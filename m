Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6425715D4
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 11:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiGLJf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 05:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGLJf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 05:35:58 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CA666AC5
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 02:35:58 -0700 (PDT)
Date:   Tue, 12 Jul 2022 11:35:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657618556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fuNSeUYQvm97MKJ0O5peT+0cMDlnixxKy1eEGKJ1U+k=;
        b=b1L3sA6GRS2Ys4OzVNSkYJgfFnfQyrBIk7qpVjh4osS8sVUvGLYOoaSG/aHKHlSXupMqFw
        tGGR6xx6s5nZ3N+XwJXP4D2ZkbSgfsNHn5kebH68twTwrooZrk6zBBqW4o+t4A6Q0CCFu5
        iC3OdfyjmqLwa0tzVpaXzGLVPzefedM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, dmatlack@google.com,
        axelrasmussen@google.com
Subject: Re: [PATCH v4 05/13] KVM: selftests: Add missing close and munmap in
 __vm_mem_region_delete
Message-ID: <20220712093555.o4y2nyog4a3gs7tn@kamzik>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-6-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624213257.1504783-6-ricarkol@google.com>
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

On Fri, Jun 24, 2022 at 02:32:49PM -0700, Ricardo Koller wrote:
> Deleting a memslot (when freeing a VM) is not closing the backing fd,
> nor it's unmapping the alias mapping. Fix by adding the missing close
> and munmap.
> 
> Reviewed-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 5ee20d4da222..3e45e3776bdf 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -531,6 +531,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>  	sparsebit_free(&region->unused_phy_pages);
>  	ret = munmap(region->mmap_start, region->mmap_size);
>  	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
> +	if (region->fd >= 0) {
> +		/* There's an extra map when using shared memory. */
> +		ret = munmap(region->mmap_alias, region->mmap_size);
> +		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
> +		close(region->fd);
> +	}
>  
>  	free(region);
>  }
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
