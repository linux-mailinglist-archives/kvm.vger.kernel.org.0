Return-Path: <kvm+bounces-20157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E35911124
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F6B3B2BC5E
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42A31BA879;
	Thu, 20 Jun 2024 18:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwnA7pcP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294261AC248
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 18:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718907609; cv=none; b=IQeO7WAtaH8esiaY58b8bg3jXMF5wFW271OS+4DLf75uPFG6FZKI8E0ZR16Prpyl6Az5X0tpN+IuIiO4A43tKXvPbhz67yMf+Ikui40m3robRM88rZFEmz092Jpaff62J2/O4GHCM4X+tRf9uDDIC0DCw6cyLOfAvo5r+5k0gho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718907609; c=relaxed/simple;
	bh=khQRGm2IIvTPuqSrSgs30CpqsUmN/Mnzv6zPLM/ZIkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uTEZearjkOh/kH6OhdL7O4fp3LsQyAsQbXc8FU82oLX5AoqeLL01QLAx6r4DP7x6gKFatCDRH0Bun3UOvJysqZBPz5DPOuMLqHLCcxxTIzPPMMgjKizwI0KzwMHZs9cdW71NXv/C67AfJAWafQX2J9Tx/1kJ/x4yGwcgfZRIV6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwnA7pcP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718907601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJbj8T1+UF7UMbUX9/SXZw2NvaJoZhTmvFC29onkHsI=;
	b=HwnA7pcPOXneZfIwWjaArJ0aj88cW+r+3/JiwH/AgvlNx6577+EfWhf05OfZZ2sLbPdRGZ
	z0AG+1jbLPIEVppV+kp9vO3PWRz6fNq4fNr8O1+vGgCFdeQyQCBFdl+K/meNDwmGFT1ybe
	5OMUNE+NM93wnGlV65U7SGNEJFvT18U=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-nGC93KAMPTOJyoizuC8fTQ-1; Thu, 20 Jun 2024 14:20:00 -0400
X-MC-Unique: nGC93KAMPTOJyoizuC8fTQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52c968340c8so1073821e87.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:19:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718907598; x=1719512398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJbj8T1+UF7UMbUX9/SXZw2NvaJoZhTmvFC29onkHsI=;
        b=U6dAsHzDztlTX9b70u/YXiI3/S/QomgFAUHKMJHMzf87i972FDd/6kgPBDNQEZBqk5
         flo15p2BfkD7Cn25Bhx+0DnXxck5zSxALndXUurNbUITFgfTSomz872g1zigVMu5ZPZc
         youMjwt6K/uA7VemHfuAC9szpB/Kx0sN2dt8fymoC1H6oOKlMXfwtf3J5wZoejERxpFG
         i3b3hEF3IRNvgbEWmlXntbFhGt1oGENWzXU+AU3xR68cVq2CjQlRIDp+RcQPrCjr6h1h
         1lzXgf6296FqVOY1SqxlrvlVWPiwOjE70psjVDbphbC5kHQDP3XixAQzuZfFdCDHy9Xh
         /qDg==
X-Gm-Message-State: AOJu0Yy48eWde5SQx+XptnPrvTmH9ukFdzTXdHaLotpaXRRDA++XJ+gy
	X9XKne4TiMTYpTW9msSyAPRNnWsAIN5FWljKBJr3uYNFOuJ9OLppXWkJZzbloyc8+tJN92mtw6w
	eepJXjYLmFjZsyASOVxALKDacHZ5RbTZnLxw/QHM1dZXZhTi2HLlQ4RbEzy8DdGiorArRlHOf9i
	bmm/+AMu7vjm7fufEdUPewptk6a/S0yCcY
X-Received: by 2002:a05:6512:76:b0:52c:84a7:f9d5 with SMTP id 2adb3069b0e04-52ccaa5a0abmr3668069e87.69.1718907598348;
        Thu, 20 Jun 2024 11:19:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6QuwIFl7cNwfX3vPqB6O2YrcoQ8M+a+1NklUV4rEQP2gvoki6RiOGp2+FRboLJ5Yeo6yiF3Nh56sGQTj8yoU=
X-Received: by 2002:a05:6512:76:b0:52c:84a7:f9d5 with SMTP id
 2adb3069b0e04-52ccaa5a0abmr3668054e87.69.1718907597942; Thu, 20 Jun 2024
 11:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240608001003.3296640-1-seanjc@google.com>
In-Reply-To: <20240608001003.3296640-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 20 Jun 2024 20:19:46 +0200
Message-ID: <CABgObfZSAGU18Yg3yQrfQfOM4AsL5y6VHZcJn3Z9UsosfF_R1w@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Remove unnecessary INVEPT[GLOBAL] from hardware
 enable path
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 8, 2024 at 2:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Remove the completely pointess global INVEPT, i.e. EPT TLB flush, from
> KVM's VMX enablement path.  KVM always does a targeted TLB flush when
> using a "new" EPT root, in quotes because "new" simply means a root that
> isn't currently being used by the vCPU.
>
> KVM also _deliberately_ runs with stale TLB entries for defunct roots,
> i.e. doesn't do a TLB flush when vCPUs stop using roots, precisely becaus=
e
> KVM does the flush on first use.  As called out by the comment in
> kvm_mmu_load(), the reason KVM flushes on first use is because KVM can't
> guarantee the correctness of past hypervisors.
>
> Jumping back to the global INVEPT, when the painfully terse commit
> 1439442c7b25 ("KVM: VMX: Enable EPT feature for KVM") was added, the
> effective TLB flush being performed was:
>
>   static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
>   {
>           vpid_sync_vcpu_all(to_vmx(vcpu));
>   }
>
> I.e. KVM was not flushing EPT TLB entries when allocating a "new" root,
> which very strongly suggests that the global INVEPT during hardware
> enabling was a misguided hack that addressed the most obvious symptom,
> but failed to fix the underlying bug.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0e3aaf520db2..21dbe20f50ba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2832,9 +2832,6 @@ int vmx_hardware_enable(void)
>                 return r;
>         }
>
> -       if (enable_ept)
> -               ept_sync_global();
> -
>         return 0;
>  }
>
>
> base-commit: af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a
> --
> 2.45.2.505.gda0bf45e8d-goog
>


