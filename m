Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79101587A10
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 11:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235760AbiHBJtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 05:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbiHBJtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 05:49:21 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8E74D177;
        Tue,  2 Aug 2022 02:49:18 -0700 (PDT)
Date:   Tue, 2 Aug 2022 11:49:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659433756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g5pQA3Fay6yZOVdRePFC9/TrGLheTiDU+GTyjdl1GFQ=;
        b=VbGGAbbhqmnRdydxbDv5IuK1ENDvX2nw54j3wT4xX7gOuK80I99j3QqPoXuQIIQ8puI3CM
        1xNqVHbsImMN8CtSdWsgPQZ8hCgU7xlsCFflk0Y50JVGF8OdQXDcyWm006uoJAkLyLWXm8
        64pkpjA4Y2XvrnB1DuAAGYkNDjHcTYo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, seanjc@google.com, michael.roth@amd.com,
        thomas.lendacky@amd.com, joro@8bytes.org, mizhang@google.com,
        pbonzini@redhat.com
Subject: Re: [V2 09/11] KVM: selftests: Make ucall work with encrypted guests
Message-ID: <20220802094915.lkmoz52gztzjjun4@kamzik>
References: <20220801201109.825284-1-pgonda@google.com>
 <20220801201109.825284-10-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801201109.825284-10-pgonda@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 01, 2022 at 01:11:07PM -0700, Peter Gonda wrote:
> Add support for encrypted, SEV, guests in the ucall framework. If
> encryption is enabled set up a pool of ucall structs in the guests'
> shared memory region. This was suggested in the thread on "[RFC PATCH
> 00/10] KVM: selftests: Add support for test-selectable ucall
> implementations". Using a listed as suggested there doesn't work well
> because the list is setup using HVAs not GVAs so use a bitmap + array
> solution instead to get the same pool result.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     |   3 +
>  .../selftests/kvm/include/ucall_common.h      |  14 +--
>  .../testing/selftests/kvm/lib/ucall_common.c  | 112 +++++++++++++++++-
>  3 files changed, 115 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 8ce9e5be70a3..ad4abc6be1ab 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -102,6 +102,9 @@ struct kvm_vm {
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
>  	struct kvm_stats_desc *stats_desc;
> +
> +	bool use_ucall_list;

use_ucall_pool

> +	struct list_head ucall_list;
>  };
>  
>  
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index c1bc8e33ef3f..a96220ac6024 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -22,6 +22,10 @@ enum {
>  struct ucall {
>  	uint64_t cmd;
>  	uint64_t args[UCALL_MAX_ARGS];
> +
> +	/* For encrypted guests. */

Please, no 'encrypted' words in ucall files. ucalls shouldn't care about
guest types. Indeed, the summary of this patch could even drop the word
'encrypted'. This patch is adding support for ucall pools, which is
motivated by the need to support encrypted guests (the motivation should
go in the commit message, but otherwise the patch should be ucall specific
and guest type agnostic)

> +	uint64_t idx;

We don't need 'idx' because 'hva' will always be at the
idx * sizeof(struct ucall) offset of ucall_hdr->ucalls, which means
we can always calculate it,

 static inline size_t uc_pool_idx(struct ucall *uc)
 {
 	return uc->hva - ucall_hdr->ucalls;
 }

> +	struct ucall *hva;
>  };
>  
>  void ucall_arch_init(struct kvm_vm *vm, void *arg);
> @@ -32,15 +36,9 @@ uint64_t ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
>  void ucall(uint64_t cmd, int nargs, ...);
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  
> -static inline void ucall_init(struct kvm_vm *vm, void *arg)
> -{
> -	ucall_arch_init(vm, arg);
> -}
> +void ucall_init(struct kvm_vm *vm, void *arg);
>  
> -static inline void ucall_uninit(struct kvm_vm *vm)
> -{
> -	ucall_arch_uninit(vm);
> -}
> +void ucall_uninit(struct kvm_vm *vm);
>  
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
> diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
> index a060252bab40..feb0173179ec 100644
> --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> @@ -1,22 +1,122 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  #include "kvm_util.h"
> +#include "linux/types.h"
> +#include "linux/bitmap.h"
> +#include "linux/atomic.h"
> +
> +struct ucall_header {
> +	DECLARE_BITMAP(in_use, KVM_MAX_VCPUS);
> +	struct ucall ucalls[KVM_MAX_VCPUS];
> +};
> +
> +static bool use_ucall_list;

use_ucall_pool

> +static struct ucall_header *ucall_hdr;

ucall_pool

> +
> +void ucall_init(struct kvm_vm *vm, void *arg)
> +{
> +	struct ucall *uc;
> +	struct ucall_header *hdr;
> +	vm_vaddr_t vaddr;
> +	int i;
> +
> +	use_ucall_list = vm->use_ucall_list;
> +	sync_global_to_guest(vm, use_ucall_list);
> +	if (!use_ucall_list)
> +		goto out;
> +
> +	TEST_ASSERT(!ucall_hdr,
> +		    "Only a single encrypted guest at a time for ucalls.");

single VM at a time

And I'd leave that on a single line. checkpatch allows up to 100 chars and
I'm included to use all 110 chars of it.

> +	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), vm->page_size);
> +	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
> +	memset(hdr, 0, sizeof(*hdr));
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		uc = &hdr->ucalls[i];
> +		uc->hva = uc;
> +		uc->idx = i;
> +	}
> +
> +	ucall_hdr = (struct ucall_header *)vaddr;
> +	sync_global_to_guest(vm, ucall_hdr);
> +
> +out:
> +	ucall_arch_init(vm, arg);
> +}
> +
> +void ucall_uninit(struct kvm_vm *vm)
> +{
> +	use_ucall_list = false;
> +	ucall_hdr = NULL;

It's unlikely we'd ever change the ucall setup on a running VM,
but we should sync these changes to the guest for good measure.

> +
> +	ucall_arch_uninit(vm);
> +}
> +
> +static struct ucall *ucall_alloc(void)
> +{
> +	struct ucall *uc = NULL;
> +	int i;
> +
> +	if (!use_ucall_list)
> +		goto out;
> +
> +	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
> +		if (atomic_test_and_set_bit(i, ucall_hdr->in_use))
> +			continue;
> +
> +		uc = &ucall_hdr->ucalls[i];
> +	}

