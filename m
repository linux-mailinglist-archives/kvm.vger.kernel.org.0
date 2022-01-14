Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B7048E219
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238677AbiANBV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238650AbiANBV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:26 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D79CC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:26 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t27-20020a63461b000000b00342c204e4f3so920177pga.11
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U//Fwfa6pex8Xxi6rdTvYagiuiOPgXXZOmW3GyzUdl4=;
        b=DvGn2VJGWuED59wOboCr3sGOZhEZrB32ScradvitnvhHT6regsaU3fh1P1HF/owCiJ
         abGoL6sxN1yYz7wVDyadx8QXm3B7LwoQyO4MZOO4KSFQb2AOEV69P51cRrlUZsW2dBVC
         3jqA7CRkmUxyrh/skx4/azVYjYFKkRWM34s+A1YQVSjBmHs+CzOM0HRYIUhXFChk2zEl
         GaoJdhRfbDOD8tp6pv9BbIGAnin5fMb143U0fhKLoaIUzLpiwZUQJ0WycoSDI8V5st1q
         Z9PLfW91PtnSXklD+O55K4SgTDFUerfykNVyqR4SATxV7kfWO/hZmx4rjK+kAFqJAJOC
         mXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U//Fwfa6pex8Xxi6rdTvYagiuiOPgXXZOmW3GyzUdl4=;
        b=vhbhw4QlAQ4FVcV0GaLyyRpD+urSsEEouXf8DdjaltJzbAvND9GXThNgxpGnM09JzJ
         I4o/a6CYQjjOvkEe4uoYarRTPqCFcrxMZTnYeIPYuj0mo5Bbf8UE4G0eiuIQPgIXkbNb
         L4mmIxIpsA9T/4jbwMvSJu7M45NxzoC3glGGNoOd70HkdRhQAY1vsFJgD/Bt5ryVvPFC
         +QOyuNlQ5S/qzaQLAFjr5J838sHfj9PiCCr/ai4aKww1Ojw0R3LfSNnW7cF2q6E0WBbq
         WqdXOtv19iDSWtcGduqR39fQV1yZAE00tC6NvsyaIUdyaQ0VnuaH+Q7Amw+yjmrjUAt2
         uBxg==
X-Gm-Message-State: AOAM5303cs4EljJeRV8/8H574uUnUVo45VIBJN3tGTkgsRflowcyZL78
        IKzb94gME759AHLsnxz6inONFi8Kg8ZBW/j6u8LeWjJH5DRdnRKDoeLy60g50tgoZD0ro2PPNkS
        UUE+gAj6viyECdOFq4hL5n6fcXulPrkylbm7lfVM21elWP41v5eE0S/ZcogROVJY=
X-Google-Smtp-Source: ABdhPJwzFG/YZdIIgr0a/HA83e04vOcncEI5M85zXKFujwziBAPl0IdWnVfqJbz3JWV3f0YmAOmGZpYkLHB7KA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:6908:b0:149:b26a:b9b5 with SMTP
 id j8-20020a170902690800b00149b26ab9b5mr7481874plk.169.1642123285842; Thu, 13
 Jan 2022 17:21:25 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:08 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-6-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 5/6] selftests: kvm/x86: Introduce x86_model()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the x86 model number from CPUID.01H:EAX.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c5306e29edd4..b723163ca9ba 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -361,6 +361,11 @@ static inline unsigned int x86_family(unsigned int eax)
         return x86;
 }
 
+static inline unsigned int x86_model(unsigned int eax)
+{
+	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
+}
+
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
-- 
2.34.1.703.g22d0c6ccf7-goog

