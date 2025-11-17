Return-Path: <kvm+bounces-63300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B93C62179
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:38:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 65C504E611C
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC1B23536B;
	Mon, 17 Nov 2025 02:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KQ4WA0h8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C6C1F4CA9;
	Mon, 17 Nov 2025 02:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347078; cv=none; b=GYvMJoDbmUZfkjvo1WWp7W39FkXIrPjaGSoDdqWVdGvWxYzwJWkdcmQi277pF9hHysV/rnI9EQD8j5EIWvw7pWriez8CuJQfj/rApF3+rjEp1GdeQeIFM+o8NIqI7YYf4uxZf1foi4fDY9IygrIuIbaw1WwHEb0jIWSGGzjUjKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347078; c=relaxed/simple;
	bh=riT9o6mRwJYJ3rwmNmwc350Zx8TCQXNFFSt3YNL3IcU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qpmiuIfdF8fgeDK/+anrBnSwkmWHulqQCmNcTajgVRzb4mkRBJOhBpp0JEzkhsP5buoVuMqo6HylOIUw91HRav/1RuXfeNr9c9KN6bc+9p/vempDmCeG19GsAJVJ/C5/zexkqv4QJPBq9cYM5pQ6Nop92898izGlg7kfIg/iU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KQ4WA0h8; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347077; x=1794883077;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=riT9o6mRwJYJ3rwmNmwc350Zx8TCQXNFFSt3YNL3IcU=;
  b=KQ4WA0h80/onQ7jyNq/ouDsOv6g0EXAf85A05SAB8iH5VhT4EcsadjVG
   8gEtcj2kZn9Cn6/X4LDLpcuHpRxh+u3K71xX0hnsyo8svKLWz53ZbB95u
   lAqDxP1cIcgX5+MC6ljvZEur+EgZyOoxMVr94N2bi809PZlNnPt6Sd66I
   +8szPKvEryVwLwEWtPbi2IQ4DGH82fCFt2uhmsN9oz7M8+5R6XE9lsVC4
   l3nNanjIl1giagwIsRg8mI5vDR9fAg3V66qawVorPjkY6F+j2ch/ta/5Y
   Zy6nxWGihxvtgFW+k1JnX3dgDDHIuCSM3HiLygNd4F++x5dmAITQNGaVH
   A==;
X-CSE-ConnectionGUID: HqPqsCOuTuem/ILARTs0OQ==
X-CSE-MsgGUID: +kwclOz+Rp+S2bbTIZwAUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729485"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729485"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:37:56 -0800
X-CSE-ConnectionGUID: T8dTDpjdQZWPAQvFD1y/BQ==
X-CSE-MsgGUID: scpoBf/USc2MpeAtPUMpmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658067"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:37:52 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 00/26] PCI/TSM: TDX Connect: SPDM Session and IDE Establishment
Date: Mon, 17 Nov 2025 10:22:44 +0800
Message-Id: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is a new version of the RFC [1]. It is based on Dan's
"Link" TSM Core infrastructure [2][3] + Sean's VMXON RFC [4]. All
together they enable the SPDM Session and IDE Establishment for TDX
Connect. This series and its base commits are available in Dan's
tsm.git#staging [5].

Changes since public RFC:
- No tdx_enable() needed in tdx-host
- Simplify tdx_page_array kAPI, no singleton mode input
- Refactor the handling of TDX_INTERRUPTED_RESUMABLE
- Refine the usage of scope-based cleanup in tdx-host
- Set nr_stream_id in tdx-host, not in PCI ACPI initialization
- Use KEYP table + ECAP bit50 to decide Domain ID reservation
- Refactor IDE Address Association Register setup
- Remove prototype patches
- Refactor tdx_enable_ext() locking because of Sean's change
- Pick ACPICA KEYP patch from ACPICA repo
- Select TDX Connect feature for TDH.SYS.CONFIG, remove temporary
  solution for TDH.SYS.INIT
- Use Rick's tdx_errno.h movement patch [6]
- Factor out scope-based cleanup patches in mm
- Remove redunant header files, add header files only when first used
- Use dev_err_probe() when possible
- keyp_info_match() refactor
- Use bitfield.h macros for PAGE_LIST_INFO & HPA_ARRAY_T raw value
- Remove reserved fields for spdm_config_info_t
- Simplify return for tdh_ide_stream_block()
- Other small fixes for Jonathan's comments

[1]: https://lore.kernel.org/linux-coco/20250919142237.418648-1-dan.j.williams@intel.com/
[2]: https://lore.kernel.org/linux-coco/20251031212902.2256310-1-dan.j.williams@intel.com/
[3]: https://lore.kernel.org/linux-coco/20251105040055.2832866-1-dan.j.williams@intel.com/
[4]: https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com/
[5]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/log/?h=staging
[6]: https://lore.kernel.org/all/20250918232224.2202592-2-rick.p.edgecombe@intel.com/


Trimmed Original Cover letter:
-------------------------------

Add a PCI/TSM low-level driver implemenation for TDX Connect (the TEE
I/O architecture for Intel platforms). Recall that PCI/TSM is the
Linux PCI core subsystem for interfacing with platform Trusted Execution
Environment (TEE) Security Managers (TSMs). TSMs establish secure
sessions with PCIe devices (SPDM over Data Object Exchange (DOE)
mailboxes) and establish PCIe link Integrity and Data Encryption (IDE).

