Return-Path: <kvm+bounces-29307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E28289A9091
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 22:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99DB7287ACE
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 20:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBD81DE3BD;
	Mon, 21 Oct 2024 20:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQSZbkgp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F201CF5E1
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729541192; cv=none; b=hd55RbT5vrwPS3sIfaechVcBnJqXtuDepeUMGyE6LLpfAmSh9eUYnhM8CoptZalkVS5LxQH3TzCUO5HKKTnEmYeQyr5Q3eKG9Jvn76wweLzwyj0fw5Nigol8rBthdAKC9wIGNXlPrdr7I+ZAPn7KmBoGVE7Gb7MgcJprZt96THE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729541192; c=relaxed/simple;
	bh=w66+HWLU29K6giFASODVZFSXlWjISKGdhyr51p1M2LU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C/s3QEvUqNjvHAngOabzdFspc9seL8fvj5B3s4RfLFhct+JZK7oBt8AjLk1pMtPyTGqRQ4y67lreZ3iBS1fy/4oYAhcM++ewTnacWg3sbd3pyosjheqqRj6b4+yzNlhHi3L40W14QAsqE0BcsWCS+UcgyWfj69EeYDxumi5D45c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQSZbkgp; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6507e2f0615so4019631a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 13:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729541190; x=1730145990; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jQydAxFmzLtSulMZLCAMDLghEafTa0lLzzgstLise7U=;
        b=hQSZbkgpf9gthJ5C8P8bsWCJDG1gi/GG8AHt7gk3MO5ja9bP9SMJDNmkueIRJuYAzq
         qouCfIiQM51EfrF5rWj/Yefs3hWr4DCqW+GwBf5vmw7q0bLglujh9L7CfAQnTW6gKWZC
         1+10WgtXfAb3dKCkeA7MfxZpVSwu4OdpJYmJat2gfA4GAqduMSdiIT543wNoKV37msLN
         6s98DEgNB2M4Ef6gTX27RQT4Kxt2zvQj1suewPgbwYjyMvLUjfOs9zM/zYzdF2Y6D0Qg
         Hikp4Q8pDZuo9DippWbZq3sRkn5lnayYeY/b5veIZqw9jbjnXCqulzrM7Wtr2R6APpM/
         PsAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729541190; x=1730145990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jQydAxFmzLtSulMZLCAMDLghEafTa0lLzzgstLise7U=;
        b=DASbYL0Mj6/eMZSsk8giic3tSIYQQxrR9Aao5nZ29AULrhb5FiymSfQcjpX03xtuAq
         f/OYs8fvVlCb+rz2639Zq21GYg9XjnF3zB6wAUf59SNGbr3BPyoN7NWNHbO9ofrb1D8b
         Xd6ObCYV4WXSM4CLL2Zu5KbQ+UbFxeH5y9TqJWKpYHAX3U4tXQnBMHcoBfdmWbDyVggD
         U9M1XupqtN64QeSNk5WAvOF33CbqINtHf7Xh7TDLyLUY4oJyXlZkorAwPCHxFexM6y3M
         uUC13B5L4QUBdoApKWzAItdk8ZvvlaWfC3unWNW7LtoOHfZbYP7PFk7d3cVNuZ5D/Xku
         MewQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXvVTX2806lZ9gNsS4lM7XKVO877lCHUilW3PjAdFj7rMaZIL3ORGFc4l7NH2/01ZEITo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfwV454i2iopYR6uHTuHnm5Q1G5/YZ7x0QxBYpdg7p16rUZgoO
	R/CJtiUucylcboCoQDzwccb5y277pFJQS0nn91xQIiybG75x4y+goyQDHyosupDRSyzVQZW05eb
	P+g==
X-Google-Smtp-Source: AGHT+IGahi+khbjtJZ0HZ/7z1LR2ppjaBN1jQLMiCZXcAgcl/ysaF2b97SAVJTQNm9M4URr0+pBZSYLOkVs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a65:6814:0:b0:7d5:e86:58fb with SMTP id
 41be03b00d2f7-7eacc89420fmr14177a12.8.1729541190191; Mon, 21 Oct 2024
 13:06:30 -0700 (PDT)
