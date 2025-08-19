Return-Path: <kvm+bounces-55071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B77B2D06F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC94C7A6972
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D284274B3D;
	Tue, 19 Aug 2025 23:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S+UWy5hX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E7353369
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755647321; cv=none; b=Z1+96HgWp5B54T6C1C7/OMAAVFt3k0qD/KZJ0p2IOwZK7eStzlzItURisCwNk8ErAPGQn9e7ewmt7KO/67SoUfLz7jjn67QyuSyx0BFI0qNkcz6IPQXeCvJ3hEdkI5c40wqzUBsS9IKYCegE8sCmFWFf25VnkHVaTSDvzkY46xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755647321; c=relaxed/simple;
	bh=ipi5PwD6DhIbf3gYVU2ymmMUm98ZU1rlUPL/Kl/mjW8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OQUKaCcvGwBN6HTR+Kt8QzmxMfVE8F8JpYIcMgnynHgyJ4VKReO+RKCtBWapEFtLRYaDsZrkKOZYcRWc6PPWWpfJgZWtHGDFbbZ1NgMd7kBU9/mityXDP0MV1pajn5K9F2OTpFjiSFtJPCj3os2vB9UvXyETTSkFbfG1Iayko4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S+UWy5hX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-323266d8396so5373091a91.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755647319; x=1756252119; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdoJo/zbx2DmtOx+cHfD9+/wXtCkplcL6AhGPh6iBPw=;
        b=S+UWy5hXBc0tw4mN2EgdrlRsrxze87nWMFv8xksune6jqa/j2DxKHVJ3s0Y0bRNWRK
         iyijE+q/dpoE7IzYqpePpgcybeZBbNA1rjbBYLZYOj7QCJjuccjDHYLqK0KjR8oXXERN
         mxwCa3Bu3xKoVTbsJSMLCKte3obigdstk+A7oWM5tmkhhqI5yNwJsofZVVGAdHvlIpFu
         +aCe8Y2XAb4iFoGK2OBR8yiKrjSAdPodLOThrtn54ZmrwhLVAqVX5dlOZg7SlnSUn6rU
         VJ70ew/yGgE8sINcP2O2mKFGj5v2Q/CxQ073YYcEzHUadOYJElgQdj6Wvj71MLHS0GGu
         GzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755647319; x=1756252119;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xdoJo/zbx2DmtOx+cHfD9+/wXtCkplcL6AhGPh6iBPw=;
        b=PGHzBbhUF+F1VK+zK35Sm1NIuiJUsU4RngJK/oh0KdQdbXy3Wvfs8QX5jX2l1dj02r
         R121gSlyJ9vC/5nBg5MXCMs77R7n6lszhgwrABhZ4Fb5Q4JSHrFs/XLvIntIyEgmKDeO
         bqJi+v7HImDM/zsheOedKLeN9QCGPnI5sdPP4ZVjKeRKurz+Bk5pkgLXRviG3k70Ad3M
         My37koOoESqnKFpX/AfWB9GAiPD80tAIt+5BlQleE3mHSKs6mx9nd1M8oPsyzuIbKIae
         biTDiOeqNHFnjF3rTvg1dD4acySiM8Rj7hVhx9y/nJbXK9n1a4R/EJG7eypbLC8wUHqU
         WwCw==
X-Gm-Message-State: AOJu0Yx8avV509kUJjzmZhx//t/tYH9bidjax5O0vbOljfobeO5+ifo+
	WvZsacxqLsWWskbXeVaO8o5MKxUmw/ABtX4+hWT4pC1FSt8hqAjySaTfaslehHB8yZCSvc+tijR
	j9ve1oQ==
X-Google-Smtp-Source: AGHT+IG6GP7ZW6sWxWYGR19K2Zbs+XFneALwWzzcq1D82H6w3JNAidLbm+h37buEX3XyOJzxPy0SI6sXWDY=
X-Received: from plnd8.prod.google.com ([2002:a17:903:1988:b0:23c:7695:dcc5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84b:b0:240:417d:8115
 with SMTP id d9443c01a7336-245ef153b9bmr8320805ad.16.1755647319501; Tue, 19
 Aug 2025 16:48:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Aug 2025 16:48:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819234833.3080255-1-seanjc@google.com>
Subject: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, 
	Vaishali Thakkar <vaishali.thakkar@suse.com>, Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

This is a combination of Nikunk's series to enable secure TSC support and to
fix the GHCB version issues, along with some code refactorings to move SEV+
setup code into sev.c (we've managed to grow something like 4 flows that all
do more or less the same thing).

Note, I haven't tested SNP functionality in any way.

v11:
 - Shuffle code around so that snp_is_secure_tsc_enabled() doesn't need to
   be exposed outside of sev.c.
 - Explicitly modify the intercept for MSR_AMD64_GUEST_TSC_FREQ (paranoia is
   cheap in this case).
 - Trim the changelog for the GHCB version enforcement patch.
 - Continue on with snp_launch_start() if default_tsc_khz is '0'.  AFAICT,
   continuing on doesn't put the host at (any moer) risk. [Kai]

v10: https://lore.kernel.org/all/20250804103751.7760-1-nikunj@amd.com

v3 (GHCB): https://lore.kernel.org/all/20250804090945.267199-1-nikunj@amd.com

Nikunj A Dadhania (4):
  KVM: SEV: Drop GHCB_VERSION_DEFAULT and open code it
  KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
  x86/cpufeatures: Add SNP Secure TSC
  KVM: SVM: Enable Secure TSC for SNP guests

Sean Christopherson (4):
  KVM: SVM: Move SEV-ES VMSA allocation to a dedicated sev_vcpu_create()
    helper
  KVM: SEV: Move init of SNP guest state into sev_init_vmcb()
  KVM: SEV: Set RESET GHCB MSR value during sev_es_init_vmcb()
  KVM: SEV: Fold sev_es_vcpu_reset() into sev_vcpu_create()

 arch/x86/include/asm/cpufeatures.h |   1 +
 arch/x86/include/asm/svm.h         |   1 +
 arch/x86/kvm/svm/sev.c             | 108 ++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c             |  37 +++-------
 arch/x86/kvm/svm/svm.h             |   7 +-
 5 files changed, 92 insertions(+), 62 deletions(-)


base-commit: c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
-- 
2.51.0.rc1.167.g924127e9c0-goog


