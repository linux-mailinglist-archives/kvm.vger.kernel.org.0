Return-Path: <kvm+bounces-50866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D59AEA4E3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F33E2188EF42
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AB51F2BB8;
	Thu, 26 Jun 2025 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1I4FkkoM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3A51D5170
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 18:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750961072; cv=none; b=eNT6giOWyxSWc+o/6PvZUpBxQ21fgZ0E7UBLkaa11ryDh+hRUwxWZhk6oe4JSIUhMU3mWlOjkDjLRfB5S6Mw8skcrqmsexkmpT+rY907lBnfmuNT2bbMUjuwu8eUeFRGLcT3dl7GOJTMf+SYA9n9mD4I7+egJxGudO4llGcoZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750961072; c=relaxed/simple;
	bh=Rkx4KQ77yeIu7CO4FS4b78ADm5/4V255wsE7gByDVsg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YsBMB2EDMVZrAzhuh5w10Ow0HJBy7lM7nEP1kCWbkJ0DWWYrxGq6KZSMSgBasAul5hIIrpdGbSmQQWJWtAed135SoW/FuCwIZP0siN6IEh3pVHAee2VLPnRFt5j5SW0nkyXxXKaYUGGGkcsC49tt8K4/7zmTjeM/WgUm1KmHNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1I4FkkoM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aaronlewis.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31cc625817so1910478a12.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 11:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750961070; x=1751565870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yWADQdQbdkIh2Q6qNS73PdjIsmJ53CZJOspegHLcrv4=;
        b=1I4FkkoMrVa0zP9kPtnlFqUyHjykEn3/4xfgpKgshkIqz1IILbVuQ0TUmYyXjAiemn
         z7HkfZSaXu1XU4OS76Yl/n4DAnRTmRmKlFJFPQxhDq8OF6FBgxLcGvupI7AUIPpphdUr
         NVutZ0PeLfSO86eOYM352BJdmMDvrDPn+ObwJ1qgp8ihj2RtGE6OvRRHFYqHHKM3Rbjs
         lrm1Ew1s+632lVMqrW4nf0sPec3rZRE66+xv6QJXPDMzINVplzlovsFHsEMwsDgozBfL
         yVzAxjKVt4e6Scjy+gb7kq/Yc21K2+3n/myx30aq1kv0Biy7YMZc7Wxn+H2dQcLXusFE
         fQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750961070; x=1751565870;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yWADQdQbdkIh2Q6qNS73PdjIsmJ53CZJOspegHLcrv4=;
        b=DQ79PHV4x/S7VdUg2zrsU+WZ4kcDHk1nmI8YdyAoDz71EtZUGtrIaYXSVtQKAp9sq5
         yp9TNKwNkOmFD/lhRYJYC9yLOj1A73VO1rpg2tZbS7zVx1/i5IxaTYgATybir+bt6ISO
         ibHx7i8DTvGtPl5rVvDoZcaDyGmgff3U8PnZpkU9QnsYdfab1vC8TeTctlvpLHSFfv77
         /kPYaZtDvpstL5n51TSviCMxkqH84QED7GE9GaEV4hBosRXNGXgh+pDr9PqGTX1T2Xyk
         5W/M1nX5WEL1XSAYIHw8bHGkCzs2jIp72bma3t/Imp600wmYB1OCeXLlCZABqbZSE19D
         glEw==
X-Gm-Message-State: AOJu0Yw74RO5mliF+LkJ95YbfTV1jUSpO5jnGVTjDZuziU2NFGBrIF7Z
	vMwGd6bdGmYLkgXX4z76j7UJoEA6demqlDcB4+CHNauJkVWwhcn/sdfL3GhguJ2Ngt7kxQIBaDi
	c1ATFdSRkgqgCVhY0d8TMGQ==
