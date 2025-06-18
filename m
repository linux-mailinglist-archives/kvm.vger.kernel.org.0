Return-Path: <kvm+bounces-49888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF14CADF3BA
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 19:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A79189E292
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 17:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433A92F19BF;
	Wed, 18 Jun 2025 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="WcnvFg8E"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDA32EE981;
	Wed, 18 Jun 2025 17:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750267715; cv=none; b=ge6bZ5c6ROfJEGlN97wQoGNZvupAWsPjCWrvON/1PMmMtWo7GTzO5l8ZjHVtyVQUxoPxnlufFMBdIaDi9mRIKvX8VJm/K5C+sMTwjj9u1vAbgMb1A9Mi/9SIIpw7efvtRD1/OtBQqQRW1NnN4JV0iheTmA23CQCOeuA9bCn7s1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750267715; c=relaxed/simple;
	bh=MRtTDb6zKFq7acUaXRScDjvIeNIyaBRw7I6QThZzBzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B9i7JZ0QCru8+qRmdIgj3wz9OeZ3EL+CRma8gD6nloPCSfSVhC4DtEzzSe/V+EEtC9JOfYKykRO7jzW8hDjZN6WnzEzTegelBMBcUyVL5ZHosOfTvzwmFmBUFIL0N0JcKBvO9+PB5417SYboihYkNprgQvgujcih/qy9BtjoJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=WcnvFg8E; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55IHRNLI1651479
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 18 Jun 2025 10:27:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55IHRNLI1651479
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750267647;
	bh=m63C6JOQ1fUlADYONnZmhuti6E+3IB05tG2sue8SRrU=;
	h=From:To:Cc:Subject:Date:From;
	b=WcnvFg8EaZgck009HwjjfyIazOav6KvoJ+2tkDpyqJU+4kIHtClFIodSEKm3Segrg
	 cyX5qDw6jSTG6aFzUsxGTsEIEB9eku40eX9ZWkOsMrbQgPNrXdbT4f/nm9SHBFWRfw
	 55j9DxurEPHvzwopxRH747SXjx/pzcyBG7n99YGojFup8GlsFlaRD1UTDsY4ZptsN8
	 O0e2uZ7uwS3YjbSd8HVXF6XftnOENksE2pWnHzHHKRPI8usbEB9rPQgNBH/ShdEIUo
	 DT/tjVXGBBPCRFjzLrPrq4Oj9voYuAKOf8glk/vAoIUnAKUO8tnCVPLkNyIQuJLNC9
	 rpuiZgvLLjmXQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v3 0/2] x86/traps: Fix DR6/DR7 initialization
Date: Wed, 18 Jun 2025 10:27:21 -0700
Message-ID: <20250618172723.1651465-1-xin@zytor.com>
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


We investigated the issue and figured out:

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

DR7 suffers from a similar issue, apply the same fix.


This patch set is based on tip/x86/urgent branch as of today.

Link to the previous patch set v2:
https://lore.kernel.org/lkml/20250617073234.1020644-1-xin@zytor.com/

Changes in v3:
*) Polish initialize_debug_regs() (PeterZ).
*) Rewrite the comment for DR6_RESERVED definition (Sohil and Sean).
*) Reword the patch 2's changelog using Sean's description.
*) Explain the definition of DR7_FIXED_1 (Sohil).
*) Collect TB, RB, AB (PeterZ, Sohil and Sean).


Xin Li (Intel) (2):
  x86/traps: Initialize DR6 by writing its architectural reset value
  x86/traps: Initialize DR7 by writing its architectural reset value

 arch/x86/include/asm/debugreg.h      | 19 ++++++++++++----
 arch/x86/include/asm/kvm_host.h      |  2 +-
 arch/x86/include/uapi/asm/debugreg.h | 21 ++++++++++++++++-
 arch/x86/kernel/cpu/common.c         | 24 ++++++++------------
 arch/x86/kernel/kgdb.c               |  2 +-
 arch/x86/kernel/process_32.c         |  2 +-
 arch/x86/kernel/process_64.c         |  2 +-
 arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
 arch/x86/kvm/x86.c                   |  4 ++--
 9 files changed, 72 insertions(+), 38 deletions(-)


base-commit: 2aebf5ee43bf0ed225a09a30cf515d9f2813b759
-- 
2.49.0


