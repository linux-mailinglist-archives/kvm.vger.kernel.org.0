Return-Path: <kvm+bounces-25836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5866B96B471
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 162CE28864A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32091865FA;
	Wed,  4 Sep 2024 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkeR3001"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D758E14F9FD;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725438280; cv=none; b=o/yDauTIGLJzrQz1lqR/ToFaHW3EJHrLzJeIf58pDhB4i5q2MP1THZY+n85e4RwNyJFDXYTX7Zm3LFKlYY1Y3aM0NpI/2A/wOcpRyIm6E/1NPo1Xh2mkx/Xh/1K+5cbH84i0bvsWnJLRddy3KoiutpLbfIsohRwKonRDblwZ3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725438280; c=relaxed/simple;
	bh=O5vZyMzug2hfi0WUZ+7tWFsjuAc2OLNoqgduTkj7QBA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rbCj7Kn9CxFsmpRPu2e2M4BTEN2Rf55UjAor4n39ro3Z57V+7OBd+G9UzZG8d98hjLuDCpaOaWZ39kJY+hrdNkPkUWUclQjwzpkhO7pUkunq+/I0ict0BByZHg3MuWp4DQH1ynjl+PC7IVBlEcX8h6OBGtXLZNBG4d1TURK+a+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkeR3001; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8828DC4CEC2;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725438280;
	bh=O5vZyMzug2hfi0WUZ+7tWFsjuAc2OLNoqgduTkj7QBA=;
	h=From:To:Cc:Subject:Date:From;
	b=KkeR3001iosJpJ6q/vRE2/Hyhi6bSKxYQCJzYX1VKJmOSvBR12/oi4uKIZDv84AsK
	 vjJRwUdGBRGTxV8AK/lyG78xrexjSUOqkuzsEHl/nJ41rA5bz/VLLVWBQU0h3c3Jih
	 IoSU1kyhwTG05cqMiVInyX4RTYiHWHyYxlQm+HqTq6MpnBa7+qzqeX9BqXT1p8S/Mi
	 TIfiRccEsij6nsBN7kbnHCDAGAbAqh4HU6+xX8DrEcYowY7KLjMKrrP0AEXGtEAdpg
	 e6kac418LNv+T/qhrxVn/9A3KO16MdiwO4ItCZZhY0w9HrGwcYEwqBdEPiassMpYaT
	 nBytBzx6sQ83A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sllJe-009VF3-9L;
	Wed, 04 Sep 2024 09:24:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 0/3] KVM: arm64: Get rid of REG_HIDDEN_USER
Date: Wed,  4 Sep 2024 09:24:16 +0100
Message-Id: <20240904082419.1982402-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

REG_HIDDEN_USER was introduced as a way to deal with the ARMv8.3 flavour of
FEAT_NV, where most EL12 sysreg accesses would trap and yet be mapped to a
EL1 register (KVM doing in SW what FEAT_NV2 does in HW). This handling
imposed that the EL12 register shouldn't be visible to userspace, hence the
special REG_HIDDEN_USER visibility.

Since 4d4f52052ba8 ("KVM: arm64: nv: Drop EL12 register traps that are
redirected to VNCR") and the admission that KVM would never be supporting
the original FEAT_NV, REG_HIDDEN_USER only had a few users, all of which
could either be replaced by a more ad-hoc mechanism, or removed altogether.

This series goes ahead and cleans it up for good, removing a tiny bit of
unnecessary complexity.

Marc Zyngier (3):
  KVM: arm64: Simplify handling of CNTKCTL_EL12
  KVM: arm64: Simplify visibility handling of AArch32 SPSR_*
  KVM: arm64: Get rid of REG_HIDDEN_USER visibility qualifier

 arch/arm64/kvm/sys_regs.c | 52 +++++++++++++++------------------------
 arch/arm64/kvm/sys_regs.h | 14 ++---------
 2 files changed, 22 insertions(+), 44 deletions(-)

-- 
2.39.2


