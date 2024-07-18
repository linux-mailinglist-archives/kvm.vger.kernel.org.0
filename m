Return-Path: <kvm+bounces-21866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E358293522E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19F181C21AE1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D381459FD;
	Thu, 18 Jul 2024 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="hwLCG+vk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E5176C61
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331417; cv=none; b=jom7NjzmncLcNgIZAkpRV6sMKfZtAAgQ3wZYcue3VSyRlFaoqfNNKMBQ9RgzJYXXe07MHABhBfkYqTzDn2QxcRshjXadc9sPovIXh18ssif5g5DAtpz65CRXufP/8oSHpiNWyL+oZEu0CHEK5syxy4qSDgW2SccmkUoh4KU2jnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331417; c=relaxed/simple;
	bh=uKrZNbdXhOK7pHv9XdtPexbteMZSQyzm0ubIpREUWaM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LIoR2QKDp5qg+n6ap71Cg9SrihT+NsD0BK+w0y2tkcWOP/6ekW7pongf8mn5rER/GJx+46KkDZtZOeO/+NYnIuXZTMds3mwlpPXiX7lnwbipqeVMXLLMbh1oosgLncCu4pPQ8RZOfMF6Q+yJ1AetIrDczdD5kudox9sagNcLyIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=hwLCG+vk; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721331415; x=1752867415;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AX/mMAcbWjHrzewntLD+0qlPpvDy3fm1eDCF7wjo0lE=;
  b=hwLCG+vkZ9V6dO1ozNL8mha6X+CgdrTq8Jenfl1Rmsno8YiI3Se0N4r6
   qNyywuFXPC3rGXr8a0DMTytLxIz25Bh4tgVzNCrMbKPyD2OuifWytywez
   zhd5O9l8YZprAlq76CyMyCa0cSPOLQUmfmAjfeGqxEK9z8BQGsN5XIErk
   I=;
X-IronPort-AV: E=Sophos;i="6.09,218,1716249600"; 
   d="scan'208";a="107367359"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 19:36:53 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:25261]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.11:2525] with esmtp (Farcaster)
 id 0a037e8f-c2fe-4023-88f5-711be319e381; Thu, 18 Jul 2024 19:36:52 +0000 (UTC)
X-Farcaster-Flow-ID: 0a037e8f-c2fe-4023-88f5-711be319e381
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:36:50 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.17) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:36:47 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <nh-open-source@amazon.com>,
	Ilias Stamatis <ilstam@amazon.com>
Subject: [PATCH v2 0/6] KVM: Improve MMIO Coalescing API
Date: Thu, 18 Jul 2024 20:35:37 +0100
Message-ID: <20240718193543.624039-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D039UWB003.ant.amazon.com (10.13.138.93) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

The current MMIO coalescing design has a few drawbacks which limit its
usefulness. Currently all coalesced MMIO zones use the same ring buffer.
That means that upon a userspace exit we have to handle potentially
unrelated MMIO writes synchronously. And a VM-wide lock needs to be
taken in the kernel when an MMIO exit occurs.

Additionally, there is no direct way for userspace to be notified about
coalesced MMIO writes. If the next MMIO exit to userspace is when the
ring buffer has filled then a substantial (and unbounded) amount of time
may have passed since the first coalesced MMIO.

This series adds new ioctls to KVM that allow for greater control by
making it possible to associate different MMIO zones with different ring
buffers. It also allows userspace to use poll() to check for coalesced
writes in order to avoid userspace exits in vCPU threads (see patch 3
for why this can be useful).

The idea of improving the API in this way originally came from Paul
Durrant (pdurrant@amazon.co.uk) but the implementation is mine.

The first patch in the series is a bug in the existing code that I
discovered while writing a selftest and can be merged independently.

Changelog:

v2: 
  - Fixed a bug in poll() in patch 3 where a NULL check was omitted.
  - Added an explicit include to allow the build to succeed on powerpc.
  - Rebased on top kvm/queue resolving a few conflicts.
  - Tiny changes on the last 2 patches.

v1: https://lore.kernel.org/kvm/20240710085259.2125131-1-ilstam@amazon.com/T/

Ilias Stamatis (6):
  KVM: Fix coalesced_mmio_has_room()
  KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
  KVM: Support poll() on coalesced mmio buffer fds
  KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
  KVM: Documentation: Document v2 of coalesced MMIO API
  KVM: selftests: Add coalesced_mmio_test

 Documentation/virt/kvm/api.rst                |  91 +++++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |  18 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/coalesced_mmio_test.c       | 313 ++++++++++++++++++
 virt/kvm/coalesced_mmio.c                     | 205 +++++++++++-
 virt/kvm/coalesced_mmio.h                     |  17 +-
 virt/kvm/kvm_main.c                           |  40 ++-
 8 files changed, 665 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_mmio_test.c

-- 
2.34.1


