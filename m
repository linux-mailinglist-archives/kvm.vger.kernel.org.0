Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E399E6DC7C1
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDJOSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 10:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDJOSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 10:18:45 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753E5213C;
        Mon, 10 Apr 2023 07:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1681136324; x=1712672324;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i+S/sDMXP9J94sRN9gjxGcSuFRzKplRBtZn53LQ1X8o=;
  b=L5q0K+YmTkCVAcIVOtlFdmrdi6Gf+cgVragl0cP7eIihGjuVuf2mvaYp
   Tv87h0EUPUlFZC+bFa+3T5kImYNcmUFbryLpux6M3929j28spHe7u1TIb
   lBXFW/A/tffo7gnRJ0wEe1jFkfR+PKpIVZ5n3iOCtcuncdtJNMGrghAO6
   Q=;
X-IronPort-AV: E=Sophos;i="5.98,333,1673913600"; 
   d="scan'208";a="312348347"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 14:18:41 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-d47337e0.us-west-2.amazon.com (Postfix) with ESMTPS id 0EA6060A8C;
        Mon, 10 Apr 2023 14:18:39 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 10 Apr 2023 14:18:39 +0000
Received: from b0f1d8753182.ant.amazon.com.com (10.106.82.21) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 10 Apr 2023 14:18:35 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH] kvm: x86: Update KVM_GET_CPUID2 to return valid entry count
Date:   Mon, 10 Apr 2023 15:18:20 +0100
Message-ID: <20230410141820.57328-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.82.21]
X-ClientProxiedBy: EX19D041UWA002.ant.amazon.com (10.13.139.121) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modify the KVM_GET_CPUID2 API to return the number of valid entries in
nent field of kvm_cpuid2, even when the API is successful.

Previously, the KVM_GET_CPUID2 API only updated the nent field when an
error was returned. If the API was called with an entry count larger
than necessary (e.g., KVM_MAX_CPUID_ENTRIES), it would succeed, but the
nent field would continue to show a value larger than the actual number
of entries filled by the KVM_GET_CPUID2 API. With this change, users can
rely on the updated nent field and there is no need to traverse
unnecessary entries and check whether an entry is valid or not.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 599aebec2d52..31838dfddda6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -523,10 +523,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries)
 {
-	int r;
+	int nent, r;
+
+	nent = cpuid->nent;
+	cpuid->nent = vcpu->arch.cpuid_nent;
 
 	r = -E2BIG;
-	if (cpuid->nent < vcpu->arch.cpuid_nent)
+	if (nent < vcpu->arch.cpuid_nent)
 		goto out;
 	r = -EFAULT;
 	if (copy_to_user(entries, vcpu->arch.cpuid_entries,
@@ -535,7 +538,6 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return 0;
 
 out:
-	cpuid->nent = vcpu->arch.cpuid_nent;
 	return r;
 }
 
-- 
2.39.2

