Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D65182446
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 22:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgCKV6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 17:58:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56011 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729328AbgCKV6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 17:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583963915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=obrvwIi1FyEjS5wRGrKPnSPLdfDGorfe7sIIaJexKBU=;
        b=Lzm5PtcSSxWyhK0h+R+EqlC0B5TW/zK+mG98cCmQxxHLFeJmGN80c5mIFiWNLhfuC4LD+b
        xLJwhewUz2Hl6TmqfzCLX1huOl4znamyZpCO59OU5Vz4eK0tfEC5jqg4OKvBKdUE+ZbkPv
        PfWgcdxQ35BB/9kgptzli2G/VpQgcV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-9hZTx998MT6e-uolMq_oRA-1; Wed, 11 Mar 2020 17:58:31 -0400
X-MC-Unique: 9hZTx998MT6e-uolMq_oRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68D4418A5500;
        Wed, 11 Mar 2020 21:58:29 +0000 (UTC)
Received: from gimli.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E887991D74;
        Wed, 11 Mar 2020 21:58:25 +0000 (UTC)
Subject: [PATCH v3 0/7] vfio/pci: SR-IOV support
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com, kevin.tian@intel.com
Date:   Wed, 11 Mar 2020 15:58:25 -0600
Message-ID: <158396044753.5601.14804870681174789709.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only minor tweaks since v2, GET and SET on VFIO_DEVICE_FEATURE are
enforced mutually exclusive except with the PROBE option as suggested
by Connie, the modinfo text has been expanded for the opt-in to enable
SR-IOV support in the vfio-pci driver per discussion with Kevin.

I have not incorporated runtime warnings attempting to detect misuse
of SR-IOV or imposed a session lifetime of a VF token, both of which
were significant portions of the discussion of the v2 series.  Both of
these also seem to impose a usage model or make assumptions about VF
resource usage or configuration requirements that don't seem necessary
except for the sake of generating a warning or requiring an otherwise
unnecessary and implicit token reinitialization.  If there are new
thoughts around these or other discussion points, please raise them.

Series overview (same as provided with v1):

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
provided with the RFC is still current for this version.  Thanks,

Alex

RFC: https://lore.kernel.org/lkml/158085337582.9445.17682266437583505502.stgit@gimli.home/
v1: https://lore.kernel.org/lkml/158145472604.16827.15751375540102298130.stgit@gimli.home/
v2: https://lore.kernel.org/lkml/158213716959.17090.8399427017403507114.stgit@gimli.home/

---

Alex Williamson (7):
      vfio: Include optional device match in vfio_device_ops callbacks
      vfio/pci: Implement match ops
      vfio/pci: Introduce VF token
      vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
      vfio/pci: Add sriov_configure support
      vfio/pci: Remove dev_fmt definition
      vfio/pci: Cleanup .probe() exit paths


 drivers/vfio/pci/vfio_pci.c         |  390 +++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/vfio_pci_private.h |   10 +
 drivers/vfio/vfio.c                 |   20 +-
 include/linux/vfio.h                |    4 
 include/uapi/linux/vfio.h           |   37 +++
 5 files changed, 433 insertions(+), 28 deletions(-)

