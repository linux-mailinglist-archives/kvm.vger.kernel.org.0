Return-Path: <kvm+bounces-47428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3734AC1828
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6616A40D6D
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 23:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2772D29DF;
	Thu, 22 May 2025 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h/xb7X3R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6882D1F72
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747957073; cv=none; b=mhk4ZEHdssxPTKdHoiou/Xmf7X/XVsVCiGuHB8XRhrC2bMY+iZJ4vIWqU4dDggDixJI8vdkU9hru8609FAp9Shi70Q+LhAVujOXRa69z2GqU+YAdt9OK7DzGTO7L7Adx2jamjMhB01UpPwwFlbP0Mk+IQCdS9mG4b2FSEVRO/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747957073; c=relaxed/simple;
	bh=vRgPvO16SMJb3ieXUqlhCqh8srFYVsp7VBXX2an5x6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k/LSZQ2H1/rhgAxFma9Pedf0RvjHhbt3uGcROWpCunrwEuTnKmwi0CSrElzE8UWQ78V9z9C8HvPv4moCoDSqH8FL1Z07iV+BvIOa0/0/O2ubbxAx2et0l83aKRIJ+wf7LyN8NoLS85DQBOkdtr35b4ECzy954beuWHNHMv/MGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h/xb7X3R; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30e9e81d4b0so8163895a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747957071; x=1748561871; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=33x8wnTKFUGsCYrD9G+PbnP8XxuzA6yDnz1QlzvR1XE=;
        b=h/xb7X3RbYuTFn7O6B4aDWF/Tp5v1c9qVDWQ3pur9N1SB1pCSCzbI05MZljUhdky2C
         ffTq+eLBQiWmAnmbDjEMQV1aDjKJXq1yDOktRNVyhwB8nLebrU3AwRrNg7k3YQsZjaGo
         613miveoPTYRa60qavFZRlKK0m+v1NgRfaR0C6NuAh/LIYYB0tyfd6/wo3QfSxD/B0k9
         Filuc7VALmcXGVESORq2gTUBwMAS/iOetMr5OYHMjyGX/5NLmTY0+w1fk/JoxrIN+0TU
         PTyDY6QkuwUGAA+5gJCP9Ro0Vueh1j9W/LGGhbI9qj6m+BLgml0Fg5XMPSOx1rP/Uy+/
         Tj/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747957071; x=1748561871;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=33x8wnTKFUGsCYrD9G+PbnP8XxuzA6yDnz1QlzvR1XE=;
        b=wl+Mdhonu/KFhT7BuBXlR3o2V0YYvW7bQMKaq60q2HYytoagZ56FwKdzGkKC0u0RIm
         CY4JnOSq5kTQZyNMivOVL7z+iQlAe7uW/mAadBttX98AMvgiCq5mIXahZQenKY86/LW/
         tBTZzSWhzM2FVHRrEAO5JKRM/WmQvThw6d8a9UZZOTCb3QnGWAMhm49+vUbeGAPYL71q
         jiXbAKC09QX06a/oTsbg4s2RFqMsmdExYHreeG1ng+YAxRiPXaNCDJe8FCesDKHHrmEd
         vpxEA47/1q4XSTrs3+NrLcTV1k3MM6E3baNd2tvNRco/onhCubi7f3XtSDrxM4cMo5Ab
         HRtw==
X-Forwarded-Encrypted: i=1; AJvYcCUIUeTz9XSnD+SFkHoM9AkszgxtzTPpmMQP6djKYa54tJQtH/68Y1e+goNJQd2Tq+YHJws=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxisgc5mkpxUeU4ms6oTgLmU/v5HL62L/4w/OtfJPfvFSGQr6EV
	JxnBz7pM/xSYioqvIfm17OYqMeOkO590BMafYxOenCbMt7ZXA4pLjHm4CDExtcXcaJypfFaFKTn
	u5tHOFA==
X-Google-Smtp-Source: AGHT+IErYR2fX0uqEW1Jt/hDr6m5ozY/eqMBmYEYZGX5WIbNApF2YfAu30cVJqx2+qm/KLiZMSEgVzM0R+8=
X-Received: from pjp15.prod.google.com ([2002:a17:90b:55cf:b0:2ea:5084:5297])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:2ff:6167:e92d
 with SMTP id 98e67ed59e1d1-30e8323ee6emr34142590a91.32.1747957071505; Thu, 22
 May 2025 16:37:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 16:37:30 -0700
In-Reply-To: <20250522233733.3176144-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522233733.3176144-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250522233733.3176144-7-seanjc@google.com>
Subject: [PATCH v3 6/8] KVM: SVM: Remove wbinvd in sev_vm_destroy()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Kevin Loughlin <kevinloughlin@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kai Huang <kai.huang@intel.com>, 
	Ingo Molnar <mingo@kernel.org>, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Mingwei Zhang <mizhang@google.com>, Francesco Lavra <francescolavra.fl@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Zheyun Shen <szy0127@sjtu.edu.cn>

Before sev_vm_destroy() is called, kvm_arch_guest_memory_reclaimed()
has been called for SEV and SEV-ES and kvm_arch_gmem_invalidate()
has been called for SEV-SNP. These functions have already handled
flushing the memory. Therefore, this wbinvd_on_all_cpus() can
simply be dropped.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a7a7dc507336..be70c8401c9b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2879,12 +2879,6 @@ void sev_vm_destroy(struct kvm *kvm)
 		return;
 	}
 
-	/*
-	 * Ensure that all guest tagged cache entries are flushed before
-	 * releasing the pages back to the system for use. CLFLUSH will
-	 * not do this, so issue a WBINVD.
-	 */
-	wbinvd_on_all_cpus();
 
 	/*
 	 * if userspace was terminated before unregistering the memory regions
-- 
2.49.0.1151.ga128411c76-goog


