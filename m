Return-Path: <kvm+bounces-25328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B232D963B32
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 08:21:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70551285D96
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 06:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7222114F130;
	Thu, 29 Aug 2024 06:20:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559B84437F;
	Thu, 29 Aug 2024 06:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724912456; cv=none; b=iDGXuAa/sbJOqN1ZsoDUOhIJAuU97y0c26EEJCYneZmiCUg3qltNS7heiaoVSX5cuooyk3D/EyqdYSpqSpjD/qhRfseejI3a20+1kEnkdn6kJSCvrLtEv1vBqr+gwv2jp7REwqLMjJLTmC3q0BdN1dhn4XeUhaEXTgjAR/Gz+G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724912456; c=relaxed/simple;
	bh=7CM/slmh1e18CB/PTxjcY6wOKEXLQ/yhroZ0wA1ALq0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o7I6BaZzBe/ZalZJTPlPNBK5XDuO7aw4bAvxHHbAKFSoehjaRcjwAZHmtgtEbwmgu+NHxh2/tNntSyO+dwHBKqzHYLWTRZJTMQPRhhPkB1xxcojN3D96hwYnMhKmYgPO2nflSyRSaRjPFq59E3LoyY2H8OTakGy7Y5JmVHAV5CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ThinkPad-T480s.. (unknown [121.237.92.13])
	by APP-03 (Coremail) with SMTP id rQCowABnbPg4E9BmDw5FCw--.54084S2;
	Thu, 29 Aug 2024 14:20:40 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH] RISC-V: KVM: Redirect instruction access fault trap to guest
Date: Thu, 29 Aug 2024 14:20:40 +0800
Message-Id: <83c2234d582b7e823ce9ac9b73a6bbcf63971a29.1724911120.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABnbPg4E9BmDw5FCw--.54084S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKw48AF1DKFykuF45uFyDJrb_yoWDCwb_Ca
	yxJFZ5WrW8ZwnayFsxGa1fuFs8tayvya4rGr98ur15G3Wq9rWxG3sagr1DZr48G3yYgFs3
	CF4DZwsxA34DJjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUby8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
	zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Cr0_Gr1UMc
	vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r
	43MxkIecxEwVAFwVW8AwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC2
	0s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI
	0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv2
	0xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2js
	IE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZF
	pf9x0JUfDGrUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAgEBmbPw933fQAAs7

From: Quan Zhou <zhouquan@iscas.ac.cn>

The M-mode redirects an unhandled instruction access
fault trap back to S-mode when not delegating it to
VS-mode(hedeleg). However, KVM running in HS-mode
terminates the VS-mode software when back from M-mode.

The KVM should redirect the trap back to VS-mode, and
let VS-mode trap handler decide the next step.

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 arch/riscv/kvm/vcpu_exit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index fa98e5c024b2..696b62850d0b 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -182,6 +182,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
+	case EXC_INST_ACCESS:
 	case EXC_INST_ILLEGAL:
 	case EXC_LOAD_MISALIGNED:
 	case EXC_STORE_MISALIGNED:

base-commit: 7c626ce4bae1ac14f60076d00eafe71af30450ba
-- 
2.34.1


