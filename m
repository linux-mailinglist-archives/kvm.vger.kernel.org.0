Return-Path: <kvm+bounces-43203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BEEA87391
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 21:30:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF6F11891BAA
	for <lists+kvm@lfdr.de>; Sun, 13 Apr 2025 19:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F4A51F3BBF;
	Sun, 13 Apr 2025 19:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="XgkyhXzY"
X-Original-To: kvm@vger.kernel.org
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6954C6BFCE;
	Sun, 13 Apr 2025 19:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744572606; cv=none; b=UmPTxU9VJYDBDawJHhR5ATXWKxlLYt+OvgiLwSburLgnfugKGxmtZT/pPQil3bazLnkMTJ5aXBmroGfBXXQWTkOxz1tU7VXrrOmJAJn78uuONeeNFajiu4X7VlkXKStbb71spxGa4AsBr2C+rhNKb5Eppp6uGbjVzJ/AlsJag8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744572606; c=relaxed/simple;
	bh=Q9hjF78YBfIyaPMAAV+P9SR2EaJNjK9taOBU/PZb7bA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3RJMlZj1/G42bmHj1WRji+UvQDz0TYg0TrAB02NUfO9oEZ+xqXSO9dlo72gbhO8JuRHezUGAQ8gRojLg9q0fkWgD0xORTPaz8nHUKLDgQXVcB+okEbTccRSDb8+ib7CQLa/zrUyBikPZxiXxt3nPwWKJflhRHXtOTBJLQhrkK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=XgkyhXzY; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Received: from localhost (unknown [10.10.165.22])
	by mail.ispras.ru (Postfix) with ESMTPSA id 050BC448786F;
	Sun, 13 Apr 2025 19:29:57 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 050BC448786F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1744572598;
	bh=oSDku4H8iTUPS58k8kaH8zVIp74ty/b9S7j0T7cs/Hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XgkyhXzYtPBlZpnDrRYOkXhN9+jgx3oJXvW4SZ7C4ph17B6HSElNHi3rdlKS9U0RL
	 D3CZAA6X4bjtqoVPenOm6ar1PBqi7Z4+iMRii0KH/O/sj/RhOnd64btvjuPC5N5k7g
	 7fdrQ8DKD5K6XxLz0yVKUEulmzS6vLlQzp33Q578=
Date: Sun, 13 Apr 2025 22:29:57 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: Sean Christopherson <seanjc@google.com>, x86@kernel.org, 
	lvc-project@linuxtesting.org, kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] KVM: SVM: forcibly leave SMM mode on vCPU reset
Message-ID: <xo6u5domb5y73v3nov5zbhrw26xvotpc64qjn6gv6zfqgew5sk@ado7wo4qo5yl>
References: <20250413115729.64712-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250413115729.64712-1-m.lobanov@rosa.ru>

On Sun, 13. Apr 14:57, Mikhail Lobanov wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d5d0c5c3300b..34a002a87c28 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2231,6 +2231,8 @@ static int shutdown_interception(struct kvm_vcpu *vcpu)
>  	 */
>  	if (!sev_es_guest(vcpu->kvm)) {
>  		clear_page(svm->vmcb);
> +		if (is_smm(vcpu))
> +			kvm_smm_changed(vcpu, false);
>  		kvm_vcpu_reset(vcpu, true);
>  	}

This won't compile without CONFIG_KVM_SMM=y being set.

arch/x86/kvm/svm/svm.c: In function ‘shutdown_interception’:
arch/x86/kvm/svm/svm.c:2235:25: error: implicit declaration of function ‘kvm_smm_changed’ [-Wimplicit-function-declaration]
 2235 |                         kvm_smm_changed(vcpu, false);
      |                         ^~~~~~~~~~~~~~~



allmodconfig build which, on the other hand, does have

  CONFIG_KVM_AMD=m
  CONFIG_KVM_SMM=y

also fails with the patch at the current mainline tip.

ERROR: modpost: "kvm_smm_changed" [arch/x86/kvm/kvm-amd.ko] undefined!
make[2]: *** [scripts/Makefile.modpost:147: Module.symvers] Error 1
make[1]: *** [/home/kc/ISP/Kernel/linux-stable-allmod/Makefile:1959: modpost] Error 2
make: *** [Makefile:248: __sub-make] Error 2


Looks like the fix in its current form requires some ifdef'erry and
EXPORT_SYMBOL***, too?

