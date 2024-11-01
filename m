Return-Path: <kvm+bounces-30315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5E49B9461
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CCCA282239
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55221C8781;
	Fri,  1 Nov 2024 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+LvVyWP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF67A1C5798
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730474809; cv=none; b=JOEHtzVY2M1qFHBp4octZCZKsfhaaNZ+6QUO7QmDY83qJgVo0VjujvUaSm1KyM7k2th4XchhGWXqeUtfgErlbAaZL5IBiumYbifU36P/WA9xyiZt9/9Mghj2crHq+CU2FaRC/TGWGrgJq4R8e7ba+cv32b/Ms38o8aaTlA8TWXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730474809; c=relaxed/simple;
	bh=wHAtH85ytanmYNA+QD9zRKwrYvKpOZ1yPwJIGLNUmVk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bgVmDXvr+sA1iZo6j2toPxAW3idTyJOywybYT0bKlpVXkuMg4At3V7hWKeKGXOlheqMkzVH4Kr17hLqAlp/DjSF/tHKvJErI/y71xa0eK5XdyrbtBUsryaa8zI1euJ2yfSS4cPuZKHMZYMhJNzsiJPxdcBmwHfkbCPomDwdaAw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t+LvVyWP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e35199eb2bso40879807b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 08:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730474806; x=1731079606; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A0ftFmxWefug8znYAUp23wDUAHo5xr+BS9XzbNWaTbY=;
        b=t+LvVyWPVEwDwJMMWe42e1+vhMgEzDpXlQoECVPk+yz4tf6L9vd1i/amucC2RcK415
         h0HolyoLEai8Mqdlgt4KnsVmPKHBog320C8N5rChYV4XN6Ex2GIwvXsAZu/TVy9UVRNo
         x7PSYaKnc9NZn4T4pZdIXjz5ulcFusCpMcZv2eIOdtAEmFAfIINbT9tqWDvon+GUlXnR
         e4LJFkQ2ayOJs2rKC+NAUIvoiPl++DOboftFvN9ci77cye0GpHzAH5EVnZCEVvIYeznC
         93VEIxZglMaFdhUk6J4ef4I89bjV4bKxDbSd1CKbFA1qE6GYY/7MY1zcZ3JctOypRSLJ
         7uJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730474806; x=1731079606;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A0ftFmxWefug8znYAUp23wDUAHo5xr+BS9XzbNWaTbY=;
        b=YeHioSdhOLcn3x8h+t4EM7shAeZE5Tdww8Ua86WbnJvKhUJKZQFiHQBP6nUxybujTW
         qV/lFg1u36bjFI4Kqfu5w4qT5NCOcGbzWJ1ZVQZxHTfRoHCM+f4cewLGtvoN5pxfaXh/
         +rCqu+P9AagKMLi6Ln212zxSk6v0fS5/vtQe36U14g/uSopbwVjXJAGWiR148pRzlZrC
         itMHaBDaLvUGeLREOSQdw59ygbOG1fe1BNFh3VE9Z6R8C7KPSdhauAugrVGIxmAjrhPL
         se8T4H/oxCmt4hFjMI53y5HZ/JoqYBUPiWI3hMjOM8ej/dQF6u0Cgi3yUjAhaYN1jKBS
         oKdw==
X-Forwarded-Encrypted: i=1; AJvYcCWehrVe2a9Q7pwFGa76cgrwzMkGHxRtDIi8S7SkHCd28MQPZ+GXSh2vcF6HA5Guj9OIe9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPZOLlHvhCmyNaUnnpUSDUgiNCMmnB3hdQaSb8kaiS+AH4k2xa
	ynR68ohRVIGHkAreTaxJvUpvkwFgxjiMrhGBP5dHsTtzX2FekJO/CdXYeM5ZpLS7XE99xSZ6pUA
	ekw==
X-Google-Smtp-Source: AGHT+IHYLzsVc20vLRQwtzwWH/ZL6V83GRzYvw29uoFmous4MU437XqJXznaZoUcfr+GEJE6ovx7W6bgmVM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6f8e:b0:6e3:2bc1:da17 with SMTP id
 00721157ae682-6ea64bc93a8mr394077b3.4.1730474805966; Fri, 01 Nov 2024
 08:26:45 -0700 (PDT)
