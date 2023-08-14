Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6168477B7D8
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 13:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjHNLwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 07:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjHNLvu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 07:51:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3776CEA;
        Mon, 14 Aug 2023 04:51:50 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d2e1a72fcca58-688142a392eso3041484b3a.3;
        Mon, 14 Aug 2023 04:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692013910; x=1692618710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FePrHfi10+XZY9oU7qWIyV1EnP7SrcBy1onsUp/NmM=;
        b=Pn1y9twCjSeSf0Kll6xM5OeFo08gfC4oSPHmQfUrlXRok8bgXwIDh+LlK3KBFehr0W
         Aix6HOn7EZfxDgPUHZU+JiS5ANT3i1L5wo1ujDar1DLs7FLL1p6abjGgsk/VITvM+aRQ
         9d6p3/wJ0gY98zIYr0nMR4ih8ofJ0DEruw+9ocNYE2CaD3vIlGk6EZmWQBGz+wVYR0CQ
         uE6hea0y46s72q4fqruv7agkMu2pzBvTiO/H3iR6JNxGTx24lXpC5lqoB57OFwgFAnm0
         wBTsXWVrRvJ6RWKp6S2Dvc+nLlEn39BsPTfhSxmQrV4WAHRL8V26ExSsj1gzTnM8gJMG
         69xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692013910; x=1692618710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FePrHfi10+XZY9oU7qWIyV1EnP7SrcBy1onsUp/NmM=;
        b=Bg2EzabFSHXFH/OIJ5KIF7TTMu0vCj9qy0Yrq1xDWnLWxfeoEzRyGSTvgzKxQbonB9
         fdf0uB2jkp8RZTJzNsuyGTJudJbJ9no/W3oQDuRgocAV3OrR2LODX+QwwiivDkJGU9Vc
         lvgluYBGShVAl/zscMHKbyk/Icm+5wVXXv2kGN556rkJtQPMKVDUarKWVWvLP/VQ29MC
         F3Rcchjx7gt7+pCtRD2qgh7LdjCbYjv1JDW1OLnh20GaV8h9toM5oa+PZ5VMU4z4RSKY
         ZJoPUrgsrNpwlPfaNq7XbPW5UpBrqxzQLJZepY0F8Jy7HD4A3r8bER2bixN0nfhtQwdQ
         85iQ==
X-Gm-Message-State: AOJu0YwCZxTz1Djqh2wbYQhbRzezdcIka2Ls5MNTLgQd+0+smzV0x6Du
        DajiEm/SJ6xxtAlQOHfw9Lc=
X-Google-Smtp-Source: AGHT+IFfOlvIMkt0oQNJwZoX1Q4qkEwKDjEtWG1S0CellW4gAVOJo4wWFQStI77JBC+D73IV0Of/Fg==
X-Received: by 2002:a05:6a00:1ace:b0:681:50fd:2b98 with SMTP id f14-20020a056a001ace00b0068150fd2b98mr13307238pfv.31.1692013909718;
        Mon, 14 Aug 2023 04:51:49 -0700 (PDT)
Received: from CLOUDLIANG-MB2.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id x7-20020a63b207000000b0055386b1415dsm8407848pge.51.2023.08.14.04.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 04:51:49 -0700 (PDT)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/11] KVM: selftests: Add x86 feature and properties for AMD PMU in processor.h
Date:   Mon, 14 Aug 2023 19:51:06 +0800
Message-Id: <20230814115108.45741-10-cloudliang@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230814115108.45741-1-cloudliang@tencent.com>
References: <20230814115108.45741-1-cloudliang@tencent.com>
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

From: Jinrong Liang <cloudliang@tencent.com>

Add x86 feature and properties for AMD PMU so that tests don't have
to manually retrieve the correct CPUID leaf+register, and so that the
resulting code is self-documenting.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 6b146e1c6736..07b980b8bec2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -167,6 +167,7 @@ struct kvm_x86_cpu_feature {
  */
 #define	X86_FEATURE_SVM			KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 2)
 #define	X86_FEATURE_NX			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 20)
+#define	X86_FEATURE_AMD_PMU_EXT_CORE	KVM_X86_CPU_FEATURE(0x80000001, 0, ECX, 23)
 #define	X86_FEATURE_GBPAGES		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 26)
 #define	X86_FEATURE_RDTSCP		KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 27)
 #define	X86_FEATURE_LM			KVM_X86_CPU_FEATURE(0x80000001, 0, EDX, 29)
@@ -182,6 +183,9 @@ struct kvm_x86_cpu_feature {
 #define	X86_FEATURE_VGIF		KVM_X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
 #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
 #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
+#define X86_FEATURE_AMD_PERFMON_V2	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
+#define X86_FEATURE_AMD_LBR_STACK	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 1)
+#define X86_FEATURE_AMD_LBR_PMC_FREEZE	KVM_X86_CPU_FEATURE(0x80000022, 0, EAX, 2)
 
 /*
  * KVM defined paravirt features.
@@ -267,6 +271,9 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
 #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
 
+#define X86_PROPERTY_AMD_PMU_NR_CORE_COUNTERS	KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 0, 3)
+#define X86_PROPERTY_AMD_PMU_LBR_STACK_SIZE	KVM_X86_CPU_PROPERTY(0x80000022, 0, EBX, 4, 9)
+
 #define X86_PROPERTY_MAX_CENTAUR_LEAF		KVM_X86_CPU_PROPERTY(0xC0000000, 0, EAX, 0, 31)
 
 /*
-- 
2.39.3

