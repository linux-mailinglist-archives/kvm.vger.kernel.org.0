Return-Path: <kvm+bounces-10473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F44286C660
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2365B2832E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:07:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59BF7651B9;
	Thu, 29 Feb 2024 10:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWmf+Xyi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD5A64CF9
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 10:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709201105; cv=none; b=qWirk7OCQEf0ITW68I9a9mmgz3fKeapf3yJgdhqgFuDFvgHWALzRjck+TlwhPArqqy76JgUbDnh3NXUPAlD6Wq7qdXrx7aiWLb9/TX41LLrvqXAV2cyWQeODKsGsQLk7oRl7IdZz8NLV+ML0xg2fijfFmizIv6pg7fyDomRP598=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709201105; c=relaxed/simple;
	bh=mJH7T3GHhmEkUgCax6VHAFCiu4bKdmthZt48XtrJvYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PmBPUhzKJe3eT0JNWgZlm7PW9yJsU5HH6o8kjGQnD+cRinoAf8BLB7TnteJDNs3+xlZOy1yqs9IGXlO6BIncnpk4yj31gPk7a58GkXBXgFS19w4hJk5bavSKS0lzHnBt7xLOPZfgy1TGc54tP1XjDNxNPTo3/HvMJ4F5ZTFjiWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWmf+Xyi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709201102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tFCpQPrTkjVx77y9FbZCVOAeK53WZkOEyY2EC3PXW0Y=;
	b=HWmf+XyiFvkQH6dGzAim2fov3WFI2jMI9lC0JyxSFI64gpMwsK8EfMuvgT3hUqW2AsOToL
	/H/Nrq7Tbfp0i9OOZiIvdetfBOvQNCMZEPVIOS8FgPNFoy+5DmVfUFWPLWiCBHz0/T8bjt
	vxz+OO+8xNc2ausSaOB3lKDrDiy1ZbE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-6QzwAxshPNmxE1zn3gIQsQ-1; Thu, 29 Feb 2024 05:04:59 -0500
X-MC-Unique: 6QzwAxshPNmxE1zn3gIQsQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-33d10bd57d7so373884f8f.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 02:04:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709201098; x=1709805898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tFCpQPrTkjVx77y9FbZCVOAeK53WZkOEyY2EC3PXW0Y=;
        b=CbJhrYjSDZkp2TU4e06et9tTLSbm4H/XtlsglnmyEi0yWInuKvMTYNgBotC88KhrVZ
         b7k9zQftuCu46FhD91S99UuTT9u9+tKTqYqXqmDwbHnc9kyobt7PNOzosn58WU2wYUlB
         j8mlbsDSLlV5nTNr2Hr4QykIzdfyXWdrWugiQ+ZfQtnOICXGyAZFIOb1gyiw4+Xi7Kuz
         TkG4Vi6sKZmNMP/C69MoAusE5jelM/zTAtLpNkhKKbbzdSfh5rqcMzKCGZ47srdy2g4U
         5ONSNKm8T6prFHStZKLxeQcnUS3BW8XB94asrSmhDo+9UUYx75uWBZMjGUOqpEV368YN
         1B2g==
X-Forwarded-Encrypted: i=1; AJvYcCVnH+rD6lRdQonZl3hgZgLkrV9xaeREwW/i4kX0R48kIjJ1nzepMRX5b8geMWUqzitGHIKop+FIN6DpKGvRjlTQGKaU
X-Gm-Message-State: AOJu0YyttWI1NmljIU2h0y79tYtFhCo10a2yJz2BvtLeb6opew3ErtS5
	TQWhKLcd4CjzP/oClTxvarH9PmnBBhH3c/MFtDy0cA16J5u2HJeD815DuAqtEavkQQyDtW9SFf7
	+fymnUZ8YmggyJQ/g1xUDiSxnoQ029lCXsrLL+jRrzbN31Y7RxrgRr0YbcA++qhLiMvabc6lhxU
	crlaNgRKhHztrdj7crCB0gxj4Q
