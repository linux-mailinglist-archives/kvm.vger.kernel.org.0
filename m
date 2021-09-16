Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C173140EA69
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345072AbhIPS5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245557AbhIPS53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:29 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E447C04A154
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:42 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e8-20020a0cf348000000b0037a350958f2so63297015qvm.7
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Pe7x0KqNWpd27U8B0VgFmhUlzq7CaBZRDC7FTGm6BYo=;
        b=c/zDfdFNoGgGDawStlpHk9tXybqTTvO3qklooPCSh2RZyn1jO926yAJN3EkzROcnWV
         +7Jv8frVlp+AjiKuCpYLQYVNhudtlSi3aG5XE0qVftcRBxmfkVHYUFK2g3I/ufLuYsD5
         yXWxHrl/35QQy9F3h5xRX4vnkMen65DAtcmDUlpWA2jh2qYxeZTWx7cuJq7rLgB37IjF
         FR1hGU1oD+z2TrGqXS1Hb1S8jn7kM7JHUntQZubO19eBArz72mowND7VvAXe/MPZogEM
         wCS3fOC64SO9FdoDCKIccrMyRTFwuxu7FOoW75kCgb27aM9H/lW5xEtfwu2ZTfFFx8KR
         /M9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Pe7x0KqNWpd27U8B0VgFmhUlzq7CaBZRDC7FTGm6BYo=;
        b=ud4Sm5W+LUrcoBjrVG6hAFsJef1qVJGgN6oC4TWM0KomG4x5w88yyP5Kig6u2kFIOq
         sy6n8WkecWBiDLlNP3XKNjEzmXGF8BagGGriUGdOvlV6i+A3EeTQaLFDIBU98NZmVt3y
         YusDG4nkevrSHV3G3sKXWA8C91KDt+2BLXL/QjGzaqiWuJNRp//r6ovLgM+w2PQdI/+u
         44uWfrhwlTRWZjvOY037Lw5vRSSwfQhSRRoAubq4qxLS7OxvmzhC9Isk5Suz6EwWFoHv
         K4GvFff13xrJnubmq6JvCxFxHCkrqJgJCqqiZkY+STNeWSsIM947+EGRbXGoFFgFnfCa
         J4qw==
X-Gm-Message-State: AOAM533o5OGBHNOZY4HRFnzLO/ZGOG9axEmzQB/NpuRSYbEge7GTw/Zh
        oJPZ00+cUYzb7lYAtzhW6I7Y0H2QQ5WQNovNA4O+Igf7wCYPLoP+XeeNTFE0t4qbKGVWTWX7Xzd
        dZNn5QPzPQ1U91s5xpFJZdvnMZ/kOCtux4XQfgLc5JKLY9MJgAy+0O+21Bg==
X-Google-Smtp-Source: ABdhPJyvIbX+FueQ86OOu11wGIo24Yj/vbCnWhhfcLYDpB8XPsQIlfG3Y+cSd9yAQkcLoDzHF5ajFaxNvtk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:9146:: with SMTP id q64mr6704127qvq.38.1631816141556;
 Thu, 16 Sep 2021 11:15:41 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:31 +0000
Message-Id: <20210916181538.968978-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 0/7] KVM: x86: Add idempotent controls for migrating system
 counter state
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM's current means of saving/restoring system counters is plagued with
temporal issues. On x86, we migrate the guest's system counter by-value
through the respective guest's IA32_TSC value. Restoring system counters
by-value is brittle as the state is not idempotent: the host system
counter is still oscillating between the attempted save and restore.
Furthermore, VMMs may wish to transparently live migrate guest VMs,
meaning that they include the elapsed time due to live migration blackout
in the guest system counter view. The VMM thread could be preempted for
any number of reasons (scheduler, L0 hypervisor under nested) between the
time that it calculates the desired guest counter value and when
KVM actually sets this counter state.

Despite the value-based interface that we present to userspace, KVM
actually has idempotent guest controls by way of the TSC offset.
We can avoid all of the issues associated with a value-based interface
by abstracting these offset controls in a new device attribute. This
series introduces new vCPU device attributes to provide userspace access
to the vCPU's system counter offset.

Patches 1-2 are Paolo's refactorings around locking and the
KVM_{GET,SET}_CLOCK ioctls.

Patch 3 cures a race where use_master_clock is read outside of the
pvclock lock in the KVM_GET_CLOCK ioctl.

Patch 4 adopts Paolo's suggestion, augmenting the KVM_{GET,SET}_CLOCK
ioctls to provide userspace with a (host_tsc, realtime) instant. This is
essential for a VMM to perform precise migration of the guest's system
counters.

Patch 5 does away with the pvclock spin lock in favor of a sequence
lock based on the tsc_write_lock. The original patch is from Paolo, I
touched it up a bit to fix a deadlock and some unused variables that
caused -Werror to scream.

Patch 6 extracts the TSC synchronization tracking code in a way that it
can be used for both offset-based and value-based TSC synchronization
schemes.

Finally, patch 7 implements a vCPU device attribute which allows VMMs to
get at the TSC offset of a vCPU.

This series was tested with the new KVM selftests for the KVM clock and
system counter offset controls on Haswell hardware. Kernel was built
with CONFIG_LOCKDEP given the new locking changes/lockdep assertions
here.

Note that these tests are mailed as a separate series due to the
dependencies in both x86 and arm64.

Applies cleanly to 5.15-rc1

v8: http://lore.kernel.org/r/20210816001130.3059564-1-oupton@google.com

v7 -> v8:
 - Rebased to 5.15-rc1
 - Picked up Paolo's version of the series, which includes locking
   changes
 - Make KVM advertise KVM_CAP_VCPU_ATTRIBUTES

Oliver Upton (4):
  KVM: x86: Fix potential race in KVM_GET_CLOCK
  KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
  KVM: x86: Refactor tsc synchronization code
  KVM: x86: Expose TSC offset controls to userspace

Paolo Bonzini (3):
  kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
  KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to separate functions
  kvm: x86: protect masterclock with a seqcount

 Documentation/virt/kvm/api.rst          |  42 ++-
 Documentation/virt/kvm/devices/vcpu.rst |  57 +++
 arch/x86/include/asm/kvm_host.h         |  12 +-
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 458 ++++++++++++++++--------
 include/uapi/linux/kvm.h                |   7 +-
 6 files changed, 419 insertions(+), 161 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

