Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155EA2CE7B4
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 06:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgLDFpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 00:45:42 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54153 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgLDFpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 00:45:42 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4CnM8h1L2wz9sVt; Fri,  4 Dec 2020 16:44:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1607060660;
        bh=4EauSkQD4kf3/NsUuIz4zpH/jdlckopP7jBdsIJNjEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgPXfOzAOuOoBPOHOWWpAFUyEbqE8iXKps8pTVpnfIiP5ObF/yHua3SZ3sUmfYMoD
         jSmIGUjtGGFkOFYcN/eQWJlzcSqATpYn8vMbKlIvzXdhPnr4oKlEd5kiV2BaMe05Uk
         a58wlRW+tkhPrViITJm+BG+uQNK0RKsROy/tGTeY=
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
Subject: [for-6.0 v5 08/13] securable guest memory: Introduce sgm "ready" flag
Date:   Fri,  4 Dec 2020 16:44:10 +1100
Message-Id: <20201204054415.579042-9-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204054415.579042-1-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The platform specific details of mechanisms for implementing securable
guest memory may require setup at various points during initialization.
Thus, it's not really feasible to have a single sgm initialization hook,
but instead each mechanism needs its own initialization calls in arch or
machine specific code.

However, to make it harder to have a bug where a mechanism isn't properly
initialized under some circumstances, we want to have a common place,
relatively late in boot, where we verify that sgm has been initialized if
it was requested.

This patch introduces a ready flag to the SecurableGuestMemory base type
to accomplish this, which we verify just before the machine specific
initialization function.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c                     | 8 ++++++++
 include/exec/securable-guest-memory.h | 2 ++
 target/i386/sev.c                     | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 816ea3ae3e..a67a27d03c 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1155,6 +1155,14 @@ void machine_run_board_init(MachineState *machine)
     }
 
     if (machine->sgm) {
+        /*
+         * Where securable guest memory is initialized depends on the
+         * specific mechanism in use.  But, we need to make sure it's
+         * ready by now.  If it isn't, that's a bug in the
+         * implementation of that sgm mechanism.
+         */
+        assert(machine->sgm->ready);
+
         /*
          * With securable guest memory, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/exec/securable-guest-memory.h b/include/exec/securable-guest-memory.h
index 7325b504ba..20cf13777b 100644
--- a/include/exec/securable-guest-memory.h
+++ b/include/exec/securable-guest-memory.h
@@ -36,6 +36,8 @@
 
 struct SecurableGuestMemory {
     Object parent;
+
+    bool ready;
 };
 
 typedef struct SecurableGuestMemoryClass {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 7333a60dc0..022ce5fc3a 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -701,6 +701,8 @@ int sev_kvm_init(SecurableGuestMemory *sgm, Error **errp)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
+    sgm->ready = true;
+
     return 0;
 err:
     sev_guest = NULL;
-- 
2.28.0

