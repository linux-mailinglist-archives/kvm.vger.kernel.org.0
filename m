Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC1B7D7003
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344478AbjJYOvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 10:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344380AbjJYOve (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 10:51:34 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280C3182
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 07:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=zpSwg/227orDxCBsv3gMLUZ9m9I2XX8JSqBJlShG0v0=; b=QHoTG9te+i9gvcPBC7248eN5gD
        0d7ZKJRmbfrvDYMldeprNtzfUi2ghqZGT4BfamdP+34wFKnGahaZO2w0dWc5OnU43AlONPtYzvLfx
        /iOsdIQ8I1IK9vJjRGhq+Nz+aMTd8ltSGhu1CP/Lnt+o6SLAAlT3oWIDLnJVsYntsLm3L/woLyq8V
        qn61VkoZMSHIRIdHCx5obwbUDEA+hOQwNtoy9WXHIifjbi52x5NgN+q1okve5oyF2W5pfabMgfiQo
        Icfzr+Avd+gKQMQECAaiiWj+kFGkLwq3ULlysWbhp7+25e0ypoTukOxFob7kA0t+VWr7DLD85zFdG
        mLjTkNCQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDY-00GPLt-3D;
        Wed, 25 Oct 2023 14:50:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qvfDX-002dDw-25;
        Wed, 25 Oct 2023 15:50:43 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v3 00/28] Get Xen PV shim running in QEMU, add net & console
Date:   Wed, 25 Oct 2023 15:50:14 +0100
Message-Id: <20231025145042.627381-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Round up a handful of outstanding fixes, add console support and fix up
per-vCPU upcall vector support (which was previously untested), and that
allows us to boot PV guests using the Xen "PV shim".

Having fixed up the per-vCPU upcall vector support, pull in slightly 
newer Xen headers just for the definition of the CPUID bit that lets
us tell the Linux (6.0+) kernel to use it. That'll help with testing.

v2 of the series added network support for emulated Xen guests by 
converting the xen_nic driver to the "new" XenDevice model. That had 
been on the TODO list for a while, and having done the console it made
sense to do network too while I still remembered it all.

But then there was a bit more breakage to deal with. Even before the 
conversion to XenDevice, the xen_nic support was already hosed for 
actual Xen PV guests (-m xenfv) because it never actually managed to 
connect the Xen network device to a netdev. And net_cleanup() was 
freeing the NICs from underneath the device models which own them, which 
upsets the devices that actually do their own cleanup.

Simplify the user experience for "-device file=IMAGE,if=xen" because
that had been offending me for a while, and now I knew how to do that
too.

Update the documentation, and take the opportunity to fix up that bit 
about unplug not working on Q35, because I *also* worked out how to do 
that when heckling Joel's attempt to do so.

v3 of the series includes more cleanups to the -nic option handling,
allowing me to ditch some of the ugly special cases for registering
the Xen network device for xenfv vs. pc platforms, and replace it with
a simple "register all NICs on this bus" which PCI can use too. That
was seen in a 45-patch series all of its own, but now I've pulled in
just the basic part that's needed for Xen support, and the remaining
bombing run on all the platforms can wait; I won't spam the list with
the rest of that again just yet.

