Return-Path: <kvm+bounces-60983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F006C04B06
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 09:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7809335C20B
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 07:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289972C11EB;
	Fri, 24 Oct 2025 07:20:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D662C2348;
	Fri, 24 Oct 2025 07:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761290414; cv=none; b=HkpjqADLwiG6BH8/RCGrfG8+ShC90P6hh8g/xdvOZbrMeE8KHzEFVKJsTr8WtqITRiAko5yI74nWdzWzyP8DnlCmLjTf8kydVovIS96moQIFQhCAFxl/Ua+Ycsh8yt2Bv0xJTy9fVE/YcZ2aCv5tVjDKcArizWaXxLdo4s3UklU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761290414; c=relaxed/simple;
	bh=7mCbYGEEVFMwYTnGEEULYeaOyefdGFNf3O7Bw3UT1UI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OpD8MTqbDaaD2nBolHcgo/7d84J+m/Rxm4FV0oWge0slpPGMGehEOVLD9EpqOsYqDkEbbvWZUa6A2OYGpLKpx7f1YlZPP56YSamjqysbfg6DHwo/2Zn02NYolZpNvMJXskAN153UeRn9v6tlx2gArQ6zEAaIKaDsALCSeQn6Dq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dxvr+iKPtoyBUaAA--.54707S3;
	Fri, 24 Oct 2025 15:20:02 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJCxocKiKPtojj4GAQ--.47710S2;
	Fri, 24 Oct 2025 15:20:02 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>,
	Song Gao <gaosong@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] LoongArch: KVM: Restore guest PMU if it is enabled
Date: Fri, 24 Oct 2025 15:19:59 +0800
Message-Id: <20251024072001.3164600-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJCxocKiKPtojj4GAQ--.47710S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

On LoongArch system, guest PMU hardware is shared by guest and host
and PMU interrupt is separated. PMU is pass-through to VM, and there is
PMU context switch when exit to host and return to guest.

There is optimiation to check whether PMU is enabled by guest. If not,
it is not necessary to return to guest. However it is enabled, PMU
context for guest need switch on. Now KVM_REQ_PMU notification is set
on vcpu context switch, however it is missing if there is no vcpu context
switch and PMU is used by guest VM.

Also there is code cleanup about PMU checking on vCPU sched-on callback,
since it is already checked on VM exit entry or VM PMU CSR access abort
routine.

Bibo Mao (2):
  LoongArch: KVM: Restore guest PMU if it is enabled
  LoongArch: KVM: Skip PMU checking on vCPU context switch

 arch/loongarch/kvm/vcpu.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


base-commit: 6fab32bb6508abbb8b7b1c5498e44f0c32320ed5
-- 
2.39.3


