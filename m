Return-Path: <kvm+bounces-44173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF239A9B0B1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:25:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AA3F4A484D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB6A2951B6;
	Thu, 24 Apr 2025 14:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x9sK5gL9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A61B4F3D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504067; cv=none; b=Q0TXvInHrpBKJzQXsbtRRGWorC3a9Ise1j0A6IMAY/p2sMbPlT1fPKzBZIp81MeBlbEK4TkhLaHZPVOmyJXZ4NFjzDH046rzyKuqFUZEMgBpoSkbSocPZqyaKYSNpsO1q7PVwnx1/G4BuIeXfbGQF+ZxozLtZryL6545/KimZU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504067; c=relaxed/simple;
	bh=TszZQ//DMZ7Wex/EWSs2RVro6IlBnBW/flMNEyx2TWU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h03cPScIScQogBqBqvs5yFUFvcU9aNlNc2ua2xnW+C1+H1FCaOxLF2TRlRINsV2JpGmaisywrl6zOlCVN6geiUNlLElzNXQq5zH6z/YkmeQkt9aSPb00qPTG0ADKR/+zWziDz08TNbf5umTqsLv8u2rCDEC4LgEekg/aH3+Q7og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x9sK5gL9; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39bf44be22fso820729f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504063; x=1746108863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88AiON8knVFtAm4gGlYsfQZYlJxkn1/VFztoyFrvZWY=;
        b=x9sK5gL9U0W0aBidfjPjwipqtUklIVk4o1kIne0qmrnkewk+mp+beWI7OgPH1JKmB/
         e77X33ZePtK10LJpX1wgpF4Z3Dh/LIWgdKfwdSz7XOGTSrMgkNDfD9HP9pYpOk97XOjh
         2yWryuObm+Pz29EgXo9Y04ybVkN8i755Yvsi4ZiZyR/5oIcg9WTSRFCy8ZlOCRwBcihU
         J7WLXsU5YtdUhQBh6TDZMZHJ5UeSCEzi+pL68GQgNSIh8mtoAvdiGc2tgh2cZwuEDjOa
         mMkJOTIMkbQb5qkfxHFt+I3J9vB0w2Zbw/VGaeBE4tJr/KilNB8IKtpgE8HnWXzRIazx
         qZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504063; x=1746108863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88AiON8knVFtAm4gGlYsfQZYlJxkn1/VFztoyFrvZWY=;
        b=IMXgRgtrFV7QM8xT0l3iaYPSr/au8VHrt7098u07X3eAM9hmSIcspMB3GPToFwtXW5
         XRIpu8XK4GMen8gr604CKcqus6fPHY6kNYsJvEMBl3fWK6IHxPgbpk0eHji/tED4xvcc
         bAQ0MwNET37Ovw1oJm0ujAvZRkQiH33iJGcHXh59iNuT+hVlanBugodLj9uFR9gOhBna
         grSNacRapqX3L3nUKBCIH9JYAhj0+PebqHWV54Cz5kUgBYnTh5siCg65TYY6dQXemFZk
         nBupNIeyK+vI5f1XmminZB2R3Lx4v+X/QAree1BwLc8eLmtaoDAJHB+8J3F0/r6mq9h1
         TzEg==
X-Forwarded-Encrypted: i=1; AJvYcCVeff1FmM3/vXBeIkNOLpMWgSNVZN382LsG6NQWo+jgF+og/EL9z8/dQbBe4C3z0LYsaVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH9EBWB5Vc1d23J3H6qAkysHt5tGfdNTr16KsEk4bYL0aGyM24
	opT2m2+p5ajPMd6jUyHQr9ZmRnIburzWY+fnjEM4iNrQh7WRQraKHFL/+IOUWmV4MDxF7OBg9ef
	v
X-Gm-Gg: ASbGncuErgbXKiQCRGoEWhjk8zIq6aAjV9YjztHMy57iNTwaMro+BKLKgmByx/nPOOy
	BuAwU/dJ4HQDtZYKJF9wuwmWE9FzB605yjXt1dIpy8CF7jSlS7m6wXvjDkKQcltNF6Dy8xr/1UB
	WVk2O0a8r5Kpd4VI3FbhTe8Q9vColTeWCuTHwX3ftaCMMV/eHhdH4axJ88XvOXpmWjHsL65e3S9
	9Mi0pXTXuDFewFJi938aJzpchIjLVaapWwZp5bJ1N/cj60XrDATizsPM0VMDR7rdwCHUHMUCU6Q
	/8V0r5DBNyThgICR+uX9MbiZ+71wLyK369vFeBB/W/iiUW3TxFcjQDsLU5D2/qPwaEGcBF2VEKU
	A9wg4mVJYPCri7tab
X-Google-Smtp-Source: AGHT+IE6SiBau6EY9Mh/ltJdHWfjy1fT3q7qjVfQcBmH9UUhGIZ598Z7cZVBqAGGCWYaKx9pVYAqXA==
X-Received: by 2002:a05:6000:43d6:10b0:3a0:7017:61f6 with SMTP id ffacd0b85a97d-3a07017626dmr1028260f8f.14.1745504062675;
        Thu, 24 Apr 2025 07:14:22 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:22 -0700 (PDT)
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
Subject: [RFC PATCH 28/34] gunyah: Add RPC to enable demand paging
Date: Thu, 24 Apr 2025 15:13:35 +0100
Message-Id: <20250424141341.841734-29-karim.manaouil@linaro.org>
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

