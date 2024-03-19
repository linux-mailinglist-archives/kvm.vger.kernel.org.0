Return-Path: <kvm+bounces-12127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14DEE87FD50
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A04821F22483
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 12:04:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC477F499;
	Tue, 19 Mar 2024 12:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J5lspP0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9947CF03;
	Tue, 19 Mar 2024 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710849877; cv=none; b=rTSkUnqAlDcCWlSDwlnEhknfTIKgg9KpvYXgm/8uX3+ZrjmP6VSo3Im8ZaceV3pJWXUCfnfu7JKMyYJVpsLD0E1e2unb4Mi/sJB8DivqzzBGvRrXaCzCt0ZjIpHMGebBV7kptQbPq/w6QnRCR4jeNTOW3mN9NpD/KNl5FRb5jQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710849877; c=relaxed/simple;
	bh=MgJW5voqxFyNFIDyqHRb3NG7cNiaAkj/78PRZlkZUUY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aTulveindf9QzWKmNoI7BcTLfETy+ozTkPr937xI7XEiVQRjx9UkFEqD6rDl9HRYsjRpraWa7JnMkUtz+r6wxp1FUr53LsgqfV7upreZnO3L1hfbfWwB0WTwfUkZeSunrm65Cv1YqGOue8QSgMZHF0pwXtUzY+s9HV5KZfdUz7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J5lspP0G; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d4a901e284so41658701fa.1;
        Tue, 19 Mar 2024 05:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710849874; x=1711454674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p3nTBtfAkkkz32UQKuz5vte+Epjvb/kCDDdWznm9o78=;
        b=J5lspP0GnF4R5QyfeFtL2tdyh1n7Jf9zgxkXVOaSkiybUYeyfHypjlM+dYZet8cgWh
         BWBkfd7uV0/Ey4fN7htU7nHSsbXE0Jja50VwRNj5Uq+Xwria3v6F01TwbtDPlhCSWtbL
         bz3NM7SQdPhdBa+z4csl2A1nceEUvVRRd+82e+MRix8GC33aLiOQLS6EvhsbLkMkC3/K
         oudcvrOL2R0iw9v5lZFfktJoeAo7+xHCVs95zIZTKEOhpN94Oiy8USoFbvAh0Jb/dYTo
         RySwo1knnjKIbq+KgwUEW25qFFFoZ3Scwc+d2rUdu8XmsOAVCf/re/ll1iGyjb2OyTSj
         KZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710849874; x=1711454674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3nTBtfAkkkz32UQKuz5vte+Epjvb/kCDDdWznm9o78=;
        b=XrbLfJ8mKSvr8EsmHM7JBmO2zQZFXfWEWfFppQxuKIoSPtxyKMLNRX22Oy49GOxH7E
         V46ED3K13mmcobecuTHWdIAii91/+DulDQuR1p0fxghriEg32TM6XcujZWnsd16mc5pb
         LXGHkdFgYlfmvxky60wLvq3zHRkQ2E/xv/uXvbDOz9hcAfMI7YwphIMeCygr3m4bGcWH
         VPib7QRYqECpKCFd3NcV/qZIUazjE3IRzZLm7Q5b80HmosMfhIYxCQn7bFpwPq3v01wQ
         dQc0tmElo8cg7ViMaD8RxaUDmZsmeT/viUXTRnVqPTf/WOSymCybC2jmrBEw0FIz9VGM
         rt2A==
X-Forwarded-Encrypted: i=1; AJvYcCXJuU5UwFxjEQLBmiMrxOONqoMTxXlUX+3JTfmZgpkaE8/z6yp/1SiejSIqTgv7gdhKYcoem0kYChmQzXzbWQ+7jqMA4qNCFWWsddmratnRXDDplkDwESqNnT/cS8O6vEeW
X-Gm-Message-State: AOJu0YwmEvhUkKQT0pMLRWg6CHPJXpUyk5mTyIhQlMyzspFjTeaO8UMB
	blKFynfciK9+qO11gD6/uhObUC4UHCcVDHuHrGdSiIzQw2HgiGh3
X-Google-Smtp-Source: AGHT+IFGmeUnYwFisUej1wxB8IsFlGhW1N1ljK8ou50CU7bNS77G8yv5k3TExvjgcerTVTvdTFLKFw==
X-Received: by 2002:a2e:95d3:0:b0:2d4:68ef:c714 with SMTP id y19-20020a2e95d3000000b002d468efc714mr8332249ljh.38.1710849873544;
        Tue, 19 Mar 2024 05:04:33 -0700 (PDT)
Received: from linguini.. ([62.96.37.222])
        by smtp.gmail.com with ESMTPSA id f23-20020a170906049700b00a4588098c5esm5989722eja.132.2024.03.19.05.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 05:04:32 -0700 (PDT)
From: Mikhail Malyshev <mike.malyshev@gmail.com>
To: alex.williamson@redhat.com,
	jgg@ziepe.ca,
	yi.l.liu@intel.com,
	kevin.tian@intel.com,
	tglx@linutronix.de,
	reinette.chatre@intel.com,
	stefanha@redhat.com
Cc: abhsahu@nvidia.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mikhail Malyshev <mike.malyshev@gmail.com>
Subject: [PATCH 0/1] Reenable runtime PM for dynamically unbound devices
Date: Tue, 19 Mar 2024 12:04:09 +0000
Message-Id: <20240319120410.1477713-1-mike.malyshev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When trying to run a VM with PCI passthrough of intel-eth-pci ETH device
QEMU fails with "Permission denied" error. This happens only if
intel-eth-pci driver is dynamically unbound from the device using
"echo -n $DEV > /sys/bus/pci/drivers/stmmac/unbind" command. If
"vfio-pci.ids=..." is used to bind the device to vfio-pci driver and the
device is never probed by intel-eth-pci driver the problem does not occur.

When intel-eth-pci driver is dynamically unbound from the device
.remove()
  intel_eth_pci_remove()
    stmmac_dvr_remove()
      pm_runtime_disable();

Later when QEMU tries to get the device file descriptor by calling
VFIO_GROUP_GET_DEVICE_FD ioctl pm_runtime_resume_and_get returns -EACCES.
It happens because dev->power.disable_depth == 1 .

vfio_group_fops_unl_ioctl(VFIO_GROUP_GET_DEVICE_FD)
  vfio_group_ioctl_get_device_fd()
    vfio_device_open()
      ret = device->ops->open_device()
        vfio_pci_open_device()
          vfio_pci_core_enable()
              ret = pm_runtime_resume_and_get();

This behavior was introduced by
commit 7ab5e10eda02 ("vfio/pci: Move the unused device into low power state with runtime PM")

This may be the case for any driver calling pm_runtime_disable() in its
.remove() callback.

The case when a runtime PM may be disable for a device is not handled so we
call pm_runtime_enable() in vfio_pci_core_register_device to re-enable it.

Mikhail Malyshev (1):
  vfio/pci: Reenable runtime PM for dynamically unbound devices

 drivers/vfio/pci/vfio_pci_core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--
2.34.1

