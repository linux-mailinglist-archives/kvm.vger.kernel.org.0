Return-Path: <kvm+bounces-49386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CAE3BAD838D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F2583B8D4F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464EF25A651;
	Fri, 13 Jun 2025 07:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="P1Q3Uy9B"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4D2248A4;
	Fri, 13 Jun 2025 07:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749798155; cv=none; b=bhoxVGlPdFbXo3XQitFNk2D0lHFwjx98i05uBXxS6ej4LP8xsxTQklswmmwGK8nOOGR/meMqsB4ckcDdugD1WcVryOFSHZGuFZDRQhnnkwx/zhFwDdIraU8LfIrpOlIUvHNWuODVvJDDdKwISCoU0oOeQxHiu2GP7R5FOq+Zdpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749798155; c=relaxed/simple;
	bh=HWrziV4+2qmDxBt322CIIw9OWk0/+AUbOu7JxXsJ6hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DonONW+gwXP09ego2f/6bnvQ5vnlzLei0giEhNZYSXxINyLcGEgFNV2qEsxj7fqJ8ERlxHk/KltifiKiQfe+VCK1bqsJ+PWyoDlUx0h6DcCMn2q5JWUAar6YjvP8pWoZ3a4pauBj4276ndVqyXgz9R9SP9kTOgziTKL7O13SYao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=P1Q3Uy9B; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55D71IfJ3694425
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 13 Jun 2025 00:01:27 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55D71IfJ3694425
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749798087;
	bh=h9iJHFOHOzOA7O5d4YSVzD0dfbtLZJOJH9bYscztX2g=;
	h=From:To:Cc:Subject:Date:From;
	b=P1Q3Uy9BjukCg0FKOFKMiZAHtXtKjaxlRQKOv4SIvLC4NVko50w73b/FmZ6tta7X9
	 4kUb1+MQqhhtAjq7YkrZ7fsq32XOU6hvBg8FaQVN1QIlBiK7J3kW5DoSK47KpTGVYS
	 RFR2jugdcU2mEhXE9I4lZxhvFqa058/NAi9BwxC+BwaEIOvsl3VQPMb85DIuGF3fnz
	 tRSBjAkHez5Et4I4LTpy8mbsSdYEUoJnLRHoJ3Da7P/FGnt4uZqy2viMIjNC1jxxOe
	 ZkpwhcGkeO5DleQPTIAvXasTZLWlhOaxbCmiM32SnHFvLt/ot0jdae4EIkKOI6Wneq
	 pIeM33RHQU5hQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        brgerst@gmail.com, tony.luck@intel.com, fenghuay@nvidia.com
Subject: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
Date: Fri, 13 Jun 2025 00:01:14 -0700
Message-ID: <20250613070118.3694407-1-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sohil reported seeing a split lock warning when running a test that
generates userspace #DB:

  x86/split lock detection: #DB: sigtrap_loop_64/4614 took a bus_lock trap at address: 0x4011ae


We investigated the issue and identified how the false bus lock detected
warning is generated under certain test conditions:

  1) The warning is a false positive.

  2) It is not caused by the test itself.

  3) It occurs even when Bus Lock Detection (BLD) is disabled.

  4) It only happens on the first #DB on a CPU.


And the root cause is, at boot time, Linux zeros DR6.  This leads to
different DR6 values depending on whether the CPU supports BLD:

  1) On CPUs with BLD support, DR6 becomes 0xFFFF07F0 (bit 11, DR6.BLD,
     is cleared).

  2) On CPUs without BLD, DR6 becomes 0xFFFF0FF0.

Since only BLD-induced #DB exceptions clear DR6.BLD and other debug
exceptions leave it unchanged, even if the first #DB is unrelated to
BLD, DR6.BLD is still cleared.  As a result, such a first #DB is
misinterpreted as a BLD #DB, and a false warning is triggerred.


Fix the bug by initializing DR6 by writing its architectural reset
value at boot time.


DR7 suffers from a similar issue.  We apply the same fix.


This patch set is based on tip/x86/urgent branch as of today.


Xin Li (Intel) (3):
  x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
  x86/traps: Initialize DR7 by writing its architectural reset value
  x86/traps: Initialize DR6 by writing its architectural reset value

 arch/x86/coco/sev/core.c             |  1 +
 arch/x86/coco/sev/vc-handle.c        |  1 +
 arch/x86/include/asm/debugreg.h      | 12 +++++-----
 arch/x86/include/asm/sev-internal.h  |  2 --
 arch/x86/include/uapi/asm/debugreg.h |  9 ++++++-
 arch/x86/kernel/cpu/common.c         | 17 ++++++-------
 arch/x86/kernel/hw_breakpoint.c      |  8 +++----
 arch/x86/kernel/kgdb.c               |  4 ++--
 arch/x86/kernel/process_32.c         |  6 ++---
 arch/x86/kernel/process_64.c         |  6 ++---
 arch/x86/kernel/traps.c              | 36 +++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.c            |  2 +-
 arch/x86/kvm/vmx/vmx.c               |  6 ++---
 arch/x86/kvm/x86.c                   |  4 ++--
 14 files changed, 63 insertions(+), 51 deletions(-)


base-commit: 7cd9a11dd0c3d1dd225795ed1b5b53132888e7b5
-- 
2.49.0


