Return-Path: <kvm+bounces-45258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3570AA7B8B
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 23:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC0AD1C01FB3
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 21:51:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72D12116FE;
	Fri,  2 May 2025 21:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YOGsvt10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F6320D50B
	for <kvm@vger.kernel.org>; Fri,  2 May 2025 21:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746222665; cv=none; b=LA2jJ685dIJABH7nqkjHbGpJzgSIXNMK5BuuNKF0nYdcz3WLSxPI6EjtCUjJ/U3sqaAL3ALhREnRbg+XI8NylmF41P1NESXlVsQpRz9sLn56kxqDNsuKnagEU8SBIQO91EbyfvcYMyvM0y/AUTyq0OQJAVa436XZ5yQZ7CmKj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746222665; c=relaxed/simple;
	bh=E6M0IvoLmXk8zvn7QAi4bJE+3u5ywWMaqGMb1cp3f4A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pP3vCkcrfQ06/7eWRCGKiFJryQHm6X7iqSScwGJxDm9pvGSb+ytKjwkqVIbWLRLAc9j5UWWjkMQ+kKkCvBhnel5GPKV0PwFbeHpBo+jRQBrpXUXi52JiN0H1MtvA/+WtJF5nMubLM4RUdW/uaF393O7uLe82Y68bwfCpPy0oi+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YOGsvt10; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3032ea03448so2555849a91.2
        for <kvm@vger.kernel.org>; Fri, 02 May 2025 14:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746222663; x=1746827463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=L5S6kzWyRg3t7ibhxxMYEu25/92uJhpv9EtUoQxKeGk=;
        b=YOGsvt10ihETK7UkeflFAgQFbqAlZJETITu9Ap06+rkxIivojked0at2FmuXBZwx25
         YjLl9oQepJQmAZXPfwZ5zMZK251pUE8IA9rpGS8oLIx1u7Gha4jiUVthjULowISCA3vx
         uw1llKQqrM+oHf7cNk8TTufI/NYJ+pxdddofmrg9Ejac9KXhey8zoQEjLlOPix8hW2O5
         iJFPtvOHgM0Jqsh3CqdiQnLE06qFhcM7seaUR2+3u1NSZdd1KX0g9giKhW4KND+5i6sg
         AvXP/Yqp1PIOJVCyJkyyxRhdL+FgvPCEIZKr5Pus6mmHO9LKri32SU0doWUYpStzk/q3
         MxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746222663; x=1746827463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L5S6kzWyRg3t7ibhxxMYEu25/92uJhpv9EtUoQxKeGk=;
        b=ODD+HcVf1BnvsdKfLVuCUOVwmRh7w2RyS48PSABNd55JgKHGjrUSIzLT03MQdo2pt/
         ptxrEie7+ReqzQAi2OWewQPnZo99rNvJpnZwYQOUiszzcDBlX29Uhe89d96rbdLHZzqv
         Jlm1DoE3d5izKVMoh9X8zKe+mN7bxnGTpUkv7JrI/+/ZGlizyCzXgfRh47nSEcgXpcJ5
         bGewOhd0zRxZ2PkC8jRWiwWmeLMAt9rWPJrikRD4YdZzfKtKQJakURCW/FMKj9/eXH3F
         1cSAOfuuyhZMxCarrLLeUlO85UUtw8iBmFBqE4oVFeOjmqeMzG816eGL45EDOCyq9glx
         5b+A==
X-Gm-Message-State: AOJu0YyK/udl1qt+Xo+Xk+hyP5C5JfKnjBZfNqRARt/RmfcFxEFJMV9l
	Mams6e4tnQR2py5oe0kU+ckEcMqYU2cnQ+OgkNwaVDwedHB9uai+YUYebqdRfLQgbXWZYyPY/kW
	Srg==
X-Google-Smtp-Source: AGHT+IEqmM5AJyCRJVxSDwYAUvBgTR1EcndjlzikTaOt866pVxcotcKieikdc2dTfpexkvGIF4+QSAcOhiI=
X-Received: from pjbqn8.prod.google.com ([2002:a17:90b:3d48:b0:2ef:d283:5089])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5250:b0:301:a0e9:66f
 with SMTP id 98e67ed59e1d1-30a4e5b2c34mr8131657a91.14.1746222662809; Fri, 02
 May 2025 14:51:02 -0700 (PDT)
Date: Fri,  2 May 2025 14:50:49 -0700
In-Reply-To: <20250430220954.522672-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430220954.522672-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.906.g1f30a19c02-goog
Message-ID: <174622206428.880669.10703752422020171252.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Prevent installing hugepages when mem
 attributes are changing
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 30 Apr 2025 15:09:54 -0700, Sean Christopherson wrote:
> When changing memory attributes on a subset of a potential hugepage, add
> the hugepage to the invalidation range tracking to prevent installing a
> hugepage until the attributes are fully updated.  Like the actual hugepage
> tracking updates in kvm_arch_post_set_memory_attributes(), process only
> the head and tail pages, as any potential hugepages that are entirely
> covered by the range will already be tracked.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing
      https://github.com/kvm-x86/linux/commit/9129633d568e

--
https://github.com/kvm-x86/linux/tree/next

