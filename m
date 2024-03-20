Return-Path: <kvm+bounces-12306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D66688129B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 14:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37E321F250C2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 13:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529B64642B;
	Wed, 20 Mar 2024 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSRll396"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAD04594B;
	Wed, 20 Mar 2024 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710942219; cv=none; b=IDfYIN0i4JAmB+wKFGA/ke0Pp7sNm3dkiZ0/9/iqSp9x5of4roFO419HvHLIWW5AdT2rD48vh1qEJ+jk3fllsVXmv61EYHEJMJA0ijU/5UfLcaClCG9bqmJQZ2e+NYf5oXEgqpJATd0cZHoOztB4DX6hM67NBk6YFjkl3DMDhVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710942219; c=relaxed/simple;
	bh=wSDEutJwD2neE7aKCvDQfy1pKH5nxR8yhjkWrLLNsBQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=pNnmL36CHbgABw86k0eyaDtu+BEHaam3k2aPekROZRSqkd/8qFZJ0gYNfMmrtANkrg66tAYEle0qKcmgZlN7nsq2yZ5QXxDDi0pZRkQ7CoTPhVsM27Tfhy2yXFxAARPgaqXUz9X5uSqgudbZb55rwRBbjvn4uj/Ag29q2dxrSrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSRll396; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5d8b887bb0cso5142408a12.2;
        Wed, 20 Mar 2024 06:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710942217; x=1711547017; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkcxNUYVeIsC5l1PCS55LiuRgLN92XEeA7AcFx54cFI=;
        b=GSRll3966gDYZ49S4StZaV/M5IIJhH6Wo3Fu7DvmqJUFdyd6qxsdDHE2B5haBDHHpU
         ljzy2bcYstO1yKhflZJ9kkIbKS6Tso2SoOJv185GYWWNao1m+lsIh61GIRTqXbkYtMLh
         n5UyZC0efuoxmaWMniJYydriCTRqTHljm+uFjRIzCoFEVXtjRxApD3wGQT/Ym6k8iOA6
         0f3K83vxKpkMMxAnQeSgFFk1AVHE1R/yK3Bo27f/2syOTqtsaS1wSJ6WcHta62JwnKpL
         nolZ+Dpb4fwOXbvKGActI3hIe1VkIkp24nYHS3JBB1U6QoDw4vFS27gEVGWj+NwDOOdO
         cDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710942217; x=1711547017;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UkcxNUYVeIsC5l1PCS55LiuRgLN92XEeA7AcFx54cFI=;
        b=lY2zKJNXBRKpYXZQA1OynfqFl+/26J4w7S9C/Xv8ZAuGmThxcQVE4gvoGJn8RFpCnd
         fsu8OQ7f/sgGIwkVvK1ld/rlD53zoQOBiPijcbRllV//BFQKseOWUsMwDGFyR3uee6gV
         oDEW/0BUX1gX8ZzYtey+Tun6QcvIJZ5XtcdB1gbO/kaSs7+ZUPlekKzajSm31VumBlZP
         Nf67d5pOwUtpubIGTR6UmiE9A2cR05skQVsmUpvD+mVFnQg46XBlCvxVXWm62f1jf6Eb
         8elt6XqMUF3nE82+xnNhiE7n/keSX/lXm8ZRDAu2qPfOZkd6q5wQz9bXiw3i3WpkwwAy
         fGDw==
X-Forwarded-Encrypted: i=1; AJvYcCUY7N2FmDGAim3LIkA3hE7e4SdQqPfwqQDK+yL4t0+h6b4vKPCRVz7IfVdtjXWa4XjSR2oLJ06eNOymiueg6brWXWTGhsqUXHG4P4fsBlnWos86WNVeXhinv6oetQ==
X-Gm-Message-State: AOJu0YyK5+uHKrPudH4zujEz3rQVbH4/kKNBlKgdJdeT/j1fdEbQcLto
	bQcTebqRsy86t5wqCGJ7utaWgz30ypAB81CLaicMK8wzeKO51TqH
