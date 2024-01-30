Return-Path: <kvm+bounces-7496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0235842D0B
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D8F2883F4
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6DEB7B3FE;
	Tue, 30 Jan 2024 19:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJd7AN4a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9747B3D3
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643531; cv=none; b=Mk4Gt4X8esCoAKvlG46xOSSO7X0AnX49dL9Mmw0RPUxMeoA1ODWpHBbwKFfd+2UxSvklqFR///T+xW5zLpGpHGjeWcuZFU6K1z0Yhd2kl2JpEnuqgMlfxjoXvTdLMbpcR5cKlTbOAs9YRxQNVxIIET9/Stnwb5dAla0pG6sEvDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643531; c=relaxed/simple;
	bh=hKWaLQDJu1+DooodwZkd2/GJkSGOF7fWmUEXgxyeh8Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mj2Iqgj+Mdy7uK8wPJKM+SDATdfamR+OESYl0q1N6+QeHAJ6UCVr1C4lG8al0EI+LoZHMaVhJl6oc963NiZ7Wxzpd+oYI3oJDCqMt12VU9IS8Ok4wAbHVHemmS4abkoyZ2e+6MEZR+568OdmG/uIFcS6ageoCxVwGc+lYPFs1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJd7AN4a; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60405c0c9b0so4688657b3.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706643529; x=1707248329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lRNC9vhu5qQNQxiaK9MmMS+U8DijJfYydYaXzrJk/Nw=;
        b=BJd7AN4aKZjGfDc4ayfWUhRkfDHhREwC8rQr1Q7Ao5gJniyfNu51QZ4LNi+QsY7pYp
         6fYd68KsKoNuTs+j9D/Hulmzoko9vK2SB5oJOpKYp194/cRhN8fyRL/iOO5WBeUFamLj
         mKPqUInguzZWKdqv1MUIJqIK8zta17GvdzguPYFcTK9u9tryc0/r2chRNGGSQooY7UFp
         MAOzi6/7haYTJ2YGghcKvO8xRBWYDa/wbKrRH7zmimrByjn4tQIDhddy5YZjKBGQpvhK
         iWGM6ZW/KVqVuSjd3b75lJ5wiG73ypvxW1XwhWPCUebSq/A6M/WWsLsZmMUfggmea8cL
         r0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643529; x=1707248329;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRNC9vhu5qQNQxiaK9MmMS+U8DijJfYydYaXzrJk/Nw=;
        b=FGyaj5zGVEaWKYprKK/Z5C4oXIuUrfetblvoQ7mYwO17XufXXQNJXCz++rz4d/EXPy
         KjFu4bQli2QbHXhQiLsWTCgT228t3vYdVHufufX0Q1kimvEpnRr/Wy5hwS3jxrMlEyMG
         xUuN4lNnhZyHHICrNsuPRHIDEeD/0IUOB+6fGagvuyQkAqHzgnrdCwT6sw1ZJ/2t1px0
         +ATUTe3MXi8/Td+I/j69IYPwRsUQPMbg7KXU0lTst57mtJrMtyywezvKLHjdDehvKN2T
         adTpOZ1EMTnhcVv0frtaxZWCY+e1mIX/z0AwcGaN5OidnDVlxBp14cV231QhQYFjp9dr
         5lNg==
X-Gm-Message-State: AOJu0YxKO+BJTuHuPFbZ0ElsU/yC4N2dimu+okF5/SEpz5qBgFZOhJ/6
	PM0eiW5gGST8vcU83c8Gk7YiqIhTevcymaujP1jTTIVwT/8BtPHOgAQcFv79z/uvK8w1SwEcHZr
	UlQ==
X-Google-Smtp-Source: AGHT+IHmrViN/ZjxmZS03vB9eaoQ7r5O1RY4TLOxKEVifZNEdHj1IOgeMb2HfrcJSZ2iX563UID7EtHcqxg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:144e:b0:dc6:1a1c:6a12 with SMTP id
 a14-20020a056902144e00b00dc61a1c6a12mr3110546ybv.5.1706643529516; Tue, 30 Jan
 2024 11:38:49 -0800 (PST)
Date: Tue, 30 Jan 2024 11:38:48 -0800
In-Reply-To: <20231218161146.3554657-2-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com> <20231218161146.3554657-2-pgonda@google.com>
Message-ID: <ZblQSI6WkrNj04dx@google.com>
Subject: Re: [PATCH V7 1/8] KVM: selftests: Extend VM creation's @mode to
 allow control of VM subtype
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 18, 2023, Peter Gonda wrote:
> Carve out space in the @mode passed to the various VM creation helpers to
> allow using the mode to control the subtype of VM, e.g. to identify x86's
> SEV VMs (which are "regular" VMs as far as KVM is concerned).
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

SoB order is messed up.

> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 82 ++++++++++++-------
>  tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++----
>  3 files changed, 73 insertions(+), 45 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index a18db6a7b3cf..ca99cc41685d 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -43,6 +43,48 @@
>  typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
>  typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
>  
> +enum vm_guest_mode {
> +	VM_MODE_P52V48_4K,
> +	VM_MODE_P52V48_64K,
> +	VM_MODE_P48V48_4K,
> +	VM_MODE_P48V48_16K,
> +	VM_MODE_P48V48_64K,
> +	VM_MODE_P40V48_4K,
> +	VM_MODE_P40V48_16K,
> +	VM_MODE_P40V48_64K,
> +	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
> +	VM_MODE_P47V64_4K,
> +	VM_MODE_P44V64_4K,
> +	VM_MODE_P36V48_4K,
> +	VM_MODE_P36V48_16K,
> +	VM_MODE_P36V48_64K,
> +	VM_MODE_P36V47_16K,
> +	NUM_VM_MODES,
> +};
> +
> +enum vm_subtype {
> +	VM_SUBTYPE_DEFAULT,
> +	VM_SUBTYPE_SEV,
> +	NUM_VM_SUBTYPES,
> +};

Now that "struct vm_shape" exists, this can be much more simply:

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 9e5afc472c14..c62b3fa4e9f6 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -90,6 +90,7 @@ enum kvm_mem_region_type {
 struct kvm_vm {
        int mode;
        unsigned long type;
+       uint8_t subtype;
        int kvm_fd;
        int fd;
        unsigned int pgtable_levels;
@@ -191,10 +192,14 @@ enum vm_guest_mode {
 };
 
 struct vm_shape {
-       enum vm_guest_mode mode;
-       unsigned int type;
+       uint32_t type;
+       uint8_t  mode;
+       uint8_t  subtype;
+       uint16_t padding;
 };
 
+kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
+
 #define VM_TYPE_DEFAULT                        0
 
 #define VM_SHAPE(__mode)                       \
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1b197426f29f..b95640c935e2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -226,6 +226,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
        vm->mode = shape.mode;
        vm->type = shape.type;
+       vm->subtype = shape.subtype;
 
        vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
        vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;


