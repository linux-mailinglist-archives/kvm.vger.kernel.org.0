Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0C233D50
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731213AbgGaCmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730820AbgGaCmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:33 -0400
IronPort-SDR: i3Q3I9Boz7JlfmrUoq2zzVtjHdxloIEZF88M8KWpzaGZKkf747cDQN7KAa/tvhoTtYwWdMjvDr
 yQiP98hfw8lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290112"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290112"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:32 -0700
IronPort-SDR: sVhhZdSM92iN3sToa5g5SlDJ2nozC2SUtFZqoCKsMMZKTgavoioTCWWSKW8VsXya/sU/QHmjhZ
 baQq0NTi3Jvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304805925"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:29 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 0/9] Split kvm_update_cpuid_runtime()
Date:   Fri, 31 Jul 2020 10:42:18 +0800
Message-Id: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_update_cpuid_runtime() is currently called by various functions for the
purpose of updating vCPU's cpuid entries, due to specific runtime changes, e.g.
CR4 bits changes, XCR0 bits changes, etc. Each of them actually just needs to
update 1 ~ 2 CPUID entries. But current kvm_update_cpuid_runtime() packages all.
Given finding a target CPUID entry need to go through all CPUID entries, calling
kvm_update_cpuid_runtime() is a waste for each cause.

This patch set splits kvm_update_cpuid_runtime() into pieces according to
different updating causes.
Then let various callers call their specific necessary kvm_xxx_update_cpuid().

This not only significantly saves each caller's time, but also eliminates
unnecessary couplings.

Robert Hoo (9):
  KVM:x86: Abstract sub functions from kvm_update_cpuid_runtime() and   
     kvm_vcpu_after_set_cpuid()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_apic_base_update_cpuid() in     kvm_lapic_set_base()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_xcr0_update_cpuid() in     __kvm_set_xcr()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_{osxsave,pke}_update_cpuid() in     kvm_set_cr4()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_mwait_update_cpuid() in     kvm_set_msr_common()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_{osxsave,pke}_update_cpuid() in     enter_smm()
  KVM:x86: Substitute kvm_update_cpuid_runtime() with
    kvm_{osxsave,pke}_update_cpuid() in     __set_sregs()
  KVM:x86: Substitute kvm_vcpu_after_set_cpuid() with abstracted
    functions
  KVM:x86: Remove kvm_update_cpuid_runtime()

 arch/x86/kvm/cpuid.c | 118 ++++++++++++++++++++++++++++++++++-----------------
 arch/x86/kvm/cpuid.h |   7 ++-
 arch/x86/kvm/lapic.c |   2 +-
 arch/x86/kvm/x86.c   |  29 ++++++++-----
 4 files changed, 103 insertions(+), 53 deletions(-)

-- 
1.8.3.1

