Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1C53424E
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245738AbiEYRj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245749AbiEYRjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 13:39:54 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA3AFB12
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:39:50 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id n10so20326666pjh.5
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 10:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7U4uF1P30bQvpGkNBtTFHlSgksK4T1vUR9gGkNYwja8=;
        b=i6yWUmI3d7HymSYwTdGJ7lWarGsh7bJxhJEeU1WAa716d1w1CikOHM6KO04FlXXgwG
         JkGguV88y6ntfp3FUfnoEgtZ0FQamASou5Y0Rv1unPe6OVyIBlF/o7yCLDaxn8dDIq1k
         IOJRo96vhsQa333W+2Oqu+07XtJJpKeQUoOtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7U4uF1P30bQvpGkNBtTFHlSgksK4T1vUR9gGkNYwja8=;
        b=0xCrY6HHZu61FxZ0e0MSt/FJvdmZXwpLZwZPOfMo0PS54aMVYp7LMAUbdKdahmb6RA
         fsNQTDZsGXHcuSOksX7P6dvoXhG/4IsSmfeb0HOdFGctKz26GWdzB5dsUS54wNdQj7RE
         5sg8zm1YR0DB1Plya1L83IJyvLch7JGtSXdSxg7L6tNr2FkDBIRGKTHjf62KRRuS+09v
         uAiNg1dUfwz73f+5BDHxaDf1363jFd9R7Hn4aAr7g4za93AT1uaW3QZAoQgiuQlmFv18
         a1Jf6j7bLnU3KcNQckkewTiEBmA+VgN4dthIfJzp0Lb7IbWx/IB1Aq8+w35L+tn0hRx+
         cKKA==
X-Gm-Message-State: AOAM530Aa6NIWMARzzpmHLnAfjLOkygmrzCpuVQLimdIoIwOkOPPilyE
        UMA4FmiVJkRHF0cL9FECddeGgBCFjkVQAg==
X-Google-Smtp-Source: ABdhPJzkgLNT9n5eBnvQN+zwpvSkm8tJ6QWm4pHVkgUhU6GoiLmmlBESdefSynSFlTp5x92Z0Br5gQ==
X-Received: by 2002:a17:902:c94c:b0:162:2b70:110f with SMTP id i12-20020a170902c94c00b001622b70110fmr14262323pla.127.1653500390405;
        Wed, 25 May 2022 10:39:50 -0700 (PDT)
Received: from corvallis2.c.googlers.com.com (72.86.230.35.bc.googleusercontent.com. [35.230.86.72])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm9797682pll.52.2022.05.25.10.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:39:50 -0700 (PDT)
From:   Venkatesh Srinivas <venkateshs@chromium.org>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, marcorr@google.com, venkateshs@chromium.org
Subject: [PATCH v2 2/2] KVM: Inject #GP on invalid writes to x2APIC registers
Date:   Wed, 25 May 2022 17:39:33 +0000
Message-Id: <20220525173933.1611076-2-venkateshs@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220525173933.1611076-1-venkateshs@chromium.org>
References: <20220525173933.1611076-1-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Orr <marcorr@google.com>

From: Venkatesh Srinivas <venkateshs@chromium.org>

The upper bytes of any x2APIC register are reserved. Inject a #GP
into the guest if any of these reserved bits are set.

Signed-off-by: Marc Orr <marcorr@google.com>
Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
---
 arch/x86/kvm/lapic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6f8522e8c492..617e4936c5cc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2907,6 +2907,8 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
 		return 1;
+	else if (data >> 32)
+		return 1;
 
 	return kvm_lapic_msr_write(apic, reg, data);
 }
-- 
2.36.1.124.g0e6072fb45-goog

