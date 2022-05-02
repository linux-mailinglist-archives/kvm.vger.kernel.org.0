Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16726517AEB
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiEBXmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiEBXmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E73286E8
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:38:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id g12-20020a170902740c00b0015d243ff163so7188805pll.19
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p7us8BZf0fK1RrSD6y3PdjBRGI3gB6CktXng+w8fit8=;
        b=ZFtXfGzbmAJt3k1RJe4no9H5OjZL/uK5Zt0HNoiErHqBqSoz71OwvmHLW6HHVqw48M
         paWxhHQiADMiWxG9eOrAwIBQC3P5UH9RrImw8cdehFtXM2f9n8EtIKfLTRkbxrJr9PEU
         4ZLlSBRYVpIIdBuQkydEN15hsaHS3yUnPpS2fvxI29+3pSLuRbVWf3Y41u1xBWenx6wp
         vyWsjpFOm/HRiJSxLq+QpCk8FME5/qYaynxVkF1pS3LXBPl7vT0SQKDT0vO6n9jOc2uD
         nC3CMP25k+1hU5/c1/VbGvxMJ97eeIjPs2UHXZ/coJ+6t81nleuFA3DCvSNpQnITbLb2
         dQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p7us8BZf0fK1RrSD6y3PdjBRGI3gB6CktXng+w8fit8=;
        b=7HU4hBaHEns7fMcGX2GnHcXpZ59qXcFHDvH9KqymNz2Q0igjaf6N1mNQP83mt1dQwn
         JQccfoPgD0un32C3Vi3DhRDkiyknc3bUY8KZ7Y+UXb18BKi9QI/tApGKckYh4b1EBz5M
         AgcCLLMcagspqdo6WAB5tpzaLyliViY41WwFPIeKccBbk/vhZpt7fxtaUf+ANBJAY4CN
         STPx6YLjBONtVlSClhqsqlR9T4S8fkHwQyI190dlNH1/4tq4sXu+R3e4AcUNiPWxQxKi
         dtKznrJIYqJ/B11oopDX4z0kGJukYapi9RDrZZPBuJiZ0GTRQcSXWF2gBA/ITWN/znRu
         yLvw==
X-Gm-Message-State: AOAM532kTD4++dZIQjlHC9yw2QhuT5/Jp68vd34t2WpI90EyG7MaawsC
        hjGRfrJbEOoYBZH0LCSw7XXAV9wpT0zD
X-Google-Smtp-Source: ABdhPJwf4ixwRgkC/4vK073vja+uTjkR9lkJA8OfzTI/L1mkBxBA/FIGRn2PdKec/lBJjYP3/0OfZfI/OStR
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:e848:b0:15e:ad4f:8cde with SMTP id
 t8-20020a170902e84800b0015ead4f8cdemr4523017plg.60.1651534737969; Mon, 02 May
 2022 16:38:57 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:44 +0000
Message-Id: <20220502233853.1233742-1-rananta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services selection
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Continuing the discussion from [1], the series tries to add support
for the userspace to elect the hypercall services that it wishes
to expose to the guest, rather than the guest discovering them
unconditionally. The idea employed by the series was taken from
[1] as suggested by Marc Z.

In a broad sense, the concept is similar to the current implementation
of PSCI interface- create a 'firmware psuedo-register' to handle the
firmware revisions. The series extends this idea to all the other
hypercalls such as TRNG (True Random Number Generator), PV_TIME
(Paravirtualized Time), and PTP (Precision Time protocol).

For better categorization and future scaling, these firmware registers
are categorized based on the service call owners. Also, unlike the
existing firmware psuedo-registers, they hold the features supported
in the form of a bitmap.

During the VM initialization, the registers holds an upper-limit of
the features supported by each one of them. It's expected that the
userspace discover the features provided by each register via GET_ONE_REG,
and writeback the desired values using SET_ONE_REG. KVM allows this
modification only until the VM has started.

Some of the standard function-ids, such as ARM_SMCCC_VERSION_FUNC_ID,
need not be associated with a feature bit. For such ids, the series
introduced an allowed-list (in kvm_hvc_call_default_allowed()), that holds
all such ids. As a result, the functions that are not elected by userspace,
or if they are not a part of this allowed-list, will be denied for when
the guests invoke them.

Older VMMs can simply ignore this interface and the hypercall services
will be exposed unconditionally to the guests, thus ensuring backward
compatibility.

The patches are based off of mainline kernel 5.18-rc5, with the selftest
patches from [2] applied.

