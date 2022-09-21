Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB875BF1FF
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiIUAcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiIUAct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:32:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A2792DF
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id c7-20020a170902d48700b00176be258f23so2726359plg.15
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=YVTX41DvvKxI+UwJXy7clPsFGJGlirwL5Ozkg5cZ92g=;
        b=jsAJOmaw4PgLCggNnx5/TYjU6cPknBULwo8y0CP8EG2Sw1Ww/Zrcrj6rGqXRDdQXIy
         EWBMc+N0YIPVg9+2uIB4J+yKk6tMlcVTEVpV4JuWamxfv2EHt8Ej3zHy+5oNaS33lDfN
         vH0m6DcsIZmg5DI1FTeFfpS1f4mHkStL+K18cPVuWZt5XpaSJGD13ON+coD8QTFYFBT0
         2meYcKf8yaGiX/cOLkiucS7uLGTg/lFhOnl9Bpa7jzJMpOV+XF1YoiuyQSMhVGmgnyon
         QYw+h9rG1jod+1d+oEBVHjsWVAsFeTGvZgaCNWH4jrGOsY16rCNYJVCAAf8mzBIPZVXO
         9sQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=YVTX41DvvKxI+UwJXy7clPsFGJGlirwL5Ozkg5cZ92g=;
        b=wi4JS72QIfj3RTO6+mFZ0dk/GgVbBFtVwKn6ulqogqaNpPjITdm6Xk26s+KwjS2PT/
         IIMGCZ/ZWiUCiN3+jpqOfCpVqt88LEXGeA+Goh5iA/cf158LTAAJlR0hMrL+9vX5qf+e
         syr9NlcagaiMTSVwkLfWyETzEIMAZ4z9c7IW07MhjfFNIeDzM9aKilRC9AA4/XDwMFpd
         xr3ixRQ/R+nLAfbr7KCLGi+KJKUbTccYhzaQVAUWRu479Iqhutv7AefGUsVM3pcL/uq+
         5vDnEnmWHlD9pP3J3kffAXikoptccEGKt6lRgOJqaJKF9alBl/iexl1mUVgAAdIv2IlE
         MIeQ==
X-Gm-Message-State: ACrzQf1AHNZuuqg2gUfxbhP9hFEs20Xf6iCcVd05Tq3nUT161rCDFXWa
        VEViyGcrc31sYr7IG8oM7w6XW9a0BgU=
X-Google-Smtp-Source: AMsMyM5IXBzO0Z3bLf7U4Nl4fzPxWQVIxnXG7eLk3nZYDV6O9qarsIgEDf3VrL/1WyPiWF5/ev4wovLKs6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:854:b0:542:4254:17f6 with SMTP id
 q20-20020a056a00085400b00542425417f6mr25988846pfk.47.1663720366656; Tue, 20
 Sep 2022 17:32:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Sep 2022 00:31:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921003201.1441511-1-seanjc@google.com>
Subject: [PATCH v4 00/12] KVM: x86: never write to memory from kvm_vcpu_check_block
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Non-x86 folks, there's nothing interesting to see here, y'all got pulled
in because removing KVM_REQ_UNHALT requires deleting kvm_clear_request()
from arch code.

Note, this based on:

	https://github.com/sean-jc/linux.git tags/kvm-x86-6.1-1

to pre-resolve conflicts with the event/exception cleanups in there.


In Paolo's words...

The following backtrace:

[ 1355.807187]  kvm_vcpu_map+0x159/0x190 [kvm]
[ 1355.807628]  nested_svm_vmexit+0x4c/0x7f0 [kvm_amd]
[ 1355.808036]  ? kvm_vcpu_block+0x54/0xa0 [kvm]
[ 1355.808450]  svm_check_nested_events+0x97/0x390 [kvm_amd]
[ 1355.808920]  kvm_check_nested_events+0x1c/0x40 [kvm] 
[ 1355.809396]  kvm_arch_vcpu_runnable+0x4e/0x190 [kvm]
[ 1355.809892]  kvm_vcpu_check_block+0x4f/0x100 [kvm]
[ 1355.811259]  kvm_vcpu_block+0x6b/0xa0 [kvm] 

can occur due to kmap being called in non-sleepable (!TASK_RUNNING) context.
The fix is to extend kvm_x86_ops->nested_ops.hv_timer_pending() to cover
all events not already checked in kvm_arch_vcpu_is_runnable(), and then
get rid of the annoying (and wrong) call to kvm_check_nested_events()
from kvm_vcpu_check_block().

