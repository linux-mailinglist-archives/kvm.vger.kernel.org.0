Return-Path: <kvm+bounces-57712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2FBB59469
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 12:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204D418813F8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 10:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B792C15AB;
	Tue, 16 Sep 2025 10:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dTIz4lCR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB342848B4;
	Tue, 16 Sep 2025 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758020080; cv=none; b=qaqpShRtWvYMusdAufStEIptK4MRdhTHvj4HH1KhKwo9Vg+GBA+w5e0u9wa+FtLpRg51h3BWnKWZNqEPAQhogXX7hDoY4//g1smAdu6ZBwqb0G3oHhYTXt+Nq64Sxri7xlE/gLL2wtCzekSpgzknAfwBEpPzI//22RSnohvjH/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758020080; c=relaxed/simple;
	bh=iQRfr2CsEXt7MpaemY80t59JywyZ3Y0X2qnknKQzFao=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kDhT9FHNQ1b8VDFYzilhtlPhFwxQtZQb2TUNVvpqu/Rx0z2+eWEAqp0qWhC6SUukTkLyZvcfqUfEy9eIH0UosCvs4ZqKBkmIb4XxHV2BlfX0n8JKy5F759OvX73Bh+fcmrHt26C5/ae0koGP+/oJquUoReu1LcbzVrsH+TMsTjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dTIz4lCR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GA8ix8015122;
	Tue, 16 Sep 2025 10:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=vB2QT4
	FmuNsW21Oklh4MJ1T5SbN06uJoDbD/5q5Shjk=; b=dTIz4lCRS2jdQwJsky7Rf1
	Dx8j36m/qXh0BzjURdre/Pt+HB+V7waLAIhKyeihGMaWdCZuJunWT8TdWmW81rpv
	oM90ePSsw0qaZF8pdv8wnvEmiZQdqKK4J4Lv7pW/xwz64TqQmVNDBxv3dVFbqU7J
	90VehOphyW4mhnpwPki9/pNZj4eTlD1oUZ7v4fhwkYpu6h0OZ7eoTsEGaMDbO77V
	LQPSCtWpWXNr9gtf6WTXcslmLy07u+95NfRPkCIATgDs/G8WS/lijHJd41UdF1m6
	5BP8CF/qjWVSWLC6SRHHtOCVIdvJ5tUNiZyF0W++tXs2KgkcW6SVc1Nz4nq6Np0Q
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tfv9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 10:54:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G6xMwM027308;
	Tue, 16 Sep 2025 10:54:34 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men3cy0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 10:54:34 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GAsWxL34799996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 10:54:33 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8D4D58061;
	Tue, 16 Sep 2025 10:54:32 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 540B558043;
	Tue, 16 Sep 2025 10:54:31 +0000 (GMT)
Received: from [9.152.212.194] (unknown [9.152.212.194])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 10:54:31 +0000 (GMT)
Message-ID: <6703760a502d146909482f3aeb4333bf33cb431b.camel@linux.ibm.com>
Subject: Re: [PATCH v3 07/10] s390/pci: Store PCI error information for
 passthrough devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Tue, 16 Sep 2025 12:54:30 +0200
In-Reply-To: <98a3bc6f-9b75-48cd-b09f-343831f5dcbf@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	 <20250911183307.1910-8-alifm@linux.ibm.com>
	 <197d61dcb036c1038180acf26042b82d4320b9f2.camel@linux.ibm.com>
	 <98a3bc6f-9b75-48cd-b09f-343831f5dcbf@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c941ea cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=H7lXNfFGqXF3HOv8TxgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ySSAb4OIcC5rGylVi2v5_M-XzjnoEvc8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfXxjsQ+COyY5br
 FgjElnh8EcjbEJTKNo43iAR+6WVkKPu5r7rTRArAV35Mt1dB+PbiAFzOMMVAq59/gRveQwwLjs+
 v8c1FbHRtwImTZ3kx4lTqG3V3BKpArEAT/NTChFnyZ2tj4AsnrIz8+ZgHyA3rzzCD823JdsKmQu
 LeGFAQnQSG346DaCrRj3UTM6jYs+7rR9PKeUWmQ7r7Zr2oYUViPkul6vfOUcPkTSjm5DBFmVQLM
 zgNap+40KMnpyaiVSBq8PgFHqvECscjXv6PQx3L4dmcxqUo2up0ieGi4VLzkWhUlk2jCQ5LfgIN
 /M+HP5O7zn7CqJ9ST/lBWbz7hRoEtdoTYyZWLjN/MYdVjRzmQ2MpGHcd3GaUIP2bkFhfJocWMGJ
 AcZNBw38
