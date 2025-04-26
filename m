Return-Path: <kvm+bounces-44410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7166A9DA50
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B0AD27B2EC9
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10DC5229B1E;
	Sat, 26 Apr 2025 11:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="liX3lWOI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67CC227581
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665488; cv=none; b=hXaZjyiEn85M0lQyuah0bVf5c9YyC9O9JesO2p391LFNp7A+DyddkVfs6dHNjn1jJV8rZHcyZWcSlBNuGMUesGH3OAgUKcsXacnXHisJaQG0WMOUhDgDSEXSs3nXhvWU3ASgLf0wE/pawmMiXJpnjmkeckvbF/0SD83LFjqXA7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665488; c=relaxed/simple;
	bh=cE/BclE69jkGkB8Xo44ZW98QODxswPea4TUBaugLP04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR1gKAM4uu5x0mq+yrL+qSDzY0sjQDNDVRYenfl8S2RaAV71Cvqtpg6m92WLukXxCJwWn76PXDztp2HPxv/VDbfpFH+mUGrEEgm78ZpbFWHVNIZ6Ty2obHk2LPJgogkd3oifM0zhrTrx0JQC/PhoEGXNrO/SoBXDWy4KNpwS/SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=liX3lWOI; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22928d629faso34287545ad.3
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665485; x=1746270285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V40WzE6Kx2dhNRCs8XzWAC2em3IawzSsYuCzNJ6Nkfo=;
        b=liX3lWOIYXkW3an2kv8wa/sO6qllUqcp+L1nmOWExL1z+9a/rsXJLONkl0z2hYJOgB
         5Xsd7mbOBLoYaUAx9ysopSYBOAjXwfwN2l7PYKxQ87ybE3byE5OvUy0+mWmZg68T+x9o
         V4/Ps/C9c/UvfvlYJTYHZF3PC7tvgEWAtZu+T1efBp7V4DogZjHAOQ/DzTvWpdhoJu2t
         mOsRZ/Qjye7hfWaaSjaJp19vTAlQVdrd2zpbhDC9xTF8dvRBogo12zw50cGxEZUHGWV5
         3YnS51yxBdKQ0NgjxPvtYg4b8J4lmxO9isu3lEyXKPSDnr7alVpYFBsjIDVkjbgVNMDK
         0dkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665485; x=1746270285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V40WzE6Kx2dhNRCs8XzWAC2em3IawzSsYuCzNJ6Nkfo=;
        b=Lc2La2eFoWYjnVbZjFhDmdev6d6TQsLZbwwm5sgTJGxJAQpWeywsRLgRrFCEFySLjb
         j1Ysk5BQrm7as53FWNx5x8osgZ4XVz6ApJ89lWAehGjzbfQC19y8MAlOo5zKHdGQd1AZ
         YIrMDV22YmKGggr/YGb8tYM08sx1dpAn7zGA/iiU0B6UF9bBRsfk5otz9jRHGmXIRDXz
         bIONpA49+kbjrvjFX2mNnMitrK/Wm1uSMQn2fDlm9KKS/+3MSMBFyDPvebtkvLJM1hzJ
         KPAvOZ0eCn1xs4S2BC25+tucUFbln4TBNsAZOA/mWa/2mCfTY7WciHG4VQzmtVtMN4fi
         ulew==
X-Forwarded-Encrypted: i=1; AJvYcCU/3HkUdUft3ZY1NhnVa4+iZwZ+YGVfz3ytyn1M/hQ6pad9q4SDZRjHD53GfjVvc248KiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdq0nk9tAiMMba+J1o3pW4kUA3UUj3NRFdu1zCdvt01owBzMB+
	yJJ+PG8f/omUZSCW84CkrYmD5QIN8axWa6E1JzV8e9ScBhYTWFlxh1OlQgSFBSs=
X-Gm-Gg: ASbGncuX82qO2rHUMTMHxVWcAYRpAMAKaV2EHGzzzJTbBDXdcuocyTOtxH4ZUzrUL6p
	ESE0P4L2HE+TyI2az1QqSsmNQRIGWmYJOZlJbEXGc/TfZwfZcBahTSQ2uRxguoFwwsdOApsOKLB
	5LU2EZxNrnXjjJUfnQcbmilqJc8A+2KYGjfSVSEwxL3OAPHmljVcTqi9hi2tcDZYQeTWBtgM3rc
	/Fyr1A+BlXl/XClpgpkE801+RmrfyBJqgjQqAunVoghmk7JG1TN9eMseV/N1x/Hk5s25FMQvH6O
	cSYnzXMAej5CP0chDSLh1ey3eTX577TMJJ8MrxCafhm+Js4eaY/w+02yJX01OjGu35s92AMoO2c
	17/Fq
X-Google-Smtp-Source: AGHT+IFhfibcfS/FIRj5KH+yFHw8fRjuopSQjWjkxth0IJofxdk0cqXcNQ+Jd1oAYGO+GJArJf0DJg==
X-Received: by 2002:a17:903:3d04:b0:223:4816:3e9e with SMTP id d9443c01a7336-22dbf5eb6f6mr72855205ad.13.1745665484937;
        Sat, 26 Apr 2025 04:04:44 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:44 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 10/10] riscv: Allow including extensions in the min CPU type using command-line
Date: Sat, 26 Apr 2025 16:33:47 +0530
Message-ID: <20250426110348.338114-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is useful to allow including extensions in the min CPU type on need
basis via command-line. To achieve this, parse extension names as comma
separated values appended to the "min" CPU type using command-line.

For example, to include Sstc and Ssaia in the min CPU type use
"--cpu-type min,sstc,ssaia" command-line option.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/fdt.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index abb6557..eba9387 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info
 	return true;
 }
 
+static void __min_enable(const char *ext, size_t ext_len)
+{
+	struct isa_ext_info *info;
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
+		info = &isa_info_arr[i];
+		if (strlen(info->name) != ext_len)
+			continue;
+		if (!strncmp(ext, info->name, ext_len))
+			info->min_enabled = true;
+	}
+}
+
 bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 {
 	struct isa_ext_info *info = NULL;
@@ -128,15 +142,37 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
 {
 	struct kvm *kvm = opt->ptr;
+	const char *str, *nstr;
+	int len;
 
-	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
+	if (strncmp(arg, "min", 3) && (strncmp(arg, "max", 3) || strlen(arg) != 3))
 		die("Invalid CPU type %s\n", arg);
 
-	if (!strcmp(arg, "max"))
+	if (!strcmp(arg, "max")) {
 		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MAX;
-	else
+	} else {
 		kvm->cfg.arch.cpu_type = RISCV__CPU_TYPE_MIN;
 
+		str = arg;
+		str += 3;
+		while (*str) {
+			if (*str == ',') {
+				str++;
+				continue;
+			}
+
+			nstr = strchr(str, ',');
+			if (!nstr)
+				nstr = str + strlen(str);
+
+			len = nstr - str;
+			if (len) {
+				__min_enable(str, len);
+				str += len;
+			}
+		}
+	}
+
 	return 0;
 }
 
-- 
2.43.0


