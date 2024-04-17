Return-Path: <kvm+bounces-14930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8098A7C37
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E05EB1C21B9D
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 06:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E5164CF3;
	Wed, 17 Apr 2024 06:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+xTBtPK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C189E53807;
	Wed, 17 Apr 2024 06:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713334625; cv=none; b=MPAYz4/oKypK9fJI2dEC8J2H+r6siTEZFDFm+UzfV1JdwpXH6RXKgoEAfAbSHdvwcNIltPakgq9eRidp1mPEo8LOl0fNe03D50uhlyEkSak0U+Orzfv/p34yFLzmuVxNp74M6kQaMb/tghlr+uPUjySh4wZcKzhwxD31b86czr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713334625; c=relaxed/simple;
	bh=0J1Qe7V2WFO72quDvEDPSDcrlOlYGUy9Qip9dj5vZ0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MWWKxuSbvqpBdhkILCdabyRHM9Zivr+u62gGr04JMOtyOmPXYVrMC51xtWPGBhOWAKnEElnS58BkcJXQoFWkPbkxWdtkxedCNGe6+BAk0AItVkTZLXnBC80pA5ZbeWTiAc7ES8aBOfNVe0HEfaxQPw5gBskJnNWoXINtQ/tJ2nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+xTBtPK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713334624; x=1744870624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0J1Qe7V2WFO72quDvEDPSDcrlOlYGUy9Qip9dj5vZ0A=;
  b=F+xTBtPKej9gUIWZBq1uDBphLsSGef1Kz8Ks7nLv/McC/GMjNP39CC/s
   fwTd4QDV52YmwMpT6X4Y47jY9DjbOlMGqspUD94bXo1vlMnlmH2fpdHX2
   6Ua6Xw2iwxrK9m2UgjIfZZQ25FHnQ+do37Jzt90wBTOUX023y7tokxdgG
   xHc2ZdnuSMLWzSrFx45xfDGf02qfbKZEXtHgAGEKU2pUQmnE79Op9JbPN
   LAmXJWNG2ZCpgROwbMz8YH8qWgS8mjZb8SpLZLrwwGwBsDLOrDDqI8wiE
   57qlJc2sHaeel0KOjfh3PIFBoaFWESW856gkJ90fp8qbQTcvBLJN1xqyV
   A==;
X-CSE-ConnectionGUID: 8QkL/u5VQsujHOhCPkUxQQ==
X-CSE-MsgGUID: kL25jsnhTz25lXWnkzGoCg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="11750832"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="11750832"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:17:03 -0700
X-CSE-ConnectionGUID: Sw/+0tTkSwORlNrgJa1Iww==
X-CSE-MsgGUID: /Xo3zss/RYenwmYmBg/J+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="59932999"
Received: from unknown (HELO [10.238.13.36]) ([10.238.13.36])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 23:16:59 -0700
Message-ID: <8d489a08-784b-410d-8714-3c0ffc8dfb39@linux.intel.com>
Date: Wed, 17 Apr 2024 14:16:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with
 TDG.VP.VMCALL
To: Isaku Yamahata <isaku.yamahata@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
 <ZgvHXk/jiWzTrcWM@chao-email>
 <20240404012726.GP2444378@ls.amr.corp.intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240404012726.GP2444378@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/4/2024 9:27 AM, Isaku Yamahata wrote:
> On Tue, Apr 02, 2024 at 04:52:46PM +0800,
> Chao Gao <chao.gao@intel.com> wrote:
>
>>> +static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>>> +{
>>> +	unsigned long nr, a0, a1, a2, a3, ret;
>>> +
>> do you need to emulate xen/hyper-v hypercalls here?
>
> No. kvm_emulate_hypercall() handles xen/hyper-v hypercalls,
> __kvm_emulate_hypercall() doesn't.
So for TDX, kvm doesn't support xen/hyper-v, right?

Then, should KVM_CAP_XEN_HVM and KVM_CAP_HYPERV be filtered out for TDX?

>
>> Nothing tells userspace that xen/hyper-v hypercalls are not supported and
>> so userspace may expose related CPUID leafs to TD guests.
>>


