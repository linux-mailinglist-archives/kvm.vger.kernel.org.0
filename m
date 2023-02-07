Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3499268CB08
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 01:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjBGAWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 19:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjBGAWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 19:22:04 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7959D32510
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 16:22:02 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u18-20020a62ed12000000b00593cc641da4so7140339pfh.0
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 16:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I+Z+wnDCARltqljoL3uU/iOxjVMjPeIS4mK0SvgvmXM=;
        b=E+x/tX7HzgELHcR+Ij6x7Y0MW/bHTaFLnLIVqRX3JDz8e8Tvpq5w7lT+zejYXOjKcm
         147j5MdceO1IYTLoomosRta3aOcWTzHdvvjyBYnXrX7C6rAQW7rNYFm78r9QSo3bt/Xt
         dA4RKuHph/QH7FmEfBbPnxJslYmLR+Wb1gLR4n8A7sYsnr88bxF6pumaDYSAXWQPrvLB
         krCdEp6vYemo605TU9sVcoJgE65NsIgGaYhamjmFukKJZCeiphVfdXJ9FMq7r/+j2Bju
         Js5/j0LA4vFOq1K36AfQvjeZNWvmodCjPYkpEiSsI+7M4gvjrqNWBv0lqedseD5pMUtn
         5SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+Z+wnDCARltqljoL3uU/iOxjVMjPeIS4mK0SvgvmXM=;
        b=ET+6MOp/OL4IF86o/zm77cSdaOeMS4e0+dtFmIcJaQzyf/82Azb45Cbv9BtSBudQRW
         4P4RI4qZ6dxJmFrR2p3dyycOxXadogcnQ8GMLjWdJCoyno/jdCJVeguoPCcSOcX9Lz1e
         oTtE3/mrcv8Fae5Nnjy1X5mGkOOrams20AWWzwjqsma9qX7WUPLWuFbD4Ln74xGrHPub
         /6wuN5T+wGFMPgrGs3/gQXT8QbNKRKOUDxFZB1wzCMHjopcO2X2zb6nm+6EIuabq/h8J
         OzGpXn8wqkxsxPE9O0UNisE5N0/HJrN4zwiUQwpFzn/6XT2pyTcoyAxSYnD6hSbecBr4
         cUkQ==
X-Gm-Message-State: AO0yUKUZPFcEs2sWi3ZlAad7iyKFWwVhiKunvbjgcGPtFRJBz2yb64YO
        XXeVr41DDzQ41zMu5cPjTz6tJ2CwuCo=
X-Google-Smtp-Source: AK7set8SfQBsfaz/UvElBol4nLp55vhh2sP6i/9kvIyliVJ6c9yEtjjeOBDxe83WkEEHSP+zX2xYU1BSyo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54b:b0:192:c7f1:977b with SMTP id
 h11-20020a170902f54b00b00192c7f1977bmr219867plf.1.1675729321872; Mon, 06 Feb
 2023 16:22:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  7 Feb 2023 00:21:55 +0000
In-Reply-To: <20230207002156.521736-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230207002156.521736-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207002156.521736-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: SVM: Modify AVIC GATag to support max number of
 512 vCPUs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
that effectively controls the largest guest physical APIC ID supported by
x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
VM bits to 24).

The AVIC GATag is programmed into the AMD IOMMU IRTE to provide a
reference back to KVM in case the IOMMU cannot inject an interrupt into a
non-running vCPU.  In such a case, the IOMMU notifies software by creating
a GALog entry with the corresponded GATag, and KVM then uses the GATag to
find the correct VM+vCPU to kick.  Dropping bit 8 from the GATag results
in kicking the wrong vCPU when targeting vCPUs with x2APIC ID > 255.

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Cc: stable@vger.kernel.org
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ca684979e90d..326341a22153 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,19 +27,29 @@
 #include "irq.h"
 #include "svm.h"
 
-/* AVIC GATAG is encoded using VM and VCPU IDs */
-#define AVIC_VCPU_ID_BITS		8
-#define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
+/*
+ * Encode the arbitrary VM ID and the vCPU's default APIC ID, i.e the vCPU ID,
+ * into the GATag so that KVM can retrieve the correct vCPU from a GALog entry
+ * if an interrupt can't be delivered, e.g. because the vCPU isn't running.
+ *
+ * For the vCPU ID, use however many bits are currently allowed for the max
+ * guest physical APIC ID (limited by the size of the physical ID table), and
+ * use whatever bits remain to assign arbitrary AVIC IDs to VMs.  Note, the
+ * size of the GATag is defined by hardware (32 bits), but is an opaque value
+ * as far as hardware is concerned.
+ */
+#define AVIC_VCPU_ID_MASK		AVIC_PHYSICAL_MAX_INDEX_MASK
 
-#define AVIC_VM_ID_BITS			24
-#define AVIC_VM_ID_NR			(1 << AVIC_VM_ID_BITS)
-#define AVIC_VM_ID_MASK			((1 << AVIC_VM_ID_BITS) - 1)
+#define AVIC_VM_ID_SHIFT		HWEIGHT32(AVIC_PHYSICAL_MAX_INDEX_MASK)
+#define AVIC_VM_ID_MASK			(GENMASK(31, AVIC_VM_ID_SHIFT) >> AVIC_VM_ID_SHIFT)
 
-#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VCPU_ID_BITS) | \
+#define AVIC_GATAG(x, y)		(((x & AVIC_VM_ID_MASK) << AVIC_VM_ID_SHIFT) | \
 						(y & AVIC_VCPU_ID_MASK))
-#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VCPU_ID_BITS) & AVIC_VM_ID_MASK)
+#define AVIC_GATAG_TO_VMID(x)		((x >> AVIC_VM_ID_SHIFT) & AVIC_VM_ID_MASK)
 #define AVIC_GATAG_TO_VCPUID(x)		(x & AVIC_VCPU_ID_MASK)
 
+static_assert(AVIC_GATAG(AVIC_VM_ID_MASK, AVIC_VCPU_ID_MASK) == -1u);
+
 static bool force_avic;
 module_param_unsafe(force_avic, bool, 0444);
 
-- 
2.39.1.519.gcb327c4b5f-goog

