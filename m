Return-Path: <kvm+bounces-59233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B34BAEDCD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 02:16:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA1023AEB54
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 00:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F11AD1957FC;
	Wed,  1 Oct 2025 00:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EOzLHNX4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE8E1411DE
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 00:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759277741; cv=none; b=TPWfwku39BE6cLYx3ADsLEVQ0IZi7KThxJ26gXLyb5vsSiSTASKDjk2FCPMnB6FW7/18rqUyrvuH9ktxDORvyPXqPVV8LamFY11zyV/4J8TwfFSyyNSaJ/2ZClO6bp7gJjGvooBMsfUVhRjTKNrxqQNMMBRvqirVgwX3X44brsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759277741; c=relaxed/simple;
	bh=E1g89qz/ZY0dhHwx4qcmJ7x5mFzqCX12pJmsaJRKND0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=WRzv7miIvw32gIjG/WlOq+zDWLjgKGpQrpV/YLGm157s9dwnLN6FEHnnQU8rSPosWjFh1wjY6mDzcgUxBgYqQMctuoHGH6jD2rQOk/7l/rT37gIeMbBOOVXXz8hap8Z60w5OIF14kETEYP8ntNYkr83YcKirgYkiTEsZgieoUAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EOzLHNX4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b59682541d5so6796690a12.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759277739; x=1759882539; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wIEK6qNuqRubYvP258NgbgAUUEfNkVMfJZpTtE2rW84=;
        b=EOzLHNX4KOmo6vac4ceI+EkKuDqTE4NefHd/irSogzmJS8IYZB7QdTmnMrkEHYt9nD
         hn3xUPJd2fLGi4Pyigrbg7qCnn7JLg0Csl8HvnOERSYBuF07C4D1EVm9LINC4j/OVqUk
         JrqD34socij6HTGRdWYAeO8kgU39HgOFzXqAusDPA4aiHpoclwaW5oHXduIwb4UvwAzA
         CvhAeu12vKj0nNdnxYqiU02gr9cmrQ5kYbBTMommHyM1BO8qDlY/IzX9e6yR0MPUKcL8
         KQfGBWPmFexsVv5i3ltFYsxg8qrh3hXMffcpvETUQRZi9DrqwnfGsHb5+aDbHWSeUQS8
         TqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759277739; x=1759882539;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wIEK6qNuqRubYvP258NgbgAUUEfNkVMfJZpTtE2rW84=;
        b=g96x+U5DOe81dXJyzTWdLOOK1P7vYI3LwLCtDT7YiGpnhbRu63hnQAeV+ZXz0oWvXW
         tp8+1k/Nt6QHcVvyHp7SZJJiVP/7ukTbvVxsx6puKp+W0frL14UL2DeBeRNjle2VJaxJ
         NRjQgjDaeE/9YNQgvdr9xlxA8udO/S24w5vIdeaf0T7TdLTVFBe7Stcpsvc4EuN+GUhV
         MNJIc4HcpgjokjzFmJg6m2ffKHCK9N2Ou304xJLlgnEo7AMr+rvXgFzyZiULDoVKRPY0
         iHZi21rJyJSER5HsVJycKN2omwabstRGYvxMOQV2OCAuY5Yh31goLDzR4llkYb3eJpgb
         2VKA==
X-Forwarded-Encrypted: i=1; AJvYcCVo4Z3cBhsK2s2o7UmzU6JlSHvbSLd0K/IbRmxlcZvlb8vjyjzwLYSu05f9MilxSH2VmPg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKGsYssP9nTUnzTiiiiaWoUjcXIxgkABEzhPnxSu95uDYZyhA5
	8HaWuWBj72h9oYxazul2XqJ34xRmgq/pW1rADDtfs2qpvrjPxlqikIYtdrPK5gpjMCJsNkEdbxb
	PRPfzrGdlg/+Wmg==
X-Google-Smtp-Source: AGHT+IEJMSvJJoH6li85hWbtpDIp13j5UuAunqLpYUIMRlasU3y61u+MMNAqyVeuM2D1EWr0caMLQu6eNYzQEQ==
X-Received: from pfdc25.prod.google.com ([2002:aa7:8c19:0:b0:77f:17c9:e8fc])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6da6:b0:2ff:3752:8375 with SMTP id adf61e73a8af0-321dfc7ca66mr1943503637.45.1759277739003;
 Tue, 30 Sep 2025 17:15:39 -0700 (PDT)
Date: Tue, 30 Sep 2025 17:14:07 -0700
In-Reply-To: <20251001001529.1119031-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001001529.1119031-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001001529.1119031-2-jmattson@google.com>
Subject: [PATCH v2 1/2] KVM: x86: Advertise EferLmsleUnsupported to userspace
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Jim Mattson <jmattson@google.com>, Perry Yuan <perry.yuan@amd.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, "Xin Li (Intel)" <xin@zytor.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
it cannot support a 0-setting of this bit.

Pass through the bit in KVM_GET_SUPPORTED_CPUID to advertise the
unavailability of EFER.LMSLE to userspace.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 v1 -> v2:
   Pass through the bit from hardware, rather than forcing it to be set.

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 751ca35386b0..f9b593721917 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -338,6 +338,7 @@
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
 #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
+#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e2836a255b16..4823970611fd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
 		F(AMD_STIBP),
 		F(AMD_STIBP_ALWAYS_ON),
 		F(AMD_IBRS_SAME_MODE),
+		F(EFER_LMSLE_MBZ),
 		F(AMD_PSFD),
 		F(AMD_IBPB_RET),
 	);
-- 
2.51.0.618.g983fd99d29-goog


