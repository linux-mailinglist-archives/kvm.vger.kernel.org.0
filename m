Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A16083FE4A6
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343783AbhIAVPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343706AbhIAVP1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:27 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2110C061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:28 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id q19-20020ac87353000000b0029a09eca2afso875191qtp.21
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Isvx4DjIyZ95UhyLPtghW+KyLIgzd4+t6VBStaNZel4=;
        b=qyxdd1Im2YrMFUu2970w/b6BrYgp0K2RtFaSPBbFajB/Z4ILFmH5RtNIhZahtm5Owk
         aezBt9A1JRyOWIRSYlCyfnap0LuVFZ7p20vC3ErhfaylqfBt3hKgkpE6HkPGooQtsfS2
         DI8qbreTIGfFkQ04tVXq7jD6kr9SV0BoxM5RCoRCzxeNpi21SrJ2DUoVDXg/xrRkEeJ0
         bXprxLBdvjeVfEFi6WQvG3MoEvTutHilR+thPeWgioFEqV+DY0IcuYzJuK95PjuHGUAR
         CyVYsF8IsaDRkVxuM2uo4sczHkZ4yguHAb1PkC10Tdr6G6RJxMBQY+tGevXPPcPsVhK5
         OlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Isvx4DjIyZ95UhyLPtghW+KyLIgzd4+t6VBStaNZel4=;
        b=tVWaPyOt1+7j3Q02xNQu7OBT14+kgoTTGeZfgJimMldQwzaEtxxrJqz+h/VmLe37SN
         pWYaabYNAg+4TP5vE+1cYCg2YGWBtt1flprOrqBGnEPAyCwDu4AwWhtFCtRYJ3N4Y8L7
         0pcJPCdctDD7cecBTM6Z+WkKJTwrIFY8GhAhfBVDpQEIzIYA5Y3eAUNqLjDaKLxXdq94
         Z9CI2aPTCCbwvOZu3nI3BR4LuOOZvNufsqJTL118rbdwh5FXa+HT0MCwBT+w4NW/BwSA
         mTRk5/yEd+gVvBUlkjXUbg4yN5pDVis45w6/QhgY6Ksmtuvr1umIV5manbWaaIPdrBjg
         E+hA==
X-Gm-Message-State: AOAM533OfypsP9uNtkQgGwJRyAEpElGqHD27Y1gVUZECWIrj2E6ikMWu
        Giod++hUz9R4n+tuKN8IfuZ9lyv/fOpw
X-Google-Smtp-Source: ABdhPJwlth2Eo5IAldYMKFCB7G6X17abdCy5ScWqLZRgKQwhrRMlUTBR9716k8Lrh7gJV88fgE5xC5aFUA+J
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a0c:9c4d:: with SMTP id
 w13mr1802546qve.43.1630530867766; Wed, 01 Sep 2021 14:14:27 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:03 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-4-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 03/12] KVM: arm64: selftests: Add support for cpu_relax
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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
index 082cc97ad8d3..78df059dc974 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -191,6 +191,11 @@ asm(
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
2.33.0.153.gba50c8fa24-goog

