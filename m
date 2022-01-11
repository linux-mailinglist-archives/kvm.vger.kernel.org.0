Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E148A5F0
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiAKCzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:55:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:25484 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233174AbiAKCzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:55:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641869738; x=1673405738;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P5cQjGjpe08DoL8xRrIcKSdUgjsMsvd+59+DcJoTRC8=;
  b=n7KwFqhLqFXEWosoQHiq/hFdAZAJ+dxOkT/LpCXpsu98VlUi8PlZmgW6
   FQAe+yxiP6jAJrH8bldYCaXh/ae9Nyw83lLnA4Zpjh9kYwGaqsfL12SLP
   BHasZM5a8SmZt7pGsnoaB2lAyMZe+VjUbN+lgzkrS2hX0ghABJsH9Fws8
   mPm5Njd+eekzOWzNKr/fVb6BvZhoNGs3LhXEElckAnIL+6/a4kRuwqQIH
   /Aa/gM9mhGDvuqVrH5CbLmSIDL35Jforp7YgdyE1Xl4NK/I/c/H5qkSM9
   VTUOP4uJ0gKMGbtXTZTTCPkYTvtJ36RxGV20qI0QZ4b7RiWT062762UCj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="306741847"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="306741847"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:55:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="472299592"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.105])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:55:34 -0800
Date:   Tue, 11 Jan 2022 11:06:28 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86: Use kvm_x86_ops in
 kvm_arch_check_processor_compat
Message-ID: <20220111030626.GA2175@gao-cwp>
References: <20211227081515.2088920-1-chao.gao@intel.com>
 <20211227081515.2088920-3-chao.gao@intel.com>
 <YdygsjmoqmfwOVgv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdygsjmoqmfwOVgv@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 09:10:10PM +0000, Sean Christopherson wrote:
>On Mon, Dec 27, 2021, Chao Gao wrote:
>> check_processor_compatibility() is a "runtime" ops now. Use
>> kvm_x86_ops directly such that kvm_arch_check_processor_compat
>> can be called at runtime.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>>  arch/x86/kvm/x86.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 6411417b6871..770b68e72391 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11383,7 +11383,6 @@ void kvm_arch_hardware_unsetup(void)
>>  int kvm_arch_check_processor_compat(void *opaque)
>>  {
>>  	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
>> -	struct kvm_x86_init_ops *ops = opaque;
>>  
>>  	WARN_ON(!irqs_disabled());
>>  
>> @@ -11391,7 +11390,7 @@ int kvm_arch_check_processor_compat(void *opaque)
>>  	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
>>  		return -EIO;
>>  
>> -	return ops->runtime_ops->check_processor_compatibility();
>> +	return kvm_x86_ops.check_processor_compatibility();
>
>I'd just squash this with patch 01.  And might as well make this a static_call().

Will do
