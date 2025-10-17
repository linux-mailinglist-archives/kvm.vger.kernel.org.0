Return-Path: <kvm+bounces-60345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3B7BEAB7A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:30:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8B3A05A02A4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E213E284B2F;
	Fri, 17 Oct 2025 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V5f2MTTJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9670B283FF8
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717395; cv=none; b=Aa0v15P6YlhsYWVjOnJfYCtMvlE3PM7eQMc9hISmIi0RQKmhaVpSuYutb8fD//0Y3i6f8vvv5Dwpwqhw63j7P0CcNm4jh4P5WAJIJqVxKXFeAST2biEZ6xQODzLUEVURo/dSO9m+1tK8Qhb+H7kTJ1dW1+xz5oAvUb+FPE4V8TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717395; c=relaxed/simple;
	bh=UiLYr8jJW28eUVROI2Zqetwow8c8Jur2bmph5Wn4+jI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pUZrlRXVi3HTCKzCwQvyu/OtkK2uFbRrIxxZxAB99VeW4D1B/LdPEoBu3HQ8ixbs5QIQlwAnQZE+H6mK7dxJkgGCcVeq0VMVdkgBRTMpILaB7jhKpAgifjCgLJbTZnYPpmgUFgMLRW0RtHSCBxk4iOJT9doga2yUfEhMzBNiFpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V5f2MTTJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eddb7e714so1878234a91.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 09:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760717393; x=1761322193; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xco4bIjlvyRAGDvFYX9qeWZinCThHE/ogACqSwyAjPk=;
        b=V5f2MTTJShkRqg9+rITcfSBO3cLyRSYQ9oN3YHtA4hJ6EwGQZ+wDQwGQQjCBwBQwXV
         qWgANYG9lLM2orWkotio7Jpr1qLvqHvCRhcgJPDnuIjPJukJFC5IINxupDEC++hMnYCq
         vrF0OklSywvO5UnvZm58PJAk1oOX2IdGatT0pZlgbWvQfnmBJs/HkdZFjqhcIbfkHHoa
         mpfAgjds7rloyx7Zaw1IYE3mE8wwl2vp3B6f/qT1Ztk1N7WNy3wp61GOpDPBCVfcK60Y
         i/akICWyVnet62AH34s+xRWNgCpa18BCTwLnEpfkwB0nCg0tYmZp3q8S1yYbtkocX+2P
         sZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760717393; x=1761322193;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xco4bIjlvyRAGDvFYX9qeWZinCThHE/ogACqSwyAjPk=;
        b=YZgzPoSBfaxKSujJ5kVvrNCSaUZj+mkh3A+CIwJwB2yhlkK7QX+VZzrMHOSMbjSjcS
         BJVxpPKMSwDJqCFygv3hhWttUKM1HnagCQOxPnsRdAyrUEPIH0YOitzPTbBeqgN8KOjv
         igK0zuYiJUywCzcmp6C6rY+HKJCNdrURQjs0J2zQ7hZO0rsP5QpgT1RsMTH3BpQqLzze
         ebjkeVoLUQ+7EXypFVWi1qlTSXjzM0CGwO+6Mfl7WEWrr1ZLr6MTis9J0/vI2HitVT2N
         6/r51UOYtHvMV75PpCyZ2IcIhD5RM4r2WYpkZRc2AuPzBDcLkGlgh1vkk0dTANBBd9k6
         bgGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaZ6idK2xexakQvr7kA7cxpRBIrgDKdHvVDqetOYb4XkNAYUfQMW8W8sOu1zibCmSCCW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0x8IYDT24JO6VTneuljWccKR6YeQdVag75ByPJy+xv9D/iYFV
	VKI9dGWgRPhQNcFL9zutBCOt5dTfpn08MuY3cloy/hQovqEeejHHcxH7Ro54jR/w9Ww3mGPmwvA
	NESNrWQ==
X-Google-Smtp-Source: AGHT+IEX3Sb5zJcmsRpA1W1vQ5QaKm+SHN+64AlkRsSY2B5yN0+QDo/O6QpFaF3gXFyeWZi0UF8r+4DiSYM=
X-Received: from pjqc13.prod.google.com ([2002:a17:90a:a60d:b0:332:7fae:e138])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0f:b0:33b:6ef4:c904
 with SMTP id 98e67ed59e1d1-33bcf8faaf5mr5262194a91.20.1760717392946; Fri, 17
 Oct 2025 09:09:52 -0700 (PDT)
Date: Fri, 17 Oct 2025 09:09:50 -0700
In-Reply-To: <ad3b910a-ff83-4738-888b-5432d09de073@maciej.szmigiero.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <90ea0b66874d676b93be43e9bf89a9a831323107.1758647049.git.maciej.szmigiero@oracle.com>
 <pssrvpxpo7ncvfkgunuwbenztcw4p4d3aavvbmgzcr23fg7biy@aeylu42ii3k6> <ad3b910a-ff83-4738-888b-5432d09de073@maciej.szmigiero.name>
Message-ID: <aPJqToq-589NovVS@google.com>
Subject: Re: [PATCH v3] KVM: selftests: Test TPR / CR8 sync and interrupt masking
From: Sean Christopherson <seanjc@google.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Naveen N Rao <naveen@kernel.org>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 17, 2025, Maciej S. Szmigiero wrote:
> On 25.09.2025 12:43, Naveen N Rao wrote:
> > On Tue, Sep 23, 2025 at 07:32:14PM +0200, Maciej S. Szmigiero wrote:
> > > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > > 
> > > Add a few extra TPR / CR8 tests to x86's xapic_state_test to see if:
> > > * TPR is 0 on reset,
> > > * TPR, PPR and CR8 are equal inside the guest,
> > > * TPR and CR8 read equal by the host after a VMExit
> > > * TPR borderline values set by the host correctly mask interrupts in the
> > > guest.
> > > 
> > > These hopefully will catch the most obvious cases of improper TPR sync or
> > > interrupt masking.
> > > 
> > > Do these tests both in x2APIC and xAPIC modes.
> > > The x2APIC mode uses SELF_IPI register to trigger interrupts to give it a
> > > bit of exercise too.
> > > 
> > > Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> > 
> > Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
> > 
> 
> Was this patch picked up or are there any other review comments here?
> I can't seem to find it in any KVM upstream tree.

Not applied yet, though it's in my queue to look at.

The main reason for the delay is that I think I made a mistake by shoving the ICR
test into xapic_state_test.c. Bundling the ICR test with APIC ID tests was "fine"
at the time, but it obviously encourages using the test as a dumping ground for
similar APIC tests.  And I don't want selftests to end up like KUT where there
are these huge, inscrutable tests that are painful to debug.

So I don't want to apply this patch before deciding whether or not to split
xapic_state_test.c, e.g. into xapic_id_test.c and xapic_icr_test.c, and then
this could add xapic_tpr_test.c.  But I haven't looked closely enough at your
patch to make a concrete suggestion (at a glance, it looks like there's not much
overlap with the ICR test, so I'm leaning strongly towards splitting).

