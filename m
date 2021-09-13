Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A29409E76
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 22:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbhIMUvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 16:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347876AbhIMUvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 16:51:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DB2C061760
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id c19-20020a17090ab29300b001984505d0efso694112pjr.2
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
        b=jXfd6Ifbv2PUpHnXkJKAouWhIx2rYsNCCmG89uNRrOlOzCsjeYdmZPzk7mQuLwmR6r
         HOnftjjdFpgdyeyrS9r1+xeyl+Z5dbnbGGrObV6o+HbKo1FTge0yKCDMgwpOj14py+V1
         BFJnXQbJTaKi2YgBbos4ghKJeyONx2b2NwHcB1YLf2Ijco6HnidQU1ZWLXg2T0xYYU9o
         aAJIP0FW5mCUmEVJD3qU1APMqM3FiNktBmol28OLolIw4CyTzcnpvwgA1ZDMgNYpUokQ
         UkGiNSM75gqzCAq7jQEGsroFKM6zUAUvJ1nDq6vWGlhJj7QmBIuX2XcKbZcz1qhZ+1NU
         FCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
        b=Nbi1OvnZTStopWEYi+dDQgVPxG5H+W/FMGMd/75An0rUYMFAqo0Y81CUGSbO4pn+Ox
         rTpbzW3VLukDuJp8t6TIITKK7waVx2ZtqwMGxRMI8ud1tt+GQU1GwGJvYOjR8Jd6CXxi
         k5jvGm2oWjVOFrjr2VGazWErbXY7oSKwfHeOJSb7WbOxyhDUxHyWMArKXyC46LCQm9TK
         nM0D/uAZ4tYfl/yGDmSxH29lCB8Mb9GG0xCrGZba6wdNI8sSbLOYQYD2n3EspEGPCaYZ
         3b1gXsTivfwPxBZhEEN22vnuYT5eSiK9mOem/IndLAn1OzFP8r/SWNLS55VUUE5UpEdz
         fCUg==
X-Gm-Message-State: AOAM533PPB/6lHjHj2DYD5dDZdsVepK0wLQbQUZsfeXwsuDtaBtLYZKf
        zcX23fYHb7Dpk3nA5E8ytvvAf5nUVu/4
X-Google-Smtp-Source: ABdhPJz6fEdV2KzMR0VbG5Fihm2AW9Am9+ncpGXvD07/3wOpr20Yhs6cZzmeUf6DUvnyDHdc3aA+w846Q2BW
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a63:6e03:: with SMTP id
 j3mr12719146pgc.465.1631566193824; Mon, 13 Sep 2021 13:49:53 -0700 (PDT)
Date:   Mon, 13 Sep 2021 20:49:21 +0000
In-Reply-To: <20210913204930.130715-1-rananta@google.com>
Message-Id: <20210913204930.130715-6-rananta@google.com>
Mime-Version: 1.0
References: <20210913204930.130715-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v5 05/14] KVM: arm64: selftests: Add support for cpu_relax
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/aarch64/processor.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 93797783abad..265054c24481 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -122,6 +122,11 @@ void vm_install_exception_handler(struct kvm_vm *vm,
 void vm_install_sync_handler(struct kvm_vm *vm,
 		int vector, int ec, handler_fn handler);
 
+static inline void cpu_relax(void)
+{
+	asm volatile("yield" ::: "memory");
+}
+
 #define isb()		asm volatile("isb" : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.33.0.309.g3052b89438-goog