Date: Mon, 21 Oct 2024 13:06:28 -0700
In-Reply-To: <0f7dac2d-e964-467c-ad4c-cfdd2daa30f5@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241018085037.14131-1-suravee.suthikulpanit@amd.com>
 <13b7b4eb-a460-4592-aec5-a2132ad60b02@oracle.com> <0f7dac2d-e964-467c-ad4c-cfdd2daa30f5@amd.com>
Message-ID: <Zxa0RDcKA-nO2RjX@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Inhibit AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
From: Sean Christopherson <seanjc@google.com>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, pbonzini@redhat.com, david.kaplan@amd.com, 
	jon.grimm@amd.com, santosh.shukla@amd.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 18, 2024, Suravee Suthikulpanit wrote:
> On 10/18/2024 4:57 PM, Joao Martins wrote:
> > On 18/10/2024 09:50, Suravee Suthikulpanit wrote:
> > > On SNP-enabled system, VMRUN marks AVIC Backing Page as in-use while
> > > the guest is running for both secure and non-secure guest. Any hypervisor
> > > write to the in-use vCPU's AVIC backing page (e.g. to inject an interrupt)
> > > will generate unexpected #PF in the host.
> > > 
> > > Currently, attempt to run AVIC guest would result in the following error:
> > > 
> > >      BUG: unable to handle page fault for address: ff3a442e549cc270
> > >      #PF: supervisor write access in kernel mode
> > >      #PF: error_code(0x80000003) - RMP violation
> > >      PGD b6ee01067 P4D b6ee02067 PUD 10096d063 PMD 11c540063 PTE 80000001149cc163
> > >      SEV-SNP: PFN 0x1149cc unassigned, dumping non-zero entries in 2M PFN region: [0x114800 - 0x114a00]
> > >      ...
> > > 
> > > Newer AMD system is enhanced to allow hypervisor to modify the backing page
> > > for non-secure guest on SNP-enabled system. This enhancement is available
> > > when the CPUID Fn8000_001F_EAX bit 30 is set (HvInUseWrAllowed).
> > > 
> > > This table describes AVIC support matrix w.r.t. SNP enablement:
> > > 
> > >                 | Non-SNP system |     SNP system
> > > -----------------------------------------------------
> > >   Non-SNP guest |  AVIC Activate | AVIC Activate iff
> > >                 |                | HvInuseWrAllowed=1
> > > -----------------------------------------------------
> > >       SNP guest |      N/A       |    Secure AVIC
> > >                 |                |    x2APIC only
> > > 
> > > Introduce APICV_INHIBIT_REASON_HVINUSEWR_NOT_ALLOWED to deactivate AVIC

Please use human/reader friendly terms, that's a very convoluted way of saying:

	APICV_INHIBIT_REASON_IN_USE_AVIC_PAGE_READ_ONLY

> > > when the feature is not available on SNP-enabled system.
> > > 
> > I misread your first sentence in v1 wrt to non-secure guests -- but it's a lot
> > more obvious now. If this was sort of a dynamic condition at runtime (like the
> > other inhibits triggered by guest behavior or something that can change at
> > runtime post-boot, or modparam) then the inhibit system would be best acquainted
> > for preventing enabling AVIC on a per-vm basis. But it appears this is
> > global-defined-at-boot that blocks any non-secure guest from using AVIC if we
> > boot as an SNP-enabled host i.e. based on testing BSP-defined feature bits solely.
> > 
> > Your original proposal perhaps is better where you disable AVIC globally in
> > avic_hardware_setup(). Apologies for (mistankenly) misleading you and wasting
> > your time :/
> 
> Repost from v1 thread:
> 
> I was considering the APICV inhibit as well, and decided to go with
> disabling AVIC since it does not require additional APICV_INHIBIT_REASON_XXX
> flag, and we can simply disable AVIC support during kvm-amd driver
> initialization.
> 
> After rethink this, it is better to use per-VM APICv inhibition instead
> since certain AVIC data structures will be needed for secure AVIC support in
> the future.

I don't follow.  I agree with Joao, this seems like an all-or-nothing situation.
There's no point in an inhibit unless Secure AVIC CPUs will exist WITHOUT
HvInuseWrAllowed, but even then, to keep things simple(r), I'm tempted to make
SNP+AVIC require HvInuseWrAllowed

