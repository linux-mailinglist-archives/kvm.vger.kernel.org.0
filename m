Return-Path: <kvm+bounces-50805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2192EAE96E7
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DD9A7B5EFD
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0A525E47E;
	Thu, 26 Jun 2025 07:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="fvf2sPRN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E88025CC57
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923316; cv=none; b=DND89FgcwlBYlyjaeyeEhH/zh8wPOkBAC+1gL3zci4VvRApIvb6lT6U5XN3Q2xzaDpBlLIg41tz+3f+j72a9Od2e/J9XgXZXprA7bSVvMrmOUsjpau/fatLHNxT/fFOQMn0g0/LLMR/vn7K9XCq0r1BZyavsfFhLphFiyArGI3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923316; c=relaxed/simple;
	bh=XVn71Afhe4jNYVmIMolfsKiptWuKK3Gs8K5TAYrc3zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOm3ype1dXuIVbPxmFOhQvtD4Pvtx0Ygr1yA5iCxzJmKZ+QUKZBMWu8QyP7yOa2uC2TFVdDaIzdy3M8hRT+78ONoPNP73V3aLipNN/AEdQLAOkrxoOpQxw20RQedsJ7sSDwQh5uDwG5U63aTFVPibA68b4FrLq3eXEt9O/VeaVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=fvf2sPRN; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a365a6804eso339624f8f.3
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923313; x=1751528113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BW3f2ITrZQTPc6FkvfuzewFNuF1BVEMrpdMZ4LOwp3s=;
        b=fvf2sPRNTk9Vwu9/pHUNcrLCFcnmDqLGXT4zx6bOZ0GGsphTkt8Fd9GJI/OelZohFF
         1R4ezddaf5zFEIdEJYXcuJ++48+RFZFFT/fp+zC3p0gZICMdEiLjad67VdBTYZ8inBnG
         HeB0DyUXCVOzcuX1dFIlN0wU3pStui45VtEB3pNmjIgz8BGQpY1zzX0YEQPg6V/p+neZ
         7djmMsvf7no68YWDizl7hGG91RjC97G8POF5SUZbL1Fuw1gFOpjQHryBq5uH4V1AlF5w
         dCu+bkcIi/U+KpxO0O571pNniSMYgmNssSwla3/YPBk2e/zUevlOPaBXtfb9We66ZASo
         jh+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923313; x=1751528113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BW3f2ITrZQTPc6FkvfuzewFNuF1BVEMrpdMZ4LOwp3s=;
        b=UPtU5u9KTk35kgYSQYcqv2DltQlZFEXoN6G7FGWRhU679zDAYLyTlL4AKO5PCjvBwD
         mFsfwesWbTkbRbkEZDlFNyb0wfbxAEOzQezv+L9xyimebKcoILlChu31WupMwz61HUjd
         MmG4BsWhSy92GyBk99vOkoqnt0RNmPogpqEJ1bmNFQjzC8TIG8iMy8p6NtA7jTBw1erZ
         O5AttafYQpCe5giCe1HW8cVMK2jYe186D5i2sjdlsXKjWkdJTNunJjdLJj4l3vrKwby1
         v4AomUSCoYfiWF8XQiJz8EXR/MDRMIvBHa4HuwEREPmsm1PhNaDz4RdWPTuEUvQa3ITJ
         n3jQ==
X-Forwarded-Encrypted: i=1; AJvYcCVx+VTQh+/3lwockPvMPck8CWQ1xlwyvYVYF5XJoKQWV+GIf+819/ezwgsgKSc7RDovH1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGEf+BSo47VV4jE/jUXTanNuil1bkigC4+sQYqWMPy7YMRwJfd
	DMRCW6EFUdwJolGbMeqV3PCeqgQpyIrzuu/yVAub27PiORCGs09cHmDbrtCut0PTv2gwD4BM+TT
	udvKb
