Return-Path: <kvm+bounces-35274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3903A0B231
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 10:03:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 076ED163A9A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 09:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81CE32397AA;
	Mon, 13 Jan 2025 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6ZO+Y9l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF3234998;
	Mon, 13 Jan 2025 09:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736758879; cv=none; b=UgO8U5dIR44o6b8lH6JbMTkqFHr8yMDhCQjVTJP/NOlVbUoS1h0W3uecnEoQlRKMjd4gVVQQ5eYQZN00XNCb+6w9rIPMdmDfm32jOcFrp1uLnI0rTrGdoP/LoPWihF+YZJnLjUoomPXZDHE7oNxq18ijMlWbwcHgCtjthydVayI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736758879; c=relaxed/simple;
	bh=GjpsjNBlCIvWjfSOKHK63am7WrBnSESbIOn/HxwUlNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rvG+axPFw1KK78yh44Q29KTLKAYY1TKcziVFIFJSLtHWjvUfKh/JCDcqTfaFHQ9Ms9WuVNwniTR+jwKdg66qmdmAo7DQitatdqyfEquTZpxV4ArYhb6M3bxrKs7Liiz2P+KrAqBqiIrtWnYMBcaH0kf5U1T/p4zNwBAYKWSvR00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6ZO+Y9l; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736758878; x=1768294878;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GjpsjNBlCIvWjfSOKHK63am7WrBnSESbIOn/HxwUlNw=;
  b=W6ZO+Y9lJtZyVEG7tKobQL5pcGpxhAHf4b2ZD/wUB/GP6jJAN1V7Tgnt
   3L8CrgkLAjHPFubuCiJWZM79SHKS4iJ2Mf3n/FIfUaNuQtrp2fu1pTi36
   d4Jb6mLjCxK3SCVBC2YYWb6zD6hvy5v4spQgXaupUAfVCsklJa5RR5P+q
   glPpcGu48fga2IVTh7NWezjNK5rIJWEF5hV53R5Ti6Zy3Fibu+4DqCscU
   IOq2pOBRWPU8+31UX+C/E6TJZqvkG1R5Lyb39GM/HigylAtm/3OR4920s
   GoN90T8kzuxbPxa7v+2qSQrbitVnK3tUlXcnKtCOFx5vgc071UbbBG4pH
   g==;
X-CSE-ConnectionGUID: ID/dxWeST/Gf+FfNkbOLWg==
X-CSE-MsgGUID: PEnDp7cFS3epfO9WgVXXxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="40684252"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="40684252"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 01:01:17 -0800
X-CSE-ConnectionGUID: MAr8JHcoQGOpnWk/c3wvbw==
X-CSE-MsgGUID: dQcu4Sj3RBa4cQc9Tnhosg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104923153"
Received: from unknown (HELO [10.238.1.62]) ([10.238.1.62])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 01:01:15 -0800
Message-ID: <f333d871-f579-4579-86a6-58030b9f024b@linux.intel.com>
Date: Mon, 13 Jan 2025 17:01:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
To: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman
 <mpe@ellerman.id.au>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20250111012450.1262638-1-seanjc@google.com>
 <20250111012450.1262638-4-seanjc@google.com> <Z4R12HOD1o8ETYzm@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z4R12HOD1o8ETYzm@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 1/13/2025 10:09 AM, Chao Gao wrote:
> On Fri, Jan 10, 2025 at 05:24:48PM -0800, Sean Christopherson wrote:
>> Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
>> that KVM_RUN needs to be re-executed prior to save/restore in order to
>> complete the instruction/operation that triggered the userspace exit.
>>
>> KVM's current approach of adding notes in the Documentation is beyond
>> brittle, e.g. there is at least one known case where a KVM developer added
>> a new userspace exit type, and then that same developer forgot to handle
>> completion when adding userspace support.
> This answers one question I had:
> https://lore.kernel.org/kvm/Z1bmUCEdoZ87wIMn@intel.com/
In current QEMU code, it always returns back to KVM via KVM_RUN after it
successfully handled a KVM exit reason, no matter what the exit reason is.
The complete_userspace_io() callback will be called if it has been setup.
So if a new kvm exit reason is added in QEMU, it seems QEMU doesn't need
special handing to make the complete_userspace_io() callback be called.

However, QEMU is not the only userspace VMM that supports KVM, it makes
sense to make the solution generic and clear for different userspace VMMs.

Regarding the support of MapGPA for TDX when live migration is considered,
since a big range will be split into 2MB chunks, in order the status is
right after TD live migration, it needs to set the return code to retry
with the next_gpa in the complete_userspace_io() callback if vcpu->wants_to_run
is false or vcpu->run->immediate_exit__unsafe is set, otherwise, TDX guest
will see return code as successful and think the whole range has been converted
successfully.

@@ -1093,7 +1093,8 @@ static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
          * immediately after STI or MOV/POP SS.
          */
         if (pi_has_pending_interrupt(vcpu) ||
-           kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending) {
+           kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending ||
+           !vcpu->wants_to_run) {
                 tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
                 tdx->vp_enter_args.r11 = tdx->map_gpa_next;
                 return 1;

Of course, it can be addressed later when TD live migration is supported.


>
> So, it is the VMM's (i.e., QEMU's) responsibility to re-execute KVM_RUN in this
> case.
>
> Btw, can this flag be used to address the issue [*] with steal time accounting?
> We can set the new flag for each vCPU in the PM notifier and we need to change
> the re-execution to handle steal time accounting (not just IO completion).
>
> [*]: https://lore.kernel.org/kvm/Z36XJl1OAahVkxhl@google.com/
>
> one nit below,
>
>> --- a/arch/x86/include/uapi/asm/kvm.h
>> +++ b/arch/x86/include/uapi/asm/kvm.h
>> @@ -104,9 +104,10 @@ struct kvm_ioapic_state {
>> #define KVM_IRQCHIP_IOAPIC       2
>> #define KVM_NR_IRQCHIPS          3
>>
>> -#define KVM_RUN_X86_SMM		 (1 << 0)
>> -#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
>> -#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
>> +#define KVM_RUN_X86_SMM			(1 << 0)
>> +#define KVM_RUN_X86_BUS_LOCK		(1 << 1)
>> +#define KVM_RUN_X86_GUEST_MODE		(1 << 2)
>> +#define KVM_RUN_X86_NEEDS_COMPLETION	(1 << 2)
> This X86_NEEDS_COMPLETION should be dropped. It is never used.
>


