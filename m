Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85005F17E5
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiJABDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiJABCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:02:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEF2139BC3
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h4-20020a5b02c4000000b006bc192d672bso5210843ybp.22
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=HY4Thk5xVyPi8wKWVdpWupQbepWNLCynruIllm630pU=;
        b=UMPvRXSU4HOXUmmnmc0jCi/0QPbsXPdSBTKgJqc25cCrOAQgtzf+tyOoZaBNLF9QMg
         n2b9DRSZpPSdhB7f8X8BG3gj3Ab9xz1/087i9IcnRTZEqBTGL7j6N386w3snyMlZApP4
         eDCC4doRfm2dctlxOQilOfUCYiO2GG3IyJoqHMY+uSCGJjhkTDCXTiNeAxnrPTNOdcEL
         /l5eXYMr3GHQwFnfgq04c5YmsZeJAqhVXP3yMojrBVpADN9ciI0WLE2AfN/tc74m2V23
         A1mN+3+oSe91kkpk6MnfzaT7FAeznCOH6k/auTehPLbixkHgvPtO39wpYb8hssFWUtoD
         ThSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=HY4Thk5xVyPi8wKWVdpWupQbepWNLCynruIllm630pU=;
        b=185ptORcWBQLqUPRZ57CiRwnFTegesliyQKA5LknZ6E10BxufJH05fmlV/rmhoF/xG
         KjXoyXXEa25yp1dcfgo/80jDmgOFWkZ/PEID8MDZsXAH8ejef791uKLUG98BvfqkV7+C
         S7x/nsnNcIFJXVHC0KtOkAKu2xruvvi5tQa6xCZZ+k1fD1rICYTFCsPnn/6ckr1Q+EHG
         p3YZUIiTRn2ddV6Zp++rwwpkoRY/ssoPAZetejIjIWl9Q6q9jd+HP5NmdGVLiQ+IL91w
         GRULkiVB+yypntFPoCyWQnKuj4q2XnM8kIxRCTOyKNawlMjZi3joJEZCgJK1vMHMzQbg
         nUTA==
X-Gm-Message-State: ACrzQf0ynisFTGd8AzEyK7eJQo0KeAGVDVBaS3JL1aqfUG1tczscuWdK
        S1gxW/COHYmt5nZ2GGuhd4ge8D3nBro=
X-Google-Smtp-Source: AMsMyM6rWD4QbGIvONouo6zkfDiIWLguwc6s8vjrkpUamNM8RtGPhWMCVyL0s7k2Wdo+5V14cJnbWZR176Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:16d6:0:b0:6b1:4a12:b2f4 with SMTP id
 205-20020a2516d6000000b006b14a12b2f4mr11014876ybw.217.1664586001024; Fri, 30
 Sep 2022 18:00:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:08 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-26-seanjc@google.com>
Subject: [PATCH v4 25/32] KVM: SVM: Inhibit AVIC if vCPUs are aliased in
 logical mode
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Inhibit SVM's AVIC if multiple vCPUs are aliased to the same logical ID.
Architecturally, all CPUs whose logical ID matches the MDA are supposed
to receive the interrupt; overwriting existing entries in AVIC's
logical=>physical map can result in missed IPIs.

Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 arch/x86/kvm/lapic.c            | 5 +++++
 arch/x86/kvm/svm/avic.c         | 3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 171e38b94c89..4fd06965c773 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1159,6 +1159,12 @@ enum kvm_apicv_inhibit {
 	 * APIC base.  For simplicity, this is sticky.
 	 */
 	APICV_INHIBIT_REASON_X2APIC,
+
+	/*
+	 * AVIC is disabled because not all vCPUs with a valid LDR have a 1:1
+	 * mapping between logical ID and vCPU.
+	 */
+	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
 };
 
 struct kvm_arch {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f6f328d36ae2..9b3af49d2524 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -391,6 +391,11 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	else
 		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
 
+	if (!new || new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
+		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
+	else
+		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
+
 	old = rcu_dereference_protected(kvm->arch.apic_map,
 			lockdep_is_held(&kvm->arch.apic_map_lock));
 	rcu_assign_pointer(kvm->arch.apic_map, new);
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2908adc79ea6..27d5abc15a91 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -968,7 +968,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
 			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
-			  BIT(APICV_INHIBIT_REASON_X2APIC);
+			  BIT(APICV_INHIBIT_REASON_X2APIC) |
+			  BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED);
 
 	return supported & BIT(reason);
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

