Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47D5FA77B
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 00:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJJWD6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 18:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiJJWD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 18:03:56 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36BD61728
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:03:54 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id l127so9488518iof.12
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fKZdTQMzzJSnzVJZ8hLWVq3L0BSUs/tEyhk7a/do8K4=;
        b=WxDKd5BvqL9kT1Jet4RhjFC6yGMGc3mced78+CfwGKId3ww05jzO36LeEufsKar+lo
         +fDMHNapDAks5GcOLiIMtMfSZcL8gyMDGMwAYDOC2/2pGLp5qp/twRUeQemKSBxePGSx
         XcEboBj5crslENf3cZeSDgHZVgNgLxjbW01u0WFSY+Q7ANnRf0JlO7HSaydKto3RtE/H
         Q0SI9e3SqYDKVtwZnqNUM841E9Xrk97ZR5lqfpnF2XXJn0a4XVcQPkT0Ss3gNTg/k9Wx
         HZLatx8cAX04dyehDV1UXiHobl4JDGEKWrZ795tpn+qM02w6faV+GMzj25+/x1ezmt0Z
         SA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fKZdTQMzzJSnzVJZ8hLWVq3L0BSUs/tEyhk7a/do8K4=;
        b=B1RZTnMVkLYcAwukbJgFNVfkduibqwmAQN+UkJgsPyG/xdQh2gfua401061Wm9ZgXN
         wStNVpqx/BHp3KLRZvivVdbOOFmzdl94QFjPlOwaEzpEtUTEeoKKzN9yywnNLHpyOqV1
         fM3iGA4YjooQMUWENosCxwKzbNpalA7N5LareT18AFVhM3t+tg5ZJRYxejHNDuHTA3Dh
         gU8Aoe4O0GYY0hN/7J3HqvAhx8ZutnqVQrT8ugoRFYlMqyPPA4cWobUzMljbjh3ZuJAo
         L3kUn4mlBRhFrMGaOMAWb1p17NpZd3B3yV7G0/rpUwtDebApQZWNuSCZobKhP3JRo0a2
         eV0A==
X-Gm-Message-State: ACrzQf2mcNwRdhw+AfT2Swr/5zc7/kAJACuYWNU22bVXlIYdTHwiQb9z
        /aAlYYdSGZdjm1EWYk0ysP0bhwIjFHRumjOdsKYJLw==
X-Google-Smtp-Source: AMsMyM7gzbkuy10hQ8nXQ841/5BxEOsf4/QAVkHVBZB0Pg0d/o6dJSUlByL4oEySL3aNmXuJTAbUv3dneghOF8W55ss=
X-Received: by 2002:a05:6638:4086:b0:363:c34a:74b0 with SMTP id
 m6-20020a056638408600b00363c34a74b0mr2256500jam.221.1665439433957; Mon, 10
 Oct 2022 15:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 10 Oct 2022 15:03:42 -0700
