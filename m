Return-Path: <kvm+bounces-73294-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sK50Ex7NrmnEIwIAu9opvQ
	(envelope-from <kvm+bounces-73294-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:37:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA5E239D91
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0CD3E3025E71
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187D5393DD2;
	Mon,  9 Mar 2026 13:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dSXMd5y6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C69D35958
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 13:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063444; cv=none; b=EvRHt+s9Iti/9RWBxmmtBbp++yDnBNKpYLYiB11hW+NhskXHj6XxPaJ4aTuVEclfLhf+mR74Ek+gNEU4yJGMHI1HLetj/uPPsXA2Nay1hF+2BsN2PfmyP8nLjmXnYhCrYOczilqIPf+3pn8zxHaUCWJAh4K0+n2TdN6s9ZcT0x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063444; c=relaxed/simple;
	bh=4mWCyx1Te9ugLEsZU9ic00xrG8f/5qA2VFmRrRi9YPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qM+RIOBVc8s4LvF2sfOJLax+jgK50dVDwZB5eC3kjzV8zyUyw1nJ9a+TnkeShNXHbiu0Yj0Rw8daoA+amefdz6WySX4nvkJDwezCDn2yUN9cUWzd3VCVVkRkIcgHhkpX4M+J5nYjzLIc8UqBcCVm9jVuum0xw2f6iNCDKOLxFEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dSXMd5y6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773063440; x=1804599440;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=4mWCyx1Te9ugLEsZU9ic00xrG8f/5qA2VFmRrRi9YPs=;
  b=dSXMd5y6KJ4yW4DPEMEY6PsoMrF9ff2nPNBxo28ipQAqs+udDqPiNb2g
   YSBjKjLQG21xsiuiSvaLiVnyBPbZVXgO/8OF94KH/kf8odH8omHopnmZy
   3iCocmzzOQgFRskELvzFd+2cCrL5fqx7hhdrMnPBiWhkA+Lsa1w6iEZot
   9/CxA+H4U+ephdoy2BDEhfyscz0TdN8uNx1dUoPxuZmrKuqwkVNB31Ybg
   eoZesmRdc1iY+b29i6I4uyaM/jA/cbp15S43uMDjVW1xf/wSpkHgT+lgp
   FsvzH7OLgdHN5riVc2ySY056i6MuqantCfWHmPc5BFwLRfZm5kbdOd/0h
   A==;
X-CSE-ConnectionGUID: Xi6OVm72SoWJU6fcpJXcwQ==
X-CSE-MsgGUID: PrhvWGByRXik0PuwRwskRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="73108724"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="73108724"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 06:37:19 -0700
X-CSE-ConnectionGUID: hC0GY+T1Toqai1gyjXyYWQ==
X-CSE-MsgGUID: NuXr/z8SQzC8gv/wAiCMhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="224203764"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 09 Mar 2026 06:37:18 -0700
Date: Mon, 9 Mar 2026 22:03:28 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 3/4] target/i386/kvm: Remove
 X86CPU::hyperv_synic_kvm_only field
Message-ID: <aa7TMGlD57JYsMLi@intel.com>
References: <20260307150042.78030-1-philmd@linaro.org>
 <20260307150042.78030-4-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260307150042.78030-4-philmd@linaro.org>
X-Rspamd-Queue-Id: 1EA5E239D91
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
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73294-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhao1.liu@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.953];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linaro.org:email]
X-Rspamd-Action: no action

On Sat, Mar 07, 2026 at 04:00:41PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Sat,  7 Mar 2026 16:00:41 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH 3/4] target/i386/kvm: Remove X86CPU::hyperv_synic_kvm_only
>  field
> X-Mailer: git-send-email 2.52.0
> 
> The X86CPU::hyperv_synic_kvm_only boolean (see commit 9b4cf107b09
> "hyperv: only add SynIC in compatible configurations") was only set
> in the pc_compat_3_0[] array, via the 'x-hv-synic-kvm-only=on'
> property. We removed all machines using that array, lets remove that
> property and all the code around it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/cpu.h     |  1 -
>  target/i386/cpu.c     |  2 --
>  target/i386/kvm/kvm.c | 15 ++++-----------
>  3 files changed, 4 insertions(+), 14 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>


