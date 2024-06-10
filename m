Return-Path: <kvm+bounces-19264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91029902AFB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 23:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B432B22C55
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 21:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 183C714F13D;
	Mon, 10 Jun 2024 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lCMLZUcS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76EA12F397
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 21:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056424; cv=none; b=LrWFDjm1T8okaaWDMiKPa64bc9rKQfXcvMiD073XW4dtYlOQAe4OfzQ9HbxMaD0IurVpfSZnCb3DcAfeHjj7GcnFAll0yTH3I6xKJkRXgjwpQ3pOwmynki5wQyvFPPS0buBesOLL+2XwPZnfvSkkQXY9i4/Mf1RtVCeFt+O6784=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056424; c=relaxed/simple;
	bh=6pneo5QO4nvKpp1/TkD7LUEm8eygp5E/+M/4RYIesFc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G4OD/PRvIxURCVkL8WoCYKk4kaBbE9ncPbIRi5+HqOlwqI/UOMfMmECFd5XCZz0mDwUQYef7XIBEoL5VXAYlx779p6ii4vkVmnlxI3qo2u47YWbE9IRr8dXJzzmrA/w/58WJvfFc24dUgQFNkD9Xn/Ei7VkVsFnlxFGtGHsdwf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lCMLZUcS; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a083e617aso8220567b3.2
        for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 14:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718056421; x=1718661221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FPx4fAee/hALOqpnRoU6sIAQmCmaPKYhlN6f9GsZiU=;
        b=lCMLZUcS+a9f3C3muTFBycFTLGKGm4+YesLQA6YYCkYPB5l2bKWM0Ki7w/asBvgz3V
         aPdVm4J7khbOqo+mSmFezEoCblI9VXOsdr+C52JGjehEKqpL3Yl/J4lRF0bsZEIOhGM7
         JaT9edKR34yi60pS5YLQFNLYIXWryg8C1DL+OvwqYvVMCYtbO9idIEq/F7FYgVQ5yyxq
         zigOdhwT9Ua5E40F7vSjS0rQ+mLZaFL19U0RzePfZFTI7vLlLqpIIXU256i4Ss//Uvl6
         LobsEej5l0E1dB2TRYcfa0Ew3dTfCJgJ6BkFrwwb5w9L4lwKTHSXvXhtVzg+VkPHZBGl
         zHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718056421; x=1718661221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3FPx4fAee/hALOqpnRoU6sIAQmCmaPKYhlN6f9GsZiU=;
        b=J7qpJG96xYA0tR/un/hzSBiVaqid524CKj5b/Lmuox8A+c8F8i6/IdVB1uTu9AFNRf
         Z/uKhujbaqoJDUlcafeMTcUwkcW8epwuqitgZnGLag/pHXNws2VNXyPzje4nNMELjkEj
         45hviWPv4UHMrY5N8xO3GI3glKHcySBA7gwzuWjs7949VvXy19V/c0TH6qBWOgZdihh0
         VKjZ0fAIxV82uis3tFc60ZH0lj8EzD+xLKmPT3Mt6xFqlQ+UJ83Hds6lJEwDuvl6AT+R
         uAfcjHITqbGygZboRTwjTHJ9HT91jVZ1V+skPPcVFu02Ou9uCgKzBd1w7TaZjZvCRtvb
         wedw==
X-Forwarded-Encrypted: i=1; AJvYcCWB7FWMV4KNF8rDZ1AqnbnLdNT4vE6Lud0CrZGnvsDQDXN1L/J0HUFRvvbGSa2JNmCj9vuUUa7ML+qqHrAUrgvBRxx5
X-Gm-Message-State: AOJu0YyBgKL83eK3p54qXcke1MTfjsYJacLttf5lrZRfgIrDX10Dszcy
	G5aqP16DINGxhFg6JA7SchHm9wKx3nSZxZbMt6cMjW3UpzMyG7gJKKmkhfd4mhBEKYUEXiGYqia
	R0g==
X-Google-Smtp-Source: AGHT+IFRB7gtoj4EkaJ8sYxdoFmmZjP1g4eF/BaGf5zkvPKvX8M6PQ1tEEYRYcVxDOEOlYBzqtIFAhaC070=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10:b0:61d:4701:5e66 with SMTP id
 00721157ae682-62cd5570599mr41126177b3.2.1718056420707; Mon, 10 Jun 2024
 14:53:40 -0700 (PDT)
Date: Mon, 10 Jun 2024 14:53:39 -0700
In-Reply-To: <c0122f66-f428-417e-a360-b25fc0f154a0@p183>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <c0122f66-f428-417e-a360-b25fc0f154a0@p183>
Message-ID: <Zmd148whQzsuIzm_@google.com>
Subject: Re: [PATCH] kvm: do not account temporary allocations to kmem
From: Sean Christopherson <seanjc@google.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 10, 2024, Alexey Dobriyan wrote:
> Some allocations done by KVM are temporary, they are created as result
> of program actions, but can't exists for arbitrary long times.
> 
> They should have been GFP_TEMPORARY (rip!).

Wouldn't GFP_USER be more appropriate for all of these?  E.g. KVM_SET_REGS uses
memdup_user() and thus GFP_USER.
 
> OTOH, kvm-nx-lpage-recovery and kvm-pit kernel threads exist for as long
> as VM exists but their task_struct memory is not accounted.
> This is story for another day.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  virt/kvm/kvm_main.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4427,7 +4427,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		struct kvm_regs *kvm_regs;
>  
>  		r = -ENOMEM;
> -		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL_ACCOUNT);
> +		kvm_regs = kzalloc(sizeof(struct kvm_regs), GFP_KERNEL);
>  		if (!kvm_regs)
>  			goto out;
>  		r = kvm_arch_vcpu_ioctl_get_regs(vcpu, kvm_regs);
> @@ -4454,8 +4454,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		break;
>  	}
>  	case KVM_GET_SREGS: {
> -		kvm_sregs = kzalloc(sizeof(struct kvm_sregs),
> -				    GFP_KERNEL_ACCOUNT);
> +		kvm_sregs = kzalloc(sizeof(struct kvm_sregs), GFP_KERNEL);
>  		r = -ENOMEM;
>  		if (!kvm_sregs)
>  			goto out;
> @@ -4547,7 +4546,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  		break;
>  	}
>  	case KVM_GET_FPU: {
> -		fpu = kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL_ACCOUNT);
> +		fpu = kzalloc(sizeof(struct kvm_fpu), GFP_KERNEL);
>  		r = -ENOMEM;
>  		if (!fpu)
>  			goto out;
> @@ -6210,7 +6209,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>  	active = kvm_active_vms;
>  	mutex_unlock(&kvm_lock);
>  
> -	env = kzalloc(sizeof(*env), GFP_KERNEL_ACCOUNT);
> +	env = kzalloc(sizeof(*env), GFP_KERNEL);
>  	if (!env)
>  		return;
>  
> @@ -6226,7 +6225,7 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm)
>  	add_uevent_var(env, "PID=%d", kvm->userspace_pid);
>  
>  	if (!IS_ERR(kvm->debugfs_dentry)) {
> -		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL_ACCOUNT);
> +		char *tmp, *p = kmalloc(PATH_MAX, GFP_KERNEL);
>  
>  		if (p) {
>  			tmp = dentry_path_raw(kvm->debugfs_dentry, p, PATH_MAX);

