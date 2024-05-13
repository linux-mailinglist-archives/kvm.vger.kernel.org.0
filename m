Return-Path: <kvm+bounces-17280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA02F8C39CB
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 03:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 914051F212B5
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 01:13:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFF612B7D;
	Mon, 13 May 2024 01:12:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E365A935;
	Mon, 13 May 2024 01:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562767; cv=none; b=Vuwq8g1WxH7ym236Fg4N7d2KX+t+2EMx5mBdbTxCRSrZKUd0wjpwmQ2hxNlIDgLzVeDLi4SAtu/u3EZEWwpdwar6zePrrWxMXn+zfvZpjWrMkCVsWt+cHLSe+zEKZ8lQINPq6eJGnNnkY/7ljixcA6VGAhy57H6BeTMezI3WGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562767; c=relaxed/simple;
	bh=3BUffUtk+rpz0Bi8pK17Oy853PU6iqE64lDci9jr/Hw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aV/nS5EZ9bX/jU/HADFKt4re7Iz8oCtn8D9Be5QIXpqZpy0ZP9xIbSaCradtEnXF9fBznQT8hMurn7bs16x8LWxGeyge31Ch+z5sYC9t1v9zI6TlArm79s3gKs0S2fPPp+zjntwkzSbOlIVvwWb+CTQFo9pafhQfwoLEZLtReBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxR_AEaUFmhP0LAA--.29633S3;
	Mon, 13 May 2024 09:12:36 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax690DaUFmV1gcAA--.51334S2;
	Mon, 13 May 2024 09:12:35 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] LoongArch: KVM: Add Binary Translation extension support
Date: Mon, 13 May 2024 09:12:32 +0800
Message-Id: <20240513011235.3233776-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Ax690DaUFmV1gcAA--.51334S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) is used to accelerate binary
translation, which contains 4 scratch registers (scr0 to scr3), x86/ARM
eflags (eflags) and x87 fpu stack pointer (ftop).

Like FPU extension, here late enabling method is used for LBT. LBT context
is saved/restored on vcpu context switch path.

Also this patch set BT capability detection, and BT register get/set
interface for userspace vmm, so that vm supports migration with BT
extension.

Bibo Mao (3):
  LoongArch: KVM: Add HW Binary Translation extension support
  LoongArch: KVM: Add LBT feature detection with cpucfg
  LoongArch: KVM: Add vm migration support for LBT feature

 arch/loongarch/include/asm/kvm_host.h |   8 ++
 arch/loongarch/include/asm/kvm_vcpu.h |  10 ++
 arch/loongarch/include/uapi/asm/kvm.h |   7 ++
 arch/loongarch/kvm/exit.c             |   9 ++
 arch/loongarch/kvm/vcpu.c             | 168 +++++++++++++++++++++++++-
 5 files changed, 201 insertions(+), 1 deletion(-)

base-commit: f4345f05c0dfc73c617e66f3b809edb8ddd41075
-- 
2.39.3