Patch-1 factors out the non-PSCI related interface from psci.c to
hypercalls.c, as the series would extend the list in the upcoming
patches.

Patch-2 sets up the framework for the bitmap firmware psuedo-registers.
It includes read/write support for the registers, and a helper to check
if a particular hypercall service is supported for the guest.
It also adds the register KVM_REG_ARM_STD_HYP_BMAP to support ARM's
standard secure services.

Patch-3 introduces the firmware register, KVM_REG_ARM_STD_HYP_BMAP,
which holds the standard hypervisor services (such as PV_TIME).

Patch-4 introduces the firmware register, KVM_REG_ARM_VENDOR_HYP_BMAP,
which holds the vendor specific hypercall services.

Patch-5,6 Add the necessary documentation for the newly added firmware
registers.

Patch-7 imports the SMCCC definitions from linux/arm-smccc.h into tools/
for further use in selftests.

Patch-8 adds the selftest to test the guest (using 'hvc') and userspace
interfaces (SET/GET_ONE_REG).

Patch-9 adds these firmware registers into the get-reg-list selftest.

[1]: https://lore.kernel.org/kvmarm/874kbcpmlq.wl-maz@kernel.org/T/
[2]: https://lore.kernel.org/all/20220409184549.1681189-1-oupton@google.com/

Regards,
Raghavendra

v6 -> v7:

Addressed the comments by Gavin and Reiji:

- kvm_arm_set_fw_reg_bmap() is optimzed to avoid unnecessary
  serialization of kvm->lock by checking for the KVM_ARCH_FLAG_HAS_RAN_ONCE
  flag or for a bitmap update before taking the lock (Reiji).
- kvm_psci_func_id_is_valid() avoids depending on *vcpu to figure out
  if the PSCI version is 0.1. Instead, it checks the same using KVM_PSCI_FN()
  for range 0 to 3 (Reiji).
- Fixed typos and comments (Gavin). 

v5 -> v6:

Addressed the comments by Marc and Gavin:

- Bitmaps are represented using 'unsigned long' inctead of 'u64' (Marc).
- Replaced the array holding the allowed-list,
  hvc_func_default_allowed_list[], which looked up the func_id using a
  loop, with a switch-case statement (Marc).
- kvm_arm_set_fw_reg_bmap() now always returns -EBUSY for any 'write' of
  the bitmap value after the VM has started running. Documentation is
  adjusted accordingly (Marc).
- kvm_psci_func_id_is_valid() is moved from an inline function to
  kvm/psci.c (Marc).
- Merged ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID into bit-0 of the vendor
  hypervisor firmware register (Gavin).
- Macro optimizations and replace arg0 with arg1 (to comply with KVM
  convention) in hypercalls.c selftest (Gavin).
- Dropped the patch v5 10/10 (Add KVM_REG_ARM_FW_REG(3) to get-reg-list)
  as it was already uploaded by Andrew.
- Fixed typos

v4 -> v5:

Addressed comments by Oliver (thank you!):

- Rebased the series to accommodate ARM_SMCCC_ARCH_WORKAROUND_3
  and PSCI 1.1 changes, and capturing VM's first run.
- Removed the patches related to register scoping (v4 02/13 and
  03/13). I plan to re-introduce them in its own series.
- Dropped the patch that captures VM's first run.
- Moved the bitmap feature firmware registers to its own CORPOC
  space (0x0016).
- Move the KVM_REG_ARM_*_BIT_MAX definitions from uapi header
  to internal header (arm_hypercalls.h).
- Renamed the hypercall descriptor to 'struct kvm_smccc_features',
  and kvm_hvc_call_supported() to kvm_hvc_call_allowed().
- Introduced an allowed-list to hold the function-ids that aren't
  represented by feature-bits.
- Introduced kvm_psci_func_id_is_valid() to check if a given
  function-id is a valid PSCI id, which is used in
  kvm_hvc_call_allowed().
- Introduced KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT as bit-0 of
  KVM_REG_ARM_VENDOR_HYP_BMAP register and
  KVM_REG_ARM_VENDOR_HYP_BIT_PTP is moved to bit-1.
- Updated the arm-smccc.h import to include the definition of
  ARM_SMCCC_ARCH_WORKAROUND_3.
- Introduced the KVM_REG_ARM_FW_FEAT_BMAP COPROC definition to
  get-reg-list selftest.
- Created a new patch to include KVM_REG_ARM_FW_REG(3) in
  get-reg-list.


v3 -> v4

Addressed comments and took suggestions by Reiji, Oliver, Marc,
Sean and Jim:

