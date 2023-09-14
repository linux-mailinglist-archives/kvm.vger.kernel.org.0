Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488417A0067
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbjINJit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237403AbjINJi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:38:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EA31FCD;
        Thu, 14 Sep 2023 02:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694684302; x=1726220302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+nX7XbfVJDmuajtuURcflfcN8G9QEQqgxp6V39Gi2/4=;
  b=E0BwAGNpX3ZGaRcX3ukmz3L68KkLiByzH4Uk5e/pIHyqAc+0vPRahE8r
   YXrYMYsDHUnRSurguhEP38+V+rTSBaleENKqAZlX3AEGLQdPn0sSR1p/X
   KLitecvwT0b65iHHROUaAqVZjuSr/yaaoyctYECmszOo1MthqIm8xgcGu
   OXvpjCJMe7XZXbUMCsmzmLeRGitm7tv5oTE0I2zOxoOoW941VMByN52pY
   YWjPR4SKkJC7a7TL9oW+P0vTVcIrNoPUTyN9n8nAJMKLuX473GQ4iTH75
   J0WF88st1/xsYbqiuAbABxH1yQTsBb84/titEFpiX2ZT/jyDSiB4AR5CJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="409857407"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="409857407"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="747656279"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="747656279"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:38:21 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com
Subject: [PATCH v6 18/25] KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT enabled"
Date:   Thu, 14 Sep 2023 02:33:18 -0400
Message-Id: <20230914063325.85503-19-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230914063325.85503-1-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the governed feature framework to track whether X86_FEATURE_SHSTK
and X86_FEATURE_IBT features can be used by userspace and guest, i.e.,
the features can be used iff both KVM and guest CPUID can support them.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/governed_features.h | 2 ++
 arch/x86/kvm/vmx/vmx.c           | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
index 423a73395c10..db7e21c5ecc2 100644
--- a/arch/x86/kvm/governed_features.h
+++ b/arch/x86/kvm/governed_features.h
@@ -16,6 +16,8 @@ KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
 KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
 KVM_GOVERNED_X86_FEATURE(VGIF)
 KVM_GOVERNED_X86_FEATURE(VNMI)
+KVM_GOVERNED_X86_FEATURE(SHSTK)
+KVM_GOVERNED_X86_FEATURE(IBT)
 
 #undef KVM_GOVERNED_X86_FEATURE
 #undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9409753f45b0..fd5893b3a2c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7765,6 +7765,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
 	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_SHSTK);
+	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_IBT);
 
 	vmx_setup_uret_msrs(vmx);
 
-- 
2.27.0

