Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C306127C9
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiJ3GYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiJ3GYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDD0DE;
        Sat, 29 Oct 2022 23:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111044; x=1698647044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1K4yf7A4XzVtLVElMggRuvYNfU2q/PlhFY/Ez4kSMlc=;
  b=ggxUr75BvmJfou7PeGA5nR8RHFENjYai2Lo8fCCdG8Jg1Py+3IKzcR2o
   9QtatENnwj2cT3xGHmquVP1FFR+jZDpYZuTZaRC35RXkVNKZy1Rqjk6tk
   AsQVZxIGa37mXadDL3MZAd9sb1v41cTolI38PzsRcVBl40EGZSQtVp0yT
   HD+5uI0p40eSp0+1WauBUMFwim3qsXIFir/O0Shh0yAwpIJK7oVkkmUnZ
   5oue1Zlw8UtWwvfaJqtjllOXY18JPaoL2DMRNv+rv/8vFD8CGAyhxqZKA
   Japto/os3+BUG/xTiQd7s9inTveEr0ur/4+ZTF++O2rPNytBZGXvT+bIK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037132"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037132"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392891"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392891"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 020/108] KVM: Support KVM_CAP_MAX_VCPUS for KVM_ENABLE_CAP
Date:   Sat, 29 Oct 2022 23:22:21 -0700
Message-Id: <07daa8dbe1e3d6fec8db47a3ff3422a9bc460548.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX attestation includes the maximum number of vcpu that the guest can
accommodate.  For that, the maximum number of vcpu needs to be specified
instead of constant, KVM_MAX_VCPUS.  Make KVM_ENABLE_CAP support
KVM_CAP_MAX_VCPUS.

Suggested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b9c270f97c88..3b05a3396f89 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4967,6 +4967,27 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	case KVM_CAP_DIRTY_LOG_RING:
 	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+	case KVM_CAP_MAX_VCPUS: {
+		int r;
+
+		if (cap->flags || cap->args[0] == 0)
+			return -EINVAL;
+		if (cap->args[0] >  kvm_vm_ioctl_check_extension(kvm, KVM_CAP_MAX_VCPUS))
+			return -E2BIG;
+
+		mutex_lock(&kvm->lock);
+		/* Only decreasing is allowed. */
+		if (cap->args[0] > kvm->max_vcpus)
+			r = -E2BIG;
+		else if (kvm->created_vcpus)
+			r = -EBUSY;
+		else {
+			kvm->max_vcpus = cap->args[0];
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
+		return r;
+	}
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.25.1

