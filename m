Return-Path: <kvm+bounces-4821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F849818A7C
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 15:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B8CEA1C21096
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 14:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 203561C694;
	Tue, 19 Dec 2023 14:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YQ0uaSgv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F4E1C68A
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 14:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJECEmb012408;
	Tue, 19 Dec 2023 14:53:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5GZBGow5ijdBMZfiviwgDfuR8B6TfC54vLlvOnoDUyc=;
 b=YQ0uaSgvYD6g8HhPb9rkbHlGR8VABsict/BLEM1wZATCNxgpS51246B+xuOTA6kPCljN
 K2XCYGW9EyopOhUEv/FP2rFBTdEu30haCIbKTmbEfLJKqPdkdRustynqQHhkrwqsV2Zn
 IXLXkhjO824CNUTOhsQv90qTpPA0TlIzl6cHPPA7e28USPdyYQLJJbdVzd2It8Kuy3jO
 bJGwXifWQsY8POz4djCoMMcTTDSj1HUZlwMZhrQDEgUlKqIth22jvlaztrxeDFEfP2Tc
 qmGV/nbLzZWXsPRBYkwg0K/XOE88EBlD07ruN0eNE0z34+KsPCgLi98EdgzG+oLuCoyK Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3cqs95h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:53:04 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BJEhEs9022012;
	Tue, 19 Dec 2023 14:53:04 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v3cqs95fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:53:04 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BJEFq34027086;
	Tue, 19 Dec 2023 14:53:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3v1rek023q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Dec 2023 14:53:02 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BJEr0dZ20251350
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Dec 2023 14:53:00 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8780F2004B;
	Tue, 19 Dec 2023 14:53:00 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FCD320043;
	Tue, 19 Dec 2023 14:53:00 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Dec 2023 14:53:00 +0000 (GMT)
Message-ID: <36675f5872ce8343b9909f3e3445e34339cb5e60.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] scripts/pretty_print_stacks.py: Silence
 warning from Python 3.12
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini
 <pbonzini@redhat.com>
Date: Tue, 19 Dec 2023 15:52:59 +0100
In-Reply-To: <20231219132313.31107-1-thuth@redhat.com>
References: <20231219132313.31107-1-thuth@redhat.com>
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
X-Proofpoint-ORIG-GUID: SUL2noRd9FVwE1RJx5FUgpX9I06bDDw1
X-Proofpoint-GUID: B35EvozgZmo1d5g3oyC-b4ku86VJQ6PU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-19_08,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2312190111

On Tue, 2023-12-19 at 14:23 +0100, Thomas Huth wrote:
> Python 3.12 complains:
>=20
>  ./scripts/pretty_print_stacks.py:41: SyntaxWarning:
>   invalid escape sequence '\?'
>   m =3D re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
>=20
> Switch to a raw string to silence the problem.
>=20
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  scripts/pretty_print_stacks.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks=
.py
> index d990d300..5bce84fc 100755
> --- a/scripts/pretty_print_stacks.py
> +++ b/scripts/pretty_print_stacks.py
> @@ -38,7 +38,7 @@ def pretty_print_stack(binary, line):
>          return
> =20
>      for line in out.splitlines():
> -        m =3D re.match(b'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)
> +        m =3D re.match(r'(.*) at (.*):(([0-9]+)|\?)([^:]*)', line)

Did you test this? Should this not be rb'<regex>'?
I get
TypeError: cannot use a string pattern on a bytes-like object
When imitating this in a REPL.
We don't open the process in text mode, so its output should
be bytes and after splitting, "line" should be too.

>          if m is None:
>              puts('%s\n' % line)
>              return


