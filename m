Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A28F397A55
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 21:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhFATB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 15:01:58 -0400
Received: from [201.28.113.2] ([201.28.113.2]:59984 "EHLO
        outlook.eldorado.org.br" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S234684AbhFATBy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 15:01:54 -0400
X-Greylist: delayed 1024 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2021 15:01:54 EDT
Received: from power9a ([10.10.71.235]) by outlook.eldorado.org.br with Microsoft SMTPSVC(8.5.9600.16384);
         Tue, 1 Jun 2021 15:43:04 -0300
Received: from eldorado.org.br (unknown [10.10.71.235])
        by power9a (Postfix) with ESMTP id 161CF80148B;
        Tue,  1 Jun 2021 15:43:04 -0300 (-03)
From:   "Bruno Larsen (billionai)" <bruno.larsen@eldorado.org.br>
To:     qemu-devel@nongnu.org
Cc:     "Bruno Larsen (billionai)" <bruno.larsen@eldorado.org.br>,
        fernando.valle@eldorado.org.br, matheus.ferst@eldorado.org.br,
        david@gibson.dropbear.id.au, farosas@linux.ibm.com,
        lucas.araujo@eldorado.org.br, luis.pires@eldorado.org.br,
        qemu-ppc@nongnu.org, richard.henderson@linaro.org,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [RFC PATCH] target/ppc: removed usage of ppc_store_sdr1 in kvm.c
Date:   Tue,  1 Jun 2021 15:42:42 -0300
Message-Id: <20210601184242.122895-1-bruno.larsen@eldorado.org.br>
X-Mailer: git-send-email 2.17.1
X-OriginalArrivalTime: 01 Jun 2021 18:43:04.0226 (UTC) FILETIME=[F4B6A820:01D75715]
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only use of this function in kvm.c is right after using the KVM
ioctl to get the registers themselves, so there is no need to do the
error checks done by ppc_store_sdr1.

The probable reason this was here before is because of the hack where
KVM PR stores the hash table size along with the SDR1 information, but
since ppc_store_sdr1 would also store that information, there should be
no need to do any extra processing here.

Signed-off-by: Bruno Larsen (billionai) <bruno.larsen@eldorado.org.br>
---

This change means we won't have to compile ppc_store_sdr1 when we get
disable-tcg working, but I'm not working on that code motion just yet
since Lucas is dealing with the same file.

I'm sending this as an RFC because I'm pretty sure I'm missing
something, but from what I can see, this is all we'd need

 target/ppc/kvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 104a308abb..3f52a7189d 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1159,7 +1159,11 @@ static int kvmppc_get_books_sregs(PowerPCCPU *cpu)
     }
 
     if (!cpu->vhyp) {
-        ppc_store_sdr1(env, sregs.u.s.sdr1);
+        /*
+         * We have just gotten the SDR1, there should be no
+         * reason to do error checking.... right?
+         */
+        env->spr[SPR_SDR1] = sregs.u.s.sdr1;
     }
 
     /* Sync SLB */
-- 
2.17.1

