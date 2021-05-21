Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F9D38C0FB
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbhEUHwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:52:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231709AbhEUHwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:52:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621583476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFNWa9esyieVAE3w5yi2oSgXdNIHABakihJ9PdNnIzg=;
        b=NM+DKY4b8DmRxhTlkzb+n5auegEI6t7l+x5BnqEIaSe3BJH3libsU0Awth0kC1iw2gIjsS
        Rc4J08BZMzH4hgs1xaYQz8BT6HCULvBgaD8adJmxoEoA+H0vgpe2dHOBzCdBGwuAe8RkKY
        qeM5nESAVjKDP4wyHpXTuV7cIAj7b6s=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 546E1AACA;
        Fri, 21 May 2021 07:51:16 +0000 (UTC)
Message-ID: <5e6ad92a72e139877fa0e7a1d77682a075060d16.camel@suse.com>
Subject: Re: [PATCH] Move VMEnter and VMExit tracepoints closer to the
 actual event
From:   Dario Faggioli <dfaggioli@suse.com>
To:     Sean Christopherson <seanjc@google.com>,
        Stefano De Venuto <stefano.devenuto99@gmail.com>
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        rostedt@goodmis.org, y.karadz@gmail.com
Date:   Fri, 21 May 2021 09:51:14 +0200
In-Reply-To: <YKaBEn6oUXaVAb0K@google.com>
References: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
         <YKaBEn6oUXaVAb0K@google.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uzzUt4wLPVAF5SK95Cg/"
User-Agent: Evolution 3.40.1 (by Flathub.org) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-uzzUt4wLPVAF5SK95Cg/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sean,

On Thu, 2021-05-20 at 15:32 +0000, Sean Christopherson wrote:
> On Wed, May 19, 2021, Stefano De Venuto wrote:
> >=20
> > This patch moves the tracepoints closer to the events, for both
> > Intel
> > and AMD, so that a combined host-guest trace will offer a more
> > realistic representation of what is really happening, as shown
> > here:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 trace.dat:=
=C2=A0 CPU 0/KVM-2553=C2=A0 [000]=C2=A0 2.190290: write_msr:
> > 48, value 0
>=20
> I'm not sure this is a good thing, as it's not clear to me that
> invoking tracing
> with the guest's SPEC_CTRL loaded is desirable.=C2=A0 Maybe it's a non-
> issue, but it
> should be explicitly called out and discussed.
>=20
Oh, this is actually a very good point. Considering the rest of the
review comments, it looks like we're not putting the tracepoint past
the SPEC_CTRL msr-write, not for now at least. :-) But I agree that it
must be explicitly considered and thought about, if/when trying to do
it again.

> And to some extent, the current behavior is _more_ accurate because
> it shows that
> KVM started its VM-Enter sequence and then the WRMSR occured as part
> of that
> sequence.=C2=A0 It is writing the guest's value after all.=C2=A0 Ditto fo=
r
> XCR0, XSS, PKRU,
> Intel PT, etc...
>=20
Yaah, I guess it comes to what we want/assume the meaning of the
VMEnter/Exit tracepoints to be. I.e., is it the beginning of the
sequence of operations necessary to enter a guest, or the exact point
in time where we switch to it (and vice-versa, for exit)?

In my view and in my experience of trying to trace host and guest at
the same time, I find the latter more useful, but I appreciate that the
former is valid too especially considering that, as you say, some
operations are altering the guest's state already.

> A more concrete example would be perf; on VMX, if a perf NMI happens
> after KVM
> invokes atomic_switch_perf_msrs() then I absolutely want to see that
> reflected
> in the trace, e.g. to help debug the PEBS mess[*].=C2=A0 If the VM-Enter
> tracepoint
> is moved closer to VM-Enter, that may or may not hold true depending
> on where the
> NMI lands.
>=20
> On VMX, I think the tracepoint can be moved below the VMWRITEs
> without much
> contention (though doing so is likely a nop), but moving it below
> kvm_load_guest_xsave_state() requires a bit more discussion.
>=20
Ok, well, IMO closer is better, even if no past XSAVE state handling.
:-) Let us look into this a little bit.

> I 100% agree that the current behavior can be a bit confusing, but I
> wonder if
> we'd be better off "solving" that problem through documentation.
>=20
Indeed. So, do you happen to have in mind what could be the best place
and the best way for documenting this?

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)

--=-uzzUt4wLPVAF5SK95Cg/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAmCnZnIACgkQFkJ4iaW4
c+5t/xAAqhBnZPq/q/f2jBMLeN43l8Zv72euROE1tJOzHkEOcN+uK1mFWehDUnyR
Yj+1RndKTupqLPkkgqeBUMIJYronQ//YY0vowiXOPbh9w6EbyfhKkOi48JiBG6bM
IMpxzXZIQFh8Wwq98Y41xgrQKAEEHn7RDIdeMmht5+Rwr0+MojjnrUDEN1Ic6U0Q
Pv+RSs11wsMmNUeCggo6i0iBmt6q4cT2pyx4PzcZw0FVfRHOGyJ5po/r7es1NsMv
Dbz8QuCtlnaUrec7NNnnxXftihAYIHxvC3nFy3wvVhEEIALwZBS+Cb83MnWH02FU
B7FTZLI2hKOgqYN2qBQRTeO3VJNeUwGeyxRByN4hfFyIqV8/YGEZ93UFHqvTFw5b
gIDwZcjFeSXTUR0pO9oM8Tmm8cJZ06bMbp1e1VsCkYiTDxKJhCpssNd5HcH5vjXJ
wWhvNlW46gWk8ph7oYt8aHHf+s2PD64EDkxVp1iSTmpq5w3/o8b+yYYEfDvWaGlU
6KdQPS92tNNWuJBKpm6SW5KUJFM1vV0ZxNUuzq4UnMGKDWQ3SZBItResOoY5IoCE
M7IRN7WtnJcmT2vBav8oiKyNiL5ROfVIS1MKQRj4D0gn0UKOEmCURLkLLx9NSmOS
ZXaZ9k4CNRtJSQTjCeH2Nyn+FMfuG5BCKsMKQ2c09k4oMpjFzzw=
=Opp8
-----END PGP SIGNATURE-----

--=-uzzUt4wLPVAF5SK95Cg/--

