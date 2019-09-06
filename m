Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277A3ABDD0
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390521AbfIFQew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:34:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:9378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388260AbfIFQev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:34:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 09:34:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="174327229"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2019 09:34:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
Subject: [kvm-unit-tests PATCH 2/3] x86: Declare online_cpus based on MAX_TEST_CPUS
Date:   Fri,  6 Sep 2019 09:34:49 -0700
Message-Id: <20190906163450.30797-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190906163450.30797-1-sean.j.christopherson@intel.com>
References: <20190906163450.30797-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declare online_cpus so that it is properly sized to have MAX_TEST_CPUS
bits.  Currently, online_cpus is hardcoded to a u64, i.e. changing
MAX_TEST_CPUS to be greater than 64 will result in a variety of out of
bounds accesses.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/smp.c  | 2 --
 x86/cstart.S   | 2 +-
 x86/cstart64.S | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 30bd1a0..7b1e0e1 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -113,8 +113,6 @@ int cpus_active(void)
     return atomic_read(&active_cpus);
 }
 
-extern unsigned long long online_cpus;
-
 void smp_init(void)
 {
     int i;
diff --git a/x86/cstart.S b/x86/cstart.S
index 575101b..76f6ba5 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -208,7 +208,7 @@ smp_init_done:
 	ret
 
 online_cpus:
-	.quad 0
+	.fill max_cpus / 8, 1, 0
 
 cpu_online_count:	.word 1
 
diff --git a/x86/cstart64.S b/x86/cstart64.S
index d4e4652..89ad9f4 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -282,7 +282,7 @@ idt_descr:
 	.quad boot_idt
 
 online_cpus:
-	.quad 0
+	.fill max_cpus / 8, 1, 0
 
 load_tss:
 	lidtq idt_descr
-- 
2.22.0

