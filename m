Return-Path: <kvm+bounces-68209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 541EDD275BB
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:20:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27F8D30D04BB
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EEF3C00BC;
	Thu, 15 Jan 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JXUOsJZ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084834216C
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498473; cv=none; b=JOrVIAJmb3x2KDMnOo23A6YYXSk7F8ZOsgRDplsoCmyqOIyYUjz+iuCv489/fl9FRkxswGv9fH4Z9SXlfNFZcLu3GDwQH6MRhoJy8KOIoGoV/l9FOYNHtk/4QKIXhCLoxR9NiAh7SIlt3Bvnv8CGpNdf5wc9myNH35/3V4gWTjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498473; c=relaxed/simple;
	bh=lfQFiFquXqqUjK0GK5LCQjQGJHjS+fT5W9fknUTJy3E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DEmKS5gOImd9Zeazvvwp6hgaCpTuDtTl6fmmS6gGN85fScGxbOG3T+Lr8NQheYu+SDkcI+25EgHetDtIWtLwC6XdtBEt+jMj1ExSdXRO+j2yU6ekNbfFksoYRvx2flMx5NLTpKktZqZZFaYOZs6PECE9eC2n60iise0bshSlCq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JXUOsJZ7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0bae9acd4so8788385ad.3
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498472; x=1769103272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vvhxNkHgD+GbG8VVPHPONdN8yxtGJ2U9E5Vry3vEwiU=;
        b=JXUOsJZ7ngjzn/UB7Q319pZzux8w4KoDVJL9Igx0jSt1b6QcfUmLEhw3uH81xEkjSz
         BB775Jt4fjyrXgKn7BKDZzI/xwSufXnqnOOB0rslx//YhuzpMBABz/tHx7/VbT8UoXM8
         lofWxZmO2jsv+E8+nXLhsUtjhWm20YF3wGHk4ngFllDupwBnKJsw22GUqtxSyHbngwK3
         ez4O0VzBWv8z4PL237Le5p8RWdF43qHe/okUwAxFn9pmKHRyfJh4LRyrOPLwPlmXg4mB
         a4lT2EZxZt4tGMJojiXZQM34c8xbo+KT6Asznap6mVjtTBrAZNUgOHDqrotzHI9zVNaR
         vY4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498472; x=1769103272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vvhxNkHgD+GbG8VVPHPONdN8yxtGJ2U9E5Vry3vEwiU=;
        b=o28lsEMn+kL2ub6lewiXtf+ybXLYEJExqSWLcIjFJjKXUdsIzN/x2QndrQRgGf9USy
         Qm/DIAkvfjq3Q9U2SYJZjv/1oT0aV3duNVscEfuCfCia6KernlXcbagJ8gIGH2p6x2sh
         udg/r3urgFldtEtZJRPEgbLck1JH45Kx4Yq/A/C5aHm0x3B4msbHDbyd6V1ZD0m3PJ1o
         1AeG2FYVlESwIHxseJ4o7SoJFOEe9obMUw9Woy4rkjx6k7PnXDEQZaTvXla1l/Fn0+TZ
         +1nkqlTwE+1HZ6ovnqo3uJ7Tx3L9XTdayA7HrVkbOUBcQRlaiOHVN4IDvcDWm1GxCbbf
         27hg==
X-Gm-Message-State: AOJu0YyeKRli8qZgZrU4FQq4QbA0/EKtiUe7peaQLeotocrr1ROe1Jh+
	jk9fdSHyL+9ZvNZ+UU/FF/mLqDAO3HzA3S31JtMNjVZizYLK6nkhYuBc46SOn5essYm4A+hbXrE
	vQCPMng==
X-Received: from plwh22.prod.google.com ([2002:a17:902:f7d6:b0:2a1:5f23:7ddd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40cc:b0:2a1:388d:8ef3
 with SMTP id d9443c01a7336-2a71754385emr3351055ad.18.1768498471672; Thu, 15
 Jan 2026 09:34:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:34:24 -0800
In-Reply-To: <20260115173427.716021-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115173427.716021-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115173427.716021-2-seanjc@google.com>
Subject: [PATCH v4 1/4] KVM: nVMX: Setup VMX MSRs on loading CPU during nested_vmx_hardware_setup()
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 2 ++
 arch/x86/kvm/vmx/vmx.c    | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 66a3eaca6817..76b08ea7c109 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -7367,6 +7367,8 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 {
 	int i;
 
+	nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
+
 	if (!cpu_has_vmx_shadow_vmcs())
 		enable_shadow_vmcs = 0;
 	if (enable_shadow_vmcs) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9e6c78a22b10..27acafd03381 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8846,8 +8846,6 @@ __init int vmx_hardware_setup(void)
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