X-Proofpoint-GUID: ySSAb4OIcC5rGylVi2v5_M-XzjnoEvc8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

On Mon, 2025-09-15 at 11:12 -0700, Farhan Ali wrote:
> On 9/15/2025 4:42 AM, Niklas Schnelle wrote:
> > On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
> > > For a passthrough device we need co-operation from user space to reco=
ver
> > > the device. This would require to bubble up any error information to =
user
> > > space.  Let's store this error information for passthrough devices, s=
o it
> > > can be retrieved later.
> > >=20
> > > Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> > > ---
> > >=20
--- snip ---
> > > +	mutex_unlock(&zdev->pending_errs_lock);
> > > +}
> > > +
> > > +void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
> > > +{
> > > +	struct pci_dev *pdev =3D NULL;
> > > +
> > > +	mutex_lock(&zdev->pending_errs_lock);
> > > +	pdev =3D pci_get_slot(zdev->zbus->bus, zdev->devfn);
> > > +	if (zdev->pending_errs.count)
> > > +		pr_err("%s: Unhandled PCI error events count=3D%zu",
> > > +				pci_name(pdev), zdev->pending_errs.count);
> > I think this could be a zpci_dbg(). That way you also don't need the
> > pci_get_slot() which is also buggy as it misses a pci_dev_put(). The
> > message also doesn't seem useful for the user. As I understand it this
> > would happen if a vfio-pci user dies without handling all the error
> > events but then vfio-pci will also reset the slot on closing of the
> > fds, no? So the device will get reset anyway.
>=20
> Right, the device will reset anyway. But I wanted to at least give an=20
> indication to the user that some events were not handled correctly.=20
> Maybe pr_err is a little extreme, so can convert to a warn? This should=
=20
> be rare as well behaving applications shouldn't do this. I am fine with=
=20
> zpci_dbg as well, its just the kernel needs to be in debug mode for us=
=20
> to get this info.

No, zpci_dbg() logs to /sys/kernel/debug/s390dbf/pci_msg/sprintf
without need for debug mode. I'm also ok with a pr_warn() or maybe even
pr_info(). I can see your argument that this may be useful to have in
dmesg e.g. when debugging a user-space driver without having to know
about s390 specific debug aids.

>=20
> >=20
> > > +	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));
> > If this goes wrong and we subsequently crash or take a live memory dump
> > I'd prefer to have bread crumbs such as the errors that weren't cleaned
> > up. Wouldn't it be enough to just set the count to zero and for debug
> > the original count will be in s390dbf.
>=20
> I think setting count to zero should be enough, but I am wary about=20
> keeping stale state around. How about just logging the count that was=20
> not handled, in s390dbf? I think we already dump the ccdf in s390df if=
=20
> we get any error event. So it should be enough for us to trace back the=
=20
> unhandled error events?
>=20
> > Also maybe it would make sense
> > to pull the zdev->mediated_recovery clearing in here?
>=20
> I would like to keep the mediated_recovery flag separate from just=20
> cleaning up the errors. The flag gets initialized when we open the vfio=
=20
> device and so having the flag cleared on close makes it easier to track=
=20
> this IMHO.

Ok yeah I can see the symmetry argument.
>=20

