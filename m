Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CF845D2D0
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhKYCFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353468AbhKYCDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:03:02 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0184FC0619EB
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:59 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id l10-20020a17090a4d4a00b001a6f817f57eso2319655pjh.3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=0LXi40ksP3m0kj2LAQOAXFSfiuiawB7JL/OtE1wsjJA=;
        b=spcu0djBqfPfjMBQo2CifdNAM1Wys0P6x/7/PV0jEqtZr831PJL4Tv+E5La3XMFpcu
         Wd01MA1sol3ajvD+k78oHRDWgoKqObZpYDOWDe9RfSwCiY4OfCtCoMxWjkqC9VyFII9a
         45SEwaanYnV8W3C6o0MO9oQGA3V04UrPD/3atepyqorrBzKESCjYh/n0++9Xfh6P3iHV
         WXuUbpFPf+qrgEn1usPHHjM+Ky+EVNmRja6qtfp1UGDyhpnrkGq9Ao+ITN1QXcOC2RvM
         4Jgmf8ioIh3tB4gkLMHXjISdLfusr42oUIGk5rkG670ubpdsB4aau9WQib5wLxORRvRC
         SUDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=0LXi40ksP3m0kj2LAQOAXFSfiuiawB7JL/OtE1wsjJA=;
        b=uSchulfb/5LdXAqMdA0jxqSOmuYvdIyiVuGcpR9yqz7X0cyiOipclnpkfjFyNjq8GS
         kRR0eEav0W0g0ylnunZMX2umy9G2MPOnA/Q7aJhE3BEhpqFZETdxI1bqN6YNj/YRulCt
         JOaI1huqAfSDnQOWggom+jTiNiR8neyRGpHl6DbEtWiqzW+ZcHxCGAd6bbxDzAlWr3Vd
         /dVv8WiDxCMwlDh0zwXUGNv7GYWvkYIHntiMTdUhi2ZXzZPSlNPt6X0utfMhfB4CtAfE
         AxnMtHPQCbSsMewFMCRoEkAWKJ92/TddWAUGBJ0DxROoSLdnu5fsO4ncJ7J0RejSmuWH
         UQSg==
X-Gm-Message-State: AOAM530qjTSn1C7cj+md2Bic/K8ViZNgaDTEk1HI2RRWxEcAvqCBQowX
        uyYH5KVpdA40MhFSNnmMqxn24fOEixE=
X-Google-Smtp-Source: ABdhPJxPkBZcNsl6QcsrsgqK1LC6w3N4WioXLbJg4ho8oL/DzZtqNiISH2u3PCE/4P9f5GZWw3l79JeC2iA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7595:b0:144:ce0e:d42 with SMTP id
 j21-20020a170902759500b00144ce0e0d42mr24392473pll.39.1637803798516; Wed, 24
 Nov 2021 17:29:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:54 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-37-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 36/39] nVMX: Get rid of horribly named "ctrl"
 boolean in test_ept_eptp()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eliminate a now-pointless and horribly name boolean in the EPT test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 27150cb..bdf541b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4713,7 +4713,6 @@ static void test_ept_eptp(void)
 	u32 primary = primary_saved;
 	u32 secondary = secondary_saved;
 	u64 eptp = eptp_saved;
-	bool ctrl;
 	u32 i, maxphysaddr;
 	u64 j, resv_bits_mask = 0;
 
@@ -4755,15 +4754,11 @@ static void test_ept_eptp(void)
 	for (i = 0; i < 8; i++) {
 		eptp = (eptp & ~EPTP_PG_WALK_LEN_MASK) |
 		    (i << EPTP_PG_WALK_LEN_SHIFT);
-		if (i == 3 || (i == 4 && is_5_level_ept_supported()))
-			ctrl = true;
-		else
-			ctrl = false;
 
 		vmcs_write(EPTP, eptp);
 		report_prefix_pushf("Enable-EPT enabled; EPT page walk length %lu",
 		    eptp & EPTP_PG_WALK_LEN_MASK);
-		if (ctrl)
+		if (i == 3 || (i == 4 && is_5_level_ept_supported()))
 			test_vmx_valid_controls();
 		else
 			test_vmx_invalid_controls();
-- 
2.34.0.rc2.393.gf8c9666880-goog