Beware, this is not a complete fix, because kvm_guest_apic_has_interrupt()
might still _read_ memory from non-sleepable context.  The fix here is
probably to make kvm_arch_vcpu_is_runnable() return -EAGAIN, and in that
case do a round of kvm_vcpu_check_block() polling in sleepable context.
Nevertheless, it is a good start as it pushes the vmexit into vcpu_block().

The series also does a small cleanup pass on kvm_vcpu_check_block(),
removing KVM_REQ_UNHALT in favor of simply calling kvm_arch_vcpu_runnable()
again.  Now that kvm_check_nested_events() is not called anymore by
kvm_arch_vcpu_runnable(), it is much easier to see that KVM will never
consume the event that caused kvm_vcpu_has_events() to return true,
and therefore it is safe to evaluate it again.

The alternative of propagating the return value of
kvm_arch_vcpu_runnable() up to kvm_vcpu_{block,halt}() is inferior
because it does not quite get right the edge cases where the vCPU becomes
runnable right before schedule() or right after kvm_vcpu_check_block().
While these edge cases are unlikely to truly matter in practice, it is
also pointless to get them "wrong".

v4:
  - Make event request if INIT/SIPI is pending when GIF=>1 (SVM) and
    on nested VM-Enter (VMX).
  - Make an event request at VMXOFF iff it's necessary.
  - Keep the INIT/SIPI pending vs. blocked checks separate (for the
    above nSVM/nVMX fixes).
  - Check the result of kvm_check_nested_events() in vcpu_block().
  - Rename INIT/SIPI helpers (hopefully we'll eventually rename all of
    the related collateral, e.g. "pending_events" is so misleading).
  - Drop pending INIT/SIPI snaphsot to avoid creating weird, conflicting
    code when kvm_check_nested_events() is called by vcpu_block().

v3:
  - https://lore.kernel.org/all/20220822170659.2527086-1-pbonzini@redhat.com
  - do not propagate the return value of  kvm_arch_vcpu_runnable() up to
    kvm_vcpu_{block,halt}()
  - move and reformat the comment in vcpu_block()

    move KVM_REQ_UNHALT removal last

Paolo Bonzini (5):
  KVM: x86: make vendor code check for all nested events
  KVM: x86: lapic does not have to process INIT if it is blocked
  KVM: x86: never write to memory from kvm_vcpu_check_block()
  KVM: mips, x86: do not rely on KVM_REQ_UNHALT
  KVM: remove KVM_REQ_UNHALT

Sean Christopherson (7):
  KVM: nVMX: Make an event request when pending an MTF nested VM-Exit
  KVM: x86: Rename and expose helper to detect if INIT/SIPI are allowed
  KVM: x86: Rename kvm_apic_has_events() to make it INIT/SIPI specific
  KVM: SVM: Make an event request if INIT or SIPI is pending when GIF is
    set
  KVM: nVMX: Make an event request if INIT or SIPI is pending on
    VM-Enter
  KVM: nVMX: Make event request on VMXOFF iff INIT/SIPI is pending
  KVM: x86: Don't snapshot pending INIT/SIPI prior to checking nested
    events

 Documentation/virt/kvm/vcpu-requests.rst | 28 +--------------
 arch/arm64/kvm/arm.c                     |  1 -
 arch/mips/kvm/emulate.c                  |  6 ++--
 arch/powerpc/kvm/book3s_pr.c             |  1 -
 arch/powerpc/kvm/book3s_pr_papr.c        |  1 -
 arch/powerpc/kvm/booke.c                 |  1 -
 arch/powerpc/kvm/powerpc.c               |  1 -
 arch/riscv/kvm/vcpu_insn.c               |  1 -
 arch/s390/kvm/kvm-s390.c                 |  2 --
 arch/x86/include/asm/kvm_host.h          |  2 +-
 arch/x86/kvm/lapic.c                     | 38 ++++++--------------
 arch/x86/kvm/lapic.h                     |  9 ++++-
 arch/x86/kvm/svm/svm.c                   |  3 +-
 arch/x86/kvm/vmx/nested.c                | 33 +++++++++--------
 arch/x86/kvm/vmx/vmx.c                   |  6 ++--
 arch/x86/kvm/x86.c                       | 46 +++++++++++++++---------
 arch/x86/kvm/x86.h                       |  5 ---
 arch/x86/kvm/xen.c                       |  1 -
 include/linux/kvm_host.h                 |  3 +-
 virt/kvm/kvm_main.c                      |  4 +--
 20 files changed, 79 insertions(+), 113 deletions(-)


base-commit: 5df50a4a9b60afba4dd2be76d0f0fb8ae8c9beab
-- 
2.37.3.968.ga6b4b080e4-goog

