Return-Path: <kvm+bounces-65883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E2805CB982B
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 19:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBAAF3095E6C
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 18:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD99F2F6195;
	Fri, 12 Dec 2025 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I06dKC75"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9447B29D26D
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765562496; cv=none; b=Dt14Hxg1O86lIb+QiOZJP5G6x0lyhqPGSC9Lz3Aekef9Pi8pB+VeHK0cCboqn1SaFq9QoYV/M1cubVuH+rlx11m9AWv+2gC7larrQhS9aRLG8h09dhyGZiKPnCTiru8RQygFwzN8SwXMtbC3r+r22FLnIdlhqYAH9idlyboXyrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765562496; c=relaxed/simple;
	bh=ZoEjubOAjdQ0I4mKDTjbIEIjvzHhGG3QwAQog6ErYcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZT7pwqzegFzPSi0cng9r6qeHvKe5jLz54KyMCN/Oq3LVKnLTR/44EsyEI8sOyV9Ws6lxGYzUCnDvEJkmKhOXIqHwJaiu0HnP16gkDC0R8Aj9DkCPryZA/dtcna27b+NBqRJV9JVWqvU/3eUvtawWd16xDEAJbSdio/e2WEryTF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I06dKC75; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-be8c77ecc63so1937832a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 10:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765562494; x=1766167294; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bo9Rm1dXUYD7l80/8yzy6VKuYdJBg7Dl5IR6XCJePgM=;
        b=I06dKC75/2bOc5blkuZ+GDpnfBG6qxKOfW9yiqhPG/orBDpHzTi43UNZdV2MXNJX/O
         exLf4rjIH0K5/+tWDlBvlXLfvA7Z+UBm2t2josfNW6KEc+kxxPSMNAJYvj3FgYsHFX8o
         8CjNo9XBa2sksSCRnHE/Pm2AXkRpJUyfRQXQ02tGOcvp6gOjev5AkUn2jYRUhdpkBGoL
         +n0WFq5mIGYNwlA3BhDtxpSOMnV0432ZseCcTa0hDnoAP7+Ct6+0qVjizpoCwIffVJQ+
         gMT5m1Os4GCUlxRbvCjaPlwualfK6KbXgSPllqvMOnpdUV+AMX0MIKUB0X7JhxJr7xfE
         kHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765562494; x=1766167294;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bo9Rm1dXUYD7l80/8yzy6VKuYdJBg7Dl5IR6XCJePgM=;
        b=RWHr5wMBNcWwbqYewVcjSw6oP07vG0FJRV7tuqwWTNFPf9KHeIrI/UStjkMCrIgeZp
         dEGsRKrWiXp2VfZr62Qzv/mdoYr8eaPaqPgZY1Yv9NCD5x+Amxq18AeU9RjKbinsuZ8q
         cu2pB55nLqYxVmyritgfk9MA6dQ9GxZvID+VcIadzmj+usesyuFijg7rmttmuu4vpaVb
         cU3eiku9Hds3uzmcDZ0YN3QhPUC5OI+Y8QGQevejfel1U2SEVOwwC/Y2hY7/Ct6G4hLC
         JpNchlKk8qADToDHbgo5vU5POKnUt904I3+QyHybNDHvhRrEfbb/M18W+DAnPsoM/zru
         kkAw==
X-Forwarded-Encrypted: i=1; AJvYcCV+mN7e48aSgLcBawrIqfn0HBNpgRiKY0b8KiSbvjUbeVNghPg0WO9afCVVPweB42g84jc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzumeGnA83Wu+coqkR2C7324ElAWrPPtVfUdPvGMWVUvRAjfgmk
	sWdyyeNFZ7KitV2XEkwPXVwBuHzQI9NIpeBJVs/pwN3KEzJZbsdVq8u6iYpxgV5cVsL2dc94CMZ
	ewcmbTw==
X-Google-Smtp-Source: AGHT+IG/4+97J2DvkIN9CYSSrtj45Rtx9GE13lZ9oDwNJ9qEfvU5HujDnh8hzt5x4oEkihpsJs4cN5QoWWM=
X-Received: from pgcu129.prod.google.com ([2002:a63:7987:0:b0:c0d:af51:bbb5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7350:b0:366:14ac:e1df
 with SMTP id adf61e73a8af0-369b05bee25mr3197541637.69.1765562493663; Fri, 12
 Dec 2025 10:01:33 -0800 (PST)
Date: Fri, 12 Dec 2025 10:01:32 -0800
In-Reply-To: <aTuLC/gNucl9o+Y+@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com> <20251205231913.441872-4-seanjc@google.com>
 <aTuLC/gNucl9o+Y+@intel.com>
Message-ID: <aTxYfJLKu6yC_5hj@google.com>
Subject: Re: [PATCH v3 03/10] KVM: selftests: Add a test to verify APICv
 updates (while L2 is active)
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 12, 2025, Chao Gao wrote:
> On Fri, Dec 05, 2025 at 03:19:06PM -0800, Sean Christopherson wrote:
> >+static void bad_ipi_handler(struct ex_regs *regs)
> >+{
> >+	TEST_FAIL("Received \"bad\" IPI; ICR MMIO write should have been ignored");
> 
> is it ok to use TEST_FAIL() in guest code?

Doh.  Good point.  It'll definitely generate a failure, but not a very helpful one.

> >+static void l2_vmcall(void)
> >+{
> >+	/*
> >+	 * Exit to L1.  Assume all registers may be clobbered as selftests's
> >+	 * VM-Enter code doesn't preserve L2 GPRs.
> >+	 */
> >+	asm volatile("push %%rbp\n\t"
> >+		     "push %%r15\n\t"
> >+		     "push %%r14\n\t"
> >+		     "push %%r13\n\t"
> >+		     "push %%r12\n\t"
> >+		     "push %%rbx\n\t"
> >+		     "push %%rdx\n\t"
> >+		     "push %%rdi\n\t"
> >+		     "vmcall\n\t"
> >+		     "pop %%rdi\n\t"
> >+		     "pop %%rdx\n\t"
> >+		     "pop %%rbx\n\t"
> >+		     "pop %%r12\n\t"
> >+		     "pop %%r13\n\t"
> >+		     "pop %%r14\n\t"
> >+		     "pop %%r15\n\t"
> >+		     "pop %%rbp\n\t"
> >+		::: "rax", "rcx", "rdx", "rsi", "rdx", "r8", "r9", "r10", "r11", "memory");
> >+}
> 
> There's already a vmcall() helper in vmx.h. Why add a new one?

Oh, nice, I somehow missed that.

> >+int main(int argc, char *argv[])
> >+{
> >+	vm_vaddr_t vmx_pages_gva;
> >+	struct vmx_pages *vmx;
> >+	struct kvm_vcpu *vcpu;
> >+	struct kvm_vm *vm;
> >+	struct ucall uc;
> >+
> >+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
> >+
> >+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
> >+
> >+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
> >+	prepare_virtualize_apic_accesses(vmx, vm);
> >+	vcpu_args_set(vcpu, 2, vmx_pages_gva);
> 
> s/2/1
> 
> only one argument here.

Gah.  Thank you!