- Renamed and moved the VM has run once check to arm64.
- Introduced the capability to dynamically modify the register
  encodings to include the scope information.
- Replaced mutex_lock with READ_ONCE and WRITE_ONCE when the
  bitmaps are accessed.
- The hypercalls selftest re-runs with KVM_CAP_ARM_REG_SCOPE
  enabled.

v2 -> v3

Addressed comments by Marc and Andrew:

- Dropped kvm_vcpu_has_run_once() implementation.
- Redifined kvm_vm_has_run_once() as kvm_vm_has_started() in the core
  KVM code that introduces a new field, 'vm_started', to track this.
- KVM_CAP_ARM_HVC_FW_REG_BMAP returns the number of psuedo-firmware
  bitmap registers upon a 'read'. Support for 'write' removed.
- Removed redundant spinlock, 'fw_reg_bmap_enabled' fields from the
  hypercall descriptor structure.
- A separate sub-struct to hold the bitmap info is removed. The bitmap
  info is directly stored in the hypercall descriptor structure
  (struct kvm_hvc_desc).

v1 -> v2

Addressed comments by Oliver (thanks!):

- Introduced kvm_vcpu_has_run_once() and kvm_vm_has_run_once() in the
  core kvm code, rather than relying on ARM specific
  vcpu->arch.has_run_once.
- Writing to KVM_REG_ARM_PSCI_VERSION is done in hypercalls.c itself,
  rather than separating out to psci.c.
- Introduced KVM_CAP_ARM_HVC_FW_REG_BMAP to enable the extension.
- Tracks the register accesses from VMM to decide whether to sanitize
  a register or not, as opposed to sanitizing upon the first 'write'
  in v1.
- kvm_hvc_call_supported() is implemented using a direct switch-case
  statement, instead of looping over all the registers to pick the
  register for the function-id.
- Replaced the register bit definitions with #defines, instead of enums.
- Removed the patch v1-06/08 that imports the firmware register
  definitions as it's not needed.
- Separated out the documentations in its own patch, and the renaming
  of hypercalls.rst to psci.rst into another patch.
- Add the new firmware registers to get-reg-list KVM selftest.

v1: https://lore.kernel.org/kvmarm/20211102002203.1046069-1-rananta@google.com/
v2: https://lore.kernel.org/kvmarm/20211113012234.1443009-1-rananta@google.com/
v3: https://lore.kernel.org/linux-arm-kernel/20220104194918.373612-1-rananta@google.com/
v4: https://lore.kernel.org/lkml/20220224172559.4170192-1-rananta@google.com/
v5: https://lore.kernel.org/lkml/20220407011605.1966778-1-rananta@google.com/
v6: https://lore.kernel.org/kvmarm/20220423000328.2103733-1-rananta@google.com/

Raghavendra Rao Ananta (9):
  KVM: arm64: Factor out firmware register handling from psci.c
  KVM: arm64: Setup a framework for hypercall bitmap firmware registers
  KVM: arm64: Add standard hypervisor firmware register
  KVM: arm64: Add vendor hypervisor firmware register
  Docs: KVM: Rename psci.rst to hypercalls.rst
  Docs: KVM: Add doc for the bitmap firmware registers
  tools: Import ARM SMCCC definitions
  selftests: KVM: aarch64: Introduce hypercall ABI test
  selftests: KVM: aarch64: Add the bitmap firmware registers to
    get-reg-list

 Documentation/virt/kvm/api.rst                |  16 +
 Documentation/virt/kvm/arm/hypercalls.rst     | 135 +++++++
 Documentation/virt/kvm/arm/psci.rst           |  77 ----
 arch/arm64/include/asm/kvm_host.h             |  16 +
 arch/arm64/include/uapi/asm/kvm.h             |  16 +
 arch/arm64/kvm/arm.c                          |   1 +
 arch/arm64/kvm/guest.c                        |  10 +-
 arch/arm64/kvm/hypercalls.c                   | 325 ++++++++++++++++-
 arch/arm64/kvm/psci.c                         | 186 +---------
 include/kvm/arm_hypercalls.h                  |  17 +
 include/kvm/arm_psci.h                        |   9 +-
 tools/include/linux/arm-smccc.h               | 193 ++++++++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      |   8 +
 .../selftests/kvm/aarch64/hypercalls.c        | 336 ++++++++++++++++++
 16 files changed, 1078 insertions(+), 269 deletions(-)
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c

-- 
2.36.0.464.gb9c8b46e94-goog

