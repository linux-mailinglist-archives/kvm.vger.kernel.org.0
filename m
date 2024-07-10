Return-Path: <kvm+bounces-21285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDD192CD9A
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 10:57:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A4FE1C224B3
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 08:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2461517B518;
	Wed, 10 Jul 2024 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="KXfeOi/Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C3E152E0A
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 08:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601699; cv=none; b=r4zgQk60QR8Hy0F80bc/hBmZZa2w4bbqDVCY8jPFj9i7MdWsoK6FTLYPF5zzD9iV04v+jo/qXBtQVLBCGsG6SMmiRw6L2WRipmCi48jOXJPlwGjtHO96P5SmotLD0Buhn/YM03ACAdptwCPMSWXRLwImNImTq4uIUsSfd3bd7Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601699; c=relaxed/simple;
	bh=pfCF8+RH/fLu4XqcZsWj9azT4x70khk79/0BE0m+NsE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJyUQYyLun+W85L703dmcok7xF2AaS3zykrET3eiFcMDrubfrBLI2F57oDRqORMSIfjFpbaX0MZVBSGP42x5e0AeiHBiuNCuHJoM30VS0U2qud0Uy7f60tmmeb6GHca5JRhV2fqDpBhlSVvOLZEYUrVv7lWrlpquxcSIzM47RZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=KXfeOi/Q; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1720601698; x=1752137698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JFS2iURKkmZi+t0llzJ0QX8JVMbmrzpQBj9YDbn+D7Y=;
  b=KXfeOi/Q2sjtW0oBuXKPm5ZwJyMOedsIk3NLm9bdRo7NhTZB9gCwqPRJ
   u+CkffzOIim9tPfvcPE+2Mfj+DAbkDfZgQVgttzzWMdawsYJo2nVutu1t
   YNdgtTryB6dIOUHXQXqzNPrQ8aKIoFCRoJYciNCpnw9TmgynVz2KrIUqj
   g=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="644908580"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:54:55 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.17.79:18712]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.169:2525] with esmtp (Farcaster)
 id e7acea66-2df8-4494-ab1f-618a9a924c21; Wed, 10 Jul 2024 08:54:53 +0000 (UTC)
X-Farcaster-Flow-ID: e7acea66-2df8-4494-ab1f-618a9a924c21
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:54:53 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.83.14) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 08:54:49 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <Laurent.Vivier@bull.net>,
	<ghaskins@novell.com>, <avi@redhat.com>, <mst@redhat.com>,
	<levinsasha928@gmail.com>, <peng.hao2@zte.com.cn>,
	<nh-open-source@amazon.com>
Subject: [PATCH 1/6] KVM: Fix coalesced_mmio_has_room()
Date: Wed, 10 Jul 2024 09:52:54 +0100
Message-ID: <20240710085259.2125131-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240710085259.2125131-1-ilstam@amazon.com>
References: <20240710085259.2125131-1-ilstam@amazon.com>
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

The following calculation used in coalesced_mmio_has_room() to check
whether the ring buffer is full is wrong and only allows half the buffer
to be used.

avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
if (avail == 0)
	/* full */

The % operator in C is not the modulo operator but the remainder
operator. Modulo and remainder operators differ with respect to negative
values. But all values are unsigned in this case anyway.

The above might have worked as expected in python for example:
>>> (-86) % 170
84

However it doesn't work the same way in C.

printf("avail: %d\n", (-86) % 170);
printf("avail: %u\n", (-86) % 170);
printf("avail: %u\n", (-86u) % 170u);

Using gcc-11 these print:

avail: -86
avail: 4294967210
avail: 0

Fix the calculation and allow all but one entries in the buffer to be
used as originally intended.

Fixes: 105f8d40a737 ("KVM: Calculate available entries in coalesced mmio ring")
Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 virt/kvm/coalesced_mmio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 1b90acb6e3fe..184c5c40c9c1 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -43,7 +43,6 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 {
 	struct kvm_coalesced_mmio_ring *ring;
-	unsigned avail;
 
 	/* Are we able to batch it ? */
 
@@ -52,8 +51,7 @@ static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
 	 * there is always one unused entry in the buffer
 	 */
 	ring = dev->kvm->coalesced_mmio_ring;
-	avail = (ring->first - last - 1) % KVM_COALESCED_MMIO_MAX;
-	if (avail == 0) {
+	if ((last + 1) % KVM_COALESCED_MMIO_MAX == READ_ONCE(ring->first)) {
 		/* full */
 		return 0;
 	}
-- 
2.34.1


