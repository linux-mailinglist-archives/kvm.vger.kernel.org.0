Return-Path: <kvm+bounces-7180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1206F83DEEB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4548A1C2364B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E1B1DFF9;
	Fri, 26 Jan 2024 16:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NuOarXt1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A2C1DFE3
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 16:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287164; cv=none; b=QfvNobf3aXMUZYgU7if4LY4XMVHQRDe0UOx6yJVJYzWr6md+CdBlXr9KtkXLy8ovbWXk4PeXz3iZ+/OrVtB1mkzVVkvcwCsOnFNSnhD9WRhmnsle6IpXv09VQRc5u9JPGFyPc+HOxoErzUAgS+puOxdZkdVIppMCXqaT///b8x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287164; c=relaxed/simple;
	bh=y9OvmThwjw+K3nfMBDe1SkN9D4kRML05OGlUopManuQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ulobnu/cbv2OVtTjU5tCHHD0xwlPMZSmUU3kEyaGFbV8a5kQhDJAd4Vc+q18gx7Q1POxtsJHJ9Qa/vGLHrAZ8tCqwELJZa4t/vbRWm3l/KhX4d1kzqLv0m447bw0Gdh0zbIw9UfF9UHCbtFpb4hpz75TH+UdHlwAhaC3ys3wJVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NuOarXt1; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ffa2bb4810so9534537b3.0
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706287161; x=1706891961; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZpNenkMM62G0MLKLgK9Oo0SvrSlKfpzY/Gj9FXzciw=;
        b=NuOarXt1qCmZYwnOBUaQZOME0Dbqw5BZyG/4NHElLgV0/IGmROUVu7xP84pqX48Lzl
         XQCQ4UB6PKLeb2Y5WFjJPWwD+a43tsQdQPc9OJ9oFeCHmgr9vW2VRcwfqMJCwHs0odg2
         WmqR5o+2C9x8HBkHnD2agwlNiavrCQ5vdHSdmnEz9IwVBSNJXnlHqssztx8v+CFv0uh+
         2TMjF/Tx+3BQnX4WvcghlOedVKnxDDJ7RHPJT/BSh/nQRC125Q10g1ZJp7bDJStXeLj1
         i0pAa7mf2l2Me0JZmEhRBOJPo3h2LaM1Xg3Q/5Pe37O1RIsLJFNR+QZNNxpQ/rIeDoA7
         c4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706287161; x=1706891961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZpNenkMM62G0MLKLgK9Oo0SvrSlKfpzY/Gj9FXzciw=;
        b=UMZlRLqyO/+p/iNkGpB3SNsVU/mnHsdUFiF+Gs8jEAoTWyCK+O6rBFsmy4+vr52tCk
         oYEHo5VLiOR/LXYgWmflwQGnG3h1nIkvzEJU0i73CDcDXF2PPEjns0QunRqYL7rIB48s
         Wy1u0OWjFwaZ27Bp3j9H1LNwHZg+L3DOOyWxOcC9MZjpsekHvVgG4a1AVr3kRH4ujBOO
         YdPCeq5pOPHaWyajGtybtxKMF5Z0lGwv7rOxUoYR8CI81ETXQSU8KlJcwg8hqfCRpzQe
         Cn+x3OeySNRM0PGuRlRWgnMsrRtG4VSBm3yAY8MvifsHCd8u1Vdk4mu2BrThK6iHV/vU
         KGGA==
X-Gm-Message-State: AOJu0YyPTMteHhtyt9XAKy9XdQ3tHD1m3AFAaEfeEoyjq/QaVl/793jb
	XWqZYBJMas2uhKhLF1LGEbA4uwgtpcNUygQtN2fp+F75NudlFhOprBQjFMSkN3VroHGUlEJMa2d
	xzg==
X-Google-Smtp-Source: AGHT+IEt7KBEKXH2oAkDokQwrod7W0W187JMIOZ3zmqTpHmMwlN026yzXyWb2j7q385wSlIt7moUe9rr8Tk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4cd3:0:b0:5ff:9698:729c with SMTP id
 z202-20020a814cd3000000b005ff9698729cmr6889ywa.3.1706287161724; Fri, 26 Jan
 2024 08:39:21 -0800 (PST)
Date: Fri, 26 Jan 2024 08:39:20 -0800
In-Reply-To: <87sf2k83qb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com> <20240110011533.503302-4-seanjc@google.com>
 <87sf2k83qb.fsf@redhat.com>
Message-ID: <ZbPgOLVk4armOGDi@google.com>
Subject: Re: [PATCH 3/4] KVM: Get reference to VM's address space in the async
 #PF worker
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > Get a reference to the target VM's address space in async_pf_execute()
> > instead of gifting a reference from kvm_setup_async_pf().  Keeping the
> > address space alive just to service an async #PF is counter-productive,
> > i.e. if the process is exiting and all vCPUs are dead, then NOT doing
> > get_user_pages_remote() and freeing the address space asap is
> > desirable.
> 
> It took me a while to realize why all vCPU fds are managed by the same
> mm which did KVM_CREATE_VM as (AFAIU) fds can be passed around. Turns
> out, we explicitly forbid this in kvm_vcpu_ioctl():
> 
>         if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
>                 return -EIO;
> 
> so this indeed means that grabbing current->mm in kvm_setup_async_pf()
> can be avoided. I'm not sure whether it's just me or a "all vCPUs are
> quired to be managed by the same mm" comment somewhere would be helpful.

It's definitely not just you.  Documentation/virt/kvm/* could use thorough
documentation of what all in KVM relies on vCPUs, and all meaningful ioctls(),
to be executed in the same mm_struct (address space).  Because that requirement
is pervasive throughout KVM.  E.g. sharing KVM page tables across vCPUs is safe
iff all vCPUs are in the same address space, otherwise the hva=>pfn translations
through the memslot would diverge, mmu_notifiers would be all kinds of broken, etc.

