Return-Path: <kvm+bounces-24936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2285D95D599
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD83B285D87
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7BC0193421;
	Fri, 23 Aug 2024 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GcbRO07+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFD819307E
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439238; cv=none; b=IXpHGUMcphvizr5LSz7qVya7PeiadYY/NmduU9/tjnnfigTevJIp7eb4aQ1P3JQPgyLRfmEbCwCzon6Vnq2rO8a2CVWgdpnHQH99R36oQPfmQyled1IL3NhThEXniIaHXI8xGMK/Ew/Izlo5eT0meeGNVh+gHbBNP1jCmKTnwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439238; c=relaxed/simple;
	bh=MyBiTMGpmZrrLOJsOFwtm0ilk6ZZtI1A1HrN6ZN27qU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=r2l5XPr2KeYoaPGfbUBieIpBCdVL7Ep1SKezuCC0ZDqdwSgUxDPh+aRCHfPXBE/tQkrRjm45fMzBHXqp1C2l9JLOttHb13xtnDmi2kw4yehgIuTFA89ha1qFHn7nlpKbgaab99qE2sRSQbJyt/tWEcZzpqZThgqYSfTHhaI9pas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GcbRO07+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2021be03c53so22443855ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724439236; x=1725044036; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gVFZNv4GWRiUrVz98MUMToFQTqhf2FOUUV+ADB4mKm4=;
        b=GcbRO07+U4WdwIujPbNy9/nYewb64VZcOKHcs9PyPeX10MhJwMH4ieTcGKdGZZGF+O
         h6kLc0mCO+5i05vHrNyRdkjmoE4erRJFGqloQ5Xs8e+TTApGuwe3jp9Hymgujfi1SiDt
         MxB8d8ufQf7zXlqKGCY58Gqi+UEVVlvEXzFyeSOUhdz8rc45sbfUiKuudUIK/jf6eGIY
         n9gUlh24oh+Y9ZZu/M5uKXn8IbRmnnfVHUnzZNEO7xNY3YXJrV5ZQYb0bqdjEB9Q1dS7
         SUQe42Kf747fGaIyYEGwgKn0cQY3rexpbpGgBfI2FDFme+pI49W/aBi4vyU4doQTZARf
         CPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724439236; x=1725044036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVFZNv4GWRiUrVz98MUMToFQTqhf2FOUUV+ADB4mKm4=;
        b=Pi7ZOLGWP+7vNv/SUgi5IKks+viUI+mzWX23eRCxnV1QJxC+KSjBHFJDZIw+Nua/R4
         cz/8HFYYQyXdN7FoRBPngCyjn6B7sj9k9Ec3HzAKBXWqF1m5RIfUWcymJC6NM9WFu6rr
         IBMDvtsRbMp6y70B4QtHeiENAFYUZ6Z07juWnnToXebcg72SML94lH2MuRySQUZTuX31
         XwJQVeslBymAH2huUF2Bhss/mCo8UGEJkbChucADzdcaYnHfGI9PLMeMA9QXDbWInXdC
         jEx9hbLnIAKQh94sJXuayRW6IsSoylbsmCIK8oVlX/MKjYGr/yUdlQH9GR3nxMge3Yo5
         R+HA==
X-Forwarded-Encrypted: i=1; AJvYcCVRn5ON0uQIrgS6R126otDuwxhbMwpd74UcHztfPeZL/FPB5jyM5Qfxr98OjsQsOVVqkpc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8MZgOYeHoO8ygOVrrym7vlrj2YLZ4ug43x0ZYZbO9SjX6q1zZ
	iydnXHQ+IE/kkUTQiZwx4E7Yete+yq+pycjcSW2FyTFTo0D+gjqStC39r9cSGDB8J9fsMEZhLZG
	IZJ7UO47GYQ==
X-Google-Smtp-Source: AGHT+IEaaQ0Woq0T5ahHq+3E7nfEsKVxnKK6BQo6ogJ10ZT5yXqN8LciMB4mft0oDRdWnpV0B08MFc8oBeGZ+Q==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a17:902:c40e:b0:200:86f4:fa1b with SMTP
 id d9443c01a7336-2039e4a7403mr2517075ad.4.1724439235807; Fri, 23 Aug 2024
 11:53:55 -0700 (PDT)
Date: Fri, 23 Aug 2024 11:53:13 -0700
In-Reply-To: <20240823185323.2563194-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823185323.2563194-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823185323.2563194-5-jmattson@google.com>
Subject: [PATCH v3 4/4] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"

From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
enumerates support for indirect branch restricted speculation (IBRS)
and the indirect branch predictor barrier (IBPB)." Further, from [2],
"Software that executed before the IBPB command cannot control the
predicted targets of indirect branches (4) executed after the command
on the same logical processor," where footnote 4 reads, "Note that
indirect branches include near call indirect, near jump indirect and
near return instructions. Because it includes near returns, it follows
that **RSB entries created before an IBPB command cannot control the
predicted targets of returns executed after the command on the same
logical processor.**" [emphasis mine]

On the other hand, AMD's IBPB "may not prevent return branch
predictions from being specified by pre-IBPB branch targets" [3].

However, some AMD processors have an "enhanced IBPB" [terminology
mine] which does clear the return address predictor. This feature is
enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].

Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
accordingly.

[1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
[2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
[3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
[4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf

Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/cpuid.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ec7b2ca3b4d3..c8d7d928ffc7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
 	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
 
-	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
+	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
+	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
+	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
 	if (boot_cpu_has(X86_FEATURE_STIBP))
 		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
@@ -759,6 +761,8 @@ void kvm_set_cpu_caps(void)
 	 * arch/x86/kernel/cpu/bugs.c is kind enough to
 	 * record that in cpufeatures so use them.
 	 */
+	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
 	if (boot_cpu_has(X86_FEATURE_IBPB))
 		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
 	if (boot_cpu_has(X86_FEATURE_IBRS))
-- 
2.46.0.295.g3b9ea8a38a-goog


