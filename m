Return-Path: <kvm+bounces-56398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEE9B3D81F
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 06:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A48017A6826
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 04:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3919E223DCE;
	Mon,  1 Sep 2025 04:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O329Z6QZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F52126C1E;
	Mon,  1 Sep 2025 04:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756699998; cv=none; b=aevkGyOpIRuhIDnz3hGs/yl5v3bwu0G+0wX29YejikHJbD8Be1/pbJ6yEJH67jxhBluVdcbs/5JidCCJmNuHXH+BdmLDYCS+vntBrFN6tFgWf2VnSxOGfDWowj+yQQrUyPCaDeLFiSSfasr6qWgimOCbU9GPan1EgODvahD+1lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756699998; c=relaxed/simple;
	bh=uC/21i4ExHUt9++DdUGF9xD+rh0VZ2vJiYUmeMoSi+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J5car6SM6Dhpxg5hJSgDex9cB3Ev2uj6tYoPx1TT809oiGoQ/Nhy1Yb5MqH/mUEnwHZc/KWIbQjwTdySnyz9C4HP635Iri2trGHqMEoNH79MGO0bxs9kurouiawzFcpFOzQmexG0qOcBlNDmOicUZkP819ZJPNRepXEsZdK9URE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O329Z6QZ; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756699996; x=1788235996;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uC/21i4ExHUt9++DdUGF9xD+rh0VZ2vJiYUmeMoSi+E=;
  b=O329Z6QZVgpZeZqeJMcv8x4fAS29UGeG6MwP4bjehLPrcPtoRQXTuGho
   ICONUxVHdsAT2s/ns/voFm4gMUOeDwSURzUM57WFhiUTcCuPALpnUc5As
   mBXnJPSBHgtZy8B28b53+OoWF9skD0T5KdMSxQh7mhuWy7sIrEz0pitI7
   4OKcnrK0vh7joRXAzJibRtVJozj/EDyluBfXQgvFrkwuj/y+i5xVT4FHm
   SEccs5on5TpsaCeExUyoJBtoowJEilyW+NIafFqO+LGZI2OQ+yOPWdpuL
   tVderkUvx4kcIL9V+QTnOfOPW3rPjKROjuRMB1DXKU9cCfIg1dyrva8Eo
   Q==;
X-CSE-ConnectionGUID: 6EDRKTNuSamgh2tFCowsXg==
X-CSE-MsgGUID: gfWNXGb5TLO46L82g04oAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="58824706"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="58824706"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:13:16 -0700
X-CSE-ConnectionGUID: rfzeSTR6Sy6VuFmUnNQYFw==
X-CSE-MsgGUID: LCjn1WRDTzGvsNcJZiOE+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="194545963"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 21:13:14 -0700
Message-ID: <424e2aaa-04df-4c7e-a7f9-c95f554bd847@intel.com>
Date: Mon, 1 Sep 2025 12:13:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] KVM: x86: Add support for RDMSR/WRMSRNS w/
 immediate on Intel
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
References: <20250805202224.1475590-1-seanjc@google.com>
 <20250805202224.1475590-5-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250805202224.1475590-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/2025 4:22 AM, Sean Christopherson wrote:
> +static int handle_rdmsr_imm(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_emulate_rdmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
> +				     vmx_get_msr_imm_reg(vcpu));
> +}
> +
> +static int handle_wrmsr_imm(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_emulate_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
> +				     vmx_get_msr_imm_reg(vcpu));
> +}

We need to inject #UD for !guest_cpu_has(X86_FEATURE_MSR_IMM)

