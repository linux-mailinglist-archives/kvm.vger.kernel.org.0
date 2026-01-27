Return-Path: <kvm+bounces-69181-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOJXEFsMeGl3ngEAu9opvQ
	(envelope-from <kvm+bounces-69181-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 01:52:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D2E978E8FA
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 01:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B394303E742
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 00:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 434951DE885;
	Tue, 27 Jan 2026 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g8PJqFlG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70DA1FBCA7
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 00:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769475118; cv=none; b=JNirR1iJrsOvSitoZuNa2iNtKYZHToOKxw/kBN28gUccCsrYgjtrswvg/JAPM57idJqIC3zCwlm+HotdY2Tx/+fTlv9q3fRaPeow8/gCd4S0S6FHA6em59niqX5eVn5Cuht6kLAxP4xzXNFvmXPBH632wss9MOOB6LVGYVwmc/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769475118; c=relaxed/simple;
	bh=I6OExhxIcNLlStXJ5kiGKT7tztrdSo0ZxELweFX2xfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZk6F8VIdJtON74KQoI8BZaj1+NfiD6cygb93LKOucPMghJz7/vz6/BzCPbDG04/ObBg46+JqwVmqvetJenUJzaUTKoL99klOYHgn7Zm/b1MQr5CQx/jBRMh4b/2yo6eWNSJS79rEJQVTUIXZXxEE2VZv1xSsErfD7MJMSKJ9hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g8PJqFlG; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769475116; x=1801011116;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I6OExhxIcNLlStXJ5kiGKT7tztrdSo0ZxELweFX2xfM=;
  b=g8PJqFlGMxf5v2UyEuAhTl8u6fT5BjhDHi9XrcsgpbV8i6FIebJHucYF
   P32w7B74FwB+1ZjjuE5ZTOgh9prKCImzl+REPLJzsDQq01+3BBYfU6bVA
   /rN3ixD5CLLZ0qCpo+EdRYTmDP41dow9gSKIv7wl0OtRqZcYs8OUYBdGu
   7IVUADbdtAfUUqCNr3yIE8M6wELSZ/TEKWHpHP9ZeX00Yjm07LDpr19HQ
   Q8xYCbJ6V/QtFl98u6Sezw+04YKbVXeXMeVWnpa7mxRCKZcW0xhHLaM2H
   y8qpf3uLC8eMhdPYouY5NNONsbuLQIogJ434qiHVCmOfnK2If+xzR7wwf
   A==;
X-CSE-ConnectionGUID: diHyJSWZTGGJP0GawtwLrA==
X-CSE-MsgGUID: D3yYaPNtRzOgOuNhVIyvkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="96124495"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="96124495"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:51:43 -0800
X-CSE-ConnectionGUID: VlMUTeDeSlq/IXjX0+lcnA==
X-CSE-MsgGUID: /zPiqImpRxumy2tvS5svGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207059752"
Received: from unknown (HELO [10.241.241.152]) ([10.241.241.152])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:51:43 -0800
Message-ID: <9341ede2-9449-4f33-a387-c4a9c82a0037@intel.com>
Date: Mon, 26 Jan 2026 16:51:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] target/i386: Make some PEBS features user-visible
To: Zhao Liu <zhao1.liu@intel.com>, "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>, xiaoyao.li@intel.com,
 Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-7-zide.chen@intel.com>
 <56dd6056-e3e2-46cd-9426-87c7889bed49@linux.intel.com>
 <513c6944-b80a-46f2-ad6c-4de77dac4b09@intel.com> <aXXWhqUuPQaxDKCV@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <aXXWhqUuPQaxDKCV@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69181-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D2E978E8FA
X-Rspamd-Action: no action



