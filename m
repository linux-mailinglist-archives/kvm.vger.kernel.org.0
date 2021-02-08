Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C38312A76
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhBHGHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:07:13 -0500
Received: from ozlabs.org ([203.11.71.1]:44627 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhBHGGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:35 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVt3vFWz9sWS; Mon,  8 Feb 2021 17:05:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764342;
        bh=N7aZkZMAZjZ1mtft7AjfybYlaQ339ZQW3otqxHe66KU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnnXAy+jknbLBjIcGZP9I7awVZdkh8WzFru4SAFtSPHo4EVXTPF67GcSSQwjjBVJh
         2a+8XbX0t0oTwxo/SvnNs8bf6lsorr6/5AK4Gofq+MGwy6wKsIzZ/nQGUgwDSHXXmm
         +6ZYHTklvtLAzO+MegAWjVUKxJ+mBTKwHLOJ5NNY=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pasic@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        jun.nakajima@intel.com, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, frankja@linux.ibm.com, andi.kleen@intel.com,
        cohuck@redhat.com, Thomas Huth <thuth@redhat.com>,
        borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        qemu-ppc@nongnu.org, David Hildenbrand <david@redhat.com>,
        Greg Kurz <groug@kaod.org>, pragyansri.pathi@intel.com
Subject: [PULL v9 11/13] spapr: PEF: prevent migration
Date:   Mon,  8 Feb 2021 17:05:36 +1100
Message-Id: <20210208060538.39276-12-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
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

