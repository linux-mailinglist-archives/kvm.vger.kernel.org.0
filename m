Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A22022BC34
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 04:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgGXC6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 22:58:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35687 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgGXC5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 22:57:52 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4BCYlw1T28z9sTK; Fri, 24 Jul 2020 12:57:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1595559468;
        bh=oUlu8u5TiukpYL5YY0i+HjSckV5d3NnHfXBN6cEFoNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAM+uwL/E+M/lqPo6JwEV3OirVdPwoH0YUjmphFtXRnwwwmqxPNOtpZXt6UKp+3y2
         kVvh0eEmXx8oPDzXuZjXDRfW1jIUhPJ/GeNmPPagmkoRSudKOBfc+1SUViCmyhbYOT
         k/e5svfcGURMKHpEqITtS1JU8RUB0oQRn4sjEifo=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com
Cc:     ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, pasic@linux.ibm.com, qemu-s390x@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [for-5.2 v4 08/10] spapr: PEF: block migration
Date:   Fri, 24 Jul 2020 12:57:42 +1000
Message-Id: <20200724025744.69644-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200724025744.69644-1-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
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

