Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E9571A41
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiGLMpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiGLMpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2404F9C250;
        Tue, 12 Jul 2022 05:45:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB758B81816;
        Tue, 12 Jul 2022 12:45:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCEFC3411C;
        Tue, 12 Jul 2022 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657629913;
        bh=Z7uBLnz/DRYYUi1c3mBwJe1ITtYV+QlSxaED9zWUWOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAB4ZLQ5u9s5+ERLbLPMGHU2VPCv/X9tmI2ZMF5pMPGtJCpkUabuD/31rBOdUJUhm
         XLnVtEdlIl2qdb7/r2SruLu+VfXDQJb2jq8c4n9SlEnIoURhYLQ7XW5oLuezTZpGke
         D2rtZqDi6MoF3FioLoUpv0QzFKgBwBZl1/iHWfDPIzkhrQ/d2xhRbV0RHCfMWt965v
         vPBG1YoLLLkwcO0y2Pq+gNY68HnnGViNZxNQfaahVQwqA5AaQjIZ2omicoJIT9gYrt
         vlvu05duUtN1n4Xk5ELg9D23ih0ctC0UwV9weze5Ra8usf7NDJfaBYnVbF0tmeuynM
         HKeGEyhVsXFww==
Date:   Tue, 12 Jul 2022 15:45:10 +0300
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
Message-ID: <Ys1s1kyfOu/FXjXr@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
 <Ys1qNQNqek5MdG3v@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys1qNQNqek5MdG3v@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 03:34:00PM +0300, Jarkko Sakkinen wrote:
> On Mon, Jun 20, 2022 at 11:13:03PM +0000, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > When SEV-SNP is enabled in the guest, the hardware places restrictions on
> > all memory accesses based on the contents of the RMP table. When hardware
> > encounters RMP check failure caused by the guest memory access it raises
> > the #NPF. The error code contains additional information on the access
> > type. See the APM volume 2 for additional information.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 76 ++++++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c | 14 +++++---
> >  2 files changed, 86 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 4ed90331bca0..7fc0fad87054 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
> >  
> >  	spin_unlock(&sev->psc_lock);
> >  }
> > +
> > +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> > +{
> > +	int rmp_level, npt_level, rc, assigned;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	gfn_t gfn = gpa_to_gfn(gpa);
> > +	bool need_psc = false;
> > +	enum psc_op psc_op;
> > +	kvm_pfn_t pfn;
> > +	bool private;
> > +
> > +	write_lock(&kvm->mmu_lock);
> > +
> > +	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))
> 
> This function does not exist. Should it be kvm_mmu_get_tdp_page?

Ugh, ignore that.

This the actual issue:

$ git grep  kvm_mmu_get_tdp_walk
arch/x86/kvm/mmu/mmu.c:bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level)
arch/x86/kvm/mmu/mmu.c:EXPORT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
arch/x86/kvm/svm/sev.c:         rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);

It's not declared in any header.

BR, Jarkko
