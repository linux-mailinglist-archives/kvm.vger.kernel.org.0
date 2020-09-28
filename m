Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7207327A971
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 10:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgI1IWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 04:22:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45654 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgI1IWt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 04:22:49 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S80hAs048950;
        Mon, 28 Sep 2020 04:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=pp1; bh=7Co01wj5qUmlD+w9viGdemqJM0vjytfZ67RkZNJo4YY=;
 b=fQ33QUZ/7vUw8bAen8p6MLp+cBZed8eVs5WmGBmtssTtJcNU9pH8CQyiMK567bdIbT/m
 8Z08OLBuxgECbEmasf3oidgMyaKYHy9kbz/B/VqSt4fu7qwmY6J6YFmAllAvB2lBbDDF
 +EpOIflCEIjGAQLPZLnZlVRcMzQoIKZ2QYZSWCStD8PU/i1PblP4eF//MJmCdXuI6n9x
 u+wvOYyDf0j+C9+yGMXiLV8evzGCMilFGTMcG7sBADjD+9FA6WMi+dF41eqhSrFhnuEO
 96iQzoI6SofEdje99SbbpTc9iht5oBJBzOc0SaRc90pMfw8/WJNhpGm+dBfDeiIMDHQv Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33u9nbmpsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 04:22:47 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08S80sFb049986;
        Mon, 28 Sep 2020 04:22:47 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33u9nbmpsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 04:22:47 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08S8I45Z009220;
        Mon, 28 Sep 2020 08:22:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgryt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 08:22:45 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08S8MgQh30081516
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 08:22:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7676F52051;
        Mon, 28 Sep 2020 08:22:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.40.163])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 08DF952050;
        Mon, 28 Sep 2020 08:22:41 +0000 (GMT)
Subject: Re: [PATCH v1 2/4] s390x: pv: implement routine to share/unshare
 memory
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
 <1601049764-11784-3-git-send-email-pmorel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <6c87a0ef-63ef-a0b8-58ff-d60e58bdb223@linux.ibm.com>
Date:   Mon, 28 Sep 2020 10:22:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1601049764-11784-3-git-send-email-pmorel@linux.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wlCwQ6Ss9n5G0nlWIqOLmcEv41lkqv5Og"
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wlCwQ6Ss9n5G0nlWIqOLmcEv41lkqv5Og
Content-Type: multipart/mixed; boundary="Rzxd9G4bNo0gXEvb26jVDBGQpEComrMrA"

--Rzxd9G4bNo0gXEvb26jVDBGQpEComrMrA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/25/20 6:02 PM, Pierre Morel wrote:
> When communicating with the host we need to share part of
> the memory.
>=20
> Let's implement the ultravisor calls for this.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Suggested-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>=20
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 4c2fc48..19019e4 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -71,4 +71,37 @@ static inline int uv_call(unsigned long r1, unsigned=
 long r2)
>  	return cc;
>  }
> =20
> +static inline int share(unsigned long addr, u16 cmd)
> +{
> +	struct uv_cb_share uvcb =3D {
> +		.header.cmd =3D cmd,
> +		.header.len =3D sizeof(uvcb),
> +		.paddr =3D addr
> +	};
> +
> +	uv_call(0, (u64)&uvcb);
> +	return uvcb.header.rc;

That's not a great idea, rc is > 1 for error codes...
In the kernel we check for the cc instead since uv_call() has only 0/1
as possible cc return values.

> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page shared with the
> + * hypervisor for IO.
> + *
> + * @addr: Real or absolute address of the page to be shared
> + */
> +static inline int uv_set_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_SET_SHARED_ACCESS);
> +}
> +
> +/*
> + * Guest 2 request to the Ultravisor to make a page unshared.
> + *
> + * @addr: Real or absolute address of the page to be unshared
> + */
> +static inline int uv_remove_shared(unsigned long addr)
> +{
> +	return share(addr, UVC_CMD_REMOVE_SHARED_ACCESS);
> +}
> +
>  #endif
>=20



--Rzxd9G4bNo0gXEvb26jVDBGQpEComrMrA--

--wlCwQ6Ss9n5G0nlWIqOLmcEv41lkqv5Og
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl9xnVEACgkQ41TmuOI4
ufgrNg//SZGk2WtnjZ6BsyX9qY3dtFy4pt6J3yxgwnNMOAUPUbQ17nyRdXoTI20G
1XW9IyXC/R5cijZ43ih6jcd4oz+l4HfbMIRIPZdEX32GMTjDGxbbmEqxfL9uHz1h
1NXwJ5M8hE5GasyyZG50jlrp+awGgZ45K1/jDfuef2Okfa3+EjJWjgQ3mUrjxblC
EctRzteBXQPGxy2nUP45CvESt0Q/bTOQsQZkCqWQpRcM6IvKDlNMAwdEZ2i00qb0
wmIix5bEFfVPspd6vCJ/t1EQK1+FOef2BPafaL0ldadgQdS38KHYjtEgaPSkDlEE
jlifaQJNvS1m2xN4oSRzXZEUJxmogAjyHy8Dv943YZJiOnPrBhavaEnas5jauojf
dGVGOzYNUy7Tz2YYyLPIWaYKcY0pJJ+/DsH0jSoHQKY2Tiz8MIV2L0rugDQQzlVN
QcHl2+FOvJ+crCKHUAhgTRvXJmjn5s2qqdnv2Fz6VJxEy4W6JM4Ey+E8ejimo2qt
OGgPrgcMGmhTNDcm5hHvSJX1T10U1A+temW4jT9OsYKvLR1aPKOrDeM+3JOz8Zx6
Sc56Kf1cTfvZs0VBj9FipsKn68KDlEGU9JafE/1iUcdJWsSbSOcIARdA82mVT+Br
E6g5qEOKWhn0zUcp3aV8SMHJT1IvyqEH/QcvUF4F9bkFY6Fuwds=
=Offx
-----END PGP SIGNATURE-----

--wlCwQ6Ss9n5G0nlWIqOLmcEv41lkqv5Og--

