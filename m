Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6951D2808
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 08:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgENGlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 02:41:32 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52975 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgENGla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 02:41:30 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49N24k0zl4z9sTF; Thu, 14 May 2020 16:41:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1589438486;
        bh=sWnq0CpX5hEnPY8jzzlEivmO4eeQV2/1OD28ZMXjoWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhbLtkyuHPZtjEOw8yFQO0SrDjdsb6+E3Xn7PttBV0J7Q9DrXDf/jRfg4rN3wM9jH
         AqtL9sk08FH/J05bSAMimCtIOCkPyUjK65znfqUjAmUwCpS4te19CjFUvQKGwY3ITI
         M5z6q/tZbULYiefX/4W9NhiQXx6rjXdZAl7rlbBs=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.redhat.com,
        qemu-devel@nongnu.org, brijesh.singh@amd.com
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>, cohuck@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.-rg,
        mdroth@linux.vnet.ibm.com
Subject: [RFC 07/18] target/i386: sev: Remove redundant policy field
Date:   Thu, 14 May 2020 16:41:09 +1000
Message-Id: <20200514064120.449050-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514064120.449050-1-david@gibson.dropbear.id.au>
References: <20200514064120.449050-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEVState::policy is set from the final value of the policy field in the
parameter structure for the KVM_SEV_LAUNCH_START ioctl().  But, AFAICT
that ioctl() won't ever change it from the original supplied value which
comes from SevGuestState::policy.

So, remove this field and just use SevGuestState::policy directly.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 target/i386/sev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index c85f59d78f..1ba05cd2a6 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -39,7 +39,6 @@ struct SEVState {
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
-    uint32_t policy;
     uint64_t me_mask;
     uint32_t handle;
     int sev_fd;
@@ -400,7 +399,7 @@ sev_get_info(void)
         info->api_major = sev_guest->state.api_major;
         info->api_minor = sev_guest->state.api_minor;
         info->build_id = sev_guest->state.build_id;
-        info->policy = sev_guest->state.policy;
+        info->policy = sev_guest->policy;
         info->state = sev_guest->state.state;
         info->handle = sev_guest->state.handle;
     }
@@ -523,8 +522,7 @@ sev_launch_start(SevGuestState *sev)
 
     start->handle = object_property_get_int(OBJECT(sev), "handle",
                                             &error_abort);
-    start->policy = object_property_get_int(OBJECT(sev), "policy",
-                                            &error_abort);
+    start->policy = sev->policy;
     if (sev->session_file) {
         if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
             goto out;
@@ -553,7 +551,6 @@ sev_launch_start(SevGuestState *sev)
                             &error_abort);
     sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
     s->handle = start->handle;
-    s->policy = start->policy;
     ret = 0;
 
 out:
-- 
2.26.2

