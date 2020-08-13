Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB49243B7A
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 16:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgHMOWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 10:22:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20777 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726252AbgHMOWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 10:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597328566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G++udBCxoR/wLpN6cjWAKuhfb/kHVkuG0cocPeBDxxY=;
        b=Jjc2z/jhgbIhhoqzi2xem8OhMJU9Dx1xY4JStwHzyXIZc82DUG5Vq4fZAxSs519czmG+m3
        M4YWPClyJUP1D1t50L60Juk8rJg8wzCK+lVRbRt3H3T1Nb5v8KZjv5lMJqYoN4zXzh63Wm
        EEABCdZEHe2qiE7cCpm9L0GmevGUC80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-lW1JyTvYNQa8BAIJAyCRng-1; Thu, 13 Aug 2020 10:22:44 -0400
X-MC-Unique: lW1JyTvYNQa8BAIJAyCRng-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 148D91015DBC;
        Thu, 13 Aug 2020 14:22:43 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E2E162A82;
        Thu, 13 Aug 2020 14:22:37 +0000 (UTC)
Date:   Thu, 13 Aug 2020 16:22:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 4/4] s390x: add Protected VM support
Message-ID: <20200813162234.01db539f.cohuck@redhat.com>
In-Reply-To: <87d03uhevw.fsf@linux.ibm.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com>
        <20200812092705.17774-5-mhartmay@linux.ibm.com>
        <20200813135642.4f493049.cohuck@redhat.com>
        <87d03uhevw.fsf@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Aug 2020 15:08:51 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> On Thu, Aug 13, 2020 at 01:56 PM +0200, Cornelia Huck <cohuck@redhat.com>=
 wrote:
> > On Wed, 12 Aug 2020 11:27:05 +0200
> > Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
> > =20
> >> Add support for Protected Virtual Machine (PVM) tests. For starting a
> >> PVM guest we must be able to generate a PVM image by using the
> >> `genprotimg` tool from the s390-tools collection. This requires the
> >> ability to pass a machine-specific host-key document, so the option
> >> `--host-key-document` is added to the configure script.
> >>=20
> >> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> >> ---
> >>  configure               |  8 ++++++++
> >>  s390x/Makefile          | 17 +++++++++++++++--
> >>  s390x/selftest.parmfile |  1 +
> >>  s390x/unittests.cfg     |  1 +
> >>  scripts/s390x/func.bash | 18 ++++++++++++++++++
> >>  5 files changed, 43 insertions(+), 2 deletions(-)
> >>  create mode 100644 s390x/selftest.parmfile
> >>  create mode 100644 scripts/s390x/func.bash
> >>=20
> >> diff --git a/configure b/configure
> >> index f9d030fd2f03..aa528af72534 100755
> >> --- a/configure
> >> +++ b/configure
> >> @@ -18,6 +18,7 @@ u32_long=3D
> >>  vmm=3D"qemu"
> >>  errata_force=3D0
> >>  erratatxt=3D"$srcdir/errata.txt"
> >> +host_key_document=3D
> >> =20
> >>  usage() {
> >>      cat <<-EOF
> >> @@ -40,6 +41,8 @@ usage() {
> >>  	                           no environ is provided by the user (enabl=
ed by default)
> >>  	    --erratatxt=3DFILE       specify a file to use instead of errata=
.txt. Use
> >>  	                           '--erratatxt=3D' to ensure no file is use=
d.
> >> +	    --host-key-document=3DHOST_KEY_DOCUMENT
> >> +	                           host-key-document to use (s390x only) =20
> >
> > Maybe a bit more verbose? If I see only this option, I have no idea
> > what it is used for and where to get it. =20
>=20
> =E2=80=9CSpecifies the machine-specific host-key document required to cre=
ate a
> PVM image using the `genprotimg` tool from the s390-tools collection
> (s390x only)=E2=80=9D
>=20
> Better?

"specify the machine-specific host-key document for creating a PVM
image with 'genprotimg' (s390x only)"

I think you can figure out where to get genprotimg if you actually know
that you want it ;)

(...)

> >> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> >> new file mode 100644
> >> index 000000000000..5c682cb47f73
> >> --- /dev/null
> >> +++ b/scripts/s390x/func.bash
> >> @@ -0,0 +1,18 @@
> >> +# Run Protected VM test
> >> +function arch_cmd()
> >> +{
> >> +	local cmd=3D$1
> >> +	local testname=3D$2
> >> +	local groups=3D$3
> >> +	local smp=3D$4
> >> +	local kernel=3D$5
> >> +	local opts=3D$6
> >> +	local arch=3D$7
> >> +	local check=3D$8
> >> +	local accel=3D$9
> >> +	local timeout=3D${10}
> >> +
> >> +	kernel=3D${kernel%.elf}.pv.bin
> >> +	# do not run PV test cases by default
> >> +	"$cmd" "${testname}_PV" "$groups pv nodefault" "$smp" "$kernel" "$op=
ts" "$arch" "$check" "$accel" "$timeout" =20
> >
> > If we don't run this test, can we maybe print some informative message
> > like "PV tests not run; specify --host-key-document to enable" or so?
> > (At whichever point that makes the most sense.) =20
>=20
> Currently, the output looks like this:
>=20
> $ ./run_tests.sh   =20
> PASS selftest-setup (14 tests)
> SKIP selftest-setup_PV (test marked as manual run only)
> PASS intercept (20 tests)
> SKIP intercept_PV (test marked as manual run only)
> =E2=80=A6
>=20
> And if you=E2=80=99re trying to run the PV tests without specifying the h=
ost-key
> document it results in:
>=20
> $ ./run_tests.sh -a
> PASS selftest-setup (14 tests)
> FAIL selftest-setup_PV=20
> PASS intercept (20 tests)
> FAIL intercept_PV=20
> =E2=80=A6
>=20
> But if you like I can return a hint that the PVM image was not
> generated. Should the PV test case then be skipped?

Yes, I was expecting something like

SKIP selftest-setup_PV (no host-key document specified)
SKIP intercept_PV (no host-key document specified)

so that you get a hint what you may want to set up.

