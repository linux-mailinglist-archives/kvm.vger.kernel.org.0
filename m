Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6275A7EAA
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiHaNYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbiHaNYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:24:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7898BB904
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661952280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Omu4YpZEW3bXVejWiGo0Hr4Xg9+WFqfzLBahZAcI0Kg=;
        b=g6xbFE+i70o+Fg1ARgRdpAzvxeMVWZGGmMdGkhSGf7ZQEGcanjYl5t0JK/EK7JIG7KXK8G
        Ivl2UxBYFhgn9c9Jzq2WObGkoE/LIwzgFtbiAh9eF8BlmyQPBHH5+7lnUScYWVSYZfYr72
        yKBxaM7vFafRP2hApZl19KmKwnd97dk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606--SIqiyzcO2m_KhAa5CuHOA-1; Wed, 31 Aug 2022 09:24:37 -0400
X-MC-Unique: -SIqiyzcO2m_KhAa5CuHOA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21A523804069;
        Wed, 31 Aug 2022 13:24:37 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B8D112131E;
        Wed, 31 Aug 2022 13:24:35 +0000 (UTC)
Message-ID: <4a4bc3ad639b0dca9f24a7616d86a7cc9abd13ea.camel@redhat.com>
Subject: Re: [PATCH 13/19] KVM: x86: Disable APIC logical map if vCPUs are
 aliased in logical mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 16:24:34 +0300
In-Reply-To: <20220831003506.4117148-14-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-14-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> Disable the optimized APIC logical map if multiple vCPUs are aliased to
> the same logical ID.  Architecturally, all CPUs whose logical ID matches
> the MDA are supposed to receive the interrupt; overwriting existing map
> entries can result in missed IPIs.
> 
> Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 82278acae95b..d537b51295d6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -303,12 +303,13 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		if (!mask)
>  			continue;
>  
> -		if (!is_power_of_2(mask)) {
> +		ldr = ffs(mask) - 1;
> +		if (!is_power_of_2(mask) || cluster[ldr]) {
>  			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
>  				    KVM_APIC_MODE_XAPIC_CLUSTER;
>  			continue;
>  		}
> -		cluster[ffs(mask) - 1] = apic;
> +		cluster[ldr] = apic;
>  	}
>  out:
>  	old = rcu_dereference_protected(kvm->arch.apic_map,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

