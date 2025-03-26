Return-Path: <kvm+bounces-42022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E55A710DD
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29070189618E
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49711993BD;
	Wed, 26 Mar 2025 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="pg77LMyp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B517578
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972224; cv=none; b=iB7BWPuy0u+Yezf3rCDKcR0MoH6LQZoygEpjDgq/YVv2dgRsMH4IyRJ1jj+cGvAwr6u1YZWSN6T3EWimsX2Roc3IRODeqIXjV+Izgw3z08ezvCF4OZ8QKRRJAGkJ8F4qZze0eFUatTvH5eTfy1Ww6BiqNgZUAW0WuTp+teP5jvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972224; c=relaxed/simple;
	bh=6N0Cm4zR6reotuM/+nFRO2EHr/VXcO/t2S4HsjKdpN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwevTs9trIFZqEbheOrdP7w6xQU9hJFuvcLHhuJX8tYIUbtxeadQNOWO6tZxxko1P25UE6i5PpiZKmlYCG3Spp7jCM6qEhwQS+suYkA9JbEyuuCZbG0b0Vu/l2W+jiFPj7OOPDU8iHemNEvNTig2LxwIqtzmX8Gp94ng2Dj5bJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=pg77LMyp; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224019ad9edso11273345ad.1
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972223; x=1743577023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UooB8pU0hhucKy0mJr1FYDYzWszgZ0h/AlN421rxqXg=;
        b=pg77LMyp9FGooSRDZUPYsKMQi725nLWP53lLzWwWG+LcVOTh4MafY/54g+Kkxk6FHN
         7zXYCmKR9PEqyV+E/d7YyQIPYdzNPKj5YPEa260ygs1HE1p/XPODbdG0v+9h9t4v1adY
         caGQZjeIuMcuWRkp83nWTg7LhFtPc3QQUGYuaB+47kWLUWt91ua0xdju5rQ7AuvF2yry
         QlSe37xoBXp8wkwqPzvghdk+jYGJCtgl8ZpWPAGSmJqLv4/d0vlRZRyi0v2pX1Z3QQLT
         suVC0DGbkvlGjg5OH+U4GD795csXEdAMPmxz41Hjo+qZXPvtIU6HXYIPRT8CriKfcH9M
         vSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972223; x=1743577023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UooB8pU0hhucKy0mJr1FYDYzWszgZ0h/AlN421rxqXg=;
        b=knVplYM5z639WIlyRb0tUG6eTkPWHeC22mjCR0wsTKnm4oAS7vBiXuRmXSFqas9zhH
         wpJrj++DSOeLyVKYW9r0d9/hGVFP+9y+aWELfcT/WBV+lVx4fJJz6vCv65Ms/zcbp9QV
         4NZjql3yg/mP7iCJH/3lpeY4RMU7IXyRYQvYUsbRbSA/x4xYg+H+vNZMBIE6ujX9Bum0
         bmQgEM2w+WItSOlropgedEZW8M9E0n3eIq4atdyVaKY5zYpvTwDvhO52H+/dS4/tuowk
         ZZmheB3Qz+3aFS16xllYdpb+HQtT/xxvCNe6YQZ0OWn//YThANAGRZb/6q2FY3N/2JUT
         77ew==
X-Forwarded-Encrypted: i=1; AJvYcCWPwWH5KA/kMJQ0qA/8kTfDYjcoyfGvW7IAiX5XSFDfAI0xvR27XUUvguYh281B7EO4Plw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOZ2CGwc/4rH4sJ5qUznqmsPGTCPbARnkpeuGpZVk4JYjfTC9N
	RDuy/q/34nyYN+2jJOHwqvxw9j4WKvElKXJp1QpQmSeGc9mqBKqVFhjoJzuyDP4=
X-Gm-Gg: ASbGncvHAKx7CVO9CJdjRRFnklLw20ChUStETpg4mjzIkeeZEVZhdXfnm4ebHokai8H
	wF9CleUagSKpoEyDhgf5JqORfaY/1uNxVAOWYTFK8gzE+q99olB9bEwOrSH0tBMYqAPo0SdEDfe
	02K3KP1q3RBV8rFhNVVjWszMVWjj0HdiToTxW5HclqgibZQ5cEUzI7gOXV8zw9+Yhv6IZS+mDpg
	op63buyqxhjsxpCmZkS4zmM6ZrUC9OTK/1y2fJlf1oYOO46lx+UHoGBKSg37Ocr7kC7JQaX1QwE
	MQZUJs4orYO/11yBjKvgMWhbpjRZPNq4ZEeMSKPF/I6FY+CpPA8GIqEy5wRI2KWG9DhRs8hVGoT
	jdfoDkQ==
X-Google-Smtp-Source: AGHT+IHZmBlLXo15HqLzfG6n0+JX79YNp/9EDbe78slX6ySDdiXIBZcPfCN/KQ2Rjg3+CfilLku8JQ==
X-Received: by 2002:a05:6a00:e13:b0:736:fff2:99b with SMTP id d2e1a72fcca58-73905a530b6mr30985680b3a.23.1742972222684;
        Tue, 25 Mar 2025 23:57:02 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:02 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 02/10] riscv: Add Svvptc extension support
Date: Wed, 26 Mar 2025 12:26:36 +0530
Message-ID: <20250326065644.73765-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Svvptc extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 03113cc..c1e688d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -27,6 +27,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"svinval", KVM_RISCV_ISA_EXT_SVINVAL},
 	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
 	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
+	{"svvptc", KVM_RISCV_ISA_EXT_SVVPTC},
 	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
 	{"zawrs", KVM_RISCV_ISA_EXT_ZAWRS},
 	{"zba", KVM_RISCV_ISA_EXT_ZBA},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index e56610b..ae01e14 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -58,6 +58,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-svpbmt",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVPBMT],	\
 		    "Disable Svpbmt Extension"),			\
+	OPT_BOOLEAN('\0', "disable-svvptc",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_SVVPTC],	\
+		    "Disable Svvptc Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zacas",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
 		    "Disable Zacas Extension"),				\
-- 
2.43.0


