Return-Path: <kvm+bounces-44152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6D3A9B072
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:17:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 413721B818A1
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCFC28467F;
	Thu, 24 Apr 2025 14:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sTk4m9/r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22C127F74A
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504040; cv=none; b=B+2jirpSR64OZpWxnYog9R/+dtr1spMBydwl2OIrvCbJ4JjaZZ4BsMP4q48gOfjEdgjGnJTS/TwlAx1A4xsvPRJ3jHpHanrMIpckkhD/TIAS4HKez7J6CRz78+sb/RlafOupVE3wSuTz6EzqvH1xSYfamSmoi0YjrPaSFfIca6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504040; c=relaxed/simple;
	bh=pMsi9MMq97g7CjVTvZZzMUKV739tetlHWJOghEinxps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Msms/uabjw6KiWs1egepG4p8sLhVjkGO9WVqsi0E4E850dILXGKjEaHF2+mYlfnhyK6Q/dmO+lc1t86aGdxgWNGk32qe1MN10RGjd2yhrM8ulM3/hV3BDSjspOcE4VAIcX2gB5JiAXqMyYkn3Qr+ereWuaoxNKCoZpX8SJIxFt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sTk4m9/r; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf257158fso6836865e9.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504034; x=1746108834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S74NKpGFaVYOESsCH+rK4kh5DkFdas6Gq4YwtRp9OLI=;
        b=sTk4m9/r/YqM6gAkyB9+f+Cf9v2YjMXe9/V7HSO7QbIMep386kIqnkxl+8b5ZgmaMi
         vq11UPzDeTnTokkrMaJkq1om7bX7cplUE72LWmmRp55xsdwa8xhIOHfkaFCBWupg7bWu
         r7rCnHfm8rpJMFtqLaSRxYaEy7UlfKA0KEbr52xdM6miVQnel9dDetTl4FMpxMkuR0dM
         QFswRunRyDAjTnUH1ma3M3jX4DJL1/2E4yj7mgGDCP0h6+LhtvAXMqxx6zZjfdR+TDB3
         ymPhFpTwlgSj4rRMQ7FTLfCHMZ2gFbLb8agEcLvCUWlIUGhnsRVx/KzpLAIKXO+7aBGD
         mElA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504034; x=1746108834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S74NKpGFaVYOESsCH+rK4kh5DkFdas6Gq4YwtRp9OLI=;
        b=XjpTKgnea5DOIBWepQ1SUv30TgUQzBCJxoWAI7lSvHwpZC4HdE+mAyl74cTgqQpNrv
         W7mPx2AncL9B0qSuftdTK6KG0gU//QDETQFmzJx6gnv5BYrNrerCZ0tAM0UjhjpIsq41
         dOiIloJI/hvNGy1MC0+IudcQj7dTRpze/rTd+BORfG/UjHjDEOlvJ4QJINX0rv99RHVa
         NoOR2FbtLdxZOKL82ZAE1gRtRmV2b/0kzI346qBWFtZO2MgIf9EDvmPE/M75w0SL3eI5
         wrO7xJJhPreyVocbFS5c14wiyoOBKYASSl2xJkZLUu31l3GrDW7cnPXEcUB2QrSDmze/
         cVMw==
X-Forwarded-Encrypted: i=1; AJvYcCUu4agacLWKgwjjp8Qt6Ou3qnGwW/GwimnYZSf0nmW8/JjcFbi+mBXrp9ow/Ch5fxyxEj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyN7dv/ROK16B65UeJnY2Ka0DdsT/nmn+ERGE0MzCkaTdcPtP8P
	cQyL1RPdSkbZUYOAK+m+qMcQaPfEpJjocem0Lm/FlS8jf7/M+eLxQIz8QKnXzcM=
X-Gm-Gg: ASbGncuOAyIlunT8mUjBKOu+cx8jTSJq9Mb3DW+DfMpxiWr+vcOgMFRpQT2tgcx0vNB
	FWG9YTXGAdCcefSD599ZUAl3GtYmXVSaRSJcbY9O9zfymSixW7O6EX8qb9Lcz2tytAmmQqT9hlZ
	nT5zuPj0FjMHj3936k2lPcjTLkkwX5TSIrqu8UC8DcegvJ4o25+CPCSKiZUUkDrnThJW/4lQOlX
	CpkZASs5EaT6pPPFxtaUVnZLTUobSxT8wTJ4/oOiURKJl53jaK9/LsSI4+cRqgunsa2VuGdfixO
	+u0PfCZ8HcPMqbysbHtosn8nGvgswFjE9S2OOEaKm+7qfNKMpZpamsD3UEg6XXI0xXF5l3usJrt
	l87Z7CMw1x7qy3U46
