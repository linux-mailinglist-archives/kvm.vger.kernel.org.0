Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8026D389D2E
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhETFpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:45:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:47737 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230333AbhETFoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:44:55 -0400
IronPort-SDR: A3PNwe1ynkfD8zY6s2lo3DnPczoVmITfLHZYduGfenMektibP5QwVdDvqPnfKEg7UFddAfDkJG
 KltOFe5NJhxg==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="180751698"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="180751698"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 22:43:33 -0700
IronPort-SDR: n3O+14PWJTQ0MUWrvf08martYtv6lVc7Ru0hSuFsbqGNNwijTesT7KnPeBMwwphR8dqN0Y+vU2
 pNo0HELEKDXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440160277"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.172])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 22:43:31 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        seanjc@google.com, richard.henderson@linaro.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 0/6] Enable CET support for guest
Date:   Thu, 20 May 2021 13:57:05 +0800
Message-Id: <1621490231-4765-1-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP). It includes two features:
Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT).
This patch series is to enable CET related CPUID report, XSAVES/XRSTORS
support and MSR access etc. for guest.

Change in v8:
- Extended xsave_area_size() to accommodate compacted format size calculation.
- Added CPUID(0xD,1).EBX assigment per maintain's feedback.
- Changed XSS field check and added more comments to make things clearer.
- Other ajustment per maintainer's review feedback.
- Rebased to 6.0.0.

v7 patch:
https://lore.kernel.org/kvm/20210226022058.24562-1-weijiang.yang@intel.com

CET KVM patches:
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=intel

CET kernel patches:
https://lkml.kernel.org/r/20210427204315.24153-1-yu-cheng.yu@intel.com


Yang Weijiang (6):
  target/i386: Change XSAVE related feature-word names
  target/i386: Enable XSS feature CPUID enumeration
  target/i386: Enable XSAVES support for CET states
  target/i386: Add user-space MSR access interface for CET
  target/i386: Add CET state support for guest migration
  target/i386: Advise CET bits in CPU/MSR feature words

 target/i386/cpu.c     | 138 +++++++++++++++++++++++++++++-------
 target/i386/cpu.h     |  52 +++++++++++++-
 target/i386/kvm/kvm.c |  72 +++++++++++++++++++
 target/i386/machine.c | 161 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 395 insertions(+), 28 deletions(-)

-- 
2.26.2

