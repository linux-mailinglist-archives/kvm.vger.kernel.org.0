Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CF53A1F68
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 23:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhFIVxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 17:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhFIVxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 17:53:18 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DCFC061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 14:51:23 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so2099117pjo.9
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 14:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9Y/hVypj5/8MTQfyupDMPZOv+BXNzCL7Uh026wKhdGE=;
        b=u8Tlr+NsMtRvAnx6UFZSHCcUO5cO0nXQuyTrAOzGV9eqoQprEEIR0n/9HdefhW7Bfy
         wHVouPt8AF092YYAyTuZ2zxiLRK5ZdW5UWfVmepBeD8irgqWM5bj9NswPzD+L4lffWlg
         eYsD9abGcWqmSnmOmXN5VNfYUsG1xdZs8Yfj+vgGqD7tpbyhk9BBD1lo+lw9bqJZtTiz
         qfhTzpZhm+yGc9soiKjqHzEYYprDB+KucSo9oxSKhNrYvJWPrcMXNVbOfoj3cCzP1dp1
         P+Es1qm1LbAbrK+MQMoi0gQJiiHL0WafV0MYzNJeTqcwoZxNE4BdfYATOQM6BtIB/3tJ
         goCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9Y/hVypj5/8MTQfyupDMPZOv+BXNzCL7Uh026wKhdGE=;
        b=QiOCy3V0vP1bYTAPUW8jVZLuEROQzXxHfwc7K+O3Z7cXsCbwZg4S1RqxCCgPg4oq8/
         2Wqf5ef1UNuNKPKB/Jq7trWgZBbZITM4aFDh0sWcOlRttRTQYno956uSaz+iiAKB8Yma
         MX2w5d2c8JlWd6O5LT9T1mVgXn4KIcJPOAM6wOCjFPfkrZDFx7A8oavbKdBlAlzUTo7U
         +kAeKfrUpZTIRahJ6h58Pta288RHueViM8ID7I4FLJek5e6EAVy00U/BhiwAqsdF/lR0
         dl9YJhfEOG9c14czQoz1reGoFfp6Gi3kywzcRc2kOGmHASBHsZre4bQvMB+KdgpdGvCm
         UYaQ==
X-Gm-Message-State: AOAM531c0ozRevpQWqwbT4I3asvPpZnNy4Bes97Rf1AVdxZv+A9KtrsE
        +PQQt2l9kT6QxbIa9g2YrVLvOFR08oxnAYU3f3/3+06oA4zS4y68M06v73vDu96eF91C15kscZP
        kOb+vWLBb2/bftNY05B+8H6zSRrBI0UOOqm5918aKr1gj/KQwRxDo2oLu0USWem4=
X-Google-Smtp-Source: ABdhPJyuP4BX3f1xAKxBvXKYejjlxBtp92RFA1WLyzEoawa70k4SAhRE0HrnUQ4dh5pwRDntNN50CWgUuc3ZQg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:902:f203:b029:107:d4cb:f840 with SMTP
 id m3-20020a170902f203b0290107d4cbf840mr1646972plc.41.1623275482873; Wed, 09
 Jun 2021 14:51:22 -0700 (PDT)
Date:   Wed,  9 Jun 2021 14:51:11 -0700
Message-Id: <20210609215111.4142972-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH] kvm: LAPIC: Restore guard to prevent illegal APIC register access
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per the SDM, "any access that touches bytes 4 through 15 of an APIC
register may cause undefined behavior and must not be executed."
Worse, such an access in kvm_lapic_reg_read can result in a leak of
kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
write down valid APIC registers"), such an access was explicitly
disallowed. Restore the guard that was removed in that commit.

Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 arch/x86/kvm/lapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..32fb82bbd63f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1410,6 +1410,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
 
+	if (alignment + len > 4)
+		return 1;
+
 	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
 		return 1;
 
-- 
2.32.0.272.g935e593368-goog

