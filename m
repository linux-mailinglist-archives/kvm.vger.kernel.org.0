Return-Path: <kvm+bounces-44940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BB6AA517A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DD0D4C70B0
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060352627F5;
	Wed, 30 Apr 2025 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TBnyiMcM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9027718
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746030012; cv=none; b=o3ATNr/wbK8qrsVxKk5fD3rO9Zs6Hw/9VS+C0aQ+6Ue41Gb07SaWRyFBCLQS6Bo78BylF+HokwWGrufDRgBmBbg5t8Rir7LvaGLUQth/FzQ0KpRtDGMMSfgrgD+TkdLZTgaad6j8ThNssol2Y5QfpuxR3YA98DwjHJn3vhfSCx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746030012; c=relaxed/simple;
	bh=dm+1GbZsrOcm2AcvE7WQn+i6gNw0Q+p5dio6jUhZrvY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YBKAo/5oYJpT9c0XAeCrXB7dET6aVo+uDGq7ASm/L+Pobcf8XGOWJaV7SdrqLCRzYBfNshfxCPuUWVBQf0s0+nEplk7Rrmer+e+vWO0tpQ0ho9VkKPARDvxvcuW7nj1ii70zZWTXA3gaD9cUU63get1AVM51fDeryIjmIOAtd1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TBnyiMcM; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c7df9b6cso89459b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746030010; x=1746634810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SYqd0GdSo7sKN0eOVySEnpJr+ZOu4vWVV2BmJ0+LyRs=;
        b=TBnyiMcMLr0FAaf3+TWs9SFQs9ZEuGBt+8zdbIuRm7O1JSe8rwn0xCj1xnogi4B7Qc
         nkN0IcAVj+CFhpV7Qmmhkot38kS0SsDrlIZJnjVNYz+x3MjNlGPjOCdpvhTretEXU/Xw
         Y8N4cTBYnkNcogx6OT30fQJnh22G/3V1v9TZUNy2hw8xLiJMIGoROhJ4RVCRHLHm77Yt
         8zUX7raObFienBuOAe4P4iY4I6la7AozBl8AtsBD8vC9mqBmjJqwwK58wiP5cuW/OWEr
         AvLeJtukkoUoCqXFweQ5TjDPCXRrX16fYyhvMLJaDVWCtydekaj5OorLx3qy4UHRB8YD
         Vuiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746030010; x=1746634810;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SYqd0GdSo7sKN0eOVySEnpJr+ZOu4vWVV2BmJ0+LyRs=;
        b=PXVgRRmLD1C1/YBuuuOiJBlAdZ6lL829bJ/Sa3KSQbdB3gckq26kwCKM/+/3KVR64P
         dYUTrJCuBLgo4gfsSbFcKeh31en9uwOqILMBhc21hhAdypgSVlZ2SRPdSPAIRT4CWYWL
         K2nkd7azyJLgeNIKCnv0tJ9p4CItntQXvgtmyoUwCt3hQGELH+ZfewlRDmy9D8J4zze3
         cvew2Xuyshp1N0yrn03+9pqHk5r59Sc/99IXVzdCbYfRLGyaiuRJqC6EZEKM3zJyffN5
         4d1XPSFBnyibKC+CdCj4Eo7qondF8XOz9gdramIrnl9iGmEbKWBxeyXCTm4XpvPhKdsq
         gDZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/Bt1CkrsITJoj/9iNKXX/DAJKl3LrW4dDsdF5u3RoZuwyII+FHmAVYs75H56qz8oStk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwX6vfdJgpSRkQfGBmU6q6dZwQicgehWoR3FF3uHz9wejiIsJqV
	9CSTueehJayNBL4wlinZnGYL8TKsnim8GEkfoygX2OLjvL8L9sZakV5zQgjEOaPd7msq+yjF65b
	++A==
