Return-Path: <kvm+bounces-56887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7A5B45A1D
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 16:10:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9EB13ADDC1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 14:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E1F3629AB;
	Fri,  5 Sep 2025 14:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sRk8BrOs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B7362089
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757081404; cv=none; b=sPKeUtkyDV1NVMoFI8QdMCarg0MStiKSRu2XBvRsE2P7vHe8IaAydR994CCbf/nd57qRdnzjhWU3AeQO864ZTcYuJ6mCBCQd/wL869NWmWaOGTNF7G2qWrys/uNrj7NsExP5QHp5FNA1eRxP5c0hwZZu4BH73smx6Zjh2VFf6jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757081404; c=relaxed/simple;
	bh=oVu6rTZbUhGzPDAYb9Eb7nO0W+rPrpZjkGeIPs5Do4Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KZdL0cx0lKS5F2STc7jcnpJXD07IJYM6v0vnEhbKDMwAbDxM+5iKQmkRZcniW4k/HtnJEilFHdZBTzA5QiG+m8Sekq1pFMoJ4SUxuEX9SlC1kIwo4T+it7VEROQEQ4BtFiogy0HyGKlRFg9t+hTCwM4l/Cle2ffj7pvrGyfUh6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sRk8BrOs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-329ccb59ef6so2570038a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 07:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757081402; x=1757686202; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2cnfE4bCiy2VBXs12iYQk842LQr812w5LNrCYBvaphs=;
        b=sRk8BrOsR6lefmJWisedk728LmzQvbvAR3NCMLCHK+HODifRaFLkq+/n5pVqjGy2dB
         wU8KZ3HpfcOBOUHUFesbqNaAElC6+5VIiYbFvfl8rPe08AzpF6exRNJf851zJ39gvpuB
         gn9lqhilcicmsIvqJTsNcusJ3y+YEXfdlVyLu7moMpYGF/b9VzI5JTtQ2jSZxUa/zvmG
         28vx2c/J2elRf2nMJpc4PoeFE/5HrqO3qDwIlQC/YMQ/fl4UghrsBGDPNDukNEghWPBP
         uB5388GD9I0CsU/NXoZqUSbjlCGn3ERSVKKATJoQRgAQx9HMdQmGkZZn1tIxx8g0achw
         /pcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757081402; x=1757686202;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2cnfE4bCiy2VBXs12iYQk842LQr812w5LNrCYBvaphs=;
        b=fd5GsXfXeATDs1O1So85F41MoHTpMy3gHOC3QV0z3Os7ed6J22eAtrBE/6bBclIvPP
         1YCL/OJ4hz6jmFKFBP0tY6E5z/P7kFmcwcCbl+SPs0SxDzi2NlNa8m55r4828vwux76v
         rSHROeBk5IfBQAPLd0U13Jmeal+TUIY66SMEQ88i3EwTDag7hoh/aQ5n77RjuOK6ZRz6
         lTMgYU5BwRF4dWZANBcYQQzfBpD4rK6jw4tNBsEYs0hbpNagT3g9W0e31nU1gKhocxYn
         uL42/4PpwiqFZKFF1RgEHAvimFFZLg7Hmtyt304b+msIcZSDqJp1woX4Ke/f3GHJDX2C
         t8dg==
X-Gm-Message-State: AOJu0YxJz9UIwPtZLZsiECt2gEdjaeLPeqI3P/8MLdqW9/By2OJr5S6h
	mFmOtcMgG2enmuImCKDdRMAkI6Ci22iRvRL7W+0hHt3NXLZ8sDHHFlpQIMgREuR7Nvr4N7vN/sR
	CsuYxTA==
X-Google-Smtp-Source: AGHT+IEOLpxllDHvfK5C/dA8xOZcRKV2+JrJ68qneanLw4PJD2TZQegnG8wL7O0EjCXIXyLbhYUtND9DG8o=
X-Received: from pjeb1.prod.google.com ([2002:a17:90a:10c1:b0:32b:b3c4:a304])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3952:b0:32b:87b7:6dd9
 with SMTP id 98e67ed59e1d1-32b87b7706cmr10790960a91.12.1757081402340; Fri, 05
 Sep 2025 07:10:02 -0700 (PDT)
Date: Fri, 5 Sep 2025 07:09:49 -0700
In-Reply-To: <20221005211551.152216-1-thanos.makatos@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
Message-ID: <aLrvLfkiz6TwR4ML@google.com>
Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
From: Sean Christopherson <seanjc@google.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>
Cc: kvm@vger.kernel.org, john.levon@nutanix.com, mst@redhat.com, 
	john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com, 
	jasowang@redhat.com, stefanha@redhat.com, jag.raman@oracle.com, 
	eafanasova@gmail.com, elena.ufimtseva@oracle.com, changpeng.liu@intel.com, 
	james.r.harris@intel.com, benjamin.walker@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 05, 2022, Thanos Makatos wrote:

