Return-Path: <kvm+bounces-58881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E98BA4929
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8529517FBCA
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D2423D294;
	Fri, 26 Sep 2025 16:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L8CtANDG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9260239085;
	Fri, 26 Sep 2025 16:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758903121; cv=none; b=NIto3EVAUPuWue2AZrc9F6M86St/f4E8YZ6T4+NQ8BjfUIGBIpdMT10qzFH4jwumJsqGww/MHTkWjqAcic2cexjSZsbF4JAmAxZ6E7hnGOEwkBGPzlv8g87hLxlw2fWOV4qGDGAuDs2IIMnTE9hBsJkeg2dToW8TtGYuuWyBV58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758903121; c=relaxed/simple;
	bh=LzwWJQ2BTEHF4pIUX4Yzagok94NcOb7RjCI0qPZI/y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tWrg4VTo2dIKfs+XRri4qwyM7J8jN5qpCrcSaVlW7iCyCNaCwNFGXBj0GMoY1/ijJgSHCs5Uc4or2j5Qf7G/Bc1vKVf90+9c2VaI1AVnKebUJtLL8kFzcq/gxylvSCnD48sh6oKbYS+CbNrn4dzViO67mw8dI/kgiZh7JyOKUpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L8CtANDG; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758903120; x=1790439120;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LzwWJQ2BTEHF4pIUX4Yzagok94NcOb7RjCI0qPZI/y4=;
  b=L8CtANDGbLvAhC3EGc4pbg8h0uYtFqFCl4kehCwcwaTQbAS+KMTzD+ST
   q6qP8aUmnpBqGYie0ZxPINakYPUDm6E4UdscbdPB0LXXFQEhpqaEsBpok
   FLBwnw30l7oA11rRTMuwfkmVh2NkC80frGFfNA94CxGNe3tjEKSuwqBSJ
   fH5ejFQ8TY81sY8gd3lBfP6Y5iUGLOmvWSi7eQ3GhFuD67jVaSSgHRvTr
   ISha4HwOQhW+BuRwBV43hVKpjYtkSBtqrKCfWWmUXqHAUE8PJjIuovlVp
   kluhTBmHsm4y8DtXpuR2/M8mSgKIaU70X3wk3G67sL7w81H+5OnlbKxgU
   w==;
X-CSE-ConnectionGUID: ha4fvSChSAyZQLlQ20kzCg==
X-CSE-MsgGUID: KNCRK3eNRCu8YYm7gRhpjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61192911"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61192911"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:11:57 -0700
X-CSE-ConnectionGUID: dPQx06EsSp2EIN10J7xiZQ==
X-CSE-MsgGUID: oQyf8SwFRMqPukPaf2iwJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,295,1751266800"; 
   d="scan'208";a="177490558"
Received: from cmdeoliv-mobl4.amr.corp.intel.com (HELO [10.125.109.59]) ([10.125.109.59])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 09:11:55 -0700
Message-ID: <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
Date: Fri, 26 Sep 2025 09:11:54 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com"
 <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "Annapurve, Vishal"
 <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/26/25 09:02, Edgecombe, Rick P wrote:
> On Fri, 2025-09-26 at 07:09 -0700, Dave Hansen wrote:
>> On 9/25/25 19:28, Yan Zhao wrote:
>>>> Lastly, Yan raised some last minute doubts internally about TDX
>>>> module locking contention. I’m not sure there is a problem, but
>>>> we
>>>> can come to an agreement as part of the review.
>>> Yes, I found a contention issue that prevents us from dropping the
>>> global lock. I've also written a sample test that demonstrates this
>>> contention.
>> But what is the end result when this contention happens? Does
>> everyone livelock?
> 
> You get a TDX_OPERAND_BUSY error code returned. Inside the TDX module
> each lock is a try lock. The TDX module tries to take a sequence of
> locks and if it meets any contention it will release them all and
> return the TDX_OPERAND_BUSY. Some paths in KVM cannot handle failure
> and so don't have a way to handle the error.
> 
> So another option to handling this is just to retry until you succeed.
> Then you have a very strange spinlock with a heavyweight inner loop.
> But since each time the locks are released, some astronomical bad
> timing might prevent forward progress. On the KVM side we have avoided
> looping. Although, I think we have not exhausted this path.

If it can't return failure then the _only_ other option is to spin. Right?

I understand the reluctance to have such a nasty spin loop. But other
than reworking the KVM code to do the retries at a higher level, is
there another option?

