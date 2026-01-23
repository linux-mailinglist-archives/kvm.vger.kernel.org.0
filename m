Return-Path: <kvm+bounces-68944-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LrCL2LLcmlgpgAAu9opvQ
	(envelope-from <kvm+bounces-68944-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 02:14:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 38BE26EEE5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 02:14:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 19560300E5C9
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 01:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB707364E9B;
	Fri, 23 Jan 2026 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xJ80Yw9C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8204435CBB2
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769130841; cv=none; b=CCoS0bnG2QY5b2IeC/wKAq+iAPvkJDYRWrdulMCRulkplcCTlWWrqezOwj/HsbyDOMynU5KP90a7AW16gPObxSZ64xpAQVogH6WFs8SRhrLxplVUKzJ+0Nr2AbZSLDm3SO2vaCYINGbi8rt1QGV+EHEQCDQ/Vn9g3eC+rNIrLiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769130841; c=relaxed/simple;
	bh=KtpkK9KMGqmPBPHTIIwQ4r4pna76M60pQr05gNWo1pg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gkRqbEihCFC8NWR0cZYDkDpRwm/0D896yaLKMk5IbQnkkmQKDOvVCvGK2IcxrI7RgRdKQCuyrXSAZWA71h+m5JwNuLInnZBMCpZy31XhyZItOrar9c5FK2dEORz7I61tWKdqKTMTw/1lM2nMUjJJpc6SNJIjc4QDQN6bEaEmHwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xJ80Yw9C; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac814f308so899603a91.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 17:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769130830; x=1769735630; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZWpU7DU72tgj32XvD0YWaDK46yB7FqvOJMG/bI82xE=;
        b=xJ80Yw9C9PM7y8wd6oq4ICPyr/ko+ihC78kg65ddfgj45NOSOlR6f0PtTTCgQGnb3u
         3c+pCDCgSXdtudK9IZG/keR6DAJmVf/CMpQPsrZfz2ZAdUdWAINI+CaKBPT2uXiiGW2h
         hndEfgkId4BDBZqVQq7BKtYXJEWlvswxj0i1K9bgzXULivKMzmZFiMOL7yMaJ4IxmXZv
         Q/rmUx+ONeofHUPaivUlb1Z63dv+F9XPEjRIRmWKTzZg+ICS/EEw255FxpKTLD2Ap/tD
         YxANGmvxRtrL75XgfcQfHfhYubdFyO3YgDdwOv46Om4oGsiVF4/r/U27M8IiqHZ5yJy3
         8SiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769130830; x=1769735630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sZWpU7DU72tgj32XvD0YWaDK46yB7FqvOJMG/bI82xE=;
        b=uoy8bUN+SMil9kPTnuXlrmCb6a/QyBGprBNHCa94Y8ezpjnOnN/TG+mitam1tbUMnI
         9aGSs2ilNhwj9zOyygfOMLPT9aMUbcKEVy9qgNOUJEe9oVXR6yMKSik9L1GWpbcQ9OL1
         TgFsq2t+gG6tVMDob2lPuXHtWMpKCaKXmB+qaOEdQT+HT6c+w4M0FKWIVtVnpnlN3yeF
         W3oc/PoVL3YaUgY8C771oLByiY8SrhxHed4sh7hdr0g/I7ZB89aFSDIe2sZIp6Dg46/J
         nSDWIlyLfCCBw0hmh/wH33J1xcZRzyXoVxq7jZNQ8P2MmaIHE6TFriOFT5Ox0aLsyzd8
         IIcA==
X-Forwarded-Encrypted: i=1; AJvYcCXX2zXOfPoGM0f65+B2+qPvkpxq6OLwILW3BrHDeZrUhlaWsSEvhFx37RmriBuZPoXxf3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWIsdkGvrKRoAE73Ga5M93Rb6beD/+TavwX05GxWLlAhcql7nV
	jdKMajK9rg7OD+tDpG1F3UpM4cCTF2yDkfFL4rjTUVIGaVvzhPmCIx/iQgH2SQzdARB9g6JAuvA
	Z9Cozcw==
X-Received: from pjtu12.prod.google.com ([2002:a17:90a:c88c:b0:34c:fbee:f264])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b12:b0:34a:4cc0:9e38
 with SMTP id 98e67ed59e1d1-35367025672mr879897a91.10.1769130830168; Thu, 22
 Jan 2026 17:13:50 -0800 (PST)
Date: Thu, 22 Jan 2026 17:13:48 -0800
In-Reply-To: <20260121004906.2373989-4-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121004906.2373989-1-chengkev@google.com> <20260121004906.2373989-4-chengkev@google.com>
Message-ID: <aXLLTA5MtOEYf8k2@google.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Add nested NPF injection test for SVM
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68944-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 38BE26EEE5
X-Rspamd-Action: no action

On Wed, Jan 21, 2026, Kevin Cheng wrote:
> ---
>  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
>  .../selftests/kvm/x86/svm_nested_npf_test.c   | 154 ++++++++++++++++++
>  2 files changed, 155 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_npf_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index e88699e227ddf..8babe6e228e11 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
>  TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
>  TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
>  TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
> +TEST_GEN_PROGS_x86 += x86/svm_nested_npf_test

a, b, c, d, e, f, g, h, i, j, k, l, m, N, o, p, q, r, S, t, u, v, w, x, y, z

>  TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
>  TEST_GEN_PROGS_x86 += x86/sync_regs_test
>  TEST_GEN_PROGS_x86 += x86/ucna_injection_test
> diff --git a/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c b/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c
> new file mode 100644
> index 0000000000000..c0a894acbc483
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/svm_nested_npf_test.c
> @@ -0,0 +1,154 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_nested_npf_test
> + *
> + * Test nested NPF injection when the original VM exit was not an NPF.
> + * This exercises nested_svm_inject_npf_exit() with exit_code != SVM_EXIT_NPF.
> + *
> + * L2 executes OUTS with the source address mapped in L2's page tables but
> + * not in L1's NPT. KVM emulates the string I/O instruction, and when it
> + * tries to read the source operand, the GPA->HPA translation fails. KVM
> + * then injects an NPF to L1 even though the original exit was IOIO.
> + *
> + * Test 1: Final data page GPA not in NPT (PFERR_GUEST_FINAL_MASK)
> + * Test 2: Page table page GPA not in NPT (PFERR_GUEST_PAGE_MASK)

Please don't add file-level comments (the Copyright is fine), because things like
the name of the test/file inevitably become stale, and they're useless, and the
description of _what_ the test is doing is almost always more helpful if it's
the comment is closer to the code it's documenting.

> + *
> + * Copyright (C) 2025, Google, Inc.
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +#define L2_GUEST_STACK_SIZE 64
> +
> +enum test_type {
> +	TEST_FINAL_PAGE_UNMAPPED, /* Final data page GPA not in NPT */
> +	TEST_PT_PAGE_UNMAPPED, /* Page table page GPA not in NPT */
> +};
> +
> +static void *l2_test_page;

Why store it as a "void *"?  Just track a vm_addr_t and avoid a bunch of casts.

> +
> +#define TEST_IO_PORT 0x80
> +#define TEST1_VADDR 0x8000000ULL
> +#define TEST2_VADDR 0x10000000ULL
> +
> +/*
> + * L2 executes OUTS with source at l2_test_page, triggering a nested NPF.
> + * The address is mapped in L2's page tables, but either the data page or
> + * a PT page is unmapped from L1's NPT, causing the fault.
> + */
> +static void l2_guest_code(void *unused)
> +{
> +	asm volatile("outsb" ::"S"(l2_test_page), "d"(TEST_IO_PORT) : "memory");
> +	GUEST_ASSERT(0);

	GUEST_FAIL
> +}
> +

...

> +static void run_test(enum test_type type)
> +{
> +	vm_paddr_t expected_fault_gpa;
> +	uint64_t exit_info_1_mask;
> +	vm_vaddr_t svm_gva;
> +
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +
> +	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
> +	vm_enable_npt(vm);
> +	vcpu_alloc_svm(vm, &svm_gva);
> +
> +	if (type == TEST_FINAL_PAGE_UNMAPPED) {
> +		/*
> +		 * Test 1: Unmap the final data page from NPT. The page table
> +		 * walk succeeds, but the final GPA->HPA translation fails.
> +		 */
> +		l2_test_page =
> +			(void *)vm_vaddr_alloc(vm, vm->page_size, TEST1_VADDR);
> +		expected_fault_gpa = addr_gva2gpa(vm, (vm_vaddr_t)l2_test_page);
> +		exit_info_1_mask = PFERR_GUEST_FINAL_MASK;
> +	} else {
> +		/*
> +		 * Test 2: Unmap a PT page from NPT. The hardware page table
> +		 * walk fails when translating the PT page's GPA through NPT.
> +		 */
> +		l2_test_page =
> +			(void *)vm_vaddr_alloc(vm, vm->page_size, TEST2_VADDR);
> +		expected_fault_gpa =
> +			get_pt_gpa_for_vaddr(vm, (vm_vaddr_t)l2_test_page);
> +		exit_info_1_mask = PFERR_GUEST_PAGE_MASK;
> +	}
> +
> +	tdp_identity_map_default_memslots(vm);
> +	tdp_unmap(vm, expected_fault_gpa, vm->page_size);

Hrm.  This should really be a vendor agnostic test.  There exactly results are
vendor specific, but thye core concept and pretty much all of the configuration
is nearly identical.

It'd also be nice to support more than just !PRESENT, e.g. to verify protection
violations and other things that set PFERR/EXIT_QUAL bits.

