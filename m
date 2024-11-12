Return-Path: <kvm+bounces-31566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCEE9C4F99
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04D02281542
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BED020B7EE;
	Tue, 12 Nov 2024 07:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="coDSGFy8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E27849C;
	Tue, 12 Nov 2024 07:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397068; cv=none; b=DcMWTkMzCPape3pMDDzvmTpRhnx+wMzydzfPElZhVvl/jZKJ6/4WwnMDMkbu7zQuWcg4PiL2lSEVVNDs56hAW669AMDVztCojBoWScmwyoEzMfVUy8hvYjprfLWkS9eY8CuBINFv0CfxtyIb/YfsNjdVaft+9xfRBbz/mb64p14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397068; c=relaxed/simple;
	bh=kT4mFrbUXzSw+ZvkIhQ9I58T4nMsjmaFcq1Xjn9KWGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA6DxSq+dNC0CXtv+Zkademu00qCf7p07ZhCtcEnP+wnD2LmlkTHyzQnvLkgdb31RUjSo0F3mKRo40A4X4dylENJYYHpcfAQtB4n9bxv/eq2wkXPCuXfvDeu30qjJFZnRkR+wj/nxOOO7QKzfBZj1iY/GPjOb3G3sgWr6/ThQYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=coDSGFy8; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397067; x=1762933067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kT4mFrbUXzSw+ZvkIhQ9I58T4nMsjmaFcq1Xjn9KWGc=;
  b=coDSGFy8U7MZDMBaf3heUDcq6FvSOqjxywB3484zzij6UycgvLsOEXAy
   Oh2AfKnU7bk/4LM2Iw1SqgGiuhj+eLw3/R2DJdxy9X5AN7HtO2v1ddW8z
   WLrFXJuTa17NXLNtbS205HugnT1C980fBP0owLUWjTSMITKKgiWXYag+P
   bm8c3Gv1QSxAmriWA+n6h2oGXWvmO/dKnQQKyfgiF+Rv+T0vYSLEveOx3
   REbg52PApcPE3w4iJ1QJzk1EpYkTbOjU8Cj7oPLi4dfxvZD+nmLHTcsJ5
   c2+oxl31QrycDfFYGqgHK9n5B2wCbGYsc/Dfi6RZXoCmGmt4oBI2rrS1v
   w==;
X-CSE-ConnectionGUID: 3yqSpFjWSFK7UG8ao/U+hA==
X-CSE-MsgGUID: pJabUOZkShmllVKL6gxR8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="30616049"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="30616049"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:37:46 -0800
X-CSE-ConnectionGUID: IQ9SC6sdTiqE00aRrGNeTg==
X-CSE-MsgGUID: S+D2hQ5GQMuTIe7ZRP2rvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92416912"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:37:42 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 03/24] KVM: x86/mmu: Do not enable page track for TD guest
Date: Tue, 12 Nov 2024 15:35:15 +0800
Message-ID: <20241112073515.22028-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fail kvm_page_track_write_tracking_enabled() if VM type is TDX to make the
external page track user fail in kvm_page_track_register_notifier() since
TDX does not support write protection and hence page track.

No need to fail KVM internal users of page track (i.e. for shadow page),
because TDX is always with EPT enabled and currently TDX module does not
emulate and send VMLAUNCH/VMRESUME VMExits to VMM.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Yuan Yao <yuan.yao@linux.intel.com>
---
TDX MMU part 2 v2:
- Move the checking of VM type from kvm_page_track_write_tracking_enabled()
  to kvm_enable_external_write_tracking() to make
  kvm_page_track_register_notifier() fail. (Paolo)
- Updated patch msg (Yan)
- Added Paolo's Suggested-by tag since the patch is simple enough and the
  current implementation was suggested by Paolo (Yan)

v19:
- drop TDX: from the short log
- Added reviewed-by: BinBin
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 561c331fd6ec..1b17b12393a8 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -172,6 +172,9 @@ static int kvm_enable_external_write_tracking(struct kvm *kvm)
 	struct kvm_memory_slot *slot;
 	int r = 0, i, bkt;
 
+	if (kvm->arch.vm_type == KVM_X86_TDX_VM)
+		return -EOPNOTSUPP;
+
 	mutex_lock(&kvm->slots_arch_lock);
 
 	/*
-- 
2.43.2


