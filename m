Return-Path: <kvm+bounces-31777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 04BDA9C79AD
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 18:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18F43B236A3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED4215AAC1;
	Wed, 13 Nov 2024 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="La92DEMa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BB641746
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731513907; cv=none; b=sfQgaWWRYXck0XfCXDQ+pW/UUerjHEZzKJ1+psFhRwFiStjGd4aM2g6kRgXZl0d0PuUpHjLKgiL1zZurhO54KfkebRo6K09AtZv0cba9gevKfqRmJgympRkIR6uVuAACYQgDmOU+yTORM3Vk27NmnTqzc2KnV0uoioS1ys1yiaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731513907; c=relaxed/simple;
	bh=G/mmn6Lq5ovAysIdOd/i6GGfzc//1jb0l2xAuvnGkjg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=adRNr+CdQlzfdji/xlUxZZGBdWLvC0w7/yTYmffbZk7qWMl746yWFrx3kp0kSq9hMUea1/hVi/64zg+q5tG7xpTsf8luuCKoADcjbt2Rla/EXcl1esM3Q/gJEVPZT9uGoQkQpi7FITL6j+E446tZ50RLGn2OPBlZZjCuH22ZbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=La92DEMa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21147fea103so95753775ad.2
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 08:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731513906; x=1732118706; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LlOQFL+9K3VuRpcPmCJ7+ar+DfDBKzSTEBW4YepjndM=;
        b=La92DEMagkqmbvYgJ8du1rbM7XizM7RRZWdodilb+0UKpXBjGi8u1HsbtgX1p1q7N1
         UoGB8C79nRzpu/V+NO4VB/hJqj42spPiOIkkLTQRy00RuiiFVALN2f0foaAkuVwSWrx8
         y5vp+PYD7O/pFeLE2Z15U06DO0CHDdXCMM9CIeJ/uRhmdIsuyY4C9+uBwkHssEzkHoKD
         50xnglmdSd6LDiVrOg5mLqL7wKmvr7A2IfSMQhpHeQnVGl2U6Dwu1d1AUMksitzfvGyL
         K/jbK82/Ao49fktzW5OrNMUKBek40ASwl0PyZWOC4rVOCtJKGBsiH9UrndFWtkA6WhP4
         y2og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731513906; x=1732118706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LlOQFL+9K3VuRpcPmCJ7+ar+DfDBKzSTEBW4YepjndM=;
        b=bawzNzH2MCxCDFjm59GpdPnCSuw8BDMl2BNlD7opgXdc8WX8VbfMmGHgAEgGVYZk8b
         CovvttsSRR8qSjSo44+3SXb2jcxkyASzZn3+TsVQ/FuXdDBzpcIAwhvgfX0BHCQrdKj6
         sxpzgpwogeqobpkRsB9m49wJYM7ctEYJi5UecId9x8wu/fG8sk38X7noxSacaZarK7Vn
         eZeKckU5q2qFWA65xto3sBDhqH6Q/o/HQtlZGIZ/NielGPEAmjfP+oCJJV4f2nEgR9Am
         kJi+jxoa2jr21DYxmF4wVpklVMFqMU6Jd21SEyP5YQ9lmtTKoxCltLc26hxOrC2FNKTZ
         oYuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWECQGWff5om3HZGKoSsPCt+U7ZzKHjEpiyfUp349CIhkTnHpaBizmDbZJMFRLSECqh5Tg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVYbEGApG5tjbSquTUWhSFhT3gVm8nE1wwTV6O0PQdoJEPELyf
	NOa+M17gLmGdcuI3HUFI4aaQfBHdUZ2UUq32543CAg8PsNXLDkjBaRcCv+vi8kN4m2ImPXdrfcJ
	dvw==
X-Google-Smtp-Source: AGHT+IHRz66Vc4kp3izG6KFJ4QkFUmkvAtjGgCUUjMa+g0jv8usG7t3rwwgFUSobZq0PzC3OQZxJPvR1jso=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab87:b0:20c:876a:fd97 with SMTP id
 d9443c01a7336-211b5bb29d8mr77225ad.2.1731513905750; Wed, 13 Nov 2024 08:05:05
 -0800 (PST)
Date: Wed, 13 Nov 2024 08:05:04 -0800
In-Reply-To: <20241113155444.2355893-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241113155444.2355893-1-arnd@kernel.org>
Message-ID: <ZzTOMFYBVjz3y3ip@google.com>
Subject: Re: [PATCH] [v2] x86: kvm: add back X86_LOCAL_APIC dependency
From: Sean Christopherson <seanjc@google.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	kernel test robot <lkp@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Michael Roth <michael.roth@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 13, 2024, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
> is disabled:
> 
> arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
> arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
>   597 |         kvm_rebooting = true;
>       |         ^~~~~~~~~~~~~
>       |         kvm_irq_routing
> arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
> make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
> In file included from include/linux/rculist.h:11,
>                  from include/linux/hashtable.h:14,
>                  from arch/x86/kvm/svm/avic.c:18:
> arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
> arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
>   909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
>       |                                      ^~
> include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
>   538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
> 
> Move the dependency to the same place as before.
> 
> Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

