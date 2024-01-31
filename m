Return-Path: <kvm+bounces-7628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D108844D7A
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:57:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 216CB28A215
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CE33B794;
	Wed, 31 Jan 2024 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sahZiboW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD923BB34
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706745379; cv=none; b=sFz59biin498HwxEPAaJgLx2X6taQ48WZYYjHdp5ymbl2tcigfPDS089BEHyqArjolEYrFn5U43lq5UpntVCRuz8B5QwMkYwRh0+f3/c6bIM253jj7j5Fd1QB/zKAzk+VCeYU8XsEdg9XdCi6L6sDMc7vTbQwPDaNflI207YV2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706745379; c=relaxed/simple;
	bh=D1nog3XCAS5QFsKZW5HVf+ENkuPBa0MU2IJSYf8wk+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZXcFHfbmHODjjZOi8juaeSF/9EXhrm5fMGi6CRvG5DWTltTij9mchDKkMDnBmKZo6XFhkj01iK3GuN4fu4mRu/S/qE9f4RTjnfJQJj6ebmBfx9AE/JPTwCWc3v9/OtZXazQT7p4eOTkpiuS5SZAjFnRaKTFXaZDHnj9JrPO99PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sahZiboW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-295b6b50fc7so1402493a91.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706745377; x=1707350177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/WObf82Vf/Y5MR7jXp0Gt7NYNHTt/4hLoEW6luDmRxk=;
        b=sahZiboWzyFipkcxsmrChqjVG6r4CmV41tCxJfv66ChItU88vt2YhWaAf3BEfazat/
         ks33WPMLlJcvZ+7xrnd3VxpkmT3n2hyNPBe3Ze0oYDuLB0NLqgxD3Bva/ke1oSUpl5G5
         KjyVltb07236dh33TY80r3vr1ygh0JKOAIPaKW1Ear7X+qIjzVEWpKMJrmo6POaxlGyG
         vYLPzGygHwJayxw5nMLaPq9bI02ODUrkai9Sz8GJm4BZxcL8x8A6IT/1VPxrLrJWNq20
         56pun4w47b6HnckQE7LytsdHAS6HzwPvAdKP48oTs8b8sGTpf04mCHh/HSoSxwNHIlrG
         0gvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706745377; x=1707350177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/WObf82Vf/Y5MR7jXp0Gt7NYNHTt/4hLoEW6luDmRxk=;
        b=GF4MwCM8qT1OmTKvK37pG0zzYrA4rtMm0jnSUEH3MyPpv+8r2cK//wXGS9LU9pK5PQ
         Zsyhe1mZuQI0tRUXrM6JoXsWKW7ED2f5Ac3Yq5kPdQRMUl7SNKljvCFrbhwjPXExKIKB
         2WR+VpkVG0gOIg7qrisPob81D5ncNA5vDs3frTIDLM4ytJo1ZPgakAQwUusMK5dgYB3Z
         6OcuypDMOuBLkV9nr1HnRzalQ1MBTKjj3yOKD0jZ7TKRsUbAvwVyp5UA2a8n5TcyH/9z
         etM7P/nk5kXDJvExaYbm16OeQEpO4PaYT1xyRDeHdMid6RlmemZPoTrUirgmm4TIqMZ3
         ga8Q==
X-Gm-Message-State: AOJu0YxfcJ+D+9kOdFRl3W99GtIfA28cmpTVWETZWMOlClHb5j2LRsrP
	7y4P3bhLylPZSuP0belv/HdnBNdrxujGBdsJoaoNKOyNiRJA55bM3zsgR0yiTPYC0UGauKZ50Kt
	jpw==
X-Google-Smtp-Source: AGHT+IGxjHZzt/t+Dce4AiwHDsCE0srigSTG6h90tg/UdTQyeP4Eje8UyXCDHFlKD+UuEx9RsI3H0LiAjwQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2bc8:b0:295:6834:b941 with SMTP id
 n8-20020a17090a2bc800b002956834b941mr45398pje.1.1706745377422; Wed, 31 Jan
 2024 15:56:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 31 Jan 2024 15:56:08 -0800
In-Reply-To: <20240131235609.4161407-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131235609.4161407-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.429.g432eaa2c6b-goog
Message-ID: <20240131235609.4161407-4-seanjc@google.com>
Subject: [PATCH v4 3/4] KVM: SVM: Add support for allowing zero SEV ASIDs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

From: Ashish Kalra <ashish.kalra@amd.com>

Some BIOSes allow the end user to set the minimum SEV ASID value
(CPUID 0x8000001F_EDX) to be greater than the maximum number of
encrypted guests, or maximum SEV ASID value (CPUID 0x8000001F_ECX)
in order to dedicate all the SEV ASIDs to SEV-ES or SEV-SNP.

The SEV support, as coded, does not handle the case where the minimum
SEV ASID value can be greater than the maximum SEV ASID value.
As a result, the following confusing message is issued:

[   30.715724] kvm_amd: SEV enabled (ASIDs 1007 - 1006)

Fix the support to properly handle this case.

Fixes: 916391a2d1dc ("KVM: SVM: Add support for SEV-ES capability in KVM")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20240104190520.62510-1-Ashish.Kalra@amd.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 04c4c14473fd..38e40fbc7ea0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -144,10 +144,21 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
 
 static int sev_asid_new(struct kvm_sev_info *sev)
 {
-	unsigned int asid, min_asid, max_asid;
+	/*
+	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
+	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
+	 * Note: min ASID can end up larger than the max if basic SEV support is
+	 * effectively disabled by disallowing use of ASIDs for SEV guests.
+	 */
+	unsigned int min_asid = sev->es_active ? 1 : min_sev_asid;
+	unsigned int max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
+	unsigned int asid;
 	bool retry = true;
 	int ret;
 
+	if (min_asid > max_asid)
+		return -ENOTTY;
+
 	WARN_ON(sev->misc_cg);
 	sev->misc_cg = get_current_misc_cg();
 	ret = sev_misc_cg_try_charge(sev);
@@ -159,12 +170,6 @@ static int sev_asid_new(struct kvm_sev_info *sev)
 
 	mutex_lock(&sev_bitmap_lock);
 
-	/*
-	 * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
-	 * SEV-ES-enabled guest can use from 1 to min_sev_asid - 1.
-	 */
-	min_asid = sev->es_active ? 1 : min_sev_asid;
-	max_asid = sev->es_active ? min_sev_asid - 1 : max_sev_asid;
 again:
 	asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
 	if (asid > max_asid) {
@@ -2234,8 +2239,10 @@ void __init sev_hardware_setup(void)
 		goto out;
 	}
 
-	sev_asid_count = max_sev_asid - min_sev_asid + 1;
-	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	if (min_sev_asid <= max_sev_asid) {
+		sev_asid_count = max_sev_asid - min_sev_asid + 1;
+		WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count));
+	}
 	sev_supported = true;
 
 	/* SEV-ES support requested? */
@@ -2266,7 +2273,9 @@ void __init sev_hardware_setup(void)
 out:
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
-			sev_supported ? "enabled" : "disabled",
+			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
+								       "unusable" :
+								       "disabled",
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-- 
2.43.0.429.g432eaa2c6b-goog


