Return-Path: <kvm+bounces-17933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39CC48CBBB9
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 09:09:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6F62282723
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 07:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E337C081;
	Wed, 22 May 2024 07:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GW4GzYK7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF1044374;
	Wed, 22 May 2024 07:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716361773; cv=none; b=Pe1MtsPGNrqe225rlR03zsMjxVI/JzZ7qpG3wWs67p/ysstQMmVEuMxvhxIO2qGibRO9fsayxJAvvzyPdH12DLhMlC5bblQbKkYNDlupId2+23taUJN/8EOVVpeA3L0QcdbrSPfmoCf6mL47aRlpPpNrjXDEmLL4PsmSzuc6yCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716361773; c=relaxed/simple;
	bh=ks7qzxBWOY/T/po/+vONtUdTYvvlAEfR8pTswVWRJh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uhm6n4iLQebGAvQSzMfaY/5CR6MBZMGCeWsDMpl6jxXUER6x0tJaJgsSWKzNadW/XljnV/9RoZxzY0ZA4FZtrF7fHRQHgHHIh1PSnmdmxtGPmQs/ob38fjQ+MeJgaX44rqaCxqyIR6WSrF91HSaSJtfEDLzm5terOrRD1TAgSgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GW4GzYK7; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716361773; x=1747897773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ks7qzxBWOY/T/po/+vONtUdTYvvlAEfR8pTswVWRJh0=;
  b=GW4GzYK7bsmMLkfN9WqTBWqPAOikcuMZgN20IP6r24ojuGvO1nIpCz4d
   eee+j43OmuygoQet5l0B7mM7rp7WXAZR70JC31Lb1TYlZD3r/a3bpIKtu
   9kX2OiKOhrBog6z4n50YqfDpZV5A6dClmiiB+MvM0Abu1z1ePrfbra4xp
   vF/kL0QMWiDl7d8bz46gmBCQNHWhijeehrCsSogbQSijzoBL/fuiZn6Wg
   rjP0a0xYn//aygMhIGW1dJ5P5BmnT2AgTssXwopoCt8TMRGuEBHmY8X4z
   PpfJEolPJ4QtdRlbo8AFx+RtDAVqUCTlze2dWWR5gJN8Nw95ldQov8an1
   A==;
X-CSE-ConnectionGUID: ioVP5Q1KTJKS+8woL/EzNg==
X-CSE-MsgGUID: c/Md+fUERZG8s/X6OItLPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="12710655"
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="12710655"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:09:32 -0700
X-CSE-ConnectionGUID: gcbXK/2ETJCasTt4wToDMA==
X-CSE-MsgGUID: rEnt1V2CR2SzZyRQOtbyYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,179,1712646000"; 
   d="scan'208";a="33306772"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 00:09:29 -0700
Message-ID: <81d9b683-450a-4fb6-9d95-108c77d9b3cb@intel.com>
Date: Wed, 22 May 2024 15:09:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/10] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
 asm/vmx.h
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Shan Kang <shan.kang@intel.com>,
 Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240520175925.1217334-1-seanjc@google.com>
 <20240520175925.1217334-9-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240520175925.1217334-9-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/21/2024 1:59 AM, Sean Christopherson wrote:
> +#define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)

Same as Patch 4. It is newly added but will be used by following patch 10.

Call out it in change log or move it to patch 10.

