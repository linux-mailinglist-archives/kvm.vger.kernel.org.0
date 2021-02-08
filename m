Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52189312A86
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 07:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBHGJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 01:09:40 -0500
Received: from ozlabs.org ([203.11.71.1]:53379 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229854AbhBHGI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 01:08:28 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4DYwY64qSJz9sWR; Mon,  8 Feb 2021 17:07:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1612764458;
        bh=EX4Wo8XL9ghYEf3SyZWEad+uxvbQlvG/RZ3Zj48wzzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gE//jotXTS1nuRpkRS3lwTtC8TlpwYP3Nyqf9CTcvtXus/lLSCuVw3p7bQWa/J/7L
         zoQqN2N2z6pzJwbRJ9ayRrAy8ATieopI6qLpe7ASGR2L6HIzPYSE1Y6Lwu20/sD5ZM
         1+cGw6Tz3Aw6ZFD37NoY9C2sFhHsIGeu0ZE3LNzw=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     pair@us.ibm.com, qemu-devel@nongnu.org, peter.maydell@linaro.org,
        dgilbert@redhat.com, brijesh.singh@amd.com, pasic@linux.ibm.com
Cc:     richard.henderson@linaro.org, ehabkost@redhat.com,
        cohuck@redhat.com, david@redhat.com, berrange@redhat.com,
        mtosatti@redhat.com, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        mst@redhat.com, borntraeger@de.ibm.com, mdroth@linux.vnet.ibm.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        jun.nakajima@intel.com, frankja@linux.ibm.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        qemu-ppc@nongnu.org, Thomas Huth <thuth@redhat.com>,
        andi.kleen@intel.com, Greg Kurz <groug@kaod.org>,
        qemu-s390x@nongnu.org
Subject: [PULL v9 09/13] confidential guest support: Update documentation
Date:   Mon,  8 Feb 2021 17:07:31 +1100
Message-Id: <20210208060735.39838-10-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208060735.39838-1-david@gibson.dropbear.id.au>
References: <20210208060735.39838-1-david@gibson.dropbear.id.au>
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
Reviewed-by: Greg Kurz <groug@kaod.org>
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
index 0000000000..bd439ac800
--- /dev/null
+++ b/docs/confidential-guest-support.txt
@@ -0,0 +1,43 @@
+Confidential Guest Support
+==========================
+
+Traditionally, hypervisors such as QEMU have complete access to a
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

