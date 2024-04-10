Return-Path: <kvm+bounces-14108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDD2589EF3C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 11:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D9271F21C04
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 09:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FE315749C;
	Wed, 10 Apr 2024 09:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="j1KKqWsG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF8E156C67;
	Wed, 10 Apr 2024 09:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712742775; cv=none; b=YBtAdjsF+Nov/1Q16HS/S3TQLxYMzkM6y+mJwmGOJW1Jf9zC8nJ0bWgLEVmQqBNkzpn44G/XB3El6HCnBdirkh6yRtIZiU5mb0I9K+8WTfJesLYaae3UxFFFBNo5seN3AmaTR9AAei7/2h8scfc19TzXfucuO8PStjby+H/Y7Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712742775; c=relaxed/simple;
	bh=ALOoJxUUYtcFrIKDN0P9vAhj1e860/PKGwkGEawya54=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upn/Ybnk8x4QMmlSyk8bXGQvFl/OHuA0IoOSoHJ9s23YyQKbZ9Ss9qUSXg/RxFBGZL4W+yGVZ8sQBX9AWV9S2cIr/6oosAtIMFHoe1zQS7WmKMtD9m2k12fcS+5W0shOhsmCHiCZYHltzgGbybCKVUrNIlRRUrNV0X2q2v34N1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=j1KKqWsG; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1712742773; x=1744278773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPon1mXI+9ynIGKH9frtzwF2RXP9ZgEapOTvbd3zMzg=;
  b=j1KKqWsGPHdhu+wiQzgdEdyRiu/xEjWD9lU6wI3Nh9vwL8I/zb7IvL4e
   tLc+OKtU/JL4L165vrOJJbP0Tn0ypW4/eoMcsd+lB1UMa1qMWBvcdzD9L
   9fErvf7kobcLz2LlVAmlgjp1kqo8NXLEXEjIyyiGlOmEGA/6mgeul6F0Q
   E=;
X-IronPort-AV: E=Sophos;i="6.07,190,1708387200"; 
   d="scan'208";a="80126940"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 09:52:50 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:58373]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.47.234:2525] with esmtp (Farcaster)
 id 693a12aa-a827-4eff-bc1b-4460d40d8f1c; Wed, 10 Apr 2024 09:52:50 +0000 (UTC)
X-Farcaster-Flow-ID: 693a12aa-a827-4eff-bc1b-4460d40d8f1c
Received: from EX19D033EUC001.ant.amazon.com (10.252.61.132) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:49 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D033EUC001.ant.amazon.com (10.252.61.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Wed, 10 Apr 2024 09:52:49 +0000
Received: from dev-dsk-jalliste-1c-e3349c3e.eu-west-1.amazon.com
 (10.13.244.142) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28 via Frontend Transport; Wed, 10 Apr 2024 09:52:48 +0000
From: Jack Allister <jalliste@amazon.com>
To: <jalliste@amazon.com>
CC: <bp@alien8.de>, <corbet@lwn.net>, <dave.hansen@linux.intel.com>,
	<dwmw2@infradead.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mingo@redhat.com>, <paul@xen.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>
Subject: [PATCH v2 0/2] Add API for accurate KVM/PV clock migration
Date: Wed, 10 Apr 2024 09:52:42 +0000
Message-ID: <20240410095244.77109-1-jalliste@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240408220705.7637-1-jalliste@amazon.com>
References: <20240408220705.7637-1-jalliste@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Guest VMs can be provided with a para-virtualized clock source to
perform timekeeping. A KVM guest can map in a PV clock via the
MSR_KVM_SYSTEM_TIME/MSR_KVM_SYSTEM_TIME_NEW virtualized MSRs.
Where as on a Xen guest this can be provided via the vcpu/shared
info pages.

These PV clocks both use a common structure which is mapped between
host <-> guest to provide the PVTI (paravirtual time information)
for the clock. This reference information is a guest TSC timestamp
and a host system time at a singular point in time.

Upon a live-update of a host or live-migration of an instance the
PVTI may be recalculated by KVM. Using the existing KVM_[GS]ET_CLOCK
functionality the relationship between the TSC and PV clock cannot
be precisely saved and restored by userspace.

This series adds in two patches, one to add in a new interface to
allow a VMM/userspace to perform a correction of the PVTI structure.
Then a second to verify the imprecision after a simulation of a
live-update/migration and then to verify the correction is to within
±1ns.

v1: https://lore.kernel.org/all/20240408220705.7637-1-jalliste@amazon.com/

v2:
- Moved new IOCTLs from vm to vcpu level.
- Adds extra error checks as suggested by Dongli Zhang / David Woodhouse.
- Adds on-demand calculation of PVTI if non currently present in vcpu.
- Adds proper synchronization for PV clock during correction.
- Added option to test without TSC scaling in sefltest.
- Updated commit messages to better explain the situation (thanks David).


Jack Allister (2):
  KVM: x86: Add KVM_[GS]ET_CLOCK_GUEST for accurate KVM clock migration
  KVM: selftests: Add KVM/PV clock selftest to prove timer correction

 Documentation/virt/kvm/api.rst                |  37 ++++
 arch/x86/kvm/x86.c                            | 124 +++++++++++
 include/uapi/linux/kvm.h                      |   3 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/pvclock_test.c       | 192 ++++++++++++++++++
 5 files changed, 357 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pvclock_test.c


base-commit: 8cb4a9a82b21623dbb4b3051dd30d98356cf95bc
-- 
2.40.1


