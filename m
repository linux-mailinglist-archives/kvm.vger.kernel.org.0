Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5FB204E05
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731888AbgFWJdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731786AbgFWJdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 05:33:20 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2016C061573;
        Tue, 23 Jun 2020 02:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XVgP/PctBqJeW7JDqvouvQRrXRHjlxZTGxeF2IRtkpg=; b=N5tZXcc8BD2j+X6gFYm94ce8eJ
        W+D+b2Wna0rnhFRpaQqDWTmavQWAOS0V/Im/fsGPLpJvkU/YdrPwVRxUqttLxxWCeLEcStH4ZT49B
        3Jm9vkG7l2YCqfA4atcqtKolWnpX+tNkwZwZ2g2e8abmFRmZVkUMwSmiM/puM7sOEFyuLx5JlbGgv
        HTfwvJRyWOq2C4vlCdGGVrf+UyKg0wEd5RWURJ9b+XgZUhHV6cfOOufrcIKhFd4S2n7wTYQvai6r5
        WcUV5EKtwJiR4rkDowdyxg4RBoUFuEWlP5oZpDbKX4LRgDJvs3s4mn4Olm1FC5Lft3bzzH6dU4x57
        KPpMAqyw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnfI9-0002rp-BP; Tue, 23 Jun 2020 09:32:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0D19C300F28;
        Tue, 23 Jun 2020 11:32:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EDE10237095DD; Tue, 23 Jun 2020 11:32:30 +0200 (CEST)
Date:   Tue, 23 Jun 2020 11:32:30 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     syzbot <syzbot+dbf8cf3717c8ef4a90a0@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        x86@kernel.org, elver@google.com
Subject: Re: linux-next build error (9)
Message-ID: <20200623093230.GD4781@hirez.programming.kicks-ass.net>
References: <000000000000c25ce105a8a8fcd9@google.com>
 <20200622094923.GP576888@hirez.programming.kicks-ass.net>
 <20200623124413.08b2bd65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20200623124413.08b2bd65@canb.auug.org.au>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2020 at 12:44:13PM +1000, Stephen Rothwell wrote:
> Hi Peter,
>=20
> On Mon, 22 Jun 2020 11:49:23 +0200 Peter Zijlstra <peterz@infradead.org> =
wrote:

> > Hurmph, I though that was cured in GCC >=3D 8. Marco?
>=20
> So what causes this? Because we got a couple of these in our s390 builds =
last night as well.

This is KASAN's __no_sanitize_address function attribute. Some GCC
versions are utterly wrecked when that function attribute is combined
with inlining. It wants to have matching attributes for the function
being inlined and function it is inlined into -- hence the function
attribute mismatch.

> kernel/locking/lockdep.c:805:1: error: inlining failed in call to always_=
inline 'look_up_lock_class': function attribute mismatch
> include/linux/debug_locks.h:15:28: error: inlining failed in call to alwa=
ys_inline '__debug_locks_off': function attribute mismatch
>=20
> s390-linux-gcc (GCC) 8.1.0 / GNU ld (GNU Binutils) 2.30

*groan*... So supposedly it was supposed to work on GCC-8 and later, see
commit 7b861a53e46b6. But now it turns out there's some later versions
that fail too.

I suppose the next quest is finding a s390 compiler version that works
and then bumping the version test in the aforementioned commit.

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEv3OU3/byMaA0LqWJdkfhpEvA5LoFAl7xzCcACgkQdkfhpEvA
5LpS8hAAiCq1u5KZtbSLBd1h7uWs5MluIRQlxH3Lwjm5BzMpV5X3z8Gd4PGJDcUv
jXyQonD/+OdSUIZVIq5TjrpSntrmMjYhbsPMke/8/A7XGZPLe0zhvfYf1PiXbUU3
Cp85cpbTMwLgJDZbz6h6Lu5PdLJLO5YopIe2RppRsgPulBUgGyIOFaRDMh7YWsFc
IwnBTjrJiPSy3PxsgyteNmxEAtyN4MLoZsqxcpiE39WtCXf9qMADV3wnh8saRyHf
8kvowW/6O/rLwmjOoiGKUMlRb/0RYvSqPSBdQw/5a2XzIHfoOviHOLroAaCeiVd/
g5qRtGjjWHP0QtOoNT+gEaxn9JsAbAaoasML2uza7tMxzE2w+fmLstGwNpxf+cTi
PlXSKiJmdhXjm0mVA7pTupNrGRUyUkyN2z18J4/ct49EkZfwGEQSnq6b5EjB6bZB
Z6aRfe6TfdFqkrGWUqaGmipIVNNY36zAlb8EhrnKeCC5ewQ9J9cwnA0fHkWu+lTY
ihgvveUktZEjw097fkW2ZleNQLCObDiEpJFHvlNKnVZlW/crMzJYbJfd53smXltZ
wBQ39ad43l+plg5pqdjsOx4VkIsgtne6n7/PpKaDW64KV6Zth7ckgK6q+czSdqZx
gOkP0vG538OhOkf97QO+D6jxvpbW7hopSUlBLYqMu/6z0hJzbNE=
=uKOi
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
