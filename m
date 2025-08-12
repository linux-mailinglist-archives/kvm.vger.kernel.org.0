Return-Path: <kvm+bounces-54483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC999B21B14
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:59:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A35514663ED
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E49C2E763F;
	Tue, 12 Aug 2025 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A1MPcKyr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D936A2E5B1E;
	Tue, 12 Aug 2025 02:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967395; cv=none; b=qcgBKnN470Ojhvny0IheLbHdbU9pWkC+YDnm7thnvQalwnMm/N0xqBQYfnOhHvbLzSek/aI02SWTy8+2RNQpoN2oV0brm9c24msFkIB2da405soQXKfkncm9p8et8P1oUpGnjQO9GMnsp5s7m2KyDmuL9NeMuGG2c7yKmWiwhjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967395; c=relaxed/simple;
	bh=iHtDX6Kw8jTF13K/I8VPDptLJ5RQ2S1gc1SzihMXvNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhpWb+YlqLq14UBaZoyBNFBKGv/j32brlNFfNINk3ntdaxS9xPrvTe2l4R35Oc2lDV9TqXJr0+UpDOY67gi3/5rsTzCWDTjob72JkQHL7dAKxI+w0kwbCq0bkKcWi1xn6NWqYn4DgnE6ovhB3ybOkT145J8aSW/6j67UtfKgUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A1MPcKyr; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967394; x=1786503394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iHtDX6Kw8jTF13K/I8VPDptLJ5RQ2S1gc1SzihMXvNY=;
  b=A1MPcKyr6q6ya8mA8/qvrO8i4O5EL+cj1HSxmgyPgrlYDpvXYHzh2PCI
   N2Wj4oo91lktRSH2/FNkHMWEwjiBUlcjSCNplTe6HcEeMhVbRUd8dEsrh
   p7xXSDwZyd12rjYlbkkV9NJOZzAssw12EbZCagiovGHHRFh+0/1uEjS3S
   jtCwH1JrZAUA+bvZ5TKVsPxq242FiN7Bzz/FoEWUO3VIexQjqZqm5m8E8
   k2JjOXOwv+Ml3rliEMcO9OSF6CtRIJWlrsaD0Ubvwv0AY9o08gmSq2mbH
   JuWwudNV94b485tjTJ02tPu+yUYud0R093vr2k88j0B3EFCbju3kuo0Lz
   A==;
X-CSE-ConnectionGUID: zSQehnEhR9eIRXEflHxLFw==
X-CSE-MsgGUID: Sup5we1PQdizMOHLOMpitA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100532"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100532"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:31 -0700
X-CSE-ConnectionGUID: ut7sF5w2SHCDJjL2hssxAQ==
X-CSE-MsgGUID: 4flUTBgvT425LPM4atel9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321288"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:31 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 11/24] KVM: x86: Add fault checks for guest CR4.CET setting
Date: Mon, 11 Aug 2025 19:55:19 -0700
Message-ID: <20250812025606.74625-12-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f87974e0682b..cca05908f989 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1172,6 +1172,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1371,6 +1374,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.47.1