This SPDM and IDE facility is enabled with TDX via a new capability
called a TDX Module Extension. An extension, as might be expected, is a
family of new seamcalls. Unlike typical base module seamcalls, an
extension supports preemptible calls for long running flows like SPDM
session establishment. This extension capability was added in response
to Intel Linux team feedback and in support of reducing the complexity
of the Linux implementation. The result is sequences like the following:

        guard(mutex)(&tdx_ext_lock);
        do {
                r = tdh_spdm_connect(tlink->spdm_id, tlink->spdm_conf,
                                     tlink->in_msg, tlink->out_msg,
                                     dev_info, &out_msg_sz);
                ret = tdx_link_event_handler(tlink, r, out_msg_sz);
        } while (ret == -EAGAIN);

...where tdh_spdm_connect() is a seamcall that may return early if this
CPU takes a hardirq or if the module needs a DOE message marshalled to
the device. tdx_link_event_handler() marshals the message and the
extension is resumed to continue the flow. In this case the TDX Connect
extension supports 1 caller at a time, think of it like a queue-depth of
one device-firmware command queue, so concurrency is managed with
@tdx_ext_lock.


Chao Gao (1):
  coco/tdx-host: Introduce a "tdx_host" device

Dave Jiang (2):
  ACPICA: Add KEYP table definition
  acpi: Add KEYP support to fw_table parsing

Kirill A. Shutemov (1):
  x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>

Lu Baolu (2):
  iommu/vt-d: Cache max domain ID to avoid redundant calculation
  iommu/vt-d: Reserve the MSB domain ID bit for the TDX module

Xu Yilun (15):
  x86/virt/tdx: Move bit definitions of TDX_FEATURES0 to public header
  coco/tdx-host: Support Link TSM for TDX host
  mm: Add __free() support for __free_page()
  x86/virt/tdx: Add tdx_page_array helpers for new TDX Module objects
  x86/virt/tdx: Read TDX global metadata for TDX Module Extensions
  x86/virt/tdx: Read TDX Connect global metadata for TDX Connect
  mm: Add __free() support for folio_put()
  x86/virt/tdx: Extend tdx_page_array to support IOMMU_MT
  x86/virt/tdx: Add a helper to loop on TDX_INTERRUPTED_RESUMABLE
  iommu/vt-d: Export a helper to do function for each dmar_drhd_unit
  coco/tdx-host: Setup all trusted IOMMUs on TDX Connect init
  coco/tdx-host: Parse ACPI KEYP table to init IDE for PCI host bridges
  x86/virt/tdx: Add SEAMCALL wrappers for IDE stream management
  coco/tdx-host: Implement IDE stream setup/teardown
  coco/tdx-host: Finally enable SPDM session and IDE Establishment

Zhenzhong Duan (5):
  x86/virt/tdx: Add tdx_enable_ext() to enable of TDX Module Extensions
  x86/virt/tdx: Add SEAMCALL wrappers for trusted IOMMU setup and clear
  coco/tdx-host: Add a helper to exchange SPDM messages through DOE
  x86/virt/tdx: Add SEAMCALL wrappers for SPDM management
  coco/tdx-host: Implement SPDM session setup

 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/tdx-host/Kconfig            |  17 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/tdx-host/Makefile           |   1 +
 arch/x86/include/asm/shared/tdx.h             |   1 +
 .../vmx => include/asm/shared}/tdx_errno.h    |  29 +-
 arch/x86/include/asm/tdx.h                    |  76 +-
 arch/x86/include/asm/tdx_global_metadata.h    |  14 +
 arch/x86/kvm/vmx/tdx.h                        |   1 -
 arch/x86/virt/vmx/tdx/tdx.h                   |  16 +-
 drivers/iommu/intel/iommu.h                   |   2 +
 include/acpi/actbl2.h                         |  59 ++
 include/linux/acpi.h                          |   3 +
 include/linux/dmar.h                          |   2 +
 include/linux/fw_table.h                      |   1 +
 include/linux/gfp.h                           |   1 +
 include/linux/mm.h                            |   2 +
 include/linux/pci-ide.h                       |   2 +
 arch/x86/virt/vmx/tdx/tdx.c                   | 740 ++++++++++++-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |  32 +
 drivers/acpi/tables.c                         |  12 +-
 drivers/iommu/intel/dmar.c                    |  67 ++
 drivers/iommu/intel/iommu.c                   |  10 +-
 drivers/pci/ide.c                             |   5 +-
 drivers/virt/coco/tdx-host/tdx-host.c         | 969 ++++++++++++++++++
 lib/fw_table.c                                |   9 +
 26 files changed, 2027 insertions(+), 47 deletions(-)
 create mode 100644 drivers/virt/coco/tdx-host/Kconfig
 create mode 100644 drivers/virt/coco/tdx-host/Makefile
 rename arch/x86/{kvm/vmx => include/asm/shared}/tdx_errno.h (62%)
 create mode 100644 drivers/virt/coco/tdx-host/tdx-host.c

-- 
2.25.1


