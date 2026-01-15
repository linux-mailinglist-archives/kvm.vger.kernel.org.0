Return-Path: <kvm+bounces-68200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E70C6D25F7D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:58:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B523830CE2D5
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 16:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627113BF2FD;
	Thu, 15 Jan 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o98zpagQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D543AE6E2
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496108; cv=none; b=QYbRNXr8AXux5Ntk6r6ONKycbTPEMy/JUv5WRX8EteVEADfvOhXjPQ1JW3Fq16rAnMk8ALbDL8uo/tKgyE1kAC9/rPjYhOi1+I8UJugYmirHiUp1vZij3R9JtWr7hjI2Nix5vpfZDRC+hT7Q2iq0neOuQX3HnQJnUbKa/tr0WYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496108; c=relaxed/simple;
	bh=vHJzNvUgrWMaqSEXYwJjvXoh/vXYEQ7TR+f/TbNG3c8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oWDjAYUJLz9bXTqh8vrqH/DKBf3ba84cY/oT4mv0cJ15Mo+qbTybfgdpoeIkFNcODotSeqo6wlUHkY6LhzNqIOY8n+z5fVXR18aQjRo461DqNrU9p5CXSeubMGzIhs2YspvY1U9mxkqWcpRjfx1anorph9jiidoNeeIp8BGuQ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o98zpagQ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f27176aa7so17033205ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768496101; x=1769100901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eL+E7/4JmScKJihcx95KMzbVjQVIxgRJYXFYqhlTPBQ=;
        b=o98zpagQZjnhW8aF+YmJ7PiI4uOky8u79nmPt6eTgm4xg8KLMQeNy6b49S/nVpUFTb
         9Pa+rUL+3CnPhz8losVkTk9mCWiWXrbwvRE7DxN7JTBajczZG2hGpEkRGO4oEM0q0X9/
         x+QQUJD4BlQo2QeInkSrzGJKhLcH9zts+sckdwP9AqltIXlwQQXpGY7/NzLUDdg5sSYi
         Dga/dc0hs1niaW8fJVSm2TP/F6AS9iQJwYV37upkvCQxbgXzkGGVDY31bFWpqZlEit/k
         TbpQNppaVlqzf8F7v+rFVIdZp5sI685Bv2dyyYtQpC04lZvFeO7pC/T3EgXBy20Qw7NC
         6HOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768496101; x=1769100901;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eL+E7/4JmScKJihcx95KMzbVjQVIxgRJYXFYqhlTPBQ=;
        b=HzeE2DXTJMrjgAjnqUPE3HBp+InLe3J0Fv2lvV9dWa9Wm5e0TZaCZiC2MUQUdP2QtC
         X3zFRJdk3p+Jr+4MQ8r/V786jO1YlYOFX1T0imKCStI4vszJ20eTSyGFnHdYT8qCbn+P
         DdtqrpM+3loo8z+dozgZfvbPZntws/QT92oU+SS2vb9g7d2s0c4EujNVQy6eBBMHbQRf
         GX0cdWltGIsJqXxxqOX6SxrNSJGXFGG4wdlEVWNnAP9bjayjHtyw+xWNFd+TiHkWxgV5
         j4IytPqKimRVnD+60LhlipwkXxL2umeR+wpnRmaXe4DVh9wNISD+0UIcO4flPgS3Ckh/
         uenw==
X-Forwarded-Encrypted: i=1; AJvYcCX3TmeiN+GS1LbAmcqBzH6gxB3lU+8JrK4ZyJ5S56aVSFuQ9pMPPr5T6gbiHMCg/Om1wl0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtXwTQwHvbB1tO3ADd/ct0xMiY79WRm/LrX16VmaCw/zWM7TLi
	BjuzDjMMgVaw7iupH72LPjAq40KhUxLPmKvagBMbrtqOIUB+3tmI43RLdfPEarR9+UUQvEUOFD+
	W3ogy+w==
X-Received: from plog2.prod.google.com ([2002:a17:902:8682:b0:2a0:ad08:d949])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f685:b0:295:96bc:8699
 with SMTP id d9443c01a7336-2a7175408damr1410685ad.20.1768496101557; Thu, 15
 Jan 2026 08:55:01 -0800 (PST)
Date: Thu, 15 Jan 2026 08:54:59 -0800
In-Reply-To: <af8bbddc-fcf5-460b-9a6f-1418a0748f37@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260114003015.1386066-1-sagis@google.com> <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
 <aWe8zESCJ0ZeAOT3@google.com> <CAAhR5DE=ypkYwqEGEJBZs5A2N9OCVaL_9Jxi5YN5X7rNpKSZTw@mail.gmail.com>
 <af8bbddc-fcf5-460b-9a6f-1418a0748f37@intel.com>
Message-ID: <aWkb41gbjs-cPX60@google.com>
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Sagi Shahar <sagis@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026, Xiaoyao Li wrote:
> On 1/15/2026 9:21 AM, Sagi Shahar wrote:
> > On Wed, Jan 14, 2026 at 9:57=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > On Wed, Jan 14, 2026, Xiaoyao Li wrote:
> > > > The -EINVAL will eventually be returned to userspace for the VCPU_R=
UN
> > > > ioctl. It certainly breaks userspace.
> > >=20
> > > It _might_ break userspace.  It certainly changes KVM's ABI, but if n=
o userspace
> > > actually utilizes the existing ABI, then userspace hasn't been broken=
.
> > >=20
> > > And unless I'm missing something, QEMU _still_ doesn't set hypercall.=
ret.  E.g.
> > > see this code in __tdx_map_gpa().
> > >=20
> > >          /*
> > >           * In principle this should have been -KVM_ENOSYS, but users=
pace (QEMU <=3D9.2)
> > >           * assumed that vcpu->run->hypercall.ret is never changed by=
 KVM and thus that
> > >           * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is n=
ow overwriting
> > >           * vcpu->run->hypercall.ret, ensuring that it is zero to not=
 break QEMU.
> > >           */
> > >          tdx->vcpu.run->hypercall.ret =3D 0;
> > >=20
> > > AFAICT, QEMU kills the VM if anything goes wrong.
> > >=20
> > > So while I initially had the exact same reaction of "this is a breaki=
ng change
> > > and needs to be opt-in", we might actually be able to get away with j=
ust making
> > > the change (assuming no other VMMs care, or are willing to change the=
mselves).
> >=20
> > Is there a better source of truth for whether QEMU uses hypercall.ret
> > or just point to this comment in the commit message.
>=20
> No version of QEMU touches hypercall.ret, from the source code.
>=20
> I suggest not mentioning the comment, because it only tells QEMU expects
> vcpu->run->hypercall.ret to be 0 on KVM_EXIT_HYPERCALL. What matters is Q=
EMU
> never sets vcpu->run->hypercall.ret to a non-zero value after handling
> KVM_EXIT_HYPERCALL. I think you can just describe the fact that QEMU neve=
r
> set vcpu->run->hypercall.ret to a non-zero value in the commit message.

+1.  We can't _guarantee_ changing the behavior won't break userspace, e.g.=
 in
theory, someone could be running a fork of QEMU in production that explicit=
ly
sets hypercall.ret to some weird value.  Or someone could be running a VMM =
we
don't even know about.  I.e. there is no single source of truth, all we can=
 do
is explain why we have high confidence that the ABI change won't break anyt=
hing.

