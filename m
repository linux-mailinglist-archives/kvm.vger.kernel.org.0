Return-Path: <kvm+bounces-39943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DB4A4CFDB
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 01:19:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A474171596
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 00:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FBB71A260;
	Tue,  4 Mar 2025 00:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rEXHFwOB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C208837
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 00:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741047545; cv=none; b=h0vwVo5GFT3DpCGdOAY5QN5t+Om1UnPPJHvm2qGmKsH1ziHdAuGlhtIAiCke6H2DUh5Ujxep4tBnQIP4N4SKRIe8A4KJMj9WIOKdPgp0Lo9PrS3YF8uRU7lxWkih0Hzjj6eSsbVGoO/V2oFZDOWTU4vmC4eDWlIcofJblsjw52g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741047545; c=relaxed/simple;
	bh=om4PCQPoPa4VZTX5RXZmkisQn/L+HobOuJGn+TrX82k=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nEr/LbTci1TlzwC00x9E/hAYFXoOVmcry5XrlZ9zCd/MFzM5Tpiwjo8CzFtIwI+EQ6zfULap2cq43UdwKE1QoRk3JWXe+EwRZhvzXHpyvDPv9fTiMA4xwQ7gvnmZ1fZCx6XRAIfaBxv9d0MG8X5IQwfxKS1WxSZIURyLY90Vk8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rEXHFwOB; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22366901375so81259285ad.0
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 16:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741047543; x=1741652343; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TDyYj5B62h+Bnx/iegfnSRCOJrRTTkL1sRbV1d02P2o=;
        b=rEXHFwOBLn3iPcfx0HDFxrfJ9ESIe29A9k6SXpUfMIFkqxBIfdNkkq4q46GgboCI8j
         ouVfCyLxdSvYz8C1QeW8uqfQ2p4Coyc1cRR3CYBCegP9Qr+gi2+aNnoo97g/ahlu04qD
         irRnTLqku7FD+O+UT8Njr23By0s7GRwA8hbI18y3KWUoFxvWspgTR7CtQVXr+xDNkIhy
         w2MYdpJ+ODvQVxMqPbjAXcKFhB/mWR/gLzHMGtm53NHPGY1OYamQO0vZ2qUAtEoNlGyM
         xV2H02obUJwFf1HB8jDFEsWKA8sWDOsFtlEIdN3oQbbBGUiooczdh1/zy6l93kW/pECG
         FDIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741047543; x=1741652343;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TDyYj5B62h+Bnx/iegfnSRCOJrRTTkL1sRbV1d02P2o=;
        b=HSkJ+Bbet/dIc6c0EaDffmDQ4prGDvw2q/fHxMCUyyjzJv/ccYf2m1h4r5i3yixMf4
         OW3DBgQ3xZYjNFC3O3o5Dbj9eIvxIHp8yHamArSTHz7pU/BbgK6v0kqyGPl9TUjNGJKM
         qG9Lvw39V9Nj8X+6RRig5Zjybx6Lfyz4TMHe5SW1lRJ1lUY2IEBlM5Q4ckRUazpTp2WA
         IrM7qci0OGWq6Cn07KxVjMKMiRHbvDthFMF/F4ZXqIzrR0J0LDG2f3nnbFY+8Hghob1U
         NF3tn0E9pF5PK5RbcDPP64VOZZ5WXxC1r0qKzMTa9A4p5lepkTTKUmGH951i43jN5If9
         /3og==
X-Forwarded-Encrypted: i=1; AJvYcCW5k970vtG9R7vf1faiWhUT7gYzAptCoJYKIEjLCtd4V71tqu73GhSbFt0VneG394D/M48=@vger.kernel.org
X-Gm-Message-State: AOJu0YxueqVErZW+6EUxzGPdAx+eM49V2ziJOQpT/Sw7rvSpCIxt13KZ
	NswIEssywb2Tb+j5OiP5XXdMtbCGLGvtdwmgcyxXceyBPfkcRZDTAAU0XuHG3Rel4tdWs+8TZYI
	4tH5S3P6XQNnJWVEroBpZZA==
X-Google-Smtp-Source: AGHT+IGjrHco3Rt+VZziwKrqBORZRwSaK6/c6j7Oy5v1wwCg0MU8Clnd3M8Xq66zBx5JDkHN1Q0qDWfyKXWIOSRuKw==
X-Received: from pfbei32.prod.google.com ([2002:a05:6a00:80e0:b0:725:1ef3:c075])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:72a1:b0:1e1:a449:ff71 with SMTP id adf61e73a8af0-1f3390f51f8mr2373495637.1.1741047543098;
 Mon, 03 Mar 2025 16:19:03 -0800 (PST)
