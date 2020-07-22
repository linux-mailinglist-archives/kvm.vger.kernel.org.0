Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C825E229C81
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgGVQBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:36 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37814 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726349AbgGVQBf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:35 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D913A3016E60;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CC0553072784;
        Wed, 22 Jul 2020 19:01:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v1 00/34] VM introspection - EPT Views and Virtualization Exceptions
Date:   Wed, 22 Jul 2020 19:00:47 +0300
Message-Id: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series is based on the VM introspection patches
(https://lore.kernel.org/kvm/20200721210922.7646-1-alazar@bitdefender.com/),
extending the introspection API with EPT Views and Virtualization
Exceptions (#VE) support.

The purpose of this series is to get an initial feedback and to see if
we are on the right track, especially because the changes made to add
the EPT views are not small (even if they add support only for different
access rights for now, not for different content).

One use case for these extensions is to run a guest agent, isolated in
another EPT view and using Virtualization Exceptions (#VE), to reduce
the number of VM-Exits caused by EPT violations.

Another case for EPT views is to single-step one vCPU on a different view
(with more relaxed page access restrictions) while all the others run
on a main/restricted view.

Patches 1-11 make preparatory changes for EPT views.

Patches 12-19 extend the VM introspection API with EPT-views related
commands and data. The Get/Set/Control EPT view commands are added,
the KVMI_VM_SET_PAGE_ACCESS command and the vCPU introspection events
are extended with the EPT view.

Patches 20-30 make preparatory changes for #VE.

Patches 31-34 extend the VM introspection API with #VE related commands.

Adalbert Lazăr (2):
  KVM: x86: mmu: reindent to avoid lines longer than 80 chars
  KVM: introspection: mask out non-rwx flags when reading/writing
    from/to the internal database

Marian Rotariu (5):
  KVM: x86: export .get_vmfunc_status()
  KVM: x86: export .get_eptp_switching_status()
  KVM: x86: mmu: add support for EPT switching
  KVM: x86: add .set_ept_view()
  KVM: x86: vmx: add support for virtualization exceptions

Sean Christopherson (2):
  KVM: VMX: Define EPT suppress #VE bit (bit 63 in EPT leaf entries)
  KVM: VMX: Suppress EPT violation #VE by default (when enabled)

Ștefan Șicleru (25):
  KVM: x86: add kvm_get_ept_view()
  KVM: x86: mmu: add EPT view parameter to kvm_mmu_get_page()
  KVM: x86: mmu: increase mmu_memory_cache size
  KVM: x86: add .control_ept_view()
  KVM: x86: page track: allow page tracking for different EPT views
  KVM: x86: mmu: allow zapping shadow pages for specific EPT views
  KVM: introspection: extend struct kvmi_features with the EPT views
    status support
  KVM: introspection: add KVMI_VCPU_GET_EPT_VIEW
  KVM: introspection: add 'view' field to struct kvmi_event_arch
  KVM: introspection: add KVMI_VCPU_SET_EPT_VIEW
  KVM: introspection: add KVMI_VCPU_CONTROL_EPT_VIEW
  KVM: introspection: extend the access rights database with EPT view
    info
  KVM: introspection: extend KVMI_VM_SET_PAGE_ACCESS with EPT view info
  KVM: introspection: clean non-default EPTs on unhook
  KVM: x86: mmu: fix: update present_mask in spte_read_protect()
  KVM: vmx: trigger vm-exits for mmio sptes by default when #VE is
    enabled
  KVM: x86: svm: set .clear_page()
  KVM: x86: add .set_ve_info()
  KVM: x86: add .disable_ve()
  KVM: x86: page_track: add support for suppress #VE bit
  KVM: vmx: make use of EPTP_INDEX in vmx_handle_exit()
  KVM: vmx: make use of EPTP_INDEX in vmx_set_ept_view()
  KVM: introspection: add #VE host capability checker
  KVM: introspection: add KVMI_VCPU_SET_VE_INFO/KVMI_VCPU_DISABLE_VE
  KVM: introspection: add KVMI_VM_SET_PAGE_SVE

 Documentation/virt/kvm/kvmi.rst               | 227 +++++++++++-
 arch/x86/include/asm/kvm_host.h               |  27 +-
 arch/x86/include/asm/kvm_page_track.h         |   5 +-
 arch/x86/include/asm/kvmi_host.h              |   1 +
 arch/x86/include/asm/vmx.h                    |   5 +
 arch/x86/include/uapi/asm/kvmi.h              |  44 ++-
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/kvmi.c                           |  83 ++++-
 arch/x86/kvm/mmu.h                            |  12 +-
 arch/x86/kvm/mmu/mmu.c                        | 191 +++++++---
 arch/x86/kvm/mmu/page_track.c                 |  63 ++--
 arch/x86/kvm/mmu/paging_tmpl.h                |   6 +-
 arch/x86/kvm/svm/svm.c                        |   1 +
 arch/x86/kvm/vmx/capabilities.h               |  13 +
 arch/x86/kvm/vmx/clear_page.S                 |  17 +
 arch/x86/kvm/vmx/vmx.c                        | 291 ++++++++++++++-
 arch/x86/kvm/vmx/vmx.h                        |  18 +
 arch/x86/kvm/x86.c                            |  20 +-
 drivers/gpu/drm/i915/gvt/kvmgt.c              |   8 +-
 include/linux/kvmi_host.h                     |   2 +-
 include/uapi/linux/kvmi.h                     |  12 +-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 335 +++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 | 175 ++++++---
 virt/kvm/introspection/kvmi_int.h             |  17 +-
 virt/kvm/introspection/kvmi_msg.c             | 106 ++++++
 25 files changed, 1512 insertions(+), 169 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/clear_page.S


base-commit: d9da9f5842e0697564f0f3e586d858f2626e8f92
Based-on: <20200721210922.7646-1-alazar@bitdefender.com>
CC: Sean Christopherson <sean.j.christopherson@intel.com>
