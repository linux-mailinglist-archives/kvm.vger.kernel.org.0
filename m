Return-Path: <kvm+bounces-15502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E16EB8ACDC7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:06:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5F4A2829DC
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2A8B14F11E;
	Mon, 22 Apr 2024 13:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j167Pmgv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F55C14A4DD;
	Mon, 22 Apr 2024 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713791168; cv=none; b=aEscad1qnkl+Fnwbxw1zaR/HhQofZpC6HxgFd7hs1JSn9I0Tbqp5DvPulRqBllytWymi5uSChf/NINZD7kYZIoD1R1jpjEox58mtW4VmRVygRH7MbkXLxlAmLg/QMmRhDD0MyByyGfoM6yG4tdKy4rsOXoHKdi8/WFEA/pvmXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713791168; c=relaxed/simple;
	bh=fhRhsOSGGETJNMDVzgOxAKmNDbY3BmfPvtw/D1BsTDY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ik5RrYwS/ZRR9c8ceVVvxvy4cggR7ZO60/1Ql6lfE1SCvuruh4TTD+DcjN7lBbtIwjjUBVvY6Y0yAYrnHmlCxQYzUR0tCi754d386eUFXNcauyvtnWO6r4R7mLusQSWOzddvvWXPwFpv/IApEdUGN0C3IFi/xxoNDpwdvNhbi2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j167Pmgv; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713791163; x=1745327163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fhRhsOSGGETJNMDVzgOxAKmNDbY3BmfPvtw/D1BsTDY=;
  b=j167PmgvL5lvvlsGQk74Rym2etEA8oKWRloF6TS+t4jCfOdothtn25En
   f9WtdASFEP64px0UXXQNxJwuJ40ks1QsntRk16mxh39tii7ilOr1HxqFw
   XFWXFgFvBoXazDpXiOH45HtN2TrU1OLASCGMPQ5AnzxabIX+eR2rIqS+W
   Hq+0SSCB/Wv+BpL9TUJF+vHA5/+mSav2ksr+hYmuyPYE4PWfTwepXcU6Z
   fU5/ETQAJYFwp1qcGlOroTeXlzgehyX+JpHazayVHRRD5aTQYTNjIjJB7
   tZl33mGyJ1Z8g8/iRNyfOICU7Zhg1mrdRRi2IuzyfR2jRvQGP9BvIdxQI
   A==;
X-CSE-ConnectionGUID: SfWqj0eBSlKNjo7l3o/QCA==
X-CSE-MsgGUID: pkK+PbygTjeqDUQxaZCycw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9546526"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="9546526"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 06:06:02 -0700
X-CSE-ConnectionGUID: ffCAjvMnQk2poxOxqT6vsA==
X-CSE-MsgGUID: DHFcOZ8ETiyPhYBH21zEgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="23986959"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by orviesa009.jf.intel.com with ESMTP; 22 Apr 2024 06:06:01 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1] KVM: x86: Validate values set to guest's MSR_IA32_ARCH_CAPABILITIES
Date: Mon, 22 Apr 2024 21:05:58 +0800
Message-Id: <20240422130558.86965-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the bits set by userspace to the guest's MSR_IA32_ARCH_CAPABILITIES
are not supported by KVM, fails the write. This safeguards against the
launch of a guest with a feature set, enumerated via
MSR_IA32_ARCH_CAPABILITIES, that surpasses the capabilities supported by
KVM.

Fixes: 0cf9135b773b ("KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts")
Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebcc12d1e1de..21d476e8e4b0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3808,6 +3808,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_ARCH_CAPABILITIES:
 		if (!msr_info->host_initiated)
 			return 1;
+		if (data & ~kvm_get_arch_capabilities())
+			return 1;
+
 		vcpu->arch.arch_capabilities = data;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:

base-commit: 49ff3b4aec51e3abfc9369997cc603319b02af9a
prerequisite-patch-id: adcf6a23955e33796219e612d703ae107482d1a5
prerequisite-patch-id: dbb173ac5bdfc012168f13188de6fda47dd109ca
prerequisite-patch-id: b0fab89edfe2456f4e892d008eaac0648c420f5d
prerequisite-patch-id: 8371de5f48c05e346824364fb6155958d21b37df
prerequisite-patch-id: 05382cd95d03b5117dbab4affa4deb1f325af11b
prerequisite-patch-id: 4597cf183484342bf1ae96fccaab209a10fa0a5c
prerequisite-patch-id: a89dfcd6ce3748d297cbe338af9ccf4178bd6538
prerequisite-patch-id: 77189fb281d97a6ec63be83c7c0659dded09c046
prerequisite-patch-id: db39eb599599bdedaf6ce3565817b484f9190d83
prerequisite-patch-id: 840f990b7e127d2610ba2633a77b96b076e5b699
prerequisite-patch-id: b4934fe6c00e8794578e8e1c43784bdeac8fe7bb
prerequisite-patch-id: b2a88fe95fb4d57757798576af88d9b10ecf0b44
prerequisite-patch-id: d2b0f2992dba636908972d75a569f1294cc5dfb1
prerequisite-patch-id: e5a19717c15d8a1ff906dc5ea097b7a8392abf80
prerequisite-patch-id: 7fc7bedbde2814763e9860d65903f1987e61107e
prerequisite-patch-id: 15b1621fda294d8b486f19a514b733dc7de94a70
prerequisite-patch-id: 87b48657d42fd4b80ad3c74d6009c06048ad5c68
prerequisite-patch-id: f5020e37f76403b649908b3a6682db1330f1202c
prerequisite-patch-id: 44b3adbeab1096ab3093cbbb2a72c9fa837d8100
prerequisite-patch-id: 50821a9074c303f3cc8cf4aefb91fe39c7bbd2b4
prerequisite-patch-id: 1168a01580cf2a4dae5ea36e58f0633da5d624e1
prerequisite-patch-id: 912e431eee034bc19cae9bd4ec3cf2aa1b86e66f
prerequisite-patch-id: 8b410b87d9c4cd67e37b59af4800aed8640ae2b4
prerequisite-patch-id: 39d09da8c9dfde6fea0ebc313b41fcf50bad9e8f
prerequisite-patch-id: df2b2c3c5116d994c3d103ea7586e189c0a8b38f
prerequisite-patch-id: d9e8b09ef589e51e925182b66c20d53a6d42d074
prerequisite-patch-id: 50ede137eb3500592b91f7ac6ba741fb680bb8d1
prerequisite-patch-id: 50e770836f91502903de710da1649ca25d06adac
-- 
2.27.0


