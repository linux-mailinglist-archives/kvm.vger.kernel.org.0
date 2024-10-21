Return-Path: <kvm+bounces-29306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D41E9A9033
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 21:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EBB4284E57
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 19:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9211CF2B7;
	Mon, 21 Oct 2024 19:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QlmTf9OE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51431C9DE5
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540301; cv=none; b=gdNKRGbJGMlNMwGaWbP1djeVZ2BGpXKwOGoiW8yzTZM22DQkRgnLq0PCwJ9Q/fwObMOI1SrgqYZ5znIIqRZRVZjvNaIJsn8w6hddpVw7hm6ckCbqyTZSYngUrzqZVKYmpBMrek2mOJERp+LacP84gRfaF6vSGj1RAHQvj/KSeIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540301; c=relaxed/simple;
	bh=cgF9qdTCV/RUJM1XhvuKTTekZ0x9M+flwDP2OJ+Mxn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BtNZYRuzjtDZXLiBffYgqJolIiPt6IDlb8Ze2kzabPi/txA2zjWo9pQ2a02YzeV9h+vgc48zUgdjq0oxeZj3RCVR1O7BHLOgotzB00DuV8CcmD/V3Ld4Dibea6XefE07gDGG2jYYXfdTwYhnOwgWto0eFa6OFYJeZYPIyBkknWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QlmTf9OE; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e390b164c7so80798407b3.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 12:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729540299; x=1730145099; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gDT9K1Zk/eR3fGoO0hal0kEeCs6xtYajmWI5rS4tNgs=;
        b=QlmTf9OE+kVVzxwypoejDuTn9VMF05eTxb6bHCfLTMLqjkGukF/qQc3Q/FYb2qhCon
         oZtObcuTTd6BVNOWw/bNs15EgJMkJg2VOwacgIw/jgM5JKF7wGYkkI7Ppdk9T4wAYqMX
         MiSK+YsvYXLl1WyhldungYaRLrZGEayH6fAW20HPDbGIhZeQXl328Auxm1ITZyaLmWhp
         nkOTyleaTGWM3sib9cYqzYsEQd4d5FSzyUWI3+RGoe0N4VE9yqEVdpotZvNDUeKJ29W/
         up9Z0q5BMbFfJBGlWWOQT0NuR3B3mBrxlxM6vJVbgpAm1HuewHKFfiGnKJYIBu4feccH
         4ciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729540299; x=1730145099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDT9K1Zk/eR3fGoO0hal0kEeCs6xtYajmWI5rS4tNgs=;
        b=mec60MnruLLJRBk6sI+F8qhMrD8ZTq1pIA4YuWSextQNokyLIfZDs8gOf8nZwqAktw
         8f9mbeG09dEVYUi5kFfgTGrsXMrE1i6ctKS3x6Tl4Kq0Gir/ASqOO1QXeOt10z5DnuJ2
         Yp9rUJBdrr1Jj8+wAMaYeh1JLleRPpii9neaaT3/IXvxp5PpECocSFS3q6CEhx7+AMiX
         h235HvOVa/Cdk+ZDwmOh/MadGgV1lSCLTV6GCdEVS5kgOsQ931sS2XAgi/qAxfZM5ngD
         wXT6XaeYdgM/+qznz6GSaJ9IMLOnF4e2L+seUm5BS12rier0jZ+hbTBt7rm5qeV0Puo0
         cQIw==
X-Forwarded-Encrypted: i=1; AJvYcCXaRZl3+6qqpTQf8UBsMn6eX7Wb4aP8jLE+2KWsu3AnIf1HxlRtDeumxIhrxJkFrVNrYbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOFKzDTTpMxGDahyNNUqYMasnvwBCwmOjNX4FNDDnb5lxHLexk
	l/iO/liCGMGUAyzLbsfCjnnqggYXtLjTmM+zlHAbRBxj5bGhR08pOdeCE1r0/963aFODyRlSGOJ
	GFA==
X-Google-Smtp-Source: AGHT+IGGFBPehWleZC7XacBr2c3VKS/i1pCA2xiI3p2Sl/k9XQN0j6oRQyRybzYCeQIxtNewnoAH//KfiNc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:23c6:b0:6de:19f:34d7 with SMTP id
 00721157ae682-6e5bfbd6b2cmr929207b3.2.1729540298379; Mon, 21 Oct 2024
 12:51:38 -0700 (PDT)
Date: Mon, 21 Oct 2024 12:51:36 -0700
In-Reply-To: <6028e1a0fad729f28451782754417b0be3aea7ed.camel@HansenPartnership.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1726506534.git.roy.hopkins@suse.com> <6028e1a0fad729f28451782754417b0be3aea7ed.camel@HansenPartnership.com>
Message-ID: <ZxawyGnWfo378f3S@google.com>
Subject: Re: [RFC PATCH 0/5] Extend SEV-SNP SVSM support with a kvm_vcpu per VMPL
From: Sean Christopherson <seanjc@google.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: roy.hopkins@suse.com, ashish.kalra@amd.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, jroedel@suse.de, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	michael.roth@amd.com, mingo@redhat.com, pbonzini@redhat.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 18, 2024, James Bottomley wrote:
> > I've prepared this series as an extension to the RFC patch series:
> > 'SEV-SNP support for running an SVSM' posted by Tom Lendacky [1].
> > This extends the support for transitioning a vCPU between VM
> > Privilege Levels (VMPLs) by storing the vCPU state for each VMPL in
> > its own `struct kvm_vcpu`. This additionally allows for separate
> > APICs for each VMPL.
> 
> I couldn't attend KVM forum, but I understand based on feedback at a
> session there, Paolo took the lead to provide an architecture document
> for this feature, is that correct?

Yep.

> Just asking because I haven't noticed anything about this on the list.

Heh, there's quite a queue of blocked readers (and writers!) at this point ;-)

