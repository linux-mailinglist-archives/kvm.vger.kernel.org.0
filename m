Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8542AB0B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232898AbhJLRpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:45:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhJLRpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3765610C9;
        Tue, 12 Oct 2021 17:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634060627;
        bh=yASkbNro1ryeq/Pn5XosEpr1G6AfQVBAJaOgTM+0Dn0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nz7y5KBa+PIOjnf5zHSt/7PGOM48ZmDjlnwWT9m2ouhxtKrJ84S0Wh8DsGCa7rmrC
         9P8kBS0340MOfHilxFpHcIlMaTcbwJXSty5L+mw6BcL+2kAwSDOMaDandi3ZSHzO26
         wo5dTwKEtu7oNAub5pDl6PGH8gXPJegDOw6Xa+i8rLzIFcVtDmTK32UdlxWdukRcmj
         3T1nGlnvUSWWU9Jmk/bbQkFnIMuDeFVXOMsoL7cjXfhr9BFvUR4GfxEywd4cmruKwX
         CPnpklYmzy3pIhsO+jOnA6y2CnllPJs2HpVKIdK/zKoBGw9Mv1J5G18afcm1DYFhtG
         jlK4slA0UQqnA==
Message-ID: <9dbc9cedd6b49eb5c5078dd776aed808534534ec.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE
 ioctl
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, seanjc@google.com, x86@kernel.org,
        yang.zhong@intel.com
Date:   Tue, 12 Oct 2021 20:43:44 +0300
In-Reply-To: <22c1c59f-9b7c-69fa-eff3-1670b94c77af@redhat.com>
References: <20211012105708.2070480-1-pbonzini@redhat.com>
         <20211012105708.2070480-3-pbonzini@redhat.com>
         <644db39e4c995e1966b6dbc42af16684e8420785.camel@kernel.org>
         <22c1c59f-9b7c-69fa-eff3-1670b94c77af@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-10-12 at 19:03 +0200, Paolo Bonzini wrote:
> On 12/10/21 18:57, Jarkko Sakkinen wrote:
> > > +
> > > =C2=A0=C2=A0static const struct file_operations sgx_vepc_fops =3D {
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.owner=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D THIS_MODULE,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.open=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D sgx_vepc_open,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.unlocked_ioctl=C2=A0=3D s=
gx_vepc_ioctl,
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.compat_ioctl=C2=A0=C2=A0=
=C2=A0=3D sgx_vepc_ioctl,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.release=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D sgx_vepc_release,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0.mmap=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D sgx_vepc_mmap,
> > > =C2=A0=C2=A0};
> > I went through this a few times, the code change is sound and
> > reasoning makes sense in the commit message.
> >=20
> > The only thing that I think that is IMHO lacking is a simple
> > kselftest. I think a trivial test for SGX_IOC_VEP_REMOVE_ALL
> > would do.
>=20
> Yeah, a trivial test wouldn't cover a lot; it would be much better to at=
=20
> least set up a SECS, and check that the first call returns 1 and the=20
> second returns 0.=C2=A0 There is no existing test for /dev/sgx_vepc at al=
l.
>=20
> Right now I'm relying on Yang for testing this in QEMU, but I'll look=20
> into adding a selftest that does the full setup and runs an enclave in a=
=20
> guest.

This having a regression would not working would not cause that much collat=
eral
damage, especially since it would be probably quickly noticed by someone, s=
o I
think that this is not absolutely mandatory. So you can ignore kselftest pa=
rt,
and thus

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Thank you, this work helps me a lot, given that my SGX testing is based aro=
und
using QEMU ATM.

/Jarkko

