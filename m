Return-Path: <kvm+bounces-30466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B56D9BAEF2
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 980C9B21438
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC011AAE30;
	Mon,  4 Nov 2024 09:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUbNrMjF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6851823AB;
	Mon,  4 Nov 2024 09:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730711021; cv=none; b=IlnY1nc5QEuBZ8SQ8VryRQu67PhLniU4Kp1yewp0s/BBwMnkQoR9T85tbMx9BVh6nU0nKstdFR97xLy4DJxt8L/Mlvm57FT/OcDh9QF1kOIxt1ajJDJu8k6Il1ERdEmplvtQX2FTxi4uU+MQ4ceGxifqmUql7GqnHoG9I0KSzPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730711021; c=relaxed/simple;
	bh=SGs6EJdQiqCeGX+vRL8+3qNu/fQ7GSWYyT6HHC957zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2fCxh0mUV3oNP6aQtXLsn6IktMHFIlen2jEIVERTwI33Tg7DQgZe2WVv5IqDH4jgRzyWRkh6m18q9OTTWV2i1UrUeqeRQMkAdFCxVRmn02XtClAac30gTnkhaeht/BHBV1RY/nWOLoDJ5Z0R91AtbNAbgETl42Jw2SmFQMAITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUbNrMjF; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730711019; x=1762247019;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SGs6EJdQiqCeGX+vRL8+3qNu/fQ7GSWYyT6HHC957zA=;
  b=mUbNrMjFQArQe3wrr6+jlnDIiE+lJD5Rmlg6DeR7+yYAZQbYO8cY+L4U
   dUJfeMNs3yKQAYPRZ6orcbReIwvu1tR2JKndT7GVRmUEFnHvzREhiYw9N
   qFoyXQDKx6cb/hSxXhUV8GIq/1M1oj585uepHnI8PlE/2FzDIBSkfKu2Y
   2oO7sU5PbWNOUKjAIR6/y41N5sbjRemBvxdqB++NQIeNH/3k4hNLf0a8x
   5p6Nu087SA94rGLlpZPL9M0EH9GSaXmx5eqCXbUjv1kFITtpXdtCQBSBN
   x2sADpgrorf+VfZ+3fIWf7+z/5iYxaKvNCrlJS3QJPjbJw33Q/63SD2j7
   g==;
X-CSE-ConnectionGUID: Wz/dR2ZCRn+yK2Y0OJjXZQ==
X-CSE-MsgGUID: rSWXovONTl+DjWNnD0/0pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="47904494"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="47904494"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 01:03:38 -0800
X-CSE-ConnectionGUID: R09q12jrR7CsMnCLZrWDIw==
X-CSE-MsgGUID: BfT10bsdSj65dhe1kAT8gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="84038475"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 01:03:36 -0800
Message-ID: <a441733d-1885-42f0-a046-2c8871c46d6b@linux.intel.com>
Date: Mon, 4 Nov 2024 17:03:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
 <ca1eab63d443c2c92c367cee418ae969ba90d6cd.camel@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ca1eab63d443c2c92c367cee418ae969ba90d6cd.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/2/2024 5:13 AM, Huang, Kai wrote:
> On Fri, 2024-11-01 at 09:39 -0700, Sean Christopherson wrote:
>> On Fri, Nov 01, 2024, Kai Huang wrote:
>>> On Thu, 2024-10-31 at 07:54 -0700, Sean Christopherson wrote:
>>>> On Thu, Oct 31, 2024, Kai Huang wrote:
>>>> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>>> -		/* MAP_GPA tosses the request to the user space. */
>>>> -		return 0;
>>>> +	r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
>>>> +	if (r <= r)
>>>> +		return r;
>>> ... should be:
>>>
>>> 	if (r <= 0)
>>> 		return r;
>>>
>>> ?
>>>
>>> Another option might be we move "set hypercall return value" code inside
>>> __kvm_emulate_hypercall().  So IIUC the reason to split
>>> __kvm_emulate_hypercall() out is for TDX, and while non-TDX uses RAX to carry
>>> the hypercall return value, TDX uses R10.
>>>
>>> We can additionally pass a "kvm_hypercall_set_ret_func" function pointer to
>>> __kvm_emulate_hypercall(), and invoke it inside.  Then we can change
>>> __kvm_emulate_hypercall() to return:
>>>      < 0 error,
>>>      ==0 return to userspace,
>>>      > 0 go back to guest.
>> Hmm, and the caller can still handle kvm_skip_emulated_instruction(), because the
>> return value is KVM's normal pattern.
>>
>> I like it!
>>
>> But, there's no need to pass a function pointer, KVM can write (and read) arbitrary
>> GPRs, it's just avoided in most cases so that the sanity checks and available/dirty
>> updates are elided.  For this code though, it's easy enough to keep kvm_rxx_read()
>> for getting values, and eating the overhead of a single GPR write is a perfectly
>> fine tradeoff for eliminating the return multiplexing.
>>
>> Lightly tested.  Assuming this works for TDX and passes testing, I'll post a
>> mini-series next week.
>>
>> --
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Fri, 1 Nov 2024 09:04:00 -0700
>> Subject: [PATCH] KVM: x86: Refactor __kvm_emulate_hypercall() to accept reg
>>   names, not values
>>
>> Rework __kvm_emulate_hypercall() to take the names of input and output
>> (guest return value) registers, as opposed to taking the input values and
>> returning the output value.  As part of the refactor, change the actual
>> return value from __kvm_emulate_hypercall() to be KVM's de facto standard
>> of '0' == exit to userspace, '1' == resume guest, and -errno == failure.
>>
>> Using the return value for KVM's control flow eliminates the multiplexed
>> return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only that hypercall)
>> means "exit to userspace".
>>
>> Use the direct GPR accessors to read values to avoid the pointless marking
>> of the registers as available, but use kvm_register_write_raw() for the
>> guest return value so that the innermost helper doesn't need to multiplex
>> its return value.  Using the generic kvm_register_write_raw() adds very
>> minimal overhead, so as a one-off in a relatively slow path it's well
>> worth the code simplification.
> Ah right :-)
>
>> Suggested-by: Kai Huang <kai.huang@intel.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
> I think Binbin can help to test on TDX, and assuming it works,
I tried to add a selftest case to do memory conversion via kvm hypercall
directly for TDX.  And found TDX code didn't handle the return value for
the hypercall properly.

I tried to add a parameter to pass the cui callback as mentioned in
https://lore.kernel.org/lkml/f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com/
And then, made the following change in TDX code to make it work.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cd27ebd3d7d1..efa434c6547d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1072,6 +1072,15 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
         return 0;
  }

+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+       u64 ret = vcpu->run->hypercall.ret;
+
+       kvm_r10_write(vcpu, ret);
+       ++vcpu->stat.hypercalls;
+
+       return 1;
+}
+
  static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
  {
         int r;
@@ -1087,7 +1096,7 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
          * R10: KVM hypercall number
          * arguments: R11, R12, R13, R14.
          */
-       r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0, R10);
+       r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0, R10, complete_hypercall_exit);

         return r > 0;
  }


>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
>


