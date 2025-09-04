Return-Path: <kvm+bounces-56837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBF66B44504
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AE2FA0220B
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B1334165C;
	Thu,  4 Sep 2025 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZFr2Lqw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F302FC025
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009157; cv=none; b=CuO1Ot7ddCXCh08Rs4ksDeINHn+DPiH5S80HXRmIFu50A/JHb/AgtHQyidjArxl4SmGEJS5KOz/1JfMNNopBb2I/uJGl6mhWyQQhm31FnMvW0OJnEt4mpNdS0oJCxtZCG0kWHHf6DqAbM5RNGejyegDoQSd92uq0yDyW/OrWiVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009157; c=relaxed/simple;
	bh=fEPQ3xPEopAj7Rbo8DF6qbYTk0TXadXXd95h2oTih9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGtUpjZK2MaxckVAAy75jQqiQQBmdbDyRtiTrArJDr/SF6eOsMXFaQ4mKbebmdrMQw1h7YI7t/cF93jApCxPWKnsaP4hXk6723IV3kP9v99EWNLbYrfvOHtx0RgmyNQL67Brj/7Z5i83zrmalArgRGUsfzzYNNssZnDTDsmGyIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZFr2Lqw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0080C4CEF0;
	Thu,  4 Sep 2025 18:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757009157;
	bh=fEPQ3xPEopAj7Rbo8DF6qbYTk0TXadXXd95h2oTih9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZFr2Lqw1/PL9GTwsLNXS/Gflir18KkCQE4MMYS6gFj6H0+mw/cjFr7eq14uIzTXl
	 V+nMVUMm73Nt6xQg6wQnj/+zcCykqCLb0l9yaPdWltsdccOh8+kyqbJ3i+5b2xFE1+
	 A8E0amU3UBUGXkfJkdBTy9seMYE1dHrNSTch4BqcYz2V4iSaMLh1eu9nsdGuSIQrSl
	 YtRnBUh7EyO8liKA5F565AUzM+a+AipLL9KSwiA6+jX1qcyHjQNYKpNRYoG0qVFhjf
	 zZl8csfrevxgvdA8KPVtO92S/wl5cRBu7lmxWxam19H1QXSpUCcifuDcx0GlwOUQe1
	 z4te3C9SXmnyQ==
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
Subject: [RFC PATCH v2 2/5] KVM: SVM: Simplify the message printed with 'force_avic'
Date: Thu,  4 Sep 2025 23:30:39 +0530
Message-ID: <5ebb7b1c278b6f20ee4f7afa0228298f9e504fbd.1756993734.git.naveen@kernel.org>
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

On systems that do not advertise support for AVIC, it can be
force-enabled through 'force_avic' module parameter. In that case, a
warning is displayed but the customary "AVIC enabled" message isn't.
Fix that by printing "AVIC enabled" unconditionally. The warning for
'force_avic' is also needlessly long. Simplify the same.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 346cd23a43a9..3faed85fcacd 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1110,16 +1110,8 @@ bool avic_hardware_setup(void)
 		return false;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_AVIC)) {
-		pr_info("AVIC enabled\n");
-	} else if (force_avic) {
-		/*
-		 * Some older systems does not advertise AVIC support.
-		 * See Revision Guide for specific AMD processor for more detail.
-		 */
-		pr_warn("AVIC is not supported in CPUID but force enabled");
-		pr_warn("Your system might crash and burn");
-	}
+	pr_info("AVIC enabled%s\n", cpu_feature_enabled(X86_FEATURE_AVIC) ? "" :
+				    " (forced, your system may crash and burn)");
 
 	/* AVIC is a prerequisite for x2AVIC. */
 	x2avic_enabled = boot_cpu_has(X86_FEATURE_X2AVIC);
-- 
2.50.1


