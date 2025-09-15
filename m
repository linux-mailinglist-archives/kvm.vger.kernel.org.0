Return-Path: <kvm+bounces-57558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3426B578D5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E075544381E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3FF3019D2;
	Mon, 15 Sep 2025 11:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViKDYxt9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953D63002B0;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936698; cv=none; b=gCDKkx71aqOX5AfBsKAZJylR9+q7H6DjHXVoARnjNA6kuq1F2eO/JKKLLCJL7P7MrqmosajU9z/oJH37mVjAylZM1XSap86DI8MoODUnhQo8FMFbncJ+BvdBOeHortjj9vwAg6xygKwSM3AFLnj8roBL+voB0pKJrFdfb9NtCRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936698; c=relaxed/simple;
	bh=RIeEnuw/2CAAw6lbd+FSBlwmDg9JXCUTkPlzLWpDftg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQHBHAOCeNlWQib+AQbMlIc0bPdpDGQD7XZtKlhEZHl3XIFIZzwnx1eNIXlk19rrrcW7Gssv6Ikp0E+9XnlLkA1opUH2JMu/vZjrcPEIHoj4DAJZsOegjU75qrOZGXx4ZDtP61ngqog1QE3zH+T/h8nCcrACZqV8qeeFe2mmSD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViKDYxt9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C81C4CEF5;
	Mon, 15 Sep 2025 11:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757936698;
	bh=RIeEnuw/2CAAw6lbd+FSBlwmDg9JXCUTkPlzLWpDftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ViKDYxt9KbtK0QeJblxeHTOBI2Awxv5lcWeduiYv1Xs7f6n7rO9pQP5TqI8K4dn8l
	 qoqm67gJJ9vlU3tvVt9VvAIQPQqo89Sx9p0fC8klW3jywY75jIV7AicfgHJjp5gXdg
	 XlCp8ayIlpEh8Vozsp6QVY2j7o+iKixF017x4K470zAKBCNbrwAIxaFiqxrqaC96PZ
	 6ClwFEI+A4A4yewNvdrER+mRcVW7wVzR3E6ABrZpk4w/CJFxeLhqGTvpwp0O+2cW8f
	 Qd9sgByVW5ZXP5r4NK4uTPyISnVWtsmaatVsKrYONVPc2Lj24UBVI9OlHmoBEsGbMk
	 8JOAoVGMwAg2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1uy7dg-00000006MDw-23kS;
	Mon, 15 Sep 2025 11:44:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 08/16] KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
Date: Mon, 15 Sep 2025 12:44:43 +0100
Message-Id: <20250915114451.660351-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250915114451.660351-1-maz@kernel.org>
References: <20250915114451.660351-1-maz@kernel.org>
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

With 52bit PAs, block mappings can exist at different levels (such
as level 0 for 4kB pages, or level 1 for 16kB and 64kB pages).

Account for this in walk_s1().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 1c2f7719b6cbb..fad9d7828d7b6 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -448,11 +448,11 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 
 		switch (BIT(wi->pgshift)) {
 		case SZ_4K:
-			valid_block = level == 1 || level == 2;
+			valid_block = level == 1 || level == 2 || (wi->pa52bit && level == 0);
 			break;
 		case SZ_16K:
 		case SZ_64K:
-			valid_block = level == 2;
+			valid_block = level == 2 || (wi->pa52bit && level == 1);
 			break;
 		}
 
-- 
2.39.2


