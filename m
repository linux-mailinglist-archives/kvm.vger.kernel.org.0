Return-Path: <kvm+bounces-14476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CDA28A2A32
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FF68B272FB
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A6B58207;
	Fri, 12 Apr 2024 08:52:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.linx-info.com (mail.linx-info.com [121.69.130.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B9E53E03;
	Fri, 12 Apr 2024 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.69.130.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911956; cv=none; b=dbP5Vgx5rvFDtRBsy67wt2IU2mE8V0TZ+Bb0++xGsAiVZe5VGzRCJ69RFQ6bkUXXAceEiTcF8Sn1VapeZ9dWD7Ym9vhNLuYAZq8sUxfF9G6FaA27oVvyRjEc47WjKFTHwD+9XOZVkfAhkGtmUNC4iWURBofJvrcTB+cFttXYKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911956; c=relaxed/simple;
	bh=6PmQtfpvoTFi/3cmAtE2o3h2Hn94hmQPmO4RMbgjjko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sjiabDu1aNotvc7X96zdMUn+tS2Lez1AidIv7+VBMB710zlD5v+xI0PA6LCvVYoTI8YxsXqbEhJp7OIfsVVf2EbfEp7ojbnkARTo4A8K7G8Cd0FDfvVgnLtAg3ndbwChfoaNlePItv2VIboFqDOgXjfGyQ3akk4maQi3UxCNtZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com; spf=pass smtp.mailfrom=linx-info.com; arc=none smtp.client-ip=121.69.130.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linx-info.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linx-info.com
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id A93E7320F70;
	Fri, 12 Apr 2024 16:47:07 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at linx-info.com
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id al50rqZR2Ojr; Fri, 12 Apr 2024 16:47:07 +0800 (CST)
Received: from linx.. (unknown [172.16.0.253])
	by mail.linx-info.com (Postfix) with ESMTP id 270B3320D3D;
	Fri, 12 Apr 2024 16:47:07 +0800 (CST)
From: Wujie Duan <wjduan@linx-info.com>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wujie Duan <wjduan@linx-info.com>
Subject: [PATCH] KVM: loongarch: Add vcpu id check before create vcpu
Date: Fri, 12 Apr 2024 16:47:03 +0800
Message-Id: <20240412084703.1407412-1-wjduan@linx-info.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a pre-allocation arch condition to checks that vcpu id should
smaller than max_vcpus

Signed-off-by: Wujie Duan <wjduan@linx-info.com>
---
 arch/loongarch/kvm/vcpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 3a8779065f73..d41cacf39583 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -884,6 +884,9 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 {
+	if (id >= kvm->max_vcpus)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.40.1


