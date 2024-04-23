Return-Path: <kvm+bounces-15645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B11EF8AE5C8
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2D251C21DE4
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A2F134427;
	Tue, 23 Apr 2024 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+LX6t7S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1036713343F;
	Tue, 23 Apr 2024 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713874424; cv=none; b=j10iTS7iSvGTBTWLX0Q6HBWMlet0W6DE8BgLZEIfvfjM1NeqOAdeg3WDA6w85MOMtVAcXBhf42bbVzsGOCPf469dhmR7Q2tQco3xr0A/vCmC46xOCQpTayNmwq+gxARNyE0SB2do6A3IWsVNJp3RTP3qOmhzGB8g3ZdGGN3n3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713874424; c=relaxed/simple;
	bh=ArWUw6uKt2yghFGqp2E1p2fxhgfr7jktAJfVc5O/ej8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K8rIguTbsmCLB5R8YMNrq+pi21VOrkrTor3xLgb3dJhKz77Wsuga8Hh/SUSPpG+1Hpl3zkhSmCvH4e7Qe5PQZCEN8qi0w5N5ysSG+1J+Z/I7rQStRFBPalAd5pVNUrcJJU38SOoVav/F/2iz3MdSZpFBMo0PTiy++NWvbFXrELc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+LX6t7S; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713874423; x=1745410423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ArWUw6uKt2yghFGqp2E1p2fxhgfr7jktAJfVc5O/ej8=;
  b=K+LX6t7SVpX2TVDcPuFstwfkK34WrL52gw3br0xZ5WglJb0CV5upEuOv
   571O4gheuCumKKUlqFRyBDW0W6MgsuhVQqSB37yo8xAXbs3WQSk+HGUGL
   yAZoTGdYt/kebOH4hS5Ae8fqO9fNlQDgaArL/kvbP38G45D1Rx2OAtYBL
   A3JuEqvTOKqV66kDWH7a3GKJtJzuBAKZKMQGg7GmfN6qICKTqPz1/TscW
   velNAduwIaNgGPiDwzMz8R07ihRPMgRegHKRG9iCAQDoWdf8LN2Cpm3/Z
   bon5nSMT+j9+ZpXpzOb+63Fj2MPgFAfA4Hnv8186f0auQbMEegiU0jv01
   g==;
X-CSE-ConnectionGUID: GuXjhNoBTQ+5mt0ZQIwt9A==
X-CSE-MsgGUID: wJswtA5YTKiSFXbrWDYNtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9307643"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9307643"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 05:13:31 -0700
X-CSE-ConnectionGUID: liVSNiqCTP6hqDIQ5KOxDg==
X-CSE-MsgGUID: Gtizr1bARWKmSVoJMgvv8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="55305704"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.225.183]) ([10.124.225.183])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2024 05:13:28 -0700
Message-ID: <01988152-c87b-4814-adc5-618e31fc035e@linux.intel.com>
Date: Tue, 23 Apr 2024 20:13:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 087/130] KVM: TDX: handle vcpu migration over logical
 processor
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <b9fe57ceeaabe650f0aecb21db56ef2b1456dcfe.1708933498.git.isaku.yamahata@intel.com>
 <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0c3efffa-8dd5-4231-8e90-e0241f058a20@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/13/2024 12:15 AM, Reinette Chatre wrote:
> Hi Isaku,
>
> On 2/26/2024 12:26 AM, isaku.yamahata@intel.com wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
> ...
>
>> @@ -218,6 +257,87 @@ static void tdx_reclaim_control_page(unsigned long td_page_pa)
>>   	free_page((unsigned long)__va(td_page_pa));
>>   }
>>   
>> +struct tdx_flush_vp_arg {
>> +	struct kvm_vcpu *vcpu;
>> +	u64 err;
>> +};
>> +
>> +static void tdx_flush_vp(void *arg_)
>> +{
>> +	struct tdx_flush_vp_arg *arg = arg_;
>> +	struct kvm_vcpu *vcpu = arg->vcpu;
>> +	u64 err;
>> +
>> +	arg->err = 0;
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	/* Task migration can race with CPU offlining. */
>> +	if (unlikely(vcpu->cpu != raw_smp_processor_id()))
>> +		return;
>> +
>> +	/*
>> +	 * No need to do TDH_VP_FLUSH if the vCPU hasn't been initialized.  The
>> +	 * list tracking still needs to be updated so that it's correct if/when
>> +	 * the vCPU does get initialized.
>> +	 */
>> +	if (is_td_vcpu_created(to_tdx(vcpu))) {
>> +		/*
>> +		 * No need to retry.  TDX Resources needed for TDH.VP.FLUSH are,
>> +		 * TDVPR as exclusive, TDR as shared, and TDCS as shared.  This
>> +		 * vp flush function is called when destructing vcpu/TD or vcpu
>> +		 * migration.  No other thread uses TDVPR in those cases.
>> +		 */
Is it possible that other thread uses TDR or TDCS as exclusive?

>>


