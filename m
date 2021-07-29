Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14E3DAC3F
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 21:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhG2T4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 15:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbhG2T4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 15:56:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB245C061765
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:56:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o3-20020a2541030000b0290557cf3415f8so7973347yba.1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 12:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pgN08b/yk00GBllZokVtpDSIFyPI7a31tDiORmsCfCE=;
        b=YYy23uG1UwrvJN92781dawTqDn7rZMmOuoeD+4Fa5cMOURrHKF4+7b+PbMfknbbdxA
         gAO0wbzpUDvMB/7yIdtwvwc5NMSXTrutcgwm4KEhR8VtONe2DahfE+BQsbia6PESTKca
         0+xIPncJvhoGX1fBAjyBzaTX/3YpdeWuQTVe/qzrGc1zEJV/3vyTEgzpd5gTGq0vXQEm
         LeylFxvvkaMHXaRdAiuuEjB2TqJ5zZ2ew7iYg9KMiHHP25U1dRuUvOY07cskE37oe/XJ
         DRTHHBc88F/Vh8xcmrroJWrPOD9C13B3s6UPhD860jT69w1S70hx2aht/1RR8+d6xe5w
         Vv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pgN08b/yk00GBllZokVtpDSIFyPI7a31tDiORmsCfCE=;
        b=gU1RYrFjPAZwCBG843UzDokHaIFRVQhE51majCgNKT0d/G+LT+e6B1fzaDwtspTu3r
         bup7fXDv3zWGPZ0CZqyktM7CE+NmGsgOy8Uy7ADn4AzxiBaVrBGTnBaTg/YH7WMl8WU1
         rn2mm8tgPj3jDGGDfNwRESDdDOAtOWPO/108XVLgg2aipQ+NYkxGuYI07ItdxCNOM/mu
         Jlz0sSvfMUnuRtmJBV2ORPuHbjd1xBuc47L1o0JIN6px2E4Ofx/8mLOoVhuja4bYE67c
         xNF49cVztQaU7lB/YlNIq1yHe6OecDK9nXSqXWagw3BOMCd0MkrLX+PnIICO+COAKYqf
         R4fw==
X-Gm-Message-State: AOAM533A9nuxgc7FO+2md7nq4qMX4WSblsOEs7xWqSZMImzUKT2nQY2V
        65TpemsdzLgfqKy5MOg6S+YADPoj798=
X-Google-Smtp-Source: ABdhPJxv5Q9iSjza/dtoJWD8Ji6uBJa+KRn2GwxkRTQBooW5PwZGIYhH1qvOF/ZaptJAN9C14jeegk4SH7g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7a03:: with SMTP id v3mr9033669ybc.202.1627588604139;
 Thu, 29 Jul 2021 12:56:44 -0700 (PDT)
Date:   Thu, 29 Jul 2021 19:56:30 +0000
In-Reply-To: <20210729195632.489978-1-oupton@google.com>
Message-Id: <20210729195632.489978-2-oupton@google.com>
Mime-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most other architectures that implement KVM record a statistic
indicating the number of times a vCPU has exited due to a pending
signal. Add support for that stat to arm64.

Cc: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 1 +
 arch/arm64/kvm/guest.c            | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..70e129f2b574 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
 	u64 wfi_exit_stat;
 	u64 mmio_exit_user;
 	u64 mmio_exit_kernel;
+	u64 signal_exits;
 	u64 exits;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..60d0a546d7fd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
+			++vcpu->stat.signal_exits;
 		}
 
 		/*
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 1dfb83578277..50fc16ad872f 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
 	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
-	STATS_DESC_COUNTER(VCPU, exits)
+	STATS_DESC_COUNTER(VCPU, exits),
+	STATS_DESC_COUNTER(VCPU, signal_exits),
 };
 static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
 		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
-- 
2.32.0.554.ge1b32706d8-goog

