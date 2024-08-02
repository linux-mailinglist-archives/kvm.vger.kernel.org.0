Return-Path: <kvm+bounces-23106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D46946367
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 20:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA3C72837E9
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 18:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35AD71547CE;
	Fri,  2 Aug 2024 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ukYeYtoA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9181537CD
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722624917; cv=none; b=GHZ/N651JPv8MCteto9GM5g2C+V0fQTVNl+SFOjvidjocbNJ0uB2lbDqr++CbRp0g5S6FsHQnH024thfYwT3gIA0bxWmF8eofls3c2+p5NcTV4c6EWLw816F0Yc7gE8kKJTGRR9BjRfiufhZw1I2fG38EitVryEzyGepzK320rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722624917; c=relaxed/simple;
	bh=csDh3SLvIft85qMK7pks0DAvlEWyp4updhhuwAFMGEM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U2ne7v11NbpcmMUw4jNyhVqGx5GbjPJ1d7aI3PaRGl1UqsYNNML9WhghAG3z7/deftF/wJyG2ZnUxJmBYbE5cv40MzDARZyrfD8eiFhCsMcGAIneqe5CvnOr5qSjhMKykNYj+qoFDVEjX1Ex+fProuJXqHbLuFMHOkve7Lnhp6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ukYeYtoA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e03a5534d58so11736329276.1
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 11:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722624915; x=1723229715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOyRewHaLJeDoMAa2YF7gd0llk31ENfFaE/kDwJ04JM=;
        b=ukYeYtoA7TvKZhwCULcggTGqFM2um4xgcgPlNCVUx6zgkNtSyq+YsCj3YfAdE9gANF
         bJCMZJ+wtBnAkshuUitrY+PFvGb0+muWZcP4jZ4/R6DJkeTUttNN32JlDFzEeGdqGMmm
         /dy67+CZh+ACa7qtZgGWsoRzSh1sJwPl18tDZy/v0zFDVyQ94j3qlWmPjAXn1D/1DwCS
         lH+RhOP3RQwXSKQeRPLRxq+X+sRI1/2g/DDI8QqyYqNcAsByHfuswoui79Bv1iihUi7t
         EcOdcEpOLTCNNqjOkioTTrhMHKUpbfrhXG5f7yBAhVZj4DbgLYtigVZiOHAp6rxLn2+C
         dkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722624915; x=1723229715;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOyRewHaLJeDoMAa2YF7gd0llk31ENfFaE/kDwJ04JM=;
        b=Gr5GwW/F3vbjlJsiUqHeiHVL9JOOC8zz260P6LdMNy47uNmIeFPfFI7+ScmUrovyMT
         CyK7n/OxxbNlTsC7FZpZ/LPUmF3eTTkXgE/TIqdVFwiZ9IUMiNhOVOAOEmyi7CZBi0rp
         yM4CC4nd7Ayw0/GQmETNB+YF17eaKSJMfwLTRdmjGdGv5qxA/LwAGlfE97h+7dlV4pfI
         e1BcppFP+IEo1Uo+ckKgj6mK2kpt+D4U3WvKQKIw7+yVjwGyrzZCPrXw5ttxRFeW35YV
         2vL8hZ1vwzFCXXF4qLLDd9GlF9XnedsobBjVJLU+6vuJ8lg141SCcHiuW6nylkX6k/IG
         /xAA==
X-Gm-Message-State: AOJu0YxrcyKvZp5kNRw71RlsSSOSjoi0aXrIAZuRVUaVA+MDtip1d18K
	h4nZX6ukqKGarfP+Wb3PY/1cG0ojn7rXv/SrpUApt33yOdAxy/9cqMqMdjQJyAHdFgZw+FBQhgD
	bWg==
X-Google-Smtp-Source: AGHT+IFx8/YCbU+oIuzkfZuhutT51QhJHSkGwIqvKExJaAJMbNbEMXpgqYu5whRNxmUqscWY+yxTgggMnJc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c02:b0:e0b:d229:af01 with SMTP id
 3f1490d57ef6-e0bde2925d2mr7503276.6.1722624914717; Fri, 02 Aug 2024 11:55:14
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 11:55:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802185511.305849-1-seanjc@google.com>
Subject: [PATCH 0/9] KVM: x86: Add a quirk for feature MSR initialization
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The primary goal of this series to fix an issue where KVM's initialization
of feature MSRs during vCPU creation results in a failed save/restore of
PERF_CAPABILITIES.  If userspace configures the VM to _not_ have a PMU,
because KVM initializes the vCPU's PERF_CAPABILTIIES, trying to save/restore
the non-zero value will be rejected by the destination.

The secondary goal is to try and avoid such goofs in the future, by making
it explicitly clear that userspace owns the vCPU model.

To achieve both goals, quirk KVM's initialization of feature MSRs and give
userspace full control of feature MSRs, mostly.  I left VMX_CR{0,4}_FIXED1
as-is, partly because there was pushback on quirking those in the past[1],
partly because I (somewhat begrudgingly) actually think that it makes sense
for KVM to take control of the allowed-1 CR4 bits, as there is no known use
case for having the post-VMXON CR4 bits diverge from pre-VMXON (guest CPUID),
and trying to sort out what should happen if there was a divergence would be
a mess.

I did apply the quirk to VMX secondary execution controls, because unlike
the CR{0,4} bits, KVM doesn't take _full_ control, and more importantly, I
want to stem the bleeding and avoid KVM fiddling with more VMX MSRs, e.g.
tertiary controls.

Note, this applies on top of the MSR userspace access series [2], and the
tests will fail without those underlying changes.

[1] https://lore.kernel.org/all/20220607213604.3346000-13-seanjc@google.com
[2] https://lore.kernel.org/all/20240802181935.292540-1-seanjc@google.com

Sean Christopherson (9):
  KVM: x86: Co-locate initialization of feature MSRs in
    kvm_arch_vcpu_create()
  KVM: x86: Disallow changing MSR_PLATFORM_INFO after vCPU has run
  KVM: x86: Quirk initialization of feature MSRs to KVM's max
    configuration
  KVM: x86: Reject userspace attempts to access PERF_CAPABILITIES w/o
    PDCM
  KVM: VMX: Remove restriction that PMU version > 0 for
    PERF_CAPABILITIES
  KVM: x86: Reject userspace attempts to access ARCH_CAPABILITIES w/o
    support
  KVM: x86: Remove ordering check b/w MSR_PLATFORM_INFO and
    MISC_FEATURES_ENABLES
  KVM: selftests: Verify get/set PERF_CAPABILITIES w/o guest PDMC
    behavior
  KVM: selftests: Add a testcase for disabling feature MSRs init quirk

 Documentation/virt/kvm/api.rst                |  22 ++++
 arch/x86/include/asm/kvm_host.h               |   3 +-
 arch/x86/include/uapi/asm/kvm.h               |   1 +
 arch/x86/kvm/svm/svm.c                        |   4 +-
 arch/x86/kvm/vmx/vmx.c                        |  11 +-
 arch/x86/kvm/x86.c                            |  34 +++---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/x86_64/feature_msrs_test.c  | 113 ++++++++++++++++++
 .../kvm/x86_64/get_msr_index_features.c       |  35 ------
 .../selftests/kvm/x86_64/platform_info_test.c |   2 -
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  23 ++++
 11 files changed, 189 insertions(+), 61 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/feature_msrs_test.c
 delete mode 100644 tools/testing/selftests/kvm/x86_64/get_msr_index_features.c


base-commit: 540fa2dc3c53613817bd7b345e1466d4a6f0ab5d
-- 
2.46.0.rc2.264.g509ed76dc8-goog


