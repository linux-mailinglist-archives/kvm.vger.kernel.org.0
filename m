Return-Path: <kvm+bounces-49679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF46ADC36C
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 412591680A4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCE128F958;
	Tue, 17 Jun 2025 07:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="vi8K0/Rg"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77655288C06;
	Tue, 17 Jun 2025 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750145628; cv=none; b=GO+b0YuqA4MWYU/mPrqsM1Nn8lxrY4AXXplk3zsi9JLODTuePWl7QNALIOR/hkPpy08GiN0rE1Yf2Gg4jEecNehSgoKEgcCbCAD1ojCjKD9XAfwJ+hgZwrz4PJt7z3I1gn33GwreeXPts6S0rZoochFEFUU0LX5tdZy/HJMBWac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750145628; c=relaxed/simple;
	bh=xW1VUV8oxY/+eJvfTBIXObAU4Xts/nmDnxOFIFFOuas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DiJef3kHmY91VJ5BMf5EAwmGQwLdUDFqS4rtjuvIt7O/WHx7adme9JjqGLNiS9ze7VzIR5Bw1S/ek0iANcOqRcbwzKb3g1VoSWtggarIgShiKnRUXAFbfKmGroI8vyvhDNASugw4KJb3DUl2NEsywa/VIs//um/iCJ6CynWDdxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=vi8K0/Rg; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55H7WY8w1020658
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 17 Jun 2025 00:32:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55H7WY8w1020658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750145558;
	bh=b1wnFPUhDY9iKxorOahzeOJ8uRrpy2/oLWDc7uprxlo=;
	h=From:To:Cc:Subject:Date:From;
	b=vi8K0/Rg19FFPpdmvoUdsRjwt4k8IzzdSie1RDC3TZKZYovSE9lPCbtxWwkpfvD7I
	 Ek6QZWWOpqGC3HxtqJU0WBpXg9zS8BSkevz6RJ9B9Amafp5V1HVgY08vgmIfDa6h3s
	 kH1ZKQ7zQ15AH0Tl8ooe46OFX4e6w6ylE5V69IraXRd+3YJdVqT1lIeJgVr80QIWHe
	 TNlnwGfJgfJUtheXc1sYaRTAyLlNAArp1qzSdLcw6vpzYYkB6IBbDxotrdS5j/x1SO
	 gXbBk3lZqW0MVqQHpaUajQxoSyVXwp92IU7v3p1/j13hv+SXYIQAd9aUg+hbPm/BZS
	 5A63bbLDYuHNw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v2 0/2] x86/traps: Fix DR6/DR7 initialization
Date: Tue, 17 Jun 2025 00:32:32 -0700
Message-ID: <20250617073234.1020644-1-xin@zytor.com>
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


DR7 suffers from a similar issue.  We apply the same fix.


This patch set is based on tip/x86/urgent branch as of today.


Changes in v2:
*) Use debug register indexes rather than DR_* macros (PeterZ and Sean).
*) Use DR7_FIXED_1 as the architectural reset value of DR7 (Sean).
*) Move the DR6 fix patch to the first of the patch set to ease backporting.


Xin Li (Intel) (2):
  x86/traps: Initialize DR6 by writing its architectural reset value
  x86/traps: Initialize DR7 by writing its architectural reset value

 arch/x86/include/asm/debugreg.h      | 14 ++++++++----
 arch/x86/include/asm/kvm_host.h      |  2 +-
 arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
 arch/x86/kernel/cpu/common.c         | 17 ++++++--------
 arch/x86/kernel/kgdb.c               |  2 +-
 arch/x86/kernel/process_32.c         |  2 +-
 arch/x86/kernel/process_64.c         |  2 +-
 arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
 arch/x86/kvm/x86.c                   |  4 ++--
 9 files changed, 50 insertions(+), 34 deletions(-)


base-commit: 594902c986e269660302f09df9ec4bf1cf017b77
-- 
2.49.0


