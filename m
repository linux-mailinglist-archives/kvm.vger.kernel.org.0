Return-Path: <kvm+bounces-25369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 214F4964938
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 468381C22ED9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5831B14E1;
	Thu, 29 Aug 2024 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsfu843s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545161A7AE4
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 14:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943307; cv=none; b=uzMPIRWln2iZjQiJjPJFY4Bc7DV5rAM93kPb4/eXB9ufjtdtNWI1Laf0UZzK9DGNUZWfSDU2JbASoSE3T7K+t7FA5nZmnDXVtYCSqLWRP/atUx1ZSGdz15uAXonCxbRhgBQYQVOmLKDgtrZ2qVaqsvNxTVoISGAYJ4XjgrDEsjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943307; c=relaxed/simple;
	bh=WuEtO6BmIl0gGlluQ8RcR2vhje+ZxPWcYV/Mr6S4Vk0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C0I0ZCPorEclfGtge/5zEle/bFG7kHjHY23mDbproPp4gjPBAALNKbOj5tfUGDTmJlz1Iz7KaxxfW4ziusxnVB5SlKBTuaqlFhGWWLVfJEie2vRqQYIZ1dRD0w0DGie5BIEMy0s5w1FDgW5FfJd3J0s7pOmte0y45vzYrTt6KVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsfu843s; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035949cc4eso1206367276.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 07:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724943305; x=1725548105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p3UuMYljCd91RJx727z2/DG7ns9tOYwJWF5xNUr/gNM=;
        b=lsfu843sUb+KMSGUuKahecf12bZJfaNucqK29Gt6Ku0oY8XCKeeOIb1P1nNosrjf/u
         fxSvbQEZLX59rkW8eRW7GRlKHUNgFHPFbl8QNct0B8G9/udrs8KXi2ShCMO3fuVBJJ6+
         iujOlsTkO4ov5frghV5nL6zvTYV+Q1SzjF+BOsZm+BNkXTPEDW/3+uV88EqnIADns9fx
         w4Md/hddxVxNVvsg7rs2nrDk1I9NVjfM4oJTa4LhFkBy9o2xSyRW/bGoAMiAq7VLXehm
         vArzmVI94pfKDvVBQ5DsQ3n+KSz6eLcfNxVEoFxYAIa2v5+iSWUAw7LGRJZkaVNAZEOG
         X4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724943305; x=1725548105;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p3UuMYljCd91RJx727z2/DG7ns9tOYwJWF5xNUr/gNM=;
        b=wmHdhlRiNTs3BLMnDL/nHVEmceq0XPdTXSs3sVulSqMIDC/TaoOkfQ+jEfy+yq6qi7
         O1+YEHFK4QaqoKh5AcJmXWoSbdWJWAfVV8spnLosdNojl2t3m56hdG/GjwzjwKvudKRX
         XtzDVNBvlwknSIaEgV7E6jLasxuntyL1l4v9Jw+DI9nQTx9CVVQgWn3CjAma0EuDoEja
         RHOL3HCvpwstDjFGQndtS1o5cGzi0mz/vgbOvPhzPdcYYEnd9CQDICNX/x++6t+1JK/H
         /sc+Ei8tTjfcexD9u/k/LzKCMbR8Nr7YBAQX4viHcTYmHWOvjOLwZ2R0pV5MUsFMX+3l
         pIdA==
X-Gm-Message-State: AOJu0YwOSv/93yeotVxwPEL3LEx7+RXu6jCcN1J8rOQtn7wIon7Z45fu
	PkNP6pgzB+/xS83akJKGpoHVQSQOErlP+VNTF1gkrE5PF5oxZVORwnJPFISF01V4x01wZ9PjXil
	dOQ==
X-Google-Smtp-Source: AGHT+IEOOM+fVkTxyRvwJSu8mdC7aHDwg3OAToByUHR/+hbltIEls5CoHUCIuCmJGffzDkQRr0JuSX4bVys=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:7cc4:0:b0:e11:69f2:e39 with SMTP id
 3f1490d57ef6-e1a5adee523mr36802276.9.1724943305173; Thu, 29 Aug 2024 07:55:05
 -0700 (PDT)
Date: Thu, 29 Aug 2024 07:55:03 -0700
In-Reply-To: <7af072f062cb4df5aac10540d4af994dc2fcd466.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240820133333.1724191-1-ilstam@amazon.com> <20240820133333.1724191-3-ilstam@amazon.com>
 <Zs8yV4M0e4nZSdni@google.com> <7af072f062cb4df5aac10540d4af994dc2fcd466.camel@amazon.co.uk>
Message-ID: <ZtCLx3zn3QznN8La@google.com>
Subject: Re: [PATCH v3 2/6] KVM: Add KVM_CREATE_COALESCED_MMIO_BUFFER ioctl
From: Sean Christopherson <seanjc@google.com>
To: Ilias Stamatis <ilstam@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Paul Durrant <pdurrant@amazon.co.uk>, 
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	"paul@xen.org" <paul@xen.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024, Ilias Stamatis wrote:
> On Wed, 2024-08-28 at 07:25 -0700, Sean Christopherson wrote:
> > > returns a file descriptor to the caller but does not allocate a ring
> > > buffer. Userspace can then pass this fd to mmap() to actually allocat=
e a
> > > buffer and map it to its address space.
> > >=20
> > > Subsequent patches will allow userspace to:
> > >=20
> > > - Associate the fd with a coalescing zone when registering it so that
> > >   writes to that zone are accumulated in that specific ring buffer
> > >   rather than the VM-wide one.
> > > - Poll for MMIO writes using this fd.
> >=20
> > Why?  I get the desire for a doorbell, but KVM already supports "fast" =
I/O for
> > doorbells.=C2=A0
>=20
> What do you refer to here? ioeventfd?=20

Ya.

> Correct me if I am wrong, but my understanding is that with an
> ioeventfd the write value is not available. And that is a problem when
> that value is a head or tail pointer.=20

Ah.  Can you describe (or point at) an example device?  I don't read many d=
evice
specs (understatement).  It would be helpful to have a concrete use case fo=
r
reviewing the design itself.

In a perfect world, poll() support would come from a third party file type,=
 as
this doesn't seem _that_ unique (to KVM).  But AFAICT there isn't an existi=
ng
type that is a good fit, probably because it's such a simple thing.

