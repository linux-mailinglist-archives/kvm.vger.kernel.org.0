Return-Path: <kvm+bounces-8360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A96E184E6D1
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBD711C26786
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F2B83CD1;
	Thu,  8 Feb 2024 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QVN375MW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96A981AD7
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 17:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413453; cv=none; b=RUSDSbe6BMqu1xWPzgr5rVz+ywLaeSkgywnPrnFAw4g/EuICXg0U3UX6Is7ol2GXOEBb9IuCigshyfqNfIKwghynFNds/62RxH0nXAEPnYCH15c0bVP33JO4knWKteClZM4DQbCnNK7DwwZfS0GLlwEKJCkeeTVeiHSvKwNXhwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413453; c=relaxed/simple;
	bh=1IQJLk1ty4Cbv9srUf/jkoJhkkc0s4qbS6Kv1KMw1nQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IrxLs7WLa6pxMwN1hq6QzRS+kMnMGQ7uu+n67qJwdsoLt6DOv4FQ/B0DJMftZPjoEEitkpPUqu8s1OTIYFLiZjfRmLYEapF8Nmg3D0OUVZ1xm8nHiEP2iJCvSR63IGvF7duuHjnuk1IEgjXBo4pxH9+UeljSvyBDeew8FOwEchQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QVN375MW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707413450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6sek37PEy2MZoPmgCe0RKHy1EATtqvffN4QHzb+4/dw=;
	b=QVN375MW/3AQvPjf5bSqwLeA89/bnn96TvphKZtupSMyt6Z1uMC0q+d431Xl6P7FPLYONL
	JGQSjTPSeTjVeEjiaCqaDYJaMbAHLs9i0W3CxlpshFIPrQFl871KJbwlqTtnqVwOtIv/oT
	NscCodKhjuEinC+yjAPrM/myvm+ovC4=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-W_ydx_FzM0aPugErGtuJtw-1; Thu, 08 Feb 2024 12:30:49 -0500
X-MC-Unique: W_ydx_FzM0aPugErGtuJtw-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7d2dfa4c63dso6181241.1
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 09:30:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707413447; x=1708018247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6sek37PEy2MZoPmgCe0RKHy1EATtqvffN4QHzb+4/dw=;
        b=PzmFUTuYzfGkVQUU8uz+plxyLm86RyKqeTA+aGEE4cIK7rkLFrDOvB2/5tGPifojS7
         mss61UFC35ajniVL7V43PiK568eyNd1xi0rUE13caeHqMQq6DM+cqs+/CZ6Qv9d+CrYS
         m7xUnS9mXXKix1MjRoee+NtTTk/4yc6Q0d06v0ynsNTuy845CyBbuMnRaIpg7j6OFtCg
         ar+FqchOxyMdPWewjYUfvH1UyQvsUFUlqePLHTtncZbCKkcqP5YColYOTsHN+aNS2m6O
         SUqoHwS99XxeEgxpT9SPLZyxqN9lQ47IPrR/pjHAZXRwUMJhVVKO3eT90/pKakZgDo2S
         qvxw==
X-Forwarded-Encrypted: i=1; AJvYcCXx2DeUi07ll4L4Ro9AGNZfobmJWqqcMMukFuH8MJtg91MoyD+J/BXlqTP+mxsRvtfsjFLr9Ho8lQ7kkisMMyQ1KQpI
X-Gm-Message-State: AOJu0YyqsdHK1R7M/IbFcFX6zZPIw+mvGMdEH4ZUhBa4LH8kVx5dmOOm
	f1EJP4vC17yZkT+LJIy9xzbnyTuKLEljN4ZxdDpa1osdU9SU4Z56kjh/Vf1LtH6ByamDnAHBD3h
	aZPSoBHISCRW4Pl1TGRaO4O1LaseZRz/WMJOmDIM4Cay76xlbO3u2Q4GOuJeVT+4Fm45wj2XFXv
	pnFMxuWyHInorf+YaM0dqB8z/D
