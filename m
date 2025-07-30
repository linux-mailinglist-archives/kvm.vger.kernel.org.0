Return-Path: <kvm+bounces-53742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F1DB165C8
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 19:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3229D5A1FD4
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 17:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1582E2653;
	Wed, 30 Jul 2025 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JzC/fzW6"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7643B2E090C;
	Wed, 30 Jul 2025 17:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897628; cv=none; b=jTuTTyN30ZboEIjdZuiDPvUcwKAj+crYwK/lSmm0hSR+gu3K8jKhI39rgQH8GEOkJfuImtua/1LytXnf7aHSJkzEC11oeagKIR10Qtf8KnvN+kXaHwx3oK0KthVAi25QhyAGDfdZI7DL/jp9YbZ6ouPHumaSatKkuMdZTE8YOQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897628; c=relaxed/simple;
	bh=nd8hL/EB+eL0dqJYvrYyO9UylOeX1AJ5Dy/kLSyfRiU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HK08WcvXm41RZcjhFNRJKF3aJhG+tVnosqKmSkw91q70cE2OYvPhpCMa5D6gykg+oGTQqfrqCIWlTW9DeYNc0o6zmGGo4QshN2zMSrKJMOkOyt/rhqWI46dRj7EldYVaXoS9UOT2DzOTm6O8Lj2sHAamyJQ8MNAJMXlq6QLI7hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JzC/fzW6; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 56UHk6n81614815
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 30 Jul 2025 10:46:29 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 56UHk6n81614815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1753897590;
	bh=MaCxJsJ7LxJ+rPvVNVpcAcWpNM3k8goFPturjeGBc4k=;
	h=From:To:Cc:Subject:Date:From;
	b=JzC/fzW6+GJf2g0x0tvSLW2JR/5SqwRVdzqonVFV1ktuBPBI+tUrvcYPUe7rT9fDC
	 v6VBJy4FyKi7CVpWPFVRaLHeh/BRzunJYAbcokFTtxq5fJy+2Q9zpJCTXNjmFxfK4i
	 FrmvjNGhJ12u64RIsuctc957hU4wbTxrs9xB21OGQKzThWEm72LvyN5C0yAIHgKfKy
	 rKSgxWIHBFatvCKSm4qZuTcmdDio02SRWgGueSXfMyW9m6wqcxoDOrnANaKujlppYF
	 LhcvnSsEXmAQMhUxeTS/cwV/Na8NJMpt16I0m2IdlH//8H+DHBioUCvbujqPMW3gh3
	 UxByJk6/CVbyw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v1 0/4] KVM: VMX: Handle the immediate form of MSR instructions
Date: Wed, 30 Jul 2025 10:46:01 -0700
Message-ID: <20250730174605.1614792-1-xin@zytor.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set handles two newly introduced VM exit reasons associated
with the immediate form of MSR instructions to ensure proper
virtualization of these instructions.

The immediate form of MSR access instructions are primarily motivated
by performance, not code size: by having the MSR number in an immediate,
it is available *much* earlier in the pipeline, which allows the
hardware much more leeway about how a particular MSR is handled.

For proper virtualization of the immediate form of MSR instructions,
Intel VMX architecture adds the following changes:

  1) The immediate form of RDMSR uses VM exit reason 84.

  2) The immediate form of WRMSRNS uses VM exit reason 85.

  3) For both VM exit reasons 84 and 85, the exit qualification is set
     to the MSR address causing the VM exit.

  4) Bits 3 ~ 6 of the VM exit instruction information field represent
     the operand register used in the immediate form of MSR instruction.

  5) The VM-exit instruction length field records the size of the
     immediate form of the MSR instruction.

Note: The VMX specification for the immediate form of MSR instructions
was inadvertently omitted from the last published ISE, but it will be
included in the upcoming edition.

Linux bare metal support of the immediate form of MSR instructions is
still under development; however, the KVM support effort is proceeding
independently of the bare metal implementation.


Xin Li (Intel) (4):
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  KVM: x86: Introduce MSR read/write emulation helpers
  KVM: VMX: Handle the immediate form of MSR instructions
  KVM: x86: Advertise support for the immediate form of MSR instructions

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 ++
 arch/x86/include/uapi/asm/vmx.h    |  6 +-
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/cpuid.c               |  6 +-
 arch/x86/kvm/reverse_cpuid.h       |  5 ++
 arch/x86/kvm/vmx/vmx.c             | 26 ++++++++
 arch/x86/kvm/vmx/vmx.h             |  5 ++
 arch/x86/kvm/x86.c                 | 96 +++++++++++++++++++++++-------
 arch/x86/kvm/x86.h                 |  1 +
 10 files changed, 130 insertions(+), 22 deletions(-)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.50.1


