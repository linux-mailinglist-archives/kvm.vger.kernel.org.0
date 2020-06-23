Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C8A204CC6
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 10:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgFWIoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 04:44:02 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:2019 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731158AbgFWIoB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 04:44:01 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 23 Jun 2020 01:43:59 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 7E399407C6;
        Tue, 23 Jun 2020 01:44:01 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: Initialize segment selectors
Date:   Tue, 23 Jun 2020 01:41:32 -0700
Message-ID: <20200623084132.36213-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the BSP's segment selectors are not initialized in 32-bit
(cstart.S). As a result the tests implicitly rely on the segment
selector values that are set by the BIOS. If this assumption is not
kept, the task-switch test fails.

Fix it by initializing them.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/cstart.S | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index fa62e09..5ad70b5 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -94,6 +94,15 @@ MSR_GS_BASE = 0xc0000101
 	wrmsr
 .endm
 
+.macro setup_segments
+	mov $0x10, %ax
+	mov %ax, %ds
+	mov %ax, %es
+	mov %ax, %fs
+	mov %ax, %gs
+	mov %ax, %ss
+.endm
+
 .globl start
 start:
         mov $stacktop, %esp
@@ -109,6 +118,7 @@ start:
 
 prepare_32:
         lgdtl gdt32_descr
+	setup_segments
 
 	mov %cr4, %eax
 	bts $4, %eax  // pse
@@ -133,12 +143,7 @@ save_id:
 	retl
 
 ap_start32:
-	mov $0x10, %ax
-	mov %ax, %ds
-	mov %ax, %es
-	mov %ax, %fs
-	mov %ax, %gs
-	mov %ax, %ss
+	setup_segments
 	mov $-4096, %esp
 	lock/xaddl %esp, smp_stacktop
 	setup_percpu_area
-- 
2.20.1

