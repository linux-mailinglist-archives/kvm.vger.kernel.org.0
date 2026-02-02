Return-Path: <kvm+bounces-69801-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BveEpdSgGla6QIAu9opvQ
	(envelope-from <kvm+bounces-69801-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:30:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 745CFC928C
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E95FB300E150
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 07:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B392882C5;
	Mon,  2 Feb 2026 07:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7wSDfi2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71A51339A4;
	Mon,  2 Feb 2026 07:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017425; cv=none; b=OMum1ylIxpQYBfU2/WXPct5kQI7Y+nbI/X6/XE17AOMfEwy14cSKdw3zl69Dv9JV+6T/OkNQdT5uTgygMm0ZdIME2Ij65F3Drwpyf1qztuyKLiXmDfHJBsbTPreJWKrc3H1eNWx2IrqTTPpIGFaFqzdDLyQS6giouFL+/1qTsqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017425; c=relaxed/simple;
	bh=7BCjcgwThACpqKINVEDrGd72svHvdvaoqjhRgec9HSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IrLtXVL8fDTKIX5G7Mr/mMdvJJwQzMBlnNMPobuygaBBwcIvypMoPyHo2k6i0mMR28X+eCkGrUTQ6bDxBdhOsJgX0uOPO8VOVsaLK5KtOo6xY9AXRlMTg6SxGIW7kQ1+PZ1VelFazjKk7Hv4V6BSXcIKRyQM5N++q4kgefR03P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7wSDfi2; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770017424; x=1801553424;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7BCjcgwThACpqKINVEDrGd72svHvdvaoqjhRgec9HSQ=;
  b=P7wSDfi2py80Sa64Rt6oYYXGJAYYoHOdmlbii5Byjkf31xt7NcACG3zW
   A75KiY5vV0Il+yBRc5prO24R5BoQ0yfe3pjvR2V2EcyJ8GfHL23MJR/dc
   LKYiu4UIk5FxXzni2yxF/wrr7Ww81YBdMFDI18OiqDXQ2yKrYqJIslDfT
   VsR34xMtdZSf5s28C3VbaPrp0ve16kWpP9ZSglxEiV0R/ANXdWgZzxPlp
   Cie8nzvI/ksBDWp5FtoShP+BWYS/mwB4jpVXpAKtmxLimaO+fU5Zq0PR+
   Oi613fNuRK5OKF8Z3kLC44VBm+HcAbJcN9j9110djxJA7iRFYGTt+abK8
   g==;
X-CSE-ConnectionGUID: pPAPGeJRScu9n89Mzq/ZjA==
X-CSE-MsgGUID: TWLfYm85Ts6mEBrr5XGQ6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11689"; a="70188882"
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="70188882"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2026 23:30:23 -0800
X-CSE-ConnectionGUID: Uw5Z8H+rSOmQG1IMkRDQ4w==
X-CSE-MsgGUID: dAuO3KFYSnadE7L3YUfpwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,268,1763452800"; 
   d="scan'208";a="209624610"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmviesa008.fm.intel.com with ESMTP; 01 Feb 2026 23:30:17 -0800
Date: Mon, 2 Feb 2026 15:11:53 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, x86@kernel.org, reinette.chatre@intel.com,
	ira.weiny@intel.com, kai.huang@intel.com, dan.j.williams@intel.com,
	sagis@google.com, vannapurve@google.com, paulmck@kernel.org,
	nik.borisov@suse.com, zhenzhong.duan@intel.com, seanjc@google.com,
	rick.p.edgecombe@intel.com, kas@kernel.org,
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 18/26] x86/virt/seamldr: Log TDX Module update failures
Message-ID: <aYBOOS1VfirL07RZ@yilunxu-OptiPlex-7050>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-19-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123145645.90444-19-chao.gao@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69801-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yilun.xu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 745CFC928C
X-Rspamd-Action: no action

> +static void print_update_failure_message(void)
> +{
> +	static atomic_t printed = ATOMIC_INIT(0);
> +
> +	if (atomic_inc_return(&printed) == 1)
> +		pr_err("update failed, SEAMCALLs will report failure until TDs killed\n");
> +}

Not sure why it can't be just pr_err_once()?

> +
>  /*
>   * See multi_cpu_stop() from where this multi-cpu state-machine was
>   * adopted, and the rationale for touch_nmi_watchdog()
> @@ -289,10 +297,13 @@ static int do_seamldr_install_module(void *params)
>  				break;
>  			}
>  
> -			if (ret)
> +			if (ret) {
>  				atomic_inc(&tdp_data.failed);
> -			else
> +				if (curstate > TDP_SHUTDOWN)
> +					print_update_failure_message();
> +			} else {
>  				ack_state();
> +			}
>  		} else {
>  			touch_nmi_watchdog();
>  			rcu_momentary_eqs();
> -- 
> 2.47.3
> 

