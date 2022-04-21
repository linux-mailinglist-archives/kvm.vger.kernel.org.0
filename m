Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0955096D6
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 07:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347486AbiDUF3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 01:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384448AbiDUF3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 01:29:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77AE810FD1
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 22:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650518807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=09wIP+Ezh+boJlEnNU0DFCx3hEkdvqLMQ0cz6cNAjsc=;
        b=CX5161W2p84sWbSSs0Prp7viCe1EBh3afZpPu8GM/7JnaIzFhcWqPfQyd1IetegWU9FdLE
        EqI0Cxxi811TgDUqUuh5pVyVb65wicbVUn9C8cDlyGzupVVynWR0ydAflqJh/UTIe4V7Tn
        /KdbkB8574nMjukn5dhbXyMCZn6gqx4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37--1U9P576OECVU_d2kZEZSA-1; Thu, 21 Apr 2022 01:26:46 -0400
X-MC-Unique: -1U9P576OECVU_d2kZEZSA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06FE480005D;
        Thu, 21 Apr 2022 05:26:45 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 649EC40D0168;
        Thu, 21 Apr 2022 05:26:39 +0000 (UTC)
Message-ID: <b622882b4fbcacdeb09e4112251aeeab48059ded.camel@redhat.com>
Subject: Re: [RFC PATCH v2 04/10] KVM: x86: mmu: tweak fast path for
 emulation of access to nested NPT pages
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, x86@kernel.org,
        David Airlie <airlied@linux.ie>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Date:   Thu, 21 Apr 2022 08:26:38 +0300
In-Reply-To: <20220421051244.187733-5-mlevitsk@redhat.com>
References: <20220421051244.187733-1-mlevitsk@redhat.com>
         <20220421051244.187733-5-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-21 at 08:12 +0300, Maxim Levitsky wrote:
> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 23f895d439cf5..b63398dfdac3b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5315,8 +5315,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  	 */
>  	if (vcpu->arch.mmu->root_role.direct &&
>  	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
> -		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
> -		return 1;
> +		if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
> +			return 1;
>  	}
>  
>  	/*

I forgot to add commit description here:

If non leaf mmu page is write tracked externally for some reason,
which can in theory happen if it was used for nested avic physid page
before, then this code will enter an endless loop of page faults because
unprotecting the page will not remove write tracking, nor will the
write tracker callback be called.

Fix this by only invoking the fast patch if we succeeded in zapping the
mmu page.

Fixes: 147277540bbc5 ("kvm: svm: Add support for additional SVM NPF error codes")
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

--

In theory, KVMGT also does external write tracking so in theory this issue can happen today,
but it is highly unlikely.

Best regards,
	Maxim Levitsk

