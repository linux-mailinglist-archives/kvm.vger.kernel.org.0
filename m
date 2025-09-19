Return-Path: <kvm+bounces-58075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CCD7B87756
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA73C1CC1486
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF23E2264B2;
	Fri, 19 Sep 2025 00:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P1Q+wUCI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AADF2629D
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241300; cv=none; b=KTEyJ/3A0JgLeZy1xszVctgJkKRjW/OXZElJPiC2fyCbBoaouLQO2Wa5nqpP92Evpm55EQl3KkkE/TP8tMGqNtg5WnZjDqB2lraQBK9KiOhdF+xh7OkOAIyWPS/xSUbyJI1Fv2BgNa7j8uVXuwcxlc6XUAm5+DSgrQqGmnsKW00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241300; c=relaxed/simple;
	bh=Py0Gqf4mW3z9BrBFdkfLUiq1lXFvm7wGPYYXdi+4lWI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DUWVRgZEaTeoMn/EiultILY5z+jTvdMAjVMi1XzXzJGGhoEToQmgeLmUKkLL/6h6Nu6BblB+zDWNY/OXyjY+Ih7Nn1CXoSw3dDb7HxmrplIsaLnlaVimVHht8P/Y1hLhmUsXRGYDcwtLxdwLoZ4YIlFmGsGx0WlrEqvnxK81ins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P1Q+wUCI; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b52435ee30cso1025277a12.3
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241299; x=1758846099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFuQV/hXyEX2NHGiw7Ns3OG8aFabTDnSTjs/IVvWYQE=;
        b=P1Q+wUCIa4xKdDDFCMdmqb3aGEC3Ln41gakM8deIcquqpwzfuepwLGrrfp5AGQ7QPF
         owSpC3mOu3ppTGM0fCNFiEkD7AllRq+nmfxywEI0R2Q5f2Dzx0QVvarUHBxCUuXwWF5B
         v3cd7VjJsFmwmOi/E4cIEx6zpxtsHD2Kj4LJompxVpll+3Qsp7cAkKFW2HWk6KHQ7YJ8
         VJHrx5MkJZoXVbpaXneqgmPvZyIWvUYFbVCiGnn0DRDyGOJo0YXmsqJh0TeaITjN99tK
         kAv7TDk87HUIEmsLSGU6T2aP5A377/8y9aStAbxsfYfeOPbYTDfAqvywoDm1TSBLFCig
         dL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241299; x=1758846099;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YFuQV/hXyEX2NHGiw7Ns3OG8aFabTDnSTjs/IVvWYQE=;
        b=w+/arKxvPFkBQiGRXK3JCfsJ4SWrxrRH1xnULJ1xDAWzwoHaxlzli8IO789QiPQ29z
         nwNx7b08cu3z3doRJdWtOy3QJUXHsRtm7yHdIHWYf8Z726dpZTWszK0ooUWsTRCDp/pf
         kxGMcxoJazi386eYcKvdPrkhpwJN/5UwznmztH2IH5IS9VEbAk5Zbdo5cfEiwN3ILBDi
         lQnn901z5EPLjjPyEJV3oz2+uSgv5I9pgkj1Q97MMD+q//g3M1kh3KsfVJvFy6tw6zCI
         VAuMV2+aAIv+WdbuI8e36BK/pRK4PwZdvaMvISUUYJp98g0ApbLHTiF1CdxosmmlGlb2
         lazg==
X-Gm-Message-State: AOJu0YxoryXvg+Jgq203NTzK7oHbFueIp4qdTtBFTk84hJWyb6CT/zme
	4IXz432Zyb6aI7fO5P/qNnkrFGLbPUuYjY4wscb+3qBp70K89bIjfhBtStdBGepTl6fYuY+FxUG
	pqB/x4w==
X-Google-Smtp-Source: AGHT+IFiFHqqY0Hd3Rz5DlEMEBLVRWCdOoDmkAOgdISqVW+S6KoPbmO/uoLubKn8Z6YZYf9uAAPwttu1Tt0=
X-Received: from plht6.prod.google.com ([2002:a17:903:2f06:b0:24b:1657:c088])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:7487:b0:269:ae5a:e32b
 with SMTP id d9443c01a7336-269ba430e71mr12775465ad.13.1758241298774; Thu, 18
 Sep 2025 17:21:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:21:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919002136.1349663-1-seanjc@google.com>
Subject: [PATCH v3 0/6] KVM: SVM: Enable AVIC for Zen4+ (if x2AVIC)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Enable AVIC by default for Zen4+, so long as x2AVIC is supported (which should
be the case if AVIC is supported).

v3:
 - Don't advise the user to enable force_avic. [Naveen]
 - Gather AVIC related module params in avic.c (by moving code/helpers to
   avic.c).
 - Print "AVIC enabled" even when it's forced.
 - Enable by default iff x2AVIC is supported.
 - Use "auto" to select KVM's automatic/default behavior.

v2: https://lore.kernel.org/all/cover.1756993734.git.naveen@kernel.org

v1: http://lkml.kernel.org/r/20250626145122.2228258-1-naveen@kernel.org

Naveen N Rao (1):
  KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support

Sean Christopherson (5):
  KVM: SVM: Move x2AVIC MSR interception helper to avic.c
  KVM: SVM: Update "APICv in x2APIC without x2AVIC" in avic.c, not svm.c
  KVM: SVM: Always print "AVIC enabled" separately, even when force
    enabled
  KVM: SVM: Don't advise the user to do force_avic=y (when x2AVIC is
    detected)
  KVM: SVM: Move global "avic" variable to avic.c

 arch/x86/kvm/svm/avic.c | 149 +++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.c  |  62 +----------------
 arch/x86/kvm/svm/svm.h  |   4 +-
 3 files changed, 125 insertions(+), 90 deletions(-)


base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


