Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42642159CBD
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 00:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgBKXFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 18:05:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727799AbgBKXFb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 18:05:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581462331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kHSxze2a1nRCn20xOJSopREUpsR/wHcjPJb/ZM+x9bk=;
        b=HX8zUnAuQN12GbxBfoHSaJsArO+KMiZgMLtzE3o65zJN3gzSGazQqUjYwukw9r2kHJ16PQ
        r13a0IJCV5d5ShSjaP+dfr+mFA0o7HKa31AbmOmh6uIGR25WTfdbG/fpRGvZltEZd5tot6
        Vp92gJIv0baEWW8K4q1nAHSgXcp48K0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-ov1zL7QkOzGol9JblHnMjg-1; Tue, 11 Feb 2020 18:05:22 -0500
X-MC-Unique: ov1zL7QkOzGol9JblHnMjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F81718FF660;
        Tue, 11 Feb 2020 23:05:20 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EAC160BF1;
        Tue, 11 Feb 2020 23:05:17 +0000 (UTC)
Subject: [PATCH 0/7] vfio/pci: SR-IOV support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Date:   Tue, 11 Feb 2020 16:05:16 -0700
Message-ID: <158145472604.16827.15751375540102298130.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given the mostly positive feedback from the RFC[1], here's a new
non-RFC revision.  Changes since RFC:

 - vfio_device_ops.match semantics refined
 - Use helpers for struct pci_dev.physfn to avoid breakage without
   CONFIG_PCI_IOV
 - Relax to allow SR-IOV configuration changes while PF is opened.
   There are potentially interesting use cases here, including
   perhaps QEMU emulating an SR-IOV capability and calling out
   to a privileged entity to manipulate sriov_numvfs and corral
   the resulting devices.
 - Retest vfio_device_feature.argsz to include uuid length.
 - Add Connie's R-b on 6/7

I still wish we had a solution to make it less opaque to the user
why a VFIO_GROUP_GET_DEVICE_FD() has failed if a VF token is
required, but this is still the best I've been able to come up with.
If there are objections or better ideas, please raise them now.

The synopsis of this series is that we have an ongoing desire to drive
PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
for this with DPDK drivers and potentially interesting future use
cases in virtualization.  We've been reluctant to add this support
previously due to the dependency and trust relationship between the
VF device and PF driver.  Minimally the PF driver can induce a denial
of service to the VF, but depending on the specific implementation,
the PF driver might also be responsible for moving data between VFs
or have direct access to the state of the VF, including data or state
otherwise private to the VF or VF driver.

To help resolve these concerns, we introduce a VF token into the VFIO
PCI ABI, which acts as a shared secret key between drivers.  The
userspace PF driver is required to set the VF token to a known value
and userspace VF drivers are required to provide the token to access
the VF device.  If a PF driver is restarted with VF drivers in use, it
must also provide the current token in order to prevent a rogue
untrusted PF driver from replacing a known driver.  The degree to
which this new token is considered secret is left to the userspace
drivers, the kernel intentionally provides no means to retrieve the
current token.

Note that the above token is only required for this new model where
both the PF and VF devices are usable through vfio-pci.  Existing
models of VFIO drivers where the PF is used without SR-IOV enabled
or the VF is bound to a userspace driver with an in-kernel, host PF
driver are unaffected.

The latter configuration above also highlights a new inverted scenario
that is now possible, a userspace PF driver with in-kernel VF drivers.
I believe this is a scenario that should be allowed, but should not be
enabled by default.  This series includes code to set a default
driver_override for VFs sourced from a vfio-pci user owned PF, such
that the VFs are also bound to vfio-pci.  This model is compatible
with tools like driverctl and allows the system administrator to
decide if other bindings should be enabled.  The VF token interface
above exists only between vfio-pci PF and VF drivers, once a VF is
bound to another driver, the administrator has effectively pronounced
the device as trusted.  The vfio-pci driver will note alternate
binding in dmesg for logging and debugging purposes.

Please review, comment, and test.  The example QEMU implementation
provided with the RFC[2] is still current for this version.  Thanks,

Alex

[1] https://lore.kernel.org/lkml/158085337582.9445.17682266437583505502.stgit@gimli.home/
[2] https://lore.kernel.org/lkml/20200204161737.34696b91@w520.home/
---

Alex Williamson (7):
      vfio: Include optional device match in vfio_device_ops callbacks
      vfio/pci: Implement match ops
      vfio/pci: Introduce VF token
      vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
      vfio/pci: Add sriov_configure support
      vfio/pci: Remove dev_fmt definition
      vfio/pci: Cleanup .probe() exit paths


 drivers/vfio/pci/vfio_pci.c         |  312 ++++++++++++++++++++++++++++++++---
 drivers/vfio/pci/vfio_pci_private.h |   10 +
 drivers/vfio/vfio.c                 |   20 ++
 include/linux/vfio.h                |    4 
 include/uapi/linux/vfio.h           |   37 ++++
 5 files changed, 355 insertions(+), 28 deletions(-)