X-Google-Smtp-Source: AGHT+IHx9bXGbc/XwzdBX2sEvhGOWsNMsxK7elP9ZHfuoFqJa71fFuvenAr2zCrjXuMcvE5wd1GoWA==
X-Received: by 2002:a05:6000:290d:b0:391:3b11:d604 with SMTP id ffacd0b85a97d-3a06cfa9d47mr2143588f8f.54.1745504034133;
        Thu, 24 Apr 2025 07:13:54 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:53 -0700 (PDT)
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
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 07/34] KVM: gunyah: Pin guest memory
Date: Thu, 24 Apr 2025 15:13:14 +0100
Message-Id: <20250424141341.841734-8-karim.manaouil@linaro.org>
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

Qualcomm's Gunyah hypervisor allows to implement protected VMs, in which
private memory given to the guest is no more accessible to the host (an
access violation will be raised if the host tries to read/write that
memory).

In the context of protected VMs (aka confidential computing), the consensus
to manage this memory is via guest_memfd. We would like this port to be
be based on guest_memfd. However, for this RFC, the port allocates
anonymous pages, which are subject to migration and swap out. That will
trigger a violation if the memory is private, which is the case for most
of the guest's main memory.

Since the memory is allocated and given to the guest for possibly an
unbounded amount of time, we longterm pin the pages to prevent the
kernel from touching and possibly swapping or migrating those pages.

In upcoming versions of this port, we intend to move to guest_memfd.

Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/gunyah.c           | 68 ++++++++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index efbfe31d262d..9c8e173fc9c1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -229,6 +229,9 @@ struct kvm_s2_mmu {
 };
 
 struct kvm_arch_memory_slot {
+#ifdef CONFIG_GUNYAH
+	struct page **pages;
+#endif
 };
 
 /**
diff --git a/arch/arm64/kvm/gunyah.c b/arch/arm64/kvm/gunyah.c
index 0095610166ad..9c37ab20d7e2 100644
--- a/arch/arm64/kvm/gunyah.c
+++ b/arch/arm64/kvm/gunyah.c
@@ -660,11 +660,47 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 {
 }
 
-void kvm_arch_commit_memory_region(struct kvm *kvm,
-				   struct kvm_memory_slot *old,
-				   const struct kvm_memory_slot *new,
-				   enum kvm_mr_change change)
+static int gunyah_pin_user_memory(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	unsigned int gup_flags = FOLL_WRITE | FOLL_LONGTERM;
+	unsigned long start = memslot->userspace_addr;
+	struct vm_area_struct *vma;
+	struct page **pages;
+	int ret;
+
+	if (!memslot->npages)
+		return 0;
+
+	/* It needs to be a valid VMA-backed region */
+	mmap_read_lock(current->mm);
+	vma = find_vma(current->mm, start);
+	if (!vma || start < vma->vm_start) {
+		mmap_read_unlock(current->mm);
+		return 0;
+	}
+	if (!(vma->vm_flags & VM_READ) || !(vma->vm_flags & VM_WRITE)) {
+		mmap_read_unlock(current->mm);
+		return 0;
+	}
+	mmap_read_unlock(current->mm);
+
+	pages = kvcalloc(memslot->npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		return -ENOMEM;
+
+	ret = pin_user_pages_fast(start, memslot->npages, gup_flags, pages);
+	if (ret < 0) {
+		goto err;
+	} else if (ret != memslot->npages) {
+		ret = -EIO;
+		goto err;
+	} else {
+		memslot->arch.pages = pages;
+		return 0;
+	}
+err:
+	kvfree(pages);
+	return ret;
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -672,11 +708,33 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	return 0;
+	int ret;
+
+	switch (change) {
+	case KVM_MR_CREATE:
+		ret = gunyah_pin_user_memory(kvm, new);
+		break;
+	default:
+		return 0;
+	}
+	return ret;
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				   struct kvm_memory_slot *old,
+				   const struct kvm_memory_slot *new,
+				   enum kvm_mr_change change)
+{
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
+	if (!slot->arch.pages)
+		return;
+
+	unpin_user_pages(slot->arch.pages, slot->npages);
+
+	kvfree(slot->arch.pages);
 }
 
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
-- 
2.39.5


