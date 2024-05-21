Return-Path: <kvm+bounces-17856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC81D8CB2FC
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 19:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5C814B229E9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92D6B1487CB;
	Tue, 21 May 2024 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQ0CQFBK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068237F48D
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716313005; cv=none; b=E9djioo3UQHy6qTmqaMunqcVBpYSWIFs55rlMeB+OobJuwrCVLweEOu7HHzKgYubuJzdRVYC71v0QIhHZyUjkOGMZ7nwQZ78qr+R6nO1JTuTc6i6w/LHbQZNLN0y4ivOGYzrguL6vW1elxDWAbztRw9HN3+/Ikd9jrprSOQspLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716313005; c=relaxed/simple;
	bh=wd0KBKKWgEMxHkVHXyAYq++wArTKYEyiWOm/WGzUV7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QonCBsK6JlaD7LW4NORo4TmsAELyd1Ezkrp42o61KO0wr2B+7ZAwUOjEGsidJbvZiyWIwBDr4qc21tBqLqlkfrSLSH+BPHpbg+OLI7HJZK0H9b7CytbG1b+XkJs5302sHZqN8cLvkKvdffE6jPnMoZFLqO9FtwMr8oLAFIo4hyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CQ0CQFBK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716313002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q5zUpod+RhthWixXTCuMGnpnj5+irE7qQCxPAzed+KE=;
	b=CQ0CQFBKooaI3/H30Vky7syyxJJQEmadlyyh5E6UoZ8IZrPi/5rRUwih+5LlWK68DYFw2M
	uHS0EJVU7uUAgMRW/o7YJGPhZnLr/SR1PU9zcDbXoJGCxdbjGo6vnwcI/bQo6DLS7DIt7V
	EC4d8cu4Hr3Q8aQWdrURVMjAuC9ZHIA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-HlJQdfh4MsmczXYoV_N_DA-1; Tue, 21 May 2024 13:36:40 -0400
X-MC-Unique: HlJQdfh4MsmczXYoV_N_DA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41c025915a9so69083775e9.3
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 10:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716312999; x=1716917799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q5zUpod+RhthWixXTCuMGnpnj5+irE7qQCxPAzed+KE=;
        b=lc62tZTr5NfbSXVPpQZQZ1o0azIMKarRs1+mOWx8YpDys9eqMF+p4G0C8NmNIcaS6w
         PJLgZ2cuPSLh4jwjwx5unjcrCq1/dYGWMDbQZU28J8cIWO5ksSj8wS7f9CZcqVW2biIy
         A6lXCR1c/LYxqrqIAg2NiMgCkXRj7uyyTjTHaeOjSMW5jn6qF1YzbC89ExzdobE5qlOA
         R8M6HphcgG5YODM2I8cnxt60TbcBDZ/aIb7CdY1LAzsxixhN9lh2jFhJAittUMdlhYRE
         qXUfN1zYovVK9IMtfFQ4DsHOIMbbj4bdMHorwi297brp//HLjM6zp30Oq5aD50RADGd3
         YlWQ==
X-Gm-Message-State: AOJu0Yy/V7IsKfvEcFd3mjI6sN8JhTl0wWO9jzHcY8DZrrDXsRkuPtRB
	rl6cAGAiXdhkFV0+Szjlil7FWI0uVlWzuv8kL0mNcbscPSwtN2u0utNFjREIqAO5UDoUwhXF/gp
	HPZSS2/8t7w7PzKnG/dbBii7imMBcAIPT4Bh9TcG0sxNWOX6NuZtNGJxDk1x7wQeXbfFcs/6Gdv
	5Zkry9qO0emdw+YfQHJlU8XG2u
X-Received: by 2002:a05:600c:35c2:b0:41c:2313:da92 with SMTP id 5b1f17b1804b1-41fea93afeemr277991495e9.4.1716312999333;
        Tue, 21 May 2024 10:36:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGndNhJCjRsgtfdjd7EnztAR09WI4tEm4q2+MYJA7kncWp/ZgsQ/grGnsNbVM0PTqn4dlJqpJWUz3TjMCFFBjw=
X-Received: by 2002:a05:600c:35c2:b0:41c:2313:da92 with SMTP id
 5b1f17b1804b1-41fea93afeemr277991385e9.4.1716312998926; Tue, 21 May 2024
 10:36:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240518000430.1118488-1-seanjc@google.com> <20240518000430.1118488-10-seanjc@google.com>
In-Reply-To: <20240518000430.1118488-10-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 May 2024 19:36:26 +0200
Message-ID: <CABgObfYo3jR7b4ZkkuwKWbon-xAAn+Lvfux7ifQUXpDWJds1hg@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: x86: Disable KVM_INTEL_PROVE_VE by default
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 18, 2024 at 2:04=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
> Disable KVM's "prove #VE" support by default, as it provides no functiona=
l
> value, and even its sanity checking benefits are relatively limited.  I.e=
.
> it should be fully opt-in even on debug kernels, especially since EPT
> Violation #VE suppression appears to be buggy on some CPUs.

More #VE trapping than #VE suppression.

I wouldn't go so far as making it *depend* on DEBUG_KERNEL.  EXPERT
plus the scary help message is good enough.

What about this:

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index b6831e17ec31..2864608c7016 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -97,14 +97,15 @@ config KVM_INTEL

 config KVM_INTEL_PROVE_VE
         bool "Check that guests do not receive #VE exceptions"
-        depends on KVM_INTEL && DEBUG_KERNEL && EXPERT
+        depends on KVM_INTEL && EXPERT
         help
           Checks that KVM's page table management code will not incorrectl=
y
           let guests receive a virtualization exception.  Virtualization
           exceptions will be trapped by the hypervisor rather than injecte=
d
           in the guest.

-          This should never be enabled in a production environment.
+          Note that #VE trapping appears to be buggy on some CPUs.
+          This should never be enabled in a production environment!

           If unsure, say N.


Paolo

> Opportunistically add a line in the help text to make it abundantly clear
> that KVM_INTEL_PROVE_VE should never be enabled in a production
> environment.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2a7f69abcac3..3468efc4be55 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -97,15 +97,15 @@ config KVM_INTEL
>
>  config KVM_INTEL_PROVE_VE
>          bool "Check that guests do not receive #VE exceptions"
> -        default KVM_PROVE_MMU || DEBUG_KERNEL
> -        depends on KVM_INTEL
> +        depends on KVM_INTEL && DEBUG_KERNEL && EXPERT
>          help
> -
>            Checks that KVM's page table management code will not incorrec=
tly
>            let guests receive a virtualization exception.  Virtualization
>            exceptions will be trapped by the hypervisor rather than injec=
ted
>            in the guest.
>
> +          This should never be enabled in a production environment.
> +
>            If unsure, say N.
>
>  config X86_SGX_KVM
> --
> 2.45.0.215.g3402c0e53f-goog
>


