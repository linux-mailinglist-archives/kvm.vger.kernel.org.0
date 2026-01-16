Return-Path: <kvm+bounces-68331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1BD8D334FE
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 16:49:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7378B313C873
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3D731063B;
	Fri, 16 Jan 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XO5aPHKa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6005258EE9;
	Fri, 16 Jan 2026 15:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768578330; cv=none; b=MdP2YEzNNHO/6tJQKb4QSgkz205FuKn6kEbWLnjHxA6T3VzshgSU+ziqL9w2lKb/bsCEUHkWGlksng6E1FfxRf6EF3qWQ+5X53ZSvS7WffZfx02CRFexiKUUTxUCQyOCcewakTiukwgZbNMSaVFfMgpY85L7gu49ejpKMMAsAq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768578330; c=relaxed/simple;
	bh=sYkApZCf7ikxNWqJYnWdzJEmSOQpdFclHStAuxtQcV0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VKb8x9sPa34WrdLoTsS2wfqkWve2CLZu4xnwHIc4dE45tvGVGpjfoMk7misoTlAGEsDJFZBvvSNQSfkeUnwuZq3hrzNUx/ujJUw345oN/uWdyRgZ2yQixbmHbSnHHIWtdbb89ZFNd+tV4l7a8knu4sKMu8OA5l0ITKVTJ3uoM+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XO5aPHKa; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60GCesGT032354;
	Fri, 16 Jan 2026 15:45:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sYkApZ
	Cf7ikxNWqJYnWdzJEmSOQpdFclHStAuxtQcV0=; b=XO5aPHKaeY+rUTuA+h75Zg
	dzyiCGldyWJ4kYcADCyDBe3w4Q/q1usvT6violTuObvqIz0RlmYba2PmfexjHGuX
	qXkM3l/QI17VmnCqlsuCjKDOWNH8HgEMZ4L1dDcDsLD8KwaXvliR6/gw/mRa8apM
	paHx4ncuwLHuleOGGe71rQYyu4MCwj+cb5FdO45If1wurZncnHd9mrNZSOTmpmI7
	XugZzItnQS4N/9mixjFg2ddkIUTrl3bout5BQCXCUWiGjCRvneXrmaXNoinWeC96
	YPYSJZ70kS7Eq2/EfuZZsu/GHZ0pEgb18IUapn3pg/ZAyBGPVk3yfNdpSIvoVVlQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bq9bmkmek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 15:45:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60GEHudW025866;
	Fri, 16 Jan 2026 15:45:25 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kky4h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 15:45:25 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60GFj56031195664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 15:45:05 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A56C658056;
	Fri, 16 Jan 2026 15:45:23 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 203DF5803F;
	Fri, 16 Jan 2026 15:45:23 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.83.216])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Jan 2026 15:45:23 +0000 (GMT)
Message-ID: <3d997b2645c80396c0f7c69f95fd8ec0d4784b20.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
From: Eric Farman <farman@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger	
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Fri, 16 Jan 2026 10:45:22 -0500
In-Reply-To: <23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
			<8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
			<f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
		 <20260114105033.23d3c699@p-imbrenda>
	 <23154a0c6b4b9e625daa2b1bbaadc349bf3a99ed.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dDH18FFknHcJR0GCRpPV3nK2hie-m5J4
X-Proofpoint-ORIG-GUID: dDH18FFknHcJR0GCRpPV3nK2hie-m5J4
X-Authority-Analysis: v=2.4 cv=TrvrRTXh c=1 sm=1 tr=0 ts=696a5d16 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=R0r9cqHsO0Xgfa1iM50A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEwOSBTYWx0ZWRfX+CLOBUBHEfVh
 W/pmCbNpapgeZBOYQw5FcyiNJbxrt8gD5yplIGjIgl7iY1zeDKt6sZE82GRiCgp79PBwF6UjqKI
 WTdY3r/lELOFlXUVZdG+zO4HY0Su+ZApE51UEkDr9A8pbohYqIWEcZwHyew9s727Bg+E8HD+PLI
 YRBcPwE61M5UvUzjJ/0jKqIMDKcaK684XEE034OWHv32EY89ZiD7N6WwOrMsg7HVNokTqI0epR5
 5+JEk5uNDpmNPGzYhMiiaOfKpHH527oUM0FxowDsk9eSIbjJXl39uglbEh2r7oGpi7AqN2Re1Sq
 mjdSUmOSdj6qKv4yYIgC/SE+s5SrdE+uwCFTqUJ+5exx2lLiR8E+H+GEm6N7fEOnvCjuHIDnTZa
 ACIjE3azeni3JjZV+oDK9LTs1t7QWv5yyCwAmcmDv7mWWCRZTD/4C+CfWsJ9ho6Skwrr0UCcNyW
 uAiVdJ1N45pPj/PWujg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601160109

On Thu, 2026-01-15 at 16:17 -0500, Eric Farman wrote:
> On Wed, 2026-01-14 at 10:50 +0100, Claudio Imbrenda wrote:
> > On Mon, 05 Jan 2026 10:46:53 -0500
> > Eric Farman <farman@linux.ibm.com> wrote:
> >=20
> > > On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
> > > > On 12/17/25 04:01, Eric Farman wrote: =20
> > > > > SIE may exit because of pending host work, such as handling an in=
terrupt,
> > > > > in which case VSIE rewinds the guest PSW such that it is transpar=
ently
> > > > > resumed (see Fixes tag). There is still one scenario where those =
conditions
> >=20
> > can you add a few words to (very briefly) explain what the scenario is?
>=20
> Maybe if this paragraph were rewritten this way, instead?
>=20
> --8<--
> SIE may exit because of pending host work, such as handling an interrupt,
> in which case VSIE rewinds the guest PSW such that it is transparently
> resumed (see Fixes tag). Unlike those other places that return rc=3D0, th=
is
> return leaves the guest PSW in place, requiring the guest to handle an
> intercept that was meant to be serviced by the host. This showed up when
> testing heavy I/O workloads, when multiple vcpus attempted to dispatch th=
e
> same SIE block and incurred failures inserting them into the radix tree.
> -->8--

Spoke to Claudio offline, and he suggested the following edit to the above:

--8<--
SIE may exit because of pending host work, such as handling an interrupt,
in which case VSIE rewinds the guest PSW such that it is transparently
resumed (see Fixes tag). Unlike those other places that return rc=3D0, this
return leaves the guest PSW in place, requiring the guest to handle a
spurious intercept. This showed up when testing heavy I/O workloads,
when multiple vcpus attempted to dispatch the same SIE block and incurred
failures inserting them into the radix tree.
-->8--

>=20
> @Janosch, if that ends up being okay, can you update the patch or do you =
want me to send a v2?
>=20
> >=20
> > > > > are not present, but that the VSIE processor returns with effecti=
vely rc=3D0,
> > > > > resulting in additional (and unnecessary) guest work to be perfor=
med.
> > > > >=20
> > > > > For this case, rewind the guest PSW as we do in the other non-err=
or exits.
> > > > >=20
> > > > > Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on h=
ost intercepts")
> > > > > Signed-off-by: Eric Farman <farman@linux.ibm.com> =20
> > > >=20
> > > > This is purely cosmetic to have all instances look the same, right?=
 =20
> > >=20
> > > Nope, I can take this path with particularly high I/O loads on the sy=
stem, which ends up
> > > (incorrectly) sending the intercept to the guest.
> >=20
> > this is a good candidate for the explanation I mentioned above :)
> >=20
> >=20
> > (the patch itself looks fine)

