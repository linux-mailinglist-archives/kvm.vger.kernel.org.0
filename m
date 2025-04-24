Return-Path: <kvm+bounces-44175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B35A9B0B6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:25:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C03C53B3808
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF492957D3;
	Thu, 24 Apr 2025 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BCIEvZRv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000082949FE
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504069; cv=none; b=Kweft5yTubyvlasxowVwO+/56HX1HShi9/aLabYmFF1FfvbSby2QRXDyxv33AlWI0zFgT/AUQtkkwRDLMbQcYR/lGgzpIrcot8sMe+UlAJBgRLsFhsaDBlcdlBHMZOEjJ8DebbIpvGWCq2hUVmPbVa+tXVsfjY3mv+hT8yM2idU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504069; c=relaxed/simple;
	bh=KiBOPw2VoeUP9jPtQen3QJ8+JIhOTaUQt1mQ67vK+Wk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GGL9LHXg9+HR5h6753XVg+drvr3VT4BYcKujWGdg8GzV2oNY+fe3H2ak+U/ED0hnsD2cD3e/snvMOOyCmBBX3sXqPJ36Tfn8bmF5OfLPW6jLE+UI4+5BvIZtZ+OEzcZalCAklZnUVdUrnNQAKHeqU5h3UnTf1iHbCGkzdj5Tn50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BCIEvZRv; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so878193f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504065; x=1746108865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fkw6jo/oeFh6qnWXDp6jlBdNEq901uF/wqE5/ZMg0xQ=;
        b=BCIEvZRv2R68O63R8brL2WfAmdo925iFx38XKdTQ0t+jxsjdLI1JKc/L5tWtXUgyok
         xDFWVlpPvWYx3toLYNTof9Xh1eEc4LiLVBxk/xTOK8U9tAr4RdU8PEjKTFoM+KdjiQWz
         pCiFnyymKrfV9BdBIiFf7Gf3o5zHiH04R18oZMKpjtiX9CWwCovgdK9tgLDSRknqUzkM
         pAupuCjzcAsPWd8wmZa1UTKIuC8oavN0xCcVzBzPMBzOVC6AKRg3Sx0z2ncIHuz4FWqM
         vFWHksGt5xY/giD2q9cuPyRcRZmD5RZoZP3Vb3qdL1mGwMuAsRjqhT70yzTBAX9WrW8k
         sZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504065; x=1746108865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fkw6jo/oeFh6qnWXDp6jlBdNEq901uF/wqE5/ZMg0xQ=;
        b=vze9HDDhJG71AJKw/fQke5bO9g0d/dUrcwUyr47Cmcj7KbUuaz+HFZSrUGKFturh0M
         Uk72wyQsAnPmPyPZIG+9iLS4HfsdXZ2Zr4Lz/xS5W2U0iaMZZ18Iyq7Evfs83U/nn97S
         r7vhUQ9dMZ6LaGVLyUIurB5hgADbIichSe4PyIky7TmlX8x5yqPRu/zRCtsyNrR5uBrN
         wlpHvW1dNyzqDn4lfHly7G9Cm99N/9c6/+AnrcDKSGsulE0IYronIcLvYlYYNDBJexLj
         9Jbc22nlmuIiueGusXBREN+Q1SaTaRawMoJOiQs7sASNc8OLPgjBb3ke3d6rEms37rbw
         291Q==
X-Forwarded-Encrypted: i=1; AJvYcCWA9/K+RmLBPXGoOc1XZ2nUaZ3U5RkAa24o/Gvzf8gvtxTBksKEFPZhyUZ/i6y8J+uxNXA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA8AQbuF2IClq8s3NvBN31ML5f3xuTjgz6vkdP9YuBMnBIG+np
	WoxbfSEHmzYi4Y8GDJx2yBD4bVUlIkIEmLQpFiM+g+R6GsKAny6VlXxgFsYMwAM=
X-Gm-Gg: ASbGncut1W5OMsSyF4sEEN3n34h8NbPMjRomFmTjgaPcA2GyOkr5We86F+Kbe32Y5ah
	EUFMMKWWS6d3TR1UKfBnz0l+JGY2ICrQ6obzj9BT3Yd6RXjHaoPAWx2TPPNGwvkVYmNSoFqHb1i
	9VBp/Q7ubGIv9u5oE+heEUck4ptYILfdv7BKdN4h/hnS3M78DY0DfOMv3JAGtJI7nb05NM8NO78
	q4Hlllvomx1fAvhuwe5LYwtshKHsl0gG/pG6k6mtlm4ZWkEmR5l+SCKv8SvJ2kLe/vEGTr8szIv
	aScQuSFumX5fYsr3k28gsLpcbOePc5mIfgG/R2zKKv+/ODU5RHSlB9rKr2Rs4C7bU41MiSI9GAy
	0F65BTYz2cNhGvEc7
