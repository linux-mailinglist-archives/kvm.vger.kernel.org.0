Return-Path: <kvm+bounces-71643-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uMbpD5/snWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71643-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:23:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E241C18B4E9
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:23:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E805B305B386
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5650A3A9DA5;
	Tue, 24 Feb 2026 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ggeqbgf1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBC12C027C;
	Tue, 24 Feb 2026 18:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957360; cv=none; b=Yir6K4Y8EgqTSHful1okhg7pVQcqZSvJdWeuGvW4emWlXIMNe6ZjR4VuhNz4kdeBTblGiHndeOx/Yy4u/+wk/fiGw1ogNt2UlHFNt4pi/5EeGhJKHvoF16UH7TWQTAep+i+m9BCKCiCu/Ob6JjpkNr16B4mD7Pql84nKQLB1EXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957360; c=relaxed/simple;
	bh=tQcoU85UUD9XcuHHDL6vWV2ziTAyXgdu2WUkS0PPoe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MS0+48uGRuyL9LeDQxyCiN6NdL4KMBZb/pHXlA0TtvYfwsmhcODTw/onvj1kXiQwdb05B1lA8CUGhuCGjVcjn+IfCZ1umivxPHrjcxmAcAY5FNxuYJN5Mo3IuRP2uUYTLazW4qfIc38H4iQTqMaz4q3rZYeqKq3wmSFUaZflybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ggeqbgf1; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771957357; x=1803493357;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tQcoU85UUD9XcuHHDL6vWV2ziTAyXgdu2WUkS0PPoe4=;
  b=ggeqbgf1HkQeJdxxvTHtVnNgMsC4oYz8GIo7LtzSj7nSUCj20BXka1eI
   yrhIdkCaNRlriDp+0XRED1wFJ/ozSr+OxMT6dDJAbnThJe8M/UKGP96MI
   ItMk6vCcEHTAiqP6hoa4wXrk76OemeCR54gMvyea+sw7Nt1DVpfbeyNVW
   gK1i9pFyAjUYexzTjFbHwfzH+DfA/o57rsmAR+8kZm+jTQZ8ycreZqMTH
   bdGqIA13k7kBp5S5RRAkuFr9+mYGCkj7+fMQvd5eDu0x+3LZOuGnXiSl6
   EpanBdbnMMYOlNmhAfnfrbKm+7hP54ifyuzhUipNpQ6HP23d480bFg53d
   w==;
X-CSE-ConnectionGUID: bIKmPFnATlaEMkUn0Clkxg==
X-CSE-MsgGUID: JPvnzNLNTbSJd5F9ffTNjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="83696386"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="83696386"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:22:37 -0800
X-CSE-ConnectionGUID: o/17PFgXSwGl7DplXy5bbg==
X-CSE-MsgGUID: qOYXcZTcQMSSYspjpo9T9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="220586598"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.111.27]) ([10.125.111.27])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:22:36 -0800
Message-ID: <6b3b0c86-99eb-406d-b88d-3d71613bef9e@intel.com>
Date: Tue, 24 Feb 2026 10:22:36 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] cpu/bugs: Fix selecting Automatic IBRS using
 spectre_v2=eibrs
To: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak
 <kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, stable@kernel.org
References: <20260224180157.725159-1-kim.phillips@amd.com>
 <20260224180157.725159-2-kim.phillips@amd.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260224180157.725159-2-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-71643-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dave.hansen@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: E241C18B4E9
X-Rspamd-Action: no action

On 2/24/26 10:01, Kim Phillips wrote:
> @@ -2136,7 +2136,8 @@ static void __init spectre_v2_select_mitigation(void)
>  	if ((spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS ||
>  	     spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
>  	     spectre_v2_cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
> -	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> +	    !(boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
> +	      boot_cpu_has(X86_FEATURE_AUTOIBRS))) {
>  		pr_err("EIBRS selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n");
>  		spectre_v2_cmd = SPECTRE_V2_CMD_AUTO;
>  	}

Didn't we agree to just use the "Intel feature" name? See this existing
code:

>         /*
>          * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
>          * flag and protect from vendor-specific bugs via the whitelist.
>          *
>          * Don't use AutoIBRS when SNP is enabled because it degrades host
>          * userspace indirect branch performance.
>          */
>         if ((x86_arch_cap_msr & ARCH_CAP_IBRS_ALL) ||
>             (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
>              !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
>                 setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
>                 if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
>                     !(x86_arch_cap_msr & ARCH_CAP_PBRSB_NO))
>                         setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
>         }

You're probably not seeing X86_FEATURE_IBRS_ENHANCED because it doesn't
get forced under SNP.

