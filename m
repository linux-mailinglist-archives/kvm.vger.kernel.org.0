Return-Path: <kvm+bounces-53107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A301CB0D600
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E44931888C12
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807D22DE1E5;
	Tue, 22 Jul 2025 09:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b+EyqEwx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D72DC35D
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 09:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176621; cv=none; b=tIXgJkxGGFdQik9p0y20Qy+2PuTAvvEvsWYu7D1vVVMBnzU8PVL9RkU8Ufk1FUkwLwpVDXQx1LalshfkI/XLKSr+yXP3tPGwmsjAByRbghlxWx6LqvHDOHSeKE/H9zLtO8k+F8/xxOmFRk/U63oHc0ekRKGFt/m5IYRnaUNJcxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176621; c=relaxed/simple;
	bh=NZOwWDer9kFTaMnL2fjpUdAJbg9zTprfuYL3AUD+ssQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mfizt+mvSlbkbSZ1yr96Z3YkfQE4pHZM4PMl/PZBTWcu7eIsa/L/GOSGUYuHdEB/3w4bJLVsts2OeejhPxbFd1XX4UvR5xL+QnuxOxwlNW8fwHA7WWMeeP6yCrJEHT5uznF2spoO+tVJSBdIN7V82AjreYEzzWRXrZ5QsIsGlTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b+EyqEwx; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab86a29c98so276471cf.0
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 02:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753176619; x=1753781419; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=b+EyqEwxW0WazZE08fRvdaKD1mmj+r1263WbnCtjsX3TfP1TMwSFkdMmKm8qQ+c/p3
         gUymifRs5uoUvj15Lb+s70lap+BPWlXLrGMx+lBgymYPsFjVvZQoqySs7Tit9G8fAfwa
         +Dyfoz6aZ8yHLSbqChGvFYrNhM4jdkL7YsgazeCSweZyDO3Dkud6QiiL+b5J5ScG/TZL
         o/ABqLnh1rM86Yu7IHo+OeSDVJw2sftBKfmPIXWd4m6jaln4GiJDHiJRrvbLNdiAAQPH
         rxvT9825L0dTaKWCOGCBKJoHQ8fV3e7JUuPRb8+we/ZT+/AA+ql+d5bp0nGXBHT6H5HT
         /T+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176619; x=1753781419;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tJ3NUgk3lgCY61pzl+Ni6KBJ9PADbvzhkTcNBzb1Rl0=;
        b=hMOYHr4C4LzXKX+dpYIU3hIlhoUIek9PRUiwly6WyQ6DbJDxv9X27CVe5UJboaby/A
         7F3hw47tM0wWxDYebsaqgdBy5ByazBCiXzt6Ofy0BDHGuL4cmfrxyTunS3Tcu4Nf+FAA
         nThbHMX1mxZvxzio+wKgyrUgAehcDakHvlHlmrpmxxdrkfhdIpKALCRtUoctijUlHMi3
         k5soVwm7NSWSlKnB37Omg5rVNnsBFYGk8zZ/6HhGJyQ80jI18WgAiBxkkLwigVlKen4s
         dgYBf+3Ui1ZeLMdT4hTVUwRKoVeVZWn3lAlsAw8WVRaGjm31lHxrLZYlB1F3IbRH55bK
         aFRg==
X-Gm-Message-State: AOJu0YzwrwqYIKJ1tI/n7hLvx3/Q5LcW75AfC7r5eIYHKyIU1TAxqmPf
	5maQ3zae3xfiews0Bjx72whMXgETnipx4v+GMjpldlpjK2chGBx4O41/wwO5KPw9gkq419tzAuG
	mmTPuedrc2JPlm9MA+966xDMlncRa7KMYGEohthuV
X-Gm-Gg: ASbGncuZjs1WqjOoNmdZrEcSKrobcSbTacAYKtSuLeKsyVqDvJ/yROKSWnILrr09Ia6
	0cMIatw4N3I+gYiSvJXixwJarLc8ohK9dLCJxxkhUBYtjayVHGOTYDFdEXjZPCkuXP/VYgIZJ99
	AJA98fmbOypvvq393NqmqmRZMZGx+6dwISo9X1Bj+h0wf8arC0f5IeD0bzfiCfxfChzcvlEA7v1
	gkNa9DI1yILII4lTKI5hS13Sxrb5/WV8Z2w
X-Google-Smtp-Source: AGHT+IHbd/BHMQdknwRTeYIHxdE5noPZ3kOvGg+B20+8ARSixzBI5h5DcNA/xdxCHeDrHowFoGGJAOmBsTNjOtbFr6w=
X-Received: by 2002:ac8:5707:0:b0:4a9:d263:dbc5 with SMTP id
 d75a77b69052e-4ae5cdcbf2fmr3451501cf.20.1753176618461; Tue, 22 Jul 2025
 02:30:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com>
In-Reply-To: <aH552woocYo1ueiU@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 10:29:42 +0100
X-Gm-Features: Ac12FXz-lwaWaACHfhK57yuAA5YnGjuXlhFfMAwyHrdRb3Dv43qkJ8E0aH-WQ58
Message-ID: <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
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

On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > cleaner resting state (see the diff stats).
> >
> > So just so that I am clear, applying the diff below to the appropriate
> > patches would address all the concerns that you have mentioned in this
> > email?
>
> Yes?  It should, I just don't want to pinky swear in case I botched something.

Other than this patch not applying, nah, I think it's all good ;P. I
guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
somewhere in a local tree of yours. There are quite a few conflicts
and I don't think it would build even if based on the right tree,
e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
rather an addition of an undeclared identifier.

That said, I think I understand what you mean, and I can apply the
spirit of this patch.

Stay tuned for v16.
/fuad

> But goofs aside, yes, if the end result looks like what was the below, I'm happy.
> Again, things might get ugly in the process, i.e. might be temporariliy gross,
> but that's ok (within reason).

