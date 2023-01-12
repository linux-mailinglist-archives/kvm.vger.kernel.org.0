Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6DE5667B50
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240652AbjALQlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239713AbjALQhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0008C15FC3;
        Thu, 12 Jan 2023 08:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541234; x=1705077234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dqYEULkH/OZWopqWd2YjxrOh4qpDuxImjqn9TYIIMZY=;
  b=cQf8xKSdZBBDBQqZiDYXjiku8AIGjW/wqnZicg44Gx5V9D38zXuJFnCy
   03cAjI6c9cnV/gUB1mzs1nWEIvw1XoOe8DPXP8iKN+LEJwWG/Ws8fDhfA
   z43u0pxrTmnunYJB5WfqKU+l2DtLu9wFxQz8SqZh2YWiYJMFLY+jNzNg+
   aPXcINNjefjfpLb7pPPz1Nbg3DN6cQqqPMTo0UI4jjpaT5iqMBXn+TiN4
   ItigkvQkqsa8O2L4w4i27sjAZouQzy9kKGec8kQQatPmYXxYYzqmwo+DX
   Um6VAOTGgJRmh1hBj/yQFoQycotMuNW+VSa6pigUS/QSGYHTGWUpIusS+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811724"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811724"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151680"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151680"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:22 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for KVM_ENABLE_CAP
Date:   Thu, 12 Jan 2023 08:31:25 -0800
Message-Id: <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 virt/kvm/kvm_main.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a235b628b32f..1cfa7da92ad0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4945,7 +4945,27 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 		}
 
 		mutex_unlock(&kvm->slots_lock);
+		return r;
+	}
+	case KVM_CAP_MAX_VCPUS: {
+		int r;
 
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
 		return r;
 	}
 	default:
-- 
2.25.1

