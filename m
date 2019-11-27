Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC4510BFF7
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 22:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfK0V5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 16:57:33 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727133AbfK0V5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 16:57:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xARLvN6r042022;
        Wed, 27 Nov 2019 16:57:25 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxqtdbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 16:57:25 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xARLvOu2042219;
        Wed, 27 Nov 2019 16:57:24 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxqtd8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 16:57:24 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xARLt135008387;
        Wed, 27 Nov 2019 21:57:17 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03dal.us.ibm.com with ESMTP id 2wevd72j5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Nov 2019 21:57:17 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xARLvGGx43057616
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Nov 2019 21:57:16 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EED1BE051;
        Wed, 27 Nov 2019 21:57:16 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05454BE04F;
        Wed, 27 Nov 2019 21:57:14 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 27 Nov 2019 21:57:14 +0000 (GMT)
Message-ID: <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 27 Nov 2019 18:57:10 -0300
In-Reply-To: <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
References: <20191021225842.23941-1-sean.j.christopherson@intel.com>
         <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
         <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
         <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
         <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
         <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
         <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
         <20191127194757.GI22227@linux.intel.com>
         <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-YvHALfCMrZZTWTBzRIrY"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-27_04:2019-11-27,2019-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=868
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=2
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911270177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-YvHALfCMrZZTWTBzRIrY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 17:15 -0300, Leonardo Bras wrote:
> > > > > So, suppose these threads, where:
> > > > > - T1 uses a borrowed reference, and=20
> > > > > - T2 is releasing the reference (close, release):
> > > >=20
> > > > Nit: T2 is releasing the *last* reference (as implied by your refer=
ence
> > > > to close/release).
> > >=20
> > > Correct.
> > >=20
> > > > > T1                              | T2
> > > > > kvm_get_kvm()                   |
> > > > > ...                             | kvm_put_kvm()
> > > > > kvm_put_kvm_no_destroy()        |
> > > > >=20
> > > > > The above would not trigger a use-after-free bug, but will cause =
a
> > > > > memory leak. Is my above understanding right?
> > > >=20
> > > > Yes, this is correct.
> > > >=20
> > >=20
> > > Then, what would not be a bug before (using kvm_put_kvm()) now is a
> > > memory leak (using kvm_put_kvm_no_destroy()).
> >=20

Sorry, I missed some information on above example.=20
Suppose on that example that the reorder changes take place so that
kvm_put_kvm{,_no_destroy}() always happens after the last usage of kvm
(in the same syscall, let's say).

Before T1 and T2, refcount =3D 1;

If T1 uses kvm_put_kvm_no_destroy():
- T1 increases refcount (=3D2)
- T2 decreases refcount (=3D1)
- T1 decreases refcount, (=3D0) don't free kvm (memleak)

If T1 uses kvm_put_kvm():
- T1 increases refcount (=3D 2)
- T2 decreases refcount (=3D 1)
- T1 decreases refcount, (=3D 0) frees kvm.

So using kvm_put_kvm_no_destroy() would introduce a memleak where it
would have no bug.

> > No, using kvm_put_kvm_no_destroy() changes how a bug would manifest, as
> > you note below.  Replacing kvm_put_kvm() with kvm_put_kvm_no_destroy()
> > when the refcount is _guaranteed_ to be >1 has no impact on correctness=
.

Yes, you are correct.=20
But on the above case, kvm_put_kvm{,_no_destroy}() would be called
with refcount =3D=3D 1, and if reorder patch is applied, it would not cause
any use-after-free error, even on kvm_put_kvm() case.

Is the above correct?

Best regards,

Leonardo


--=-YvHALfCMrZZTWTBzRIrY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3e8TYACgkQlQYWtz9S
ttQTnA/+KWa1OB0s6oIQx8k0/fYKBdkrFAaM7NsmARe4iggvBxQWR+6Ii1YVVeVO
283oQMalK4v8Q7/VkKIWqoM0ckm3s64Qsq4P1bupxpX1cbOOBAIdsuIdX2Rh6n0G
jvjYoFddzkIgNBZvB/Pt7i9gd7E15dkL8P61v6ZFjsWAigEF/VSV4QKoOq5p81w5
roElJVxLJuLj4uXG6G6zG/a/EPcW2ubL4YJShwt3R+WC7Z7eDt3TDord1KseTEOH
rmxHdMEDI8VKuSdmtW1mBZyXI7AABUjIoaMWcxAURndtIal3huBfJ4qbLYebITkP
hkFxaDorJDqr7Mwowc7V0QNN4E0bw8XHPRY/HdnOFHnjdy9QwaDxUPEwSpns3BPY
3tY2g9usUf2XsZzJjST4TvXA5QUowM0k4kUhaS3mBj+XR+tyjv3BPJBcdJyyxWp2
WVkLOb0iw/urbRRGR0eY6UI82oLHSkymQC0Lkz8GeiMLqxhtPGII6Rn+zje8X2UL
mwncGjVDbk+YDeHDRdtcod6NLZy3gCPxPSPG8GJDL5+QJU70o+4IfuCskjHp8USL
VIS9L9Ue7CCWm5FZvK0gogk2lpBWE9gynJCsT9Csf9cW2y32CnJUHiblDiHDZLDy
9DyNLj39ajxLBIPci8baCLx22b3PI3jFfX75n/ELLQKtCHGlimA=
=AHre
-----END PGP SIGNATURE-----

--=-YvHALfCMrZZTWTBzRIrY--

