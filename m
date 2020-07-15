Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40612216A9
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 22:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGOU4u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 16:56:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:52919 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgGOU4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 16:56:50 -0400
IronPort-SDR: 2/opewqulrN6hrLpyBM+HseJn1OgLCOiz4LQPoh3djJryVLQGmECKxLtTf+r61RrNVEwQf1dWy
 IK2YCP7ypluw==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="146778076"
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="146778076"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 13:56:49 -0700
IronPort-SDR: UKSxa/PxHAyPwbXxRbMPl3eug2mS0ifarNlwyIbQdNUWTxx6/uYeqduX89MCzO/zWYi9bVWwA3
 UUMs7b7kbqbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,356,1589266800"; 
   d="scan'208";a="308388400"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jul 2020 13:56:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] cstart64: do not assume CR4 should be zero
Date:   Wed, 15 Jul 2020 13:52:35 -0700
Message-Id: <20200715205235.13113-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly zero cr4 in prepare_64() instead of "zeroing" it in the
common enter_long_mode().  Clobbering cr4 in enter_long_mode() breaks
switch_to_5level(), which sets cr4.LA57 before calling enter_long_mode()
and obviously expects cr4 to be preserved.

Fixes: d86ef58 ("cstart: do not assume CR4 starts as zero")
Cc: Nadav Amit <namit@vmware.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Two lines of code, two bugs.  I'm pretty sure Paolo should win some kind
of award. :-D

 x86/cstart64.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index 3ae98d3..2d16688 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -175,8 +175,12 @@ prepare_64:
 	lgdt gdt64_desc
 	setup_segments
 
+	xor %eax, %eax
+	mov %eax, %cr4
+
 enter_long_mode:
-	mov $(1 << 5), %eax // pae
+	mov %cr4, %eax
+	bts $5, %eax  // pae
 	mov %eax, %cr4
 
 	mov pt_root, %eax
-- 
2.26.0

