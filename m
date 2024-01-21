Return-Path: <kvm+bounces-6483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CEE8E83556F
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 12:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50D651F21115
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 11:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 956F937153;
	Sun, 21 Jan 2024 11:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPrt7HSL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8995B36B11;
	Sun, 21 Jan 2024 11:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705835887; cv=none; b=duplkFWTApnPqZpBbi32+ENmlSb7qkQY6amCtY+MHscdSpQ8QnRAA0f6kOOI54wJFgMFS5vLBnsxpz/3UvtnytzN/HCfMQtCqLtEGh5tINXh609hx2GhdKmXxOk8fIIHJMkzRTSJ7itUJ3OOWhH/6M4YboBONvoUmo4+DqUGdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705835887; c=relaxed/simple;
	bh=07zXkl9lHANOUcd6XR5gd9jmRvw8FKdC6Cb4j1ULJhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IgFZkNpW7dfvtn6SC4NxnLGxVv8xNzknY+Bl1XDn+zG3uWHuIAQNiShtrMVDMjQJtwV5DBYDPnQq3WT12SLiJXHEUzJy9qpWA629mb0sLPVzuQ40E1Pvv/nmfgzjcSz0a0dJKoPCxSLeTB9POvU9pvE9BAp//uMm9THFSceGjx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPrt7HSL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1d70696b6faso19999115ad.3;
        Sun, 21 Jan 2024 03:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705835886; x=1706440686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlzhCvasoAnbsRB+yzByHdWEGu1RCD7tTbBHyJB+Mp0=;
        b=ZPrt7HSLCLSRJCKFf32NYy2MD44Exp9YeKQIruVgzZAVcXHM6cPf/Ym0rKy53u/hVv
         lLLgXxAZxDVSRQ7VAcCBlEdO/HQPe29S2M6Z8UzNXcVWik43UyhgLuNl5gzMPi9qMmR6
         qAp1EKoCCjob5YZ0mGHUgZKFIjugkaeakZjHEJmN2xbFi1DQvgxpmYBXDHO+xfAdR9dY
         Z9ZSWIvj8wdTn0VhLzi7JnF5xjoBp5ixzq+bHisaKpV6r5LyrI9UZtX5E3015JgbAcOn
         YzYSSnpG+nB9YW6RcZMhp09HGCQ3HydlMS0/edewYx7MqJLdo/wc+jvBd7+CV2kEbsBF
         61rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705835886; x=1706440686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlzhCvasoAnbsRB+yzByHdWEGu1RCD7tTbBHyJB+Mp0=;
        b=tHTcabZokh+XYpRPGsG/VRF7NE/Ccr+aDax7erinP/6OX9AOqRLK4Dhy6jY5jMfEay
         pHswmWU84E6X+RpmptY6M7NqAet55/3C/Ax2ZcdzZAjiDcUeD8nNg238EWj0BkSYhQNJ
         JJhBDcdXGsQJePJ5f84R/uxlwPOSXsCrNS2QmJjGkRzu+/WH+FjVPOKae/cs9hYDOAla
         SH5SA5rnjmBRJKl3e9Q48wUWEe9isNf1jedQ114ijZxXh8WeweYj6XvPdqJrzAty6p0d
         JhVdHUgz1SDBYh4ZD7po9DVWZzNzZHFOifqPAIQ7ETAfrRC11Ov/ufmkhiE0+0rmqaz3
         ellg==
X-Gm-Message-State: AOJu0YwnXhLc8Zm0+ZeMpn8HDu4zdKdYDHUIDsy90zrEpSFdsKfu36FC
	64Qs7dM0yThQ09PJPM3CBjlZ4OJS3thwU49WaVmjB5965Dr/Ri1d
X-Google-Smtp-Source: AGHT+IGulDwiOuh73UoaA8hIZQHE2qu7m3gTR6eSQJpnGQ16IgoBL8sUFc95+rvsbtqjpQqxXE18nA==
X-Received: by 2002:a17:903:228c:b0:1d6:f185:f13b with SMTP id b12-20020a170903228c00b001d6f185f13bmr4014802plh.17.1705835885716;
        Sun, 21 Jan 2024 03:18:05 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3560255plb.221.2024.01.21.03.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 03:18:05 -0800 (PST)
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
Subject: [v2 1/4] KVM: irqchip: add setup empty irq routing function
Date: Sun, 21 Jan 2024 19:17:27 +0800
Message-Id: <20240121111730.262429-2-foxywang@tencent.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240121111730.262429-1-foxywang@tencent.com>
References: <20240121111730.262429-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new function to setup empty irq routing in kvm path, which
can be invoded in non-architecture-specific functions. The difference
compared to the kvm_setup_empty_irq_routing() is this function just
alloc the empty irq routing and does not need synchronize srcu, as
we will call it in kvm_create_vm().

This patch is a preparatory step for an upcoming patch to avoid
delay in KVM_CAP_SPLIT_IRQCHIP ioctl.

Signed-off-by: Yi Wang <foxywang@tencent.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/irqchip.c       | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

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
-- 
2.39.3