This is not what I suggested in the last revision and it's still wrong.
Here, you're still looping through all of the pool and returning the last
one.

What I suggested was

 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		if (!atomic_test_and_set_bit(i, ucall_hdr->in_use)) {
 			uc = &ucall_hdr->ucalls[i];
 			break;
 		}
 	}

Notice how we leave the loop early when we find a free uc.

We should also zero the contents of the uc buffer before returning.

> +
> +out:
> +	return uc;
> +}
> +
> +static void ucall_free(struct ucall *uc)
> +{
> +	if (!use_ucall_list)
> +		return;
> +
> +	clear_bit(uc->idx, ucall_hdr->in_use);

This seems to be the one and only use of idx which is another argument for
dropping the variable and just calculating it instead.

> +}
> +
> +static vm_vaddr_t get_ucall_addr(struct ucall *uc)
> +{
> +	if (use_ucall_list)
> +		return (vm_vaddr_t)uc->hva;

A comment explaining that this hva has already been synchronized
with the guest would be good. Or maybe a different name for the
pointer than hva, one which conveys that it's a pointer that works
as both an hva and gva would be better.


> +
> +	return (vm_vaddr_t)uc;
> +}
>  
>  void ucall(uint64_t cmd, int nargs, ...)
>  {
> -	struct ucall uc = {
> -		.cmd = cmd,
> -	};

This zeros all members except cmd.

> +	struct ucall *uc;
> +	struct ucall tmp;

And this makes tmp full of stack garbage, so in the non uc-pool case we
no longer have an equivalent uc. Please initialize tmp the same way uc
was initialized.

>  	va_list va;
>  	int i;
>  
> +	uc = ucall_alloc();
> +	if (!uc)
> +		uc = &tmp;
> +
> +	uc->cmd = cmd;
> +
>  	nargs = min(nargs, UCALL_MAX_ARGS);
>  
>  	va_start(va, nargs);
>  	for (i = 0; i < nargs; ++i)
> -		uc.args[i] = va_arg(va, uint64_t);
> +		uc->args[i] = va_arg(va, uint64_t);
>  	va_end(va);
>  
> -	ucall_arch_do_ucall((vm_vaddr_t)&uc);
> +	ucall_arch_do_ucall(get_ucall_addr(uc));

We don't need get_ucall_addr(). Just do the if-else right here

   if (use_ucall_list)
       ucall_arch_do_ucall((vm_vaddr_t)uc->hva);
   else
      ucall_arch_do_ucall((vm_vaddr_t)uc);

> +
> +	ucall_free(uc);
> +}
> +
> +static void *get_ucall_hva(struct kvm_vm *vm, uint64_t uc)
> +{
> +	if (vm->use_ucall_list)
> +		return (void *)uc;
> +
> +	return addr_gva2hva(vm, uc);
>  }
>  
>  uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
> @@ -27,7 +127,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
>  	if (!uc)
>  		uc = &ucall;
>  
> -	addr = addr_gva2hva(vcpu->vm, ucall_arch_get_ucall(vcpu));
> +	addr = get_ucall_hva(vcpu->vm, ucall_arch_get_ucall(vcpu));

Wait, I thought we wanted ucall_arch_get_ucall() to return hvas?
It would make more sense if it did, since it's called from the
host.

>  	if (addr) {
>  		memcpy(uc, addr, sizeof(*uc));
>  		vcpu_run_complete_io(vcpu);
> -- 
> 2.37.1.455.g008518b4e5-goog
>

Thanks,
drew
