Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52317715552
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjE3GFj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjE3GFS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:05:18 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF64611D;
        Mon, 29 May 2023 23:05:03 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d247a023aso2924119b3a.2;
        Mon, 29 May 2023 23:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426701; x=1688018701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efk2eikpj9mkGblIwh4EqJ49dRC5zifywNghQx+zwtw=;
        b=aFtM9vhuk79O2zie8OsV+1jDP6yQZXhM33aJF9taaC/ySWHcgI00xn5atb2f8sc9nr
         IsS5OPM1Omin/CsOLGb3hNKgZ0lKYdco86LGYwkTkQHVIyNqihTHJ4RC+rDIYbHigPJr
         msA95FVMQmL1aBPFMc+BOZnlneuPm2m23cDquBGh8+ybYYmc0EmdpMY75BIkrjR/r8b8
         n/sFiLiDSiadSHUh3JD+TINmyC1MTbyxPmqx0OAkgfB7A9EFTcXHGGecs3UXjGwUxBmh
         5QJgV8tBvS9DpouFD9cupfXkEKvm5pi9R3VDw/3A5DDNfVGoZ0FIX/Az4kkSFptGdcQe
         MHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426701; x=1688018701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=efk2eikpj9mkGblIwh4EqJ49dRC5zifywNghQx+zwtw=;
        b=Z1aVB1WEvpfUog39zcFXqVjtAOtvh5UkoGaA0IUuvhYn2jZF+qaCz45ai/9xbRvHS1
         9qIkMoA9VEhzTdKuWRBjlPqvHy/XI2pk5XEufTYXJHjSeS8A5VFhc/9lafe31XEh0Qsa
         0b9T0jkApWOog4AHXx1XIrfhYrybFmG68q9AD7bj81HR34eU2An8OVVbGZLAEh904Im5
         Z5zqjffhUZ+Y91p0ysnzT1yQS83KuD7VhqukPltx/7h9Cv6lDuyH9volpellXIOgIisP
         M7I6abE2VXmr8KhK4Touic4Yt698KBXo1EyZCM3imTwbN+axOgrXSQoqvkudceNtDQFp
         gtgg==
X-Gm-Message-State: AC+VfDy33dvNJl+BjT6BcG6BQTYF6yRmKW56aY7y0oR9Apj3n1BU8dCm
        CMgZW+nKK0YmX1IaCn+qN44=
X-Google-Smtp-Source: ACHHUZ7EhyvX2Y8wx1fKSqlT2UxSHNbr3lmXVxS1FZv27GD+52K0sMkQ3lTCffcpgiUcR9humEAx1w==
X-Received: by 2002:a05:6a20:3d89:b0:f2:57da:7f45 with SMTP id s9-20020a056a203d8900b000f257da7f45mr1680080pzi.8.1685426701421;
        Mon, 29 May 2023 23:05:01 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:05:01 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/10] KVM: x86/cpuid: Add a KVM-only leaf to redirect AMD PerfMonV2 flag
Date:   Tue, 30 May 2023 14:04:21 +0800
Message-Id: <20230530060423.32361-9-likexu@tencent.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530060423.32361-1-likexu@tencent.com>
References: <20230530060423.32361-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
2.40.1

