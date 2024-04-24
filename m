Return-Path: <kvm+bounces-15851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E202E8B114D
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 19:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96CD11F28382
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C9216D4E8;
	Wed, 24 Apr 2024 17:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZWEZ6M52"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C088913777A
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713980413; cv=none; b=BrE/Mn+pjqwLJrS6EIj3gzP0jlDNakeoa0TppORHfpj3X+x2AIBu+hFRI/ligXg2+C9JgcDdczR480/Rjsb+rJwv/54CNqYXbpqGIqhhV4/1AxH98WkGiU+mNZT8Nuc6spyDlDdebiYTuRqFwtlvYSH4Py8DqgDkpRIzurzEqrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713980413; c=relaxed/simple;
	bh=9cjGIBWDtm293I1mBUzGX8gnpk+3cVyprZL/pD5e56M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qNEBQauQ6jeizfJLN6rkU87kabPqigP58qHSIJQTVA0JBywo3+r/+W+43ubNpQrs1WVe5HhSsvpcSE87IFOMjuOwVgX6NCx75Fa1XWkOmS11w2wpvj1Gega2t+fa69zvUdPOd1DltYVVKE0S5TxRx7bceC+m0V8FKBkFoRE6tpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZWEZ6M52; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713980409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ODFn/kVBzjTb2vYSbkWdi27ylHj8BGS28Jm50+JvVcA=;
	b=ZWEZ6M5270ub3EKUHnXXcVXQAq6mzhWeuca/QguRFnyae+P5I8bocDBXvbMfnqdNLILHe0
	sng22/MMsrl/+cdn1MKoYgW76/r3TmIegCmrq4jlexdxfyxcVEoboE9dFVSA+80hPYbY4L
	xSJAOr8dYQ7mxjycE7TOYmnWt9R8lrg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: Avoid NULL dereference in vgic-v2 device attr accessors
Date: Wed, 24 Apr 2024 17:39:57 +0000
Message-ID: <20240424173959.3776798-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Alex reports that it is possible to trigger a NULL dereference via the
vgic-v2 device attribute accessors, stemming from a lack of sanitization
of user input...

Here's a fix + regression test for the bug. Obviously, I intend to take
these as a fix ASAP.

Oliver Upton (2):
  KVM: arm64: vgic-v2: Check for non-NULL vCPU in vgic_v2_parse_attr()
  KVM: selftests: Add test for uaccesses to non-existent vgic-v2 CPUIF

 arch/arm64/kvm/vgic/vgic-kvm-device.c         |  8 +--
 .../testing/selftests/kvm/aarch64/vgic_init.c | 49 +++++++++++++++++++
 2 files changed, 53 insertions(+), 4 deletions(-)


base-commit: fec50db7033ea478773b159e0e2efb135270e3b7
-- 
2.44.0.769.g3c40516874-goog