Date: Fri, 1 Nov 2024 08:26:44 -0700
In-Reply-To: <9c55087b-e529-46cd-8678-51975a9acc71@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com> <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com> <9c55087b-e529-46cd-8678-51975a9acc71@linux.intel.com>
Message-ID: <ZyTzNHil-55v7D3r@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2024, Binbin Wu wrote:
> On 10/31/2024 10:54 PM, Sean Christopherson wrote:
> > My other idea was have an out-param to separate the return code intende=
d for KVM
> > from the return code intended for the guest.  I generally dislike out-p=
arams, but
> > trying to juggle a return value that multiplexes guest and host values =
seems like
> > an even worse idea.
> >=20
> > Also completely untested...

...

> >   	case KVM_HC_MAP_GPA_RANGE: {
> >   		u64 gpa =3D a0, npages =3D a1, attrs =3D a2;
> > -		ret =3D -KVM_ENOSYS;
> > +		*ret =3D -KVM_ENOSYS;
> >   		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
> >   			break;
> >   		if (!PAGE_ALIGNED(gpa) || !npages ||
> >   		    gpa_to_gfn(gpa) + npages <=3D gpa_to_gfn(gpa)) {
> > -			ret =3D -KVM_EINVAL;
> > +			*ret =3D -KVM_EINVAL;
> >   			break;
> >   		}
>=20
> *ret needs to be set to 0 for this case before returning 0 to caller?

No, because the caller should consume *ret if and only if the function retu=
rn value
is '1', i.e. iff KVM should resume the guest.  And I think we actually want=
 to
intentionally not touch *ret, because a sufficient smart compiler (or stati=
c
analysis tool) should be able to detect that incorrect usage of *ret is con=
suming
uninitialized data.

> > @@ -10080,13 +10078,13 @@ unsigned long __kvm_emulate_hypercall(struct =
kvm_vcpu *vcpu, unsigned long nr,
> >   		return 0;
> >   	}
> >   	default:
> > -		ret =3D -KVM_ENOSYS;
> > +		*ret =3D -KVM_ENOSYS;
> >   		break;
> >   	}
> >   out:
> >   	++vcpu->stat.hypercalls;
> > -	return ret;
> > +	return 1;
> >   }
> >   EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> > @@ -10094,7 +10092,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu=
)
> >   {
> >   	unsigned long nr, a0, a1, a2, a3, ret;
> >   	int op_64_bit;
> > -	int cpl;
> > +	int cpl, r;
> >   	if (kvm_xen_hypercall_enabled(vcpu->kvm))
> >   		return kvm_xen_hypercall(vcpu);
> > @@ -10110,10 +10108,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcp=
u)
> >   	op_64_bit =3D is_64_bit_hypercall(vcpu);
> >   	cpl =3D kvm_x86_call(get_cpl)(vcpu);
> > -	ret =3D __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, =
cpl);
> > -	if (nr =3D=3D KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > -		return 0;
> > +	r =3D __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cp=
l, &ret);
> > +	if (r <=3D r)
> A typo here.
> I guess it meant to be "if (r <=3D ret)" ?

No, "if (r <=3D 0)", i.e. exit to userspace on 0 or -errno.

> So the combinations will be
> -------------------------------------------------------------------------=
---
> =C2=A0=C2=A0 |=C2=A0 r=C2=A0 |=C2=A0=C2=A0=C2=A0 ret=C2=A0=C2=A0=C2=A0 | =
r <=3D ret |
> ---|-----|-----------|----------|----------------------------------------=
---
> =C2=A01 |=C2=A0 0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 true=C2=A0=C2=A0 |=C2=A0 return r, which is 0, exit to us=
erspace
> ---|-----|-----------|----------|----------------------------------------=
---
> =C2=A02 |=C2=A0 1=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 false=C2=A0 |=C2=A0 set vcpu's RAX and return back to gue=
st
> ---|-----|-----------|----------|----------------------------------------=
---
> =C2=A03 |=C2=A0 1=C2=A0 | -KVM_Exxx |=C2=A0=C2=A0 false=C2=A0 |=C2=A0 set=
 vcpu's RAX and return back to guest
> ---|-----|-----------|----------|----------------------------------------=
---
> =C2=A04 |=C2=A0 1=C2=A0 |=C2=A0 Positive |=C2=A0=C2=A0 true=C2=A0=C2=A0 |=
=C2=A0 return r, which is 1,
> =C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0 N=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
|=C2=A0 back to guest without setting vcpu's RAX
> -------------------------------------------------------------------------=
---
>=20
> KVM_HC_SEND_IPI, which calls kvm_pv_send_ipi() can hit case 4, which will
> return back to guest without setting RAX. It is different from the curren=
t behavior.
>=20
> r can be 0 only if there is no other error detected during pre-checks.
> I think it can just check whether r is 0 or not.

Yeah, I just fat fingered the code (and didn't even compile test).

