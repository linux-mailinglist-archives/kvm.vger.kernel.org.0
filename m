Return-Path: <kvm+bounces-43114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D945A84FBD
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E81F619E890F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D18620D4F9;
	Thu, 10 Apr 2025 22:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DwCLsEdK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EA21EBA03
	for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744325053; cv=none; b=pFIsX0lrCSwP9Jz1WQckWOPkaZiRA8SxqGkQtIUhriI/zMDSSN4pmBV80v1bhoeD2ePxLdOQO0H+oYfsh25RvNsazC+5r6VAadBNLfh4nntgCeNhDlHuD5zR1Tv4IQgD6n5rkhEYXZXVr6Fu9/66KaLAAuGAnO09yvJXfoB/6I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744325053; c=relaxed/simple;
	bh=wa/Rh13hQx92rRge1q1HAZxI2JO3FMA+gXbCNHClTfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ufoasSYAAM05TMhRaUTj2C/1ip9CIWEJ6ZwTDqI9qwdXwDIjYJIWdYbXzT3viuoe33TJh63Yagl10pKK0zrjhnwA3PIblxppuTvwsUvIbRLPliN98Xh+S2zUKYJXa9W+Mrgq94w5WWn2a3rpmW03kQKKZcn8oq3mC72R+uP4bAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DwCLsEdK; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-739515de999so1197997b3a.1
        for <kvm@vger.kernel.org>; Thu, 10 Apr 2025 15:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744325051; x=1744929851; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8q3CiISuCdraqP5NmbHkgBNhRWV9JENCPu8CVDBomok=;
        b=DwCLsEdKoyiblmGAykg+0nGOkRhYSjGYCRK7+wEY5GbKg/ypLDCV7Hq+sliNnTnRH0
         /ULGAFRI1VfpWgNKN2MXdf0J6d/AjaVw4CPYOmZAL0KZHdQS95xsFmdrg1V5Kt+tNr32
         x+pZfo94dOpi0VwJPCBW68zhhSVeW+IIEd3+Coh3IK5fYU4scJE3DPNtbmv/z2F5918y
         nZ3iO629OcFyj1DffQnxFpVARPo1O4n7mb/ysZ1xlYQNwep/UuvNEVL1B5I3VxyY1yzf
         KlZU4CJh8CWvXFaHjjnFknNr6dT+fjdwJ8mTyI4F31XRQDTTKf60VZCFQCUvKRGmy/Wn
         pkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744325051; x=1744929851;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8q3CiISuCdraqP5NmbHkgBNhRWV9JENCPu8CVDBomok=;
        b=MJbEphWpMP4VbLirlD9ub3zDxLcp4z8sCVkt5vlOnOs8NNM6jVJSn+TBCeqKuOBrl2
         On2/CDEpuL1qsZh4EZZjL2O4ids+0xN05zjr4GtlZZzhqyU2cBNTVvukoYqZ7J4fuxT+
         F3sQxCFQuFT4oopdHLEpnim11kcvTkuADsFEEhW3pTgmO8DrCyPkhzI9kVCF5acyGo13
         8++uGFD+0Nk04c//M2JDMC2dzPEwURVgxkZ2uhQtcILhObYUz6tiOngUhP5/jJJPHy6q
         nKFbHNihXTsW9WwCzESpJb6+N88nbHnrodGco5GbZjaKog0DA+gUopQUvNUoX95Bs6uR
         uaKw==
X-Forwarded-Encrypted: i=1; AJvYcCWx24eX2uKqQEqF0N/MGQvqqXnMZqonYKhPeLlsag+mMd3+jTCce9oYIwhOiCcWPswmszk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTuZMwXh4wxaKS36myrbs0PDK0MGHmgRR5IOyd/z3SbsPKgX1k
	ds6XVqZDwitpOrOdKos1yZK+GmIYx6ezBT7ckGmApYs5tlh/S4yITSoQvXyp3SHQoKA9tCPBzsG
	+Bd3IFr9Sl8i/JngLOrhgwA==
X-Google-Smtp-Source: AGHT+IEYlt0gVCvlaMwf0civi1/Gt1C+rN2vsEcK26X/Wy47JZJtnV7Cpm0OLOPQfOn3q9dHvyxaDidMfs1bvz2+7A==
X-Received: from pfbi30.prod.google.com ([2002:a05:6a00:af1e:b0:739:4935:6146])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a01:b0:736:69aa:112c with SMTP id d2e1a72fcca58-73bd11e26d6mr589808b3a.9.1744325051085;
 Thu, 10 Apr 2025 15:44:11 -0700 (PDT)
