Return-Path: <kvm+bounces-4144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A799380E43F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 07:27:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A520282DD8
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC8C815AE2;
	Tue, 12 Dec 2023 06:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hw+SvKlL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2302FC7
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 22:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702362465; x=1733898465;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gODY0Ki/ypqSEOmjsLFoUz+Pzjura63qPe5lCoM90ww=;
  b=hw+SvKlLVyVP74gsiWxoEo93Q7MoY9F7o/U3zjkXsgMvcSdRoh6khcAo
   SUYyaJwsYE/vxZf6SJjJ6GRFhZrT+Jw3eLgdR472LhM472YXemQUPjLD7
   eGd+isYn7n2AIoDJk71ODbPz/TNxaLkPHzjmYEU8Gnliek9BEYpaGamDe
   XWaCGpUCK+23FaJL2LEBuwGu8+f06/wSMUzfGrzcQLKbCmx0Eg9wgZu0c
   cQipmtLGXG5SP1cwMz86UbwjXfYmM6OPJ5gzqlFxztDyqWwhtb11y4+h2
   57Fr7xAtuth7Rnzl7iWsaAhbeos3DNxMiW5nY2Fck9J8rA771lxyu2d4v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="8128888"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="8128888"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 22:27:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="723109009"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="723109009"
Received: from spr-bkc-pc.jf.intel.com ([10.165.56.234])
  by orsmga003.jf.intel.com with ESMTP; 11 Dec 2023 22:27:44 -0800
From: Dan Wu <dan1.wu@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	dan1.wu@intel.com
Subject: [kvm-unit-tests PATCH v1 0/3] x86: fix async page fault issues
Date: Tue, 12 Dec 2023 14:27:05 +0800
Message-Id: <20231212062708.16509-1-dan1.wu@intel.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When running asyncpf test, it gets skipped without a clear reason:

    ./asyncpf

    enabling apic
    smp: waiting for 0 APs
    paging enabled
    cr0 = 80010011
    cr3 = 107f000
    cr4 = 20
    install handler
    enable async pf
    alloc memory
    start loop
    end loop
    start loop
    end loop
    SUMMARY: 0 tests
    SKIP asyncpf (0 tests)

The reason is that KVM changed to use interrupt-based 'page-ready' notification
and abandoned #PF-based 'page-ready' notification mechanism. Interrupt-based
'page-ready' notification requires KVM_ASYNC_PF_DELIVERY_AS_INT to be set as well
in MSR_KVM_ASYNC_PF_EN to enable asyncpf.

This series tries to fix the problem by separating two testcases for different mechanisms.

- For old #PF-based notification, changes current asyncpf.c to add CPUID check
  at the beginning. It checks (KVM_FEATURE_ASYNC_PF && !KVM_FEATURE_ASYNC_PF_INT),
  otherwise it gets skipped.

- For new interrupt-based notification, add a new test, asyncpf-int.c, to check
  (KVM_FEATURE_ASYNC_PF && KVM_FEATURE_ASYNC_PF_INT) and implement interrupt-based
  'page-ready' handler.

Dan Wu (3):
  x86: Add a common header asyncpf.h
  x86: Add async page fault int test
  x86/asyncpf: Add CPUID feature bits check to ensure feature is
    available

 ci/cirrus-ci-fedora.yml |   1 +
 lib/x86/processor.h     |   6 ++
 x86/Makefile.common     |   3 +-
 x86/asyncpf.c           |  31 ++++++----
 x86/asyncpf.h           |  23 ++++++++
 x86/asyncpf_int.c       | 127 ++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg       |   6 +-
 7 files changed, 185 insertions(+), 12 deletions(-)
 create mode 100644 x86/asyncpf.h
 create mode 100644 x86/asyncpf_int.c

-- 
2.39.3


