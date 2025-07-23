Return-Path: <kvm+bounces-53196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 990B2B0EE4B
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 11:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAA703A6F62
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 09:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD10B286405;
	Wed, 23 Jul 2025 09:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="09MKU2zb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B652820C6
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753262578; cv=none; b=gY/9V1K1J9uBZ1GGQ+o2HmbpyfnnlgD/hZycQ0LLu69YjEBcKDN3S+QQI/xf3bcAD+Egkc/Iojpq+MeJv2UxDQvoBQPyCp28B42Qv1kcAM/nx+1Dr0kghDueQh9ucDOrM+IQ56Dse0+9YDL29JE65BV5jwGGnGwmPyAAFhUyV/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753262578; c=relaxed/simple;
	bh=vAA1Lv7W544jmjXnmOIpPcLBsrN3AE3t7Hfl5SQXlKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKmteM4oQJxMKM0oF4eZJ4UulA8ZQdr8Uq/4Uh5ov4b0AzPkyhYgzAgv4VXxErX92Yh9hYn4AX8bN6wFE/nYZ0WT8RJt9jCHO3SMame/PBM1NdYDWHYqV1voXvZbAzIAbHgDvU5Wx2uKDpsnYuxOYmwR82/VyegHta+XIKmMLuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=09MKU2zb; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso349491cf.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 02:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753262576; x=1753867376; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=09MKU2zb8s9g82Pd6b2dy2Mh7mho49wOe0iNYpSOyXSQLZvwdYDq18/RcD/jcrUGG6
         bc1hDjfMZhnziXAM79G5dX6HPS7d3T5aooRcREwL67O0g3zokaeRHuJh9F1e4zj17PDl
         Dx96dLyfDZNPwJo18QkC8C7hbBEklq7Xlzg9ibVzCZR/+3nZMsKkBUEUtNa+GDjlRTXb
         NuZXJnyjy9c+LjuUgMugBiL6jgU7WT3o7CE60nJ4aTWFw67cmDIRxHQfKy0SNFmY5u/i
         53Etzjo2E3p5IxltPsk9UQFqrjjCiG0Y11SnrDytvqnvTr85o0SzLydyPcqfrAxpCXmI
         ZEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262576; x=1753867376;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q1l9DC9s6bqSZlXl3hk+96usOVx+LGIZFtzxNIqVYEY=;
        b=ldKDxKWh2ccGomeoEbjXhyEf0QRn26zGlCCLvGM1uLbazlP0946Ee3GmET989kM87j
         xWZYaHBRmzwN4n/lbqsccZ51S3OJJtfyyzqNebgwT6FneeYaYzYNCH/BwgqPSB3Yjr5i
         ntOBwkdhbORrYoGAlRfH2q5Ye9OqPhbJ27GU7VTXE2ESgQ4ZP9XaXX9rSgXLow7JoHlb
         25pSODUNDl3edIYIZfxsnfBibUPwSEt97Ii+64U2gzjmPLZqJQ2BPOTFg16v/AlUA3zw
         qfo7BDHBNp1w5ijH1J5bYTJeS17E2xOrT2WTV1XQHW0I8aRkFc/WHrmluvsv+EjXDx5/
         v+9A==
X-Gm-Message-State: AOJu0Yznqkj0hsBf54bEJ45IdPb8uSkpNx5qNpehV7WjsLftjPl+7iCF
	/ThSHK+tmd2N9fH9UivievPgghKBNM5iY81+Bfsh8pFXDCpbvjHhQhzf8Eo7Z+PNXQsso4iruZF
	iROtwOG79Dtqn+VxvUoySzBAt1ixjCa0xW/P9dugn
X-Gm-Gg: ASbGncuaFqaehJpm+zo7AadCk+fLo7WSGxcC3rnsLHJYTmxsw4LNx2ErKoO/2SLhfrZ
	BxKWeGA/huUjs5oP6cC8gvZjFs2dcFfCWWqBXNtZWIqhEDRz0fb2Zo2QqQG1YOCzjjZOOLkDYKx
	it65+9FohEa6So8TkTNH7h/hSDUu94QCn8O3ZRZj2697knJnDlXa9h5mLVLgGqpRQg5A5kAb6eb
	fr3FvYTP4LU5PEFQldFMMjrJkZ9LifRgH4g
X-Google-Smtp-Source: AGHT+IHpGSWUb20Op9Qp28Uz72zppWmO/fpdDBu9sBC5ToKI3zBiTnA4LkrTZ+17aXYm0O7UQ4tqXYX6jHbEEiExdf0=
X-Received: by 2002:a05:622a:551a:b0:4a8:eb0:c528 with SMTP id
 d75a77b69052e-4ae6f066032mr2643391cf.15.1753262575605; Wed, 23 Jul 2025
 02:22:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com> <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
 <aIAh3xkU52Z100xK@google.com>
