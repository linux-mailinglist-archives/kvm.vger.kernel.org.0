Return-Path: <kvm+bounces-67812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B06D1477C
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:46:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10E1D3043F1E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B6137BE8B;
	Mon, 12 Jan 2026 17:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KiCrBAzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED672BDC27
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239940; cv=none; b=WpogE/PWaxoOUakOiTwGvdSkpThODgEkauV5+xikeiwde7W+Uc3BMX1b2XX839/ji4QiAfS7Dxuokv+goxfLVMlizSBpLLS66519l3EKNbso71fGrzqd6zJkjrHwWTHGjRdYVvnkdObRxyXf1pqe6hK/aGcXQMMh+rGngPYjI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239940; c=relaxed/simple;
	bh=tRUBNtvsGTyz9uO2LZ/ZrWHUO/SAepqw+Xmr/joWlQM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lw/3BGevTYTjhYAb1kS51xCM1gXuTQZxQ3E3BV+gYtn77y7Ninjzi9deRbEkAE/f1IM13i9MBFDIowqCmXb/WUJfbSM3jx/3ui6EyhUgtsbN+lCB0Ie0hkAJUbD/l3hBxsWbx6fdya+vpbQeTt4Nyw17kMLcAhjIN/WG6YVHCvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KiCrBAzJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so7914547a91.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239939; x=1768844739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QFvZ/pSKJV6B/QHBj1Be7Gjgij0dz+ZlxZdi6kp9tRU=;
        b=KiCrBAzJtHYHN1fIpV63YTW2gamLtw7lAgFwBHPm5y4xe8Cdzilzuunuxa9darFkFd
         zxKv5VzzcOEh0brZBvagf00N0w114bjPl2IF6uTkBn0fAmN4RbtMjUKX2JevKeL8xwDt
         Om1f/8wH+8Vj4ejYU3/Sb6zJ8R+dRcCtqaLmxR0DD8cv0SaPsWkMrSClsBbspbUXsXtg
         QZK3EOT9Y62YTAx7n02CWreJ8V/HTMBHWqb4DDDTKGIkiEGNZDueimlveFCw8C7Ab1cQ
         gR+Q95pnXHifBhfP+DrZJFegdRQFQjo5DC1aENy1a254a4zF82lpZtZaHd30hCECnwSt
         21Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239939; x=1768844739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QFvZ/pSKJV6B/QHBj1Be7Gjgij0dz+ZlxZdi6kp9tRU=;
        b=aKx6fLtXF2er/zTRvUjttiX7cVhHrz/AGoPFE77PvwhIx4AL4xVZgta421AQjDTTqw
         NMFQCwozccQ3ChhiZW1WTmjI+pt1z7PSPk2eH997o/+kcvJH8YE9qHeO9m2kTBF02hxX
         hsFWC0yu36Pn/M7IC1/qJSOXUYIBwo2dYvFzToJAoQVDWIGW4dzvTHqxE1U3pzjN7Nn9
         8gsd6wLlCmP0g0/aFXzYn/usTY3lNWTwL66XpPt6haQUICoHh3JRz5kNgLEOx0k3p9J1
         lMrcBOP78Pdokzn0gAY55GhpTArnL0HK5l2THLeJNRv5ImAruGi2BoWRg0DaTS0RdbaM
         C9jA==
X-Gm-Message-State: AOJu0YxCUrysytjEcaAdQjKirrM7sCPP/jsRcye07R0dJPJO2xp3a1Fs
	w/Tz09oxljKTO7wt7NldhGtJ+bncLjN/jlm0ZfFhy0QQzD3lM5tLRK2gCO8AX6eKtYBFN7c9UzF
	qVUhsMPdEW39mHw==
X-Google-Smtp-Source: AGHT+IH+5Ti2CyCkFUj7kZjziTJj2MyxNeskCbGX9fhVYJduvDiOjLzxqfbfPh3Z93MKpWd4k05+583dHXFLfw==
X-Received: from pjzd8.prod.google.com ([2002:a17:90a:e288:b0:34c:811d:e3ca])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5287:b0:340:bde5:c9e3 with SMTP id 98e67ed59e1d1-34f68c91773mr17708252a91.23.1768239938830;
 Mon, 12 Jan 2026 09:45:38 -0800 (PST)
Date: Mon, 12 Jan 2026 17:45:30 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112174535.3132800-1-chengkev@google.com>
Subject: [PATCH V2 0/5] Align SVM with APM defined behaviors
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

The APM lists the following behaviors
  - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
    can be used when the EFER.SVME is set to 1; otherwise, these
    instructions generate a #UD exception.
  - If VMMCALL instruction is not intercepted, the instruction raises a
    #UD exception.
  - STGI instruction causes a #UD exception if SVM is not enabled and
    neither SVM Lock nor the device exclusion vector (DEV) are
    supported.

The patches in this series fix current SVM bugs that do not adhere to
the APM listed behaviors.

v1 -> v2:
  - Split up the series into smaller more logical changes as suggested
    by Sean
  - Added patch for injecting #UD for STGI under APM defined conditions
    as suggested by Sean
  - Combined EFER.SVME=0 conditional with intel CPU logic in
    svm_recalc_instruction_intercepts

v1: https://lore.kernel.org/all/20260106041250.2125920-1-chengkev@google.com/

Kevin Cheng (5):
  KVM: SVM: Move STGI and CLGI intercept handling
  KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and SVM Lock and DEV are
    not available
  KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
  KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
  KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted

 arch/x86/kvm/svm/svm.c | 52 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 45 insertions(+), 7 deletions(-)

--
2.52.0.457.g6b5491de43-goog


