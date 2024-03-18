Return-Path: <kvm+bounces-12001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0C2A87EDF3
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:51:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C06C91C21EEA
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832DD5647F;
	Mon, 18 Mar 2024 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6rUVJkD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBED5644D
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780546; cv=none; b=U9oeq/bYa6YRwTAHCTjC/ckydmbm/wcGuga74d2mwwWKOp5PS4Vl/vTqCkEgK6Ek8An8rUA6RmM8nMlrCPUOcCOal81KPMvzA32+NidLGmuMry98eJY8ckA630jmFvgH5aPiqazDBB/SEeI4ln+iMG5Ypu7wYRY/8rYiZUxIY8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780546; c=relaxed/simple;
	bh=stnly8HvasFMCvsYR1fbyuJtmkCcBTZ3FsH47hj2E1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k2CB9rrXykDHtHL46R6F9WifIi2+jDxJ1BV4bC4YLlqbyQVEjk/kQXzT3n0vLZ5CwkhTDHWyzHIB+Lc/u1+SBL3xqpw1VVBbCZD8mMz9eaBPd/dl7awMYHrgPm4EqO/FAqaFjxPMwBobuhAXskO4t0DO1rXrvVkMiu1/CLsOyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6rUVJkD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710780544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBtKOdFjpK+3+Il0olwQK+Bw8samb3ue692p47qxRLg=;
	b=A6rUVJkDBt+43nNeeksNMXEkWejmtRVd6ji5VJkXFVX1oCDI9v+5YOq+VVlo8wJnoG8j8v
	XdYOTanou/dLKS3cbCVO4HhSfKzekPQHhDjqlrlScs2Mmo+/Mb2X39QiwU6LkPzN0kUkiN
	gaceDE6Pw8FpAJVIjt57mxZHWQXWEu8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-FjMfDB-wPSmJNaf-WFZ8hQ-1; Mon, 18 Mar 2024 12:49:02 -0400
X-MC-Unique: FjMfDB-wPSmJNaf-WFZ8hQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33ed8677d16so1323845f8f.1
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 09:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710780541; x=1711385341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBtKOdFjpK+3+Il0olwQK+Bw8samb3ue692p47qxRLg=;
        b=EvrPJwBapXHYupev4XjnmadFZoJJtRdcIcNI3aFLhG6eWZiJD3vwifcBfMdAXxGy3x
         qIZ1Eaayx9p5cgsLCgQ9k19d+6z1tz9//doAJiCE379Z9NbWBAV6tTczTdG8BKomQb8R
         AXxgZByQzKBfuL/pEpm2bQ0FiIE98XxVkq13hmV2ijRsQDyjZjxM5aXcXsCXUKudlRZf
         HVX2skrtYA1eeWCXQWpcJ58YmuVhA6kxnwcLLVncwes/S9mV3hheyzGEBYq5TSTrVlHR
         w9quJMFE3VxTXY10QDC1SCRHEdxNhgy+7wU8z+eN2qeGWRBwBYGwmfrSlLuIEy96LNnz
         W7ng==
X-Forwarded-Encrypted: i=1; AJvYcCWBiR8NfaDebTLjXQikr/kWI4p51b4pmWYwwKtTKNMV183PFY+O6Nq3IK7LfTWstnMTxQALUwKQY6N5oLAlUsWSbeLP
X-Gm-Message-State: AOJu0YwrZHX9GwF3IB3VK56PqRtDgyUfUG4raCjTMFHOX2ApsniRgaOz
	dY7BH3lRGJlJA34aAfuqUWki1gEEEZM5PJU9YorbLm5B+nmlnvIlnbv+iXrrAI6FOfnw/QUo8xM
	cVnbJvLJxi2axyCPLudKZImKZ+waY5C2EmGGbm3PzzUkQtCs0szYJY4VLh10jPMs87rAX35hqBK
	37NoCsPkpjiD83IjlBdnV0qXPT