David Woodhouse (28):
      i386/xen: Don't advertise XENFEAT_supervisor_mode_kernel
      i386/xen: fix per-vCPU upcall vector for Xen emulation
      hw/xen: select kernel mode for per-vCPU event channel upcall vector
      hw/xen: don't clear map_track[] in xen_gnttab_reset()
      hw/xen: fix XenStore watch delivery to guest
      hw/xen: take iothread mutex in xen_evtchn_reset_op()
      hw/xen: use correct default protocol for xen-block on x86
      i386/xen: Ignore VCPU_SSHOTTMR_future flag in set_singleshot_timer()
      hw/xen: Clean up event channel 'type_val' handling to use union
      include: update Xen public headers to Xen 4.17.2 release
      i386/xen: advertise XEN_HVM_CPUID_UPCALL_VECTOR in CPUID
      hw/xen: populate store frontend nodes with XenStore PFN/port
      hw/xen: automatically assign device index to block devices
      hw/xen: add get_frontend_path() method to XenDeviceClass
      hw/xen: do not repeatedly try to create a failing backend device
      hw/xen: update Xen console to XenDevice model
      hw/xen: add support for Xen primary console in emulated mode
      hw/xen: only remove peers of PCI NICs on unplug
      hw/xen: update Xen PV NIC to XenDevice model
      net: do not delete nics in net_cleanup()
      xen-platform: unplug AHCI disks
      net: add qemu_{configure,create}_nic_device(), qemu_find_nic_info()
      net: report list of available models according to platform
      net: add qemu_create_nic_bus_devices()
      hw/pci: add pci_init_nic_devices(), pci_init_nic_in_slot()
      hw/i386/pc: use qemu_get_nic_info() and pci_init_nic_devices()
      hw/xen: use qemu_create_nic_bus_devices() to instantiate Xen NICs
      docs: update Xen-on-KVM documentation

 MAINTAINERS                                    |   2 +-
 blockdev.c                                     |  15 +-
 docs/system/i386/xen.rst                       | 100 +++--
 hw/block/xen-block.c                           |  44 +-
 hw/char/trace-events                           |   8 +
 hw/char/xen_console.c                          | 572 +++++++++++++++++++------
 hw/i386/kvm/meson.build                        |   1 +
 hw/i386/kvm/trace-events                       |   2 +
 hw/i386/kvm/xen-stubs.c                        |   8 +
 hw/i386/kvm/xen_evtchn.c                       | 158 ++++---
 hw/i386/kvm/xen_gnttab.c                       |   7 +-
 hw/i386/kvm/xen_primary_console.c              | 193 +++++++++
 hw/i386/kvm/xen_primary_console.h              |  23 +
 hw/i386/kvm/xen_xenstore.c                     |  31 +-
 hw/i386/pc.c                                   |  21 +-
 hw/i386/xen/xen_platform.c                     |  77 ++--
 hw/net/meson.build                             |   2 +-
 hw/net/trace-events                            |  11 +
 hw/net/xen_nic.c                               | 484 ++++++++++++++++-----
 hw/pci/pci.c                                   |  45 ++
 hw/xen/xen-backend.c                           |  27 +-
 hw/xen/xen-bus.c                               |  23 +-
 hw/xen/xen-legacy-backend.c                    |   1 -
 hw/xen/xen_devconfig.c                         |  53 ---
 hw/xenpv/xen_machine_pv.c                      |  19 -
 include/hw/net/ne2000-isa.h                    |   2 -
 include/hw/pci/pci.h                           |   4 +-
 include/hw/xen/interface/arch-arm.h            |  37 +-
 include/hw/xen/interface/arch-x86/cpuid.h      |  31 +-
 include/hw/xen/interface/arch-x86/xen-x86_32.h |  19 +-
 include/hw/xen/interface/arch-x86/xen-x86_64.h |  19 +-
 include/hw/xen/interface/arch-x86/xen.h        |  26 +-
 include/hw/xen/interface/event_channel.h       |  19 +-
 include/hw/xen/interface/features.h            |  19 +-
 include/hw/xen/interface/grant_table.h         |  19 +-
 include/hw/xen/interface/hvm/hvm_op.h          |  19 +-
 include/hw/xen/interface/hvm/params.h          |  19 +-
 include/hw/xen/interface/io/blkif.h            |  27 +-
 include/hw/xen/interface/io/console.h          |  19 +-
 include/hw/xen/interface/io/fbif.h             |  19 +-
 include/hw/xen/interface/io/kbdif.h            |  19 +-
 include/hw/xen/interface/io/netif.h            |  25 +-
 include/hw/xen/interface/io/protocols.h        |  19 +-
 include/hw/xen/interface/io/ring.h             |  49 +--
 include/hw/xen/interface/io/usbif.h            |  19 +-
 include/hw/xen/interface/io/xenbus.h           |  19 +-
 include/hw/xen/interface/io/xs_wire.h          |  36 +-
 include/hw/xen/interface/memory.h              |  30 +-
 include/hw/xen/interface/physdev.h             |  23 +-
 include/hw/xen/interface/sched.h               |  19 +-
 include/hw/xen/interface/trace.h               |  19 +-
 include/hw/xen/interface/vcpu.h                |  19 +-
 include/hw/xen/interface/version.h             |  19 +-
 include/hw/xen/interface/xen-compat.h          |  19 +-
 include/hw/xen/interface/xen.h                 |  19 +-
 include/hw/xen/xen-backend.h                   |   1 +
 include/hw/xen/xen-bus.h                       |   3 +
 include/hw/xen/xen-legacy-backend.h            |   2 -
 include/net/net.h                              |  10 +-
 include/sysemu/kvm_xen.h                       |   1 +
 net/net.c                                      | 226 +++++++++-
 target/i386/kvm/kvm.c                          |   4 +
 target/i386/kvm/xen-emu.c                      |  59 ++-
 63 files changed, 1851 insertions(+), 1033 deletions(-)


