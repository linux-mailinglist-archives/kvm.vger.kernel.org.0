Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32BDFA0E51
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfH1Xli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:38 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:47735 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfH1Xli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:38 -0400
Received: by mail-qt1-f201.google.com with SMTP id v16so1505972qtp.14
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=55LG9o0K/Z79bWNiEbFGpI4D7GLYB+RNqYG5023eeWs=;
        b=LWRY/rbEqwEm2i41s0DY9EKKGIgoFOwG+s5CMQVctDRWRFj/DeiM8j9VypwR9K3iJj
         BveWLNT2IH5abn9di6VJxYgNVE5g0oGNYawdLXJQ9rSZB6t/pyJreRSNNdom8wOGlVlO
         HFLCAEvnyAcqI0MxUlKFzqFLEsEudb1lc+gygZrLxQwj/fO5P3vR+0n23U8Sj7k+OLM4
         Dasmn0s8ixAmDv1zo0egQfi9WYERjOC4g0eXHz9xXAJfzhTaqJ1xkbCSDSOOGTAgJe8T
         6HjQnXtD1DpvxDHlI5JC72B25SXG2lfcQ/ULicRIfYhMD7Z0V5DNqmGpHvYqWX5ic+F7
         p4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=55LG9o0K/Z79bWNiEbFGpI4D7GLYB+RNqYG5023eeWs=;
        b=XpecL9UF72KT/18hBNXVlLFLCx2HPN1CDQJLQ1rtV82Z/P3/l2I85bwdnXB6+oG1b0
         Nb92b6cMfZXLmZwbyy5j5c0W914zoBdikE4SFFeo+ZYnw3L7L3qPKDF0REU01xjgsFN3
         03sXKyMAPliuQqM6Ia7YhZOSSW0agQ+itgGacDLfriL7XYTCP7W3pdd0xp3z0bqEkyAa
         /KIPp+/Sov3UlKeBgMLYCUzFmaWnBRj7VF/trY2KLSiywk43NevaD+V3yvkSOoRYVb8W
         Q0WIBsYCda2josN7A+lzI3xaMrsXeClzHIVhoFZf68TzN9lNWUnxJGwvRHlfrKEv3K3X
         IK5A==
X-Gm-Message-State: APjAAAW3zHne7gc+Rrj3CZMFEAOREwEPnqOlb39ENOFrIRouoYFYmJY0
        B7Pt1R0KgbP4moGx8KCTp1Ber5cdLQ7schR/ihC2VPlDeOUCnOLedAgc8eUGQWrEz5YuDyt0UVb
        /9djETqdQnMI40rpwIlDe933lCx5QFUdygjATKxNJzpV9oQRMWwhaq5MV5Q==
X-Google-Smtp-Source: APXvYqxlbZcwU0k3/0/Yz1tOUefRsteJp46eRdRrpf4HtlJbTXtrPdMv7H0OmRq0DwUhrtsrtSDiZnKQSAw=
X-Received: by 2002:aed:22d3:: with SMTP id q19mr7246521qtc.101.1567035697460;
 Wed, 28 Aug 2019 16:41:37 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:27 -0700
Message-Id: <20190828234134.132704-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 0/7] KVM: VMX: Add full nested support for IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nested
VM-entry and VM-exit. There already was some existing code that supported the
VM-exit ctrl, though it had an issue and was not exposed to the guest
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
(7) Tests in kvm-unit-tests to check the VM-entry and VM-exit controls
    work properly



Oliver Upton (6):
  KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on vmexit
  KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on vmentry
  KVM: VMX: Add helper to check reserved bits in
    MSR_CORE_PERF_GLOBAL_CTRL
  KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
  KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-entry
  KVM: nVMX: Enable load IA32_PERF_GLOBAL_CTRL vm control if supported

 arch/x86/kvm/pmu.h           | 11 +++++++++++
 arch/x86/kvm/vmx/nested.c    | 35 ++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/pmu_intel.c |  3 +++
 arch/x86/kvm/vmx/vmx.c       | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  1 +
 5 files changed, 68 insertions(+), 3 deletions(-)

-- 
2.23.0.187.g17f5b7556c-goog

