Return-Path: <kvm+bounces-69606-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AD0cC1fQe2m0IgIAu9opvQ
	(envelope-from <kvm+bounces-69606-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:25:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 111A0B4993
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7490F3008326
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 21:25:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A2A3271F2;
	Thu, 29 Jan 2026 21:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rabo/T+8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653D4265CBE
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 21:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769721940; cv=none; b=ck/7esTKqsxjgDsjYR79OdMreZ0zT+cZHytCWq1fRTsQsyz413ZSSJ2RqP7o299LjpDhYqNbDso4UeoUOFMdGF95xtvuhHSgj4B9gdbBHVC+m3imPzj+xZlacTgIros8PWuQksyj9sMqJ1uBQbqE24oiXAem3QSaiZto6Y4K4Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769721940; c=relaxed/simple;
	bh=i4fTBf4JlgeFGGBKcJxBa5kh3xL/047pYN73iqANQCo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dxvbyMJXZ4HLqCD7exwlNd5oBDhoPNgAJFA6adRdzGKHTtF1r8Z1yJpANMTZl1MN2yDIkwlUoI1odffcYyeRvt04bo/E3MoMAaE4bRLW8EtEkA3IG0WnwNsGYPfl93LGq7u5of2m01lIXgnTz7Hg0ozpwlQNEU8xvUYA6dliXwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rabo/T+8; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34abd303b4aso2994419a91.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 13:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721938; x=1770326738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F7w0g/nR8ml7KkZqbualmYDfY5KbOVPfKhgZAMsaNL0=;
        b=rabo/T+8aRjoD7P1QZ8TCY/4/GS6vNQ0egChJrpISJiM+F4VCOxEzL4le8ycju9fEv
         lp0GcuNU/MOaAixSrbDVjoFVONl0TI3BBA5GWqC9CYxrZwicUgBVaWYNKKn77KqX/Sam
         dgtIaJ6EpfOsEbSRTkKdBejlCF5Y+2nJBto+ehl1JsW1z85GvFmk8GSbx9IBrZKZJ29Z
         Hg6XVlKxnWX0iRwa/GV15HYmLxTAnYA/Felbe1nyCkhHpKoaa1J6A9O1Ls8XDSteQjpo
         D8hJxDHZnBxji1UpYMpx0rcJEL5b52AvCY6qrAVTWe9RAxZbr1przjpCsKcAmX4JqKzX
         bUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721938; x=1770326738;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F7w0g/nR8ml7KkZqbualmYDfY5KbOVPfKhgZAMsaNL0=;
        b=DsxkxqM06MlzXBHYUnMYWQ1W/BL4zYhLKUcxJZxQAYxVBLjvifei/y1pUnnfwlNqIk
         DCLVNaEYmvOBkzQ2c4t9gYJHY66uJkf+0sSO6PKsDzKcQnEriqcAMLnd1NPb4I5Z1HQ5
         2GtCd+YaW/miPhxDu+bf9JqyLefkFokYjFayRTn0KNx61Msx7/X7n8Tt0buWAtYnJRyi
         EWKQvsI2RN35rdlR5Qh8KAc4Gild4OMZoAp40ioyhGvma1H7Tr1zTLMrwa7AcuuzJ66q
         FclWDV1eVUxMbQpwWUUl26dqeI2vPe8AC5JhVDtcDIn1kV6TqM031qma/dMXNIQg+F9I
         qA6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/ZE4FmsHB9UUGEYsaowDM5nahBg/kd+OmWWrs9V9VWFnZXYFXEQNUmXo1AWkytO92q+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR6BQgVDc9lY4RyeSUVIC+Cnh/9PA2AYj/n28+zHqN+1HqO3fK
	j7OZU8TKme9FzivpOsfQXayGgZGgGUtoh0AOqh4HFn4L+MLsn9EJVjuoc98k3LKoWvSyqOBaHWb
	J7Ib0RrlrnN0HcQ==
X-Received: from pjd16.prod.google.com ([2002:a17:90b:54d0:b0:32e:ca6a:7ca9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d06:b0:340:d81d:7874 with SMTP id 98e67ed59e1d1-3543b3b43f0mr808394a91.26.1769721937697;
 Thu, 29 Jan 2026 13:25:37 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:47 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-1-dmatlack@google.com>
Subject: [PATCH v2 00/22] vfio/pci: Base Live Update support for VFIO device files
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69606-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	FREEMAIL_CC(0.00)[nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,soleen.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,wunner.de:email]
X-Rspamd-Queue-Id: 111A0B4993
X-Rspamd-Action: no action

This series can be found on GitHub:

  https://github.com/dmatlack/linux/tree/liveupdate/vfio/cdev/v2

This series adds the base support to preserve a VFIO device file across
a Live Update. "Base support" means that this allows userspace to
safely preserve a VFIO device file with LIVEUPDATE_SESSION_PRESERVE_FD
and retrieve it with  LIVEUPDATE_SESSION_RETRIEVE_FD, but the device
itself is not preserved in a fully running state across Live Update.

This series aims to provide a foundation on which to build the rest of
the device preservation infrastructure, including:

 - Preservation of iommufd files [1]
 - Preservation of IOMMU driver state
 - Preservation of PCI state (BAR resources, device state, bridge state, ...)
 - Preservation of vfio-pci driver state

Testing
-------

The patches at the end of this series provide comprehensive selftests
for the new code added by this series. The selftests have been validated
in both a VM environment using a virtio-net PCIe device, and in a
baremetal environment on an Intel EMR server with an Intel DSA PCIe
device.

Here is an example of how to run the new selftests:

vfio_pci_liveupdate_uapi_test:

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test 0000:00:04.0
  $ tools/testing/selftests/vfio/scripts/cleanup.sh

vfio_pci_liveupdate_kexec_test:

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
  $ kexec ...

  $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
  $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0
  $ tools/testing/selftests/vfio/scripts/cleanup.sh

It is also possible to run vfio_pci_liveupdate_kexec_test multiple times
to preserve multiple devices simultaneously across a Live Update. This
series has been tested with up to 8 devices concurrently preserved.

Changelog
---------

v2:
 - Rebase on top of linux-next (tag: next-20260115)
 - Add missing EXPORT_SYMBOL_GPLs in LUO (Zhu)
 - Add Missing EXPORT_SYMBOL_GPLs for vfio_device_fops (Zhu)
 - Fix circular dependency between vfio-pci-core and vfio-pci (Zhu)
 - Handle pci=assign-busses (Lukas)
 - Drop driver_override patch (Jason)
 - Use kho_alloc_preserve(), kho_unpreserve_free(), kho_restore_free() (Pasha)
 - Don't access PCI FLB after device initialization (Jason)
 - Fix folio leak in vfio_pci_liveupdate_retrieve() (Alex)
 - Add Documentation (Pasha)

v1: https://lore.kernel.org/kvm/20251126193608.2678510-1-dmatlack@google.com/

rfc: https://lore.kernel.org/kvm/20251018000713.677779-1-vipinsh@google.com/

Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Parav Pandit <parav@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: William Tu <witu@nvidia.com>
Cc: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Josh Hilke <jrhilke@google.com>
Cc: David Rientjes <rientjes@google.com>

[1] https://lore.kernel.org/linux-iommu/20251202230303.1017519-1-skhawaja@google.com/

David Matlack (13):
  liveupdate: Export symbols needed by modules
  PCI: Add API to track PCI devices preserved across Live Update
  PCI: Inherit bus numbers from previous kernel during Live Update
  vfio/pci: Notify PCI subsystem about devices preserved across Live
    Update
  vfio: Enforce preserved devices are retrieved via
    LIVEUPDATE_SESSION_RETRIEVE_FD
  vfio/pci: Store incoming Live Update state in struct
    vfio_pci_core_device
  docs: liveupdate: Document VFIO device file preservation
  vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
  vfio: selftests: Add vfio_pci_liveupdate_uapi_test
  vfio: selftests: Expose iommu_modes to tests
  vfio: selftests: Expose low-level helper routines for setting up
    struct vfio_pci_device
  vfio: selftests: Verify that opening VFIO device fails during Live
    Update
  vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test

Vipin Sharma (9):
  vfio/pci: Register a file handler with Live Update Orchestrator
  vfio/pci: Preserve vfio-pci device files across Live Update
  vfio/pci: Retrieve preserved device files after Live Update
  vfio/pci: Skip reset of preserved device after Live Update
  selftests/liveupdate: Move luo_test_utils.* into a reusable library
  selftests/liveupdate: Add helpers to preserve/retrieve FDs
  vfio: selftests: Build liveupdate library in VFIO selftests
  vfio: selftests: Initialize vfio_pci_device using a VFIO cdev FD
  vfio: selftests: Add vfio_pci_liveupdate_kexec_test

 Documentation/userspace-api/liveupdate.rst    | 144 ++++++++++
 MAINTAINERS                                   |   1 +
 drivers/pci/Makefile                          |   1 +
 drivers/pci/liveupdate.c                      | 212 +++++++++++++++
 drivers/pci/probe.c                           |  23 +-
 drivers/vfio/device_cdev.c                    |  25 +-
 drivers/vfio/group.c                          |   9 +
 drivers/vfio/pci/Makefile                     |   1 +
 drivers/vfio/pci/vfio_pci.c                   |  11 +-
 drivers/vfio/pci/vfio_pci_core.c              |  24 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c        | 246 +++++++++++++++++
 drivers/vfio/pci/vfio_pci_priv.h              |  16 ++
 drivers/vfio/vfio.h                           |  13 -
 drivers/vfio/vfio_main.c                      |  23 +-
 include/linux/kho/abi/pci.h                   |  55 ++++
 include/linux/kho/abi/vfio_pci.h              |  45 +++
 include/linux/pci.h                           |  47 ++++
 include/linux/vfio.h                          |  58 ++++
 include/linux/vfio_pci_core.h                 |   2 +
 kernel/liveupdate/luo_core.c                  |   1 +
 kernel/liveupdate/luo_file.c                  |   2 +
 tools/testing/selftests/liveupdate/.gitignore |   1 +
 tools/testing/selftests/liveupdate/Makefile   |  14 +-
 .../include/libliveupdate.h}                  |  11 +-
 .../selftests/liveupdate/lib/libliveupdate.mk |  20 ++
 .../{luo_test_utils.c => lib/liveupdate.c}    |  43 ++-
 .../selftests/liveupdate/luo_kexec_simple.c   |   2 +-
 .../selftests/liveupdate/luo_multi_session.c  |   2 +-
 tools/testing/selftests/vfio/Makefile         |  23 +-
 .../vfio/lib/include/libvfio/iommu.h          |   2 +
 .../lib/include/libvfio/vfio_pci_device.h     |   8 +
 tools/testing/selftests/vfio/lib/iommu.c      |   4 +-
 .../selftests/vfio/lib/vfio_pci_device.c      |  60 ++--
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 256 ++++++++++++++++++
 .../vfio/vfio_pci_liveupdate_uapi_test.c      |  93 +++++++
 35 files changed, 1410 insertions(+), 88 deletions(-)
 create mode 100644 drivers/pci/liveupdate.c
 create mode 100644 drivers/vfio/pci/vfio_pci_liveupdate.c
 create mode 100644 include/linux/kho/abi/pci.h
 create mode 100644 include/linux/kho/abi/vfio_pci.h
 rename tools/testing/selftests/liveupdate/{luo_test_utils.h => lib/include/libliveupdate.h} (80%)
 create mode 100644 tools/testing/selftests/liveupdate/lib/libliveupdate.mk
 rename tools/testing/selftests/liveupdate/{luo_test_utils.c => lib/liveupdate.c} (89%)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_uapi_test.c


base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
-- 
2.53.0.rc1.225.gd81095ad13-goog


