Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1523559F1A9
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiHXDDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234196AbiHXDC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:02:56 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0703480353
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o17-20020a056a0015d100b00536fc93b990so1822971pfu.14
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=oUV8wY28pMmJmcPl2/RqP8e8EGWbztH4dG0hihA7UIA=;
        b=A2E6f34ENqSDSsBvaEMa64oIPMDPWf77P5uOhkFl/r4lyOba5sWFMSPU/mbHHxKzig
         A3l4IQBzoo4nzd6j7TaNBCu+rB7XUQCPIDqBzfRFDXpnkIR1pIcWt9r7UQRbBt56FbrG
         12Na5/33ve0BDBX6vg6M4f+T7n44ifMGEAJi4ds4T49CD1T/A/wfqXlvi7U5QNe+e6tv
         D2vsOi1ur+668GGhbj4hsuHG5Zdr+JftGVOchEwj7deGN3pLaj3JmF2QIPkb61Gqdedj
         O/Qlh5zETCohtjVKRztWPKDQuExLXDY8S08PnpLCy4UR1cNT1r2bj+KbtzriGvAvGtbm
         AeFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=oUV8wY28pMmJmcPl2/RqP8e8EGWbztH4dG0hihA7UIA=;
        b=7KJuws9pa1T6AASWd58VjxcGEyaBp9l7qXYQ3YXOLihnvuUiSo/DtgtaiNWU1vhdg0
         Q0keb3cHD6rSkEv9B57RXtrcnPdZ43ONBAX1x6QaRda3Uba9IMJWCWBHvZ5wSZNaLs7a
         EMFAFjIU7d/51ZekdzzPL9p/+1aI+sZv3p4KSzDuJ0nPCtQHsK5krxvfSi7hZhga8Fqo
         58v4ppDnY9Wcv1umKPxSBFm+46HXQduJP6fkiffbBOUibOzLHcVmSUAEIg9radjYIi7J
         rFm6tGM+yTIffJJEFS1O0bRzJf3MZzl9FxcCTjzIenPdkhxAps69Wua2/zrTbJC6AYeX
         0LYQ==
X-Gm-Message-State: ACgBeo2q5EDiaVmL+osXvZ/uH6VJAJO9RsJ4jV+3MmkolEwIDdojKGl/
        0hhNIUqaUXLzuqvLTSvyd0kjQvN5E5I=
X-Google-Smtp-Source: AA6agR4MvWiMqw6opMbcJIlre8rIR6OqZCQ8jiMxOMwFgX5UYr9JJ7rBiLfI9aPLgskr9RsqHjBbgMc8jJ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3b8d:b0:1fb:72f5:2d1e with SMTP id
 pc13-20020a17090b3b8d00b001fb72f52d1emr3704588pjb.135.1661310102440; Tue, 23
 Aug 2022 20:01:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:03 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 01/36] x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
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

Section 1.9 of TLFS v6.0b says:

"All structures are padded in such a way that fields are aligned
naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
and so on)".

'struct enlightened_vmcs' has a glitch:

...
        struct {
                u32                nested_flush_hypercall:1; /*   836: 0  4 */
                u32                msr_bitmap:1;         /*   836: 1  4 */
                u32                reserved:30;          /*   836: 2  4 */
        } hv_enlightenments_control;                     /*   836     4 */
        u32                        hv_vp_id;             /*   840     4 */
        u64                        hv_vm_id;             /*   844     8 */
        u64                        partition_assist_page; /*   852     8 */
...

And the observed values in 'partition_assist_page' make no sense at
all. Fix the layout by padding the structure properly.

Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and clean field bits")
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 0a9407dc0859..6f0acc45e67a 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -546,7 +546,7 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
@@ -554,7 +554,7 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
-- 
2.37.1.595.g718a3a8f04-goog

