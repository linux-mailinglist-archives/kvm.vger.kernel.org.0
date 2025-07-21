Return-Path: <kvm+bounces-53017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC02EB0C9BB
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:33:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15E674E021C
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818042E11AD;
	Mon, 21 Jul 2025 17:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N3d8lKUG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA417C21E
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 17:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119199; cv=none; b=p7F1PZL5YYyz13Jv2QXnoDX1Pd+vfZrMpE0TRNiWKPy/VlH2hy2ns7B9QE9c9HxhquUEh3HqfLMN3eiARosygbhWUDUKruj7wpL2T4vEMR3dXo0GWGVH5LwLnC88wTqMrFklYjXXRhEoEYV7pCEns+noyXhZOxSxmc4Nkzss+B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119199; c=relaxed/simple;
	bh=mNDNOCM/MmTeG8bWN8KzikOsujHMksewTXy/RHZM/qE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EJp1e0ssqPsnGRSjfJ48682c9eCNn/Fqv9Ap6f/ijceDopEY4KWCCW1g2rhYiA/NDqrNa7VUUp3Y/WhL5ZMfbA6sTVGAsDlZ6e+rZ8fBmiy/uF8yQHAlnWTAxwp77t6NM3xt8K7HKWPY5OeIE4a4LrRzPm7BraMMyfMpwadIOtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N3d8lKUG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so6182575a91.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753119197; x=1753723997; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZ4+t7dcQ2ZTieyIQcNf54MPM3Tf5VMEW4AFMPESUF4=;
        b=N3d8lKUGk/bQ1FKto9x5kAHNe3GopGBm/ofUbbwxiQhDShB+njzBbi25olBju9tzdV
         KYNF1hKyd+Iz6QypE3k/c+b577PzXh8adOaFpZ0XyR3sSkj0aGPIy3Pdb9HcmH0OGsgk
         V/3dbLBmcH1zd00Cd8MrO3qEbXGd8kVRCKM48JssUtebcwlgUBBe4qCgmZPruaMooKzr
         +L22k/yeN1eaOV4SOeXQjJle+Gs3gtXVqGVchBXTxRR1g9ffB5ExoTKBn42Q5bAPkIdW
         g2mcqgf9zthZhR8mcyB4PACNzj3kEtiRwZ82/qnBucut+xUM6R6+Q1MUzGXWBTdV0hWw
         6Z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753119197; x=1753723997;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZ4+t7dcQ2ZTieyIQcNf54MPM3Tf5VMEW4AFMPESUF4=;
        b=LaHWkDQpYU57SRumxzWg4+zJxkU7bbPdJibGQMFKpjXaqVECg6R57Hjt0UXE+o4qZZ
         5ri9ZH+DAfrBNGuajngIJksyAtUX5U+VGmQBqeLgrCiffpotn2zH7giJem3g99imrysO
         wR6OlBOFrksZju1JF4me3hoUH8iC0GB5GK2jGWSmLuFcvMOK+kbvwyySOmpad/A44Bi+
         4gOU+ldZ1EDVb7hV5OO6Sx4LymcuGrE3ctOalxN8gofGdfCPRiTYXZM3X7WQYJNL3vC5
         0f/Ca7ZUKd2dUkLt5GmbCntOkrZFazjcMQkSRZ7A1QmO3MsPJvV4BTAyvDGS6vEuJsLL
         gt+g==
X-Gm-Message-State: AOJu0YwCei2pV+TQZui1eFL9yIq1fJj5ISIsMOaqAfji4idE3DJJV3qm
	HkBmBsQbKn35ABmdTgBuzIfrMEL5iBrbdqmlQpIE4wRjE6t1Y3dVCMB7jO0UPj3ZZDlnDHRaTsO
	TOL1PmQ==
X-Google-Smtp-Source: AGHT+IFwe3ukJO/AwYaZYv00wIRNUUpc+AWlcSl6+/xV7rqHjeFmT15UCVZr+TsQ5cn11BlfaXrHgArz1CM=
X-Received: from pjbrs12.prod.google.com ([2002:a17:90b:2b8c:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b06:b0:311:f2f6:44ff
 with SMTP id 98e67ed59e1d1-31c9f42400cmr34113055a91.17.1753119196635; Mon, 21
 Jul 2025 10:33:16 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:33:15 -0700
In-Reply-To: <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
Message-ID: <aH552woocYo1ueiU@google.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > The below diff applies on top.  I'm guessing there may be some intermediate
> > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > series, and there is feedback relevant to future patches), but IMO this is a much
> > cleaner resting state (see the diff stats).
> 
> So just so that I am clear, applying the diff below to the appropriate
> patches would address all the concerns that you have mentioned in this
> email?

Yes?  It should, I just don't want to pinky swear in case I botched something.

But goofs aside, yes, if the end result looks like what was the below, I'm happy.
Again, things might get ugly in the process, i.e. might be temporariliy gross,
but that's ok (within reason).

