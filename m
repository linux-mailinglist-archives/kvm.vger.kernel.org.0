Return-Path: <kvm+bounces-18012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B91078CCAF7
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:11:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E81741C21582
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 03:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11D613B593;
	Thu, 23 May 2024 03:10:34 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F3913A41C;
	Thu, 23 May 2024 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716433834; cv=none; b=eQMNGNSM1pyTiP4YyXOSLjeFu6Mrr97JzP37tj3ksEve2iXgF0hDv5BM2uvyuq4bSl4YREHxseUTRwK1UIt3v7i3URW7vfpb7BjpvWEgfRtJSRXw9D5ZxAoElFUEM+HxBq9wVWzxQrtmeOFd+zwkgisDq6gTpqxHgeueBkUZZRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716433834; c=relaxed/simple;
	bh=rkWd1LiZOCPGNFseKQ4iQdbeUewChv9rFdE/pH6zKqU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aAUGGdTRCnVSk75kvDYMB7gOnCpy+n1NtfPkrLmJ9vBjfk7mLI+cMmpfecbaKxBjLpaMyPuxyZ0L2Oh1t3W2PPrYjGjAL9n2KVkeQQTR8rdbvUHsXBO8OF+B8p04fL+F6Jz5gd4hfwBxiV7FBnd4rjiwh1E7Q7yQzu+CJiKXZA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxEK+fs05mUeQCAA--.2565S3;
	Thu, 23 May 2024 11:10:23 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxNMWfs05mCEQGAA--.6973S2;
	Thu, 23 May 2024 11:10:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] LoongArch: KVM: Add Binary Translation extension support
Date: Thu, 23 May 2024 11:10:19 +0800
Message-Id: <20240523031023.709347-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxNMWfs05mCEQGAA--.6973S2
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

---
v1 ... v2:
  1. With LBT register read or write interface to userpace, replace
device attr method with KVM_GET_ONE_REG method, since lbt register is
vcpu register and can be added in kvm_reg_list in future.
  2. Add vm device attr ctrl marcro KVM_LOONGARCH_VM_FEAT_CTRL, it is
used to get supported LBT feature before vm or vcpu is created.
---

Bibo Mao (4):
  LoongArch: KVM: Add HW Binary Translation extension support
  LoongArch: KVM: Add LBT feature detection with cpucfg
  LoongArch: KVM: Add vm migration support for LBT registers
  LoongArch: KVM: Add VM LBT feature detection support

 arch/loongarch/include/asm/kvm_host.h |   8 ++
 arch/loongarch/include/asm/kvm_vcpu.h |  10 +++
 arch/loongarch/include/uapi/asm/kvm.h |  13 +++
 arch/loongarch/kvm/exit.c             |   9 ++
 arch/loongarch/kvm/vcpu.c             | 121 +++++++++++++++++++++++++-
 arch/loongarch/kvm/vm.c               |  34 +++++++-
 6 files changed, 193 insertions(+), 2 deletions(-)


base-commit: 29c73fc794c83505066ee6db893b2a83ac5fac63
-- 
2.39.3


