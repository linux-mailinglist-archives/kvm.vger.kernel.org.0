Return-Path: <kvm+bounces-46501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7507EAB6D68
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 15:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DC6F1B68437
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F2D2797BB;
	Wed, 14 May 2025 13:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P+rcEGXF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53EC27B4EB
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 13:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230772; cv=none; b=DCJ5WWF3kAek1MUCuYdvSKNKpFYcli4s5HYF6mm/XKusSiI9Ax+afomniUCkBOLDVjkRCRmDr5jpAqKncxbFFlqOggZc08E1vkLCcCwC/BAJlXA5uHEqXg0F4Xv64i5ikndu2cRl/NcIEq7W0cUBPGY/hgKCNmyqwkz9EJrNvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230772; c=relaxed/simple;
	bh=WbRWswzujG7wOYAXbYBdZrfTqNrxo2bXeYmMrShF5kk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lc557HXe1VS6s55EQmMAWeYySHA5kOzet1SSFjEnN3VWPxhPd9O+lYGp4DUUxT7ik6sBB7FmPOOI/QTWw7ZY21WnNdeY1vSUm0YIhn/4JNVDqLQ5rP8BJFQOM1WnjyzTmnReTsnY+Ntnsl6bycfS+Pwuv7yHJ/55MWlWIJHZcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P+rcEGXF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-af5310c1ac1so3971012a12.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747230770; x=1747835570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eYg4+rpHp33PbS4Itshy4T2HbraqnrFIaURvTmb0+kE=;
        b=P+rcEGXFltuWwmjg3ccjbahpIE+NQJeMQGLSHJc+MHYfmc7glp07+dvc/kPhnFgQ8+
         FVImmbAW/InV7VQ0DlMvDAj43H8O3UYxEqmz44Z+2oGehcz8m4ZDDql2QEA1fegQrOKF
         37XImf/Th44h+U/jJlD7kSmsB7Fl2vS5CCc9rTX462C1XYKDoallVTko0yR4vFnGdt/t
         c2ArOCF8peVq2D0YTqfxslnA+6+WT9U4bGm+kDQLbZ1L+RGJ+wrVuW/6zAppHVYaN7it
         6Y7XNHZrsEnGp1kGYCyrbx5jblepg+99x5k5SvHqvljWDgpAEGc3zbK03/dT+ee/oy7q
         4mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747230770; x=1747835570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eYg4+rpHp33PbS4Itshy4T2HbraqnrFIaURvTmb0+kE=;
        b=e/BGgvYyoXHtj4vg2XXbXYw1JJPOT/X0P6wC9qLSC2nwgbbKlZKjdAFgw84SXVS3dx
         q+yz2svEiQIKGF8CGKhYl1a8gkcpWm8taiD2KiF/jY0JHN2eS+scKYpxHfk38Y+miSTY
         NdrT1vx6lCEXVSx06vGFpf5HfJcXB82lpRVKvwZ9tVDYe6Djnbs97/MKRoKsnuhFOIIW
         mNQXaxGokEf3sig8aSoO9frioAxj9Lt7HtU6312CgedWjvOOR1vFRWUy7HLefxXaMZUo
         VJxf5/kw0X+geT4mWXkRGpNBeDEklpyWF8b+QSXHijTuQtKXa3UrL3XbLm9F+9z0ugAU
         7UwA==
X-Forwarded-Encrypted: i=1; AJvYcCXl/iF/5NnbhGFJY0wuyFxR++UW/lQ/7Oe6USNloPnLSppnj3vu19kWSqIKT/6olKAInIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YytZkxocEVCopFHSaBpr4YjBIAjmUSt8qTC+0CwERY+xozJfh66
	crabv3lk+bajXlt+X/zw513QlqoqaDtChBAI/1gxWSkgOmKaZ8qcLV9xmN238opuaQUnnNBuowQ
	8Tw==
