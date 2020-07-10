Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC6721BD14
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 20:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgGJSfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 14:35:46 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:7518 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgGJSfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 14:35:43 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 10 Jul 2020 11:35:38 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id E5FB040CBC;
        Fri, 10 Jul 2020 11:35:42 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 3/4] x86: remove blind writes from setup_mmu()
Date:   Fri, 10 Jul 2020 11:33:19 -0700
Message-ID: <20200710183320.27266-4-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200710183320.27266-1-namit@vmware.com>
References: <20200710183320.27266-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Recent changes cause end_of_memory to be disregarded in 32-bit. Remove
the blind writes to it.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/x86/vm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 2bc2a39..41d6d96 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -151,9 +151,6 @@ void *setup_mmu(phys_addr_t end_of_memory)
 
     setup_mmu_range(cr3, 0, end_of_memory);
 #else
-    if (end_of_memory > (1ul << 31))
-	    end_of_memory = (1ul << 31);
-
     setup_mmu_range(cr3, 0, (2ul << 30));
     setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
     init_alloc_vpage((void*)(3ul << 30));
-- 
2.25.1

