Return-Path: <kvm+bounces-59442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3B5BB4DC7
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 20:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8604216D6E7
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 18:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0471E27815D;
	Thu,  2 Oct 2025 18:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S+1JsslO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCE275AE4;
	Thu,  2 Oct 2025 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759428905; cv=none; b=gy2peB1bj4ittwYrwitfzw8eOJtfxKjQ0wxlwDI8u5lxKe5Sv3KsiAF9P+c9dclkU9bwUNke10vRfvVsFFjBctI8r29iPsP0DbDBIyRCzavXXGrfXVIQs9RJkGpBF5mt2U6dPjPKxxfx3fc+MrmePVhl2e85pil1G/K/Gy9maZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759428905; c=relaxed/simple;
	bh=tiV/FGk2Ps/lQoSsnYzNz+wLVhTMw2A5LiaQbhTiZv4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TTybcNyzL5kHHqvoqzjq7mUkFjh0CPBr5fo1gSfw+0yKIRZrfAzTSzfP5f+jCMKptDN//8XY27Bczbng5pDdaqFXWcCve1E9y3/DFIWb1jIRe3pbQIP4mF7/uf0KLOGHaEigHRg+eFmzEWc9Vs32xpsv0TitpJ65fNH9TQBD9Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S+1JsslO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 592DgdbG024968;
	Thu, 2 Oct 2025 18:14:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GXGtV3
	K5iJLkV+B+kB54OqbtTgSa0cw/I6ElY2TOEa0=; b=S+1JsslOB4gz1OthBWQrOi
	clZCFDim45qbJZ+6ujU7Q9pxD8QbZAC55z2mbp7XXojDkuRyIVxPtljv8MBKY37u
	J9oMXKI69wFwZgnmNGKkDtop90Lj/i1F+4ffOxOz4w6imlEE7kXG1ip0jryB51++
	oaaeZX0/ew3kaaHIBrn2uQ4BEH4ECqDt8CO55A/4S71zcYivIgxDIUb+oPu7DYle
	KZ5HziGmXuCKF75nLdToOMwTYhLWzWEvkXxgvfCMPfK/b5XFHH5WXzJKsfvI0L2z
	LZUXimD35c2pI8tg/OM4cgesCCyKfVvdcb7qIKLLqIclO3oWWT9XBt1AH9szqdVw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7n872ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 18:14:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 592F00qH024198;
	Thu, 2 Oct 2025 18:14:56 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy1exw4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Oct 2025 18:14:56 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 592IEsaD24314256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Oct 2025 18:14:55 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A71405805A;
	Thu,  2 Oct 2025 18:14:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F384658061;
	Thu,  2 Oct 2025 18:14:52 +0000 (GMT)
Received: from [9.111.23.34] (unknown [9.111.23.34])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Oct 2025 18:14:52 +0000 (GMT)
Message-ID: <0a9c8e9d58b7ccecb9aa0b4b8f7f7af7a5c0cbe6.camel@linux.ibm.com>
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific
 resource/bus address translation
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        alex.williamson@redhat.com, clg@redhat.com, mjrosato@linux.ibm.com,
        Farhan
 Ali	 <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci
 <linux-pci@vger.kernel.org>
Date: Thu, 02 Oct 2025 20:14:52 +0200
In-Reply-To: <20251002170013.GA278722@bhelgaas>
References: <20251002170013.GA278722@bhelgaas>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
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
X-Proofpoint-ORIG-GUID: H6_KdVQh8EzQXIU-gr_ttHH4CMG71dvi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX5U1mdw/z9MEG
 EUmTAbJxik1F77blKO0nDn03JcTNUkLVRPLUsdekM8LQr5eIV9NT8DI1ktk+KIJduu7oi+MUOfi
 apOVpn5KCtIteLJBTui8fVEjUZ/5YKEUS+MHFX28LH+FvG/rIXEkMBdHiLeU+VGEuF34DYKGrur
 iqmFn1o7wsTjAHi9HBD43cYeba70f6LjnXBNMdydW1S+GBFKkUjbQNdyWM6eQD96YiUR0RCz9Dd
 faqlXdQ72fXhnzFsUZv39GQbql2yCQCpnGTli3/BCO1GXwNzBVaBQQu9+P27UMyeEx11ts9Rhvs
 /EgrMUqd1zefr+E7zCg8ncFQJ9e+tUBdAl9KfT3oU+8Q3vS0O/TfSDcU8dNZZcBsDqFLsg8wsg8
 NYET4ibN7dd54qi4atX6VXH6860tNA==
