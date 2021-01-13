Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493B72F56CD
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 02:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbhANBxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 20:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729703AbhANABN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 19:01:13 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7F7C0617A6
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 15:58:25 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DGPXR0hDnz9sX1; Thu, 14 Jan 2021 10:58:15 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1610582295;
        bh=XAe7Xx+YpNUPHcyhxW/cHKgMuEbgQoNbc1c/1ol/ah8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHrQo0CpGmuAyajbdwUMx7qgn9Kr7iTclU8Uk3Goi3mgJfMWU9Nzex3+mn0SUfPIy
         xecXjdlhCJ1+mTEjl5fbqWu0n2T0lKHXdsVYiVX+tGC9y732Yulz2rRkTGA0sx0BfA
         V3fI8nw9ocNIb/PNhEsP0m0vgGwV8LbBBaXzbDoM=
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
Subject: [PATCH v7 09/13] confidential guest support: Update documentation
Date:   Thu, 14 Jan 2021 10:58:07 +1100
Message-Id: <20210113235811.1909610-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we've implemented a generic machine option for configuring various
confidential guest support mechanisms:
  1. Update docs/amd-memory-encryption.txt to reference this rather than
     the earlier SEV specific option
  2. Add a docs/confidential-guest-support.txt to cover the generalities of
     the confidential guest support scheme

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 docs/amd-memory-encryption.txt      |  2 +-
 docs/confidential-guest-support.txt | 43 +++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 docs/confidential-guest-support.txt

diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
index 80b8eb00e9..145896aec7 100644
--- a/docs/amd-memory-encryption.txt
+++ b/docs/amd-memory-encryption.txt
@@ -73,7 +73,7 @@ complete flow chart.
 To launch a SEV guest
 
 # ${QEMU} \
-    -machine ...,memory-encryption=sev0 \
+    -machine ...,confidential-guest-support=sev0 \
     -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
 
 Debugging
diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
new file mode 100644
index 0000000000..2790425b38
--- /dev/null
+++ b/docs/confidential-guest-support.txt
@@ -0,0 +1,43 @@
+Confidential Guest Support
+==========================
+
+Traditionally, hypervisors such as qemu have complete access to a
+guest's memory and other state, meaning that a compromised hypervisor
+can compromise any of its guests.  A number of platforms have added
+mechanisms in hardware and/or firmware which give guests at least some
+protection from a compromised hypervisor.  This is obviously
+especially desirable for public cloud environments.
+
+These mechanisms have different names and different modes of
+operation, but are often referred to as Secure Guests or Confidential
+Guests.  We use the term "Confidential Guest Support" to distinguish
+this from other aspects of guest security (such as security against
+attacks from other guests, or from network sources).
+
+Running a Confidential Guest
+----------------------------
+
+To run a confidential guest you need to add two command line parameters:
+
+1. Use "-object" to create a "confidential guest support" object.  The
+   type and parameters will vary with the specific mechanism to be
+   used
+2. Set the "confidential-guest-support" machine parameter to the ID of
+   the object from (1).
+
+Example (for AMD SEV)::
+
+    qemu-system-x86_64 \
+        <other parameters> \
+        -machine ...,confidential-guest-support=sev0 \
+        -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
+
+Supported mechanisms
+--------------------
+
+Currently supported confidential guest mechanisms are:
+
+AMD Secure Encrypted Virtualization (SEV)
+    docs/amd-memory-encryption.txt
+
+Other mechanisms may be supported in future.
-- 
2.29.2

