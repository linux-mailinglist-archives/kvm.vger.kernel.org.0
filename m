Return-Path: <kvm+bounces-9945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE583867C32
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:40:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 568ECB27981
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CFC12C803;
	Mon, 26 Feb 2024 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iUdIC7l5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C783412BEA1;
	Mon, 26 Feb 2024 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708964490; cv=none; b=NGEOSQ/p9XqwuGgHu6u7VxbV977OZp45i2hDp0rgZCa0T/5CcZvARz20RgXqqhg4oPYuHlTYeR5iYeSptFV4PoWoKgXK7rgMy6H/BLhyWjGm/ndaegze8EcptnZQcBt7tZ+l8jtGtyjcz2IXU7q7CgiwX5WYv5tZgWYuJSXChTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708964490; c=relaxed/simple;
	bh=/EHIikTMWeOS0ZuaWwLi00khF35uJieHD8tZwTSpUD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S6o2nCwjOonuM61LWkwFwCWyG073hjvMI2BkUUeSwg85yuelnCHbtwG+KlvBXccK85cQNjr8t4ayjnA5c1NQGI6pLqS4yreSxTLmtwpdWX6MfR9YnONdBFoLaBwNicWZ0Sjt8Gn3w0bqMwKeH3jldHICI+nJrMVc+T0FYuOd9VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iUdIC7l5; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708964486; x=1740500486;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/EHIikTMWeOS0ZuaWwLi00khF35uJieHD8tZwTSpUD0=;
  b=iUdIC7l5fudfQwkhG6GfZc/SyxkzEswt+DhYO92D34wBaR4ODY7kYl4d
   OwGw2nWRZ+pHy3Gz+3qOXtwImVWozDT/mHGbHuiyf2bXHVqm+l0PheApx
   3HJ+PrfxJ2uVgiuYy1Ekke7+ThSARHj08H9O9h1Y9193XEmCwW0M8qf21
   Z3RF8wE3VzDJYoAFuwTOsD70rO1led6m9Q5DtkD6TGKLnU13AqEF0o1uJ
   ijMoe/DpMjK8hV9Kp2y0cvq4+5nQ30WnS3igpoxMU1x/dXbrXIbXwdEb/
   LJgXFj9I+aZcDNSQYhfRDUAppJbhghYXQ5JS8c6KdkRzAcGaOjhIwTfmk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3373739"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3373739"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 08:21:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6652281"
Received: from dukhanki-mobl.amr.corp.intel.com (HELO [10.209.30.102]) ([10.209.30.102])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 08:21:24 -0800
Message-ID: <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
Date: Mon, 26 Feb 2024 08:21:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Yin Fengwei <fengwei.yin@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
 x86@kernel.org, stable@vger.kernel.org
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
 <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
 <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
 <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/25/24 17:57, Yin Fengwei wrote:
> On 2/23/24 02:08, Paolo Bonzini wrote:
>> On Thu, Feb 22, 2024 at 7:07 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>>> Ping, in the end are we applying these patches for either 6.8 or 6.9?
>>> Let me poke at them and see if we can stick them in x86/urgent early
>>> next week.  They do fix an actual bug that's biting people, right?
>> Yes, I have gotten reports of {Sapphire,Emerald} Rapids machines that
>> don't boot at all without either these patches or
>> "disable_mtrr_cleanup".
> We tried platform other than Sapphire and Emerald. This patchset can fix
> boot issues on that platform also.

Fengwei, could you also test this series on the troublesome hardware,
please?

> https://lore.kernel.org/all/20240222183926.517AFCD2@davehans-spike.ostc.intel.com/

If it _also_ fixes the problem, it'll be a strong indication that it's
the right long-term approach.

