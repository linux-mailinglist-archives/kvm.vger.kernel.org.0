Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E3320F1F0
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbgF3Js0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jun 2020 05:48:26 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:21770 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732078AbgF3JsW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Jun 2020 05:48:22 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 30 Jun 2020 02:48:19 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 2517FB211F;
        Tue, 30 Jun 2020 05:48:20 -0400 (EDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH 3/5] x86: svm: flush TLB on each test
Date:   Tue, 30 Jun 2020 02:45:14 -0700
Message-ID: <20200630094516.22983-4-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200630094516.22983-1-namit@vmware.com>
References: <20200630094516.22983-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several svm tests change PTEs but do not flush the TLB. To avoid messing
around or encountering new bugs in the future, flush the TLB on every
test.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/svm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/svm.c b/x86/svm.c
index f35c063..0fcad8d 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -170,6 +170,7 @@ void vmcb_ident(struct vmcb *vmcb)
 	if (npt_supported()) {
 		ctrl->nested_ctl = 1;
 		ctrl->nested_cr3 = (u64)pml4e;
+		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 }
 
-- 
2.25.1

