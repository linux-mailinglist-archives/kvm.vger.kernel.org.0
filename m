Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51E209990
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 07:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389652AbgFYFrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 01:47:35 -0400
Received: from ozlabs.org ([203.11.71.1]:40971 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbgFYFrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 01:47:32 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 49spv509mmz9sT9; Thu, 25 Jun 2020 15:47:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1593064049;
        bh=gnSHCl8vwImx7o9H0Ein+TSImN511M/Zl2woK1V+Fks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f4RMuflOGe+siIzPupiMAEhRQvHrh8t+/mvPGK44eZgNtCNrBq8v89NlHTANwcj3B
         otoGXUAYuJua6V1vH89LZRpp2hW3l4alcIJp4MgF4/x1Q2GeUTadOXLyZWzitFucsF
         C4BFxkAUXDW7athopwzP1jkL17XoNMP3oDaryPn0=
Date:   Thu, 25 Jun 2020 15:44:48 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com, pair@us.ibm.com,
        pbonzini@redhat.com, dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        mst@redhat.com, cohuck@redhat.com, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200625054448.GF172395@umbus.fritz.box>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <2fa7c84a-6929-ef04-1d61-f76a4cac35f5@de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FeAIMMcddNRN4P4/"
Content-Disposition: inline
In-Reply-To: <2fa7c84a-6929-ef04-1d61-f76a4cac35f5@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--FeAIMMcddNRN4P4/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2020 at 04:27:28PM +0200, Christian Borntraeger wrote:
> On 19.06.20 04:05, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> >=20
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> >=20
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> >=20
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> >=20
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "host-trust-limitation" property pointing to a platform specific
> > object which configures and manages the specific details.
> >=20
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
>=20
> Let me try to summarize what I understand what you try to achieve:
> one command line parameter for all platforms that=20
>=20
> common across all platforms:
> - disable KSM
> - by default enables iommu_platform

Pretty much, yes.  Plus, in future if we discover other things that
don't make sense in the context of a guest whose memory we can't
freely access, it can check for those and set sane defaults
accordingly.

> per platform:
> - setup the necessary encryption scheme when appropriate
> - block migration

That's true for now, but I believe there are plans to make secure
guests migratable, so that's not an inherent property.

> -....
>=20
>=20
> The tricky part is certainly the per platform thing. For example on
> s390 we just have a cpumodel flag that provides interfaces to the guest
> to switch into protected mode via the ultravisor. This works perfectly
> fine with the host model, so no need to configure anything.  The platform
> code then disables KSM _on_switchover_ and not in general.

Right, because your platform code is aware of the switchover.  On
POWER, we aren't.

> Because the=20
> guest CAN switch into protected, but it does not have to.
>=20
> So this feels really hard to do right. Would a virtual BoF on KVM forum
> be too late? We had a BoF on protected guests last year and that was
> valuable.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FeAIMMcddNRN4P4/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl70OdAACgkQbDjKyiDZ
s5IUJQ/9EKOS1WmdsXTeIqzvdTE1f0NTDsgME+rPrh8z6e3ZcJgY1Fei6Clr2Amq
+F5xcLnOAq8P8zfk6dpjyZ8oa0lyxfC6j9n9raoQMJrDL7e4mricPn7ERaSrBcyI
5rTOkx1i64cdlRR1/ajN2N8KpR+IkiTkJVxlXIO8xq7Vgha/sP3hb2qyMLFeCd1H
wj59bduUNo1BMMrU6EAC13S+ZpuiCd10V6XMfmaXGN4Y6IWAKckLCIjTtjWuxA1A
7GNNt88iIFKkIHd7mYLwuHBeryO2D/D/VVym1ssYUfzDWqG6J6K5lwpcjkbrbCLL
rA6N0kIbHZqcIaHgfqf3j3V16oh9r3KJydjDHR2h75lPcqqZNNZ3f5xMFSnYWrXv
6CJ2cxfcI3eF1zPFwVSTOmd8xOx2YJPlVU1RNurwBxO4OVoljsdqfWSErkfB30Zd
7oHOQ9tePXBv3rkzgGpF9RUnqFz2SNyGfzQjvQAzlXTNQRwp6KVS1NazEa6e+VI4
t42scr5er3V9qyp0mwoyq86RAbcObNZS8JOya9RqYJTrJdGFHVeWbSBKYX9vUm0H
cPtlwYHMGT9A+Qk7tbPK4m7kLtu4EMwU6jJl53Dlm5/7AB/Dla+O2/EXQ5cP5vbm
NEhNz5N0yx/v/douwEJCJ8Catj81QtVn+mMh4KfUGt1EFwnufW0=
=6tvg
-----END PGP SIGNATURE-----

--FeAIMMcddNRN4P4/--
