Return-Path: <kvm+bounces-53318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A12B0FBF4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 23:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 318CF547A74
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 21:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D122236A70;
	Wed, 23 Jul 2025 21:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3a876eDu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B366235076
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 21:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753304667; cv=none; b=ucqmNtxaz+eP1T8tYNFOe+1CYfjKz1gBIxa49+Sxs3wihlvMmtpjPp4awnuRdEoS47yWhsZ8uFUKft7cW/OW2ByXL6d03zvBjSKYZCXArQHr56manhG0TY96x8QqmAgsCrx8IObW61/GykxH2q12VN4n4QhSFzKBiM5rP/0wT2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753304667; c=relaxed/simple;
	bh=WAv8i9t+2A4TSqFub5I4xy1flvqkr+YG7h0uKx/Wfok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XWfNFSbhYEgNQgECNoN4uHehjIbSDZNCdZTJXwI14PCtVYs+Tx5pWBHDgWhxAxiwFl7vjp5w1UYH9o+j648NfLTsbnEhGdlpy+kPowY6GptmpueXsZg4pLOtlS2SpHNJY8Cg1LLxmC4gOi7mQaUUWyyLhXfVOvKeZ6ynGK6E2ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3a876eDu; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3122368d82bso402109a91.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 14:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753304665; x=1753909465; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6AKxdsaDKMq8JifVPZTjK8B0Aqm8PGqtAXC7zsjT09Y=;
        b=3a876eDujIwCtpicY/A4hnyFdOf05uazhExg/1n36Iz9YIvufj/ExXC1ca0pdIT8LI
         LlefJalA2m1HkJFlXFwFZ0zbblGzDleoNPixFoqtixqWuxuGEPwCBk3XSZJ5EJvHbGIR
         gyFijJwUb37YtuSxNpXaD6Vpqv4a18vbZLAoKga1nD1RbIrVEhp6bVyABeBP5/Z4x3bJ
         jaaT9XEoOmQz2CmA7LgdV0lnQGf3QyXUYLLkLPPhif0s5pgDDc60vTJRNjp1tOtfvqZE
         uD8Evm+azPLspelMS+PWr8f+z8nAiNTzgX2SX2NiWxg5jtryH2HGT9NnOm4ItlI6QWxn
         3hwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753304665; x=1753909465;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6AKxdsaDKMq8JifVPZTjK8B0Aqm8PGqtAXC7zsjT09Y=;
        b=pOJDD9i1G2452tgKCs0ZeMiBXkPdt3ub5Lot/cj1RVwKvsvNsaHrWVB6nK72KLCakC
         6lDKu/AdHG3VTi2xV+wzRnVSZmsVSUBd8AyQiEINaSCN6QoZUAx6ozCesWdfCztpv2lP
         940PUDpAkGNs5EH74fUoJUwb4HMv8Gh+XwFnBGfSCRsHylTDJSRlrZ4fGKegBrUWMoWD
         qUq4eyZV/f+1fCTnNPa/9RBU+s5X16l9IRMiTrGx68O6HbBN/Pp2npbcgvd+gqTbGeOd
         m8PFL9h/kIwgJiZmZHx14zCad1WnxXK6m/8xL2dVKS78MaV+DmHkpFcUL6br5LBTxkoF
         XTsg==
X-Forwarded-Encrypted: i=1; AJvYcCWSfvl5dWxJWRs5WdqbMxwTm/WvBZ4Ttrx/USYV8uzqkc8Weouo5iO22fjXSqNC6Y4kjwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAFRdvCrOJ9Zc6ODMQM7HIVqWGoCzwTvEJjluNvk5l+pK7qk7k
	Q/qRWPK9kRxpoYMTJsv0i6grhkmlAY0EPFtdOSrcZIEFdsbbg9cj9B7aJvQKPXS5jQzLwmU29aM
	NSkV2aQ==
X-Google-Smtp-Source: AGHT+IGMPRmib3bNif1K4SFd+9uNWBQSopU22YYdtSI0CHVsr5nQ6FOrb6bhSIdrxx4sJqoJq+ep89XSFQI=
X-Received: from pjbov7.prod.google.com ([2002:a17:90b:2587:b0:31c:bd1d:516])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2885:b0:311:f99e:7f4b
 with SMTP id 98e67ed59e1d1-31e507ce490mr5730816a91.28.1753304665082; Wed, 23
 Jul 2025 14:04:25 -0700 (PDT)
