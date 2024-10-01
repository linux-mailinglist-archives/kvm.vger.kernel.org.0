Return-Path: <kvm+bounces-27789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9978798C5DF
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 21:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44586B2379D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 19:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667A71CCEDF;
	Tue,  1 Oct 2024 19:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQxEChV3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4453D286A8
	for <kvm@vger.kernel.org>; Tue,  1 Oct 2024 19:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727810214; cv=none; b=l4XyBFI0+EdVIOrtgMsVJ5IS/rMfHuh/J84C7gqPfROLE3y1Zggd701OWAmi39x93xbO8J7prh3MKU9eQP491KgqpyDDi6H6/xJmCK4SJO3D7t7fdwAfI5abNqFuALqu7dD3Pjfqip52ssiBJfhT0MpAt5BEWAc1VnbNfJcQvQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727810214; c=relaxed/simple;
	bh=VJCuu0CmxTMWIeYIPM/ilPiGNlQ+ZFuL/oWaHaMEeNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NnhDu1a5FsM7zWqS22+CkRxQhL0HP+7FQ1RCaHaauwmvDliS40hjopldVU9xhreyNcnuliZ+sCBny/Cg13Vkpn/1xRdGMubnFF4KeAtHQR9wZxB7kBqajbdHPGosVnSCoDFmwP2OhLAZ7B6FqCY4aKyqm1aWQ7l1Bzh1701VLbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WQxEChV3; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e0aceab142so5374232a91.3
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2024 12:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727810212; x=1728415012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uM2tuW3HA/PRfyXJPuBh+8scxOJWHS7AVT9M1VvwYHU=;
        b=WQxEChV33rXfT5QyBnwoZEmb6qpFUIvdT/tUPFePBMbPesiMND+nr4QhcR3WoA2aTA
         NOlUQ3NMSzwi+fTc8C60QJqTKCra7TD7TqqiTETx0h931RsWYGdW5sefKVbK+/MKFhMr
         ZsSIxOdWu7GzXfx7vuep8gsDe+MmsH2ljBwa4R9+6XQBUL/9DTsfGsY1kav6529qtNde
         l+YPDlJSynkAlZ7cms/OBQoEhWvg8B7SDe1Vf2pkbxYpJZIZ1LTWbdNcPwk+8JhS8Qb0
         belphvdfKPRx4PkqWv2/1+5o5ZPtDNfa+LWADPj42Lc8v59y/Yd76BpiRec9W+qjKIlk
         zR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727810212; x=1728415012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uM2tuW3HA/PRfyXJPuBh+8scxOJWHS7AVT9M1VvwYHU=;
        b=ZX1qkq7RtFRPP//PA44bR0q9PZdC6IfIluPEs1Qg1rqTYx72SSlVVQff/GX2yI6sYb
         PDa+NueN0JafuD0g+BLnk8erjpPtGKHCZmMjPMr5NQLOkPtlCZG+0eiAlfd+vhqacEaL
         ah2YiesS4TaVaG5Sc6BjQ78EGC84E/VVWgg2uW1vbU9+ED8DFScpYk01Fe0+t+ObB7w2
         YiW1dYSz0s2Thgc0N3BlcTuXHfLTzc4V+3EIiwDyClogEWyTY/AxbhE8AithLDG58Qh6
         vaMhiKli7s3Nog51XUhZPWjdgqV5Nq9zvf/U0ZO4HGnWX5OJys6wBJ7MPkxs1QSywy2A
         8NPg==
X-Forwarded-Encrypted: i=1; AJvYcCX5ohkt6VZCMIjYe2OvF4r+B4nTupTf/dErAXjiaZTNeqUMZZG5dBza8rAWuNzJwjPnHo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKSTwd7Yv+QEiZfukKePpRW8mjHU9OT4hg5J2d/EARmP9zOC/c
	rWnczG5CI1LekBUc0hmX7IgUFFlNnkI3n9nVhu04NqRogUMuKwIFYMCJ/tanCFhtQaNEr10Du9s
	9mA==
X-Google-Smtp-Source: AGHT+IG0uVqEwG5gFR9gmtKegj+9Fuss22dO15Bnyo/5gYwR45UtKDn7aNmWE8yCFPJM3drpR+ruk+/qeVU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4a92:b0:2e0:b741:cdc2 with SMTP id
 98e67ed59e1d1-2e1848cc3dcmr3834a91.3.1727810212485; Tue, 01 Oct 2024 12:16:52
 -0700 (PDT)
Date: Tue, 1 Oct 2024 12:16:51 -0700
In-Reply-To: <2e2e6161-9f65-4939-8061-83bf71810076@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
 <ZvrMBs-eScleFMOT@google.com> <2e2e6161-9f65-4939-8061-83bf71810076@amd.com>
Message-ID: <ZvxKoz9WQKmOp5HR@google.com>
Subject: Re: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
From: Sean Christopherson <seanjc@google.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, pbonzini@redhat.com, 
	david.kaplan@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 01, 2024, Suravee Suthikulpanit wrote:
> Hi Sean,
> 
> On 9/30/2024 11:04 PM, Sean Christopherson wrote:
> > On Mon, Sep 30, 2024, Suravee Suthikulpanit wrote:
> > > On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
> > > the guest is running for both secure and non-secure guest. This causes
> > > any attempts to modify the RMP entries for the backing page to result in
> > > FAIL_INUSE response. This is to ensure that the AVIC backing page is not
> > > maliciously assigned to an SNP guest while the unencrypted guest is active.
> > > 
> > > Currently, an attempt to run AVIC guest would result in the following error:
> > > 
> > >      BUG: unable to handle page fault for address: ff3a442e549cc270
> > >      #PF: supervisor write access in kernel mode
> > >      #PF: error_code(0x80000003) - RMP violation
> > >      PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
> > >      SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
> > >      ...
> > This should be "fixed" by commit 75253db41a46 ("KVM: SEV: Make AVIC backing, VMSA
> > and VMCB memory allocation SNP safe"), no?
> 
> The commit 75253db41a46 fixes another issue related to 2MB-aligned in-use
> page, where the CPU incorrectly treats the whole 2MB region as in-use and
> signal an RMP violation #PF.
> 
> This enhancement is mainly to allow hypervisor to write to the AVIC backing
> page of non-secure guest on SNP-enabled system.

In that case, the changelog needs to be rewritten, because the changelog very
explicitly talks about modifying RMP entries, whereas IIUC, the issue is that
cross-CPU writes to a vCPU's vAPIC page, e.g. to inject an interrupt, will generate
unexpected #PFs in the host.

> Note: This change might need to be ported to stable 6.9, 6.10, and 6.11 tree
> as well.

At the very least, it needs a fixes, which I believe is:

  Fixes: 216d106c7ff7 ("x86/sev: Add SEV-SNP host initialization support")

6.9 and 6.10 aren't LTS kernels, so backports to them aren't necessary.

