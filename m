Return-Path: <kvm+bounces-24234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F039529DD
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 09:27:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 134701C2113C
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 07:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5F9F15E5D4;
	Thu, 15 Aug 2024 07:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DkmNQfmp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494C81990DA
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723706845; cv=none; b=lVxZcnzs+ArmtbdX8Atpj2SoftU+tZVDL1Udw9UJjhDVPk+rTKy8fXee9+TDpij5afj+1vg50KKKKGH8eNahonh223iJpDp/kc4XDDSh77Fk2xW9qG8/sSIm4LH2pMx0Jj7+98kl3pxC7sXNB80G8hmRak4apMk/rqFw47tX2C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723706845; c=relaxed/simple;
	bh=6QJJn5b6f0l+ilD2qxo5fUbwkkKew80w/ezKJNlfOTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RO9OdAKhCI7Us8+hJnaXxbxNM3/hS2AJGFT7C861wWdZBC6egV0IQCReQxKtFoaECoc0k+tz6TTGj7N4zCkXFrjw+KDI+Xe3MkgV8UxcnkiGRxaOj7Cv8XrVsLNVNmJShAIKyhNdvQyp4nofD0WqVKbpXNZgMmAecdpsXmYBPH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DkmNQfmp; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-367963ea053so418172f8f.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 00:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723706842; x=1724311642; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pXJzm0D10WfLU9z0++7Jp9e2VIC6jCXOZwkG9G3TV6A=;
        b=DkmNQfmpgDCoUQso1mwsL/DOZtbqd1+yE/zguR8YqK+7Fi9QlJg7pTqrHwbWNg+eYd
         PG1qTAKwwVUJjf/jQ1PZAYbzUF18HLFaGzohZdBE0ZnspP2llW9FA1YSHbZyNsi95upK
         DxKssm9P2y7YK50dawbFBr1qR5hDGZZ3iIGLNK6TufSNsP6xlaJVfLGE9I9daYgPPkss
         bhUSnjAHQub3NEf27cj86+4gqxhJwqnn4tX0YSpuncRulzieYg37zz8xqUXMPKSX6GIO
         dfAdokbMKJMnghRlEMaoMHLAPMqkNkd/jIal9b0S4A5XTBnI5Li0PeTG8mLu4Uki1Ekg
         cJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723706842; x=1724311642;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXJzm0D10WfLU9z0++7Jp9e2VIC6jCXOZwkG9G3TV6A=;
        b=QZm/7oue3yPHs21Yoc7wrLJkD1cK3fHpJ/3wgnZZui8bq2iRuiqCU+W0WEfeSqwOwl
         zdOIGsbIU/yHvkYWqemlAq1jQQm/JYDccw80qAN2bYj5BbhlBvD8sLlLRDihixM8jNe3
         b+tscaxiQ19PDBfXzO12d6n7tWc6MA0T8Q2Np5I5BhoXCm5L5jrXpjwTsfpwWGH7rfFF
         sb1rtFKG7ct5jAW9PIOKwVuMqV3F4LrmbpFbF+dYvWVQMAlw1rjo0he+LS8qAJAYzZQq
         XnkT+sw/YoAEo8ychclw8Cqz2YeDP6atkfZT1hQmriTB5dcWQqGZLlU2OOSrrP53i8Hr
         5ZEQ==
X-Gm-Message-State: AOJu0YyOyDmIuSwkXvV73xxgXvTXg/JZpfmITZiM20dr9bsRryf5Jvt3
	44MB7dqM7t2INEW7HWpytCYd7ctj5+7tzeyR0GI2SvjFg7u5O12rE3ispXvjzRrzaELgu078GY8
	qQRaZTA9EmMZIc2S4xX7To9HnJfA2NSfphVyX
X-Google-Smtp-Source: AGHT+IH6naSRz220SzN8RarZSndGjV+CeULQ4qqyqInU1++JS55z0LhTf5shflkfmNPy3v60d0PC6kZ+l6KMyILMVYE=
X-Received: by 2002:adf:f283:0:b0:368:3b5c:7a5d with SMTP id
 ffacd0b85a97d-3717775c4c3mr4945906f8f.20.1723706842239; Thu, 15 Aug 2024
 00:27:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com> <20240801090117.3841080-10-tabba@google.com>
 <910085c1-c29c-4828-853c-70760b458086@amazon.co.uk>
In-Reply-To: <910085c1-c29c-4828-853c-70760b458086@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 15 Aug 2024 08:26:45 +0100
Message-ID: <CA+EHjTztRO0x4yMGjm9amshaQ3sThuWePVnF0QUGzFR=M_Kjyw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/10] KVM: arm64: arm64 has private memory support
 when config is enabled
To: Patrick Roy <roypat@amazon.co.uk>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Thu, 15 Aug 2024 at 07:27, Patrick Roy <roypat@amazon.co.uk> wrote:
>
> Hi Fuad,
>
> On Thu, 2024-08-01 at 10:01 +0100, Fuad Tabba wrote:
> > Implement kvm_arch_has_private_mem() in arm64, making it
> > dependent on the configuration option.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 36b8e97bf49e..8f7d78ee9557 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1414,4 +1414,7 @@ bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
> >                 (pa + pi + pa3) == 1;                                   \
> >         })
> >
> > +#define kvm_arch_has_private_mem(kvm)                                  \
> > +       (IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
> > +
>
> Would it make sense to have some ARM equivalent of
> KVM_X86_SW_PROTECTED_VM here? Both for easier testing of guest_memfd on
> ARM, as well as for future non-coco usecases.

I don't really have a strong opinion about this. I thought that
if/when that were to happen, it would be trivial to modify this macro.

Cheers,
/fuad

> >  #endif /* __ARM64_KVM_HOST_H__ */
> > --
> > 2.46.0.rc1.232.g9752f9e123-goog
> >
>
> Best,
> Patrick

