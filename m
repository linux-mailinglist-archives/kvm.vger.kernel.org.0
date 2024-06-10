Return-Path: <kvm+bounces-19243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1DA390267D
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BD1128A04C
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7D6143728;
	Mon, 10 Jun 2024 16:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3rQAy0Go"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF5681754
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 16:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718036376; cv=none; b=Sd0BkPJwqrFdAJmVgxqQoX0MYDPx7dGgip1ZDt8kbLnDg7E5G6YJI28P0hV3W6/4UyKkwvUYCS3J/IhjOvBcgBHPMaAmVYGqWTmSR7u3MZPl0SB8hY/L3mrf1hLQNtE1BzPHROKHopHbK51pFPCUvF8D0dkuZW6rdS04EMIQWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718036376; c=relaxed/simple;
	bh=nuxTR3CH9P7Y4RDrtApmBEaW6Xc1c9ZyqxUg5eKbxSo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jNMLVxVfa6msHV2kTsDjhkSM/OPwTgtjLR5cVLGNzfGWKe5y95MHDGu5nMa1HYKn8OUovXEyWScO0K7736ayJviMtauHhQR2UKRASAscr0kbkce/twGMaTQcsRhSvDJvECcz7YcMCnIp7ZLRpmxCmW5CP2/POiM12KY4Ggti/ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3rQAy0Go; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7041c30be29so76872b3a.3
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 09:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718036375; x=1718641175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ikH/R8MZ/k5w4tUSKc7WaDfELjNmgc1A9Z/tdHObMgk=;
        b=3rQAy0Go4r8NvsFrNWKIRg0fw4Vw5CNNf9PtYSd0VXh9+h4hVyP6jYDGQiDelnGSQQ
         Cu5Q2HvDzgnfyqO2nd35q0evKHKR0eWvVXmEe+25HH+tfETGpbQ6Pq/l6AX4yCbhFt+u
         kkxnwB55kk9lh7U8inpbzEt+9oKjARBggp1Wy6GY6dVJhovfB8rofEPwTDBm7xc887nI
         fqU2oyKbuAsYQMj3/BXbWQx7ynVEePp4hWORwAL5cW8hYDOnL/vInr5LH8xp+eh3SKJV
         lsTSVJxz+YCqB5i5OOEc0pT4GxxqexPlI5F9QW3fVOregwMv6dbahXIg+yC4E4xkTcT/
         Okcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718036375; x=1718641175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikH/R8MZ/k5w4tUSKc7WaDfELjNmgc1A9Z/tdHObMgk=;
        b=rb8G2SZsW18BQhc/TtvubCCIkhI6HPO7MiwsP0QFtqlcztcCbMxXdn5TT+HTSedTL3
         NWB5wgcpvPgvhzxU0vnbV4TwVsFnLf9naEMiKxbf5m66o+WENR39rMYxUTeRUStUuzo4
         g+UM/LDPCAXBpct+K6fuiWFB7lyIuIeSIS7dZMMYcPdJQqB92kYo+yNFH/gzp90KIqxX
         EP/L38zr5IYWsCLlxdEwvmosjXySZRlpZ0BVr/gZNoO9LruizAVOrNmfZyXvRjSZTFK2
         v9/R233SxU6TkFDkrJUXnr/tpN3HD/Qip9lqgZWO7v5V+YOh4z0xIYn3KvmYEsfO27OD
         Hi2w==
X-Forwarded-Encrypted: i=1; AJvYcCWiePk5bHnqBJA9ENFVxHL8LS7nwNRBY/NCzUtYJDDYm7y7R8anyVaj+hcWdUcow7UZJkGoaiQX5gAnl2UWyl0Cmznr
X-Gm-Message-State: AOJu0YwGWSe1w5IyEDJJrfp+O7t3Qtw5wWN/acvpQ8uWDw844tKi5BlT
	K5aQHoOvLFUx3GqL9WmbbaafG+Nj9eMZ24y+3OScnVyYYum86M35dZqSo+ST5v1AQR3qmhULRju
	S+A==
