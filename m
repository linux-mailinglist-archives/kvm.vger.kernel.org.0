Return-Path: <kvm+bounces-28464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4D6D998D48
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61386281AA6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC671CDFD1;
	Thu, 10 Oct 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Skua3cm0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC37DA62
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577466; cv=none; b=QSDYbSEuq9KT02rUboE2PQDdsm7rl/ob9wkVBWZICqbJFXHc+UiPKolF5tPOC4B3kSu9tM4SYwqNiXhYEWnPCTCo7v3v1IO14wlP0NGBs6mn1OPpwgrbZclGlf0epF4HC/CAHy0qdA732i7JMnpJgEB04IhSvRC23NIbVSAqzVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577466; c=relaxed/simple;
	bh=QBVdNb4X6f8yuV8IA5V+zDgeVHF/4N7Vou4Rtba1u8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4ShD2l0wjaC/TbWdVm09TTghONQs1TMho0mZPtDAIPHFhl4FE1N7ZdMlabj+zqRIvejS8va84pfmQg1HDQc1kXVPvFgwrdRDL7ot9FIvqVkgzwZ140vDh0D4JX+o4VhreQXgIeJI1eNyTWqkK4OtqAblVWBPd1yojoCDgyzBI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Skua3cm0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728577463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HqKXpH36dfv9uG+fY8ea1xXDrNeQHdPWULm3fpYA1qI=;
	b=Skua3cm093EuKt1YmNMeEeY6JZPd9TT5kAu8RxbrfKfGU2y1wWZoGofJ466ayADIn+QTvX
	XqzplZ2xet9KqQCb7CeGtjG99tPNNSPeFiPLP3p8MCmMU0ZVAdE8hrDvc4DM3PxbH4JEn0
	ATcIb0FHBtah+Q5+qf4iGkO6PtMQ0FM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-R5ZJfOJROV2-z1aVEnaenQ-1; Thu, 10 Oct 2024 12:24:22 -0400
X-MC-Unique: R5ZJfOJROV2-z1aVEnaenQ-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d45de8bbfso586970f8f.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:24:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728577461; x=1729182261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqKXpH36dfv9uG+fY8ea1xXDrNeQHdPWULm3fpYA1qI=;
        b=MEUCKrDYsxgVdIrpAKKAMRo2K3vCs7yb+fRfwqaLwJhElD37LiuTChgsEnR+C2FjdR
         8OEGNX0QPkh6NT+DYfneuxXgtHD8V51hphC7unHiZ+7MsTVJPMIJ+QGP0F82sn4RDKa8
         KUowUnIIC0VoyWtBEyb4VhSuOE1Eym8qh9SOASZ87Og5QsRannpxEWRFovru3ZaTEbU7
         I3V27N2LsNULmu1Wb4Lr1CkdZeccD5o4kNzj4eHnRRYHZdr3TcpLHZIFjlRU5ccsKxpZ
         RlSoLuoAht+422lBEa0klhvVQem2vW+VfXyCiCeqKFYhigJbeLjNjIy81tUSueQQ0suV
         wOfw==
X-Gm-Message-State: AOJu0Yys1On1f2DlDxfgLy/RNMrp/Zum6zAtVPHd0ikuHNBLIkFgvCPT
	pJTxnqD0/xgIE+Z/WkuqNvI206krIMe6gGIWpDbogx+6Lpn3HS/FvgdvVCFKbk4i6lVTQdZRUOH
	1De8zqe8ApTuBbVyjTexPqHRkxSCWWFRjThh/hqSVNoX//3MX80M/975RkGVsEDsCpGH967WpqL
	I+545FoTGq+ZdSCbSSEPqul3JE
X-Received: by 2002:a5d:526e:0:b0:37d:2ea4:bfcc with SMTP id ffacd0b85a97d-37d3aa3e0b3mr5431165f8f.13.1728577461006;
        Thu, 10 Oct 2024 09:24:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOpHuEnNwHPkh32sVqmcpShjg6f2VSeZjXf+Zw4AE4kSoSpmKcwl3S+T/q6TmJMxn3LegqxVUVb4KT/sS+RO0=
X-Received: by 2002:a5d:526e:0:b0:37d:2ea4:bfcc with SMTP id
 ffacd0b85a97d-37d3aa3e0b3mr5431150f8f.13.1728577460594; Thu, 10 Oct 2024
 09:24:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009175002.1118178-1-seanjc@google.com> <dade78b3-81b1-45fb-8833-479f508313ac@redhat.com>
 <Zwf-EX_JVfAGmrPj@google.com>
In-Reply-To: <Zwf-EX_JVfAGmrPj@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 10 Oct 2024 18:24:08 +0200
Message-ID: <CABgObfYU4=bZYHXqjh-wDDFHdF=qkbdX6Do-DobQgrqikA6zTw@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] KVM: x86: Fix and harden reg caching from !TASK context
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 6:17=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Oct 10, 2024, Paolo Bonzini wrote:
> > On 10/9/24 19:49, Sean Christopherson wrote:
> > > Fix a (VMX only) bug reported by Maxim where KVM caches a stale SS.AR=
_BYTES
> > > when involuntary preemption schedules out a vCPU during vmx_vcpu_rest=
(), and
> > > ultimately clobbers the VMCS's SS.AR_BYTES if userspace does KVM_GET_=
SREGS
> > > =3D> KVM_SET_SREGS, i.e. if userspace writes the stale value back int=
o KVM.
> > >
> > > v4, as this is a spiritual successor to Maxim's earlier series.
> > >
> > > Patch 1 fixes the underlying problem by avoiding the cache in kvm_sch=
ed_out().
> >
> > I think we want this one in stable?
>
> If anything, we should send Maxim's patch to stable trees.  While not a c=
omplete
> fix, it resolves the only known scenario where caching SS.AR_BYTES is tru=
ly
> problematic, it's as low risk as patches get, and it's much more likely t=
o backport
> cleanly to older kernels.

Ok, this works for me.

Paolo


