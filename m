Return-Path: <kvm+bounces-15011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D128A8D0E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 22:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3AD28B0D1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24EB144C88;
	Wed, 17 Apr 2024 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6LeMw2K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC52E381BA
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 20:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713386240; cv=none; b=KCb1D85G6QfogmudliyXAAxB7TpZzre+iPSQFklpsrvNdJ8InD+jKQIwgo5+pv614nsY7AmoFYzA6VEqJkVwKQKnKbc+pC+pTMp/F9CmVQgffbSKAudiSVia89Vzfc96DzBImsaslGWvRRjLrWBl4VZCnNxyEpu7TeFuWZ0eswQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713386240; c=relaxed/simple;
	bh=0fxrj0l4TnhUB9V5QYOGnaaFLDoyHeRuV75JKhy5UeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fDOE3twUG08SzfN50NXJQTqXDK1pTd2J9IgsXKbQe4OI81AijiTZv2ejs2VTO3pYY9Vra0W5K8p5LxtWvyVuTpGIR9VKezPABXvdLLuDsEx9mL6sTxSNUmDGGcnjPnqQ4GBgSmNFGDdih++DlfDbS9vzotPv9Go9wzdllpLJOFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6LeMw2K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713386237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8OjOuibrnAqJkR6ILH2qe3B2MC0JgGVAzLdrU1EZavU=;
	b=b6LeMw2Kt8z2ljs7teJYjN9q+syaMwy4tkeNvjhsb5dGgTMRjq1XMqs42EDiXib9bJajDg
	0UyAVfZE3lBzSSxOa/1oHUPbTUjSehlkCuLOqj5SqaPg1yi1rWf1GSwJ4qxVzMS3fboMRO
	eBMwkuIPcI/NBIA2xRZU8DzJR9btp6w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-4wFrPzBFMdaSb7ptHuCDOQ-1; Wed, 17 Apr 2024 16:37:15 -0400
X-MC-Unique: 4wFrPzBFMdaSb7ptHuCDOQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-343e46df264so63548f8f.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 13:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713386234; x=1713991034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8OjOuibrnAqJkR6ILH2qe3B2MC0JgGVAzLdrU1EZavU=;
        b=w0DGNw50uSedXErzikt3KojNLZX6HRe82V7ONpjGEpDa3SiimpVhpczbfYdo51WVqc
         wadZKMsRVsci5+4vnpOZ+HrvKWM1OHcqTW8nsUpLtACCyLos0ggUa8ISN3Jx0jxvTesd
         yJUUzb8vrkoCjuAvBFqytq8g5g/0ymUXCf+mi17wQhm5D1YsJJFVWdc6EVhCC0wBxPmX
         dmOX0/1BIXpjrXGea371pL/rf4WKGHEEvhR5pgpjdQEuVrqCOSide/mXa/cvvVa5Hlld
         sqdlx7T6uGG3B0YXbNIgKYWC2Pek7Fn/AMsjpfPuPMM8M2XTKwQLCVl2L06MeMXl8dag
         6tBw==
X-Forwarded-Encrypted: i=1; AJvYcCXGGOaBjmIvUlgEOB82YmrlKO9fidylp6qx+Sm0gNDiaPBR/YuL+ThdnQSYC5LwIkVyFUTDB0oGzO5T4P4TWqrPV5jw
X-Gm-Message-State: AOJu0YyNN3hjsbapT0lztIGiNWfLzkB8DoklogXq/7AH90cYML0/FcTQ
	3dRkcbyoYdf51PxUk0QYGMokBp0ItlEeC+4tQtnHE7/sAvot5ufttxUD0vS/k4x2BVGJbTJCwTa
	kzhvFXwOY+jN6G93cLDHjBWPje1qtK3BcPi5KIbHYUJhokdfcNN4wUrQgtTb/1iHLRl73wVh13g
	MtochsKyo7kaPtynekTfBKkjsJ
X-Received: by 2002:adf:ff8d:0:b0:349:f8a1:cd6a with SMTP id j13-20020adfff8d000000b00349f8a1cd6amr278174wrr.16.1713386233840;
        Wed, 17 Apr 2024 13:37:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHU9ndjqJmTepwAVDhSHoIewhE9kNn3HqYSbmjhx5WoLKj6UhTkzOn107FxBNx5uL5nlfOAr0w6pwnk1bvOhf4=
X-Received: by 2002:adf:ff8d:0:b0:349:f8a1:cd6a with SMTP id
 j13-20020adfff8d000000b00349f8a1cd6amr278165wrr.16.1713386233462; Wed, 17 Apr
 2024 13:37:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240417153450.3608097-1-pbonzini@redhat.com> <20240417153450.3608097-2-pbonzini@redhat.com>
 <ZiAw1jd8840jXqok@google.com>
