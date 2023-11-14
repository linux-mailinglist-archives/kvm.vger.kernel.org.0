Return-Path: <kvm+bounces-1629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC477EA99C
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 05:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA1CFB20AC9
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 04:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BF78828;
	Tue, 14 Nov 2023 04:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GrJE1Zw9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C38BE3
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 04:35:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5810010C6;
	Mon, 13 Nov 2023 20:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699936533; x=1731472533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LicepLvuxX8MsuqiDGUanI1SzH7zkogiKG9oBJpEPec=;
  b=GrJE1Zw92I0Pno3KGmGwW5AFRSJANMRuIcbccBNgU7mYYWRkW1vCWyxp
   EzXyT+8EqKi6jCkvEYVLINWPzDVgvuP2efv36L6kAKg4iH68f9NV4GIMJ
   Oh7aRxibWhQYiCeJcGHs7lPE9i09Hqy6HWecyp6FiuZx6Oa4x28SA+gaz
   3IVUtQIQsiTOL6cdOuZsLjn0iB85JBhnvvHRu4naOWICaUNeGWmk4GdmP
   kbC0UKSBgO2zaMk6rxhgS9pxxOEByfclNT5yedjGufbYsBsQrxA31ZpKK
   mDPQPQz+mssrIzqfqCnsyoZ2OoAtWG/7IgEgGAiqy1YPIZDkRSuTeilWL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="389437292"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="389437292"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 20:35:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="830467499"
X-IronPort-AV: E=Sophos;i="6.03,301,1694761200"; 
   d="scan'208";a="830467499"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 20:35:31 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: [PATCH v2 0/3] KVM: X86: Make bus clock frequency for vapic timer configurable
Date: Mon, 13 Nov 2023 20:35:01 -0800
Message-Id: <cover.1699936040.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Changes from v1:
  https://lore.kernel.org/all/cover.1699383993.git.isaku.yamahata@intel.com/
- Added a test case
- Fix a build error for i386 platform
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Updated api.rst

Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREUQNCY_CONTROL) to set the
frequency.  When using this capability, the user space VMM should configure
CPUID[0x15] to advertise the frequency.

TDX virtualizes CPUID[0x15] for the core crystal clock to be 25MHz.  The
x86 KVM hardcodes its freuqncy for APIC timer to be 1GHz.  This mismatch
causes the vAPIC timer to fire earlier than the guest expects. [1] The KVM
APIC timer emulation uses hrtimer, whose unit is nanosecond.

There are options to reconcile the mismatch.  1) Make apic bus clock frequency
configurable (this patch).  2) TDX KVM code adjusts TMICT value.  This is hacky
and it results in losing MSB bits from 32 bit width to 30 bit width.  3). Make
the guest kernel use tsc deadline timer instead of acpi oneshot/periodic timer.
This is guest kernel choice.  It's out of control of VMM.

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/

Isaku Yamahata (3):
  KVM: x86: Make the hardcoded APIC bus frequency vm variable
  KVM: X86: Add a capability to configure bus frequency for APIC timer
  KVM: selftests: Add test case for x86 apic_bus_clock_frequency

 Documentation/virt/kvm/api.rst                |  14 ++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/kvm/hyperv.c                         |   2 +-
 arch/x86/kvm/lapic.c                          |   6 +-
 arch/x86/kvm/lapic.h                          |   4 +-
 arch/x86/kvm/x86.c                            |  37 +++++
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   7 +
 .../kvm/x86_64/apic_bus_clock_test.c          | 132 ++++++++++++++++++
 10 files changed, 201 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c


base-commit: be3ca57cfb777ad820c6659d52e60bbdd36bf5ff
-- 
2.25.1


