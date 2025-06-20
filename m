Return-Path: <kvm+bounces-50014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 644D1AE1173
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 04:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAC6B164AA0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 02:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279C11C863B;
	Fri, 20 Jun 2025 02:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ksx1Wn7I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CE661FF2;
	Fri, 20 Jun 2025 02:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388245; cv=none; b=W6Ma4AUqMS2+Q89OBXXKSsMYaOQbLA3red4fzk7aD+nHM1mevTk/oaCtc4DfioOzlr59/os+LfcPVyJlIRcLm3J40y0SVKhUdMY4Hctix3ILpsRCYO13Gect9hzeEUWvm4FFbSNGpfIRiXo5DR+zoXTBa5WUHkCAFVioTl5INJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388245; c=relaxed/simple;
	bh=J8rEIU/ZH6PsGvJ3REkRTiG+okEA29iqacRsyJNfN0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOwwgKneAgFe5wYz0tAqVUNkiuWemF/8nEt/Cz1yk6xVjHz+5INv9SwsgomEuUzjZl+tgmsdm3iJHM+dvWah987QtUZFj1mrnpSwYmJiH6fa0BaM6/f4U+0IBx0Phce7n0IVV9Z7NuU7SrXUIvBWdcCO525wCQzp4TgICdn8mug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ksx1Wn7I; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750388244; x=1781924244;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J8rEIU/ZH6PsGvJ3REkRTiG+okEA29iqacRsyJNfN0I=;
  b=ksx1Wn7IsRebrWIPHhZWHDox4HAnbJvXJibqWmq5SLcIio82XJ8FLVBz
   CP883zOE3iKM3mAVonTlaUq8Qojy3H8N+VFV10Ox9UahDJ6e3QxAyqiUQ
   xoL7QyXavdGdwxO5nJROHmiUHpwb5jTtFfE8MkQvxMC3TEQRThpMWqylV
   QyrHuYDJ0yB7Mu/YtNDBcRP+N0gIR40Mof/vfDX7609R8RUvgmmPAvCHy
   VHSFCSBnflwI8QXK3XIl5YkMVWPEdLY17aOuYJv2l41B83itqHIZgtpHd
   WWS6MmBftDZ1Cr9U75kEtROmwStCR3CsStQKxBWmMFpVdqLNYbrlPiH4Q
   w==;
X-CSE-ConnectionGUID: QN0d8KUqSzqJ7Lc9+UvWdQ==
X-CSE-MsgGUID: tWr6n0WmScK4qwsEkS4akg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52725770"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="52725770"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 19:57:23 -0700
X-CSE-ConnectionGUID: uaaqy+cQTb+hcXpyZSWymA==
X-CSE-MsgGUID: mwiHqx86SCWtgrvpx0cucg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="156596041"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 19:57:19 -0700
Message-ID: <afcb49f2-d881-420d-9727-58182e52f977@linux.intel.com>
Date: Fri, 20 Jun 2025 10:57:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com, jiewen.yao@intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <20250619180159.187358-3-pbonzini@redhat.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250619180159.187358-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
[...]
> @@ -7174,6 +7175,52 @@ The valid value for 'flags' is:
>     - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
>       in VMCS. It would run into unknown result if resume the target VM.
>   
> +::
> +
> +		/* KVM_EXIT_TDX */
> +		struct {
> +			__u64 flags;
> +			__u64 nr;
> +			union {
> +				struct {
> +					u64 ret;
> +					u64 data[5];
Should the interface reserve more elements?

Without considering XMM registers, the possible registers according to GHCI spec
are RBX, RDX, RBP, RDI, RSI, R8, R9, R12-R15. Since RBP is not suggested to be
used to pass information, how about make the array 10 elements?


> +				} unknown;
> +				struct {
> +					u64 ret;
> +					u64 gpa;
> +					u64 size;
> +				} get_quote;
> +			};
> +		} tdx;
> +