In-Reply-To: <ZiAw1jd8840jXqok@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 17 Apr 2024 22:37:00 +0200
Message-ID: <CABgObfYNNgpwOWFNmhHED7wL72Gi7sbFi5_ED_B7f-BUO+nrZg@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: Document KVM_MAP_MEMORY ioctl
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 10:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Apr 17, 2024, Paolo Bonzini wrote:
> > +4.143 KVM_MAP_MEMORY
> > +------------------------
> > +
> > +:Capability: KVM_CAP_MAP_MEMORY
> > +:Architectures: none
> > +:Type: vcpu ioctl
> > +:Parameters: struct kvm_map_memory (in/out)
> > +:Returns: 0 on success, < 0 on error
> > +
> > +Errors:
> > +
> > +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > +  EINVAL     The specified `base_address` and `size` were invalid (e.g=
. not
> > +             page aligned or outside the defined memory slots).
>
> "outside the memslots" should probably be -EFAULT, i.e. keep EINVAL for t=
hings
> that can _never_ succeed.
>
> > +  EAGAIN     The ioctl should be invoked again and no page was process=
ed.
> > +  EINTR      An unmasked signal is pending and no page was processed.
>
> I'm guessing we'll want to handle large ranges, at which point we'll like=
ly end
> up with EAGAIN and/or EINTR after processing at least one page.

Yes, in that case you get a success (return value of 0), just like read().

> > +  EFAULT     The parameter address was invalid.
> > +  EOPNOTSUPP The architecture does not support this operation, or the
> > +             guest state does not allow it.
>
> I would phrase this as something like:
>
>                 Mapping memory given for a GPA is unsupported by the
>                 architecture, and/or for the current vCPU state/mode.

Better.

> > +  struct kvm_map_memory {
> > +     /* in/out */
> > +     __u64 base_address;
>
> I think we should commit to this being limited to gpa mappings, e.g. go w=
ith
> "gpa", or "guest_physical_address" if we want to be verbose (I vote for "=
gpa").
>
> > +     __u64 size;
> > +     /* in */
> > +     __u64 flags;
> > +     __u64 padding[5];
> > +  };
> > +
> > +KVM_MAP_MEMORY populates guest memory in the page tables of a vCPU.
>
> I think we should word this very carefully and explicitly so that KVM doe=
sn't
> commit to behavior that can't be guaranteed.  We might even want to use a=
 name
> that explicitly captures the semantics, e.g. KVM_PRE_FAULT_MEMORY?
>
> Also, this doesn't populate guest _memory_, and "in the page tables of a =
vCPU"
> could be interpreted as the _guest's_ page tables.
>
> Something like:
>
>   KVM_PRE_FAULT_MEMORY populates KVM's stage-2 page tables used to map me=
mory
>   for the current vCPU state.  KVM maps memory as if the vCPU generated a
>   stage-2 read page fault, e.g. faults in memory as needed, but doesn't b=
reak
>   CoW.  However, KVM does not mark any newly created stage-2 PTE as Acces=
sed.
>
> > +When the ioctl returns, the input values are updated to point to the
> > +remaining range.  If `size` > 0 on return, the caller can just issue
> > +the ioctl again with the same `struct kvm_map_memory` argument.
>
> This is likely misleading.  Unless KVM explicitly zeros size on *every* f=
ailure,
> a pedantic reading of this would suggest that userspace can retry and it =
should
> eventually succeed.

Gotcha... KVM explicitly zeros size on every success, but never zeros
size on a failure.

> > +In some cases, multiple vCPUs might share the page tables.  In this
> > +case, if this ioctl is called in parallel for multiple vCPUs the
> > +ioctl might return with `size` > 0.
>
> Why?  If there's already a valid mapping, mission accomplished.  I don't =
see any
> reason to return an error.  If x86's page fault path returns RET_PF_RETRY=
, then I
> think it makes sense to retry in KVM, not punt this to userspace.

Considering that vcpu_mutex critical sections are killable I think I
tend to agree.

> > +The ioctl may not be supported for all VMs, and may just return
> > +an `EOPNOTSUPP` error if a VM does not support it.  You may use
> > +`KVM_CHECK_EXTENSION` on the VM file descriptor to check if it is
> > +supported.
>
> Why per-VM?  I don't think there's any per-VM state that would change the=
 behavior.

Perhaps it may depend on the VM type? I'm trying to avoid having to
invent a different API later. But yeah, I can drop this sentence and
the related code.

> The TDP MMU being enabled is KVM wide, and the guest state modifiers that=
 cause
> problems are per-vCPU, not per-VM.
>
> Adding support for KVM_CHECK_EXTENSION on vCPU FDs is probably overkill, =
e.g. I
> don't think it would add much value beyond returning EOPNOTSUPP for the i=
octl()
> itself.

Yes, I agree.

Paolo