Add Gunyah Resource Manager RPC to enable demand paging for a virtual
machine. Resource manager needs to be informed of private memory regions
which will be demand paged and the location where the DTB memory parcel
should live in the guest's address space.

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/rsc_mgr_rpc.c | 71 +++++++++++++++++++++++++++++++
 include/linux/gunyah_rsc_mgr.h    | 12 ++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/virt/gunyah/rsc_mgr_rpc.c b/drivers/virt/gunyah/rsc_mgr_rpc.c
index ec187d116dd7..7fccd871cc0b 100644
--- a/drivers/virt/gunyah/rsc_mgr_rpc.c
+++ b/drivers/virt/gunyah/rsc_mgr_rpc.c
@@ -106,6 +106,23 @@ struct gunyah_rm_vm_config_image_req {
 	__le64 dtb_size;
 } __packed;
 
+/* Call: VM_SET_DEMAND_PAGING */
+struct gunyah_rm_vm_set_demand_paging_req {
+	__le16 vmid;
+	__le16 _padding;
+	__le32 range_count;
+	DECLARE_FLEX_ARRAY(struct gunyah_rm_mem_entry, ranges);
+} __packed;
+
+/* Call: VM_SET_ADDRESS_LAYOUT */
+struct gunyah_rm_vm_set_address_layout_req {
+	__le16 vmid;
+	__le16 _padding;
+	__le32 range_id;
+	__le64 range_base;
+	__le64 range_size;
+} __packed;
+
 /*
  * Several RM calls take only a VMID as a parameter and give only standard
  * response back. Deduplicate boilerplate code by using this common call.
@@ -467,3 +484,57 @@ int gunyah_rm_get_hyp_resources(struct gunyah_rm *rm, u16 vmid,
 	return 0;
 }
 ALLOW_ERROR_INJECTION(gunyah_rm_get_hyp_resources, ERRNO);
+
+/**
+ * gunyah_rm_vm_set_demand_paging() - Enable demand paging of memory regions
+ * @rm: Handle to a Gunyah resource manager
+ * @vmid: VMID of the other VM
+ * @count: Number of demand paged memory regions
+ * @entries: Array of the regions
+ */
+int gunyah_rm_vm_set_demand_paging(struct gunyah_rm *rm, u16 vmid, u32 count,
+				   struct gunyah_rm_mem_entry *entries)
+{
+	struct gunyah_rm_vm_set_demand_paging_req *req __free(kfree) = NULL;
+	size_t req_size;
+
+	req_size = struct_size(req, ranges, count);
+	if (req_size == SIZE_MAX)
+		return -EINVAL;
+
+	req = kzalloc(req_size, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->vmid = cpu_to_le16(vmid);
+	req->range_count = cpu_to_le32(count);
+	memcpy(req->ranges, entries, sizeof(*entries) * count);
+
+	return gunyah_rm_call(rm, GUNYAH_RM_RPC_VM_SET_DEMAND_PAGING, req,
+			      req_size, NULL, NULL);
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_vm_set_demand_paging, ERRNO);
+
+/**
+ * gunyah_rm_vm_set_address_layout() - Set the start address of images
+ * @rm: Handle to a Gunyah resource manager
+ * @vmid: VMID of the other VM
+ * @range_id: Which image to set
+ * @base_address: Base address
+ * @size: Size
+ */
+int gunyah_rm_vm_set_address_layout(struct gunyah_rm *rm, u16 vmid,
+				    enum gunyah_rm_range_id range_id,
+				    u64 base_address, u64 size)
+{
+	struct gunyah_rm_vm_set_address_layout_req req = {
+		.vmid = cpu_to_le16(vmid),
+		.range_id = cpu_to_le32(range_id),
+		.range_base = cpu_to_le64(base_address),
+		.range_size = cpu_to_le64(size),
+	};
+
+	return gunyah_rm_call(rm, GUNYAH_RM_RPC_VM_SET_ADDRESS_LAYOUT, &req,
+			      sizeof(req), NULL, NULL);
+}
+ALLOW_ERROR_INJECTION(gunyah_rm_vm_set_address_layout, ERRNO);
diff --git a/include/linux/gunyah_rsc_mgr.h b/include/linux/gunyah_rsc_mgr.h
index fb3feee73490..f16e64af9273 100644
--- a/include/linux/gunyah_rsc_mgr.h
+++ b/include/linux/gunyah_rsc_mgr.h
@@ -152,6 +152,18 @@ gunyah_rm_alloc_resource(struct gunyah_rm *rm,
 			 struct gunyah_rm_hyp_resource *hyp_resource);
 void gunyah_rm_free_resource(struct gunyah_resource *ghrsc);
 
+int gunyah_rm_vm_set_demand_paging(struct gunyah_rm *rm, u16 vmid, u32 count,
+				   struct gunyah_rm_mem_entry *mem_entries);
+enum gunyah_rm_range_id {
+	GUNYAH_RM_RANGE_ID_IMAGE = 0,
+	GUNYAH_RM_RANGE_ID_FIRMWARE = 1,
+};
+
+int gunyah_rm_vm_set_address_layout(struct gunyah_rm *rm, u16 vmid,
+				    enum gunyah_rm_range_id range_id,
+				    u64 base_address, u64 size);
+
+
 int gunyah_rm_call(struct gunyah_rm *rsc_mgr, u32 message_id,
 		   const void *req_buf, size_t req_buf_size, void **resp_buf,
 		   size_t *resp_buf_size);
-- 
2.39.5


