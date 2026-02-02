Return-Path: <kvm+bounces-69787-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6D5jG0vxf2nH0gIAu9opvQ
	(envelope-from <kvm+bounces-69787-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 01:35:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17894C7A2C
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 01:35:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 053B73008743
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 00:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D09A1A9F90;
	Mon,  2 Feb 2026 00:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOur2aA0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9B03EBF3E;
	Mon,  2 Feb 2026 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769992504; cv=none; b=m+7xvq75t5VyqZKWHJgCk+30Stv2/pi1WqCMfQO8QnKHKDbPFhCjHOx1ihaza+1fS2mj9jB67xf3/OZT83GuHwPpmWC+sjzjv7/tV2nw5Rq2vn2W1kbynwtwLujZg2t7+ZuCZHrII5ky/56MB7BrKQV+PDF5yOEBCt1Oxfd4+os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769992504; c=relaxed/simple;
	bh=wz9rV3CF1KEWpwqa7d/fNw+x+D64kdndnPRdh55Qvcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ITFfpQBzWmxGht8dMW1a5uSxMlZs+TuHK2r6fxpzqgrAKlMB3UQ0G6HmBaoxESbukEV3TUthfCUKaNMnuuVJt2rJgCQOs+QuFLR7vedCbH6+2UvUXCTpI3ESs4+oZ0mHaCWw92CzL6wKi/oCDerDZcVuGqMI1uE1dsUvUxvBS+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOur2aA0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769992503; x=1801528503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wz9rV3CF1KEWpwqa7d/fNw+x+D64kdndnPRdh55Qvcw=;
  b=gOur2aA0uJPU8duraRQj0m7Sx0d0nkLR06Pi6K0u9bpPwoJf7lqR3MiY
   qXlfOJoyqsDTdYMLP9bimR72sNiZOT6V47vyjaue5O6IeT0OkhAtoCuf/
   OMKBjoLi7uMJv8UUL57KXtDWURvNk86lAUYS9LAYYhiE0tTIvjL5stcs+
   rCV9ukXJkvFKv1EUTg2JzPjSggj0YvhF8isT8EHaXiWIMeMZdSgO3aNve
   JvW8da1Rc0PNSgZO6yPUvs7r8Mdc12tRR33O2W31H7FfTql5mt2cmIk/2
   yTtOaC4OO3osFxerB4HtznrSNuTfEfr22e/ywGgUpgb+G/4b1/GZqrVJk
   A==;
X-CSE-ConnectionGUID: q9vTdjXnStaH37aiPkzADA==
X-CSE-MsgGUID: GX8sp4FPRHSkid7iWgdlhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="81782126"
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="81782126"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 16:35:02 -0800
X-CSE-ConnectionGUID: W1ON+5smRCOHVEuVTXZY3Q==
X-CSE-MsgGUID: sZ/PK8PpSMGVpXxA63IW1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,267,1763452800"; 
   d="scan'208";a="209680260"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa010.fm.intel.com with ESMTP; 01 Feb 2026 16:34:57 -0800
Date: Mon, 2 Feb 2026 08:16:33 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com,
	dan.j.williams@intel.com, sagis@google.com, vannapurve@google.com,
	paulmck@kernel.org, nik.borisov@suse.com, zhenzhong.duan@intel.com,
	seanjc@google.com, rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aX/s4XV9+uupmocL@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
 <b2e2fd5e-8aff-4eda-a648-9ae9f8234d25@intel.com>
 <aXwtILdwb/KMX9uH@yilunxu-OptiPlex-7050>
 <1b1a2fe7-d225-414c-9055-8ad06938a0bf@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1a2fe7-d225-414c-9055-8ad06938a0bf@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69787-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:dkim]
X-Rspamd-Queue-Id: 17894C7A2C
X-Rspamd-Action: no action

> If nothing else, __packed is a good indicator that WYSIWYG for structure
> layout because it's an ABI. I honestly don't see a lot of downsides.

OK. So on x86 I can use it without worry. Thanks.

