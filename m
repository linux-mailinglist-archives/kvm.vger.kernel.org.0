Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F03677770
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 10:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjAWJb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 04:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjAWJb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 04:31:29 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924B318B1D;
        Mon, 23 Jan 2023 01:31:27 -0800 (PST)
Received: (Authenticated sender: alex@ghiti.fr)
        by mail.gandi.net (Postfix) with ESMTPSA id 49BFB240009;
        Mon, 23 Jan 2023 09:31:21 +0000 (UTC)
Message-ID: <bdabafb1-53f3-403c-ab9c-1c2d00421690@ghiti.fr>
Date:   Mon, 23 Jan 2023 10:31:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] KVM: RISC-V: Fix wrong usage of PGDIR_SIZE to check page
 sizes
To:     Alexandre Ghiti <alexghiti@rivosinc.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20230123092928.808014-1-alexghiti@rivosinc.com>
Content-Language: en-US
From:   Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20230123092928.808014-1-alexghiti@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

@Anup: Sorry, forgot to add -fixes to the patch title, as I think this 
should go into your fixes branch for 6.2.

On 1/23/23 10:29, Alexandre Ghiti wrote:
> At the moment, riscv only supports PMD and PUD hugepages. For sv39,
> PGDIR_SIZE == PUD_SIZE but not for sv48 and sv57. So fix this by changing
> PGDIR_SIZE into PUD_SIZE.
>
> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> ---
>   arch/riscv/kvm/mmu.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 34b57e0be2ef..dbc4ca060174 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -585,7 +585,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.pgd)
>   		return false;
>   
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>   
>   	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>   				   &ptep, &ptep_level))
> @@ -603,7 +603,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>   	if (!kvm->arch.pgd)
>   		return false;
>   
> -	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
> +	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
>   
>   	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
>   				   &ptep, &ptep_level))
> @@ -645,12 +645,12 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>   	if (logging || (vma->vm_flags & VM_PFNMAP))
>   		vma_pagesize = PAGE_SIZE;
>   
> -	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
> +	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>   		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
>   
>   	mmap_read_unlock(current->mm);
>   
> -	if (vma_pagesize != PGDIR_SIZE &&
> +	if (vma_pagesize != PUD_SIZE &&
>   	    vma_pagesize != PMD_SIZE &&
>   	    vma_pagesize != PAGE_SIZE) {
>   		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
