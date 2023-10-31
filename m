Return-Path: <kvm+bounces-164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EAF7DC8C9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:58:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E512E2815D9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 08:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050CD12E76;
	Tue, 31 Oct 2023 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bjnUZzXa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508F7125C4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:58:35 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68310C2;
	Tue, 31 Oct 2023 01:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698742714; x=1730278714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pEpzXE0NNcmHwTemudkQ6k8syJET3+LhUaz0WTQrc5c=;
  b=bjnUZzXaxHp13Dm5qW+AhHMGIwIb5OtyIWb3MHsirDMlpwLuwzkJhfOo
   wtOMxmHRORjVRRkoBkGPDpT0s6tEe8pNsaCrQ5Rzdw5TGKfHV76kQtxQU
   dEpkljHmWF1drTzh7BqPijP3utU3xDqp2ixO6ped54MevKvPm/4tCmnb8
   TH8TjtMuXsrHZ2sGhsDcHnbs3g8ssf/x6EavnYCaEKtnPwkbGk7p/Voc8
   qIvjVWH5y0wRKziOxuqI4HrwBb2vKzWN7O06445FYLYZAU8zjQ02qLnMi
   fR1sO3qbsr1ZIHZ/plj4W0hpZ+2FoeF005GZ6Y/+1BNdWwb70Q/YHGfG+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="378627547"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="378627547"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 01:58:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="8257894"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by orviesa001.jf.intel.com with ESMTP; 31 Oct 2023 01:58:31 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [Patch 0/2] Enable topdown slots event in vPMU
Date: Tue, 31 Oct 2023 17:06:11 +0800
Message-Id: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The topdown slots event counts the total number of available slots for
an unhalted logical processor. Software can use this event to calculate
the topdown metrics by collaborating with IA32_PERF_METRICS MSR.

Since Intel Icelake CPU starts, the topdown slots event can be
programmed both on GP counters or the exclusive fixed counter 3 but with
different event & umask code. The event with code (event=0xa4,umask=0x01)
is an architectural event which is represented in CPUID.0AH.EBX and can
be programed on any GP counter. Besides, Intel PMU from Icelake
introduces a new fixed counter (fixed counter 3) to count/sample
todpown slots event so the precious GP counters can be saved. The fixed
counter 3 uses an exclusive code (event=0x00,umask=0x04) to count/sample
the slots event.

Actually this patchset is a portion of the patchset "Enable fixed counter
 3 and topdown perf metrics for vPMU"[1]. As this original patchset needs to
make some fundamental changes on perf code and cause big arguments, it
leads to the vPMU topdown metrics patchset is hard to be merged in current
vPMU emulation framework.

The patches of enabling topdown slots event is simple and doesn't
touch any perf code. Moreover topdown slots event as an independent
feature is still valuable even though in no topdown metrics cases, some
perf metrics depend on slots event and need to be derived from slots
event.

Thus the patches of enabling slots event is extracted as an independent
patchset and resend.

Ref:
1. https://lore.kernel.org/all/20230927033124.1226509-1-dapeng1.mi@linux.intel.com/T/


Dapeng Mi (2):
  KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
  KVM: x86/pmu: Support PMU fixed counter 3

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 12 ++++++++++++
 arch/x86/kvm/x86.c              |  4 ++--
 3 files changed, 15 insertions(+), 3 deletions(-)


base-commit: 35dcbd9e47035f98f3910ae420bf10892c9bdc99
-- 
2.34.1


