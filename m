Return-Path: <kvm+bounces-21296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B18192CE99
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3D3C1F26A4E
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296D318FC62;
	Wed, 10 Jul 2024 09:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="kmbW9RFx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350618FA24;
	Wed, 10 Jul 2024 09:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720605103; cv=none; b=dDDOSeNoQDMd/1WxeHwKibtQMhdtxJurxa3vRHRFGH+AYmDhuCWTeGWQEj9Jfvc3xdZNTUNqTPa8419Zn7FTMX3o2r8AS3rgTcU3fWwtqzyw7gvGmAM9Ea3tGf2pkSiLM8nZDZSLLekmK3O2GaQARV3T/Vhc05awy5bHIQ3AHMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720605103; c=relaxed/simple;
	bh=LKUQ1g3huEdYZKIyc/kRdhR95IYzPsKqaNbyDCwocn4=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GQMnWwNkgrJ8xs2C3IGKAQfSrmlglvFnkkB7ynxvoCItk8tnYVUAl5+RixpwwQTKXqiVyhjlgwsnLEJIJcuaQQ6A2p2RnHdAq3Xa4CARhkeauTOtVad/wptAve7n/pIuedOG9LnCTOdg5PnkqWn/8H6QEaEaZl9ydK8s1R4Ghds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=kmbW9RFx; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1720605102; x=1752141102;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=nK6dem30/R4Q7t0pgui63Ry1Sj5Xd4Mv4l1MOOrjNtU=;
  b=kmbW9RFxVl/nREu/4VWqAapAFgQVNXghfgkDx1KkFy/2Hz2C5gNOpWQf
   6Gol2JrH0y/1AAl4+mgCgof4BtdUN7/pzKwogYvyZ+kCROSnGzKmo+L1e
   K8QadeSVd0G7+vW0qvLqKk970SdBYx1BLwo/CpNlGdHGlGs6yOWYsxzjR
   0=;
X-IronPort-AV: E=Sophos;i="6.09,197,1716249600"; 
   d="scan'208";a="739710169"
Subject: Re: [RFC PATCH 8/8] kvm: gmem: Allow restricted userspace mappings
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 09:51:23 +0000
Received: from EX19MTAUEA002.ant.amazon.com [10.0.44.209:62414]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.81.34:2525] with esmtp (Farcaster)
 id 35b3f801-8f14-44a3-a9e2-5ce76030037f; Wed, 10 Jul 2024 09:51:21 +0000 (UTC)
X-Farcaster-Flow-ID: 35b3f801-8f14-44a3-a9e2-5ce76030037f
Received: from EX19D008UEA003.ant.amazon.com (10.252.134.116) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:51:21 +0000
Received: from EX19MTAUEA001.ant.amazon.com (10.252.134.203) by
 EX19D008UEA003.ant.amazon.com (10.252.134.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 10 Jul 2024 09:51:20 +0000
Received: from [127.0.0.1] (172.19.88.180) by mail-relay.amazon.com
 (10.252.134.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Wed, 10 Jul 2024 09:51:18 +0000
Message-ID: <f7106744-2add-4346-b3b6-49239de34b7f@amazon.co.uk>
Date: Wed, 10 Jul 2024 10:51:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <akpm@linux-foundation.org>,
	<dwmw@amazon.co.uk>, <rppt@kernel.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <willy@infradead.org>, <graf@amazon.com>,
	<derekmn@amazon.com>, <kalyazin@amazon.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <dmatlack@google.com>,
	<chao.p.peng@linux.intel.com>, <xmarcalx@amazon.co.uk>, James Gowans
	<jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-9-roypat@amazon.co.uk>
 <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
 <47ce1b10-e031-4ac1-b88f-9d4194533745@redhat.com>
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
In-Reply-To: <47ce1b10-e031-4ac1-b88f-9d4194533745@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit



On 7/9/24 22:13, David Hildenbrand wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> On 09.07.24 16:48, Fuad Tabba wrote:
>> Hi Patrick,
>>
>> On Tue, Jul 9, 2024 at 2:21 PM Patrick Roy <roypat@amazon.co.uk> wrote:
>>>
>>> Allow mapping guest_memfd into userspace. Since AS_INACCESSIBLE is set
>>> on the underlying address_space struct, no GUP of guest_memfd will be
>>> possible.
>>
>> This patch allows mapping guest_memfd() unconditionally. Even if it's
>> not guppable, there are other reasons why you wouldn't want to allow
>> this. Maybe a config flag to gate it? e.g.,
> 
> 
> As discussed with Jason, maybe not the direction we want to take with
> guest_memfd.
> If it's private memory, it shall not be mapped. Also not via magic
> config options.
> 
> We'll likely discuss some of that in the meeting MM tomorrow I guess
> (having both shared and private memory in guest_memfd).

Oh, nice. I'm assuming you mean this meeting:
https://lore.kernel.org/linux-mm/197a2f19-c71c-fbde-a62a-213dede1f4fd@google.com/T/?
Would it be okay if I also attend? I see it also mentions huge pages,
which is another thing we are interested in, actually :)

> Note that just from staring at this commit, I don't understand the
> motivation *why* we would want to do that.

Fair - I admittedly didn't get into that as much as I probably should
have. In our usecase, we do not have anything that pKVM would (I think)
call "guest-private" memory. I think our memory can be better described
as guest-owned, but always shared with the VMM (e.g. userspace), but
ideally never shared with the host kernel. This model lets us do a lot
of simplifying assumptions: Things like I/O can be handled in userspace
without the guest explicitly sharing I/O buffers (which is not exactly
what we would want long-term anyway, as sharing in the guest_memfd
context means sharing with the host kernel), we can easily do VM
snapshotting without needing things like TDX's TDH.EXPORT.MEM APIs, etc.

> -- 
> Cheers,
> 
> David / dhildenb
> 

