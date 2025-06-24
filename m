Return-Path: <kvm+bounces-50477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02CC9AE61BC
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 12:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 881754A7B03
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 10:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2AE27E7D2;
	Tue, 24 Jun 2025 10:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nkLJ6WiU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420B953BE
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759415; cv=none; b=WhPFJAGWpu+fl83IixJToW0nvMbpFx2oDBB/0Y6gFAVLanq33YVEAzS5skg2kBV+Tp0heFuDijaYMNnbOPSj+FjcDvXX4iRryxkdm4B1MvO01aKMygo9EVi9QzNSxMVOPKgXUfHL5uPhVZwnVyTonYQWLVmESBDxiwzEio1CwSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759415; c=relaxed/simple;
	bh=KsoThbVuC03tvHvNTihda3ndo5AaudSgCC/2MFyVqhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TdQMpLILkuO1y5cMfPbb/4uV1ZBxdhN2aA6jIZqQW/vf/a3rKy+E4jpWotXOUcC0K7nDS2e29goo+xJiAnEZ5E4S5wquHq1AmLhfCPq1EPKE6LxsJ6iQQYoQRKGOE6tatcWDdId0/uhs1FXQKsxtmtWUoI8reF3mu/+rBQ+Rcts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nkLJ6WiU; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-47e9fea29easo285311cf.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 03:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750759413; x=1751364213; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gMW0MMECznJialVQa7oe4n9ne+tvTZu0qfqDN/JkXfs=;
        b=nkLJ6WiUp1JJOFeeGno11Z4oLtN/3YMdbKHteeeYDQfEXKt2LAgirE9KrksBjjPfU3
         mJk4pDwKUAAIVGoUC9UYBqw+4uaa3cAahXD/aPPa8JJm0hDHtGrDEZJf1ZuU3gBtfJ9e
         ujvtn1g+FCtqpu+/7TNxAPrUzNT9NY36vtP5epJicXLFAjYXXwbPc42k65v/tI+BeS2E
         Q9H3KNQKKpqJkF5dlJYWTRCEvf+3LD1nf9n108TaVc4Loh1ko6vhY+Vj+9in13qWIowY
         M8tVqfpxPQnXx1BmAjcpFvgcAOqh1tzTmmC0gr0mcQyGStSO099wW5X7cM6PYxochunI
         4qew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750759413; x=1751364213;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gMW0MMECznJialVQa7oe4n9ne+tvTZu0qfqDN/JkXfs=;
        b=BAAjjST/gTLj74W94e6KfZFkNlLo1Xp/iACx4mDNaBdk/jBCrzYDJG8CnDQukyx6F5
         c//Q5NO65oK/FyTfEuu5ACcx5y/kqPjAJNTDlZEpDacibAYgseg9n1Psc8lTlf8tNrXB
         E0zNChnvNQvmXK2x+fLxyhqC3FFX4FO2VoP0nO/KNY6Lz+bVSiS1++lViNUps+3Db8w5
         qPsNhelr22bj9TLiG2tPFVS6CrvrUn6UBBQN7VPLgN0Er33XTZTqsj1elWjd7T5rgFpF
         y2Gva+TS+eodHFrezJiUsLpksM782H6X3xT/vpNNNmFV8RJaiPOXLWZpTlnulvNqkiHv
         RS0A==
X-Gm-Message-State: AOJu0YxuszLh+anAD8HBlfYw+/83WdForIVuuH8MSu0blx+cLYfL3Kja
	of+7mD5kOs3PQ7nu3N+vvxu0Qm8aIJm0HSs64wnWE0JKaoUCIaHolgwy0xGhcbsVnsBmzU9zrb9
	XWaXyOpx9N+4lho3YWPGnD/u30OjHNkDh68dAQ9Ge
X-Gm-Gg: ASbGnctgIE2y55sZJ6Zpoo+qzFZMd7YJG2/yLiaaZNLO9HUiG5J9kcCxtN7FDNM0H7O
	JUOV2MJ7+/NFqD7hjOXO2C1IGkMuiz+ue1Hd3wPzM8odyJFRKc8EWy/AeT2kVohOV7je87g0yx7
	gId4P87ag51wLtbfeR8pKPchHUmPW/k1N8dqxCblb+TLILpzV0SunrAl+aT9BPi8zFyPPVzeSU
X-Google-Smtp-Source: AGHT+IHT3LkZ35Y5UJEPwLhq2j0BxxOtoLWYptCtFgQuare8SnS0uBLCBrYuYOhTXMb3sDYFZdMfbm/xeJe2fFK+8kI=
X-Received: by 2002:a05:622a:c3:b0:494:763e:d971 with SMTP id
 d75a77b69052e-4a7b171e2aemr2408971cf.23.1750759412503; Tue, 24 Jun 2025
 03:03:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
In-Reply-To: <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 24 Jun 2025 11:02:56 +0100
X-Gm-Features: Ac12FXyaJ6fQiRli6N-G9Ic58vssGb1-G3P5sN6L-3mpP1G-97NTKumDYqIFAvc
Message-ID: <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: David Hildenbrand <david@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi,

Before I respin this, I thought I'd outline the planned changes for
V13, especially since it involves a lot of repainting. I hope that by
presenting this first, we could reduce the number of times I'll need
to respin it.

    In struct kvm_arch: add bool supports_gmem instead of renaming
has_private_mem

    The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
called GUEST_MEMFD_FLAG_MMAP

    The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should
be called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP

    kvm_arch_supports_gmem_shared_mem() should be called
kvm_arch_supports_gmem_mmap()

    kvm_gmem_memslot_supports_shared() should be called
kvm_gmem_memslot_supports_mmap()

    kvm_gmem_fault_shared(struct vm_fault *vmf) should be called
kvm_gmem_fault_user_mapping(struct vm_fault *vmf)

    The capability KVM_CAP_GMEM_SHARED_MEM should be called KVM_CAP_GMEM_MMAP

    The Kconfig CONFIG_KVM_GMEM_SHARED_MEM should be called
CONFIG_KVM_GMEM_SUPPORTS_MMAP

Also, what (unless you disagree) will stay the same as V12:

    Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GMEM: Since private
implies gmem, and we will have additional flags for MMAP support

    Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE

    Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
private does imply that it has gmem

Thanks,
/fuad



On Thu, 12 Jun 2025 at 18:39, David Hildenbrand <david@redhat.com> wrote:
>
> On 11.06.25 15:33, Fuad Tabba wrote:
> > Main changes since v11 [1]:
> > - Addressed various points of feedback from the last revision.
> > - Rebased on Linux 6.16-rc1.
>
> Nit: In case you have to resend, it might be worth changing the subject
> s/software protected/non-CoCo/ like you did in patch #12.
>
> --
> Cheers,
>
> David / dhildenb
>

