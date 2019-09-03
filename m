Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09533A7632
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfICVbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:05 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:48523 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfICVbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:05 -0400
Received: by mail-pg1-f201.google.com with SMTP id k20so11782958pgg.15
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MNNoUj0yiKrEjTSWIR60vCalOW1RbGBXgGVWJVh28ZA=;
        b=AWmpGcRKO36jo2bj7ZIyU/+NzIqmwafszrEN5L7jtZy/MGwkSsBF3BUw8KjTX58UpY
         leCtEeSjum2vPgyH93fBelvRPyk8MABMwmz+CDk3elCTrWbMQ+NywW+oKYw30J5QCj5s
         K8mfwwiIRo/qQ90YBdV1mZen5rmfvxpRyKEUxUnw6GaEb21JQtu4xle+InUlFWQ1/uPm
         qkPjmL3omXUCT4NhO6Nf9TCQj3Bt89YvbYHIfsPHu1zXH0p8q7vwcDgEob4HVPWqXUiH
         JuHk4VUlOGJhmFLKAOhEBsq8jb8qOS3TSRa4fIuNGJEsnMZT3sXtEeXIp5mzPWUU3Crb
         IVrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MNNoUj0yiKrEjTSWIR60vCalOW1RbGBXgGVWJVh28ZA=;
        b=eqJQfgif6Jr+0PhuTs+Sr3DC07BNNl491qYPFwrH1U/jhICqlS+d7zZk0VijU8IZIR
         dIzN+HTwj5Cotl++ZHzf3nux1JTpdqkVJ32yEeA3lNGDMb9v6aRYe1Fs+OGJRi4vFxGW
         7iG4q96TldWg5NCIFdb2FDW7z9XM5a85ArhdvkwI73YpZyc4uQHGEXjbZ+zNHxoZoC9F
         fszNVdfxN1PpMsL07IVxY4emICw5DWJWMZLYV4ywEXB8ij9dMtYxm/xBC5i9cvFnwYxU
         i0LUS2yocNjgfDYvZtR/o/TGx7bsM9Bqk8xFHsMcaY+ujmhHt3ohA5eiYF3VpWDSQN7x
         PFYA==
X-Gm-Message-State: APjAAAXLPJy1LWLT8or4oNBwFsOjep9bXzE5/eakHhngeO5U8Cf5snZo
        8IKmmybpMDDOtdskw4ZBvb1+9DIKMR11EiFB2kBuYJUhMpYS69IOqQlKsNMsjtLSxRBaNmtGaCg
        L5EUHVV57oT75aJfOKTHCqVsCetlqqJN21zYdQsEdq0D1P9jNwjudCrIJ4A==
X-Google-Smtp-Source: APXvYqzsPDG5yRDY2mIu2Q53uzy6eAttRtMmdjKJQZZDxaw04GwhhEyQ4/UF1irOGfHJe8PRY9JgeGOcYN4=
X-Received: by 2002:a63:d002:: with SMTP id z2mr32959196pgf.364.1567546264275;
 Tue, 03 Sep 2019 14:31:04 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:36 -0700
Message-Id: <20190903213044.168494-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 0/8] KVM: VMX: Add full nested support for IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[v1] https://lore.kernel.org/r/20190828234134.132704-1-oupton@google.com

v1 => v2:
 - Add Krish's Co-developed-by and Signed-off-by tags.
 - Fix minor nit to kvm-unit-tests to use 'host' local variable
   throughout test_load_pgc()
 - Teach guest_state_test_main() to check guest state from within nested
   VM
 - Update proposed tests to use guest/host state checks, wherein the
   value is checked from MSR_CORE_PERF_GLOBAL_CTRL.
 - Changelog line wrapping

This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nested
VM-entry and VM-exit. There already was some existing code that supported
the VM-exit ctrl, though it had an issue and was not exposed to the guest
anyway. These patches are based on the original set that Krish Sadhukhan
sent out earlier this year.

Purpose of each patch:

(1) Change the existing code that implemented the VM-exit functionality
    to use kvm_set_msr() to avoid being overwritten by
    atomic_perf_switch_msrs().
(2) Update prepare_vmcs02() to implement the VM-entry functionality,
    again using kvm_set_msr().
(3) Create a helper function for checking the validity of an
    IA32_PERF_GLOBAL_CTRL value against pmu->global_ctrl_mask.
(4) Check guest state on VM-entry as described in the SDM.
(5) Check host state on VM-entry as described in the SDM.
(6) Expose the "load IA32_PERF_GLOBAL_CTRL" VM-entry and VM-exit
    controls if IA32_PERF_GLOBAL_CTRL is a valid MSR.
(7) Modify guest_state_test_main() to check guest state MSRs
(8) Tests in kvm-unit-tests to check the VM-entry and VM-exit controls
    work properly

Oliver Upton (6):
  KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on vmexit
  KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vm-entry
  KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
  KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
  KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
  KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm control if supported

 arch/x86/kvm/pmu.h           |  6 ++++++
 arch/x86/kvm/vmx/nested.c    | 37 +++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
 arch/x86/kvm/vmx/vmx.c       | 21 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  1 +
 5 files changed, 66 insertions(+), 4 deletions(-)

-- 
2.23.0.187.g17f5b7556c-goog

