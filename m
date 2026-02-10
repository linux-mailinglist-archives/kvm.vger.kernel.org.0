Return-Path: <kvm+bounces-70707-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wCudAyLYimnrOAAAu9opvQ
	(envelope-from <kvm+bounces-70707-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:02:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A361179A9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 08:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 26F51302F7D6
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 07:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BAF2E6CA8;
	Tue, 10 Feb 2026 07:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jEsnk7cW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A417BB21
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 07:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770706974; cv=none; b=h/kD4IlDy2m97d14W8OYRFep0WtGIMAZJOcp/pMuG0U6D98G4nCEvc28T0fDZXBE8mYLfVqLYPq0EDiYhKlx+M5KuvD8smtw0ZP00/eBUKUvL11ZY6vxKt/Z/pAE/SrvR0L8XJXLGLX3YgggYwu+A2h6CV1EUg3WZa99GTDrW0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770706974; c=relaxed/simple;
	bh=7yD8/EM5IxH+Bdj4cjFGOQKe6NgtEHQJ7XLVrHwBR2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUZd0B4xcGecDSvvp65Db76tn2V7vEICC/fg15K1bNEo5AxRPQYwuatLUCQoTHOiUQ06rjBD3FtpHbSnPb2+XTJLQc4msmUdg1B2RHozLUAz2khi7of+Oe15243eg4tR7j7ZOnDlAdPL6jfs2ZOI7nwb0C0g3X0s1PNqF0xiuMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jEsnk7cW; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770706973; x=1802242973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7yD8/EM5IxH+Bdj4cjFGOQKe6NgtEHQJ7XLVrHwBR2o=;
  b=jEsnk7cW3xrr67b+SZjDJEkvZXJfK/j1wgl77BY1C+iRAqdNMMq9afHS
   DXYdBbn0cCmybHx0sr53IFdGiQkfNXbZ9myBUseCnIWgRbfVpYt5kEeV6
   zg7Twpx+DTAwau+7Z62z85RTrDlEKmIlVCuQmt24Mz2cW7+k3J8mtfFz4
   uRuzWWuMtfPReH496M+UH88jw34gUy+SwA9IYSwowXQWEBxk34+gnG5eU
   cbfYay2hyFtqjyoWwz/2BsKiRrQzho5fF7zo9DqhucoHT4xyIC/z4WfiP
   TZ1UtN/K5ldN9SnuiQzMfOlef/FDCbplTCteihsJibtpVGozU2EW51iwT
   w==;
X-CSE-ConnectionGUID: w6fn4c9UQFCh4uid8MKkBg==
X-CSE-MsgGUID: aMYCHXDYTWShhj3/hi+gRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83199338"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="83199338"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:02:52 -0800
X-CSE-ConnectionGUID: sAPpXRqLQky9YaL3s5hiiQ==
X-CSE-MsgGUID: qdw0VuQwTE+LijKhAV91sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211366527"
Received: from qianm-mobl2.ccr.corp.intel.com (HELO [10.238.1.184]) ([10.238.1.184])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:02:50 -0800
Message-ID: <5e0b0f99-2692-4316-85bc-6d83e83e353d@linux.intel.com>
Date: Tue, 10 Feb 2026 15:02:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 07/11] target/i386: Make some PEBS features
 user-visible
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260128231003.268981-1-zide.chen@intel.com>
 <20260128231003.268981-8-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260128231003.268981-8-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.intel.com:mid,intel.com:email,intel.com:dkim];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70707-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 76A361179A9
X-Rspamd-Action: no action


On 1/29/2026 7:09 AM, Zide Chen wrote:
> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
> the corresponding bits user-visible CPU feature knobs, allowing them to
> be explicitly enabled or disabled via -cpu +/-<feature>.
>
> Once named, these bits become part of the guest CPU configuration
> contract.  If a VM is configured with such a feature enabled, migration
> to a destination that does not support the feature may fail, as the
> destination cannot honor the guest-visible CPU model.
>
> The PEBS_FMT bits are not exposed, as target/i386 currently does not
> support multi-bit CPU properties.
>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
> V2:
> - Add the missing comma after "pebs-arch-reg".
> - Simplify the PEBS_FMT description in the commit message.
>
>  target/i386/cpu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index d3e9d3c40b0a..f2c83b4f259c 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1618,10 +1618,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .type = MSR_FEATURE_WORD,
>          .feat_names = {
>              NULL, NULL, NULL, NULL,
> +            NULL, NULL, "pebs-trap", "pebs-arch-reg",
>              NULL, NULL, NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> -            NULL, "full-width-write", NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> +            NULL, "full-width-write", "pebs-baseline", NULL,
> +            NULL, "pebs-timing-info", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



