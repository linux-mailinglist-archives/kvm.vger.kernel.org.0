Return-Path: <kvm+bounces-44172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D17A9B0AB
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936A53B0055
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:24:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A9E294A04;
	Thu, 24 Apr 2025 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="P3uDnySM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3AA28E607
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504065; cv=none; b=UcONeTZNVdp5vjajrz7gUi+EaBvrQNe9Z2oEuefDKtAV8mTg3xxzl4EyHlP5SoAIe5W1AdCNRy3r8tLSZe+1BH+z/SCFWppeLg9bKcKPLSWX/VTtDO/Ks/GcyZuI/k9qdpg99RzOO2CDkcYcpnbnhMfDCg85lZQ0t3qDhp8kzgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504065; c=relaxed/simple;
	bh=Yi4ZtnxtwEwwcGq5Pu3T2/cALo63bY4y5tVWXmp+Y3c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PBoztBjFQBQHBl4eQ0HWD1/Qqj5sxe8aENvbor6JPAUZ4vZSOV6gMItxgwP9q4O0ZsGclzAb6c3K5/uIc80MvksUARhSyjVwwrmlVo4gn3gb3sgf0iZ+bDF01GvEnmpeAhYRdz+BfZa+LPj8P/m0r5BrYZmTyDz+IjvrJB5b2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=P3uDnySM; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39ee682e0ddso731738f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504061; x=1746108861; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KqI809F7wKcnGZMELURBH0WwNUVNARNAdRqZ1Gwku8c=;
        b=P3uDnySMxJTWQ7/cn0c6QZfS+2mrcsS4YkITm9Jqvkwwd5JKcVX1YIHlyx536M/Icz
         4zoZfnwIj3oiZI26ksGkdThqhKWvQPNuKpAtg0fkVVqb0ht0/qc+RXXvjh9+I7NEmj82
         l2vILtAz+xiQF9fd9P4TADL3bYT0NkFm03GbsGx9OF16fSnpc8NRO2c8JfG9wsP2i7AG
         5RmNr/QZ9Rn4X7SQjxqek8nWQOPb2h12lqjSgAFaeCHojqBNfD7Rc22d4ZYqnlClkN05
         bPkc1avSLqwWPj47rGA9wVVzjqkp1NktobmDDPe/qldAM3KePajlpvrZKB615gfDflo7
         4MJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504061; x=1746108861;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KqI809F7wKcnGZMELURBH0WwNUVNARNAdRqZ1Gwku8c=;
        b=VcuU1vkaNa+fN6G7se27FNmWVBaqYT/j0zboJAZ2bi5IWCcZ34MoE+KwOKnkAUvuP4
         DATojCjRAI0FefU5AcQQCrt/KSk9HO+vyYLEIZFhgTOkxnAdFDBxK/xnWdqY5oxCJFz7
         pyB4HozKs0GSFS+PHHcx91AIBYcCbxUgadIQdviLfsJIWhgizO0vOYmuuNslH+Q/FeKw
         ukuTmueOZVuGdPssW44Y4s2fNY4sbLfy4BxOEDONevqX2TNYmy8puBLhxoG24QCqtqmF
         KgfOVxIin+EJ6fN9ksY2WbO3cm2bdUu/A7yCmxwd/Uv4JIIaiK3i9bZkjUwbGwZNarYs
         rZGA==
X-Forwarded-Encrypted: i=1; AJvYcCUSGi9VqB2L6xe+x8uoJw7bjxTTwzCDMhPGKrWzZvtCMjBMjm9G0S/q3CO7qSgCLsDSfLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwShNFrCeEVWihrm4/m+0vlfnBn9dQcIvCnQs+hW2Csx6skbz02
	Sp1JhF9xKmrbBzweMohojWrSqKNPMlUAlaXD8cE9SzSg1ANDDNXqJFqC6JuPxfk=
X-Gm-Gg: ASbGncv2B80QHLaaat1DkCSm7sUZGr9SkGzi160mCTMb+Mby5EGT1faiTJearf0na0x
	nKr/FOuEbp3N12elhYbgYPGVvicy7c23MVa4cWuz/mWHvGraHra85tPOtMgj/1zzaQS3kiFwu+w
	DV1cxL/cCyXZfuZNsCs0M21iO0sW2ZnGcA0pqladofzQsVJt0oOGfA5Qoo/xEjshnsZoOTaCu0A
	KDsrTqYt+ZpSWQWVB7XhuNpx64uDAJrJKw+0mz2x2RwhxCDeRlJCzvB7GYk0YZLQq4sGoN/4ndn
	vJS7NOQLiGil6WypCPZ2javcyiT2pqIDlirWN3cfWtpb5B7WB2FMFT1heoiHVypy6c3ldJHjzl2
	zneQP9EqBdvVXbOGh
X-Google-Smtp-Source: AGHT+IHu0xINB3AI0ORmGPEOw/RldxQp1Lf0CLnYLBWHSDl9/V/LyKw8BRQRYMCgyV0pnZHvllr1jA==
X-Received: by 2002:a5d:584e:0:b0:39a:c9ac:cd3a with SMTP id ffacd0b85a97d-3a06cfa9c91mr2435184f8f.51.1745504061234;
        Thu, 24 Apr 2025 07:14:21 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:20 -0700 (PDT)
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
Subject: [RFC PATCH 27/34] gunyah: Share guest VM dtb configuration to Gunyah
Date: Thu, 24 Apr 2025 15:13:34 +0100
Message-Id: <20250424141341.841734-28-karim.manaouil@linaro.org>
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

