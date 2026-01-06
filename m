Return-Path: <kvm+bounces-67168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 551BFCFA94E
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E341931C2785
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 18:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD373559C1;
	Tue,  6 Jan 2026 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vSErz6oT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424493559F2
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 18:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767724204; cv=none; b=J1mFZ+NGTaD4hYl/DsCpB6WVg085gjyVjxZiuB90/BhyJFHFEtApJVkMCdQ3Ru9QSrSgRdGH+qqWeifOE2GhVrHGjZrMOtbtuyKrGhhw5TYSVVoEtI3E9Fqg2Y9JAyOPLrdgiXqeCBGcfKYma0dw/i12FzONGJY0HxjSIsZE+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767724204; c=relaxed/simple;
	bh=Fc2BipJ8dVRuvfYfezzVQ5W1M6GeS4SikFI0dSgwCvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hTo5i0PhWTSL9CDqQ59C2venftBgPHIwfnxp5zGPfrx+NGcMa/JUMoBVzQNeWuSr0gY7WnaVYWjAGf3zOwSbHPeQP7Vk5vwnjC+sx9CuxB5lrLRVtVhuMV4JUqtVAN74ptwWhKaZjRi8J9hNt/Z6bwpvGbOBl85iuw7Mpa92Kys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vSErz6oT; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-be8c77ecc63so1742916a12.2
        for <kvm@vger.kernel.org>; Tue, 06 Jan 2026 10:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767724201; x=1768329001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxKpvU7MXRoaE794uGM24F+IGVWZlDYfOsJw+D2rdM4=;
        b=vSErz6oT3b44gtYnqUCAwxzKwE7dtN78ZGPqQA7i6JQwVsKxmM6iFcqO264DdP37B4
         f3EqsV4B44bIkgb/eqEe0YqSK1ACheJnW6pheXcV5Iz5eXP4rLZa2Gp1OQZ4yfBDyZFP
         KhZAjh/ce29MUJW5PJZIc4hrJIPvrb7VyBhz04eIKdQV8+H8wn48JFEdutBtNW8QebN3
         9TSV/vmJjfb3yyyAUZANl32nvOJCgY3Ohor8mNjhcpHEbBz713vf/c1C0wCB+zmx52ka
         gZwU1PJi1QVrzG6CNve3U8jqptzfF6bwHR1K5xsRPE18OAL3GwYnmu0GgRdWXtKY+tR7
         huRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767724201; x=1768329001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fxKpvU7MXRoaE794uGM24F+IGVWZlDYfOsJw+D2rdM4=;
        b=aA2zxThfzXPzTHWDv5k4M6iQDGyvQdASDLxj213L5U9TqhPRanZIyTCU16M4AHMldR
         zZ2zgIhaZDHL3jgwdLZLj/51qO/IGZQW3wzWBXnqWn6Z0eKKG6NIoZa0XnokEBEj7rjq
         TG3T68c1Mfk0BvcDP/0fnHM1qCkzGVj7Bu7PAuJdonogESalagh3QUiJB51qYsdpPp1H
         LP/yHpyzhEbH0lyzlcgJ/pm8l6EAKnY2n7W41nozTwa2T3dNI8fKzRDk++GqhSOxLfQ1
         vJwWfNegG7NCEbrjgwO+1Hd07kEZTch89mOzttvZrMpJmNRm74AmBMs6+ziyWpBFqidj
         cANw==
X-Forwarded-Encrypted: i=1; AJvYcCU7U2ppjx1G8v4xcRPv4JlbMN+tb8ky6Nb0hdmaOqt+MqOrB8pkYnU738kVNTzM4Fcfqr4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ1iEoZmi/oRFq+GRo0S62LIlqDYx331rpqNS8F7zRWqlzyW0v
	yStZr6VKi4jj61OEtsjKeg7a+fsDwvi0dtNll82Xc7d7Di1q5FhJ6K5Uxkt+iaj+ec4BgeiziH9
	yELPAZA==
X-Google-Smtp-Source: AGHT+IEpHQH0PLvLpJgW5R5685aLoya6CH30aGzrrjZV62JRaOXbohHV0hFImFtK9L7cCdYGqYuB/k0Uz7k=
X-Received: from pjqq11.prod.google.com ([2002:a17:90b:584b:b0:34c:612a:167a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d84:b0:34e:8442:73e0
 with SMTP id adf61e73a8af0-389823f743cmr3297292637.54.1767724201342; Tue, 06
 Jan 2026 10:30:01 -0800 (PST)
Date: Tue, 6 Jan 2026 10:29:59 -0800
In-Reply-To: <20260106041250.2125920-3-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106041250.2125920-1-chengkev@google.com> <20260106041250.2125920-3-chengkev@google.com>
Message-ID: <aV1UpwppcDbOim_K@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 06, 2026, Kevin Cheng wrote:
> The AMD APM states that if VMMCALL instruction is not intercepted, the
> instruction raises a #UD exception.
> 
> Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
> from L2 is being handled by L0, which means that L1 did not intercept
> the VMMCALL instruction.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Co-developed-by requires a SoB.  As Yosry noted off-list, he only provided the
comment, and I have feedback on that :-)  Unless Yosry objects, just drop his.
Co-developed-by.

Ditt for me, just give me

  Suggested-by: Sean Christopherson <seanjc@google.com>

I don't need a Co-developed-by for a tossing a code snippet your way. though I
appreciate the offer. :-)

> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fc1b8707bb00c..482495ad72d22 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3179,6 +3179,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * If VMMCALL from L2 is not intercepted by L1, the instruction raises a
> +	 * #UD exception
> +	 */

Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
IMO the most notable thing is what's missing: an intercept check.  _That_ is
worth commenting, e.g.

	/*
	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
	 * and only if the VMCALL intercept is not set in vmcb12.
	 */

> +	if (is_guest_mode(vcpu)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	return kvm_emulate_hypercall(vcpu);
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3229,7 +3243,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
>  	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
>  	[SVM_EXIT_VMRUN]			= vmrun_interception,
> -	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
> +	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
>  	[SVM_EXIT_VMLOAD]			= vmload_interception,
>  	[SVM_EXIT_VMSAVE]			= vmsave_interception,
>  	[SVM_EXIT_STGI]				= stgi_interception,
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

