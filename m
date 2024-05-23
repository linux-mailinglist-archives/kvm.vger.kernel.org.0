Return-Path: <kvm+bounces-18014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4855C8CCAFC
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 05:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77D181C215E3
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 03:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D07C13B791;
	Thu, 23 May 2024 03:10:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8155D13A879;
	Thu, 23 May 2024 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716433834; cv=none; b=qaMggitN20Gy4m0qYB+vXk4CvlwCF8LV1c25xEZ4PTXDFCdnUaQxzz2ALwAKHAOH4YiS930DwtXaz3he2G9fQrCHYtb1AsvwQvmWV+RlxTJgA2HfUJ+5ZnqcQzQZtAPm350k8N2KGGsOu7ECN5sjzsftv1m9Ok4rOCvughVzENE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716433834; c=relaxed/simple;
	bh=EBDVXOmgMgfl8zYiYQw+LxzSeEjy1MIY+uBc1KG6b70=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NA9BwWeXQRZMBAFKAXI/NrjDZaIqq7ZyRqLNIFrrFv+kvfzQfGu9LPoH2hJb6i+0Ig1ES7uicBlpz2fvX7ZeBVsm7e2R1PrnIA4VxDfiFI/+T7U9D+QWQck05q0KdOkI1jaczmqQUnfLc67XikwvvpHMYsU/XJpg54c/LaL/+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxOOqgs05mWeQCAA--.2761S3;
	Thu, 23 May 2024 11:10:24 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxNMWfs05mCEQGAA--.6973S4;
	Thu, 23 May 2024 11:10:23 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] LoongArch: KVM: Add LBT feature detection with cpucfg
Date: Thu, 23 May 2024 11:10:21 +0800
Message-Id: <20240523031023.709347-3-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240523031023.709347-1-maobibo@loongson.cn>
References: <20240523031023.709347-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxNMWfs05mCEQGAA--.6973S4
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Loongson Binary Translation (LBT) feature is defined in register
cpucfg2. Here LBT capability detection for VM is added.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 8f80d1a2dcbb..c32aff8e261e 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -537,6 +537,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 			*v |= CPUCFG2_LSX;
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
+		if (cpu_has_lbt_x86)
+			*v |= CPUCFG2_X86BT;
+		if (cpu_has_lbt_arm)
+			*v |= CPUCFG2_ARMBT;
+		if (cpu_has_lbt_mips)
+			*v |= CPUCFG2_MIPSBT;
 
 		return 0;
 	case LOONGARCH_CPUCFG3:
-- 
2.39.3


