Return-Path: <kvm+bounces-4828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1A7A818B53
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 16:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 74623B2109E
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:37:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21C61CA95;
	Tue, 19 Dec 2023 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X8zhlrPG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77161CA87
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJFRC8K011989;
	Tue, 19 Dec 2023 15:37:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=SJxS9mfNqf5vQBi0bSRRuy5WD53vGCb9rCIXlb/7wEw=;
 b=X8zhlrPGYLAia4q5CKyKSWNgfg9j91AcIzRX+um+oYnDLQSxhCHfXOC8uVSaDwTAvgOq
 6iSycYxbCTzBbBerqkcQjndXI2z33ZxQOrdEQx+au7o9nzDD0/3ibG0koUabx5DzJOY+
 zQe5OZbDaRxjP7Wbaas7ROyD8jOeJgVoprESJkrn+agHHSoUxAprqdpymVNgXGmWHy0R
 NInQw143qk4S+W+vXG/i4HNo33r2WQuDVQZhGJIh1XWSH1vSDMT3jg1gjMRW363CgNx7
 WCoQgQUN6s4WJRNiRvD+0hqcj6ktfsMANHk5zfvgl6hegl3uUUg04Ge1ij6/2HCi3oJ/ Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3dtv8a0w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 15:37:30 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJFTLwN018623;
	Tue, 19 Dec 2023 15:37:29 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3dtv8a04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 15:37:29 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJEFTT1012351;
	Tue, 19 Dec 2023 15:37:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1rx1r84x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 15:37:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BJFbR7C4260556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 15:37:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2635C2004D;
	Tue, 19 Dec 2023 15:37:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AB4120043;
	Tue, 19 Dec 2023 15:37:27 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Dec 2023 15:37:26 +0000 (GMT)
Message-ID: <ce449d515b88b8bf3eb5d0cabc1c926cfa721036.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/pretty_print_stacks.py:
 Silence warning from Python 3.12
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini
 <pbonzini@redhat.com>
Date: Tue, 19 Dec 2023 16:37:26 +0100
In-Reply-To: <20231219153134.47323-1-thuth@redhat.com>
References: <20231219153134.47323-1-thuth@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: D3F5IajArcCpZxhr9p899CMudsqFHkET
X-Proofpoint-GUID: r3opr4yefn8gf07nEp-0Wr81K_2y5JBe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312190116

On Tue, 2023-12-19 at 16:31 +0100, Thomas Huth wrote:
> Python 3.12 complains:
>=20
>  ./scripts/pretty_print_stacks.py:41: SyntaxWarning:
>   invalid escape sequence '\?'
>   m =3D re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
>=20
> Switch to a raw byte string to silence the problem.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

> ---
>  v2: Use "rb" prefix
>=20
>  scripts/pretty_print_stacks.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks=
.py
> index d990d300..a1526d5e 100755
> --- a/scripts/pretty_print_stacks.py
> +++ b/scripts/pretty_print_stacks.py
> @@ -38,7 +38,7 @@ def pretty_print_stack(binary, line):
>          return
> =20
>      for line in out.splitlines():
> -        m =3D re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
> +        m =3D re.match(rb'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
>          if m is None:
>              puts('%s\n' % line)
>              return


