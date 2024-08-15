Return-Path: <kvm+bounces-24230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAEE9529B4
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CA2EEB215F7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA2817BB25;
	Thu, 15 Aug 2024 07:15:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A054217AE03;
	Thu, 15 Aug 2024 07:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723706151; cv=none; b=qvwsfL6Z0hMqtAu4gYyT3iJyMKGTvL3eMi6OJM753ob0jkL+5NOS2N/oS7dlwpdt27ofVOwVJ6dJD/y7qbIXTW4bWTaDLZDtX/WyKJPycGtjcjh11ugzOQPanA1BWvinZ2m8/9LsCdzBXX18RcpVpm85bg2YfpyFjSOfrbEBFSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723706151; c=relaxed/simple;
	bh=gru72qHo5RPi/X5tMdVztqIy6DA/pkzm8Yz30xMif7A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jbkt5AMQJsZngfs5OtRMf+qDWByst/2mNWPZSaCTYPtSgb68B8ymweN1zsiVxEGJ3Kny3Yy3kAATuPpVqlLRv+7y1W31o8fJjfTMnTWopRYLf2dkKDWlgJiYY72VmbSg2ER9XZ/nCcMjdyE9gOAJ7UmRPxrNGiMPkaYKR4ANR6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx25ohq71mnIsUAA--.11889S3;
	Thu, 15 Aug 2024 15:15:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxG2chq71mlesUAA--.1465S2;
	Thu, 15 Aug 2024 15:15:45 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] LoongArch: KVM: Fix some VM reboot issues
Date: Thu, 15 Aug 2024 15:15:43 +0800
Message-Id: <20240815071545.925867-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxG2chq71mlesUAA--.1465S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Sometimes VM fails to reboot with the reboot stress test, one problem
is that there is IPI interrupt during AP vCPU reboot stage, the other
problem is that steal time gpa address needs be invalidated from host
when VMM forcely reboots VM.

After this patchset, VM passes to reboot at 2000 times with reboot
test case.

---
v1 ... v2:
 1. Add patch invalidate steal time gpa address in the patchset.
---
Bibo Mao (2):
  LoongArch: Fix AP booting issue in VM mode
  LoongArch: KVM: Invalid guest steal time address on vCPU reset

 arch/loongarch/include/asm/kvm_vcpu.h |  1 -
 arch/loongarch/kernel/paravirt.c      | 19 +++++++++++++++++++
 arch/loongarch/kvm/timer.c            |  7 -------
 arch/loongarch/kvm/vcpu.c             |  2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)


base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.39.3


