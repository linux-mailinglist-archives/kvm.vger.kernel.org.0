Return-Path: <kvm+bounces-65737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C29FECB5168
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 09:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B49123023559
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8DA1296BC0;
	Thu, 11 Dec 2025 08:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vs/mD+UZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886D51684A4
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765440931; cv=none; b=SI9Nha7aqJNa690rBxnDX7iSN+WKvP2O/m2YHb2rolOz1OUr+4+sXD2NdIv9sdCLUEQyJvtV9YTQEc2Ue33zmMiQTMGurZqmIuP6f8iYE8uHmECdSNbs3a2/+dTyk5r0Sb1RCBA2G97xZxAiJDH6xB1P4X3zYTB0gJiL7T2DAkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765440931; c=relaxed/simple;
	bh=1tEaWLISHqYgla55b+HslTXeEQGlNMWtH4voU+8XGXA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iyToXSJjvWgp1UL3YUoRIHK07eUTmbWjZcIy1BSZ7rEHuJKc+fZ6/7L1iMs3epxRQ+XvA2DwHcre4Vn/EJhXv/9sBZoGcOL3rdwLYTcOWJmh4anU+XSXLXx2tq6R3ojfs1sk4l8Cj65tk4qX2dRQg0bxEkxo+CuavGyqrVfHjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vs/mD+UZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765440928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=M8fjFCZRCNVfT3+gG6VX2JPyrUB/kemfpjD20xKGraY=;
	b=Vs/mD+UZO0z7O5VyAvTAHNocvF8pMsrtFJ5ivM5omruPvfOiOi36KKPg5UWOLJ+epDKC5N
	ACl5nyEnPxirIGRPcJZcceu0r3zgV/WxPtMm1FxODFMD9GRIlOEfHf3uQv/tZXxl6UcF6C
	Xoqy/9Irxq23GhWSK7NmnGvBF3rPxkE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-Av6hOU9LN4aL6s108i7sdA-1; Thu,
 11 Dec 2025 03:15:27 -0500
X-MC-Unique: Av6hOU9LN4aL6s108i7sdA-1
X-Mimecast-MFC-AGG-ID: Av6hOU9LN4aL6s108i7sdA_1765440925
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBABE1956089;
	Thu, 11 Dec 2025 08:15:24 +0000 (UTC)
Received: from osteffen-laptop.redhat.com (unknown [10.45.225.89])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7ADD23000218;
	Thu, 11 Dec 2025 08:15:19 +0000 (UTC)
From: Oliver Steffen <osteffen@redhat.com>
To: qemu-devel@nongnu.org
Cc: Joerg Roedel <joerg.roedel@amd.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ani Sinha <anisinha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Oliver Steffen <osteffen@redhat.com>
Subject: [PATCH 0/3] igvm: Supply MADT via IGVM parameter
Date: Thu, 11 Dec 2025 09:15:14 +0100
Message-ID: <20251211081517.1546957-1-osteffen@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

Based-On: 20251118122133.1695767-1-kraxel@redhat.com
Signed-off-by: Oliver Steffen <osteffen@redhat.com>

Oliver Steffen (3):
  hw/acpi: Make BIOS linker optional
  hw/acpi: Add standalone function to build MADT
  igvm: Fill MADT IGVM parameter field

 backends/igvm-cfg.c       |  8 +++++++-
 backends/igvm.c           | 37 ++++++++++++++++++++++++++++++++++++-
 hw/acpi/aml-build.c       |  7 +++++--
 hw/i386/acpi-build.c      |  8 ++++++++
 hw/i386/acpi-build.h      |  2 ++
 include/system/igvm-cfg.h |  4 ++--
 include/system/igvm.h     |  2 +-
 target/i386/sev.c         |  2 +-
 8 files changed, 62 insertions(+), 8 deletions(-)

-- 
2.52.0


