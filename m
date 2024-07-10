Return-Path: <kvm+bounces-21295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C54A592CE92
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:51:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3FF6E1F26101
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:51:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F9218FC9E;
	Wed, 10 Jul 2024 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="GWN7TO4G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0652B9C6;
	Wed, 10 Jul 2024 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605044; cv=none; b=NhjtkaE9KltPN64JIHbGyrajHAA+ZtndiyooWm6f5HDl1wp+3RB5fClti/jaynHx5PWoHpxqfLcZBWC+ATllZz1PZdTGx1przpWc1+TRLQW/rvt/hr5Vf7Cswt448VHl+pmRlWJ0MZIgvPKlbvYcstfpX+7i2cEozLCvyEudZYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605044; c=relaxed/simple;
	bh=jOn7hmsbOmREtHu0Gwg2PyRuvbsDbY6SWLRxt380v3c=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nCAg/ro5XGBq/5f69GNRMGqulfaNf9bHelS/bLz7e0GgOT16vR0aQLpNhuHAbgmH3P4UGJTfK0hzq4QA0CaR2WDOEyIzfkt4amBJOq/IRkgCL29ZfTbHccjHvXPSQUPDutN5clieVNrzd13H0jolQu7bXVzdZlpRjoDs8IyrwHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=GWN7TO4G; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720605044; x=1752141044;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=DnO9vyxIjhRPaz3em9T0G9QiR6aV7OUdcc5EJkgzZRY=;
  b=GWN7TO4GUYDWnDQOT2dZXZ7Htn+8CurOT8PaCVlV/Oa+3DaTqSWhFpGo
   CPLDYPORwl0Qc/vm2Xyg2cEXFE4vuer00iE91qjZxEqSdmyOeTaBaYpcN
   iUPx9xI/5yo1FGxGZXvo5ED/QhWS73KpEBpQxC4XwFsqJHJo1Vj62k4mw
   0=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="666251251"
Subject: Re: [RFC PATCH 7/8] mm: secretmem: use AS_INACCESSIBLE to prohibit GUP
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 09:50:40 +0000
Received: from EX19MTAUWB001.ant.amazon.com [10.0.38.20:41730]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.19.144:2525] with esmtp (Farcaster)
 id 82a19754-40f2-4c44-87d8-6c4b9cb6e7ce; Wed, 10 Jul 2024 09:50:38 +0000 (UTC)