Date: Thu, 10 Apr 2025 15:44:09 -0700
In-Reply-To: <d5942725-2789-4626-bee1-81d69ed794f8@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-4-tabba@google.com>
 <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com> <diqzr022twsw.fsf@ackerleytng-ctop.c.googlers.com>
 <d5942725-2789-4626-bee1-81d69ed794f8@amd.com>
Message-ID: <diqzzfgn4oxy.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v7 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Shivank Garg <shivankg@amd.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Shivank Garg <shivankg@amd.com> writes:

> On 4/8/2025 10:28 PM, Ackerley Tng wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>> 
>>> Hi Fuad,
>>>
>>> On 3/18/2025 9:48 PM, Fuad Tabba wrote:
>>>> Add support for mmap() and fault() for guest_memfd backed memory
>>>> in the host for VMs that support in-place conversion between
>>>> shared and private. To that end, this patch adds the ability to
>>>> check whether the VM type supports in-place conversion, and only
>>>> allows mapping its memory if that's the case.
>>>>
>>>> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
>>>> indicates that the VM supports shared memory in guest_memfd, or
>>>> that the host can create VMs that support shared memory.
>>>> Supporting shared memory implies that memory can be mapped when
>>>> shared with the host.
>>>>
>>>> This is controlled by the KVM_GMEM_SHARED_MEM configuration
>>>> option.
>>>>
>>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>>
>>> ...
>>> ...
>>>> +
>>>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>>>> +{
>>>> +	struct kvm_gmem *gmem = file->private_data;
>>>> +
>>>> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
>>>> +		return -ENODEV;
>>>> +
>>>> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>>>> +	    (VM_SHARED | VM_MAYSHARE)) {
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	file_accessed(file);
>>>
>>> As it is not directly visible to userspace, do we need to update the
>>> file's access time via file_accessed()?
>>>
>> 
>> Could you explain a little more about this being directly visible to
>> userspace?
>> 
>> IIUC generic_fillattr(), which guest_memfd uses, will fill stat->atime
>> from the inode's atime. file_accessed() will update atime and so this
>> should be userspace accessible. (Unless I missed something along the way
>> that blocks the update)
>> 
>
> By visibility to userspace, I meant that guest_memfd is in-memory and not
> directly exposed to users as a traditional file would be.

shmem is also in-memory and uses updates atime, so I guess being
in-memory doesn't mean we shouldn't update atime.

guest_memfd is not quite traditional, but would the mmap patches Fuad is
working on now qualify the guest_memfd as more traditional?

>
> Yes, theoretically atime is accessible to user, but is it actually useful for
> guest_memfd, and do users track atime in this context? In my understanding,
> this might be an unnecessary unless we want to maintain it for VFS consistency.
>
> My analysis of the call flow:
> fstat() -> vfs_fstat() -> vfs_getattr() -> vfs_getattr_nosec() -> kvm_gmem_getattr()
> I couldn't find any kernel-side consumers of inode's atime or instances where
> it's being used for any internal purposes.
>
> Searching for examples, I found secretmem_mmap() skips file_accessed().
>

I guess I'm okay both ways, I don't think I have a use case for reading
atime, but I assumed VFS consistency is a good thing.

>
> Also as side note, I believe the kvm_gmem_getattr() ops implementation
> might be unnecessary here.
> Since kvm_gmem_getattr() is simply calling generic_fillattr() without
> any special handling, couldn't we just use the default implementation?
>
> int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>                       u32 request_mask, unsigned int query_flags)
> {
> ...
>         if (inode->i_op->getattr)
>                 return inode->i_op->getattr(idmap, path, stat,
>                                             request_mask,
>                                             query_flags);
>
>         generic_fillattr(idmap, request_mask, inode, stat);
>         return 0;
> }

I noticed this too. I agree that we could actually just use
generic_fillattr() by not specifying ->getattr().

>
> I might be missing some context. Please feel free to correct me
> if I've misunderstood anything.
>
> Thanks,
> Shivank
>
>>>> +	vm_flags_set(vma, VM_DONTDUMP);
>>>> +	vma->vm_ops = &kvm_gmem_vm_ops;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +#else
>>>> +#define kvm_gmem_mmap NULL
>>>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>>>> +
>>>>  static struct file_operations kvm_gmem_fops = {
>>>> +	.mmap		= kvm_gmem_mmap,
>>>>  	.open		= generic_file_open,
>>>>  	.release	= kvm_gmem_release,
>>>>  	.fallocate	= kvm_gmem_fallocate,
>>>
>>> Thanks,
>>> Shivank

