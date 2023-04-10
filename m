Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E896DC5F2
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjDJKwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 06:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjDJKvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 06:51:52 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8194C7ABF;
        Mon, 10 Apr 2023 03:51:37 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2467736d1c6so212712a91.2;
        Mon, 10 Apr 2023 03:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681123891; x=1683715891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOg/+c/G3VaaM9K0QFYQTbvifMIEuvnJxkrgp3NNysU=;
        b=lKs/DvJBKJnaZZgO/n8km6dzrGzOHLTyY8aATpZ69AGrI7fQmaptA7Blcw/eeD3cxr
         1yOR10Bgz1IFC9lSbQ0HhGdp6b/5VO4RBGSH996nF6C+pUUUTXtFWn/iViGy2Lw62rZ9
         APpYOITBn22lGewetwI4X/mXF7CEpM+T0DHE9yPck8435JJi2eJAoBA2xpRJA3cwyzO3
         NOjY3zrz6jogqTCPkf7uvv1sHLIw3MgSwpjSnK5kvnIeBea+PrttIbBcpyAZ36dvu38t
         iJ7ivNqiv2k6FMaXcvOopYNWffDVtidHH+NlW1xiQo79Rxk8qsEknpnMiQWtoLQrDoqm
         KSwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681123891; x=1683715891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOg/+c/G3VaaM9K0QFYQTbvifMIEuvnJxkrgp3NNysU=;
        b=usHkspA5UQCt7XaqSI3ncNywL38fc3dP0TfC51IolQVbIWqs2W0+j0ZdUwnmxmhU4L
         imN/hBMxyl1iV9bojXjKV6SEgUI6DCcpS0Sst4MwrY1E58HF/FjhmsSjCsXCtSYnopy8
         3BL8osyoMvGZxAxcMUnXujkeLuIu2E2UcVT3el4IZOvzMZ4OB0tKXxumv5m21AAIlPLS
         GUt41goghqLWbVJpi5u8f2eH9TaA/GajAL7R4YFRa0Zxe20aW2/2buRtCzn2oXp4iYZv
         1S1q7cOGzKt4rEFC+lCNYUX0NrBhNFN9KEG44IQ0D0yCloF8C/Q1AabrgO2WaJFsXjcj
         kCZg==
X-Gm-Message-State: AAQBX9cDXwulNMOe0gGI8kbkC7JvdamM5oa4AWUHzp4ueHj6X0+vpgJI
        MKhTZMeAxQDdgDgLbo8voGA=
X-Google-Smtp-Source: AKy350Y0l/Xy0MOOr+Hx+VT4fsOco2CjQkIlByB3RzddbFkqj2dhaZendap8pteVG6M63WaNyxbAcA==
X-Received: by 2002:a62:5257:0:b0:635:1d57:bdee with SMTP id g84-20020a625257000000b006351d57bdeemr4572705pfb.11.1681123891125;
        Mon, 10 Apr 2023 03:51:31 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00170400b0062e032b61a6sm7783252pfc.91.2023.04.10.03.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 03:51:30 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 08/10] KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
Date:   Mon, 10 Apr 2023 18:50:54 +0800
Message-Id: <20230410105056.60973-9-likexu@tencent.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230410105056.60973-1-likexu@tencent.com>
References: <20230410105056.60973-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

A KVM-only leaf for AMD's PerfMonV2 feature flag is defined to redirect
the kernel's scattered version to its architectural location, e.g. so that
KVM can query guest support via guest_cpuid_has().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a5717282bb9c..56cbdb24400a 100644
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
@@ -74,6 +78,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
 	[CPUID_8000_0007_EDX] = {0x80000007, 0, CPUID_EDX},
 	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
+	[CPUID_8000_0022_EAX] = {0x80000022, 0, CPUID_EAX},
 };
 
 /*
@@ -108,6 +113,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX_EDECCSSA;
 	else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
 		return KVM_X86_FEATURE_CONSTANT_TSC;
+	else if (x86_feature == X86_FEATURE_PERFMON_V2)
+		return KVM_X86_FEATURE_PERFMON_V2;
 
 	return x86_feature;
 }
-- 
2.40.0