X-Farcaster-Flow-ID: 82a19754-40f2-4c44-87d8-6c4b9cb6e7ce
Received: from EX19D020UWC002.ant.amazon.com (10.13.138.147) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:37 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D020UWC002.ant.amazon.com (10.13.138.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:50:36 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 10 Jul 2024 09:50:31 +0000
Message-ID: <258b3b76-cf87-4dfc-bcfa-b2af94aba811@amazon.co.uk>
Date: Wed, 10 Jul 2024 10:50:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<tabba@google.com>, <chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>,
	James Gowans <jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-8-roypat@amazon.co.uk>
 <0dc45181-de7e-4d97-9178-573c6f683f55@redhat.com>
 <Zo45CQGe_UDUnXXu@kernel.org>
Content-Language: en-US
From: Patrick Roy <roypat@amazon.co.uk>
Autocrypt: addr=roypat@amazon.co.uk; keydata=
 xjMEY0UgYhYJKwYBBAHaRw8BAQdA7lj+ADr5b96qBcdINFVJSOg8RGtKthL5x77F2ABMh4PN
 NVBhdHJpY2sgUm95IChHaXRodWIga2V5IGFtYXpvbikgPHJveXBhdEBhbWF6b24uY28udWs+
 wpMEExYKADsWIQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbAwULCQgHAgIiAgYVCgkI
 CwIEFgIDAQIeBwIXgAAKCRBVg4tqeAbEAmQKAQC1jMl/KT9pQHEdALF7SA1iJ9tpA5ppl1J9
 AOIP7Nr9SwD/fvIWkq0QDnq69eK7HqW14CA7AToCF6NBqZ8r7ksi+QLOOARjRSBiEgorBgEE
 AZdVAQUBAQdAqoMhGmiXJ3DMGeXrlaDA+v/aF/ah7ARbFV4ukHyz+CkDAQgHwngEGBYKACAW
 IQQ5DAcjaM+IvmZPLohVg4tqeAbEAgUCY0UgYgIbDAAKCRBVg4tqeAbEAtjHAQDkh5jZRIsZ
 7JMNkPMSCd5PuSy0/Gdx8LGgsxxPMZwePgEAn5Tnh4fVbf00esnoK588bYQgJBioXtuXhtom
 8hlxFQM=
In-Reply-To: <Zo45CQGe_UDUnXXu@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On 7/10/24 08:32, Mike Rapoport wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On Tue, Jul 09, 2024 at 11:09:29PM +0200, David Hildenbrand wrote:
>> On 09.07.24 15:20, Patrick Roy wrote:
>>> Inside of vma_is_secretmem and secretmem_mapping, instead of checking
>>> whether a vm_area_struct/address_space has the secretmem ops structure
>>> attached to it, check whether the address_space has the AS_INACCESSIBLE
>>> bit set. Then set the AS_INACCESSIBLE flag for secretmem's
>>> address_space.
>>>
>>> This means that get_user_pages and friends are disables for all
>>> adress_spaces that set AS_INACCESIBLE. The AS_INACCESSIBLE flag was
>>> introduced in commit c72ceafbd12c ("mm: Introduce AS_INACCESSIBLE for
>>> encrypted/confidential memory") specifically for guest_memfd to indicate
>>> that no reads and writes should ever be done to guest_memfd
>>> address_spaces. Disallowing gup seems like a reasonable semantic
>>> extension, and means that potential future mmaps of guest_memfd cannot
>>> be GUP'd.
>>>
>>> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
>>> ---
>>>   include/linux/secretmem.h | 13 +++++++++++--
>>>   mm/secretmem.c            |  6 +-----
>>>   2 files changed, 12 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h
>>> index e918f96881f5..886c8f7eb63e 100644
>>> --- a/include/linux/secretmem.h
>>> +++ b/include/linux/secretmem.h
>>> @@ -8,10 +8,19 @@ extern const struct address_space_operations secretmem_aops;
>>>   static inline bool secretmem_mapping(struct address_space *mapping)
>>>   {
>>> -   return mapping->a_ops == &secretmem_aops;
>>> +   return mapping->flags & AS_INACCESSIBLE;
>>> +}
>>> +
>>> +static inline bool vma_is_secretmem(struct vm_area_struct *vma)
>>> +{
>>> +   struct file *file = vma->vm_file;
>>> +
>>> +   if (!file)
>>> +           return false;
>>> +
>>> +   return secretmem_mapping(file->f_inode->i_mapping);
>>>   }
>>
>> That sounds wrong. You should leave *secretmem alone and instead have
>> something like inaccessible_mapping that is used where appropriate.
>>
>> vma_is_secretmem() should not suddenly succeed on something that is not
>> mm/secretmem.c
> 
> I'm with David here.
> 

Right, that makes sense. My thinking here was that if memfd_secret and
potential mappings of guest_memfd have the same behavior wrt GUP, then
it makes sense to just have them rely on the same checks. But I guess I
didn't follow that thought to its logical conclusion of renaming the
"secretmem" checks into "inaccessible" checks and moving them out of
secretmem.h.

Or do you mean to just leave secretmem untouched and add separate
"inaccessible" checks? But then we'd have two different ways of
disabling GUP for specific VMAs that both rely on checks in exactly the
same places :/

>> --
>> Cheers,
>>
>> David / dhildenb
>>
> 
> --
> Sincerely yours,
> Mike.

