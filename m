Return-Path: <kvm+bounces-57363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7574BB54229
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 07:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 268CB58405C
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 05:48:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22302727FA;
	Fri, 12 Sep 2025 05:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PCT2ZViB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B771A38F9;
	Fri, 12 Sep 2025 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757656120; cv=none; b=sWJUyiTVCTZFb4KULNKhNurr6VgTCC5PNZYCyRQnZ0WFXLZUdF839+HnwqmYRBWRCW1Vu+5KF3LnNRGr/UrJ0o0yDQh4JNYPH7yY83BQx+6Yxqa8rUFMT14BNtUPBMghKBGGy4VyurVxNusMEJtuewTNlllZdq8vm+T6i0KI9uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757656120; c=relaxed/simple;
	bh=+i4OoREQks4VV2znGBqgJdvvBG5OWmH2qBK7R3A4A60=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sio/TJ+7NIWQk/W3lWbip2nIWvxQ8jRmGW0l+UeU6CHmJGbyZF83M7JsCPzuEeNOA4FSCSt16V2gWNWmr8y60YGX1n8QK8Cu14r5lfzu6GrvemzYR3CW6H3lzIe6PFVzIoNF29KVjuaToF4VWbyMThUTvOVoQtD85ELSHD2oFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PCT2ZViB; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BHxX67015803;
	Fri, 12 Sep 2025 05:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Viz/HV
	rWkQaPqWNQsh/R5A1KAtj0VuBWkxP051RDCa8=; b=PCT2ZViB1lXPOpkWCh2J5D
	lZzHSYXAsOR1qIlPVjFINrWaopxlBxwFeWDHdmFg95vefudV8R4CfP3simnwySni
	dlkFjoDaRz8zlV83hGagcwUOB41i5vEgaVfAWrqY+0nuBhhIwQY+RrGRTR455/7V
	UXnZvzjo3kJMRk6r5myQj+8jeyzAK9wXgz6bUG1CFThxhukr2tcm3jsP489hDcpD
	lMRygYpgkKuVS3xr2N/O4pSsKBr6sMT+vhriLFkhPi8YWpbKAcJg29qzQtwK490a
	qtmWSRQB1w7KVINjykdU+TTH9bVb8FpCdiOzVIef0u27KGFnLN+U/CqgjLWP0YdA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukewnb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 05:48:25 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58C2kUaj017172;
	Fri, 12 Sep 2025 05:48:24 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gms7ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 05:48:24 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58C5mKGx58458556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 05:48:20 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E3FC20074;
	Fri, 12 Sep 2025 05:48:20 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 23029200B4;
	Fri, 12 Sep 2025 05:47:19 +0000 (GMT)
Received: from [9.111.56.142] (unknown [9.111.56.142])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 12 Sep 2025 05:47:19 +0000 (GMT)
Message-ID: <dc821fe28bf530c28903a97068aee87d65774b9c.camel@linux.ibm.com>
Subject: Re: [PATCH v2 10/20] KVM: s390: KVM page table management
 functions: walks
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank
	 <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Date: Fri, 12 Sep 2025 07:47:18 +0200
In-Reply-To: <20250911151408.2a1595d4@p-imbrenda>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
		<20250910180746.125776-11-imbrenda@linux.ibm.com>
		<aeb461ff-90a1-4d6e-a779-1c6e885bdddb@linux.ibm.com>
	 <20250911151408.2a1595d4@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX0hSe59ZIE3pp
 Xtvx5rTg6492jmxKk7xedXgTbBwqkSrtYB/rkAe6SVjEnzEY0awZbO23qYVjWeO/YCzQu4Ir7Vn
 w1nUw3zmTYinKfO1J5GVTZpkI1X3YletfTBlxUyuJTqN2/DzLlejflMoanv8oKrUxQTqg4F82AR
 nYMn4wjK3ojWwmm2C3KZOkkoX21SX15LUtQNcmq9FOzj7SjB2Z9XQquhEAbQvCPmGUkaK8D7PaN
 Y/G5C/GU6g14u3qOq2qyzpsGKJqBTS5IzuQ98IocoYduyGrbtVBklyH9QcuU6RLK15UfwrsyMn2
 Di4wA/iJjIhvan2jmOJ5TOh9wBjI/i0yzO9qWTYyg5hn2fE8VuVzgrL+lW/vJO7EjmR+6Xnlq4Y
 9j/sPG+p
X-Proofpoint-ORIG-GUID: vpLpewZiyJnZlNq7RK-oZ1P01xplWk5V
X-Proofpoint-GUID: vpLpewZiyJnZlNq7RK-oZ1P01xplWk5V
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c3b429 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=qYKTZLTtyhLZ8LqLyoEA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_01,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1011 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

On Thu, 2025-09-11 at 15:14 +0200, Claudio Imbrenda wrote:
> On Thu, 11 Sep 2025 14:56:59 +0200
> Janosch Frank <frankja@linux.ibm.com> wrote:
>=20
> > On 9/10/25 8:07 PM, Claudio Imbrenda wrote:
> > > Add page table management functions to be used for KVM guest (gmap)
> > > page tables.
> > >=20
> > > This patch adds functions to walk to specific table entries, or to
> > > perform actions on a range of entries.
> > >=20
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >   arch/s390/kvm/dat.c | 351 +++++++++++++++++++++++++++++++++++++++++=
+++
> > >   arch/s390/kvm/dat.h |  38 +++++
> > >   2 files changed, 389 insertions(+)
> > >=20
> > > diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
> > > index f26e3579bd77..fe93e1c07158 100644
> > > --- a/arch/s390/kvm/dat.c
> > > +++ b/arch/s390/kvm/dat.c
> > > @@ -209,3 +209,354 @@ union pgste __dat_ptep_xchg(union pte *ptep, un=
ion pgste pgste, union pte new, g
> > >   	WRITE_ONCE(*ptep, new);
> > >   	return pgste;

[... snip ...]

> > > +
> > > +	while (old.h.i || old.h.fc) {
> > > +		init.val =3D pmd_origin_large(old);
> > > +		init.h.p =3D old.h.p;
> > > +		init.h.i =3D old.h.i;
> > > +		init.s.d =3D old.s.fc1.d;
> > > +		init.s.w =3D old.s.fc1.w;
> > > +		init.s.y =3D old.s.fc1.y;
> > > +		init.s.sd =3D old.s.fc1.sd;
> > > +		init.s.pr =3D old.s.fc1.pr; =20
> >=20
> > This looks horrible but I haven't found a better solution.
>=20
> I know what you mean :)

If nothing else, you may try and encapsulate this in a helper to
concentrate the ugliness there. Then the while-body just calls some
prepare_init() or similar?



