Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E400B37152E
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhECMWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:22:40 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:29375 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhECMWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 08:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1620044506; x=1651580506;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=at0cHJEgodCI3tI7LMoEAMYJODv2kVfd48UoqDPk8F8=;
  b=m2dUjPKc8zrBDVaBR5Mx8HWKvyuGjgmILwJ+oahhcKE9eIbKG2anQkYj
   0J3TGCqOL291i1vbQNPuM1S8TYHW6GBQ8aHczIwrWMTqQrJ8x6i7f19QO
   dSO4crE2FdE+rRfH8C3WfRYNqTgo8WKiLlJ3i4WLnF/MiuUTvg616XH8l
   k=;
X-IronPort-AV: E=Sophos;i="5.82,270,1613433600"; 
   d="scan'208";a="132584766"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 03 May 2021 12:21:39 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 70C30A216C;
        Mon,  3 May 2021 12:21:35 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.224) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 3 May 2021 12:21:29 +0000
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
Subject: [PATCH] KVM: x86: Hoist input checks in kvm_add_msr_filter()
Date:   Mon, 3 May 2021 14:21:11 +0200
Message-ID: <20210503122111.13775-1-sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.224]
X-ClientProxiedBy: EX13D21UWB004.ant.amazon.com (10.43.161.221) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In ioctl KVM_X86_SET_MSR_FILTER, input from user space is validated
after a memdup_user(). For invalid inputs we'd memdup and then call
kfree unnecessarily. Hoist input validation to avoid kfree altogether.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 arch/x86/kvm/x86.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ee0dc58ac3a5..15c20b31cc91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5393,11 +5393,16 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	struct msr_bitmap_range range;
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
@@ -5413,24 +5418,10 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 		.bitmap = bitmap,
 	};
 
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
 	msr_filter->ranges[msr_filter->count] = range;
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



