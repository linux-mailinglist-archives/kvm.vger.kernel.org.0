Return-Path: <kvm+bounces-17838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4308E8CB0EE
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 17:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C3B31C22DCB
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 15:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368F2142E87;
	Tue, 21 May 2024 15:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vzoyxWOS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA8914A8E
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 15:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716303745; cv=none; b=sBLCFH+WM86LM3FV3FSCiO5R+c+PH0EFKSrSFeqd7OdhD0sScOopNk8IloYqEtjfGxKzeQf9KIWYyh7YZSgRnU/nDgmXldjLZhiUV0pvMjvNKVFIicILcOSeGCeGBJibbrk7cEkIBUoJrKclEIDeUeJg5bqYcIDrmz0lD6bxJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716303745; c=relaxed/simple;
	bh=2gdPp9oYLqQf/RP21Dj3aRzPOWXXvW43KLiglLnZLhA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gPKjLvY4HUBzzv2ip4biHt38JQaqkCor++6MeJhMkV6AQkCyjwP3t0iZ2PISvy3pX8dk/IBiVN1/ONriR4JPaeyGvksOfEZizmlA9gkxidh/DoRDtk8OOXZuWnpBjUqA/eildD5HzjNQYkvasyWkpPs+qmSoAWwCjpqxLMpDLuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vzoyxWOS; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so17289778276.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 08:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716303741; x=1716908541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rA84hVBnpCIrwTsdUfOtT5LNCN3IxRZXsCw7UuzC1H8=;
        b=vzoyxWOS2lPdCvgfCJJ3IMJxDJzAgiTgHqsw5KWQHKRmgEAjm4r4jU5L2d7WnuR727
         617jRsiyr+xh2yAw3t+YeDxpQqUrcO7BRuadxd1R6jZbSqo2kjBbbX8tcqPhFH1Mc4Tx
         0TRs4uoxpp9VHQlx+diyhdCDKJCHWjEebOXsoA4S/BeBv+UYivAWhMjP/D3S1JVdMCQ1
         uPAsBDerLmR1NO4celzW18KeXP3u7liU3GodfxphC45XK8gU2zQhyGnuw4johzr7HvTx
         K/tI+VDb+8uYAlwnXwCU8F36tEhk35v9WRUQnxDzMxz5UmkIAg8XAVA2+WpuI9la1bRU
         q2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716303741; x=1716908541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rA84hVBnpCIrwTsdUfOtT5LNCN3IxRZXsCw7UuzC1H8=;
        b=bKUlZ4epYIyKGfp1VppnVFfuZwKMzubNfPWrHYD8K0KcVU8lgS3NIgmUEH583LJA5y
         tkyLcIwo6eNkxWZ3X11e3LkuwIuYK+WYv8vZUHIEr1fXK4CBqwoS2XGgxyibuJF+m+EK
         ad00tD1iraNp4BoeOm9tzIcasZRr0X2z2aLf/hlrxKqSBiDhVVbfCQX+sKuP3Bf7XWn2
         xX5IfSrbeCn2UZmmAgPp/8myfoEedbluM7FnskQ9vcO0U02uAycTCSjn7Q4/YRxJuLCP
         mKvq32PN3JV2787S5oPxFdgLX7cFYsZLMptZsSmGxvSt3iTuuuXBujKkd/jeVXVOkJs9
         0tBA==
X-Forwarded-Encrypted: i=1; AJvYcCXhV5PCok9198MjQOStnNfIcpKBxggBJ5bjAap1tSnqwdkzecLwTZgCoDxQkRatOfvO9sWM59XggEPmVVI8/5u2w/+Q
X-Gm-Message-State: AOJu0YyaoZoVulD0FBGQvlAW2Zpk3CW+CdKyCvlMFzCDMyms05TY8J9P
	or77CnIsli6BsbUepEKON95A3bzuECOzgcAj77QKrgvEpd2UXuktLi9iH1zJu+2OGp1OTYwGhjl
	pdw==
