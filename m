Return-Path: <kvm+bounces-71419-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKlgCs2rmGkuKwMAu9opvQ
	(envelope-from <kvm+bounces-71419-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:45:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97B0716A2A9
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 68FC430292CE
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7A29366DA5;
	Fri, 20 Feb 2026 18:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ji6AtaDg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5C0366061;
	Fri, 20 Feb 2026 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771613117; cv=none; b=bWdFZf0yscb49Ne2zTcT9nDAvEuxNa23XyC3jpSgRYElPBMg8YsNItsFe96LjbEjuel+WceHaFZs6oALF00nHmhI8eYF1l+VCtHb4hqDb+sM0dB6OepY1QtPQI4l2qDdGYRWV/xNATfF1kFa0p6aIySX4qI05ixzW1ANWcwgrDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771613117; c=relaxed/simple;
	bh=QQGm/efUewdd0uPaGsutyunhLIVLi9ZwuiNqcgKVR7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cJIMTCUL5GoffxqITSDFRxNePpmneHoPqPabHl/EoXSreUBLJWHwvwX2LvcYjxveQtM/Ejg7kjnAYu6umFs02OjYHvFzQeUw//5R8Hv5q5VO6PKaI1xlAariEyrGVZr08Xxj8AvJFBZTYi15K6EaY2QLDj5n6Sq/2NmotLA7J0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ji6AtaDg; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771613116; x=1803149116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QQGm/efUewdd0uPaGsutyunhLIVLi9ZwuiNqcgKVR7g=;
  b=ji6AtaDgBy7//bPFIQ3k5Ru5trZzysQJ189NFT9KFpSrtUo6rXUaYfRE
   wBUhVSjKE/Ov71D1Xd3i6eGdJIsGW63CeuR6NNqFd8AKkOQ+ekX9ArBa5
   1onlQ+ug/NmxSniGyHltaV1qcHyprIwT9KI1E/NshUBT3AI1JH0gmJbKo
   lZvs7QbZ/UbXUymzpZOKT/5OufrV2nSrG3UaPI3cHRXUeKeYumi1QDmJo
   XODOK+y0gpK3vP4+1LvnhHA2S+IU2iAdzFx7+2Z0Mlcc2Kqy79/rtWSRF
   EB0dVhlAgRr7xNKfBsbKGH7vlNBAMxNj3k3s9xwER/slFo5DXX0zWDyRE
   w==;
X-CSE-ConnectionGUID: bcH06EJNRkimndffcnujSw==
X-CSE-MsgGUID: O/XjAarVRz2SYUARin15IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11707"; a="84070846"
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="84070846"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 10:45:15 -0800
X-CSE-ConnectionGUID: T3bLLtQ5QC+LL9aBphtnew==
X-CSE-MsgGUID: KODdNr/SSPmw0R9tzPcyHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="212666612"
Received: from soc-pf446t5c.clients.intel.com (HELO [10.24.81.126]) ([10.24.81.126])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 10:45:15 -0800
Message-ID: <1cc137df-0940-4eb4-b7c3-2e5e8948d9f5@linux.intel.com>
Date: Fri, 20 Feb 2026 10:45:14 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] virt: tdx-guest: Optimize the get-quote polling
 interval time
To: Jun Miao <jun.miao@intel.com>, kas@kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260211085801.4036464-1-jun.miao@intel.com>
 <20260211085801.4036464-2-jun.miao@intel.com>
Content-Language: en-US
From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <20260211085801.4036464-2-jun.miao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71419-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sathyanarayanan.kuppuswamy@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.intel.com:mid,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 97B0716A2A9
X-Rspamd-Action: no action

Hi Miao,

On 2/11/2026 12:58 AM, Jun Miao wrote:
> The TD guest sends TDREPORT to the TD Quoting Enclave via a vsock or
> a tdvmcall. In general, vsock is indeed much faster than tdvmcall,
> and Quote requests usually take a few millisecond to complete rather
> than seconds based on actual measurements.
> 
> The following get quote time via tdvmcall were obtained on the GNR:
> 
> | msleep_interruptible(time)     | 1s       | 5ms      | 1ms        |
> | ------------------------------ | -------- | -------- | ---------- |
> | Duration                       | 1.004 s  | 1.005 s  | 1.036 s    |
> | Total(Get Quote)               | 167      | 142      | 167        |
> | Success:                       | 167      | 142      | 167        |
> | Failure:                       | 0        | 0        | 0          |
> | Avg total / 1s                 | 0.97     | 141.31   | 166.35     |
> | Avg success / 1s               | 0.97     | 141.31   | 166.35     |
> | Avg total / 1s / thread        | 0.97     | 141.31   | 166.35     |
> | Avg success / 1s / thread      | 0.97     | 141.31   | 166.35     |
> | Min elapsed_time               | 1025.95ms| 6.85 ms  | 2.99 ms    |
> | Max elapsed_time               | 1025.95ms| 10.93 ms | 10.76 ms   |
> 

Thanks for sharing the data!

> According to trace analysis, the typical execution tdvmcall get the
> quote time is 4 ms. Therefore, 5 ms is a reasonable balance between
> performance efficiency and CPU overhead.

Since the average is 4 ms, why choose 5ms?

> 
> And compared to the previous throughput of one request per second,
> the current 5ms can get 142 requests per second delivers a
> 142× performance improvement, which is critical for high-frequency
> use cases without vsock.

Is this addressing a real customer issue or a theoretical improvement? 
If this is solving a real problem, could you share more details about
the use case and Quoting Service implementation you're testing against?

I ask because the Quote completion time depends heavily on the Quoting
Service implementation, which varies by deployment. Since we're optimizing
for performance, I'm wondering if we should consider an interrupt-based
approach using the SetupEventNotifyInterrupt TDVMCALL instead of polling.

> 
> So, change the 1s (MSEC_PER_SEC) -> 5ms (MSEC_PER_SEC / 200)
> 
> Signed-off-by: Jun Miao <jun.miao@intel.com>
> ---
>  drivers/virt/coco/tdx-guest/tdx-guest.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/virt/coco/tdx-guest/tdx-guest.c b/drivers/virt/coco/tdx-guest/tdx-guest.c
> index 4e239ec960c9..71d2d7304b1a 100644
> --- a/drivers/virt/coco/tdx-guest/tdx-guest.c
> +++ b/drivers/virt/coco/tdx-guest/tdx-guest.c
> @@ -251,11 +251,11 @@ static int wait_for_quote_completion(struct tdx_quote_buf *quote_buf, u32 timeou
>  	int i = 0;
>  
>  	/*
> -	 * Quote requests usually take a few seconds to complete, so waking up
> -	 * once per second to recheck the status is fine for this use case.
> +	 * Quote requests usually take a few milliseconds to complete, so waking up
> +	 * once per 5 milliseconds to recheck the status is fine for this use case.
>  	 */
> -	while (quote_buf->status == GET_QUOTE_IN_FLIGHT && i++ < timeout) {
> -		if (msleep_interruptible(MSEC_PER_SEC))
> +	while (quote_buf->status == GET_QUOTE_IN_FLIGHT && i++ < 200 * timeout) {
> +		if (msleep_interruptible(MSEC_PER_SEC / 200))
>  			return -EINTR;
>  	}
>  

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer


