Return-Path: <kvm+bounces-42952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74414A8131E
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 18:59:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64E264C34D6
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 16:58:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88FAEB676;
	Tue,  8 Apr 2025 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSIZjP3M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443E122FAD4
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131507; cv=none; b=iVL2N7OfJFBuOCLbWEeNRHUpWtkqmw9pV1YZ3xaPQo7uhnJdZdaqnOdtsS39bK3gZV1Jfm6uzQBPn2UBGoJWfGxYldQAkvqul4YjkzfHZ6XUc9CT89ZRI3hfMj0gHnW+Ow8Xt8/GosEdQvajSmWLb2vnHScVUSs9iwsSNNCDu9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131507; c=relaxed/simple;
	bh=1yHW+WngQPDcxfP4JH1rGuORo3S8ePfGj/4p30/ZjG4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=F0uOOfyjzKbuutZHzTgVJWUwd6A9o++cTTyK//08QqIk09p/U+qadMi9CkOl1mABoeQU80Z0cLHKrOK2LXeWUQD0PhAUqo//53aB1UHhrKOF6E9+I9sMEUCOhoAY3T01/uD9wjTtNAzfBHLeQPOzFlym7Gz99Yny/25LQW3oUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSIZjP3M; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso5602397a91.0
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 09:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744131505; x=1744736305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/cspsRoH7mgvJKsLmS0oN+FfcvZOZE3BpLLUKAvOl4=;
        b=cSIZjP3MUj4KMRKAjqY8bK7uPsYJjmCWLFKRW/eL+E7CAWrMR1ZKFk6lN8t0C/U+me
         Bxt1hgpMSuhkUagbBUboxx1uZhBpIcUPohct1hoLr/WwTBB6cyppIjJuSuDn9SrXFcku
         a7Zo4+6RdebbLVhNdCBQFNMYoSu7tHuOpe/ZOfSoCisg6bkuqvqE7rD0AUhmqtDGSHRZ
         6FEugAZM45JSH+XC5ji92fcUeKqtdinSNnxfUNixUQ+ObhP8jyDol2Zg1rYjranjhB5z
         a2KAPxPxzO/+CKAm+NTFVUvgeh9kusjOIYhz/qMxxK5vFnPT5+7rT2RpA/eTkGBXnGBv
         Q24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744131505; x=1744736305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/cspsRoH7mgvJKsLmS0oN+FfcvZOZE3BpLLUKAvOl4=;
        b=pInqVLRBLaTj+yEA5LarbkZepb8NctI6a8GolnBlEy7BJBWNxZZiaAZXWTl9FnCYTU
         H7CsbjxGoJjO0FnGiATxlPIKRJBbblrAwx9AYJj2wULEYMIHC2MiSLJWbV8CAwdApihl
         T+Gg62Rj2PRtnG8UPGwELrv7HcNYqwlEubkMahjIQdPnIvn973Yd2kFc4mIGONZkHsjx
         sStWCCn9qUZI8tm4DIiQMDozPkIssQmPUFg75+43YVZIv1hDZvBOuIuaWRR9tZH9efvo
         RX+7yOOxDlkkPGF7jCwV/GKtsCC9m+yF6m382gaOuPdOPQlTN0eXyoX+RMneXGo20lud
         DOKA==
X-Forwarded-Encrypted: i=1; AJvYcCX9AqerMqV7gD5I1whsry5AHO13YO9Q38a4Dm7TAZRNHruZ/ScWoXOmagwM+Hfxkc3rtes=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk4DGLTO+/seSNxMRwwy62o2SxjzDrWmsaGpIgJYxZYipxaHyl
	4Rkx0rVdqeJki0C8ecZ5+PTcN0nTbDWBLoP4DJhYBcwj4qiDHBemikTdhXl/x3pggHocXVqlgTx
	zPiAeUBo9I2wpGA/oJ2yjiw==
X-Google-Smtp-Source: AGHT+IHhG5hSB3aOnKu/HHrAmMFRLsHAG6Yf/NLT6GaoqAr+8hqPxs0sYHiqY17BjjeR0rXHNDk0o7C4Y+BsIOeodw==
X-Received: from pjbse3.prod.google.com ([2002:a17:90b:5183:b0:2ee:3128:390f])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:51cb:b0:2fe:861b:1ae3 with SMTP id 98e67ed59e1d1-306af7178cemr18710322a91.8.1744131505344;
 Tue, 08 Apr 2025 09:58:25 -0700 (PDT)
Date: Tue, 08 Apr 2025 09:58:23 -0700
In-Reply-To: <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318161823.4005529-1-tabba@google.com> <20250318161823.4005529-4-tabba@google.com>
 <aeed695d-043d-45f6-99f3-e41f4a698963@amd.com>
Message-ID: <diqzr022twsw.fsf@ackerleytng-ctop.c.googlers.com>
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

> Hi Fuad,
>
> On 3/18/2025 9:48 PM, Fuad Tabba wrote:
>> Add support for mmap() and fault() for guest_memfd backed memory
>> in the host for VMs that support in-place conversion between
>> shared and private. To that end, this patch adds the ability to
>> check whether the VM type supports in-place conversion, and only
>> allows mapping its memory if that's the case.
>> 
>> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
>> indicates that the VM supports shared memory in guest_memfd, or
>> that the host can create VMs that support shared memory.
>> Supporting shared memory implies that memory can be mapped when
>> shared with the host.
>> 
>> This is controlled by the KVM_GMEM_SHARED_MEM configuration
>> option.
>> 
>> Signed-off-by: Fuad Tabba <tabba@google.com>
>
> ...
> ...
>> +
>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	struct kvm_gmem *gmem = file->private_data;
>> +
>> +	if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
>> +		return -ENODEV;
>> +
>> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>> +	    (VM_SHARED | VM_MAYSHARE)) {
>> +		return -EINVAL;
>> +	}
>> +
>> +	file_accessed(file);
>
> As it is not directly visible to userspace, do we need to update the
> file's access time via file_accessed()?
>

Could you explain a little more about this being directly visible to
userspace?

IIUC generic_fillattr(), which guest_memfd uses, will fill stat->atime
from the inode's atime. file_accessed() will update atime and so this
should be userspace accessible. (Unless I missed something along the way
that blocks the update)

>> +	vm_flags_set(vma, VM_DONTDUMP);
>> +	vma->vm_ops = &kvm_gmem_vm_ops;
>> +
>> +	return 0;
>> +}
>> +#else
>> +#define kvm_gmem_mmap NULL
>> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
>> +
>>  static struct file_operations kvm_gmem_fops = {
>> +	.mmap		= kvm_gmem_mmap,
>>  	.open		= generic_file_open,
>>  	.release	= kvm_gmem_release,
>>  	.fallocate	= kvm_gmem_fallocate,
>
> Thanks,
> Shivank

