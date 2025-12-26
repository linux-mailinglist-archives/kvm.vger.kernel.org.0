Return-Path: <kvm+bounces-66712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D74EACDEC95
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 16:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD2BB30255BA
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:08:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162BE252917;
	Fri, 26 Dec 2025 15:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="KRrne3jc"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1A248891;
	Fri, 26 Dec 2025 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766761715; cv=none; b=gZN8mMEuWgfJR/VqFKwurCszu/Xg5dENzDbXgqZjkV6wja1dIjZB7YIhvXR6bA3da+62AuQKmOTiOgsOIr1dfKwVhwk19uuINvF47ucYtYOzTErAFIcL8NFNG7Qx92GKSVZpGOYt812MH66fJHio88cuxgNP72pBWTSeN6gbG2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766761715; c=relaxed/simple;
	bh=76qE1+cU/nVx7gkBkJGi1456blDzExtWHQs+4qo0GHM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kLdSVMYQcadZThPBcPBDinFUFMUZ7oE1L92/bCShv2QGlcsMcdVtNm3uNQ6fH9OnASJCH7/dkAaqKSHiBtFDlOTGUn8AzU6nR3AeRRpJbu+yTPP/9mcJNnDgxV/NP2XKcQPVLVbJHACWM1oovJJ5+WJDWjbbTkxfTfpxZ+tk5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=KRrne3jc; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1766761685;
	bh=gAA8ercDf/MBI9jGYZi3I+nHltQEY5W8JCzCFw10xbg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=KRrne3jchrI+y1qLUhZnvL/o1IFWPF3NOGzUJOk6tBTij3PGtdLNg+NMnm4+ZTINT
	 aMvGrWSiqLDzUKIKbJO7dw5FVH6eNbJbCsWTUyXNsH0kLxIJLrYd+ph3BikPr3qE9z
	 xbDBDEwY37FyqZAWKgQYyQatifsmnzSQZm6w1tJo=
X-QQ-mid: zesmtpgz9t1766761680td78bb22e
X-QQ-Originating-IP: IAZD2qB3oP1GJHKGhPt5DXJjFbmGIk9+HCgeAASKpdg=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Dec 2025 23:07:56 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9278752954791636414
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
Subject: [PATCH 3/3] LoongArch: KVM: Fix kvm_device leak in kvm_eiointc_destroy
Date: Fri, 26 Dec 2025 23:07:06 +0800
Message-Id: <20251226150706.2511127-4-maqianga@uniontech.com>
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
X-QQ-XMAILINFO: MJGq/3UMnf82C1EgfPv3Cck32TYRKw7Dv4E6iP74ymDimHJiSqWyK7BV
	O4sKxb/yFmRxod6gFjFpNd0vbQAibw1ev/4xeEURCe1UTCmcYNanbeNs6EWRlBF5L+MipDx
	IAy3SJoO7ydocLMeJgaiBk26u43IPDSyLCjk00Jt/LUK8UAYOKky5Ui1Hbv5U6eW0Ip9omN
	TjtZPwzQNziYD7nLB3qRcZAMPxTBvBncDcPCSGD6JqpJoAWWy22iVUMny7bbXRvyNgM6UDl
	Vn5Aldbb3r+OJF3PcBc+mG/3UC73PxxOcaI3d7kilYcuY1LAe+dfjdZe8jGPyk8zBgZUFQd
	Q/xtBtakLa1ftHhfklPMW6QE0R9fOqurt52LsAZuuNs+bvF4oMaXMG7QC8J33ZOhPoY1Fak
	uLRmN3wPS42OjGSWHVOlNqjsn/yMDg8vZ9VUMEZ7YVyICK0FaLWCGu2Vksstsy9nPpNokgq
	b26GPbm3xQe4nNpTNw5AgjvvYqpC/kKglQuPtdUQ8jJB/9QSo8tmtiYQdVAExkh1gfAnUTU
	PhxN/jvY+1R5vNTKR23oxn0/R16vEq57RjcqlrLBvc7h5VSL3xvz/EpUeyLeaA+2o/t0gJa
	/r4KS3Tq7N8/tZGcRJENbcYl3cynBZf4u0CacrMd+eEkcv0fucS8L9Img7dZavx2GqUt3uq
	AUuImNoVAKCNrrwzolKnbF47qVNiK8WHiVwfY+XlwXgz4aHgOYoYrsKzG/OSAZT2C7V5+ay
	+G6HjH9c1Od1PKyfyTvgTlzta9hrcDNDTF5d6LmLVEBl7u3PivClTVo5jHS0yF6EMn7ssgP
	EVsXawAq3PXhgP8WvY1KymbFCSyy3jap1rieSRKefpsKWwjZG608gbItiO58vVCpvQ1H+2O
	MGtyfT/vhNTEsSmp6Ph3JBieZhtDRnztcuoE4stqsExeKzvlQR8Sz/kXPJOFxPP1po/iVMO
	9J1FqanpnbDQXaQkMBsAb2fb1voAZbBV2o1uY0p2eoffVqaknNrTPRkSv786o3hIdC8O3XC
	n6T+v2h7Ymn76wQovn/Z6Mxj5GoALftN5hVSiJVAMafhcjOTXEqDXHJVJA6cmIWQMDKdnYk
	9Ak7KKmeDrY
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_eiointc_destroy() is not currently doing this,
that would lead to a memory leak.

So, fix it.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 arch/loongarch/kvm/intc/eiointc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index 29886876143f..cb94c7e8267a 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -679,6 +679,8 @@ static void kvm_eiointc_destroy(struct kvm_device *dev)
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
 	kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
 	kfree(eiointc);
+	/* alloc by kvm_ioctl_create_device, free by .destroy */
+	kfree(dev);
 }
 
 static struct kvm_device_ops kvm_eiointc_dev_ops = {
-- 
2.20.1


