Return-Path: <kvm+bounces-12998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9761E88FD16
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC9429268F
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630767BB1E;
	Thu, 28 Mar 2024 10:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LywfnhsE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB7A364DA
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711621950; cv=none; b=DTSoO5dP1ClIIhoukWKwKkRms1zTVoIO2dmWjiYPx9LaCuztixuszx8twkMDRBzHeVW2UtNFi6jTp/HxZUZ4n1h0wPkijjuOxNyCB2NMzZ8pg+/w7XvX3TLI7IsaTOvatM0sACmhDLCBJ36sAxX04zX7hYNnubppwKIHewE8HX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711621950; c=relaxed/simple;
	bh=cDBIxK1RVHecfS9pgG+aJOyuCcg60fVVWzcVOP1S+g8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZjbO2x3rJ0uBk3Hg5U73F30IFJ1HSXHsbqFD1ZtfwSBSq502oHdT/NhDfORWJeaG7bIwK3VxavGJShXWamGCEweI8OrgYLpAgXraiVWUlX9VPsWYFoYQngDoFMJzAGvShacK03dKw4/NJ5zhwWtjJfrhmImkDxokDzFK/c8B59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LywfnhsE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711621947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a2lVbDhBQAGHbBTeKbzP4+/8kq2G3gaGnD2z+bIc43o=;
	b=LywfnhsE4hS9UchhDnNmZn4rfW9BTp6ZNBlXVssM1yCCHdtkgFtruarpnjxdoVgP8Gv+hV
	VZTxf+ioY7QL+ejjRAmKnMvA4Zo/FFemjlFMFvWdKcENVv2zl2M3n9wigxto7TCHHV7ziE
	KXVZfCC5FN8uIRCTVDSExkAbSyKM1DQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-IXp30EsTN-SIq8K5epeG4Q-1; Thu, 28 Mar 2024 06:32:26 -0400
X-MC-Unique: IXp30EsTN-SIq8K5epeG4Q-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33ed44cb765so397012f8f.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711621945; x=1712226745;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2lVbDhBQAGHbBTeKbzP4+/8kq2G3gaGnD2z+bIc43o=;
        b=N4oO+t2lexcopX+JzjjYhsK0rFmdCIhcasv0XXhnGFcAFhhAfb80pyIWCTG06xx+wx
         DGnoekECibfVwuW87yr7Cx6kj8vuweb12NUJ0ftIx2v362lUsKtPLKULDbXi0SlqC0eL
         DZRcoDIY0V1OGKkzOtuLS5UuEmyvh7WIljFcFodEq3foGryGYn+fo+wxFE8D/hNrb9fO
         eMBBfNdoqSRP1WH0FU5JSWaxPf+K9MZXAqATJK+v2A1fOLXwGQh5Ivq0NRNzn3/ub82x
         E7HdLRV2mupL43s/+Gsjfo0XCI92wMtYet6nW1dPrtkbk7JK8enXalPU0i2q6b5bCxY7
         lxjA==
X-Forwarded-Encrypted: i=1; AJvYcCXuisEVxQvdirWua2no8N8Ho9e342qvpo2sCV58aRdxs7Wup5QAgmlLGCEzKaXuaBuYUFx1/jtqlGhyfhm560plOUPu
X-Gm-Message-State: AOJu0YyNDuQs5r/7QPPNDksEMzlgFsBAefJWFQumzQGgJBx0wDFGdHnl
	R0V+HfqLlRBtNTqKnZmAO+yQK/E43s94Jortfs9l0NRDd/QQWXpvCBlM2Ph+PbZtNLPwH/VyEUV
	V98FFXDQLQGLNe3zyqKNiMddWwtziVqfKqO90g2ljyfxRgbcNPw==
X-Received: by 2002:a05:6000:b02:b0:341:b88b:1625 with SMTP id dj2-20020a0560000b0200b00341b88b1625mr1833207wrb.47.1711621945037;
        Thu, 28 Mar 2024 03:32:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtRmr7MLED52ndtuQiaribupCgpW5/XeVPL8xlVphG3frt96gyLBlt13aNtU8L03uNXpOcew==
X-Received: by 2002:a05:6000:b02:b0:341:b88b:1625 with SMTP id dj2-20020a0560000b0200b00341b88b1625mr1833174wrb.47.1711621944502;
        Thu, 28 Mar 2024 03:32:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:3600:8033:4189:6bd4:ea29? (p200300cbc7143600803341896bd4ea29.dip0.t-ipconnect.de. [2003:cb:c714:3600:8033:4189:6bd4:ea29])
        by smtp.gmail.com with ESMTPSA id bx6-20020a5d5b06000000b00341e67a7a90sm1423428wrb.19.2024.03.28.03.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 03:32:24 -0700 (PDT)
