Return-Path: <kvm+bounces-44462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A178DA9DD3F
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 23:27:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0541F189A63D
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 21:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F00401FAC42;
	Sat, 26 Apr 2025 21:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DmknmQgv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984CD1DF963;
	Sat, 26 Apr 2025 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745702817; cv=none; b=a1nezV03LfOlMZHjQZkXlPLlzh2ubmAA+Qjbx7YtoAsgKtGThpvx8wHj86YEgzxAe7El7MN7l9jNwjsGEuJFSua2f6pX1r8lA8+vpS5KYijPdQ6T7MAaZKlnMI4WjmCmhfxcXNyHc47tO0BKBqk90FdToRACUeFyNCAlCe7foTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745702817; c=relaxed/simple;
	bh=EcE21CmXTGN4YKLwnlETDTOORw3h1YWBDGZ5X+SRCwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W9jrDdcj9ti1aZ9RssKYbVFZGXbhXNmxOJCxBE2Q7H6CUl7dISiNm18ZnWzIHhbSzniPHoUUmuC9REjyH9lDbvcWsg7wVQddVYp5EUp9Fwa/tjlpxXimv3wcthretpfEt4E+otKsMK7mrO1ixRaxggN8HUUnyCgEiYFdbU2M/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DmknmQgv; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-86142446f3fso101530839f.2;
        Sat, 26 Apr 2025 14:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745702814; x=1746307614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MmxI1k+sF1d3zlvj3ACA+eByFlsBlJlVBc9Y0SYMFWo=;
        b=DmknmQgvlUj0S5e80MXfnC2C4k0QoGQ8tZO1pAvgQ5l+CLuOmqBqKItg5VUUiJ3jqI
         W9r+XqARBlgB3XDbxcimLK2By4whd6Skx62Zz/VOX8Z2DTud6pwUS2TqhQ+OsEsAA2mc
         AZ5GJ7kv/W9X1jsYZdWmcjCHzPOOGamQzwnx03CZawwgzCHbAO7ZiuUymFUm7F0lUpPi
         n8St0mzQcYMmzwWIalgkSpa3QOcSmDPSbzZz4akimbQzpAoJ6WkQuil7xCnst937dE/h
         pGSWEfVN7Ya8V9sRImbTiUy7R+6JKna+TC6blG6THSJtysT/c0qlrdwlh9FvpCvFsLTK
         H35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745702814; x=1746307614;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MmxI1k+sF1d3zlvj3ACA+eByFlsBlJlVBc9Y0SYMFWo=;
        b=GVzB9YTWINTHE3aAdsUsE8Eaj03/pEYzcVXLCdM21A1q+/zx+p3rvNDOrFM0l/kJtI
         g/20dnmIOpYm3kBN8EMjq8zhRIDBrYnOyTRg3kGdxBzNG73GWGYSHvsQDN/ql4sb0PXm
         DWtu5bijtX9u0X3BllGwcCvArs2FTjorqZUOkwQsC4jtspjT5/m9W/QkOJLfx/oUlW9C
         gsMb3aJ7gQolwfs0fOt6ivo4A+ZSshR2TKt7WszzUEH/2X8ckKsCtD9BA2spac59IB/T
         P1sbNiPCxuZGfJUbMIcLQ9XXgMxIUTWjZCYCJAdIM2gxkwUnb1pnxofGcuWSWfiW4+q5
         mngQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQjzx6qECnN43Di5S80zMg0KT4GE6z24KrLZNalEOUFlhhbFAK/Uk6Ke4UsWfqeuMKhLgEPS0tzj8klsk3@vger.kernel.org, AJvYcCVbA3QgPfJIfTxUTtZGVIDs/z9c+73YFGrnMFXErYQmFhDbzse/vyEwqOC6QdSxmy85oSksIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/qYStRzc9z9hgCvN4ut94gvM2wa1FXQeUrhMy4OEg/MNohkEQ
	cFf5oF3aT7cI2m6YSHE06aVpKjN9vyScuXRjbjTwNK2WAFuzS50NO1+3i/HJ
