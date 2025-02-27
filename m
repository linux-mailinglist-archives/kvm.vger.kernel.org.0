Return-Path: <kvm+bounces-39459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 630E6A4715F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D86DC1885113
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCED91482E7;
	Thu, 27 Feb 2025 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJvRV1zI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87857270037
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619546; cv=none; b=eQxEBsnxCa4xrlaxXx1Fils5Or5rgJ5kKg5NhaEwhym37pAcpk7weo9YmTLCIISwlCojhOxCd5WMw0SvZjWidevr6gyxOSwe1yRRX5mElLVzkZ5RztBEGKm8G9k4rZ2ZTA7n3VLywWAkRO5WRuPtMubrLj/3H9/82hyg+QO4niA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619546; c=relaxed/simple;
	bh=Wdtw3z3dIE5xlcyqhTg1CA/Qey9qjDhjXCDgcU154ok=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PpDY8fzd+XQNfrmG+XiAXA5uUroPIj+NpkXz9lgzYKHxxlnNTDhOV1BS2euDzHZnBd+dE98dDhyj/a+1CKLevpRP/uip/63uLcmEOZT4Nim6F4Tm6HvHOyBemONZ+T7Tzin4BHlb7Cb3P+BpjsSJ7quSYfv8OFesgXS4Qni9P3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJvRV1zI; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc0bc05afdso1034384a91.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740619544; x=1741224344; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8mLsNEc2L477qh6hOYKkOTiyy9P6wrebcPjxTzB9Zh8=;
        b=fJvRV1zI5pX7V06l6W8++0iSmCHSY+C3p4yB/k/MwLU5jrLGs/M/NSisLP6y7XY5jU
         saH6Ve7qQjWEWFEBVeQoFnm5DplpMuBT2ilIoQhSOEuAF9lklV7BC4wruxulyzZP4bkp
         MS6QcKDTgnORwUcnC3Q61l27BiHkXnykC1Yy4bkU6elIOADGCm8bQe/qrsWYCB9EY3Mu
         KeHBqvS3VOkXfDdjTsFn5hakLifinjYE540I013iukj5uETF0UuruMp8xkzJUuG2/g56
         BBaQI6l9mbAJkXWC8QipmrTR6dP157DLDHh54kFvnoqjM8w3u9Ac+1R0k5T17nrj1P2M
         MxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740619544; x=1741224344;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8mLsNEc2L477qh6hOYKkOTiyy9P6wrebcPjxTzB9Zh8=;
        b=XpWT5Br/rAfRqwY0lVHHURXMjxkwLVZ2nilOCmGmQXvR2eHOlyMnyJntenxu7urpWI
         0+eW1Ccgxaz4pBQOxFsUpN9hkgWmJqVebf//hBWGovoDjF+fNTb781Rwn1mCKT/V9nM+
         dV4QZXcrSI5cHO2M7Mmb1nj1pGNWfHC6xEcBBlZSIcTqJPStCkDuA40KoMo/fmi46JEb
         hJeSwhHVPuNjg7F0hp67D8eXgzFjjRynZVWE4fpCkCJakwi0WULMZNaj2zw3Sim2UmO7
         yeP5BaPp5RVouZyhcO7zMBW6AluDSn5tMboKDaEvz75KCj3pmwsxh70Q9aLjWZQYAstw
         Ti2A==
X-Gm-Message-State: AOJu0YwaFlJVMyw53+urkkX+d1Ey8wV2ReC23NGWPMnaaFeunSkVOnTD
	MJVIqFvESFhLTBmwwE2cx3EXIWMvuB9pMWzZRDbxYpru3UxqQr5K8kPeLFE3CmF0FaLCkhAawia
	tlQ==
X-Google-Smtp-Source: AGHT+IFmdKitPwpVg76MTWIh6m9tmRlIO5efvR0bfhT7MBKnu/8de+ECfUmAcILvmXo50JclDrSlfYk5Rns=
X-Received: from pjboh3.prod.google.com ([2002:a17:90b:3a43:b0:2fc:af0c:4be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2c7:b0:2ea:3f34:f194
 with SMTP id 98e67ed59e1d1-2fe68ad9a18mr15452651a91.10.1740619543912; Wed, 26
 Feb 2025 17:25:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:25:31 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227012541.3234589-1-seanjc@google.com>
Subject: [PATCH v2 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>, 
	Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

Try to address the worst of the issues that arise with guest controlled SEV
features (thanks AP creation)[1].  The most pressing issue is with DebugSwap,
as a misbehaving guest could clobber host DR masks (which should be relatively
benign?).

The other notable issue is that KVM doesn't guard against userspace manually
making a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).
This shouldn't be super problematic, as VMRUN is supposed to "only" fail if
the VMSA page is invalid, but passing a known bad PA to hardware isn't exactly
desirable.

[1] https://lore.kernel.org/all/Z7TSef290IQxQhT2@google.com

v2:
 - Collect reviews. [Tom, Pankaj]
 - Fix a changelog typo. [Tom]
 - Reject KVM_RUN, but don't terminate the guest if KVM attempts VMRUN
   with a bad VMSA. [Tom]
 - Fix a commment where DRs were incorreclty listed as Type-A when DebugSwap
   is disabled/unsupported. [Tom]

v1: https://lore.kernel.org/all/20250219012705.1495231-1-seanjc@google.com

Sean Christopherson (10):
  KVM: SVM: Save host DR masks on CPUs with DebugSwap
  KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
  KVM: SVM: Refuse to attempt VRMUN if an SEV-ES+ guest has an invalid
    VMSA
  KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
  KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
  KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
  KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
  KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
  KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
  KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure

 arch/x86/kvm/svm/sev.c | 218 +++++++++++++++++++----------------------
 arch/x86/kvm/svm/svm.c |  11 ++-
 arch/x86/kvm/svm/svm.h |   2 +-
 3 files changed, 109 insertions(+), 122 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


