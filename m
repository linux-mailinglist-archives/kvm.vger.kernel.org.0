Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505917083C1
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 16:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjEROOq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 10:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjEROOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 10:14:44 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D14DC;
        Thu, 18 May 2023 07:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684419284; x=1715955284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/EG3kAoZFFoNmCZxjC6esPJxCN2aXyXfUCBCGN6t9H4=;
  b=qBiCGTIDiOH5mAN/A1EqCjfnfQD5UEeF0WyP4RV2uHoX7qGpZGzf4duW
   0yMhRbzAAmSmp0GRH0HovwkRb4cGIvtAWSK1ecn4nUm3nRjEGrVqc1lmx
   Iw66bOVbWhiyFSGmzdzwIYgfu4WonYLO+qTOg2SJoGC/eOad/DGddivU2
   s=;
X-IronPort-AV: E=Sophos;i="5.99,285,1677542400"; 
   d="scan'208";a="214654107"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 14:14:41 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-b404fda3.us-east-1.amazon.com (Postfix) with ESMTPS id 1BC99822CA;
        Thu, 18 May 2023 14:14:39 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 18 May 2023 14:14:38 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.82.23) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 18 May 2023 14:14:35 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [RESEND PATCH v2] KVM: x86: Update KVM_GET_CPUID2 to return valid entry count
Date:   Thu, 18 May 2023 15:14:20 +0100
Message-ID: <20230518141420.37404-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.82.23]
X-ClientProxiedBy: EX19D035UWB003.ant.amazon.com (10.13.138.85) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
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

