Return-Path: <kvm+bounces-17715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1368C8E40
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 00:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 375202831B7
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 22:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9BD1420A2;
	Fri, 17 May 2024 22:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cs65yOiU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B8314036E
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 22:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715983521; cv=none; b=gLOL9+cFKs9xV/kcsgbUvyatVcTEGSI9Fj5OBmOk+XL0cHKOjX+8CO3pCwfb/58f6D5F6VgDhE97KuBiYYq++lvGd43Re+FBKLLkk8nrLaE19aCU7Rr0york+ocHRKoqk1Ir562f8+5IO8I9kppbxMRWEl+OXilkeP9mLYHIM6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715983521; c=relaxed/simple;
	bh=AHx8CIhs2HHm+fB0sCzYsJzW+7XsKO52cFDTr2C0qY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f2FfeasbEPcmGZrWuLQX8PknZ+o56cVdLMGnEprzs2UfI7uXgmeXTqWkZ1xWvyL3ulU7HwJRLTRreoUgTYDJYzP5AW5oq9RPy+L/NRzPUUPq3aJc48yWoVwm8GcwcdCZ19f3cYuGpiV+OBjVumS2AnxF0uy9eE5CfR5lnmuILOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cs65yOiU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715983518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zt2YQ8as06qnba86WmttjcIU7BwJ2cSLKT1s3ZSljEo=;
	b=Cs65yOiUvFNlreTHDFQS9TOKfsYJsf7xBE8mH86xFPPfui6KT63kZg/FTLCvMsyG6HbUzb
	ldcY5SBMYKdMKKXRpVDW2gGgeivxmAMiFZDyUk7YYPsZ/Ml0UeKpVDTx9rxhB1rxssZwat
	QLdBDp+GE5y3A8zL9vJja/H87tKVRzs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-CDQ5v200PIqvJ_7LxbPDvQ-1; Fri, 17 May 2024 18:05:16 -0400
X-MC-Unique: CDQ5v200PIqvJ_7LxbPDvQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-34db1830d7cso4255242f8f.1
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 15:05:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715983515; x=1716588315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zt2YQ8as06qnba86WmttjcIU7BwJ2cSLKT1s3ZSljEo=;
        b=Qlji8k26NnI72niq1nLd4UOjRvm1j2fT+sbrMGs2GWyvpJj+f1N19eeUYb1f7MSipB
         cqIuba2H9ra6PCBCa7kPBOstxw2fIGZp6kFdv76SIkdBtmE3dEdWjwYmMcK33j11JQZA
         bPND/uGSwED4VcL8XaBhgAdhFV+EQh6GG7nAHn2KUbtFAPgiqPUUeIC8woUZr73OCxTM
         9YMfUJXjtjqpGAv5OUiIiMnXoQr+WE6Jucj/adf4DOgz6pYu+HTkxeMtHH1I6GSmTihE
         QOwYpE3wdraupQLhong/5dZHkoIU9hqV084nPTqRGVt6y/1YyMcMPPQRyiZZU42JOYZ3
         g6pg==
X-Forwarded-Encrypted: i=1; AJvYcCXVfPCL2mRyiQDFrAqp0rZnKaig6qy2s5ZpovycwdjVpTna4YsvsdCW86Pi2Jj45KHuDwJhmxBRRoamW7uUQjZbP910
X-Gm-Message-State: AOJu0YzHuQQm6hSkR3CtQpi8u5epbO8O2SeVbDrbHEJeOStwMu1BzObf
	7OkXmvhX+QwWQpkyhomwjofcMDJZS2aUQWl2VSWOleObLsQZVJVjCP9vCLQnWU9xw4Wk+AwA2dW
	fDj2pZBP8fPamVySfKi1fcXevswgPmah6Mn/fq9AI2q7i3WJks3MbypbaXr7j7cY0BBYGLnaU1V
	YYMFU0RpGYYxPDmJXqBwDqhD3ebqUOUrp+bzE=
X-Received: by 2002:adf:cb14:0:b0:34c:f87b:f9fb with SMTP id ffacd0b85a97d-354b8e677aamr269060f8f.25.1715983515288;
        Fri, 17 May 2024 15:05:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCykS6wvyjHIXN8dpfn4UDJzkZBOEpL4smez8eBByWg6Ebpx8Upm7/QjviJimReTQbmgO7ksC6tbxtT31lW1g=
X-Received: by 2002:adf:cb14:0:b0:34c:f87b:f9fb with SMTP id
 ffacd0b85a97d-354b8e677aamr269052f8f.25.1715983514904; Fri, 17 May 2024
 15:05:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240507154459.3950778-1-pbonzini@redhat.com> <20240507154459.3950778-8-pbonzini@redhat.com>
 <ZkVHh49Hn8gB3_9o@google.com> <7c0bbec7-fa5c-4f55-9c08-ca0e94e68f7c@redhat.com>
 <ZkeH8agqiHzay5r9@google.com> <2450ce49-2230-45a2-bc0d-b21071f2cce6@redhat.com>
 <ZkefU_PhjvnaEE7Q@google.com>
In-Reply-To: <ZkefU_PhjvnaEE7Q@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 18 May 2024 00:05:01 +0200
Message-ID: <CABgObfYwxN7yoRUDfYVPb57=p90nUqfW9+y_=Ndeg4oXKaZNQg@mail.gmail.com>
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2024 at 8:18=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > Ok, so it does look like a CPU issue.  Even with the fixes you identifi=
ed, I
> > don't see any other solution than adding scary text in Kconfig, default=
ing
> > it to "n", and adding an also-very-scary pr_err_once("...") the first t=
ime
> > VMPTRLD is executed with CONFIG_KVM_INTEL_PROVE_VE.
>
> I don't think we need to make it super scary, at least not yet.  KVM just=
 needs
> to not kill the VM, which thanks to the BUSY flag is trivial: just resume=
 the guest.
> Then the failure is "just" a WARN, which won't be anywhere near as proble=
matic for
> KVM developers.
>
> If we don't have a resolution by rc6 or so, then maybe consider doing som=
ething
> more drastic?
>
> I agree that it should be off by default though.  And the help text shoul=
d be
> more clear that this intended only for developers and testing environment=
s.
>
> I have a handful of patches, including one to not kill the VM.  I'll try =
to post
> them later today, mostly just need to write changelogs.
>
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 75082c4a9ac4..5c22186671e9 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -98,15 +98,15 @@ config KVM_INTEL
>
>  config KVM_INTEL_PROVE_VE
>          bool "Check that guests do not receive #VE exceptions"
> -        default KVM_PROVE_MMU || DEBUG_KERNEL
> -        depends on KVM_INTEL
> +        depends on KVM_INTEL && KVM_PROVE_MMU
>          help

"depends on KVM_PROVE_MMU" is wrong, I think.  I'd like to keep it
enabled without slowing down too much the VMs, for example.

On the other hand "default DEBUG_KERNEL" is definitely too heavy
with these CPU issues.

Paolo


