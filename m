Return-Path: <kvm+bounces-22657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EB0940EC2
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39A1B2811FB
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12590195B28;
	Tue, 30 Jul 2024 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVA1ji1R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C231153BF7
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722334566; cv=none; b=APaI1XvVLmdQn5uN38cEe5V0kkBZIDNkTY4248zc2bXwYMsVBP0bwV+9Qqp/BUmiPSEc+c85ZCxBdbumGHYtrIDXCnfdSIZNouRFdiW8xJCspEIvFvj2L+KNtUHBFwvDu9PxZOTqVMurh+L10hoNOi+bYQWyRz/XGJxyS7XQbs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722334566; c=relaxed/simple;
	bh=dPE52On1XPPd1fO8a1wdKfBGJ7BxX18geH3vJBa8MP4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOfWZq1RhVZt+gp1RAeAnvs7I5nrmFYy0KRgFimBQ7pR/TAfnFqqJZKxB92KiRCLbMb/uFxu4uHCExcNNFk/dGk4FpERGSRoxHj17IAjYfBQ40cWZ1pwHawoVzkFEqvaXMN4bw5YN9o9cWK666zCmae2zHTpkTH/mrMzNGnj/U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVA1ji1R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722334563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=owK5Gb4Y1b7hNFGBuCGYRLOJe16PvMmwqprOo8ysou4=;
	b=RVA1ji1RR3O49suYH0NVPfL9j0jJep9dDTiEXVLkXd/LR8t2UOGfdQSXqZDt5obEeIF2OO
	4Z3fahm+NsZcERO/rlQYQCGz+uPJqy/ISEOHwYljOmNOqMXb0zBzfXZ4t9NKLqGhdF6Jym
	AABHHRvX+zZ7bnRsjekwtLlYmQviv+0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-jbwO4g4uNCmhW6W7pRHzxQ-1; Tue, 30 Jul 2024 06:16:00 -0400
X-MC-Unique: jbwO4g4uNCmhW6W7pRHzxQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3688010b3bfso2457498f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 03:16:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722334559; x=1722939359;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=owK5Gb4Y1b7hNFGBuCGYRLOJe16PvMmwqprOo8ysou4=;
        b=UN+hKw62v5Fy7GNbicS+c94vAN0bhIEFbnZVq712OxNfQmDjAmGfrjoXwPSLmWg0gn
         uJC0Q0tPvcxtPdJRK6IwDDSLpuIm/Yj40t5zTczWdv/iHaYtcwE7MpQ3w1GBrKzKnew+
         YE2ZPcF6QX0HvuYMwm08LhsOLnipu9GcT6z63OPt3pHNEgOGJMDm4mfU6ocYzpv+pXp2
         bh+6+gmMW/3Loi6/YwTOzh4sZhVb4IXppjCqZ6i7Yx892RlwzDfF9Svx0+IfxYl9rJmN
         0TAniil4Z7W0ijNiSuGe17ypclzzNPJfQo5GOuqWNmtA5QLZfwQ96duw/C5ensRVfP1S
         EXgQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0uyj4ec0gHK/Otp9rF700qWFOpGFInQSOCD6ARend1Wz0RfNgVvsK+MsCmoOn+u2IX2HLeemGT2Qygrnl5Tb97ImR
X-Gm-Message-State: AOJu0YyaRHgp+NxBX+6dF6IXOgVDVPNwsIrCiCyjVS+wrXepDeaWs6SQ
	/RAkamlUcRVw4CjJ6zRqSIXBQrNfOa1haZRy/F943w2Wy5zrvpJALJAFh/FoOIJQmlrz4qjVwLj
	vqT8iSh8ypRgJ0mhwLMKiCeKITFW6DqLz13gvgxk8rXl8PQutbA==
X-Received: by 2002:a5d:460c:0:b0:368:4226:407b with SMTP id ffacd0b85a97d-36b5d2e7860mr8236513f8f.61.1722334559093;
        Tue, 30 Jul 2024 03:15:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF56qKYCOfp4HJaJ7NS+ZhOVMI3IH9nTtAn+VcLyU2FNsz6VVLyBd3yEBsZtBOX8Gtk+U0bSQ==
X-Received: by 2002:a5d:460c:0:b0:368:4226:407b with SMTP id ffacd0b85a97d-36b5d2e7860mr8236470f8f.61.1722334558451;
        Tue, 30 Jul 2024 03:15:58 -0700 (PDT)
