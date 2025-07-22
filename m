Return-Path: <kvm+bounces-53164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9355AB0E294
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 19:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F6FE1C8551E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 17:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B39B27FB18;
	Tue, 22 Jul 2025 17:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q45HmErC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC34685
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 17:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753205264; cv=none; b=Nk0nSkGlFn1EXmmfznjAavZM5JEZ989vJcmRmWHeNMZI433fer4jF7zRWoBqI8kRRnAjMepWV5q+kAw4Y6oJ0wuuinbh3BAqS3M6H6lz2TIrBNdRjXILc+8ZaPlIFP7tSNaPj/EXgb5n/Sz8iVlhtJBSLklyGQ3WyETo8MM2ma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753205264; c=relaxed/simple;
	bh=syxL5yFIfrXhC+h4Uv6eBBsalk6IqK7By/q7/N6YndA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hmpDL1M3jiC7HHz0SzZAiRS6dziklj3srSQYvYjLceE9DMojztC80Xycbz7/Wryg2Xnr2BbOkOwG9+tlNTY7IqV5T5EGPyC80/bK2EHrYVyKwk1ZAXX+ogi0d7Sq5Hjjz96PBzJ6aLgHG5QR6vKD5vVTRJomHXbY0gTmJB3v/Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q45HmErC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-237f8d64263so55392885ad.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 10:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753205262; x=1753810062; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gNuep+WR+auVA36XZo3u/qqPdLw6h3Tg29vPjRH6q58=;
        b=Q45HmErC57yTnIxKh43vbtFhCuYSIO86jfWOqskujsasYE5v5NWqQp/ZV8BfiAHy4I
         KlU0vvyZqPIVgHQlHT9d9yjC17Pw+VLtjIwPiIQLf7Opxpw4AYh/g+BWFSV/nShYpCLa
         CoE2bHjodyqbblCnxV6a1XYG15e8xoV0Sq/40NekF9+W3dF0yek3f92dR6F3742eSHkb
         5pqB1YdpgIVgx4jC7rtyIheMPCQiv1ND462D0m9z1rDiqq+VNjOc1Up/zRy3YFgNyOhj
         MqJl5wFWIXPVWJrxaVxLFR5Zm2DAu7frTdh+6qHsChmr+7+JKBwt9dL97hw6wd3r8oFg
         KpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753205262; x=1753810062;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNuep+WR+auVA36XZo3u/qqPdLw6h3Tg29vPjRH6q58=;
        b=WHWjOIubwto8Z/3Ui2q4bjfPnjMAFsCq8niqAsFnyU3p2coGuErqPnlDjPoIY5Og3s
         qa3hY8GqoxkcOr7Dk8ljQ2rJCV02OQPNYJXl5XpmQRwn7tmTXhHOVqnD5folQh/a75n0
         pGCMjtyiscr33Y4wlwHZQ0k3VEc/sNH4m+xZunHOFWIelnevulki8XO9EOeuqcR138NL
         xpIFsKsJNt1i56nSGS/siAd9lHd1nswIPRi788SqcvOlmnY0e3DUjBZs31u7jSGcwSkU
         wTbIdzxptnzmrRz8Dyt6LJ1pZiKv0jSDuw+RG7TFMqvkDYDMk28JPh3hrWccpyi4Yu1k
         O+kg==
X-Forwarded-Encrypted: i=1; AJvYcCVZb8DDn/Zi1edBXlbl43VTPYN+IqSzMMJ8dSBkWGSHk6oPlecXgTpACUWqVPJWGmwZuBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yytrd6tISXnoxYcTTLPmVe0w/QspbhkIbM1qTdNc4ZMvBHEikKa
	vSMud2G26oB+ICaevSShJCjZF8FZy21rUVqpF0QXf+Nig1+yX8juMmTTGUm29gVTbfnQ8FS6CGx
	zz2UGfw==
X-Google-Smtp-Source: AGHT+IGlPsKj2kXWks86x+28HfdK7Z/QqkDwZwVYgVnNVIpsClfKH/9J41q2BYHdfvNQBrCCOD4NuTpzbJE=
X-Received: from pjbcz15.prod.google.com ([2002:a17:90a:d44f:b0:312:f650:c7aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c6c:b0:235:f51f:c9e4
 with SMTP id d9443c01a7336-23e24f49430mr394121175ad.12.1753205262126; Tue, 22
 Jul 2025 10:27:42 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:27:40 -0700
In-Reply-To: <20250722074958.2567-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250722074958.2567-1-lirongqing@baidu.com>
Message-ID: <aH_KDFJsH3i7xF-e@google.com>
Subject: Re: [PATCH] x86/kvm: Downgrade host poll messages to pr_debug_once()
From: Sean Christopherson <seanjc@google.com>
To: lirongqing <lirongqing@baidu.com>
Cc: pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The current host-side polling messages are misleading, as they will be
> printed when the hypervisor intentionally disables polling (by providing
> MWAIT to the guest) rather than due to version incompatibility. so
> Downgrade to pr_debug_once() to prevent spurious log messages.

I agree the messages are unfortunate, but the guest can't possibly know that the
host is correctly configured.  E.g. if MWAIT is allowed, but the host is still
intercepting HLT and the guest happens to choose HLT for idling, then the guest
is absolutely right to complain.

And there's really no reason for the host to NOT provide KVM_FEATURE_POLL_CONTROL.
The only thing the guest can do with MSR_KVM_POLL_CONTROL is to disable host-side
halt-polling, and for a KVM_HINTS_REALTIME vCPU, single_task_running() should hold
true the vast majority of the time.  I.e. a properly configured host won't actually
poll anyways, so providing KVM_FEATURE_POLL_CONTROL is basically a nop.

In other words, I agree using pr_err is annoying, but I don't think downgrading
it is quite right either.

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kernel/kvm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 9cda79f..c5f96ee 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -1136,8 +1136,8 @@ static void kvm_enable_host_haltpoll(void *i)
>  void arch_haltpoll_enable(unsigned int cpu)
>  {
>  	if (!kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL)) {
> -		pr_err_once("host does not support poll control\n");
> -		pr_err_once("host upgrade recommended\n");
> +		pr_debug_once("host does not support poll control\n");
> +		pr_debug_once("host upgrade recommended\n");
>  		return;
>  	}
>  
> -- 
> 2.9.4
> 

