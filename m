Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21224200008
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 04:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgFSCGP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 22:06:15 -0400
Received: from ozlabs.org ([203.11.71.1]:48353 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729164AbgFSCGN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 22:06:13 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49p2GT40bYz9sT6; Fri, 19 Jun 2020 12:06:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1592532369;
        bh=oUlu8u5TiukpYL5YY0i+HjSckV5d3NnHfXBN6cEFoNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpLRJFPR1N23oZq2OQi5denxnJtl2OxBqOQnPDm3P9o+q4fZ5ysUcRMcPMD/rZTIM
         fgcPuCtC/xXL8TCuT3gP/WfwbsXGC9F3HeTX65JwHjfjT0DjaXNmyUmIY3q4H3J9uC
         BoMmZaz7l+Y+Dx4agziwde1pIyeDwdHvLvAaWS4k=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, mst@redhat.com, mdroth@linux.vnet.ibm.com,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, david@redhat.com
Subject: [PATCH v3 8/9] spapr: PEF: block migration
Date:   Fri, 19 Jun 2020 12:06:01 +1000
Message-Id: <20200619020602.118306-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619020602.118306-1-david@gibson.dropbear.id.au>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We haven't yet implemented the fairly involved handshaking that will be
needed to migrate PEF protected guests.  For now, just use a migration
blocker so we get a meaningful error if someone attempts this (this is the
same approach used by AMD SEV).

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/ppc/pef.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/ppc/pef.c b/target/ppc/pef.c
index 53a6af0347..6a50efd580 100644
--- a/target/ppc/pef.c
+++ b/target/ppc/pef.c
@@ -36,6 +36,8 @@ struct PefGuestState {
     Object parent_obj;
 };
 
+static Error *pef_mig_blocker;
+
 static int pef_kvm_init(HostTrustLimitation *gmpo, Error **errp)
 {
     if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
@@ -52,6 +54,10 @@ static int pef_kvm_init(HostTrustLimitation *gmpo, Error **errp)
         }
     }
 
+    /* add migration blocker */
+    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
+    migrate_add_blocker(pef_mig_blocker, &error_abort);
+
     return 0;
 }
 
-- 
2.26.2