X-Google-Smtp-Source: AGHT+IHrlpU6TSN8LFEDqLk4N7nyxIXqbtuZg3bjjLval5KFIlyghPAfN3T3Jm+iafOU8Hu0EqUexqT5TWc=
X-Received: from pjbee11.prod.google.com ([2002:a17:90a:fc4b:b0:2fc:ccfe:368])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1a89:b0:2fe:85f0:e115
 with SMTP id 98e67ed59e1d1-30e2e65e6e3mr4418434a91.26.1747230769918; Wed, 14
 May 2025 06:52:49 -0700 (PDT)
Date: Wed, 14 May 2025 06:52:48 -0700
In-Reply-To: <diqzo6vvpami.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-9-tabba@google.com>
 <CADrL8HVikf9OK_j4aUk2NZ-BB2sTdavGnDza9244TMeDWjxbCQ@mail.gmail.com>
 <CA+EHjTyWOJA8u3iXS9txF8oDKF-soykjJm8HPPEW+6VpM+uvtg@mail.gmail.com>
 <aCSbfjoD2_Dj_t6b@google.com> <diqzo6vvpami.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aCSgMEXrNYgB_Ha4@google.com>
Subject: Re: [PATCH v9 08/17] KVM: guest_memfd: Check that userspace_addr and
 fd+offset refer to same range
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Fuad Tabba <tabba@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 14, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> > On Wed, May 14, 2025, Fuad Tabba wrote:
> >> On Tue, 13 May 2025 at 21:31, James Houghton <jthoughton@google.com> wrote:
> >> > > @@ -585,9 +611,14 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >> > >             offset + size > i_size_read(inode))
> >> > >                 goto err;
> >> > >
> >> > > -       if (kvm_gmem_supports_shared(inode) &&
> >> > > -           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> >> > > -               goto err;
> >> > > +       if (kvm_gmem_supports_shared(inode)) {
> >> > > +               if (!kvm_arch_vm_supports_gmem_shared_mem(kvm))
> >> > > +                       goto err;
> >> > > +
> >> > > +               if (slot->userspace_addr &&
> >> > > +                   !kvm_gmem_is_same_range(kvm, slot, file, offset))
> >> > > +                       goto err;
> >> >
> >> > This is very nit-picky, but I would rather this not be -EINVAL, maybe
> >> > -EIO instead? Or maybe a pr_warn_once() and let the call proceed?
> >
> > Or just omit the check entirely.  The check isn't binding (ba-dump, ching!),
> > because the mapping/VMA can change the instant mmap_read_unlock() is called.
> >
> >> > The userspace_addr we got isn't invalid per se, we're just trying to
> >> > give a hint to the user that their VMAs (or the userspace address they
> >> > gave us) are messed up. I don't really like lumping this in with truly
> >> > invalid arguments.
> >> 
> >> I don't mind changing the return error, but I don't think that we
> >> should have a kernel warning (pr_warn_once) for something userspace
> >> can trigger.
> >
> > This isn't a WARN, e.g. won't trip panic_on_warn.  In practice, it's not
> > meaningfully different than pr_info().  That said, I agree that printing anything
> > is a bad approach.
> >
> >> It's not an IO error either. I think that this is an invalid argument
> >> (EINVAL).
> >
> > I agree with James, this isn't an invalid argument.  Having the validity of an
> > input hinge on the ordering between a KVM ioctl() and mmap() is quite odd.  I
> > know KVM arm64 does exactly this for KVM_SET_USER_MEMORY_REGION{,2}, but I don't
> > love the semantics.  And unlike that scenario, where e.g. MTE tags are verified
> > again at fault-time, KVM won't re-check the VMA when accessing guest memory via
> > the userspace mapping, e.g. through uaccess.
> >
> > Unless I'm forgetting something, I'm leaning toward omitting the check entirely.
> >
> 
> I'm good with dropping this patch. I might have misunderstood the conclusion
> of the guest_memfd call.

No, I don't think you misunderstood anything.  It's just that sometimes opinions
different when there's actual code, versus a verbal discussion.  I.e. this sounds
like a good idea, but when seeing the code and thinking through the effects, it's
less appealing.

