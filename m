Return-Path: <kvm+bounces-32404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C7949D7BAC
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 07:47:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 533F0162D0D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 06:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA0D185935;
	Mon, 25 Nov 2024 06:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ebnRtUTm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B0517E00B;
	Mon, 25 Nov 2024 06:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732517250; cv=none; b=bD2CPpMg+Dj5YScRYNXq2B0RA/PEDswI6zb6dv8dwWlV+i8+sntEb+AsvasHQSmsq9P+xzXigfx445qBEW6a29APpTbuxN2jYYiv5iNivqBGN+gv6PoAdXGH613OkozPcLhq/AOOBm6Vvm/jUJpzFDFVq0hKwrZEoxwUGfeV9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732517250; c=relaxed/simple;
	bh=hh2VeZrEP+wIEna9sZt9yWCIbilXA/lFhf2oZas9WQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Trk/PVO6cg5luukOdSAI5STr1fVrtcyiDjoYyfu/3H43n1u0vPNJlT0GEbEvgAqmj6JM92Xi5HZ70fS0GPgIAAeOS5f2iepkgLX4jSmG6da15Z/Z3RKrt8dBzcKJTjewuDTB6ASt6mgSPRgMsqIJl3MUnIFgK/4e/0/xR5KGTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ebnRtUTm; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732517249; x=1764053249;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hh2VeZrEP+wIEna9sZt9yWCIbilXA/lFhf2oZas9WQw=;
  b=ebnRtUTms0SlfL/nkcsr9wAJEU/EX52rjrCJXuY6cTqs4tMlQY8YER6R
   hSK9HRQXlHNH03bwPm8CL5MvW2tgffBZePc1RQbbBNsM0LiMQG/fQcRcE
   UB/qogY7hSl/z+RJ2RFkmUTT7llhKqWT02z2vbV/4/7UVCoFcQLLa37Qc
   vLca5GwnDoBlV1ayPUol4wckKVbSjB+5+q2XtB1IXA9OU69nT19LTC0rN
   RVMQwM0kgQA3yIWKB+g9IvQDSDGu46wi5RzJnd4VuwiPCXgKfl505MbFM
   /UH0SFRUWHQUHldpefebYkgieeB/wyuHeqEmAYlfmCxy2ovk7EPhs05Bb
   g==;
X-CSE-ConnectionGUID: pAW9WuRjSDiLc9rEEEsayQ==
X-CSE-MsgGUID: K0Xiqo6wT5qpm8OAFNXEgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="44001541"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="44001541"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 22:47:28 -0800
X-CSE-ConnectionGUID: KL3sJdpFSgeErg1uM1fMHA==
X-CSE-MsgGUID: rb7Q7rMsQf2WUQNLESV5uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="91587893"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.241.124]) ([10.124.241.124])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2024 22:47:25 -0800
Message-ID: <57d308a8-0ce5-41f8-aef4-33d36723c434@linux.intel.com>
Date: Mon, 25 Nov 2024 14:47:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
 <ZymDgtd3VquVwsn_@google.com>
 <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
 <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
 <e2c19b20b11c307cc6b4ae47cd7f891e690b419b.camel@intel.com>
 <b7fd2ddf-77a4-423c-b5cf-36505997990d@linux.intel.com>
 <ZyuLf5evSQlZqG6w@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZyuLf5evSQlZqG6w@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/6/2024 11:30 PM, Sean Christopherson wrote:
> On Wed, Nov 06, 2024, Binbin Wu wrote:
>> On 11/6/2024 4:54 PM, Huang, Kai wrote:
>>> On Wed, 2024-11-06 at 16:32 +0800, Binbin Wu wrote:
>>>>> static void kvm_complete_hypercall_exit(struct kvm_vcpu *vcpu, int ret_reg,
>>>>>    				        unsigned long ret, bool op_64_bit)
>>>>> {
>>>>>    	if (!op_64_bit)
>>>>>    		ret = (u32)ret;
>>>>>    	kvm_register_write_raw(vcpu, ret_reg, ret);
>>>>>    	++vcpu->stat.hypercalls;
>>>>> }
>>>> If this is going to be the final version, it would be better to make it
>>>> public, and export the symbol, so that TDX code can reuse it.
>>> Does making it 'static inline' and moving to kvm_host.h work?
>> It doesn't have a complete definition of struct kvm_vcpu in
>> arch/x86/include/asm/kvm_host.h, and the code is dereferencing
>> struct kvm_vcpu.
>> Also, the definition of kvm_register_write_raw() is in
>> arch/x86/kvm/kvm_cache_regs.h, which make it difficult to be called
>> there.
> A way around that would be to move the declarations from asm/kvm_host.h to x86.h,
> and then kvm_complete_hypercall_exit() can be inlined (or not), without having to
> deal with the kvm_host.h ordering issues.
>
> IMO, KVM x86 would ideally put as much as possible in x86.h.  The vast majority
> of KVM x86's exports are intended only for the vendor modules.  Declaring those
> exports in kvm_host.h is effectively bleeding KVM internals to the broader kernel.
>
> I'll go that route for the series, assuming it works as I intend :-)
>
Based on the previous discussions, is the below code expected?
If so, I am gonna use __kvm_emulate_hypercall() and kvm_complete_hypercall_exit()
in TDX code for handling KVM hypercalls.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e51a95aba824..356620f74bb0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2205,10 +2205,6 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
         kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
  }

