Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24B7B206A
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjI1PFn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjI1PFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:05:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD751A8
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695913489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zSW4L47PrK+7DJbUcadmA8oL8chw/9RJFYn/fvmJlQ=;
        b=Y35kKURBpMmvCUw+8sti1NrL94VIZ79XRgwzwhNLXrc9pwinAILrgzldGX51A20nqS6CwU
        iC3EdPVBWxfYvQSGQfkZ7iEiTCqIug57OjcPDJXByZkZ9VWc7nGkurV9LU0idNcnXIdCjw
        is9Rpvm+Dup8nme8Q4l93bT4yQv3V8s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-UUxYy2WWNlqjcdm6QvOhzQ-1; Thu, 28 Sep 2023 11:04:42 -0400
X-MC-Unique: UUxYy2WWNlqjcdm6QvOhzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 187D438145AB;
        Thu, 28 Sep 2023 15:04:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1A0540C6E76;
        Thu, 28 Sep 2023 15:04:36 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/5] x86: KVM: SVM: add support for Invalid IPI Vector interception
Date:   Thu, 28 Sep 2023 18:04:25 +0300
Message-Id: <20230928150428.199929-3-mlevitsk@redhat.com>
In-Reply-To: <20230928150428.199929-1-mlevitsk@redhat.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In later revisions of AMD's APM, there is a new 'incomplete IPI' exit code:

"Invalid IPI Vector - The vector for the specified IPI was set to an
illegal value (VEC < 16)"

Note that tests on Zen2 machine show that this VM exit doesn't happen and
instead AVIC just does nothing.

Add support for this exit code by doing nothing, instead of filling
the kernel log with errors.

Also replace an unthrottled 'pr_err()' if another unknown incomplete
IPI exit happens with WARN_ON_ONCE()

(e.g in case AMD adds yet another 'Invalid IPI' exit reason)

Cc: <stable@vger.kernel.org>

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/avic.c    | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 19bf955b67e0da0..3ac0ffc4f3e202b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
 	AVIC_IPI_FAILURE_INVALID_TARGET,
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
+	AVIC_IPI_FAILURE_INVALID_IPI_VECTOR,
 };
 
 #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2092db892d7d052..c44b65af494e3ff 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -529,8 +529,11 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
 		WARN_ONCE(1, "Invalid backing page\n");
 		break;
+	case AVIC_IPI_FAILURE_INVALID_IPI_VECTOR:
+		/* Invalid IPI with vector < 16 */
+		break;
 	default:
-		pr_err("Unknown IPI interception\n");
+		WARN_ONCE(1, "Unknown avic incomplete IPI interception\n");
 	}
 
 	return 1;
-- 
2.26.3

