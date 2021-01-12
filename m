Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE02F2749
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 05:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbhALEp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 23:45:59 -0500
Received: from ozlabs.org ([203.11.71.1]:48037 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731559AbhALEp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 23:45:59 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DFJ0S42M5z9t18; Tue, 12 Jan 2021 15:45:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610426712;
        bh=U34ioj+EjS4wgtSHG2jFZVWN7LCIU1LR2wuCkfl/yQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHlNPvTs2cVT4cdB4OoM2f6kPlbweBcyVlgDWwLL0deqq6QjZOtUnzBPtTC5AAEao
         MUf085r+zcwFu5na/WvmN6CPmh7/7lHFD2/66ApEtHtKx3KSFhu/73XUFxrxOwoXgn
         V23aCD/QVnyVwmZaMtSCz8QYgV36R/CL9xP4NTgs=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, brijesh.singh@amd.com, pair@us.ibm.com,
        dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>,
        mdroth@linux.vnet.ibm.com, richard.henderson@linaro.org,
        kvm@vger.kernel.org,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
Subject: [PATCH v6 11/13] spapr: PEF: prevent migration
Date:   Tue, 12 Jan 2021 15:45:06 +1100
Message-Id: <20210112044508.427338-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112044508.427338-1-david@gibson.dropbear.id.au>
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
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
---
 hw/ppc/pef.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
index b227dc6905..822668d9ae 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -38,6 +38,8 @@ struct PefGuestState {
 };
 
 #ifdef CONFIG_KVM
+static Error *pef_mig_blocker;
+
 static int kvmppc_svm_init(Error **errp)
 {
     if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
@@ -54,6 +56,11 @@ static int kvmppc_svm_init(Error **errp)
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

