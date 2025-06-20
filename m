Return-Path: <kvm+bounces-50201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F49AAE25F4
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 907333B801E
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D0B324291B;
	Fri, 20 Jun 2025 23:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JCSS81Cr"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39730E840;
	Fri, 20 Jun 2025 23:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461342; cv=none; b=mnKjMrtIPFPF6aMY0B7yhiSy6Fqi7LXUOjb2T7ABMLTsU5WBkTM6PmPRd9fg8h8+Mk0XVgTUulNUeT6wC17ySOTGpI5ItTp5wwSCaDCADyQEbyazM57eGANDbdSSU3ZHxQ27J8HoUh1vGfoC8Q5T9MESK5rfW/tAYod7VX6PEHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461342; c=relaxed/simple;
	bh=/Xa1lMxEWzyw7WKi7Rkr130RGrCzVUp1evWZIVWS+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=srF5RtgY6B2o7/NQs84IM5otzcmGrInsBySe1tVmFgZ3eiT8DNH1pBpTCJ7fb6GUJOxEmPsaEr7LW29d8ltRiFvCpgauZZ0h8L5HIDj7MgYJMyIeoevpy0nM6Iko/l9fvPGhLgnKUzW1//z2PO2AgNknTKWgFzX3TE9VxZqaInI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JCSS81Cr; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55KNF5V62676916
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 20 Jun 2025 16:15:08 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55KNF5V62676916
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750461309;
	bh=Px5CO72QPBisPG/bUS/X8TULOpQ2XC4+cNEsOXocc2M=;
	h=From:To:Cc:Subject:Date:From;
	b=JCSS81Crk/RLt64Zyil4AzR+m/sKxyGUqljLTFjiMnrTlvP2gZ8sVKkIoprwEBHAJ
	 7SDcoGCpjdLWHGHrNO1xZPX/ilcPuStaiDUUhpSc8tNkwi5CMjBWYGrRCWcQiGvXWU
	 GRMR83ZAlw/Qx4O2z/Z4Z81FzkbUiM5Z5jFf8vOtwek/WTsi6eUy+caAp9nS1po3Ly
	 ZVA1SQC0bzJvSrwH5dfIiZpBBa2F15YZ5rqYxtb/eH5WBJlsWF9a77akzcUdTRpM+S
	 ptS9F8sOeEt7eUzctrieFh2GGUGmyotmj/8PTFAA9BpwHn6+jrzxOqgbRoqqW1wRId
	 PG9SFgs9n4ALg==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v4 0/2] Fix DR6/DR7 initialization
Date: Fri, 20 Jun 2025 16:15:02 -0700
Message-ID: <20250620231504.2676902-1-xin@zytor.com>
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

Link to the previous patch set v3:
https://lore.kernel.org/all/20250618172723.1651465-1-xin@zytor.com/


Change in v4:
*) Cc stable in the DR7 initialization patch for backporting, just in
   case bit 10 of DR7 has become unreserved on new hardware, even
   though clearing it doesn't currently cause any real issues (Dave
   Hansen).


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