X-Google-Smtp-Source: AGHT+IGmAPc3I8Fc3EIEsDGgOCGC2lw0aCXAriZknEVcCvh7xm+LcY2olpwwekyRq/2LWezSivRs7MrnFU9qhbjJ
X-Received: from pjbov13.prod.google.com ([2002:a17:90b:258d:b0:311:4201:4021])
 (user=aaronlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:394d:b0:2fa:2133:bc87 with SMTP id 98e67ed59e1d1-316d69bf1dfmr6671785a91.6.1750961070177;
 Thu, 26 Jun 2025 11:04:30 -0700 (PDT)
Date: Thu, 26 Jun 2025 18:04:21 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626180424.632628-1-aaronlewis@google.com>
Subject: [RFC PATCH 0/3] vfio: selftests: Add VFIO selftest to demontrate a
 latency issue
From: Aaron Lewis <aaronlewis@google.com>
To: alex.williamson@redhat.com, bhelgaas@google.com, dmatlack@google.com, 
	vipinsh@google.com
Cc: kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

This series is being sent as an RFC to help brainstorm the best way to
fix a latency issue it uncovers.

The crux of the issue is that when initializing multiple VFs from the
same PF the devices are reset serially rather than in parallel
regardless if they are initialized from different threads.  That happens
because a shared lock is acquired when vfio_df_ioctl_bind_iommufd() is
called, then a FLR (function level reset) is done which takes 100ms to
complete.  That in combination with trying to initialize many devices at
the same time results in a lot of wasted time.

While the PCI spec does specify that a FLR requires 100ms to ensure it
has time to complete, I don't see anything indicating that other VFs
can't be reset at the same time.

A couple of ideas on how to approach a fix are:

  1. See if the lock preventing the second thread from making forward
  progress can be sharded to only include the VF it protects.
  
  2. Do the FLR for the VF in probe() and close(device_fd) rather than in
  vfio_df_ioctl_bind_iommufd().

To demonstrate the problem the run script had to be extended to bind
multiple devices to the vfio-driver, not just one.  E.g.

  $ ./run.sh -d 0000:17:0c.1 -d 0000:17:0c.2 -d 0000:16:01.7 -s

Also included is a selftest and BPF script.  With those, the problem can
be reproduced with the output logging showing that one of the devices
takes >200ms to initialize despite running from different threads.

  $ VFIO_BDF_1=0000:17:0c.1 VFIO_BDF_2=0000:17:0c.2 ./vfio_flr_test
  [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
  [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.

And the BPF script indicating that the latency issues are coming from the
mutex in vfio_df_ioctl_bind_iommufd().

  [pcie_flr] duration = 108ms
  [vfio_df_ioctl_bind_iommufd] duration = 108ms
  [pcie_flr] duration = 104ms
  [vfio_df_ioctl_bind_iommufd] duration = 212ms

  [__mutex_lock] duration = 103ms
  __mutex_lock+5
  vfio_df_ioctl_bind_iommufd+171
  __se_sys_ioctl+110
  do_syscall_64+109
  entry_SYSCALL_64_after_hwframe+120

This series can be applied on top of the VFIO selftests using the branch:
upstream/vfio/selftests/v1.

https://github.com/dmatlack/linux/tree/vfio/selftests/v1

Aaron Lewis (3):
  vfio: selftests: Allow run.sh to bind to more than one device
  vfio: selftests: Introduce the selftest vfio_flr_test
  vfio: selftests: Include a BPF script to pair with the selftest vfio_flr_test

 tools/testing/selftests/vfio/Makefile         |   1 +
 tools/testing/selftests/vfio/run.sh           |  73 +++++++----
 tools/testing/selftests/vfio/vfio_flr_test.c  | 120 ++++++++++++++++++
 .../testing/selftests/vfio/vfio_flr_trace.bt  |  83 ++++++++++++
 4 files changed, 251 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/vfio/vfio_flr_test.c
 create mode 100644 tools/testing/selftests/vfio/vfio_flr_trace.bt

-- 
2.50.0.727.gbf7dc18ff4-goog


