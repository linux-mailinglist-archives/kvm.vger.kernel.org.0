Return-Path: <kvm+bounces-41338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13D36A66524
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 825C6173FB6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 01:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4401F140E30;
	Tue, 18 Mar 2025 01:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdcJYygP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B3B256D;
	Tue, 18 Mar 2025 01:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742261619; cv=none; b=InEcSPMd7hEeXzBP2xZpb2nBadpPxW5xN+l4C5DtH3IOT8Vza1r5ldJ13qTPeGviz+r+BmV8JuxVOoYKK7PjcRzv3EEwAoOZh485zfqHWnHGqmmo+1/1nhUUeMWoVmaP82xvxUXoyKk7oSXmCKi/N7Nogp15+WGh7xLcNmAm00k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742261619; c=relaxed/simple;
	bh=PXdTvjKO9jrgad/pGh2EBWa191SiR6GvYLmT4pf8h8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBm+TvfN/wuP7zWYcYMD51270HoANN9aA8qhqypZedvKTiximOfobpdrYSjFwNLhGr+W/0U7dBWrLjSsPxUx+KUTC78FL5gyGVQkj2LjTREcZNjupMuQZ9nS6x2vvasao7so6Kqw2KsdI4BKmsPKuPwrZTW6TERW0hw0lSjwWLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdcJYygP; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742261617; x=1773797617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PXdTvjKO9jrgad/pGh2EBWa191SiR6GvYLmT4pf8h8o=;
  b=DdcJYygPPJjxCaaUN2PC6RxF8BJMcATb/9U4CyIoP1bClORLSmhjIIIj
   JkMgZbeeAxVvkIaWwcnqwi3uAL223P4IwAjHQ6iIf4mT6IABDe+ZXNqk3
   iGZG+XXgkZzlsQ534poGdpGvdokNZmb1ePUp/qtmktwcJ9OyyI1/EAVcO
   T1cU65d6dHaffPeQFG+YyIllGS08rLJjSMyCAZMsg1KGmFDIEYXIByovF
   APeWrFWQ2zzL5jm5Hyagp6YvdwFNc2j3SgTZyNVoqopkjAbhqLD5PcsKa
   PKdyh2fxUfrB9p0EE1HUK9AE0zJ74BJ9L25heRrr5ydvYxEU3fheBpvUX
   g==;
X-CSE-ConnectionGUID: OYvE5lg1SiSIO4HSL+k8iw==
X-CSE-MsgGUID: pKfqyy0MQESZW6/ifjNqMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="30964561"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="30964561"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:33:37 -0700
X-CSE-ConnectionGUID: CymqiyvaTJGLx2NR/rmWzA==
X-CSE-MsgGUID: Y2QCO1HXSuaByq2AZzbfBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="121838316"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 18:33:34 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 2/5] KVM: x86/tdp_mmu: Merge prefetch and access checks for spurious faults
Date: Tue, 18 Mar 2025 09:32:10 +0800
Message-ID: <20250318013210.5701-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250318013038.5628-1-yan.y.zhao@intel.com>
References: <20250318013038.5628-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Combine prefetch and is_access_allowed() checks into a unified path to
detect spurious faults, since both cases now share identical logic.

No functional changes.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ab65fd915ef2..6365eb6c1390 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1137,12 +1137,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (WARN_ON_ONCE(sp->role.level != fault->goal_level))
 		return RET_PF_RETRY;
 
-	if (fault->prefetch && is_shadow_present_pte(iter->old_spte) &&
-	    is_last_spte(iter->old_spte, iter->level))
-		return RET_PF_SPURIOUS;
-
 	if (is_shadow_present_pte(iter->old_spte) &&
-	    is_access_allowed(fault, iter->old_spte) &&
+	    (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
 	    is_last_spte(iter->old_spte, iter->level))
 		return RET_PF_SPURIOUS;
 
-- 
2.43.2