Amusingly, I floated this exact idea internally without ever seeing this patch
(we ended up going a different direction).  Sadly, I can't claim infringement,
as my suggestion was timestamped from December 2022 :-D

If this is useful for y'all, I don't see a reason not to do it.

> ---
>  include/uapi/linux/kvm.h       | 5 ++++-
>  tools/include/uapi/linux/kvm.h | 2 ++
>  virt/kvm/eventfd.c             | 9 +++++++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index eed0315a77a6..0a884ac1cc76 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -804,6 +804,7 @@ enum {
>  	kvm_ioeventfd_flag_nr_deassign,
>  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
>  	kvm_ioeventfd_flag_nr_fast_mmio,
> +	kvm_ioevetnfd_flag_nr_commit_write,
>  	kvm_ioeventfd_flag_nr_max,
>  };
>  
> @@ -812,16 +813,18 @@ enum {
>  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
>  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
>  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit_write)

Maybe POST_WRITE to try to capture the effective semantics?  As for read after
write hazards, my vote is to document that KVM provides no guarantees on that
front.  I can't envision a use case where it makes sense to provide guarantees
in the kernel, since doing so would largely defeat the purpose of handling writes
in the fastpath.

>  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
>  
>  struct kvm_ioeventfd {
>  	__u64 datamatch;
>  	__u64 addr;        /* legal pio/mmio address */
> +	__u64 vaddr;       /* user address to write to if COMMIT_WRITE is set */

This needs to be placed at the end, i.e. actually needs to consume the pad[]
bytes.  Inserting into the middle changes the layout of the structure and thus
breaks ABI.

And maybe post_addr (or commit_addr)?  Because vaddr might be interpreted as the
host virtual address that corresponds to "addr", which may or may not be the case.

>  	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
>  	__s32 fd;
>  	__u32 flags;
> -	__u8  pad[36];
> +	__u8  pad[28];
>  };
 
...

> @@ -812,6 +813,7 @@ enum {
>  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
>  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
>  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit_write)
>  
>  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2a3ed401ce46..c98e7b54fafa 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -682,6 +682,8 @@ struct _ioeventfd {
>  	struct kvm_io_device dev;
>  	u8                   bus_idx;
>  	bool                 wildcard;
> +	bool                 commit_write;
> +	void                 *vaddr;

There's no need for a separate bool, just pivot on the validity of the pointer.
The simplest approach is to disallow NULL pointers (which aren't technically
illegal for userspace, but I doubt any use case actually cares).  Alternatively,
set the internal pointer to e.g. -EINVAL and then act on !IS_ERR().

The pointer also needs to be tagged __user.

>  };
>  
>  static inline struct _ioeventfd *
> @@ -753,6 +755,10 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>  	if (!ioeventfd_in_range(p, addr, len, val))
>  		return -EOPNOTSUPP;
>  
> +	if (p->commit_write) {
> +		if (unlikely(copy_to_user(p->vaddr, val, len)))

This needs to check that len > 0.  I think it's also worth hoisting the validity
checks into kvm_assign_ioeventfd_idx() so that this can use the slightly more
optimal __copy_to_user().

E.g. 

	if (args->flags & KVM_IOEVENTFD_FLAG_REDIRECT) {
		if (!args->len || !args->post_addr ||
		    args->redirect != untagged_addr(args->post_addr) ||
		    !access_ok((void __user *)(unsigned long)args->post_addr, args->len)) {
			ret = -EINVAL;
			goto fail;
		}

		p->post_addr = (void __user *)(unsigned long)args->post_addr;
	}

And then the usage here can be

	if (p->post_addr && __copy_to_user(p->post_addr, val, len))
		return -EFAULT;

I assume the spinlock in eventfd_signal() provides ordering even on weakly
ordered architectures, but we should double check that, i.e. that we don't need
an explicitly barrier of some kind.

Lastly, I believe kvm_deassign_ioeventfd_idx() needs to check for a match on
post_addr (or whatever it gets named).

> +			return -EFAULT;
> +	}
>  	eventfd_signal(p->eventfd, 1);
>  	return 0;
>  }
> @@ -832,6 +838,9 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
>  	else
>  		p->wildcard = true;
>  
> +	p->commit_write = args->flags & KVM_IOEVENTFD_FLAG_COMMIT_WRITE;
> +	p->vaddr = (void *)args->vaddr;
> +
>  	mutex_lock(&kvm->slots_lock);
>  
>  	/* Verify that there isn't a match already */
> -- 
> 2.22.3
> 

