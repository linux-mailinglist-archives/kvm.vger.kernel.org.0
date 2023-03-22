Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60456C3FCA
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCVBed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCVBea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:34:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAF8574D5
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id ek18so66973703edb.6
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679448867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b2CIvia+ysoMzgOq7ln7L4piO+fXsxlfLSknqU78fQ8=;
        b=gy8eg4eVkf7F9R4PCvXL29F38RM8L3sYXPWVchx8ef7eDJrdvpoXqYzMdvoNa23Rws
         0BKrz39unk31nMtSekHyuySaA8ClRqgvbBdIdWcFvxYC3l0rrZGrwYOSeKRnRlepXl/8
         7bLvcV7/0DMNlkTAhv+nKQFcSqkjgNhIAPZfMm35HGLvxDl7yKyJmnhG6pHXD/fIejWQ
         lEOg2nU90LmiYOisDpHLtdqhMX4uCWkNWIoRMHti1iFNfVEEj2aT4HuGqO/UURvNegJJ
         3W8DcnNnuyZMFd2gnDbIlg4YZqIVNxRPuXHlrxDwxGmWn4DF27iYwB90D/PqkgaSPqmc
         r9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679448867;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b2CIvia+ysoMzgOq7ln7L4piO+fXsxlfLSknqU78fQ8=;
        b=SGBrer04hFZsA4N9Urz3sOByG5/QXLASue1hPJ++3q7rXidThSnELaaEhYI7qiuhDo
         b5naSxJTTy6XYMMGAxKiEdr8swsxX9TaYW+/vrq2l46mYlALHgfJCj9xqKzeVp8zcFml
         lroFhikiowCx/rcOPUz0FgtW//rW9aMDgM5Ck8XWshICRGvrAuvNK7GPmqr/EgjiR7Es
         5E8zVSm8npv78UEBbNIIxwo9/Oet1OMryqs9nleOxctG+qKy3zDPtMZCAMDFQcyk9vbn
         pFsm5vdKfPYXvakQ2hm4wYmI/39XV0lKICo2Qox3Ga+ME5xYlbyTmNeYom8V0+J7tfYz
         DcTA==
X-Gm-Message-State: AO0yUKX/qej+4yAl/sI2JPTVlud0ge56E6g0u1BjsluSE84q7KuyAJgI
        EsoHhbwSDCvm7MbfKjjXNXgE4n9NZXFhtRvK7lQ=
X-Google-Smtp-Source: AK7set8/V0praTwRF4XPrGpz444uJtL4Oc25BCNaTyJpjGPzZ+/bBAMj59Kzk8SbKvodjAuXlrLAdA==
X-Received: by 2002:a17:906:2cca:b0:93b:46f7:a716 with SMTP id r10-20020a1709062cca00b0093b46f7a716mr707383ejr.50.1679448866926;
        Tue, 21 Mar 2023 18:34:26 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af344e007f5e5982a136b54e.dip0.t-ipconnect.de. [2003:f6:af34:4e00:7f5e:5982:a136:b54e])
        by smtp.gmail.com with ESMTPSA id w11-20020a1709067c8b00b009231714b3d4sm6356260ejo.151.2023.03.21.18.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 18:34:26 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP users
Date:   Wed, 22 Mar 2023 02:37:25 +0100
Message-Id: <20230322013731.102955-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3: https://lore.kernel.org/kvm/20230201194604.11135-1-minipli@grsecurity.net/

This series is the fourth iteration of resurrecting the missing pieces of
Paolo's previous attempt[1] to avoid needless MMU roots unloading.

It's incorporating Sean's feedback to v3 and rebased on top of
kvm-x86/next, namely commit d8708b80fa0e ("KVM: Change return type of
kvm_arch_vm_ioctl() to "int"").

The performance gap between TDP and legacy MMU is still existent,
especially noticeable under grsecurity which implements kernel W^X by
toggling CR0.WP, which happens very frequently. This series tries to fix
this needless performance loss.

Patch 1 is a v3 of [3], addressing Sean's feedback.

Patch 2 implements Sean's feedback[2] to Paolo's original approach and
skips unloading the MMU roots for CR0.WP toggling under TDP.

Patch 3 further micro-optimizes this for non-paging guests -- anyone still
running MS Singularity? ;)