X-Google-Smtp-Source: AGHT+IG6HYZ26nAMqxybqcYqauiCVba2xS61d5ebnHm0QJwNQYKpaO1QKV845PfyQA5Qs6SlU48zpoy8n/0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1142:b0:df1:d00c:130c with SMTP id
 3f1490d57ef6-df1d00c1507mr1678473276.5.1716303741597; Tue, 21 May 2024
 08:02:21 -0700 (PDT)
Date: Tue, 21 May 2024 08:02:20 -0700
In-Reply-To: <36b8df1d-593e-44c0-b34d-eb158e5ebabe@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520115334.852510-1-zhoushuling@huawei.com>
 <Zktd8QHU84_EdaNb@google.com> <36b8df1d-593e-44c0-b34d-eb158e5ebabe@huawei.com>
Message-ID: <Zky3fJPiOi8cpPSI@google.com>
Subject: Re: [PATCH] KVM: LAPIC: Fix an inversion error when a negative value
 assigned to lapic_timer.timer_advance_ns
From: Sean Christopherson <seanjc@google.com>
To: zhoushuling <zhoushuling@huawei.com>
Cc: pbonzini@redhat.com, weiqi4@huawei.com, wanpengli@tencent.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024, zhoushuling wrote:
> > On Mon, May 20, 2024, zhoushuling@huawei.com wrote:
> > diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> > index 0a0ea4b5dd8c..6fb3b16a2754 100644
> > --- a/arch/x86/kvm/lapic.h
> > +++ b/arch/x86/kvm/lapic.h
> > @@ -54,6 +54,7 @@ struct kvm_timer {
> >          u32 timer_advance_ns;
> >          atomic_t pending;                       /* accumulated trigger=
ed timers */
> >          bool hv_timer_in_use;
> > +       bool timer_advance_dynamic;
> >   };
>=20
>=20
> However=EF=BC=8CI do not understand why the global function switch
> 'lapic_timer_advance_dynamic' > is changed to a local variable in the 'st=
ruct
> kvm_timer'.  On a host, the adaptive tuning of timer advancement is globa=
l
> function, and each=C2=A0vcpu->apic->lapic_timer.timer_advance_dynamic of =
each VM
> is the same, different VMs cannot be configured with different switches.

...

> =C2=A0static int __read_mostly lapic_timer_advance_ns =3D -1;
> =C2=A0module_param(lapic_timer_advance_ns, int, 0644);

The module param is writable, i.e. can be modified while KVM is running.  E=
.g. if
the admin changes lapic_timer_advance_ns from a negative to a postive value=
, then
vCPUs that were created while lapic_timer_advance_ns<0 will have a timer_ad=
vance_ns
that was dynamically calculated, but is now static.  I doubt there's a use =
case
that actually does anything like that, and in practice it probably doesn't =
cause
real problems, but it makes for bizarre and unpredictable behavior.

Hmm, alternativately, we could make lapic_timer_advance_ns a read-only bool=
ean.
The param is wrtiable primarily because dynamic/adaptive tuning was added m=
uch
later, i.e. getting a usable value required modifying the advancement time =
while
VMs were running.  But I would be very surprised if there are use cases tha=
t still
*need* to hand tune the advancement, as it's practically impossible for use=
rspace
to do better than KVM.

The only argument I can think of for taking a raw value from userspace is i=
f there
is an absurd delay that exceeds KVM's max advancement of 5us.  But I'm not =
sure
KVM should even support such values.

Let me post a patch to convert lapic_timer_advance_ns to a read-only bool. =
 If
there is pushback on that idea, then we can circle back to this patch, but =
I'm
hoping we can simplify all of this instead of hardening KVM against edge ca=
ses
that no one likely cares about.

Side topic, if we keep the module param as-is, it really should be wrapped =
with
READ_ONCE().

