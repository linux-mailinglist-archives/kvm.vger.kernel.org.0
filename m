Return-Path: <kvm+bounces-41812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A683A6DF41
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 17:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2704B1886905
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 16:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43FD82620DD;
	Mon, 24 Mar 2025 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THW8rtgm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613BF25D1E1;
	Mon, 24 Mar 2025 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742832382; cv=none; b=FZs/qwA4ibCrl4bnM6Lwk0BYVEBbKokgcEdXJ7H/ZNPY4w+F8mdc6/vEHYqIk/qZqUh/mgRQmc67OolQ68Gojcc+D1z7H4xt28dHfnvpg7iCPP6aaxX0eIJCfSalnIq0qLBKx6j6uMfahB/41NP3cfOVYCdUwJgKu3kVJtFj8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742832382; c=relaxed/simple;
	bh=NBr9hauWH0hXl44CcQwq1LSrc1ZJnCp50KRC5y+Qgg4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g5eX4wUFMQakfGxniSK4Z0a/JQ3Ca8jFs/ILjKORuZ0gDoz9zvdGAx3/+it3+txNCsxpPLAcXWkL7INMfdbJlsz4MCHu2BBsibSdf0a7vE2uLQ9YBcvecKRBY4LTT0a3QX8cFGtvV5OzA4Ce7Bpmr+vFK9zNLsPcRtauDCa8pW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THW8rtgm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4131C4CEDD;
	Mon, 24 Mar 2025 16:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742832382;
	bh=NBr9hauWH0hXl44CcQwq1LSrc1ZJnCp50KRC5y+Qgg4=;
	h=From:To:Cc:Subject:Date:From;
	b=THW8rtgmTexXtErwlE/Ud8rm2P6b/IxelVZg24TshIRoAlKTxBAvrz+yNMeGO8yi6
	 0AWNS+7R9ZxPJD2jk0QPJfqNUNXV5ZOnRAV/IU9H8PHsAoU6YFmOsed+SE+F9e5PFD
	 lAlIWfMRYrIobUw2H3PzlFSdfiW93akUa5P4PCHk7EuFoCLFvHJ3OHRbCkR8Qf136G
	 i83cgMFTISSUGH8MKkpfRXCwG5DoiU5nAD3Hcic2jia7pocpHSmBHonERCSVU89sk8
	 3dZLg9W+5jWNb4y2jgdsE6rjRg2P2fV6tSFYbwNdFou2FyzR0/5Xd9aV6YGOOpRj6Z
	 1CyBu+J6NhTnw==
From: Borislav Petkov <bp@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: X86 ML <x86@kernel.org>,
	KVM <kvm@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
Date: Mon, 24 Mar 2025 17:06:17 +0100
Message-ID: <20250324160617.15379-1-bp@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Borislav Petkov (AMD)" <bp@alien8.de>

WRMSR_XX_BASE_NS is bit 1 so put it there, add some new bits as
comments only.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/kvm/cpuid.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 121edf1f2a79..e98ab18f784b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1160,6 +1160,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP),
+		F(WRMSR_XX_BASE_NS),
 		/*
 		 * Synthesize "LFENCE is serializing" into the AMD-defined entry
 		 * in KVM's supported CPUID, i.e. if the feature is reported as
@@ -1173,10 +1174,14 @@ void kvm_set_cpu_caps(void)
 		SYNTHESIZED_F(LFENCE_RDTSC),
 		/* SmmPgCfgLock */
 		F(NULL_SEL_CLR_BASE),
+		/* UpperAddressIgnore */
 		F(AUTOIBRS),
 		EMULATED_F(NO_SMM_CTL_MSR),
+		/* FSRS */
+		/* FSRC */
 		/* PrefetchCtlMsr */
-		F(WRMSR_XX_BASE_NS),
+		/* GpOnUserCpuid */
+		/* EPSF */
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),
-- 
2.43.0


