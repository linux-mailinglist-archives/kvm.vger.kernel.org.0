Return-Path: <kvm+bounces-24422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7F89550CA
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 20:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D2EA1C21B3A
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 18:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B679D1C3F34;
	Fri, 16 Aug 2024 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VKN5S+Rp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963861C379E
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 18:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832768; cv=none; b=UfickI5WcfnmfKldXZWp6aDccw/zFwWMsX0k4PbCc6vD1id78WUc3qn5eRoIjTnAlbhigI7ciC0wZfgsI2fd2Syxtait8lzSHXzLBEMhQHsjMYLOBXqmOmddF7CIg4Gu3gHODY5hKfC8a1KlM2m8fM8vtp7aOVKwwmH2BXBbGV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832768; c=relaxed/simple;
	bh=MJC7nEJsLQW96ofZcmOX1FaidhLei9K4+rANZcg3DS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LtjKR3GYmbFR4O7G1ttuL32iCwVa1WWs3jFqZQ+xoknWcNj7u6ofSCPloU3+EKP7LL2FhrsYhpUflfJ9phyiwDy5mMru1O1mnX24n3MZGn7hUG07J1EmzAFDumaW2srSO7EjyK5IU5KSFkCCsxnwV4/+SS7h2LhgddnwI+8vUPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VKN5S+Rp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7278c31e2acso2269983a12.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 11:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832766; x=1724437566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i0/Dzxs86f6ftJO2B1jByWJPM+C0/huK5/pjbVScDDk=;
        b=VKN5S+RpM/+izq4LXgzNVUocT2HaYKOnfXRTKfnd2aOy6IRtVJ+lb19JEyrSgJ4tiR
         8uyBxNeiOlRH/UwQhMB7sQ056YsoBCUbs1NI/UwEEvmNddKPxKQVw1TMlhT6echQ+P2w
         E9LmFgJ2I/vjIqhDcMr5XlqVaEJI4PWwDO+0R4/C3HZ2m/hYEUEEPukR83tgilTY5pVo
         nvbu7zfT8wUDKODqFyQFHv4JT5yXjIqv66znqh3fiA0tfTpFzejdV25WpofLYamdpHtz
         ztycsjC0xvKYjeXJuTa/QlJDuUAs2AqQtunNE4D6+k7EblC5M+bg9XCsiG+RrIP/D0TX
         XLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832766; x=1724437566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i0/Dzxs86f6ftJO2B1jByWJPM+C0/huK5/pjbVScDDk=;
        b=cLK8eEfGpfnUtpXXDYlZIrZ48BPc8TBROUJwOYzKf/F8VYMWKfOGGHHaJ27XlkgOCA
         0VL9ChZ89vG520Hnl7cpzU+jlDf0vYRnC6XNQ7YOGt/H7vpWN3BrgVui3uxs/2F31mCR
         axnzMNGPbqt1X8lh3Q350MK28UAl4euvpnaaThO0grveR8JlsC9X3n1lan/9eLqlfepi
         tMQg322TtxxAy4RK4ayDqoJrFdYM/VntpVYqfikFx1fWJIRuihQFNYqBxWl2kIEiL0jS
         nrNdu7NUEBKxqFEl3h7L9n+YJCREaLjRwghh3hXMqsP8XH0wZ1mDhIAV2HOyvylAIy9c
         oZIw==
X-Forwarded-Encrypted: i=1; AJvYcCXxzSlSR3u9FIMxrGrcTz8HWeM9b8AUX1zQF1BxiSPcPAHCPVDNnXdjNe3mo87kc/dpDVDTnhqLTxYKGfUzUv27iqG+
X-Gm-Message-State: AOJu0YytOhRjAWz5Q9xdFAx/3HvQtjgQhWFlDJKqJub0By+fIeMOTAxh
	RjEfHss0eRqjkNm6As673s2E9BNlSJ0e1Gj1v3WYlYDsb1D7fRsUlhqPHRNil6K+EElGQGT+/Ik
	jgr0nqgLzyw==
X-Google-Smtp-Source: AGHT+IHuK0XyI9quxEpVXMzaV02NmnG9/saRSfQMGl4jJ28Ky2gHkkoF49pjkowXvl/2+5uvWEfSmZJJeu1AwA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:90a:e516:b0:2d3:bd43:789d with SMTP
 id 98e67ed59e1d1-2d3e00ef3d0mr40938a91.4.1723832765467; Fri, 16 Aug 2024
 11:26:05 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:25:22 -0700
In-Reply-To: <20240816182533.2478415-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240816182533.2478415-1-jmattson@google.com>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
Message-ID: <20240816182533.2478415-2-jmattson@google.com>
Subject: [PATCH v2 2/2] KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Daniel Sneddon <daniel.sneddon@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Sandipan Das <sandipan.das@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>, Venkatesh Srinivas <venkateshs@chromium.org>
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
 v2: Use IBPB_RET to identify semantic equality (Venkatesh)

 arch/x86/kvm/cpuid.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2617be544480..044bdc9e938b 100644
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
@@ -759,8 +761,10 @@ void kvm_set_cpu_caps(void)
 	 * arch/x86/kernel/cpu/bugs.c is kind enough to
 	 * record that in cpufeatures so use them.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBPB))
+	if (boot_cpu_has(X86_FEATURE_IBPB)) {
 		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
+		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);
+	}
 	if (boot_cpu_has(X86_FEATURE_IBRS))
 		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
 	if (boot_cpu_has(X86_FEATURE_STIBP))
-- 
2.46.0.184.g6999bdac58-goog


