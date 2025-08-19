Return-Path: <kvm+bounces-55074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D2FAB2D075
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7315628468
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF72B279DA6;
	Tue, 19 Aug 2025 23:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bBirvKg3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EC02773F6
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647326; cv=none; b=Ux818i9pOGHzj+9FbfIwS7WNGfzW2lh3l6chPJU/nKFX77Ek9a/y56O89u6tvJc4kSSU8zH7taJXRBuWo2RfiSF0CGGg/d7KEyOED3cSgMSgc8sFV/Qk4c+TJ7orBZYZcaNE9lL1exfTO+gOlz/VZJpjGdXIjlekeTuhmU6ALuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647326; c=relaxed/simple;
	bh=iAOlnEDBm9bLP06d6OktV3PZy0wjZl1YCX04dPNJ5Z8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CZBVrfPuXmJsZ5TH4He9zk0+uG9CYzm4j+niyAf50n6h+XqNDCw9MxqPS/mwCoOJjpPkiEGpXliwiQ3JyLzMHj/1SCOTgfriryYCHZhXene1Xwn4sx86cXUjbXjXnICgOP4sbyArLc8s2I92Fj35WpdxxWm0HulcUeeEHI0p6DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bBirvKg3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f440f0so64430285ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647325; x=1756252125; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sz+7s9SOsOItMaiZYOE1v1CBb6Dp1ei0pOw+46xMBUo=;
        b=bBirvKg3eg9VVDAIPS7bXEh4qIEOnFDifgCZTPtvWEBXoBhgRZowLaJmjhAhmLoXy8
         mMuoaj8zbTQkRUAwPQZP/XPDOGiyJgOVnV7uCm4NtgncBg0YZmYh3fpmrEIprc8kBadC
         vj3B11y8nFYCSTHjLhQh1mdlMdn4e/xzFbBLEbjAVR8Nn958oHPWyCB6QEw4CoboC2g5
         qC/TQ2lSCqsJKTtJD2mnYJjwmL+bdaRexpmRvvPpYGfT1WfL4hXYxolAe4w4MrTgB5p/
         PDhurbDPVFzxvSvn3Im/FY17nmFbTOdZcFUuDKQATeXsvIZlLzdnLyL/fQtbthz+zcgr
         ysAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647325; x=1756252125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sz+7s9SOsOItMaiZYOE1v1CBb6Dp1ei0pOw+46xMBUo=;
        b=bO0/wBCz2u63oTOsaby3Eij5UtZJAFs0vsVSJ11PsJLga+Ltr7dsbzimLpLCDUjnBY
         Yp2x1ymTRqUTID2/ZcOW/htoh0BdUQpMJV2es4YESHSj3syzquR2NDpitf8OmVHZUVOX
         gndbVuWKPGmG/NbYn4qDVgDPd2r6r1skgLKYyzMw+tFt7BE4d+KjG94vIPGRb8Mo8MMO
         fefJmXICueZlbLSJm9gUjd4K9lzrWWcNe3uEq7B9h28VbsTNLcJ2CcalQrnyCIOF/Fas
         QaE+zuA5wbNe8+v5QsyMed+jXORhi0adl1ZFCAjSZFyh1I4/EOwEKB4G6Umf0NkH0EEY
         7muQ==
X-Gm-Message-State: AOJu0Ywht45IGv6kFUsXERA23nkOZkzFpj7C7NSBkRhg4wSH77GOiY11
	LiBsaLmZelhNkSqVAr69GwLP9N5v6safMt9qWlSJyj0VX74+5tMfxe6Qk2+Ir3q6GD15OGuyZsY
	dnsE9uw==
X-Google-Smtp-Source: AGHT+IHqJWCaN8uj3DCl8ZvW4nfBJELdUJz19xicpjBd0k390UEqs4teZPxYyhTqf/4qK1wvPcaz/cEj3PI=
X-Received: from pjl11.prod.google.com ([2002:a17:90b:2f8b:b0:313:551:ac2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c8:b0:243:7cf:9bca
 with SMTP id d9443c01a7336-245ef292632mr7796995ad.55.1755647324793; Tue, 19
 Aug 2025 16:48:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:28 -0700
In-Reply-To: <20250819234833.3080255-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819234833.3080255-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-4-seanjc@google.com>
Subject: [PATCH v11 3/8] x86/cpufeatures: Add SNP Secure TSC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Nikunj A Dadhania <nikunj@amd.com>

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 06fc0479a23f..f53d4943ea63 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -444,6 +444,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.51.0.rc1.167.g924127e9c0-goog


