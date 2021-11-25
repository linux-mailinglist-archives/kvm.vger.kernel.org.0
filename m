Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466A245D2CA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353445AbhKYCFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344083AbhKYCDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEE4C0619E7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:52 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a16-20020a17090aa51000b001a78699acceso3866305pjq.8
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8cJOSbBoh2lg97dakR1lsw9AruuqF4eSBfdHXy0uAQY=;
        b=cRTEo4Hu71tnXiTy41zKan1mANPkYzYaS8fLIUdOqBLamvmxiXJQv5IFK0oqTW/t2k
         3rKjrFUWdtLZ0WXnbZiBUb2QSAyEAQr7db/7BHgPAVZv4g/U5sUb0zBpO94nKJFcb8S7
         HmYI4FGa92rpmDG+vPG5M6003HqD4TOLffLHD8Qk79z/fT0ID0d/ZEByoVLjKS0Asjht
         Hsyz6g5Mf0QRKQL8pdmr2HQJPWm4GiVBlaB+GJt994Iif5GjdordCGJst6NYPbviQCes
         QBhYAmsGgIgwR+gL0Dwt+GL3YoZbwdzhh6GMIcWHAY/NO6958k166IkCPiNyCPMf3Zi+
         cWgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8cJOSbBoh2lg97dakR1lsw9AruuqF4eSBfdHXy0uAQY=;
        b=0Lxwf9Rb5pXM9ofzI4O+KPf/nzRAOWERbccWWyZLfm1/wwJZqn2pgJtds5E3C94DL7
         850jiHdyAwuin9Zgs6NTQ6BRrKI+GOhq3o53jiQNl+ydILQ2hh3FMr9b6+cufnE3wivq
         u+xsK1CaG8ax99wuMwa5o0QGwWPGGYFEwxAk1XtTVL7UyY6wxeN6Tw2TR+3HoLQR3RbD
         F9xSdopwdzehs+NEyJq3guVqdNkQxoz7fBWbm5fOQG6rXA/+mDMcSQGsTJ+fKt8QDFBN
         QRp1JSW3AQ3q59oSr4THLgLYlMt5yMSt97JmWt74BMyIFBtbY//VL3ER0gQBFFsBbr4g
         Ie3A==
X-Gm-Message-State: AOAM532i0JeHwTnwxZ3swz+gfqzSsquA9+djMaGjJIYeeqZa7rPT9B77
        s53fzAwWXs00DMXpnvtTMVXquOpyD8Y=
X-Google-Smtp-Source: ABdhPJzqw8AAfIH44prN8KtbtFyOQYoOsrrMuxy789cgF7LpaDuZRFehOFf5Pd3fXxiiAejob0+AdmCRkow=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a47:: with SMTP id
 lb7mr2161534pjb.243.1637803792106; Wed, 24 Nov 2021 17:29:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:50 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-33-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 32/39] nVMX: Use helper to check for EPT A/D support
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the existing helper to check for EPT A/D support instead of rereading
the capabilities MSR and open-coding the check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f2e24f6..116ae66 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1485,7 +1485,7 @@ static int eptad_init(struct vmcs *vmcs)
 	if (r == VMX_TEST_EXIT)
 		return r;
 
-	if ((rdmsr(MSR_IA32_VMX_EPT_VPID_CAP) & EPT_CAP_AD_FLAG) == 0) {
+	if (!ept_ad_bits_supported()) {
 		printf("\tEPT A/D bits are not supported");
 		return VMX_TEST_EXIT;
 	}
@@ -4805,7 +4805,7 @@ static void test_ept_eptp(void)
 	/*
 	 * Accessed and dirty flag (bit 6)
 	 */
-	if (msr & EPT_CAP_AD_FLAG) {
+	if (ept_ad_bits_supported()) {
 		report_info("Processor supports accessed and dirty flag");
 		eptp &= ~EPTP_AD_FLAG;
 		test_eptp_ad_bit(eptp, true);
-- 
2.34.0.rc2.393.gf8c9666880-goog