-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-                                     unsigned long a0, unsigned long a1,
-                                     unsigned long a2, unsigned long a3,
-                                     int op_64_bit, int cpl);
  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);

  int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2b5b0ae3dd7e..05191c4af156 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10008,19 +10008,17 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)

  static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
  {
-       u64 ret = vcpu->run->hypercall.ret;
+       kvm_complete_hypercall_exit(vcpu, VCPU_REGS_RAX,
+               vcpu->run->hypercall.ret, is_64_bit_mode(vcpu));

-       if (!is_64_bit_mode(vcpu))
-               ret = (u32)ret;
-       kvm_rax_write(vcpu, ret);
-       ++vcpu->stat.hypercalls;
         return kvm_skip_emulated_instruction(vcpu);
  }

-unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
-                                     unsigned long a0, unsigned long a1,
-                                     unsigned long a2, unsigned long a3,
-                                     int op_64_bit, int cpl)
+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+                             unsigned long a0, unsigned long a1,
+                             unsigned long a2, unsigned long a3,
+                             int op_64_bit, int cpl, int ret_reg,
+                             int (*cui)(struct kvm_vcpu *vcpu))
  {
         unsigned long ret;

@@ -10104,16 +10102,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
         }

  out:
-       ++vcpu->stat.hypercalls;
-       return ret;
+       kvm_complete_hypercall_exit(vcpu, ret_reg, ret, op_64_bit);
+
+       return 1;
  }
-EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
+EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);

  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
  {
-       unsigned long nr, a0, a1, a2, a3, ret;
-       int op_64_bit;
-       int cpl;
+       int r;

         if (kvm_xen_hypercall_enabled(vcpu->kvm))
                 return kvm_xen_hypercall(vcpu);
@@ -10121,23 +10118,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
         if (kvm_hv_hypercall_enabled(vcpu))
                 return kvm_hv_hypercall(vcpu);
                 return kvm_hv_hypercall(vcpu);

-       nr = kvm_rax_read(vcpu);
-       a0 = kvm_rbx_read(vcpu);
-       a1 = kvm_rcx_read(vcpu);
-       a2 = kvm_rdx_read(vcpu);
-       a3 = kvm_rsi_read(vcpu);
-       op_64_bit = is_64_bit_hypercall(vcpu);
-       cpl = kvm_x86_call(get_cpl)(vcpu);
-
-       ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
-       if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
-               /* MAP_GPA tosses the request to the user space. */
+       r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
+                                   is_64_bit_hypercall(vcpu),
+                                   kvm_x86_call(get_cpl)(vcpu), RAX,
+                                   complete_hypercall_exit);
+       if (r <= 0)
                 return 0;

-       if (!op_64_bit)
-               ret = (u32)ret;
-       kvm_rax_write(vcpu, ret);
-
         return kvm_skip_emulated_instruction(vcpu);
  }
  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a84c48ef5278..5667d029e7f0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -568,4 +568,25 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
                          unsigned int port, void *data,  unsigned int count,
                          int in);

+int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+                             unsigned long a0, unsigned long a1,
+                             unsigned long a2, unsigned long a3,
+                             int op_64_bit, int cpl, int ret_reg,
+                             int (*cui)(struct kvm_vcpu *vcpu));
+
+#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, ret, cui)           \
+ ____kvm_emulate_hypercall(vcpu, \
+                                 kvm_##nr##_read(vcpu), kvm_##a0##_read(vcpu),                 \
+                                 kvm_##a1##_read(vcpu), kvm_##a2##_read(vcpu),                 \
+                                 kvm_##a3##_read(vcpu), op_64_bit, cpl, VCPU_REGS_##ret,       \
+                                 cui)
+
+static inline void kvm_complete_hypercall_exit(struct kvm_vcpu *vcpu, int ret_reg,
+                                              unsigned long ret, bool op_64_bit)
+{
+       if (!op_64_bit)
+               ret = (u32)ret;
+       kvm_register_write_raw(vcpu, ret_reg, ret);
+       ++vcpu->stat.hypercalls;
+}
+
  #endif



