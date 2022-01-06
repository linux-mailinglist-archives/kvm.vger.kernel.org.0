Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFEB486A95
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 20:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbiAFTlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 14:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiAFTlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 14:41:51 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AE3C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 11:41:51 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id y9so3450904pgr.11
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wg/B46QMv3R7zr0QCFORSpHyZLNN6fOU3xOXq9jFLYw=;
        b=c5ksrlJPpX9PdvH/3R2QtOWfU37xk8l7O9jVTBWzUNt21fs7Z8LHBuHijy8QeMyQN6
         xqNpsYdVwWApFZJGGRCXpQ0/dVZAIhEpEfbfMx+TH748oOdB5Eu8YMDpcQuim6iPHb/J
         3WQVJMVsBu8eS0SJ05J7udAw365Re8j8PNo2KPW4idW3vFPvIf8a9zlbLThawiJmm4Y2
         /2d231gDHNm+KytNI9iADRycxWWRrAYX89Fm6KN2jPLMe2K5zPLUIeakw5FBkMAChYUB
         Pw4ySgOeNV0o8EslunUe2vP5GYHALYVt15ZFYAHdkbzs2Gp7IbPkHpkt+SWyQi+npdtX
         Wa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wg/B46QMv3R7zr0QCFORSpHyZLNN6fOU3xOXq9jFLYw=;
        b=l+XbKmJSNSto93vq1BbGT8F7aZieYuqW5pf+o+eSeDXpJeMEzU837EBrQsHKBdnd4f
         HqyRL+2x2DdGhWZp2z93AkfKKqIj2Xwea4o1ZRds6Mc4h9DDTxcJguSPy5AKlT0ZXwJp
         GjtLDRcm3ANUmd+5KbQAEtelr9PHGj1G8HQaKTA+8Ea3EMeF6Tpv6dWqbdPpaIxYPBhT
         tcWYoiAYlAOBFGz23U2hRBex+3k6EmTSYMdn1Pb83KAoFvJ/bBo+8yn6xlSuPz7B87NT
         Y9DEx0MAgtJFUmjwKOMsuyjokAFokkQ0DRlIle0zKh/mBbrHxtI8lLEbhQvpei98SYbA
         j9eA==
X-Gm-Message-State: AOAM533asM+uGfc19pmDqSoejPgnUQ+tUSKNlhgy/V1ZmWvit1YWbDpl
        ndIrU4Vx0gTiR/jSGTjsA2D5PQ==
X-Google-Smtp-Source: ABdhPJx9G+sPMdnrpTnRmmEeCI++OhxIq0kPCbp7OcaZPsazED5Ch/cTtBZjp6msYZTEGuoCP9uVfA==
X-Received: by 2002:a05:6a00:847:b0:4ba:f004:e380 with SMTP id q7-20020a056a00084700b004baf004e380mr61094005pfk.42.1641498111066;
        Thu, 06 Jan 2022 11:41:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q2sm3551041pfu.66.2022.01.06.11.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 11:41:50 -0800 (PST)
Date:   Thu, 6 Jan 2022 19:41:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Message-ID: <YddF+6eX7ycAsZLr@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-6-jiangshanlai@gmail.com>
 <YdTCKoTgI5IgOvln@google.com>
 <CAJhGHyAOyR6yGdyxsKydt_+HboGjxc-psbbSCqsrBo4WgUgQsQ@mail.gmail.com>
 <YdXLNEwCY8cqV7KS@google.com>
 <dc8f2508-35ac-0dee-2465-4b5a8e3879ca@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc8f2508-35ac-0dee-2465-4b5a8e3879ca@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022, Lai Jiangshan wrote:
