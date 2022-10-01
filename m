Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1A75F1801
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiJABOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiJABNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:13:51 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448BC5815D
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:10 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id cq15-20020a056a00330f00b005438e527f24so3643078pfb.23
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=s9nQcTbWA1vaBJd+OdxvrWwoXTy8Z0AA2k1z4pE8JHE=;
        b=hQxDWtI39FF4zi5PG3yfqEa4s39uUDIRKRY1bt1QBiCmAUOkOJV3rdhoLNzAcgnKu4
         so1EU0vaxf3tvKSE/1KqkScbbn9yw19WIzkjqnTMHcvL8I01m+ELtF+G5y/PP+AcHtT+
         wDwhbkmxb/CiM0Mv6kuyDzuafRRx0r3C/munW1+Me3oSHdt/VE2z0XfiXa6M1oZFaEsD
         7bD2DmnuGjejcfUf70qzTa90KmJWwQIg4oDn0KfPfReeAHtPcMDCvgT30l3JXdQkFm9Q
         r/CKfGlA6n0Jee2WaZo7J4JZUBP9kCevkJxaLPa3RzfXlV5VvBHKNhBU+OAXOeLKUFTH
         nZIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=s9nQcTbWA1vaBJd+OdxvrWwoXTy8Z0AA2k1z4pE8JHE=;
        b=DElrYTUXYl5FR+KqBLlOuvGkgU+WZKnLLxHysRAX/FBe/CgbXvflnD5SZHzcnbN5LQ
         LZkrnziYZ2iwKGgBnO+QK0iTuXX9Tz4vHBIqIao1nVMt8uUtamAgOmvlvCLX6SApQqcn
         1H2MaLhVElVEHC14JNHx0mcLK1nqfxCf7m9Mckb68OVDz5ZkBaIR+Xkp4OtpoQFUzDAc
         fTmePUUjRAvtHiAuwCgU1JaY0zhu2c86bAwVm3lEIPBm98LVG+eDKEkIFrmUAK7y7GIh
         qyUtTYL8gB+5wTtTUCLDZ02GA/KxscqQdBVnw1HXv3AVZiK/ONqTkCZV6vsPqCWpLIgu
         i2Mg==
X-Gm-Message-State: ACrzQf3w0rIipe5GJXMA/hdNxnvstaLRyRX2vo77xIJ2gwjSkee85+SS
        JtJKe147zwo7SmAFnB40RfIiPON0W/c=
X-Google-Smtp-Source: AMsMyM6QTNanTWQ5/3CNvWssFD8mQqfCKFmUs7K7saowmXjQQsBYd348TBUz05NRiBcthW6w/gnv8AUXvqI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:384e:0:b0:55a:fa17:5ca8 with SMTP id
 f75-20020a62384e000000b0055afa175ca8mr10291217pfa.79.1664586789881; Fri, 30
 Sep 2022 18:13:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 01:12:56 +0000
In-Reply-To: <20221001011301.2077437-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001011301.2077437-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001011301.2077437-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 4/9] x86/apic: Assert that vCPU0's APIC is
 enabled at the start of the test
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

Assert that vCPU's APIC is fully enabled at the start of the apic test.
The boot code is supposed to do that, but nothing ever actually verifies
the APIC got setup correctly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/apic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/x86/apic.c b/x86/apic.c
index 650c1d0..6c555ce 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -15,6 +15,11 @@ static bool is_apic_hw_enabled(void)
 	return rdmsr(MSR_IA32_APICBASE) & APIC_EN;
 }
 
+static bool is_apic_sw_enabled(void)
+{
+	return apic_read(APIC_SPIV) & APIC_SPIV_APIC_ENABLED;
+}
+
 static bool is_x2apic_enabled(void)
 {
 	return (rdmsr(MSR_IA32_APICBASE) & (APIC_EN | APIC_EXTD)) == (APIC_EN | APIC_EXTD);
@@ -691,6 +696,9 @@ static void test_pv_ipi(void)
 
 int main(void)
 {
+	assert_msg(is_apic_hw_enabled() && is_apic_sw_enabled(),
+		   "APIC should be fully enabled by startup code.");
+
 	setup_vm();
 
 	test_lapic_existence();
-- 
2.38.0.rc1.362.ged0d419d3c-goog

