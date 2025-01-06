Return-Path: <kvm+bounces-34574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93374A01D47
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 03:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0618F3A3597
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 02:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E06F78F46;
	Mon,  6 Jan 2025 02:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tmecjr9Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5EA4206E;
	Mon,  6 Jan 2025 02:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736129928; cv=none; b=ggPPvoeYcwP+ykYZZBO4XeYG6cW5xxCEe0NLG8VZDrXnnC3X2caGrv99AzRhywNajGmyrzy64Yn9yo+iQ0Qo7b9b5FmJzD1wsOyOdjwmTow1OLabGL6A4IHcx9VJJYD8Yr2/yE10k5A7IscfGPRramcOwXR+Yq/R/68NrgXdvms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736129928; c=relaxed/simple;
	bh=TDLA25HF20ow9vuFzExnUuFJwQ0y0m/M//u4rkjqGnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ui0mIgMm0KJKGdARbTD5xTeACriRPa4TIIScvKappadsTUcQsLHE0J40JqeMj9ZWTdOwjaLEY6ZZIYWMrD+JyHxky4OQnmQrri7LAhSpadlZYrROlkcz2bZQz6MofYxsOVXVKMJphEELZCr+MYQuikBD1bPSV9MF/FHt92jKy14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tmecjr9Q; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736129926; x=1767665926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TDLA25HF20ow9vuFzExnUuFJwQ0y0m/M//u4rkjqGnQ=;
  b=Tmecjr9QyZC0+lOx+lZ7BUmGwTg9hGGGvSj5q4NMczbsrNPCugzMBrx+
   cYXZtcXKcbKPyu9hOBjb2j8zTvZExrDLWo/Zr6kIpOgcO8eRlz4V/ULB9
   Sn8hjHBEE9WUR4Q0ao0wM9pJ8o97m5lAaLsdFnt28iP1tpv3T6U4YjkMp
   yU3GZyXR+bjWiYDhrGFs4tD5jATj1HCd3ZisJJ+CLFj9dFA5YxvsrQ1lx
   KUEBKxrcs1p43jTmvPZR9es12HPxbJnMUNYtVy98QFD/vtJaDy5NeNH+O
   qF30o9+tGe81enhVC5V5j5mkLNN5Eiw2+2UgDcae9gTd9TGb8q2Cq+ULx
   g==;
X-CSE-ConnectionGUID: V66DoPN6Tg6/nXw+cJcm/g==
X-CSE-MsgGUID: 8iGygUu0RJ2LbCnPx0vl3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="36387992"
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="36387992"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:18:46 -0800
X-CSE-ConnectionGUID: 7dEtBfVSQMu7ljuNTBc7MA==
X-CSE-MsgGUID: UACoyiFJTU+1w75KKvEdjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="107283200"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 18:18:44 -0800
Message-ID: <7416f775-9859-4148-acbf-875dbb9db108@linux.intel.com>
Date: Mon, 6 Jan 2025 10:18:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] KVM: TDX: Add methods to ignore virtual apic
 related operation
To: Vishal Annapurve <vannapurve@google.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com, linux-kernel@vger.kernel.org
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
 <20241209010734.3543481-14-binbin.wu@linux.intel.com>
 <CAGtprH98GkZuFgJ6ZFTFUv2Bqzow9yw7WCd7TAyKPUe=2iqfbg@mail.gmail.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <CAGtprH98GkZuFgJ6ZFTFUv2Bqzow9yw7WCd7TAyKPUe=2iqfbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/4/2025 6:04 AM, Vishal Annapurve wrote:
> On Sun, Dec 8, 2024 at 5:12 PM Binbin Wu <binbin.wu@linux.intel.com> wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>> ...
>> +}
>> +
>>   static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>>   {
>>          struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
>> @@ -236,6 +245,22 @@ static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>>          memset(pi->pir, 0, sizeof(pi->pir));
> Should this be a nop for TDX VMs? pre_state_restore could cause
> pending PIRs to get cleared as KVM doesn't have ability to sync them
> to vIRR in absence of access to the VAPIC page.
This callback is called by kvm_lapic_reset() and kvm_apic_set_state().
If it is call by kvm_lapic_reset(), it should be cleared.

If it is called by kvm_apic_set_state() when userspace want to setup the
lapic. It will be needed when live migration is enabled for TDX.
For VMX VM, the PIR is synced to vIRR and then the state will be sent to
destination VM.
For TDX guest, I am not sure the final solution to sync PIR from source to
destination TDX guest. I guess TDX module probably will do the job. Will
ask Intel guys to check what is the solution.
For this base series, TDX live migration is not supported yet, it is OK
to reset PIR for now.

>
>>   }
>>
>> +static void vt_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
>> +{
>> +       if (is_td_vcpu(vcpu))
>> +               return;
>> +
>> +       return vmx_hwapic_irr_update(vcpu, max_irr);
>> +}
>> +