X-Gm-Gg: ASbGncsLnw7j0WzB3fbcudGfxhJqmEM1OVbMmKwamILzrLc+/p0tKpQp23S3x6mqysa
	WHOw6fK0Ycq4fEccjkQbA0Q2aSO5diPX2wBEtLoHOGv3V/H+6iBUM1MpwkE+osbnJ4HJNLuWD/F
	qcKJKdbScYIn5GYDhStKW89DSeBsMmqIiv2e4zxYU/dLFF5BQESLKNoCTYZNNr3nQKDYW9Nj6ko
	S0ATdLT2SbVvN132oXNzxY/zPFQ19cRKhcmP4cspWbcSrjBOsRFQN3sOZHu1h7+BWxqucb5JTF1
	m1EVV9eybKFAq89VlzxSjyWq0pneWntLkn4JgUCOZaV9mFJuNgscz/KV7yHecDpX0GaovPzO+nG
	NJFmcTcF6MsXwQMOnMLqTIitkpF8MrlYQvv4iZjO+ZFevQ8QH
X-Google-Smtp-Source: AGHT+IFqIkAIWvE7cI9PgKyNPszXP20HXmpxMumo1GwtTzvMneS1kNj13tISEJjrHxvrvEUjXDzn1Q==
X-Received: by 2002:a05:6e02:b22:b0:3d5:7f32:8d24 with SMTP id e9e14a558f8ab-3d93b5763b3mr67922455ab.15.1745702814441;
        Sat, 26 Apr 2025 14:26:54 -0700 (PDT)
Received: from master.chath-253561.iommu-security-pg0.wisc.cloudlab.us (sm220u-10s10539.wisc.cloudlab.us. [128.105.146.46])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f824ba34c1sm1454482173.126.2025.04.26.14.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 14:26:54 -0700 (PDT)
From: Chathura Rajapaksha <chathura.abeyrathne.lk@gmail.com>
X-Google-Original-From: Chathura Rajapaksha <chath@bu.edu>
To: kvm@vger.kernel.org
Cc: Chathura Rajapaksha <chath@bu.edu>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Yahui Cao <yahui.cao@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Yunxiang Li <Yunxiang.Li@amd.com>,
	Dongdong Zhang <zhangdongdong@eswincomputing.com>,
	Avihai Horon <avihaih@nvidia.com>,
	linux-kernel@vger.kernel.org,
	audit@vger.kernel.org
Subject: [RFC PATCH 0/2] vfio/pci: Block and audit accesses to unassigned config regions
Date: Sat, 26 Apr 2025 21:22:47 +0000
Message-Id: <20250426212253.40473-1-chath@bu.edu>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some PCIe devices trigger PCI bus errors when accesses are made to
unassigned regions within their PCI configuration space. On certain
platforms, this can lead to host system hangs or reboots.

The current vfio-pci driver allows guests to access unassigned regions
in the PCI configuration space. Therefore, when such a device is passed
through to a guest, the guest can induce a host system hang or reboot
through crafted configuration space accesses, posing a threat to
system availability.

This patch series introduces:
1. Support for blocking guest accesses to unassigned
   PCI configuration space, and the ability to bypass this access control
   for specific devices. The patch introduces three module parameters:

   block_pci_unassigned_write:
   Blocks write accesses to unassigned config space regions.

   block_pci_unassigned_read:
   Blocks read accesses to unassigned config space regions.

   uaccess_allow_ids:
   Specifies the devices for which the above access control is bypassed.
   The value is a comma-separated list of device IDs in
   <vendor_id>:<device_id> format.

   Example usage:
   To block guest write accesses to unassigned config regions for all
   passed through devices except for the device with vendor ID 0x1234 and
   device ID 0x5678:

   block_pci_unassigned_write=1 uaccess_allow_ids=1234:5678

2. Auditing support for config space accesses to unassigned regions.
   When enabled, this logs such accesses for all passthrough devices.
   This feature is controlled via a new Kconfig option:

     CONFIG_VFIO_PCI_UNASSIGNED_ACCESS_AUDIT

   A new audit event type, AUDIT_VFIO, has been introduced to support
   this, allowing administrators to monitor and investigate suspicious
   behavior by guests.

This proposal is intended to harden VFIO passthrough in environments
where guests are untrusted or system reliability is critical.

Any feedback and comments are greatly appreciated.

Chathura Rajapaksha (2):
  block accesses to unassigned PCI config regions
  audit accesses to unassigned PCI config regions

 drivers/vfio/pci/Kconfig           |  12 +++
 drivers/vfio/pci/vfio_pci_config.c | 164 ++++++++++++++++++++++++++++-
 include/uapi/linux/audit.h         |   1 +
 3 files changed, 176 insertions(+), 1 deletion(-)


base-commit: f1a3944c860b0615d0513110d8cf62bb94adbb41
-- 
2.34.1


