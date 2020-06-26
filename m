Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC55620AEEF
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgFZJ0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:26:02 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:59908 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbgFZJ0B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:26:01 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 26 Jun 2020 02:25:55 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id EE476B1605;
        Fri, 26 Jun 2020 05:25:59 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 1/3] x86: realmode: initialize idtr
Date:   Fri, 26 Jun 2020 02:23:31 -0700
Message-ID: <20200626092333.2830-2-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200626092333.2830-1-namit@vmware.com>
References: <20200626092333.2830-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The realmode test does not initialize the IDTR, assuming that its base
is zero and its limit 0x3ff. Initialize it, as the BIOS might not set it
as such.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/realmode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 234d607..ef79f7e 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1799,6 +1799,7 @@ void realmode_start(void)
 unsigned long long r_gdt[] = { 0, 0x9b000000ffff, 0x93000000ffff };
 
 struct table_descr r_gdt_descr = { sizeof(r_gdt) - 1, &r_gdt };
+struct table_descr r_idt_descr = { 0x3ff, 0 };
 
 asm(
 	".section .init \n\t"
@@ -1819,6 +1820,7 @@ asm(
 	".text \n\t"
 	"start: \n\t"
 	"lgdt r_gdt_descr \n\t"
+	"lidt r_idt_descr \n\t"
 	"ljmp $8, $1f; 1: \n\t"
 	".code16gcc \n\t"
 	"mov $16, %eax \n\t"
-- 
2.20.1

