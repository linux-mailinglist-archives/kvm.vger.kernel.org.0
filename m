Return-Path: <kvm+bounces-48299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E2CACC7B7
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D39AC1741DE
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 13:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E00231A32;
	Tue,  3 Jun 2025 13:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bZRTT9Vy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68985A937
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 13:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748957215; cv=none; b=gzYNtyf1phvr78owxWZtild97B+nxAPvUJKTm78Uc+G7ZheaRzyyi7dJLOuIdnYVQmEPO7BXvJO2qPioA5VXkd84lDSC59FOWAX9d4rHvWXVLtfeQxkz1v7PqWpWKF5LA6WUJg5QXVn2njFL1W0zvMl92VnLTjuaFpaQlKm874A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748957215; c=relaxed/simple;
	bh=L7+qtgykgPi3lroglO8RwZIW+N2GCF2llGYrBQ0oYU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I06KmGTW+oJVqX9yNNoIZhVO45ESGmdWqxDZK+xhff4Wy9hjhsdhptuK+YiPko+ZfLLbSvKu7snOeKZcH5IAUgifgnZ4PUY5F6T7D67DH5E309hGt0HGRVvVH7QPzlQmIgJUKyRubChMjSH0b9srpV2cH6mYvlZ0TEXeuhVg9+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bZRTT9Vy; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7398d70abbfso7975906b3a.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 06:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748957213; x=1749562013; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BEXJHtjU9V+ltSdQUZb8ZRixRuCJWu7iAmqz2qP5bA=;
        b=bZRTT9VyNS5GOAu5dKxNgweEqHqrjrxNvdKa92aHhEuIlMwIgDw+wyTmDF6Dm91gtN
         K7pu79f59edwUgdzPOKvdy2O12XcHo0Hi9SAKn4IPmh/+WqdQapbKfJrJEAxE01ogzYb
         hD7GfMUOrsBYba0nxt8USynWQWBJE7VTuDgG1qnQVHXvKPEfz2AR+F4sOFMj3GLYVEQy
         7vNngqQQnWoQ+P4PBTBVY0LDQeUKJKgo9wG6u7/6xeVWOsjv4g7BXYVsnkwabYTg/JQI
         49X2xPUKmuJUX4/C9+xpPPhpxsHQfREDiOkpm1JbVVfUWz3E6PMdfE0TYm1S6Lb1fxX5
         PAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748957213; x=1749562013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6BEXJHtjU9V+ltSdQUZb8ZRixRuCJWu7iAmqz2qP5bA=;
        b=tCIPnDlaYdJWkPngC1UawhHupHZmRaY3DFG6yltRkBB+G1nuIPolw6vbH8voavZC/X
         l0Jt1JJRDH3T/7jjkTFqVyc8aCY9DNkDjGo/OCp0PkLi5GG5CBnjuqtUUSKOryyeZ71B
         UGdteiCNCS5bjY+Am4qVhCVj0uhK+tX5GgcZA6KnuL7JEYxviVQUb3vJ8KlgwF2navLR
         ia2//DMc9LXZbimQJbEq7HFfHHIoC1r3xMKl5bYRstpmjc4X2bB7KTK4uVUqDmu02fF7
         CbkOAi/n7yw/mxVrXAs7/pLG5x4mZXWoMMyvODGEIJ2QBfJYO1v9ihHKUQFqCTXzKhO4
         tHpw==
X-Forwarded-Encrypted: i=1; AJvYcCUY2aruOJ2bneStj+WShL7Uw1/MFw3ILGL8cnflngEpG9MAJx9U1cYpyElxYEGZClbqq2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvatAYM6Rr8A+4cnOSZqSWKl7FpeeD0e22KTfbQbFnuYylcppo
	otBn/5YW+wvMhC/eboItfQWLh0p3Kq9NlJry+hidl3mD9A8Z0JmGhsiLX+f8FW3njqBhiE4iEO9
	p5WOXDA==
X-Google-Smtp-Source: AGHT+IGaWOJYzlEyg0eyG1P05zKPEo0H8ydP/NrBdiTTYiphzAFMaccGUkuQON6CduTUYVcs2AW60bOD4f8=
X-Received: from pfvo25.prod.google.com ([2002:a05:6a00:1b59:b0:746:1931:952a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3418:b0:215:e60b:3bd3
 with SMTP id adf61e73a8af0-21ad9799478mr26954618637.29.1748957213638; Tue, 03
 Jun 2025 06:26:53 -0700 (PDT)
Date: Tue, 3 Jun 2025 06:26:51 -0700
In-Reply-To: <aD6tFSu5dvEQs8dJ@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529234013.3826933-1-seanjc@google.com> <20250529234013.3826933-5-seanjc@google.com>
 <aD6tFSu5dvEQs8dJ@intel.com>
Message-ID: <aD74GyZmU4Z0dMn1@google.com>
Subject: Re: [PATCH 04/28] KVM: SVM: Kill the VM instead of the host if MSR
 interception is buggy
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 03, 2025, Chao Gao wrote:
> On Thu, May 29, 2025 at 04:39:49PM -0700, Sean Christopherson wrote:
> >WARN and kill the VM instead of panicking the host if KVM attempts to set
> >or query MSR interception for an unsupported MSR.  Accessing the MSR
> >interception bitmaps only meaningfully affects post-VMRUN behavior, and
> >KVM_BUG_ON() is guaranteed to prevent the current vCPU from doing VMRUN,
> >i.e. there is no need to panic the entire host.
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> >---
> > arch/x86/kvm/svm/svm.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> >index 36a99b87a47f..d5d11cb0c987 100644
> >--- a/arch/x86/kvm/svm/svm.c
> >+++ b/arch/x86/kvm/svm/svm.c
> >@@ -827,7 +827,8 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
> > 	bit_write = 2 * (msr & 0x0f) + 1;
> > 	tmp       = msrpm[offset];
> 
> not an issue with this patch. but shouldn't the offset be checked against
> MSR_INVALID before being used to index msrpm[]?

Oof, yes.  To some extent, it _is_ a problem with this patch, because using
KVM_BUG_ON() makes the OOB access less fatal.  Though it's just a load, and code
that should be unreachable, but still worth cleaning up.

Anyways, I'll place the KVM_BUG_ON()s in the right location as part of this patch.

Thanks!

