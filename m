Return-Path: <kvm+bounces-66711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 33F83CDEC89
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 16:08:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0347B3009C34
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AB524C676;
	Fri, 26 Dec 2025 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IqAskk4Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E2024886A;
	Fri, 26 Dec 2025 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766761701; cv=none; b=KqPxqNUKUWgnRWlMtklCnx1/Os6bVc6WIaxgYTpGmkNRvZ+b94vs1c60tjnt+Gg/1dz8zLulErXvnAO6wk7ROg1ivnAFp+1tb5WpYZUhdt7lMaLVfEeh2hI0qiYD9TkPHSsS06Sx/Wd8bZmSe4A8CpdlU2HfMmt+gd+SmuNp8JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766761701; c=relaxed/simple;
	bh=uXxLR0MGTqOzFrqXX4Ne6S9wWwXR3kK+OXiCgCprU2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LJ+KYNcvkEwJm6xPPYR9MRkUi5MV3yLXVIrc7poCE/k2M3o7jiFv1z49Ieb03yT+NhTmfLiYcuWEPISrJ8yOZQ6hhhu6c4tSA/qlfMgyzM01HrGVUR2s2DZ5FYQ6z4uN+e/21XYzkC3AFNJFxXDNhfl14sR8Q3fyBc7+5Ar+ZMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IqAskk4Q; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1766761679;
	bh=H/ljW3XaP6vzoo1T1qMzrSYeqbnkzt5TovpDcS9Twv8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=IqAskk4QzdiMC3x+SK9SRDXk+W4HQ0efH3LPpqZ6KMheBhBzrmW3fml+2GWbhrhIC
	 BbMK1R7FkOfTx2W8uXDLK0dyan5zKqGNpUepJ64YhDzkeKIJYzcbgeLZd7PgYUTOZi
	 l6LoqOtho1CyOO9chSLjULiT5bJK5xsGNLxT61js=
X-QQ-mid: zesmtpgz9t1766761674t914098cb
X-QQ-Originating-IP: ENZ2oCc4iZCQyWcVmDUCsDXsw32lUBmpKWAWS3IE+I4=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Dec 2025 23:07:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 752817031373649488
EX-QQ-RecipientCnt: 8
From: Qiang Ma <maqianga@uniontech.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Qiang Ma <maqianga@uniontech.com>
Subject: [PATCH 2/3] LoongArch: KVM: Fix kvm_device leak in kvm_ipi_destroy
Date: Fri, 26 Dec 2025 23:07:05 +0800
Message-Id: <20251226150706.2511127-3-maqianga@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20251226150706.2511127-1-maqianga@uniontech.com>
References: <20251226150706.2511127-1-maqianga@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: Of5NOHXWTvQUWQM6enTE9jKV5SgmBxm109sJQjaTdSUBluvWWEH47CJJ
	wL4aYcfJrYUKRY1RiaS5gL8uWcomG4v2Hzupqt+qnSOR7UB8KTIdX4wpxWSuBt9NV/nXAxP
	H93murCB3N5SuGh+Kh8UaVCYsA4I80VN3nOQvOp2LybM9lUSg3V8+ko7LhFm+bIs+G++hhq
	7KhudpYiWkKY4CcaF/NetrQHXFDAezRXQRx9BYbIubLqyVb8mnwpygClX7cPiXRNSG0aJC4
	65uzg9nh1H5GnYf683ZiW1OTIGDI5yZiWneKXuikCDouY6bk+1NsZnzcD6JwPrZhwUW28o2
	NRqDQTAC1NNCoKlY1UQMs8jpuVnVmkc2+6JYyaEPmu8RT7rN+HYZuHS+GYVcOBFI9Q5UQ5O
	PC+vxxPgkypsJMTR/tWL2m3EThMSnbFaGXSo5MgyRV3XRuWEAOSebV9GyqmiBQ+p6QvK4RJ
	MhgKSX/B20kpAvM50p2CwoZdcgZsUWtD0J9mhOlJ4Hq9Jro9iE8MCp2uS0O7HSdOi4jxTfp
	uPvQlklwZeIovUBs1XSy+OjdgrDUWJnzR4El1DFFKJCt4vYlSD0PjZ34Iy1VCHWiGuQawV5
	pYNDguBsNZyssit83IaUvenJs5MpKhd7xjJMkDARTYcDAnF9jAlZ44zBl0xWY7T5XJkSB9F
	xmWz51S6dvBId1ENh5gK/45/cKwufayK5PZUjvjPLNwnnYaZ8kL/Pg73x+qQkwnFGcjLnL1
	cTSvBtozGCFlXROFSDEyXa2yJ8Li8Djar8wQeDdxXEY5k6WuOkwQPfJhEIZ+NzDhzlvjCIi
	j8BmqdlR4qlSLBUK5hu4jddg58dmURVWGFDI4AekD+GNm0kiv4A6NoQs8S+gYkYohMu+sU5
	TLrKkDODLpWCsAMJgh2pEUtkeTFXH4aozc39R6S9iGOCOuUsRmDBLKoTK1GVxZsDQUSjWxD
	r+J18hA3HwXv9LPC4+jlAYqEp6g+Ul6f/tMVxPvqg6xzYdjGrjOj6MZ+mkhHRgHA0R5QYc6
	X/p+6x6EXTN97s2WXZYWBRmokpYWu1FmiFxzTTEvxcvBZZlcnXPokeCKcnAqcIT76ZdoUqe
	4mJqOylhaLQM76OoQmECn0EnM19KnDgwWFxxK/8oaPa
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_ipi_destroy() is not currently doing this, that
would lead to a memory leak.

So, fix it.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 arch/loongarch/kvm/intc/ipi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
index 05cefd29282e..77169bf49f3f 100644
--- a/arch/loongarch/kvm/intc/ipi.c
+++ b/arch/loongarch/kvm/intc/ipi.c
@@ -459,6 +459,8 @@ static void kvm_ipi_destroy(struct kvm_device *dev)
 	ipi = kvm->arch.ipi;
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &ipi->device);
 	kfree(ipi);
+	/* alloc by kvm_ioctl_create_device, free by .destroy */
+	kfree(dev);
 }
 
 static struct kvm_device_ops kvm_ipi_dev_ops = {
-- 
2.20.1