> 
> 
> On 2022/1/6 00:45, Sean Christopherson wrote:
> > On Wed, Jan 05, 2022, Lai Jiangshan wrote:
> > > On Wed, Jan 5, 2022 at 5:54 AM Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > > > 
> > > > > default_pae_pdpte is needed because the cpu expect PAE pdptes are
> > > > > present when VMenter.
> > > > 
> > > > That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
> > > > is perfectly ok, present with reserved bits is what's not allowed.
> > > > 
> > > > Intel SDM:
> > > >    A VM entry that checks the validity of the PDPTEs uses the same checks that are
> > > >    used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
> > > >    would cause a general-protection exception due to the PDPTEs that would be loaded
> > > >    (e.g., because a reserved bit is set), the VM entry fails.
> > > > 
> > > >    7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
> > > >       (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.
> > > 
> > > But in practice, the VM entry fails if the present bit is not set in the
> > > PDPTE for the linear address being accessed (when EPT enabled at least).  The
> > > host kvm complains and dumps the vmcs state.
> > 
> > That doesn't make any sense.  If EPT is enabled, KVM should never use a pae_root.
> > The vmcs.GUEST_PDPTRn fields are in play, but those shouldn't derive from KVM's
> > shadow page tables.
> 
> Oh, I wrote the negative what I want to say again when I try to emphasis
> something after I wrote a sentence and modified it several times.
> 
> I wanted to mean "EPT not enabled" when vmx.

Heh, that makes a lot more sense.

> The VM entry fails when the guest is in very early stage when booting which
> might be still in real mode.
> 
> VMEXIT: intr_info=00000000 errorcode=0000000 ilen=00000000
> reason=80000021 qualification=0000000000000002

Yep, that's the signature for an illegal PDPTE at VM-Enter.  But as noted above,
a not-present PDPTE is perfectly legal, VM-Enter should failed if and only if a
PDPTE is present and has reserved bits set.

> IDTVectoring: info=00000000 errorcode=00000000
> 
> > 
> > And I doubt there is a VMX ucode bug at play, as KVM currently uses '0' in its
> > shadow page tables for not-present PDPTEs.
> > 
> > If you can post/provide the patches that lead to VM-Fail, I'd be happy to help
> > debug.
> 
> If you can try this patchset, you can just set the default_pae_pdpte to 0 to test
> it.

I can't reproduce the failure with this on top of your series + kvm/queue (commit
cc0e35f9c2d4 ("KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled")).

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f6f7caf76b70..b7170a840330 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -728,22 +728,11 @@ static u64 default_pae_pdpte;

 static void free_default_pae_pdpte(void)
 {
-       free_page((unsigned long)__va(default_pae_pdpte & PAGE_MASK));
        default_pae_pdpte = 0;
 }

 static int alloc_default_pae_pdpte(void)
 {
-       unsigned long p = __get_free_page(GFP_KERNEL | __GFP_ZERO);
-
-       if (!p)
-               return -ENOMEM;
-       default_pae_pdpte = __pa(p) | PT_PRESENT_MASK | shadow_me_mask;
-       if (WARN_ON(is_shadow_present_pte(default_pae_pdpte) ||
-                   is_mmio_spte(default_pae_pdpte))) {
-               free_default_pae_pdpte();
-               return -EINVAL;
-       }
        return 0;
 }

Are you using a different base and/or running with other changes?

To aid debug, the below patch will dump the PDPTEs from the current MMU root on
failure (I'll also submit this as a formal patch).  On failure, I would expect
that at least one of the PDPTEs will be present with reserved bits set.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe06b02994e6..c13f37ef1bbc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5773,11 +5773,19 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
        pr_err("CR4: actual=0x%016lx, shadow=0x%016lx, gh_mask=%016lx\n",
               cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
        pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
-       if (cpu_has_vmx_ept()) {
+       if (enable_ept) {
                pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
                       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
                pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
                       vmcs_read64(GUEST_PDPTR2), vmcs_read64(GUEST_PDPTR3));
+       } else if (vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL &&
+                  VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
+               u64 *pdpte = __va(vcpu->arch.mmu->root_hpa);
+
+               pr_err("PDPTE0 = 0x%016llx  PDPTE1 = 0x%016llx\n",
+                      pdpte[0], pdpte[1]);
+               pr_err("PDPTE2 = 0x%016llx  PDPTE3 = 0x%016llx\n",
+                      pdpte[2], pdpte[3]);
        }
        pr_err("RSP = 0x%016lx  RIP = 0x%016lx\n",
               vmcs_readl(GUEST_RSP), vmcs_readl(GUEST_RIP));

> If you can't try this patchset, the mmu->pae_root can be possible to be modified
> to test it.
> 
> I guess the vmx fails to translate %rip when VMentry in this case.

No, the CPU doesn't translate RIP at VM-Enter, vmcs.GUEST_RIP is only checked for
legality, e.g. that it's canonical.  Translating RIP through page tables is firmly
a post-VM-Enter code fetch action.
