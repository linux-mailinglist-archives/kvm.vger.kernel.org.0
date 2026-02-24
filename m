Return-Path: <kvm+bounces-71580-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PrHE6sbnWmPMwQAu9opvQ
	(envelope-from <kvm+bounces-71580-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:31:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 801E618164B
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:31:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F58A3109642
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:31:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BDB29B799;
	Tue, 24 Feb 2026 03:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AWgfIiAB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DD86329;
	Tue, 24 Feb 2026 03:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771903872; cv=none; b=IrhqUCwf5rOe7IdOI9NVSXJUNj1ZZe8Fk8ej5He2dRQyU6l0nQMLQdmLAuylsBWuP1SQcFLJXaSwlO0CFW4CA3aWcLRlu83RInC2A93YMBsPfiHYZZLgqao2UFQlAVrE2UYAz1/shNKJY1yC/mUzq0PoXX3HE4iTXTjSeLexRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771903872; c=relaxed/simple;
	bh=d9XK4ozPZNMwwxms2Wj8OcWsauVAZO0gzXgbb385vF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBMUkS/sXNsYmr9mhLBQVsaoEfmqXadfA9w7g/r46cxgd2xBLXTNgatZyrYtdUGf8lX4/UpgNI8ninCk/5Gebb4+f7YjCicWF5McNsn2NUY1Cppn9Gqw4Fs+8ks+S0Pw/jlpWyL/WQu6YOdKl8zaG+9f5HYBgom+HetvgCWBpMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AWgfIiAB; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771903870; x=1803439870;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d9XK4ozPZNMwwxms2Wj8OcWsauVAZO0gzXgbb385vF4=;
  b=AWgfIiABUoSiYvr5wKbHDsInUd3ARCTit6MQovYac6pU6y6HMP5OXLwz
   IFej6i9CDGos1zl9raIhZCMqffDi4ujdOlnW2vQD1u+/x5U3HS5Q3R2KN
   2HFxGZp4hdfIqav6ktFVOvcsqg8G1YmZfQ6xg/LaxSGn4c8HfxvMVNiC7
   6b6h6v/u4ppHza6/yOfwVsCkio6W+W/lys/EaHEFqIuxs1NDCDKbza7yf
   /vn3BVDLnyX7jueJtxXyIowzDPQ83vfk0ilzNvvGXpDGVA8edSRGn9Ntp
   IhKktux1xVvw0DtDcKN7cwbIuKkCwbgz3qDINZ6ZwYye67BnqvCg4PvOq
   w==;
X-CSE-ConnectionGUID: odfRMZH1Sm66dcc4iMfaKA==
X-CSE-MsgGUID: 4YknXuzVSnmeQ1+/7BBO1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="90495212"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="90495212"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 19:31:10 -0800
X-CSE-ConnectionGUID: duJy0aM9QhOJUEr9iGmLyA==
X-CSE-MsgGUID: MwAB7YECREam9zuCxb+Krw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="220775057"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 19:31:08 -0800
Message-ID: <efc7e336-71b9-48c2-b1ad-d591283e7090@linux.intel.com>
Date: Tue, 24 Feb 2026 11:31:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: VMX: Fix a wrong MSR update in
 add_atomic_switch_msr()
To: Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
References: <20260220220216.389475-1-namhyung@kernel.org>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260220220216.389475-1-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71580-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dapeng1.mi@linux.intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 801E618164B
X-Rspamd-Action: no action


On 2/21/2026 6:02 AM, Namhyung Kim wrote:
> The previous change had a bug to update a guest MSR with a host value.
>
> Fixes: c3d6a7210a4de9096 ("KVM: VMX: Dedup code for adding MSR to VMCS's auto list")
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 967b58a8ab9d0d47..83d057cfa8164937 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1149,7 +1149,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	}
>  
>  	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
> -	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
> +	vmx_add_auto_msr(&m->host, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
>  }
>  
>  static bool update_transition_efer(struct vcpu_vmx *vmx)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



