Return-Path: <kvm+bounces-30954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0C19BEFA2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D5391C248B8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 13:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2BD201029;
	Wed,  6 Nov 2024 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="im+CynPU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F373200CB4
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730901464; cv=none; b=DW6hR6Dmqh4+lrs0L9lBW3gI/2EZAYp2AYdWT+KMqkkfanjcM4MZHN1nd/LZIjDcE1GU/tulQdvEx0HcZ8xzPsdZeI5d2TrZ/2H853aGX3oJhFFqy3Vdo6BpBDCfb5GMgOKiKUlf+zSR4hJAhcGR17tz3fFf568AnzLr4D9TUcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730901464; c=relaxed/simple;
	bh=zwAC45OJhmnmO548e21DRwBu5ZsdXTpXh46ezboPAA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gUKWfUuHEmfjJEvWlDCjhdpgJDpNrH4AmEbXlSQIk/E8ceCCTMcQS3ndIcRXNgC1COcuWfkdJqQZ//CIHgr2r1nC2UWgdDrhkCeUzSS79CSZtHfl2S/yUGAKok2eIgaCbij1Iy+fOJ/AdL6NjzMS46+h/CEnIPB0hIc+C4tgeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=im+CynPU; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730901463; x=1762437463;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zwAC45OJhmnmO548e21DRwBu5ZsdXTpXh46ezboPAA0=;
  b=im+CynPUSOgwsxNBS7TKEXPkuA31BFddoYuNcNDKKzkPQDmCCScyGM6F
   IFlwldWCWu+M0RbPIQAGK4tNfE893FuxCEtp7h6XBvpDmqYR+Hck+Hoal
   YxWg7u9+bbbPtkbwrg+5n3sN/Vf/lOOKT+lg0vHsR3otG+vsRcHv4pf0m
   wrcI+kw6hLaq9NhtYP4jtenJiP+Gey7cUnjG+PDAwJUWD3KoxrzzvHieD
   99mktK0susjdvHDOv6IERpniBhAAIiyPqPtHTdctulOLHFwB+WIgDSAOP
   iba+tvXneKuNx4rug4BwZ5/NcAGegZ6CKeZMEC/3YmeEAIyWjH6GYcKyE
   w==;
X-CSE-ConnectionGUID: 3QgDdi36ShyjX/02f1JZFA==
X-CSE-MsgGUID: 8+DkHHswSeudOfFRPza1kw==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="30812700"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30812700"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 05:57:41 -0800
X-CSE-ConnectionGUID: 9/wVuzWVSm+bO4Sl9QL7Gw==
X-CSE-MsgGUID: o/0fKsyyQkKtzT+HyjzVuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84680014"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 05:57:35 -0800
Message-ID: <35233d1f-eb6c-4882-abd6-884c1f559e12@intel.com>
Date: Wed, 6 Nov 2024 21:57:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 45/60] i386/tdx: Don't get/put guest state for TDX VMs
To: Paolo Bonzini <pbonzini@redhat.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-46-xiaoyao.li@intel.com>
 <8cd78103-5f49-4cbd-814d-a03a82a59231@redhat.com>
 <e5d02d7f-a989-4484-b0c1-3d7ac804ec73@intel.com>
 <a90e29a6-0e07-46a3-8dfc-658e02af9856@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <a90e29a6-0e07-46a3-8dfc-658e02af9856@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/5/2024 10:23 PM, Paolo Bonzini wrote:
> On 11/5/24 12:25, Xiaoyao Li wrote:
>> On 11/5/2024 5:55 PM, Paolo Bonzini wrote:
>>> On 11/5/24 07:23, Xiaoyao Li wrote:
>>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>>
>>>> Don't get/put state of TDX VMs since accessing/mutating guest state of
>>>> production TDs is not supported.
>>>>
>>>> Note, it will be allowed for a debug TD. Corresponding support will be
>>>> introduced when debug TD support is implemented in the future.
>>>>
>>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>>>
>>> This should be unnecessary now that QEMU has 
>>> kvm_mark_guest_state_protected().
>>
>> Reverting this patch, we get:
>>
>> tdx: tdx: error: failed to set MSR 0x174 to 0x0
>> tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
>> kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
>> error: failed to set MSR 0x174 to 0x0
>> tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
>> kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> Difficult to "debug" without even a backtrace, but you might be calling 
> kvm_mark_guest_state_protected() too late.  For SNP, the entry values of 
> the registers are customizable, for TDX they're not.  So for TDX I think 
> it should be called even before realize completes, whereas SNP only 
> calls it on the first transition to RUNNING.

TDX calls kvm_mark_guest_state_protected() very early in
   kvm_arch_init() -> tdx_kvm_init()

I find the call site. It's caused by kvm_arch_put_register() called in 
kvm_cpu_exec() because cpu->vcpu_dirty is set to true in kvm_create_vcpu().

Maybe we can do something like below?

8<<<<<<<<<<<<<<<<<<<<<<<<<<<<
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -457,7 +457,9 @@ int kvm_create_vcpu(CPUState *cpu)

      cpu->kvm_fd = kvm_fd;
      cpu->kvm_state = s;
-    cpu->vcpu_dirty = true;
+    if (!s->guest_state_protected) {
+        cpu->vcpu_dirty = true;
+    }
      cpu->dirty_pages = 0;
      cpu->throttle_us_per_full = 0;

> Paolo
> 


