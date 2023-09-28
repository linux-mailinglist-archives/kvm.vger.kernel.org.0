Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318AF7B2434
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 19:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbjI1Rlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjI1Rla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 13:41:30 -0400
X-Greylist: delayed 525 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 28 Sep 2023 10:41:28 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860A11A4;
        Thu, 28 Sep 2023 10:41:28 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id A5A2A101920C7;
        Thu, 28 Sep 2023 19:32:36 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 8184760E0037;
        Thu, 28 Sep 2023 19:32:36 +0200 (CEST)
X-Mailbox-Line: From 467bff0c4bab93067b1e353e5b8a92f1de353a3f Mon Sep 17 00:00:00 2001
Message-Id: <cover.1695921656.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 28 Sep 2023 19:32:32 +0200
Subject: [PATCH 00/12] PCI device authentication
To:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Authenticate PCI devices with CMA-SPDM (PCIe r6.1 sec 6.31) and
expose the result in sysfs.  This enables user-defined policies
such as forbidding driver binding to devices which failed
authentication.

CMA-SPDM forms the basis for PCI encryption (PCIe r6.1 sec 6.33),
which will be submitted later.

The meat of the series is in patches [07/12] and [08/12], which contain
the SPDM library and the CMA glue code (the PCI-adaption of SPDM).

The reason why SPDM is done in-kernel is provided in patch [10/12]:
Briefly, when devices are reauthenticated on resume from system sleep,
user space is not yet available.  Same when reauthenticating after
recovery from reset.

One use case for CMA-SPDM and PCI encryption is confidential access
to passed-through devices:  Neither the host nor other guests are
able to eavesdrop on device accesses, in particular if guest memory
is encrypted as well.

Further use cases for the SPDM library are appearing on the horizon:
Alistair Francis and Wilfred Mallawa from WDC are interested in using
it for SCSI/SATA.  David Box from Intel has implemented measurement
retrieval over SPDM.

The root of trust is initially an in-kernel key ring of certificates.
We can discuss linking the system key ring into it, thereby allowing
EFI to pass trusted certificates to the kernel for CMA.  Alternatively,
a bundle of trusted certificates could be loaded from the initrd.
I envision that we'll add TPMs or remote attestation services such as
https://keylime.dev/ to create an ecosystem of various trust sources.

If you wish to play with PCI device authentication but lack capable
hardware, Wilfred has written a guide how to test with qemu:
https://github.com/twilfredo/spdm-emulation-guide-b

Jonathan Cameron (2):
  spdm: Introduce library to authenticate devices
  PCI/CMA: Authenticate devices on enumeration

Lukas Wunner (10):
  X.509: Make certificate parser public
  X.509: Parse Subject Alternative Name in certificates
  X.509: Move certificate length retrieval into new helper
  certs: Create blacklist keyring earlier
  crypto: akcipher - Support more than one signature encoding
  crypto: ecdsa - Support P1363 signature encoding
  PCI/CMA: Validate Subject Alternative Name in certificates
  PCI/CMA: Reauthenticate devices on reset and resume
  PCI/CMA: Expose in sysfs whether devices are authenticated
  PCI/CMA: Grant guests exclusive control of authentication

 Documentation/ABI/testing/sysfs-bus-pci   |   27 +
 MAINTAINERS                               |   10 +
 certs/blacklist.c                         |    4 +-
 crypto/akcipher.c                         |    2 +-
 crypto/asymmetric_keys/public_key.c       |   12 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   15 +
 crypto/asymmetric_keys/x509_loader.c      |   38 +-
 crypto/asymmetric_keys/x509_parser.h      |   37 +-
 crypto/ecdsa.c                            |   16 +-
 crypto/internal.h                         |    1 +
 crypto/rsa-pkcs1pad.c                     |   11 +-
 crypto/sig.c                              |    6 +-
 crypto/testmgr.c                          |    8 +-
 crypto/testmgr.h                          |   16 +
 drivers/pci/Kconfig                       |   16 +
 drivers/pci/Makefile                      |    5 +
 drivers/pci/cma-sysfs.c                   |   73 +
 drivers/pci/cma-x509.c                    |  119 ++
 drivers/pci/cma.asn1                      |   36 +
 drivers/pci/cma.c                         |  151 +++
 drivers/pci/doe.c                         |    5 +-
 drivers/pci/pci-driver.c                  |    1 +
 drivers/pci/pci-sysfs.c                   |    3 +
 drivers/pci/pci.c                         |   12 +-
 drivers/pci/pci.h                         |   17 +
 drivers/pci/pcie/err.c                    |    3 +
 drivers/pci/probe.c                       |    1 +
 drivers/pci/remove.c                      |    1 +
 drivers/vfio/pci/vfio_pci_core.c          |    9 +-
 include/crypto/akcipher.h                 |   10 +-
 include/crypto/sig.h                      |    6 +-
 include/keys/asymmetric-type.h            |    2 +
 include/keys/x509-parser.h                |   46 +
 include/linux/oid_registry.h              |    3 +
 include/linux/pci-doe.h                   |    4 +
 include/linux/pci.h                       |   15 +
 include/linux/spdm.h                      |   41 +
 lib/Kconfig                               |   15 +
 lib/Makefile                              |    2 +
 lib/spdm_requester.c                      | 1510 +++++++++++++++++++++
 40 files changed, 2232 insertions(+), 77 deletions(-)
 create mode 100644 drivers/pci/cma-sysfs.c
 create mode 100644 drivers/pci/cma-x509.c
 create mode 100644 drivers/pci/cma.asn1
 create mode 100644 drivers/pci/cma.c
 create mode 100644 include/keys/x509-parser.h
 create mode 100644 include/linux/spdm.h
 create mode 100644 lib/spdm_requester.c

-- 
2.40.1

