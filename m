Return-Path: <kvm+bounces-15211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAEF8AAA36
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3B51C2247D
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 08:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C825EE8D;
	Fri, 19 Apr 2024 08:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnEdvGUT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4925A51004;
	Fri, 19 Apr 2024 08:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515522; cv=none; b=fcCCuT2s7BktlZ/85hKxvd+GsVy+C+b3pSiGibl/cBb1CztHgRWVOfuT4XsFk+UyEGrPZOvMReTSesMk9HYs+UAWSXUSLDJW9PB9btdRkEQg2OFWsNVmqEO8VB+lLpEzfJ4Ydt60Gfjj1kVBxv1qQTCCXXJpc0td7LjlZMXzqmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515522; c=relaxed/simple;
	bh=OMlxlvn+v5dCEZSvtMC2q0m9aDtCxxSWRWfi6Q60WDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DAxbuGTnGeaMs2Qx4E3onNdwpKyfvlawThPuotr2N8/84oap4JHcd6IxPvtkrwbT0VSISdKt8TjlGHGFmBwRtU2oXH4sWTqQHm1ouqxDTvh8Dxig6FtvhAA8n5TmHUlWEPsDpp6qJJZKoeZYTGbuGFMErlvLu8LXHZPjyrS7chI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnEdvGUT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713515520; x=1745051520;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OMlxlvn+v5dCEZSvtMC2q0m9aDtCxxSWRWfi6Q60WDI=;
  b=QnEdvGUTvXx+TasWS5yl5BwC+U63qV31oeCwRzaRCs8L2VkpetD5zCB9
   eDHWSSrTyaeCoQmIR8WaR7FU2UDU0QEfBrv8r2RxfU+/wvEH17u4ScruY
   PTi5ANlhFSvinc8lcrM6TCcI+Rip82aozTDxIUGhoOnIp/yp9xxSrBdvk
   EIooke72wkPKW1+9VjSbO55xN/eQDkG6rGqUrAvPn14NvBOnjGZdEdv/6
   /Do9//Q7vnIsYn9kRCpZke64BtuK2sabweL+TUq039NgmMBWrWyM3hFKb
   1MPFbjfh7tP4KV7wcses9v51V9vV7O3m6Z6LF1+ZiyFMkglxVR8TrrHXW
   w==;
X-CSE-ConnectionGUID: 2m0tbYkvReiBnc6TCVEoiA==
X-CSE-MsgGUID: VI0OBgVgThaqOfr9rMn7cA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="34504727"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="34504727"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 01:31:59 -0700
X-CSE-ConnectionGUID: 2soE2fBTS2KGUANzz0HUNA==
X-CSE-MsgGUID: GWW+RnrQTpeAm04mCQohjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23338204"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.225.183]) ([10.124.225.183])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 01:31:56 -0700
Message-ID: <7c71c294-8ce4-4f13-b827-d16a8811739a@linux.intel.com>
Date: Fri, 19 Apr 2024 16:31:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 117/130] KVM: TDX: Silently ignore INIT/SIPI
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <4a4225de42be0f7568c5ecb5c22f2029f8e91d62.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The TDX module API doesn't provide API for VMM to inject INIT IPI and SIPI.
> Instead it defines the different protocols to boot application processors.
> Ignore INIT and SIPI events for the TDX guest.
>
> There are two options. 1) (silently) ignore INIT/SIPI request or 2) return
> error to guest TDs somehow.  Given that TDX guest is paravirtualized to
> boot AP, the option 1 is chosen for simplicity.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
[...]
> +
> +static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu)) {
> +		/* TDX doesn't support INIT.  Ignore INIT event */
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
Why change the mp_state to KVM_MP_STATE_RUNNABLE here?

And I am not sure whether we can say the INIT event is ignored since 
mp_state could be modified.

> +		return;
> +	}
> +
> +	kvm_vcpu_deliver_init(vcpu);
> +}
> +

