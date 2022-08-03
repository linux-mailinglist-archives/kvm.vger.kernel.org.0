Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7726D588A23
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 12:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiHCKIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 06:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiHCKIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 06:08:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3DF13DF4D
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 03:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659521307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ombNgzXxVb25gnDLaXkVZE1drvU8iJaz17u9QxcdADc=;
        b=SLLJCuDTZMXbUd9gEFddNsbr7COrV36ZWGST+xdHMXM6JzXzzTZmkR92GlxwSIntU0juIB
        /dAbLKCc86iDXdEWLDponISQtnqqDzdccQoQL2lCelGVpf1DofGObITI399yYFvjwH3GcA
        FRklK0AluSqIpIeED970NxtWF2QrRCs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-sch-Y4pfO6mYs5fag_yzmA-1; Wed, 03 Aug 2022 06:08:24 -0400
X-MC-Unique: sch-Y4pfO6mYs5fag_yzmA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DBB680A0BF;
        Wed,  3 Aug 2022 10:08:24 +0000 (UTC)
Received: from starship (unknown [10.40.194.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD3F8492C3B;
        Wed,  3 Aug 2022 10:08:21 +0000 (UTC)
Message-ID: <060419e118445978549f0c7d800f96a9728c157c.camel@redhat.com>
Subject: Re: [PATCH 1/5] KVM: x86: Get vmcs12 pages before checking pending
 interrupts
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>
Date:   Wed, 03 Aug 2022 13:08:20 +0300
In-Reply-To: <20220802230718.1891356-2-mizhang@google.com>
References: <20220802230718.1891356-1-mizhang@google.com>
         <20220802230718.1891356-2-mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-02 at 23:07 +0000, Mingwei Zhang wrote:
> From: Oliver Upton <oupton@google.com>
> 
> vmx_guest_apic_has_interrupts implicitly depends on the virtual APIC
> page being present + mapped into the kernel address space. However, with
> demand paging we break this dependency, as the KVM_REQ_GET_VMCS12_PAGES
> event isn't assessed before entering vcpu_block.
> 
> Fix this by getting vmcs12 pages before inspecting the guest's APIC
> page. Note that upstream does not have this issue, as they will directly
> get the vmcs12 pages on vmlaunch/vmresume instead of relying on the
> event request mechanism. However, the upstream approach is problematic,
> as the vmcs12 pages will not be present if a live migration occurred
> before checking the virtual APIC page.

Since this patch is intended for upstream, I don't fully understand
the meaning of the above paragraph.


> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/x86.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5366f884e9a7..1d3d8127aaea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10599,6 +10599,23 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
>  {
>  	bool hv_timer;
>  
> +	/*
> +	 * We must first get the vmcs12 pages before checking for interrupts
> +	 * that might unblock the guest if L1 is using virtual-interrupt
> +	 * delivery.
> +	 */
> +	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
> +		/*
> +		 * If we have to ask user-space to post-copy a page,
> +		 * then we have to keep trying to get all of the
> +		 * VMCS12 pages until we succeed.
> +		 */
> +		if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
> +			kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> +			return 0;
> +		}
> +	}
> +
>  	if (!kvm_arch_vcpu_runnable(vcpu)) {
>  		/*
>  		 * Switch to the software timer before halt-polling/blocking as


If I understand correctly, you are saying that if apic backing page is migrated in post copy
then 'get_nested_state_pages' will return false and thus fail?

AFAIK both SVM and VMX versions of 'get_nested_state_pages' assume that this is not the case
for many things like MSR bitmaps and such - they always uses non atomic versions
of guest memory access like 'kvm_vcpu_read_guest' and 'kvm_vcpu_map' which
supposed to block if they attempt to access HVA which is not present, and then
userfaultd should take over and wake them up.

If that still fails, nested VM entry is usually failed, and/or the whole VM
is crashed with 'KVM_EXIT_INTERNAL_ERROR'.

Anything I missed? 

Best regards,
	Maxim Levitsky

