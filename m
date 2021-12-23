Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5E47E980
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350715AbhLWW1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350680AbhLWWZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:49 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845EDC061D7E
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:29 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y7-20020a62ce07000000b004bb3ae114a1so4019014pfg.5
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Yr+H8LBjl0djQfSMzX2wORKjmAdREQqaSzyX3BhenYw=;
        b=XmQFD7vyhq5p8trN7cLD10q9mdheW4EOLvr7SHz8EpgoyH6oda/tiRX7ZBVlJwAHwm
         pxx0c47eP51bpRUXyCWELedYY8s3KrRuvX/xhBiZqPIDn05GKwYbUTdvZxtQSRJNcxLN
         kK77GUtf7L3Chh6OYUxSTJBxhHHfyiumxfeqDNePqdI5C0bFRb7f15c2McJzFQ0Fp95K
         3JKbIWhgctO43HlTl2C0ZLUvmH5HJoTdyLkO9imR/gh6Mryu33xmQGLIzCenALuJ2lta
         kskFun16QDJJZ4g8xCW7JLFuo7WuGx2WS5vm87C3T5Hf5RgmmCuvx702nSwCrdp5oCix
         P32g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Yr+H8LBjl0djQfSMzX2wORKjmAdREQqaSzyX3BhenYw=;
        b=wtFKJ5PAQnsGhu0XKpeDL78qnzkNpkImv72ExLwP6HjBWfnnq7aK8fCFtLJ+bPeT0U
         1VKvNOsHplUygYa9IHP37nU9QZIssLSDZmlbJ+rxAEeYhGSYvl0ZFjnuD+8a2w1JHqe6
         tIVLAXvLf2unKnXZcnIMiu90DhOh0GYCumugrFc71AGd7S0VFoZIGMBgtSbgNMvsJNmp
         rX/HeQ90HYNL3ZMlC5PnJ3kRUTxcHY7oAqMOXQDQAwxKiPgZEVnI/EWGVNq299nAisJw
         SmTIU7FmUJKI4OQfkkvYh9olcoNAGnEsCAkSuRm/4F4TJU6Ux945jxwj4WrbxI9KrFPv
         1wNw==
X-Gm-Message-State: AOAM532xC62qr7cg/Z1hy0cnlWaX6DR4L0u94mPLwi96AgvsTV0y130Z
        4fqtiBejAxcvxYkr8Mp5r7ILNg2RzWU=
X-Google-Smtp-Source: ABdhPJwUiLkdbtaG9+zrvhGoVsZmSI+nH0Nx0az82/C5LbcyzQYJaBgH11x2pnQDooEF32SEPCtIuz686jQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a81:: with SMTP id
 lp1mr4969813pjb.19.1640298269028; Thu, 23 Dec 2021 14:24:29 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:17 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-30-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 29/30] KVM: selftests: Define cpu_relax() helpers for s390
 and x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add cpu_relax() for s390 and x86 for use in arch-agnostic tests.  arm64
already defines its own version.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/s390x/processor.h  | 8 ++++++++
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
index e0e96a5f608c..255c9b990f4c 100644
--- a/tools/testing/selftests/kvm/include/s390x/processor.h
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -5,6 +5,8 @@
 #ifndef SELFTEST_KVM_PROCESSOR_H
 #define SELFTEST_KVM_PROCESSOR_H
 
+#include <linux/compiler.h>
+
 /* Bits in the region/segment table entry */
 #define REGION_ENTRY_ORIGIN	~0xfffUL /* region/segment table origin	   */
 #define REGION_ENTRY_PROTECT	0x200	 /* region protection bit	   */
@@ -19,4 +21,10 @@
 #define PAGE_PROTECT	0x200		/* HW read-only bit  */
 #define PAGE_NOEXEC	0x100		/* HW no-execute bit */
 
+/* Is there a portable way to do this? */
+static inline void cpu_relax(void)
+{
+	barrier();
+}
+
 #endif
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 05e65ca1c30c..224574ee9967 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -346,6 +346,11 @@ static inline unsigned long get_xmm(int n)
 	return 0;
 }
 
+static inline void cpu_relax(void)
+{
+	asm volatile("rep; nop" ::: "memory");
+}
+
 bool is_intel_cpu(void);
 
 struct kvm_x86_state;
-- 
2.34.1.448.ga2b2bfdf31-goog

