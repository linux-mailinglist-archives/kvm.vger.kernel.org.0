Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEAB571569
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiGLJMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGLJM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:12:29 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141079D524
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:12:28 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:12:24 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657617146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AdYBaFbvR1EKigmcP6qPo0MU3om4RulKrTIGhjq71YU=;
        b=qFfxnHQUS8xeITKBlkc7db0oD+Tij7+tPBqaZDfyiOmoDeX952cpg9EcnJLi8sQ2Coz88E
        3WEflxbO9BELOXaH/HeSEC24LZucdrpeLanQ4LBUZCQMQHHNdTFT5H2cANgP3Kj3uQ0F8x
        Gxk00XoQyuo8poMqwYDu/uxqnG7Qo6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 02/13] KVM: selftests: aarch64: Add virt_get_pte_hva
 library function
Message-ID: <20220712091224.ei53bu5vjaihtlsy@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-3-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-3-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 02:32:46PM -0700, Ricardo Koller wrote:
> Add a library function to get the PTE (a host virtual address) of a
> given GVA.  This will be used in a future commit by a test to clear and
> check the access flag of a particular page.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/aarch64/processor.h       |  2 ++
>  tools/testing/selftests/kvm/lib/aarch64/processor.c | 13 ++++++++++---
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> index a8124f9dd68a..df4bfac69551 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> @@ -109,6 +109,8 @@ void vm_install_exception_handler(struct kvm_vm *vm,
>  void vm_install_sync_handler(struct kvm_vm *vm,
>  		int vector, int ec, handler_fn handler);
>  
> +uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva);
> +
>  static inline void cpu_relax(void)
>  {
>  	asm volatile("yield" ::: "memory");
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 6f5551368944..63ef3c78e55e 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -138,7 +138,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
>  	_virt_pg_map(vm, vaddr, paddr, attr_idx);
>  }
>  
> -vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +uint64_t *virt_get_pte_hva(struct kvm_vm *vm, vm_vaddr_t gva)
>  {
>  	uint64_t *ptep;
>  
> @@ -169,11 +169,18 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
>  		TEST_FAIL("Page table levels must be 2, 3, or 4");
>  	}
>  
> -	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
> +	return ptep;
>  
>  unmapped_gva:
>  	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
> -	exit(1);
> +	exit(EXIT_FAILURE);
> +}
> +
> +vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
> +{
> +	uint64_t *ptep = virt_get_pte_hva(vm, gva);
> +
> +	return pte_addr(vm, *ptep) + (gva & (vm->page_size - 1));
>  }
>  
>  static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t page, int level)
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
