Return-Path: <kvm+bounces-66710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A083CDEC83
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 16:08:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A80363001809
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8521E25486D;
	Fri, 26 Dec 2025 15:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="ZrccXZ2w"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF5B23E340;
	Fri, 26 Dec 2025 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766761699; cv=none; b=L5GVKoR8e6ksv/SKaFqdkKw0vvqxODhodz4n76Ae3lQeNl/qwdfWMWgk9Jd3R6qXlJcSG4RfWwKVSPVTxX7fUIvVjJBCXKv/XqwMeiqrZ82V3QkbSaOIsarjTG/aUSS/EU2GassfbQigzbv9F6iyQkh1BRHLHLU0NCR0fR18xOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766761699; c=relaxed/simple;
	bh=axBdI3hV0EsBEmOe7IOaWPjXqQcIWJCnYybfDeyo0Fs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MfbJ3NLBoFwZKeT8ujEES8TQNjIR/yVoPspV4I3e4XkkyR5+Say+S6PR0WyZUu5Kl/hFRkna5PDypQaHKDDMG86gwo49efhtuUYKsGp48GTpgCdKBNiOs8I4qTDaEjH8F2rBdSTDNqGp3Yv8l6hwEJH62bpFg6uCsZnvzT5WoMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=ZrccXZ2w; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1766761670;
	bh=qpQeelTX+gHQhxFeFXv34+633IgLQz0cCNxLRHPWVcU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=ZrccXZ2wNA71+3xl1vnNJmlNM7zXYet22n53PSG4EnE6saZrLtFbhNSxY3242yvn0
	 yIo7GN+Gd5sFQ0PcsyQQxQJqwlkd/N54xkTb8LKL7Nt1ORoh47554XT14S2Dvb1KV9
	 RKfVAMbENnbbHarnVECJx+ZhB7sNJzOZRY68KfH8=
X-QQ-mid: zesmtpgz9t1766761665ted0b83c5
X-QQ-Originating-IP: FriV2fS68Zg1b0gJxF28wBf4NylR5xKo9MPbNTuD/yU=
Received: from localhost.localdomain ( [123.114.60.34])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Dec 2025 23:07:28 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17417006942467808155
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
Subject: [PATCH 1/3] LoongArch: KVM: Fix kvm_device leak in kvm_pch_pic_destroy
Date: Fri, 26 Dec 2025 23:07:04 +0800
Message-Id: <20251226150706.2511127-2-maqianga@uniontech.com>
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
X-QQ-XMAILINFO: ODc4ukgihQJXx4Tr0vCNUVCxZg/cBK5oA2Wg7Y5dXTrNAQ8eVdbnDRX6
	ZC3QT3BEMdueIT8mp5aLM17rTwIc3PDFRAwvi5GQKHeoJ0pZo7bFW8wBEBNen7YD9m/BOaT
	caUH4nyhf3HGDJj+mJzJcvGmmbSvj/zg19q/pBVOLGpTF1jdG9vZh9Zcg+S3asm7Iy6W2A9
	S3MkVq1wBhuj92lVEuWSeBcPqjWls779ktT6Jt2NOr7lSkatKCuMua6ar0OQekcwTyMS0cn
	Kep5LvG1/TP/eXvFRyy2oRCqmqkpp5uDuaqK8br7vewYFn/EHerQocTFlX2tmVA5jaTxVEn
	rKQrxJeFp0Fselkc5t4eF+Z9xzU90yNYxt1x90nyvIR3wvmhZnPFXhwDf4FlqsXuDm7tdV4
	n2XfLAwwLcwRooQ6RNcuKs7a4Zfj5a5E306+Nvrj1G3kWNWb4cLyQIYrm+0SIkmQurZwbGp
	kutL2H2X5E031JEgSd5HwBMS/4CN8wRS6m8Gs4hgkM/4X6qsDgnNEPMJXOR3M0Tyasn8MK9
	yFpRedXz8Ozm3EtLPQ4k8s7smmYoA/VfLCPkZYQTFLjzQziK5IWQu7pyOzRhioUamqdzoii
	b2THo/ZGSKKd3Y6CSeea/aqvliuQv7kiqK273UfnitkJtOB4BW0EXI0czdfkd0dDtZ0NDmF
	unYKL7LULC8/efrF9jlUtHj4zQ1XxjKcVMgkVio4cr/V6UBjx2ND+52KihwWAckF1sdxUVh
	gGVnyd6oo4+wHcgPNhLSuPFAYZv7B9T+apcvwOqfvwSWCHDRb7AzEjZPJvp5jWPmm3PdbKR
	6YRt/j+w7vkrjHUlroGGgFngJee4wRfwIxeds9MQBMC5F/HrW4IsPbjbNCLtIw3GbeVchML
	iKe5bnayPlYUIUVrcqvDwGIgt3Rhe6h2LsCW7g1VXmQdthyiYeQMNv817JhrBhH1pK7Q4nr
	A5Jg7oRajQq9T2nEFEJSjLeEkIiVEeQ0L043Kblmn4QxitPbyU5qwvKvgqTxvU7WFV09VPd
	IG6BmnCXGWCCtSvgoE8eyGNbXMPsWUz+NYdRjRXkvZqmB0jdN5smdadym7zws=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_pch_pic_destroy() is not currently doing this,
that would lead to a memory leak.

So, fix it.

Signed-off-by: Qiang Ma <maqianga@uniontech.com>
---
 arch/loongarch/kvm/intc/pch_pic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kvm/intc/pch_pic.c b/arch/loongarch/kvm/intc/pch_pic.c
index a698a73de399..f710c904b40c 100644
--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -475,6 +475,8 @@ static void kvm_pch_pic_destroy(struct kvm_device *dev)
 	/* unregister pch pic device and free it's memory */
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &s->device);
 	kfree(s);
+	/* alloc by kvm_ioctl_create_device, free by .destroy */
+	kfree(dev);
 }
 
 static struct kvm_device_ops kvm_pch_pic_dev_ops = {
-- 
2.20.1


