Return-Path: <kvm+bounces-59000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33A8DBA9F28
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 070C63A8382
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F285030C0EB;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SKZPE8da"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C02E30CB40;
	Mon, 29 Sep 2025 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161906; cv=none; b=BLrNYiaEMkaOwGf2wcniBUNyoVnRuczm3f3afY3RwVlo6G28xrx4orpKNs86hX2V6a5WJLNX9BlvGZ4Oxjr7iHs0uwa9+ETGI/NMQOSxqlNHgmVY4u9CffNaGz7GNTkM5wrxvoE7yyOnkeL76f06DxRTvk+GkNmUmtU2MLHUU2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161906; c=relaxed/simple;
	bh=ekwDuQm/LViV5dWIz28P721OuKbhpFowpx6Jkl0Irms=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fcT8K7wKUJjLLRDpJauDKuPA3YL1Mu2SLzFiaYoleMZ4O8uqJnIGxPefJVeCv0ox8QMjpK4S6lRQnlSlheml1CwWYB4lc1iaM/WNMQbAVRazvIL7wdAHh5xt5CPbMZq+JENRppGEHZiFpRoZQGET5tQpYnz+O+HTrfWq1SgXFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SKZPE8da; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76BDC113D0;
	Mon, 29 Sep 2025 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161905;
	bh=ekwDuQm/LViV5dWIz28P721OuKbhpFowpx6Jkl0Irms=;
	h=From:To:Cc:Subject:Date:From;
	b=SKZPE8daQEViOlp2HYgoJhPIXdAGzG2SqZl/c0EV8UnHPLICvQzvHyxLogMv1M1h5
	 jY5z9NIIEWX0B5YXuFeGU+5xIpXUbNjmmidC6zJpm5ocEd9Yh3C+JH8EE4lEHDKqnJ
	 HP6wftqushbfhF4DhDsY2DgkRnZSnsPwXVc6mik1rAxNUJSMhQEHzu5EB26E0kNYCt
	 /DkVxxyvxErXR9KSNb1gLI2U/xD0ASscl8qHxVi+8V0HmN8XUJ4s7B3hILNveRnNgq
	 HT6slkrogWplR4QWwt9ksj0dEjcZkIHdnEr8gzvK8tFqMdDxNMdXNFoTXekdGbo/vo
	 dAmGqQooW+87g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN5-0000000AHqo-0cJ2;
	Mon, 29 Sep 2025 16:05:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 00/13] KVM: arm64: De-specialise the timer UAPI
Date: Mon, 29 Sep 2025 17:04:44 +0100
Message-ID: <20250929160458.3351788-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since the beginning of the KVM/arm64 port, the timer registers were
handled out of the normal sysreg flow when it came to userspace
access, leading to extra complexity and a bit of code duplication.

When NV was introduced, the decision was made early to handle the new
timer registers as part of the generic infrastructure. However, the
EL0 timers were left behind until someone could be bothered to
entangle that mess.

Said mess is more complicated than it looks, due to a nasty bug
documented in 290a6bb06de9e ("arm64: KVM: Add UAPI notes for swapped
registers"), where it was realised that CNTV_CVAL_EL0 and CNTVCT_EL0
have had their encoding swapped at the user interface level. Handling
of this issue is spread all over the place instead of being contained
in a single location, and it needs to be contained.

Finally, it was noticed that we expose the CNTHV_*_EL2 registers to
userspace for nVHE guest, while the architecture is clear that they do
not exist in that configuration.

This series aims at fixing all of the above, moving the handling of
the timer sysregs to sys_regs.c, fix a corner case with WFxT, handle
the nVHE issue described above, and finally improve the testing by
introducing an E2H==0 configuration.

If excluding the selftests, this is a net deletion of code. What's not
to like?

Marc Zyngier (13):
  KVM: arm64: Hide CNTHV_*_EL2 from userspace for nVHE guests
  KVM: arm64: Introduce timer_context_to_vcpu() helper
  KVM: arm64: Replace timer context vcpu pointer with timer_id
  KVM: arm64: Make timer_set_offset() generally accessible
  KVM: arm64: Add timer UAPI workaround to sysreg infrastructure
  KVM: arm64: Move CNT*_CTL_EL0 userspace accessors to generic
    infrastructure
  KVM: arm64: Move CNT*_CVAL_EL0 userspace accessors to generic
    infrastructure
  KVM: arm64: Move CNT*CT_EL0 userspace accessors to generic
    infrastructure
  KVM: arm64: Fix WFxT handling of nested virt
  KVM: arm64: Kill leftovers of ad-hoc timer userspace access
  KVM: arm64: selftests: Make dependencies on VHE-specific registers
    explicit
  KVM: arm64: selftests: Add an E2H=0-specific configuration to
    get_reg_list
  KVM: arm64: selftest: Fix misleading comment about virtual timer
    encoding

 arch/arm64/kvm/arch_timer.c                   | 105 ++-------------
 arch/arm64/kvm/guest.c                        |  70 ----------
 arch/arm64/kvm/handle_exit.c                  |   7 +-
 arch/arm64/kvm/sys_regs.c                     | 123 +++++++++++++++---
 arch/arm64/kvm/sys_regs.h                     |   6 +
 include/kvm/arm_arch_timer.h                  |  24 ++--
 .../selftests/kvm/arm64/get-reg-list.c        |  99 +++++++++++++-
 7 files changed, 240 insertions(+), 194 deletions(-)

-- 
2.47.3