X-Google-Smtp-Source: AGHT+IFW67cPx23ALjOO6pVU1+yxckmTH3qtP1K1gSVYZcIrRRBY4tUMK7k8CT+nxZbQGRKfJtAGRQ==
X-Received: by 2002:a17:90a:a78a:b0:29b:af61:fb34 with SMTP id f10-20020a17090aa78a00b0029baf61fb34mr6607716pjq.34.1710942217140;
        Wed, 20 Mar 2024 06:43:37 -0700 (PDT)
Received: from localhost (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id fy16-20020a17090b021000b0029fc7a754c7sm1588113pjb.25.2024.03.20.06.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 06:43:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Mar 2024 23:43:28 +1000
Message-Id: <CZYME80BW9P7.3SC4GLHWCDQ9K@wheely>
Subject: Re: [PATCH] KVM: PPC: Book3S HV nestedv2: Cancel pending HDEC
 exception
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Vaibhav Jain" <vaibhav@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>
Cc: "Michael Ellerman" <mpe@ellerman.id.au>, "Jordan Niethe"
 <jniethe5@gmail.com>, "Vaidyanathan Srinivasan"
 <svaidy@linux.vnet.ibm.com>, <mikey@neuling.org>, <paulus@ozlabs.org>,
 <sbhat@linux.ibm.com>, <gautam@linux.ibm.com>,
 <kconsul@linux.vnet.ibm.com>, <amachhiw@linux.vnet.ibm.com>,
 <David.Laight@ACULAB.COM>
X-Mailer: aerc 0.15.2
References: <20240313072625.76804-1-vaibhav@linux.ibm.com>
In-Reply-To: <20240313072625.76804-1-vaibhav@linux.ibm.com>

On Wed Mar 13, 2024 at 5:26 PM AEST, Vaibhav Jain wrote:
> This reverts commit 180c6b072bf360b686e53d893d8dcf7dbbaec6bb ("KVM: PPC:
> Book3S HV nestedv2: Do not cancel pending decrementer exception") which
> prevented cancelling a pending HDEC exception for nestedv2 KVM guests. It
> was done to avoid overhead of a H_GUEST_GET_STATE hcall to read the 'HDEC
> expiry TB' register which was higher compared to handling extra decrement=
er
> exceptions.
>
> This overhead of reading 'HDEC expiry TB' register has been mitigated
> recently by the L0 hypervisor(PowerVM) by putting the value of this
> register in L2 guest-state output buffer on trap to L1. From there the
> value of this register is cached, made available in kvmhv_run_single_vcpu=
()
> to compare it against host(L1) timebase and cancel the pending hypervisor
> decrementer exception if needed.

Ah, I figured out the problem here. Guest entry never clears the
queued dec, because it's level triggered on the DEC MSB so it
doesn't go away when it's delivered. So upstream code is indeed
buggy and I think I take the blame for suggesting this nestedv2
workaround.

I actually don't think that is necessary though, we could treat it
like other interrupts.  I think that would solve the problem without
having to test dec here.

I am wondering though, what workload slows down that this patch
was needed in the first place. We'd only get here after a cede
returns, then we'd dequeue the dec and stop having to GET_STATE
it here.

Thanks,
Nick

>
> Fixes: 180c6b072bf3 ("KVM: PPC: Book3S HV nestedv2: Do not cancel pending=
 decrementer exception")
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 0b921704da45..e47b954ce266 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4856,7 +4856,7 @@ int kvmhv_run_single_vcpu(struct kvm_vcpu *vcpu, u6=
4 time_limit,
>  	 * entering a nested guest in which case the decrementer is now owned
>  	 * by L2 and the L1 decrementer is provided in hdec_expires
>  	 */
> -	if (!kvmhv_is_nestedv2() && kvmppc_core_pending_dec(vcpu) &&
> +	if (kvmppc_core_pending_dec(vcpu) &&
>  			((tb < kvmppc_dec_expires_host_tb(vcpu)) ||
>  			 (trap =3D=3D BOOK3S_INTERRUPT_SYSCALL &&
>  			  kvmppc_get_gpr(vcpu, 3) =3D=3D H_ENTER_NESTED)))


