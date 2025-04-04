Return-Path: <kvm+bounces-42617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC7CA7B549
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 03:07:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D5347A5B8F
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 01:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CAF383A5;
	Fri,  4 Apr 2025 01:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dc7h0IkO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD21B282EB;
	Fri,  4 Apr 2025 01:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743728811; cv=none; b=aVLIKwftU/ABhKitoDvlOoEKGbEpTVgPO2loOueDZoo16xS8pZqeyF6lDcvWfecLyjSgxw/toKN3/9H500NBmEgqblU56nGYkoK7Akpcyr913aY9m9YnRtHRlvim0+UmKjEWragwk9eA0BwSplfI9zvjwCHx1Fa4x7xopB+xrPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743728811; c=relaxed/simple;
	bh=8C6IDIcQHn1jLehA/s8xA3qyLU0hjoWs3X0OwFhO8PE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G1PxIbouVWbAfXzEselYH1ypqjbwmEeJxoekH8nnhsbdtZQppB8zdyxjkwp7Grq7QYfAmhUgjMrkcGNxm7yg1c9g32OYYi79jrm7Jo0BbLtFGI/AAqm3r1RvqpMbb2Pv5cD3PTYbU1pTeFgPReOpCSK6KxIMs0UIy2SkeA6q4dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dc7h0IkO; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743728810; x=1775264810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8C6IDIcQHn1jLehA/s8xA3qyLU0hjoWs3X0OwFhO8PE=;
  b=Dc7h0IkOFSQLCfoY26p8FgU5gGF1HHk+ljX6oVAMe+HAi/ekb6V5B4Fi
   pEVTn2OE8xHzYOp8v8kitb4fPePowQo+7QEpRhrkUCh58GpgE7ettRBtc
   AwnqYuNPAodOT0tLm16y/k0Z0mr4SX/aR3WNQWUQlMPajZJZxJmAo4b+i
   69c2r3aHPbPvry4UJLYiR+Rb/iHTx+1mJeO3qyTexG+c9qq3M44sR75rS
   SB235hq1LJh7qqtdwjs5eEFJii30wFHNoadFhkW2IZjEhJeOnUkoWxGsq
   cQR9wYY00Z68gpQoMv7SYEo12yvkFe4n/oW8q6KnpZ8IXW5kAcbbjZmBy
   A==;
X-CSE-ConnectionGUID: 4Yvu/OdNRmSfVhRVvk4qKg==
X-CSE-MsgGUID: zH3hY+OPStOKnjEbnkUcaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11393"; a="56531917"
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="56531917"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 18:06:49 -0700
X-CSE-ConnectionGUID: oPCtcRdgTUmjkfL9smRgXA==
X-CSE-MsgGUID: x+EUCswBR4O528EH5Uo0cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,186,1739865600"; 
   d="scan'208";a="126976491"
Received: from lbogdanm-mobl3.ger.corp.intel.com (HELO [10.124.222.248]) ([10.124.222.248])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2025 18:06:46 -0700
Message-ID: <0d8be9b7-1d81-4494-b317-82aec02d7a47@intel.com>
Date: Thu, 3 Apr 2025 18:06:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/8] x86/fpu/xstate: Warn if guest-only supervisor
 states are detected in normal fpstate
To: "Chang S. Bae" <chang.seok.bae@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
 peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
 john.allen@amd.com, bp@alien8.de, xin3.li@intel.com,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
 Mitchell Levy <levymitchell0@gmail.com>, Adamos Ttofari
 <attofari@amazon.de>, Uros Bizjak <ubizjak@gmail.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-9-chao.gao@intel.com>
 <ec953e80-a39e-4d42-b75e-6f995289a669@intel.com> <Z+1KBN+s3CWdTN60@intel.com>
 <fe730028-1861-4fc3-8ddb-6b218d5aa234@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <fe730028-1861-4fc3-8ddb-6b218d5aa234@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/3/25 17:02, Chang S. Bae wrote:
> On 4/2/2025 7:30 AM, Chao Gao wrote:
>> The goal is to ensure that guest-only _supervisor_ features are
>> not enabled in non-guest FPUs.
> 
> I think the common XSAVE path matters here. The other XSAVE paths — 
> signal delivery and saving the LBR state — already handle supervisor 
> states properly. Signal delivery excludes all of supervisor states
> from the RFBM, while LBR state saving triggers a warning if any non-
> LBR state is set in the RFBM. Given this, the guard seems good
> enough unless missing something.
This patch is looking more and more optional. There's no broad consensus
on the need for a warning or exactly what it should warn on.

I think it should be dropped.