Gunyah Resource Manager sets up a virtual machine based on a device tree
which lives in guest memory. Resource manager requires this memory to be
provided as a memory parcel for it to read and manipulate. Construct a
memory parcel, lend it to the virtual machine, and inform resource
manager about the device tree location (the memory parcel ID and offset
into the memory parcel).

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/kvm/gunyah.c | 27 ++++++++++++++++++++++++---
 include/linux/gunyah.h  | 10 ++++++++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index ef0971146b56..687f2beea4e7 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -699,8 +699,7 @@ static int gunyah_reclaim_memory_parcel(struct gunyah_vm *ghvm,
 	if (parcel->mem_handle != GUNYAH_MEM_HANDLE_INVAL) {
 		ret = gunyah_rm_mem_reclaim(ghvm->rm, parcel);
 		if (ret) {
-			dev_err(ghvm->parent, "Failed to reclaim parcel: %d\n",
-				ret);
+			pr_err("Failed to reclaim parcel: %d\n", ret);
 			/* We can't reclaim the pages -- hold onto the pages
 			 * forever because we don't know what state the memory
 			 * is in
@@ -1574,6 +1573,7 @@ static void gunyah_vm_stop(struct gunyah_vm *ghvm)
 
 static int gunyah_vm_start(struct gunyah_vm *ghvm)
 {
+	struct kvm *kvm = &ghvm->kvm;
 	struct gunyah_rm_hyp_resources *resources;
 	struct gunyah_resource *ghrsc;
 	int i, n, ret;
@@ -1597,7 +1597,18 @@ static int gunyah_vm_start(struct gunyah_vm *ghvm)
 	ghvm->vmid = ret;
 	ghvm->vm_status = GUNYAH_RM_VM_STATUS_LOAD;
 
-	ret = gunyah_rm_vm_configure(ghvm->rm, ghvm->vmid, ghvm->auth, 0, 0, 0, 0, 0);
+	ghvm->dtb.parcel_start = gpa_to_gfn(kvm->dtb.guest_phys_addr);
+	ghvm->dtb.parcel_pages = gpa_to_gfn(kvm->dtb.size);
+	ret = gunyah_share_memory_parcel(ghvm, &ghvm->dtb.parcel,
+					 ghvm->dtb.parcel_start,
+					 ghvm->dtb.parcel_pages);
+	if (ret) {
+		pr_warn("Failed to allocate parcel for DTB: %d\n", ret);
+		goto err;
+	}
+
+	ret = gunyah_rm_vm_configure(ghvm->rm, ghvm->vmid, ghvm->auth,
+			ghvm->dtb.parcel.mem_handle, 0, 0, 0, kvm->dtb.size);
 	if (ret) {
 		pr_warn("Failed to configure VM: %d\n", ret);
 		goto err;
@@ -1698,6 +1709,16 @@ static void gunyah_destroy_vm(struct gunyah_vm *ghvm)
 	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_RUNNING)
 		gunyah_vm_stop(ghvm);
 
+	if (ghvm->vm_status == GUNYAH_RM_VM_STATUS_LOAD ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_READY ||
+	    ghvm->vm_status == GUNYAH_RM_VM_STATUS_INIT_FAILED) {
+		ret = gunyah_reclaim_memory_parcel(ghvm, &ghvm->dtb.parcel,
+						 ghvm->dtb.parcel_start,
+						 ghvm->dtb.parcel_pages);
+		if (ret)
+			pr_err("Failed to reclaim DTB parcel: %d\n", ret);
+	}
+
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->addrspace_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_shared_extent_ticket);
 	gunyah_vm_remove_resource_ticket(ghvm, &ghvm->host_private_extent_ticket);
diff --git a/include/linux/gunyah.h b/include/linux/gunyah.h
index 1d363ab8967a..72aafc813664 100644
--- a/include/linux/gunyah.h
+++ b/include/linux/gunyah.h
@@ -94,6 +94,12 @@ struct gunyah_vm_resource_ticket {
  * @resource_tickets: List of &struct gunyah_vm_resource_ticket
  * @auth: Authentication mechanism to be used by resource manager when
  *        launching the VM
+ * @dtb: For tracking dtb configuration when launching the VM
+ * @dtb.parcel_start: Guest frame number where the memory parcel that we lent to
+ *                    VM (DTB could start in middle of folio; we lend entire
+ *                    folio; parcel_start is start of the folio)
+ * @dtb.parcel_pages: Number of pages lent for the memory parcel
+ * @dtb.parcel: Data for resource manager to lend the parcel
  */
 struct gunyah_vm {
 	u16 vmid;
@@ -113,6 +119,10 @@ struct gunyah_vm {
 	struct gunyah_vm_resource_ticket host_shared_extent_ticket;
 	struct gunyah_vm_resource_ticket guest_private_extent_ticket;
 	struct gunyah_vm_resource_ticket guest_shared_extent_ticket;
+	struct {
+		gfn_t parcel_start, parcel_pages;
+		struct gunyah_rm_mem_parcel parcel;
+	} dtb;
 };
 
 /**
-- 
2.39.5


