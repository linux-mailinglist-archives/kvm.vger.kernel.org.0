Return-Path: <kvm+bounces-21154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F51B92B00E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 08:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D11511F229B3
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 06:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B7613A27D;
	Tue,  9 Jul 2024 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="caeLTwQC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E24F7D07F;
	Tue,  9 Jul 2024 06:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720506404; cv=none; b=mkTDqLMRRs1lm87yi/9wSwq0hP6H06m2UfxTVCCnjBiZqZvt6nvNLDK1pNzyR/wFaKzEi74v6iENPn+4RHSjwg0NXSGh70Od7+Zoug/A3KWBRMDPJcMyTqUKFjzOl2PnTmM19LJNx8aPnXdicTMl1cvWdhJNNZnwbAu2/Q2QtfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720506404; c=relaxed/simple;
	bh=7rhoCvATLjh7YDmR6VilaOYZi0txZK/lFS5HJUdBrGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=USx25xQ3oUE9cd616y3qfqVtnmAbtGpDrHqO+Ajf7MXTejN7eQt15BMelLE97T1wAzb3uqxYZM7W602b6jyllDeZCC9CW83UFGTIsnpIXSQdQ8gEibXQBPEoLhOqpaihLrVAjWQTZJL5tlFR960NokBWFrdHM/195BaHphfWZ2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=caeLTwQC; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720506403; x=1752042403;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7rhoCvATLjh7YDmR6VilaOYZi0txZK/lFS5HJUdBrGo=;
  b=caeLTwQC3s1li4y0rWsFH+8XJrq3UNJA74sAfwbF9A9oTew/FVrlGVpv
   l+/veVTbHodVv3Rz8tT1XBzYnO9r+/gT6JgSIjYc+YFkEHOwGYSTDpqUv
   uhxD+xNko+a6qMHpU+kqQWM8V/QO0Waw6oUpXtbsGrhW4uyFRpqpyVKtg
   /wu2Qv8Or+/eG/2NBxicp0lhRW+iZN37TJS27YH3Qz/ReMKzYWKkgGssy
   ZcUU0K3ZFABTZIVTUUs4Bn3KIvRGl3fWkqy3zVgB5jsrT5g2w7K9D183F
   Sd5QOlE+pcbEDXBMTu6F1ZxjJE8/MxkRV/BwxJ1Fm1l1SMtoTSYb9AP99
   Q==;
X-CSE-ConnectionGUID: O/rn2BV7R0W+zEmoNlsuzw==
X-CSE-MsgGUID: TxS99ZrTRGqt185awUlryQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="35174053"
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="35174053"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 23:26:43 -0700
X-CSE-ConnectionGUID: vweDiCz2Rpq5DpUmPEbT0w==
X-CSE-MsgGUID: 4kbflCVUTY2eYStYo00XPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,194,1716274800"; 
   d="scan'208";a="48407438"
Received: from taofen1x-mobl1.ccr.corp.intel.com (HELO [10.238.11.85]) ([10.238.11.85])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 23:26:38 -0700
Message-ID: <e7233d96-2ab1-4684-8ce4-0189a78339ca@linux.intel.com>
Date: Tue, 9 Jul 2024 14:26:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 109/130] KVM: TDX: Handle TDX PV port io hypercall
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 isaku.yamahata@linux.intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Reinette Chatre <reinette.chatre@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4f4aaf292008608a8717e9553c3315ee02f66b20.1708933498.git.isaku.yamahata@intel.com>
 <00bb2871-8020-4d60-bdb6-d2cebe79d543@linux.intel.com>
 <20240417201058.GL3039520@ls.amr.corp.intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240417201058.GL3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/18/2024 4:10 AM, Isaku Yamahata wrote:
