Return-Path: <kvm+bounces-56980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 889E5B4918C
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 16:33:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28228442B85
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 14:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081C93101BD;
	Mon,  8 Sep 2025 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ceot0oGz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A730F30E0F3
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757341829; cv=none; b=k3xGxklx5Tae2QSaKYBEEQCi8KhDYUCGXNIb4tWNSxNbpvkOsW3aohQRXlcwO3m2RIYIqER5LDbKA/gCgMU+RTtb5CqvHsjrbGxrXrx6QhgL7BYY+mQye13M9ZqTwA7azNT6nxcCXxbbBV78iTw6nfH3RZVi2bZ7rLz8ep820dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757341829; c=relaxed/simple;
	bh=cmyRdu79YsuSij3FfU0KEBsMepHM37Prr20hi8qJG6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oAqT2O6P68YTR2fDWqs4nRcHgNUNKomZI4LMoxi+htoyVTLPZGOoUAjPFD7qdvftcDA1fWEmMVKZI5LfWcgvA+gsBP48OTpKGA9I3Cc1v4W7ThIzP0LpjctHpeW2kfHuPj8IM1VLOcqykcRqnZ9WffVZOLXW2g1XmB+TQddaeUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ceot0oGz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32bbe7c5b87so2862636a91.3
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 07:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757341826; x=1757946626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Os6XU2XhawOtL2RY3j64uiQc+pzgMuwrVN7W9RY195E=;
        b=ceot0oGzFNc8szA3i3+uAd+fthlLCHgJcKNDkHqGJeZkllnoEyrBkiKTPnhxGcj3sv
         R1tv/Hr41FfnL6ygjkQpFJ+EUgb5jEEapWui4b0sSELw4QxXDrEKPdqtauCmj9C8CrWU
         SWNa3ITw0qKMHGU+LFE0WjMA4SrOeOFzyDvkLba7Q/c/E9/de4IpWmUx/W8QL6OC0hOF
         zQgwM4An/l/kofnhDcH/0eTOWf1jRgCm6B7MeqOQwOetsCojZRWaPWq+RaHjqVdJcGLj
         KaNYVXgiGgFJulzZP6g4IrP8rjaQs6lcEqhzrbKl/QJRs8+EMwQFQFiwKWF7VetTZBpG
         sf1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341826; x=1757946626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Os6XU2XhawOtL2RY3j64uiQc+pzgMuwrVN7W9RY195E=;
        b=LBuDIItfOmiEXcZFij4CyHI7kX0yjUwesHSHVsHlu6GfQiWsm/6GtqW8+L87lHchye
         Qq1JANzhsVUIhXPwzYIWsAR2mYlKizJpWMuu5SAmis8E0KCFUXnmgYqKFtXjjGd1JgCG
         AOvLQyK0N0a/rKnjDTJgtwzuynp2wDoh+o8FfYZIWg5ccb39Po8fNNbEzwEbLc2C406q
         dStj70mO+IKz1Pt76immCDqvIiQJXtjPStJmY3FvnUnRXfho/bq92zNbO0LxVQP3MiEP
         VvptwU/X3YaXQ+cDZHs0BoEjQns4d7jLPTfG0FkN4BopO6tpu/gV1TkTaGA6I9txfd1K
         ojNw==
X-Forwarded-Encrypted: i=1; AJvYcCWYtRcyKjMUAnLpcimmEIB9mpESF4w34Pc2X+i7jqL/k6oTfLkTtHNzYL0XqQo0ysT+CaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHGNMZBlOVFKXTD4ISlhz9tMlKjqiWytn+QNlng813GeA4TxVG
	htqpws0d1AMpMmKJ8qJ+KS+Yx6S8yDD1y72vxgrOSBhAPEOw+h0yiwpViCc95B/ar3TgSvqpKfc
	hBJPnUw==
X-Google-Smtp-Source: AGHT+IFzFQXq39q0wt+yWcjspFshRrGb6Ni8X5edy538tKagMLPlwv9Fmec7NohENqeG0o5K7Lljk6m7DjY=
X-Received: from pjbsy8.prod.google.com ([2002:a17:90b:2d08:b0:32b:5f22:e5da])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac9:b0:327:531b:b85c
 with SMTP id 98e67ed59e1d1-32d43f99cbamr10850847a91.35.1757341825786; Mon, 08
 Sep 2025 07:30:25 -0700 (PDT)
Date: Mon, 8 Sep 2025 07:30:24 -0700
In-Reply-To: <20250906184324.89974-1-hsukrut3@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250906184324.89974-1-hsukrut3@gmail.com>
Message-ID: <aL7ogKtOUi2py1jx@google.com>
Subject: Re: [PATCH] selftests/kvm: Use vcpus count instead of hardcoded 0xff
 in test_icr
From: Sean Christopherson <seanjc@google.com>
To: Sukrut Heroorkar <hsukrut3@gmail.com>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" <kvm@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 06, 2025, Sukrut Heroorkar wrote:
> Replace the hardcoded 0xff in test_icr() with the actual number of vcpus
> created for the vm. This address the existing TODO and keeps the test
> correct if it is ever run with multiple vcpus.

The TODO is stale, it was resolved by commit 376bc1b458c9 ("KVM: selftests: Don't
assume vcpu->id is '0' in xAPIC state test"), I/we just forgot to delete the
comment.

> Signed-off-by: Sukrut Heroorkar <hsukrut3@gmail.com>
> ---
>  tools/testing/selftests/kvm/x86/xapic_state_test.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86/xapic_state_test.c b/tools/testing/selftests/kvm/x86/xapic_state_test.c
> index fdebff1165c7..4af36682503e 100644
> --- a/tools/testing/selftests/kvm/x86/xapic_state_test.c
> +++ b/tools/testing/selftests/kvm/x86/xapic_state_test.c
> @@ -56,6 +56,17 @@ static void x2apic_guest_code(void)
>  	} while (1);
>  }
>  
> +static unsigned int vm_nr_vcpus(struct kvm_vm *vm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned int count = 0;
> +
> +	list_for_each_entry(vcpu, &vm->vcpus, list)
> +		count++;
> +
> +	return count;
> +}
> +
>  static void ____test_icr(struct xapic_vcpu *x, uint64_t val)
>  {
>  	struct kvm_vcpu *vcpu = x->vcpu;
> @@ -124,7 +135,7 @@ static void test_icr(struct xapic_vcpu *x)
>  	 * vCPUs, not vcpu.id + 1.  Arbitrarily use vector 0xff.
>  	 */
>  	icr = APIC_INT_ASSERT | 0xff;
> -	for (i = 0; i < 0xff; i++) {
> +	for (i = 0; i < vm_nr_vcpus(vcpu->vm); i++) {

This is wrong/undesirable.  The original code was:

        for (i = vcpu->id + 1; i < 0xff; i++) {
                for (j = 0; j < 8; j++)
                        __test_icr(vm, vcpu, i << (32 + 24) | APIC_INT_ASSERT | (j << 8));
        }

I.e. the _lower_ bound was nr_vcpus+1.  Regardless, as fixed by the aformentioned
commit, using the number of vCPUs in any capacity is simply wrong.  The stale
comment just needs to be deleted.:

>  		if (i == vcpu->id)
>  			continue;
>  		for (j = 0; j < 8; j++)
> -- 
> 2.43.0
> 

