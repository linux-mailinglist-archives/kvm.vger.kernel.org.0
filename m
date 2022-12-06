Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64C1643EA0
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 09:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbiLFIaZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 03:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiLFIaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 03:30:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A821B784;
        Tue,  6 Dec 2022 00:30:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso17389058pjt.0;
        Tue, 06 Dec 2022 00:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a04oUGY9n3fJGrXo8icImVtwc+ewjypnXhaaNSDY1GQ=;
        b=ffnkQM8md00BOrMgIrR3OQZYzhrii36HasWPdUxYB3CgDo6No5kJFd/i9K+xbHtLM7
         1NDNH+BlJfyHXiizyks0KVClq5KwqE/ZU4E9jO5j5VNnKAsExCuivoQikD59srPvvNEq
         nZSVM3GZrE3aWExVe9ZFPT/p1R8nZzTgKed/QJrrQri63Xwl2vmVjv4sncRIQnvhmDbl
         zifnMl7Td5TfcouQlYF7i5DihELWQgL+vPGnXir/P1GWFS104Y/kvgf89Us3U6tu6UYt
         xkmP/zSaqQ4EeqCKiH83kcTc2DcQEe2uUSOzlOmceZnq42awAbh0Y5YV6amwVLzNiCIv
         LKnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a04oUGY9n3fJGrXo8icImVtwc+ewjypnXhaaNSDY1GQ=;
        b=hjnCny9cCulD8YGNqM4jQi18pUBqe608JPzT9VYpzij+rNhQYDAb4fF8lBpTmoaLpb
         JMV6JVVNgYGMD3dc5KAJ1G9JV6WtWSbBQmvZFJp9qprlPws/I13Khnabo9PQKr6/XETF
         ep4BwiqrPkQUiQ5yc+awZSLdXJHVNBHnCrPJLx1pxfOY7+8kdeHcs3cA0iq3PRsr129i
         bBdaBAa7A3DFWyqqB9a0bx0Rjdt1Ho+AiUJkWgpNZ294SDpIRZc9YxzDjKIRFwoPTN0x
         xxxf7/FiZfZTDdh/4zM3ygfyWMg6vn9Hs7ShRJRtHCsTT800dKhtyUfHmFYb3HVLDLy8
         dBbQ==
X-Gm-Message-State: ANoB5plXGkg4aTCKNpOmGAZ6GtahoGLkZr/jxWJYygprXBdE8mx72uHR
        56DBIB+ya8Gj05ihDQ7JAajKz+wkSdgbEA==
X-Google-Smtp-Source: AA0mqf7DfNx2wCWwDvGDShzXe33Twfhp5f1Ny7zoaA1Pz7YwoM/INQKj1y6WHGMPY802E0NoqYa0gg==
X-Received: by 2002:a17:90a:9f46:b0:219:b1db:f7e3 with SMTP id q6-20020a17090a9f4600b00219b1dbf7e3mr14235394pjv.64.1670315408566;
        Tue, 06 Dec 2022 00:30:08 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h15-20020a056a00000f00b00574d38f4d37sm11203330pfk.45.2022.12.06.00.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 00:30:08 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH RESEND v3 1/3] KVM: x86/pmu: Disable guest PEBS on hybird cpu due to heterogeneity
Date:   Tue,  6 Dec 2022 16:29:42 +0800
Message-Id: <20221206082944.59837-2-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206082944.59837-1-likexu@tencent.com>
References: <20221206082944.59837-1-likexu@tencent.com>
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

