Return-Path: <kvm+bounces-61590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D29C226F7
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 22:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C37661892EFF
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5DFD311C3C;
	Thu, 30 Oct 2025 21:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RnENy23/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E66D307AFB
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761860244; cv=none; b=kMjOlnPtB+dt0YxlUUrqwlzS3WliafaNoNqooTCecpP+8uyFFE4HUDbUblnQ+6ClmeBEf8cdA9OeDHiVWuD/I8KHk+lPwJvbZ//NqCk8UNjI8dx1wDZEwCTN/uAsj5BWZJgvXnNJOmS1fHCiBh+8CH8ILlYSz3KFePbAKZ7WGuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761860244; c=relaxed/simple;
	bh=VAui8AWn8copQhC4kZGHA0swzDjJZpFxDyviY8QdSiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ls3WSwT6HeU36agsdMUIO01B2sfAlD9Thjuir7xE7WMXQS5w5fwn5Ti1pf0kq3SHZ6OwQztcGV+4ZMSsjRKdOzU1i4FTi/qnf9UC3SvaOmXozX0M0DaURAhMa8qufgG0APdqmhdxFIiffayZTS5RKy/zQR2uWGEeNkWFTDXCL60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RnENy23/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a27837ead0so1248178b3a.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 14:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761860242; x=1762465042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqH9fMyxc9+P0OjDrNByGI1LC2bpJVWLzcv83ocI04=;
        b=RnENy23/e4lgXVayIyLNA7exwHRTKb4fJksMUWcVHeSosYHvOy/61GaUfOpPSrtqS8
         NtOWnvTnxh2A54220FlAFteLRgXmeSkwSDndrNSl6Mm/zwBerLqhDcUPCri7kuWSsCDU
         N1Gd5RpAXD90I9M/DhfzSikpavNSghllNeYcehp+lrg3r1PTm9/2or+RTA6cngCMYWaN
         ljYoWz0q0cOPcoXAJbyVn6ORrvuzzAL+Go+/ItQmJdKOoMo22qh0AQDiKM9a+8UjXKVz
         2+FNT8a38emNKBq4SeKUrSKW7jDnYlgdPl1s+fnQH1ASC2JfZkdsc5JqYS95Q6vQua/7
         JSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761860242; x=1762465042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FjqH9fMyxc9+P0OjDrNByGI1LC2bpJVWLzcv83ocI04=;
        b=tzBkpqaTs5Edd4HQGeJhxdxhqebJ8eOXBUHSC66GB0J8mBhywysHXw5gi+A9FO1QAA
         sEJrr8KohpdV/AHN9A3MYZ2fjjKwY1/j6edM3KqWjJmg2YcYxo7VMP8k00Lpw8Mb9Ea8
         U+q0xjsLOzFnXZdqdGFzhH4b+81vy652ONacz8pPP49IG4uiRCJTng35L7Rf/JXT9TJX
         uiyT7GJvVCUQ9My732qkluYLZwAQSnTQO2eTZQ45WkRP5rNzgelgrd0+iAgT2STktX2K
         FQZS5do+yLzPQBt6EWpQ76dB6kvu7lttJPMz+9Vehew/kAlAOtzxUeaHscTkEXxR2zNh
         8mZg==
X-Forwarded-Encrypted: i=1; AJvYcCVLPtYNir7c+X7FmYmsPOJ4pAwfurs4KyjhbcbBdvY49jJeVAMZkSCkxm18bhpVqrZIR70=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe6cWiquiTQK42EVbUDXtm44JewXk8DL/2Olbjg6dHeSkflZKI
	WnuTFw1Kve1lYe0SWz7A8R4Z3shgSPWv4rBPf8dMD75JOh7yPmtSkaNulmWtzZNEeBP60NYit5B
	TXqB3MQ==
X-Google-Smtp-Source: AGHT+IHQXCkASO98UAVSO9VjI2IZVkmCZ27+eNAxxCZJeBSQ6f5kJjB6Vk2Jfqs7FpDmqPvWjbxdho5Wjic=
X-Received: from pjbbt5.prod.google.com ([2002:a17:90a:f005:b0:33b:e0b5:6112])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1595:b0:341:5935:e209
 with SMTP id adf61e73a8af0-348cb9a0c1fmr1707096637.38.1761860242517; Thu, 30
 Oct 2025 14:37:22 -0700 (PDT)
Date: Thu, 30 Oct 2025 14:37:20 -0700
In-Reply-To: <8a28ddea-35c0-490e-a7d2-7fb612fdd008@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251020161352.69257-1-kalyazin@amazon.com> <20251020161352.69257-2-kalyazin@amazon.com>
 <aPpS2aqdobVTk_ed@google.com> <8a28ddea-35c0-490e-a7d2-7fb612fdd008@amazon.com>
Message-ID: <aQPakDuteQkg0hTu@google.com>
Subject: Re: [PATCH v6 1/2] KVM: guest_memfd: add generic population via write
From: Sean Christopherson <seanjc@google.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Nikita Kalyazin <kalyazin@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"shuah@kernel.org" <shuah@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	Jack Thomson <jackabt@amazon.co.uk>, Derek Manwaring <derekmn@amazon.com>, 
	Marco Cali <xmarcalx@amazon.co.uk>, ackerleytng@google.com, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 24, 2025, Nikita Kalyazin wrote:
