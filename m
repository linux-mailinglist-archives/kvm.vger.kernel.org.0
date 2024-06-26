Return-Path: <kvm+bounces-20517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCF0917605
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 04:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38D27284DF6
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 02:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9B720B3E;
	Wed, 26 Jun 2024 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVo+cvq9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6421C68C;
	Wed, 26 Jun 2024 02:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719367756; cv=none; b=Rtt/tcQTUvQf361hfFrR0WI5+qOnxOXgWM6UNN3E5FILagF/JVV2WCV+Zk4C6zXq52fz3fXzmABGS4wEsNxjWHK54N75BwW5Z67mO2M7BjCFziBsChpDo0ppHR3Pun1Q1nT9Hkh6IAphY7LtEsqo5ZYVZD+E2q3x8tyRMP0lMqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719367756; c=relaxed/simple;
	bh=gJAvJvUWGrrEiCwtoTwQH9cDQpKtkLOcnQBp+ZrFuk8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eXBRvwJZP48t2p8Cs2AFnwwoDOWPWqvrzWuw1DH/CDfs6/annFzFfAkCUNSXWEA+wHwWfywgPMXLdPeYpHAlPRx5VlmHmlr66yUm0IKnGBr4A51amU/xBPJQkMQbZraaVoF4pHXQFVpf1gYkJN0opvDKmSl+2coSGPD8cSCbQN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVo+cvq9; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719367755; x=1750903755;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gJAvJvUWGrrEiCwtoTwQH9cDQpKtkLOcnQBp+ZrFuk8=;
  b=fVo+cvq9C+YO2hOOE1exXVZFPS6iTbVQ/r2kPTJ0QTfY+WaFa0vJ3w6i
   d6qpXgOKaFIYvrOOXi3iJMLApe/DXTY72aswh+4ZkBO2RqLqdvyTk6T4y
   4JdxnQXdnONX/IjahGPKgbmzgi2j1fhJGUjShE0zWzI6ozlKdUXSKgren
   QtsCL6bVMJ+PhfLofB7kW7dKgbMEVXndvgYvaHP3bZG4km4jOfIdVPbOT
   VPawy/MqY9DHjLYYtJ0cxXZeKriFA8OkWbni5d6rTzf2cntSBicim49Om
   0geLt6KGT89aHG59ghT560KgDoP3ZbUhxfboATwnzfDfzyKNXFSx3xVLE
   g==;
X-CSE-ConnectionGUID: Uw7WgJUbRxCX93Qzqbc31Q==
X-CSE-MsgGUID: +oT2wvhQQ9W4hgUxYHD/cw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16563387"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16563387"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 19:09:15 -0700
X-CSE-ConnectionGUID: D9YuBf2jQgS/eyhnB77QkA==
X-CSE-MsgGUID: JsvHagXqQp2Rt5YIEfg9LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44275977"
Received: from qunyang-mobl1.ccr.corp.intel.com (HELO [10.238.2.59]) ([10.238.2.59])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 19:09:10 -0700
Message-ID: <edfc5edc-4bf7-4bc6-b760-c9d4341acc9d@linux.intel.com>
Date: Wed, 26 Jun 2024 10:09:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc: "Zhang, Tina" <tina.zhang@intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
 "Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
 "sagis@google.com" <sagis@google.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "Aktas, Erdem" <erdemaktas@google.com>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
 <07e410205a9eb87ab7f364b7b3e808e4f7d15b7f.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <07e410205a9eb87ab7f364b7b3e808e4f7d15b7f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/26/2024 5:09 AM, Edgecombe, Rick P wrote:
> On Tue, 2024-06-25 at 14:54 +0800, Binbin Wu wrote:
>>> +               gpa = vcpu->mmio_fragments[0].gpa;
>>> +               size = vcpu->mmio_fragments[0].len;
>> Since MMIO cross page boundary is not allowed according to the input
>> checks from TDVMCALL, these mmio_fragments[] is not needed.
>> Just use vcpu->run->mmio.phys_addr and vcpu->run->mmio.len?
> Can we add a comment or something to that check, on why KVM doesn't handle it?
> Is it documented somewhere in the TDX ABI that it is not expected to be
> supported?
TDX GHCI doesn't have such restriction.

According to the reply from Isaku in the below link, I think current 
restriction is due to software implementation for simplicity.
https://lore.kernel.org/kvm/20240419173423.GD3596705@ls.amr.corp.intel.com/
+       /* Disallow MMIO crossing page boundary for simplicity. */
+       if (((gpa + size - 1) ^ gpa) & PAGE_MASK)
                 goto error;

According to 
https://lore.kernel.org/all/165550567214.4207.3700499203810719676.tip-bot2@tip-bot2/,
for Linux as TDX guest, it rejects EPT violation #VEs that split pages 
based on the reason "MMIO accesses are supposed to be naturally aligned 
and therefore never cross page boundaries" to handle the 
load_unaligned_zeropad() case.

I am not sure "MMIO accesses are supposed to be naturally aligned" is 
true for all other OS as TDX guest, though.

Any suggestion?


