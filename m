Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DC85A7EA6
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 15:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiHaNXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 09:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiHaNXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 09:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF08EBB904
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 06:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661952219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZECxeq+VOxz3+YhbPEZAiDDllz5WtJE1F6cO2w5XPV0=;
        b=NnMdCSUF8MpjKERiwDkzrQX0O3yX55bruUKlOIfv7xXVdDB+hFybukX3hR/6GLPUkmJ17N
        MV6OSLPpjlod9fkd4hlzRe9MijJlQL1nRR8jD/U5v8gZD1iFpoWQBalx46XNI6GKxERMpJ
        43VTxlx1UfCYSKDE2bhjELOZZf7rc24=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-GNYk6GstMAu40G4z40UUqQ-1; Wed, 31 Aug 2022 09:23:36 -0400
X-MC-Unique: GNYk6GstMAu40G4z40UUqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ADB051C07589;
        Wed, 31 Aug 2022 13:23:35 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 186201121320;
        Wed, 31 Aug 2022 13:23:33 +0000 (UTC)
Message-ID: <bccb116fd8fef3da918faa2270fac3256bfb62c6.camel@redhat.com>
Subject: Re: [PATCH 12/19] KVM: x86: Disable APIC logical map if logical ID
 covers multiple MDAs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 16:23:32 +0300
In-Reply-To: <20220831003506.4117148-13-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-13-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Disable the optimized APIC logical map if a logical ID covers multiple
> MDAs, i.e. if a vCPU has multiple bits set in its ID.  In logical mode,
> events match if "ID & MDA != 0", i.e. creating an entry for only the
> first bit can cause interrupts to be missed.
> 
> Note, creating an entry for every bit is also wrong as KVM would generate
> IPIs for every matching bit.  It would be possible to teach KVM to play
> nice with this edge case, but it is very much an edge case and probably
> not used in any real world OS, i.e. it's not worth optimizing.
> 
> Use an impossible value for the "mode" to effectively designate that it's
> disabled.  Don't bother adding a dedicated "invalid" value, the mode
> handling will be cleaned up in the future and it would take just as much
> effort to explain what value is "safe" at this time.
> 
> Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 9dda989a1cf0..82278acae95b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -300,8 +300,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
>  			continue;
>  
> -		if (mask)
> -			cluster[ffs(mask) - 1] = apic;
> +		if (!mask)
> +			continue;
> +
> +		if (!is_power_of_2(mask)) {
> +			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
> +				    KVM_APIC_MODE_XAPIC_CLUSTER;
> +			continue;
> +		}
> +		cluster[ffs(mask) - 1] = apic;
>  	}
>  out:
>  	old = rcu_dereference_protected(kvm->arch.apic_map,


I was about to complain about the abuse of the invalid mode,
but I see that this is fixed in later patch as it is said in the commit
description, so no complains.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

