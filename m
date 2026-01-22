Return-Path: <kvm+bounces-68882-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKVXM0cPcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68882-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:51:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 20105663DD
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 12:51:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B4A75C9538
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FFE44DB62;
	Thu, 22 Jan 2026 11:14:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABFB392C2E;
	Thu, 22 Jan 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769080489; cv=none; b=ktwc8BI312o19Zdy6dz9wOe3IQbRaaeO+QmU+wpT5nJOh8pQ2KO8Bx19bNhWtOhEMUwXetp1GL+N5rHnQ7uBipsPmdWeLJEEci2JLqy/HK2lFj+lnC5S5dvnQ1u6SntZjx92w/fC/hAkz1zjPfTOGPrKwvmL1JRZPH2vxcdqCkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769080489; c=relaxed/simple;
	bh=yw0kJTMQtMqr3v+Rrkx70e6nlIcqa+DOS9BluHh8uiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jf7gwTQJWxmHoV4LP/dyuO5nJPX6cSCu9Sp6MAL7lqQ20xZLWnsBt1nCsgpkvpBx+qpV/4kJXadsTa8PiB9ymGVxOs51lm1y3DcSAKbsb/263zVU5ccLE1osUN9jC+ZPAUfYv/ms4Aj1XPQVrVBkTJ+WGf36jkDaKFOeG4Lm6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Dx+8KdBnJpzHsLAA--.36936S3;
	Thu, 22 Jan 2026 19:14:37 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowJDxquCbBnJpwR4rAA--.21397S4;
	Thu, 22 Jan 2026 19:14:36 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/3] LoongArch: KVM: Move LASX capability check in LASX exception handler
Date: Thu, 22 Jan 2026 19:14:32 +0800
Message-Id: <20260122111434.1737872-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20260122111434.1737872-1-maobibo@loongson.cn>
References: <20260122111434.1737872-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxquCbBnJpwR4rAA--.21397S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.24 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	TAGGED_FROM(0.00)[bounces-68882-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,loongson.cn:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 20105663DD
X-Rspamd-Action: no action

Like FPU exception handler, check LASX capability in LASX exception
handler rather than function kvm_own_lasx().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 4 +++-
 arch/loongarch/kvm/vcpu.c | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 76eec3f24953..74b427287e96 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -810,8 +810,10 @@ static int kvm_handle_lsx_disabled(struct kvm_vcpu *vcpu, int ecode)
  */
 static int kvm_handle_lasx_disabled(struct kvm_vcpu *vcpu, int ecode)
 {
-	if (kvm_own_lasx(vcpu))
+	if (!kvm_guest_has_lasx(&vcpu->arch))
 		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+	else
+		kvm_own_lasx(vcpu);
 
 	return RESUME_GUEST;
 }
diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index aff295aa6b0b..d91a1160a309 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -1391,9 +1391,6 @@ int kvm_own_lsx(struct kvm_vcpu *vcpu)
 /* Enable LASX and restore context */
 int kvm_own_lasx(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_guest_has_fpu(&vcpu->arch) || !kvm_guest_has_lsx(&vcpu->arch) || !kvm_guest_has_lasx(&vcpu->arch))
-		return -EINVAL;
-
 	preempt_disable();
 
 	kvm_check_fcsr(vcpu, vcpu->arch.fpu.fcsr);
-- 
2.39.3


