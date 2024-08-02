Return-Path: <kvm+bounces-23087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C51569462E9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:19:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85BAF282C97
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:19:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E2515C156;
	Fri,  2 Aug 2024 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SezKx380"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205CE1AE05A
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722622780; cv=none; b=HSx13GJ2+o0OsqGIowI47QXMW0XuXwDh+AgLOPsL0VFvFKl8MI0+nJQxkg71ljr1B0iv8CY4zBJ3gnJhmtXpw4hq8vz63M8tDT09UJiPDHiomtRSI3k+f796ffmtAWKPsIYoK0i3F7ODJcn0hTSmGzdHthbj5Eucl58mTjZK5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722622780; c=relaxed/simple;
	bh=g5DCrivJfscGQJsAj/olVwFg1c/ACZKfEBkGsjkZnpE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H6eZHwhRAV7u3D0Or9nswZdrY27Mtl10ugQKKRsa1NlRMdPL0094CYUNExraDtFb8Do454fHWW7xmSIpBDRmGWNMC0yu2JbL5jcyfif0YRh6WmlbrT7SKHFJiPgR3xX0IFBj/zTeUOSE9+C8ScxcorQitAygU3MsqdafJKyhexA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SezKx380; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fee7c9e4a4so67538255ad.2
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722622778; x=1723227578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p99bB6rFk1E0Qk5WCBmO4dKzx4FN/Po7pdDDEwtD+VA=;
        b=SezKx380CFxSjnP+JQGFwTHEx8hQ5WGfPaTxm/bFLfJckCy98o5wrkW2CC1c0YXOUX
         lEA3xYgh+qzrNY0MdA2kBos9g1OouxRf5wx2J9Rggm0N8R2rwMd6WipADj79/+SOtY14
         RgqfPxCwMRtgl826X1Q1mpPTj7PIatP8lffOmhqZkvaBEdsleOqTeRC8o1qQaVh3ikmi
         LnHOJ6N89C8VbnXFctsLX3i37vJtAaR+9gQO1DsoPAf96+V0nJYg393FCslY8jBT8HMc
         gCW12UTNfBP0CNF6c4So6oM5AWM00QHsu7fZSY7K2XF3Dkp33qscqDCuYB2jJSL5WHKd
         vW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722622778; x=1723227578;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p99bB6rFk1E0Qk5WCBmO4dKzx4FN/Po7pdDDEwtD+VA=;
        b=dd5IJTQ/v0YAaTbFIUcz6Ia/GeYW+2IIeCZOQqWp3bNuvXAN/Hra/DBZyvqepgVoi7
         9CiSajIa6iMX5xBdWgRoz4XUZcwPz3KZMZ5z+GwPpn20ak0FepbwCI5GmNCn50+kYfqS
         uySwkF2pREmofdQf0tJSAygCy/6JqiBgQ0WPWJ02jhuJbbi5RREmQ43oPzoGpMSNEOMT
         hg7hgAEA8rxBYVe4ZX+1MvWfBo51rvJvVrRiMb58knM76CFaXNLCvWF0OWB/B1lCNRra
         fg2omDUuaujN1dL+NgbgBe6zOyA9A67raWPLnm1+pCFjk5pRqmCChE1jvHW/GTfWGWWo
         vyaA==
X-Gm-Message-State: AOJu0Yw+AWUDi3CfXajOF0wfHy1WoLzEkHm1v6/8X80BwvJjoATEAGAN
	KJP/20d4KzvHZLQPlM39EDJoYKOuLrfOERdRTsr2DAxMB1sIZxEpszIfgGIgrn45v9PBROKOGx3
	uvQ==
X-Google-Smtp-Source: AGHT+IFoscLe03nTUDGGcFRuyJrRv6kdtTJblF4kSXqKij8H2j5hOlnaVhA/9ziRv3whGQXlfznLCmHN+sM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244b:b0:1fb:80c5:ce5d with SMTP id
 d9443c01a7336-1ff572749dfmr1929745ad.4.1722622778205; Fri, 02 Aug 2024
 11:19:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:19:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802181935.292540-1-seanjc@google.com>
Subject: [PATCH v2 00/10] KVM: x86: Clean up MSR access/failure handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Weijiang Yang <weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Rework KVM's MSR access handling, and more specific the handling of failures,
to begin the march towards removing host_initiated exemptions for CPUID
checks, e.g. to eventually turn code like this:

		if (!msr_info->host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
			return 1;

into

		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
			return KVM_MSR_RET_UNSUPPORTED;

For all intents and purposes, KVM already requires setting guest CPUID before
setting MSRs, as there are multiple MSR flows that simply cannot work if CPUID
isn't in place.

But because KVM's ABI is that userspace is allowed to save/restore MSRs that
are advertised to usersepace regardless of the vCPU CPUID model, KVM has ended
up with code like the above where KVM unconditionally allows host accesses.

The idea here is to funnel all MSR accesses through a single helper so that
KVM can make the "host_initiated" exception in a single location based on
KVM_MSR_RET_UNSUPPORTED, i.e. so that KVM doesn't need one-off checks for every
MSR, which is especially problematic for CET where a Venn diagram is needed to
map CET MSR existence to CPUID feature bits.

This series doesn't actually remove the existing host_initiated checks.  I
*really* wanted to do that here, but removing all the existing checks is
non-trivial and has a high chance of subtly breaking userspace.  I still want
to eventually get there, but it needs to be a slower, more thoughtful process.

For now, the goal is to allow new features to omit the host_initiated checks
without creating a weird userspace ABI, e.g to simplify the aforementioned CET
support.

v2:
 - Rebase (really the only reason I posted v2).
 - Collect reviews. [Weijiang]

v1:
 - https://lore.kernel.org/all/20240425181422.3250947-1-seanjc@google.com

Sean Christopherson (10):
  KVM: SVM: Disallow guest from changing userspace's MSR_AMD64_DE_CFG
    value
  KVM: x86: Move MSR_TYPE_{R,W,RW} values from VMX to x86, as enums
  KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
  KVM: x86: Refactor kvm_x86_ops.get_msr_feature() to avoid
    kvm_msr_entry
  KVM: x86: Rename get_msr_feature() APIs to get_feature_msr()
  KVM: x86: Refactor kvm_get_feature_msr() to avoid struct kvm_msr_entry
  KVM: x86: Funnel all fancy MSR return value handling into a common
    helper
  KVM: x86: Hoist x86.c's global msr_* variables up above
    kvm_do_msr_access()
  KVM: x86: Suppress failures on userspace access to advertised,
    unsupported MSRs
  KVM: x86: Suppress userspace access failures on unsupported,
    "emulated" MSRs

 arch/x86/include/asm/kvm-x86-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h    |   2 +-
 arch/x86/kvm/svm/svm.c             |  29 +-
 arch/x86/kvm/vmx/main.c            |   2 +-
 arch/x86/kvm/vmx/vmx.c             |   8 +-
 arch/x86/kvm/vmx/vmx.h             |   4 -
 arch/x86/kvm/vmx/x86_ops.h         |   2 +-
 arch/x86/kvm/x86.c                 | 513 ++++++++++++++---------------
 arch/x86/kvm/x86.h                 |  21 +-
 9 files changed, 294 insertions(+), 289 deletions(-)


base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0.rc2.264.g509ed76dc8-goog


