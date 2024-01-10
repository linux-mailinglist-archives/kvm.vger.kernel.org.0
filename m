Return-Path: <kvm+bounces-5980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A85D8293B2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 07:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7FC82869D3
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 06:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48DF838F84;
	Wed, 10 Jan 2024 06:27:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp238.sjtu.edu.cn (smtp238.sjtu.edu.cn [202.120.2.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631C838DE8
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 06:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sjtu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sjtu.edu.cn
Received: from mta90.sjtu.edu.cn (unknown [10.118.0.90])
	by smtp238.sjtu.edu.cn (Postfix) with ESMTPS id DC5B98B23;
	Wed, 10 Jan 2024 14:22:11 +0800 (CST)
Received: from mstore135.sjtu.edu.cn (unknown [10.118.0.135])
	by mta90.sjtu.edu.cn (Postfix) with ESMTP id B4AD837C878;
	Wed, 10 Jan 2024 14:22:11 +0800 (CST)
Date: Wed, 10 Jan 2024 14:22:11 +0800 (CST)
From: Zheyun Shen <szy0127@sjtu.edu.cn>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com
Message-ID: <982162224.1083330.1704867731391.JavaMail.zimbra@sjtu.edu.cn>
Subject: [PATCH] target/i386/sev: Add an option to allow SEV not to pin
 memory
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 10.0.5_GA_4574 (ZimbraWebClient - GC120 (Win)/10.0.5_GA_4574)
Thread-Index: 2z/N+LsUvJeJl+Li7PEkNfi8agF9BA==
Thread-Topic: target/i386/sev: Add an option to allow SEV not to pin memory

For now, SEV pins guest's memory to avoid swapping or
moving ciphertext, but leading to the inhibition of
Memory Ballooning.

In Memory Ballooning, only guest's free pages will be relocated
in balloon inflation and deflation, so the difference of plaintext
doesn't matter to guest.

Memory Ballooning is a nice memory overcommitment technology can
be used in CVM based on SEV and SEV-ES, so userspace tools can
provide an option to allow SEV not to pin memory.

Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>
---
 qapi/qom.json     |  7 ++++++-
 qemu-options.hx   |  5 ++++-
 target/i386/sev.c | 39 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 95516ba..c23397c 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -882,6 +882,10 @@
 # @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
+
+# @pin-memory: if true, sev initialization will pin guest's
+#     memory by registering to kvm, and disable ram block discard.
+#     (default: true)
 #
 # Since: 2.12
 ##
@@ -893,7 +897,8 @@
             '*handle': 'uint32',
             '*cbitpos': 'uint32',
             'reduced-phys-bits': 'uint32',
-            '*kernel-hashes': 'bool' } }
+            '*kernel-hashes': 'bool',
+            '*pin-memory': 'bool' } }
 
 ##
 # @ThreadContextProperties:
diff --git a/qemu-options.hx b/qemu-options.hx
index b66570a..1add214 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -5668,7 +5668,7 @@ SRST
                  -object secret,id=sec0,keyid=secmaster0,format=base64,\\
                      data=$SECRET,iv=$(<iv.b64)
 
-    ``-object sev-guest,id=id,cbitpos=cbitpos,reduced-phys-bits=val,[sev-device=string,policy=policy,handle=handle,dh-cert-file=file,session-file=file,kernel-hashes=on|off]``
+    ``-object sev-guest,id=id,cbitpos=cbitpos,reduced-phys-bits=val,[sev-device=string,policy=policy,handle=handle,dh-cert-file=file,session-file=file,kernel-hashes=on|off,pin-memory=on|off]``
         Create a Secure Encrypted Virtualization (SEV) guest object,
         which can be used to provide the guest memory encryption support
         on AMD processors.
@@ -5712,6 +5712,9 @@ SRST
         cmdline to a designated guest firmware page for measured Linux
         boot with -kernel. The default is off. (Since 6.2)
 
+        The ``pin-memory``  pins guest's memory in sev initialization.
+        The default is on.
+
         e.g to launch a SEV guest
 
         .. parsed-literal::
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9a71246..40be187 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -64,6 +64,7 @@ struct SevGuestState {
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
     bool kernel_hashes;
+        bool pin_memory;
 
     /* runtime state */
     uint32_t handle;
@@ -226,6 +227,9 @@ static void
 sev_ram_block_added(RAMBlockNotifier *n, void *host, size_t size,
                     size_t max_size)
 {
+        if (!sev_guest->pin_memory) {
+                return;
+        }
     int r;
     struct kvm_enc_region range;
     ram_addr_t offset;
@@ -256,6 +260,9 @@ static void
 sev_ram_block_removed(RAMBlockNotifier *n, void *host, size_t size,
                       size_t max_size)
 {
+        if (!sev_guest->pin_memory) {
+                return;
+        }
     int r;
     struct kvm_enc_region range;
     ram_addr_t offset;
@@ -353,6 +360,20 @@ static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
     sev->kernel_hashes = value;
 }
 
+static bool sev_guest_get_pin_memory(Object *obj, Error **errp)
+{
+    SevGuestState *sev = SEV_GUEST(obj);
+
+    return sev->pin_memory;
+}
+
+static void sev_guest_set_pin_memory(Object *obj, bool value, Error **errp)
+{
+    SevGuestState *sev = SEV_GUEST(obj);
+
+    sev->pin_memory = value;
+}
+
 static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
@@ -376,6 +397,11 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                    sev_guest_set_kernel_hashes);
     object_class_property_set_description(oc, "kernel-hashes",
             "add kernel hashes to guest firmware for measured Linux boot");
+    object_class_property_add_bool(oc, "pin-memory",
+                                   sev_guest_get_pin_memory,
+                                   sev_guest_set_pin_memory);
+    object_class_property_set_description(oc, "pin-memory",
+            "pin guest memory at initialization");
 }
 
 static void
@@ -383,6 +409,7 @@ sev_guest_instance_init(Object *obj)
 {
     SevGuestState *sev = SEV_GUEST(obj);
 
+        sev->pin_memory = true;
     sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
     sev->policy = DEFAULT_GUEST_POLICY;
     object_property_add_uint32_ptr(obj, "policy", &sev->policy,
@@ -920,11 +947,13 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return 0;
     }
 
-    ret = ram_block_discard_disable(true);
-    if (ret) {
-        error_report("%s: cannot disable RAM discard", __func__);
-        return -1;
-    }
+        if (sev->pin_memory) {
+                ret = ram_block_discard_disable(true);
+                if (ret) {
+                        error_report("%s: cannot disable RAM discard", __func__);
+                        return -1;
+                }
+        }
 
     sev_guest = sev;
     sev->state = SEV_STATE_UNINIT;
--
2.34.1

