Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A5B6B647D
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjCLJ6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCLJ5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60B056154
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615041; x=1710151041;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r9zfwza+K+yPCsvTWw3Iy8apFTUX+SFR9+1Vu6Pe6fk=;
  b=VbP0FNQuYqH+tuYaaF79xRpSQcwVp2b89TrcaSjOQ1Uaa6QVE4PhpWwi
   Ibj73ynziODYpxZelMBRGiKtY3Xt/W+vqYq+Q3IsEFw/9sPTL89eCbCIK
   uh+4VrrCs8pWDGBbvJr6tLPBQT9V7EqE10eWWi08jNfBwtHKaROSRa1n6
   Zdnxjyuum5D2/PrOvA5MjJQiAJaI0OIt5c6VLkBaOYzTrP/ax1jARIuIk
   hKO+IOzbhQpwV2+oUO3iGIpn0IxlCcS9+hNCtC3oeqsrRmaWxCoONwJII
   OUnFboTiWBBgDuiek8hd3LyR0wfHWavxeGXTaK+gxvVlJ+OwuBDfKmwea
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998089"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998089"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677638"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677638"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:08 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 00/22] VMX emulation
Date:   Mon, 13 Mar 2023 02:02:41 +0800
Message-Id: <20230312180303.1778492-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is part-5 of this RFC patches. It introduces VMX
emulation for pKVM on Intel platform.

Host VM wants the capability to run its guest, it needs VMX support.

pKVM is designed to emulate VMX for host VM based on shadow vmcs.
This requires "VMCS shadowing" feature support in VMX secondary
processor-based VM-Execution controls field [1].

One alternative way to emulate VMX is based on enlightened vmcs (evmcs)
which was introduced by Hyper-V nesting support. evmcs does normal memory
reads/writes instead of doing VMWRITE/VMREAD instructions, it's a
flexible SW solution to emulate VMX, and does not need "VMCS shadowing"
feature support; while making evmcs work for pKVM leads to the
refactor to KVM Hyper-V code; to avoid change that part of code, we
choose to use shadow VMCS in this RFC.

    +--------------------+   +-----------------+
    |     host VM        |   |   guest VM      |
    |                    |   |                 |
    |        +---------+ |   |                 |
    |        | vmcs12* | |   |                 |
    |        +---------+ |   |                 |
    +--------------------+   +-----------------+
    +------------------------------------------+       +---------+
    |     +---------+         +---------+      |       | shadow  |
    |     | vmcs01* |         | vmcs02* +------+---+-->|  vcpu   |
    |     +---------+         +---------+      |   |   |  state  |
    |                      +---------------+   |   |   +---------+
    |                      | cached_vmcs12 +---+---+
    | pKVM                 +---------------+   |
    +------------------------------------------+

 [*]vmcs12: virtual vmcs of a nested guest
 [*]vmcs02: vmcs of a nested guest
 [*]vmcs01: vmcs of host VM

"VMCS shadowing" use a shadow vmcs page (vmcs02) to cache vmcs fields
accessing from host VM through VMWRITE/VMREAD, avoid causing vmexit.
The fields cached in vmcs02 is pre-defined by VMREAD/VMWRITE bitmap.
Meanwhile for other fields not in VMREAD/VMWRITE bitmap, accessing from
host VM cause VMREAD/VMWRITE vmexit, pKVM need to cache them in another
place - cached_vmcs12 is introduced for this purpose.

The vmcs02 page in root mode is kept in the structure shadow_vcpu_state,
which allocated then donated from host VM when it initialize vcpus for
its launched guest (nested). Same for field of cached_vmcs12.

pKVM use vmcs02 with two purposes, one is mentioned above, using it
as the shadow vmcs page of nested guest when host VM program its vmcs
fields; the other one is using it as ordinary (or active) vmcs for the
same guest during the vmlaunch/vmresume.

For a nested guest, during its vmcs programing from host VM, according
to above, its virtual vmcs (vmcs12) is saved in two places: vmcs02 for
shadow fields and cached_vmcs12 for no shadow fields. Meanwhile for
cached_vmcs12, there are also two parts for its fields: one is emulated
fields, the other one is host state fields. The emulated fields are
mostly security related control fields which shall be emulated to the
physical value then fill into vmcs02 before vmcs02 active to do
vmlaunch/vmresume for the nested guest. The host state fields are
guest state of host vcpu, it shall be restored to guest state of host
vcpu vmcs (vmcs01) before return to host VM.

Below is a summary for contents of different vmcs fields in each above
mentioned vmcs:

              host state      guest state          control
 ---------------------------------------------------------------
 vmcs12:      host VM's     nested guest's     set by host VM
 vmcs02:       pKVM's       nested guest's   set by host VM + pKVM*
 vmcs01:       pKVM's        host VM's          set by pKVM

 [*]the security related control fields of vmcs02 is controlled by pKVM
  (e.g., EPT_POINTER)

