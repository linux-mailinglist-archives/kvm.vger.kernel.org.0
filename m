Return-Path: <kvm+bounces-1857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E391A7ED999
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 03:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DAB5B20C74
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 02:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059DA9447;
	Thu, 16 Nov 2023 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 95C42199;
	Wed, 15 Nov 2023 18:33:05 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8BxHOtff1Vll3A6AA--.45150S3;
	Thu, 16 Nov 2023 10:33:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxnd5df1Vl9p9DAA--.18774S2;
	Thu, 16 Nov 2023 10:33:01 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
Date: Thu, 16 Nov 2023 10:30:33 +0800
Message-Id: <20231116023036.2324371-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxnd5df1Vl9p9DAA--.18774S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7AF4rZryDJry3Gw48Kw4xKrX_yoW8XF47pr
	ZIkrnxXr40kr4Yg3Waqa1DXr97W3yxKFWxJrnxAFy8Ar17AF1YqFW8Kr95XFy3A393AryI
	vryrt3W5ua4UA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI0UMc
	02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAF
	wI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU70PfDUUUU

This patches removes SW timer switch during vcpu block stage. VM uses HW
timer rather than SW PV timer on LoongArch system, it can check pending
HW timer interrupt status directly, rather than switch to SW timer and
check injected SW timer interrupt.

When SW timer is not used in vcpu halt-polling mode, the relative
SW timer handling before entering guest can be removed also. Timer
emulation is simpler than before, SW timer emuation is only used in vcpu
thread context switch.
---
Changes in v4:
  If vcpu is scheduled out since there is no pending event, and timer is
fired during sched-out period. SW hrtimer is used to wake up vcpu thread
in time, rather than inject pending timer irq.

Changes in v3:
  Add kvm_arch_vcpu_runnable checking before kvm_vcpu_halt.

Changes in v2:
  Add halt polling support for idle instruction emulation, using api
kvm_vcpu_halt rather than kvm_vcpu_block in function kvm_emu_idle.

---
Bibo Mao (3):
  LoongArch: KVM: Remove SW timer switch when vcpu is halt polling
  LoongArch: KVM: Allow to access HW timer CSR registers always
  LoongArch: KVM: Remove kvm_acquire_timer before entering guest

 arch/loongarch/include/asm/kvm_vcpu.h |  1 -
 arch/loongarch/kvm/exit.c             | 13 +-----
 arch/loongarch/kvm/main.c             |  1 -
 arch/loongarch/kvm/timer.c            | 62 ++++++++++-----------------
 arch/loongarch/kvm/vcpu.c             | 38 ++++------------
 5 files changed, 32 insertions(+), 83 deletions(-)


base-commit: c42d9eeef8e5ba9292eda36fd8e3c11f35ee065c
-- 
2.39.3


