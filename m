Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3A58B070
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbiHETks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238395AbiHETkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:40:47 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5EE11451
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:40:45 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id e15so4840680lfs.0
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=rty6mPaEYkYj+hk2AIwEoGnTyks1fl0dWOatixd39IQ=;
        b=ZVdfbFAYeIUhGFL1MsmiiKPKr/iDRfw7LNLWovNYdZMMSqGycmpqxqzuBFS59yToBK
         MPF47XlwvkHwloFZ0QU+WvcrJW+xDfoqtCH6+uSUqgYSW2NOjGo2det5Od7Njoq5Ml6/
         +CwAoGIa929cRNttmpn9qxEz7B25vEtt9azLRc4iOHcQBoQNErztOE3hjKnLTHyzGigl
         4mvtAuLzu+sJRNekNhuKmQSjb7IotNHEnum47KHJxbGqltNqRcXB5U3smOfpln9CRsBE
         QX1tQ+doOlI35hmgOmUSmYGQtWtHtzm0jO8ApsmID8pbklD+AmnrFFEawPFrZlRm05Ee
         pU5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=rty6mPaEYkYj+hk2AIwEoGnTyks1fl0dWOatixd39IQ=;
        b=zox1oxlzW5iUjyu3GXO5Twbwp0itBSEzcKXljIOfgy2uQpuu+BXSiIJw7I9tK2JhCm
         4WppHeBWqz/052vSUW0GSuJcTqWCWS9hM/XmzrcwSY6yDM1KU1DLWjhLJ9vCihFo+2Uy
         5+jx2yGIjcZ84LRbNCC5wx8wNSF2QVmbU7cDptG2aAhlTUyMb0kcEf84UY81Tgt8T2UX
         FttFo2J21ZeyMi0XNZJnbZqeJcPPQT92HulGucZFTiCWROIYl/0i/xaMBbabuiQMQo0d
         LOCBsBjdbDUVTriHRCgCjnT3341EnosMUIIQyRlTD0vxXeFk7VDu3r0O3xWt9YwFex8N
         5VIw==
X-Gm-Message-State: ACgBeo1Qdzx4bq/ksITOPF5ObR2YfczSIIO6TFRG7KTjIWRdsmFh8O53
        Q8qol8Y/oq5pMBEtEm+lI0SCvw==
X-Google-Smtp-Source: AA6agR4yyOputGlNoeiiinUA89rWH8MyQHy5pMHZ5HQQAH93EmzS4UkCpxA03zHmJI4OgjW4LGuxNA==
X-Received: by 2002:a05:6512:3981:b0:48a:6fb9:74b7 with SMTP id j1-20020a056512398100b0048a6fb974b7mr2647305lfu.98.1659728443958;
        Fri, 05 Aug 2022 12:40:43 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id o4-20020a056512230400b0048a407f41bbsm560079lfu.238.2022.08.05.12.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:40:43 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH v2 0/5] KVM: Fix oneshot interrupts forwarding
Date:   Fri,  5 Aug 2022 21:39:14 +0200
Message-Id: <20220805193919.1470653-1-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing KVM mechanism for forwarding of level-triggered interrupts
using resample eventfd doesn't work quite correctly in the case of
interrupts that are handled in a Linux guest as oneshot interrupts
(IRQF_ONESHOT). Such an interrupt is acked to the device in its
threaded irq handler, i.e. later than it is acked to the interrupt
controller (EOI at the end of hardirq), not earlier. The existing KVM
code doesn't take that into account, which results in erroneous extra
interrupts in the guest caused by premature re-assert of an
unacknowledged IRQ by the host.

This patch series fixes this issue (for now on x86 only) by checking if
the interrupt is unmasked when we receive irq ack (EOI) and, in case if
it's masked, postponing resamplefd notify until the guest unmasks it.

Patches 1 and 2 extend the existing support for irq mask notifiers in
KVM, which is a prerequisite needed for KVM irqfd to use mask notifiers
to know when an interrupt is masked or unmasked.

Patch 3 implements the actual fix: postponing resamplefd notify in irqfd
until the irq is unmasked.

Patches 4 and 5 just do some optional renaming for consistency, as we
are now using irq mask notifiers in irqfd along with irq ack notifiers.

Please see individual patches for more details.

v2:
  - Fixed compilation failure on non-x86: mask_notifier_list moved from
    x86 "struct kvm_arch" to generic "struct kvm".
  - kvm_fire_mask_notifiers() also moved from x86 to generic code, even
    though it is not called on other architectures for now.
  - Instead of kvm_irq_is_masked() implemented
    kvm_register_and_fire_irq_mask_notifier() to fix potential race
    when reading the initial IRQ mask state.
  - Renamed for clarity:
      - irqfd_resampler_mask() -> irqfd_resampler_mask_notify()
      - kvm_irq_has_notifier() -> kvm_irq_has_ack_notifier()
      - resampler->notifier -> resampler->ack_notifier
  - Reorganized code in irqfd_resampler_ack() and
    irqfd_resampler_mask_notify() to make it easier to follow.
  - Don't follow unwanted "return type on separate line" style for
    irqfd_resampler_mask_notify().

Dmytro Maluka (5):
  KVM: x86: Move irq mask notifiers from x86 to generic KVM
  KVM: x86: Add kvm_register_and_fire_irq_mask_notifier()
  KVM: irqfd: Postpone resamplefd notify for oneshot interrupts
  KVM: irqfd: Rename resampler->notifier
  KVM: Rename kvm_irq_has_notifier()

 arch/x86/include/asm/kvm_host.h |  17 +---
 arch/x86/kvm/i8259.c            |   6 ++
 arch/x86/kvm/ioapic.c           |   8 +-
 arch/x86/kvm/ioapic.h           |   1 +
 arch/x86/kvm/irq_comm.c         |  74 +++++++++++------
 arch/x86/kvm/x86.c              |   1 -
 include/linux/kvm_host.h        |  21 ++++-
 include/linux/kvm_irqfd.h       |  16 +++-
 virt/kvm/eventfd.c              | 136 ++++++++++++++++++++++++++++----
 virt/kvm/kvm_main.c             |   1 +
 10 files changed, 221 insertions(+), 60 deletions(-)

-- 
2.37.1.559.g78731f0fdb-goog

