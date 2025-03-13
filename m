Return-Path: <kvm+bounces-40866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3516A5EA1B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 04:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 173A13ADFE1
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 03:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591DD8635E;
	Thu, 13 Mar 2025 03:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RTvPH7Cw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00534C9D;
	Thu, 13 Mar 2025 03:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741835852; cv=none; b=geEJJdeA4npu0nYqdUDVqyuQnKM3cRk6C/2bR3fsLvq2HWS70RuLHmvzv9fJYU+4QEgYmWYHr8jrFjZ+Ir0AJB3uk7Dn64U60S+pZc92Uj+IDyPa3bA0tDyHNdY68/WgJ93so4DXFA0RDSUIEsjUbSXX6kmZtljqg5ngI4DFB48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741835852; c=relaxed/simple;
	bh=OekOGraYs0om9dmnsshqjY3GsKEuJkwsR5qh+YYbmLY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k+FSNnHMFY5ociIFa6fKy7V9W4ynEHKZ9lq+VWrWBNJ/+sh6wQ1h6jGKdNwr1w576gNk7DEMsyPZO10Kd8kO+yf85k7QOIgyw7Bs1VKLizEZnrWfwaZBHDUS/DWLT0rq2uVbp9pkM9YR/ltrhrfoM4fVZ2srVPNxstOej8coDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RTvPH7Cw; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741835851; x=1773371851;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OekOGraYs0om9dmnsshqjY3GsKEuJkwsR5qh+YYbmLY=;
  b=RTvPH7Cwa+rNuxVfXkSp5GNa9ZwdyqNhFG4xJg10bXkF/fwn65fr1t8g
   fbuSEZNREfP+vqVqb5ZDv3CeRBhyc5UlU6aNwA+gPY91986ZiWcMa8JV6
   jzZ3U8/U8mfjjGZlio5TqaIZ7y8jU4i78byQHIZofwc2iE/IgC9E1ppME
   TJeBpyWDX0HfU1qkUxQHxYuMg2YZagmZnQv9xRQiFqXnRH9ma3N2fsWZH
   LbIW/AzQNNYAidu3lbgiRfkQgzVY3P+Cp8LTZpQcxPCcWPlyAFOudSxdB
   H+NEqFkqIX6H9RSIMfQXIi0GzteqcCmgxa3Qxl0AGPbqJr8uUK5iwAtuB
   w==;
X-CSE-ConnectionGUID: v7P7r4mPSWyJq0wInVxiIQ==
X-CSE-MsgGUID: 2JQUSwunRhejJ0+wQuGNrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11371"; a="42191047"
X-IronPort-AV: E=Sophos;i="6.14,243,1736841600"; 
   d="scan'208";a="42191047"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 20:17:30 -0700
X-CSE-ConnectionGUID: rCQUFmT8S9qU0Aa5lpreBw==
X-CSE-MsgGUID: jQv7TTHYTS6Ff69EiBx4kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,243,1736841600"; 
   d="scan'208";a="125899547"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2025 20:17:28 -0700
Message-ID: <91208627-74a6-4d19-9eef-cc8da7b0a4dc@intel.com>
Date: Thu, 13 Mar 2025 11:17:26 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/10] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 adrian.hunter@intel.com, seanjc@google.com, rick.p.edgecombe@intel.com,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
 <20250307212053.2948340-6-pbonzini@redhat.com>
 <405c30e9-73be-4812-86dc-6791b08ba43c@intel.com>
 <CABgObfZOhNtk0DKq+nB2UC+FFhsEkyiysngZoovoJP-vF43bYA@mail.gmail.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CABgObfZOhNtk0DKq+nB2UC+FFhsEkyiysngZoovoJP-vF43bYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/12/2025 7:36 PM, Paolo Bonzini wrote:
> On Mon, Mar 10, 2025 at 8:24 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>
>> On 3/8/2025 5:20 AM, Paolo Bonzini wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> On exiting from the guest TD, xsave state is clobbered; restore it.
>>
>> I prefer the implementation as this patch, which is straightforward.
>> (I would be much better if the changelog can describe more)
> 
> Ok:
> 
> Do not use kvm_load_host_xsave_state(), as it relies on vcpu->arch
> to find out whether other KVM_RUN code has loaded guest state into
> XCR0/PKRU/XSS or not.  In the case of TDX, the exit values are known
> independent of the guest CR0 and CR4, and in fact the latter are not
> available.

In fact, I expected some description of how xsave state is clobbered and 
what value of them after TD exit.

   After return from TDH.VP.ENTER, XCR0 is set to TD's user-mode feature
   bits of XFAM and MSR_IA32_XSS is set to TD's supervisor-mode feature
   bits of XFAM. PKRU keeps unchanged if the TD is not exposed with PKU
   in XFAM or PKRU is set to 0 when XFAM.PKE(bit 9) is 1.

If the changelog has the description of TDX module, it indeed can help 
people understand the code.

> Thanks!
> 
> Paolo
> 


