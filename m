Return-Path: <kvm+bounces-56841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6FF4B44509
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6987D1CC3742
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6886341662;
	Thu,  4 Sep 2025 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnuxHlWF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04B9305E2C
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009199; cv=none; b=kvMr0j9H2+Vk+j93lXytDfOWs1rRtvrhTSkQX4RUhIDpl5rG2T42LS7IYBbvrmbtUXVhPMUYN52LZB4iC3o2hEGLnl3IC2f1x1wpdVNM6uydMX2OAjEdNfcZgBrWxXN+puZ2gl43KIR22ejf1Z2I3GDPh7OPzmH92X7zTpWtx/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009199; c=relaxed/simple;
	bh=S15DWB0cMTDUtOhPwFPFiq52rw6C8F4YjsBmZmikn8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBO7FK6B7YSQ6kh5Nimi6Bat5zczdBRfwwmCmivVGs9B6O9wRGjAOG0vfHGYSSGRpYHBRpkpjWzKIm6rdIh4WtaJRor2VfaHUgwDSU5pJkiWS863Tah7WZ8Y4zJ7X53+FWXK/2CIgs39CucNeqgXqHFAiM6L8cS398ULWVIVkDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnuxHlWF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FD2C4CEF6;
	Thu,  4 Sep 2025 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009199;
	bh=S15DWB0cMTDUtOhPwFPFiq52rw6C8F4YjsBmZmikn8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnuxHlWFlasbPULTUOHOzglne/IFGdpW5qT6mErhs7wUQtceaOioAq3iCWwhZzP9a
	 7cSoNV2Y7JDU21E2xF6rDUMFWU8AgUYCX0J38PO4ZN2N4VX1CAU4Lq1kqRFnQ3wTcg
	 fBNJCYet35BqyBgBX0StcqhKvDR68lCz+IlYf+zOj7kwSbX6WSyN68kvOtKgvXg0md
	 vSHVuMectu6V1nRPy+pCfzOxGtjTCPmG7UknGwn5nGZxpwkZDoSHTf0M3Qu7eqKvMl
	 zoOXjZ+7X48ZkTl3uDQuUNqyA8TN7XyY6uOK6IYFe40Vij/rzY514WgYdf1np4Sr1W
	 azGwrbHJYhcRw==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RFC PATCH v2 1/5] KVM: SVM: Stop warning if x2AVIC feature bit alone is enabled
Date: Thu,  4 Sep 2025 23:30:38 +0530
Message-ID: <62c338a17fe5127215efbfd8f7c5322b7b49a294.1756993734.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756993734.git.naveen@kernel.org>
References: <cover.1756993734.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A platform can choose to disable AVIC by turning off the AVIC CPUID
feature bit, while keeping x2AVIC CPUID feature bit enabled to indicate
AVIC support for the x2APIC MSR interface. Since this is a valid
configuration, stop printing a warning.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a34c5c3b164e..346cd23a43a9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1101,14 +1101,8 @@ bool avic_hardware_setup(void)
 	if (!npt_enabled)
 		return false;
 
-	/* AVIC is a prerequisite for x2AVIC. */
-	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic) {
-		if (boot_cpu_has(X86_FEATURE_X2AVIC)) {
-			pr_warn(FW_BUG "Cannot support x2AVIC due to AVIC is disabled");
-			pr_warn(FW_BUG "Try enable AVIC using force_avic option");
-		}
+	if (!boot_cpu_has(X86_FEATURE_AVIC) && !force_avic)
 		return false;
-	}
 
 	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
 	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
-- 
2.50.1


