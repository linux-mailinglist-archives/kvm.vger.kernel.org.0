Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141B52FBA50
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404779AbhASOvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:51:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21652 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389775AbhASKQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:16:43 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA2efg044144;
        Tue, 19 Jan 2021 05:16:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=B2pfOzVPEWvrcHf8yuZvNxs75twumi6cIm3uTetfPxo=;
 b=anpCZsIvzh/U0xNy88BrxMctEm1epYTZwdD6KKNKNIUD0qVGLei7kvqD3w3/V+4mjy0t
 jIgSsvv8ERd+ZiI64SjhKoceEEyIZSAPYY+xnTgGY1yiN48NEjzE9G2JLvMr9E+dovO+
 xnaQAAPmY6Jpy+1JBJ9fg0DwcoCeE1q8w+tX6/ntmVxb6ShaN0w6jLZWiVHMxXJMeDqi
 d21C00uc86n1oaOKw3viD4PbrTsABHrqChoia7CUQuBlTa3QgZ8tvA5wLpV0jeAd4QR8
 AyAfBp7j4NrtK1uZGfpyObj/EIZUf5qzKV6OW9PsRVM5Jb9S47G+D1j97VbfSaRhCIIh 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365v8wjahd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:16:01 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA3Gnm046710;
        Tue, 19 Jan 2021 05:16:00 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365v8wjagj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:16:00 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JACOuV013493;
        Tue, 19 Jan 2021 10:15:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 363t0y9fct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:15:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JAFn0u23331170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:15:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A187AE045;
        Tue, 19 Jan 2021 10:15:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB94CAE055;
        Tue, 19 Jan 2021 10:15:54 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.154.17])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:15:54 +0000 (GMT)
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-2-frankja@linux.ibm.com>
 <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <945319e9-641b-70ea-0e0b-2e71f73cf086@linux.ibm.com>
Date:   Tue, 19 Jan 2021 11:15:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JXmkQwHCz3sbY2Fj0qkTT5EXxMRwhLeHS"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 phishscore=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101190060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JXmkQwHCz3sbY2Fj0qkTT5EXxMRwhLeHS
Content-Type: multipart/mixed; boundary="lz5q6hLeak3dWPor1jJiwzRZnMqWZiCIj";
 protected-headers="v1"
From: Janosch Frank <frankja@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
 imbrenda@linux.ibm.com, cohuck@redhat.com, linux-s390@vger.kernel.org,
 gor@linux.ibm.com, mihajlov@linux.ibm.com
Message-ID: <945319e9-641b-70ea-0e0b-2e71f73cf086@linux.ibm.com>
Subject: Re: [PATCH 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-2-frankja@linux.ibm.com>
 <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>
In-Reply-To: <d72e2823-f30f-02be-1ee5-445496ca9dbc@de.ibm.com>

--lz5q6hLeak3dWPor1jJiwzRZnMqWZiCIj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 1/19/21 11:11 AM, Christian Borntraeger wrote:
>=20
>=20
> On 19.01.21 11:04, Janosch Frank wrote:
>> The number reported by the query is N-1 and I think people reading the=

>> sysfs file would expect N instead. For users creating VMs there's no
>> actual difference because KVM's limit is currently below the UV's
>> limit.
>>
>> The naming of the field is a bit misleading. Number in this context is=

>> used like ID and starts at 0. The query field denotes the maximum
>> number that can be put into the VCPU number field in the "create
>> secure CPU" UV call.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for=
 Ultravisor information")
>> Cc: stable@vger.kernel.org
>> ---
>>  arch/s390/boot/uv.c        | 2 +-
>>  arch/s390/include/asm/uv.h | 4 ++--
>>  arch/s390/kernel/uv.c      | 2 +-
>>  3 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
>> index a15c033f53ca..afb721082989 100644
>> --- a/arch/s390/boot/uv.c
>> +++ b/arch/s390/boot/uv.c
>> @@ -35,7 +35,7 @@ void uv_query_info(void)
>>  		uv_info.guest_cpu_stor_len =3D uvcb.cpu_stor_len;
>>  		uv_info.max_sec_stor_addr =3D ALIGN(uvcb.max_guest_stor_addr, PAGE_=
SIZE);
>>  		uv_info.max_num_sec_conf =3D uvcb.max_num_sec_conf;
>> -		uv_info.max_guest_cpus =3D uvcb.max_guest_cpus;
>> +		uv_info.max_guest_cpu_id =3D uvcb.max_guest_cpu_num;
>>  	}
>> =20
>>  #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
>> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
>> index 0325fc0469b7..c484c95ea142 100644
>> --- a/arch/s390/include/asm/uv.h
>> +++ b/arch/s390/include/asm/uv.h
>> @@ -96,7 +96,7 @@ struct uv_cb_qui {
>>  	u32 max_num_sec_conf;
>>  	u64 max_guest_stor_addr;
>>  	u8  reserved88[158 - 136];
>> -	u16 max_guest_cpus;
>> +	u16 max_guest_cpu_num;
>=20
> I think it would read better if we name this also max_guest_cpu_id.
> Otherwise this looks good.
>=20

Yes, but I wanted to have the same name as in the specification.
So, what do we value more?


--lz5q6hLeak3dWPor1jJiwzRZnMqWZiCIj--

--JXmkQwHCz3sbY2Fj0qkTT5EXxMRwhLeHS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAmAGsVkFAwAAAAAACgkQ41TmuOI4ufh3
8RAAvEI3EI9BFL8WyNz+3cZsOMr9YUwTDQ8hH1ZmxYf6Gn2dxY91L1Tq1KENifEOI00d6N3XSyar
hPt+dZfuumEBMgVgS/7gj68rzf1hMl0aiZzdPAmlCGHbrz/QcwXkcYUyY2Xl5xAyx7AmoI/31JZL
BzYcxOce3LWBiW//oukm2WUC5iF5QTpDxj0SoOBBhs/F4p2eIxD6PLZ0H1ft5+DDU4sJMZx7t2f+
yuyKeGZVjtbGheoCambagQIbfsT67hBo1GNlwXF9AYlfC5U9uqorblnEFAqSevdxxjd0aAd0LOJK
egB+7ERukG4vIcLDXxUEUSfNXlj98I92XLs8sLuZZRmfHLGkMp6hRUuXLXuuATK6lVwtSC22u6ll
3SG1+pQaB9jGkgsfh3BjKcJyU2YDOurCvhrPOYep4AeI/WQPDhCgRDcQ5YQG+Ts0vaGzaqQjRo9H
i3lYOsEU1pxGkXMA7ypDDRQoB1+8hj2eeLpxDHnpEm2o8SelCwS/kFxg2+rVusYnnMzG0yoAW9yR
U01P5kUO6EC0+4rpz2rsI0pNy4pZop36j7ZEqr+RPseXnEk21FOopwOpKArmwb+v394rpvel+Syk
RZnJSvnYE9nJAxZquBVuS7b338azcFe3tYsbF8YssBV9h9yHdrCEO/MalIYpJGnTZdk0uGEcz/oh
3os=
=GVgv
-----END PGP SIGNATURE-----

--JXmkQwHCz3sbY2Fj0qkTT5EXxMRwhLeHS--

