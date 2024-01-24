Return-Path: <kvm+bounces-6828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD33E83A7FF
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 12:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EB3F2963C9
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 11:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645D01B27D;
	Wed, 24 Jan 2024 11:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ce0zhmj4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4E24F88E;
	Wed, 24 Jan 2024 11:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706096112; cv=none; b=HCKIyUJD3Nyj6w4DW+O3yS14hti4GiJacyA3AxMrZMN5psPttelEgha3pOI0CRewPyZKA3lkAltsOdDOYulVca2EGvAv3ISSH3cKR6P2BpXcSqdozkPB8qs+GLFT6KEOtxin+CxiNchadunKCFR7vyK99dyYrHn1PfiMWEO7BkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706096112; c=relaxed/simple;
	bh=rpPUI8/Ilc1h0gZrxlo0S9MkxaA5lzl3nhDeUQz8WlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lj3UKjfudKDzddcqzGiSk8LnFucukWqi3ohhXeQIm6QDVY0HG108vU+Kx2AMdxJJzOddXsNBrc2DuQTMrqoeO7gbZm2tydd3kS988T1A0RCARjDmAfgYbijyq9cn+Jw27E39DyVSn6zFZvpLoirzlM6QPBjOZ4NAE6KwMhW3224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ce0zhmj4; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3619e804f3aso19652625ab.2;
        Wed, 24 Jan 2024 03:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706096110; x=1706700910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LzYCOce5vbS2RbT3cfrlWimjZLlkPfrhe1IV1KHmmpQ=;
        b=Ce0zhmj4yuRiYAr/IoZJWByO5qKyfC8f5L8ss1bm2bNlJflI147abq/Wxr4u5WZFXK
         uq18bBVumNcrYRPtj2xfdsLeeUu4c82X49r60KCf0NiOQD3FBSOYB5px08s/jzAQkwG/
         DvFATjvj0vEzV/OwepZba6WcjdZyCWZ+k/FL3OW7SUJ9ZuFe0vquZmShDO5zHkXTmJCB
         2UWQs/0eN9wJKjnZWAWflEuNizVawyu7KQVyrT0iEcHF0KT5Q2E0cPRwqJccyETjWZ9i
         Y8YGNze097+UHYMyLiXzPJbkrYOCV8WVMpP5StfESOF7OPnsKOnh7Tc3gwawA0k6DyOq
         E6PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706096110; x=1706700910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LzYCOce5vbS2RbT3cfrlWimjZLlkPfrhe1IV1KHmmpQ=;
        b=OJXQbwhYOYbmUIClOi9Rq0Tcip/I2qhCu1IbqaHSJwLM0109O9hvwl/EB0PZkg2cwO
         uIWve/VoSQFW0fqGzwFDFao9XnZfdIqsjmuzCs+BxKZnDq5FsGKC6Ieqm6kroHgJBedO
         NowQ4Eg2rGuhrxZb8MvIufhGBsnNRsNGtmDqR1pqrUABt5YbOwuqlhOittmja9ugA9Qs
         4HIGnGjNvMK4gto9sB5KLslVBJa6LloHxSOplXSJEY0/KTjoQP5oaK47lhA2RhrktcT6
         sWefoqrkOsz/Pmg3g2StvxaHgsG+mAZbkf4t99jdbvRrTnrW3i6WuxoEim4sqU4ZDHXP
         P2pw==
X-Gm-Message-State: AOJu0YylRw3dHmN/mOuc5FqZEYgHeWosuoiLFPg4gRKsIGGFZYb1dyG0
	WbVdEynGUW+vMfMU1kg31oRwRZb8In36a59+/FBVKP981/kQ4xxp
X-Google-Smtp-Source: AGHT+IH5BookJEY65PdeNkId1YqameYAPF4mf8+ugNLT298Scx7hdAz+EfFd5LyUYZ9yWkhk/+XRNw==
X-Received: by 2002:a05:6e02:506:b0:361:9727:7cbe with SMTP id d6-20020a056e02050600b0036197277cbemr1293077ils.117.1706096110011;
        Wed, 24 Jan 2024 03:35:10 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id c15-20020a63d50f000000b00578b8fab907sm11727820pgg.73.2024.01.24.03.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 03:35:09 -0800 (PST)
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
Subject: [v3 1/3] KVM: setup empty irq routing when create vm
Date: Wed, 24 Jan 2024 19:34:44 +0800
Message-Id: <20240124113446.2977003-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124113446.2977003-1-foxywang@tencent.com>
References: <20240124113446.2977003-1-foxywang@tencent.com>
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


