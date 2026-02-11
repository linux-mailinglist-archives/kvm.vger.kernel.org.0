Return-Path: <kvm+bounces-70829-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPxrCaZEjGlxkQAAu9opvQ
	(envelope-from <kvm+bounces-70829-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:58:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFDE122768
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 09:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0982F3011A5F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 08:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FC0309F1D;
	Wed, 11 Feb 2026 08:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="maHr2SOJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9517C342539;
	Wed, 11 Feb 2026 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770800289; cv=none; b=hxpQehtKRwIWkZzTGaAQwBFbCnFkmBM/yCCf3+te2KxzAsLSAAK2Zl/o5gycTKD6E/DAOYEekrMBSNTEBnPjMRxJayTctvB2FmbFkJJQ8+X/dQ1cA3rVeeBaeSbiLmU8wkFMctcjJQ+apVAgwE/s40NUa2mUoGneiz+c9BhcGc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770800289; c=relaxed/simple;
	bh=1P8/Aj+KLSO2UwFUQGGb75QRc86jiUTlgfFmsVS2V4c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sm2pTsVUX90KzEnA91N4mVADEEsDeGdwRWcyS6FraZSkj5sD2/rP//EVkqAI6wLfqwcaMwW45kqMmN9TGlBoLEMWDOyMwNr138adJPI8NqlI+4vgX0I47+2ZM1VtyUI17n6urD/gp9zaafWkfPkqgyh3o4sMRVnnq12z2MU2TGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=maHr2SOJ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770800289; x=1802336289;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1P8/Aj+KLSO2UwFUQGGb75QRc86jiUTlgfFmsVS2V4c=;
  b=maHr2SOJf4+xaDAzu5/CEqXb/s6HzohjqLK2qJF030xkd5e0i/yc94Wj
   EckqjeAfEf+7xOp5eJirpfjoNfoALDt5XXkq1ISMuURmfYgrYnsvoRnXV
   MczjNR79q/2mz31/gM3uDHp/dMR+k1V0ZMfUuDy1P6c/WwnWu130vyaVK
   u0LgZYLbPwfsY9xTiqgyyIJzWsIl5c42DJsEUoga/1O9rAVLP/GWCdTBa
   61AgU+Zz3buTpW0xQ+RVAc/6VRZ4r6eyXm4Tw/BNkjXn49y88zFlpv95K
   Fuo7sbMdJlH0suACSRKLiH5y6DlJDMK6giuI0LOrt2vcHyv0vx8a8x/9H
   Q==;
X-CSE-ConnectionGUID: ONdLbLCeQbSlto6eDJBgKw==
X-CSE-MsgGUID: 6bruQEpzTsO8P8VwsFRePA==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="71840756"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71840756"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 00:58:08 -0800
X-CSE-ConnectionGUID: yT9/sHxaQ82znlwh32vVoA==
X-CSE-MsgGUID: JYEhrPw2QWeTSkhMWkepZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211592551"
Received: from ubuntu.bj.intel.com ([10.238.152.35])
  by fmviesa010.fm.intel.com with ESMTP; 11 Feb 2026 00:58:06 -0800
From: Jun Miao <jun.miao@intel.com>
To: kas@kernel.org,
	dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com
Cc: linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jun.miao@intel.com
Subject: [PATCH 0/1] [Test Report] get qutoe time via tdvmcall
Date: Wed, 11 Feb 2026 16:58:00 +0800
Message-Id: <20260211085801.4036464-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jun.miao@intel.com,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-70829-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,inteltdx:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 8CFDE122768
X-Rspamd-Action: no action

[Background]
Currently, many mobile device vendors (such as OPPO and Xiaomi) use TDVM for security management.
Each mobile terminal must perform remote attestation before it can access the TDVM confidential container.
As a result, there are a large number of remote attestation get-quote requests, especially in cases 
where vsock is not configured or misconfigured and cannot be used.

[Limitation]
Currently, the polling interval is set to 1 second, which allows at most one quote to be retrieved per second.
For workloads with frequent remote attestations, polling once per second severely limits performance.
Test like this:
[root@INTELTDX ~]# ./test_tdx_attest-thread
Start tdx_att_get_quote concurrent loop, duration: 1 s, threads: 1
Summary (tdx_att_get_quote)
Threads: 1
Mode: concurrent
Duration: requested 1 s, actual 1.036 s
Total:   1
Success: 1
Failure: 0
Avg total per 1s:   0.97
Avg success per 1s: 0.97
Avg total per 1s per thread:   0.97
Avg success per 1s per thread: 0.97
Min elapsed_time: 1025.95 ms
Max elapsed_time: 1025.95 ms

[Optimization Rationale]
But the actual trace the get quote time on GNR platform:
test_tdx_attest-598     [001] .....   371.214611: tdx_report_new: [debug start wait]===: I am in function wait_for_quote_completion    LINE=155===
test_tdx_attest-598     [001] .....   371.220287: tdx_report_new: [debug end wait]===: I am in function wait_for_quote_completion    LINE=162===

Cost time: 371.220287 - 371.215611 = 0.004676 = 4.6ms

The following test results were obtained on the GNR platform:
| msleep_interruptible(time)     | 1ms      | 5ms      | 1s         |
| ------------------------------ | -------- | -------- | ---------- |
| Duration                       | 1.004 s  | 1.005 s  | 1.036 s    |
| Total(Get Quote)               | 167      | 142      | 1          |
| Success:                       | 167      | 142      | 1          |
| Failure:                       | 0        | 0        | 0          |
| Avg total / 1s                 | 166.35   | 141.31   | 0.97       |
| Avg success / 1s               | 166.35   | 141.31   | 0.97       |
| Avg total / 1s / thread        | 166.35   | 141.31   | 0.97       |
| Avg success / 1s / thread      | 166.35   | 141.31   | 0.97       |
| Min elapsed_time               | 2.99 ms  | 6.85 ms  | 1025.95 ms |
| Max elapsed_time               | 10.76 ms | 10.93 ms | 1025.95 ms |



Jun Miao (1):
  virt: tdx-guest: Optimize the get-quote polling interval time

 drivers/virt/coco/tdx-guest/tdx-guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.32.0


