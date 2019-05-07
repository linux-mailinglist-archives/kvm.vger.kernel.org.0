Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E88C166E5
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbfEGPgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:51035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfEGPgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:31 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 0/7]  KVM: nVMX: Optimize VMCS data copying
Date:   Tue,  7 May 2019 08:36:22 -0700
Message-Id: <20190507153629.3681-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM spends a lot of time copying data between VMCSes, especially when
utilizing a shadow VMCS as data needs to moved between vmcs12 and the
shadow VMCS.

This series is comprised of three mostly unrelated optimizations that
happen to modify the same code and would cause non-trivial conflicts:

  - Expose read-frequently write-rarely fields to L1 for VMREAD only.
    Exposing fields to L1 for both VMWRITE and VMREAD means KVM needs
    to copy data from the shadow VMCS to vmcs12 on nested VM-Entry.
    For fields that are almost never written by L1, copying those
    fields on every nested VM-Entry is pure overhead.

  - Track the vmcs12 offsets for shadowed fields.  All offsets are
    known at compile time (HIGH fields complicate this slightly), but
    KVM currently does a runtime lookup to get the offset, which adds
    measurable latency to copying to/from the shadow VMCS.

  - Sync rarely accessed guest fields from vmcs02 to vmcs12 only when
    necessary.  A non-trivial number of guest fields are infrequently
    accessed by VMMs, e.g. most segment descriptor fields.  Avoid
    copying the fields from vmcs02 (30+ VMREADs) on every nested VM-Exit
    to L1, and instead pull them from vmcs02 when read by L1, or when
    they may be consumed by KVM, e.g. for consistency checks.


Sean Christopherson (7):
  KVM: nVMX: Intercept VMWRITEs to read-only shadow VMCS fields
  KVM: nVMX: Intercept VMWRITEs to GUEST_{CS,SS}_AR_BYTES
  KVM: nVMX: Track vmcs12 offsets for shadowed VMCS fields
  KVM: nVMX: Lift sync_vmcs12() out of prepare_vmcs12()
  KVM: nVMX: Use descriptive names for VMCS sync functions and flags
  KVM: nVMX: Add helpers to identify shadowed VMCS fields
  KVM: nVMX: Sync rarely accessed guest fields only when needed

 arch/x86/kvm/vmx/nested.c             | 384 +++++++++++++++++---------
 arch/x86/kvm/vmx/nested.h             |   2 +-
 arch/x86/kvm/vmx/vmcs12.h             |  57 ++--
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  78 +++---
 arch/x86/kvm/vmx/vmx.c                |   4 +-
 arch/x86/kvm/vmx/vmx.h                |   8 +-
 6 files changed, 320 insertions(+), 213 deletions(-)

-- 
2.21.0