Sean was suggesting another change on top of v2 of this series (and then
again a more elaborate version on top of v3), to skip intercepting CR0.WP
writes completely for VMX[4]. That turned out to be yet another
performance boost and is implemented in patch 6.

Patches 2 and 6 are the most important ones, as they bring the big
performance gains.

I used 'ssdd 10 50000' from rt-tests[5] as a micro-benchmark, running on a
grsecurity L1 VM. Below table shows the results (runtime in seconds, lower
is better):

                              legacy     TDP    shadow
    kvm-x86/next@d8708b        8.43s    9.45s    70.3s
    + patches 1-3              5.39s    5.63s    70.2s
    + patches 4-6              3.51s    3.47s    67.8s

I re-ran the benchmarks (again) and the numbers changed a little from the
ones in v3. We got a better baseline which is likely caused by the rebase
to a v6.3-rc2 based tree (was v6.2-rc3 based before).

Patches 1, 4 and 5 didn't change from v3, beside minor changelog tweaks.

Patches 2 and 6 have been rewritten.

Patch 3 is new to this series.

Bonus rant^Wbug report:

Actually re-running the benchmarks took me a while because my VM was
constantly crashing on me with a #GP during scheduling. Looking a little
closer, I noticed it was for a IA32_PRED_CMD MSR write which was puzzling,
as the VM's kernel didn't change for my tests (built it more than a month
ago!), so the old test runs should have triggered that code path (and #GP)
too! Digging through some kernel code let me see it's all tied to the x86
feature flag X86_FEATURE_USE_IBPB which gets set when X86_FEATURE_IBPB is,
i.e. the CPU supports IBPB.

*head-scratching pause* 

Foolish me probably did a system update of the host and got a microcode
update that added IBPB support to my CPU. Yayyy... NOT! As this implies
announcing IBPB support to the VM as well and, in turn, makes the guest
kernel try to use it, I'm doomed to hit that bug. *bummer*

Something must not be right with KVM / QEMU / the kernel, as this guest
behaviour clearly shouldn't cause KVM to inject a #GP into the guest.

The bugging call chain in the guest kernel is:
  -> switch_mm_irqs_off()
     -> cond_mitigation()
        -> indirect_branch_prediction_barrier()
           -> alternative_msr_write(MSR_IA32_PRED_CMD, val, X86_FEATURE_USE_IBPB))

So far I'm working around this by passing 'clearcpuid=ibpb' on the kernel
commandline. But this should probably be fixed, that's why I'm mentioning
it. It's just too late here already to debug this further today. Well, for
some definition of "today."


Thanks,
Mathias

[1] https://lore.kernel.org/kvm/20220217210340.312449-1-pbonzini@redhat.com/
[2] https://lore.kernel.org/kvm/YhATewkkO%2Fl4P9UN@google.com/
[3] https://lore.kernel.org/kvm/YhAB1d1%2FnQbx6yvk@google.com/
[4] https://lore.kernel.org/kvm/Y8cTMnyBzNdO5dY3@google.com/
[5] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git


Mathias Krause (5):
  KVM: x86: Do not unload MMU roots when only toggling CR0.WP with TDP
    enabled
  KVM: x86: Ignore CR0.WP toggles in non-paging mode
  KVM: x86: Make use of kvm_read_cr*_bits() when testing bits
  KVM: x86/mmu: Fix comment typo
  KVM: VMX: Make CR0.WP a guest owned bit

Paolo Bonzini (1):
  KVM: x86/mmu: Avoid indirect call for get_cr3

 arch/x86/kvm/kvm_cache_regs.h  |  2 +-
 arch/x86/kvm/mmu/mmu.c         | 31 ++++++++++++++++++++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/mmu/spte.c        |  2 +-
 arch/x86/kvm/pmu.c             |  4 ++--
 arch/x86/kvm/vmx/nested.c      |  4 ++--
 arch/x86/kvm/vmx/vmx.c         |  6 +++---
 arch/x86/kvm/vmx/vmx.h         | 18 ++++++++++++++++++
 arch/x86/kvm/x86.c             | 18 ++++++++++++++++++
 9 files changed, 66 insertions(+), 21 deletions(-)

-- 
2.39.2

