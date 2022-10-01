Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717B35F17FD
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiJABOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiJABNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:48 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645C013DFF
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id be18-20020a056a001f1200b00543d4bac885so3625682pfb.13
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=OLIOJuJhX0MzUSXrz6+yz/u+BTyao2rAE5Ph28PVgzU=;
        b=RRT3wXunCmMOHs878JIwHINoMuAgmTvPqLwyrteVhTuaO9w+5k/gG3esUjzLAhfVmj
         Mj4SKJdV1FAEbhPrEqMeE4nLc45YR0xupc7/Upe3i7UabZD57Wx6Vn1YZFJKJH7DsF4d
         fSWkzM9C4sRODw6H6IO9ZGcC7RHtVL2AWQCUu8OcXReKuf0rszupty+rspyzoV1or4Mt
         StG+6wU9djjnI33ckbYr6PKIEktaSM/I2yqUNzkdPXVFbUwZ+RXGserragoGRyywdIh8
         hKQd5wa2TK1ttcnhihz+FyGzrEJ5JFFxjk7S0T8retkIKHYBB3PcVjjNPG3xuj+f/0BZ
         U3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=OLIOJuJhX0MzUSXrz6+yz/u+BTyao2rAE5Ph28PVgzU=;
        b=iNVbOsI7N2quY66DhIIg3RP9asWUyDkPxcamKIWHPdFHYF7P4zRa1DVmPipuBKmqGo
         JWzX10EfDIztPsMYlET8EMBgmP607H2FfOKYW5w1SPnjLUKrSnAuwbCHzWS7s1O/+I6s
         WL6ERytunHPHzXbCuV0n5SppcKzfEsW2qY03lU6gYztdWhRBB6DpOcAS44Urflx3bWrC
         osYA/S1SSFRNXylh9XZA0MZx7V1iFUOV7AXkKR3d/gug1zv7yCCJfkiz2tPGBAxsBsQC
         BSpQWcwZPCU+UxVdEe2Z+A4DODUVe3GoP3A0t8Y6u/rOC9hPt5latn4DUC30oyB+0el7
         JtFA==
X-Gm-Message-State: ACrzQf3m8QJTkdU0HaCaA5cSPKyw99YGkrzgVCZdYvhy/9yqyRN7vqqD
        CBstg2XO/yOpkpsCTdvHLr4DIslladE=
X-Google-Smtp-Source: AMsMyM4rr1e+QRsghPrQo4YbOJbQ1hohkLVZ43J91qqYR//0arzF8wQuCRxNnHhOCkJD9BzZmy1k3bpO2Bc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3ec9:b0:203:246e:4370 with SMTP id
 rm9-20020a17090b3ec900b00203246e4370mr1000329pjb.221.1664586785010; Fri, 30
 Sep 2022 18:13:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:53 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 1/9] x86/apic: Add test config to allow running
 apic tests against SVM's AVIC
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

Add a curated "xapic" test configuration that hides x2APIC from the guest
and does not expose a PIT/8254 timer to the guest so that KVM won't
disable AVIC due to incompatibilities.

Set the timeout to '60' as the test is painfully slow when AVIC is
enabled.

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index ed65185..7600935 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -30,18 +30,31 @@ file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
 arch = x86_64
+groups = apic
 
 [ioapic-split]
 file = ioapic.flat
 extra_params = -cpu qemu64 -machine kernel_irqchip=split
 arch = x86_64
+groups = apic
 
-[apic]
+[x2apic]
 file = apic.flat
 smp = 2
 extra_params = -cpu qemu64,+x2apic,+tsc-deadline
 arch = x86_64
 timeout = 30
+groups = apic
+
+# Hide x2APIC and don't create a Programmable Interval Timer (PIT, a.k.a 8254)
+# to allow testing SVM's AVIC, which is disabled if either is exposed to the guest.
+[xapic]
+file = apic.flat
+smp = 2
+extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
+arch = x86_64
+timeout = 60
+groups = apic
 
 [ioapic]
 file = ioapic.flat
-- 
2.38.0.rc1.362.ged0d419d3c-goog

