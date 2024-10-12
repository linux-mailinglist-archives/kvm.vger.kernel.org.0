Return-Path: <kvm+bounces-28674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96DDD99B1DC
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 09:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CDAB1F25681
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2024 07:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6859146A66;
	Sat, 12 Oct 2024 07:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k/Fh5Bzm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7363113B7BC;
	Sat, 12 Oct 2024 07:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728719774; cv=none; b=lvdaGfx1rt5GJ/nhdm8EStzDaeiUuQ+2sWf4uuyrYLhDIATYmV3pmTQHxdQFt+jzjpNoe/Q+fSYGgVJ+e9j7HJbaZnbdfRZ/me6IWWXTuqoaIYs1VfJ69H7LV1an1XVKAKak9pOrnTEAk4ga3ZvM7uBSSxv16hGSzNfzupdJt3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728719774; c=relaxed/simple;
	bh=Z4r6YlfUbeU/3Vc1bRAgwqZUf48Vf50QTA+ykifcW2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQREay47M4uGXdSMP4b5DQ7duIaSzAD4fBB+eiPMrQ+sE1JdwhAITbV1yw5MwPpR66pBvO7QmOuWGZJ89BuWMapQsR8PC785pL4nAI2hfAdGnmOoeNjqufnQX5SOXojS5fqVz+L+rk7UgjLgEw6P2cfIu56d/3asP7Q2igIIjSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k/Fh5Bzm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728719773; x=1760255773;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z4r6YlfUbeU/3Vc1bRAgwqZUf48Vf50QTA+ykifcW2k=;
  b=k/Fh5Bzmu02cKY7oQKGqs2nGj6wz58MAR7J4y9kEcrYAPq2uvxBEZulV
   j/ftMUt1Q+GqBh6+QM8+fYEZaSFp6U3zac4/TuPyNRLIe8Yv7xNf71XSb
   wpoqZ06Zl0mj6jEyi8XVjR6Ny4GWBVfrXol0V3SknKt7BDJEIOYSLPtV/
   ZNiQEBhtVzSSJ+NhZzMQPNEtYHXwpB6Jfr0f8aLLSZe3vPuHC6JUhvVTM
   lebF2UowC6BoU21U5u9o9hjmgKFPNv5evckOEiPZeBAnlZHSVUAhwVtd1
   3DQV2dvtXnOI543pSSMtCt/AYgGCQwKsxUeCfz4EgagL2KQeshe54whIq
   g==;
X-CSE-ConnectionGUID: Gzs99NopRJmDtga/DmFkNQ==
X-CSE-MsgGUID: DWRCZJZlSD+Y4JYNTBYSQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="39510289"
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="39510289"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:09 -0700
X-CSE-ConnectionGUID: luuAxlURTr+oWa4OYWzoBg==
X-CSE-MsgGUID: So5Y1WThQTWb4yQ7kcacow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,198,1725346800"; 
   d="scan'208";a="82116739"
Received: from ls.amr.corp.intel.com (HELO localhost) ([172.25.112.54])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2024 00:56:09 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: Sean Christopherson <seanjc@google.com>,
	chao.gao@intel.com,
	isaku.yamahata@intel.com,
	rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	Nikunj A Dadhania <nikunj@amd.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/2] KVM: x86: Push down setting vcpu.arch.user_set_tsc
Date: Sat, 12 Oct 2024 00:55:55 -0700
Message-ID: <62b1a7a35d6961844786b6e47e8ecb774af7a228.1728719037.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1728719037.git.isaku.yamahata@intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push down setting vcpu.arch.user_set_tsc to true from kvm_synchronize_tsc()
to __kvm_synchronize_tsc() so that the two callers don't have to modify
user_set_tsc directly as preparation.

Later, prohibit changing TSC synchronization for TDX guests to modify
__kvm_synchornize_tsc() change.  We don't want to touch caller sites not to
change user_set_tsc.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb24e394d768..65d871bb5b35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2644,12 +2644,15 @@ static inline bool kvm_check_tsc_unstable(void)
  * participates in.
  */
 static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
-				  u64 ns, bool matched)
+				  u64 ns, bool matched, bool user_set_tsc)
 {
 	struct kvm *kvm = vcpu->kvm;
 
 	lockdep_assert_held(&kvm->arch.tsc_write_lock);
 
+	if (user_set_tsc)
+		vcpu->kvm->arch.user_set_tsc = true;
+
 	/*
 	 * We also track th most recent recorded KHZ, write and time to
 	 * allow the matching interval to be extended at each write.
@@ -2735,8 +2738,6 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 		}
 	}
 
-	if (user_value)
-		kvm->arch.user_set_tsc = true;
 
 	/*
 	 * For a reliable TSC, we can match TSC offsets, and for an unstable
@@ -2756,7 +2757,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
 		matched = true;
 	}
 
-	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
+	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched, !!user_value);
 	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
@@ -5760,8 +5761,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
 		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
 		ns = get_kvmclock_base_ns();
 
-		kvm->arch.user_set_tsc = true;
-		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
+		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched, true);
 		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
 		r = 0;
-- 
2.45.2


