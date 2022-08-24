Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1B859F1AB
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiHXDDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiHXDDH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5A28035D
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:46 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so10260289plg.23
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=t4vMm870M4g3ssr8brXhkP5Bn1IsoWUYY/W+sk0HRzk=;
        b=fAiCFGfkfKe3SPJoq17NXfZHNAtaD9r6HW2CzwP8cDhhGgvI+JGyIOS2ZiyD55uTmg
         HPlONTQKC2EdV9gOltmTYemeQ/S2MbvWczk0em1cOW56y9EOoFlfEURuFqTWGYOzt8vQ
         CaprnMzfjH5YMZi7cqVOgCnjpUklbuxj4+6xGgAqsSilF7z69Ru2dsxeyj05jbzIbbGz
         FOfVZGD2utXSr1XsYf49TlvE68yF6WffYSZDbl0+RmqYAe1rBcieEY77rPNVAEBZ2twg
         KDW0RLDcvjr1ii5m93NSO/WvsFo8/G6lxWi41r4/QeZnQu4WXExHIdcYXFz+2KE2sLrx
         YD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=t4vMm870M4g3ssr8brXhkP5Bn1IsoWUYY/W+sk0HRzk=;
        b=dOKbT3zd1cAkfA/6DcR5td0yXJIjzHoAD1BxBQWp2P0ZhnkzF3cGi6qBtrL0PyzWQy
         DCNONyZ2QzV/BYRNHIMK/CagDK1y9m4nos+kBt7P/hp0QqVUN+6Dw9+KHgLwCx074ueF
         WTPfL2PrCNAqgVUk9bYV+se2QbrGNsA19uIIlruGA1d0SYkEeoMLDHuOPlThsIJxhnay
         W/OnWMCJCg0tql5f2DnT/+VhMEhRJR97JnfLSCYDRLhPGYxKReWXI9G4XcaldxlxpY57
         la/ROa3nMMkoc382ZYhILTdkpOwSwBooCjoWUJ+Vd1auWxGyzyaeh5pTn1jTfxinZzvE
         EMaA==
X-Gm-Message-State: ACgBeo1Ovx3SBiMqsQtc/SY5fdwWsdcbVCAzTg+JVkOPM/QETqaTtqOn
        LYxABQwzGZZukwmAhyiAGxTk88J0PhQ=
X-Google-Smtp-Source: AA6agR58AjAkFVMOpyI5pNc+HCriBxFR3+BkkSl91lgR3Td6mANprHq3zdsSCw2wCejA2XP6sHCcKmjvWo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c8:b0:172:f0a1:4d4d with SMTP id
 n8-20020a170902d2c800b00172f0a14d4dmr10215572plc.142.1661310105766; Tue, 23
 Aug 2022 20:01:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:05 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 03/36] KVM: x86: Zero out entire Hyper-V CPUID cache
 before processing entries
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Wipe the whole 'hv_vcpu->cpuid_cache' with memset() instead of having to
zero each particular member when the corresponding CPUID entry was not
found.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: split to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/hyperv.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index ed804447589c..611c349a08bf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2005,31 +2005,24 @@ void kvm_hv_set_cpuid(struct kvm_vcpu *vcpu)
 
 	hv_vcpu = to_hv_vcpu(vcpu);
 
+	memset(&hv_vcpu->cpuid_cache, 0, sizeof(hv_vcpu->cpuid_cache));
+
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_FEATURES);
 	if (entry) {
 		hv_vcpu->cpuid_cache.features_eax = entry->eax;
 		hv_vcpu->cpuid_cache.features_ebx = entry->ebx;
 		hv_vcpu->cpuid_cache.features_edx = entry->edx;
-	} else {
-		hv_vcpu->cpuid_cache.features_eax = 0;
-		hv_vcpu->cpuid_cache.features_ebx = 0;
-		hv_vcpu->cpuid_cache.features_edx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO);
 	if (entry) {
 		hv_vcpu->cpuid_cache.enlightenments_eax = entry->eax;
 		hv_vcpu->cpuid_cache.enlightenments_ebx = entry->ebx;
-	} else {
-		hv_vcpu->cpuid_cache.enlightenments_eax = 0;
-		hv_vcpu->cpuid_cache.enlightenments_ebx = 0;
 	}
 
 	entry = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES);
 	if (entry)
 		hv_vcpu->cpuid_cache.syndbg_cap_eax = entry->eax;
-	else
-		hv_vcpu->cpuid_cache.syndbg_cap_eax = 0;
 }
 
 int kvm_hv_set_enforce_cpuid(struct kvm_vcpu *vcpu, bool enforce)
-- 
2.37.1.595.g718a3a8f04-goog

