Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C11357647
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhDGUuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:50:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:47225 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhDGUuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:50:21 -0400
IronPort-SDR: WXZ8l/OYZtr8quJD0NfBkywV9p1Gy2e7ulp/jteAO5ccq1KhevpdpqEPrTzG+F9uHOHgRMslk+
 jn8j2k0UwKnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="278660295"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="278660295"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:49:59 -0700
IronPort-SDR: vFe3+KXld1UIaBO7mIXpjTMZ4P6NxTcooMCdqrrX59OChSLU2EuIE7PZ1fVLW0dnaVmdayqu/D
 /xRKS3NIjtKQ==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="415437309"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:49:56 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com
Subject: [PATCH v4 00/11] KVM SGX virtualization support (KVM part)
Date:   Thu,  8 Apr 2021 08:49:24 +1200
Message-Id: <cover.1617825858.git.kai.huang@intel.com>
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

This seris is still based on tip/x86/sgx (which is based on 5.12-rc3), since it
requires x86 patches to work. I tried to rebase them to latest kvm/queue, but
found patch 

KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
KVM: x86: Add capability to grant VM access to privileged SGX aattribute

have merge conflict, but the conflict is quite easy to resolve, so I didn't sent
out the resolved version. Please let me know how would you like to proceed.

Thank you all guys!

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
 arch/x86/kvm/vmx/sgx.c          | 500 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h          |  34 +++
 arch/x86/kvm/vmx/vmcs12.c       |   1 +
 arch/x86/kvm/vmx/vmcs12.h       |   4 +-
 arch/x86/kvm/vmx/vmx.c          | 109 ++++++-
 arch/x86/kvm/vmx/vmx.h          |   2 +
 arch/x86/kvm/x86.c              |  23 ++
 include/uapi/linux/kvm.h        |   1 +
 17 files changed, 855 insertions(+), 23 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/sgx.c
 create mode 100644 arch/x86/kvm/vmx/sgx.h

-- 
2.30.2

