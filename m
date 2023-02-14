Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427C4695831
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 06:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjBNFJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 00:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbjBNFIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 00:08:38 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546781C7C9;
        Mon, 13 Feb 2023 21:08:29 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id r3so4003210pfh.4;
        Mon, 13 Feb 2023 21:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uzva8eb/mui8pw0PBjhdPuWAzuWwELEXUdu9aOzTQY=;
        b=IJmUd2UQPqNmMdeuv3yUaBdedV0P89pQVW88PWvTK+PU964FJJ1c7Hp5lMyA5kx09c
         TPKj/IDK+B5rpl+7iTfo9AFjt8xIEmXDsPbgQ6r6wv1YLJEnrQNDpwhUc4KlEhE741/0
         V++53RCTZAPQ14I9bFhtGcZGFSReCD5ifRSN43XnVkLuZYHcq9+gXQzbcBPd9E3INlKb
         Nv13yl0OeOC7qOuWNlLrQDtSaxHZ77mQFYM85LKJilYPFjezNsr/7ayuZvzUQ11wUkvp
         LSvEw3lcHtRS2ZK3qeR6LI5rEVmHqapXQohIwiM1OeY7EOQuBJ0vkIWUIxdvRBt2lUMu
         BwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7uzva8eb/mui8pw0PBjhdPuWAzuWwELEXUdu9aOzTQY=;
        b=1FM5JRDHdrVSxkV2JTrzsB8uxs14h429KpssU2b4q4tYKLek8FaX+OkZk7uLmICB7q
         PTi33IRr6r5e6oTqTWEp57UDExr+HxDUM+gwebiLdhH04o1xIkEdfBsYnMUqSWYl38yS
         S9UGtiSlbPezB8GGkRJDueD7M4jCmBLIUYitM2xqemA4XxWtHFPWqqK5qcZnSMaPF10D
         0R8rjsJIm2YhhHEMTYGgOsRz5unpECJJUFI6ptKlnxwKkmrWNqvCp0jupET783eF5VTS
         IVHMdteWJXnee0m9IZBbix7jf9igN2a4kAgcKck89FYrRYBlDkkphUZ/pVYeDwPtNf9e
         5GLA==
X-Gm-Message-State: AO0yUKUZrEaPJWtkzIcOWr2nvjgx486ZPtV588GG9iYj6T0xkp6wH5uN
        RqgNUL6b/x62RP5NGcxcMFdW4hZYxK9QVfMRNzs=
X-Google-Smtp-Source: AK7set+s+E5lO/gV2UBkQ1BR5lMV3sjLlBLL9bNG9fBekVQM6d6ZhWnUsu6Ucmvz5se/p6AQ8BtXNQ==
X-Received: by 2002:a05:6a00:4304:b0:5a8:d438:c72 with SMTP id cb4-20020a056a00430400b005a8d4380c72mr2688608pfb.5.1676351308639;
        Mon, 13 Feb 2023 21:08:28 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j22-20020aa79296000000b005a79f5d9f53sm8738919pfa.165.2023.02.13.21.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 21:08:28 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/12] KVM: x86/cpuid: Use fast return for cpuid "0xa" leaf when !enable_pmu
Date:   Tue, 14 Feb 2023 13:07:52 +0800
Message-Id: <20230214050757.9623-8-likexu@tencent.com>
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

Add an explicit !enable_pmu check as relying on kvm_pmu_cap to be
zeroed isn't obvious. Although when !enable_pmu, KVM will have
zero-padded kvm_pmu_cap to do subsequent cpuid leaf assignments,
one extra branch instruction saves a few subsequent zero-assignment
instructions, speeding things up a bit.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2a9f1e200dbc..b0bb5f9f5307 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -944,7 +944,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		union cpuid10_eax eax;
 		union cpuid10_edx edx;
 
-		if (!static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
+		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
-- 
2.39.1