In-Reply-To: <aIAh3xkU52Z100xK@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 10:22:19 +0100
X-Gm-Features: Ac12FXy0a_zhWCTWrmc8iH91Uu03l4tlmUMT8pdCRl-WsFj9mim4tPfVNS6-H9U
Message-ID: <CA+EHjTy_82ADyf05-ySq-+901bT+W30EXm7t4ppvVAd5Eds40Q@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Jul 2025 at 00:42, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > > > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > > > cleaner resting state (see the diff stats).
> > > > > >
> > > > > > So just so that I am clear, applying the diff below to the appropriate
> > > > > > patches would address all the concerns that you have mentioned in this
> > > > > > email?
> > > > >
> > > > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> > > >
> > > > Other than this patch not applying, nah, I think it's all good ;P. I
> > > > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > > > somewhere in a local tree of yours. There are quite a few conflicts
> > > > and I don't think it would build even if based on the right tree,
> > > > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > > > rather an addition of an undeclared identifier.
> > > >
> > > > That said, I think I understand what you mean, and I can apply the
> > > > spirit of this patch.
> > > >
> > > > Stay tuned for v16.
> > >
> > > Want to point me at your branch?  I can run it through my battery of tests, and
> > > maybe save you/us from having to spin a v17.
> >
> > That would be great. Here it is:
> >
> > https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16
> >
> > No known issues from my end. But can you have a look at the patch:
> >
> > KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks
> >
> > In that I collected the changes to the config/enable checks that
> > didn't seem to fit well in any of the other patches.
>
> Regarding config stuff, patch 02, KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
> CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE, is missing a KVM_GMEM => KVM_GUEST_MEMFD rename.
>
> While playing with this, I also discovered why this code lives in the KVM_X86 config:
>
>   select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>
> Commit ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module
> is requested") didn't have all the vendor netural configs depend on KVM_X86, and
> so it's possible to end up with unmet dependencies.  E.g. KVM_SW_PROTECTED_VM can
> be selected with KVM_X86=n, and thus with KVM_GUEST_MEMFD=n.
>
> We could punt on that mess until after this series, but that'd be a even more
> churn, and I'm not sure I could stomach giving acks for the continued addition
> of ugly kconfig dependencies. :-)
>
> Lastly, regarding "Consolidate Kconfig and guest_memfd enable checks", that needs
> to land before f6a5f3a22bbe ("KVM: guest_memfd: Allow host to map guest_memfd pages"),
> otherwise KVM will present a weird state where guest_memfd can be used for default
> VMs, but if and only KVM_GUEST_MEMFD happens to be selected by something else.
> That also provides a better shortlog: "KVM: x86: Enable KVM_GUEST_MEMFD for all
> 64-bit builds".  The config cleanups and consolidations are a nice side effect,
> but what that patch is really doing is enabling KVM_GUEST_MEMFD more broadly.
>
> Actually, all of the arch patches need to come before f6a5f3a22bbe ("KVM: guest_memfd:
> Allow host to map guest_memfd pages"), otherwise intermediate builds will have
> half-baked support for guest_memfd mmap().  Or rather, KVM shouldn't let userspace
> enable GUEST_MEMFD_FLAG_MMAP until all the plumbing is in place.  I suspect that
> trying to shuffle the full patches around will create cyclical dependency hell.
> It's easy enough to hold off on adding GUEST_MEMFD_FLAG_MMAP until KVM is fully
> ready, so I think it makes sense to just add GUEST_MEMFD_FLAG_MMAP along with the
> capability.
>
> Rather than trying to pass partial patches around, I pushed a branch to:
>
>   https://github.com/sean-jc/linux.git x86/gmem_mmap
>
> Outside of the x86 config crud, and deferring GUEST_MEMFD_FLAG_MMAP until KVM is
> fully prepped, there _shouldn't_ be any changes relatively to what you have.
>
> Note, it's based on:
>
>   https://github.com/kvm-x86/linux.git next
>
> as there are x86 kconfig dependencies/conflicts with changes that are destined
> for 6.17 (and I don't think landing this in 6.17 is realistic, i.e. this series
> will effectively follow kvm-x86/next no matter what).
>
> I haven't done a ton of runtime testing yet, but it passes all of my build tests
> (I have far too many configs), so I'm reasonably confident all the kconfig stuff
> isn't horribly broken.
>
> Oh, and I also squashed this into the very last patch.  The curly braces, line
> wrap, and hardcoded boolean are all superfluous.

Thank you for this. These patches look good to me.

I've tested them on x86 and arm64, and everything runs fine. I'll have
a closer look at them, and probably send v16 later today.

I know that it's probably too late for 6.17, but it would be great if
we could queue this for 6.18.

Cheers,
/fuad


> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 4cdccabc160c..a0c5db8fd72d 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -249,8 +249,7 @@ static bool check_vm_type(unsigned long vm_type)
>         return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
>  }
>
> -static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
> -                          bool expect_mmap_allowed)
> +static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
>  {
>         struct kvm_vm *vm;
>         size_t total_size;
> @@ -272,7 +271,7 @@ static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags,
>
>         test_file_read_write(fd);
>
> -       if (expect_mmap_allowed) {
> +       if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
>                 test_mmap_supported(fd, page_size, total_size);
>                 test_fault_overflow(fd, page_size, total_size);
>
> @@ -343,13 +342,11 @@ int main(int argc, char *argv[])
>
>         test_gmem_flag_validity();
>
> -       test_with_type(VM_TYPE_DEFAULT, 0, false);
> -       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP)) {
> -               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP,
> -                              true);
> -       }
> +       test_with_type(VM_TYPE_DEFAULT, 0);
> +       if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +               test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
>
>  #ifdef __x86_64__
> -       test_with_type(KVM_X86_SW_PROTECTED_VM, 0, false);
> +       test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
>  #endif
>  }

