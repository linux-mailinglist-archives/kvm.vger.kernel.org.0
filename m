Return-Path: <kvm+bounces-22288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3729B93CE5C
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D788F281E3F
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 06:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BC9176248;
	Fri, 26 Jul 2024 06:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="u8msaMXU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37E1E57E;
	Fri, 26 Jul 2024 06:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721976930; cv=none; b=hC2kHLu+esLDfv7PV2xRyz2h4jXGayaZrgiVuiHf4xE/ok/YmlZNOkpXvwdQLnjFF5f9YKABa/oKPtbi6GwTENHnIz7D5b5hyaan1tz0Ceen+knLcWLN8QPiSUSqFWLwmhkvLpL7XnxGQzHEjbcvMIXJqvnlHz5kCqzwi+rXsnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721976930; c=relaxed/simple;
	bh=8rUJ3cyfU+5X3yR1c71yzPbyRpz4uW+z1XrTC218QOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XVzdlNVJzppME38C8HOqe82b8Zp1syQRqTOhx66Ij2RV6DJsMTo/jBK6MJJc32Um7SvEZidVZ9JBUN2zG4hsMFOAKDOMhuWpAmnLtTVymc4wIR+MkuTRmREhAscCtTusbti/C04nkfULEp7Q0ZOapOtmglvDcltS/aBgXkP/svg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=u8msaMXU; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1721976929; x=1753512929;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0AdTsOthjnlgfDxLIVkwDvprncxlljTjxqJjxzx5ehw=;
  b=u8msaMXUVQMrvlKHXoBaJNDOerXdxxbvimWdbdvY/iMIN/Zrmt5MofM2
   gpKn1XQy4DentZSlnnWIsguTFxCFtnGx8CRbj8Xp/g8Nct16OCWOubijp
   gc4xGfRix4vdu1KPJYiGoaFpMOaNPfHIuygOVfuxx0MAvDVbm+FIeXaN2
   k=;
X-IronPort-AV: E=Sophos;i="6.09,238,1716249600"; 
   d="scan'208";a="438564128"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2024 06:55:22 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.0.204:50983]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.60.140:2525] with esmtp (Farcaster)
 id f3168678-d81e-430d-a953-37df33a02185; Fri, 26 Jul 2024 06:55:21 +0000 (UTC)
X-Farcaster-Flow-ID: f3168678-d81e-430d-a953-37df33a02185
Received: from EX19D008UEC004.ant.amazon.com (10.252.135.170) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 26 Jul 2024 06:55:20 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008UEC004.ant.amazon.com (10.252.135.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Fri, 26 Jul 2024 06:55:20 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.135.200) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Fri, 26 Jul 2024 06:55:17 +0000
Message-ID: <7e175521-38bb-49f0-b1fb-8820f8708c9c@amazon.co.uk>
Date: Fri, 26 Jul 2024 07:55:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/8] Unmapping guest_memfd from Direct Map
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <akpm@linux-foundation.org>, <dwmw@amazon.co.uk>,
	<rppt@kernel.org>, <david@redhat.com>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<willy@infradead.org>, <graf@amazon.com>, <derekmn@amazon.com>,
	<kalyazin@amazon.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>, <tabba@google.com>,
	<chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <e12b91ef-ca0c-4b77-840b-dcfb2c76a984@kernel.org>
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
In-Reply-To: <e12b91ef-ca0c-4b77-840b-dcfb2c76a984@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit



On Mon, 2024-07-22 at 13:28 +0100, "Vlastimil Babka (SUSE)" wrote:
>> === Implementation ===
>>
>> This patch series introduces a new flag to the `KVM_CREATE_GUEST_MEMFD`
>> to remove its pages from the direct map when they are allocated. When
>> trying to run a guest from such a VM, we now face the problem that
>> without either userspace or kernelspace mappings of guest_memfd, KVM
>> cannot access guest memory to, for example, do MMIO emulation of access
>> memory used to guest/host communication. We have multiple options for
>> solving this when running non-CoCo VMs: (1) implement a TDX-light
>> solution, where the guest shares memory that KVM needs to access, and
>> relies on paravirtual solutions where this is not possible (e.g. MMIO),
>> (2) have KVM use userspace mappings of guest_memfd (e.g. a
>> memfd_secret-style solution), or (3) dynamically reinsert pages into the
>> direct map whenever KVM wants to access them.
>>
>> This RFC goes for option (3). Option (1) is a lot of overhead for very
>> little gain, since we are not actually constrained by a physical
>> inability to access guest memory (e.g. we are not in a TDX context where
>> accesses to guest memory cause a #MC). Option (2) has previously been
>> rejected [1].
> 
> Do the pages have to have the same address when they are temporarily mapped?
> Wouldn't it be easier to do something similar to kmap_local_page() used for
> HIMEM? I.e. you get a temporary kernel mapping to do what's needed, but it
> doesn't have to alter the shared directmap.
> 
> Maybe that was already discussed somewhere as unsuitable but didn't spot it
> here.

For what I had prototyped here, there's no requirement to have the pages
mapped at the same address (I remember briefly looking at memremap to
achieve the temporary mappings, but since that doesnt work for normal
memory, I gave up on that path). However, I think guest_memfd is moving
into a direction where ranges marked as "in-place shared" (e.g. those
that are temporarily reinserted into the direct map in this RFC)  should
be able to be GUP'd [1]. I think for that the direct map entries would
need to be present, right?

>> In this patch series, we make sufficient parts of KVM gmem-aware to be
>> able to boot a Linux initrd from private memory on x86. These include
>> KVM's MMIO emulation (including guest page table walking) and kvm-clock.
>> For VM types which do not allow accessing gmem, we return -EFAULT and
>> attempt to prepare a KVM_EXIT_MEMORY_FAULT.
>>
>> Additionally, this patch series adds support for "restricted" userspace
>> mappings of guest_memfd, which work similar to memfd_secret (e.g.
>> disallow get_user_pages), which allows handling I/O and loading the
>> guest kernel in a simple way. Support for this is completely independent
>> of the rest of the functionality introduced in this patch series.
>> However, it is required to build a minimal hypervisor PoC that actually
>> allows booting a VM from a disk.
 
[1]: https://lore.kernel.org/kvm/489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.com/T/#mc944a6fdcd20a35f654c2be99f9c91a117c1bed4