X-Google-Smtp-Source: AGHT+IELqmSvaP6OfocDnjzMS7mUki3w51itbTq+w393mXtO1Vl290MnI9dSMs1K0cj071gNYf3OVQ==
X-Received: by 2002:a5d:6da2:0:b0:39e:cc0c:9789 with SMTP id ffacd0b85a97d-3a06cf4f2f6mr2251923f8f.11.1745504065280;
        Thu, 24 Apr 2025 07:14:25 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:24 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>
Subject: [RFC PATCH 30/34] gunyah: Add RPC to set VM boot context
Date: Thu, 24 Apr 2025 15:13:37 +0100
Message-Id: <20250424141341.841734-31-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

The initial context of a the primary vCPU can be initialized by
performing RM RPC calls.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Reviewed-by: Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/rsc_mgr_rpc.c | 32 +++++++++++++++++++++++++++++++
 include/linux/gunyah_rsc_mgr.h    |  2 ++
 2 files changed, 34 insertions(+)

diff --git a/drivers/virt/gunyah/rsc_mgr_rpc.c b/drivers/virt/gunyah/rsc_mgr_rpc.c
index 7fccd871cc0b..78c4d1d5d42a 100644
--- a/drivers/virt/gunyah/rsc_mgr_rpc.c
+++ b/drivers/virt/gunyah/rsc_mgr_rpc.c
@@ -106,6 +106,15 @@ struct gunyah_rm_vm_config_image_req {
 	__le64 dtb_size;
 } __packed;
 
+/* Call: VM_SET_BOOT_CONTEXT */
+struct gunyah_rm_vm_set_boot_context_req {
+	__le16 vmid;
+	u8 reg_set;
+	u8 reg_index;
+	__le32 _padding;
+	__le64 value;
+} __packed;
+
 /* Call: VM_SET_DEMAND_PAGING */
 struct gunyah_rm_vm_set_demand_paging_req {
 	__le16 vmid;
@@ -447,6 +456,29 @@ int gunyah_rm_vm_init(struct gunyah_rm *rm, u16 vmid)
 }
 ALLOW_ERROR_INJECTION(gunyah_rm_vm_init, ERRNO);
 
+/**
+ * gunyah_rm_vm_set_boot_context() - set the initial boot context of the primary vCPU
+ * @rm: Handle to a Gunyah resource manager
+ * @vmid: VM identifier
+ * @reg_set: See &enum gunyah_vm_boot_context_reg
+ * @reg_index: Which register to set; must be 0 for REG_SET_PC
+ * @value: Value to set in the register
+ */
+int gunyah_rm_vm_set_boot_context(struct gunyah_rm *rm, u16 vmid, u8 reg_set,
+				  u8 reg_index, u64 value)
+{
+	struct gunyah_rm_vm_set_boot_context_req req_payload = {
+		.vmid = cpu_to_le16(vmid),
+		.reg_set = reg_set,
+		.reg_index = reg_index,
+		.value = cpu_to_le64(value),
+	};
+
+	return gunyah_rm_call(rm, GUNYAH_RM_RPC_VM_SET_BOOT_CONTEXT,
+			      &req_payload, sizeof(req_payload), NULL, NULL);
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_vm_set_boot_context, ERRNO);
+
 /**
  * gunyah_rm_get_hyp_resources() - Retrieve hypervisor resources (capabilities) associated with a VM
  * @rm: Handle to a Gunyah resource manager
diff --git a/include/linux/gunyah_rsc_mgr.h b/include/linux/gunyah_rsc_mgr.h
index f16e64af9273..6a07fe25b0ba 100644
--- a/include/linux/gunyah_rsc_mgr.h
+++ b/include/linux/gunyah_rsc_mgr.h
@@ -126,6 +126,8 @@ int gunyah_rm_vm_configure(struct gunyah_rm *rm, u16 vmid,
 			   u32 mem_handle, u64 image_offset, u64 image_size,
 			   u64 dtb_offset, u64 dtb_size);
 int gunyah_rm_vm_init(struct gunyah_rm *rm, u16 vmid);
+int gunyah_rm_vm_set_boot_context(struct gunyah_rm *rm, u16 vmid, u8 reg_set,
+				  u8 reg_index, u64 value);
 
 struct gunyah_rm_hyp_resource {
 	u8 type;
-- 
2.39.5