On 1/25/2026 12:38 AM, Zhao Liu wrote:
> Hi Zide & Dapeng,
> 
>> On 1/18/2026 7:30 PM, Mi, Dapeng wrote:
>>>
>>> On 1/17/2026 9:10 AM, Zide Chen wrote:
>>>> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
>>>> the corresponding bits user-visible CPU feature knobs, allowing them to
>>>> be explicitly enabled or disabled via -cpu +/-<feature>.
>>>>
>>>> Once named, these bits become part of the guest CPU configuration
>>>> contract.  If a VM is configured with such a feature enabled, migration
>>>> to a destination that does not support the feature may fail, as the
>>>> destination cannot honor the guest-visible CPU model.
>>>>
>>>> The PEBS_FMT bits are intentionally not exposed. They are not meaningful
>>>> as user-visible features, and QEMU registers CPU features as boolean
>>>> QOM properties, which makes them unsuitable for representing and
>>>> checking numeric capabilities.
>>>
>>> Currently KVM supports user space sets PEBS_FMT (see vmx_set_msr()), but
>>> just requires the guest PEBS_FMT is identical with host PEBS_FMT.
>>
>> My mistake — this is indeed problematic.
>>
>> There are four possible ways to expose pebs_fmt to the guest when
>> cpu->migratable = true:
>>
>> 1. Add a pebs_fmt option similar to lbr_fmt.
>> This may work, but is not user-friendly and adds unnecessary complexity.
>>
>> 2. Set feat_names[8] = feat_names[9] = ... = "pebs-fmt".
>> This violates the implicit rule that feat_names[] entries should be
>> unique, and target/i386 does not support numeric features.
>>
>> 3. Use feat_names[8..11] = "pebs-fmt[1/2/3/4]".
>> This has two issues:
>> - It exposes pebs-fmt[1/2/3/4] as independent features, which is
>> semantically incorrect.
>> - Migration may fail incorrectly; e.g., migrating from pebs_fmt=2 to a
>> more capable host (pebs_fmt=4) would be reported as missing pebs-fmt2.
> 
> For 2) & 3), I think if it's necessary, maybe it's time to re-consider
> the previous multi-bits property:
> 
> https://lore.kernel.org/qemu-devel/20230106083826.5384-4-lei4.wang@intel.com/

I think the multi-bit property may be a better approach (which I
previously referred to as “numeric features”).

As Igor pointed out, this would involve an infrastructure change, so I
am hesitant to pursue it at this time.


> But as for now, I think 1) is also okay. Since lbr-fmt seems very
> similar to pebs-fmt, it's best to have them handle these fmt things in a
> similar manner, otherwise it can make code maintenance troublesome.
Yes, it works. Will post V2 with this approach.

>> Given this, I propose the below changes. This may allow migration to a
>> less capable destination, which is not ideal, but it avoids false
>> “missing feature” bug and preserves the expectation that ensuring
>> destination compatibility is the responsibility of the management
>> application or the user.
>>
>> BTW, I am not proposing a generic “x86 CPU numeric feature” mechanism at
>> this time, as it is unclear whether lbr_fmt and pebs_fmt alone justify
>> such a change.
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 015ba3fc9c7b..b6c95d5ceb31 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1629,6 +1629,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>          .msr = {
>>              .index = MSR_IA32_PERF_CAPABILITIES,
>>          },
>> +       .migratable_flags = PERF_CAP_PEBS_FMT,
> 
> About the migration issue, I wonder whether it's necessary to migrate
> pebs-fmt? IIUC, it seems not necessary: the guest's pebs-fmt depends on
> host's pebs-fmt, but I'm sure what will happens when guest migrates to
> a mahince with different pebs-fmt.
> 
> note, lbr-fmt seems not be migrated.
For a migratable feature, it's related state should be fully captured in
the VM migration stream.  Both the LBR and PEBS states are serialized
via vmstate, so it may not be wrong to call labr/pebs_fmt a migratable
feature.

However, QEMU must provide means—either to external management
applications via QOM properties or to users via command-line options—to
ensure that the destination machine supports all features enabled on the
source. The current migratable_flags proposal does not address this.

My original intention was to treat this as a workaround.


> Thanks,
> Zhao
> 


