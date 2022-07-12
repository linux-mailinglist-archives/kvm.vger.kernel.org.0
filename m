Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F7657156C
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbiGLJN5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGLJNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:13:54 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE5F33356
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:13:52 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:13:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657617230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Zt0Xhd8ddIucQPrOJb3PEM9OfWFEuoA7oRWJOVyzHU=;
        b=Y3+CoTo+csjBr7N8wooQcAhjhzmL1GWrCYpUtpjRLRdD7JnZFZPSkuvf1cpISLlWIceEsu
        cyRltp8DlQo+sEYHHa2iHApdQAq2k8bx/7PNqZ7VQz81f5gc3Lcn6Mqf/IfIxnp1x3+LZ2
        vpRLVNQW0WGFFl+hpxhAUuel6MPfolc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 03/13] KVM: selftests: Add
 vm_alloc_page_table_in_memslot library function
Message-ID: <20220712091348.66x54s47ali4h2ki@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-4-ricarkol@google.com>
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

On Fri, Jun 24, 2022 at 02:32:47PM -0700, Ricardo Koller wrote:
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 7ebfc8c7de17..54ede9fc923c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -579,6 +579,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  			      vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>  
>  /*
>   * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index f8c104dba258..5ee20d4da222 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1784,9 +1784,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>  
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
> +			pt_memslot);
> +}
> +
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
>  {
> -	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
> +	return vm_alloc_page_table_in_memslot(vm, 0);
>  }
>  
>  /*
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
