Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B85E325B72
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 03:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZCKI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 21:10:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:38815 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhBZCKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 21:10:07 -0500
IronPort-SDR: YkgfKQUQ8X8qrUqsuJFY+NxLXO4cVQz5GLjJKSNO6lTjiaUKTJfAl4PgGC5maKwA+1s9Oodpti
 2LrpQ25T6qNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185800989"
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="185800989"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2021 18:09:26 -0800
IronPort-SDR: xOwwmjowfjV7aycmDHUcC2m3gRoi3SONIf7RDFAKjUpQRXe4oqDnD/qwg3zVOScMfnsfEnGbNy
 VtdFHPSr8NaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,207,1610438400"; 
   d="scan'208";a="404679897"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 25 Feb 2021 18:09:24 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, richard.henderson@linaro.org,
        ehabkost@redhat.com, mtosatti@redhat.com,
        sean.j.christopherson@intel.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 0/6] Enable CET support for guest 
Date:   Fri, 26 Feb 2021 10:20:52 +0800
Message-Id: <20210226022058.24562-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Control-flow Enforcement Technology (CET) provides protection against
Return/Jump-Oriented Programming (ROP/JOP). It includes two features:
Shadow Stack(SHSTK) and Indirect Branch Tracking(IBT).
This patch series is to enable CET related CPUID report, XSAVES/XRSTORS
support and MSR access etc. for guest.

Change in v7:
- Reverted part of XSAVE feature-word naming change per review feedback.
- Fixed an issue blocking SHSTK and IBT used as two independent features
  if OS just enables either of them.
- Other minor changes during testing and review.
- Rebased to 5.2.0 base.

CET KVM patches:
https://lkml.kernel.org/r/20210203113421.5759-1-weijiang.yang@intel.com

CET kernel patches:
https://lkml.kernel.org/r/20210217222730.15819-1-yu-cheng.yu@intel.com


Yang Weijiang (6):
  target/i386: Change XSAVE related feature-word names
  target/i386: Enable XSS feature enumeration for CPUID
  target/i386: Enable CET components support for XSAVES
  target/i386: Add user-space MSR access interface for CET
  target/i386: Add CET state support for guest migration
  target/i386: Advise CET bits in CPU/MSR feature words

 target/i386/cpu.c     | 113 +++++++++++++++++++++++------
 target/i386/cpu.h     |  55 ++++++++++++++-
 target/i386/kvm.c     |  72 +++++++++++++++++++
 target/i386/machine.c | 161 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 379 insertions(+), 22 deletions(-)

-- 
2.26.2

