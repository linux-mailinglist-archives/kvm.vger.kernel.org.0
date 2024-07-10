Return-Path: <kvm+bounces-21284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5FA892CD99
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:57:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A58211F229FA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77D4D17CA0D;
	Wed, 10 Jul 2024 08:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="M/CDYaGF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15EE1662FB
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601650; cv=none; b=c4yT4/zQlISprRGG2d3JJLAbU5z16NuOx8m/goLQO9YzZPPQafDCayvgdFGNvpXyzxhGhxknPrKwfsZ6bbFTomIwrER/im6KEhbpHKHRelrEN3++tkZBLadGCxWQxP9sVe4z/tPiZRTsLEdgTDz4+rJWDsjgxuV2ReL8pDzsggY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601650; c=relaxed/simple;
	bh=/qXVF6bqk4LEnOmIQ0fuJ2V4+lmTYdwhVvs16aQn98I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oJzPSAdjzVN4R4EWnk6zLTWRTY8lndq3sLFinZ7bsSo2ALrx478Ka1082gd9dPY5/QnhlANZ9bs0OBgTMLH+KWf7pjOouSg1NRtKsW4T30BmVlLarjzfjR+jZePdQ/SZS+91rJ30lqecWdeJp9yu5Soot5/UnaFjcO+0UHT/BXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=M/CDYaGF; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720601649; x=1752137649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QwCfjXS/kYsMjXws7vKBnjfkXQjfPeTGtCOlVsJ8OLk=;
  b=M/CDYaGFsXsEL4yrX6Af7a7MlwxB9RjyZ4rMUbSY6wZyHkeSjIOma3zM
   XIIhCEwDd1PkWDPEIJ8kHoc9wKdJYefMrVI5TnkPMwgd/0GVb124zCMCD
   iQqA9mn1rVd46dtxlivpSUZPy6nzpiZ4gDHOke28ULRp9nf+niOtR4+45
   M=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="419071250"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:54:05 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:23180]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.92:2525] with esmtp (Farcaster)
 id fba6259c-daf2-4ac2-b11c-1ba7b3658e66; Wed, 10 Jul 2024 08:53:56 +0000 (UTC)
X-Farcaster-Flow-ID: fba6259c-daf2-4ac2-b11c-1ba7b3658e66
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:53:53 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.83.14) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:53:49 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>,
	<ghaskins@novell.com>, <avi@redhat.com>, <mst@redhat.com>,
	<levinsasha928@gmail.com>, <peng.hao2@zte.com.cn>,
	<nh-open-source@amazon.com>
Subject: [PATCH 0/6] KVM: Improve MMIO Coalescing API
Date: Wed, 10 Jul 2024 09:52:53 +0100
Message-ID: <20240710085259.2125131-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
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
 .../selftests/kvm/coalesced_mmio_test.c       | 310 ++++++++++++++++++
 virt/kvm/coalesced_mmio.c                     | 202 +++++++++++-
 virt/kvm/coalesced_mmio.h                     |  17 +-
 virt/kvm/kvm_main.c                           |  40 ++-
 8 files changed, 659 insertions(+), 21 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_mmio_test.c

-- 
2.34.1


