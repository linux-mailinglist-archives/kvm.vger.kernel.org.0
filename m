Return-Path: <kvm+bounces-19166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 17ADB901F2F
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:22:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 306241C213E9
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEB27E0E8;
	Mon, 10 Jun 2024 10:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuHJaB/E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FB07A15A;
	Mon, 10 Jun 2024 10:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014888; cv=none; b=P4JuoP124iOQEYPw2QfIqnNHEN310lqpbJtlvb0z/0aQzc8v9aGtEM7SFC7LDXooSAPd+eQWwBnTY0VEz/sv8SsZDgMOUnd/m7IFv9jf2jC1nemrbAb8dVJCHbG1NCkTDZ7Xri3YZxitcigdnu7U5R3qsSzKdQWgHhU4XYJlSDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014888; c=relaxed/simple;
	bh=B2wImS6jYkVNxmJNAz/7Rmlae+jcWsMN5Euy7uX8VsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TZLL7lZn2Vl+Pt/Jwmiu6INtBMasAykZHMoAobFCNpyb0hRB5nBLSjuO0fmA6WhUubR2PiKlvCkzjbFnFeW+09l88XMWtrARyQI2vcgNDT/1tsgQ7U4NCWri6rIfvZm9YKiOXa4e+pEvy9UUwu2YWmBhzpDOJIi8haPOpg50bm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GuHJaB/E; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a68b41ef3f6so462290966b.1;
        Mon, 10 Jun 2024 03:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014885; x=1718619685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iEfSemHRxgSOfPiZYMvW6KyDv2YGLxFXvDUpF+fStco=;
        b=GuHJaB/E1SHWPw4NrPkg8fcdUM6LTFVZ6p9rnjQn+YbkwCRwnjbL6f+JA7W++oLmh4
         pf3ojqbyulcyQvlctxFJooEjsYThs54n7eez5YGnltoHmdCzmZiJjGcH5W4j1PaIeKsV
         wrBXlpyYJNlPCrtHLvOi9CV6Em4dA5qr1FeArxZa7FxdOIqblFfQHH+QaMULJYjpd/7J
         2ZRhmJ9DtEkJJWnSi7jbhQ8ZFEUkbf8d4tr7y32jjfUcIZJg9u00TQDK8FJNLDSb6WUx
         D9NWBfLtmeMBX6i/zo0UvQCOWYwuMe+YA7ZTpVBoJfyFrYnwqVY0oYlpk+SrBn3aALHy
         9lnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014885; x=1718619685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEfSemHRxgSOfPiZYMvW6KyDv2YGLxFXvDUpF+fStco=;
        b=wYmveTqzMROK4m6hxGtaJOJMyf3qtZTuNW1MTySN5kXkP0BmPy8s8d0R/b76sjPJ6l
         xz9runq9TY33jvObwbnAxQpGmIIFojqrxiBn7vNgWA5+OWaUpNU4ZqaRHP2f8HxgH1Kx
         /WKckjym8sBnKlBViSKoA6nsdBWbGOrNIOEl3kBp9AvNHAtrRTSuSZ3P6IFh/7TCwSUp
         zZLWOl3Q5Ru4FibKLFDjTJn65PRki6ONA4RNAdYvATh5XNNq46XfF/8FS9ScdbRTEYT8
         V0IswnXDiOEGh0q+hhiSLHZ3G8PfXr52r8pRP0fals3GD/no+VU8Fx2tufIHK22d4YwZ
         ++gA==
X-Forwarded-Encrypted: i=1; AJvYcCXsPWxaBSMA3gNw3bL3ZX/xhejhOaEa0J5WpiSdCa1Lx5yLMZbSCOIOK3Z6CUd+LERs+RLfTqu3QbLZ2lc1dhZw4HVFbno52y8+F47VE/dcvAKBOVc94XTGIbmTwq61EmLGKchivSQYPSB1y5SFOmmXCUE24o60bXi5
X-Gm-Message-State: AOJu0Yy8DLBxjxrb1FxSm+JdUyoUJCinNx6j3ifbx9WZGF7pVZh8TWcp
	JsDxPNjkDGuzTS78HVcfL9LpmqROZmbZUWcneb1+hrEXutJMLlI7
X-Google-Smtp-Source: AGHT+IG1u2X9S9HjwLyvUzoKmM04a54bnBw7Lz54/NkJdSpdqT0nvOtendvNpOdVPb71wHGOXHjzEw==
X-Received: by 2002:a17:906:3289:b0:a69:1a11:d396 with SMTP id a640c23a62f3a-a6cdc0e252amr568492666b.71.1718014885293;
        Mon, 10 Jun 2024 03:21:25 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:24 -0700 (PDT)
From: vsntk18@gmail.com
To: vsntk18@gmail.com
Cc: x86@kernel.org,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com,
	ashish.kalra@amd.com,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jroedel@suse.de,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	michael.roth@amd.com,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de
Subject: [PATCH v6 01/10] x86/kexec/64: Disable kexec when SEV-ES is active
Date: Mon, 10 Jun 2024 12:21:04 +0200
Message-Id: <20240610102113.20969-2-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610102113.20969-1-vsntk18@gmail.com>
References: <20240610102113.20969-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

SEV-ES needs special handling to support kexec. Disable it when SEV-ES
is active until support is implemented.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index cc0f7f70b17b..1dfb47df5c01 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -267,11 +267,22 @@ static void load_segments(void)
 		);
 }
 
+static bool machine_kexec_supported(void)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		return false;
+
+	return true;
+}
+
 int machine_kexec_prepare(struct kimage *image)
 {
 	unsigned long start_pgtable;
 	int result;
 
+	if (!machine_kexec_supported())
+		return -ENOSYS;
+
 	/* Calculate the offsets */
 	start_pgtable = page_to_pfn(image->control_code_page) << PAGE_SHIFT;
 
-- 
2.34.1


