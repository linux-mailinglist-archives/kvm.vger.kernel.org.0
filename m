Return-Path: <kvm+bounces-1299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510BA7E64A6
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 08:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC35F280E63
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 07:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE119101ED;
	Thu,  9 Nov 2023 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bcIZMRBD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBCFDF78
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 07:50:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C9026A0
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 23:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699516222; x=1731052222;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sFrdaYDqHcmeMwI+r91s4Pu9byCxYPzQ4VEuUXb9rxI=;
  b=bcIZMRBDvNv7oF8GDhLQaVyH+SS/Wu4rqUD56K/YcMIgGI4G/EzroWFZ
   CffTfPEJ2p7y9Vf1zm1SnF/N/hAK0XYompArQpKZdG3XukuZOAel5Ckna
   InvQyHbJdMLeGF4JjrZE+aqvj/DrVt5h0CdPQIgYDJAK+yelv3AWjHlwH
   S6aaGr/wdaoYa494Tc2mIReSuTElxgPz7W4XTbOtwYz67uI0J+Yj4mXsr
   lLb8iUZjovPurfkotiLK1OEtO89DJmm9OJlOUpnm9X/rRF6D9oqONIGEn
   H5TD/RMJL3OtO12GfcUoJiLsYNhHDd12UadDEJW5ttxOJItek0wxTZCht
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="476165123"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="476165123"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 23:50:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="763329260"
X-IronPort-AV: E=Sophos;i="6.03,288,1694761200"; 
   d="scan'208";a="763329260"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2023 23:50:21 -0800
From: Xin Li <xin3.li@intel.com>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	pbonzini@redhat.com,
	eduardo@habkost.net,
	seanjc@google.com,
	chao.gao@intel.com,
	hpa@zytor.com,
	xiaoyao.li@intel.com,
	weijiang.yang@intel.com
Subject: [PATCH v3 0/6] target/i386: add support for FRED
Date: Wed,  8 Nov 2023 23:20:06 -0800
Message-ID: <20231109072012.8078-1-xin3.li@intel.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adds support for the Intel flexible return and event delivery
(FRED) architecture to allow Qemu to run KVM guests with FRED enabled.

The FRED architecture defines simple new transitions that change privilege
level (ring transitions). The FRED architecture was designed with the
following goals:
1) Improve overall performance and response time by replacing event delivery
   through the interrupt descriptor table (IDT event delivery) and event
   return by the IRET instruction with lower latency transitions.
2) Improve software robustness by ensuring that event delivery establishes
   the full supervisor context and that event return establishes the full
   user context.

Intel VMX architecture is extended to run FRED guests, and the changes
are majorly:
1) New VMCS fields for FRED context management, which includes two new
   event data VMCS fields, eight new guest FRED context VMCS fields and
   eight new host FRED context VMCS fields.
2) VMX nested-Exception support for proper virtualization of stack
   levels introduced with FRED architecture.

Search for the latest FRED spec in most search engines with this search pattern:

  site:intel.com FRED (flexible return and event delivery) specification

The counterpart KVM patch set is at:
https://lore.kernel.org/kvm/20231108183003.5981-1-xin3.li@intel.com/T/#m77876e22876f41c5ec677c0834a46113a4987d31


---
Changelog
v3:
- Add WRMSRNS as a baseline feature for FRED.
- Add the secondary VM exit controls MSR.
- Add FRED VMX controls to VM exit/entry feature words and
  scripts/kvm/vmxcap.
- Do not set/get FRED SSP0 MSR, i.e. PL0_SSP MSR, with FRED, leave it to
  KVM CET.

v2:
- Add VMX nested-exception support to scripts/kvm/vmxcap (Paolo Bonzini).
- Move FRED MSRs from basic x86_cpu part to .subsections part (Weijiang Yang).


Xin Li (6):
  target/i386: add support for FRED in CPUID enumeration
  target/i386: mark CR4.FRED not reserved
  target/i386: add the secondary VM exit controls MSR
  target/i386: add support for VMX FRED controls
  target/i386: enumerate VMX nested-exception support
  target/i386: Add get/set/migrate support for FRED MSRs

 scripts/kvm/vmxcap    | 13 ++++++++++++
 target/i386/cpu.c     | 15 ++++++++++---
 target/i386/cpu.h     | 42 ++++++++++++++++++++++++++++++++++++-
 target/i386/kvm/kvm.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/machine.c | 28 +++++++++++++++++++++++++
 5 files changed, 143 insertions(+), 4 deletions(-)


base-commit: a3c3aaa846ad61b801e7196482dcf4afb8ba34e4
-- 
2.42.0


