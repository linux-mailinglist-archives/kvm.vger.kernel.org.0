Return-Path: <kvm+bounces-24321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6784D953907
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 19:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 829B51C25795
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 758C37346F;
	Thu, 15 Aug 2024 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9xqtquZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7FC4D9FE
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723743108; cv=none; b=quYywN0m+0eR7S/YTcvSuFwx27PxbsSVaK0CShvwo9eHMA2mojDbdXdtONeri5xr9eFUp5YcKu1sTEVayLc0CfzPpNMYLIYC3uGM0sPFPC7zGAFo2lTWn0oFMrhFOWP81wRqvEKO9tYHhl1GUVG6sCAzhONoap2u7/mwwOjkkuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723743108; c=relaxed/simple;
	bh=QbXlSIN7Jb6zKr7Do8xhpv3pvluEnhYN3MIAUO+roak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BktTpvMI5eUdhqjR8Pn1KxmbsUCOm2UzeJjMtBlPrrSshJJEka0Icu1YlWjZV3oCg966nm9nKBRI/TuCFm/nLJ92T++SFk81W4foLIVzFGAOUVCoPzU3X4520pm57yygnpSp+sMfqU4HsFI7rEkQloJVUOIApPGibufSYRPa0t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9xqtquZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6af4700a594so23168887b3.0
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 10:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723743106; x=1724347906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=37F32RQuy8+0cBTW6OKKkuSelNVTFSr/zBWZTj9nXuI=;
        b=C9xqtquZtAo1tz31Fxl4sP0bAZogb8j+eJAXE3bwt00wMyF56gaMDDgJfQR9P3SRhz
         LJQ2EBG5IP+EDMr075SN1/iLxnPK9la1WTHtY1gqrg8PdIOlYp6or6uKIEzpA29/nu1q
         2vuF2oxi/wgXp2Q60j8jjx3XX1B2mbzR0JQ9pzU7kxej6snDK43DWEgSwSwS+b6i3Nhn
         u+gxHY2a09O6Sr9Sp8nLMDvTbVr+MvUrEbVwZGC6yu2QDjHlaOlUol9MDAfT4PxMR8SA
         H75Eq2Qv4SzEK4yra0Y3MK9bCcTx8rsk78ZxNNqGeo8QXOKJAD1gRfoNaCyTisgwHyP/
         59Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723743106; x=1724347906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=37F32RQuy8+0cBTW6OKKkuSelNVTFSr/zBWZTj9nXuI=;
        b=plREafgn7E90680PxyOcJzL/fCC52st+MgPGe5vgoiyVuvr+1/famcrC9v+c3YVN0J
         PNFx6gWi9cLtn5gE3NntOApYEvOJJRsIRFOw0ZFDiZwFk/KNW66OTbXMnZuxhTVoKZck
         XkJ2pm6zHYVDLibtqsQs4aOqoDwunFPqvJEQ0NVhHDPVGU5D42D4rlu7hTOZirZGLuD+
         Ea3QaEdQy81XBAWK+EYuHiisjPapwHVaUGoZFwAsuv5WG/5jkaDPwXY4wdBFXFRYANHA
         BLNubyWbcDMQHP2TEDNW+uYlm7S6MxOdLXa1SKnm8Z0smIUZnQtvTRw9wvnNBw6irH5j
         RS4A==
X-Gm-Message-State: AOJu0YzNOi2CAPLau/kEa9Ge4VZuihzYlECV1ggUwluw07JksnmEcVPs
	UwI+D9G+oHpkRZEBnNExdiDyYbbd+BTPM/5gQHvcRyRyO8mtYo1bvwBI18OyjxyjwLlU+JDrpJ2
	8ug==
X-Google-Smtp-Source: AGHT+IFcExSDSrYqJfIAeCJVnOPaRKoHoSW2taeGhC9rK65ohx19AQTb8ulOz1IcFs0HZt63/1LzBvs8k7k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:7690:b0:69b:2f8e:4d10 with SMTP id
 00721157ae682-6b1bbe2eb40mr149967b3.7.1723743106134; Thu, 15 Aug 2024
 10:31:46 -0700 (PDT)
Date: Thu, 15 Aug 2024 10:31:44 -0700
In-Reply-To: <20240522001817.619072-19-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522001817.619072-1-dwmw2@infradead.org> <20240522001817.619072-19-dwmw2@infradead.org>
Message-ID: <Zr47gM9HWnzG9aN9@google.com>
Subject: Re: [RFC PATCH v3 18/21] KVM: x86: Avoid gratuitous global clock
 reload in kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Durrant <paul@xen.org>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Daniel Bristot de Oliveira <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jalliste@amazon.co.uk, sveith@amazon.de, zide.chen@intel.com, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit d98d07ca7e034 ("KVM: x86: update pvclock area conditionally, on
> cpu migration") turned an unconditional KVM_REQ_CLOCK_UPDATE into a
> conditional one, if either the master clock isn't enabled *or* the vCPU
> was not previously scheduled (vcpu->cpu == -1). The commit message doesn't
> explain the latter condition, which is specifically for the master clock
> case.

It handles the first load of the vCPU, which is distinctly different from CPU
migration.

> Commit 0061d53daf26f ("KVM: x86: limit difference between kvmclock
> updates") later turned that into a KVM_REQ_GLOBAL_CLOCK_UPDATE to avoid
> skew between vCPUs.
> 
> In master clock mode there is no need for any of that, regardless of
> whether/where this vCPU was previously scheduled.
> 
> Do it only if (!kvm->arch.use_master_clock).
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 32a873d5ed00..dd53860ca284 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5161,7 +5161,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		 * On a host with synchronized TSC, there is no need to update
>  		 * kvmclock on vcpu->cpu migration
>  		 */
> -		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
> +		if (!vcpu->kvm->arch.use_master_clock)
>  			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);

I believe this needs to be:

		if (!vcpu->kvm->arch.use_master_clock)
			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
		else if (vcpu->cpu == -1)
			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);

or alternatively do KVM_REQ_CLOCK_UPDATE during vCPU creation (hotplug?).

>  		if (vcpu->cpu != cpu)
>  			kvm_make_request(KVM_REQ_MIGRATE_TIMER, vcpu);
> -- 
> 2.44.0
> 

