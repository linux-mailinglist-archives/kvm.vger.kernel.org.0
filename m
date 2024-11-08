Return-Path: <kvm+bounces-31315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0349C24FF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4FE82846C8
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 18:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E631A9B49;
	Fri,  8 Nov 2024 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xRleWoVd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4671A9B3E
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 18:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731091469; cv=none; b=t+iByxkaM87UtuQiBhwxvSzz/IVehbnolA8xieZqtbW9jSI/YsNVlxxEUTqCkT9bAX9VtyICuhAh7fykpWVxymvSxP1M8qKw7y8ouG5eAWtytge8/YBxjGH7v9MwFhJY6X2+AB//2vSOpCY1MWFw4/RGHbM3s1nRJHGeDJKRYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731091469; c=relaxed/simple;
	bh=xJjap7sNY/81/oXWIYKmLfhopGKwOX3mvVuYtwhXGds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q00Kl8UjbprynJ7leEWTlflvpnbF+xoUPKHg9yepLGGO0R964LjSD6eIUinZbNFxEurS4sdsrDzKGic7CX5zDmnWyyKWfh545B7TjrtV3JdtQjV3GT5U9y+DTPXRMoqpIk2lSEtujSQKmd4JTHfw+uQ3C/i/bGoeM5dMSDwDOkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xRleWoVd; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea69eeb659so2167102a12.0
        for <kvm@vger.kernel.org>; Fri, 08 Nov 2024 10:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731091468; x=1731696268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WoOm9ACkx5SWCzD3BiI5DqC4avsoAgUOaWIdVW9u+Rc=;
        b=xRleWoVdjCMDnSrolcmD1snIBmFyhwXW0ZzKyCP+LxdBWtPP/GvpzbLAEI3rasHT26
         586y6KTl9+lMcnShpqx+PCBMMfDHid9kV64iFrZpQO+P08gZnTiUq8Nx7hL2XVLWxMfg
         5WI8ZRU19c3d7BUhs+XReK89KcfEKOFYc/UuGm4JgH8gbfq0yhGmOTBUSeBJQjVwr9Wf
         c575pjgKjzG/4PsvrWCrxf9ukpgokgMZLeTPNbOrDKPbkEJy810nK6NwPWqooztamwCX
         jpui46XVYFUJJYtOQeFhtCWV8CCDbAAX/DoqbbSJUgA4PYlJ3GZYpA6jm+WpRZ7QrEDC
         p6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731091468; x=1731696268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoOm9ACkx5SWCzD3BiI5DqC4avsoAgUOaWIdVW9u+Rc=;
        b=stP4pfpFqpP1IJl15yvkuo6/A7FeWr/X9+G2ox1Jtvz5pEmLuzfQEtI5OHCQW0My/H
         JMo53zhbIxs8Z3+ZfqFLsjxB0JCu8PefdgfHyAk3pg9o6ySfrIXVuFUOt4XlBJipXBGO
         KFTbQT9FZXk8q4Qa2J8LKH3hkqm5LmpHgAAb1pTruxL2kWEpsHgMXxu5PSawFxop2qm8
         Hc2bRyJ1SVxlQVx0Tj/iG+vHOoAoegGXVMMCYzbgBaqU1iW5Yn3FooVvPmHLUgazW+ah
         8V2ii4mFKZLT9jsAVG2CfBrqDeg4f30XijWSYgn5Aks7U8npSj5y4+0pIZgPHUxhI+TN
         vlqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVNIs11dIyBUONXhJZHjr0sdHZlk9phwjLrFmqVF+uKECinoMSkFdzi3gh2HH+bX5d09I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGN586HDNLElJU9U8lI4cF/XjMcKuwvJjpVbXVpLA0vAdfftla
	TCxywEMycPQcJMu+Ts1SKNgCEs+if9ukyoVoBclalzDFFq9JQ0ZfyV3lHC7IBfU4XgkdfE4yiGC
	Jkw==
X-Google-Smtp-Source: AGHT+IFVEg3hBrHUvpQAXsewTrpUVfh6ZcizLr1BwBeaZYtb+taySoJXMd2e7OomEttUBjSKQhB3qW+zBz8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c41:b0:2e2:c183:8b1c with SMTP id
 98e67ed59e1d1-2e9b168bfcbmr21938a91.7.1731091467897; Fri, 08 Nov 2024
 10:44:27 -0800 (PST)
Date: Fri, 8 Nov 2024 10:44:26 -0800
In-Reply-To: <20241108171304.377047-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241108161312.28365-1-jgross@suse.com> <20241108171304.377047-1-pbonzini@redhat.com>
Message-ID: <Zy5b06JNYZFi871K@google.com>
Subject: Re: [PATCH] KVM/x86: don't use a literal 1 instead of RET_PF_RETRY
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org, x86@kernel.org, 
	kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 08, 2024, Paolo Bonzini wrote:
> Queued, thanks.

Noooo!  Can you un-queue?

The return from kvm_mmu_page_fault() is NOT RET_PF_xxx, it's KVM outer 0/1/-errno.
I.e. '1' is saying "resume the guest", it has *nothing* to do with RET_PF_RETRY.
E.g. that path also handles RET_PF_FIXED, RET_PF_SPURIOUS, etc.

