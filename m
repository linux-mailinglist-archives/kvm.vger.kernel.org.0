Return-Path: <kvm+bounces-569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E35877E0E69
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 09:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA81BB214FD
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 08:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D76C8C3;
	Sat,  4 Nov 2023 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C9BE5C
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 08:58:04 +0000 (UTC)
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD7561A8;
	Sat,  4 Nov 2023 01:58:00 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxjuuVB0Zl0+E2AA--.39420S3;
	Sat, 04 Nov 2023 16:57:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxbS+UB0ZlmGs5AA--.59322S2;
	Sat, 04 Nov 2023 16:57:56 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/3] LoongArch: KVM: Remove SW timer switch during
Date: Sat,  4 Nov 2023 16:57:52 +0800
Message-Id: <20231104085755.930439-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxbS+UB0ZlmGs5AA--.59322S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7JF1xtr45WFWfAryDCry7CFX_yoWDKrc_WF
	97A3WUGrZ7Wr98tF1qyw15Aa4rZrs7uF1rt3Z7Ar4xGF13trZxur48Xw43ZFy0gay7GFsx
	XrWDtryfZr1jqosvyTuYvTs0mTUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb7AYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_JrI_Jryl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8czVUUUUUU==

This patches removes SW timer switch during vcpu block stage. VM uses HW
timer rather than SW PV timer on LoongArch system, it can check HW timer
pending interrupt status directly, rather than switch to SW timer and
check injected SW timer interrupt.

When SW timer is not used in vcpu block polling status, the relative
SW timer handling before entering guest can be removed also. Timer
emulation is simpler than before, SW timer emuation is only used in vcpu
thread context switch.

Bibo Mao (3):
  LoongArch: KVM: Remove SW timer switch during vcpu block flow
  LoongArch: KVM: Allow to access HW timer CSR registers always
  LoongArch: KVM: Remove kvm_acquire_timer before entering guest

 arch/loongarch/include/asm/kvm_vcpu.h |  1 -
 arch/loongarch/kvm/exit.c             | 11 +-----
 arch/loongarch/kvm/main.c             |  1 -
 arch/loongarch/kvm/timer.c            | 48 ++++++++-------------------
 arch/loongarch/kvm/vcpu.c             | 38 +++++----------------
 5 files changed, 22 insertions(+), 77 deletions(-)


base-commit: 8f6f76a6a29f36d2f3e4510d0bde5046672f6924
-- 
2.39.3


