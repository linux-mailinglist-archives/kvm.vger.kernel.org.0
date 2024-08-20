Return-Path: <kvm+bounces-24638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A808958806
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A2B41F2314F
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E519D18FDDF;
	Tue, 20 Aug 2024 13:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="v42arRQN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B111AACB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724160947; cv=none; b=O/uVbmsW+SMlJBVsHW4FgXZ6MSWTHFtlR0ge41mmWFTJYXpN6H4rVXU1OLXeuistY1R0qzaTg8h2NdIQITZoMrMl0YQxXuTnuJSlgYVOE44wEaW0OUKykbcEuASGSWOVOhEUqwjWfSzpjTuG/w/XTaJUp4Hhztb3w1dZb/aYJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724160947; c=relaxed/simple;
	bh=H7k+6nAtfPAjMYGkXJcBgLA3LEHTFAquwe3upQ2dfFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUpH0N6AkO3sLlbk5IGDvstwV9XpLuqnUj3aR944imb2234HKot12QKZmI/dZPu3EsCr9n22qR+8D9pDgI0FDpD9oPK9P6t1aR2HayoAl78SZz3f3D3BRgnuRAiRa32uzGgmrMqWY5TxTIGgox8bvFH/6nZrF2vCdFRy/J0XsVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=v42arRQN; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724160946; x=1755696946;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OuOmf53f5AL3V3xjIto3P3hy6XPDMnPWCwtF1OZEi8k=;
  b=v42arRQNlMWnFgmVEqGuLaFzxXT0ArJeNFi0hxh15Gu3TwFQOV0DYPL6
   dq/SG0IV7gZnPM08Dx5n9UowbCJctIyzOiU2F+9i1E8yCWixZHpY4eZFp
   s/ugXyTp7ZI/h1tu0bcS7fswlKknSZSBZMykjtBSATeCijlWiORuYmtqZ
   c=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="19994641"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:35:43 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:8030]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.126:2525] with esmtp (Farcaster)
 id b1ad6a92-1159-4e63-bdbf-420d2a32b1e0; Tue, 20 Aug 2024 13:35:41 +0000 (UTC)
X-Farcaster-Flow-ID: b1ad6a92-1159-4e63-bdbf-420d2a32b1e0
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:35:41 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:35:37 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>, Paul Durrant
	<paul@xen.org>
Subject: [PATCH v3 1/6] KVM: Fix coalesced_mmio_has_room()
Date: Tue, 20 Aug 2024 14:33:28 +0100
Message-ID: <20240820133333.1724191-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820133333.1724191-1-ilstam@amazon.com>
References: <20240820133333.1724191-1-ilstam@amazon.com>
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
Reviewed-by: Paul Durrant <paul@xen.org>
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