X-Received: by 2002:adf:ef03:0:b0:33b:784c:276e with SMTP id e3-20020adfef03000000b0033b784c276emr1025129wro.25.1709201098195;
        Thu, 29 Feb 2024 02:04:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVQghsQXIC4avUjIa45ZpxqXLw07aC63ABv1OLNHKr5AAr7XCmN+5e1UkrNR4sIYwoHhANxACUuLsQnEF9TKc=
X-Received: by 2002:adf:ef03:0:b0:33b:784c:276e with SMTP id
 e3-20020adfef03000000b0033b784c276emr1025118wro.25.1709201097850; Thu, 29 Feb
 2024 02:04:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2024022822-CVE-2021-46978-3516@gregkh> <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
 <2024022905-barrette-lividly-c312@gregkh>
In-Reply-To: <2024022905-barrette-lividly-c312@gregkh>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 29 Feb 2024 11:04:45 +0100
Message-ID: <CABgObfZ+bMOac-yf2v6jD+s0-_RXACY3ApDknC2FnTmmgDXEug@mail.gmail.com>
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
To: Greg KH <gregkh@kernel.org>
Cc: cve@kernel.org, linux-kernel@vger.kernel.org, 
	KVM list <kvm@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 6:21=E2=80=AFAM Greg KH <gregkh@kernel.org> wrote:
>
> On Wed, Feb 28, 2024 at 11:09:50PM +0100, Paolo Bonzini wrote:
> > On 2/28/24 09:14, Greg Kroah-Hartman wrote:
> > > From: gregkh@kernel.org
> > >
> > > Description
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > In the Linux kernel, the following vulnerability has been resolved:
> > >
> > > KVM: nVMX: Always make an attempt to map eVMCS after migration
> >
> > How does this break the confidentiality, integrity or availability of t=
he
> > host kernel?  It's a fix for a failure to restart the guest after migra=
tion.
> > Vitaly can confirm.
>
> It's a fix for the availability of the guest kernel, which now can not
> boot properly, right?  That's why this was selected.  If this is not
> correct, I will be glad to revoke this.

To expand on what Vitaly touched, guest availability based on host
action is generally not considered part of the threat model (not even
by the newfangled confidential computing stuff). If you want to stop a
guest, run "virsh pause" or kill -9. Add load to the host until the
guest reports a lockup. dd if=3D/dev/random to their disk. Or if you
need to bypass SELinux, just turn off the host---in CVSS parlance,
that would be a valid attack on an "adjacent" machine, but nobody
treats it as such and the reason should be obvious.

Yes, there can be mitigations but let's say that "orchestrate a fake
migration so that the guest fails to restart on the destination" is
fairly down on the checklsit.

> > Apparently the authority to "dispute or modify an assigned CVE lies sol=
ely
> > with the maintainers", but we don't have the authority to tell you in
> > advance that a CVE is crap, so please consider this vulnerability to be
> > disputed.
>
> Great, but again, not allowing the guest kernel to boot again feels like
> an "availability" issue to me.  If not, we can revoke this.
>
> > Unlike what we discussed last week:
> >
> > - the KVM list is not CC'd so whoever sees this reply will have to find=
 the
> > original message on their own
>
> Adding a cc: to the subsystem mailing list for the CVEs involved can be
> done, but would it really help much?

Yes, it would give a heads up like you do for stable patches roundup.

> > - there is no list gathering all the discussions/complaints about these
> > CVEs, since I cannot reply to linux-cve-announce@vger.kernel.org.
>
> That's what lkml is for, and is why the "Reply-to:" is set on the
> linux-cve-announce emails.  Creating yet-another-list isn't really going
> to help much.

So why do we have subsystem lists at all? It helps people that have
interest in proposing and gathering CVE disputes, providing an easy
way to do so; just like subsystem mailing lists people that are
interested in USB or virtualization patches. It helps searching for
all messages related to a CVE by not splitting them between
linux-cve-announce and lkml, too.

Also, LKML does not get the initial announcement, which makes it a bit
more painful to find the full discussion on lore (you have to go
through a "no message with that id, maybe you mean this one from other
mailing lists" page, instead of having the whole thread in the same
place). A linux-cve mailing list with public posting, used for Cc and
Reply-to of the initial message, would solve this issue as well.

Paolo