X-Received: by 2002:adf:fd0b:0:b0:33e:6760:6def with SMTP id e11-20020adffd0b000000b0033e67606defmr10341242wrr.56.1710780541341;
        Mon, 18 Mar 2024 09:49:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFepTlAmHpk5XYr52CmG+vr1oXsaNyDVNLRINU5cOCbpoo7rMo/2qyJQ4eDkMw6LiUrwInEBeyds8RYpJNHITE=
X-Received: by 2002:adf:fd0b:0:b0:33e:6760:6def with SMTP id
 e11-20020adffd0b000000b0033e67606defmr10341226wrr.56.1710780540978; Mon, 18
 Mar 2024 09:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com> <20240314220923.htmb4qix4ct5m5om@amd.com>
 <ZfOAm8HtAaazpc5O@google.com> <20240314234850.js4gvwv7wh43v3y5@amd.com> <ZfRhu0GVjWeAAJMB@google.com>
In-Reply-To: <ZfRhu0GVjWeAAJMB@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 18 Mar 2024 17:48:48 +0100
Message-ID: <CABgObfYNnDXvPU7OMDHzq-yjRYGHaS-M0E_tE2UB4ucv6E1x2Q@mail.gmail.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for CoCo features
To: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	aik@amd.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 3:57=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Mar 14, 2024, Michael Roth wrote:
> > On Thu, Mar 14, 2024 at 03:56:27PM -0700, Sean Christopherson wrote:
> > > On Thu, Mar 14, 2024, Michael Roth wrote:
> > > > On Wed, Mar 13, 2024 at 09:49:52PM -0500, Michael Roth wrote:
> > > > > I've been trying to get SNP running on top of these patches and h=
it and
> > > > > issue with these due to fpstate_set_confidential() being done dur=
ing
> > > > > svm_vcpu_create(), so when QEMU tries to sync FPU state prior to =
calling
> > > > > SNP_LAUNCH_FINISH it errors out. I think the same would happen wi=
th
> > > > > SEV-ES as well.
> > > > > Maybe fpstate_set_confidential() should be relocated to SEV_LAUNC=
H_FINISH
> > > > > site as part of these patches?
> > > >
> > > > Talked to Tom a bit about this and that might not make much sense u=
nless
> > > > we actually want to add some code to sync that FPU state into the V=
MSA
>
> Is manually copying required for register state?  If so, manually copying=
 everything
> seems like the way to go, otherwise we'll end up with a confusing ABI whe=
re a
> rather arbitrary set of bits are (not) configurable by userspace.

Yes, see sev_es_sync_vmsa. I'll add FPU as well.

> > SET_REGS/SREGS and the others only throw an error when
> > vcpu->arch.guest_state_protected gets set, which doesn't happen until
>
> Ah, I misread the diff and didn't see the existing check on fpstate_is_co=
nfidential().
>
> Side topic, I could have sworn KVM didn't allocate the guest fpstate for =
SEV-ES,
> but git blame says otherwise.  Avoiding that allocation would have been a=
n argument
> for immediately marking the fpstate confidential.
>
> That said, any reason not to free the state when the fpstate is marked co=
nfidential?

No reason not to do it, except not wanting to add more cases to code
that's already pretty hairy.

> > sev_launch_update_vmsa(). So in those cases userspace is still able to =
sync
> > additional/non-reset state prior initial launch. It's just XSAVE/XSAVE2=
 that
> > are a bit more restrictive because they check fpstate_is_confidential()
> > instead, which gets set during vCPU creation.
> >
> > Somewhat related, but just noticed that KVM_SET_FPU also relies on
> > fpstate_is_confidential() but still silently returns 0 with this series=
.
> > Seems like it should be handled the same way as XSAVE/XSAVE2, whatever =
we
> > end up doing.
>
> +1
>
> Also, I think a less confusing and more robust way to deal with the new V=
M types
> would be to condition only the return code on whether or not the VM has p=
rotected
> state

Makes sense (I found KVM_GET/SET_FPU independently and will fix that
as well in the next submission).

Paolo