X-Google-Smtp-Source: AGHT+IH6cqE3LGw37xIBZ4TrCBvOQiRuLUqMP0mbRU95s18gUWeG0RaK4DE1gC56zy/03sXH44jz18lGIe0=
X-Received: from pfbih5.prod.google.com ([2002:a05:6a00:8c05:b0:740:4436:90d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c707:b0:1fd:f8eb:d232
 with SMTP id adf61e73a8af0-20aa30d375amr5251598637.24.1746030009952; Wed, 30
 Apr 2025 09:20:09 -0700 (PDT)
Date: Wed, 30 Apr 2025 09:20:08 -0700
In-Reply-To: <b1f5bcc441b74bef6efe91da1055a3a4efe13613.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aAtG13wd35yMNahd@intel.com> <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com> <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com> <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
 <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com> <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
 <281354d3-1f04-483d-a6d0-baf6fdcec376@intel.com> <b1f5bcc441b74bef6efe91da1055a3a4efe13613.camel@intel.com>
Message-ID: <aBJMxGLjXY9Ffv5M@google.com>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chang Seok Bae <chang.seok.bae@intel.com>, "ebiggers@google.com" <ebiggers@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>, 
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, Xin3 Li <xin3.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"vigbalas@amd.com" <vigbalas@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "john.allen@amd.com" <john.allen@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Weijiang Yang <weijiang.yang@intel.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"aruna.ramakrishna@oracle.com" <aruna.ramakrishna@oracle.com>, Chao Gao <chao.gao@intel.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-04-30 at 08:01 -0700, Chang S. Bae wrote:
> > On 4/28/2025 8:36 PM, Edgecombe, Rick P wrote:
> > >=20
> > > KVM_GET_XSAVE is part of KVM's API. It uses fields configured in stru=
ct
> > > fpu_guest. If fpu_user_cfg.default_features changes value (in the cur=
rent code)
> > > it would change KVM's uABI.=20
> >=20
> > Not quite. The ABI reflects the XSAVE format directly. The XSAVE header=
=20
> > indicates which feature states are present, so while the _contents_ of=
=20
> > the buffer may vary depending on the feature set, the _format_ itself=
=20
> > remains unchanged. That doesn't constitute a uABI change.
>=20
> Heh, ok sure.

Hmm, it's a valid point that format isn't changing, and that host userspace=
 and
guests will inevitably have different state in the XSAVE buffer.

That said, it's still an ABI change in the sense that once support for CET_=
S is
added, userspace can rely on KVM_{G,S}ET_XSAVE(2) to save/restore CET_S sta=
te,
and dropping that support would clearly break userspace.

> > > It should be simple. Two new configuration fields are added in this p=
atch that
> > > match the existing concept and values of existing configurations fiel=
ds. Per
> > > Sean, there are no plans to have them diverge. So why add them.=20
> >=20
> > I'm fine with dropping them -- as long as the resulting code remains=20
> > clear and avoids unnecessary complexity around VCPU allocation.
> >=20
> > Here are some of the considerations that led me to suggest them in the=
=20
> > first place:
> >=20
> >   * The guest-only feature model should be established in a clean and
> >     structured way.
> >   * The initialization logic should stay explicit -- especially to make
> >     it clear what constitutes guest features, even when they match host
> >     features. That naturally led to introducing a dedicated data
> >     structure.
> >   * Since the VCPU FPU container includes struct fpstate, it felt
> >     appropriate to mirror relevant fields where useful.
> >   * Including user_size and user_xfeatures made the VCPU allocation log=
ic
> >     more straightforward and self-contained.
> >=20
> > And to clarify -- this addition doesn=E2=80=99t necessarily imply diver=
gence=20
> > from fpu_guest_cfg. Its usage is local to setting up the guest fpstate,=
=20
> > and nothing more.
>=20
> I'd like to close this out. I see there there is currently one concept of=
 user
> features and size, and per Sean, KVM intends to stay consistent with the =
rest of
> the kernel - leaving it at one concept. This was new info since you sugge=
sted
> the fields. So why don't you propose a resolution here and we'll just go =
with
> it.

I'm not totally opposed to diverging, but IMO there needs to be strong moti=
vation
to do so.  Sharing code and ABI between KVM and the kernel is mutually bene=
ficial
on multiple fronts.

Unless I've missed something, KVM will need to provide save/restore support=
 via
MSRs for all CET_S state anyways, so I don't see any motivation whatsoever =
in this
particular case.

