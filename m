Return-Path: <kvm+bounces-37773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B9AA30143
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B159188986E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6163D1D5CD9;
	Tue, 11 Feb 2025 02:01:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A941B5EB5;
	Tue, 11 Feb 2025 02:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239290; cv=none; b=TsWpaX7CEC2pPua9f7LNqILI/O9lO78fS/ahXdNtnl+ZBRDjN1V8WX5g/LBiZ31s9on152seOv1xyPJyY8FaGiwgKRTPPmmNR2EElJNzPZvj2gT5ukBSJYkmgexpsPocrh/1FFKNOBP0RTgFJmQK7r/Jge9d8uvVhMMMouEVqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239290; c=relaxed/simple;
	bh=DrDN0qXwYUeJmVYM4obTyiq2/nWrMHnNJRk3fDdhUdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VrQnIQ5anMZF2t7f8ExprEhu1vSctK5awrgOs7bOIUMrWOSOXWhKkPPKhhf9k6mMOdg9FJFRHIg9iCe+pgCjY20Ne8ksAkZ2I5QxnSTgNFmw3kgyZ+nVNcuyNRyBVudfnjbk4vGS4so/cRTtq87EdJrWFo+6YgVidfJoipmtwDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxOGpvr6pnps5xAA--.1574S3;
	Tue, 11 Feb 2025 10:01:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLsdur6pnLz8LAA--.44545S2;
	Tue, 11 Feb 2025 10:01:18 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] LoongArch: KVM: Some tiny code cleanup
Date: Tue, 11 Feb 2025 10:01:15 +0800
Message-Id: <20250211020118.3275874-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsdur6pnLz8LAA--.44545S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

There is some tiny code cleanup with VM context switch or vCPU context
switch path, and it fixes typo issue about macro usage GCFG register.

---
  v1 .. v2:
    1. Remove comments about LOONGARCH_CSR_GCFG definition in header file.
    2. Add notes why PRMD need be kernel mode when switch to VM.
---
Bibo Mao (3):
  LoongArch: KVM: Fix typo issue about GCFG feature detection
  LoongArch: KVM: Remove duplicated cache attribute setting
  LoongArch: KVM: Set host with kernel mode when switch to VM mode

 arch/loongarch/kvm/main.c   | 4 ++--
 arch/loongarch/kvm/switch.S | 2 +-
 arch/loongarch/kvm/vcpu.c   | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)


base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
-- 
2.39.3


