Return-Path: <kvm+bounces-36575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F4AA1BD27
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 21:11:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA392167F3B
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 20:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA69A224B16;
	Fri, 24 Jan 2025 20:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R/rZ+icN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79833224AF0
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737749487; cv=none; b=Bh040eEk/Q3VI2TybmvVP16Gc50ku4HopNPErm0O/mcNzRGT9TJ3L3UT+UDOBJIBzHVVCA3z0v05jbH1U4nCXLKQcahiAlsrapbEkUBpsHF27hWQ9XVLKRmIysnJo8dZVgi/xT4GR6lArqgosfMSHt6LSgd/WmwljT36kdGcI1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737749487; c=relaxed/simple;
	bh=oSvhoOu2lfr43aDW18uDXKi1Zq1yPNUwO1ruRmx8R7I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D8x5KdFA33AEx98hEtabn7G2B2qtuFZ40ZLBq0sIGYKhfiYHVuIlnGzatf7mW5DH9bISTNK+jngfynO4uWqNEWt9R/qZb9oGe3Ma5VtKhUa2izWues7YsgGyOHBmI0xmSWLK+ivHf5DdoJ7cFFlRtzMsBmuvxKO9gKqS/69bIqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R/rZ+icN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-218ad674181so73961475ad.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737749486; x=1738354286; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2N3KMri1vGQaqU0d9XUaHZn5JGbv/cJsvyzX91aErOc=;
        b=R/rZ+icN0N7qfw2pZ7HXlUWbdm89cunEXz7FN/4+nZbmsLdfyIKY2UwU/50Bw+u9fr
         cYUhb/bonGyfgDrQnRgq29CPCarlujxiEqxbIupM9xyHvUQ5lHputQQEbEumr7gda9rL
         LJ1oIc5gFCfvWLhOaz4bUevPHHdZfXj6T4KJKww1Kn1BFXNg8QoPwoGoBxMOD0hjwrJM
         BlGscgLOnsSSA+KoTAF3Ir6c8go1PvL45cumtVyxfg/M9uE1lh0A7C5X5T5SamYI6m8H
         pVNRO2EtpJu41/yx2aX8tJISgnn+ZVmUK7p0d4HtFPJ8csLEQelTfINp5cNeY6F+XMmr
         flCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737749486; x=1738354286;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2N3KMri1vGQaqU0d9XUaHZn5JGbv/cJsvyzX91aErOc=;
        b=P+1ZYbvCAYKexjLbJDtMJStpcHsaK6r+Vlxa4c94YK5xlewFEuHCpZVQfUYcCYis9Q
         JpzJkkrBrEXLayjb3wq0W5jL0zYPjEVxMP+IIS4oAmWyhpY96HmerMVL/FdKhqiE4SBi
         th/bzVk1nlgBIKBfSAazKAScANbpO4nzGdWXceD4EwO9f3PaeXZxTQkw5YT5RszIaSHQ
         awAQ24GbtcgO5VZnkWWoBojsUZqnGmdtBqf4ccqQO4aJzw49JyNLziMqJC9cOP4YCKvv
         KKWJi82cL+uPB8MMJ9mK5lNrDTkooKL3YHk2Xq0ZOYuTmqaWks1a+9n9zN5cuKfzelWu
         /AfA==
X-Forwarded-Encrypted: i=1; AJvYcCXs4D9M9EnwJMnqMjAjCr5X7hFPqshQ5g+6mdWs8PD19ajP/L3/xU13l5mGWC1lBTdXQC8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvLgIGbOykunneMAtnjUKsi3diNrAIaJTIvqMYxYYCD46+YXFI
	eXkffDdvMkzmFNpYctq2XAODGbBVcbwxmkRwUl1WlrIfOt1e+tSCjIFHOsolswQ01d/KQmdY7rv
	yNw==
X-Google-Smtp-Source: AGHT+IG4E+KNNzOc8URgwVq0gAjL4g6nFVWR969X9iQCt6c+YTZ8tznONtRYY3APCTp8AvowRYbeDHO9Gag=
X-Received: from pfbeg15.prod.google.com ([2002:a05:6a00:800f:b0:725:c72a:a28a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3a21:b0:728:15fd:dabb
 with SMTP id d2e1a72fcca58-72f7d22307bmr14543734b3a.8.1737749485759; Fri, 24
 Jan 2025 12:11:25 -0800 (PST)
Date: Fri, 24 Jan 2025 12:11:24 -0800
In-Reply-To: <20250124191109.205955-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
Message-ID: <Z5Pz7Ga5UGt88zDc@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Paolo Bonzini wrote:
> Protect the whole function with kvm_lock() so that all accesses to
> nx_hugepage_mitigation_hard_disabled are under the lock; but drop it
> when calling out to the MMU to avoid complex circular locking
> situations such as the following:

...

> To break the deadlock, release kvm_lock while taking kvm->slots_lock, which
> breaks the chain:

Heh, except it's all kinds of broken.  IMO, biting the bullet and converting to
an SRCU-protected list is going to be far less work in the long run.

> @@ -7143,16 +7141,19 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  	if (new_val != old_val) {
>  		struct kvm *kvm;
>  
> -		mutex_lock(&kvm_lock);
> -
>  		list_for_each_entry(kvm, &vm_list, vm_list) {

This is unsafe, as vm_list can be modified while kvm_lock is dropped.  And
using list_for_each_entry_safe() doesn't help, because the _next_ entry have been
freed.

> +			kvm_get_kvm(kvm);

This needs to be:

		if (!kvm_get_kvm_safe(kvm))
			continue;

because the last reference to the VM could already have been put.

> +			mutex_unlock(&kvm_lock);
> +
>  			mutex_lock(&kvm->slots_lock);
>  			kvm_mmu_zap_all_fast(kvm);
>  			mutex_unlock(&kvm->slots_lock);
>  
>  			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);

See my bug report on this being a NULL pointer deref.

> +
> +			mutex_lock(&kvm_lock);
> +			kvm_put_kvm(kvm);

The order is backwards, kvm_put_kvm() needs to be called before acquiring kvm_lock.
If the last reference is put, kvm_put_kvm() => kvm_destroy_vm() will deadlock on
kvm_lock.

>  		}
> -		mutex_unlock(&kvm_lock);
>  	}

