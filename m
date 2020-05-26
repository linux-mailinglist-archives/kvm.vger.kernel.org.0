Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E661C545A
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgEEL2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:28:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45930 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725766AbgEEL2x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 May 2020 07:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588678130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pH5v8lnkymv75dSfzGEf3HUvcOnzC2qJ7vr+cN2+9sQ=;
        b=S60OcNZZkVJ7OLXyCQOIxwC+f+oYL5IR4Z4lJsGbnXk89r1488dJ8g/LOjU6On5yFt8sAE
        2gNZbpIIoKIt6I7M8GQHfcQ5EC9DRF63Cy1Ctu2l3Y+JD6UubIftHZQ9cjRbNAvZzkEO9H
        sxxlme1YUFSE9NJ5yJM0fgUnfCTDCVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-3iuswwebPdyJJlS2QcFZpQ-1; Tue, 05 May 2020 07:28:46 -0400
X-MC-Unique: 3iuswwebPdyJJlS2QcFZpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3027510766DB
        for <kvm@vger.kernel.org>; Tue,  5 May 2020 11:28:45 +0000 (UTC)
Received: from paraplu.localdomain (unknown [10.36.110.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5112D60BEC;
        Tue,  5 May 2020 11:28:43 +0000 (UTC)
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, dgilbert@redhat.com, cohuck@redhat.com,
        vkuznets@redhat.com, Kashyap Chamarthy <kchamart@redhat.com>
Subject: [PATCH v3] docs/virt/kvm: Document configuring and running nested guests
Date:   Tue,  5 May 2020 13:28:39 +0200
Message-Id: <20200505112839.30534-1-kchamart@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a rewrite of this[1] Wiki page with further enhancements.  The
doc also includes a section on debugging problems in nested
environments, among other improvements.

[1] https://www.linux-kvm.org/page/Nested_Guests

Signed-off-by: Kashyap Chamarthy <kchamart@redhat.com>
---
- In v3:
  - Address feedback from Paolo and Cornelia from v2:
    https://marc.info/?t=3D158738155500003&r=3D1&w=3D2

- In v2:
  - Address Cornelia's feedback v1:
    https://marc.info/?l=3Dkvm&m=3D158109042605606&w=3D2
  - Address Dave's feedback from v1:
    https://marc.info/?l=3Dkvm&m=3D158109134905930&w=3D2

- v1 is here: https://marc.info/?l=3Dkvm&m=3D158108941605311&w=3D2
---
 .../virt/kvm/running-nested-guests.rst        | 287 ++++++++++++++++++
 1 file changed, 287 insertions(+)
 create mode 100644 Documentation/virt/kvm/running-nested-guests.rst

diff --git a/Documentation/virt/kvm/running-nested-guests.rst b/Documenta=
tion/virt/kvm/running-nested-guests.rst
new file mode 100644
index 0000000000000000000000000000000000000000..72b5a9bc7b456c28ea5c45f22=
89ff4ba0211db6f
--- /dev/null
+++ b/Documentation/virt/kvm/running-nested-guests.rst
@@ -0,0 +1,287 @@
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+Running nested guests with KVM
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
+
+A nested guest is the ability to run a guest inside another guest (it
+can be KVM-based or a different hypervisor).  The straightforward
+example is a KVM guest that in turn runs on a KVM guest (the rest of
+this document is built on this example)::
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
+      |        Hardware (with virtualization extensions)     |
+      '------------------------------------------------------'
+
+Terminology:
+
+- L0 =E2=80=93 level-0; the bare metal host, running KVM
+
+- L1 =E2=80=93 level-1 guest; a VM running on L0; also called the "guest
+  hypervisor", as it itself is capable of running KVM.
+
+- L2 =E2=80=93 level-2 guest; a VM running on L1, this is the "nested gu=
est"
+
+.. note:: The above diagram is modelled after the x86 architecture;
+          s390x, ppc64 and other architectures are likely to have
+          a different design for nesting.
+
+          For example, s390x always has an LPAR (LogicalPARtition)
+          hypervisor running on bare metal, adding another layer and
+          resulting in at least four levels in a nested setup =E2=80=94 =
L0 (bare
+          metal, running the LPAR hypervisor), L1 (host hypervisor), L2
+          (guest hypervisor), L3 (nested guest).
+
+          This document will stick with the three-level terminology (L0,
+          L1, and L2) for all architectures; and will largely focus on
+          x86.
+
+
+Use Cases
+---------
+
+There are several scenarios where nested KVM can be useful, to name a
+few:
+
+- As a developer, you want to test your software on different operating
+  systems (OSes).  Instead of renting multiple VMs from a Cloud
+  Provider, using nested KVM lets you rent a large enough "guest
+  hypervisor" (level-1 guest).  This in turn allows you to create
+  multiple nested guests (level-2 guests), running different OSes, on
+  which you can develop and test your software.
+
+- Live migration of "guest hypervisors" and their nested guests, for
+  load balancing, disaster recovery, etc.
+
+- VM image creation tools (e.g. ``virt-install``,  etc) often run
+  their own VM, and users expect these to work inside a VM.
+
+- Some OSes use virtualization internally for security (e.g. to let
+  applications run safely in isolation).
+
+
+Enabling "nested" (x86)
+-----------------------
+
+From Linux kernel v4.19 onwards, the ``nested`` KVM parameter is enabled
+by default for Intel and AMD.  (Though your Linux distribution might
+override this default.)
+
+In case you are running a Linux kernel older than v4.19, to enable
+nesting, set the ``nested`` KVM module parameter to ``Y`` or ``1``.  To
+persist this setting across reboots, you can add it in a config file, as
+shown below:
+
+1. On the bare metal host (L0), list the kernel modules and ensure that
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
+3. For the nested KVM configuration to persist across reboots, place the
+   below in ``/etc/modprobed/kvm_intel.conf`` (create the file if it
+   doesn't exist)::
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
+
+Additional nested-related kernel parameters (x86)
+-------------------------------------------------
+
+If your hardware is sufficiently advanced (Intel Haswell processor or
+higher, which has newer hardware virt extensions), the following
+additional features will also be enabled by default: "Shadow VMCS
+(Virtual Machine Control Structure)", APIC Virtualization on your bare
+metal host (L0).  Parameters for Intel hosts::
+
+    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
+    Y
+
+    $ cat /sys/module/kvm_intel/parameters/enable_apicv
+    Y
+
+    $ cat /sys/module/kvm_intel/parameters/ept
+    Y
+
+.. note:: If you suspect your L2 (i.e. nested guest) is running slower,
+          ensure the above are enabled (particularly
+          ``enable_shadow_vmcs`` and ``ept``).
+
+
+Starting a nested guest (x86)
+-----------------------------
+
+Once your bare metal host (L0) is configured for nesting, you should be
+able to start an L1 guest with::
+
+    $ qemu-kvm -cpu host [...]
+
+The above will pass through the host CPU's capabilities as-is to the
+gues); or for better live migration compatibility, use a named CPU
+model supported by QEMU. e.g.::
+
+    $ qemu-kvm -cpu Haswell-noTSX-IBRS,vmx=3Don
+
+then the guest hypervisor will subsequently be capable of running a
+nested guest with accelerated KVM.
+
+
+Enabling "nested" (s390x)
+-------------------------
+
+1. On the host hypervisor (L0), enable the ``nested`` parameter on
+   s390x::
+
+    $ rmmod kvm
+    $ modprobe kvm nested=3D1
+
+.. note:: On s390x, the kernel parameter ``hpage`` is mutually exclusive
+          with the ``nested`` paramter =E2=80=94 i.e. to be able to enab=
le
+          ``nested``, the ``hpage`` parameter *must* be disabled.
+
+2. The guest hypervisor (L1) must be provided with the ``sie`` CPU
+   feature =E2=80=94 with QEMU, this can be done by using "host passthro=
ugh"
+   (via the command-line ``-cpu host``).
+
+3. Now the KVM module can be loaded in the L1 (guest hypervisor)::
+
+    $ modprobe kvm
+
+
+Live migration with nested KVM
+------------------------------
+
+The below live migration scenarios should work as of Linux kernel 5.3
+and QEMU 4.2.0 for x86; for s390x, even older versions might work.
+In all the below cases, L1 exposes ``/dev/kvm`` in it, i.e. the L2 guest
+is a "KVM-accelerated guest", not a "plain emulated guest" (as done by
+QEMU's TCG).
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
+Limitations on Linux kernel versions older than 5.3 (x86)
+---------------------------------------------------------
+
+On Linux kernel versions older than 5.3, once an L1 guest has started an
+L2 guest, the L1 guest would no longer capable of being migrated, saved,
+or loaded (refer to QEMU documentation on "save"/"load") until the L2
+guest shuts down.
+
+Attempting to migrate or save-and-load an L1 guest while an L2 guest is
+running will result in undefined behavior.  You might see a ``kernel
+BUG!`` entry in ``dmesg``, a kernel 'oops', or an outright kernel panic.
+Such a migrated or loaded L1 guest can no longer be considered stable or
+secure, and must be restarted.
+
+Migrating an L1 guest merely configured to support nesting, while not
+actually running L2 guests, is expected to function normally.
+Live-migrating an L2 guest from one L1 guest to another is also expected
+to succeed.
+
+Reporting bugs from nested setups
+-----------------------------------
+
+Debugging "nested" problems can involve sifting through log files across
+L0, L1 and L2; this can result in tedious back-n-forth between the bug
+reporter and the bug fixer.
+
+- Mention that you are in a "nested" setup.  If you are running any kind
+  of "nesting" at all, say so.  Unfortunately, this needs to be called
+  out because when reporting bugs, people tend to forget to even
+  *mention* that they're using nested virtualization.
+
+- Ensure you are actually running KVM on KVM.  Sometimes people do not
+  have KVM enabled for their guest hypervisor (L1), which results in
+  them running with pure emulation or what QEMU calls it as "TCG", but
+  they think they're running nested KVM.  Thus confusing "nested Virt"
+  (which could also mean, QEMU on KVM) with "nested KVM" (KVM on KVM).
+
+Information to collect (generic)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following is not an exhaustive list, but a very good starting point:
+
+  - Kernel, libvirt, and QEMU version from L0
+
+  - Kernel, libvirt and QEMU version from L1
+
+  - QEMU command-line of L1 -- when using libvirt, you'll find it here:
+    ``/var/log/libvirt/qemu/instance.log``
+
+  - QEMU command-line of L2 -- as above, when using libvirt, get the
+    complete libvirt-generated QEMU command-line
+
+  - ``cat /sys/cpuinfo`` from L0
+
+  - ``cat /sys/cpuinfo`` from L1
+
+  - ``lscpu`` from L0
+
+  - ``lscpu`` from L1
+
+  - Full ``dmesg`` output from L0
+
+  - Full ``dmesg`` output from L1
+
+x86-specific info to collect
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Both the below commands, ``x86info`` and ``dmidecode``, should be
+available on most Linux distributions with the same name:
+
+  - Output of: ``x86info -a`` from L0
+
+  - Output of: ``x86info -a`` from L1
+
+  - Output of: ``dmidecode`` from L0
+
+  - Output of: ``dmidecode`` from L1
+
+s390x-specific info to collect
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Along with the earlier mentioned generic details, the below is
+also recommended:
+
+  - ``/proc/sysinfo`` from L1; this will also include the info from L0
--=20
2.21.1

