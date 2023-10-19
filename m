Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06277CF342
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 10:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235280AbjJSIwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 04:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbjJSIw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 04:52:29 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C6F6121;
        Thu, 19 Oct 2023 01:52:27 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qtOlP-0004JN-00; Thu, 19 Oct 2023 10:52:19 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 6910EC01C1; Thu, 19 Oct 2023 10:50:33 +0200 (CEST)
Date:   Thu, 19 Oct 2023 10:50:33 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] MIPS: KVM: Fix a build warning about variable set but
 not used
Message-ID: <ZTDt2ZRn1kWqTz5Z@alpha.franken.de>
References: <20231010085434.2678144-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010085434.2678144-1-chenhuacai@loongson.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 04:54:34PM +0800, Huacai Chen wrote:
> After commit 411740f5422a ("KVM: MIPS/MMU: Implement KVM_CAP_SYNC_MMU")
> old_pte is no longer used in kvm_mips_map_page(). So remove it to fix a
> build warning about variable set but not used:
> 
>    arch/mips/kvm/mmu.c: In function 'kvm_mips_map_page':
> >> arch/mips/kvm/mmu.c:701:29: warning: variable 'old_pte' set but not used [-Wunused-but-set-variable]
>      701 |         pte_t *ptep, entry, old_pte;
>          |                             ^~~~~~~
> 
> Cc: stable@vger.kernel.org
> Fixes: 411740f5422a960 ("KVM: MIPS/MMU: Implement KVM_CAP_SYNC_MMU")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202310070530.aARZCSfh-lkp@intel.com/
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
>  arch/mips/kvm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index e8c08988ed37..cc09fd23aae3 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -592,7 +592,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	int srcu_idx, err;
>  	kvm_pfn_t pfn;
> -	pte_t *ptep, entry, old_pte;
> +	pte_t *ptep, entry;
>  	bool writeable;
>  	unsigned long prot_bits;
>  	unsigned long mmu_seq;
> @@ -664,7 +664,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>  	entry = pfn_pte(pfn, __pgprot(prot_bits));
>  
>  	/* Write the PTE */
> -	old_pte = *ptep;
>  	set_pte(ptep, entry);
>  
>  	err = 0;
> -- 
> 2.39.3

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
