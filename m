Return-Path: <kvm+bounces-66422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D648ECD228C
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 00:00:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 849583090F21
	for <lists+kvm@lfdr.de>; Fri, 19 Dec 2025 22:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745D12E8DEF;
	Fri, 19 Dec 2025 22:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4S7LI2z7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F62E62D9
	for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766185172; cv=none; b=hSSuOQkhDMJ3+kOlVCXcNrPLtvpbH7emadyAzhALSMIOJNoqDGUWUUNibEA4rWTrvXsoXcDquwRdWL+bKZGEZuFxe4uyPTBtnGbXT7l2L8n/1+X7ZIVtlidWjBedulxHkcvj2Fun0iN425apwa0Llil3UK8ElagraOclxQRiOFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766185172; c=relaxed/simple;
	bh=MdMgFla0wfem3Cv1xiQKR8njRV75M3bXzRlPRffWcII=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uqKx917n8ip6Alk0//BwQ9eHilliEV+H7U4LD37P0750VTTPCuacruMxAnDa1RvaMk1U1/Zwpjzk7pLHh4kirBCyI2Okl1FtV5iNRLVZo9sN8ZTv08nGM4AUWZUJTlyYZAk9Hlm83tfjde5jAOlGTPiknqRoM9CLTfbg5Z8dPmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4S7LI2z7; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a08cbeb87eso30976235ad.3
        for <kvm@vger.kernel.org>; Fri, 19 Dec 2025 14:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766185168; x=1766789968; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PSR7XvpC/UVT8m33sgFfslQIytMaSIpZ+dg4JnjS9ag=;
        b=4S7LI2z7xNkqc46siInqvL4gS5t/sxMJJsFCpRAD9r2iQv38hdDNXXnCXPifz4fH1F
         PM5grVrtYeFVQu5WJq7yGJxQm5VVscM69WQM4jtAMPlj8j4hmW1Fe07eBiBxl6fiF1Ba
         /Yqw57p4sSYBRiu/vDbCZJw5AuIF/a9/gBFu3ylWlBEoMsT65hK/ptDuiCrBmyYjVnNS
         OXLT1URp9bvqa1u6xths0U8IYrWiysXFKycSFCGONgGy4txMiz71Cc04WNsYsvlzozYb
         6rdv1zj6mQNro8kFw1AUiQbC6ngLRtpUOKXHsHUwRRmDtZpL3aIOXcJvsn+Ne8sm0V6F
         6tIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766185168; x=1766789968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSR7XvpC/UVT8m33sgFfslQIytMaSIpZ+dg4JnjS9ag=;
        b=HaUTMvt/LeMRHcjJfbanu+gKpxUT8kDIELdI8iE9BtNUYt/CBrXFheu04R8bSKi+ZE
         ehhDabNbWi4YsksdVXOmpTjB22+KumKfqj47ddSylQAeCe8TzF8WRICsXn1i8iaQdzaG
         50UeE2jjEhwg+2tviDXPQxGgEHSoqOU80YGlM17LYOFVsj0cyKHxGE2/5MksGbNRbsXN
         nrXBm2gFRoYjYTjGyC3ZRO9IEK8SZuQFZANsFol+/AgiCHD4+yK8MAN/DN26/UXrzU5L
         kzQG34gp1KfPr143N7X/QSCit7XJ8SZRHv4Vt2YOZYTJ3yTzDonHYsq7R9jvb6n7QpvD
         XWzw==
X-Gm-Message-State: AOJu0Yy5fe7q3hqWeYSb3zqbNVccWnJEBGataSCV3orhzsmtW4mvTXTa
	bttsKiAGkh3gQiK/Uf2/SZ98+Vwm0vLaxT9jzbewfukJtL4hKvuSKr1nMvah44uIP6NfP5LQxIU
	rV5/S+Mxax/YODfgViFlBxwiC3emG1NHbK39dJYP5GBIIklpSj+InQ+44GI83rEC4a8SCXJtIXV
	VUba4xL5wtwfKwmUC28ip7FSb0Q0o8T38WPQbcJ8q6omk=
X-Google-Smtp-Source: AGHT+IGJIXc/EU6gvtHnE9NQz0MC43GFq17k9PBz/ZhOrhVaqPcJxthH473fyNAtuXfMtnGsgCfBL0jBIzlHJw==
X-Received: from pjbpc3.prod.google.com ([2002:a17:90b:3b83:b0:341:88c5:20ac])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce8b:b0:2a0:bb11:9072 with SMTP id d9443c01a7336-2a2f2a3db5fmr41809435ad.55.1766185167756;
 Fri, 19 Dec 2025 14:59:27 -0800 (PST)
Date: Fri, 19 Dec 2025 22:59:06 +0000
In-Reply-To: <20251219225908.334766-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251219225908.334766-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219225908.334766-8-chengkev@google.com>
Subject: [kvm-unit-tests PATCH 7/9] x86/svm: Add NPT ignored bits test
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

Bits 62:59 are ignored if memory protection keys are disabled via the
PKE CR4 bit. Verify that accesses are allowed when these bits are set
while memory protection keys are disabled.

Bits 52:58 are available so test that those are ignored as well.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_npt.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 5d70fd69a0c35..ab744d41824f8 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -372,6 +372,35 @@ static void npt_rwx_test(void)
 	npt_access_test_cleanup();
 }
 
+static void npt_ignored_bit(int bit)
+{
+	/* Set the bit. */
+	npt_access_allowed(0, 1ul << bit, OP_READ);
+	npt_access_allowed(0, 1ul << bit, OP_WRITE);
+	npt_access_allowed(0, 1ul << bit, OP_EXEC);
+
+	/* Clear the bit. */
+	npt_access_allowed(1ul << bit, 0, OP_READ);
+	npt_access_allowed(1ul << bit, 0, OP_WRITE);
+	npt_access_allowed(1ul << bit, 0, OP_EXEC);
+}
+
+static void npt_ignored_bits_test(void)
+{
+	ulong saved_cr4 = read_cr4();
+
+	/* Setup must be called first because it saves the original cr4 state */
+	npt_access_test_setup();
+
+	write_cr4(saved_cr4 & ~X86_CR4_PKE);
+
+	for (int i = 52; i <= 62; i++)
+		npt_ignored_bit(i);
+
+	write_cr4(saved_cr4);
+	npt_access_test_cleanup();
+}
+
 static void npt_rw_pfwalk_prepare(struct svm_test *test)
 {
 
@@ -831,6 +860,7 @@ static struct svm_test npt_tests[] = {
 	NPT_V2_TEST(npt_ro_test),
 	NPT_V2_TEST(npt_rw_test),
 	NPT_V2_TEST(npt_rwx_test),
+	NPT_V2_TEST(npt_ignored_bits_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
-- 
2.52.0.322.g1dd061c0dc-goog


