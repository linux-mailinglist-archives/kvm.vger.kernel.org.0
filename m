Return-Path: <kvm+bounces-21867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DC093522F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33A0B1F22576
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 19:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9E81459FD;
	Thu, 18 Jul 2024 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="h2QI/R08"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5583813AA26
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 19:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.21.196.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721331434; cv=none; b=ctdPmU7E72ygBrt79q4lciXz2qlzjfvD39e+IWufzICMwosw8hUr3olLyW93nXnR1TnnJB6gqbscaGwNeTHmxhjD96Fb3H7NNUPuB24ObCa31tLJyJ6b0WUWgUuERq0tcpKQ7tmK5MdCq4SWsfFJ/DxJmPZqmBP98ioS3uZs8pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721331434; c=relaxed/simple;
	bh=H7k+6nAtfPAjMYGkXJcBgLA3LEHTFAquwe3upQ2dfFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MiU68PsA3A7HdMwHgxWJnsmbafvA9ksGOHpnkC5BwYww1l4eLMusHBX0EchNXjAFmGN/QXWWlj1mNhI93k7YqpO4RZplnBVfu6EkhZAnFjZGS1EHPgr3eYpBSMEZMB4Me6MiaD5KQqvueYWtcCLj60NkYXJcWJml4lYBcn0fJXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=h2QI/R08; arc=none smtp.client-ip=72.21.196.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1721331433; x=1752867433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OuOmf53f5AL3V3xjIto3P3hy6XPDMnPWCwtF1OZEi8k=;
  b=h2QI/R08ftyXP75XN8JyjcHICRuoIiVHyq9Cqu4Rtr5GA+u4KXKbW5bq
   hvq8FtSYqQcJzoW5pmf3LCgCuvAllthx2brr07yyh3xm4xBsgw/wcsQMY
   X62ioYTM9D1izUN38M5PB6Fzr2sDeChLJ9068kFCGwfXzsdotJIVZ03l2
   Y=;
X-IronPort-AV: E=Sophos;i="6.09,218,1716249600"; 
   d="scan'208";a="415723094"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 19:37:10 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:52140]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.109:2525] with esmtp (Farcaster)
 id d3b33e29-21c8-48f9-8f15-2565880861f0; Thu, 18 Jul 2024 19:37:07 +0000 (UTC)
X-Farcaster-Flow-ID: d3b33e29-21c8-48f9-8f15-2565880861f0
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:37:07 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.17) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Thu, 18 Jul 2024 19:37:03 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <nh-open-source@amazon.com>,
	Ilias Stamatis <ilstam@amazon.com>, Paul Durrant <paul@xen.org>
Subject: [PATCH v2 1/6] KVM: Fix coalesced_mmio_has_room()
Date: Thu, 18 Jul 2024 20:35:38 +0100
Message-ID: <20240718193543.624039-2-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718193543.624039-1-ilstam@amazon.com>
References: <20240718193543.624039-1-ilstam@amazon.com>
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


