Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A44A3F0B32
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 20:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhHRSoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 14:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbhHRSoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 14:44:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409CEC0613D9
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v130-20020a25c5880000b0290593c8c353ffso3858782ybe.7
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 11:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
        b=c8xHVk4s6hSd+6Y9GryOeLTGVMmzfkiq1hv7+jFyRnpW6EH3IA6vmLaWc7VfrEEA9H
         BC5PDnWCLJQYD9/0Xt+U8dv1Hz1sD/0zc/41uJi38os0mU+Gy01KpPSwhnyRj/Gr1yBA
         GO0AuLPq9dgBbgik2aFUjbnvbKt/xem2y4uC8HTF6LEJ0/1IX9Us5a3LLtfBjdVOiMU+
         YosbEo5C7+oG7IxmbUBFFHTDPskrCRAsnrhO2XGtZsFSmNugOGf3h4yFHVuLFyX+B8Vg
         THIDBL5JM6sHOxo6jAk1l1wrkOmBjDxa2oo74PYYstjOagpBtrnx3g4Gi7UHSKp9/9xe
         4t4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=i0gC3YpOlYGFveSBqO/xZNra4rgAWDR79DWIZ6oDj6o=;
        b=JaJQBoDM68u3mGCn3YHKtAM2AcTcrMG9m3HjIY1dD5G/dFPN6gDow32ba/48e6VPbO
         B2z1PPoy0ML4G2FHI0yS/baW5hvUPfnjj0HLv+qAYu0xBUz487mgRElo5fUUSyHWlZJp
         qcAQvv3yphVuCAyXM/3Q4SjbtUk50qQuNN0f5MH8ZMshn8fQwVPs10tRycrHFe9qOrR/
         d5pLT5DFgWpFox0i3tDpWfcMnErF5PvCiJACtOODPhLRZTXQX57MkTEwBaCRsCbUq7N6
         qtfYvZlBcaVClnd+MAVSnOJ+Gsqa9K+39hIMoSpUkboaOsyLsgk8WAZawlBjbtnugJSs
         81dQ==
X-Gm-Message-State: AOAM533nPhayVCQwS97hSOTEPPbZJLQJKUJoSCjvz8TbwJyejogLajn5
        PQML6w1CP1bgvKX0U8WbCfOWqJIlOlUs
X-Google-Smtp-Source: ABdhPJwB6PS63y9NDjqeatAE1xaf+AJcpA2bji3PMSZ/4YD/r9FU49atLPRhaO9PZI8UBkHhanFmIb7u3Kje
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:f803:: with SMTP id
 u3mr12689796ybd.515.1629312203430; Wed, 18 Aug 2021 11:43:23 -0700 (PDT)
Date:   Wed, 18 Aug 2021 18:43:04 +0000
In-Reply-To: <20210818184311.517295-1-rananta@google.com>
Message-Id: <20210818184311.517295-4-rananta@google.com>
Mime-Version: 1.0
References: <20210818184311.517295-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 03/10] KVM: arm64: selftests: Add support for cpu_relax
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement the guest helper routine, cpu_relax(), to yield
the processor to other tasks.

The function was derived from
arch/arm64/include/asm/vdso/processor.h.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b4bbce837288..c83ff99282ed 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -188,6 +188,11 @@ asm(
 	val;								  \
 })
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.rc1.237.g0d66db33f3-goog

