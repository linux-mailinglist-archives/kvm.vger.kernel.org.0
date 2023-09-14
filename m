Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610A97A0062
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbjINJiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237379AbjINJi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A1A1FC8;
        Thu, 14 Sep 2023 02:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684301; x=1726220301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eOwVTkRE0fn4PxlTlhArnb0PaHsbEIKS1k0cy/K5iE4=;
  b=Igb7a9z+s0YwBvnrASfWT91tui2prdVT/lZsYqqNXonmC0KrdqfKp3vL
   xM1L6Yhgznb2uC/9WHCyeXe9Oi/R0eASlr48BX3rRNTL9bY9wrZDq33/v
   dVKVbVGYecyilH/RwdrSvyXbS5tM1ybnAAG+eRletcqt8L+tC7zMwGQBY
   gKnZLLZjVlUKVP2jJ2f5dvMe357Keuw6JahmykFZrUin5GvTO5FJISL7+
   r4JLqOfWkgeuIdtRxVf7WDkTLOoazlk50w/6YkNddBBkZF602yqCje/hU
   j3c2laltFZg6XbWfDaNStIwrCTVxD+9lBMm/2NQbFs0xoWLzQOl6WXHju
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857391"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857391"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656265"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656265"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:20 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 15/25] KVM: x86: Add fault checks for guest CR4.CET setting
Date:   Thu, 14 Sep 2023 02:33:15 -0400
Message-Id: <20230914063325.85503-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check potential faults for CR4.CET setting per Intel SDM requirements.
CET can be enabled if and only if CR0.WP == 1, i.e. setting CR4.CET ==
1 faults if CR0.WP == 0 and setting CR0.WP == 0 fails if CR4.CET == 1.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a091764bf1d2..dda9c7141ea1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1006,6 +1006,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
+		return 1;
+
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1217,6 +1220,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
+		return 1;
+
 	static_call(kvm_x86_set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
-- 
2.27.0

