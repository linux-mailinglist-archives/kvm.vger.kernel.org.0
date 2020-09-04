Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618D525D796
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 13:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgIDLjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 07:39:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729659AbgIDLjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Sep 2020 07:39:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084BXBMV137811;
        Fri, 4 Sep 2020 07:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=AOv6EMXMKZYWawzy65e8YqQsO0Jqvxw0XyAQChqZGXw=;
 b=bQObKiAWAKpxvKWcVVif8rVzL6Iy/gV+Qy6C0AsXwqlbnaWrv4XrXaUXHrFcUbf+ojtX
 EgC2fl5XrU6EGHiDCpJVoUYFyUpu3TRq7ZX6+EeTwYBCT0z8qAsH0B+dLBNpyedXMxwS
 0atGmiAR82vBGUGrVlZe0+xjrTyEI/DVA0fsIHrnKUFq4+7A4B84pTykupjFCxjHnVDX
 cxXqOQ/QNNTpgVTCQzRLHjtYc/qoDSvIzaZ2uPGVcE0TcUZa/s98fMRIP6cFGzzr4EDY
 RI1mDFN2B/Cl5EGVXeVcxZbhFW8Gvy6F82i4K4/l+s88Fx2uBbT53P/YLXmKziruIcv2 gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bhmewsx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 07:39:00 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 084BXAZ0137677;
        Fri, 4 Sep 2020 07:39:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33bhmewswa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 07:38:59 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 084BbWXP010111;
        Fri, 4 Sep 2020 11:38:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 337en8ete5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Sep 2020 11:38:57 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 084BbMtw63504672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Sep 2020 11:37:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C5D642045;
        Fri,  4 Sep 2020 11:38:54 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C46D242042;
        Fri,  4 Sep 2020 11:38:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.183.173])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Sep 2020 11:38:53 +0000 (GMT)
Subject: Re: [PATCH 1/2] s390x: uv: Add destroy page call
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com
References: <20200903131435.2535-1-frankja@linux.ibm.com>
 <20200903131435.2535-2-frankja@linux.ibm.com> <20200904103939.GE6075@osiris>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <98237148-bbb4-c6d7-aba2-6fa11fb788b1@linux.ibm.com>
Date:   Fri, 4 Sep 2020 13:38:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200904103939.GE6075@osiris>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ty87bI7MgMKm6fXe49RqHo8ycbhLLhy96"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_06:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009040106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ty87bI7MgMKm6fXe49RqHo8ycbhLLhy96
Content-Type: multipart/mixed; boundary="5gYus1bgkJ2xCtNJM2WNdNZpXxcjIOGZ1"

--5gYus1bgkJ2xCtNJM2WNdNZpXxcjIOGZ1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/4/20 12:39 PM, Heiko Carstens wrote:
> On Thu, Sep 03, 2020 at 09:14:34AM -0400, Janosch Frank wrote:
>> +int uv_destroy_page(unsigned long paddr)
>> +{
>> +	struct uv_cb_cfs uvcb =3D {
>> +		.header.cmd =3D UVC_CMD_DESTR_SEC_STOR,
>> +		.header.len =3D sizeof(uvcb),
>> +		.paddr =3D paddr
>> +	};
>> +
>> +	if (uv_call(0, (u64)&uvcb))
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +

I need to remove one of those \n

>>  /*
>>   * Requests the Ultravisor to encrypt a guest page and make it
>>   * accessible to the host for paging (export).
>> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
>> index 373542ca1113..cfb0017f33a7 100644
>> --- a/arch/s390/mm/gmap.c
>> +++ b/arch/s390/mm/gmap.c
>> @@ -2679,7 +2679,7 @@ static int __s390_reset_acc(pte_t *ptep, unsigne=
d long addr,
>>  	pte_t pte =3D READ_ONCE(*ptep);
>> =20
>>  	if (pte_present(pte))
>> -		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
>> +		WARN_ON_ONCE(uv_destroy_page(pte_val(pte) & PAGE_MASK));
>=20
> Why not put the WARN_ON_ONCE() into uv_destroy_page() and make that
> function return void?
>=20
If you prefer that, I'll change the patch.

I think we'd need a proper print of the return codes of the UVC anyway,
the warn isn't very helpful if you want to debug after the fact.


--5gYus1bgkJ2xCtNJM2WNdNZpXxcjIOGZ1--

--Ty87bI7MgMKm6fXe49RqHo8ycbhLLhy96
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9SJ00ACgkQ41TmuOI4
ufgwCA/+IwTFYXBSyrr4KJtIPoXgxNzI2KFUQwJBCuOl/dOCYBLQCz4NGfj6Ijh1
cnXOhIni65ZgFsQ8Year5Pw9k47yO4CPznu/txjwvtEy2ACR6Fav7kUv2RaARzMr
hLT2UynecUZAic1I+3P4zeBk9rPE7uf6VSTRhdlyIpUViL6VasuwpMN7kihG5YbO
erhpxkiNWYrXVmaNRQ4GxbQ5rs07+8I+7s+K8V9arU2LyUxMVnM3FeAE8D37FXEc
ZWq00ghAs2FbmdNG6RbpkOS4VEYR7j8MxNv7k3gaLJIj3p9sYXUK5BsASesrE5JD
6rLNPoTO6w2AlHg2STwxVHI84ubo2kjovaJTj4bCJX/FgZIzmlmlckIBYXT9U/Fe
j7EoyqY4mEvYaXvkwyf1m6L5tWR3hIPRpmhP0F+FingHO4lOLlpccCmgpIaUdiol
b2KPMkH32uH+Lcri9LD2TUAYEE5Px7Fodjs5wlvLJ+SXPonWocsDPrxXQY+LQmDw
W+DZPloFCen3fe2wgkrxR8eVjbjgLSJD4Dyfzafc79SiaKSO6dEx5bKNdFP5rTzU
lMNKS7NsgmW4O+maZiwuDJEB7atKkQv9movF2PXCoeOU44hZ0KL660jEgO9JQ06x
dxoF+s8uftOHQvsgWm596UP2AcIwrexLuk2v5s9//8cvK0ryTLI=
=enNr
-----END PGP SIGNATURE-----

--Ty87bI7MgMKm6fXe49RqHo8ycbhLLhy96--

