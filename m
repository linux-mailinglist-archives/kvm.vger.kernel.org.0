Return-Path: <kvm+bounces-36390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9F4A1A6F0
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D9773ABD3F
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C2A9212B38;
	Thu, 23 Jan 2025 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="fRcaI3aY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15CA20B22;
	Thu, 23 Jan 2025 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737645760; cv=none; b=bkNXjbRcau0SGB5D4Af9w0gBIUcrvGieKnPr9khhqmG5YRQRZmwR86hEjgCizkFbStJhDrQ0GmSDVLTUndUpTZygm58psCpnscGlUH7q3fMma6qmWdx+ITk0PCmIXqTzx0pf16oucDDkAeFNW6wUzF/2EnFIGxuW6bjmwrZ7rbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737645760; c=relaxed/simple;
	bh=LdsUt5nuqRKTBo+Zf7y2sEcmeiI/oxeUDf9fxmTv2zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IPLyjh74L3Y7kipWY8fRUmu7osvPvJ08jnJI1g4ELTs1+RH9VP1T69E7dR15VDHB7sD45M4HpkdlN1nuanjOfndjI6pfC1Z7Oraqt6IlhnuIQnflzv3cM9l3BFEeBsxfqNZN3JtZRWo7HRqDJKb5s6OFOjxpYypF5TJC1YFVhsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=fRcaI3aY; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1737645758; x=1769181758;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=P5aqkjPNbdb3uSgVXaztNFotezbG1xCHVak/q8V4drs=;
  b=fRcaI3aYwwAeEb69dgfPtWKJPfTvyB03296jsD5nkpAs+seCaIZqH9Mx
   XlVbjk2/nLoKigG+nB2ZeLzZBlvdi/nD0U5G0NPLucQkGvUCtbGc/KIwf
   KcrSuyiKDDrn+M+7CJF35Duntt5vmjsF3toRpu8m3OB17x0XPR6MbVeD3
   Q=;
X-IronPort-AV: E=Sophos;i="6.13,228,1732579200"; 
   d="scan'208";a="163691432"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 15:22:37 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.38.20:44330]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.215:2525] with esmtp (Farcaster)
 id c1fbe00d-964c-4662-b952-85a0f885aad2; Thu, 23 Jan 2025 15:22:36 +0000 (UTC)
X-Farcaster-Flow-ID: c1fbe00d-964c-4662-b952-85a0f885aad2
Received: from EX19EXOUWC001.ant.amazon.com (10.250.64.135) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 15:22:35 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19EXOUWC001.ant.amazon.com (10.250.64.135) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Thu, 23 Jan 2025 15:22:35 +0000
Received: from email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.39 via Frontend Transport; Thu, 23 Jan 2025 15:22:35 +0000
Received: from [127.0.0.1] (dev-dsk-roypat-1c-dbe2a224.eu-west-1.amazon.com [172.19.88.180])
	by email-imr-corp-prod-pdx-all-2c-475d797d.us-west-2.amazon.com (Postfix) with ESMTPS id 7A4D5A1EFD;
	Thu, 23 Jan 2025 15:22:22 +0000 (UTC)
Message-ID: <5b2949bf-ab8b-46d4-9daf-71fe3e20b0c8@amazon.co.uk>
Date: Thu, 23 Jan 2025 15:22:21 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 2/9] KVM: guest_memfd: Add guest_memfd support to
 kvm_(read|/write)_guest_page()
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <pbonzini@redhat.com>, <chenhuacai@kernel.org>,
	<mpe@ellerman.id.au>, <anup@brainfault.org>, <paul.walmsley@sifive.com>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <seanjc@google.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<chao.p.peng@linux.intel.com>, <jarkko@kernel.org>, <amoorthy@google.com>,
	<dmatlack@google.com>, <yu.c.zhang@linux.intel.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
	<liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
	<kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
	<steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <shuah@kernel.org>,
	<hch@infradead.org>, <jgg@nvidia.com>, <rientjes@google.com>,
	<jhubbard@nvidia.com>, <fvdl@google.com>, <hughd@google.com>,
	<jthoughton@google.com>
References: <20250122152738.1173160-1-tabba@google.com>
 <20250122152738.1173160-3-tabba@google.com>
 <e6ea48d2-959f-4fbb-a170-0beaaf37f867@redhat.com>
 <CA+EHjTxNEoQ3MtZPi603=366vxt=SmBwetS4mFkvTK2r6u=UHw@mail.gmail.com>
 <82d8d3a3-6f06-4904-9d94-6f92bba89dbc@redhat.com>
 <ef864674-bbcf-457b-a4e3-fec272fc2d8a@amazon.co.uk>
 <fe154ef9-ac57-40ce-96d8-4e744d83d37e@redhat.com>
From: Patrick Roy <roypat@amazon.co.uk>
Content-Language: en-US
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
In-Reply-To: <fe154ef9-ac57-40ce-96d8-4e744d83d37e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2025-01-23 at 14:18 +0000, David Hildenbrand wrote:
>>>>
>>>> That said, we could always have a userspace address dedicated to
>>>> mapping shared locations, and use that address when the necessity
>>>> arises. Or we could always require that memslots have a userspace
>>>> address, even if not used. I don't really have a strong preference.
>>>
>>> So, the simpler version where user space would simply mmap guest_memfd
>>> to provide the address via userspace_addr would at least work for the
>>> use case of paravirtualized time?
>>
>> fwiw, I'm currently prototyping something like this for x86 (although
>> not by putting the gmem address into userspace_addr, but by adding a new
>> field to memslots, so that memory attributes continue working), based on
>> what we talked about at the last guest_memfd sync meeting (the whole
>> "how to get MMIO emulation working for non-CoCo VMs in guest_memfd"
>> story).
> 
> Yes, I recall that discussion. Can you elaborate why the separate field
> is required to keep memory attributes working? (could it be sorted out
> differently, by reusing userspace_addr?).

The scenario I ran into was that within the same memslots, I wanted some
gfns to be backed by guest_memfd, and others by traditional memory, so
that KVM can GUP some parts of guest memory even if guest_memfd itself
is direct map removed.

It actually also has to do with paravirtual time, but on x86. Here, the
guest chooses where in guest memory the clock structure is placed via an
MSR write (so I can't a priori use a traditional memslot, like we can on
ARM).  KVM internally wants to GUP the hva that corresponds to the gfn
the guest chooses, but if the hva is in a mapping of direct map removed
gmem, that won't work. So what I did was just intercept the MSR write in
userspace, and clear KVM_MEMORY_ATTRIBUTES_PRIVATE for the gfn. But for
this, I need userspace_addr to not point to the guest_memfd hva.
Although maybe it'd be possible to instead reconfigure the memslots when
intercepting the MSR? Not sure where we stand on KVM_MEM_GUEST_MEMFD
memslots though.

But also conceptually, doesn't KVM_MEMORY_ATTRIBUTES_PRIVATE kinda loose
any meaning if userspace_addr also points towards gmem? E.g. no matter
what we set, we'd get gmem mapped into the guest.

> -- 
> Cheers,
> 
> David / dhildenb
> 

Best, 
Patrick