X-Google-Smtp-Source: AGHT+IELGegd6g36C/J8R9TwAA8ahdxIA5hWoH24f8z3rOR38vK9vW62qn43Fg3GcplWtlU1VBnrOsku5GY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:98b:b0:704:3415:7c5b with SMTP id
 d2e1a72fcca58-70434158199mr66452b3a.3.1718036374323; Mon, 10 Jun 2024
 09:19:34 -0700 (PDT)
Date: Mon, 10 Jun 2024 09:19:32 -0700
In-Reply-To: <20240506101751.3145407-4-foxywang@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506101751.3145407-1-foxywang@tencent.com> <20240506101751.3145407-4-foxywang@tencent.com>
Message-ID: <ZmcnlPcplno-toU4@google.com>
Subject: Re: [v5 3/3] KVM: s390: don't setup dummy routing when KVM_CREATE_IRQCHIP
From: Sean Christopherson <seanjc@google.com>
To: Yi Wang <up2wing@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, wanpengli@tencent.com, 
	foxywang@tencent.com, oliver.upton@linux.dev, maz@kernel.org, 
	anup@brainfault.org, atishp@atishpatra.org, borntraeger@linux.ibm.com, 
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 06, 2024, Yi Wang wrote:
> From: Yi Wang <foxywang@tencent.com>
> 
> As we have setup empty irq routing in kvm_create_vm(), there's
> no need to setup dummy routing when KVM_CREATE_IRQCHIP.
> 
> Signed-off-by: Yi Wang <foxywang@tencent.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5147b943a864..ba7fd39bcbf4 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2998,14 +2998,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		break;
>  	}
>  	case KVM_CREATE_IRQCHIP: {
> -		struct kvm_irq_routing_entry routing;
> -
> -		r = -EINVAL;
> -		if (kvm->arch.use_irqchip) {
> -			/* Set up dummy routing. */
> -			memset(&routing, 0, sizeof(routing));
> -			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
> -		}
> +		r = 0;

This is wrong, KVM_CREATE_IRQCHIP should fail with -EINVAL if kvm->arch.use_irqchip
is false.

There's also a functional change here, though I highly doubt it negatively affects
userspace.  Nothing in s390 prevents invoking KVM_CREATE_IRQCHIP after
KVM_SET_GSI_ROUTING, so userspace could very theoretically use KVM_CREATE_IRQCHIP
to reset to empty IRQ routing.

Christian, if it works for you, I'll massage it to this when applying.

--
From: Yi Wang <foxywang@tencent.com>
Date: Mon, 6 May 2024 18:17:51 +0800
Subject: [PATCH] KVM: s390: Don't re-setup dummy routing when
 KVM_CREATE_IRQCHIP

Now that KVM sets up empty irq routing in kvm_create_vm(), there's
no need to setup dummy routing when KVM_CREATE_IRQCHIP.

Note, userspace could very theoretically use KVM_CREATE_IRQCHIP after
KVM_SET_GSI_ROUTING to reset to empty IRQ routing, but it's extremely
unlikely any VMM does that, e.g. the main reason s390 does anything for
KVM_CREATE_IRQCHIP is to that s390 doesn't need to be special cased by the
VMM.

Signed-off-by: Yi Wang <foxywang@tencent.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20240506101751.3145407-4-foxywang@tencent.com
[sean: keep use_irqchip check, call out KVM_SET_GSI_ROUTING impact]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/s390/kvm/kvm-s390.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 82e9631cd9ef..4641083ee100 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2996,14 +2996,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		break;
 	}
 	case KVM_CREATE_IRQCHIP: {
-		struct kvm_irq_routing_entry routing;
-
 		r = -EINVAL;
-		if (kvm->arch.use_irqchip) {
-			/* Set up dummy routing. */
-			memset(&routing, 0, sizeof(routing));
-			r = kvm_set_irq_routing(kvm, &routing, 0, 0);
-		}
+		if (kvm->arch.use_irqchip)
+			r = 0;
 		break;
 	}
 	case KVM_SET_DEVICE_ATTR: {

base-commit: 9a859becf1b7f6879466e8c0ebee492b236f2080
-- 

