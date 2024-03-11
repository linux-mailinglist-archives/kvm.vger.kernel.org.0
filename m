Return-Path: <kvm+bounces-11561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AF68784DA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E43A1282A0E
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BF54F88A;
	Mon, 11 Mar 2024 16:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8WGV4LY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC3E48CCD;
	Mon, 11 Mar 2024 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173861; cv=none; b=Se8GxmfMOZDxiGGBKHJcdPSilXyOsOOCI9OYn8itcOT4b+7NF5xjCGvT+QzxfvNWsbH5ew98HrWc/UsftnyMCKEhT6alR68HI38McQYRyKxh61IbNu/J/lz1n9fcHyZibWnQlFC0kNcHhUvPrK4GCo29Sq4iPxRSTWq+YnVVRAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173861; c=relaxed/simple;
	bh=uh321KuZzkIr6bov6gkL2gVcZHrVCSYkUtEmo3DNyRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eAzlXBRv/ca2/7K/Xd/Qaa2QYePWyhMqOKZKMiUGj1SYoDRA6CQN2lPUSULLn3QyiyNHI0kYggG8QywN3GlOrldbjO5rTCGrinm3w4s8Qb7q6hOuCTc2tz48InIQe8v/ZVRNRwTq9QWV7GctZBl5vcufpUkEqI2smJIQWsuryZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8WGV4LY; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-33e5978fc1bso1971279f8f.3;
        Mon, 11 Mar 2024 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173854; x=1710778654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KwrPOtCFWcQDMfUXPx+XS96HNczA3gaW/2MdY2qxab4=;
        b=R8WGV4LYJFYpU3dVc2AaxSoHFRQBUFD/wHB6lI/EIJ6B6Uw8Dy750PT2+jtSkzSvZI
         +j1tTu+t7/PBAVOn53aPdz9UBui9YtAFLstfaVw3CJD+65tF4gIJbz/wNkdnmMd9ENvU
         h7e4vkx9tSQhPIxT5AxrtNNTuWIOIt0zbzgHNGiDNIMi+6IcJYn2JjUbmP/kODveD4AT
         cWTx1CG4vznyiaeqnwWYps10H0YQuuouPE5pzXPBE8HLoF2bNeUlpdIHiQVqDUxk6oiO
         jYLFjONIyFcfuZxlSxGfxUi9JEgjdQBHFRiMXe1AC8n2dv6PpzokHitYYijGpA8sDWhd
         9luA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173854; x=1710778654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwrPOtCFWcQDMfUXPx+XS96HNczA3gaW/2MdY2qxab4=;
        b=CW+JS30OoNhkZVWvQ4Ewu7UYMlvg1W7xZJQtlLwMCI8aINQMD6UKBxN6ghhcpaUorL
         +/DqeTgOUC2Ajkj6RuSJLjqMKoW/CEIctU2mXHjGpbBLDJhK6TAlw3oeJU0/3St2NGYi
         WZCbC307toOWRNvxqfAx9FE0zoiWGFV/0ZSB7BGboxU/E4q7NQUfualoLIcRxZIXQQHJ
         Q2Pa6C32PVzB3hYMUz9Ty7UmbIvL40aPMGANiWS9bHrwBx+aSu8zwm3Xrp7OwCFTuDZP
         Cb1R18DF4PzvGL8MhSuxN1eKzjNyaibxkxqB92uIBP18Zz1VeiPzVEq7mlfn2qMWcMgW
         Yx+A==
X-Forwarded-Encrypted: i=1; AJvYcCVdmf82kYWH5mIyEZtwJzXeLEMZhg8rPAFzQL0xI1CYmXTjkBE68+rkIW2T8ZaaZpxZYHNyMhh4RFRBMSEm9L/HTXpCdHZLfejGtkhUxEXdSW2zscuOv5W4TR/hTLbP9xKLw19N3JFUly/A3acRtNu5ccozG58HlT4M
X-Gm-Message-State: AOJu0Yw3clnGJb6isL41L+BeUw5h5WPz6FNynHi5SH/kQ62n3jGo/ExR
	Bbs0zQ5b2ut3toYRMLK3/2LFAOtcJYBU6MJcAyBuMYyJ/mPICq1W
X-Google-Smtp-Source: AGHT+IH2ferHpfaCLktwprSAlut0kfkjOaWyxqFOcoy+lU0gHOdVqoYzZnhz4uQfv99VU6U5lBGYiQ==
X-Received: by 2002:a5d:45ce:0:b0:33d:3abb:6db4 with SMTP id b14-20020a5d45ce000000b0033d3abb6db4mr4095738wrs.69.1710173853730;
        Mon, 11 Mar 2024 09:17:33 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:33 -0700 (PDT)
From: Vasant Karasulli <vsntk18@gmail.com>
To: x86@kernel.org
Cc: joro@8bytes.org,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
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
	Joerg Roedel <jroedel@suse.de>,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 1/9] x86/kexec/64: Disable kexec when SEV-ES is active
Date: Mon, 11 Mar 2024 17:17:19 +0100
Message-Id: <20240311161727.14916-2-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240311161727.14916-1-vsntk18@gmail.com>
References: <20240311161727.14916-1-vsntk18@gmail.com>
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

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/kernel/machine_kexec_64.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index bc0a5348b4a6..3671ea1a5045 100644
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


