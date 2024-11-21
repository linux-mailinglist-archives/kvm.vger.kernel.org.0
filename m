Return-Path: <kvm+bounces-32301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC139D5315
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 20:01:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14B49B21CBA
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE291E1C2A;
	Thu, 21 Nov 2024 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U81UXU5U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6616D1E1325
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215225; cv=none; b=JFl/0JZ5nl6LF8LA54y9uYl2+lP4M6ViDq7fCq5SyAIImc6M3DIq9HDrxaV9QOy2vamRcJttazfrkd85RcPHnMSCG5IQtr54lCoWQ0CZamsjCaQ9xYvBmJy22alA/TDfrx+mu0OzaIo8w94xJA+iyu0AKKXNs3kEz/M01TCpmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215225; c=relaxed/simple;
	bh=dpvmC6fUg1oYhPj0KX7fGNscwICe9zRsrr6N3ofRupc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rRf3mN81Cwru6y3WAAxAHqMlYxStP7KhpEvLrX5pweoRB8ws7pwwe1aRSCNtyVil4K8uYwgD1eV+vamXOSQV+N4iX8xDM+nF5rWEbHqTjwtZ/dPkG8cAz1zG4bUKqaUP++9Og73MvsfvVVjctBRkEQA70ifQ8Zdb27MUi/MBmLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U81UXU5U; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ee7ccc0286so20553407b3.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215222; x=1732820022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PTZwTdWNiJi5zJc4U346f9dQ01Nf48/ag1/NR2uEtTY=;
        b=U81UXU5U93yVsVK8sO+tVnlyAYBKwLw0nHgeFyomsvzKhRJWKqXPsJhwJDXZZRM0ir
         ZlcQiXYSEBqYwAqrMRgCvghTfTafXu8zLr99pOzjhzaCpdP2pVzRLzTh0qXuHXK7G+lg
         +7sIiIR/rS69XQ78TQQpjzztRwR6dWLlKO6mDFs2z5wPtGR1m+WMsneLu3tUeUCdJTKv
         U2AmY5IAeASvhaPYNpz3r+Sj7c0e8EE/54Gg+VGqxAWloBYoCmtFMG48zJM8w/iY9fWq
         arDxZEUTs1KNiI9J5ixPO+Y2UTbj8R9ZwIxzUBxZ02eHRC56cMqdYSn/7du4+VSPFvBd
         R2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215222; x=1732820022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PTZwTdWNiJi5zJc4U346f9dQ01Nf48/ag1/NR2uEtTY=;
        b=MTXW/1wu6/bGodHnMxYALUE3ApuFh69Y8kF7SFuVY2A1o6w7ID7KTyI8/XFqRlgxNv
         bpeIM8vruhx/rVfv2YsgDFsHHu7jpKrPMlLvENhTicM+nx2uydUYDM207KdA6EVGK5Mi
         pnT3H2aUBuxxykPGza8oyvgildhOy5RAehHEDYb7bW7tlwK/aQrrJzrdiY80Fhp2734z
         fFOAOQandInB4GZprjmPTtFKEjF8/LfdoxSAuwcbXVVkCWRuHVusgfIQpNtMZAzyDHh1
         FLP5qJe6yWxqYMVchSlsUT6tzHGeZkrp9g3BIa57Xk40VTBbmc25zS9nReOZYXR9Mvvr
         Jntw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ+AzuvRJWukCPvT6jaZSAhsNMDmkLTfiFbVlqY8+QTKx2MCoiKbJjZKq302R8kV5EwJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD30OjqWR4pzkXre9m6isOH0QvOvlAXAz+Y6xJ6KR3f2xj741p
	gd270PbkXse0GBK3C+OYMx9PHgY+76whrIARQ0gk6EufLwOtU0A0FOWCPau5o7UsEWPb4piC4l7
	xOnByhw==
X-Google-Smtp-Source: AGHT+IHARvlONItudnx3LP0qpCsMs2eWD55KOxdOXi+6vEQansb9DlnkhO2mSfcmALCI/jGewWhmjCqnweLA
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a0d:dc04:0:b0:6ee:8453:f427 with SMTP id
 00721157ae682-6eee0a5e9dbmr1207b3.7.1732215222397; Thu, 21 Nov 2024 10:53:42
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:53:06 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-15-mizhang@google.com>
Subject: [RFC PATCH 14/22] KVM: x86: Introduce kvm_user_return_notifier_register()
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

From: Jim Mattson <jmattson@google.com>

Factor out user return notifier registration logic from
kvm_set_user_return_msr() into a separate helper function to prepare
for the registration of KVM's user return notifier from
kvm_load_guest_aperfmperf().

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index acfa9ecc5bc36..6df8f21b83eb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -637,6 +637,15 @@ static void kvm_user_return_msr_cpu_online(void)
 	}
 }
 
+static void kvm_user_return_notifier_register(struct kvm_user_return_msrs *msrs)
+{
+	if (!msrs->registered) {
+		msrs->urn.on_user_return = kvm_on_user_return;
+		user_return_notifier_register(&msrs->urn);
+		msrs->registered = true;
+	}
+}
+
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
@@ -650,11 +659,7 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 		return 1;
 
 	msrs->values[slot].curr = value;
-	if (!msrs->registered) {
-		msrs->urn.on_user_return = kvm_on_user_return;
-		user_return_notifier_register(&msrs->urn);
-		msrs->registered = true;
-	}
+	kvm_user_return_notifier_register(msrs);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
-- 
2.47.0.371.ga323438b13-goog


