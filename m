Return-Path: <kvm+bounces-11532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F8A877F04
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B72A61F21B6B
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 11:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087983C46B;
	Mon, 11 Mar 2024 11:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HRDUfDxo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E4C3C060;
	Mon, 11 Mar 2024 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710156749; cv=none; b=H62YwAienSYJM+otymqk3GmG9LGzo7I7kF/oMafxtWMzunYKHQmtlKghXplUkIJB3lOT4UqjOujdiOM3gn8cFSuCItjcxg6riSQ0tE5eT8p9EMvmGng48po1vYIOsAxZNacVacqLwsA9MsVGNhP7Qx1gJKk5u2LUgzmhqbOK7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710156749; c=relaxed/simple;
	bh=Vn20qf9DTQQMe11ASxaeaffQv1ZREW+W1V6XsP9x5+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tCcyNJ56T31VF19FrLNGWyA+4wExIrk8x8puH4zdMU0xKNuf4Wik+3mBVsZYywzE3L87vWE6kXHHBBR900MOttvn1ynpWkJz1IQwoEiXRDXQhfNdYsnKpJYibRU1BXaHhOdHrVUBoRi+Cpj0yX9xmOHNHNQYhWeNOImIeEA1/DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HRDUfDxo; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dc49b00bdbso20790985ad.3;
        Mon, 11 Mar 2024 04:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710156746; x=1710761546; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjSnYXhojEHyw3NBSZoX4ixUMbShZw6w9glZGeYbmK8=;
        b=HRDUfDxocMjCQeAUDLD3Zg2Yrl4mlSCoqCa804fr3ikG2efZeaXyYtFnQKVXtCACVf
         RJ6PFWwOTAisOfiUw6f5Rg5sVV9lveocPRfV1OWz3aBvD2Uj5IUbIeqyZNvLqFOtJfEn
         icRgDdEWVUs+U4v7YMvd/y5+i8gUYtUdCB5Ukdc1Nb+U4aO0na3WDSQWcWnDM96kahL5
         RiTmjm+xVf++S2Pv/N/8XtSH4iQ5WblrLERMzu3OUIHcrOPFGK07+Zjf5cgtpUGglnyF
         Vx0/zeilgdgBYD9GjqtKInnlOTVxhelofdf5c+dscoNf6EV0sTS4cOpq4DLk9Govuajx
         d7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710156746; x=1710761546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjSnYXhojEHyw3NBSZoX4ixUMbShZw6w9glZGeYbmK8=;
        b=YtSQzPrH7o+z496SOujD6IAijE+qK4+ha1lnUOGUlcuaVdIO9CXpESKUmvIRrYdOD/
         agh70WhYnhDJbKBhgkE7lReQ9XKO85I43kJXjiNoG435Gq9y+U3T3xlQsLZrAhn0CjFB
         0xBjUgM6IrIvqH43pphEKd7d3JQO1LlCPUQDtcAz++xt2RY3vcYyJEhBCPbKitGTuHRh
         qLNbhmFz4KEReKfYBxWX/tSAiHza97JnhcCffqAPcogKQ9wNuSHqyDen6O30d2oie+Jd
         B6YSGRpRyGFRfCHTXTuxIVRUh7De11eVSeY2oSEiPsEH5015QqnFZ8w7q4+Q7Yrn7oWT
         MUqw==
X-Forwarded-Encrypted: i=1; AJvYcCXU2NN+xCK2j6JGDYWVAtmrhoYGQQ3he8oq8rYcpJ7I+3vfUtrIkAUk5O3g8vn0kGog+4N+7H3dc0sXI8SbIyq1lkVt8DKLLkMVl9YOPraBxjthN2CKyvayxzLk3qRSmHV+
X-Gm-Message-State: AOJu0YwYUo6+kdCBh8OmOAeteAZr1T3JoI6ovZHIJLV0IwKeB0DRL8sy
	Rj12BQUt6rng82r32E8LiEU/1e3Bn0foNM7lDIVSXy50LtA0NWCU
X-Google-Smtp-Source: AGHT+IHVfRE7UleLmkQLh7mAeEFfyKcvUlTHcQ48EapDUyPc/oP0F8DAhV1UsEbnp4Mf+Hp24t0KWQ==
X-Received: by 2002:a17:902:7403:b0:1d9:7095:7e3c with SMTP id g3-20020a170902740300b001d970957e3cmr5513986pll.57.1710156746275;
        Mon, 11 Mar 2024 04:32:26 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id u3-20020a170902e5c300b001dda32430b3sm1459042plf.89.2024.03.11.04.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 04:32:26 -0700 (PDT)
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
	imbrenda@linux.ibm.com,
	weijiang.yang@intel.com
Cc: up2wing@gmail.com
Subject: [v4 1/3] KVM: setup empty irq routing when create vm
Date: Mon, 11 Mar 2024 19:31:44 +0800
Message-Id: <20240311113146.997631-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240311113146.997631-1-foxywang@tencent.com>
References: <20240311113146.997631-1-foxywang@tencent.com>
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
index 179df96b20f8..48b5d7fc108d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2068,6 +2068,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *entries,
 			unsigned nr,
 			unsigned flags);
+int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm);
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue);
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..266bab99a8a8 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -237,3 +237,22 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	return r;
 }
+
+int kvm_setup_empty_irq_routing_lockless(struct kvm *kvm)
+{
+	struct kvm_irq_routing_table *new;
+	int chip_size;
+
+	new = kzalloc(struct_size(new, map, 1), GFP_KERNEL_ACCOUNT);
+	if (!new)
+		return -ENOMEM;
+
+	new->nr_rt_entries = 1;
+
+	chip_size = sizeof(int) * KVM_NR_IRQCHIPS * KVM_IRQCHIP_NUM_PINS;
+	memset(new->chip, -1, chip_size);
+
+	RCU_INIT_POINTER(kvm->irq_routing, new);
+
+	return 0;
+}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f50960b0e3a..3438d6aa0f23 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1288,6 +1288,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
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


