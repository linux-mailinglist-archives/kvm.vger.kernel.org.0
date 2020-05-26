Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297D31B2F4E
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 20:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgDUSmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 14:42:21 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:57885 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgDUSmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 14:42:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1587494540; x=1619030540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Bn059cn0UaWuunziZy7N2XUwHB6IqIik8uzBmA7RfbM=;
  b=Up1q4aSoFwpqz3UGDJs0Ad+/NJeESEo2HHD32xWI6YHVYulPbIHcF72w
   rpcjHTVPbwkFHcpL0TswkI7B/MYJo9XGZMCwnHDyLsCBWzv3O09AQxkYx
   2PV/yJHc7oFkcqSFtvLbTrRzZMm/u238x9rK4P05rx5UU7rlVz1eXiV0O
   s=;
IronPort-SDR: TnmuHb1KMexz/kTaI5cRCyeYQBuDMZfo1e1qgKu+Qu6ZvfoV7wtrFL11mlK3PV0brJ/BleTI+K
 LTYhxttSSnkQ==
X-IronPort-AV: E=Sophos;i="5.72,411,1580774400"; 
   d="scan'208";a="26614410"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 21 Apr 2020 18:42:06 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id AE10C1A4668;
        Tue, 21 Apr 2020 18:42:05 +0000 (UTC)
Received: from EX13D16EUB003.ant.amazon.com (10.43.166.99) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:42:05 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.160.90) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 21 Apr 2020 18:41:56 +0000
From:   Andra Paraschiv <andraprs@amazon.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Bjoern Doebel <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Frank van der Linden <fllinden@amazon.com>,
        Alexander Graf <graf@amazon.de>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: [PATCH v1 00/15] Add support for Nitro Enclaves
Date:   Tue, 21 Apr 2020 21:41:35 +0300
Message-ID: <20200421184150.68011-1-andraprs@amazon.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
X-Originating-IP: [10.43.160.90]
X-ClientProxiedBy: EX13D25UWC004.ant.amazon.com (10.43.162.201) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nitro Enclaves (NE) is a new Amazon Elastic Compute Cloud (EC2) capability
that allows customers to carve out isolated compute environments within EC2
instances [1].

For example, an application that processes highly sensitive data and
runs in a VM, can be separated from other applications running in the same VM.
This application then runs in a separate VM than the primary VM, namely an
enclave.

An enclave runs alongside the VM that spawned it. This setup matches low latency
applications needs. The resources that are allocated for the enclave, such as
memory and CPU, are carved out of the primary VM. Each enclave is mapped to a
process running in the primary VM, that communicates with the NE driver via an
ioctl interface.

An enclave communicates with the primary VM via a local communication channel,
using virtio-vsock [2]. An enclave does not have a disk or a network device
attached.

The following patch series covers the NE driver for enclave lifetime management.
It provides an ioctl interface to the user space and includes a PCI device
driver that is the means of communication with the hypervisor running on the
host where the primary VM and the enclave are launched.

The proposed solution is following the KVM model and uses the KVM API to be able
to create and set resources for enclaves. An additional ioctl command, besides
the ones provided by KVM, is used to start an enclave and setup the addressing
for the communication channel and an enclave unique id.

Thank you.

Andra

[1] https://aws.amazon.com/ec2/nitro/nitro-enclaves/
[2] http://man7.org/linux/man-pages/man7/vsock.7.html

---

Patch Series Changelog

The patch series is built on top of v5.7-rc2.

v1

* The current patch series.

---

Andra Paraschiv (15):
  nitro_enclaves: Add ioctl interface definition
  nitro_enclaves: Define the PCI device interface
  nitro_enclaves: Define enclave info for internal bookkeeping
  nitro_enclaves: Init PCI device driver
  nitro_enclaves: Handle PCI device command requests
  nitro_enclaves: Handle out-of-band PCI device events
  nitro_enclaves: Init misc device providing the ioctl interface
  nitro_enclaves: Add logic for enclave vm creation
  nitro_enclaves: Add logic for enclave vcpu creation
  nitro_enclaves: Add logic for enclave memory region set
  nitro_enclaves: Add logic for enclave start
  nitro_enclaves: Add logic for enclave termination
  nitro_enclaves: Add Kconfig for the Nitro Enclaves driver
  nitro_enclaves: Add Makefile for the Nitro Enclaves driver
  MAINTAINERS: Add entry for the Nitro Enclaves driver

 MAINTAINERS                                   |   11 +
 drivers/virt/Kconfig                          |    2 +
 drivers/virt/Makefile                         |    2 +
 drivers/virt/amazon/Kconfig                   |   28 +
 drivers/virt/amazon/Makefile                  |   19 +
 drivers/virt/amazon/nitro_enclaves/Makefile   |   23 +
 .../virt/amazon/nitro_enclaves/ne_misc_dev.c  | 1039 +++++++++++++++++
 .../virt/amazon/nitro_enclaves/ne_misc_dev.h  |  120 ++
 .../virt/amazon/nitro_enclaves/ne_pci_dev.c   |  675 +++++++++++
 .../virt/amazon/nitro_enclaves/ne_pci_dev.h   |  266 +++++
 include/linux/nitro_enclaves.h                |   23 +
 include/uapi/linux/nitro_enclaves.h           |   52 +
 12 files changed, 2260 insertions(+)
 create mode 100644 drivers/virt/amazon/Kconfig
 create mode 100644 drivers/virt/amazon/Makefile
 create mode 100644 drivers/virt/amazon/nitro_enclaves/Makefile
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_misc_dev.c
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_misc_dev.h
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_pci_dev.c
 create mode 100644 drivers/virt/amazon/nitro_enclaves/ne_pci_dev.h
 create mode 100644 include/linux/nitro_enclaves.h
 create mode 100644 include/uapi/linux/nitro_enclaves.h

-- 
2.20.1 (Apple Git-117)




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.

