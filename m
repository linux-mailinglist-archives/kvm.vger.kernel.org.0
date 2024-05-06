Return-Path: <kvm+bounces-16607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058CE8BC5D6
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 04:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 372A31C214B6
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 02:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECC034CD8;
	Mon,  6 May 2024 02:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L6M2js6q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00C71096F
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714963373; cv=none; b=PLZ8tyl9iKsFpt86gBQXOQXmt7cHSbOaOH3wgHT5KTs/Oa52GmiX9yhmUEKaessqr6JnrGWYfWiNjtw9MNPr0HxqAUfUNJ6eG6UgZdI0Zxh5qe8QILLWCrzdo6rViUEuorxTSRleSErYCNOkN1EQosbMWR+KCQ5q32lfohypE18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714963373; c=relaxed/simple;
	bh=LzRCBXPhfqaFfj4fQHqmi9NM6+t8R/Qm8mpHsXOCVnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+2T8EpBULo+xpwJGSrsHbHQzTkP0mLM6cOWe3e7Ysv/Kft+2ZFg7j+B/oo7vpRCiXH8uw1ikDYgjqP5WWPufxFfXQo0NSZmkZR+tFHFvvwjRc5qFNfvhIbLHNwuaX55tl7RFyRIVl/M2w6wqpNhRg6N7oBCF9Y4kzZEKopUKWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L6M2js6q; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714963372; x=1746499372;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LzRCBXPhfqaFfj4fQHqmi9NM6+t8R/Qm8mpHsXOCVnA=;
  b=L6M2js6q7wPZkDibEjqoCRHie4db5yMn8zMAJfzPyVyhZi/yUwhHiY6I
   7P33TwtKjMgYm+OUOcU2W/unFt28kyhOXhtf5jL353jc5a/Avgd9X9GqK
   arJGIl92sQk2LfOs6DHyGYSLH3ptEbyWmJ0fKrE+q29qXNwCMsHaDDQG5
   DCUhMhYYotaDInRw4B6LF8rctVCR7j+Jogj5EcS8UJ2xJpcAMvQOGNqFP
   iOSh60Z3cry7ewNq7zc+CSDvxZBsaknrOfV3I4+ktleXAkc8GOnb0iYKB
   qpCt1BWdpdQjjbNCxB3dwzhdPgx6FNmpTK6rHIKhz52PdIizHDMgJ7OBM
   A==;
X-CSE-ConnectionGUID: +86XdyhKS/WNvAJ3yiiqkg==
X-CSE-MsgGUID: sfEzv1qyQ1qtQ/HC9ZoG3Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10524761"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="10524761"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2024 19:42:51 -0700
X-CSE-ConnectionGUID: L8z9fa1MS0+ruIrD18g45Q==
X-CSE-MsgGUID: hJNJZ3e0QFuwIDprIVz+/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28106331"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 05 May 2024 19:42:49 -0700
Date: Mon, 6 May 2024 10:57:01 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 6/6] target/i386/confidential-guest: Fix comment of
 x86_confidential_guest_kvm_type()
Message-ID: <ZjhG/cCMFP9T1z6J@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
 <20240426100716.2111688-8-zhao1.liu@intel.com>
 <c75723d7-353e-4208-96bc-865a227f1bac@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c75723d7-353e-4208-96bc-865a227f1bac@intel.com>

Hi Xiaoyao,

On Sat, Apr 27, 2024 at 07:05:41AM +0800, Xiaoyao Li wrote:
> Date: Sat, 27 Apr 2024 07:05:41 +0800
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> Subject: Re: [PATCH 6/6] target/i386/confidential-guest: Fix comment of
>  x86_confidential_guest_kvm_type()
> 
> On 4/26/2024 6:07 PM, Zhao Liu wrote:
> > Update the comment to match the X86ConfidentialGuestClass
> > implementation.
> > 
> > Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> I think it should be "Reported-by"
>

Right, let me fix and respin it.

Thanks,
Zhao


