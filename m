Return-Path: <kvm+bounces-31676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4229C63B2
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:44:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1BAE285905
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD70421A4D8;
	Tue, 12 Nov 2024 21:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJIz7DUy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F743AA1;
	Tue, 12 Nov 2024 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731447855; cv=none; b=BcJMk4PE+6XYbXYnKylR3+aP4jdJpeDsCVgVu+/6IXhHA/vCd5LOCNVLxdsk3YW7juaRK3brc6qAfK/Hae6g1BGjGt+YVV3Z3NZeUhCvMzz6+1HR+g2BdMlQRy6upfYe1i7AJbmClMyizf1bh5Q7DPgH80ZBSCIWwdbAu2S9cNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731447855; c=relaxed/simple;
	bh=A7B3sLUFPVOwvWzKLuaKlJTuWFPFoeCThHlOCtBbVZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgRVLYPxbd/I7IZgi4Ss3YfLQA+6R77g5PzXRjrD3Oc6buPhEkO1US6YMyXp7/TuffYVEN0zgsMI6fk9TL2yuiJPybMrQbU0q5xetw8QDR8F1DMAPp6yxR51OyjRevSUeyBXRLg2mgdgpmZv5otk6Fk9DpSbCTYVV7GbmBRzGlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJIz7DUy; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731447853; x=1762983853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A7B3sLUFPVOwvWzKLuaKlJTuWFPFoeCThHlOCtBbVZA=;
  b=aJIz7DUyhBSoDMvy5kHDghklgOeI2gUoVqw2hTDZCK+GtiNagmG//pZ3
   Eg2T17ijmkNElZM0Tt5aCZqgs7O4e+qmTZDM+KsASYw/KSJXwPWCjWyUO
   u22qP6qk+s2nND5xM2auOqO6ak/N3Xb5MKPQfpJWIybiEtFiBhzS4MFuH
   qKvSvJiwXAEHqkBy3vfHiYafoBi4y6uk5XheEOZW96txnB1T7SdXOhQqr
   w6v+7s+TdDSt3kcpaLlfXKdDqEv8k/tDhzw9+nBIb/53xH01rrfdBwqyI
   2jczHXwzZKsC+8TDYn/zvqQvLv6EEvCVwu4Sx2K9awzO77JfBZ7jTlqR0
   Q==;
X-CSE-ConnectionGUID: NtvsC4c5TgmH+oIG0BkA2A==
X-CSE-MsgGUID: H4mJydZHQ9G+Kn6Bp8iXfA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41873427"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41873427"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 13:44:12 -0800
X-CSE-ConnectionGUID: Ra3NatL0QYa+hh7ULACDQQ==
X-CSE-MsgGUID: GoTOa4UxTGyaPCzOwuZJCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92587877"
Received: from ahpasha-mobl4.amr.corp.intel.com (HELO desk) ([10.125.147.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 13:44:11 -0800
Date: Tue, 12 Nov 2024 13:43:48 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241112214241.fzqq6sqszqd454ei@desk>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112014644.3p2a6te3sbh5x55c@jpoimboe>

On Mon, Nov 11, 2024 at 05:46:44PM -0800, Josh Poimboeuf wrote:
> +	 * 1) RSB underflow ("Intel Retbleed")
>  	 *
>  	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
>  	 *    speculated return targets may come from the branch predictor,
>  	 *    which could have a user-poisoned BTB or BHB entry.
>  	 *
> -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> -	 *    regardless of the state of the RSB.
> +	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack is
> +	 *    mitigated by the IBRS branch prediction isolation properties, so
> +	 *    the RSB buffer filling wouldn't be necessary to protect against
> +	 *    this type of attack.
>  	 *
> -	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
> -	 *    scenario is mitigated by the IBRS branch prediction isolation
> -	 *    properties, so the RSB buffer filling wouldn't be necessary to
> -	 *    protect against this type of attack.
> +	 *    The "user -> user" attack is mitigated by RSB filling on context
> +	 *    switch.

user->user SpectreRSB is also mitigated by IBPB, so RSB filling is
unnecessary when IBPB is issued. Also, when an appication does not opted-in
for IBPB at context switch, spectre-v2 for that app is not mitigated,
filling RSB is only a half measure in that case.

Is RSB filling really serving any purpose for userspace?

