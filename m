Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983E91EB1A7
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFAWYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 18:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgFAWYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 18:24:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25F6C061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 15:24:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e192so12762554ybf.17
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 15:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ye6V+VSMQvB/FIQh5FZ01Cn8NyhcIOXA1Edk2Rr6mbY=;
        b=Pt/xGBDn0hxL0F+ixV9e9vHUk+xSRevJbeOVlvessSErPIQJrU3aGGITJYzkck0l42
         uS3HfpvPCSMSUo8yl5RH9QYzED8SFerWM0RqnVqcKgbruuSLtczcgL97i9ihcMEVZ4CG
         1aYbrkwXzB5sx4sVOucRg065kbLJ5WvqJ3a7DTC2r1Szrr0EhNDLnWgDo5fBb0AdyEsw
         XytNQ90mN8LFlXq2bpwdIlszr4MQS1GrN/vj4N0glkOpu9maHpOB4i6XFyJcIxLRlbR6
         XaVqwgxvgMm16Fqji1pOrEyWaJ7ql9GR0gVz+Var+CLqef9L3/ICy9hB5kFZaDE2DxmV
         PfZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ye6V+VSMQvB/FIQh5FZ01Cn8NyhcIOXA1Edk2Rr6mbY=;
        b=hHdbLCOZai6g9RPvic3h90qeP4BIt3m2xKBWvE/alBP5nUE3532pAcB3ta/fBmenbn
         KhjVHoDv7y3e+SgY3/jYr5r0avNdtkhPwklrijiJh5QpXvQ4cmQCgz8nzQgfXyVgoFti
         WOrcy8uqeIwhARh11l3C8Qhi9lR8gNoMveksfYaCMGGIG3UlCrP7tgMpUEduFYfzrMaT
         y/W3pQbgc5pemv2jINhuBpCUnXQGkkhg9UR4gJCe4Y+2B1z0yeh71eFUNrUOuJRXHF2j
         GGo2PjOUf8tSiZHI6tSAUSEO5zoIOWlCCRKV9OmS4zELIYwGqgDDmb0m61TrvbAGkjAi
         TRMA==
X-Gm-Message-State: AOAM530DPiwQR9aucaYvwy1BDqIsQe/+y8b1stLAmNkHq66Qh1VSHoHl
        XKiTOfagkmbeftlJt0ZJOdqBL9NSdmQDsr9hJ5pk9EIYZo5kFzXiPOOpYsyk3fbTeK9sRDrejTp
        5AcYMUYV9q0eSpOF5ANod8CvCljRSpO4ocRoEtDhwNXjFyaxT/vB3JOmkl+LEIig=
X-Google-Smtp-Source: ABdhPJx5P1exhMFaoXrN/utbnODDyX3+7HjSG5R4PS9kA/jvoPQTYI89wGznPer/ds4Hhf/p+H08XJtVA2NJpQ==
X-Received: by 2002:a25:eb05:: with SMTP id d5mr16241511ybs.12.1591050260926;
 Mon, 01 Jun 2020 15:24:20 -0700 (PDT)
Date:   Mon,  1 Jun 2020 15:24:12 -0700
Message-Id: <20200601222416.71303-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH v3 0/4] Add logical CPU to KVM_EXIT_FAIL_ENTRY info
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's been about 6 months since v2. Sorry for the delay. Initially, this
was a single patch to add information to KVM_EXIT_FAIL_ENTRY to help
identify a defective CPU. It has gotten a little more complicated,
since Peter Shier pointed out that the vCPU thread may have migrated
between the time of failure and the KVM exit. Fortunately, the SEV folks
started to make the necessary information available with "last_cpu," but
only on AMD and only with SEV. The current version expands upon that by
making "last_cpu" available in all configurations on AMD and Intel.

v2: Use vcpu->cpu rather than raw_smp_processor_id() (Liran).
v3: Record the last logical processor to run the vCPU thread (Peter).
    Add the "last CPU" information to KVM_EXIT_INTERNAL_ERROR exits as
    well as KVM_EXIT_FAIL_ENTRY [except for "EMULATION" errors].
    (Liran & Paolo).

Jim Mattson (4):
  kvm: svm: Prefer vcpu->cpu to raw_smp_processor_id()
  kvm: svm: Always set svm->last_cpu on VMRUN
  kvm: vmx: Add last_cpu to struct vcpu_vmx
  kvm: x86: Add "last CPU" to some KVM_EXIT information

 Documentation/virt/kvm/api.rst |  1 +
 arch/x86/kvm/svm/sev.c         |  1 -
 arch/x86/kvm/svm/svm.c         | 14 +++++++-------
 arch/x86/kvm/vmx/vmx.c         | 11 +++++++++--
 arch/x86/kvm/vmx/vmx.h         |  3 +++
 arch/x86/kvm/x86.c             |  1 +
 include/uapi/linux/kvm.h       |  2 ++
 7 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.27.0.rc2.251.g90737beb825-goog

