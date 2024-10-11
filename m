Return-Path: <kvm+bounces-28654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE6899AE2C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 23:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 366BD1F23E40
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 21:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7AF1D1E69;
	Fri, 11 Oct 2024 21:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c5lpjeIH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC3C1D172C
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728683050; cv=none; b=kx3kfLDz6X4IqrjrVGcLi8aEwavrrXm3bAeVH2xJbfEr5B38njeM2biAkZ6nSgfHYofqExf1qEouFNYBz30Q6fZavDt5Xvdf87XfL+P+4q5aqwv61YuG2xFgOzh2psUNJwh81oGeVkmGNflwU/LUVSa1TYYM4s5Dr9253/q57E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728683050; c=relaxed/simple;
	bh=GkG6HA/ztoTmh8RNk8cfGt8sBATI27MLHUFNbQ1Xric=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sNmUD3sHqqSeRIFQ2wdc52c3YVz8lKJ874RKqsPiYAXhLPWhkOaLnzkbJFlADtaern7B8T5BF9DqjSHnhDPnU6TvWGRivf9NNgOXO8CyY0kq4wnUIqOq/Yd0AbDsTrojqPsOw3nwwdABdkFI1gQSrLoF+g+e6LnuKwvErplki2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c5lpjeIH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2ebab7abfso1239590a91.0
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 14:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728683048; x=1729287848; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p/VK3ZfgElYZvlSjzEmYwYu25ZvAhjSSKI8JYiiP+Nw=;
        b=c5lpjeIHuoKxvFmSONt6rembpxne5neN/z8ubwXZFD+ou31vY5zieVCn2f00hQmHYq
         +x1rBOV1rIKMBbwkLxSRIQhprAyJztf2OTWQInrQWgsW5b92lLont5Li2Fj3wfQLBsdn
         j5g3b2MrH1Xj0ks7GDZ+G9E8/qi05uKB6C0c1F3DWe7EqAmXh5rtKota8PgCdzr8l3qN
         8Obj5qkLTRd+08NBVOMpqwUhqZwE7dDeX9pOMewpXOtePiSTx3OaiNeyNDbAgvUyM5Fr
         y/Wklvn59DHgS/gqmdUsrYjt8jb+bPFLLHtbWfyt2osmzBYr6F3ZSB1Bq2W2hYcJuinE
         5bZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728683048; x=1729287848;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/VK3ZfgElYZvlSjzEmYwYu25ZvAhjSSKI8JYiiP+Nw=;
        b=eHzkfaxeyVGuL+qAzt/80TJnPUd2qD+YbEp+bY7QdbwG64rH8KqCxi9JfpOCppPQaF
         92OihVCXSx1FjF/k9oFrJmJeBOHssgeQ7OhzQ2JxAq98rMUu3uefogrJ5PlL90z0a3Ms
         6E1agMfSs0VTejTTtnd+My7zd37oJrXudrSQY2f5tziu1gNdV2anNNYhjU9FSiB2DxGi
         rXtYbPUY3EyouuervY4gHkGXrF/C0azakb2pBBvYSP3XtaHlfvTXhd1iMOmdQRfkphEi
         rKde6orTb53brHe8Pwh//Qo/1PE1xA24oXARXJj1XvkDd5FOVsI+WFRBwrsTm3dalyP5
         fdlg==
X-Gm-Message-State: AOJu0Yx37eydmL88QkVguyQzgm2djuUBzgOVY9y/suS3a87EGThd1PPH
	CZSj8PCtfPtcPjHYBkEnykBJp1rNICl0K/HYX34Qm68ijget0as0eIt7sq0H0EobvYJVEJxITgl
	wtbryiKo/xMFvCaTr3kj9Mm7j/DfG1MXf8DQwhjIdm0RSEMfS6uwEJqWCDLNDkPfmBoj5WO+Uo7
	ExNhZNPFhpVaDN7pqBK5KFTIqpLLicv1eLKSSObLo=
X-Google-Smtp-Source: AGHT+IGJsPr4hCQb4coiPXkuMY9sZ3MF8ZOV10AcmHOfAQjQx8qT1FpU0cYNsudkCc+q1mrwx7cCJDN2XjCsIQ==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a17:90b:3109:b0:2e2:9984:802b with SMTP
 id 98e67ed59e1d1-2e2c81bd68cmr13436a91.3.1728683045747; Fri, 11 Oct 2024
 14:44:05 -0700 (PDT)
Date: Fri, 11 Oct 2024 14:43:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241011214353.1625057-1-jmattson@google.com>
Subject: [PATCH v5 0/4] Distinguish between variants of IBPB
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	jpoimboe@kernel.org, kai.huang@intel.com, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com, 
	sandipan.das@amd.com, seanjc@google.com, tglx@linutronix.de, x86@kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
terminology, the RSB). Hence, the older version of AMD's IBPB was not
equivalent to Intel's IBPB. However, KVM has been treating them as
equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
platform that supports the synthetic features X86_FEATURE_IBPB and
X86_FEATURE_IBRS.

Equivalence also requires a previously ignored feature on the AMD side,
CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.

v5: Restored the first commit, which was unintentionally dropped in v4.
    Added Tom Lendacky's and Thomas Gleixner's Reviewed-by to the two
    commits that have not changed since v3.

v4: Added "guaranteed" to X86_FEATURE_IBPB comment [Pawan]
    Changed logic for deducing AMD IBPB features from Intel IBPB features
    in kvm_set_cpu_caps [Tom]
    Intel CPUs that suffer from PBRSB can't claim AMD_IBPB_RET [myself]

v3: Pass through IBPB_RET from hardware to userspace. [Tom]
    Derive AMD_IBPB from X86_FEATURE_SPEC_CTRL rather than
    X86_FEATURE_IBPB. [Tom]
    Clarify semantics of X86_FEATURE_IBPB.

v2: Use IBPB_RET to identify semantic equality. [Venkatesh]


Jim Mattson (4):
  x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
  x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
  KVM: x86: Advertise AMD_IBPB_RET to userspace
  KVM: x86: AMD's IBPB is not equivalent to Intel's IBPB

 arch/x86/include/asm/cpufeatures.h |  3 ++-
 arch/x86/kvm/cpuid.c               | 12 +++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.47.0.rc1.288.g06298d1525-goog


