Return-Path: <kvm+bounces-9550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DFD861871
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CBD92848AD
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00874128815;
	Fri, 23 Feb 2024 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bVBB2U3Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965DF12839B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708706929; cv=none; b=uZPh4a6fj//SNAhv8Wt8w+xy+Um9HCA5bz2oCK75nNAo0fDWw5mgAFBUTNUFncjKBjROuGAqPvPSU3iJZFXq0evWlF0tupCuymCCs39vMiXfi+H6t0kaQ/XyxEAQJg4QQ6c7XJY3i1PV7U6BZ7mkCYZc4bcREtYB3S0U5Fxqou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708706929; c=relaxed/simple;
	bh=NL6Poyql//ChqFYnAITXk/nlto//1JQfy0RIuysn5XY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkBHw9wykEZ6csnXvQdC2qZJHytlWngzv9AUjF6iNDkg09JTZ6Ph1GDiXg1W2y/lXGRm/gFoO/lYM8j4W4Z95ZPmdLBl/l8n+3lscgq4v3oPLlGLOu8I/nZxMbocPKr9apCxqHI1Qq2eYWOv2JrKkzQ7l5bb8FiYsxOPJHD69jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bVBB2U3Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708706926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWTBT8l0r4+LfEgX4DGPyzuq25NZlKjkAYRK5GPaE0Y=;
	b=bVBB2U3ZJcTcbYtXszi0oAmbH4VRoS0CkMQ1tdxfvyMxCJo7kvAcoKCBD0R4v5K7kUypQq
	ojRfpwyO5StiL7hGcz+mqlHq+die8VNBqCtuFp/gV0o3Or42AKBwDGBfYg5l6xpcZCWolk
	FZpD+S3Nd/TUwcsuQ7rWXgAV12YtS8w=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-hA2uSj0wNOqI9bZmWx_CoQ-1; Fri, 23 Feb 2024 11:48:45 -0500
X-MC-Unique: hA2uSj0wNOqI9bZmWx_CoQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2d2654a942cso8107061fa.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:48:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708706903; x=1709311703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lWTBT8l0r4+LfEgX4DGPyzuq25NZlKjkAYRK5GPaE0Y=;
        b=LYwRgL9G2rtoFfCfHhh6fw+qSSyLb8zen+3/WcRV57/RruAt2WFW0/dxasVvUQzb63
         Lvhz9omZbG1WuHozXOpZC4ES4GgG4LIDxeeQd7yIev51aFlrsjFnZx2rI9d+TQXnTRN3
         0VPwzZozYylLaoyVT0rjfPKwU7LYzkmIMnXITkF46A1/gc2r3L2ln0LbNrpKYAL4Wj0b
         bo8tGeQruxw2UygCP0c5UMkDU7kZXvRywJO57jeB2JzxTNBAOtaum+7iB0CZF+NolTWj
         yZR+Cvljp2Owp5EYZCA7zfywm3sSMQ3Mp5XMpS263kDptZBlmbRtahxuvCk6nC9cqjnJ
         THZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFW1jLaJkanLURsuWolOxt1QNuoru6fgZtH0KZvTLFfSN9u9C6m4fIOslStab6+SJ7kHWRMz0AhflKGPNOMjQcRWfx
X-Gm-Message-State: AOJu0YwUqw5gvlfKRu7St+AsewKg/n/nrzbZHFB24lWy+yaEhBsEx5oz
	c551WNGTicIEbsVkKyxeS0TGnfWbMGwd2p4Z0gxjXuEEb6NrfWhh98adt1rCMsaNdQmfOgAOKsK
	fOeT8lACuLcTWNwUA1Fhyh5gFV8SCv17Kk9x3pko+OQn2tPFSuc5H5THEIp2nDCbd5g2lmKDzsp
	/GO0+Tah8WnEY5KdZI0893EvlMeyNMop/e
X-Received: by 2002:a2e:97cf:0:b0:2d2:3b61:a2b with SMTP id m15-20020a2e97cf000000b002d23b610a2bmr240917ljj.11.1708706903115;
        Fri, 23 Feb 2024 08:48:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3L8Jq/Pr0xzR++9DOj5OHGNQPCSNmFwB1mlOHfr9+KdeJXsyxiieOyfL6BKk400aamUP6IrcyHDkdN1To+jY=
X-Received: by 2002:a2e:97cf:0:b0:2d2:3b61:a2b with SMTP id
 m15-20020a2e97cf000000b002d23b610a2bmr240905ljj.11.1708706902739; Fri, 23 Feb
 2024 08:48:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-8-pbonzini@redhat.com>
 <ZdjL783FazB6V6Cy@google.com>
In-Reply-To: <ZdjL783FazB6V6Cy@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 23 Feb 2024 17:48:10 +0100
Message-ID: <CABgObfYF4pyUDpf0E98xqoJkDsjwXuViasoib-CbB0MUtRNBuQ@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] KVM: x86: define standard behavior for bits 0/1
 of VM type
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 5:46=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> > Some VM types have characteristics in common; in fact, the only use
> > of VM types right now is kvm_arch_has_private_mem and it assumes that
> > _all_ VM types have private memory.
> >
> > So, let the low bits specify the characteristics of the VM type.  As
> > of we have two special things: whether memory is private, and whether
> > guest state is protected.  The latter is similar to
> > kvm->arch.guest_state_protected, but the latter is only set on a fully
> > initialized VM.  If both are set, ioctls to set registers will cause
> > an error---SEV-ES did not do so, which is a problematic API.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  9 +++-
> >  arch/x86/kvm/x86.c              | 93 +++++++++++++++++++++++++++------
> >  2 files changed, 85 insertions(+), 17 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 0bcd9ae16097..15db2697863c 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2135,8 +2135,15 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_=
t new_pgd);
> >  void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >                      int tdp_max_root_level, int tdp_huge_page_level);
> >
> > +
> > +/* Low bits of VM types provide confidential computing capabilities.  =
*/
> > +#define __KVM_X86_PRIVATE_MEM_TYPE   1
> > +#define __KVM_X86_PROTECTED_STATE_TYPE       2
> > +#define __KVM_X86_VM_TYPE_FEATURES   3
> > +static_assert((KVM_X86_SW_PROTECTED_VM & __KVM_X86_VM_TYPE_FEATURES) =
=3D=3D __KVM_X86_PRIVATE_MEM_TYPE);
>
> Aliasing bit 0 to KVM_X86_SW_PROTECTED_VM is gross, e.g. this
>
>  #define KVM_X86_DEFAULT_VM     0
>  #define KVM_X86_SW_PROTECTED_VM        1
> +#define KVM_X86_SEV_VM         8
> +#define KVM_X86_SEV_ES_VM      10
>
> is _super_ confusing and bound to cause problems.
>
> Oh, good gravy, you're also aliasing __KVM_X86_PROTECTED_STATE_TYPE into =
SEV_ES_VM.
> Curse you and your Rami Code induced decimal-based bitwise shenanigans!!!

v1 was less gross but Mike talked me into this one. :)

> I don't see any reason to bleed the flags into KVM's ABI.  Even shoving t=
he flags
> into kvm->arch.vm_type is unncessary.  Aha!  As is storing vm_type as an =
"unsigned
> long", since (a) it can't ever be bigger than u32, and (b) in practice a =
u8 will
> suffice since as Mike pointed out we're effectively limited to 31 types b=
efore
> kvm_vm_ioctl_check_extension() starts returning error codes.
>
> So I vote to skip the aliasing and simply do:

Fair enough.

Paolo


