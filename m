Return-Path: <kvm+bounces-24932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2557C95D592
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 20:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFB661F23C4F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA981922FD;
	Fri, 23 Aug 2024 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TG2CnnXP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EC8191499
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724439231; cv=none; b=o8Datqzd/lbk2d07KrSpTOk7xRkccbnsVKbK7WIu+Ed4+mLxRk3SmGveyTKHUhZzQxl18l2nu3VIgZKSjofmKI+UMhXwA4PikyHe+ak84WLnXx/sPJQJ25lUKuVZB1MoBUOlMZAR3YMHy7ob7A/Ks08u4DkttiQ3DceRzbVed3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724439231; c=relaxed/simple;
	bh=I0qyn/icG9D6L2FLHgV3ipU2mv5QmM8/4/jsHKYN5sU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=G4X31at3id1eg2Ha8OGf4m3o1G5sA0kTAkOe23BEKrIsKkgpgddBuJ3Nat5nbzizYLc4OgvnSl/ke8k69bbgPZCSbjl5/NPVtSJHvuOlQZUQVTKb3hcD4Ce4905JA21AAvkDNkN50jBIaaPVl35EYTqkZ1En+9c5oPUWZW+ZcwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TG2CnnXP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6b2249bf2d0so47422697b3.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 11:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724439229; x=1725044029; darn=vger.kernel.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Z5atdIZMHIshod5y/lRNkXHga0YOPYF7YnbQxHMFSWU=;
        b=TG2CnnXPHVBqWB8VVPsq3OUA9V30YNKqlBk5P9E71YH7uOgltyI4iArJ9/T+jU5EGY
         Xpk+qwqvahVb7MYJ1/2uL2BTby5tAi4CN4uI2o+RI1UZ2/lNueKVFjWPhODHJD6WoMJr
         L/9XFDJEOdCzuC4VC8vv0zxDJ9UREFU0fbPeHxwqnFCUOY4p+U7gvZEHD2H2XCnTfAxT
         DyUZCq77CaeFDqm+AgYhUG1qmPOdf0FlUsO+wTOjhr2iH437bBfAwbOaYGR4FDXhi6Ii
         Ljdmxo1CMqGiZCiZgQSQrEwAZsgU5AytMzKLjg7U6u9aeHgzefaGT/+1Uf1VqOBSHEHs
         L41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724439229; x=1725044029;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z5atdIZMHIshod5y/lRNkXHga0YOPYF7YnbQxHMFSWU=;
        b=UDXl5fPtDiy7AoLBwKMYO6QPC75LQFoxn10Rt0cv+ABNbsEhCK1A5ckejUbWIb/EUG
         O9+EYU9MfVK3homuY0fkSG0PEEFyu4633M7rDxMRO2KV/Idbut7okIzPpiysYvcP2tgu
         Z/KfthEZIv90Ct+vjAJT0GvfjRzDNcMIKPzJqJOq+KqlFyhXqU4H7Ve9tfHYDCH1LPT3
         Qklc7peNj9+cz1CFXtawrKQsMAHWdQ9PnnRJ/w+vOoT0voT458qwZ+2Jg+eu7tCTerw1
         +PX1ZBAN5cdp4YD5DyvV1wii+zlXsW6Vo3nW9Yz1nzUtWa9D7lqAUWTJFlwnqMSVcpNP
         Qe8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXjEM40vHtS6nbGX1+dK/Hc49N32Abg8izJTUfD/0Qzrr3Uip5jN8Zp70ijaRhGxz7L+Rs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOzIMjN/QJO/TX3o7d80mkOuDLsHRVkhMdEQD/d4gJ2KTdHPP0
	o1omjQEOEQu2A1PQz+kV4rSAxICRd3s9rDv0558KoZ1l4od6Lv89mSeSuX/YFgetj5l0eJtSOlx
	AqYpPOwcFnQ==
X-Google-Smtp-Source: AGHT+IHI3MGKzFkEWdRAldfnlQ7Tp3k1gDJgOQ3i3BZpeAA1GjGuMOyrHUJ90/DFmqXbTOCcSgmh3QpVVuZgAw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:f3:525d:ac13:60e1])
 (user=jmattson job=sendgmr) by 2002:a25:8450:0:b0:e0e:a784:2957 with SMTP id
 3f1490d57ef6-e17a83a77a2mr47383276.1.1724439228784; Fri, 23 Aug 2024 11:53:48
 -0700 (PDT)
Date: Fri, 23 Aug 2024 11:53:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823185323.2563194-1-jmattson@google.com>
Subject: [PATCH v3 0/4] Distinguish between variants of IBPB
From: Jim Mattson <jmattson@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Kai Huang <kai.huang@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Prior to Zen4, AMD's IBPB did not flush the RAS (or, in Intel
terminology, the RSB). Hence, the older version of AMD's IBPB was not
equivalent to Intel's IBPB. However, KVM has been treating them as
equivalent, synthesizing Intel's CPUID.(EAX=7,ECX=0):EDX[bit 26] on any
platform that supports the synthetic features X86_FEATURE_IBPB and
X86_FEATURE_IBRS.

Equivalence also requires a previously ignored feature on the AMD side,
CPUID Fn8000_0008_EBX[IBPB_RET], which is enumerated on Zen4.

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

 arch/x86/include/asm/cpufeatures.h | 3 ++-
 arch/x86/kvm/cpuid.c               | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

-- 
2.46.0.295.g3b9ea8a38a-goog


