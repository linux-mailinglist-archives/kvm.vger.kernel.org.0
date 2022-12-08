Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D571647847
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 22:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLHVyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 16:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLHVyS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 16:54:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847AF26133
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 13:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670536394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JrJq5pFdcBwIApACklja7/lOG0etsZT07B9kvDYqyYM=;
        b=HUmIplmm1Ve9YFOV+22wMfYrLGQeW598KkKHxwjkPFBKUUBtOCESw9yuYJKHayGOweN47a
        DaWhKt1xs41jrZNTCu/8/BJuaHuHqwZ7sNtynm6+LkxNT+4IV8A1/leCze7Wx4ke324dSM
        zM8pW6OHw3DXW7x1nVSj+sg/22jscJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-gdRG-3ItPnab8vysSVe-jw-1; Thu, 08 Dec 2022 16:53:10 -0500
X-MC-Unique: gdRG-3ItPnab8vysSVe-jw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B62886C043;
        Thu,  8 Dec 2022 21:53:10 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAF6040C2065;
        Thu,  8 Dec 2022 21:53:08 +0000 (UTC)
Message-ID: <5476ef637f70def68b8f9ec50579d5580659fe9a.camel@redhat.com>
Subject: Re: [PATCH v4 05/32] KVM: x86: Don't inhibit APICv/AVIC on xAPIC ID
 "change" if APIC is disabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Thu, 08 Dec 2022 23:53:07 +0200
In-Reply-To: <20221001005915.2041642-6-seanjc@google.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-10-01 at 00:58 +0000, Sean Christopherson wrote:
> Don't inhibit APICv/AVIC due to an xAPIC ID mismatch if the APIC is
> hardware disabled.  The ID cannot be consumed while the APIC is disabled,
> and the ID is guaranteed to be set back to the vcpu_id when the APIC is
> hardware enabled (architectural behavior correctly emulated by KVM).
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/lapic.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5de1c7aa1ce9..67260f7ce43a 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2072,6 +2072,9 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>  {
>  	struct kvm *kvm = apic->vcpu->kvm;
>  
> +	if (!kvm_apic_hw_enabled(apic))
> +		return;
> +
>  	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>  		return;
>  
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

