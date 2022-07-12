Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ACA5715E8
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiGLJkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiGLJkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:40:08 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168F46E8AD
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:40:07 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:40:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657618805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6I8XyEibxsxWt8qyNSqLmTosyFt4crDkICfPujymAM=;
        b=JkONTmRbHmjXwBsCxqYQq3aXd4kywPtIcgN8mX/KwsDbVVNEy3uybI14LwLSfDHK8Bp6N6
        Z0G7AEVhBban0Fqqp0MU6NDlSACnWfwIqrDfAtkHuLSFOa0yYVkh+WUooAdD6BOvnWy/s2
        K20GC4rGw2cG9uhC8lIRsCDEiD8fZVY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 06/13] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
Message-ID: <20220712094004.7kuapr7m4u5xwd6h@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-7-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-7-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 02:32:50PM -0700, Ricardo Koller wrote:
> Add a library function to get the backing source FD of a memslot.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 54ede9fc923c..72c8881fe8fb 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -322,6 +322,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
>  struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 3e45e3776bdf..7c81028f23d8 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -466,6 +466,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  	return &region->region;
>  }
>  
> +/*
> + * KVM Userspace Memory Get Backing Source FD
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - KVM memory slot ID
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> + *
> + * Returns the backing source fd of a memslot, so tests can use it to punch
> + * holes, or to setup permissions.
> + */

nit: We're starting to slowly change these verbose function headers into
smaller headers, so this could be reduced.

> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> +{
> +	struct userspace_mem_region *region;
> +
> +	region = memslot2region(vm, memslot);
> +	return region->fd;
> +}
> +
>  /*
>   * VM VCPU Remove
>   *
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
