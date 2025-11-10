Return-Path: <kvm+bounces-62527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E96C47B27
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 16:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 36D214F4DDF
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 15:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740B13101C8;
	Mon, 10 Nov 2025 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uHxxPFoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C7B153BD9
	for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 15:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762789485; cv=none; b=h5/Ylx1MpKJZNRLYpXyc62gs2RCJmxOhB0v+qwn+OqjT2PTyWgrUSLyZqDmklx3qTbXdpHScS7MSmXtgZWeZntVMLEVvt73G1X5omuFm2DICiRMN/ww77MHtUcveFRJfOdrJC41ZuYkaNg+tUyaLydsoI9TS2B6z68YSfRuGUM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762789485; c=relaxed/simple;
	bh=bNt2PZljUpkQXyqAV+l9raXMOae2EYPbRP80e8vTOcc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HiSMVHHQdQzcxGyovRzFbQThygxSmy9REC9pdaWV1ZrnHML2Kg02FzQSwwJNJTP6UuN8mPF2HJEAeEQkGuS86yrULly/DdJvthzoDkYbPAr/EmFUnLIFIRaXvTxFCD1M10KGtusf8cLFZfQwo1e7/ouZCOzEm2yxQeiX2aNm7J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uHxxPFoZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34188ba5990so6626654a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Nov 2025 07:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762789483; x=1763394283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PNvF5/12NI7Kmlyo9BOq5gEtZwJ6DGwEfeo3VaDJ+tc=;
        b=uHxxPFoZDfimZl3wKLKhg3Hyn0VZVm52poy2aiwqsZ2VB2jZm1aO7BVW5PjlOfTe/3
         VvGyYTn27OXpuSVzidzvlSzhON1UmDyzrXnXFIhNMJMzrJYKVsc5W/YmG4XR6Wf7Likr
         CVYlOFuPVpFU9akSy1KgULE0ctjrj0VJZ/Lj/HAK0TtKOS81y/JnbxXtTJMT6lYZ0xvx
         QR8VULZv4mBufxUJj6xxuDZMCancS3zEy4ok4OeYnfiKeILwhWDGkInr+Ei6AXs4fjqO
         hx+fjJ1UF7fIkrr8L9lCIxmaOgSzXFK3S7jmvClQ47Sry5t8/Fr0DyG0ta5JvhR7xOfl
         X9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762789483; x=1763394283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PNvF5/12NI7Kmlyo9BOq5gEtZwJ6DGwEfeo3VaDJ+tc=;
        b=PwxzUd/3h0n0UhWkYOuG7WxOCH4WVIH4GHrx06EE2iWrf6juVxgFAfr2iBWdnunEFn
         B+AeXpLXdjujRLjeUznCzDM9vpK0kas/gtzr4n8EtnoopZDXRaN0uFs5j8JGSuFtmNAA
         lGZP04MSiMJjks5Y55VGAzSqJYko47MB97IXqZ3GAKddvGWZ21FtgTz+oatxAZEIcbhU
         BG5v0HaIM8xjnEvKX98no8hs1CTVWI/cmMwo1lhnBbsAJJp8einugi4edZ2UMFVRTt7B
         F+n+LmRmVm9yuM6JQ5tVD6v8cJjQ2QE0SOQZrvEd6AcfNvr37IyNLRLg1j4yrAjkaMnj
         uHeA==
X-Forwarded-Encrypted: i=1; AJvYcCUf6Tn+zGXS9LFDkg29Q4t5NVbMUabZ5xVxow6HJxNGFipBORdG2n03S1fNafeCVpwXJAs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrw54ffFtiWrfOV9EpOfNqHU40PW2QvU224vFd87sBuNS0z6cD
	43hd+xb9KjNbQTOj+a5ZNoWDi9+P3GX1aIxCO5LLK4OlIh3VpcGUwVO7eEqbp6+v03GNz7u72Yo
	A7P3yFA==
X-Google-Smtp-Source: AGHT+IELh7nZC4fHPfancD3LYIl4mtUlqnr7FmYAen6UFOQxRy4XiowaQaog0157dzQxx8WtJhl+aMM0lzQ=
X-Received: from pllt13.prod.google.com ([2002:a17:902:dccd:b0:295:61b:84fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:388b:b0:269:d978:7ec0
 with SMTP id d9443c01a7336-297e56d900emr111842015ad.28.1762789483440; Mon, 10
 Nov 2025 07:44:43 -0800 (PST)
Date: Mon, 10 Nov 2025 07:37:31 -0800
In-Reply-To: <20250820100007.356761-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250820100007.356761-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <176278795912.917009.6888471958480924459.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Fix SPEC_CTRL handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 20 Aug 2025 11:59:54 +0200, Uros Bizjak wrote:
> SPEC_CTRL is an MSR, i.e. a 64-bit value, but the assembly code
> assumes bits 63:32 are always zero. The bug is _currently_ benign
> because neither KVM nor the kernel support setting any of bits 63:32,
> but it's still a bug that needs to be fixed

Applied to kvm-x86 vmx, with a slightly tweaked shortlog+changelog to call out
that only the guest's value is affected (whereas on SVM both guest and host
values are affected).  Thanks!

[1/1] KVM: VMX: Ensure guest's SPEC_CTRL[63:32] is loaded on VM-Enter
      https://github.com/kvm-x86/linux/commit/32ed0bc2f0f8

--
https://github.com/kvm-x86/linux/tree/next

