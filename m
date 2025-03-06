Return-Path: <kvm+bounces-40254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A18A55040
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:10:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E673016E07D
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 16:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27682116F6;
	Thu,  6 Mar 2025 16:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VzjOYvhw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C838210F6D
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741277397; cv=none; b=HDYPHvWAAnPWLZFGgcRrgFY4TD1dHwBCg+Oox9UECxtEThX6eeRim4cUxLrsmYo3DOWCt7mf1/Rnm+RqxLx1JyW2B3QiG0aAKeEhVejTQXT0bajWHf3t/m+4VeqX7BdZlJ7+BnBlkSTvo0q8qXZCJLd7qHU14QCRq3VqfUT26Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741277397; c=relaxed/simple;
	bh=dSkSnGRSTg6/8HCqL1kZd6r14a9sf9T98LpqXDkluBw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lSRoUTnybYx9LkrJuHXLcK1bbtB+uT4/U6U1EwlFhjRnkvzgU9bMEXjNhFf/kgbEGVV+MnIs67Rzq7Dk4da0QfbkEiGTl5kFIZ/i5ys6ByFmdEqsI4nuAd5CScf57r6iagnpPyYPoqNY4QrYzL/ntyHYXYpSRo8kLTZd8NjVHM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VzjOYvhw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff581215a0so2634665a91.0
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 08:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741277395; x=1741882195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Hs/rNKptw4ZYO6spUUnJ/Zhn7gqoIyuxcR/DXY52zCs=;
        b=VzjOYvhwSb6uAqJDgLIo/imMcae4YtF25vUnudowGVN0oWwO30CUzfJTxkBdEMBXjD
         F7PyrGzjp1nwMF3G8zEWtTaYxTIE3RD11vnWw0X7W0+qsNNWTaGrGTcGRMOkO6CN3sh4
         1VLMAE1F7NjlyBcqMipLAeYsxApJ5pfSpZb3mx6gPBivZ99LzzEnpPvPgaWUqvnYjwo8
         TwMG1QhlGxOqqQSpm81rJ9D6Gg/upC1iegKY2U05dxKN7mPF1XZltpRF/mz9+isI8IHN
         9DvJ2UTdbMgYu1tsHUNaG5GHDNSBvzCJI7hsEaim/FwhlMUCLMErrpyGK6iwI2dXTxrr
         OW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741277395; x=1741882195;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hs/rNKptw4ZYO6spUUnJ/Zhn7gqoIyuxcR/DXY52zCs=;
        b=BDwSg2CNOWWG4SErrgOAKyBvb/p2C0Z7422OfwsldzaIDT6HxZZVdjbLCFAJbSilL/
         D/9S0ez+7/IEI6hmjAg2HFKXGmrd+PnetnamyseJRUkI+JSod/tsKPR6XEcYGTv48Ow0
         FpLBVETyY+sctEvrz9JkdJpyG/zMjcEi74EFGEJ17mjMlvFtqrXlrCDrrtJs3rvxe+z+
         6ahOlu6oxHIGSS/iYmL3LaAa/1m+JYFP3f/GByImJzaqd7+TmQTVpJzu21JYph2IGNnT
         v2qZf/bvyvVDgU/wVPFQ9iao65NyAPi/anw+oMRkvZ0b7BQcyifp76C7MXU3Iw1NqTCO
         RnlQ==
X-Gm-Message-State: AOJu0YxqUoFeNWxXmMA8SJOYlmFYwGnVPva/dxB8CmVFfyIIbQNf6J+u
	kWK2+hIpXQBV7x01ixjNROT9n6ffhpstoOr+LsaoDGf4D2xRU6ap0B+m2SGZAerTzwfktEbOCgk
	/uheB+PwPj+AL/szjkMSF5g==
X-Google-Smtp-Source: AGHT+IHZELEys14r7zs4SZgmd2W46MIv/QUbWyKYwMP6mPNo6vZ2zpUnDCZiIhuHsH03hVH88HWBYJTxZmQFNJNnRQ==
X-Received: from pjbnd9.prod.google.com ([2002:a17:90b:4cc9:b0:2ef:9b30:69d3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:38c4:b0:2ff:6a5f:9b39 with SMTP id 98e67ed59e1d1-2ff6a5f9ba4mr4264848a91.18.1741277395327;
 Thu, 06 Mar 2025 08:09:55 -0800 (PST)
Date: Thu, 06 Mar 2025 16:09:54 +0000
In-Reply-To: <20250303171013.3548775-5-tabba@google.com> (message from Fuad
 Tabba on Mon,  3 Mar 2025 17:10:08 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzldtita25.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v5 4/9] KVM: guest_memfd: Handle in-place shared memory as
 guest_memfd backed memory
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
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
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> For VMs that allow sharing guest_memfd backed memory in-place,
> handle that memory the same as "private" guest_memfd memory. This
> means that faulting that memory in the host or in the guest will
> go through the guest_memfd subsystem.
>
> Note that the word "private" in the name of the function
> kvm_mem_is_private() doesn't necessarily indicate that the memory
> isn't shared, but is due to the history and evolution of
> guest_memfd and the various names it has received. In effect,
> this function is used to multiplex between the path of a normal
> page fault and the path of a guest_memfd backed page fault.
>

I think this explanation is a good summary, but this change seems to
make KVM take pages via guest_memfd functions for more than just
guest-private pages.

This change picks the guest_memfd fault path as long as the memslot has
an associated guest_memfd (kvm_slot_can_be_private()) and gmem was
configured to kvm_arch_gmem_supports_shared_mem().

For shared accesses, shouldn't KVM use the memslot's userspace_addr?
It's still possibly the same mmap-ed guest_memfd inode, but via
userspace_addr. And for special accesses from within KVM (e.g. clock),
maybe some other changes are required inside KVM, or those could also
use userspace_addr.

You mentioned that pKVM doesn't use
KVM_GENERIC_MEMORY_ATTRIBUTES/mem_attr_array, so perhaps the change
required here is that kvm_mem_is_private() should be updated to
kvm_slot_can_be_private() && whatever pKVM uses to determine if a gfn is
private?

So perhaps kvm_arch_gmem_supports_shared_mem() should be something like
kvm_arch_gmem_use_guest_memfd(), where x86 would override that to use
mem_attr_array if CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES is selected? 

>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2d025b8ee20e..296f1d284d55 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2521,7 +2521,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  #else
>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>  {
> -	return false;
> +	return kvm_arch_gmem_supports_shared_mem(kvm) &&
> +	       kvm_slot_can_be_private(gfn_to_memslot(kvm, gfn));
>  }
>  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */

