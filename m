Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E9035B93A
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhDLEWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:53368 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhDLEWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:09 -0400
IronPort-SDR: FoYqkzv/LFzzJ+QB1ew3CltJuopGb2eqWcnF/1yzIQDeZ+JeGaK4o0o7Z2+11bi8ic/5lfItNh
 iqRycluaGVzQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083736"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083736"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:51 -0700
IronPort-SDR: T3JTS6xv/VQ4UVbj73NncAbScptLx2jk2XAtoh50u0vb/bK0hBltG4Ks9TM/xIQDTNjE9k447z
 sqIGwDVpVPrw==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030335"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:48 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com
Subject: [PATCH v5 00/11] KVM SGX virtualization support (KVM part)
Date:   Mon, 12 Apr 2021 16:21:32 +1200
Message-Id: <cover.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo, Sean,

Boris has merged x86 part patches to the tip/x86/sgx. This series is KVM part
patches. Due to some code change in x86 part patches, two KVM patches need
update so this is the new version. Please help to review. Thanks!

Specifically, x86 patch (x86/sgx: Add helpers to expose ECREATE and EINIT to
KVM) was changed to return -EINVAL directly w/o setting trapnr when 
access_ok()s fail on any user pointers, so KVM patches:

KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)

were updated to handle this case.

This seris was firstly based on tip/x86/sgx, and then rebased to latest
kvm/queue, so it can be applied to kvm/queue directly now.

Changelog:

(Please see individual patch for changelog for specific patch)

v4->v5:
 - Addressed Sean's comments (patch 06, 07, 09 were slightly updated).
 - Rebased to latest kvm/queue (patch 08, 11 were updated to resolve conflict).

Sean Christopherson (11):
  KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
  KVM: x86: Define new #PF SGX error code bit
  KVM: x86: Add support for reverse CPUID lookup of scattered features
  KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
  KVM: VMX: Add basic handling of VM-Exit from SGX enclave
  KVM: VMX: Frame in ENCLS handler for SGX virtualization
  KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
  KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
  KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
  KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
  KVM: x86: Add capability to grant VM access to privileged SGX
    attribute

 Documentation/virt/kvm/api.rst  |  23 ++
 arch/x86/include/asm/kvm_host.h |   5 +
 arch/x86/include/asm/vmx.h      |   1 +
 arch/x86/include/uapi/asm/vmx.h |   1 +
 arch/x86/kvm/Makefile           |   2 +
 arch/x86/kvm/cpuid.c            |  89 +++++-
 arch/x86/kvm/cpuid.h            |  50 +++-
 arch/x86/kvm/vmx/nested.c       |  28 +-
 arch/x86/kvm/vmx/nested.h       |   5 +
 arch/x86/kvm/vmx/sgx.c          | 502 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h          |  34 +++
 arch/x86/kvm/vmx/vmcs12.c       |   1 +
 arch/x86/kvm/vmx/vmcs12.h       |   4 +-
 arch/x86/kvm/vmx/vmx.c          | 109 ++++++-
 arch/x86/kvm/vmx/vmx.h          |   3 +
 arch/x86/kvm/x86.c              |  23 ++
 include/uapi/linux/kvm.h        |   1 +
 17 files changed, 858 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/sgx.c
 create mode 100644 arch/x86/kvm/vmx/sgx.h

-- 
2.30.2

