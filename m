Return-Path: <kvm+bounces-62022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E1ECC32DC4
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D53934EC652
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31E22FF14D;
	Tue,  4 Nov 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kDt1VJTf"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29422FCC02
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286419; cv=none; b=dS+xVK4+9PKjxgea8FjsKU7NE6NoXqjkN6dn80O0p26F3Sn1pllUFXOnw5PH+7ra40iQb9zm7sinjqbEqvsyVYq7ANW0whfCz/BoSDHJ5C6UX1sEyVMlNYGeOGEQbXzrW2g9V3fWzJPjZPJu03i/eXeR2bgxEV7N4YS3Ubs9br4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286419; c=relaxed/simple;
	bh=2OhcAUdB0tHmscZz9a/V7gpElutoP/FD8ca9U+0iMrI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=thw9lin4zGexSlY6poaxtIuKPYX21VhdayR6LJHAUJxxZVih3F3kmjIYVkrhRGOsfbGt+x/dqwyC+kMIj1B6TlQjp8z9YAslk8uAJ7Lo+bfCvAt1UgTdDjSrznnJIUg31gazgmEgOGf6sp3qyxB1gRxPyvY2UkvakgZ3+2d/Gj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kDt1VJTf; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lm03zTugh5/LobL3mDR9QgjFS+gdjZMCrMtSX6UIEmA=;
	b=kDt1VJTfvo8GlrWFY8BAGnUc0yJ9QD3F5qz6lBNdBgVdzIuojeBDOu5Wpo1wc2v0fq5hFD
	PgnsMJBD7Zj2EzGLt9wWebi+svqZWtS1ogb7i4JI4FP/dazkSZGMqtIlC08Hx9H4N9WgFC
	FU8MsMJr2cqGaajC6whMl/MgTzlZHj0=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 00/11] Nested SVM fixes, cleanups, and hardening
Date: Tue,  4 Nov 2025 19:59:38 +0000
Message-ID: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A group of semi-related fixes, cleanups, and hardening patches for nSVM.

Patches 1-3 fix or add missing consistency checks.

Patches 4-5 are renames to clarify some VMCB fields.

Patches 6-10 add hardening to reading the VMCB12, caching all used
fields in the save area to prevent theoritical TOC-TOU bugs, sanitizing
used fields in the control area, and restricting accesses to the VMCB12
through guest memory.

Patch 11 further restricts fields copied from VMCB01 to VMCB12.

Yosry Ahmed (11):
  KVM: nSVM: Fix consistency checks for NP_ENABLE
  KVM: nSVM: Add missing consistency check for EFER, CR0, CR4, and CS
  KVM: nSVM: Add missing consistency check for event_inj
  KVM: SVM: Rename vmcb->nested_ctl to vmcb->misc_ctl
  KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
  KVM: SVM: switch svm_copy_lbrs() to a macro
  KVM: nSVM: Cache all used fields from VMCB12
  KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN
  KVM: nSVM: Simplify nested_svm_vmrun()
  KVM: nSVM: Sanitize control fields copied from VMCB12
  KVM: nSVM: Only copy NP_ENABLE from VMCB01's nested_ctl

 arch/x86/include/asm/svm.h                    |  31 +-
 arch/x86/kvm/svm/nested.c                     | 335 +++++++++++-------
 arch/x86/kvm/svm/sev.c                        |   4 +-
 arch/x86/kvm/svm/svm.c                        |  51 ++-
 arch/x86/kvm/svm/svm.h                        |  46 ++-
 tools/testing/selftests/kvm/include/x86/svm.h |  14 +-
 6 files changed, 302 insertions(+), 179 deletions(-)

-- 
2.51.2.1026.g39e6a42477-goog


