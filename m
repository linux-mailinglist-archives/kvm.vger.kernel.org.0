Return-Path: <kvm+bounces-39424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859E5A4708C
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A53F16E9A8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 00:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F804D8CE;
	Thu, 27 Feb 2025 00:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wNILA9DJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B03938FA6
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740617519; cv=none; b=VPZhVhGiH1EF2xqF8YgIAIkbizYkn0we/ipfl1NRUP6b62TE0VtDLQlMuGwiBDZLaVUjhP5Se1sunOh6e9HI9JnYZdqG0ZQhVDZtkLvu7z1d66p84oqgluLmJcjdqaJKtGtlySbj8QFIcctGWzGEB7MHp5/XiOApHq6oJFPNQY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740617519; c=relaxed/simple;
	bh=Q7mNOkHjkgMmZIP6NY5cOonhJIgXhPCJV3iNp/QtlhY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kMlMYXfrYs+JsSuyfnvDEMMLOAhc8esotFYTX8gxW1CQSmWx4HNhvkC/XPYNTgKMEd1vBkN+vlIZuGMtJj4Z8Iy5urq++ruvzeACEhnnHwBPTYmHuvNBuRUkwFEmOPHimlGdYAQ3hiODkqgv3j4W29CX3hI4gj+gmsG45e2DiVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wNILA9DJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2233b764fc8so6215545ad.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 16:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740617517; x=1741222317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJotyZiERuL6yZQBDvDnm5IddJUBCXFIUhbBusTXxps=;
        b=wNILA9DJwSfaz+/FgVDFsta5xGuj+gnGpK6sHsfci7ZXNns9WBL6UM+2o6J+Kqu61g
         WxZZzY8vPV51whMMcnPQhK6dqbafOlE5cbqOsIEBWvJ3xhy4K0wRAcgr8RqsDNIZVTzx
         2VBGJlqcaDa3q7aQmlKahTx5jvvtSeR2mHP61nbsKnucGHwH78hPFppZf31AlQndSVIR
         tMF5GruKGgNthtNdrL2EEUzK/2/WxDPoV/f76xi98vKHzr2MQM3uW3C+NQzTweiHhYq8
         PoJYYnLVBk6CiEtZR/d7InKoSjo8FcFNWr0X62Nc21GIEZg1/SZYuEaY++bqpnF5+Tpb
         WM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740617517; x=1741222317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EJotyZiERuL6yZQBDvDnm5IddJUBCXFIUhbBusTXxps=;
        b=ojGjnu/x02hjAG+ygAnrnOMY6x41b8WrOoMXnqsFw57Ytaz5oWwMT1LrA0ofaf3jgq
         nI1S+hPNcgmgEE+ZLi+OYPT8imW6JDBtc+8itURlhwuRwaDMsn5wuxJ3jLr4tgAQJCoT
         xosG8EEcAkoPN6aqPQHtpCDG9duQzgsnCjGu+w3bHxNTuQAEdSrrBnGQ4UW1sOAXnY94
         8LhX0PqVJ6cwwi2Ilrbmo0y6ty30v1gXA1n0XHa5Chl0AYv4ymXS5Ku6anowuxqq1bGU
         OmdC8qo232uZnXQe5vfvtvf/y3voHGzUBltxcXvZJ/Y7BOlsvllgrYCceHyLpVzI/IAh
         EZkw==
X-Forwarded-Encrypted: i=1; AJvYcCXwEIXKkVb1Bs28kkHbVym8yNbLGaE8mll+3o2mGYfbfsRq3wHTUb1WMYKq2Z7Q9Vk7tHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsFFwCguznCAs87ZAsaDdc/aEc5C3isX0cyYvpLzxqPbI45jcR
	w3eLNSiWjHXkA+aXxqPigwtVT6UKise2gmm88IFFWLH6jWO3iVZVrB2z4tHgH0WdPlQTxr1mEyi
	4Ug==
X-Google-Smtp-Source: AGHT+IEL51u+VHZPqDrfRj4ysQhapPxjeZQ1gDCkR3XNIivE5W3G5YIUboDt4EBORJQZsRkmkIxq982vmL4=
X-Received: from pjbeu5.prod.google.com ([2002:a17:90a:f945:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d502:b0:21a:8300:b9ce
 with SMTP id d9443c01a7336-221a002afb5mr402718905ad.49.1740617517337; Wed, 26
 Feb 2025 16:51:57 -0800 (PST)
Date: Wed, 26 Feb 2025 16:51:55 -0800
In-Reply-To: <4c605b4e395a3538d9a2790918b78f4834912d72.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
 <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
 <Z7UwI-9zqnhpmg30@google.com> <07788b85473e24627131ffe1a8d1d01856dd9cb5.camel@redhat.com>
 <Z75lcJOEFfBMATAf@google.com> <4c605b4e395a3538d9a2790918b78f4834912d72.camel@redhat.com>
Message-ID: <Z7-3K-CXnoqHhmgC@google.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: James Houghton <jthoughton@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Feb 26, 2025, Maxim Levitsky wrote:
> On Tue, 2025-02-25 at 16:50 -0800, Sean Christopherson wrote:
> > On Tue, Feb 25, 2025, Maxim Levitsky wrote:
> > What if we make the assertion user controllable?  I.e. let the user opt-out (or
> > off-by-default and opt-in) via command line?  We did something similar for the
> > rseq test, because the test would run far fewer iterations than expected if the
> > vCPU task was migrated to CPU(s) in deep sleep states.
> > 
> > 	TEST_ASSERT(skip_sanity_check || i > (NR_TASK_MIGRATIONS / 2),
> > 		    "Only performed %d KVM_RUNs, task stalled too much?\n\n"
> > 		    "  Try disabling deep sleep states to reduce CPU wakeup latency,\n"
> > 		    "  e.g. via cpuidle.off=1 or setting /dev/cpu_dma_latency to '0',\n"
> > 		    "  or run with -u to disable this sanity check.", i);
> > 
> > This is quite similar, because as you say, it's impractical for the test to account
> > for every possible environmental quirk.
> 
> No objections in principle, especially if sanity check is skipped by default, 
> although this does sort of defeats the purpose of the check. 
> I guess that the check might still be used for developers.

A middle ground would be to enable the check by default if NUMA balancing is off.
We can always revisit the default setting if it turns out there are other problematic
"features".

> > > > Aha!  I wonder if in the failing case, the vCPU gets migrated to a pCPU on a
> > > > different node, and that causes NUMA balancing to go crazy and zap pretty much
> > > > all of guest memory.  If that's what's happening, then a better solution for the
> > > > NUMA balancing issue would be to affine the vCPU to a single NUMA node (or hard
> > > > pin it to a single pCPU?).
> > > 
> > > Nope. I pinned main thread to  CPU 0 and VM thread to  CPU 1 and the problem
> > > persists.  On 6.13, the only way to make the test consistently work is to
> > > disable NUMA balancing.
> > 
> > Well that's odd.  While I'm quite curious as to what's happening,

Gah, chatting about this offline jogged my memory.  NUMA balancing doesn't zap
(mark PROT_NONE/PROT_NUMA) PTEs for paging the kernel thinks are being accessed
remotely, it zaps PTEs to see if they're are being accessed remotely.  So yeah,
whenever NUMA balancing kicks in, the guest will see a large amount of its memory
get re-faulted.

Which is why it's such a terribly feature to pair with KVM, at least as-is.  NUMA
balancing is predicated on inducing and resolving the #PF being relatively cheap,
but that doesn't hold true for secondary MMUs due to the coarse nature of mmu_notifiers.

