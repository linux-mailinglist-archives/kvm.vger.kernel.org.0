Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF26B62256F
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 09:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiKII3F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 03:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiKII2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 03:28:39 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6AFFED;
        Wed,  9 Nov 2022 00:28:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m6so16087377pfb.0;
        Wed, 09 Nov 2022 00:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a04oUGY9n3fJGrXo8icImVtwc+ewjypnXhaaNSDY1GQ=;
        b=K+P7tZlfLXA88kzJjIIjZZPjUJaBHbJmrzVN6PYRfi1Oa6oMruscZ3MQ8qCz2hQg0E
         ML3j/csqsCnwbY8AJpY0g/t9XkiTZbL7pvFRmXrzHM0k2miDCOk/m++Jm9usTJAgOVqC
         BvyHk5STlaPWgpWPglqWGrIrH4C8GzHonSRQT8yeMs7tx4XYislMnOSSd8+sZETkI4io
         cGtTmNt+9NNhvaITYBOPXYAKq4efcw1YFlAOTWJRjS43Wu7fWhbazjR2j6+J4+RG71EY
         BBeVo6He1aShlfX9OjrTNRVkCTBhjfO/ueCvE+OHNUpXX4YOELeZvIXlYJ998QHCWH80
         X+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a04oUGY9n3fJGrXo8icImVtwc+ewjypnXhaaNSDY1GQ=;
        b=pDFIzOlghFrMxUt516ISdIpMHqkLd2soNhXrmXjY26CO/z3huq5zZvLME87LrYQCkx
         lEh1Uy5WONSFMbaqG0Rr3S3FAKKSCBUgnSQn5UY8AYvTv76hhlC7dKPj42vCvgjjRTCU
         Nc0IzrPVKAO7XHhoGIJHXJkEtj2FO5Fcp+s/IjiwN/MPfBNC6lFl2MxgP/UuBJsMlvto
         yUwtmiGGaYP0X0r67Ad1OzKOrB1W84mrPROH1KeMd4aa75WQowlU9JUsr4ARASKgasIE
         Nm9g984eGdB7tnUFZVOechGSXxxhu2yWn5kd63UGTXZ/IDJCf11fr1IIvZQTTdo78nG5
         dvyQ==
X-Gm-Message-State: ACrzQf3zZfhFJgB1W+Va0L/iaUHsgy57AakfiQ8m/MiwYnxdvcQuISWj
        X1WaQ0dlgI8feqQikS5PCjY=
X-Google-Smtp-Source: AMsMyM78WsUhfOEjjGrvcqtI2z9E40hwegmA30/cdbdMiK+48RhgZtY62i+bXtDc3vYbWSjWAvofsw==
X-Received: by 2002:a63:1f13:0:b0:455:80ce:6d36 with SMTP id f19-20020a631f13000000b0045580ce6d36mr52181566pgf.111.1667982502775;
        Wed, 09 Nov 2022 00:28:22 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id b14-20020a63d30e000000b00470537b9b0asm6587700pgg.51.2022.11.09.00.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 00:28:22 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due to heterogeneity
Date:   Wed,  9 Nov 2022 16:28:00 +0800
Message-Id: <20221109082802.27543-2-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109082802.27543-1-likexu@tencent.com>
References: <20221109082802.27543-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

From vPMU enabling perspective, KVM does not have proper support for
hybird x86 core. The reported perf_capabilities value (e.g. the format
of pebs record) depends on the type of cpu the kvm-intel module is init.
When a vcpu of one pebs format migrates to a vcpu of another pebs format,
the incorrect parsing of pebs records by guest can make profiling data
analysis extremely problematic.

The safe way to fix this is to disable this part of the support until the
guest recognizes that it is running on the hybird cpu, which is appropriate
at the moment given that x86 hybrid architectures are not heavily touted
in the data center market.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/vmx/capabilities.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cd2ac9536c99..ea0498684048 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -392,7 +392,9 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 
 static inline bool vmx_pebs_supported(void)
 {
-	return boot_cpu_has(X86_FEATURE_PEBS) && kvm_pmu_cap.pebs_ept;
+	return boot_cpu_has(X86_FEATURE_PEBS) &&
+	       !boot_cpu_has(X86_FEATURE_HYBRID_CPU) &&
+	       kvm_pmu_cap.pebs_ept;
 }
 
 static inline bool cpu_has_notify_vmexit(void)
-- 
2.38.1

