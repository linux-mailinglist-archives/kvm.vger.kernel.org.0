Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8233E2F56D2
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbhANBxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:44 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729680AbhAMX7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 18:59:09 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXQ6v7Cz9sWk; Thu, 14 Jan 2021 10:58:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582294;
        bh=idJr0chYvjooRoA3aqKnU601BZd17+94MhdcU47V62A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZL+y3MKlNgB5V+HRIddau2xZRc6ivsKrn3t/xFPR8WxiViIiH2Xk6XkGU+p50nzp3
         9PiQflWHy4l7o9AMlYI6cuxI6Ra0IMEMQUAlves2Zjz6icBTX85QlI1njCPu4/yEZ+
         0oS6eZN8sQ8K+HEg3dVIKHxSHipa8jKx9IAI+y9E=
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
Subject: [PATCH v7 07/13] confidential guest support: Introduce cgs "ready" flag
Date:   Thu, 14 Jan 2021 10:58:05 +1100
Message-Id: <20210113235811.1909610-8-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The platform specific details of mechanisms for implementing
confidential guest support may require setup at various points during
initialization.  Thus, it's not really feasible to have a single cgs
initialization hook, but instead each mechanism needs its own
initialization calls in arch or machine specific code.

However, to make it harder to have a bug where a mechanism isn't
properly initialized under some circumstances, we want to have a
common place, relatively late in boot, where we verify that cgs has
been initialized if it was requested.

This patch introduces a ready flag to the ConfidentialGuestSupport
base type to accomplish this, which we verify just before the machine
specific initialization function.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/core/machine.c                         | 8 ++++++++
 include/exec/confidential-guest-support.h | 2 ++
 target/i386/sev.c                         | 2 ++
 3 files changed, 12 insertions(+)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 94194ab82d..5a7433332b 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -1190,6 +1190,14 @@ void machine_run_board_init(MachineState *machine)
     }
 
     if (machine->cgs) {
+        /*
+         * Where confidential guest support is initialized depends on
+         * the specific mechanism in use.  But, we need to make sure
+         * it's ready by now.  If it isn't, that's a bug in the
+         * implementation of that cgs mechanism.
+         */
+        assert(machine->cgs->ready);
+
         /*
          * With confidential guests, the host can't see the real
          * contents of RAM, so there's no point in it trying to merge
diff --git a/include/exec/confidential-guest-support.h b/include/exec/confidential-guest-support.h
index 5f131023ba..bcaf6c9f49 100644
--- a/include/exec/confidential-guest-support.h
+++ b/include/exec/confidential-guest-support.h
@@ -27,6 +27,8 @@ OBJECT_DECLARE_SIMPLE_TYPE(ConfidentialGuestSupport, CONFIDENTIAL_GUEST_SUPPORT)
 
 struct ConfidentialGuestSupport {
     Object parent;
+
+    bool ready;
 };
 
 typedef struct ConfidentialGuestSupportClass {
diff --git a/target/i386/sev.c b/target/i386/sev.c
index e2b41ef342..3d94635397 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -737,6 +737,8 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
+    cgs->ready = true;
+
     return 0;
 err:
     sev_guest = NULL;
-- 
2.29.2