Message-ID: <5cec1f98-17a5-4120-bbf4-b487c2caf92c@redhat.com>
Date: Thu, 28 Mar 2024 11:32:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Quentin Perret <qperret@google.com>
Cc: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 keirf@google.com, linux-mm@kvack.org
References: <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
 <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck>
 <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>
 <ZgVCDPoQbbXjTBQp@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZgVCDPoQbbXjTBQp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

[...]

> 
>> Any state I am missing?
> 
> So there is probably state (0) which is 'owned only by the host'. It's a
> bit obvious, but I'll make it explicit because it has its importance for
> the rest of the discussion.

Yes, I treated it as "simply not mapped into the VM".

> 
> And while at it, there are other cases (memory shared/owned with/by the
> hypervisor and/or TrustZone) but they're somewhat irrelevant to this
> discussion. These pages are usually backed by kernel allocations, so
> much less problematic to deal with. So let's ignore those.
> 
>> Which transitions are possible?
> 
> Basically a page must be in the 'exclusively owned' state for an owner
> to initiate a share or donation. So e.g. a shared page must be unshared
> before it can be donated to someone else (that is true regardless of the
> owner, host, guest, hypervisor, ...). That simplifies significantly the
> state tracking in pKVM.

Makes sense!

> 
>> (1) <-> (2) ? Not sure if the direct transition is possible.
> 
> Yep, not possible.
> 
>> (2) <-> (3) ? IIUC yes.
> 
> Actually it's not directly possible as is. The ballooning procedure is
> essentially a (1) -> (0) transition. (We also tolerate (3) -> (0) in a
> single hypercall when doing ballooning, but it's technically just a
> (3) -> (1) -> (0) sequence that has been micro-optimized).
> 
> Note that state (2) is actually never used for protected VMs. It's
> mainly used to implement standard non-protected VMs. The biggest

Interesting.

> difference in pKVM between protected and non-protected VMs is basically
> that in the former case, in the fault path KVM does a (0) -> (1)
> transition, but in the latter it's (0) -> (2). That implies that in the
> unprotected case, the host remains the page owner and is allowed to
> decide to unshare arbitrary pages, to restrict the guest permissions for
> the shared pages etc, which paves the way for implementing migration,
> swap, ... relatively easily.

I'll have to digest that :)

... does that mean that for pKVM with protected VMs, "shared" pages are 
also never migratable/swappable?

> 
>> (1) <-> (3) ? IIUC yes.
> 
> Yep.
> 
> <snip>
>>> I agree on all of these and, yes, (3) is the problem for us. We've also
>>> been thinking a bit about CoW recently and I suspect the use of
>>> vm_normal_page() in do_wp_page() could lead to issues similar to those
>>> we hit with GUP. There are various ways to approach that, but I'm not
>>> sure what's best.
>>
>> Would COW be required or is that just the nasty side-effect of trying to use
>> anonymous memory?
> 
> That'd qualify as an undesirable side effect I think.

Makes sense!

> 
>>>
>>>> I'm curious, may there be a requirement in the future that shared memory
>>>> could be mapped into other processes? (thinking vhost-user and such things).
>>>
>>> It's not impossible. We use crosvm as our VMM, and that has a
>>> multi-process sandbox mode which I think relies on just that...
>>>
>>
>> Okay, so basing the design on anonymous memory might not be the best choice
>> ... :/
> 
> So, while we're at this stage, let me throw another idea at the wall to
> see if it sticks :-)
> 
> One observation is that a standard memfd would work relatively well for
> pKVM if we had a way to enforce that all mappings to it are MAP_SHARED.

It should be fairly easy to enforce, I wouldn't worry too much about that.

> KVM would still need to take an 'exclusive GUP' from the fault path
> (which may fail in case of a pre-existing GUP, but that's fine), but
> then CoW and friends largely become a non-issue by construction I think.
> Is there any way we could enforce that cleanly? Perhaps introducing a
> sort of 'mmap notifier' would do the trick? By that I mean something a
> bit similar to an MMU notifier offered by memfd that KVM could register
> against whenever the memfd is attached to a protected VM memslot.
> 
> One of the nice things here is that we could retain an entire mapping of
> the whole of guest memory in userspace, conversions wouldn't require any
> additional efforts from userspace. A bad thing is that a process that is
> being passed such a memfd may not expect the new semantic and the
> inability to map !MAP_SHARED. But I guess a process that receives a

I wouldn't worry about the !MAP_SHARED requirement. vhost-user and 
friends all *must* map it MAP_SHARED to do anything reasonable, so 
that's what they do.

> handle to private memory must be enlightened regardless of the type of
> fd, so maybe it's not so bad.
> 
> Thoughts?

The whole reason I brought up the guest_memfd+memfd pair idea is that 
you would similarly be able to do the conversion in the kernel, BUT, 
you'd never be able to mmap+GUP encrypted pages.

Essentially you're using guest_memfd for what it was designed for: 
private memory that is inaccessible.

-- 
Cheers,

David / dhildenb


