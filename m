Return-Path: <kvm+bounces-61043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D67A8C07926
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 19:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94BF9407196
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 17:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA17C346775;
	Fri, 24 Oct 2025 17:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMnn1vD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4D334676F
	for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 17:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761327911; cv=none; b=RjjDyM5I4sv+r6ytYfmLyKt/gDCRMZEum7cG2lgTi+m0dtVuGAxUvDFySdTvhAcRp2zmKpF/4EPsjz1k+Fkf6NtJOdsC9lkO4ss8CK5YK2U43sbfsFRmiuSIYH1zPi6ZfmjPAJ3OU5mTkCKxcN4wngwMqdJxRCHizuJGFVmDQAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761327911; c=relaxed/simple;
	bh=tQchZRo3dfbeEwC4XDdsg27WfVhtytszSYNfMKLDCRk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AF+KGXeQp4SrX7ctrvbHZUCzratIYoKBvrYSsNH4I1R800YAovXfVr1vnjzQ+jZAhdjyT6PIaIjWjP0RvdCZ1NtVXbNTjdbPx2YorZCvPtcHfnk3fzVcu0ih4yTSSiwqrL8R3670zjDMRPyA4LFjUZH5baRmFsjE+ThDgKpnotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMnn1vD1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33da21394adso2224426a91.1
        for <kvm@vger.kernel.org>; Fri, 24 Oct 2025 10:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761327909; x=1761932709; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9y+RsixQBpMVe8jJ0C0RXhB2GIgsnXkIXIfG2sQ8Z6s=;
        b=eMnn1vD19Z/AtaGDFSF76Wb8pRldCfdAtrfp1z69jekrJASMUIUv9+MIv6TvFAfRu6
         meQ0LfQQ/jR3vKxASa8LfEkRwsNQd7cj+hmP0frmqxGXeetPdpXMxuT/Ru/Ahw3k9aQM
         Zxm5CDHnuhXKwVpLeYm0irNSMLKxvD5bObbmgxRvzQoC1djM24HFU3UAj5LDYGrE1TVL
         YQVJEer+k6g9sIAGfgKz6uX0vCZYvpHKq84L5IMW+Z3daaahF3rW3wNdwRrgfN4WWUvk
         VNZ7dQ8vPBa8XDSIllX2KL2P1khde5viPudpfO/vjBiQsP4nJS35nq9fXrpVfHEI/RC+
         BC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761327909; x=1761932709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9y+RsixQBpMVe8jJ0C0RXhB2GIgsnXkIXIfG2sQ8Z6s=;
        b=rCpFTCeBoR7xdtmRuTy3z/yT4eI70e/Poy7wAEKZFw9DX0B7oiwJGcdPxqwZLkainW
         fkGxbpUMnWVa5RVu6kzxxEL9z+hbcro0nAoY+llczmpt/KvQMtgg2rEGRmnGS53pY8ck
         L1Nm4hlPI2dc94Rl4jGD79hN7/iUagpdfe2Yt2Aq+JNfR9id93fx57sOf3rEI+WB2LFe
         tY1ZrIzSs5wCdQ9/SZCvycRVmFqT/mjCok4A9Wgk4VkW4N8RJcgAqctgKaV8q9s7piSc
         8lPba6wsmiV1EOd7xIuFsWtssQd83OYp3XIiyyhNzBtQzdXsiBvzRAIf10l4fjwMrCgB
         1SjA==
X-Forwarded-Encrypted: i=1; AJvYcCUAfnexMq6u1/tEmmgzKF1+E6coITP7anEJ8jNCv0XdfYIFGbA4kPjkAeptp840OssSGhg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0WBTBgJY21eRbifsm0y52PhbYljaPFAODCSUNax20Z2DFjBfg
	Iwy9b6d5rK+B5Dpmn36780QdyAJt1tcTZYOORyZVm2rPjJy29oEI8e6VHbhjbbXvjZymxzz1kbv
	K4u9dQg==
X-Google-Smtp-Source: AGHT+IGvJAcWikn/2GkAunTJp4wJjRX2y0XegrvA0YCLDSoXMGm33ouWPic5F/FBkAnJdnxZYF98SiNPybw=
X-Received: from pjte14.prod.google.com ([2002:a17:90a:c20e:b0:33b:ca21:e3e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3891:b0:32e:9da9:3e60
 with SMTP id 98e67ed59e1d1-33bcf9375e8mr34102450a91.36.1761327908483; Fri, 24
 Oct 2025 10:45:08 -0700 (PDT)
Date: Fri, 24 Oct 2025 10:45:06 -0700
In-Reply-To: <diqzo6pwdzfy.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8ee16fbf254115b0fd72cc2b5c06d2ccef66eca9.1760731772.git.ackerleytng@google.com>
 <2457cb3b-5dde-4ca1-b75d-174b5daee28a@arm.com> <diqz4irqg9qy.fsf@google.com>
 <diqzy0p2eet3.fsf@google.com> <aPlpKbHGea90IebS@google.com>
 <diqzv7k5emza.fsf@google.com> <aPpEPZ4YfrRHIkal@google.com>
 <diqzqzuse58c.fsf@google.com> <aPuXCV0Aof0zihW9@google.com> <diqzo6pwdzfy.fsf@google.com>
Message-ID: <aPu7IosMI61NjZY5@google.com>
Subject: Re: [RFC PATCH v1 07/37] KVM: Introduce KVM_SET_MEMORY_ATTRIBUTES2
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Steven Price <steven.price@arm.com>, cgroups@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, x86@kernel.org, 
	akpm@linux-foundation.org, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	corbet@lwn.net, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	david@redhat.com, dmatlack@google.com, erdemaktas@google.com, 
	fan.du@intel.com, fvdl@google.com, haibo1.xu@intel.com, hannes@cmpxchg.org, 
	hch@infradead.org, hpa@zytor.com, hughd@google.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, jack@suse.cz, james.morse@arm.com, 
	jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, jhubbard@nvidia.com, 
	jthoughton@google.com, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, 
	shakeel.butt@linux.dev, shuah@kernel.org, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@linutronix.de, thomas.lendacky@amd.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	vkuznets@redhat.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 24, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > @@ -486,6 +488,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
> >         }
> >         guest_rng = new_guest_random_state(guest_random_seed);
> >         sync_global_to_guest(vm, guest_rng);
> > +       sync_global_to_guest(vm, kvm_has_gmem_attributes);
> 
> I ported this [1] except for syncing this value to the guest, because I
> think the guest shouldn't need to know this information,

KVM selftests are about practically and testing, what information should or
shouldn't be available to a test from e.g. a safety perspective is completely
irrelevant.  In fact, one of the biggest advantages of selftests over KUT is
that the guest side can know _exactly_ what's going on in the host.

See the usage in 1850e3da4b03 ("KVM: selftests: Update private_mem_conversions_test
to mmap() guest_memfd") from:

  https://github.com/sean-jc/linux.git x86/gmem_inplace

> the host should decide what to do. I think, if the guests really need to know
> this, the test itself can do the syncing.

Why force tests to do extra work, and potentially introduce subtle bugs due to
state being stale?

