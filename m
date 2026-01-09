Return-Path: <kvm+bounces-67563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E7DCD0AA7A
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 15:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82093300D41C
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 14:34:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E552BD5BD;
	Fri,  9 Jan 2026 14:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iwt7R26Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DC2877C3
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969271; cv=none; b=Ho1mRRoLM+FBGTbuXZ6r+QqtQjhLof6jCT7aso7MzwuFhXYHKmcbLFfMGME3EoCzxmCJ5T5AXbhHfXL4u9rT0c8735YIi4dluL0tVCz3dKlgtXGoh5kdeA5MA8xXaaE3zbtTEmlsj/W25T4c0UT/JhiDD2bG91eDHNPhwokUWxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969271; c=relaxed/simple;
	bh=15qTU4+CXke1ygG+TmMY+CLBeIcRQYGh6Uyey+ohHi4=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=mmarV9DH9OPm7MuazkFLN7HtCrAeyCrdyZP2yOw65xP7oyCJziHfcTy6oEiYoKDRElHqajgXTX7Dgo9i12RvkBhUJQ7okmHBm8RpVHgF4Mak52f5v5MFiZiiDId3rtrAjWvW25wtrhfaphLgXdeZC3PkpffOVc3cA9IEQNMmOBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Iwt7R26Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767969269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6OoGxTNXWXsiEZoieyaX1+6UGf5UFE8Qs8/QIPEPbvI=;
	b=Iwt7R26Z97Qk0sEEJo2zW9iTRf1XHFPPklqYUnZb8JU3BvGf18bOQk++vItTVNxzlkzzsS
	NN8VYowDuTKrrjonB2grPXOSsWI09BpUafCenfDTvYwflgo7FAjXyXhHZbF85yMZTxR7kj
	cHob0te0LQUTmVDF5KqwvD4yZWCoX4g=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-73-GQNkyb6IPie6RbZFkXSlgg-1; Fri,
 09 Jan 2026 09:34:23 -0500
X-MC-Unique: GQNkyb6IPie6RbZFkXSlgg-1
X-Mimecast-MFC-AGG-ID: GQNkyb6IPie6RbZFkXSlgg_1767969262
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1FB61956054;
	Fri,  9 Jan 2026 14:34:21 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.84])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B5FB518001D5;
	Fri,  9 Jan 2026 14:34:15 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	kvm@vger.kernel.org,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH v3 0/6] igvm: Supply MADT via IGVM parameter
Date: Fri,  9 Jan 2026 15:34:07 +0100
Message-ID: <20260109143413.293593-1-osteffen@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

When launching using an IGVM file, supply a copy of the MADT (part of the ACPI
tables) via an IGVM parameter (IGVM_VHY_MADT) to the guest, in addition to the
regular fw_cfg mechanism.

The IGVM parameter can be consumed by Coconut SVSM [1], instead of relying on
the fw_cfg interface, which has caused problems before due to unexpected access
[2,3]. Using IGVM parameters is the default way for Coconut SVSM; switching
over would allow removing specialized code paths for QEMU in Coconut.

In any case OVMF, which runs after SVSM has already been initialized, will
continue reading all ACPI tables via fw_cfg and provide fixed up ACPI data to
the OS as before.

This series makes ACPI table building more generic by making the BIOS linker
optional. This allows the MADT to be generated outside of the ACPI build
context. A new function (acpi_build_madt_standalone()) is added for that. With
that, the IGVM MADT parameter field can be filled with the MADT data during
processing of the IGVM file.

Generating the MADT twice (IGVM processing and ACPI table building) seems
acceptable, since there is no infrastructure to obtain the MADT out of the ACPI
table memory area during IGVM processing.

[1] https://github.com/coconut-svsm/svsm/pull/858
[2] https://gitlab.com/qemu-project/qemu/-/issues/2882
[3] https://github.com/coconut-svsm/svsm/issues/646

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

Oliver Steffen (6):
  hw/acpi: Make BIOS linker optional
  hw/acpi: Add standalone function to build MADT
  igvm: Add missing NULL check
  igvm: Add common function for finding parameter entries
  igvm: Pass machine state to IGVM file processing
  igvm: Fill MADT IGVM parameter field

 backends/igvm-cfg.c       |   2 +-
 backends/igvm.c           | 169 +++++++++++++++++++++++++-------------
 hw/acpi/aml-build.c       |   7 +-
 hw/i386/acpi-build.c      |   8 ++
 hw/i386/acpi-build.h      |   2 +
 include/system/igvm-cfg.h |   3 +-
 include/system/igvm.h     |   3 +-
 target/i386/sev.c         |   2 +-
 8 files changed, 132 insertions(+), 64 deletions(-)

-- 
2.52.0


