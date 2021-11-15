Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB54545022A
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 11:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbhKOKR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 05:17:27 -0500
Received: from foss.arm.com ([217.140.110.172]:53314 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237116AbhKOKRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 05:17:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF7711FB;
        Mon, 15 Nov 2021 02:14:18 -0800 (PST)
Received: from e120937-lin.home (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C58F63F70D;
        Mon, 15 Nov 2021 02:14:17 -0800 (PST)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
Cc:     andre.przywara@arm.com, sudeep.holla@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        Cristian Marussi <cristian.marussi@arm.com>
Subject: [RFC PATCH kvmtool 0/2] Introduce VirtIO SCMI Device support
Date:   Mon, 15 Nov 2021 10:13:59 +0000
Message-Id: <20211115101401.21685-1-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

this short series aims mainly to introduce support (in [01/02]) for the
emulation of a VirtIO SCMI Device as per the VirtIO specification in [1].

Afterwards, as a related but independent patch, general support for
FDT Overlays is also added in [02/02], since this latter is needed to
craft more complex DT configurations needed from time to time with SCMI
for testing/development purposes.

Generally, ARM SCMI protocol [2] defines how an SCMI platform server can
talk with a number of SCMI Agents (like a Linux Kernel implementing the
SCMI stack) to manage and control various aspects of System power and
performance.

An SCMI Platform firmware could already reside in a number of places and,
with the recent addition of a VirtIO transport layer in the Linux SCMI
stack, the SCMI backend can also be deployed in a virtualized environment,
represented by an emulated VirtIO SCMI Device.

Since it is clearly not advisable/sensible to implement the whole SCMI
Server backend logic inside kvmtool (i.e. the SCMI fw), the proposed
emulated SCMI device will indeed act as 'proxy' device, routing the
VirtIO SCMI traffic received from the guest OSPM SCMI Agent virtqueues
back and forth to some external userspace application (acting as an SCMI
Server) via Unix sockets.

The aim of this addition to kvmtool is to provide an easy way to debug
and test the SCMI Kernel stack in the guest during development, so that it
should be possible to exercise the Kernel SCMI stack without the need to
have a fully compliant SCMI hw and fw in place: the idea is to be able to
use as the FW userspace emulation backend (reachable via Unix sockets), a
simpler stripped down SCMI server supporting only mocked HW and easily
extendable but also simply configurable to misbehave at will at the SCMI
protocol level.

For testing purposes using such a simplified server should be easier than
using a fully compliant one when it comes to:

 - implement a new protocol support backend to test the Kernel brand new
   implementation before some official full SCMI fw support is made
   available (if ever in case of custom vendor protocols)

 - mock a variety of fake HW for testing purposes without worrying about
   real HW (all is mocked really...)
 
- force some sort of misbehaviour at the SCMI protocol layer to test
  the robustness of the Kernel implementation (i.e. late/duplicated/
  unexpected/out-of-order/malformed SCMI Replies): a fully fledged
  official SCMI Server implementation is NOT meant/designed to misbehave
  so it's harder to make it do it.

The reason I'm posting this as an RFC is mainly because of the usage of
the custom Unix sockets interface to relay SCMI messages to userspace: this
is easier and is sufficient for our testing/development scenario above, but
it is clearly a non standard approach: a more standard way would be to use
the vhost-user protocol to negotiate the direct sharing of the SCMI vqueues
between the guest and the userspace FW emulation.

Such alternative solution would have the main advantage to be able to
interface also with the standard full fledged SCP SCMI Firmware Server
(for validation purposes ?) which is recently adding support [3] to be run
as a vhost-user server: the drawback instead would be the added complexity
to kvmtool and especially to the simplified userspace SCMI emulation server
I was blabbing about above (and the fact that the whole vhost-user support
would have to be added to kvmtool at first and I'm not sure if that is
something wanted given its nature of an hack tool...but I'd be happy to
add it if deemed sensible instead...)

Based on kvmtool:

commit 39181fc6429f ("vfio/pci: Align MSIX Table and PBA size to guest
		      maximum page size")

Any feedback welcome !

Thanks,
Cristian

[1]: https://github.com/oasis-tcs/virtio-spec/blob/master/virtio-scmi.tex
[2]: https://developer.arm.com/documentation/den0056/latest
[3]: https://github.com/ARM-software/SCP-firmware/pull/524
----
Cristian Marussi (2):
  virtio: Add support for VirtIO SCMI Device
  arm/fdt: Add FDT overlay support

 Makefile                                 |   1 +
 arm/fdt.c                                |  38 ++
 arm/include/arm-common/kvm-config-arch.h |  23 +-
 arm/include/arm-common/scmi.h            |   6 +
 include/kvm/virtio-pci-dev.h             |   2 +
 include/kvm/virtio-scmi.h                |   9 +
 include/linux/virtio_ids.h               |   1 +
 include/linux/virtio_scmi.h              |  43 ++
 virtio/scmi.c                            | 656 +++++++++++++++++++++++
 9 files changed, 778 insertions(+), 1 deletion(-)
 create mode 100644 arm/include/arm-common/scmi.h
 create mode 100644 include/kvm/virtio-scmi.h
 create mode 100644 include/linux/virtio_scmi.h
 create mode 100644 virtio/scmi.c

-- 
2.17.1

