Return-Path: <kvm+bounces-13852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9929A89B8A7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:41:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A28E1F2204E
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDF628DD1;
	Mon,  8 Apr 2024 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EknSmdbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273B225777;
	Mon,  8 Apr 2024 07:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562066; cv=none; b=GGoyhOXXXHrmrzpUI9autpHjPKdtuciyQna3/kFP6kLg1M2NcS9FyegsAhtoaHBObQRxREu8kf/MdBs7CDJg84fyDm7EupllC8PIh5WxpxNu0g2dXxKp5IBhx2MIRknUzheK1BeQDHKmLZnxtVNYG52+p+7NOcXGKAxQlRWVxN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562066; c=relaxed/simple;
	bh=deFR0EbFGoz01sPfPnM8bTuqp1Yx689MWIkLggdnTCk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fFl0otCxBJIWE9BgqnRfuiokhzu8S9K0acqVH6Gg8LnDRWU0q8NN8+fnTGXTIdEgNfuBoNMgPKVF6pqbQHfX4yL2zyGB0YRUSb30cGPwgnKos5LL89CXhTzb2K0PT+HrpHGhCtZdykDPjQg2mgb3HrnW5snJfISVDdiuw/Dg+r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EknSmdbc; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41551500a7eso33906295e9.2;
        Mon, 08 Apr 2024 00:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562063; x=1713166863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1UC5Sjs0y+1l0bqhsbHpWK9vOawmeA7/6gd6QlKv6W8=;
        b=EknSmdbc6hV5wR/0PwaXJgLM16apjjqIzgSEaX8OOKWjQpNFBugWS1FC45/iqzXlh8
         Z0P8nF67fBeCjPj9v6KhLWDcGqZuyHlv8qvQfD16TEc2yoAhnPHT97dgIs5sJhZywCah
         06votYFzXRqgnorg9nJGy/J62aGDiZ9F5cXVVKIpcWWBkGjxSFFiUFyN6o0m1fL4jUES
         sQDtN9wz/8xUdWkdyL8crfJWsZitEhxPKbaKNXL88DcUOMmNoj2R4FoligZNkyAjkxRG
         UtHVwxGIwKUtmhzVUTkaulzt8/e8PYk6/DnFfnp+6j8M9XYeAfYlMM6WEvpF8wVlbBRz
         qpmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562063; x=1713166863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1UC5Sjs0y+1l0bqhsbHpWK9vOawmeA7/6gd6QlKv6W8=;
        b=L+hh9l65d1DAnfVPo2EkD8uQHDbv9+XM1ea0MV3By1X+LSNA9CIDCBL+8z1kY49vKi
         hTx49YRdogF2Ww8p05oXlcDM+aL4qrZXXl6+P4prJjHzqRlrl6z2QWW8mMQ6T6QCsG6G
         a+eel7NMfLDG9Ft/wawaqLq8u1rpK9+f4dbxvvsH6SJThzRAZNni9PzFubHOLE8Mvn1y
         Uf0k7jXvE0/hV6/2AAj4q/a2cYLwVjavo6uj3v3P+X/pUDqA+C6fRHBDf6QSbtr9RxAc
         xGL/lHkdhNUhDLDd6kiN+e/Ol/gUCHSmueEfM8K2Mg3gkkbHGeRaaBhY1v2UDVK9PkQF
         EWlg==
X-Forwarded-Encrypted: i=1; AJvYcCW35mMAbkvXdEOc66eknWYXRKJRKmaXofS90CDFY29xwtos68PZMBZ92Bb6LmBzGnFt09txYuFS60ygTqgV0YEeisnWrjlCGZzviBPZdrAYgCVJBmRWXhK2rS/KtFat03RzW5lKjx7ALP6VAEeOz4N9c6zN07nr75Vj
X-Gm-Message-State: AOJu0Yxk2/ovmcK2vpW4t53hsVtyr/wb+Ka/z6aW9Ao0C3lKVT8Xoi5L
	va/4uKaHsy3RD13kBicgoA4BZPVzjG0nGC8K4WJiCcF8nptFnkrm
X-Google-Smtp-Source: AGHT+IEA4rqVnV0zCmstOW3Lm+tswAKk7lUuBX8iEtTS9cgrpMZ4GU/tM2sKL8kd/pn/zpEd0eSv3A==
X-Received: by 2002:a05:600c:470b:b0:416:6a7a:8528 with SMTP id v11-20020a05600c470b00b004166a7a8528mr1630488wmo.39.1712562063310;
        Mon, 08 Apr 2024 00:41:03 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:02 -0700 (PDT)
From: vsntk18@gmail.com
To: x86@kernel.org
Cc: cfir@google.com,
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
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com
Subject: [PATCH v5 01/10] x86/kexec/64: Disable kexec when SEV-ES is active
Date: Mon,  8 Apr 2024 09:40:40 +0200
Message-Id: <20240408074049.7049-2-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408074049.7049-1-vsntk18@gmail.com>
References: <20240408074049.7049-1-vsntk18@gmail.com>
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
index b180d8e497c3..4696e149d70d 100644
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


