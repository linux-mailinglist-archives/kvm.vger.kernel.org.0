Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42510CC75
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfK1QEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 11:04:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbfK1QEo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 11:04:44 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASG44K1009257;
        Thu, 28 Nov 2019 11:04:38 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxrsrf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 11:04:37 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xASG4A5l009840;
        Thu, 28 Nov 2019 11:04:37 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2whcxrsre6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 11:04:37 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xASG2Kkq005914;
        Thu, 28 Nov 2019 16:04:36 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2wevd7af5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 16:04:36 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASG4ZqL34210226
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 16:04:35 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B20C211206D;
        Thu, 28 Nov 2019 16:04:35 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95AAF112067;
        Thu, 28 Nov 2019 16:04:34 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 16:04:34 +0000 (GMT)
Message-ID: <aba06fb62083a7424a10170c074911de8cd4e347.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Nov 2019 13:04:30 -0300
In-Reply-To: <a924cb9c-8354-23fe-1052-8ad564edad7f@redhat.com>
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
         <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
         <a924cb9c-8354-23fe-1052-8ad564edad7f@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Fts/3gcBB3+hmUFp/MtR"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_04:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 impostorscore=0 clxscore=1015 adultscore=0 suspectscore=2
 phishscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-Fts/3gcBB3+hmUFp/MtR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-11-28 at 14:49 +0100, Paolo Bonzini wrote:
> On 27/11/19 22:57, Leonardo Bras wrote:
> > But on the above case, kvm_put_kvm{,_no_destroy}() would be called
> > with refcount =3D=3D 1, and if reorder patch is applied, it would not c=
ause
> > any use-after-free error, even on kvm_put_kvm() case.
>=20
> I think this is what you're missing: kvm_put_kvm_no_destroy() does not
> protect against bugs in the code that uses it.  It protect against bugs
> _elsewhere_.
>=20
> Therefore, kvm_put_kvm_no_destroy() is always a better choice when
> applicable, because it turns bugs in _other parts of the code_ from
> use-after-free to WARN+leak.
>=20
> Paolo
>=20

Hello Paolo,

Thanks for explaining that! I think I got to understand it better now.

Best regards,
Leonardo

--=-Fts/3gcBB3+hmUFp/MtR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3f8A4ACgkQlQYWtz9S
ttSxLw/+Pxm4KexspPrHxnbhSelogMo2/TtFjJ/t4zpdc8K6tDMRHQrGl2yptMPl
J/Q4pSbmRLTtuqWsBcUEH8+6+NOytwk/qaWUGUF2hxLZZ3qDZ87Pj8y5u0DzXN1k
NkxXofuB7r8CHxutdV4t+q6xL9cXUzNzjIjtg6MkgGUPYtWJCKB2xFy7ESQWga63
kDr03Ekjq3tjk+NsymTj37+jRJeu5oukzzOOIEJ7F6D9Irc5EWGkYJEaZIheQxV8
msAEFLDJJz/YsqueRCSRN8jd07oDIaPJGu2C7nBzMZmHzzZ5Vdaoumbo3nV27uZW
Htf4bYzz0xThqDtjOJ+kgnnoCz362FtdIKFDFo8hJvLsnX4DbPb+OHiyx17mGDO9
ZhOxO576TknKbgJqf5sFMpenygmTDFFZOLKQSOTKxQT9yXJvUIRM4PkygxpKsWg5
8fUs/XM9PG9wvbas8DCgt7iQARsVDyRwFpv/V/Qyv2TgGlkxKof/cOmG6Qj9ntEW
mzkF3fuRHfYuKQXYT/PYRHVaZIpAc7YNwkSVOtMv/5BF+Aou573CZV/LrPoYzuh7
DgPfn8NE8GaMisEksVPv28LT9csmhZ15AD77ZhdJnwbZ2WcluelGzbvChh3xz78y
Q+b4lax6EEkoOUXlwoYvETnHMJnfGFhRRPoJMnRk8HAf2sCJNVc=
=4O3c
-----END PGP SIGNATURE-----

--=-Fts/3gcBB3+hmUFp/MtR--

