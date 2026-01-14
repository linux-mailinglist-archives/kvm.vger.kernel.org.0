Return-Path: <kvm+bounces-68062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EB10FD20A42
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 18:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E76B230313C7
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 17:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A54E932B98D;
	Wed, 14 Jan 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZpZ83HKu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8C031ED7D
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768413023; cv=none; b=E6JFB729LPtRkR2zEsTSCADXl+UuzOAe7jF/mcGZo9J+c+ySt7+BYEq00ip+EY1sNjMfxIPm1Q1Yy3HQfHwz192gQ8YYgPBWkgkdvzepPXkJVQ2cHpZyQ6D6v1Rr5Y/WhopkoFpz2p5J9GbNZGk/pyEIrf8CHUQWIHI2Itf/ngI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768413023; c=relaxed/simple;
	bh=CgrTIw2YKQlHzFIzLr4KXO5z/+MmT9jJNIVXKe4X9Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lKGV3PcKD0ORhiwH/P56SOE0E/HeZB2qZLifCVqPrKGAgj187NC1yYCfNv832s0omI2hnF6VscTae0TeYQx/8yfZ2iCOfqsfnS+71/0Q44qKhfNjj+Gar0pg5/LBIPi6IVXQFCIkIhMYO7m49404XnC22MW5QKtFjioVzOxW/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZpZ83HKu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768413020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wXFRdfgha3IAcabnT3zx5QHsWtqFvEa1mHJ7Qyzdn18=;
	b=ZpZ83HKurrVqz0+hIir85ZoOsw4BVoDI4LrHsWFHNTvy/X36eA9WyMSXhOZmwh513BRW9F
	pJYqEtb+copHFSFAjsBlJ7jA7lHyRmdjYAktepUzptFodjUe76IMya3aUYYQ2xt17smLKj
	ALeG9CR7WCDpb0N5NZClJcF9D4XBquA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-xaFClcQKMoGxL-5YPBqFNQ-1; Wed,
 14 Jan 2026 12:50:17 -0500
X-MC-Unique: xaFClcQKMoGxL-5YPBqFNQ-1
X-Mimecast-MFC-AGG-ID: xaFClcQKMoGxL-5YPBqFNQ_1768413016
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4B44195605B;
	Wed, 14 Jan 2026 17:50:15 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.224.90])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 960BB1800665;
	Wed, 14 Jan 2026 17:50:09 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v4 0/5] igvm: Supply MADT via IGVM parameter
Date: Wed, 14 Jan 2026 18:50:02 +0100
Message-ID: <20260114175007.90845-1-osteffen@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

When launching using an IGVM file, supply a copy of the MADT (part of the ACPI
tables) via an IGVM parameter (IGVM_VHY_MADT) to the guest, in addition to the
regular fw_cfg mechanism.

The IGVM parameter can be consumed by Coconut SVSM [1], instead of relying on
the fw_cfg interface, which has caused problems before due to unexpected access
[2,3]. Using IGVM parameters is the default way for Coconut SVSM; switching
over would allow removing specialized code paths for QEMU in Coconut.

Coconut SVSM needs to know the SMP configuration, but does not look at
any other ACPI data, nor does it interact with the PCI bus settings.
Since the MADT is static and not linked with other ACPI tables, it can
be supplied stand-alone like this.

Generating the MADT twice (IGVM processing and ACPI table building) seems
acceptable, since there is no infrastructure to obtain the MADT out of the ACPI
table memory area during IGVM processing.

In any case OVMF, which runs after SVSM has already been initialized, will
continue reading all ACPI tables via fw_cfg and provide fixed up ACPI data to
the OS as before.

This series makes ACPI table building more generic by making the BIOS linker
optional. This allows the MADT to be generated outside of the ACPI build
context. A new function (acpi_build_madt_standalone()) is added for that. With
that, the IGVM MADT parameter field can be filled with the MADT data during
processing of the IGVM file.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

v4:
- Add ACPI table checksum calculation without BIOS linker, used
  for the standalone MADT.
- Don't pass ConfidentialGuestState into the IGVM backend anymore.
  Not needed, since we already have the full MachineState there now.
- Move the NULL check patch out into a new series (to be posted).
- Address remaining cleanup comments.

v3:
- Pass the machine state into IGVM file processing context instead of MADT data
- Generate MADT from inside the IGVM backend
- Refactor: Extract common code for finding IGVM parameter from IGVM parameter handlers
- Add NULL pointer check for igvm_get_buffer()

v2:
- Provide more context in the message of the main commit
- Document the madt parameter of IgvmCfgClass::process()
- Document why no MADT data is provided the process call in sev.c

Based-on: <20251118122133.1695767-1-kraxel@redhat.com>
Signed-off-by: Oliver Steffen <osteffen@redhat.com>

Oliver Steffen (5):
  hw/acpi: Make BIOS linker optional
  hw/acpi: Add standalone function to build MADT
  igvm: Add common function for finding parameter entries
  igvm: Pass machine state to IGVM file processing
  igvm: Fill MADT IGVM parameter field

 backends/igvm-cfg.c       |   2 +-
 backends/igvm.c           | 179 +++++++++++++++++++++++---------------
 hw/acpi/aml-build.c       |  29 +++++-
 hw/i386/acpi-build.c      |   9 ++
 hw/i386/acpi-build.h      |   2 +
 include/system/igvm-cfg.h |   3 +-
 include/system/igvm.h     |   5 +-
 target/i386/sev.c         |   3 +-
 8 files changed, 155 insertions(+), 77 deletions(-)

-- 
2.52.0


