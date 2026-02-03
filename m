Return-Path: <kvm+bounces-70071-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHFQGMdHgmnzRgMAu9opvQ
	(envelope-from <kvm+bounces-70071-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:08:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EB3DE0DB
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 20:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 968EC30E6C8B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 19:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B4F322DD6;
	Tue,  3 Feb 2026 19:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jiy0Aqn7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C2C2DB78D
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 19:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770145634; cv=none; b=eSRFZFZ5jIF/SS8hzBt7SBcsgjR58fzWefrKVDPGGPXXGT7K9obQuYu/Rf8yISca8Gh6XTR9zpAxyorjvsPKcMCqygAojLyl9ExIx3Q2UY//lyMaK2TMTJqIpIIhlBAYj5RHO+RaNcmkohujgemvq1R/W4TZjh9+n+zgvQmEElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770145634; c=relaxed/simple;
	bh=rSmJCm/c/mKOveunYcaZmGnbytpuXAWyHrTksnP3oZI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tHRKJOfbINx0sQgn0fcjiCBN+4SMXag+ULvaDa6m40Lnnddt2vaFYFmiigM2hMs9V+RZXTdTVaXUkd1j4gQTHqtnINVQnAtKJNnrzVTMr3fZ7ylRdpSVYo8cD02u9N95VJ/OkctpzaoD6TNsgVNgra+zFSr328DOVsTkFEbg9lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jiy0Aqn7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c52d37d346dso3402484a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 11:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770145633; x=1770750433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0PgStJD0hlGtCGajd6vbNEL6gWOOLYA62RNilMSbNc=;
        b=jiy0Aqn7vcoWgVB6RtzbVbw91z1r9HN3EFc5TSZB3P0iCX+6S9hR9WUfTOscGinDFn
         X9DCemanQkHsB+7GFS7adPA9cVUCiyIOK0HIEct1fnA/sN1yPo8qWpfoEPQCwPHRmmvq
         GTYHLn1nTKcAZXAMaCpzCeKm9OsefDRJvGk+4Y8jn3Xp8tWYFkcL3XdI1+LLJWMnRVYz
         NasaKS1wHmInCR+ykpHGj4j8tNeKAlyt+fGCJ3a0Rqx8P1z9N3jXW8xNLaA5EGzW2Rs+
         EeHQcX4PtlSwpk3BuhOl87idkqB8DiMt9hlFoQFuvQECcceMdk2jg8uiXpaZCIVm/4vl
         HqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770145633; x=1770750433;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V0PgStJD0hlGtCGajd6vbNEL6gWOOLYA62RNilMSbNc=;
        b=SqR5d+L43pLYuKUL8nhwHeVLC+ngkphYOhOF8dd0Cl5QSrL3stynbadtFphyJwzMnI
         BpKGRswxfCg8nOAUnGyp2qMzHDqtdC3HDrKwAs2+K/WeN8nunrB3w3W2Ju5aE7LzzMbI
         4CNw0fn6ffUTP3dn00dPVay/aQBp4xaCWbjYWbgV7SvE0F7bjZ4bEJKhQlZoZGIiNPeW
         Sn+S67kbOgKFG8aKsjb7LQT0OYnTdL0lHfhFLkK84PD9Qes0z93OETfOrX/cki6LNmdm
         BIkrWS20LJY2R7ZyGfBPHXE9mJ3MN3isVjPT5kzHCawqBqQb6EglXZb8URnq7RVxhLid
         +WFA==
X-Gm-Message-State: AOJu0YzwHkfJSDrqVRTVYXPMAqEppc95+N+V+kZet/Cll2VB+8bTWVCN
	JpgMKU6BiZFrsDrsBpHhZbFt952ocQyUYRE1T1PdSNPsIfyHxb3ocq55YmjU6ol93es2wUMhYC3
	XPefDDA==
X-Received: from pjnu10.prod.google.com ([2002:a17:90a:890a:b0:34c:4074:d7ec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5346:b0:340:c179:365a
 with SMTP id 98e67ed59e1d1-35486f549ffmr303479a91.0.1770145633024; Tue, 03
 Feb 2026 11:07:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  3 Feb 2026 11:07:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260203190711.458413-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: SVM: Fix CR8 intercpetion woes with AVIC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Naveen N Rao <naveen@kernel.org>, 
	"Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70071-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 02EB3DE0DB
X-Rspamd-Action: no action

Fix a bug (or rather, a class of bugs) where SVM leaves the CR8 write
intercept enabled after AVIC is enabled.  On its own, the dangling CR8
intercept is "just" a performance issue.  But combined with the TPR sync bug
fixed by commit d02e48830e3f ("KVM: SVM: Sync TPR from LAPIC into VMCB::V_TPR
even if AVIC is active"), the danging intercept is fatal to Windows guests as
the TPR seen by hardware gets wildly out of sync with reality.

Tagged for stable even though there shouldn't be functional issues so long as
the TPR sync bug is fixed, because (a) write_cr8 exits can represent the
overwhelming majority of exits (hence the quotes around "just" a performance
issue), and (b) running with a bad/wrong configuration increases the chances
of encountering other lurking TPR bugs (if there are any), i.e. of hitting
bugs that would otherwise be rare edge (which is good for testing, but bad
for production).

Sean Christopherson (2):
  KVM: SVM: Initialize AVIC VMCB fields if AVIC is enabled with
    in-kernel APIC
  KVM: SVM: Set/clear CR8 write interception when AVIC is (de)activated

 arch/x86/kvm/svm/avic.c |  8 +++++---
 arch/x86/kvm/svm/svm.c  | 11 ++++++-----
 2 files changed, 11 insertions(+), 8 deletions(-)


base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
-- 
2.53.0.rc2.204.g2597b5adb4-goog


