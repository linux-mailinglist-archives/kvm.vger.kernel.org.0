Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0E26C580B
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 21:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjCVUsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 16:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjCVUr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 16:47:58 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73885199D4
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 13:44:38 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id g18so20332396ljl.3
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 13:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1679517874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HRJLzQx1UmsMap1tfRUZIxUpggNdDJZoMHruY0d4CdQ=;
        b=IqONvWg8n6amjpEoKFJGMl580Jn17yQZsKw5Ijc6YSReCyctQN9b7yzMeGUpiaBxdZ
         jH06dcHuNJF27mAMQAhHoYkQC0WvtDZDdpo5zTwLRG1qf3ZPIdFg3yryCaiggMBVPyFr
         xe3CD6EoWyKcg/2D7yLp3OVz+CH4D8OaxYe5fzyyQSl9D3IoloPh7j29yGiEZEQOaGeP
         rqx4FooeM3YUbdM1FuzHGmnhAvQtFca+2ya9XIJUmJ84HHh747u/TWgxVE7Dj1j6sgWC
         qViW+Bnbu91lDTGXUxjvHnqthsZ5LmfpIR1d/dBzY+JQPvVhhtIUFUqtK0fle3/pa/OI
         +dQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679517874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HRJLzQx1UmsMap1tfRUZIxUpggNdDJZoMHruY0d4CdQ=;
        b=FbOrg08kGXR1yyI5qX/JMabhNrL0S++xJFyPxNWsemDT4yAjt67ip449kQJ88hbn2o
         pHk0G9lV9WWIJ4woJVgiIPPnZwGntX45oh9iVBZ2nSw80K1KwhkSllHBW0KCi1ztBW1z
         QRU3dk3AdyR2Exmw5yP0DCk43zXAZBXXQmjLDngv1PIWw1ysTRfAnuN52wc0ssDzLnZ8
         lGg4vxfZdQKoG36gU82iGnVJglF0hr+1EGhKAVa/JaeYeFOrBVCREW5GWcJ+x+EF2yeU
         sNzK9NZg5NDzep0sYSE1VrcA0XsJg3fLk2bZmjmFD6+Na9AeOMVaxT9G0ZdJs7r28G3t
         DqsA==
X-Gm-Message-State: AO0yUKVAQs0LnfZWfF8cFRGByYe0OrOan+JLOcJ6bRyfeT/3drABNWzP
        Kvmz3X6FzJ2KbKNIWbnpPd6K4A==
X-Google-Smtp-Source: AK7set9RGuKIR6uqdOkBQcXa7OcWAsBUP5XGWkHF9ScpIW9hEVZo9ZpfY5b6VBJlg9JrOorG7c1cjg==
X-Received: by 2002:a05:651c:1047:b0:29b:d220:bbb7 with SMTP id x7-20020a05651c104700b0029bd220bbb7mr2466039ljm.47.1679517874566;
        Wed, 22 Mar 2023 13:44:34 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id d16-20020a2eb050000000b0029aa0b6b41asm2585686ljl.115.2023.03.22.13.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 13:44:33 -0700 (PDT)
From:   Dmytro Maluka <dmy@semihalf.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Rong L Liu <rong.l.liu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>, upstream@semihalf.com,
        Dmitry Torokhov <dtor@google.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        Dmytro Maluka <dmaluka@google.com>
Subject: [PATCH v4 0/2] KVM: x86/ioapic: Fix oneshot interrupts forwarding
Date:   Wed, 22 Mar 2023 21:43:42 +0100
Message-Id: <20230322204344.50138-1-dmy@semihalf.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dmytro Maluka <dmaluka@google.com>

KVM irqfd based emulation of level-triggered interrupts doesn't work
quite correctly in some cases, particularly in the case of interrupts
that are handled in a Linux guest as oneshot interrupts (IRQF_ONESHOT).
Such an interrupt is acked to the device in its threaded irq handler,
i.e. later than it is acked to the interrupt controller (EOI at the end
of hardirq), not earlier.

Linux keeps such interrupt masked until its threaded handler finishes,
to prevent the EOI from re-asserting an unacknowledged interrupt.
However, with KVM + vfio (or whatever is listening on the resamplefd)
we always notify resamplefd at the EOI, so vfio prematurely unmasks the
host physical IRQ, thus a new physical interrupt is fired in the host.
This extra interrupt in the host is not a problem per se. The problem is
that it is unconditionally queued for injection into the guest, so the
guest sees an extra bogus interrupt. [*]

There are observed at least 2 user-visible issues caused by those
extra erroneous interrupts for a oneshot irq in the guest:

1. System suspend aborted due to a pending wakeup interrupt from
   ChromeOS EC (drivers/platform/chrome/cros_ec.c).
2. Annoying "invalid report id data" errors from ELAN0000 touchpad
   (drivers/input/mouse/elan_i2c_core.c), flooding the guest dmesg
   every time the touchpad is touched.

The core issue here is that by the time when the guest unmasks the IRQ,
the physical IRQ line is no longer asserted (since the guest has
acked the interrupt to the device in the meantime), yet we
unconditionally inject the interrupt queued into the guest by the
previous resampling. So to fix the issue, we need a way to detect that
the IRQ is no longer pending, and cancel the queued interrupt in this
case.

With IOAPIC we are not able to probe the physical IRQ line state
directly (at least not if the underlying physical interrupt controller
is an IOAPIC too), so in this patch series we use irqfd resampler for
that. Namely, instead of injecting the queued interrupt, we just notify
the resampler that this interrupt is done. If the IRQ line is actually
already deasserted, we are done. If it is still asserted, a new
interrupt will be shortly triggered through irqfd and injected into the
guest.

In the case if there is no irqfd resampler registered for this IRQ, we
cannot fix the issue, so we keep the existing behavior: immediately
unconditionally inject the queued interrupt.

This patch series fixes the issue for x86 IOAPIC only. In the long run,
we can fix it for other irqchips and other architectures too, possibly
taking advantage of reading the physical state of the IRQ line, which is
possible with some other irqchips (e.g. with arm64 GIC, maybe even with
the legacy x86 PIC).

[*] In this description we assume that the interrupt is a physical host
    interrupt forwarded to the guest e.g. by vfio. Potentially the same
    issue may occur also with a purely virtual interrupt from an
    emulated device, e.g. if the guest handles this interrupt, again, as
    a oneshot interrupt.


v4:
  - Cosmetic coding style changes as suggested by Sean.

v3:
  - Completely reworked: instead of postponing resamplefd notify until
    unmask (to avoid extra interrupts in the host), resample the pending
    status at unmask to avoid erroneous propagation of those extra
    interrupts to the guest.
    Thanks to Marc Zyngier for helping to identify the core issue, which
    resulted in a simpler and probably more sensible implementation
    (even though Marc's concern about presenting inaccurate pending
    status to the guest is a non-issue in the case of IOAPIC, since
    IOAPIC doesn't present this information anyway).

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

Dmytro Maluka (2):
  KVM: irqfd: Make resampler_list an RCU list
  KVM: x86/ioapic: Resample the pending state of an IRQ when unmasking

 arch/x86/kvm/ioapic.c     | 36 +++++++++++++++++++++++++---
 include/linux/kvm_host.h  | 11 +++++++++
 include/linux/kvm_irqfd.h |  2 +-
 virt/kvm/eventfd.c        | 49 ++++++++++++++++++++++++++++++++-------
 4 files changed, 86 insertions(+), 12 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

