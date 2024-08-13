Return-Path: <kvm+bounces-23935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D9A94FD15
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 262631C225D7
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89560364A4;
	Tue, 13 Aug 2024 05:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ke9o+I1Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA68219F3;
	Tue, 13 Aug 2024 05:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723525872; cv=none; b=dihGqicM9sp4KprpN6P7F2bw5HXit9KXXdjfX+RlfZ91NlldbZdbTZQ9EqS3IKT3C9aTzELaBKnnOTFoWupIBeuq0oFctdbPLw3c6cukCSKjVndcUzE7sE8CZJnSGqX6rG7sqrAtCvkPuH4zcIbq5K4z5sbrfyzFLiFj1gHwuhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723525872; c=relaxed/simple;
	bh=Jt2fVvXI2xZMtx/2VPb0il/aCjdgZSC1QGJwabQziG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1/ie05UOmJoIg84g6jF7gGRV85BKYoMhcEnd0HRBxvpJdAuMYKEHXEv9PJW8Zvjo2j4/bB62JSt7da9Tix5dXEFb+e3BQa8uzBFEM4aX75MY2Hn5YgYs/0Z3BQJs3SzmuQobbAfE4RPaObaOO1NnYu76+paHdSrJndH/94bVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ke9o+I1Z; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723525871; x=1755061871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jt2fVvXI2xZMtx/2VPb0il/aCjdgZSC1QGJwabQziG0=;
  b=ke9o+I1ZWpyE4MYO2QkLYz2AwyrJWQF064r/zh+R/AHAVui+C5W4AkQQ
   T3hBsjbnyG22T7zLckmzH+soCkqC+EXJbmIMB9UMBdkzLc8nbdZbhdO/+
   9AP7FA01MguRX7jZtVxDTIUIXPj7KGdQhArufELEZ262ODsbU63H7zlRZ
   ZFlrzolyxLiMHUQUwwsu9zka5dxhRbyYS8KSkqwyWZHD6b/CQ4vDb6GPL
   YsIjhvy0c5e1bsF4Rxiu47TzGgi9XXHDsK19VUVMRVs+VLj2p9ZGkbOBU
   PX1XZLojmdGLEmb8DoycnEAp7iGtSHlSIGetF5sHuj/KFag9vjkvFxXhN
   w==;
X-CSE-ConnectionGUID: uy2W0BNUSZC3IoM24Iqc+Q==
X-CSE-MsgGUID: anPvIKOjScCREQ7tSiK7GA==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32239360"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32239360"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:09 -0700
X-CSE-ConnectionGUID: JyovyQ68SQarXa7RKt55yw==
X-CSE-MsgGUID: 9DL1GqM0S8m52vCzJj+7bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58185524"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:11:07 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 1/2] KVM: x86: Check hypercall's exit to userspace generically
Date: Tue, 13 Aug 2024 13:12:55 +0800
Message-ID: <20240813051256.2246612-2-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check whether a KVM hypercall needs to exit to userspace or not based on
hypercall_exit_enabled field of struct kvm_arch.

Userspace can request a hypercall to exit to userspace for handling by
enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set in
hypercall_exit_enabled.  Make the check code generic based on it.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 arch/x86/kvm/x86.h | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af6c8cf6a37a..6e16c9751af7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10226,8 +10226,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	cpl = kvm_x86_call(get_cpl)(vcpu);
 
 	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-		/* MAP_GPA tosses the request to the user space. */
+	if (!ret && is_kvm_hc_exit_enabled(vcpu->kvm, nr))
+		/* The hypercall is requested to exit to userspace. */
 		return 0;
 
 	if (!op_64_bit)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 50596f6f8320..0cbec76b42e6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -547,4 +547,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline bool is_kvm_hc_exit_enabled(struct kvm *kvm, unsigned long hc_nr)
+{
+	if(WARN_ON_ONCE(hc_nr >= sizeof(kvm->arch.hypercall_exit_enabled) * 8))
+		return false;
+
+	return kvm->arch.hypercall_exit_enabled & (1 << hc_nr);
+}
 #endif
-- 
2.43.2


