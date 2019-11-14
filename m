Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83F0FBCE9
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKNARe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:34 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:56414 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfKNARe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:34 -0500
Received: by mail-pg1-f201.google.com with SMTP id 11so3112637pgm.23
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GTIC95OO8wyHkXq89RvQsalRu9vquP6LSLQDB4RTONs=;
        b=Txi9mR2pTU0pZCkosjcm1DVX9yWJYOo+4X64OW5Gm+J6WOPI1Or+0giA7VVJQ3ERUK
         7wM2OoHOR+d4B1/r+DLzWAXy9/veatXdlJXVJ0El8qSGCNxGQZTmwKl6948XUrnZGla8
         MQpOMbT0M7a8GI48LmfCA2qm4HZjhE2eYkRwWXye9Qoor413Vw6O7wZKXB7YYlTWbKtz
         IkRmy+R9mJAAPjlEEzDO9MiFD6YHmDcQ/f3RWZnCGtlc5G5jv/bv6b0hmlzo9X2j/lW1
         +gJIQYRgui7iiszSbCJtZ1GgWjnr0mBhEgwyNUMG8UHnBcg8KEjwOzYHyiN0WPhOYAc3
         lt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GTIC95OO8wyHkXq89RvQsalRu9vquP6LSLQDB4RTONs=;
        b=lPzUzex6ZXN5mo1KqnALHnfdNQYE+4pV23DXJMhnafIBle/ephiOv7HVtytJUSns4O
         Z492s/FvyKreyDmzB6kgQbUMkG75/v4MsUg7DzYmRKCUWdx2G6RnqSj+y8pG4OTzRxDl
         j+PAS/iyIj3YhsTXehz0USP14LyS+6gqR8LwmZALD1OntH69W1aUREPxsxxi3rDIY2Bk
         MxbL6NY4goZ/D6mi48IEBzkz5q81pDgfhys6n56Wf3L/vcif/mt3lkJtARDopkj+j9j+
         hFJl0T8YPjtXdWCE5+ORRVEjDz5DYWGkpPC7EOlqn4hXbyr7hPb7NC2e+M6vNWO3/NhY
         jyxQ==
X-Gm-Message-State: APjAAAVQRLi1SgiHGceDpBpLWhFEhuIv/ttlkRsLUD1n8GkfkUEckb2K
        jNbk8uUuxsE4CHu8HbNqsYuo6VJZxEFB64XjCyTzkffV7eEDVDGcuHIsg+V3D1lZBlWkYUEOOer
        onPlQ66foAQ1M4V3hx5WD5sIwsox6H6otqa2CnxTsmB4ozy7bYZy1RLcXLA==
X-Google-Smtp-Source: APXvYqyYaQFXSRef/kiz4OUzE0JH+kQxyotZdTTl1c8PG92NUXU/fM8iRZ1aADSA3xufuFYRWe5GxV4eMLk=
X-Received: by 2002:a63:b20f:: with SMTP id x15mr6707598pge.65.1573690651517;
 Wed, 13 Nov 2019 16:17:31 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:14 -0800
Message-Id: <20191114001722.173836-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 0/8] KVM: nVMX: Add full nested support for "load
 IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit} control
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
[v2] https://lore.kernel.org/r/20190903213044.168494-1-oupton@google.com
[v3] https://lore.kernel.org/r/20190903215801.183193-1-oupton@google.com
[v4] https://lore.kernel.org/r/20190906210313.128316-1-oupton@google.com

v1 => v2:
 - Add Krish's Co-developed-by and Signed-off-by tags.
 - Fix minor nit to kvm-unit-tests to use 'host' local variable
   throughout test_load_pgc()
 - Teach guest_state_test_main() to check guest state from within nested
   VM
 - Update proposed tests to use guest/host state checks, wherein the
   value is checked from MSR_CORE_PERF_GLOBAL_CTRL.
 - Changelog line wrapping

v2 => v3:
 - Remove the value unchanged condition from
   kvm_is_valid_perf_global_ctrl
 - Add line to changelog for patch 3/8

v3 => v4:
 - Allow tests to set the guest func multiple times
 - Style fixes throughout kvm-unit-tests patches, per Krish's review

v4 => v5:
 - Rebased kernel and kvm-unit-tests patches
 - Reordered and reworked patches to now WARN on a failed
   kvm_set_msr()
 - Dropped patch to alow resetting guest in kvm-unit-tests, as the
   functionality is no longer needed.

This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nested
VM-entry and VM-exit. There already was some existing code that supported
the VM-exit ctrl, though it had an issue and was not exposed to the guest
anyway. These patches are based on the original set that Krish Sadhukhan
sent out earlier this year.

Oliver Upton (6):
  KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control
  KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry
  KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on VM-Exit
  KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-Entry
  KVM: nVMX: Check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
  KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL

 arch/x86/kvm/pmu.h           |  6 ++++++
 arch/x86/kvm/vmx/nested.c    | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/nested.h    |  1 +
 arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-

-- 
2.23.0.187.g17f5b7556c-goog

