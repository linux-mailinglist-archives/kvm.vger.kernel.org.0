Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0139D5F1807
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiJABOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiJABNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C060AE6E
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:15 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hk15-20020a17090b224f00b00205fa3483bdso5553361pjb.8
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=d3z8rpME15F36lBJBWqhpN8Q8sYozxq8eC5r552UkaU=;
        b=V+XAi81nSBo2rFPt+tXFh8koIpQSoOakT40IcBLOkQlQTy9ydMZ2a3qhPze0V5jPQo
         nUlajSxvB25m58JzE6eR5djnPOxW6v+QOSt/WgvPG4MRLYXdL4zp8t3nc5RI5RzHlV5p
         O6DAJXGgSilkcDup7pWWw1UarX0vDp5vlPSzcgavf9ER4cIVF0TffFg3sDqapz8CzaPc
         1SlKQuMTjFw5R4Ib0N1w0NTC6U+1yPpnRFx6Z+Nu91bCGPzKAC9zO4Cl2pEyNtEew/uW
         M65aO93Jd2QPC5mWK3genB5tLLaavd69F7Mh6DgvUJCFJvSdC3Glbnt0LxqrQqJX1/PU
         4SAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=d3z8rpME15F36lBJBWqhpN8Q8sYozxq8eC5r552UkaU=;
        b=WAifs8BMqQuCUFweA+0EgMb5oIQIQOWKY+K9AztVB0rfrzwnTjJitLsSBfTvTKMclz
         t30garFNceg6PZ8MyL3OR/76Ta1nrjwcw9yTFMDe/6bTPo2WoRBhn1RQiPW+KIpGoMO0
         UlEer4AtKZZ2umBKT6UDvP5b6RfCWA1EEyF1QttRiGKbOskIl8giKwTRKOY1l7KEWtxw
         6Mz6XDkCdMqX7kH8g0lTDmYA6OynY3+FVaSEyjjlRRD7YURLGU81nGwrfSdWFeXvTw5e
         S1LFfbD7EUxmx7bKJT6Ar61ws0z4vd8Jvb4cQO+bbEWM2UXE8Krq3r+g9WtEgWwjwOqj
         yKKw==
X-Gm-Message-State: ACrzQf1WMOCYBEjUxME1wtBeM9hce/hWHW7EDXkFirKzZrEqnnkX4Ami
        kfmv6ITVJTvoLYv6hm3u+yuATIf1c/w=
X-Google-Smtp-Source: AMsMyM6PpJQ4CUr6KWfd55xFh5/qekK5HSt6MMCGMaGguAkp+OI6Wd7Sa08vCf8UVKO0jk/oMOA8kkPF9KE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:4e8e:0:b0:54a:ee65:cde6 with SMTP id
 c136-20020a624e8e000000b0054aee65cde6mr11728633pfb.42.1664586794785; Fri, 30
 Sep 2022 18:13:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:59 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 7/9] x86/apic: Run tests that modify APIC ID
 and/or APIC_BASE after other tests
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
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

Run the sub-tests that modify the APIC ID and/or APIC base address after
all other sub-tests.  KVM disables APICv/AVIC if the ID or base is
changed, and keeps APICv/AVIC disabled even if the original value is
restored.  I.e. run as many tests as possible with an APICv/AVIC friendly
setup.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/apic.c b/x86/apic.c
index 3c00137..5be44b8 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -676,10 +676,8 @@ int main(void)
 	const apic_test_fn tests[] = {
 		test_lapic_existence,
 
-		test_apic_id,
 		test_apic_disable,
 		test_enable_x2apic,
-		test_apicbase,
 
 		test_self_ipi_xapic,
 		test_self_ipi_x2apic,
@@ -694,6 +692,14 @@ int main(void)
 		test_apic_timer_one_shot,
 		test_apic_change_mode,
 		test_tsc_deadline_timer,
+
+		/*
+		 * KVM may disable APICv if the APIC ID and/or APIC_BASE is
+		 * modified, keep these tests at the end so that the test as a
+		 * whole provides coverage for APICv (when it's enabled).
+		 */
+		test_apic_id,
+		test_apicbase,
 	};
 
 	assert_msg(is_apic_hw_enabled() && is_apic_sw_enabled(),
-- 
2.38.0.rc1.362.ged0d419d3c-goog

