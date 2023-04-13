Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044BB6E13CF
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 19:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjDMR7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 13:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjDMR7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 13:59:11 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ACF8A5F;
        Thu, 13 Apr 2023 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681408750; x=1712944750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7NPGHZe7ksBAVtMO40tlkfmxNY/cTdX4an+XZxwARlU=;
  b=DzFFJusJYtIeSq9/CDD+Z7MfSrVKqdm5q7N753NLLe/0RwWAC/EUfwIA
   a6MkgQWCk9y+sOmUA7m2VCus53vuhomP2BE06kPtXZ78jRy6oxr9bKk6C
   kgRZrvGueFtwX2XbBzjFmhJLuIT6D/WHoy90Abq3tKE/gdtVCNmA5fXbb
   U=;
X-IronPort-AV: E=Sophos;i="5.99,194,1677542400"; 
   d="scan'208";a="1122409867"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 17:59:01 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-cadc3fbd.us-west-2.amazon.com (Postfix) with ESMTPS id 77999A0F1C;
        Thu, 13 Apr 2023 17:59:01 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 13 Apr 2023 17:59:01 +0000
Received: from b0f1d8753182.ant.amazon.com (10.95.156.18) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 13 Apr 2023 17:58:57 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH v2] KVM: x86: Update KVM_GET_CPUID2 to return valid entry count
Date:   Thu, 13 Apr 2023 18:58:44 +0100
Message-ID: <20230413175844.21760-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.95.156.18]
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the KVM_GET_CPUID2 API to return the number of valid entries in
nent field of kvm_cpuid2 even on success.

Previously, the KVM_GET_CPUID2 API only updated the nent field when an
error was returned. If the API was called with an entry count larger
than necessary (e.g., KVM_MAX_CPUID_ENTRIES), it would succeed, but the
nent field would continue to show a value larger than the actual number
of entries filled by the KVM_GET_CPUID2 API. With this change, users can
rely on the updated nent field and there is no need to traverse
unnecessary entries and check whether an entry is valid or not.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
Changes
v1 -> v2
* Capitalize "kvm" in the commit title.
* Remove a scratch "nent" variable.
* Link to v1: https://lore.kernel.org/all/20230410141820.57328-1-itazur@amazon.com/

 arch/x86/kvm/cpuid.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 599aebec2d52..20d28ebdc672 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -523,18 +523,18 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries)
 {
-	int r;
+	int r = 0;
 
-	r = -E2BIG;
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
-		goto out;
-	r = -EFAULT;
-	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
+		r = -E2BIG;
+	else if (copy_to_user(entries, vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
-		goto out;
-	return 0;
+		r = -EFAULT;
 
-out:
+	/*
+	 * Update "nent" even on failure, e.g. so that userspace can fix an
+	 * -E2BIG issue by allocating a larger array.
+	 */
 	cpuid->nent = vcpu->arch.cpuid_nent;
 	return r;
 }
-- 
2.39.2

