Return-Path: <kvm+bounces-69667-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPAFKYI8fGkXLgIAu9opvQ
	(envelope-from <kvm+bounces-69667-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:07:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6481EB7306
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B30A63015896
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19D83346A5;
	Fri, 30 Jan 2026 05:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lU7NoxE7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DDC2F7468;
	Fri, 30 Jan 2026 05:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769749622; cv=none; b=ENzzFsPLO+Lr59ejzkeImVq3Wf+HVp6zoiz2jly1QxILhtfs16FKKQQPerIyYqG3E89shhrzAOf6QUpWUKETII9ThdVuQHxiJySoKBgt2zUAp8Ccf4+zSK2kiPd+WYArNtIuM/JPheltlvUGMHQ+3sflnxuEOUK6oGDs7WvmlIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769749622; c=relaxed/simple;
	bh=NJqIde6aEff1nOWpd3liyCuz1VExEkEigsoV5duKsjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2ON3HYgwCKIaI98YaSiuKAo4kWeDx602ZgUlwPlOVO10RRGFRPNjsFBDrQLDVW79a3Gj+0umwDhxMRdUwVyf34UTj6cDsTQ8ago+ZrVbeE3lIiqL4avV4L9Ih3JldazHQtDJsZeBzhfud3MTYhFa48SuvUSGHstA09Lw2StJu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lU7NoxE7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769749620; x=1801285620;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NJqIde6aEff1nOWpd3liyCuz1VExEkEigsoV5duKsjk=;
  b=lU7NoxE73FcXpifvB7Dcym7cLmSCuDabqjqfdC701ftyGScPezkE7ntq
   LOY+pfeYPo17T0YgdXWCg2k5C7CMeNNiRErxZI7IjhzYxUUQ/HLilkkj3
   32YIyrG8wqOk93g+BoheDpMo2Q96ytn4vWFRvWxC6kYikPhE4inPuP8XG
   Tnw0DPENXsm7/r2zr0YTSSpgULcvxZfJIlr2UZeAKqU8A+c3dmgY1tAeR
   RomNg6jc6KKjh4oztCcRq/NvGYPEs5t+B/v4IvjYVScTr643quQlFcArx
   XKtEGPEu8GktmkXevOZVJZf5c0RBbnxW6+LdVsbxtS9AxH5gtnmlTlroN
   g==;
X-CSE-ConnectionGUID: xnl9IQ6JQ8uX8LCg+iX5lg==
X-CSE-MsgGUID: oMGT8xgRS5SA2v6p7xRzPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="93657204"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="93657204"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 21:06:59 -0800
X-CSE-ConnectionGUID: bXozd89WQveo1jsTDMdQmg==
X-CSE-MsgGUID: D1QbWXANTf63Byvvu1B1NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="213666601"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 21:06:56 -0800
Message-ID: <ccad59aa-d1b0-475a-a838-e705d7dc446a@linux.intel.com>
Date: Fri, 30 Jan 2026 13:06:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from
 {svm,vmx}_set_cpu_caps()
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
 John Allen <john.allen@amd.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-2-seanjc@google.com>
 <9856fb02-b72a-4626-b34a-16a7adb55fc6@linux.intel.com>
 <e4e52215-3160-4f67-877b-16b9d6cba210@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <e4e52215-3160-4f67-877b-16b9d6cba210@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69667-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6481EB7306
X-Rspamd-Action: no action



On 1/30/2026 11:23 AM, Xiaoyao Li wrote:
> On 1/29/2026 3:34 PM, Binbin Wu wrote:
>>
>>
>> On 1/28/2026 9:43 AM, Sean Christopherson wrote:
>>> Explicitly configure KVM's supported XSS as part of each vendor's setup
>>> flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
>>> to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
>>> VMX is enabled, i.e. when nested=1.  The late clearing results in
>>> nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
>>> when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
>>> ultimately leading to a mismatched VMCS config due to the reference config
>>> having the CET bits set, but every CPU's "local" config having the bits
>>> cleared.
>>
>> A bit confuse about the description.
>>
>> Before this patch:
>>
>> kvm_x86_vendor_init
>> | vmx_hardware_setup
>> |   nested_vmx_hardware_setup
>> |     nested_vmx_setup_ctls_msrs
>> | ...
>> | for_each_online_cpu(cpu)
>> |   smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1)
>> |                                 | kvm_x86_check_processor_compatibility
>> |                                 |   kvm_x86_call(check_processor_compatibility)()
>> |                                 |     vmx_check_processor_compatibility
>> |                                 |       setup_vmcs_config
>> |                                 |         nested_vmx_setup_ctls_msrs
>> | ...
>> | //late clearing of SHSTK and IBT
>>
>> If we don't consider CPU hotplug case, both the setup of reference VMCS and the
>> local config are before the late clearing of SHSTK and IBT. They should be
>> consistent.
>>
>> So you are referring the mismatch situation during CPU hotplug?
> 
> I guess it's triggered the path
> 
>   kvm_init()
>     kvm_init_virtualization()
>       kvm_enable_virtualization()
>         cpuhp_setup_state()
>           kvm_online_cpu()
>             ...
> 
>   (note, it requires enable_virt_at_load to be true)
> 
> which is after
>   vmx_init()
>     kvm_x86_vendor_init()
> 

Oh, right.
Forgot about that by default KVM enables virtualization when KVM is loaded,
which trigger the cpuhp framework to do per-CPU enabling.

Thanks!


