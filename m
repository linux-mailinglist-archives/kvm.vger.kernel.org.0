Return-Path: <kvm+bounces-19374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B05390483D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:19:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02371285A8A
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59C875CB0;
	Wed, 12 Jun 2024 01:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sLztlY4b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB83AD35
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155156; cv=none; b=NL7b8qfosyq7p5NlqQnq4vWim0ZdJRSA5GoWcbSlgC7iO+iQS6azQD90N3oLQSt/5J1fJ0jQDUVR+FE3nhOe/+y5OqwJahXgsJKGf916pFmvfJuRCUTF9krfjSaMi6bpDszdrBY7v3//koiphlyHziDDgIEkcMb+wnGK+a5LWiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155156; c=relaxed/simple;
	bh=j74mLBolZka09Rl/k9datpc7l1Az7Efas1c/FiOj2lM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=pczTlgR4y6v8f6UMhpMQpBXy5e88S5YrP4++7liDqlw2qjUcJyFqHhGaTtXqbO3nFjfcCKO8zjgZnmdYjC45KJ0Do9NOalpQDucsTDRS4aSBfoGzPVEKa+u5K5uYdtu4k8gzyr7oOGSSNkO0k6HM+4p8ev7Ie/uY2xuOZ3hdZSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sLztlY4b; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6e35e34f9b7so264569a12.0
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155154; x=1718759954; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OycshDtHbSNfjOhpYEd5FzYSc4S1OTDwcYjhFujY3Cw=;
        b=sLztlY4b8/7i4M9O202QyopnKD3NDCojXeitOZaauOPZgvs3Na/bjKmxg+rWss1dLi
         /SWzT4uxGrnNF2kXq2shGD8pPJsaSP7Er3rQVBQUcSLZbz9rNg5kpPd0CDNlOTcT8bsL
         VVH/0A/WNMoYHchc1oI+kXZP6mOFgafu7Nah/XUAjQGrr/ncpTySBohoFgQuSuRFnRn4
         RSrI41nIugDEGOUH/YmpMPIuAYpU50CNe1UxlcY/ZmOIJ6WGqxVeG1N17XT7V8WcbsD7
         OrVI5d5FkK2zY3ChwqkaGdIRoiAu8ksDM9gvs2N6apgpEMn5eN55I1aP5FsXWtAW2p4t
         uA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155154; x=1718759954;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OycshDtHbSNfjOhpYEd5FzYSc4S1OTDwcYjhFujY3Cw=;
        b=eaJqtVjwdNVf2VNyVpXNE7i5nlUvWues4MLRt8LyQJq+pBM+KvFHrJjNiZMYUZXGmL
         fEJtzaGEBXhQId4l21G2Pn9PLy3JUYVpOL+O4ygbqeMVKIYws3EjN63gUd1FPDoty55p
         HUPQXyDst/FiDq27c8KAFNOvBVbAyF37wmeL2mOpA3T1DMYVMlq25v90wFPCu4YUaEUA
         6cd32lP9YiKwfaCdai8x+mlye3heHoZ98J87iGffIav/9AUqSvK7yAeHYzdGEV3SmECk
         KwidzKTvuOROO0vVKwnumk4Z6m0i06ifnc+Y5shKsVsIhXLZaVFvf+XJUM7z32TZY2td
         WAWg==
X-Forwarded-Encrypted: i=1; AJvYcCUnbv5T26TwkowCjIWPe/6mUGF8iCOxUOFu5VA8dFlB9O4neWhxvPANvExW9aJfwZTGvgrdbrNiloOgeEb4GJ402R1i
X-Gm-Message-State: AOJu0YzqX1Byj0ZRgB+e5lROE6XaTcKaQlEygg9dpoOD4+ziQ6S9qu6N
	rKRNqtjKevaBNIS6Av8wUbylBMrCFvaZgIaeUehku7eOR6eUaeAlPbw1dhIwTdDtSEtjl/1rg/I
	Kmg==
X-Google-Smtp-Source: AGHT+IGTOVJWoC/IZGpdHTWIQr0wyCI+DQgy7TWj2KigyMYTW0aE5HL9Fv+uFkjZTnUvUlYtk2sdSu0OJzQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3c4:b0:2c2:f2f8:a997 with SMTP id
 98e67ed59e1d1-2c32b466c91mr43869a91.1.1718155154238; Tue, 11 Jun 2024
 18:19:14 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:29 -0700
In-Reply-To: <20240506101751.3145407-1-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506101751.3145407-1-foxywang@tencent.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171803642381.3355478.4236692282060742412.b4-ty@google.com>
Subject: Re: [v5 0/3] KVM: irqchip: synchronize srcu only if needed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	wanpengli@tencent.com, foxywang@tencent.com, oliver.upton@linux.dev, 
	maz@kernel.org, anup@brainfault.org, atishp@atishpatra.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	weijiang.yang@intel.com, Yi Wang <up2wing@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 06 May 2024 18:17:48 +0800, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> We found that it may cost more than 20 milliseconds very accidentally
> to enable cap of KVM_CAP_SPLIT_IRQCHIP on a host which has many vms
> already.
> 
> The reason is that when vmm(qemu/CloudHypervisor) invokes
> KVM_CAP_SPLIT_IRQCHIP kvm will call synchronize_srcu_expedited() and
> might_sleep and kworker of srcu may cost some delay during this period.
> One way makes sence is setup empty irq routing when creating vm and
> so that x86/s390 don't need to setup empty/dummy irq routing.
> 
> [...]

Applied to kvm-x86 generic, with a lot of fixup.  A sanity check on the end
result would be much appreciated.  Thanks!

[1/3] KVM: Setup empty IRQ routing when creating a VM
      https://github.com/kvm-x86/linux/commit/fbe4a7e881d4
[2/3] KVM: x86: Don't re-setup empty IRQ routing when KVM_CAP_SPLIT_IRQCHIP
      https://github.com/kvm-x86/linux/commit/e3c89f5dd11d
[3/3] KVM: s390: Don't re-setup dummy routing when KVM_CREATE_IRQCHIP
      https://github.com/kvm-x86/linux/commit/c4201bd24f4a

--
https://github.com/kvm-x86/linux/tree/next

