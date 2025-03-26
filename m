Return-Path: <kvm+bounces-42030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB687A710E4
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 859631896170
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EC8E1A00F2;
	Wed, 26 Mar 2025 06:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Z9XvGCcy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B9019E97B
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972253; cv=none; b=Pf0aKFru4TfMc94d1U3rGxfT9W3rUBM5+KHekPyys0SwpZYUesc/ZfqOM9YIb5uItZh3ixzeJ7OAldPlGubf4o0rU57uFbjfY2yzyfC69L5n3c66UBV4INF9XC1ekULKKoo3Jxuv5wrK5nA86jOl/QTEPx3JIq5GIfd4WdVAteM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972253; c=relaxed/simple;
	bh=/O0tC6mRXrOzXpJaph015Cuf8VG9IzJRU936MY9fUts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LS6dHynfWeMS4MvuuIu3EcxDF9GfjJlLWV0g/89FwfRVUsuRSoJw4i4wTBIkc6dTHHIw9HJob7SGDS6TeeDLE4P9Ah6cigmUqtqwXc9p1l8UqvLzzxZYFYydJIjmp2Y97noe2RiE/IAqjg9hbz8jxv3crMZs1NOpFvO7WQxJTnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Z9XvGCcy; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2239c066347so150863995ad.2
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972251; x=1743577051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9MJWtrq1qUp0l6b4wtZQ9cCEUjd4ODyd9V5DXVU6+M=;
        b=Z9XvGCcyT6XHyBLHs9QisI65akhEbcwIA9SJRFcBsqC6h98/XYE/bgr4khVbpSyve5
         +kpPgMJeADCTL2Gn85Zm9LxcM6AKeiYY9N4Sp8N1W1pAl1n217/gsm/EI5jJ5SMQIK/3
         FZrJRRX7RRBGSe4x5AafF0JqWVEh2dp39EfI+FGQihWcUeq+2sbGDi4g9lzz/hC89Oy4
         uAXEH3jsFiiDM0jaH/HWevcSbvPelOk0mIucaMSlVuYrAkZ+nmpugzq5w2/BdY9D7bP0
         wLofNhfuzke9H7LUcZHcNSAodynhugKzpRZMqLqD7LokGcwq8eWvvY+ySNhTsEkLkzFi
         aAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972251; x=1743577051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a9MJWtrq1qUp0l6b4wtZQ9cCEUjd4ODyd9V5DXVU6+M=;
        b=U9te28x3/VuuQSaIfc48kAWXUAPpBc3yycYWfAafMeZo1gmmOx80EiMEa+o9bFTfm1
         FsUrPTbAz+ycjIeUYX1WSWw5cI7Y9nR3MNFwwRd3Ioo5ZtPh31ejRZQOsCcKG+v9gCAC
         7SCsYbHtAu/2ewxAM3xmMj/tYhSyFAoZE9p4v/f4M/8Rm0qqgfxcCxRKA4b5QkIj8vX1
         uPZ1Zw0JiLc85uGx9u5+7HoQdY4yVPPwrIoDzh0FLGN1kr2efRCW2dyRFsNnLLduWguv
         wOSDiKfKMY0stE1XlCm6FAyPMNQJm8VavUTSqARlgXdsIeXXQBk4BVM3aydOjwQT4C/n
         EuJA==
X-Forwarded-Encrypted: i=1; AJvYcCUgRsw8IrcuLvVKiXSUvcYuGmDpXRTbrTzl6Meeih1KmvEDACZ/qE+UZe2YFV9jFkm+PTI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+C8DxL3XF4omeNYTDXBreEwKRwHw0sjEjnPTJSnz5WTbd8KMV
	qKvuDrNJDQU/E9p1wSvAEx16s4lcIIvD2mi7ftxsh9I2ycHNqOSriV9uAKttTYg=
X-Gm-Gg: ASbGncutFYYw6XbhEdE2aVcuKdea3np6GrzhROzTJzPDJnw4QVSScuV+rnvT05J0VXy
	oQSy5bpKcjIy4/2RPLJazEzRkM3WCWaM7I2zbI/0tRde1smCutBnR2j0kfOhM8RsFO8faC2MHWj
	c+TcoInTu89X/a7QQU+Ubpi0p/fhbEoi+Apu4WwjCHevm/s/WbNcRy0nx1bt4VFxpbiEzTnWJB2
	MHq1bXWJM1DQeOarlHC3EnKFX9OF/UbTfBQB3pzl7A1kyItagCu4fXavKTqiz81xTg2RmD+4T08
	vl3drtSYwW8oPfTWq6gnbD+d3r9Lt4aGo0+Gajvlb0LBilFRmbdPUsVhj5VgrruLkncEosv8bLM
	towgz9w==
X-Google-Smtp-Source: AGHT+IHtVn85K2rMf1ncp6GOXVZX1zpl6C8lQ1pT3KexM1a5pSygx2xZpYwD5GQcLRPUNLPXhZQIyQ==
X-Received: by 2002:aa7:9317:0:b0:736:a682:deb8 with SMTP id d2e1a72fcca58-7390596685bmr36416962b3a.8.1742972251101;
        Tue, 25 Mar 2025 23:57:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:30 -0700 (PDT)
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
Subject: [kvmtool PATCH 10/10] riscv: Allow including extensions in the min CPU type using command-line
Date: Wed, 26 Mar 2025 12:26:44 +0530
Message-ID: <20250326065644.73765-11-apatel@ventanamicro.com>
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

It is useful to allow including extensions in the min CPU type on need
basis via command-line. To achieve this, parse extension names as comma
separated values appended to the "min" CPU type using command-line.

For example, to include Sstc and Ssaia in the min CPU type use
"--cpu-type min,sstc,ssaia" command-line option.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/fdt.c | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index 4c018c8..9cefd2f 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -108,6 +108,20 @@ static bool __isa_ext_warn_disable_failure(struct kvm *kvm, struct isa_ext_info
 	return true;
 }
 
+static void __min_cpu_include(const char *ext, size_t ext_len)
+{
+	struct isa_ext_info *info;
+	unsigned long i;
+
+	for (i = 0; i < ARRAY_SIZE(isa_info_arr); i++) {
+		info = &isa_info_arr[i];
+		if (strlen(info->name) != ext_len)
+			continue;
+		if (!strncmp(ext, info->name, ext_len))
+			info->min_cpu_included = true;
+	}
+}
+
 bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 {
 	struct isa_ext_info *info = NULL;
@@ -128,16 +142,39 @@ bool riscv__isa_extension_disabled(struct kvm *kvm, unsigned long isa_ext_id)
 int riscv__cpu_type_parser(const struct option *opt, const char *arg, int unset)
 {
 	struct kvm *kvm = opt->ptr;
+	const char *str, *nstr;
+	int len;
 
-	if ((strncmp(arg, "min", 3) && strncmp(arg, "max", 3)) || strlen(arg) != 3)
+	if ((strncmp(arg, "min", 3) || strlen(arg) < 3) &&
+	    (strncmp(arg, "max", 3) || strlen(arg) != 3))
 		die("Invalid CPU type %s\n", arg);
 
 	if (!strncmp(arg, "max", 3))
 		kvm->cfg.arch.cpu_type = "max";
 
-	if (!strncmp(arg, "min", 3))
+	if (!strncmp(arg, "min", 3)) {
 		kvm->cfg.arch.cpu_type = "min";
 
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
+				__min_cpu_include(str, len);
+				str += len;
+			}
+		}
+	}
+
 	return 0;
 }
 
-- 
2.43.0


