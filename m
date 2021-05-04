Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F2F372732
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 10:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEDI1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 04:27:40 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:21893 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhEDI1j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 04:27:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1620116805; x=1651652805;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=31dOGfcg2GObswIUd+iAQCyOWXV3Asmut6GnIm4jpIg=;
  b=O1UXWtmUAQWlo8bueA+5YyzToydGDmoenp0mpVcoHs0RM8eiAT8HVJQU
   z1w9U08H6YdnSlwfRCHsxWrCNUHHbipUEjcR4nQgyELi8jqgZ61qLO0Dr
   uweln/w4LEPSmUBwbu/ivrmpp/KUw/tzlpiu7uZdmWx043e8mb1uM0JQp
   0=;
X-IronPort-AV: E=Sophos;i="5.82,271,1613433600"; 
   d="scan'208";a="132862651"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 04 May 2021 08:26:27 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 34731A1CDB;
        Tue,  4 May 2021 08:26:26 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.85) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 4 May 2021 08:26:20 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: Hoist input checks in kvm_add_msr_filter()
Date:   Tue, 4 May 2021 10:25:59 +0200
Message-ID: <20210504082600.3668-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D35UWB001.ant.amazon.com (10.43.161.47) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In ioctl KVM_X86_SET_MSR_FILTER, input from user space is validated
after a memdup_user(). For invalid inputs we'd memdup and then call
kfree unnecessarily. Hoist input validation to avoid kfree altogether.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/x86.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee0dc58ac3a5..c4fc0c46927a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5390,14 +5390,18 @@ static void kvm_free_msr_filter(struct kvm_x86_msr_filter *msr_filter)
 static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 			      struct kvm_msr_filter_range *user_range)
 {
-	struct msr_bitmap_range range;
 	unsigned long *bitmap = NULL;
 	size_t bitmap_size;
-	int r;
 
 	if (!user_range->nmsrs)
 		return 0;
 
+	if (user_range->flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE))
+		return -EINVAL;
+
+	if (!user_range->flags)
+		return -EINVAL;
+
 	bitmap_size = BITS_TO_LONGS(user_range->nmsrs) * sizeof(long);
 	if (!bitmap_size || bitmap_size > KVM_MSR_FILTER_MAX_BITMAP_SIZE)
 		return -EINVAL;
@@ -5406,31 +5410,15 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	if (IS_ERR(bitmap))
 		return PTR_ERR(bitmap);
 
-	range = (struct msr_bitmap_range) {
+	msr_filter->ranges[msr_filter->count] = (struct msr_bitmap_range) {
 		.flags = user_range->flags,
 		.base = user_range->base,
 		.nmsrs = user_range->nmsrs,
 		.bitmap = bitmap,
 	};
-
-	if (range.flags & ~(KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE)) {
-		r = -EINVAL;
-		goto err;
-	}
-
-	if (!range.flags) {
-		r = -EINVAL;
-		goto err;
-	}
-
-	/* Everything ok, add this range identifier. */
-	msr_filter->ranges[msr_filter->count] = range;
 	msr_filter->count++;
 
 	return 0;
-err:
-	kfree(bitmap);
-	return r;
 }
 
 static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



