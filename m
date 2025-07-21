Return-Path: <kvm+bounces-53004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0571B0C78D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 889E41AA54D9
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 15:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1701B2DFA37;
	Mon, 21 Jul 2025 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NcOMATBv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85D42DEA9E
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753111602; cv=none; b=YtECJm+sBAtBFddF7ToehxNOnlMdTxp/CCEw1FCmV/+RwUd3Rfn2ir3Vmlbu4COXkDbZSUjAV+oHfj0MyRl9C5zuJPiZvp8W1+sFC11vZtk7aKyskvrEdSsP5hf15pPUUKZwWaMTG4kSKj9TTjIdunUpBTGFQX5dJHPFFJehIEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753111602; c=relaxed/simple;
	bh=8DwP3omhkAVQqs7IffAT+dALozWU0wdNIC142sQ97Ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=StqBJ3XJd+v6yttI7EzD7Yq5ciqXTsP8gN/S5/MQWeDylILHjuKZ07p4cmvN3NgLVRIIuJ8cG7H4cOuXN8BhJterTEHJMpdxrqTPdilarz+anlNhg1SuitddwnhT65eE0/TOGAsBr0UyNuz6ZDcLbZ4ck7yxQebjv0rmUQ638cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NcOMATBv; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso809981cf.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753111599; x=1753716399; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+zXX1Cs6v+OQFAHcUcXiOun/0OGx+sBx9HWHDVkm/fI=;
        b=NcOMATBv9IB8+ioYrYRklZgPjNH7tFX7gmzzsrhT0cPTt/gZzNDsVCZxpIOxbp3ltD
         pU8yWN53p4AFCeT9Ryg7h1fyhiLjlqKLoArNPK7UvvxZXejk+TrZwRNDQH8bee7nTMwZ
         I/zNb9OTZ31MNF+ejdOPWtxUWBkm94qOMJnRu2YN46PDi95osOSFCPzbTPngU5e5PeqI
         +yr0jfEyPR90t1EBMcCYXOWu+7yydOJglxbSbRaRceA3XntXYzRZDpQe2PLf6IJZKP4l
         NwsIYu4YuhTYhWlnQXFfZ1+OIncK31RWh1ohqwNCV8CXw0CwsTVQguvUdnMmCsgbNmGr
         6odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753111599; x=1753716399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+zXX1Cs6v+OQFAHcUcXiOun/0OGx+sBx9HWHDVkm/fI=;
        b=cb0ZA/zFgjzHsaCcujEhp962obNcDuMlE4j26Qs9bR2mhtYYfexm/hpkb0yruOVoQ4
         Qe3CsxfHXQTrzCCen2R4if2rnVq/qR57eeX/eh8UI96bkUTKmmH7gKEFU/TQXfmJ+y1T
         PqfhOAhPAvHY92ruAnENuM/VtjvxgJ4Fn8jaduGnR7qaXS8XWNYnc1yWXDgYNT8J3asH
         bV8PtTFfJXYusuNqdsvJng6SnjgcAfhW1hyVu6df/GQUeMqq4LQXmBxcBVV43S8fwld9
         3bDjAxKH0ic/+4N9RmffJsWLcA3DXMqqb/f5YsXqV1SNaKFaXD3s0Tq8gYqlP7UAgSzE
         0lBg==
X-Gm-Message-State: AOJu0YyLK4LC4XOjPTmFCi1JoFLhSCbx92CUExrqMlgi9PTAoCbEDiuj
	gVBoRpWnX1MS+RwXKiSZ34nSWm1VZlltzeqJNUrD6ogZmIpfqqSNcxMUZUKkNsSKSbYbVMlLPpf
	EyEKX0347qP2yB+h1EEPLFAE1G+7XP66sbvjONqzk
X-Gm-Gg: ASbGncteUM20GZjxtfHs2itxljSfNW3cmzFO+Mi9gkQIDy7UNsOYi3ugaU1DlJQCMX2
	O1kAuSTXZXsWiWq+NLmUfHoaxxGe0IMhy44h7qYjCDi2avvzfiDK7GS67P6xe4SD7OjxqTt1hEx
	slAqecYxfIaSzxYLRYkDD5uHJqD3mdBbUbV5wRIZSwP1wImucGR/kzhol03DnrkfnEBo8XP4sGD
	/21vm4=
X-Google-Smtp-Source: AGHT+IEJ1agfPLztb2zu+kNSQrf+HNQSH/8YBV9oHV+GLXju3loOkIiAuNIEAfRphTYzBRJ1wUQtlA8Dhv1rRae6lKk=
X-Received: by 2002:a05:622a:a18d:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ae5ad66634mr161081cf.2.1753111599011; Mon, 21 Jul 2025
 08:26:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-2-tabba@google.com>
 <aH5Z7edFZSPzmJ5w@google.com>
In-Reply-To: <aH5Z7edFZSPzmJ5w@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 16:26:02 +0100
X-Gm-Features: Ac12FXxSI2fqE4AUgjZ2pvOx5zOwfObgBpuUEKoP_2mWQ6ddL7hqgwa3HEbqCBI
Message-ID: <CA+EHjTzemPVuHnm8vZh2Lh25GpZL-CR3kqtFQ7uktKobkjNDUA@mail.gmail.com>
Subject: Re: [PATCH v15 01/21] KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM
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

Hi Sean,

On Mon, 21 Jul 2025 at 16:17, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > Rename the Kconfig option CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM.
>
> Please name this CONFIG_KVM_GUEST_MEMFD.  I'm a-ok using gmem as the namespace
> for functions/macros/variables, but there's zero reason to shorten things like
> Kconfigs.

Ack.

> > @@ -719,10 +719,10 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
> >  #endif
> >
> >  /*
> > - * Arch code must define kvm_arch_has_private_mem if support for private memory
> > - * is enabled.
> > + * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> > + * enabled.
>
> This is undesirable, and the comment is flat out wrong.  As evidenced by the lack
> of a #define in arm64, arch does NOT need to #define kvm_arch_has_private_mem if
> CONFIG_KVM_GUEST_MEMFD=y.  It "works" because the sole caller to kvm_arch_has_private_mem()
> is guarded by CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, and that's never selected
> by arm64.
>
> I.e. this needs to key off of CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES=y, not off of
> CONFIG_KVM_GUEST_MEMFD=y.  And I would just drop the comment altogether at that
> point, because it's all quite self-explanatory:
>
> #ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> {
>         return false;
> }
> #endif

Ack.

>
> >   */
> > -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
> > +#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> >  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> >  {
> >       return false;
> > @@ -2527,7 +2527,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> >
> >  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  {
> > -     return IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) &&
> > +     return IS_ENABLED(CONFIG_KVM_GMEM) &&
>
> And this is equally wrong.  The existing code checked CONFIG_KVM_PRIVATE_MEM,
> because memory obviously can't be private if private memory is unsupported.
>
> But that logic chain doesn't work as well for guest_memfd.  In a way, this is a
> weird semantic change, e.g. it changes from "select guest_memfd if private memory
> is supported" to "allow private memory if guest_memfd is select".   The former
> existed because compiling in support for guest_memfd when it coulnd't possibly
> be used was wasteful, but even then it was somewhat superfluous.
>
> The latter is an arbitrary requirement that probably shouldn't exist, and if we
> did want to make it a hard requirement, should be expressed in the Kconfig
> dependency, not here.
>
> TL;DR: drop the IS_ENABLED(CONFIG_KVM_GMEM) check.

Ack.

Thanks!
/fuad

