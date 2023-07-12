Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B894E75108D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 20:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjGLScE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 14:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbjGLSb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 14:31:56 -0400
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05827DC;
        Wed, 12 Jul 2023 11:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1689186715; x=1720722715;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NUM+SsTWU9wvHoPzLXfvOsVyQM5ZYPYAOL7pyHpyzkM=;
  b=NqvxwxwUkq6h6SY59/00ZVcvTXfK0G6ZUHrVhoTaClKEWhWtmjO0hrNj
   eVX8lmFhSzzl0urPd+frxxxUxlQXiJiA1iz/85fE/eQaZwuidJ1pOp4w2
   HLWZZxcPTFbK2uTy6jV8ly7qnoYWo287Am+PGV5Y2dg6t3XEm8BKEM4VS
   c=;
X-IronPort-AV: E=Sophos;i="6.01,200,1684800000"; 
   d="scan'208";a="142361311"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 18:31:53 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-bbc6e425.us-east-1.amazon.com (Postfix) with ESMTPS id 423CB806BF;
        Wed, 12 Jul 2023 18:31:52 +0000 (UTC)
Received: from EX19D002ANA003.ant.amazon.com (10.37.240.141) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 12 Jul 2023 18:31:51 +0000
Received: from b0f1d8753182.ant.amazon.com (10.106.83.21) by
 EX19D002ANA003.ant.amazon.com (10.37.240.141) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 12 Jul 2023 18:31:47 +0000
From:   Takahiro Itazuri <itazur@amazon.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Takahiro Itazuri <zulinx86@gmail.com>,
        Takahiro Itazuri <itazur@amazon.com>
Subject: [PATCH] KVM: pass through CPUID 0x80000005
Date:   Wed, 12 Jul 2023 19:31:36 +0100
Message-ID: <20230712183136.85561-1-itazur@amazon.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.83.21]
X-ClientProxiedBy: EX19D033UWA002.ant.amazon.com (10.13.139.10) To
 EX19D002ANA003.ant.amazon.com (10.37.240.141)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass CPUID 0x80000005 (L1 cache and TLB info).

CPUID 0x80000006 (L2 cache and TLB and L3 cache info) has been returned
since commit 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)").
Enumerating both 0x80000005 and 0x80000006 with KVM_GET_SUPPORTED_CPUID
would be better than reporting either, and 0x80000005 could be helpful
for VMM to pass it to KVM_SET_CPUID{,2} for the same reason with
0x80000006..

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---

Discussion was made a bit on
https://lore.kernel.org/all/20230712170258.75355-1-itazur@amazon.com/.
If there is any reason that leaf 0x80000005 should not be enumerated or
dropping leaf 0x80000006 is preferred, please feel free to share your
thoughts.

---
 arch/x86/kvm/cpuid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a07b23..54a5b256c484 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1152,6 +1152,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
+	case 0x80000005:
+		/*  Pass host L1 cache and TLB info. */
+		break;
 	case 0x80000006:
 		/* Drop reserved bits, pass host L2 cache and TLB info. */
 		entry->edx &= ~GENMASK(17, 16);
-- 
2.38.0