> 
> 
> On 23/10/2025 17:07, Sean Christopherson wrote:
> > On Mon, Oct 20, 2025, Nikita Kalyazin wrote:
> > > From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> + Vishal and Ackerley
> 
> > > 
> > > write syscall populates guest_memfd with user-supplied data in a generic
> > > way, ie no vendor-specific preparation is performed.  If the request is
> > > not page-aligned, the remaining bytes are initialised to 0.
> > > 
> > > write is only supported for non-CoCo setups where guest memory is not
> > > hardware-encrypted.
> > 
> > Please include all of the "why".  The code mostly communicates the "what", but
> > it doesn't capture why write() support is at all interesting, nor does it explain
> > why read() isn't supported.
> 
> Hi Sean,
> 
> Thanks for the review.
> 
> Do you think including the explanation from the cover letter would be
> sufficient?

It's pretty close.  A few more details would be helpful, e.g. to explain that VMMs
may use write() to populate the initial image

> Shall I additionally say that read() isn't supported because there is no use
> case for it as of now or would it be obvious?

Hmm, I think if you want to exclude read() support, the changelog should explicitly
state why.  E.g. "there's no use case" is quite different from "deliberately
don't support read() for security reasons".

> > > Signed-off-by: Nikitia Kalyazin <kalyazin@amazon.com>
> > > ---
> > >   virt/kvm/guest_memfd.c | 48 ++++++++++++++++++++++++++++++++++++++++++
> > 
> > There's a notable lack of uAPI and Documentation chanegs.  I.e. this needs a
> > GUEST_MEMFD_FLAG_xxx along with proper documentation.
> 
> Would the following be ok in the doc?
> 
> When the capability KVM_CAP_GUEST_MEMFD_WRITE is supported, the 'flags'

No capability is necessary, see d2042d8f96dd ("KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP
into KVM_CAP_GUEST_MEMFD_FLAGS").

> field
> supports GUEST_MEMFD_FLAG_WRITE. Setting this flag on guest_memfd creation
> enables write() syscall operations to populate guest_memfd memory from host
> userspace.
> 
> When a write() operation is performed on a guest_memfd file descriptor with
> the
> GUEST_MEMFD_FLAG_WRITE set, the syscall will populate the guest memory with
> user-supplied data in a generic way, without any vendor-specific
> preparation.
> The write operation is only supported for non-CoCo (Confidential Computing)
> setups where guest memory is not hardware-encrypted. 

The restriction should be that guest memory must be SHARED, i.e. not PRIVATE.
Strictly speaking, guest memory can be encrypted, e.g. with SME and TME (I think
TME is still a thing?), but with a shared key and thus accessible from the host.

Even if that weren't the case, we want to support this for CoCo VMs.

> If the write request is not page-aligned, any remaining bytes within the page
> are initialized to zero.

Why?  (Honest question, e.g. is that standard file semantics?)

> > And while it's definitely it's a-ok to land .write() in advance of the direct map
> > changes, we do need to at least map out how we want the two to interact, e.g. so
> > that we don't end up with constraints that are impossible to satisfy.
> > 
> 
> write() shall not attempt to access a page that is not in the direct map,
> which I believe can be achieved via kvm_kmem_gmem_write_begin() consulting
> the KVM_GMEM_FOLIO_NO_DIRECT_MAP in folio->private (introduced in [1]).
> 
> Do you think we should mention it in the commit message in some way? What
> particular constraint are you cautious about?

I want to be cautious with respect to the ABI/uAPI.  Patrick's series also adds
a flag, and guest_memfd doesn't currently provide a way to toggle flags after the
file is created.  That begs the question of how GUEST_MEMFD_FLAG_NO_DIRECT_MAP
will co-exist with GUEST_MEMFD_FLAG_WRITE.  Presumably the goal is to use write()
to initialize memory, and _then_ nuke the direct map.

I want line of sight to understanding the exact semantics/flows.  E.g. will KVM
require userspace to clear GUEST_MEMFD_FLAG_WRITE before allowing
NO_DIRECT_MAP?  Or will the write() simply fail?  How will the sequencing be
achieved?

> > > +     struct inode *inode = file_inode(file);
> > > +     pgoff_t index = pos >> PAGE_SHIFT;
> > > +     struct folio *folio;
> > > +
> > > +     if (!kvm_gmem_supports_mmap(inode))
> > 
> > Checking for MMAP is neither sufficient nor strictly necessary.  MMAP doesn't
> > imply SHARED, and it's not clear to me that mmap() support should be in any way
> > tied to WRITE support.
> 
> As in my reply to the comment about doc, I plan to introduce
> KVM_CAP_GUEST_MEMFD_WRITE and GUEST_MEMFD_FLAG_WRITE.  The
> kvm_arch_supports_gmem_write() will be a weak symbol and relying on
> !kvm_arch_has_private_mem() on x86, similar to
> kvm_arch_supports_gmem_mmap().  Does it look right?

No.  As above, write() should be allowed iff memory is SHARED.  Relevant commits
that are now in Linus' tree:

  44c6cb9fe9888b371e31165b2854bd0f4e2787d4 KVM: guest_memfd: Allow mmap() on guest_memfd for x86 VMs with private memory
  9aef71c892a55e004419923ba7129abe3e58d9f1 KVM: Explicitly mark KVM_GUEST_MEMFD as depending on KVM_GENERIC_MMU_NOTIFIER
  5d3341d684be80892d8f6f9812f90f9274b81177 KVM: guest_memfd: Invalidate SHARED GPAs if gmem supports INIT_SHARED

