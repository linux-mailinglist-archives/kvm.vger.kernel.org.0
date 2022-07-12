Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7266E571A12
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 14:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbiGLMeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiGLMeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 08:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803405FB4;
        Tue, 12 Jul 2022 05:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1754C616AF;
        Tue, 12 Jul 2022 12:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14B1C341C8;
        Tue, 12 Jul 2022 12:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657629240;
        bh=9DjX9o6ibssfN2gVfTH2pbVMipRj/UkB3PPyZA75DLc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XCdKNUuRGjW9rRR0xnr8jYvOUe05Iuaci0Az7i0qa/N7392kbXhDQcOTEWElhi5jE
         6HK6icZCWNZCpC4q3LQ1iT2ud7LV14A/VOLk7SOoNTEW+FLFU5rl1J/GPOF1scyQKr
         CQaJO8PtaGbulZdGcLg1SB75oPB6jvgVZk+CydYqVg6jiDP1IgRQf2xDgDMLPnchsV
         6oxB9FpN/ZqFq8Ffx6uybtcggIDqvya5PUeFGfE6dG2diC/tD35aFY+N9qoQrMsX8T
         41aU/Gl0mawE3ShnsZtjXC4GfXVxG15vJkbXBPCTmqHlS0d5H/ljEasTJbEtpSAGzS
         8Ahr0dc6hjxmw==
Date:   Tue, 12 Jul 2022 15:33:57 +0300
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
Message-ID: <Ys1qNQNqek5MdG3v@kernel.org>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 11:13:03PM +0000, Ashish Kalra wrote:
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
>  	spin_unlock(&sev->psc_lock);
>  }
> +
> +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
> +{
> +	int rmp_level, npt_level, rc, assigned;
> +	struct kvm *kvm = vcpu->kvm;
> +	gfn_t gfn = gpa_to_gfn(gpa);
> +	bool need_psc = false;
> +	enum psc_op psc_op;
> +	kvm_pfn_t pfn;
> +	bool private;
> +
> +	write_lock(&kvm->mmu_lock);
> +
> +	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level)))

This function does not exist. Should it be kvm_mmu_get_tdp_page?

BR, Jarkko

