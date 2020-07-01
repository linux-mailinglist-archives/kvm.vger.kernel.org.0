Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE2C211383
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 21:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgGATdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 15:33:06 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:9757 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725771AbgGATdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Jul 2020 15:33:05 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 1 Jul 2020 12:33:03 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 429F1407A8;
        Wed,  1 Jul 2020 12:33:05 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: realmode: fix serial_init()
Date:   Wed, 1 Jul 2020 12:30:45 -0700
Message-ID: <20200701193045.31247-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some setups serial output from the real-mode tests is corrupted.

I do not know the serial port initialization code well, but the
protected mode initialization code is different than the real-mode code.
Using the protected mode serial port initialization fixes the problem.

Keeping the tradition of code duplication between real-mode and
protected mode, this patch copies the missing initialization into
real-mode serial port initialization.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/realmode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 90ecd13..7c2d776 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -77,6 +77,15 @@ static void serial_init(void)
 	lcr = inb(serial_iobase + 0x03);
 	lcr &= ~0x80;
 	outb(lcr, serial_iobase + 0x03);
+
+	/* IER: disable interrupts */
+	outb(0x00, serial_iobase + 0x01);
+	/* LCR: 8 bits, no parity, one stop bit */
+	outb(0x03, serial_iobase + 0x03);
+	/* FCR: disable FIFO queues */
+	outb(0x00, serial_iobase + 0x02);
+	/* MCR: RTS, DTR on */
+	outb(0x03, serial_iobase + 0x04);
 }
 #endif
 
-- 
2.17.1

