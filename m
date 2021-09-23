Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B564165CB
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 21:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbhIWTRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 15:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242823AbhIWTRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 15:17:50 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0572DC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:19 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id j7-20020a0566022cc700b005d65f61a95fso427926iow.9
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 12:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wuhjwc3cWbjk5tU/NeZeTgW/a/HXaQKuoN5QMNZMGeo=;
        b=NW8v62EkiXXa/7jVpmzPJkblutKY6sFQQtlrPHUh/urfKOecQh+LY5D8kM6u7PPiWK
         0oly2o5b/4LbqN+NIplDvevj7Cn/th27ZuwZgEi10MtixmOenyMM05kj0nrSpUes04bw
         PO7kEWOWJCJZri+aNKHQk6SxmvMsNxOcvAgqk+00DbZfsyzbeEIf/7YXhOTlO8kTeuiZ
         pq15LOw3gPdO6YKDTMwsdTYROADLZhHQBhYN7It3etPcpx1ASAmzXpG+1q2IN4u2fpR+
         /MmDb4XK28dvfXRL+evkK+1tr6W+pyL+tfA8StOQQbxdOUwOZ2Y6u924RyVvgx1KXmHK
         Bq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wuhjwc3cWbjk5tU/NeZeTgW/a/HXaQKuoN5QMNZMGeo=;
        b=OLi7jhfi/R9B7SsQNBNdmaQnRT6Ak7OUajsbATK5ivDwK9PfRssjnjTPtD5nQgGlVK
         GniGksH0IV/mBpkcXdC9KU9w+2mJcfrf/2o/TauQVxikQFvCHa+Jm2EQJ/h6o4/cg24A
         hHRsv9qogiuC4dF/4Pmvo6cWOpwqLVDxn5YPCCr9FZ1BbNk0ntqT3PThz2w6zM+zOUPp
         IV3uk45RakJvvJ7aV3mQ4uM21Eisvj04cJjCSSISQyThFPDJJjDBKXrWKT3bDLnvEwdm
         rvi5EVvlTYL8wYU10iSayUsXpIP7nLvqt2UG+iE/vL605W48pTuSgmeADhj2Ffi+6g6o
         3mKw==
X-Gm-Message-State: AOAM532g+vKo3ffx1jpT4lCkOF5YunPlra8PjWExDd5/N4qsFCgJbXav
        c0rp9MPSA+0PPX6RKQ61sa6/LOdqfcs=
X-Google-Smtp-Source: ABdhPJzwGEX23UIo4CYuNKmMK206kckBCE8dVTHHtaVtRij6igKpJLs0Yao5aVSEMfyGpu3eSFezGo0/Qb0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:7710:: with SMTP id n16mr5290999iom.101.1632424578398;
 Thu, 23 Sep 2021 12:16:18 -0700 (PDT)
Date:   Thu, 23 Sep 2021 19:16:01 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-3-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 02/11] KVM: arm64: Clean up SMC64 PSCI filtering for
 AArch32 guests
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d46842f45b0a..310b9cb2b32b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.33.0.685.g46640cef36-goog