X-Gm-Gg: ASbGncuKENKFuJ5TC8o3MyO2cEzlLZb7oAZoVJtncXXnbH4kuXpefI+tsl8DIPO6+aw
	1g9vIU4/fQ+HbsiaVk9lR0O4TEFxpkVWdGKHmzE7asJzACOBU6h7vsbeq8Mp4dqoVVSzJhl+iDc
	GaILCttdByfsSei8iZd0fCpg2ms3UdhW3JVSWp+ialYC/OxWKm0qPZid0Tiqu4Q+mLrkUWzfH5e
	nTOVf+ol9hKvEJmCqCnKAqbazuXGyPoASPLm4a2alMbVelA4ZzZxoKU/Jxme/Zmh/drlYqZ1/LV
	3yhnI2oKlXPfxHDYZexvpn+Ah//3i4Oesmehdhgs6W5yERotmhfQC1vhmgyJYNpa6Qj/DNyoaMT
	WIH56cmECV81QJeB0GPMbUMOsTOm63NoNNfmNhmeDnVTjgTcziBh9KGQ=
X-Google-Smtp-Source: AGHT+IGTw0FgonZw9l42NRjGRinYQn8+G/I7EnPRzaSbYJeiY0Db/GJ+WOxKuihWK0Y/UAGOQartRQ==
X-Received: by 2002:a05:6000:4a0d:b0:3a0:b308:8427 with SMTP id ffacd0b85a97d-3a6ed65e7d5mr4870316f8f.37.1750923312836;
        Thu, 26 Jun 2025 00:35:12 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f259dsm6692451f8f.50.2025.06.26.00.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 00:35:12 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 12/13] x86: cet: Test far returns too
Date: Thu, 26 Jun 2025 09:34:58 +0200
Message-ID: <20250626073459.12990-13-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250626073459.12990-1-minipli@grsecurity.net>
References: <20250626073459.12990-1-minipli@grsecurity.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test for far returns which has a dedicated error code.

Tested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
v2:
- rebase on top of Chao Gao's series

 x86/cet.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/x86/cet.c b/x86/cet.c
index dbaecc7d74d7..99333c35a028 100644
--- a/x86/cet.c
+++ b/x86/cet.c
@@ -31,6 +31,34 @@ static uint64_t cet_shstk_func(void)
 	return 0;
 }
 
+static uint64_t cet_shstk_far_ret(void)
+{
+	struct far_pointer32 fp = {
+		.offset = (uintptr_t)&&far_func,
+		.selector = USER_CS,
+	};
+
+	if (fp.offset != (uintptr_t)&&far_func) {
+		printf("Code address too high.\n");
+		return -1;
+	}
+
+	printf("Try to temper the return-address of far-called function...\n");
+
+	/* The NOP isn't superfluous, the called function tries to skip it. */
+	asm goto ("lcall *%0; nop" : : "m" (fp) : : far_func);
+
+	printf("Uhm... how did we get here?! This should have #CP'ed!\n");
+
+	return 0;
+far_func:
+	asm volatile (/* mess with the ret addr, make it point past the NOP */
+		      "incq (%rsp)\n\t"
+		      /* 32-bit return, just as we have been called */
+		      "lret");
+	__builtin_unreachable();
+}
+
 static uint64_t cet_ibt_func(void)
 {
 	unsigned long tmp;
@@ -99,6 +127,10 @@ int main(int ac, char **av)
 	report(rvc && exception_error_code() == CP_ERR_NEAR_RET,
 	       "NEAR RET shadow-stack protection test");
 
+	run_in_user(cet_shstk_far_ret, CP_VECTOR, 0, 0, 0, 0, &rvc);
+	report(rvc && exception_error_code() == CP_ERR_FAR_RET,
+	       "FAR RET shadow-stack protection test");
+
 	/* Enable indirect-branch tracking */
 	wrmsr(MSR_IA32_U_CET, ENABLE_IBT_BIT);
 
-- 
2.47.2


