Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F591545F20
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 10:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347788AbiFJIbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 04:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347809AbiFJIaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 04:30:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E18538BDB;
        Fri, 10 Jun 2022 01:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654849775; x=1686385775;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=dsMgarbW4ow9Oyit6hSUwqptlh8ZDDx+kqJw7wi9gec=;
  b=YoPHyw60F8xTJhmwMV1JCjmalKKUAucKnCW0Zp/VHfFWore/buZlBox2
   YZCqbcGrr7DsYHGqbfCNiNJizClv/h4pQDY5aFlolpEa40QMZWmrAoM4P
   098egHEYm+4xnY/aqZF5rnN5kw1MnyiDa6JGlnURX/GyS5yL4a+ElRGVc
   /O5B7cZg221W/UeWfqd/hp7dStazk3hr+quQxWK9ZBI5VjRLyFroHgON8
   1tLBjOc8HTiWp7zgQz4Mmjqv/HRemPLpRWJZuiTl/q5Z72Js26meje08Q
   EDoSQxzvVjusWGBr3K9YiD3LKOP+8Qpxq6HuCYi1c8P4VNLm0XnhA10cE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="260680195"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="260680195"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 01:29:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="616391073"
Received: from harmonjo-mobl.amr.corp.intel.com (HELO guptapa-desk) ([10.252.138.149])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 01:29:34 -0700
Date:   Fri, 10 Jun 2022 01:29:34 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        tony.luck@intel.com, ak@linux.intel.com,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] KVM: x86/speculation/taa: Export TAA_NO to guest when
 host is not affected
Message-ID: <5ce91cdab031ecfdc82975ae492e4804b1c862d9.1654849348.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On CPUs that are not affected by TSX Async Abort (TAA), some host/guest
configurations can result in guest unnecessarily report TAA
vulnerability and deploy its mitigation. Particularly when a host
exports MSR_IA32_TSX_CTRL to guests and hides TAA_NO.

Due to MSR_IA32_TSX_CTRL exported by commit 7131636e7ea5 ("KVM: x86:
Allow guests to see MSR_IA32_TSX_CTRL even if tsx=off"), a guest with
CPUID.RTM=0 and "tsx=on" cmdline parameter will try to enable TSX
feature (using the exported MSR). Although TSX won't actually be enabled
in the hardware, but the guest would think that it is. Such a guest
would then set its X86_FEATURE_RTM. Also, KVM hides MSR
IA32_ARCH_CAPABILITIES[TAA_NO] bit from guests when TSX is disabled on
host. TAA mitigation selection in guest then sees X86_FEATURE_RTM=1 and
TAA_NO=0, and deploys "Clear CPU buffers" mitigation.

Export TAA_NO to guests when host is not affected by TAA to ensure that
guest doesn't deploy TAA mitigation unnecessarily.

Fixes: c11f83e0626b ("KVM: vmx: implement MSR_IA32_TSX_CTRL disable RTM functionality")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215969
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
I am not sure if exporting TAA_NO would affect migration pools and if
this is a sane thing to do. Any feedback on same is highly appreciated.

 arch/x86/kvm/x86.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9473c7c7390..1d14b5f82edc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1595,25 +1595,8 @@ static u64 kvm_get_arch_capabilities(void)
 		data |= ARCH_CAP_SSB_NO;
 	if (!boot_cpu_has_bug(X86_BUG_MDS))
 		data |= ARCH_CAP_MDS_NO;
-
-	if (!boot_cpu_has(X86_FEATURE_RTM)) {
-		/*
-		 * If RTM=0 because the kernel has disabled TSX, the host might
-		 * have TAA_NO or TSX_CTRL.  Clear TAA_NO (the guest sees RTM=0
-		 * and therefore knows that there cannot be TAA) but keep
-		 * TSX_CTRL: some buggy userspaces leave it set on tsx=on hosts,
-		 * and we want to allow migrating those guests to tsx=off hosts.
-		 */
-		data &= ~ARCH_CAP_TAA_NO;
-	} else if (!boot_cpu_has_bug(X86_BUG_TAA)) {
+	if (!boot_cpu_has_bug(X86_BUG_TAA))
 		data |= ARCH_CAP_TAA_NO;
-	} else {
-		/*
-		 * Nothing to do here; we emulate TSX_CTRL if present on the
-		 * host so the guest can choose between disabling TSX or
-		 * using VERW to clear CPU buffers.
-		 */
-	}
 
 	return data;
 }

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.35.3


