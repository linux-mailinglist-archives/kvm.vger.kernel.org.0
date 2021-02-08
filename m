Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771C0312A6D
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBHGGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhBHGGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:06:31 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337D2C061786
        for <kvm@vger.kernel.org>; Sun,  7 Feb 2021 22:05:51 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwVs2m9Jz9sVn; Mon,  8 Feb 2021 17:05:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764341;
        bh=cnlEO+w/k8AwHUX8N63/06xxXcU3DOPo90IV/45n4iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgBirXVDLEBl7hnrWO70ZQ7qO+CYPp7szfnpV3uVC3Zidj0zlsKj/7ThjKH14T+NJ
         xwr9XM/KvVdsdPNKOsDrh6KmcwBKW9T4wmN52YQ7VEYVLLKVP15FXGAHUVgg7XgqPj
         djQEVYKevCZbOVncliguSwUATyobbyjjFmTti6n0=
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
Subject: [PULL v9 04/13] confidential guest support: Move side effect out of machine_set_memory_encryption()
Date:   Mon,  8 Feb 2021 17:05:29 +1100
Message-Id: <20210208060538.39276-5-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060538.39276-1-david@gibson.dropbear.id.au>
References: <20210208060538.39276-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the "memory-encryption" property is set, we also disable KSM
merging for the guest, since it won't accomplish anything.

We want that, but doing it in the property set function itself is
thereoretically incorrect, in the unlikely event of some configuration
environment that set the property then cleared it again before
constructing the guest.

More importantly, it makes some other cleanups we want more difficult.
So, instead move this logic to machine_run_board_init() conditional on
the final value of the property.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/core/machine.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 5d6163ab70..919067b5c9 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -437,14 +437,6 @@ static void machine_set_memory_encryption(Object *obj, const char *value,
 
     g_free(ms->memory_encryption);
     ms->memory_encryption = g_strdup(value);
-
-    /*
-     * With memory encryption, the host can't see the real contents of RAM,
-     * so there's no point in it trying to merge areas.
-     */
-    if (value) {
-        machine_set_mem_merge(obj, false, errp);
-    }
 }
 
 static bool machine_get_nvdimm(Object *obj, Error **errp)
@@ -1166,6 +1158,15 @@ void machine_run_board_init(MachineState *machine)
                     cc->deprecation_note);
     }
 
+    if (machine->memory_encryption) {
+        /*
+         * With memory encryption, the host can't see the real
+         * contents of RAM, so there's no point in it trying to merge
+         * areas.
+         */
+        machine_set_mem_merge(OBJECT(machine), false, &error_abort);
+    }
+
     machine_class->init(machine);
     phase_advance(PHASE_MACHINE_INITIALIZED);
 }
-- 
2.29.2

