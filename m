Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2195444A4CF
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240526AbhKICmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbhKICl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:41:59 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84EBC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:13 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id i25-20020a631319000000b002cce0a43e94so11316858pgl.0
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9kfjkwh0XeCTSxvEq2rSuYCXrCO8cNiwIU3519UtjQc=;
        b=pbf3M2iVHeF14qUsyMIOeVLd7BZ2/YXwEev0iQZ8Ka2isZ/J6/aNkE7JsSKGZ5CL1a
         KW3irQLhsUmxsH4Aej+wgE3bwRDbLmkjryi9TDCn7Zprx3NBlvp9vE1G5AVm57AzNNRu
         IYi0RnfKi4BUwdDJetDZ6IFtmAFkAULwJkXBWgC7bJy0HMawJsMGsIVq2BE+AqBEOejk
         DsPvZRvl8dz9C9AePdbR+Hiszj3zQVcBhwXLHL98xo+dw7lbn0vCqUEL7flYw+uMYHK+
         BG+h56ap9V2LLRjiHIlSB2/cnlA9HdmSBcHPg2U96CFQOeFKxoblQnlP9XXtnhVYJ1rt
         pzRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9kfjkwh0XeCTSxvEq2rSuYCXrCO8cNiwIU3519UtjQc=;
        b=449FJx+5qFRhJh/9GEGLDymdSwJFH0l9JKQvo5akwc8+ghLbsMpyp7PyfV1Q3EFzLZ
         y+O1scDDjIjdhcWGbiiCRhqk930rYch5iu5ZaLQfVkZMUvNnwQhKNLUGX3vJiyjv2VEU
         frDOGEoP6MyHttJSteKii/jY2OVIDN3hr2CFSWVuLLhqe39A/kitALdZx85pK7T1xofx
         Qc41qpF4hthP+XMJwYVqSPJnikfyyJHlZPFEry6XVhlP7JBYo6pnDKBlQZ6pqc6amdxR
         9MWLpHcSoycksd2NQmC8yQyY6Wo8xifcVzrdutY9lVvfIyFbEzIHz2X0TnsV3FO7vP/v
         6JAA==
X-Gm-Message-State: AOAM530JAO6j0IdEWAkEGg9LBqz0ArL6MibRhDt8ucHtFoeP+lsi3pz/
        UnWurWFaZF0Zg4mhKyNkzyQGnvzawnWX+JYPXBfKFLQ+Q+CWTUqw7DcrX6hdkinuiELCo7Xa5mZ
        h826BzVRQmtzyaUdcmdKje/njXoRoERNGPKt/x+jx+Vio2ed2arvccDPgwib69co=
X-Google-Smtp-Source: ABdhPJyEaUpzC3JP/YSAblsMH687yjvwYd2dNYq5Vd9uD22fsk3Uu1dvR2/eGxjJjXIibqlAla0BEREdORMgdA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e789:b0:140:801:1262 with SMTP id
 cp9-20020a170902e78900b0014008011262mr4046586plb.42.1636425552990; Mon, 08
 Nov 2021 18:39:12 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:49 -0800
Message-Id: <20211109023906.1091208-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 00/17] KVM: selftests: aarch64: Test userspace IRQ injection
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds a new test, aarch64/vgic-irq, that validates the injection of
different types of IRQs from userspace using various methods and configurations
(when applicable):

    Intid        Method     |       |          Configuration
                            |       |
               IRQ_LINE     |       |
    SGI        LEVEL_INFO   |       |
    PPI    x   IRQFD        |   x   | level-sensitive  x  EOIR + DIR
    SPI        ISPENDR      |       | edge-triggered      EOIR only
    bogus      ISACTIVER    |       |
                            |       |

vgic-irq is implemented by having a single vcpu started in any of the 4 (2x2)
configurations above.  The guest then "asks" userspace to inject all intids of
a given IRQ type using each applicable method via a GUEST_SYNC call.  The
applicable methods and intids for a given configuration are specified in tables
like this one:

    /* edge-triggered */
    static struct kvm_inject_desc inject_edge_fns[] = {
            /*                            sgi    ppi    spi */
            { KVM_IRQ_LINE,               false, false, true },
            { IRQFD,                      false, false, true },
            { ISPENDR,                    true,  false, true },
    };

Based on the (example) table above, a guest running in an edge-triggered
configuration will try injecting SGIs and SPIs.  The specific methods are also
given in the table, e.g.: SGIs are injected from userspace by writing into the
ISPENDR register.

This test also adds some extra edge tests like: IRQ preemption, restoring
active IRQs, trying to inject bogus intid's (e.g., above the configured KVM
nr_irqs).

Note that vgic-irq is currently limited to a single vcpu, GICv3, and does not
test the vITS (no MSIs).

- Commits 1-3 add some GICv3 library functions on the guest side, e.g.: set the
  priority of an IRQ.
- Commits 4-5 add some vGICv3 library functions on the userspace side, e.g.: a
  wrapper for KVM_IRQ_LINE.
- Commit 6 adds the basic version of this test: inject an SPI using
  KVM_IRQ_LINE.
- Commits 7-17 add other IRQs types, methods and configurations.

Ricardo Koller (17):
  KVM: selftests: aarch64: move gic_v3.h to shared headers
  KVM: selftests: aarch64: add function for accessing GICv3 dist and
    redist registers
  KVM: selftests: aarch64: add GICv3 register accessor library functions
  KVM: selftests: add kvm_irq_line library function
  KVM: selftests: aarch64: add vGIC library functions to deal with vIRQ
    state
  KVM: selftests: aarch64: add vgic_irq to test userspace IRQ injection
  KVM: selftests: aarch64: abstract the injection functions in vgic_irq
  KVM: selftests: aarch64: cmdline arg to set number of IRQs in vgic_irq
    test
  KVM: selftests: aarch64: cmdline arg to set EOI mode in vgic_irq
  KVM: selftests: aarch64: add preemption tests in vgic_irq
  KVM: selftests: aarch64: level-sensitive interrupts tests in vgic_irq
  KVM: selftests: aarch64: add tests for LEVEL_INFO in vgic_irq
  KVM: selftests: aarch64: add test_inject_fail to vgic_irq
  KVM: selftests: add IRQ GSI routing library functions
  KVM: selftests: aarch64: add tests for IRQFD in vgic_irq
  KVM: selftests: aarch64: add ISPENDR write tests in vgic_irq
  KVM: selftests: aarch64: add test for restoring active IRQs

 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/arch_timer.c        |   2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 853 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/gic.h       |  26 +
 .../kvm/{lib => include}/aarch64/gic_v3.h     |  12 +
 .../selftests/kvm/include/aarch64/vgic.h      |  18 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  10 +
 tools/testing/selftests/kvm/lib/aarch64/gic.c |  66 ++
 .../selftests/kvm/lib/aarch64/gic_private.h   |  11 +
 .../selftests/kvm/lib/aarch64/gic_v3.c        | 206 ++++-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 103 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  72 ++
 13 files changed, 1352 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_irq.c
 rename tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h (80%)

-- 
2.34.0.rc0.344.g81b53c2807-goog

