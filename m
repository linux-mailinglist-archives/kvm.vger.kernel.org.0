Return-Path: <kvm+bounces-69762-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOb6AJNpfWk4SAIAu9opvQ
	(envelope-from <kvm+bounces-69762-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 03:31:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A051C04DA
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 03:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B4F43016EC2
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 02:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452862D29C7;
	Sat, 31 Jan 2026 02:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DWvVdY9S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040F179A3
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 02:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769826697; cv=none; b=n9FUuHsJY3+bzmCq3KtQax9cDEJbR5fujIZSs1ycMR3EVMYs1ObJP3AdNbdcjUbMYoZzKU8UafFXYxLhv8WKWA1whgo08X4onIJfsGk8lfjYECwG2sjQva5rA7941vLVA8TmPEIq2dJfW0tEoe6jY1heOl+MlakWs3oXrjUHibc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769826697; c=relaxed/simple;
	bh=EKPQLWbsWyT9BUr2s5Ctqy4Jc4chfE3nJq0OgEVxysQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Shkjmd0nzzXSvkYKGth1KG+Niw+cvcHVVVX4ZJt8glJXSYzVMDZwSZ+2COJf9lhqGVmGPEHEHY3eOegySR52P4roCe3YEGQkgS+uZa3zscDGQLLa+ZqVuXoHRyNKqtlD7aYM24stzj6HzIu11ToSrZ7kP0Kc0Jce3GdCVoR993o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DWvVdY9S; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a773db3803so30995685ad.1
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 18:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769826696; x=1770431496; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ctO94QNI1k+SuuLJULnF65RAXsyYJ0G/MWNFTi5M4v8=;
        b=DWvVdY9StnwMEIxAtMuD5nVYgOsPMQRFQ+U0+nuhOewbCst9Jv73Ru3GTpAwr3vd9y
         Hjxaj8zjixYnd19Xpl+FQPOyRRTDdyTDVqDqZSbSOTlCmqBcZHkG8KBuNl6mhNCOQXkz
         e16Bq/u8+EES6k2++Q53d44hH7hVtZc5PJqAriG6poeLXfPvRhibsIuUrq7FPQP60NSZ
         wQm1TQ9txr0ETEc2Mnd5ite1pUjA1xk5AWQLw4B7b3HhJA9Nlc8FSkAwWC/cypeHAW8v
         vXkj0jsk0zVQApVIGgf56yBpmhqXNNcmaIbugStuq1DwrwskWBa8ofMBkVSixQFz00F9
         wkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769826696; x=1770431496;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctO94QNI1k+SuuLJULnF65RAXsyYJ0G/MWNFTi5M4v8=;
        b=tUQIuw6Fv9GkGp9aBlUwOWQBENo1uoifsi8tP2Ynsr98x56pCn/+IpHmoBeERYny7p
         CbRgTkiyyZbQpsFfLxP5OnWasdcJBxWC71U/6VKhZORDeML73391hwLAhFVOHF/aQ45g
         Fqe3NiM+vH47SXX7KYJvV1BsPUiY5JjV6W0YG3afaCJpRIkaqpmRkiw5NkpaC6Fd8f9Z
         +baHaGCoN6mTwKfV/DMc0X9nasRieU95b91mNZVLsNWtUJ6pikTtpMwlCLDtaQeh8gHy
         guIT54rDvmaeGCxOaF2wK66+KQluzswpVGGbf6OP1PatOLcPwfNltBovrf1oYV1dVenw
         J/6w==
X-Gm-Message-State: AOJu0Yx9b92GahOHVNXtqO9K+JbcNt2RZHPgOtA30O+3M1llMd0Ku+VT
	gM/Gi+GYy7RTMGrTgfDVQZauEPJjNBlLzYTaGUotOoprsEMjuHU7PwP8my11lL7tmgiR56YUNAG
	rekkFSw==
X-Received: from plgz13.prod.google.com ([2002:a17:903:18d:b0:29f:bf99:8c9f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:aa82:b0:29e:e642:95d6
 with SMTP id d9443c01a7336-2a8d9a7a005mr34084265ad.59.1769826695713; Fri, 30
 Jan 2026 18:31:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Jan 2026 18:31:33 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260131023133.2661-1-seanjc@google.com>
Subject: [GIT PULL] KVM: Fix for 6.19-rc8 (or final)
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69762-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCPT_COUNT_THREE(0.00)[4];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 5A051C04DA
X-Rspamd-Action: no action

Sorry for the late pull request, I was waiting on reviews for the CET fix to
settle down.  I _just_ amended that commit to add a Reviewed-by, but it's been
in linux-next with identical code since Tuesday.

The most pressing issue is the IRQ routing bug (and also probably the scariest,
but it's had several weeks in -next), as it leads to all kinds of badness on
AMD platforms.

The following changes since commit 3611ca7c12b740e250d83f8bbe3554b740c503b0:

  selftests: kvm: Verify TILELOADD actually #NM faults when XFD[18]=1 (2026-01-10 07:17:30 +0100)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.19-rc8

for you to fetch changes up to f8ade833b733ae0b72e87ac6d2202a1afbe3eb4a:

  KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps() (2026-01-30 13:27:33 -0800)

----------------------------------------------------------------
KVM fixes for 6.19

 - Fix a bug where AVIC is incorrectly inhibited when running with x2AVIC
   disabled via module param (or on a system without x2AVIC).

 - Fix a dangling device posted IRQs bug by explicitly checking if the irqfd is
   still active (on the list) when handling an eventfd signal, instead of
   zeroing the irqfd's routing information when the irqfd is deassigned.
   Zeroing the irqfd's routing info causes arm64 and x86's to not disable
   posting for the IRQ (kvm_arch_irq_bypass_del_producer() looks for an MSI),
   incorrectly leaving the IRQ in posted mode (and leading to use-after-free
   and memory leaks on AMD in particular).

 - Disable FORTIFY_SOURCE for KVM selftests to prevent the compiler from
   generating calls to the checked versions of memset() and friends, which
   leads to unexpected page faults in guest code due e.g. __memset_chk@plt
   not being resolved.

 - Explicitly configure the support XSS from within {svm,vmx}_set_cpu_caps() to
   fix a bug where VMX will compute the reference VMCS configuration with SHSTK
   and IBT enabled, but then compute each CPUs local config with SHSTK and IBT
   disabled if not all CET xfeatures are enabled, e.g. if the kernel is built
   with X86_KERNEL_IBT=n.  The mismatch in features results in differing nVMX
   setting, and ultimately causes kvm-intel.ko to refuse to load with nested=1.

----------------------------------------------------------------
Sean Christopherson (4):
      KVM: SVM: Check vCPU ID against max x2AVIC ID if and only if x2AVIC is enabled
      KVM: Don't clobber irqfd routing type when deassigning irqfd
      KVM: x86: Assert that non-MSI doesn't have bypass vCPU when deleting producer
      KVM: x86: Explicitly configure supported XSS from {svm,vmx}_set_cpu_caps()

Zhiquan Li (1):
      KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some unpredictable test failures

 arch/x86/kvm/irq.c                       |  3 ++-
 arch/x86/kvm/svm/avic.c                  |  4 +--
 arch/x86/kvm/svm/svm.c                   |  2 ++
 arch/x86/kvm/vmx/vmx.c                   |  2 ++
 arch/x86/kvm/x86.c                       | 30 ++++++++++++----------
 arch/x86/kvm/x86.h                       |  2 ++
 tools/testing/selftests/kvm/Makefile.kvm |  1 +
 virt/kvm/eventfd.c                       | 44 +++++++++++++++++---------------
 8 files changed, 52 insertions(+), 36 deletions(-)