Message-ID: <CABpDEukNp9eH8jXpv6+Dun+e943AbEMA6G68uQu=TrOLSvh_oA@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        dgilbert@redhat.com, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 4:13 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> When SEV-SNP is enabled in the guest, the hardware places restrictions on
> all memory accesses based on the contents of the RMP table. When hardware
> encounters RMP check failure caused by the guest memory access it raises
> the #NPF. The error code contains additional information on the access
> type. See the APM volume 2 for additional information.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c | 14 +++++---
>  2 files changed, 86 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 4ed90331bca0..7fc0fad87054 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
>
>         spin_unlock(&sev->psc_lock);
>  }
> +
> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> +{
> +       int rmp_level, npt_level, rc, assigned;
> +       struct kvm *kvm = vcpu->kvm;
> +       gfn_t gfn = gpa_to_gfn(gpa);
> +       bool need_psc = false;
> +       enum psc_op psc_op;
> +       kvm_pfn_t pfn;
> +       bool private;
> +
> +       write_lock(&kvm->mmu_lock);
> +
> +       if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
> +               goto unlock;
> +
> +       assigned = snp_lookup_rmpentry(pfn, &rmp_level);
> +       if (unlikely(assigned < 0))
> +               goto unlock;
> +
> +       private = !!(error_code & PFERR_GUEST_ENC_MASK);
> +
> +       /*
> +        * If the fault was due to size mismatch, or NPT and RMP page level's
> +        * are not in sync, then use PSMASH to split the RMP entry into 4K.
> +        */
> +       if ((error_code & PFERR_GUEST_SIZEM_MASK) ||
> +           (npt_level == PG_LEVEL_4K && rmp_level == PG_LEVEL_2M && private)) {
> +               rc = snp_rmptable_psmash(kvm, pfn);


Regarding this case:
RMP level is 4K
Page table level is 2M

Does this also cause a page fault with size mismatch? If so, we
shouldn't try psmash because the rmp entry is already 4K.

I see these errors in our tests and I think it may be happening
because rmp size is already 4K.

[ 1848.752952] psmash failed, gpa 0x191560000 pfn 0x536cd60 rc 7
[ 2922.879635] psmash failed, gpa 0x102830000 pfn 0x37c8230 rc 7
[ 3010.983090] psmash failed, gpa 0x104220000 pfn 0x6cf1e20 rc 7
[ 3170.792050] psmash failed, gpa 0x108a80000 pfn 0x20e0080 rc 7
[ 3345.955147] psmash failed, gpa 0x11b480000 pfn 0x1545e480 rc 7

Shouldn't we use AND instead of OR in the if statement?

if ((error_code & PFERR_GUEST_SIZEM_MASK) && ...

> +               if (rc)
> +                       pr_err_ratelimited("psmash failed, gpa 0x%llx pfn 0x%llx rc %d\n",
> +                                          gpa, pfn, rc);
> +               goto out;
> +       }
> +
> +       /*
> +        * If it's a private access, and the page is not assigned in the
> +        * RMP table, create a new private RMP entry. This can happen if
> +        * guest did not use the PSC VMGEXIT to transition the page state
> +        * before the access.
> +        */
> +       if (!assigned && private) {
> +               need_psc = 1;
> +               psc_op = SNP_PAGE_STATE_PRIVATE;
> +               goto out;
> +       }
> +
> +       /*
> +        * If it's a shared access, but the page is private in the RMP table
> +        * then make the page shared in the RMP table. This can happen if
> +        * the guest did not use the PSC VMGEXIT to transition the page
> +        * state before the access.
> +        */
> +       if (assigned && !private) {
> +               need_psc = 1;
> +               psc_op = SNP_PAGE_STATE_SHARED;
> +       }
> +
> +out:
> +       write_unlock(&kvm->mmu_lock);
> +
> +       if (need_psc)
> +               rc = __snp_handle_page_state_change(vcpu, psc_op, gpa, PG_LEVEL_4K);
> +
> +       /*
> +        * The fault handler has updated the RMP pagesize, zap the existing
> +        * rmaps for large entry ranges so that nested page table gets rebuilt
> +        * with the updated RMP pagesize.
> +        */
> +       gfn = gpa_to_gfn(gpa) & ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
> +       kvm_zap_gfn_range(kvm, gfn, gfn + PTRS_PER_PMD);
> +       return;
> +
> +unlock:
> +       write_unlock(&kvm->mmu_lock);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1c8e035ba011..7742bc986afc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1866,15 +1866,21 @@ static int pf_interception(struct kvm_vcpu *vcpu)
>  static int npf_interception(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_svm *svm = to_svm(vcpu);
> +       int rc;
>
>         u64 fault_address = svm->vmcb->control.exit_info_2;
>         u64 error_code = svm->vmcb->control.exit_info_1;
>
>         trace_kvm_page_fault(fault_address, error_code);
> -       return kvm_mmu_page_fault(vcpu, fault_address, error_code,
> -                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> -                       svm->vmcb->control.insn_bytes : NULL,
> -                       svm->vmcb->control.insn_len);
> +       rc = kvm_mmu_page_fault(vcpu, fault_address, error_code,
> +                               static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> +                               svm->vmcb->control.insn_bytes : NULL,
> +                               svm->vmcb->control.insn_len);
> +
> +       if (error_code & PFERR_GUEST_RMP_MASK)
> +               handle_rmp_page_fault(vcpu, fault_address, error_code);
> +
> +       return rc;
>  }
>
>  static int db_interception(struct kvm_vcpu *vcpu)
> --
> 2.25.1
>
>
