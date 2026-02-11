Return-Path: <kvm+bounces-70830-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id pXWQEKxEjGl+kQAAu9opvQ
	(envelope-from <kvm+bounces-70830-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:58:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 80913122770
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 38706300B45E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 08:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE253542F9;
	Wed, 11 Feb 2026 08:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iAHCPnIC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F1354AD4;
	Wed, 11 Feb 2026 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770800293; cv=none; b=tuL8u5n3GFNsk0AAUF0hsz9xt5FbaqQvQkLcnNFHkgA5021iyYxESac57m6HigU+JhTPKCGG3PcoRNIUAmq8jxSQUMklOX4Ze9gI2/JpvMMYOrDdagC9e0cd9Hj0w0y0XRxgwgOt2uCNHK4a1ErEUDQ4pQ2hnbwz+Q6fWqFvYIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770800293; c=relaxed/simple;
	bh=vbXWSR6dG3bltC8HdcCEJENHZTI+G290TKxZwcxoBA0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqNHTY6W9rn6qXQpU29oDkHJN+TY6p6x4bqBctHftsZX8MeRkxmf6om1oxY7h11cVtyMQhqL3VO617XOhPXUn7uNz7YDtJlXxGTIA3ySYUPgFkk0RDY5+guJZIImMMw9gLnXZC55ewyj9RYhKd3/2bXjqsMFZQqX1jlN0I5r54I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iAHCPnIC; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770800292; x=1802336292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vbXWSR6dG3bltC8HdcCEJENHZTI+G290TKxZwcxoBA0=;
  b=iAHCPnICkYtwr+nJLOPtmanc+/Xh8Y9ryMzd3u0lZhin6ksdB+eB6/0l
   LNwcp+VSDPUlQhfoSBqGxeMvHhXKn2S7uRHQt58vBHgwqyyiVmZMoi7wX
   X/FILeMrgBAxV5CrZ6DBHXAaSC2WB5hc6F3w7Y9R0LR1poEE8AaV/uEDw
   dfkaa1C5qsLW5F6fMG2389u8mYSCOuJ20NzUgrtc9k7wUGPkOxBduqkOD
   GeK5ofeq6WuWDfzrps0MVCjkoRW77D+YGqSo/HLLkBwIhj0y/41j/iZj1
   jxODOZXbLNPW6SoE6HD5vUmKBMVu33korjhGnk+3Dsi9/kDSR1qO8iI77
   A==;
X-CSE-ConnectionGUID: vkEeKak6TG64wrhZeJ6WsA==
X-CSE-MsgGUID: PzLFJHtTQxGt6Qoi5eHpxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71840758"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71840758"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 00:58:12 -0800
X-CSE-ConnectionGUID: YUOCP3GHShm6uCA9C/5U7A==
X-CSE-MsgGUID: fEHVFDleR8SjbN72lG6ulg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211592557"
Received: from ubuntu.bj.intel.com ([10.238.152.35])
  by fmviesa010.fm.intel.com with ESMTP; 11 Feb 2026 00:58:10 -0800
From: Jun Miao <jun.miao@intel.com>
To: kas@kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com
Cc: linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jun.miao@intel.com
Subject: [PATCH 1/1] virt: tdx-guest: Optimize the get-quote polling interval time
Date: Wed, 11 Feb 2026 16:58:01 +0800
Message-Id: <20260211085801.4036464-2-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20260211085801.4036464-1-jun.miao@intel.com>
References: <20260211085801.4036464-1-jun.miao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jun.miao@intel.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70830-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 80913122770
X-Rspamd-Action: no action

The TD guest sends TDREPORT to the TD Quoting Enclave via a vsock or
a tdvmcall. In general, vsock is indeed much faster than tdvmcall,
and Quote requests usually take a few millisecond to complete rather
than seconds based on actual measurements.

The following get quote time via tdvmcall were obtained on the GNR:

| msleep_interruptible(time)     | 1s       | 5ms      | 1ms        |
| ------------------------------ | -------- | -------- | ---------- |
| Duration                       | 1.004 s  | 1.005 s  | 1.036 s    |
| Total(Get Quote)               | 167      | 142      | 167        |
| Success:                       | 167      | 142      | 167        |
| Failure:                       | 0        | 0        | 0          |
| Avg total / 1s                 | 0.97     | 141.31   | 166.35     |
| Avg success / 1s               | 0.97     | 141.31   | 166.35     |
| Avg total / 1s / thread        | 0.97     | 141.31   | 166.35     |
| Avg success / 1s / thread      | 0.97     | 141.31   | 166.35     |
| Min elapsed_time               | 1025.95ms| 6.85 ms  | 2.99 ms    |
| Max elapsed_time               | 1025.95ms| 10.93 ms | 10.76 ms   |

According to trace analysis, the typical execution tdvmcall get the
quote time is 4 ms. Therefore, 5 ms is a reasonable balance between
performance efficiency and CPU overhead.

And compared to the previous throughput of one request per second,
the current 5ms can get 142 requests per second delivers a
142× performance improvement, which is critical for high-frequency
use cases without vsock.

So, change the 1s (MSEC_PER_SEC) -> 5ms (MSEC_PER_SEC / 200)

Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 drivers/virt/coco/tdx-guest/tdx-guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/tdx-guest.c
index 4e239ec960c9..71d2d7304b1a 100644
--- a/drivers/virt/coco/tdx-guest/tdx-guest.c
+++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
@@ -251,11 +251,11 @@ static int wait_for_quote_completion(struct tdx_quote_buf *quote_buf, u32 timeou
 	int i = 0;
 
 	/*
-	 * Quote requests usually take a few seconds to complete, so waking up
-	 * once per second to recheck the status is fine for this use case.
+	 * Quote requests usually take a few milliseconds to complete, so waking up
+	 * once per 5 milliseconds to recheck the status is fine for this use case.
 	 */
-	while (quote_buf->status == GET_QUOTE_IN_FLIGHT && i++ < timeout) {
-		if (msleep_interruptible(MSEC_PER_SEC))
+	while (quote_buf->status == GET_QUOTE_IN_FLIGHT && i++ < 200 * timeout) {
+		if (msleep_interruptible(MSEC_PER_SEC / 200))
 			return -EINTR;
 	}
 
-- 
2.32.0


