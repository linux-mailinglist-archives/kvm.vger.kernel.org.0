Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5601715549
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 08:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjE3GFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 02:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjE3GEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 02:04:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F3DCD;
        Mon, 29 May 2023 23:04:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id 98e67ed59e1d1-256932cea7aso835284a91.3;
        Mon, 29 May 2023 23:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685426692; x=1688018692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SB00GL0LbEeM0tLPl7sWR4JRmLJ9vo4/Dc9WjVfAf2U=;
        b=E7o3ljUlcc4rw7Ia8B2++kia5ZJAPLUrqtgTC1IgSWDFq4E2e5CF/4WAk6YAtUmRw+
         zurur91Mpvb9+mao/1F4RMggXb2NxprpzzhBqeW1chfJqjrghLXndnIfqLODjcX3kdaA
         TTYnDYs91vP9ON9R8EH1zz/+17ZR8cTuuggV/jyvOlv9EwupZ9zMVGw2bL8Fn0DHmOE/
         Sfng/IGlCOs5orLNjPLnNj6GNkMJlRygfaWTEy6WMu3oQhkwYnpZuV1H5rmtTSfTJsGU
         vrgXp60V98JvOHZBIzCl/ipeMU2O5P3Oga6qeBrWTB37QQBaqxenwEelupWiL/NaXtNE
         fGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685426692; x=1688018692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SB00GL0LbEeM0tLPl7sWR4JRmLJ9vo4/Dc9WjVfAf2U=;
        b=NzcmbZFx8M2qqrHQQMlaMaMptkkFK8xR8l8UO5bJXeMeGo8tmcAbQDozrUuDz6Kfmd
         fV24oLwnJXuwN2Dr2ETYBp2IaTGAN7CanfqwYt/tATfXOCYq3QLSB6Z1x0LAC5HRwx6e
         A7hOxMk+rUuIbXG0QeK2ClvKi4AsAkW1GzayP7NfVVCjlAWE0mJ79s9Plet/BN9SQ2J9
         7t/gHGd/voyb+44K4hK6KDLEanClq3sE8FF2YytpdphZpiBDhqDYeQkZP2M5WbTraK8j
         nGelcRe1tjSdpQb12No+Zn15UOoypSagIFd7PCN4Yv3Lsmn29P1v5T1twnTh1JQ61YJ2
         S5OA==
X-Gm-Message-State: AC+VfDzn8FSIrzLm7bHZZJMIrPqNlsidADOin4vFcxulbZpqSJ5CG0ym
        FH36jUaZwpuwL/CH463LlWA=
X-Google-Smtp-Source: ACHHUZ6WN28aII96wTlBbMppEFN6i5zJ+FOOIDHS/5Fo/ZwqXLxs91u/J6g0tHCRv3Qxd06OyAvoIg==
X-Received: by 2002:a17:90a:2805:b0:250:d293:5da0 with SMTP id e5-20020a17090a280500b00250d2935da0mr1420134pjd.17.1685426691727;
        Mon, 29 May 2023 23:04:51 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id gw8-20020a17090b0a4800b00256b67208b1sm638072pjb.56.2023.05.29.23.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 23:04:51 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/10] KVM: x86: Explicitly zero cpuid "0xa" leaf when PMU is disabled
Date:   Tue, 30 May 2023 14:04:17 +0800
Message-Id: <20230530060423.32361-5-likexu@tencent.com>
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

Add an explicit !enable_pmu check as relying on kvm_pmu_cap to be
zeroed isn't obvious. Although when !enable_pmu, KVM will have
zero-padded kvm_pmu_cap to do subsequent CPUID leaf assignments.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a07b23..61bc71882f07 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -948,7 +948,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
+		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
-- 
2.40.1

