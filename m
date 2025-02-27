Return-Path: <kvm+bounces-39493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FB30A47235
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8FB283B32EC
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F43517C225;
	Thu, 27 Feb 2025 02:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NYBCZS58"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B701B653C
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622755; cv=none; b=jFbKgCJbk9DFtCyNNdbomJecRDVwedxDWdJqs2wOqtqU+oS8eq3x3lffpJfyE+VCxtizuCvqtXIb9irlq1ocGvQPyAhdbfcZzXrXb7rQ9IUUtfDQN388A67Yas2hE8h/X3P5C7B9CPAjuQeOWR3TWF3wPcoqRAWimdWwxmCzXoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622755; c=relaxed/simple;
	bh=zouDyKCvgpfKjJTRdNmQrbmUt1upitIlri45/tL/V2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O/ksbOS+xndi0/zlfH/MM7uL3VPRzrWZ/lylgOf6wWS4j93ot9jdWIRuJXGl0c5O+fmdLOE4X7GwmuG2O0l/fBSwXcPGplCV2Jynb2RUv3TRkPhnULnpp3i3q6aRJpjvgdkJa2e+z8N/QjXVE94ggZTm/44bDJNawhBVVx6iD4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NYBCZS58; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc5a9f18afso1085285a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622752; x=1741227552; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=JV0vL5ay0SjXSCwSvRRqMw5uYQ06F8yr+AS2fSIuB98=;
        b=NYBCZS58L0f/9PeWx7lqjHczttpcvhByhEy6/htzrG7ZDmbRs4hbvRKAcpiViwVFkp
         z/ACXB4U3NN5K5CSAcZTmLbUQETJVhXMbu6mKpoBpDewcv9usu16GoOTYsAiaBEUzNOk
         bW8f5iTVnyfNMEHPxcrkJ24qAJfi9rIocHPwjjklffa3yD7/2WExma/gQ/mT50f/Y4Jk
         XyZWkX3qHgOMVIYeOay1xgirs2AyZJUmScRp6r+AG+/UpKpXxKGi6VjNKGE3Q/t2OMhC
         JKXwadCWKCDJ2QXP7DkiIHl0BGP9c4W3B/+pVyY2qBPHf1oYQ9aoieGyGgLdZ8KvT72E
         ldXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622752; x=1741227552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JV0vL5ay0SjXSCwSvRRqMw5uYQ06F8yr+AS2fSIuB98=;
        b=Re818y6muG6UQfc18NHOUGJPPi9Lsxqjy1cPQ9a9fDjld6+keyLcYXOPCWVxWh6PDB
         NK62rHfjgLxEGFzIfB4hpIMboelpk9wNIOyrFjrMb+Ar5Z0fIQGdvE4iq4GLy+2rkySj
         CCVlwkJQM9zFkHfkzFWQe0w/PLSlzE7hvZJd/+glVePeKcn+pLS85lhPtL559TwMnt7x
         GQrDADCglxBbicL39XmmU+QtQDc8lGTOBGYdZ4PRMVToSSSBZZquOopk/ONb1WsQZnwH
         C/wG8BAskY4Nb4U4XN1Qi8pAvzbKpPYWNRK3H7h/guXQr9axE3e3oE5tX+v49Eavyj2D
         jbiw==
X-Forwarded-Encrypted: i=1; AJvYcCUyqXqh4hhLq1QFrYTAPtj8BIhKofeSyuCwek/X/5AiTA2VAJyrYwgwU+anSW265Zx221o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx051NAciUaDaX4GVMGPeQ9anQbMK8nDWUmoyEHEPIH8dMJq5Wg
	Bl6K8piLnGZZQoJhaP4dHed8Vaa8t1eit/UEITibiy+nywNFBoyZkXOSISrAKAeOXmAp/ngMy1m
	mJg==
X-Google-Smtp-Source: AGHT+IEvNph7CiMpObG1u+jVz8JxqMtO0a8+Wef5S19XtPgcpuEdHq4SZt8ZBvsmjyd64opTzInKcYcJX7E=
X-Received: from pjbsw14.prod.google.com ([2002:a17:90b:2c8e:b0:2fc:11a0:c546])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3b48:b0:2fc:9967:acd8
 with SMTP id 98e67ed59e1d1-2fe7e3b327fmr9422757a91.33.1740622751672; Wed, 26
 Feb 2025 18:19:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:21 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-6-seanjc@google.com>
Subject: [PATCH v2 05/38] x86/sev: Move check for SNP Secure TSC support to tsc_early_init()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move the check on having a Secure TSC to the common tsc_early_init() so
that it's obvious that having a Secure TSC is conditional, and to prepare
for adding TDX to the mix (blindly initializing *both* SNP and TDX TSC
logic looks especially weird).

No functional change intended.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/sev/core.c | 3 ---
 arch/x86/kernel/tsc.c    | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e6ce4ca72465..dab386f782ce 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3284,9 +3284,6 @@ void __init snp_secure_tsc_init(void)
 {
 	unsigned long long tsc_freq_mhz;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
-		return;
-
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index d65e85929d3e..6a011cd1ff94 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1563,7 +1563,8 @@ void __init tsc_early_init(void)
 	if (is_early_uv_system())
 		return;
 
-	snp_secure_tsc_init();
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		snp_secure_tsc_init();
 
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
-- 
2.48.1.711.g2feabab25a-goog