Blow show the brief vmcs emulation method for different vmcs fields for
a nested guest:

                host state      guest state   security related control
 ---------------------------------------------------------------------
 virutal vmcs:  cached_vmcs12*     vmcs02*          emulated*

 [*]cached_vmcs12: vmexit then set/get value to/from cached_vmcs12
 [*]vmcs02:        no-vmexit and directly shadow from vmcs02
 [*]emulated:      vmexit then do the emulation

The vmcs02 & cached_vmcs12 is sync back to vmcs12 during VMCLEAR
emulation, and updated from vmcs12 when emulating VMPTRLD. And before
the nested guest vmentry(vmlaunch/vmresume emulation), the vmcs02 is
further sync dirty fields(caused by vmwrite) from cached_vmcs12 and
update emulated fields through emulation.

INVEPT/INVVPID now is simplify emulated by doing a global INVEPT.

VMX msrs are emulated by pKVM as well to provide the VMX capabilities
to host VM, features of PT, SMM, shadowing VMCS and vmfunc are filtered
out.

[1]: SDM: Virtual Machine Control Structures chapter, VMCS TYPES.

Haiwei Li (2):
  pkvm: x86: Do guest address translation per page granularity
  pkvm: x86: Add check for guest address translation

Jason Chen CJ (19):
  pkvm: x86: Add memcpy lib
  pkvm: x86: Add memory operation APIs for for host VM
  pkvm: x86: Add hypercalls for shadow_vm/vcpu init & teardown
  KVM: VMX: Add new kvm_x86_ops vm_free
  KVM: VMX: Add initialization/teardown for shadow vm/vcpu
  pkvm: x86: Add hash table mapping for shadow vcpu based on vmcs12_pa
  pkvm: x86: Add VMXON/VMXOFF emulation
  KVM: VMX: Add more vmcs and vmcs12 fields definition
  pkvm: x86: Init vmcs read/write bitmap for vmcs emulation
  pkvm: x86: Initialize emulated fields for vmcs emulation
  pkvm: x86: Add msr ops for pKVM hypervisor
  pkvm: x86: Move _init_host_state_area to pKVM hypervisor
  pkvm: x86: Add vmcs_load/clear_track APIs
  pkvm: x86: Add VMPTRLD/VMCLEAR emulation
  pkvm: x86: Add VMREAD/VMWRITE emulation
  pkvm: x86: Add VMLAUNCH/VMRESUME emulation
  pkvm: x86: Add INVEPT/INVVPID emulation
  pkvm: x86: Initialize msr_bitmap for vmsr
  pkvm: x86: Add vmx msr emulation

Tina Zhang (1):
  pkvm: x86: Add has_vmcs_field() API for physical vmx capability check

 arch/x86/include/asm/kvm-x86-ops.h            |    1 +
 arch/x86/include/asm/kvm_host.h               |    5 +
 arch/x86/include/asm/kvm_pkvm.h               |   14 +
 arch/x86/include/asm/pkvm_image_vars.h        |    3 +-
 arch/x86/include/asm/vmx.h                    |    4 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile            |    6 +-
 arch/x86/kvm/vmx/pkvm/hyp/cpu.h               |   23 +
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c     |    3 +
 arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S     |   26 +
 arch/x86/kvm/vmx/pkvm/hyp/memory.c            |  216 ++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h            |   11 +
 arch/x86/kvm/vmx/pkvm/hyp/nested.c            | 1030 +++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h            |   27 +
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c              |  342 ++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h          |   82 ++
 .../vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h    |  195 ++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c            |  174 ++-
 arch/x86/kvm/vmx/pkvm/hyp/vmsr.c              |   88 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmsr.h              |   11 +
 arch/x86/kvm/vmx/pkvm/hyp/vmx.c               |   77 ++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h               |   23 +
 arch/x86/kvm/vmx/pkvm/include/pkvm.h          |    5 +
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c        |    4 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c             |  181 +--
 arch/x86/kvm/vmx/vmcs12.c                     |    6 +
 arch/x86/kvm/vmx/vmcs12.h                     |   16 +-
 arch/x86/kvm/vmx/vmx.c                        |   14 +-
 arch/x86/kvm/x86.c                            |    1 +
 include/linux/kvm_host.h                      |    8 +
 29 files changed, 2459 insertions(+), 137 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/lib/memcpy_64.S
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/nested.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/nested.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/pkvm_nested_vmcs_fields.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmsr.h
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/vmx.c

-- 
2.25.1

