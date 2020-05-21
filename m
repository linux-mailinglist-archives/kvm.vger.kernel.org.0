Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC6F1DC5C4
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 05:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEUDnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 23:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgEUDnQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 23:43:16 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E55C061A0E
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 20:43:16 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49SFns27szz9sTg; Thu, 21 May 2020 13:43:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1590032593;
        bh=bf5Cd9xw2ZTvT2sR3eQKUWyajZbzGCNDJL88uOSTsxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSbn203Rcy19lTP/Uh82Cy4AGqsnatY7iLqO1Uu8XUf+L14nn+MXwj7IzuNAJs8GW
         i3uJUx/g84fqSywOCIEW/9jbHGEcBeg8ccTaDTqgmW8US17FJnd6H0XVtsN3Zf5t6z
         HxpqCsnypeqML8EXHQMmBW/KfTN4Ivk8ZV66ZFVU=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [RFC v2 07/18] target/i386: sev: Remove redundant policy field
Date:   Thu, 21 May 2020 13:42:53 +1000
Message-Id: <20200521034304.340040-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
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
index d25af37136..4b261beaa7 100644
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
@@ -397,7 +396,7 @@ sev_get_info(void)
         info->api_major = sev_guest->state.api_major;
         info->api_minor = sev_guest->state.api_minor;
         info->build_id = sev_guest->state.build_id;
-        info->policy = sev_guest->state.policy;
+        info->policy = sev_guest->policy;
         info->state = sev_guest->state.state;
         info->handle = sev_guest->state.handle;
     }
@@ -520,8 +519,7 @@ sev_launch_start(SevGuestState *sev)
 
     start->handle = object_property_get_int(OBJECT(sev), "handle",
                                             &error_abort);
-    start->policy = object_property_get_int(OBJECT(sev), "policy",
-                                            &error_abort);
+    start->policy = sev->policy;
     if (sev->session_file) {
         if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
             goto out;
@@ -550,7 +548,6 @@ sev_launch_start(SevGuestState *sev)
                             &error_abort);
     sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
     s->handle = start->handle;
-    s->policy = start->policy;
     ret = 0;
 
 out:
-- 
2.26.2

