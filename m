Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E9C59F1B7
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbiHXDEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiHXDDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6AD80F77
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:05 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g11-20020a17090a4b0b00b001fb5f1e195fso145168pjh.6
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=0Xy7eBzbNN8MTiEd3EXCj0aIRisHdIJdojoY0QFBRi8=;
        b=SRyApU4+GyPydjXMj51RqoCUOrw6cNJMwtKlcSLzFlUdfngCgaCArtEfzsOx/3+vGO
         vueiVc9E11BuDg857LKY6JwCxijAQIR6KqZLIuzcXe9AT927tCwEJqLNL03tLfVnyxeb
         OmYkIwh8D6QDwRZHsSIFs6bWpkLS0m2PZVcffZhLE69lg//8reAOGPEvS/5/fmFoPyf7
         Lv5yEpc3BzbMFNNnf+kEmojdstr33w1a2viKr1zU+Vt3rfWKnk4u8TtV7kUXfcF3bbx+
         1SmO9/CAc1IySSsoTehPgEwPow3EcF5tJ1HgrL/7CZwd3C2Z7/JCkqhOdB3KNVPrACDv
         0bpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=0Xy7eBzbNN8MTiEd3EXCj0aIRisHdIJdojoY0QFBRi8=;
        b=JmauoUvqtnGCxFFbKIDWEXllv0Qww1r/cOC+gCylUzA+XNsxICfRxKHPumZdo+2sF6
         2AY2JDEn1fLI3rr6OYRbNZnv9Fh/D2gF/C82XxE5ca7rHukIuL8qAX6Wzm1YKP5O0Sap
         z2jcOvLINnJx5mP2Yf7WWS1AVFuUaqkUR+iblfLZgrMN+hSpZPBbY5jYrARh/2mt0xP5
         mNgoocpB8ntusde/Ykp41FNORbbCho/76TT8NfLU2oTkL8QCQ6rP7j/6X2buHqp8FEF1
         yBZgH0OHtqeSB2L5Tbm1VrMaGwUyDFU9qFT14+fCaU+Dw9FEKXaKD1JfMkt8fkQne1k0
         ambA==
X-Gm-Message-State: ACgBeo0WDT6OnCt+4FjO6mnyAJ9HGqaVaJJZ6OIR7q5T7bM7AAmnR5ys
        c31+gUCsJXzqZkdMB8TvMx3VSLNOFEk=
X-Google-Smtp-Source: AA6agR6vqER3FneGTvJ3XZGlSU9pTpvLv+ti4pKyrMAWMW1VewM08E0cjvM8oFnNexUx39mZnOf+Jl4I3mE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:228c:b0:536:b82b:e427 with SMTP id
 f12-20020a056a00228c00b00536b82be427mr10784106pfe.17.1661310124750; Tue, 23
 Aug 2022 20:02:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:16 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 14/36] KVM: selftests: Switch to updated eVMCSv1 definition
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

Update Enlightened VMCS definition in selftests from KVM.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/evmcs.h      | 45 +++++++++++++++++--
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 3c9260f8e116..58db74f68af2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -203,14 +203,25 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	} hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
 	u64 guest_bndcfgs;
-	u64 padding64_5[7];
+	u64 guest_ia32_perf_global_ctrl;
+	u64 guest_ia32_s_cet;
+	u64 guest_ssp;
+	u64 guest_ia32_int_ssp_table_addr;
+	u64 guest_ia32_lbr_ctl;
+	u64 padding64_5[2];
 	u64 xss_exit_bitmap;
-	u64 padding64_6[7];
+	u64 encls_exiting_bitmap;
+	u64 host_ia32_perf_global_ctrl;
+	u64 tsc_multiplier;
+	u64 host_ia32_s_cet;
+	u64 host_ssp;
+	u64 host_ia32_int_ssp_table_addr;
+	u64 padding64_6;
 };
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
@@ -656,6 +667,18 @@ static inline int evmcs_vmread(uint64_t encoding, uint64_t *value)
 	case VIRTUAL_PROCESSOR_ID:
 		*value = current_evmcs->virtual_processor_id;
 		break;
+	case HOST_IA32_PERF_GLOBAL_CTRL:
+		*value = current_evmcs->host_ia32_perf_global_ctrl;
+		break;
+	case GUEST_IA32_PERF_GLOBAL_CTRL:
+		*value = current_evmcs->guest_ia32_perf_global_ctrl;
+		break;
+	case ENCLS_EXITING_BITMAP:
+		*value = current_evmcs->encls_exiting_bitmap;
+		break;
+	case TSC_MULTIPLIER:
+		*value = current_evmcs->tsc_multiplier;
+		break;
 	default: return 1;
 	}
 
@@ -1169,6 +1192,22 @@ static inline int evmcs_vmwrite(uint64_t encoding, uint64_t value)
 		current_evmcs->virtual_processor_id = value;
 		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT;
 		break;
+	case HOST_IA32_PERF_GLOBAL_CTRL:
+		current_evmcs->host_ia32_perf_global_ctrl = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1;
+		break;
+	case GUEST_IA32_PERF_GLOBAL_CTRL:
+		current_evmcs->guest_ia32_perf_global_ctrl = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1;
+		break;
+	case ENCLS_EXITING_BITMAP:
+		current_evmcs->encls_exiting_bitmap = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
+		break;
+	case TSC_MULTIPLIER:
+		current_evmcs->tsc_multiplier = value;
+		current_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2;
+		break;
 	default: return 1;
 	}
 
-- 
2.37.1.595.g718a3a8f04-goog

