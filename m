Return-Path: <kvm+bounces-38526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 787C4A3AEDD
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19C4217083B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F6D132122;
	Wed, 19 Feb 2025 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OPcDgQX9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C429FA920
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 01:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739928430; cv=none; b=Sixr6JldGcxC0JnwgZz2/S+R5BPzVnepMMDuPxc9FTRkWLzrZ0X6BwtQG/Chq4amqujUXwD/yOz1iOm5f3peck9X4TAt7c9WhvEIuwYiju+79jgOX0dbWpy4KB6mDfNlP20MHSuFf3O//eT3pnh/8eCCgnobmWF9HUcPQb2w9b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739928430; c=relaxed/simple;
	bh=exShF3Jms5ap2aAuImaKw8KZckFL9+mG6aZKRU3W4nM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=r79SG1A1aIqZE+DxTeZ6WC+9cRyjXStmYIGMuKAZyRoN/Kf08QwSTR8K2FPPi/Atc2lICnVJlEfeIdIXuRfDd0ZbVqzreg3nxAh4O+BlJ7O/+B6yGpMQtA/joDEICQhBPqhpRZ0hLEsrElyob8+DrQUy53IGa+6ZSFX8a7Z+cEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OPcDgQX9; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22104619939so111659115ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 17:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739928428; x=1740533228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oMOZDM8xcXZ3hDCyKFDMjTBZKyrAQ3OwkqnB3/wSmXw=;
        b=OPcDgQX963cGTdytohRI/LhPr7bw1tD/rqlNlAspb1XTTAslJvyQN+CLOcGKlfQzmm
         UVKbbnJFNy9rQjRH3Y+5PrC7Jn3jzDAUVryV8evixGx9YQLUIRPDZntjPvFfw6wnGaul
         jghe6DfNoNsKrFggdEMx12bkW7OD1Gu36S16PTItd14KLHl0twVIqvMoth9Bo8HuvFPQ
         UblNX5EM70pBs2Mg6LNH5nzVV/X0UeAmwnUHq/Jxy5ZHDmo3pTNuzFNfq8RHu++OT3VF
         W1okUK9kjLm6d7G83kxRH7u3bxH97qKkUsrRUYv2RwgeeBuAFgcmH9mdRyQ8QGl5SJbf
         /a+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739928428; x=1740533228;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oMOZDM8xcXZ3hDCyKFDMjTBZKyrAQ3OwkqnB3/wSmXw=;
        b=AYQvigUjsAHM0tJfbmTjBenBZpcQXOhF6JETNhOauswRe93e/gQAPw+jukK91ieZcM
         pjqVp9x34K/Uy1qpy+Ljau5mr7YTz13ZcXo71keDNJ3H+HaK8tAUMsuMKvdbsb6kwAjb
         JHTtnktpMQ2S8hP4mPhxqvp0Ui1n/UXtNZL9vK8YSIIbVqEea+Xkzlj4iraBSc5gz3vg
         syezMOT54f1xP06+n0b3pR7kNRyiGnUhd9bsW9fHfDJ0pNZjAf9UchkWu7QKOvaUuLdO
         aXMY7QZIMqCAD8Tiv9EUxndTDDplWHZsQVGa0+UqT/pQuyYIEG2AWrp6P6iPDkLOzJKl
         RGkA==
X-Gm-Message-State: AOJu0YyYRfne6eieP083a8LzXyGdDtk86m7Ix3f4uAfyLT8isWjSUpK+
	cLthLmNMRVmhnfEVybTna+aGZARWHWqL4nh0NtnRMZARBzBZe3QkPcckK+HVE+LB9LnV06or2D2
	1yA==
X-Google-Smtp-Source: AGHT+IGg4/+Z632vwDAzljKVNGaUy1dvH4zOerOMi3O3noRyOOumQGKZoWK0rtlraamdCnEjOsGhZJgMx44=
X-Received: from pjbrs16.prod.google.com ([2002:a17:90b:2b90:b0:2fc:1e77:d6b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea08:b0:220:ef79:ac9d
 with SMTP id d9443c01a7336-2217098bff3mr25912075ad.31.1739928428089; Tue, 18
 Feb 2025 17:27:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Feb 2025 17:26:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250219012705.1495231-1-seanjc@google.com>
Subject: [PATCH 00/10] KVM: SVM: Attempt to cleanup SEV_FEATURES
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="UTF-8"

This is a hastily thrown together series, barely above RFC, to try and
address the worst of the issues that arise with guest controlled SEV
features (thanks AP creation)[1].

In addition to the initial flaws with DebugSwap, I came across a variety
of issues when trying to figure out how best to handle SEV features in
general.  E.g. AFAICT, KVM doesn't guard against userspace manually making
a vCPU RUNNABLE after it has been DESTROYED (or after a failed CREATE).

This is essentially compile-tested only, as I don't have easy access to a
system with SNP enabled.  I ran the SEV-ES selftests, but that's not much
in the way of test coverage.

AMD folks, I would greatly appreciate reviews, testing, and most importantly,
confirmation that all of this actually works the way I think it does.

[1] https://lore.kernel.org/all/Z7TSef290IQxQhT2@google.com

Sean Christopherson (10):
  KVM: SVM: Save host DR masks but NOT DRs on CPUs with DebugSwap
  KVM: SVM: Don't rely on DebugSwap to restore host DR0..DR3
  KVM: SVM: Terminate the VM if a SEV-ES+ guest is run with an invalid
    VMSA
  KVM: SVM: Don't change target vCPU state on AP Creation VMGEXIT error
  KVM: SVM: Require AP's "requested" SEV_FEATURES to match KVM's view
  KVM: SVM: Simplify request+kick logic in SNP AP Creation handling
  KVM: SVM: Use guard(mutex) to simplify SNP AP Creation error handling
  KVM: SVM: Mark VMCB dirty before processing incoming snp_vmsa_gpa
  KVM: SVM: Use guard(mutex) to simplify SNP vCPU state updates
  KVM: SVM: Invalidate "next" SNP VMSA GPA even on failure

 arch/x86/kvm/svm/sev.c | 218 +++++++++++++++++++----------------------
 arch/x86/kvm/svm/svm.c |   7 +-
 arch/x86/kvm/svm/svm.h |   2 +-
 3 files changed, 106 insertions(+), 121 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.601.g30ceb7b040-goog


