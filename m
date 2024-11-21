Return-Path: <kvm+bounces-32307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 121029D5328
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:03:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB2C21F2146C
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:03:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECFF61E3DCC;
	Thu, 21 Nov 2024 18:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="biGQBj2G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2111DBB31
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215235; cv=none; b=qeVrq8cinb8PBr85HSRhDYxaBgDuWl8hDRdGt2XchbfqRDwKz0UYRdHVUsBk5rIqpk+umQkzNQeRC+dOcwNr7Bv9o+Tk4ZnbBfJNVuo5f5+Y2sQAFvvSUyrtFfJPKINrT6/VjTKgjTvbqUKujPwYFtn8BO+JQayeKZAc0HgVRaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215235; c=relaxed/simple;
	bh=Hy08ItaN1vh35+QFnvoRmFPDzzUHBtLBpFRgo8LJ4H0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TQswYIiX9pUY6i5xrRjIZM+HpEuwxuw4QTLSNslt46fKRjs+ezFk5QyminCkEIdYLFgDRZekCg+Bdt8A6Sbu9wneMc+hagslC4Oiy/hJSj2x/4siF8buc9HrbEeUp49P/yUB20VN7nTWAtps1Yz4bW4ED2aaT4sTtf8xDeYjtN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=biGQBj2G; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7ea8c2b257bso1129822a12.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215232; x=1732820032; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sPf5bDD3hksLR3rzX7SusPWKEW/ra9S+dTiXjvmnjtI=;
        b=biGQBj2G4TPm5qDQgcgKgHzbPZFjunZThdC7upjLFC1MrxViYNlWzKnnDDBNW9YOYq
         pIoQumN8lk3OmohmHnpkjjDfVdmX16xfGhnmAbFG/eutckAbTgyLC0jCJ1s8Far2cTMY
         DBri7lmvm0pp99vG5Flnl69Bc2i1GRkChhsGQeKi7PVDLFD3KrnB4qJBkmK9oKV/JNGf
         cOgPsVMPxQuzA7CiJr/b6bhFnBlzJuKKs9zJ2NCv/TZ1uzR+uYHC5mP/4Zxj6J3Q+nKy
         BnZ7H4Xa23iFJDpOoZym6cn5s7F5Pkq2DrIw1jxAh1Kug3RfO7go5wBN2XoPxjlf6SnE
         ++Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215232; x=1732820032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sPf5bDD3hksLR3rzX7SusPWKEW/ra9S+dTiXjvmnjtI=;
        b=g20JU+iBeMCYdbZxWwDRoCL5T80OPd5n7TZaZbaaIGBP7To2E+QPNdr7GGvBQ01i8S
         M0gws94q1lJ/vJzRDEhp8prZDFGQhFvtOLLWcckaxGzUo0dqxyjDBGLk7xnqqyiDTKJS
         hIJBsQOF30JmTNv8BWGFZ+Jk3K1Rzgcj5LEZQ1b1EIiH2IG99uqU0rxVTu2sWYa/zkQf
         XnQXUV8hfDh15iEl48aTVX16/VHr6EUvFZ36GPh5XY2L3immNES7k/mhsS+s+idVqJXt
         cjhNeE1hiwWRb6jEJakmtqmGa2pRelKaJos97SJXJ8Euyfey3SzCLD9yDEKzqdHuna+3
         anbg==
X-Forwarded-Encrypted: i=1; AJvYcCVF4kUNDzxDaBwQZ/Qw+SdimOWKcoFQKtSGuPV5gcamGBzIxKO2y9Wdh7vyL+YosAlQ/uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7FXcJMXTOTFqrYr5oeOxn2he95Q4CshsLt50Fl5xcvp2S47Je
	wcwjIsYYLJknDAGtsdCwl7DY9yEqwlp43GImi/4Hv8+90t2bYOf0lOEH3oKnTfoXbS8PG4zw5oh
	xFY0N5Q==
X-Google-Smtp-Source: AGHT+IGPeTewj+iJvEbKTL9QyGdyQogrjTSOIxx2PfdMSr0ggvJqvr9e70xwTnl5Z/jK702TslGml2RZu/Gc
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a63:6307:0:b0:7f7:1648:276b with SMTP id
 41be03b00d2f7-7fbccaa9bd1mr115a12.4.1732215232189; Thu, 21 Nov 2024 10:53:52
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:12 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-21-mizhang@google.com>
Subject: [RFC PATCH 20/22] KVM: VMX: Pass through guest reads of IA32_[AM]PERF
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow direct guest rdmsr access to IA32_APERF and IA32_MPERF while
continuing to intercept guest wrmsr. Direct read access reduces overhead
for guests that poll these MSRs frequently (e.g. every scheduler tick),
while write interception remains necessary to maintain proper host
offset tracking.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 arch/x86/kvm/vmx/vmx.h | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d28618e9277ed..07f013912370e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -186,6 +186,8 @@ static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_CORE_C3_RESIDENCY,
 	MSR_CORE_C6_RESIDENCY,
 	MSR_CORE_C7_RESIDENCY,
+	MSR_IA32_APERF,
+	MSR_IA32_MPERF,
 };
 
 /*
@@ -7871,6 +7873,11 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
 					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R,
+				  !guest_can_use(vcpu, X86_FEATURE_APERFMPERF));
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R,
+				  !guest_can_use(vcpu, X86_FEATURE_APERFMPERF));
+
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20be..929f153cdcbae 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -356,7 +356,7 @@ struct vcpu_vmx {
 	struct lbr_desc lbr_desc;
 
 	/* Save desired MSR intercept (read: pass-through) state */
-#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
+#define MAX_POSSIBLE_PASSTHROUGH_MSRS	18
 	struct {
 		DECLARE_BITMAP(read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
 		DECLARE_BITMAP(write, MAX_POSSIBLE_PASSTHROUGH_MSRS);
-- 
2.47.0.371.ga323438b13-goog


