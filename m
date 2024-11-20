Return-Path: <kvm+bounces-32118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 012F69D32DD
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFC6F1F23936
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4085157495;
	Wed, 20 Nov 2024 04:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QOjHkX1l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC373176;
	Wed, 20 Nov 2024 04:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732075440; cv=none; b=RkSmbe5yXU1HWGR6eKd/c+PJbFu5i4H5GrC38kUY4HDi61exFDLgrMDQTMlmHKPewlOQEh8pTRmLid8aPB5tbb+imy3C2xDMLzZcsl1SlBAqcGUX1x+sJYymcPZ2PCx1hp/GJfM1AUra/nRjJ/EM1SG2KCyFp0cq2FLw628TKz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732075440; c=relaxed/simple;
	bh=r41Eb+fJ3uIywp8te8U4WHM8WHp7sJWz+VL8aPrV7nA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XmeJ/ZZSI9N2VMgzeJeI4JsS/46iH9H1vCubjHvAp7pncPz1EuywxHFzC/tA2hZHwagAF6BEJbRWLHsYodCEkOI4cq3HGEclogGffetgkAxs3fkAfWYQI4QiczG1jJ+T+neey3+l2i61lShJiE9oTE8HYOqhK0wTUJU/94JSjLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QOjHkX1l; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732075438; x=1763611438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r41Eb+fJ3uIywp8te8U4WHM8WHp7sJWz+VL8aPrV7nA=;
  b=QOjHkX1lcMKxu0beETiggI9lEI9di234F+9PZMpvNG+rjzAOXoUowxkH
   iZKSQ3qRt+RZKgKGKTPzVFA4bOSzE5fjGYkwCTDtrLKoUnvVbYai5K8yM
   7eQyphlh6WkrYODsPDxJfDKnZD4KxL3/tJYBYZ/g0JdFX+e+pJvHLY7yK
   HtfLnhexOdm5Gw+TvJKUCSzxYe5Z8m0caVHD7ht9ZARKSMabQ0UkOmP5h
   xVaeA5cPFHFXu1dPyTIxQUP70ptBaZHP9BiDWIHaXX58xNfkSq0ZhM6qk
   kSaVg/2pAPBBf6jPiUKU+LtX/fLbjeUg+WpIcs98QBRhM6Jp2A4IFlB30
   A==;
X-CSE-ConnectionGUID: rahOZsykToeqMGuthCgDfQ==
X-CSE-MsgGUID: nsl/syGFSK6YfHrBC7Cy2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="36024545"
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="36024545"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 20:03:57 -0800
X-CSE-ConnectionGUID: sXZrxEyUSTSoSVppd524cg==
X-CSE-MsgGUID: QFNulvvjSR6eI60JKfRu9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,168,1728975600"; 
   d="scan'208";a="94243691"
Received: from shiningy-mobl1.ccr.corp.intel.com (HELO [10.124.227.33]) ([10.124.227.33])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2024 20:03:51 -0800
Message-ID: <6fc71b3c-fbc1-4fb8-9692-f85d3166a68f@linux.intel.com>
Date: Wed, 20 Nov 2024 12:03:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
To: Michael Roth <michael.roth@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org,
 pbonzini@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com,
 pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "Peng, Chao P" <chao.p.peng@intel.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com> <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com>
 <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
 <20241119135327.zjxlczjbli3wdo5o@amd.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20241119135327.zjxlczjbli3wdo5o@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/19/2024 9:53 PM, Michael Roth wrote:
[...]
> A few weeks back we discussed during the PUCK call on whether it makes
> sense for use a common exit type for REQ_CERTS and TDX_GET_QUOTE, and
> due to the asynchronous/polling nature of TDX_GET_QUOTE, and the
> somewhat-particular file-locking requirements that need to be built into
> the REQ_CERTS handling, we'd decided that it's probably more trouble
> than it's worth to try to merge the 2.
>
> However, I'm still hoping that KVM_EXIT_COCO might still provide some
> useful infrastructure for introducing something like
> KVM_EXIT_COCO_GET_QUOTE that implements the TDX-specific requirements
> more directly.
I am not sure it benefits much.
Since the handling codes of REQ_CERTS and  TDX_GET_QUOTE in userspace are
quite different, i.e., there will be little common code to reuse, but it
requires KVM to convert the error code from the KVM_EXIT_COCO version to
vendor specific versions.


>
> I've just submitted v2 of KVM_EXIT_COCO where the userspace-provided
> error codes are reworked to be less dependent on specific spec-defined
> values but instead relies on standard error codes that KVM can provide
> special handling for internally when needed:
>
>    https://lore.kernel.org/kvm/20241119133513.3612633-1-michael.roth@amd.com/
>
> But I suppose in your case userspace would just return "SUCCESS"/0 and
According to GHCI spec, besides "TDG.VP.VMCALL_SUCCESS", there are two more
error codes "TDG.VP.VMCALL_RETRY" and "TDG.VP.VMCALL_INVALID_OPERAND".
"TDG.VP.VMCALL_RETRY" could cover EAGAIN.
"TDG.VP.VMCALL_INVALID_OPERAND" could be used to cover the other errors
returned, i.e., EIO and ENOSPC according to your proposal in v2.

> then all the vendor-specific values are mainly in relation to the
> "Status Code" field so it likely doesn't make a huge difference as far
> as what userspace passes back to KVM.
>
> Thanks,
>
> Mike
>
[...]

