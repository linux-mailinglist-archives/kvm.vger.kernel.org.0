Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583F02CE7B6
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgLDFpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:43 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:52235 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728181AbgLDFpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:43 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8h5R7zz9sVv; Fri,  4 Dec 2020 16:44:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060660;
        bh=lCwJ3O4sNiYS7HxagCxP/NpsI9RVLllMh2C+EBE4vKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEw6C4v8bZxI94lZhAlLyeTaiqyeRSbJP2VK4KmnizsQ4wpJIFV8F0t+kCUmUVVBZ
         fmveDgtGjDJq/JuBqzuaCQG3ZK2M448N1+Qfe4RBotNgppJ5TIjMwbb/1q9RUCl8iM
         +sx71e29CEN1FADUNXJ37lo3oJ0yueV7XLjQ2UUg=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, David Gibson <david@gibson.dropbear.id.au>,
        cohuck@redhat.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com
Subject: [for-6.0 v5 11/13] spapr: PEF: prevent migration
Date:   Fri,  4 Dec 2020 16:44:13 +1100
Message-Id: <20201204054415.579042-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
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
 hw/ppc/pef.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
index 3ae3059cfe..edc3e744ba 100644
--- a/hw/ppc/pef.c
+++ b/hw/ppc/pef.c
@@ -38,7 +38,11 @@ struct PefGuestState {
 };
 
 #ifdef CONFIG_KVM
+static Error *pef_mig_blocker;
+
 static int kvmppc_svm_init(Error **errp)
+
+int kvmppc_svm_init(SecurableGuestMemory *sgm, Error **errp)
 {
     if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
         error_setg(errp,
@@ -54,6 +58,11 @@ static int kvmppc_svm_init(Error **errp)
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
2.28.0

