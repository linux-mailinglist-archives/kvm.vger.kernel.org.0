Return-Path: <kvm+bounces-27731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CFC8198B360
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 07:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DB3C1F243DC
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 05:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715EA1BE878;
	Tue,  1 Oct 2024 05:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Nprt8NK8"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE11BBBEB;
	Tue,  1 Oct 2024 05:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727758939; cv=none; b=snJiBbl+A4iCO0tksvN5qEr7dHG1huIAj5LQ++Jr/HsGCwMP2SUcCG5v2ZHFLLnpu9k7R4X9f74AAV6FcVRBumF8zedQipAaCBhE3rqHtMYr3kHwGLnaSFStUdFyF7334uqyCEdaPHDH+51XQc/dFI/3mww0iLf1q5NXlu3HoiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727758939; c=relaxed/simple;
	bh=LRG9ZLTJGb1kbujI26m79Oe7Kb0Z4AA/H5tMveOXNdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZch4r5G3+DCvsZ4YtnN4471KuAk8Tm2UEb0TKiNXSelpvNHY+RR4w1l7FzP6PpwSZfp9qcm/9Z2Y5axRmOL3IRnvI4wvAk4c+2c/sidpnTEV+58etzp8KQPl8559gvvFannH6xXfhKr2OUjWsBfqF+Vocqv+WUrdeXLll9tIas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Nprt8NK8; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 49151A7k3643828
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Mon, 30 Sep 2024 22:01:36 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 49151A7k3643828
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2024091601; t=1727758897;
	bh=RPhFfy2zSZru20q1Ob2vvvbmoygA5l+/VjghCwP2ILE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nprt8NK8Ij25W0/Ds+RHl2uuWji4EmoQRja+k9MCKZJASd2B2r0nAwTd8mu/j4aGI
	 v8O0CbhnhNKONJZl+K5UE+H42tr8Ni1rjpzrBmfCbkPkkZpCZzaJ2rxrl5c9KO29eW
	 dMF0E6LpoeCzG6q1nYGtcA2Qnk97CvX/W+SDU+FJP2IvhY0M/SY56JvGC1qQE1aWje
	 bhkL9oXJz4Ei/QVEiollXJ0Dkvr6hOIfRvSIaWQ/A+kCVlsfzgeQpfbi74CWDaJViq
	 6vUlbRRZOahU7QYm+vzlnm6MAQWBhJcWTyeGwXuui9gsYB0EIR7cGHrhLEA4aXm10C
	 gf436e1BSEyGQ==
From: "Xin Li (Intel)" <xin@zytor.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
        andrew.cooper3@citrix.com, xin@zytor.com
Subject: [PATCH v3 21/27] KVM: VMX: Invoke vmx_set_cpu_caps() before nested setup
Date: Mon, 30 Sep 2024 22:01:04 -0700
Message-ID: <20241001050110.3643764-22-xin@zytor.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001050110.3643764-1-xin@zytor.com>
References: <20241001050110.3643764-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xin Li <xin3.li@intel.com>

Set VMX CPU capabilities before initializing nested instead of after,
as it needs to check VMX CPU capabilities to setup the VMX basic MSR
for nested.

Signed-off-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef807194ccbd..522ee27a4655 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8774,6 +8774,12 @@ __init int vmx_hardware_setup(void)
 
 	setup_default_sgx_lepubkeyhash();
 
+	/*
+	 * VMX CPU capabilities are required to setup the VMX basic MSR for
+	 * nested, so this must be done before nested_vmx_setup_ctls_msrs().
+	 */
+	vmx_set_cpu_caps();
+
 	if (nested) {
 		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
@@ -8782,8 +8788,6 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
-	vmx_set_cpu_caps();
-
 	r = alloc_kvm_area();
 	if (r && nested)
 		nested_vmx_hardware_unsetup();
-- 
2.46.2


