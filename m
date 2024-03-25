Return-Path: <kvm+bounces-12600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9FF88B353
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E425ACE1295
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 17:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D8374C14;
	Mon, 25 Mar 2024 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZsFzR4JC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117C74C04
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711380742; cv=none; b=dBSm4Lr/K4dptzmnjhB8xyEPJqqUp9KSuWMkyYVWWypN6ADFKbD07y00pkTsuTGxv3ZYUDZFSRK1E+JO2fgs0QxJtuUCa/Zeqp+9LlrCjZIJGfMznUowEZMc/ZzTp+j4bDiwGXYN2EWvkkG3POAZZfB6O9mFGlKBttRDo59Bsw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711380742; c=relaxed/simple;
	bh=DP1EWV+DaTZClNbTiC14/4ATSw1RqTbtY2Q8DvhB4vo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gLDWGRjuG4yR1h0hQycXP6ZRYDi/SMs4ljgLUDM+8jvP9SKAgAp9egQOf2RmwU5UY7YAe6LXeWKwRpdsh5ZPtXn3FQDCOb+LFa7iQSoHGaJhjXPgAAsGLzUYH02kFyLrPK9HlTgbNMdB5+iFXm/XdVVTJDWFN7q/3RtRIN1He50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZsFzR4JC; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1e0ae065d24so12301835ad.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711380740; x=1711985540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFm9NQGP0DUDEjsrEvI+7wvK/uTDrnrNenXusq6GWmA=;
        b=ZsFzR4JCJrg5/R9gEjoDXXQ62mA61+eo6xHMR5mu4aQ6AyA7wBfB5s6EwYHzFMjxSz
         jDDYJ2O+UjWTrVP7Q0cg75Wm2CZFla9ilOFKe+kLHTjlNMtGNRfXHH6IQXMv+rU1Y18g
         TirARr+28KjVhOE2Qlf7/u+G6ZkfMUUmPRbV4hTKtZ9TVGcX2EdYFA8e8ngkW+e0vG50
         qozRzr/3cxXl2bVtP0FCm+wEzi6KKndv71RSWEHtj5qCKV0ZxWpzKyONxbIO8dswdCZ1
         5X9NaJMuxRw1eq0VLTT4ZsgCNEfMymRumndET0urpQzLl5tReQF+4rorGoujpnV4GtJw
         tMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711380740; x=1711985540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFm9NQGP0DUDEjsrEvI+7wvK/uTDrnrNenXusq6GWmA=;
        b=Fm4AdiyuNnafEeI1oi6woDekkU3LnunVdsQD7QcszJ1sOc/M3DH+X7VZZJf1cc3Gi+
         5zHl4hgpq1++3k599Vz8jAOFPFSQbLfXbUL2Dh8fLNIvivdoAFQr9YdxMBfCkhjbWoSb
         JiAqxeWR3+EnEtF03zv3SReHcpSB9LzgRad9Nk8OwGLBzYyzLmRrwiCpFxGdaSJ9+7IB
         43I27t4K8VB4fxPBAGZllSZT1LHjrt4u+s88yn1Q/HfjD0+bO2w4oK92vxfh5a0cPNc+
         AP8CgJJRlbsXXFAuvHJMa4Y5Pudv1Y55sB4JeLzCAkFzVkY/gkqErSA7aNKU8TNJphsW
         l0+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXlXwL8x6j51GKUASb5WMRVba7pC2fwDrlCrOXM6aDpA5P937oMPRE1F4hzDn9VIzG6A6D1aWib8Rt9Cp/TjN8irRPm
X-Gm-Message-State: AOJu0Yw4AikQMExaWgrgU4IjF21nrRnwQJagnCrEHUPyWd9qYCrCHhBB
	9gl44TNtFD+rgfmBglerQJXItbH6S57c7TFJyJfNH5QIjXrg8L8KChD7RZauJR8=
X-Google-Smtp-Source: AGHT+IHKz7diJGkynNyYXC1BSf/dtkbZPeikB0qGgp1b90pjrujts/88PI8LBaP8ykyhNRL+Y02FNQ==
X-Received: by 2002:a17:902:f687:b0:1e0:b87f:beb4 with SMTP id l7-20020a170902f68700b001e0b87fbeb4mr3914639plg.30.1711380740385;
        Mon, 25 Mar 2024 08:32:20 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.87.36])
        by smtp.gmail.com with ESMTPSA id u11-20020a170902e80b00b001dd0d090954sm4789044plg.269.2024.03.25.08.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 08:32:19 -0700 (PDT)
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
Subject: [kvmtool PATCH v2 07/10] riscv: Add Zihintntl extension support
Date: Mon, 25 Mar 2024 21:01:38 +0530
Message-Id: <20240325153141.6816-8-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240325153141.6816-1-apatel@ventanamicro.com>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zihintntl extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 7687624..80e045d 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -37,6 +37,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zicond", KVM_RISCV_ISA_EXT_ZICOND},
 	{"zicsr", KVM_RISCV_ISA_EXT_ZICSR},
 	{"zifencei", KVM_RISCV_ISA_EXT_ZIFENCEI},
+	{"zihintntl", KVM_RISCV_ISA_EXT_ZIHINTNTL},
 	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
 	{"zihpm", KVM_RISCV_ISA_EXT_ZIHPM},
 	{"zknd", KVM_RISCV_ISA_EXT_ZKND},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index f1ac56b..2935c01 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -88,6 +88,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zifencei",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIFENCEI],	\
 		    "Disable Zifencei Extension"),			\
+	OPT_BOOLEAN('\0', "disable-zihintntl",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTNTL],	\
+		    "Disable Zihintntl Extension"),			\
 	OPT_BOOLEAN('\0', "disable-zihintpause",			\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZIHINTPAUSE],\
 		    "Disable Zihintpause Extension"),			\
-- 
2.34.1


