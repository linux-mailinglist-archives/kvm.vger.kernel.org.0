Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD645D2CF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347838AbhKYCFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353464AbhKYCDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:02 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259FBC0619ED
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:02 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id mn13-20020a17090b188d00b001a64f277c1eso3884603pjb.2
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hNIMol95TlBJFRh2G21KJT1228y59kbdDegrV8nCH8w=;
        b=eUOU0gcnhgMS9S0jytJVjeJLwXALsKN3z45InbabzFJh1+rn0VXaRVKf9AkUZxBlKW
         rmjBi0mmK503oFyH1UDbUX+ElSy0yIrstE2kdVohlg7Q+DFPWW/QRHapWrzXcGrn3wp8
         mSwkNIUTCOTVVmJDIQygkuD6D3S8nUQgr0ahXbnJEGxN52jAHNrArGSvGlJbuuvTJgYh
         bLbx9Q38kX0nB662zDjQ8UDZdBYL2h0e7DXwblWxuHNiPdZ3V2Po6bQeK4ixDjim//Fe
         czD/1eOfVa+69cxe2MopxvXLcdOguSbyyhgYnk5SFAFu0XI3TOr6aNBZkZT6zdN/bxGo
         b7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hNIMol95TlBJFRh2G21KJT1228y59kbdDegrV8nCH8w=;
        b=4Q819Z77RW8gXJoEKzPdKzg/JF7F/DxZ9NIuzCtnN6GwF7SI5w1iBqjDOK3fdROJ01
         yRAIOvpWD7XnRDRMqHHnThfAm8fh9RjMR1lVoYXter7oRSIIMyGY6xlcfxEUs3zOJ6Tw
         i76U4a3ZCymQsJlv/LnEtASe3etjciXqTCVxLTszr8cb+eU1MshP9nHmY5mjNpYnemQ6
         FqMFOQRohPrV/iAVQWUYpZfnX4wEtleiAvBua3IAxooSxTeFB1wwDGoNr9nE2U0xMYzw
         1PtEzfjKm/3SUp1XDR9qaXyrjSr8fW1hocxJxMcAFkX6tE9DtnRvCOA7RQhFVartzO33
         aMKA==
X-Gm-Message-State: AOAM5327YbkdObawPRR2BMNWjx+aChPDKZF7mNFn1WiJpcFiz4LNO1Cc
        0Ayc+gGeS65iecdzOgr9jwpTW+qay2g=
X-Google-Smtp-Source: ABdhPJxlO11QD16RFdkfgfwbTiX0J0rRPe6VF7uqEPW4zm8pMOW19BvRfjXsKIFiznOV4OGWtbUxPDtQ3IY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:db01:b0:141:ea12:2176 with SMTP id
 m1-20020a170902db0100b00141ea122176mr25416019plx.44.1637803801694; Wed, 24
 Nov 2021 17:30:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:56 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-39-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 38/39] nVMX: Add helper to check if VPID is supported
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to check for VPID support to deduplicate code, now and in
the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.h       | 6 ++++++
 x86/vmx_tests.c | 6 ++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/x86/vmx.h b/x86/vmx.h
index 401715c..4423986 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -844,6 +844,12 @@ static inline bool is_invept_type_supported(u64 type)
 	return ept_vpid.val & (EPT_CAP_INVEPT_SINGLE << (type - INVEPT_SINGLE));
 }
 
+static inline bool is_vpid_supported(void)
+{
+	return (ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
+	       (ctrl_cpu_rev[1].clr & CPU_VPID);
+}
+
 static inline bool is_invvpid_supported(void)
 {
 	return ept_vpid.val & VPID_CAP_INVVPID;
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 316105b..172d385 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3304,8 +3304,7 @@ static void invvpid_test(void)
 	unsigned types = 0;
 	unsigned type;
 
-	if (!(ctrl_cpu_rev[0].clr & CPU_SECONDARY) ||
-	    !(ctrl_cpu_rev[1].clr & CPU_VPID))
+	if (!is_vpid_supported())
 		test_skip("VPID not supported");
 
 	if (!is_invvpid_supported())
@@ -4099,8 +4098,7 @@ static void test_vpid(void)
 	u16 vpid = 0x0000;
 	int i;
 
-	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
-	    (ctrl_cpu_rev[1].clr & CPU_VPID))) {
+	if (!is_vpid_supported()) {
 		printf("Secondary controls and/or VPID not supported\n");
 		return;
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog

