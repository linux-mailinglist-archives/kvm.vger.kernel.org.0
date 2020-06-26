Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CF420AEF0
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 11:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgFZJ0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 05:26:06 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:59908 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgFZJ0C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Jun 2020 05:26:02 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 26 Jun 2020 02:25:55 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 07060B272D;
        Fri, 26 Jun 2020 05:26:00 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 2/3] x86: realmode: hlt loop as fallback on exit
Date:   Fri, 26 Jun 2020 02:23:32 -0700
Message-ID: <20200626092333.2830-3-namit@vmware.com>
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

For systems without emulated devices (e.g., bare-metal), use halt-loop
when exiting the realmode test.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/realmode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index ef79f7e..301b013 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -115,6 +115,10 @@ static int failed;
 static void exit(int code)
 {
 	outb(code, 0xf4);
+
+	while (1) {
+		asm volatile("hlt" ::: "memory");
+	}
 }
 
 struct regs {
-- 
2.20.1