> On Wed, Apr 17, 2024 at 08:51:39PM +0800,
> Binbin Wu <binbin.wu@linux.intel.com> wrote:
>
>>
>> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Wire up TDX PV port IO hypercall to the KVM backend function.
>>>
>>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>> v18:
>>> - Fix out case to set R10 and R11 correctly when user space handled port
>>>     out.
>>> ---
>>>    arch/x86/kvm/vmx/tdx.c | 67 ++++++++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 67 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>>> index a2caf2ae838c..55fc6cc6c816 100644
>>> --- a/arch/x86/kvm/vmx/tdx.c
>>> +++ b/arch/x86/kvm/vmx/tdx.c
>>> @@ -1152,6 +1152,71 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)
>>>    	return kvm_emulate_halt_noskip(vcpu);
>>>    }
>>> +static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
>>> +{
>>> +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
>>> +	tdvmcall_set_return_val(vcpu, 0);
>>> +	return 1;
>>> +}
>>> +
>>> +static int tdx_complete_pio_in(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>> +	unsigned long val = 0;
>>> +	int ret;
>>> +
>>> +	WARN_ON_ONCE(vcpu->arch.pio.count != 1);
>>> +
>>> +	ret = ctxt->ops->pio_in_emulated(ctxt, vcpu->arch.pio.size,
>>> +					 vcpu->arch.pio.port, &val, 1);
>>> +	WARN_ON_ONCE(!ret);
>>> +
>>> +	tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
>>> +	tdvmcall_set_return_val(vcpu, val);
>>> +
>>> +	return 1;
>>> +}
>>> +
>>> +static int tdx_emulate_io(struct kvm_vcpu *vcpu)
>>> +{
>>> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>>> +	unsigned long val = 0;
>>> +	unsigned int port;
>>> +	int size, ret;
>>> +	bool write;
>>> +
>>> +	++vcpu->stat.io_exits;
>>> +
>>> +	size = tdvmcall_a0_read(vcpu);
>>> +	write = tdvmcall_a1_read(vcpu);
>>> +	port = tdvmcall_a2_read(vcpu);
>>> +
>>> +	if (size != 1 && size != 2 && size != 4) {
>>> +		tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
>>> +		return 1;
>>> +	}
>>> +
>>> +	if (write) {
>>> +		val = tdvmcall_a3_read(vcpu);
>>> +		ret = ctxt->ops->pio_out_emulated(ctxt, size, port, &val, 1);
>>> +
>>> +		/* No need for a complete_userspace_io callback. */
>> I am confused about the comment.
>>
>> The code below sets the complete_userspace_io callback for write case,
>> i.e. tdx_complete_pio_out().
> You're correct. This comment is stale and should be removed it.
Also, since the tdx_complete_pio_out() is installed as 
complete_userspace_io callback for write, it's more reasonable to move 
the reset of pio.count into tdx_complete_pio_out().
How about the following fixup:

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9ead46cb75ab..b43bb8ccddb9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1115,6 +1115,7 @@ static int tdx_emulate_hlt(struct kvm_vcpu *vcpu)

  static int tdx_complete_pio_out(struct kvm_vcpu *vcpu)
  {
+       vcpu->arch.pio.count = 0;
         tdvmcall_set_return_code(vcpu, TDVMCALL_SUCCESS);
         tdvmcall_set_return_val(vcpu, 0);
         return 1;
@@ -1159,15 +1160,13 @@ static int tdx_emulate_io(struct kvm_vcpu *vcpu)
         if (write) {
                 val = tdvmcall_a3_read(vcpu);
                 ret = ctxt->ops->pio_out_emulated(ctxt, size, port, 
&val, 1);
-
-               /* No need for a complete_userspace_io callback. */
-               vcpu->arch.pio.count = 0;
-       } else
+       } else {
                 ret = ctxt->ops->pio_in_emulated(ctxt, size, port, 
&val, 1);
+       }

-       if (ret)
+       if (ret) {
                 tdvmcall_set_return_val(vcpu, val);
-       else {
+       } else {
                 if (write)
                         vcpu->arch.complete_userspace_io = 
tdx_complete_pio_out;
                 else


