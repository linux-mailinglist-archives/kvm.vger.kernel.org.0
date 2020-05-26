Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFFF1BB671
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgD1GXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726042AbgD1GXk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:40 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0A0C03C1A9;
        Mon, 27 Apr 2020 23:23:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w65so10167644pfc.12;
        Mon, 27 Apr 2020 23:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Rg/qLxiNVWfFmoRhGooaCspQ06LzLm65xMpP+49aITo=;
        b=bT0f3LxwO8Wi5DI7F28YPePPQo3wDrPpjG6Z7eWzzlW/9SesYyzKkuW37K9Au8//he
         TJydnm3o0UhAtfOXKz+cx0hcQ/z6U2WJjWrGTvkX4fdfdIGH3NEg6JMIlwGW6nZtD2/I
         fVRRAkox95aPwbuubMx74r+vjBUspp77S7AMj3mYFzzd0PYf3o+kHkcxleB7oJeU26NV
         yztRJNbOwq+j/3VsdsxLt/qzuyHTnGH3xj+rZJgbR2QMk2TpVjMqcKF2M+8HKMNmWPzB
         vNOcOew2+OqmKPHvcKdAD788A8XoYm404jF82NdVvWnwGTUJUT7QmR7jzQyNoNJD2LR2
         KQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Rg/qLxiNVWfFmoRhGooaCspQ06LzLm65xMpP+49aITo=;
        b=U7kslQhYc31FKrp9SenphdbWtkb5gwcz4pURCzQMAW8+FNud2L9rhJw8O9Mp8n4LSe
         6p6n84dOnbqcSo/m6iqn/aSHEmibHd1KiWzOgB68gHc2pP80pJ3OI4fJZ2qv+kPUqopq
         Ef/LxRck+L4UzHvgHS1340py2Vi1ELAnB3EpWlXdb1dq+NXwrbsgz6W6oeForpe15C+8
         AG0q36iCL0cQrJxMbr/IRVYB30TCfMKTRhONZOtNNXOfBEaVTEauAlWeEe49tseR2jPk
         47Nhe09me+CWSSlklzitzWOBEMi+OzfAP9tBP75Kgya1UtaVaCRV1YiA3mt4qwCTOfEY
         zCjA==
X-Gm-Message-State: AGi0PuaKwRk5cF3IEUS36AX5iA38EI+ZS9zz/QNkkQudtQVAvPVj1EIM
        xpMvSNDdWBF7bwiV7O3Qz52b0Php
X-Google-Smtp-Source: APiQypKx447iCNYPNvDT17BVFLgzVIFOyg3nZ+i5OqMFjvdBwiERmw/EydV78/66W3kQT5sqS2DBWQ==
X-Received: by 2002:a62:e80e:: with SMTP id c14mr27294464pfi.83.1588055019397;
        Mon, 27 Apr 2020 23:23:39 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 0/7] KVM: VMX: Tscdeadline timer emulation fastpath
Date:   Tue, 28 Apr 2020 14:23:22 +0800
Message-Id: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IPI and Timer cause the main vmexits in cloud environment observation, 
after single target IPI fastpath, let's optimize tscdeadline timer 
latency by introducing tscdeadline timer emulation fastpath, it will 
skip various KVM related checks when possible. i.e. after vmexit due 
to tscdeadline timer emulation, handle it and vmentry immediately 
without checking various kvm stuff when possible. 

Testing on SKX Server.

cyclictest in guest(w/o mwait exposed, adaptive advance lapic timer is default -1):

5540.5ns -> 4602ns       17%

kvm-unit-test/vmexit.flat:

w/o avanced timer:
tscdeadline_immed: 3028.5  -> 2494.75  17.6%
tscdeadline:       5765.7  -> 5285      8.3%

w/ adaptive advance timer default -1:
tscdeadline_immed: 3123.75 -> 2583     17.3%
tscdeadline:       4663.75 -> 4537      2.7%

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>

v3 -> v4:
 * fix bad indentation
 * rename CONT_RUN to REENTER_GUEST
 * rename kvm_need_cancel_enter_guest to kvm_vcpu_exit_request
 * rename EXIT_FASTPATH_CONT_RUN to EXIT_FASTPATH_REENTER_GUEST 
 * introduce EXIT_FASTPATH_NOP 
 * don't squish several stuffs to one patch
 * REENTER_GUEST be introduced with its first usage
 * introduce __handle_preemption_timer subfunction

v2 -> v3:
 * skip interrupt notify and use vmx_sync_pir_to_irr before each cont_run
 * add from_timer_fn argument to apic_timer_expired
 * remove all kinds of duplicate codes

v1 -> v2:
 * move more stuff from vmx.c to lapic.c
 * remove redundant checking
 * check more conditions to bail out CONT_RUN
 * not break AMD
 * not handle LVTT sepecial
 * cleanup codes

Wanpeng Li (7):
  KVM: VMX: Introduce generic fastpath handler
  KVM: X86: Enable fastpath when APICv is enabled
  KVM: X86: Introduce more exit_fastpath_completion enum values
  KVM: X86: Introduce kvm_vcpu_exit_request() helper
  KVM: VMX: Optimize posted-interrupt delivery for timer fastpath
  KVM: X86: TSCDEADLINE MSR emulation fastpath
  KVM: VMX: Handle preemption timer fastpath

 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/lapic.c            | 18 +++++++----
 arch/x86/kvm/svm/svm.c          | 11 ++++---
 arch/x86/kvm/vmx/vmx.c          | 66 +++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/x86.c              | 44 ++++++++++++++++++++-------
 arch/x86/kvm/x86.h              |  3 +-
 virt/kvm/kvm_main.c             |  1 +
 7 files changed, 110 insertions(+), 36 deletions(-)

-- 
2.7.4

