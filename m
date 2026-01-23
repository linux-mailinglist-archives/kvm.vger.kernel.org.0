Return-Path: <kvm+bounces-69009-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDfoNfCuc2nOxwAAu9opvQ
	(envelope-from <kvm+bounces-69009-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:25:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79DEA78FB5
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 18:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B76B3066BC2
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 17:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D462F3C30;
	Fri, 23 Jan 2026 17:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NgY/2hD0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A69285CBA
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 17:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769189061; cv=none; b=YBj7MHPIf+J+GJcR2/IXfcICSx1HdRHt1nRKqLKF5NwMQFPPu5wKQCipgl5/LNQM+wnNXx2bNsFFbyzmQFJk3lrDCfCanWiVxmK253NN9CSFyzsPE0HV4kiNdDFM87vDOGL6sbmMN4qXznTr2haUau1RpDnByceESpM/+Icmnzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769189061; c=relaxed/simple;
	bh=yZATZytNo47ricvgK6c9sWNeQLnWnfdmL3utQvOTqyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WAUVV9GJI0Fk94ydjQXeA+A+2hn+ANHnISBpGY/R1xwYA90P2N+WMWbS04AGHXlilUz8R/Sh5gUw1czmmdvcIAXFz4pmn3eHAtS6RMcJly8YPHKitKTY3XGlxolV9gt2zJ+KtG1g4YoWqY2IJxLu1mPAJ2gHa0cAfRli4WZsPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NgY/2hD0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a773db3803so23626475ad.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 09:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769189059; x=1769793859; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nacqI7AX7aLDmv3ApWbp8k0PEjJITHgicOysDhXmb94=;
        b=NgY/2hD0ZTHJCcQtCun4r/q83sjEUFIPdULwNVxr30FrwLSFoa9olagAtKKmX3H0LO
         U1vLTKv5AX2SgaN4XawVMXXvv/6Kf3xXGgzly5RmVaiEbAcxDaWIex9Vt2p51DtpohQ3
         +gGMIWoCcK7ME9juxflCxK0gugzkNyIDHZCeS0yCbOpkw6xHwSZXwKSF9qWryzdu3AvL
         IveCI07WBFjDTou/R8d67wTtXyNA1MPMEhMt/3UW7Kk6BbPPWxrMdUh4q86xg7oKh/Qw
         /23mMA6ZZ6usetS7gzpdocewzCKfCW8vRxnxL3dj/XW6if8tjo5bSPlZOLCnHdNE3iQI
         +iBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769189059; x=1769793859;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nacqI7AX7aLDmv3ApWbp8k0PEjJITHgicOysDhXmb94=;
        b=ZXnJgCFF7YOOPR+v+s2Mg57s4QfbTjsju+18J3oxAzF5zmTJ3pnXdAwNd3PWLa3fPS
         2jjrtJe/5QtqLLUafSVoQWyu1zm4txwRXKrKU082NC8rq69QV33bWTV+2h0oExWagGX+
         YY78cwN3aeRmTU6q+A9nkS53wGNJe/x//uE7RFtjZC4GqFExH6CvmDwm8gTVK8pyjrEq
         Wa8g3EGVYxeoyXNpbdhmBjxUQnoeZCxEMSgZbqya7QuJvkrz4DRpkpA4pUUnzKGvu7CC
         NASLO0tPVO/jY3Vosk0Nb1K2iZ5qZkXjhUDorCNGt0N8XFNzw4MXleZuwOLfj/CMNbe6
         Uy7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUmZ3WOABvp/WjR7jVR6Q2RjNlW5tp6ydqyA1JWwO6LoFKeQ9mm5qaRwwpPvHqpwTrfDTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQI9crZTbNnDB2dWe23te+4HoyuyVW3V7/v0Q2kXAbDDC6s3f1
	VKyzvK3kSIt0B40xR8W9cdoWNHP37KQ8W8gZxpBi/F/3EWm7Gv4ZxCYbtcFB/tFVoqIqp9uGfUe
	bD2pVIw==
X-Received: from plbkx11.prod.google.com ([2002:a17:902:f94b:b0:2a0:d5bf:714e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d591:b0:2a0:d629:903c
 with SMTP id d9443c01a7336-2a7fe626c48mr39334405ad.30.1769189059297; Fri, 23
 Jan 2026 09:24:19 -0800 (PST)
Date: Fri, 23 Jan 2026 09:24:17 -0800
In-Reply-To: <20260116151523.291892-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260116151523.291892-1-kovalev@altlinux.org>
Message-ID: <aXOuwWI3WcvT6Ccb@google.com>
Subject: Re: [PATCH] KVM: x86: Add SRCU protection for KVM_GET_SREGS2
From: Sean Christopherson <seanjc@google.com>
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69009-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 79DEA78FB5
X-Rspamd-Action: no action

On Fri, Jan 16, 2026, Vasiliy Kovalev wrote:
> ---
> Note 1: commit 85e5ba83c016 ("KVM: x86: Do all post-set CPUID processing
> during vCPU creation") in v6.14+ reduces the likelihood of hitting this
> path by ensuring proper MMU initialization, but does not eliminate the
> requirement for SRCU protection when accessing guest memory.
> 
> Note 2: KVM_SET_SREGS2 is not modified because __set_sregs_common()
> already acquires SRCU when update_pdptrs=true, which covers the case
> when PDPTRs must be loaded from guest memory.

On the topic of the update_pdptrs behavior, what if we scope the fix to precisely
reading the PDPTRs?  Not for performance reasons, but for documentation purposes,
e.g. so that future readers don't look at __get_sregs() and wonder why that call
isn't wrapped with SRCU protection.

I.e.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e013392fe20c..a5a65dde89c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12145,9 +12145,11 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
                return;
 
        if (is_pae_paging(vcpu)) {
+               kvm_vcpu_srcu_read_lock(vcpu);
                for (i = 0 ; i < 4 ; i++)
                        sregs2->pdptrs[i] = kvm_pdptr_read(vcpu, i);
                sregs2->flags |= KVM_SREGS2_FLAGS_PDPTRS_VALID;
+               kvm_vcpu_srcu_read_unlock(vcpu);
        }
 }
 

> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8acfdfc583a1..73c900c72f31 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6619,7 +6619,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		r = -ENOMEM;
>  		if (!u.sregs2)
>  			goto out;
> +		kvm_vcpu_srcu_read_lock(vcpu);
>  		__get_sregs2(vcpu, u.sregs2);
> +		kvm_vcpu_srcu_read_unlock(vcpu);
>  		r = -EFAULT;
>  		if (copy_to_user(argp, u.sregs2, sizeof(struct kvm_sregs2)))
>  			goto out;
> -- 
> 2.50.1
> 

