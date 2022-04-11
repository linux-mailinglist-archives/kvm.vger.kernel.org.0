Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50A94FB7CC
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbiDKJkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344633AbiDKJjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:39:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBCE740923;
        Mon, 11 Apr 2022 02:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649669853; x=1681205853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=wVjlORT4Ee/YTCdDKrpjhYEEMJhlDlPVyc5jVtqX37o=;
  b=IZ6jW7MC2e6S7MLlR1l0KJdC0Xt1PCVweohDP7hW9dBMBhdLRxOGgO2A
   KPBHdd+qgPIW8CJR+kIbul2s0zQ1kl5/sodNbATZ60PVgTEBqvp6+CiyA
   JG6v6sEf9Ba8YtdYpGLMWgkob5bIXP28QUYt/w/U89P3EolvULwCxJ3F7
   Y2prGcHNRohyVTx24LpqomfQ/zpxrBHJuMVgs51ZgknS4PBCNsAyx6u+P
   ARNSjWCcuf2CtyWXoUaCC6cNTnVWy4j7gWvt3X4oY638GrAE8Qre2RNJW
   80WaRV9v9wHKNVInnSGRlQsUF7LU5JpWuUZyQf+7G6cn0LO9sfUv3uJEc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10313"; a="259671479"
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="259671479"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:37:09 -0700
X-IronPort-AV: E=Sophos;i="5.90,251,1643702400"; 
   d="scan'208";a="572050567"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2022 02:37:03 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v8 7/9] KVM: Move kvm_arch_vcpu_precreate() under kvm->lock
Date:   Mon, 11 Apr 2022 17:04:45 +0800
Message-Id: <20220411090447.5928-8-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411090447.5928-1-guang.zeng@intel.com>
References: <20220411090447.5928-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch specific KVM common data may require pre-allocation or other
preprocess ready before vCPU creation at runtime. It's safe to
invoke kvm_arch_vcpu_precreate() within the protection of kvm->lock
directly rather than take into account in the implementation for each
architecture.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/s390/kvm/kvm-s390.c | 2 --
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..5c795bbcf1ea 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3042,9 +3042,7 @@ static int sca_can_add_vcpu(struct kvm *kvm, unsigned int id)
 	if (!sclp.has_esca || !sclp.has_64bscao)
 		return false;
 
-	mutex_lock(&kvm->lock);
 	rc = kvm->arch.use_esca ? 0 : sca_switch_to_extended(kvm);
-	mutex_unlock(&kvm->lock);
 
 	return rc == 0 && id < KVM_S390_ESCA_CPU_SLOTS;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 70e05af5ebea..a452e678a015 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3732,9 +3732,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 	}
 
 	kvm->created_vcpus++;
+	r = kvm_arch_vcpu_precreate(kvm, id);
 	mutex_unlock(&kvm->lock);
 
-	r = kvm_arch_vcpu_precreate(kvm, id);
 	if (r)
 		goto vcpu_decrement;
 
-- 
2.27.0

