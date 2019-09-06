Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0401BABDCE
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 18:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390539AbfIFQew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 12:34:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:9378 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390335AbfIFQev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 12:34:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 09:34:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="174327227"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Sep 2019 09:34:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Evgeny Yakovlev <wrfsh@yandex-team.ru>
Subject: [kvm-unit-tests PATCH 1/3] x86: Fix out of bounds access when processing online_cpus
Date:   Fri,  6 Sep 2019 09:34:48 -0700
Message-Id: <20190906163450.30797-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190906163450.30797-1-sean.j.christopherson@intel.com>
References: <20190906163450.30797-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

online_cpus is misdeclared as a 64 *byte* variable instead of a 64 *bit*
variable.  This causes init_apic_map() to test random bytes when it
iterates over online_cpus, which in turn can cause it to overflow id_map
and corrupt rnadom memory, e.g. pg_base.  Declare online_cpus using
MAX_TEST_CPUS, which presumably is set explicitly to match the storage
size of online_cpus (64-bit values == max of 64 CPUS).

Reported-by: Evgeny Yakovlev <wrfsh@yandex-team.ru>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 lib/x86/apic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index b3e39ae..f43e9ef 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -232,13 +232,13 @@ void mask_pic_interrupts(void)
     outb(0xff, 0xa1);
 }
 
-extern unsigned char online_cpus[256 / 8];
+extern unsigned char online_cpus[MAX_TEST_CPUS / 8];
 
 void init_apic_map(void)
 {
 	unsigned int i, j = 0;
 
-	for (i = 0; i < sizeof(online_cpus) * 8; i++) {
+	for (i = 0; i < MAX_TEST_CPUS; i++) {
 		if ((1ul << (i % 8)) & (online_cpus[i / 8]))
 			id_map[j++] = i;
 	}
-- 
2.22.0

