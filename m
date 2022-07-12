Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C4C571A6D
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiGLMsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiGLMsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:48:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A4F64C0;
        Tue, 12 Jul 2022 05:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15857B81866;
        Tue, 12 Jul 2022 12:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC2DC341C8;
        Tue, 12 Jul 2022 12:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657630114;
        bh=u3UpGccjJ2q2H3+rErFteKR1Zd4HKdFuMd3EDwq08Fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kpicQ+ZAooSoAWd/cbF7tEWilDBpOtRbO/CQ05knRl/3aaxqqTDxIYrMPkuh7rVzm
         CqOwnSljY6yj29NZhMXWhq56TX0PAjpsJsRLWMC7jwfxq3mQ5f3mtfUphRBQJBNkNl
         IE1Lcg5sRhAJjsgf6uU/V7b82XrLFdLz7wtw1fvbPw5WxYeQoNGdsqUMHIncxeYp2Z
         meRl83O2hLAnHWfQL/+tf0AFHFznlFOllqZ7+BuUZiADXMw1GB0hUV9PxZ+XIHUfyW
         SiOy4NWlkd5VQ9hRH4AxrI5Rv0xv4X4Yh+CvrhJqX8Hei+kL/ayL6vbp38bPL3Ugkc
         EKo8rWTxvw5vw==
Date:   Tue, 12 Jul 2022 15:48:31 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
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
        alpergun@google.com, dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
Message-ID: <Ys1tn7w0E/0cOud8@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
 <Ys1qNQNqek5MdG3v@kernel.org>
 <Ys1s1kyfOu/FXjXr@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys1s1kyfOu/FXjXr@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 03:45:13PM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 12, 2022 at 03:34:00PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Jun 20, 2022 at 11:13:03PM +0000, Ashish Kalra wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > 
> > > When SEV-SNP is enabled in the guest, the hardware places restrictions on
> > > all memory accesses based on the contents of the RMP table. When hardware
> > > encounters RMP check failure caused by the guest memory access it raises
> > > the #NPF. The error code contains additional information on the access
> > > type. See the APM volume 2 for additional information.
> > > 
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
> > >  arch/x86/kvm/svm/svm.c | 14 +++++---
> > >  2 files changed, 86 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 4ed90331bca0..7fc0fad87054 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> > >  
> > >  	spin_unlock(&sev->psc_lock);
> > >  }
> > > +
> > > +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> > > +{
> > > +	int rmp_level, npt_level, rc, assigned;
> > > +	struct kvm *kvm = vcpu->kvm;
> > > +	gfn_t gfn = gpa_to_gfn(gpa);
> > > +	bool need_psc = false;
> > > +	enum psc_op psc_op;
> > > +	kvm_pfn_t pfn;
> > > +	bool private;
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +
> > > +	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
> > 
> > This function does not exist. Should it be kvm_mmu_get_tdp_page?
> 
> Ugh, ignore that.
> 
> This the actual issue:
> 
> $ git grep  kvm_mmu_get_tdp_walk
> arch/x86/kvm/mmu/mmu.c:bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
> arch/x86/kvm/mmu/mmu.c:EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
> arch/x86/kvm/svm/sev.c:         rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
> 
> It's not declared in any header.

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 0e1f4d92b89b..33267f619e61 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -164,6 +164,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
                               u32 error_code, int max_level);

+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level):
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE


BTW, kvm_mmu_map_tdp_page() ought to be in single line since it's less than
100 characters.

BR, Jarkko
