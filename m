Return-Path: <kvm+bounces-53863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DE4B189CE
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 02:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 059D3626AF2
	for <lists+kvm@lfdr.de>; Sat,  2 Aug 2025 00:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0739718B12;
	Sat,  2 Aug 2025 00:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="uD8mwxkY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F5C46BF;
	Sat,  2 Aug 2025 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754093766; cv=none; b=iRllKyYU+x9qFKc741w0kXjpFriRnTctUl/ho2roLEjrEdyWzdjwOfZ0nECsBS+e0708gOF+HBSKL1Jz4HLtzvrggggf3QIny7UVdHSrx2EpBWCyFQYNamEawsroSStB2WoYuJkEcR5buYWpqR1g/v+bPQox7KNr3r1dKxKApc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754093766; c=relaxed/simple;
	bh=ZjL6t+ZUQBirgXGjQFRXTNDF/1481sb6+aiNnP+pb6o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JzZB+g5L9aptdcSuiDSWe74K6YpZ/dkHzz10GctuOvIs8ZAtYxR0oyv8iPcTMKtRRzd8Zdsf0tiY3eN3ZIrfbsjYF0yqkguVbBQHyucL4H3VrN0EIRyZ+o3mAnce+qUGTIDg96VSV3x7bB4SJwnAY9xEZNeGVDW+Z+63EsehSMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=uD8mwxkY; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5720FKpF3142596
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 1 Aug 2025 17:15:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5720FKpF3142596
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025072201; t=1754093728;
	bh=3rOaNXsSKK6dIAjfdVXW0TCyQmf9B1Fk/MWfWN8qKxg=;
	h=From:To:Cc:Subject:Date:From;
	b=uD8mwxkYBkFw2mUdtlog4lLDARVr7Wzci2jspt8yO8Ns+MqtnHoX0IBOsnvIqzzYP
	 rkQpqwD2chO9mcwJM6qtFhLiB+ukpdGq96bS2TfeyeNkJHZ7nBC40NwFVknPs7imQ4
	 PQn/rxIVCjcC9FnxiWGlHVCi49B15wiyGRQNrl4zgTkR9gmyZs23xZG0mTlUoqb1a/
	 oz7+cAVqvDTbQwTZ3yKM0EAiczNRrMnUZZsNyVDWYUIwVuMYTOaq0qgyWdLdeIjZw7
	 q2DoZsGi5Ixa0npS4LTms5QorBYRWc+4tEqP5i+EXxFc/PsnXNYo/YoI4AM7N5ZJEV
	 AdsIrSkHEmdtw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, xin@zytor.com, chao.gao@intel.com
Subject: [PATCH v2 0/4] KVM: VMX: Handle the immediate form of MSR instructions
Date: Fri,  1 Aug 2025 17:15:16 -0700
Message-ID: <20250802001520.3142577-1-xin@zytor.com>
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


Link to v1:
https://lore.kernel.org/lkml/20250730174605.1614792-1-xin@zytor.com/


Changes in v2:
*) Added nested MSR bitmap check for the two new MSR-related VM exit
   reasons (Chao).
*) Shortened function names that still convey enough information
   (Chao & Sean).
*) Removed VCPU_EXREG_EDX_EAX as it unnecessarily exposes details of a
   specific flow across KVM (Sean).
*) Implemented a separate userspace completion callback for the
   immediate form RDMSR (Sean).
*) Passed MSR data directly to __kvm_emulate_wrmsr() instead of the
   encoded general-purpose register containing it (Sean).
*) Merged modifications to x86.c and vmx.c within the same patch to
   facilitate easier code review (Sean).
*) Moved fastpath support in a separate patch, i.e., patch 3 (Sean).
*) Cleared the immediate form MSR capability in SVM in patch 4 (Sean).


Xin Li (Intel) (4):
  x86/cpufeatures: Add a CPU feature bit for MSR immediate form
    instructions
  KVM: VMX: Handle the immediate form of MSR instructions
  KVM: VMX: Support the immediate form WRMSRNS in fastpath
  KVM: x86: Advertise support for the immediate form of MSR instructions

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  4 ++
 arch/x86/include/uapi/asm/vmx.h    |  6 +-
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/cpuid.c               |  6 +-
 arch/x86/kvm/reverse_cpuid.h       |  5 ++
 arch/x86/kvm/svm/svm.c             |  8 ++-
 arch/x86/kvm/vmx/nested.c          | 13 ++++-
 arch/x86/kvm/vmx/vmx.c             | 26 ++++++++-
 arch/x86/kvm/vmx/vmx.h             |  5 ++
 arch/x86/kvm/x86.c                 | 92 ++++++++++++++++++++++--------
 arch/x86/kvm/x86.h                 |  3 +-
 12 files changed, 139 insertions(+), 31 deletions(-)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.50.1


