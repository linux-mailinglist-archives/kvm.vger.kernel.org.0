Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487A46DB51A
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 22:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjDGUTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 16:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjDGUTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 16:19:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3602B170D
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 13:19:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54ed65e1fe0so11305447b3.18
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 13:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680898787; x=1683490787;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GJQMWpvn8MVU8sNDXW5eTLeruYhzG+Ay4iiSsRa6PWQ=;
        b=jEiQebudI/8hsSRlocLarfn/xkRFCxpYqPvHtoha3Hl+wF+TJpDQ05DC3RXdBygwSp
         rsryuYUExNymDw1GYNOvnTjR0tFtZE6TJSkkVeej2ZKZkVOdBKwWHBaqUrd5PVyMnDy1
         i/5C3jCCyg/vNG7LrqWT5naKwBBPljkhlfT6/Uy7dZK2T4LB++JFJxXD3B7i30O0v0rX
         in/FSgxZfBmtVD7Df8CXP/XI0LW9uFdRx/dmqTKnw8bpW3iyOj4tDobgaUMPbV2zau9p
         QAmVMue1KLby4Kq40/h8QCBz2N1Apw8C7W97lArdoFwfD76FKE5wWd8S81iV7ZIY47h2
         nu8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680898787; x=1683490787;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GJQMWpvn8MVU8sNDXW5eTLeruYhzG+Ay4iiSsRa6PWQ=;
        b=t0UtTY5VYhz/8GQSZmP5sAcaT5VXL8bpmUqW1H9r2Uah8VWeeUP1gY1rqkSbvsffRC
         dyqI6jkvvnIKdD6rPG97PDtdeAeJ/z+HQnksSbaP+R4thHaWxfoQIH1pUzIrAn+heYOl
         2oRwDo2hZ22ZuWb30NaoWgz9UzeVXrGXcz3b46l30RD+VSQWN2+/0pPaUqlLuRwA0Tfp
         5PiJ6W/2b8ElHtT9APBkd6lWAVi12vRK4+DJUveTkWe/A/KSRfBEWo9qBpvRQ2kzDZ1j
         L5nFw7MqLNj+yi1jjqZVCxeHQKgbi51akQLl/RHLGYbMsB7ffKlvvV5CvrQeBzhd1GTJ
         f4ng==
X-Gm-Message-State: AAQBX9cAO9yIC82FDLPfZwwPiDfsx1YXSR+ZG/Bc+U4A9twsNrKT9Rw7
        L4WAXuqn7PoTNT7gDav4AzpkJEqVhc+0GLcZ7PsDlia0WiajSmNGp7efGCLzYEm2P7P/IbBrQic
        wXBj3EilFQ2nHHAaT9KSSSNT/7+Bl4hWKKlCgp7xcvpvS617nTAKjcKE=
X-Google-Smtp-Source: AKy350YYinBGf1TxiXyHxTA9ZuGbVR3aG35VgJ6mUfyDNtndvmIONMWL9+70TP2pVQ8ccPOCgSTPInSWeQ==
X-Received: from sagi.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:241b])
 (user=sagis job=sendgmr) by 2002:a25:d6c8:0:b0:b8b:fd23:5028 with SMTP id
 n191-20020a25d6c8000000b00b8bfd235028mr2415459ybg.3.1680898787294; Fri, 07
 Apr 2023 13:19:47 -0700 (PDT)
Date:   Fri,  7 Apr 2023 20:19:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407201921.2703758-1-sagis@google.com>
Subject: [RFC PATCH 0/5] Add TDX intra host migration support
From:   Sagi Shahar <sagis@google.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sagi Shahar <sagis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset adds support for TDX intra host migration using the same
API which was added for SEV intra host migration here:
https://lore.kernel.org/all/20211021174303.385706-1-pgonda@google.com/

This patchset relies on the latest TDX patches from Intel:
- fd-based approach for supporing KVM v10 and
  https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
- TDX host kernel support v10
  https://lore.kernel.org/lkml/cover.1678111292.git.kai.huang@intel.com/
- KVM TDX basic feature support v13
  https://lore.kernel.org/cover.1678643051.git.isaku.yamahata@intel.com

The tree can be found at https://github.com/googleprodkernel/linux-cc/tree/copyless
and is based on Intel's tdx tree at https://github.com/intel/tdx/tree/kvm-upstream

In the TDX case, we need to transfer the VM state from multiple sources:

 * HKID and encrypted VM state is transfered between the kvm_tdx
   objects.
 * Encrypted and runtime state is transfered between the vcpu_tdx
   objects.
 * The EPT table backing TD's private memory is transfered at the
   kvm-mmu level. This is needed since the secure EPT table managed by
   the TD module remains the same after the migration so moving the
   current private EPT table eliminates the need to rebuild the private
   EPT table to match the secure EPT table on the destination.
 * Information regarding the current shared/private memory is trasfered
   using the mem_attr_array stored at the kvm object.
 * Additional information derived from shared/private memory state is
   trasfered at the memslot level.

Tested with selftests locally. I will attach the self test in the next
version after we send the new TDX selftest framework patches based on
KVM TDX basic feature support v13.

Sagi Shahar (5):
  KVM: Split tdp_mmu_pages to private and shared lists
  KVM: SEV: Refactor common code out of sev_vm_move_enc_context_from
  KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
  KVM: TDX: Implement moving private pages between 2 TDs
  KVM: TDX: Add core logic for TDX intra-host migration

 arch/x86/include/asm/kvm_host.h |   5 +-
 arch/x86/kvm/mmu.h              |   2 +
 arch/x86/kvm/mmu/mmu.c          |  60 ++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  88 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h      |   3 +
 arch/x86/kvm/svm/sev.c          | 175 +++--------------------
 arch/x86/kvm/vmx/main.c         |  10 ++
 arch/x86/kvm/vmx/tdx.c          | 245 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |   2 +
 arch/x86/kvm/vmx/x86_ops.h      |   5 +
 arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++
 arch/x86/kvm/x86.h              |  16 +++
 12 files changed, 613 insertions(+), 164 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