Date: Wed, 23 Jul 2025 14:04:23 -0700
In-Reply-To: <20250707224720.4016504-8-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707224720.4016504-1-jthoughton@google.com> <20250707224720.4016504-8-jthoughton@google.com>
Message-ID: <aIFOV4ydqsyDH72G@google.com>
Subject: Re: [PATCH v5 7/7] KVM: selftests: Add an NX huge pages jitter test
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 07, 2025, James Houghton wrote:
> +		/*
> +		 * To time the jitter on all faults on pages that are not
> +		 * undergoing nx huge page recovery, only execute on every
> +		 * other 1G region, and only time the non-executing pass.
> +		 */
> +		if (page & (1UL << 18)) {

This needs a #define or helper, I have no idea what 1 << 18 is doing.

> +			uint64_t tsc1, tsc2;
> +
> +			tsc1 = rdtsc();
> +			*gva = 0;
> +			tsc2 = rdtsc();
> +
> +			if (tsc2 - tsc1 > max_cycles)
> +				max_cycles = tsc2 - tsc1;
> +		} else {
> +			*gva = RETURN_OPCODE;
> +			((void (*)(void)) gva)();
> +		}
> +	}
> +
> +	GUEST_SYNC1(max_cycles);
> +}
> +
> +struct kvm_vm *create_vm(uint64_t memory_bytes,
> +			 enum vm_mem_backing_src_type backing_src)
> +{
> +	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
> +	struct guest_args *args = &guest_args;
> +	uint64_t guest_num_pages;
> +	uint64_t region_end_gfn;
> +	uint64_t gpa, size;
> +	struct kvm_vm *vm;
> +
> +	args->guest_page_size = getpagesize();
> +
> +	guest_num_pages = vm_adjust_num_guest_pages(VM_MODE_DEFAULT,
> +				memory_bytes / args->guest_page_size);
> +
> +	TEST_ASSERT(memory_bytes % getpagesize() == 0,
> +		    "Guest memory size is not host page size aligned.");
> +
> +	vm = __vm_create_with_one_vcpu(&vcpu, guest_num_pages, guest_code);
> +
> +	/* Put the test region at the top guest physical memory. */
> +	region_end_gfn = vm->max_gfn + 1;
> +
> +	/*
> +	 * If there should be more memory in the guest test region than there
> +	 * can be pages in the guest, it will definitely cause problems.
> +	 */
> +	TEST_ASSERT(guest_num_pages < region_end_gfn,
> +		    "Requested more guest memory than address space allows.\n"
> +		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
> +		    " wss: %" PRIx64 "]",

Don't wrap this last one.

> +		    guest_num_pages, region_end_gfn - 1, memory_bytes);
> +
> +	gpa = (region_end_gfn - guest_num_pages - 1) * args->guest_page_size;
> +	gpa = align_down(gpa, backing_src_pagesz);
> +
> +	size = guest_num_pages * args->guest_page_size;
> +	pr_info("guest physical test memory: [0x%lx, 0x%lx)\n",
> +		gpa, gpa + size);

And don't wrap here either (82 chars is totally fine).

> +
> +	/*
> +	 * Pass in MAP_POPULATE, because we are trying to test how long
> +	 * we have to wait for a pending NX huge page recovery to take.
> +	 * We do not want to also wait for GUP itself.
> +	 */

Right, but we also don't want to wait for the initial fault-in either, no?  I.e.
plumbing in MAP_POPULATE only fixes the worst of the delay, and maybe only with
the TDP MMU enabled.

In other words, it seems like we need a helper (option?) to excplitly "prefault",
all memory from within the guest, not the ability to specify MAP_POPULATE.

> +	vm_mem_add(vm, backing_src, gpa, 1,
> +		   guest_num_pages, 0, -1, 0, MAP_POPULATE);
> +
> +	virt_map(vm, guest_test_virt_mem, gpa, guest_num_pages);
> +
> +	args->pages = guest_num_pages;
> +
> +	/* Export the shared variables to the guest. */
> +	sync_global_to_guest(vm, guest_args);
> +
> +	return vm;
> +}
> +
> +static void run_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	struct timespec ts_elapsed;
> +	struct timespec ts_start;
> +	struct ucall uc = {};
> +	int ret;
> +
> +	clock_gettime(CLOCK_MONOTONIC, &ts_start);
> +
> +	ret = _vcpu_run(vcpu);
> +
> +	ts_elapsed = timespec_elapsed(ts_start);
> +
> +	TEST_ASSERT(ret == 0, "vcpu_run failed: %d", ret);
> +
> +	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
> +		    "Invalid guest sync status: %" PRIu64, uc.cmd);
> +
> +	pr_info("Duration: %ld.%09lds\n",
> +		ts_elapsed.tv_sec, ts_elapsed.tv_nsec);
> +	pr_info("Max fault latency: %" PRIu64 " cycles\n", uc.args[0]);
> +}
> +
> +static void run_test(struct test_params *params)
> +{
> +	/*
> +	 * The fault + execute pattern in the guest relies on having more than
> +	 * 1GiB to use.
> +	 */
> +	TEST_ASSERT(params->memory_bytes > PAGE_SIZE << 18,

Oooh, the 1 << 18 is 1GiB on PFNs.  Ugh.  Just use SZ_1G here.  And assert immediate
after setting params.memory_bytes, don't wait until the test runs.

> +		    "Must use more than 1GiB of memory.");
> +
> +	create_vm(params->memory_bytes, params->backing_src);
> +
> +	pr_info("\n");
> +
> +	run_vcpu(vcpu);
> +}
> +
> +static void help(char *name)
> +{
> +	puts("");
> +	printf("usage: %s [-h] [-b bytes] [-s mem_type]\n",
> +	       name);
> +	puts("");
> +	printf(" -h: Display this help message.");
> +	printf(" -b: specify the size of the memory region which should be\n"
> +	       "     dirtied by the guest. e.g. 2048M or 3G.\n"
> +	       "     (default: 2G, must be greater than 1G)\n");
> +	backing_src_help("-s");
> +	puts("");
> +	exit(0);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct test_params params = {
> +		.backing_src = DEFAULT_VM_MEM_SRC,
> +		.memory_bytes = DEFAULT_TEST_MEM_SIZE,
> +	};
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "hb:s:")) != -1) {
> +		switch (opt) {
> +		case 'b':
> +			params.memory_bytes = parse_size(optarg);
> +			break;
> +		case 's':
> +			params.backing_src = parse_backing_src_type(optarg);
> +			break;
> +		case 'h':
> +		default:
> +			help(argv[0]);
> +			break;
> +		}
> +	}
> +
> +	run_test(&params);
> +}
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 

