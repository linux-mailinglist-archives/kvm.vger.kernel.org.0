Return-Path: <kvm+bounces-67515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC13D07183
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 05:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8DFF630096B6
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 04:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13FA627B32B;
	Fri,  9 Jan 2026 04:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZ3EZbbG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41987261B91
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 04:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767932131; cv=none; b=iosLB6fqK0gZDYElxobYYMIizoP4EizF4PjzIBtXkT0nDOFMh5rOnYBUdGG36LC9nFilfbSvfGyRf0Antj1FDOqvS8HUmINjkifJf4KP+8ffjrI1nK/jjeo4MCUg+9w4f+fMYL6maqt4M9Zp0SdHqA2cuh9vw1QFlIJi39k9aCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767932131; c=relaxed/simple;
	bh=ttBmpLMWidEdkz97YFQ/9Dt2bR+bS4sY/4Xw7P8Aaf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GxU8+PCMxW5Aj2I4DjUYkOXXKtz0bHi/ZeMxeehC8V94ufD7Z58hhzdsEGk2WKnhTZapb643mu2iJuwQ3Q8ZG6o5jFqN6ksd+UhybYP1xJvjNFhKehAfyrfJ8LU5lcyRxt4/+mMxcDNpZTwZcSt31kCs3OFXWvc7+P6VAgV304o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZ3EZbbG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c552bbd1b03so710841a12.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 20:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767932127; x=1768536927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3GHidu0ea60roJ0gGQhZj+Z1e5++0YYDkHwGtRpk6Cs=;
        b=lZ3EZbbGnlnNKGvXt4vemw06Jbefhh7SYvVKOaed4AS0qp9QZSZRCh7r0d2JPW9taK
         2rX0S3jbkRBhxxiuLVtIk5418B6hPp/g8G0GR24RvUlHd4RQFCv9oyJilGdzgaLaTdKO
         6ii/nwIqLF5NBbZvVGvlgK23L0z0AljAHNoRHP2Vy2ImgjP76DHfSpZST2FSxL2qaTd/
         8CKQSkBkCqok03z0N51BAGPgUZO2Et+TD4eWjM2V9C8BiWoUFnnwMiv/5EnOz6NE4Yci
         9jbdH3+V53JDidksnoCpwDckmJzowyt4wGpoqOYp5esYIF1kB07zUGmQIYyOYN1W9RXP
         ZQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767932127; x=1768536927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GHidu0ea60roJ0gGQhZj+Z1e5++0YYDkHwGtRpk6Cs=;
        b=Ba9B4oe0ot2EkZw9LTy9KsEgy/TkVWFKUq5JVNc/x69yTIMCiVGQO22IVQ4hdZeWda
         Moa1KQ5x94g+BO1cMF+YyGKTagtBZtpNDgSyCBQjy8haP4FheaAdBQ40C38q8OTuuOdx
         VJVuAzACcWgOGv0BiuGNKIav9JW8LjGhJcPb19xS5Sw4pXXJkWRpI+SG1/y3JQyO/ZkI
         bGuAKYYiav0oPOjcAKBod4c1xhUoMMStNLMGP2HqiwCgW3jVazgpU50skZTEv+bGB1mX
         aySb2x03rfeUs4Wo3XdDjqNsBEYw8NUaDk4zSPBmXXisemZXqgIfLQsDfMUid/UmscUB
         4Qyg==
X-Gm-Message-State: AOJu0YxN7xVxVRDvT9X6GkUf9tuCBN2cV6cmftTzSeNlpDiszruy5UFR
	+Q/G9HHWZ/XSKavqGc0wkVh5GGV5D8oq9fL++Q0snFGrcgjtWg1WmxNJIYDRc+lTsWWdqIDLp+r
	fj/FpTg==
X-Google-Smtp-Source: AGHT+IHgD01Kakv5duDK42eGXuAPcJ3NtDZS3hrl9d7PTOlzUyB8ND722Ru9FIyz63vVI3/ImvorWbJHbZA=
X-Received: from pjbml23.prod.google.com ([2002:a17:90b:3617:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a0:b0:364:13aa:a526
 with SMTP id adf61e73a8af0-3898f9bde7emr7933220637.60.1767932127537; Thu, 08
 Jan 2026 20:15:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 20:15:20 -0800
In-Reply-To: <20260109041523.1027323-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109041523.1027323-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109041523.1027323-2-seanjc@google.com>
Subject: [PATCH v3 1/4] KVM: nVMX: Setup VMX MSRs on loading CPU during nested_vmx_hardware_setup()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Move the call to nested_vmx_setup_ctls_msrs() from vmx_hardware_setup() to
nested_vmx_hardware_setup() so that the nested code can deal with ordering
dependencies without having to straddle vmx_hardware_setup() and
nested_vmx_hardware_setup().  Specifically, an upcoming change will
sanitize the vmcs12 fields based on hardware support, and that code needs
to run _before_ the MSRs are configured, because the lovely vmcs_enum MSR
depends on the max support vmcs12 field.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6137e5307d0f..61113ead3d7b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7407,6 +7407,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
+	nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
+
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
 	if (enable_shadow_vmcs) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..5bb67566e43a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8670,8 +8670,6 @@ __init int vmx_hardware_setup(void)
 	 * can hide/show features based on kvm_cpu_cap_has().
 	 */
 	if (nested) {
-		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
-
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)
 			return r;
-- 
2.52.0.457.g6b5491de43-goog


