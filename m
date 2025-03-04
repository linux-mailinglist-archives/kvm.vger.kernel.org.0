Return-Path: <kvm+bounces-40046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60A78A4E439
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 16:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA7C16E6BC
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 15:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929F62356A3;
	Tue,  4 Mar 2025 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DiF3v5Vk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A4F204C1D
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102223; cv=none; b=VIKYqr1kSdYjbvdlVgq3mtl4nazFYjmz77PUgcluGBZblOn0dIbbj4xrGKSh2v20+93DrG3srd0u6o4q+GCuUqUaiZ59mTqPI6Fb3n4MWbEHvTXI/AoGF+6cGd3Kp7/GZw5/ghfpy6+FMqaK/qpo5bEYjOcyCYumlU3Df/bGsM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102223; c=relaxed/simple;
	bh=pCfGtvk96jzYY0aDPo6UzD5wZN4EHA8IEklxkYVKezQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Vk+uAitTXXR2UZ9MJReeCe7j9O7IZyIJWnne29SMi1Rgs9XPzBk4wvGxdZNw6uzyZwrBo9o6QmIaAVYb5JJBbXEUx07bFfkLh4kbfl9cio3o6qf4PXxec3SigmoYk9Dx1m2ft6b+7hoRALQYCmNUk74rvhjn9sjJSg6DgU0AO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DiF3v5Vk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2feda472a7bso5683068a91.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 07:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741102221; x=1741707021; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cvg9RGNtgXTSILk0IdpR94FQL1jxJC1gyLgPdqw8XU0=;
        b=DiF3v5VkUGnzU9LKyJFBLtvo7EuoyDw4OnRAFiK+y8GgN2HpMhbK8zc+rPW6V+4IK8
         TYW4fTuVYM41oIxmQaZBZq0o0HbHJLedCSSU2GgvWAH5pz6pLojHA/aIl9g8er5M03Yr
         BjAISmyhDBrGcce83oggSEo1XMgS/4C8xlA6tW0JCgl0dW3TBJn8ksyPyrh9ZEdqA9xU
         Nbtp3xtpEx6yvGs/9oPSIOx6pib+NM4PGyvglFbFc7K3+inEa8mXx/cYzMAxwgVlJmhH
         dM+EarfIA5cX5aGGpBxXzZsLq0QwUCrrq7TQPuLflyLlIzjlgIo6Z9iyzUeXJoqyIYni
         dVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102221; x=1741707021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cvg9RGNtgXTSILk0IdpR94FQL1jxJC1gyLgPdqw8XU0=;
        b=WNBrtJe4ckPWoMvBO8A25VWBA8W6sa4qXI5QCYAZuBuAkuyC/qK+q+/S2w+YWE55/R
         LDJQSwIuKAxbgV1zBG//GmPSnhcJakmzUjFECb8Ei7hR/mcFV++C25RMtF5IpBVHJ8tG
         AOzTW2D0NdVcumAzyUHdRs+3g8GfLRCap6vO1ngVqSuVKe3BCxswNlVuK3iLcsV/HSag
         AsVJyGDXY1FSCOtzvcUMruKZGrO/IDs7yYp7ZwK6iHZtBkm63slZD8VXCupqVjAJVh7G
         ZmP0K410Hfchry/MZjKwdbP32c4MAClRkJJtt6WWrQN+4I0txVYHhi4uwlkSh3HI9l5Z
         hkoA==
X-Forwarded-Encrypted: i=1; AJvYcCXqot0MVrrmXtyvS9OD5Aj7pktETOBhn/RiyzDPAuODEikxhYbeGn2ugCGKqugDNBb+1PM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCZLAIRw3Yqcp04mS2FNl361afcOK/o7gXzeutlvhhAUpFjFRd
	UNldFPHWE9OJxt+7A9tPyTK7D4H9nWorz+S/5XoyCPHWUjfcZ/kab1jdpmRR+dmQkmt8nMErcQv
	PsA==
X-Google-Smtp-Source: AGHT+IEM4E5/Zptus46DoKrgzz5+XTeSJ4hJIAQWQAIYRnIL9pjg60K5aKaF81Eu644JbhsDlC5832QLpoQ=
X-Received: from pjur6.prod.google.com ([2002:a17:90a:d406:b0:2fc:2959:b397])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c90:b0:2ee:db8a:2a01
 with SMTP id 98e67ed59e1d1-2febac10a9fmr26741760a91.30.1741102221273; Tue, 04
 Mar 2025 07:30:21 -0800 (PST)
Date: Tue, 4 Mar 2025 07:30:19 -0800
In-Reply-To: <diqz8qplabre.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <b494af0e-3441-48d4-abc8-df3d5c006935@suse.cz> <diqz8qplabre.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <Z8cci0nNtwja8gyR@google.com>
Subject: Re: [PATCH v6 4/5] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, shivankg@amd.com, akpm@linux-foundation.org, 
	willy@infradead.org, pbonzini@redhat.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, chao.gao@intel.com, david@redhat.com, 
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 04, 2025, Ackerley Tng wrote:
> Vlastimil Babka <vbabka@suse.cz> writes:
> >> struct shared_policy should be stored on the inode rather than the file,
> >> since the memory policy is a property of the memory (struct inode),
> >> rather than a property of how the memory is used for a given VM (struct
> >> file).
> >
> > That makes sense. AFAICS shmem also uses inodes to store policy.
> >
> >> When the shared_policy is stored on the inode, intra-host migration [1]
> >> will work correctly, since the while the inode will be transferred from
> >> one VM (struct kvm) to another, the file (a VM's view/bindings of the
> >> memory) will be recreated for the new VM.
> >> 
> >> I'm thinking of having a patch like this [2] to introduce inodes.
> >
> > shmem has it easier by already having inodes
> >
> >> With this, we shouldn't need to pass file pointers instead of inode
> >> pointers.
> >
> > Any downsides, besides more work needed? Or is it feasible to do it using
> > files now and convert to inodes later?
> >
> > Feels like something that must have been discussed already, but I don't
> > recall specifics.
> 
> Here's where Sean described file vs inode: "The inode is effectively the
> raw underlying physical storage, while the file is the VM's view of that
> storage." [1].
> 
> I guess you're right that for now there is little distinction between
> file and inode and using file should be feasible, but I feel that this
> dilutes the original intent.

Hmm, and using the file would be actively problematic at some point.  One could
argue that NUMA policy is property of the VM accessing the memory, i.e. that two
VMs mapping the same guest_memfd could want different policies.  But in practice,
that would allow for conflicting requirements, e.g. different policies in each
VM for the same chunk of memory, and would likely lead to surprising behavior due
to having to manually do mbind() for every VM/file view.

> Something like [2] doesn't seem like too big of a change and could perhaps be
> included earlier rather than later, since it will also contribute to support
> for restricted mapping [3].
> 
> [1] https://lore.kernel.org/all/ZLGiEfJZTyl7M8mS@google.com/
> [2] https://lore.kernel.org/all/d1940d466fc69472c8b6dda95df2e0522b2d8744.1726009989.git.ackerleytng@google.com/
> [3] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/T/

