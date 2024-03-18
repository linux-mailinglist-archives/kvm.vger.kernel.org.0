Return-Path: <kvm+bounces-12043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEFC87F3DD
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:16:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B604B2818CC
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EB45D916;
	Mon, 18 Mar 2024 23:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ApfgFdHq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4E45D907
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710803775; cv=none; b=cHjlBB/tMZjg9dqP2X1b92JcD9vH8IJ+8y5XZLRF4iDsgbL3JaYszd7IUDS3czpejA/wM6iM6NgMIpPX6yn2OiIqE4ICMV6eJGV434gsKotUW/aD8liAN0AOEs1E3A2ED3d7PBgznwQdgA1XgeHfC6vRd3mU/75Cf/XmqiBCkBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710803775; c=relaxed/simple;
	bh=CHxdl6kAXtZp0a3hKo/dM7poV0nO/vJGX8P8Nu3+bDA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=O6EJY6gkbVrUaUueplvUiVLBxnyzChwal3VqeXxucG8V9XbiuwtSCG12yDJbWuujd0wJ3FIqXX8Kpzzixu8pT4JtNjoWNQstq+rQcBNKunBuWlaK8EtU900xFrPMIVgtMVpWL7gVJHFfVyn/yq5Qnuxtk/Zd825FkkPgMAasi7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ApfgFdHq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-29c7744a891so3718179a91.2
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 16:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710803773; x=1711408573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=712Uq95Ye80r9VKiZLIOk45Be4JzcIlUt71r/EgKKMo=;
        b=ApfgFdHqACTeUsaZ22yMNig5nznpsFysY53xcdyQhu+hYPv5Jwe4o8lNEoWkYB0aA4
         FEfkBsyUYGk2IZf/MAAhxrcyyla1uxnDN4X/mi+cYr1dBuW7KhIuoux0E0Bz8A0d/qAM
         +ZjPQAWETMUwk6uvlkGTU03++cPsDbTMX6xN1jx1QJukYeL17QujgcTHR4FivJvvsvr7
         4V97E4okpcz05DTVDMChkmYChWmyfL3smlVlbzmSNavBKaQ1xldqguDcKrvQOzCEXh+i
         MbsJ3CnjsYQD/Q1mXuBejRWV86EUsiKWsna2z8vcYnCh13kZz8dUExoMd8HakkYv4JbI
         t0HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710803773; x=1711408573;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=712Uq95Ye80r9VKiZLIOk45Be4JzcIlUt71r/EgKKMo=;
        b=eNKqFJaULSh2A8cNx2yt76IR8Sp4xATNgds353G8VQta6l355CN60JWcfXdljYLTFl
         8Krca78XSYnLyWnSJYpV0c9i6nIzElvXKXSgMYqTdN+z38CVOY8WCdhzC+MPAEoj/i89
         I5O4//0yKX223ECSX+o45Bl2cu/d4XR+hheT2X7zhMv4rIpKMo/wTVecv3cK0u5fNtEC
         F6XXEzKZ2p4zE2BflT95j46g96EoDGrF8V96XkXZmxVQvgNf8DD73Jqdf+7VtyxV3Yjf
         LREMpnUohhsCOk+CY8V10ksHXJi4Zhp4Oze0pnsewLdmVtBNX6G4cd4RFNqQcoSiTIYv
         aCOQ==
X-Gm-Message-State: AOJu0YzBVGnoZK1BGLIvwujL154le2KmOTW4htuJuMRCegETTAAPMhV2
	Bxm3B89sDr9Y6/hnj4RhBrE3JRgGJOs2tSgUE3Z0yf7301lXs15OYCEpD0zT1Z3cReC1XtXj6Pf
	iTg==
X-Google-Smtp-Source: AGHT+IEJCS4sso9+BDUHjE08Zy8XM+CBXBCA9eeN7sJX1a/RvK/k4u2k/DK1M0owQMR4EL87j5D4U3ec98c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c582:b0:29b:f557:3ebb with SMTP id
 l2-20020a17090ac58200b0029bf5573ebbmr36131pjt.9.1710803773342; Mon, 18 Mar
 2024 16:16:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 18 Mar 2024 16:16:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240318231609.2958332-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Late CPUID related fix for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Another small series for 6.9.  In hindsight, I could have squeezed this into the
"misc" PR, but since it was from Vitaly, my mind thought "Hyper-V!" and I put in
kvm-x86/hyperv.  *sigh*

FWIW, I'm hoping to eliminate this sort of bug in KVM_SET_CPUID{2,} by swapping
the incoming CPUID with the current CPUID, and undoing the swap on failure,  But
that's firmly a future cleanup (if it even works).

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-pvunhalt-6.9

for you to fetch changes up to c2585047c8e185b070ad5c7bd887ef59cee3941f:

  KVM: selftests: Check that PV_UNHALT is cleared when HLT exiting is disabled (2024-03-06 09:59:20 -0800)

----------------------------------------------------------------
Fix a bug in KVM_SET_CPUID{2,} where KVM looks at the wrong CPUID entries (old
vs. new) and ultimately neglects to clear PV_UNHALT from vCPUs with HLT-exiting
disabled.

----------------------------------------------------------------
Vitaly Kuznetsov (3):
      KVM: x86: Introduce __kvm_get_hypervisor_cpuid() helper
      KVM: x86: Use actual kvm_cpuid.base for clearing KVM_FEATURE_PV_UNHALT
      KVM: selftests: Check that PV_UNHALT is cleared when HLT exiting is disabled

 arch/x86/kvm/cpuid.c                               | 44 +++++++++++++---------
 .../selftests/kvm/include/x86_64/processor.h       |  9 +++++
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   | 39 +++++++++++++++++++
 3 files changed, 75 insertions(+), 17 deletions(-)

