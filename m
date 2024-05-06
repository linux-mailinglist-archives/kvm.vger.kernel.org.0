Return-Path: <kvm+bounces-16712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC0E8BCBCD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A90D01F23525
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E69914291A;
	Mon,  6 May 2024 10:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjN6Tqlc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21756142652;
	Mon,  6 May 2024 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714990710; cv=none; b=l6Y3OOmvaVaS7Q/9rENPh+XTw5SWrk/c2z2i39u5gAVPD8zDVLe3RcigWPwJ1bO2Vnhn2rlfeCtS4lL6CUGtA+D5EnstorxjO/xIrjjSzT7eF8XrwMrMNCxKe24DnJiTPG8NV+3Ve9KKmxj57v7E7mrdg+yOMkENQCeTtYHdGiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714990710; c=relaxed/simple;
	bh=2SV8hvvR18gCursA15Qb0T+vbllKSA4vn8ie5U+muzs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q3Fm3t85oqCSKgQDszZ7vif1EnCULtNr0wSHI4lKRSqEnuMXOTmjuVunrAOsLcp+J5i//1aamv0Wvm7i8DPTmFVd89/mwPl2Pio54LeP0j4ZfTsh5lBj7ZieW5nrOQct44HdeoQyam+4sUU/hkgmK/ceDQ45/jQXxKgq/DKOLBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjN6Tqlc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ad8fb779d2so1321097a91.0;
        Mon, 06 May 2024 03:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714990708; x=1715595508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9bizzlFKkW+X7zXOFueofhPZfnb9FC5f94YiJnWK6U=;
        b=UjN6TqlcBBo7Rd0ekgyugyKUeQngHmxFq+vqly5fqIpTXipi9WdhDGnZPfNq4OVNLa
         0f34SoxxGZMHKgg5iTo0Hxf/NkvMK6lUUaw0lSv6lX9/LaUu+q78gRwLHPGBzEq3xEaT
         07qbVikjERXaA36vOx1G8KP/ErT7JkLfrHnKgdj1YgUR9CKOKrloqZXxGQTuEwZv1285
         NGJkjOQctjon/YvIPGOQlzIpS9aZUTz25M70PokT+fz1FeVG04tRiakuUzzE6LYeFZQI
         yYjz51a4ojGX87+Z/yoHw5fSPg30wSLyCwdMo4xp4Npvm3pkWLNxxkBT0rGx7xmakv0F
         AxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714990708; x=1715595508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9bizzlFKkW+X7zXOFueofhPZfnb9FC5f94YiJnWK6U=;
        b=AMLnDpJJdW1nEjWuCbrUMMGHxTePTQF8Lnclh05R45pJYhfH+gQcorFpcMWmggrLRG
         4OK4GeFAJwXci17dxVbLitkuGATzs+elZ7JT1y3gZKPEOASA5J7mOBtWDLO4JDddSSjA
         RMog75IVtT46kiWnIQWUBh4ryaak6XTemulAP3mrtYR/ojURg5VlqfOO3X+ULDJUK1Ek
         2h4xnB+YVNd10k4IYwWOItAru2Hl8ry5GkDOaNtdPY+5W2sFhOJqVKmtVnlLKEAS2gei
         gU3oR2n6gBdwt6GgoXwFgltprkn9WwAfbLd+C6E6nZ8OeP8aP3pvNJ37JSb6uoZplk5z
         LWjg==
X-Forwarded-Encrypted: i=1; AJvYcCXpUu88jWf1spA4Z45p7XBDirKX/gcP4lnszHDVxZEaSrKjbRso9S8FYgAJ4fvvbNNP+b//zboRBAI7btZJPcW8r8eqVxpg8lq0oQfXDOos9wCvijdDJE7bdigPv4X0NhuE
X-Gm-Message-State: AOJu0Yy7DnHaWNgAujcEKNxWZt3zhgoUp0mqY/xgfKYKW38kkfk3J35R
	KlPGdqrycI42L/P32qSvNcULPeby9hsOvfkwakxkuTPUANbG9uRx
X-Google-Smtp-Source: AGHT+IFquGoUNfMy6p5hJLXHS/bcYf20+a142u6IzKcRp9f37VGywJyIGJYHuvCO0lsZEarpxaKoKQ==
X-Received: by 2002:a17:90a:f597:b0:2b0:e2cf:118b with SMTP id ct23-20020a17090af59700b002b0e2cf118bmr7460458pjb.33.1714990708372;
        Mon, 06 May 2024 03:18:28 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id co18-20020a17090afe9200b002af8f746f28sm9747820pjb.14.2024.05.06.03.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 03:18:28 -0700 (PDT)
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
Subject: [v5 1/3] KVM: setup empty irq routing when create vm
Date: Mon,  6 May 2024 18:17:49 +0800
Message-Id: <20240506101751.3145407-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240506101751.3145407-1-foxywang@tencent.com>
References: <20240506101751.3145407-1-foxywang@tencent.com>
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
 include/linux/kvm_host.h |  2 ++
 virt/kvm/irqchip.c       | 23 +++++++++++++++++++++++
 virt/kvm/kvm_main.c      |  9 ++++++++-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 48f31dcd318a..a5f12b667ca5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2100,6 +2100,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 			const struct kvm_irq_routing_entry *entries,
 			unsigned nr,
 			unsigned flags);
+int kvm_init_irq_routing(struct kvm *kvm);
 int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue);
@@ -2108,6 +2109,7 @@ void kvm_free_irq_routing(struct kvm *kvm);
 #else
 
 static inline void kvm_free_irq_routing(struct kvm *kvm) {}
+int kvm_init_irq_routing(struct kvm *kvm) {}
 
 #endif
 
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..ec1fda7fffea 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -237,3 +237,26 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	return r;
 }
+
+/*
+ * Alloc empty irq routing.
+ * Called only during vm creation, because we don't synchronize_srcu here.
+ */
+int kvm_init_irq_routing(struct kvm *kvm)
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
index ff0a20565f90..4100ebdd14fe 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1233,6 +1233,11 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 		goto out_err_no_irq_srcu;
 
 	refcount_set(&kvm->users_count, 1);
+
+	r = kvm_init_irq_routing(kvm);
+	if (r)
+		goto out_err_no_irq_routing;
+
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		for (j = 0; j < 2; j++) {
 			slots = &kvm->__memslots[i][j];
@@ -1308,9 +1313,11 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_disable:
 	kvm_arch_destroy_vm(kvm);
 out_err_no_arch_destroy_vm:
-	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
+	kvm_free_irq_routing(kvm);
+out_err_no_irq_routing:
+	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	cleanup_srcu_struct(&kvm->irq_srcu);
 out_err_no_irq_srcu:
 	cleanup_srcu_struct(&kvm->srcu);
-- 
2.39.3


