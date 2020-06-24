Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84671207D95
	for <lists+kvm@lfdr.de>; Wed, 24 Jun 2020 22:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391490AbgFXUiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 16:38:25 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:9153 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727981AbgFXUiX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jun 2020 16:38:23 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Wed, 24 Jun 2020 13:38:18 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 6260CB24B4;
        Wed, 24 Jun 2020 16:38:21 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [PATCH] x86: fix smp_stacktop on 32-bit
Date:   Wed, 24 Jun 2020 13:36:02 -0700
Message-ID: <20200624203602.44659-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

smp_stacktop in 32-bit is fixed to some magic address. Use the address
of the memory that was reserved for the stack instead.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/cstart.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/cstart.S b/x86/cstart.S
index 1d8b8ac..a072aed 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -134,7 +134,7 @@ prepare_32:
 	mov %eax, %cr0
 	ret
 
-smp_stacktop:	.long 0xa0000
+smp_stacktop:	.long stacktop - 4096
 
 save_id:
 	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
-- 
2.20.1

