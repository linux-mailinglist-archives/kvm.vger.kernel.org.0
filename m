Return-Path: <kvm+bounces-16890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E15778BEA09
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 19:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C8EAB2BA3B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0089B176FA5;
	Tue,  7 May 2024 16:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CMBByKuX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7131B16D304
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 16:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100096; cv=none; b=YBDYUFS587UgrSTnhLuQLraWLTWCR/rOgdJDI5uvy9ljvv5GWn2O8DE9yAngsvXxTZYZ0bF3pUSzNTDBU/TrdyTsaiDffp9Dsjui33ptfHywN7HFE/6QcQ/uZbFQGsHkeDRK00D4S4Ii2htqlVoA1GGnyxleoC8dK+ok81w7J/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100096; c=relaxed/simple;
	bh=7Y91Q6yCsxx2F5Qm9j/+kVPuyr2U0O/GbtkbgJspc+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lK4WP3Zim1GezRy335uGY6+Pwy8EzNuxHZPPxhmN9lgb/yjN/FaGLi7O6jmmgMwba7tXamAX2taQPd+Z3Bz48NlOJZrYZO1gTspic2IY6P1q2BQiemR5sboIyAoZeARRHQqkj4WfamX7pEWrkbaCEFPV3Dy4kEU2rGrYm9ItG50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CMBByKuX; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715100095; x=1746636095;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=7Y91Q6yCsxx2F5Qm9j/+kVPuyr2U0O/GbtkbgJspc+I=;
  b=CMBByKuX59n+59unieyjovYB7QK+A4ZYLkKbVbntD0PgfOB+Q/OOMMDh
   k/ZvwDVuXULmGShZbO9ZWSp6+ADjBjC6b3gAasx3h/3w8e8VA/73j2+MT
   oHOKyO5QY5PNSPHi0HGw9rBl4+z+xGjyg6yz3dorRMioGxic/QkHd9vjB
   6evhp9q36Eb7YsvUUNwAXGhnrEaJoI8/CG4gQwVlnW/ivS+4+Q/mpySri
   32X28WMS1faUD8g4+WhCVcz66X4GCO1WpwBCj9gCKrhl1bgI8u61ylIIm
   Jfgq1mA4soboV1wVNJf7uta7gv+sn0C4g5Bjcgk4lPcLJ21PdZBQNLyFT
   Q==;
X-CSE-ConnectionGUID: K2EA+jSQTAaLUK2QiKzpzQ==
X-CSE-MsgGUID: 3DhU3FAaRAWXOPgGlBMXbg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="36289575"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="36289575"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 09:41:34 -0700
X-CSE-ConnectionGUID: TQThCEdIT86bRwcUl36+dw==
X-CSE-MsgGUID: 5KiP+wtaRbyuAzqfplUvWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="28674358"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 09:41:32 -0700
Message-ID: <6e0dc5f2-169e-4277-b7fe-e69234ccc1fd@intel.com>
Date: Wed, 8 May 2024 00:41:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] TDX module configurability of 0x80000008
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "seanjc@google.com" <seanjc@google.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/25/2024 12:55 AM, Edgecombe, Rick P wrote:
> Hi,
> 
> This is a new effort to solicit community feedback for potential future TDX
> module features. There are two features in different stages of development
> around the configurability of the max physical address exposed in
> 0x80000008.EAX. I was hoping to get some comments on them and share the current
> plans on whether to implement them in KVM.

Sean and Paolo,

> One of the TDX module features is called MAXPA_VIRT. In short, it is similar to
> KVM’s allow_smaller_maxphyaddr. It requires an explicit opt-in by the VMM, and
> allows a TD’s 0x80000008.EAX[7:0] to be configured by the VMM. Accesses to
> physical addresses above the specified value by the TD will cause the TDX module
> to inject a mostly correct #PF with the RSVD error code set. It has to deal with
> the same problems as allow_smaller_maxphyaddr for correctly setting the RSVD
> bit. I wasn’t thinking to push this feature for KVM due the movement away from
> allow_smaller_maxphyaddr and towards 0x80000008.EAX[23:16].
> 

I would like to get your opinion of the MAXPA_VIRT feature of TDX. What 
is likely the KVM's decision on it? Won't support it due to it has the 
same limitation of allow_smaller_maxphyaddr?

