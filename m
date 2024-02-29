Return-Path: <kvm+bounces-10424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 285FE86C168
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF476286A81
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E9145BE4;
	Thu, 29 Feb 2024 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpsomyGm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757AD4594C;
	Thu, 29 Feb 2024 06:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189629; cv=none; b=dl1AUsKBrS3tUOK/67sk/CMJ6sgVIu3z+smk5Tm1WeIKuh3pHvz9Zo932TmTMtnFEdSAvnHRn424g14xLmgoLK70PsDc56eC0HxMMbkFSX2EKTInMGwXoMIhW7IHQ3MRvtaoWSlRieLC7sRbZoDfHw4vNc/4qvwEK9DVYyQ336g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189629; c=relaxed/simple;
	bh=rpPUI8/Ilc1h0gZrxlo0S9MkxaA5lzl3nhDeUQz8WlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lZ4xHPETObuGQyZyI7fhb6M5jNEriaFhKo2CcX81x7wmjbXipLgJQ0HYQeU5p/KmQomXDBnAmrQwtfwyk/o+TPGNugLrlgHfZheoAq0yalP2Lj/PVB0LV4RMUu/G0baAHcoXfntadJ5YUyFupRQh1ZQe27W0Jm5ANLJHOLqkfqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpsomyGm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dc96f64c10so5996475ad.1;
        Wed, 28 Feb 2024 22:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709189628; x=1709794428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzYCOce5vbS2RbT3cfrlWimjZLlkPfrhe1IV1KHmmpQ=;
        b=lpsomyGmik/3vO9sZ4IA21YIOlmSpYdnlnEDKodzBGH067choMFeG3lAv9pjYKLmre
         DUzql0CMm1HTwyLXqiuHvq1A4V4xxKE2w2akUG3PXBZMoqS8rGyE0WHasSNRgY04s+iT
         yvMs/gavcw421rKf6FYXLuyAMFr4wTDz1RKoHZnmyWknFAJ3+U6hs5/8xl0ROrxG2E0M
         WrVicFcOd5BkiCgaN/4LKVU6VRetMS5hMZwYlBxZCNEdxQToM/xBU0GzWL3oJ5K6G8Gl
         kDuHhtpILW6QN8kCti6fBbnniAHDm6/bE4fMzsh0Rz9HWDB4Izd5XXObHpVjEf3wqvue
         uXnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709189628; x=1709794428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LzYCOce5vbS2RbT3cfrlWimjZLlkPfrhe1IV1KHmmpQ=;
        b=TM+g7QOkxoPgvfUWGxRcVA/P9JoeddpwyohQHTIY5rANWeTMc1FBRaY6CNzOq4qT4O
         oJemr0mr7jLecABwJ0oD260eplFgvnx9Oo2MgPqQeV7tPsbQkGi6BKG+1t+wGevoGQ32
         neOyhbdiw2t4oXz+eeUfjCDcvSmovc/V8QV69g2mxIauX9CX24H6Jl6oGQCbMAAwhTel
         XuHm4QkkckrUTaIFI5cb0Di/eqVlWtXml10u/Y9TRQNp7gLu3C1ODXY2+YVhyBeiXvus
         J8PvXb3+NFfEyzjd4M17Y5I4l8+Y4e+w1Og1BVFQ3eJOgY9IGXA+6Tbxj3yjyo2i7U92
         EEPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWrv5/7w/vQSorZxZJWauCwTslo6mcf/wAWLeznuJybeRPiqTwTsAQCyDQ+cr5cKUtAVZ+bQ3T2VFuGwGvV/fSZk43S5sxfgAafqCohp5C/qZH1y1GzxCD/LqEkiQ7J6Um
X-Gm-Message-State: AOJu0YwGw8924YSRmfJ/ekh8m4gMn5VwBV6mDqsYyrkHD8/WKqhP1NiQ
	CEQYWqPjronU27OjY81uE9wmfQYizrf3CtJ5JfbbN+Zs6v/zLjZV
X-Google-Smtp-Source: AGHT+IGda8LP7RnnCF1XOEo6jvOCk88OmaEv0BmiQ3NUSVYHPR/reUiX2a6zIhwxj1w+wf9y9XY1mg==
X-Received: by 2002:a17:902:c403:b0:1db:ecf1:3b67 with SMTP id k3-20020a170902c40300b001dbecf13b67mr1673914plk.66.1709189627675;
        Wed, 28 Feb 2024 22:53:47 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001dc0d1fb3b1sm610509plh.58.2024.02.28.22.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Feb 2024 22:53:47 -0800 (PST)
From: Yi Wang <up2wing@gmail.com>
X-Google-Original-From: Yi Wang <foxywang@tencent.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wanpengli@tencent.com,
	foxywang@tencent.com,
	oliver.upton@linux.dev,
	maz@kernel.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com
Cc: up2wing@gmail.com
Subject: [RESEND v3 1/3] KVM: setup empty irq routing when create vm
Date: Thu, 29 Feb 2024 14:53:11 +0800
Message-Id: <20240229065313.1871095-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240229065313.1871095-1-foxywang@tencent.com>
References: <20240229065313.1871095-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Wang <foxywang@tencent.com>

Add a new function to setup empty irq routing in kvm path, which
can be invoded in non-architecture-specific functions. The difference
compared to the kvm_setup_empty_irq_routing() is this function just
alloc the empty irq routing and does not need synchronize srcu, as
we will call it in kvm_create_vm().

Using the new adding function, we can setup empty irq routing when
kvm_create_vm(), so that x86 and s390 no longer need to set
empty/dummy irq routing when creating an IRQCHIP 'cause it avoid
an synchronize_srcu.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 virt/kvm/kvm_main.c      |  4 ++++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4944136efaa2..e91525c0a4ea 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2000,6 +2000,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *entries,
 			unsigned nr,
 			unsigned flags);
+int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm);
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..90fc43bd0fe4 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -237,3 +237,22 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	return r;
 }
+
+int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)
+{
+	struct kvm_irq_routing_table *new;
+	u32 i, j;
+
+	new = kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
+	if (!new)
+		return -ENOMEM;
+
+	new->nr_rt_entries = 1;
+	for (i = 0; i < KVM_NR_IRQCHIPS; i++)
+		for (j = 0; j < KVM_IRQCHIP_NUM_PINS; j++)
+			new->chip[i][j] = -1;
+
+	RCU_INIT_POINTER(kvm->irq_routing, new);
+
+	return 0;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7db96875ac46..db1b13fc0502 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1242,6 +1242,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (r)
 		goto out_err;
 
+	r = kvm_setup_empty_irq_routing_lockless(kvm);
+	if (r)
+		goto out_err;
+
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
-- 
2.39.3


