Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F4D10CCD3
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 17:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfK1Q3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 11:29:10 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57682 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726510AbfK1Q3K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 11:29:10 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASGQeHX168002;
        Thu, 28 Nov 2019 11:29:05 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wjah6qc8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 11:29:05 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id xASGQvHX169335;
        Thu, 28 Nov 2019 11:29:04 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wjah6qc80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 11:29:04 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xASGQgIc010162;
        Thu, 28 Nov 2019 16:29:03 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 2wevd6xvqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 16:29:03 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASGT28545744420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 16:29:02 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80291AC066;
        Thu, 28 Nov 2019 16:29:02 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62BA5AC05B;
        Thu, 28 Nov 2019 16:29:01 +0000 (GMT)
Received: from leobras.br.ibm.com (unknown [9.18.235.137])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 28 Nov 2019 16:29:01 +0000 (GMT)
Message-ID: <45e643bce58e0f7c9646bb6c548c4e9f026f1fa8.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: Add separate helper for putting borrowed reference
 to kvm
From:   Leonardo Bras <leonardo@linux.ibm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 28 Nov 2019 13:29:00 -0300
In-Reply-To: <20191128010001.GJ22227@linux.intel.com>
References: <de313d549a5ae773aad6bbf04c20b395bea7811f.camel@linux.ibm.com>
         <20191126171416.GA22233@linux.intel.com>
         <0009c6c1bb635098fa68cb6db6414634555039fe.camel@linux.ibm.com>
         <e1a4218f-2a70-3de3-1403-dbebf8a8abdf@redhat.com>
         <bfa563e6a584bd85d3abe953ca088281dc0e167b.camel@linux.ibm.com>
         <6beeff56-7676-5dfd-a578-1732730f8963@redhat.com>
         <adcfe1b4c5b36b3c398a5d456da9543e0390cba3.camel@linux.ibm.com>
         <20191127194757.GI22227@linux.intel.com>
         <103b290917221baa10194c27c8e35b9803f3cafa.camel@linux.ibm.com>
         <41fe3962ce1f1d5f61db5f5c28584f68ad66b2b1.camel@linux.ibm.com>
         <20191128010001.GJ22227@linux.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-lkoTnqA1IktRvD8hYwr4"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_05:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=997 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-lkoTnqA1IktRvD8hYwr4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-27 at 17:00 -0800, Sean Christopherson wrote:
> > Sorry, I missed some information on above example.=20
> > Suppose on that example that the reorder changes take place so that
> > kvm_put_kvm{,_no_destroy}() always happens after the last usage of kvm
> > (in the same syscall, let's say).
>=20
> That can't happen, because the ioctl() holds a reference to KVM via its
> file descriptor for /dev/kvm, and ioctl() in turn prevents the fd from
> being closed.
>=20
> > Before T1 and T2, refcount =3D 1;
>=20
> This is what's impossible.  T1 must have an existing reference to get
> into the ioctl(), and that reference cannot be dropped until the ioctl()
> completes (and by completes I mean returns to userspace). Assuming no
> other bugs, i.e. T2 has its own reference, then refcount >=3D 2.
>=20

Thanks for explaining, I think I get it now.

Best regards,
Leonardo Bras

--=-lkoTnqA1IktRvD8hYwr4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEMdeUgIzgjf6YmUyOlQYWtz9SttQFAl3f9cwACgkQlQYWtz9S
ttQiShAAmAyXr/SVVcZnPHuqz3y4cJ53nMVktdEAtF8U0z3IdztHygSaR/fDLJh7
l9gbD8FHe5Q5mm/cJ22GvZBpi1UJZfq0PZkc9X6h8laGCoBB3hZROkKTyPdeIxD2
1OaisVXrjDi6F/Y9NgRfwhtYdja7MrDEXhzxfcvHf2wylukYIQ58AaZd2f/zgD/X
1Br2XHdKZrKb59MUr4zjWr4v5mNn3Irt16MmdCeZeW5WKiPWvfNPgDSeJhsWWhvH
TudyzCickYAn+uOu91BCwzX6oiKRhhWmacI7OB6fByypGaP36yLCxmfyzgIDAvsL
BSS7eqCbVFN5x/fSqwHTfXobnTGiLLGJJAzRxsZ6pECitcEgDlyHVg4I3n1nmktV
Dsvg2efxVwdhADXesl1d6G3UO51g0vkz4doRq2T+EvONdCp9zpjR6FmpjNQo3VVu
jtCfKGayQA3stSSB8iPXllAQ1AhwfqApCmSlRciH5+st2C9GTqocEGWnrxbwAsx4
+6ukeybJxv/bFE568gMvulVUIsLGxQi0Hm2TliyqxTKvhv6Fi8StnP+zo0koquuC
IKk4KfpkMHpcwG39X3IYH0tTJW7NFZKR/FBrTN9D6CazZJLvB2RmUmX01C+1d+hq
sEbfMtyt7TBruoiT4wrPTEV36FQN+nhKBLFzDH22GYT5xy3aPdQ=
=/1KK
-----END PGP SIGNATURE-----

--=-lkoTnqA1IktRvD8hYwr4--

