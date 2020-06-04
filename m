Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9861EE1B3
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 11:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgFDJp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 05:45:27 -0400
Received: from 13.mo3.mail-out.ovh.net ([188.165.33.202]:53544 "EHLO
        13.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFDJp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 05:45:27 -0400
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2020 05:45:24 EDT
Received: from player711.ha.ovh.net (unknown [10.108.57.95])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id C206C257A58
        for <kvm@vger.kernel.org>; Thu,  4 Jun 2020 11:08:52 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player711.ha.ovh.net (Postfix) with ESMTPSA id 7121712DFA0B3;
        Thu,  4 Jun 2020 09:08:31 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-104R0053139fd52-1911-4642-b917-db792ecb09ea,0E78B47C015AB62E5F4E4B3B4EB6DB016BBCF3B5) smtp.auth=groug@kaod.org
Date:   Thu, 4 Jun 2020 11:08:21 +0200
From:   Greg Kurz <groug@kaod.org>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     Thiago Jung Bauermann <bauerman@linux.ibm.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        qemu-devel@nongnu.org, dgilbert@redhat.com, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, mdroth@linux.vnet.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory
 protection
Message-ID: <20200604105228.2cb311d3@kaod.org>
In-Reply-To: <20200604064414.GI228651@umbus.fritz.box>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
        <87tuzr5ts5.fsf@morokweng.localdomain>
        <20200604064414.GI228651@umbus.fritz.box>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T8M54mOA9k=ZBfZa=7RzYIy";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Ovh-Tracer-Id: 13412845592681355750
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudeguddguddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtsehgtderreertddvnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeggfekuddvuddtgfekkeejleegjeffheduuefhledtteeftdfhffdtgfegiefhvdenucfkpheptddrtddrtddrtddpkedvrddvheefrddvtdekrddvgeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeduuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--Sig_/T8M54mOA9k=ZBfZa=7RzYIy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jun 2020 16:44:14 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> On Thu, Jun 04, 2020 at 01:39:22AM -0300, Thiago Jung Bauermann wrote:
> >=20
> > Hello David,
> >=20
> > David Gibson <david@gibson.dropbear.id.au> writes:
> >=20
> > > A number of hardware platforms are implementing mechanisms whereby the
> > > hypervisor does not have unfettered access to guest memory, in order
> > > to mitigate the security impact of a compromised hypervisor.
> > >
> > > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > > to accomplish this in a different way, using a new memory protection
> > > level plus a small trusted ultravisor.  s390 also has a protected
> > > execution environment.
> > >
> > > The current code (committed or draft) for these features has each
> > > platform's version configured entirely differently.  That doesn't seem
> > > ideal for users, or particularly for management layers.
> > >
> > > AMD SEV introduces a notionally generic machine option
> > > "machine-encryption", but it doesn't actually cover any cases other
> > > than SEV.
> > >
> > > This series is a proposal to at least partially unify configuration
> > > for these mechanisms, by renaming and generalizing AMD's
> > > "memory-encryption" property.  It is replaced by a
> > > "guest-memory-protection" property pointing to a platform specific
> > > object which configures and manages the specific details.
> > >
> > > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> >=20
> > Thank you very much for this series! Using a machine property is a nice
> > way of configuring this.
> >=20
> > >From an end-user perspective, `-M pseries,guest-memory-protection` in
> > the command line already expresses everything that QEMU needs to know,
> > so having to add `-object pef-guest,id=3Dpef0` seems a bit redundant. Is
> > it possible to make QEMU create the pef-guest object behind the scenes
> > when the guest-memory-protection property is specified?
> >=20
> > Regardless, I was able to successfuly launch POWER PEF guests using
> > these patches:
> >=20
> > Tested-by: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> >=20
> > > can be extended to cover the Intel and s390 mechanisms as well,
> > > though.
> > >
> > > Note: I'm using the term "guest memory protection" throughout to refer
> > > to mechanisms like this.  I don't particular like the term, it's both
> > > long and not really precise.  If someone can think of a succinct way
> > > of saying "a means of protecting guest memory from a possibly
> > > compromised hypervisor", I'd be grateful for the suggestion.
> >=20
> > Is "opaque guest memory" any better? It's slightly shorter, and slightly
> > more precise about what the main characteristic this guest property con=
veys.
>=20
> That's not a bad one, but for now I'm going with "host trust
> limitation", since this might end up covering things other than just
> memory protection.
>=20

Any idea what these other things might be ? It seems a bit hard to
decide of a proper name without a broader picture at this point.

--Sig_/T8M54mOA9k=ZBfZa=7RzYIy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEtIKLr5QxQM7yo0kQcdTV5YIvc9YFAl7YugUACgkQcdTV5YIv
c9YaHRAAsCGaQhAxkJQswzk2fB4NUMaNIjaDUka+MU/TxbgZuYyMNrvklAyPjG/a
Rzr281IzBU907eLOuP3KM0jf3enSdU3DpfD1fll2Dzw9eSgNphvMrCf4xkD4wcad
rSkID8GRegn4KbK7GL4xCFdvPE1egiAwVRjPMkJi9yVDdPgRkhufIlswWoN5Mhx/
ydKcdmjbP9fbKu5d9y6aa0D9Uw/lt1PpIbU8yHJnOuRz9HBROCx5CJ8mD9IgSgd8
IWums28UJKvVwq+zJojQButne51nVkHjn9yY2VxW3WAj7JpjHBdm4o3VdbeNFUTm
MXaYmCBMcuwTxMrqxXvR32byRhRCHw/2q6PkEAUkxa0SHBIsqjhmU+mUU0hgqrYt
lPynCReqrJ2M0JabdYfrpXQvCTp6L7LmHBmzR/4wfMvF1PI1oKe4cp7uvDDpfXql
NHfckWS5V+QQYq87YmriFP56aVxRNx6lmSGk3mXS6ohn01GJ9z2O3/LQY5pIFCxb
fnTh58xb4y05+/+cQa85CWEa+HuGNxXA7p0DecHE5gEeG8imrNH7vu4SzSwcD5qO
WmgGCNF1qftUZDOzWUQuj1mjwaaW0mnIYseqb41mFxpg6vvKeebmhbgObUx2N1by
AkEqzB8IaCxO7/b7yYPyhv1R1aWIxEmBTQhJvr53nzWmAWSgupQ=
=zeHm
-----END PGP SIGNATURE-----

--Sig_/T8M54mOA9k=ZBfZa=7RzYIy--