X-Proofpoint-GUID: H6_KdVQh8EzQXIU-gr_ttHH4CMG71dvi
X-Authority-Analysis: v=2.4 cv=T7qBjvKQ c=1 sm=1 tr=0 ts=68dec121 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=UOJYZS6k4RvA-RpS-ukA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-02_06,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025

On Thu, 2025-10-02 at 12:00 -0500, Bjorn Helgaas wrote:
> On Thu, Oct 02, 2025 at 02:58:45PM +0200, Niklas Schnelle wrote:
> > On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> > > On s390 today we overwrite the PCI BAR resource address to either an
> > > artificial cookie address or MIO address. However this address is dif=
ferent
> > > from the bus address of the BARs programmed by firmware. The artifici=
al
> > > cookie address was created to index into an array of function handles
> > > (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by fi=
rmware
> > > but maybe different from the bus address. This creates an issue when =
trying
> > > to convert the BAR resource address to bus address using the generic
> > > pcibios_resource_to_bus().
> > >=20
> > > Implement an architecture specific pcibios_resource_to_bus() function=
 to
> > > correctly translate PCI BAR resource addresses to bus addresses for s=
390.
> > > Similarly add architecture specific pcibios_bus_to_resource function =
to do
> > > the reverse translation.
> > >=20
> > > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > > ---
> > >  arch/s390/pci/pci.c       | 74 +++++++++++++++++++++++++++++++++++++=
++
> > >  drivers/pci/host-bridge.c |  4 +--
> > >  2 files changed, 76 insertions(+), 2 deletions(-)
> > >=20
> >=20
> > @Bjorn, interesting new development. This actually fixes a current
> > linux-next breakage for us. In linux-next commit 06b77d5647a4 ("PCI:
> > Mark resources IORESOURCE_UNSET when outside bridge windows") from Ilpo
> > (added) breaks PCI on s390 because the check he added in
> > __pci_read_base() doesn't find the resource because the BAR address
> > does not match our MIO / address cookie addresses. With this patch
> > added however the pcibios_bus_to_resource() in __pci_read_base()
> > converts  the region correctly and then Ilpo's check works. I was
> > looking at this code quite intensely today wondering about Benjamin's
> > comment if we do need to check for containment rather than exact match.
> > I concluded that I think it is fine as is and was about to give my R-b
> > before Gerd had tracked down the linux-next issue and I found that this
> > fixes it.
> >=20
> > So now I wonder if we might want to pick this one already to fix the
> > linux-next regression? Either way I'd like to add my:
> >=20
> > Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
>=20
> Hmmm, thanks for the report.  I'm about ready to send the pull
> request, and I hate to include something that is known to break s390
> and would require a fix before v6.18.  At the same time, I hate to add
> non-trivial code, including more weak functions, this late in the
> window.
>=20
> 06b77d5647a4 ("PCI: Mark resources IORESOURCE_UNSET when outside
> bridge windows") fixes some bogus messages, but I'm not sure that it's
> actually a functional change.  So maybe the simplest at this point
> would be to defer that commit until we can do it and the s390 change
> together.
>=20
> Bjorn

Yeah that makes a lot of sense. I agree this change is not completely
trivial. Might have been a little enthusiastic with it reviving PCI
support from the dead on linux-next. If the other patch is not an
important fix and Ilpo seems to agree, then simply reverting it is the
safe solution.

Thanks,
Niklas

