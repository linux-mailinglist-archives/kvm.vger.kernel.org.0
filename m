Return-Path: <kvm+bounces-63846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 01066C74487
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 14:37:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E963832334
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D2633E375;
	Thu, 20 Nov 2025 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwZgB7Cv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018C33AD8A;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763645540; cv=none; b=KHYzDXw0X+BR1PiYKMpTC01QulLUjVEQeEQGdaY4c/3PfbmdDBGkFp5BGmGjCEye9y+4vrB8EutWD+l1r/Z9mrHs7dQF+Mk/Z/TDI4s/I1UhWZe0iskD2gjIskfDa9OheJrP2uH505JxRvyypupA0Qcc5iGoKvhq8DK9HVyn5/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763645540; c=relaxed/simple;
	bh=weqSIwlp3xIIHPIv7fkV+2kNuL/A0SzWqeYwqZ5jLi8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oqtCMZXXQnNSzcg9d+vVQTQ942BNe06TwSvQTqF3s6UxOqFFpEJsNCFpmZBUFf9ZFzXcVw8aJZLtNee9UPvlqG4LDmGxDCE8A31RxtoW/aJw7qddiA5LpnpRhRHzFTISC+WGuOiaoyp8C/W9NKmDObLD+IMnV5OJ0OhQauGZs4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwZgB7Cv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CB0C4CEF1;
	Thu, 20 Nov 2025 13:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763645540;
	bh=weqSIwlp3xIIHPIv7fkV+2kNuL/A0SzWqeYwqZ5jLi8=;
	h=From:To:Cc:Subject:Date:From;
	b=dwZgB7CvdEkFocHnkkkxHfssM84KVXbUrqRzwJB1NVp/V/keQLLD+LHdAgN/KNlz3
	 B0k9IWy4v7v5ERWdMvWaEu2c+lzN5HOTzOeaA+spGcFcO8rb7hN6MJZ6UMH89ovZHo
	 /cLmv51TPJXDLk3nf5RaMYchzMFeIfKTWYLz4iNMOAJKXWSNyyZd3RkKfv4N0nHnHV
	 4DlsnoQJZ80fBTTgYFds4dFcLqcc7V/esF0p+cuwrz4lUQdMY98YFWcH4lfVUhApwX
	 OWRALzFH6j7CraDI7+yPYM7t7QhWSQjn3TquzZJZcWbT1fRU57Rgtx+UpeYdgP0ip4
	 6PC4eDdRAaLZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM4ll-00000006tUG-2khI;
	Thu, 20 Nov 2025 13:32:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/5] KVM: arm64: Add support for FEAT_IDST
Date: Thu, 20 Nov 2025 13:31:57 +0000
Message-ID: <20251120133202.2037803-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_IDST appeared in ARMv8.4, and allows ID registers to be trapped
if they are not implemented. This only concerns 3 registers (GMID_EL1,
CCSIDR2_EL1 and SMIDR_EL1), which are part of features that may not be
exposed to the guest even if present on the host.

For these registers, the HW should report them with EC=0x18, even if
the feature isn't implemented.

Add support for this feature by handling these registers in a specific
way and implementing GMID_EL1 support in the process. A very basic
selftest checks that these registers behave as expected.

Marc Zyngier (5):
  KVM: arm64: Add routing/handling for GMID_EL1
  KVM: arm64: Force trap of GMID_EL1 when the guest doesn't have MTE
  KVM: arm64: Add a generic synchronous exception injection primitive
  KVM: arm64: Report optional ID register traps with a 0x18 syndrome
  KVM: arm64: selftests: Add a test for FEAT_IDST

 arch/arm64/include/asm/kvm_emulate.h          |   1 +
 arch/arm64/kvm/emulate-nested.c               |   8 ++
 arch/arm64/kvm/inject_fault.c                 |  10 +-
 arch/arm64/kvm/sys_regs.c                     |  17 ++-
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/arm64/idreg-idst.c  | 117 ++++++++++++++++++
 6 files changed, 149 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/arm64/idreg-idst.c

-- 
2.47.3


