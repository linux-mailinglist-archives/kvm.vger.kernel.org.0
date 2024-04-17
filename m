Return-Path: <kvm+bounces-15034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0168A8F4D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 01:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DA0C1C20C4D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 23:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BD386647;
	Wed, 17 Apr 2024 23:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCZ1hdSE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEBC85C7D
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 23:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713396554; cv=none; b=fAyqP0AZpuDD4yzEMuBdmFa6mSUcusldt9pTXf2FKninnjVFe+u6Fl87IFMZWDlSkZ7t/cj7Rgu0d+0IX7ZdmPEfGofBX+pbll/IP+9Ler4twdtg0guCJBRr2X6sSl93+mwQ2De55g3Xus3/oF5ALsjbSz1jPuSq1JjsUbU394E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713396554; c=relaxed/simple;
	bh=r7QxmzLtx6JzU1kSChdPftZW2vo9FkVx+nNkLGHfOZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QfTDXgKJFY31I6o8mm6a1rL+roQzIdCsCRZ7mdq0P7PsMon0NaD77cnxZygRFb+75rrrbHxebPGAQflet2MSSGSoIePbUnXQOVcVarGggZ8YPa3dCSXSzljOcKQK2kJk7ewX7BmUu1bHd/1prEmF4NsJfpaysIYMEJdatdH6B8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCZ1hdSE; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8df7c5500so228646a12.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713396552; x=1714001352; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=orz6MK6yTlB3i3G+L6FZGPbEc0hZVBsIVho6a86g1q4=;
        b=WCZ1hdSEbXjU2lZcdliXhpICbAb974IoYb1eCJRouwJ/XcqBDhm/vySLDtvTZ1+kFX
         03uoh3Ha8Az2isPVchh1qsz/F95sWq8zX0XxhiojcNXi/58k9Yi33cdCQddvOPs56n1O
         wiSMvcpg5DQ/e6/x7oQtCXaQ2dFaZijvH6UKukjhOz+ZwL7RBiAF4BUsMSUmfsS+m7QY
         SKyMmSzMlcglLfLYHQgsj2e8KZRTSyfDoyU3tYAXsSaRLhQdChYKqKeCxX3MxP9f3I6T
         +zu7JN0Ti8Hb6nQOgiTn9iZpBIUpZzrZkMTbWBW+tPVm9w59+WpLXVo5BqaHsFbn5jmF
         mzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713396552; x=1714001352;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orz6MK6yTlB3i3G+L6FZGPbEc0hZVBsIVho6a86g1q4=;
        b=E7Uxjau4XvC41Ra2cX/R4qEVKYx+/A2adKybn4Ht9ByycOEIc8Ly731PPaz4M2W7uu
         R0EnRiBWQIpKEI9t+fFo6+ilmhth303UE1wd8n31XVx3hx777SASR/aaBsClyFrgcjJ0
         I9W2yxJrHrGsaqqaxrIH5dyAVytVocRghUvDVx9rJI/tOpzRFXtQo3mvHase+powaTfd
         N0Sd6lacRcbjvNZcXRFOJnPf8MZIi4iOY+tQiu2OGg/YxXKNxazrAzC/8QEz5bOaFRRF
         PJ1ju+spza/b4h+7V369qziJYQhg+rdc626zGxNyaf3p5Sd6uSFmOxzjLGML8AlNYNRT
         Y/jw==
X-Gm-Message-State: AOJu0YyvweBnoiodgiQ3sWMp5mqjdZWFKTgYBh1uxgUNnRhoN4SdPaLf
	aDwEitbW2j0ipASiXurabxHarvHKpw58kD5tSnH6iKaRKoJJc7SORiL1POzZ/wnyV6tkma+YpV3
	qOongHQ==
X-Google-Smtp-Source: AGHT+IHOl+ccS97IYO3ZVI14I9/buia/9xDJ9m/wK0/o91lMxG3oD6w6KzSN2dwRplI1YDfgV6ldHEYDjWe5
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:cd3:b0:6ec:f407:ec0c with SMTP id
 b19-20020a056a000cd300b006ecf407ec0cmr95365pfv.2.1713396552035; Wed, 17 Apr
 2024 16:29:12 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Wed, 17 Apr 2024 23:29:06 +0000
In-Reply-To: <20240417232906.3057638-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240417232906.3057638-1-mizhang@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240417232906.3057638-3-mizhang@google.com>
Subject: [kvm-unit-tests PATCH v2 2/2] x86: msr: testing MSR_IA32_FLUSH_CMD
 reserved bits only in KVM emulation
From: Mingwei Zhang <mizhang@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Avoid testing reserved bits of MSR_IA32_FLUSH_CMD in hardware. Since KVM
passes through the MSR at runtime, testing reserved bits directly on the HW
does not generate #GP in some older CPU models like skylake.

Ideally, it could be fixed by enumerating all such CPU models. The value
added is would be low. So just focus on testing bits when the KVM force
emulation is enabled. This is in a new helper test_wrmsr_fep_fault().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 x86/msr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/x86/msr.c b/x86/msr.c
index 3a041fab..17f93029 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -112,6 +112,16 @@ static void test_rdmsr_fault(u32 msr, const char *name)
 	       "Expected #GP on RDSMR(%s), got vector %d", name, vector);
 }
 
+static void test_wrmsr_fep_fault(u32 msr, const char *name,
+				 unsigned long long val)
+{
+	unsigned char vector = wrmsr_fep_safe(msr, val);
+
+	report(vector == GP_VECTOR,
+	       "Expected #GP on emulated WRSMR(%s, 0x%llx), got vector %d",
+	       name, val, vector);
+}
+
 static void test_msr(struct msr_info *msr, bool is_64bit_host)
 {
 	if (is_64bit_host || !msr->is_64bit_only) {
@@ -302,8 +312,11 @@ static void test_cmd_msrs(void)
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
 	}
-	for (i = 1; i < 64; i++)
-		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
+
+	if (is_fep_available()) {
+		for (i = 1; i < 64; i++)
+			test_wrmsr_fep_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
+	}
 }
 
 int main(int ac, char **av)
-- 
2.44.0.683.g7961c838ac-goog


