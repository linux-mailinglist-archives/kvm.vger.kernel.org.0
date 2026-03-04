Return-Path: <kvm+bounces-72662-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eGImJ/Lpp2nelgAAu9opvQ
	(envelope-from <kvm+bounces-72662-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:14:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7191FC565
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 09:14:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9692B31A3E38
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 08:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB22390205;
	Wed,  4 Mar 2026 08:08:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C790390200;
	Wed,  4 Mar 2026 08:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772611702; cv=none; b=UbXNa4hemXPvFPn0DHtU2VET7jsypNJnj8TkJwjFfiwSxRXgteSYp77ua+jIe5GfdEZG/xbYwibrhM7jPDTfcoAMVOF5i+EY20qvDWy1Co1I7kR7VpZ96cfTODuxL8SLzIQIlRKLNISpKgaHYOhbqrlasQGiAd56b/VGtSRsP54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772611702; c=relaxed/simple;
	bh=fFNIrmUOaK8eA6oU+ro+IWJFXch/m0SAE+f5QfRHIYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a/IZKgQfD/ZmQHzDu/j2UjUIHPs7GThuziI8CZpbtZbaIzTnNubqxhT5BGvENuBiyKXG9ghFBbTYxYpPCbjMMkqb2c5JXW7OwpnXJzNA7Vxn9CElOwMFfKzHqMjcQIaH/z3nmcRw3N6QGa5Z0CZIHmSqorSi2/DpeqNFV/M0EB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from fric.. (unknown [210.73.43.101])
	by APP-01 (Coremail) with SMTP id qwCowAAHsm1m6KdpumE5CQ--.5449S2;
	Wed, 04 Mar 2026 16:08:06 +0800 (CST)
From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH] RISC-V: KVM: Fix potential UAF in kvm_riscv_aia_imsic_has_attr()
Date: Wed,  4 Mar 2026 08:08:04 +0000
Message-Id: <20260304080804.2281721-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAHsm1m6KdpumE5CQ--.5449S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar18Cr4ftw4UKryUuFWDXFb_yoW8ZF45pF
	WrCF97CrW3Kw12grZFqwn7Xw4vqayjkw43GrW3Kw4I9rn8tr1IyFyI9rW09rWUJFWqvan2
	9r1UtayruF45Ar7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67
	AK6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjdOz3UU
	UUU==
X-CM-SenderInfo: 50xmxthndljiysv6x2xfdvhtffof0/1tbiBgsQCWmnycp17wAAsD
X-Rspamd-Queue-Id: BB7191FC565
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72662-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[iscas.ac.cn];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[brainfault.org,linux.dev,kernel.org,eecs.berkeley.edu,dabbelt.com,ghiti.fr,iscas.ac.cn,gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xujiakai2025@iscas.ac.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

The KVM_DEV_RISCV_AIA_GRP_APLIC branch of aia_has_attr() was identified
to have a race condition with concurrent KVM_SET_DEVICE_ATTR ioctls,
leading to a use-after-free bug.

Upon analyzing the code, it was discovered that the
KVM_DEV_RISCV_AIA_GRP_IMSIC branch of aia_has_attr() suffers from the same
lack of synchronization. It invokes kvm_riscv_aia_imsic_has_attr() without
holding dev->kvm->lock.

While aia_has_attr() is running, a concurrent aia_set_attr() could call
aia_init() under the dev->kvm->lock. If aia_init() fails, it may trigger
kvm_riscv_vcpu_aia_imsic_cleanup(), which frees imsic_state. Without proper
locking, kvm_riscv_aia_imsic_has_attr() could attempt to access imsic_state
while it is being deallocated.

Although this specific path has not yet been reported by a fuzzer, it
is logically identical to the APLIC issue. Fix this by acquiring the
dev->kvm->lock before calling kvm_riscv_aia_imsic_has_attr(), ensuring
consistency with the locking pattern used for other AIA attribute groups.

Fixes: 5463091a51cf ("RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
 arch/riscv/kvm/aia_device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index fb901947aefe..9a45c85239fe 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -471,7 +471,10 @@ static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		mutex_unlock(&dev->kvm->lock);
 		break;
 	case KVM_DEV_RISCV_AIA_GRP_IMSIC:
-		return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr);
+		mutex_lock(&dev->kvm->lock);
+		r = kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr);
+		mutex_unlock(&dev->kvm->lock);
+		break;
 	}
 
 	return r;
-- 
2.34.1


