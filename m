Return-Path: <kvm+bounces-53771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2FEB16CE4
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 09:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 892F856565E
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 07:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FC829DB61;
	Thu, 31 Jul 2025 07:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nmZbqEVx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867D230BEF;
	Thu, 31 Jul 2025 07:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753948179; cv=none; b=eIuOUF9sfqh+fAuwpxbAckEBIcH8XAMLyDS+BaKCl3LOkVnV6KoHWehyAnBYYjKqv5qMNS92iJ0rwfUAbVjfiuEtO/VUs+GtE1JMcriRjV8uDlPXeDLm358ff7ruOt+W3qDdM3IkihtYfyzFqxIwRaSX7H+q97upj6Vdv3O9b7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753948179; c=relaxed/simple;
	bh=Gs1MIGdx+aL/FvTa33b5/hEqyQZgikPYWC/APuQ9dlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CzS2fOLw+3rXNiQkecvYSJ/h3gkcT1V878PshiRBQQWDTs/CvWulQPGygfAbDyBchunRPH13PqJ72dolSSAxxpFKSTWnxRrZ2gI2omvBHZVPeL1NlNV4aa556NUr2pLQ76md0+NUrUy+C7cr0AzMH49XkjMSy72Jbvx7de8nc6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nmZbqEVx; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753948178; x=1785484178;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gs1MIGdx+aL/FvTa33b5/hEqyQZgikPYWC/APuQ9dlg=;
  b=nmZbqEVx1N6R7tT8hKoZ/o9AIxq3SeQRTKWHivQ7pFIVdwkO6NTX92jV
   drF5+QP98U0aX8YGTchTRbcC53zIGirHBlojtcsdFvFyqeoXraKHQQ7tF
   e71ZlKzCTr+YzfPjxYeCMuuqhHaW6JzZAZfwYbTjHkQv5k8jl3NULXYz1
   G6RbQwml8h7qKMVdoxO+0OlFLcsaxoMABFlR6SW7LH9uBTKsC9VeDmpsC
   dmC2DzXmXeGLdZUkROtF+H6uCdwRueOn/4PHa9vrcormabEjz0FSGoHTF
   PNTHDFNtN3xymuQF6KF3ZroaGJWGu93FGIgn2j9ZBhwvwWXZ67excUr26
   Q==;
X-CSE-ConnectionGUID: GbY/VSI4Rp2jX+WsHbHoHw==
X-CSE-MsgGUID: QjqMY99GRK210g8Ox+R3Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56340251"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="56340251"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 00:49:37 -0700
X-CSE-ConnectionGUID: 73cEAW53RymL+KeNij9jPQ==
X-CSE-MsgGUID: my5o4r9WSBaok3whtlcfJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163541810"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 00:49:33 -0700
Message-ID: <44f17b93-cf3c-43e9-b921-5f904c13db69@intel.com>
Date: Thu, 31 Jul 2025 15:49:29 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 23/24] KVM: selftests: guest_memfd mmap() test when
 mmap is supported
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-24-seanjc@google.com>
 <856487d0-8e1a-4e64-a8e6-13977fd31fed@intel.com>
 <aIoWosN3UiPe2qQK@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aIoWosN3UiPe2qQK@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 8:57 PM, Sean Christopherson wrote:
> On Wed, Jul 30, 2025, Xiaoyao Li wrote:
>> On 7/30/2025 6:54 AM, Sean Christopherson wrote:
>>
>> ...
>>
>>> +int main(int argc, char *argv[])
>>> +{
>>> +	unsigned long vm_types, vm_type;
>>> +
>>> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
>>> +
>>> +	/*
>>> +	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
>>> +	 * support guest_memfd have that support for the default VM type.
>>> +	 */
>>> +	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
>>> +	if (!vm_types)
>>> +		vm_types = VM_TYPE_DEFAULT;
>>> +
>>> +	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>>> +		test_guest_memfd(vm_type);
>>
>> For ARCHes that don't support KVM_CAP_VM_TYPES, e.g., ARM, vm_types is 0
>> (VM_TYPE_DEFAULT). the for_each_set_bit() loop will not execute any
>> iteration at all.
> 
> Doh, indeed.
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index b86bf89a71e0..b3ca6737f304 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -372,7 +372,7 @@ int main(int argc, char *argv[])
>           */
>          vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
>          if (!vm_types)
> -               vm_types = VM_TYPE_DEFAULT;
> +               vm_types = BIT(VM_TYPE_DEFAULT);
>   
>          for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>                  test_guest_memfd(vm_type);

With the above fix,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

