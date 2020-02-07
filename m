Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C80A155ABB
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGPaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:30:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51924 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGPaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:30:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581089413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kzWDSvBw3VE0LQexdqxKLxFwvOaZNkpkVRmLXLOnsBk=;
        b=L6fqpXULUL2fVANkrYXLheZbbYp29ybG7+KPttvj44HzQhMZsEQEZTJKkNy9Ef+7m4Gef4
        CuP30aPhXSRotdErKbO0arafd+9iulTnin/QcNQ/SI2yzdYb9vEXRET/rM5HIlfZlCPHLc
        U4jdKrBKaBPJv30I67LZv+WC0uxZpnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-LjFylj3BMU6NoqA-Cqke4Q-1; Fri, 07 Feb 2020 10:30:09 -0500
X-MC-Unique: LjFylj3BMU6NoqA-Cqke4Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56B941085933
        for <kvm@vger.kernel.org>; Fri,  7 Feb 2020 15:30:08 +0000 (UTC)
Received: from paraplu.localdomain (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ED547794F;
        Fri,  7 Feb 2020 15:30:07 +0000 (UTC)
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, dgilbert@redhat.com, vkuznets@redhat.com,
        Kashyap Chamarthy <kchamart@redhat.com>
Subject: [PATCH] docs/virt/kvm: Document running nested guests
Date:   Fri,  7 Feb 2020 16:30:02 +0100
Message-Id: <20200207153002.16081-1-kchamart@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a rewrite of the Wiki page:

    https://www.linux-kvm.org/page/Nested_Guests

Signed-off-by: Kashyap Chamarthy <kchamart@redhat.com>
---
Question: is the live migration of L1-with-L2-running-in-it fixed for
*all* architectures, including s390x?
---
 .../virt/kvm/running-nested-guests.rst        | 171 ++++++++++++++++++
 1 file changed, 171 insertions(+)
 create mode 100644 Documentation/virt/kvm/running-nested-guests.rst

diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documenta=
tion/virt/kvm/running-nested-guests.rst
new file mode 100644
index 0000000000000000000000000000000000000000..e94ab665c71a36b7718aebae9=
02af16b792f6dd3
--- /dev/null
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -0,0 +1,171 @@
+Running nested guests with KVM
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+A nested guest is a KVM guest that in turn runs on a KVM guest::
+
+              .----------------.  .----------------.
+              |                |  |                |
+              |      L2        |  |      L2        |
+              | (Nested Guest) |  | (Nested Guest) |
+              |                |  |                |
+              |----------------'--'----------------|
+              |                                    |
+              |       L1 (Guest Hypervisor)        |
+              |          KVM (/dev/kvm)            |
+              |                                    |
+      .------------------------------------------------------.
+      |                 L0 (Host Hypervisor)                 |
+      |                    KVM (/dev/kvm)                    |
+      |------------------------------------------------------|
+      |                  x86 Hardware (VMX)                  |
+      '------------------------------------------------------'
+
+
+Terminology:
+
+  - L0 =E2=80=93 level-0; the bare metal host, running KVM
+
+  - L1 =E2=80=93 level-1 guest; a VM running on L0; also called the "gue=
st
+    hypervisor", as it itself is capable of running KVM.
+
+  - L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "nested =
guest"
+
+
+Use Cases
+---------
+
+An additional layer of virtualization sometimes can .  You
+might have access to a large virtual machine in a cloud environment that
+you want to compartmentalize into multiple workloads.  You might be
+running a lab environment in a training session.
+
+There are several scenarios where nested KVM can be Useful:
+
+  - As a developer, you want to test your software on different OSes.
+    Instead of renting multiple VMs from a Cloud Provider, using nested
+    KVM lets you rent a large enough "guest hypervisor" (level-1 guest).
+    This in turn allows you to create multiple nested guests (level-2
+    guests), running different OSes, on which you can develop and test
+    your software.
+
+  - Live migration of "guest hypervisors" and their nested guests, for
+    load balancing, disaster recovery, etc.
+
+  - Using VMs for isolation (as in Kata Containers, and before it Clear
+    Containers https://lwn.net/Articles/644675/) if you're running on a
+    cloud provider that is already using virtual machines
+
+
+Procedure to enable nesting on the bare metal host
+--------------------------------------------------
+
+The KVM kernel modules do not enable nesting by default (though your
+distribution may override this default).  To enable nesting, set the
+``nested`` module parameter to ``Y`` or ``1``. You may set this
+parameter persistently in a file in ``/etc/modprobe.d`` in the L0 host:
+
+1. On the bare metal host (L0), list the kernel modules, and ensure that
+   the KVM modules::
+
+    $ lsmod | grep -i kvm
+    kvm_intel             133627  0
+    kvm                   435079  1 kvm_intel
+
+2. Show information for ``kvm_intel`` module::
+
+    $ modinfo kvm_intel | grep -i nested
+    parm:           nested:boolkvm                   435079  1 kvm_intel
+
+3. To make nested KVM configuration persistent across reboots, place the
+   below entry in a config attribute::
+
+    $ cat /etc/modprobe.d/kvm_intel.conf
+    options kvm-intel nested=3Dy
+
+4. Unload and re-load the KVM Intel module::
+
+    $ sudo rmmod kvm-intel
+    $ sudo modprobe kvm-intel
+
+5. Verify if the ``nested`` parameter for KVM is enabled::
+
+    $ cat /sys/module/kvm_intel/parameters/nested
+    Y
+
+For AMD hosts, the process is the same as above, except that the module
+name is ``kvm-amd``.
+
+Once your bare metal host (L0) is configured for nesting, you should be
+able to start an L1 guest with ``qemu-kvm -cpu host`` (which passes
+through the host CPU's capabilities as-is to the guest); or for better
+live migration compatibility, use a named CPU model supported by QEMU,
+e.g.: ``-cpu Haswell-noTSX-IBRS,vmx=3Don`` and the guest will subsequent=
ly
+be capable of running an L2 guest with accelerated KVM.
+
+Additional nested-related kernel parameters
+-------------------------------------------
+
+If your hardware is sufficiently advanced (Intel Haswell processor or
+above which has newer hardware virt extensions), you might want to
+enable additional features: "Shadow VMCS (Virtual Machine Control
+Structure)", APIC Virtualization on your bare metal host (L0).
+Parameters for Intel hosts::
+
+    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
+    Y
+
+    $ cat /sys/module/kvm_intel/parameters/enable_apicv
+    N
+
+    $ cat /sys/module/kvm_intel/parameters/ept
+    Y
+
+Again, to persist the above values across reboot, append them to
+``/etc/modprobe.d/kvm_intel.conf``::
+
+    options kvm-intel nested=3Dy
+    options kvm-intel enable_shadow_vmcs=3Dy
+    options kvm-intel enable_apivc=3Dy
+    options kvm-intel ept=3Dy
+
+
+Live migration with nested KVM
+------------------------------
+
+The below live migration scenarios should work as of Linux kernel 5.3
+and QEMU 4.2.0.  In all the below cases, L1 exposes ``/dev/kvm`` in
+it, i.e. the L2 guest is a "KVM-accelerated guest", not a "plain
+emulated guest" (as done by QEMU's TCG).
+
+- Migrating a nested guest (L2) to another L1 guest on the *same* bare
+  metal host.
+
+- Migrating a nested guest (L2) to another L1 guest on a *different*
+  bare metal host.
+
+- Migrating an L1 guest, with an *offline* nested guest in it, to
+  another bare metal host.
+
+- Migrating an L1 guest, with a  *live* nested guest in it, to another
+  bare metal host.
+
+
+Limitations on Linux kernel versions older than 5.3
+---------------------------------------------------
+
+On Linux kernel versions older than 5.3, once an L1 guest has started an
+L2 guest, the L1 guest would no longer capable of being migrated, saved,
+or loaded (refer to QEMU documentation on "save"/"load") until the L2
+guest shuts down.  [FIXME: Is this limitation fixed for *all*
+architectures, including s390x?]
+
+Attempting to migrate or save & load an L1 guest while an L2 guest is
+running will result in undefined behavior.  You might see a ``kernel
+BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
+Such a migrated or loaded L1 guest can no longer be considered stable or
+secure, and must be restarted.
+
+Migrating an L1 guest merely configured to support nesting, while not
+actually running L2 guests, is expected to function normally.
+Live-migrating an L2 guest from one L1 guest to another is also expected
+to succeed.
--=20
2.21.0

