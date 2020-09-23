Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A43275F4E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgIWSEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:39920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgIWSEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:21 -0400
IronPort-SDR: Vs5B0MXa0Oo1UaAYS1v20plHBXk9Xtds1fBMM7+MNalEBNjrjsfoqA7ULONvMZrS4yJmbRC1Ot
 gItbTncnq5+A==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="245808953"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="245808953"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:11 -0700
IronPort-SDR: 2viIkAbMaqgxezyhz3M8YAUjBhe6d1JCM8KNzKI9D5/T0YHugyB2geqRkrwbi/iqse+frU5+uZ
 gZaApIISwT3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670253"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/15] KVM: x86: VMX: Fix MSR namespacing
Date:   Wed, 23 Sep 2020 11:03:54 -0700
Message-Id: <20200923180409.32255-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series attempts to clean up VMX's MSR namespacing, which is in
unimitigated disaster (keeping things PG).

There are a variety of ways VMX saves and restores guest MSRs, all with
unique properties and mechanisms, but with haphazard namespacing (assuming
there is any namespacing at all).  Some fun collisions:

  __find_msr_index(), find_msr_entry() and vmx_find_msr_index()

  vmx_set_guest_msr() and vmx_set_msr()

  structs vmx_msrs, vmx_msr_entry, shared_msr_entry, kvm_shared_msrs and
  kvm_shared_msrs_values

  vcpu_vmx fields guest_msrs, msr_autoload.guest and msr_autostore.guest

Probably the most infurating/confusing nomenclature is "index", which can
mean MSR's ECX index, index into one of several VMX arrays, or index into
a common x86 array.  __find_msr_index() even manages to mix at least three
different meanings in about as many lines of code.

The biggest change is to rename the "shared MSRs" mechanism to "user
return MSRs" (details in patch 1), most everything else is either derived
from that rename or is fairly straightforward cleanup.

No true functional changes, although the update_transition_efer() change
in patch 10 dances pretty close to being a functional change.

v2:
  - Rebased to kvm/queue, commit e1ba1a15af73 ("KVM: SVM: Enable INVPCID
    feature on AMD").

Sean Christopherson (15):
  KVM: x86: Rename "shared_msrs" to "user_return_msrs"
  KVM: VMX: Prepend "MAX_" to MSR array size defines
  KVM: VMX: Rename "vmx_find_msr_index" to "vmx_find_loadstore_msr_slot"
  KVM: VMX: Rename the "shared_msr_entry" struct to "vmx_uret_msr"
  KVM: VMX: Rename vcpu_vmx's "nmsrs" to "nr_uret_msrs"
  KVM: VMX: Rename vcpu_vmx's "save_nmsrs" to "nr_active_uret_msrs"
  KVM: VMX: Rename vcpu_vmx's "guest_msrs_ready" to
    "guest_uret_msrs_loaded"
  KVM: VMX: Rename "__find_msr_index" to "__vmx_find_uret_msr"
  KVM: VMX: Check guest support for RDTSCP before processing MSR_TSC_AUX
  KVM: VMX: Move uret MSR lookup into update_transition_efer()
  KVM: VMX: Add vmx_setup_uret_msr() to handle lookup and swap
  KVM: VMX: Rename "find_msr_entry" to "vmx_find_uret_msr"
  KVM: VMX: Rename "vmx_set_guest_msr" to "vmx_set_guest_uret_msr"
  KVM: VMX: Rename "vmx_msr_index" to "vmx_uret_msrs_list"
  KVM: VMX: Rename vmx_uret_msr's "index" to "slot"

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/vmx/nested.c       |  22 ++--
 arch/x86/kvm/vmx/vmx.c          | 184 ++++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h          |  24 ++---
 arch/x86/kvm/x86.c              | 101 +++++++++---------
 5 files changed, 168 insertions(+), 167 deletions(-)

-- 
2.28.0

