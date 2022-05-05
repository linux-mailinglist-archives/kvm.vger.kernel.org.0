Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130A351C6DD
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383061AbiEESTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383071AbiEESTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C971117B;
        Thu,  5 May 2022 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774543; x=1683310543;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DF2YmHbo2UpGtex9X0UYIzKWr6u+VFipK67sZ4vSZkM=;
  b=PyS7vwmlFSZJAsJ/ZogvCqRNameyPqUBNBB53TK1869q2Cle6CpTnvYR
   RTHXkDw54eR6GzaL0C3f5OTwK4eF9aFaJQ5XO+IOJhf+cp5GZ5nENdxDu
   RsFW7Bx2u5baPXyD4RwaHrzz/S2WA8qqMcUwrcpl3icH8KI5ihZjQ/LQv
   BQfCjCdcimhStCIdb0/bg0OYlIvZFeiMySSEJAtwLHufqMlQvrZmNVwKK
   cb+mgk3nJLBk6r5yPV7Pk7bEqs650SsNa50qJrUMdHXeLfaf59uGPP4db
   8P+9MG0AR0irFll7llVvIyXzmWin++6GfURndmfvzJ9axQSZ2X1vqN/OB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="265800737"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="265800737"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083216"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:43 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 026/104] KVM: TDX: Make KVM_CAP_SET_IDENTITY_MAP_ADDR unsupported for TDX
Date:   Thu,  5 May 2022 11:14:20 -0700
Message-Id: <a207a7181260bc1c55629c2bf901b22efb6418e2.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX doesn't support KVM_SET_IDENTITY_MAP_ADDR.  Return
KVM_CAP_SET_IDENTITY_MAP_ADDR as unsupported.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77e83e20180a..fd282e5efec1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4236,7 +4236,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_IOEVENTFD_NO_LENGTH:
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
-	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_HYPERV:
 	case KVM_CAP_HYPERV_VAPIC:
@@ -4389,6 +4388,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_DISABLE_QUIRKS2:
 		r = KVM_X86_VALID_QUIRKS;
 		break;
+	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
+		if (kvm && kvm->arch.vm_type == KVM_X86_TDX_VM)
+			r = 0;
+		else
+			r = 1;
+		break;
 	case KVM_CAP_VM_TYPES:
 		r = BIT(KVM_X86_DEFAULT_VM);
 		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
-- 
2.25.1

