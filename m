Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A2D695837
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjBNFJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjBNFJA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:09:00 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273FACA1F;
        Mon, 13 Feb 2023 21:08:34 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id z3so3240148pfw.7;
        Mon, 13 Feb 2023 21:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DNG7iDcVMtfb40SDu0zvkvTBUqehHjLkdQ4BeI2teog=;
        b=WeHRCKyJOZwVVwH6pZu9aM45Q2zlIXy+PTYbvZXIwwloD+wBsZGQ0rNZJhcSMKFo+l
         tsGbd7v3xDWPRGbM5LVC/Ia2W9ZLEJrA+fEOTtsOong0se4gcM+7w5POXtuLljiYvfwv
         kStjyw6IWttLIedGwLXeLA1iHmfyTyXc/vKqHt0RSva5Xgr5FA7nEJuQ5b6Uc802mRd0
         g7ACRyrns43mbusZ6nuz8Tg6mX90tebc9ie1UBx4dIRQsZwvQ+a5wZwdwsC4LAWFNB+W
         5cRQqcdR7+aByvJ0UMX+XOtyZ6Xp2iwyo25cKteN6Fv5zxA70FewByR6mWG/DYhf3iOI
         llRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNG7iDcVMtfb40SDu0zvkvTBUqehHjLkdQ4BeI2teog=;
        b=LY+46eeSFMVp3dFOER1DpF4oMnrBko6dnBMD6ewR2zdeK3qovK+YwOLBegjRE3szd6
         a8jKsYAedqWY+ippEnwCvuTGIn0/LlthM9fexnTjK0dElVWuZVRz9iFiBJRrPwQh6WQa
         uXv6ixIj1wuVEkiE17oJsdv+aMpL9gcrAhz9KzjfkKJe6IltHFeRaXw/J6KN3gEfun+X
         kA1J4xuFQqhWrILgo4jz3T3YlJdhLxLLsLGZKz+dvatp5Qkqb/R0GX5xrsmvtxDbbh2Q
         e+lbc/SlzXWD9pfckft6Y7c5ulsa4Nw8/A3qHByKa2wH7UoTsVLAHSNaFvnDeyCYMG0Y
         TicQ==
X-Gm-Message-State: AO0yUKUd2qcaRLTRuQhDbt23zxgTR1hlBhT9yLvsulSVpOeA4ja2nY+2
        XYNJAFnmIOCsQ+EZv67EC4o=
X-Google-Smtp-Source: AK7set9KBksYB1M6g5NVHkf6TCRxAZdBSaU49B98pD+Xwve5PkObThRiBpSVyGkfI2e8jHNj3iNwnQ==
X-Received: by 2002:a05:6a00:c84:b0:5a6:cbdc:2a1a with SMTP id a4-20020a056a000c8400b005a6cbdc2a1amr20861869pfv.2.1676351313627;
        Mon, 13 Feb 2023 21:08:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:33 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/12] KVM: x86/cpuid: Add X86_FEATURE_PERFMON_V2 as a scattered flag
Date:   Tue, 14 Feb 2023 13:07:55 +0800
Message-Id: <20230214050757.9623-11-likexu@tencent.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214050757.9623-1-likexu@tencent.com>
References: <20230214050757.9623-1-likexu@tencent.com>
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

Considering that the core kernel may also want to know this flag, to avoid
confusion this needs to be a scattered flag rather than a pure KVM flag so
that KVM can redirect it to the hardware-defined bit position, which is the
role of __feature_translate() and KVM_X86_FEATURE_PERFMON_V2.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4945456fd646..333e28b0a13c 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -15,6 +15,7 @@ enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
 	CPUID_7_1_EDX,
 	CPUID_8000_0007_EDX,
+	CPUID_8000_0022_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -47,6 +48,9 @@ enum kvm_only_cpuid_leafs {
 /* CPUID level 0x80000007 (EDX). */
 #define KVM_X86_FEATURE_CONSTANT_TSC	KVM_X86_FEATURE(CPUID_8000_0007_EDX, 8)
 
+/* CPUID level 0x80000022 (EAX) */
+#define KVM_X86_FEATURE_PERFMON_V2	KVM_X86_FEATURE(CPUID_8000_0022_EAX, 0)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -73,6 +77,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
+	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 };
 
 /*
@@ -107,6 +112,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX_EDECCSSA;
 	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
 		return KVM_X86_FEATURE_CONSTANT_TSC;
+	else if (x86_feature == X86_FEATURE_PERFMON_V2)
+		return KVM_X86_FEATURE_PERFMON_V2;
 
 	return x86_feature;
 }
-- 
2.39.1

