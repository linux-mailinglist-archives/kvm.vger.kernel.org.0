Return-Path: <kvm+bounces-25624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 180D7967142
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 13:28:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D18A8282D8A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 11:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB7D17DFFB;
	Sat, 31 Aug 2024 11:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kXIsS+xC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C70917DFF5
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 11:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725103697; cv=none; b=AKTRI4cvuLjOjcKBvVL7RixH9ks5WwTVEUrzGoT2EtX05xZqbQZcN+Cc7Uwc4tJ5ZMnI96tmX+fhcpVxKae/5eEbqjKGmYKHTWr+Pd27/CUT7pxBZMgLy5WJGSA0mQA/TGT4X7b0pGZ2wYTlGXsCKRB2q0GZKoCEX9O+32bRsh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725103697; c=relaxed/simple;
	bh=GnxgynmvUgyIqjlMIaCajHTOkjPUbB3pBslWEwlNhY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYL7KRro7oCRHIpTmmm6rjov83fGZcwgTwN+iIP/kCSx6o7TDRo6K1j5P51SlksdxPxHWHf5wUt/D/Z6zOtPqoO70KOgeTSLQeOu4LKplvmHo1+amAfUT81W0LuvWlyRVRIvBDsHHVsFe2SU7lmTh3MtPIw6TWtj/Ja6NUd8z8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kXIsS+xC; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2053525bd90so8838115ad.0
        for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 04:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1725103695; x=1725708495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXdSRSEmTvo6sMNXYdaHKPgibvgWAOri4J2oivTeXtU=;
        b=kXIsS+xCV7aHYpZM/y4bl7J8AxZzNvAaWMhqV4EWNILVVnnOXEb6rl6YNIue0y4pbI
         SDbOK6+riVDSeGNDADGi0r96PYYnCGLwDHkUWxp7541Wrp20wBK01+pb6k7+bKprw94n
         5RK8DvdeMQgE+TWE9o51gRmyin31XsEWtehiTF9TOW72zKD0A+8V+3uzNYRt5YSU4EyD
         sBRt4jMctHUSVLmeEt1+0cETYI4kh/YFiCxoLPgVulQM4YG7bG+rHwy1vX7j8LHVnCpE
         79yrXgm0qjyYKW4MceY5ID8Kc/BQc6QmmKbtNQWkxi+0fe1w5eLz0c24gfxu4xham433
         Kemg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725103695; x=1725708495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXdSRSEmTvo6sMNXYdaHKPgibvgWAOri4J2oivTeXtU=;
        b=jw0H/ineXmQjraQXyepJ7MGmWIAiKxad7t3m+Ujn+LiYAeZPyzkTIL3lAdNzpzKqmG
         PNHxC6U6ugv4K1AhKKRG0LdkNQaZVjn29NK/2zw8V45F6aBYVXS4itC+j/z0SDGwmd0O
         cjx3fqxqTpjxPquMkMox1TbexdqrHcafUGTB77CSLMoJnQ6uUO/zYq1+89wo+sWroztV
         Hc1H4JWzrutxIz3iTIYGX1X+/PuXlf+B/RqWAAFk2fPN08+Q32xnk3s0IXPbtIL0TfIF
         AvVaqYbNHCzvSnhQhNmwu+pPOZKN47PPngSnK54CjKL79AbDoZWcbUdKf+TawxlGjv3v
         GMag==
X-Forwarded-Encrypted: i=1; AJvYcCXUJ5VpG0lGb2v/RYUa8xWA+M3HSwD51ECPUgAKwy5VkNl1f6cR2J64l9yaIZnRTFPeKds=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtatjsfJ5eFSQOq3QpS8YkdMtzagHVXVTaUchU7dXUrQIqTYsA
	69rUMg9gkr3h/P2DtrhwtFOadKdSp7jUpJup1cEcW6n1L3I0zUvo9mFyf94ZDfE=
X-Google-Smtp-Source: AGHT+IGBQF/RklUqRdEy3O8AxYUqet69JKdRJE18Ux3VuXiVLZkLiHhukunLvYx/vAWNbtRyNXDMvA==
X-Received: by 2002:a17:902:f34c:b0:202:190e:2adb with SMTP id d9443c01a7336-2054bd15aa9mr7563845ad.36.1725103695192;
        Sat, 31 Aug 2024 04:28:15 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20542d5d1b2sm11934415ad.36.2024.08.31.04.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2024 04:28:14 -0700 (PDT)
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
Subject: [kvmtool PATCH 4/8] riscv: Add Zcb extension support
Date: Sat, 31 Aug 2024 16:57:39 +0530
Message-ID: <20240831112743.379709-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240831112743.379709-1-apatel@ventanamicro.com>
References: <20240831112743.379709-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the Zcb extension is available expose it to the guest
via device tree so that guest can use it.

Signed-off-by: Anup Patel Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c                         | 1 +
 riscv/include/kvm/kvm-config-arch.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 4fe4583..c62d4a3 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -33,6 +33,7 @@ struct isa_ext_info isa_info_arr[] = {
 	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
 	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
 	{"zca", KVM_RISCV_ISA_EXT_ZCA},
+	{"zcb", KVM_RISCV_ISA_EXT_ZCB},
 	{"zfa", KVM_RISCV_ISA_EXT_ZFA},
 	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
 	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 40679ef..68fc47c 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -76,6 +76,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-zca",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCA],	\
 		    "Disable Zca Extension"),				\
+	OPT_BOOLEAN('\0', "disable-zcb",				\
+		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZCB],	\
+		    "Disable Zcb Extension"),				\
 	OPT_BOOLEAN('\0', "disable-zfa",				\
 		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFA],	\
 		    "Disable Zfa Extension"),				\
-- 
2.43.0


