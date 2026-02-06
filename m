Return-Path: <kvm+bounces-70388-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mD2XBgc+hWme+gMAu9opvQ
	(envelope-from <kvm+bounces-70388-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:04:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE40EF8C9E
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA355301E946
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95C2E22D4D3;
	Fri,  6 Feb 2026 01:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B9k0fbMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E3F15746F
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770339831; cv=none; b=OkZi5IySXh18kXB09LarJKWt3OmQkCKj80Z8XXoH3mPjy8JLKGPZITyHLiuu08IlgGOLG2+cYjsa/dwEaBigibwnH8OghvfeWwjiUOUjsyUahXlSUjhpVFr77B8ebsQTvi0iA4kHBAd9gjZZ9trT9rM3C4yCNt2aO2SEeGCHlXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770339831; c=relaxed/simple;
	bh=JmX/XfWXR629Pr1MI2kc6h/brXJQWKMwVlG9q0ypUlM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IOAJz5L/e4EJE6/scULKlfoJgGK7Nm6iYFSh4EgvrII5Wwxa+pq9Nc/Q4uRXBYm0EJgUFdiRhn6EE3ez8NNfoLXrSO6lA93TtdTEuYXHnmhoBCSpezXB0VvM6ODn5OjnzWIhgdzGIOUcPIu2T33FTC4ZfaGGJq2MWXu7TN/SXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B9k0fbMr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bce224720d8so958613a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770339831; x=1770944631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0lVoFfKvl5YSoIcbrPqAsIJPlod8CDuqfq1QKihmH+M=;
        b=B9k0fbMrhlpCvp2vtT3vSK/LEfFwYNw1mp7r/HT7GvGnS/7h5ElEBcZZfFc4uiYIO0
         euIoieOM65XBVJwS2Chk29EQqMaUalv2DyHOcVIsL2tEVtW51CKXIY/mREtwzyNHy3OE
         r3k7afCooVKjdDJCm4Ss+CIxcaDETDT54mVmf64Y387O7m5P8qDMQv+Yxol9mHxlTBZx
         d4erJmPhtGZEj/utCPx7SJ5pnV5C4q0mbNiJUtly5wDjtljIkN654qjiko5a3VE76v0M
         0MkI9F2Yjp23SlLO+txce/2euuRmsb/R2abUMmT9Tqqfs9h4SNdptXyPwUJptGjtkfLj
         QEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770339831; x=1770944631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0lVoFfKvl5YSoIcbrPqAsIJPlod8CDuqfq1QKihmH+M=;
        b=u/KzKhSYgiqnRUE/QvJNPReEILooHRd4hNhq7MqqZSUoTYdsqCQTts+L/RCrgkGHu/
         +fOePJCJbOctBh/WZYvUekmjY/LdpdZBpVw0S/1oBz23SWBBW4wT7EfHTTOWmXPu+Ie9
         hM+QX5Xys9Wk/smvjczwlqJMSGuPiaAuaKaTTy3MUBjHj8YQNXwH+9WRtxxyBUwkk4RN
         /5NI48YWMry6YW/FD/pbTqbA4mFJt4g5vDjgNa8Fc8GeG3yzDnWCV6EZIQJlrQFQ3BvR
         sgnfy5Qy/HCUTeBFxhn8eHBTmeZhs+cZVHt8xuqoaKX1MCF9a8i8gsDrSal5xdc+SEiv
         gakg==
X-Forwarded-Encrypted: i=1; AJvYcCUie3LsD+zTgDwAZs8J66XMN5DNJ4ysghJcha/XnYCokz1GPXFCgqz0HAx+9MOSa9U1ZNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNiZFKvuiRG40KfIHzfRcd2Gpxg/LOmLqU2l6LG6BuXBM93Exr
	A4ob3OjjVxIMsGgvEOROjwHi2ma4ZzP6BXC3GXCZR0YkRnbDJMDjC9rFNvGpL2Iz22CWTFHjJN1
	Pphg2JA==
X-Received: from pgbee14.prod.google.com ([2002:a05:6a02:458e:b0:c66:9f06:4f46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a95:b0:387:5ded:994a
 with SMTP id adf61e73a8af0-393ad376782mr1047583637.60.1770339831056; Thu, 05
 Feb 2026 17:03:51 -0800 (PST)
Date: Thu, 5 Feb 2026 17:03:49 -0800
In-Reply-To: <20260115011312.3675857-4-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev> <20260115011312.3675857-4-yosry.ahmed@linux.dev>
Message-ID: <aYU99UWEIKwSzlJI@google.com>
Subject: Re: [PATCH v4 03/26] KVM: selftests: Add a test for LBR save/restore
 (ft. nested)
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_FROM(0.00)[bounces-70388-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: AE40EF8C9E
X-Rspamd-Action: no action

On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> @@ -1359,6 +1359,11 @@ static inline bool kvm_is_ignore_msrs(void)
>  	return get_kvm_param_bool("ignore_msrs");
>  }
>  
> +static inline bool kvm_is_lbrv_enabled(void)
> +{
> +	return !!get_kvm_amd_param_integer("lbrv");

Argh, KVM and its stupid "bools are ints" params.

> +}
> +
>  uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr);
>  
>  uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
> diff --git a/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
> new file mode 100644
> index 000000000000..a343279546fd
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86/svm_lbr_nested_state.c
> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_lbr_nested_state
> + *
> + * Test that LBRs are maintained correctly in both L1 and L2 during
> + * save/restore.

Drop the file comments.  The name of the test is beyond useless, and if the
reader can't quickly figure out what the test is doing, then the code itself
needs more comments.

> + *
> + * Copyright (C) 2025, Google, Inc.
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +
> +
> +#define L2_GUEST_STACK_SIZE 64
> +
> +#define DO_BRANCH() asm volatile("jmp 1f\n 1: nop")
> +
> +struct lbr_branch {
> +	u64 from, to;
> +};
> +
> +volatile struct lbr_branch l2_branch;
> +
> +#define RECORD_BRANCH(b, s)						\

RECORD_AND_CHECK_BRANCH?

> +({									\

Use do-while (0) unless the macro _needs_ to return a value.  do-while provides
compile-time safety against some goofs.

> +	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);			\
> +	DO_BRANCH();							\
> +	(b)->from = rdmsr(MSR_IA32_LASTBRANCHFROMIP);			\
> +	(b)->to = rdmsr(MSR_IA32_LASTBRANCHTOIP);			\
> +	/* Disabe LBR right after to avoid overriding the IPs */	\
> +	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);					\
> +									\
> +	GUEST_ASSERT_NE((b)->from, 0);					\
> +	GUEST_ASSERT_NE((b)->to, 0);					\
> +	GUEST_PRINTF("%s: (0x%lx, 0x%lx)\n", (s), (b)->from, (b)->to);	\

Why print here?  Won't the asserts below print useful information if they fail?

> +})									\

