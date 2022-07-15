Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4565764DE
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 18:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiGOQAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 12:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiGOQAo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 12:00:44 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E7D958C
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:43 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bu42so8581248lfb.0
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIopSGAH3mTa/L5EYVPega0Li+O294uXD/7Fiv3FbZo=;
        b=r4EXCR1lFsBKKqZK7VFCnZQxznNws5DThf7w05STlutfX+LxffmlXJic/kW2E8qg/t
         DKPrUlO9a6Fj5qLYbChTFy8tqbHhexn0eRkqmzSLhR9/ydpqDlfX6E2chixJYgGCo1tb
         U+LLFeu+Ny7iDvnZVGlwd+spWQXWmt7nN1n8/4dhM2zarAE/zp31gIWgbSM/Yz7UgMF4
         Mt7sfJMLM9Z1LuZhgh/pmrHXMYSUfyi+SzOn4Bi7VzyAZKnW55TBHhX0BLKBE5Dqb+NA
         JTNTjZRuFAhm8s7vz0JToq48xP8eV/mebB4yv5uTU5PSfKtpqknn2nngKrvn1Q3LBx8R
         FLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIopSGAH3mTa/L5EYVPega0Li+O294uXD/7Fiv3FbZo=;
        b=q6h247RpUfPr56J09qt7qZtGRdifjM/ykEgIxjlg0EODd4l3iZMliUSZ/q4UAvO89N
         uY2oLKatcPQ2yy2ARA/BmJpjPNI7Jk6GCj/xDHgyks9/8polpbsIQ3JojyFLoVk9K9l7
         OHCEZWc1jKMq3cI2OymxY9C659fu8VLgRSPH9ScYd7xlyn2g/NrAHTUa7PzCAYhTWxhX
         3rHWf5l4J//eSt07ODeFSCjS8VV3Scyfqpv4Qa5zh78S+wpImKw+Xv/bORMTSA539A+k
         MK3ohrLFlnQmskuK7GqKEMjGHhM0KU6MGx/fvMmNrflrzpOIG0LDU4HEJhrs7KTFJsj9
         JKiw==
X-Gm-Message-State: AJIora91LsaNdXyJgOemlsGdlV0BwcBw1XO8P/sFN7FFgGiGQKdwSqyi
        aJQEWeYSz22COawjuWKtEDbGwA==
X-Google-Smtp-Source: AGRyM1sy8e8fPJdsNFqKUZ3+IuaUwVfbMDgUo5p1mH0WqHRT0w0vw/BcUr3AlC/CEkBL043+uaOgvA==
X-Received: by 2002:a05:6512:3e15:b0:489:e882:12c7 with SMTP id i21-20020a0565123e1500b00489e88212c7mr8640328lfv.0.1657900842057;
        Fri, 15 Jul 2022 09:00:42 -0700 (PDT)
Received: from dmaluka.office.semihalf.net ([83.142.187.84])
        by smtp.gmail.com with ESMTPSA id c12-20020a056512238c00b0047968606114sm959772lfv.111.2022.07.15.09.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:00:40 -0700 (PDT)
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
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Dmitry Torokhov <dtor@google.com>,
        Dmytro Maluka <dmy@semihalf.com>
Subject: [PATCH 0/3] KVM: Fix oneshot interrupts forwarding
Date:   Fri, 15 Jul 2022 17:59:25 +0200
Message-Id: <20220715155928.26362-1-dmy@semihalf.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Patches 1 and 2 implement the prerequisites needed for KVM irqfd to
know the interrupt mask state. Patch 3 implements the actual fix:
postponing resamplefd notify in KVM irqfd until the irq is unmasked.

Please see individual patches for more details.

Dmytro Maluka (3):
  KVM: x86: Move kvm_(un)register_irq_mask_notifier() to generic KVM
  KVM: x86: Add kvm_irq_is_masked()
  KVM: irqfd: Postpone resamplefd notify for oneshot interrupts

 arch/x86/include/asm/kvm_host.h | 11 +-----
 arch/x86/kvm/i8259.c            | 11 ++++++
 arch/x86/kvm/ioapic.c           | 11 ++++++
 arch/x86/kvm/ioapic.h           |  1 +
 arch/x86/kvm/irq_comm.c         | 34 +++++++++---------
 include/linux/kvm_host.h        | 13 +++++++
 include/linux/kvm_irqfd.h       | 14 ++++++++
 virt/kvm/eventfd.c              | 63 +++++++++++++++++++++++++++++++++
 virt/kvm/irqchip.c              | 34 ++++++++++++++++++
 9 files changed, 164 insertions(+), 28 deletions(-)

-- 
2.37.0.170.g444d1eabd0-goog

