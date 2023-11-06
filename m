Return-Path: <kvm+bounces-758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC377E26F1
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B92F1C20BFF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25BC628DC3;
	Mon,  6 Nov 2023 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBC528DAC
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:35:24 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50AFC6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:35:22 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="41362360"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:35:21 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-d23e07e8.us-east-1.amazon.com (Postfix) with ESMTPS id 20E1283A70;
	Mon,  6 Nov 2023 14:35:14 +0000 (UTC)
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:14317]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.187:2525] with esmtp (Farcaster)
 id 1c473c1c-c50b-4c1c-b64e-8d2edea49916; Mon, 6 Nov 2023 14:35:13 +0000 (UTC)
X-Farcaster-Flow-ID: 1c473c1c-c50b-4c1c-b64e-8d2edea49916
Received: from EX19EXOUWB002.ant.amazon.com (10.250.64.247) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:35:13 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19EXOUWB002.ant.amazon.com (10.250.64.247) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.27; Mon, 6 Nov 2023 14:35:12 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:35:09 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Peter
 Maydell" <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, "Paul
 Durrant" <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, "Marcel
 Apfelbaum" <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 00/17] Get Xen PV shim running in QEMU, add net and console
Date: Mon, 6 Nov 2023 14:34:50 +0000
Message-ID: <20231106143507.1060610-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: Bulk

The Xen PV shim requires a PV console; add that. Also update the Xen PV 
network support to the new XenDevice model so that it can be used with 
emulated Xen guests. Fix up the Xen block support to allow it to be used
with '-device file=IMAGE,if=xen'.

Update the documentation to reflect all of these, taking the opportunity
to simplify what it says about q35, by making unplug work for AHCI.

Ignore the VCPU_SSHOTTMR_future timer flag, and advertise the 'fixed'
per-vCPU upcall vector support, as newer upstream Xen do.

Fix a bug where net_cleanup() would remove the NIC from underneath the 
emulated network devices, which doesn't work well when network devices 
have their own destructors (as the Xen PV one has to, in order to clean 
up the XenStore nodes).

v4:
 • Drop the fixes from the start of the series, which have been sent as
   a separate pull request (cc: qemu-stable):
   https://lore.kernel.org/qemu-devel/20231106103955.200867-1-dwmw2@infradead.org/
 • Go back to the original, more hackish, version of making `-nic` work
   for Xen network. The better fix for that is not going to get through
   review before the soft freeze.
 • Fix the documentation so the docs can reference the '-initrd' command
   line option with newer Sphinx.
 • Improve the duplicate detection for Xen block devices to match all
   partitions and even the same disk number on different majors.

David Woodhouse (17):
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
      hw/i386/pc: support '-nic' for xen-net-device
      net: do not delete nics in net_cleanup()
      xen-platform: unplug AHCI disks
      doc/sphinx/hxtool.py: add optional label argument to SRST directive
      docs: update Xen-on-KVM documentation



 MAINTAINERS                                    |   2 +-
 blockdev.c                                     |  15 +-
 docs/sphinx/hxtool.py                          |  18 +-
 docs/system/i386/xen.rst                       | 107 +++--
 docs/system/invocation.rst                     |   1 +
 hw/block/xen-block.c                           | 118 ++++-
 hw/char/trace-events                           |   8 +
 hw/char/xen_console.c                          | 572 +++++++++++++++++++------
 hw/i386/kvm/meson.build                        |   1 +
 hw/i386/kvm/trace-events                       |   2 +
 hw/i386/kvm/xen-stubs.c                        |   8 +
 hw/i386/kvm/xen_evtchn.c                       | 151 +++----
 hw/i386/kvm/xen_gnttab.c                       |   7 +-
 hw/i386/kvm/xen_primary_console.c              | 193 +++++++++
 hw/i386/kvm/xen_primary_console.h              |  23 +
 hw/i386/kvm/xen_xenstore.c                     |  23 +-
 hw/i386/pc.c                                   |  11 +-
 hw/i386/pc_piix.c                              |   2 +-
 hw/i386/pc_q35.c                               |   2 +-
 hw/i386/xen/xen_platform.c                     |  77 ++--
 hw/net/meson.build                             |   2 +-
 hw/net/trace-events                            |  11 +
 hw/net/xen_nic.c                               | 484 ++++++++++++++++-----
 hw/xen/xen-backend.c                           |  27 +-
 hw/xen/xen-bus.c                               |  23 +-
 hw/xen/xen-legacy-backend.c                    |   1 -
 hw/xen/xen_devconfig.c                         |  28 --
 hw/xenpv/xen_machine_pv.c                      |  10 -
 include/hw/i386/pc.h                           |   4 +-
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
 include/hw/xen/xen-bus.h                       |   5 +-
 include/hw/xen/xen-legacy-backend.h            |   1 -
 net/net.c                                      |  28 +-
 qemu-options.hx                                |  14 +-
 target/i386/kvm/kvm.c                          |   4 +
 target/i386/kvm/xen-emu.c                      |  43 +-
 64 files changed, 1681 insertions(+), 991 deletions(-)



