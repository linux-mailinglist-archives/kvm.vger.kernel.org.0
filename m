Return-Path: <kvm+bounces-24637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A16BE958805
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAD761C21A79
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACCB18EFEE;
	Tue, 20 Aug 2024 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="BeyOR4vA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BA818A6D1
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160907; cv=none; b=E1kSutAmBaEBWS71fv30HYNHWYxdRF4m6Pow9BiNDyi/mXkKTzz98KWzat6GAv8V43kx7mzbcyac+FCvGvPrGPa0/4wSq7jHZ4xruYimr4aLy1JczaAwLjN9YpaZNQdkz6UHzJWzS3yCSKF2SVxCdbZBCSeNm8Bkrn77m5ogTHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160907; c=relaxed/simple;
	bh=eDlOvs7s0hvqqUbA2KxNUdARJ6vvFVdhPE13uoJ1Vts=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r/LbM+muU0jdOTMLQBR9eWK9j5tYVLj0K1YFrVfuYAYYcCWicM6W9m8d1n59tVtzzVsYWyYjlx2lmPZ+QQC9FRt5X2JMhwiRRcFVlOIDYaimwTrPcJ2ytfxCsCec/53MO7ecLW6X06UdGNhYQIrkrHEyt08uqulzRVDzlBrjag4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=BeyOR4vA; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724160903; x=1755696903;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1SJeF/u166tjTOo7xoAGpb4832yUY3Jf9IDYbfxoSck=;
  b=BeyOR4vAWN+2u+zdB2Eq6zIbDy/wJDqdyZvjbxSYUOL9rt6On8X3Xj46
   2yIGKSnNfwsGBWJCIFUJxsCKup3E+qOF2BJaKnzFtWQvmudzVK8I/OU+X
   Pn8GpjOyCzCmT3pWvP3bUDVX0XYM63S0WVjB74gQFFXeP9VnXx/qIuibR
   w=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="117200682"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:35:00 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:11620]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.126:2525] with esmtp (Farcaster)
 id e16951a5-5f1e-4580-839a-61aaad654d33; Tue, 20 Aug 2024 13:34:59 +0000 (UTC)
X-Farcaster-Flow-ID: e16951a5-5f1e-4580-839a-61aaad654d33
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:34:59 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:34:56 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>
Subject: [PATCH v3 0/6] KVM: Improve MMIO Coalescing API
Date: Tue, 20 Aug 2024 14:33:27 +0100
Message-ID: <20240820133333.1724191-1-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
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

v3:
  - Fixed test robot build warning and made small changes suggested by
    Sean Christopherson

v2: https://lore.kernel.org/kvm/20240718193543.624039-1-ilstam@amazon.com/T/

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
 virt/kvm/coalesced_mmio.c                     | 203 +++++++++++-
 virt/kvm/coalesced_mmio.h                     |  17 +-
 virt/kvm/kvm_main.c                           |  37 ++-
 8 files changed, 661 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/coalesced_mmio_test.c

-- 
2.34.1