X-Received: by 2002:a05:6102:1158:b0:46d:5cb9:c3a0 with SMTP id j24-20020a056102115800b0046d5cb9c3a0mr2966155vsg.33.1707413445633;
        Thu, 08 Feb 2024 09:30:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHVJrEfvzHf07ew1SqpcL/nGkmHxsA0uPvjt9O5eXM69qEknptZPt4QM5pHUoRhFZH5bdOAnh06VotZpQb5AI=
X-Received: by 2002:a05:6102:1158:b0:46d:5cb9:c3a0 with SMTP id
 j24-20020a056102115800b0046d5cb9c3a0mr2966099vsg.33.1707413445212; Thu, 08
 Feb 2024 09:30:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231016115028.996656-1-michael.roth@amd.com> <20231016115028.996656-9-michael.roth@amd.com>
 <ZbmenP05fo8hZU8N@google.com> <20240208002420.34mvemnzrwwsaesw@amd.com> <ZcUO5sFEAIH68JIA@google.com>
In-Reply-To: <ZcUO5sFEAIH68JIA@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Feb 2024 18:30:31 +0100
Message-ID: <CABgObfa_KWVTk-yitCSU2aQi_a3vMTOMTHiT5s0qst5GtMwTzg@mail.gmail.com>
Subject: Re: [PATCH RFC gmem v1 8/8] KVM: x86: Determine shared/private faults
 based on vm_type
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	isaku.yamahata@intel.com, ackerleytng@google.com, vbabka@suse.cz, 
	ashish.kalra@amd.com, nikunj.dadhania@amd.com, jroedel@suse.de, 
	pankaj.gupta@amd.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 6:27=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> No.  KVM does not yet support SNP, so as far as KVM's ABI goes, there are=
 no
> existing guests.  Yes, I realize that I am burying my head in the sand to=
 some
> extent, but it is simply not sustainable for KVM to keep trying to pick u=
p the
> pieces of poorly defined hardware specs and broken guest firmware.

101% agreed. There are cases in which we have to and should bend
together backwards for guests (e.g. older Linux kernels), but not for
code that---according to current practices---is chosen by the host
admin.

(I am of the opinion that "bring your own firmware" is the only sane
way to handle attestation/measurement, but that's not how things are
done currently).

Paolo

> > > > +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u=
64 err)
> > > > +{
> > > > + bool private_fault =3D false;
> > > > +
> > > > + if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> > > > +         private_fault =3D !!(err & PFERR_GUEST_ENC_MASK);
> > > > + } else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> > > > +         /*
> > > > +          * This handling is for gmem self-tests and guests that t=
reat
> > > > +          * userspace as the authority on whether a fault should b=
e
> > > > +          * private or not.
> > > > +          */
> > > > +         private_fault =3D kvm_mem_is_private(kvm, gpa >> PAGE_SHI=
FT);
> > > > + }
> > >
> > > This can be more simply:
> > >
> > >     if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM))
> > >             return !!(err & PFERR_GUEST_ENC_MASK);
> > >
> > >     if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM))
> > >             return kvm_mem_is_private(kvm, gpa >> PAGE_SHIFT);
> > >
> >
> > Yes, indeed. But TDX has taken a different approach for SW_PROTECTED_VM
> > case where they do this check in kvm_mmu_page_fault() and then synthesi=
ze
> > the PFERR_GUEST_ENC_MASK into error_code before calling
> > kvm_mmu_do_page_fault(). It's not in the v18 patchset AFAICT, but it's
> > in the tdx-upstream git branch that corresponds to it:
> >
> >   https://github.com/intel/tdx/commit/3717a903ef453aa7b62e7eb65f230566b=
7f158d4
> >
> > Would you prefer that SNP adopt the same approach?
>
> Ah, yes, 'twas my suggestion in the first place.  FWIW, I was just review=
ing the
> literal code here and wasn't paying much attention to the content.
>
> https://lore.kernel.org/all/f474282d701aca7af00e4f7171445abb5e734c6f.1689=
893403.git.isaku.yamahata@intel.com
>


