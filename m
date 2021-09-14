Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329C040BB8B
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhINWdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbhINWcw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:32:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAEAC061574
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so925898yba.9
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
        b=lq/RxhWNVx7HvcaPCnLIvkYwVN/qajC6Z/TJt7BjQwh2kiG8aYIi9XXaH0fBS2ObXi
         uE6/PIk3diZR5P/av9EkChN11F3yxn4ytG2jrnfrPhRGWUQURMRhLO13q9wfpwCR7A5g
         7/RM69WnbITiPwIbs0CKxqrkVixmM0zXsLIHEQ1wRoh9YknzbX05OpiklsPNYRuGulYJ
         ieHH741AlkpjfWugkGP71HaL/RjstLd4VOJDdNdvowz1eyiO3NYovGHA5UHOVGx1wlXU
         yW88zoT/uvTdgcLKGt87Xg/M64lmUFO4TbQhZOSwiPy7azMCeLzAURvn+KJL+pQF/9m8
         vfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VREX88yx9xWzleHW1ZEh6k892sL/xPpdGpps/n5mOO0=;
        b=0cEYj7tfSbXY3cGkxzbDnuZpi5meIu1RajtIAjy9PWTnMSbaoJPntE1ncg0qzrjDXt
         knnYLJUqpmxMGFh1VY7lybMoQW8zT0y+U1i9fS/2sOGEX91tJJFxSwKDbYY06ZhhE67k
         IzC7w6S5kLnJIgHcimhH/rj5fO/vQMlElI42GHV9w4F2tV2xSjICv2PQWxtw6gJxRAPJ
         Tq5Gzy/aNivO1CJso1MVjqCmolLFpAlvs6FRnUJyBDzJpbx6kbyodoZXjIB6iHVh9Uy5
         EG5uovYZqOZQB5O2oHDl1+pz8tR8aI3Hn7hDukad6QjCFBQyvHSw84tRRKN71yhP8zEo
         p2kQ==
X-Gm-Message-State: AOAM530ey4pdv0Tpxk12ZbocPck898VxsW879kyyxaMKwE3tcCCgTD/t
        2omXudG4qxIOVaNSUw134QpAzY1awp2E
X-Google-Smtp-Source: ABdhPJyLk4QgmytoSzKirQaQHCryllAwONOUAJ9rKEqFuwJe5coEC6Nmu0X3brEpwZMn9TH/d1w9gy2iCB0z
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:61c8:: with SMTP id
 v191mr1965131ybb.472.1631658693708; Tue, 14 Sep 2021 15:31:33 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:04 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-6-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 05/15] KVM: arm64: selftests: Add support for cpu_relax
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