Date: Tue, 04 Mar 2025 00:19:01 +0000
In-Reply-To: <b494af0e-3441-48d4-abc8-df3d5c006935@suse.cz> (message from
 Vlastimil Babka on Mon, 3 Mar 2025 09:58:51 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqz8qplabre.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v6 4/5] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Ackerley Tng <ackerleytng@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: shivankg@amd.com, akpm@linux-foundation.org, willy@infradead.org, 
	pbonzini@redhat.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	chao.gao@intel.com, seanjc@google.com, david@redhat.com, bharata@amd.com, 
	nikunj@amd.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Vlastimil Babka <vbabka@suse.cz> writes:

> On 2/28/25 18:25, Ackerley Tng wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>> 
>>> Previously, guest-memfd allocations followed local NUMA node id in absence
>>> of process mempolicy, resulting in arbitrary memory allocation.
>>> Moreover, mbind() couldn't be used since memory wasn't mapped to userspace
>>> in the VMM.
>>>
>>> Enable NUMA policy support by implementing vm_ops for guest-memfd mmap
>>> operation. This allows the VMM to map the memory and use mbind() to set
>>> the desired NUMA policy. The policy is then retrieved via
>>> mpol_shared_policy_lookup() and passed to filemap_grab_folio_mpol() to
>>> ensure that allocations follow the specified memory policy.
>>>
>>> This enables the VMM to control guest memory NUMA placement by calling
>>> mbind() on the mapped memory regions, providing fine-grained control over
>>> guest memory allocation across NUMA nodes.
>>>
>>> The policy change only affect future allocations and does not migrate
>>> existing memory. This matches mbind(2)'s default behavior which affects
>>> only new allocations unless overridden with MPOL_MF_MOVE/MPOL_MF_MOVE_ALL
>>> flags, which are not supported for guest_memfd as it is unmovable.
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>> ---
>>>  virt/kvm/guest_memfd.c | 76 +++++++++++++++++++++++++++++++++++++++++-
>>>  1 file changed, 75 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>>> index f18176976ae3..b3a8819117a0 100644
>>> --- a/virt/kvm/guest_memfd.c
>>> +++ b/virt/kvm/guest_memfd.c
>>> @@ -2,6 +2,7 @@
>>>  #include <linux/backing-dev.h>
>>>  #include <linux/falloc.h>
>>>  #include <linux/kvm_host.h>
>>> +#include <linux/mempolicy.h>
>>>  #include <linux/pagemap.h>
>>>  #include <linux/anon_inodes.h>
>>>
>>> @@ -11,8 +12,12 @@ struct kvm_gmem {
>>>  	struct kvm *kvm;
>>>  	struct xarray bindings;
>>>  	struct list_head entry;
>>> +	struct shared_policy policy;
>>>  };
>>>
>> 
>> struct shared_policy should be stored on the inode rather than the file,
>> since the memory policy is a property of the memory (struct inode),
>> rather than a property of how the memory is used for a given VM (struct
>> file).
>
> That makes sense. AFAICS shmem also uses inodes to store policy.
>
>> When the shared_policy is stored on the inode, intra-host migration [1]
>> will work correctly, since the while the inode will be transferred from
>> one VM (struct kvm) to another, the file (a VM's view/bindings of the
>> memory) will be recreated for the new VM.
>> 
>> I'm thinking of having a patch like this [2] to introduce inodes.
>
> shmem has it easier by already having inodes
>
>> With this, we shouldn't need to pass file pointers instead of inode
>> pointers.
>
> Any downsides, besides more work needed? Or is it feasible to do it using
> files now and convert to inodes later?
>
> Feels like something that must have been discussed already, but I don't
> recall specifics.

Here's where Sean described file vs inode: "The inode is effectively the
raw underlying physical storage, while the file is the VM's view of that
storage." [1].

I guess you're right that for now there is little distinction between
file and inode and using file should be feasible, but I feel that this
dilutes the original intent. Something like [2] doesn't seem like too
big of a change and could perhaps be included earlier rather than later,
since it will also contribute to support for restricted mapping [3].

[1] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com/
[2] https://lore.kernel.org/all/d1940d466fc69472c8b6dda95df2e0522b2d8744.1726009989.git.ackerleytng@google.com/
[3] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/T/

