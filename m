Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32816238DA
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiKJBaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbiKJBaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:30:11 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B59318E19
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:30:11 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f126-20020a255184000000b006cb2aebd124so523022ybb.11
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MwcsabIB4BaNJTZXLskYlIE6OYIcO08VWcBRJDU6GBY=;
        b=hqcslbD7QX+04riaiUMb4oE5H0KGB0y2jsZBE+cI1SYe90LgB1Jnz4F7RxzZkT7/j/
         uUwMwVt5PMLKMbBUOfNSNcG4tpMoCPsucflKBJIT2+dpMWYuTmZaK3I0wlt/j/9jJ768
         ONZSyzM1wPgVeNiHFxoECj4DLH/GkIcQte9f6qNio5JxpxR7zhwXMMb8Jz8FLp11xLJJ
         1Ryb4YabWzDpFSqFqB2jmx7ylbSDDartSDSXuq2cAsMP6pJ72Zh1bwN3jfIP7QSsEdcF
         q2wArMCyFhhHuM4ZApu0I/4ltv6p4EQt/XAqdDxrbOj2oJXSjsrTxN9l26PCrX/PivEs
         RiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MwcsabIB4BaNJTZXLskYlIE6OYIcO08VWcBRJDU6GBY=;
        b=6wGBZfDqBlJHOqkLI69UBlsEHLOCTLZklD2tjd/ywrh64ADXl97neYoKqp+etxjMVq
         +MBYYFXyxCGNrXFSzRwBFPEcZ+fvrsFv5RgjKBU2/fZvItOgrl9Ro8wDskAJhpm1fZ8b
         RC5mbwg8g3Qb3ANu0o1w/rI5mzT+hElru5Ssll6xt9tGSB/aLoFC/niA1BTBnnO4gu7a
         Fx3BbcWujeZ6hAc4haCFMd14H6k83v9VRRbwgFt+Ns8utaD8iOz9I7s8OFF90GgO++kL
         9iLkuuLZSb69NgxVnFKc1UN9RN+vYx4iCLg2h0+bdkg5S30KdARosL2hC1qXEtw+1Gz2
         n6yQ==
X-Gm-Message-State: ACrzQf36+ndiEu8VUAJQU1zIsQbCWcPzoBgGXG8LLojYT1wqa4oLvb8C
        shpjq/q1Sbwt4WzCIMOigoGAv1uLpOI=
X-Google-Smtp-Source: AMsMyM7GLLzY/flUF6cQMZtB3ZvhxPRMfSN25EHpYCrV4KC+IEtuKh5x3uCcs5AHkTwj8S/m9/P9sJFtxvw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:5b82:0:b0:36b:c476:c27e with SMTP id
 p124-20020a815b82000000b0036bc476c27emr1150133ywb.320.1668043810152; Wed, 09
 Nov 2022 17:30:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:30:03 +0000
In-Reply-To: <20221110013003.1421895-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221110013003.1421895-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110013003.1421895-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: SVM: Make module params and other variables
 read-only after init
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tag SVM's module params and global variables that are configured under
the svm_init() umbrella as read-only after init.  The global knobs should
never change once KVM is fully loaded.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e96c808fa8d3..f13d96e1dd0c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -168,70 +168,70 @@ static const struct svm_direct_access_msrs {
  *	count only mode.
  */
 
-static unsigned short pause_filter_thresh = KVM_DEFAULT_PLE_GAP;
+static unsigned short pause_filter_thresh __ro_after_init = KVM_DEFAULT_PLE_GAP;
 module_param(pause_filter_thresh, ushort, 0444);
 
-static unsigned short pause_filter_count = KVM_SVM_DEFAULT_PLE_WINDOW;
+static unsigned short pause_filter_count __ro_after_init = KVM_SVM_DEFAULT_PLE_WINDOW;
 module_param(pause_filter_count, ushort, 0444);
 
 /* Default doubles per-vcpu window every exit. */
-static unsigned short pause_filter_count_grow = KVM_DEFAULT_PLE_WINDOW_GROW;
+static unsigned short pause_filter_count_grow __ro_after_init = KVM_DEFAULT_PLE_WINDOW_GROW;
 module_param(pause_filter_count_grow, ushort, 0444);
 
 /* Default resets per-vcpu window every exit to pause_filter_count. */
-static unsigned short pause_filter_count_shrink = KVM_DEFAULT_PLE_WINDOW_SHRINK;
+static unsigned short pause_filter_count_shrink __ro_after_init = KVM_DEFAULT_PLE_WINDOW_SHRINK;
 module_param(pause_filter_count_shrink, ushort, 0444);
 
 /* Default is to compute the maximum so we can never overflow. */
-static unsigned short pause_filter_count_max = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
+static unsigned short pause_filter_count_max __ro_after_init = KVM_SVM_DEFAULT_PLE_WINDOW_MAX;
 module_param(pause_filter_count_max, ushort, 0444);
 
 /*
  * Use nested page tables by default.  Note, NPT may get forced off by
  * svm_hardware_setup() if it's unsupported by hardware or the host kernel.
  */
-bool npt_enabled = true;
+bool npt_enabled __ro_after_init = true;
 module_param_named(npt, npt_enabled, bool, 0444);
 
 /* allow nested virtualization in KVM/SVM */
-static int nested = true;
+static int nested __ro_after_init = true;
 module_param(nested, int, S_IRUGO);
 
 /* enable/disable Next RIP Save */
-static int nrips = true;
+static int nrips __ro_after_init = true;
 module_param(nrips, int, 0444);
 
 /* enable/disable Virtual VMLOAD VMSAVE */
-static int vls = true;
+static int vls __ro_after_init = true;
 module_param(vls, int, 0444);
 
 /* enable/disable Virtual GIF */
-int vgif = true;
+int vgif __ro_after_init = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable LBR virtualization */
-static int lbrv = true;
+static int lbrv __ro_after_init = true;
 module_param(lbrv, int, 0444);
 
-static int tsc_scaling = true;
+static int tsc_scaling __ro_after_init = true;
 module_param(tsc_scaling, int, 0444);
 
 /*
  * enable / disable AVIC.  Because the defaults differ for APICv
  * support between VMX and SVM we cannot use module_param_named.
  */
-static bool avic;
+static bool avic __ro_after_init;
 module_param(avic, bool, 0444);
 
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
 
-bool intercept_smi = true;
+bool intercept_smi __ro_after_init = true;
 module_param(intercept_smi, bool, 0444);
 
 
-static bool svm_gp_erratum_intercept = true;
+static bool svm_gp_erratum_intercept __ro_after_init = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
@@ -255,7 +255,7 @@ DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
  * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
-static int tsc_aux_uret_slot __read_mostly = -1;
+static int tsc_aux_uret_slot __ro_after_init = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
-- 
2.38.1.431.g37b22c650d-goog

