Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645092F56CB
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbhANBxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbhANABN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:01:13 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94DDC0617B0
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:25 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXR3Gm0z9sj5; Thu, 14 Jan 2021 10:58:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582295;
        bh=NmD42X0WsHRqDVYpVVbDz7PiUpDumAPsjTSKm/2tvCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHnrJQZ9Z4likHKrb5Kig2JSXFW0K06BO15ZxTUk6xEr/KwURm9e9/XjyUT8EI6lB
         iY3L/J4gGwpnSp8p8o/6ndTeJ+yr82C+aujC7PsR2jVMwSVeh/t5Y3M4BvxM29ePok
         8hzRL5a/WrMh32T/jRpiEVR+JaU30Vjhv16FKmP4=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org
Cc:     cohuck@redhat.com,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        berrange@redhat.com, andi.kleen@intel.com
Subject: [PATCH v7 11/13] spapr: PEF: prevent migration
Date:   Thu, 14 Jan 2021 10:58:09 +1100
Message-Id: <20210113235811.1909610-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
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
index 02b9b3b460..d7a49ef337 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -42,6 +42,8 @@ struct PefGuest {
 };
 
 #ifdef CONFIG_KVM
+static Error *pef_mig_blocker;
+
 static int kvmppc_svm_init(Error **errp)
 {
     if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
@@ -58,6 +60,11 @@ static int kvmppc_svm_init(Error **errp)
         }
     }
 
+    /* add migration blocker */
+    error_setg(&pef_mig_blocker, "PEF: Migration is not implemented");
+    /* NB: This can fail if --only-migratable is used */
+    migrate_add_blocker(pef_mig_blocker, &error_fatal);
+
     return 0;
 }
 
-- 
2.29.2