Received: from [192.168.3.141] (p4ff233ea.dip0.t-ipconnect.de. [79.242.51.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857e46sm14365191f8f.67.2024.07.30.03.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 03:15:57 -0700 (PDT)
Message-ID: <ab528aa0-d4a5-4661-9715-43eb1681cfef@redhat.com>
Date: Tue, 30 Jul 2024 12:15:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 8/8] kvm: gmem: Allow restricted userspace mappings
To: Patrick Roy <roypat@amazon.co.uk>, seanjc@google.com,
 Fuad Tabba <tabba@google.com>
Cc: pbonzini@redhat.com, akpm@linux-foundation.org, dwmw@amazon.co.uk,
 rppt@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 willy@infradead.org, graf@amazon.com, derekmn@amazon.com,
 kalyazin@amazon.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, dmatlack@google.com, chao.p.peng@linux.intel.com,
 xmarcalx@amazon.co.uk, James Gowans <jgowans@amazon.com>
References: <20240709132041.3625501-1-roypat@amazon.co.uk>
 <20240709132041.3625501-9-roypat@amazon.co.uk>
 <CA+EHjTynVpsqsudSVRgOBdNSP_XjdgKQkY_LwdqvPkpJAnAYKg@mail.gmail.com>
 <47ce1b10-e031-4ac1-b88f-9d4194533745@redhat.com>
 <f7106744-2add-4346-b3b6-49239de34b7f@amazon.co.uk>
 <f21d8157-a5e9-4acb-93fc-d040e9b585c8@redhat.com>
 <e26ec0bb-3c20-4732-a09b-83b6b6a6419a@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <e26ec0bb-3c20-4732-a09b-83b6b6a6419a@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> Hi,
>>
>> sorry for the late reply. Yes, you could have joined .... too late.
> 
> No worries, I did end up joining to listen in to y'all's discussion
> anyway :)

Sorry for the late reply :(

> 
>> There will be a summary posted soon. So far the agreement is that we're
>> planning on allowing shared memory as part guest_memfd, and will allow
>> that to get mapped and pinned. Private memory is not going to get mapped
>> and pinned.
>>
>> If we have to disallow pinning of shared memory on top for some use
>> cases (i.e., no directmap), I assume that could be added.
>>
>>>
>>>> Note that just from staring at this commit, I don't understand the
>>>> motivation *why* we would want to do that.
>>>
>>> Fair - I admittedly didn't get into that as much as I probably should
>>> have. In our usecase, we do not have anything that pKVM would (I think)
>>> call "guest-private" memory. I think our memory can be better described
>>> as guest-owned, but always shared with the VMM (e.g. userspace), but
>>> ideally never shared with the host kernel. This model lets us do a lot
>>> of simplifying assumptions: Things like I/O can be handled in userspace
>>> without the guest explicitly sharing I/O buffers (which is not exactly
>>> what we would want long-term anyway, as sharing in the guest_memfd
>>> context means sharing with the host kernel), we can easily do VM
>>> snapshotting without needing things like TDX's TDH.EXPORT.MEM APIs, etc.
>>
>> Okay, so essentially you would want to use guest_memfd to only contain
>> shard memory and disallow any pinning like for secretmem.
> 
> Yeah, this is pretty much what I thought we wanted before listening in
> on Wednesday.
> 
> I've actually be thinking about this some more since then though. With
> hugepages, if the VM is backed by, say, 2M pages, our on-demand direct
> map insertion approach runs into the same problem that CoCo VMs have
> when they're backed by hugepages: How to deal with the guest only
> sharing a 4K range in a hugepage? If we want to restore the direct map
> for e.g. the page containing kvm-clock data, then we can't simply go
> ahead and restore the direct map for the entire 2M page, because there
> very well might be stuff in the other 511 small guest pages that we
> really do not want in the direct map. And we can't even take the

Right, you'd only want to restore the direct map for a fragment. Or 
dynamically map that fragment using kmap where required (as raised by 
Vlastimil).

> approach of letting the guest deal with the problem, because here
> "sharing" is driven by the host, not the guest, so the guest cannot
> possibly know that it maybe should avoid putting stuff it doesn't want
> shared into those remaining 511 pages! To me that sounds a lot like the
> whole "breaking down huge folios to allow GUP to only some parts of it"
> thing mentioned on Wednesday.

Yes. While it would be one logical huge page, it would be exposed to the 
remainder of the kernel as 512 individual pages.

> 
> Now, if we instead treat "guest memory without direct map entries" as
> "private", and "guest memory with direct map entries" as "shared", then
> the above will be solved by whatever mechanism allows gupping/mapping of
> only the "shared" parts of huge folios, IIUC. The fact that GUP is then
> also allowed for the "shared" parts is not actually a problem for us -
> we went down the route of disabling GUP altogether here because based on
> [1] it sounded like GUP for anything gmem related would never happen.

Right. Might there also be a case for removing the directmap for shared 
memory or is that not really a requirement so far?

> But after something is re-inserted into the direct map, we don't very
> much care if it can be GUP-ed or not. In fact, allowing GUP for the
> shared parts probably makes some things easier for us, as we can then do
> I/O without bounce buffers by just in-place converting I/O-buffers to
> shared, and then treating that shared slice of guest_memfd the same way
> we treat traditional guest memory today. 

Yes.

> In a very far-off future, we'd
> like to be able to do I/O without ever reinserting pages into the direct
> map, but I don't think adopting this private/shared model for gmem would
> block us from doing that?

How would that I/O get triggered? GUP would require the directmap.

> 
> Although all of this does hinge on us being able to do the in-place
> shared/private conversion without any guest involvement. Do you envision
> that to be possible?

Who would trigger the conversion and how? I don't see a reason why -- 
for your use case -- user space shouldn't be able to trigger conversion 
private <-> shared. At least nothing fundamental comes to mind that 
would prohibit that.

-- 
Cheers,

David / dhildenb


