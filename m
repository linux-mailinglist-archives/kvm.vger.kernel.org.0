Return-Path: <kvm+bounces-16016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 469DC8B2F5C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:16:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0D961F217DE
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 04:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E201A82C8E;
	Fri, 26 Apr 2024 04:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksN6WRSA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5F98288A;
	Fri, 26 Apr 2024 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104994; cv=none; b=mTK/71cSlp6xxcfIz4JgBNzo72MTd/AoG9Beu6Wr4MGFCJUj9WOCMT0gy24fQxBMK66c8GPnwQdADHTLQRFr2quR6zcYEmna+4pKLDHrDANvDwMzMkE03wGwZrAchnGneuWeLMOwZCTliZDpi8Qn/9jlUiftW3m9UPZrw2vWcCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104994; c=relaxed/simple;
	bh=JcKMXuYEQh40cczWYml11k2EtrXtg012AhMqdwi07Ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V2bAVXOcADiMHkW7uJ+U1LPHVB04yus/s65omlI6w+5EFlqk6BXcz3GiYzbxqugyQsXpOAkWuM2JS1i1u07MIteUiAn3uX1ePwR9VmyWFwWrd5nZW4yF4kQPZZlI/gIU++nDpGe9SJSDNUh2tgbOXrjiRkep2FEzGuDdGHlad4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksN6WRSA; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e3f17c6491so14612605ad.2;
        Thu, 25 Apr 2024 21:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714104992; x=1714709792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TghmkCSzFoqsw5QCAxEDwkPGZav8YlUmggnIBuM83cU=;
        b=ksN6WRSAiR+kqS5XcmNtvDHftjBW1ggqPRIRsnJlJDagsEXokHE/OrMhREvyxNPqKc
         NoGI43Xbwa7x3pqlSsFkC7IEbeUgy9Pr9gdTYJYOcj6eX6SLAgTQEZ/YtSJQTtYskAWZ
         fWsjlO/wvZM/+KlB/2zI3d7AsyAj6HTYEkhROySRzQ40yRnJrv0GMlhNbfGs7g43opjN
         1lfKlju9I9ZZbYcZvQ2WD5nxeGgotLr4dDYiJXSH1ShuNMqE13DSvGlm5GfZfKOJvIAm
         YDLECPiBfwaQqIWBmVE4WoemPhD4EP700TV6crm0qBoG8YuSAQOt8LzeJFEiPHNfpmZg
         n3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714104992; x=1714709792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TghmkCSzFoqsw5QCAxEDwkPGZav8YlUmggnIBuM83cU=;
        b=YSfXode6jhIMcm3iKPYzoVY5Msnn5iG5/pLg8wPaCstsfuBcIVNz0q1xHCv6eXyeUp
         nKHOQPBJ+79/FFEq6VOsU9H59Sab5kIz8mZ33WI+RAi1QvzIPp0ADguVUiZpXZIxQj3K
         8T5V6A8BSV7M31OMBo18BRpKuc95xtJuHMBjJAcVwINAY2WHRC3/4zjSRJ3PFZWHCOs8
         wiYh7SVRyDQyWZrAmJNvK9sRWSoiPltDYDNXhrcwUFSp0YtUJ71uk9rxcFXu0Kkc39xp
         hpdTszbuBhhnG3OOdZeXlvFMHf/m+qF5hCbgcii8EdPGsKN7PNKbgWagLCgLjxLvqYMO
         2Izg==
X-Forwarded-Encrypted: i=1; AJvYcCWMTSvAk3JKuI9Kx/8CRowGz0WpZdcZTPZCmxMCFJjeFzT0kEvmVanZNP4f7s4+r3k3qpL9s5ZAwvQsn7u07g3oaAlHvAy55b6UAZ6wweS1QWGhzRsTS/KynukWd0o8b07c
X-Gm-Message-State: AOJu0YwElDrXB0osDzd9gFECeV8fol7gCzJ+jWU9GdIvj2ZUfLLssc6Y
	ykczNukJ73grRW+Gc3wthVM94PQzQf4UGgOTbLw7ZCv7sCNCep3m
X-Google-Smtp-Source: AGHT+IEhA6D1ThaJJdeC1CSGAsZcA+jHq7zl+B7k5wz3ml29MUQ6uN9m56IeW/U9eyYoNpzicygfVA==
X-Received: by 2002:a17:902:784f:b0:1e2:a31e:2062 with SMTP id e15-20020a170902784f00b001e2a31e2062mr1547422pln.53.1714104991748;
        Thu, 25 Apr 2024 21:16:31 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902ec8d00b001e9684b0e07sm9426780plg.173.2024.04.25.21.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 21:16:31 -0700 (PDT)
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
Subject: [v4 RESEND 1/3] KVM: setup empty irq routing when create vm
Date: Fri, 26 Apr 2024 12:15:57 +0800
Message-Id: <20240426041559.3717884-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240426041559.3717884-1-foxywang@tencent.com>
References: <20240426041559.3717884-1-foxywang@tencent.com>
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
index 48f31dcd318a..9256539139ef 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2100,6 +2100,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
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
index ff0a20565f90..b5f4fa9d050d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1285,6 +1285,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
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


