Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D730B64B
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 05:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhBBEPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 23:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhBBEOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 23:14:45 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0547AC0613D6
        for <kvm@vger.kernel.org>; Mon,  1 Feb 2021 20:14:04 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DVBJ01fbkz9tlC; Tue,  2 Feb 2021 15:13:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612239200;
        bh=N7aZkZMAZjZ1mtft7AjfybYlaQ339ZQW3otqxHe66KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JP3/qk1qZq03RFyAcML9rtZhy+z27tS9QEFTNI17Ydw6LDcPZpHHBfteFsDdz1r+4
         4rz+/7cpDIjLJfGtVhe2WFrH025s4c/K81nCx9mA8an+fNVqeTASv49IBRCiQEit4C
         tZeTlTdBMzWTk+NfBi4DD9VtQHyhNePSZ8L07KvQ=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com, borntraeger@de.ibm.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH v8 11/13] spapr: PEF: prevent migration
Date:   Tue,  2 Feb 2021 15:13:13 +1100
Message-Id: <20210202041315.196530-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202041315.196530-1-david@gibson.dropbear.id.au>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We haven't yet implemented the fairly involved handshaking that will be
needed to migrate PEF protected guests.  For now, just use a migration
blocker so we get a meaningful error if someone attempts this (this is the
same approach used by AMD SEV).

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
---
 hw/ppc/pef.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
index f9fd1f2a71..573be3ed79 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -44,6 +44,8 @@ struct PefGuest {
 static int kvmppc_svm_init(Error **errp)
 {
 #ifdef CONFIG_KVM
+    static Error *pef_mig_blocker;
+
     if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
         error_setg(errp,
                    "KVM implementation does not support Secure VMs (is an ultravisor running?)");
@@ -58,6 +60,11 @@ static int kvmppc_svm_init(Error **errp)
         }
     }
 
+    /* add migration blocker */
+    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
+    /* NB: This can fail if --only-migratable is used */
+    migrate_add_blocker(pef_mig_blocker, &error_fatal);
+
     return 0;
 #else
     g_assert_not_reached();
-- 
2.29.2

