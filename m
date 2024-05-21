Return-Path: <kvm+bounces-17852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E388CB267
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:44:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C730CB221D3
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699C6147C73;
	Tue, 21 May 2024 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W+sB67KS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85991442F3;
	Tue, 21 May 2024 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716309839; cv=none; b=dUuC6bY/XYqzbDe+USQKAzNH3fNnjlGZW6jEo6zENpNeWSUYZ1YeSuoSlxCwj9VlYIts12z1ciWraIibNIHb6wOFx43pzMNGO9sLXSYneAPKBjtx1HBT0Sl0yVQh+96le6MCWSJO8MHnAOqIZZ6v2cVnQ5GllVnPJCxtvOrtg20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716309839; c=relaxed/simple;
	bh=1kIOw8EmG5C3MMu3fc/3rTG1lOhDQ9euf2N1W1Gutrg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fVkTBp8Z3vECpM05WRs4Oasl5zNy3FRJ6X9+wifjaqsBnQjjW4Qy2AkrJQvifkOvoR6sF1q873T7SMnSPCYLnUSZ40C0OHpMyzSvn2JciwdkbeT7EwZpPLn7Qb0nIuVPF/12kBuMNmcsqtW0gc6mwumMYTcd/lV0YST0gC+M3Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W+sB67KS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LGg41v030021;
	Tue, 21 May 2024 16:43:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=218JILOyktT9xJUug9V+fyulF7xvAZiesivrueJvh3w=;
 b=W+sB67KSKa4w23S+xqa3rAMIfhggobnpB0TLxe8ZJbkxek55/6DlJvgPmJTYPolT7P0t
 bhB45Wa5uINfL/f+b0wTai9chb+jrSut3ZdR/QM61slDyHH8g/NSVSh4pMKhmjt/cr4J
 toNnt0rG5TmKgV1wthP8BliVW5UOj5V/wO62fICMdm3VGfW4lxJq4zaxElTGJDhHWwix
 Hg0NzrEt992GVdv7aveEANCfrsFMtgUfvaILLL7ey4Hr8ye6hlOQhTEt44w1g/ixCJyI
 vAhxhFnan23u4CMR3rOSUYPGP6l6PZe6LrNuoEycPAOWx3KEAb//X8/nYkx0bGFA1Gn1 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8yc2r082-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:43:56 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44LGhtO2032398;
	Tue, 21 May 2024 16:43:55 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y8yc2r07x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:43:55 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44LFub96008090;
	Tue, 21 May 2024 16:43:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y79c2xc0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 May 2024 16:43:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44LGhnfS39190930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 16:43:51 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CA4B20040;
	Tue, 21 May 2024 16:43:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7160F2004D;
	Tue, 21 May 2024 16:43:48 +0000 (GMT)
Received: from [9.179.20.140] (unknown [9.179.20.140])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 May 2024 16:43:48 +0000 (GMT)
Message-ID: <6e2757232acf5582b05d5f6516b14ea091e04296.camel@linux.ibm.com>
Subject: Re: [PATCH v3 3/3] vfio/pci: Continue to refactor
 vfio_pci_core_do_io_rw
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
 <schnelle@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Julian Ruess <julianr@linux.ibm.com>
Date: Tue, 21 May 2024 18:43:47 +0200
In-Reply-To: <20240429103201.7e07e502.alex.williamson@redhat.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
	 <20240425165604.899447-4-gbayer@linux.ibm.com>
	 <20240429103201.7e07e502.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ytS3bhbsCNvy1KDwDFUyqUWBWn7xn6Wj
X-Proofpoint-GUID: Nge-TKDmHyXhRg26IybSZn25l-MOJ88R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_10,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=687 spamscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210126

On Mon, 2024-04-29 at 10:32 -0600, Alex Williamson wrote:
> On Thu, 25 Apr 2024 18:56:04 +0200
> Gerd Bayer <gbayer@linux.ibm.com> wrote:
>=20
> > Convert if-elseif-chain into switch-case.
> > Separate out and generalize the code from the if-clauses so the
> > result
> > can be used in the switch statement.
> >=20
> > Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> > ---
> > =C2=A0drivers/vfio/pci/vfio_pci_rdwr.c | 30 ++++++++++++++++++++++++---=
-
> > --
> > =C2=A01 file changed, 24 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c
> > b/drivers/vfio/pci/vfio_pci_rdwr.c
> > index 8ed06edaee23..634c00b03c71 100644
> > --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> > +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> > @@ -131,6 +131,20 @@ VFIO_IORDWR(32)
> > =C2=A0VFIO_IORDWR(64)
>=20
> #define MAX_FILL_SIZE 8
> #else
> #define MAX_FILL_SIZE 4
>=20
> > =C2=A0#endif
> > =C2=A0
> > +static int fill_size(size_t fillable, loff_t off)
> > +{
> > +	unsigned int fill_size;
>=20
> 	unsigned int fill_size =3D MAX_FILL_SIZE;
>=20
> > +#if defined(ioread64) && defined(iowrite64)
> > +	for (fill_size =3D 8; fill_size >=3D 0; fill_size /=3D 2) {
> > +#else
> > +	for (fill_size =3D 4; fill_size >=3D 0; fill_size /=3D 2) {
> > +#endif /* defined(ioread64) && defined(iowrite64) */
> > +		if (fillable >=3D fill_size && !(off % fill_size))
> > +			return fill_size;
> > +	}
> > +	return -1;
> > +}
> > +
> > =C2=A0/*
> > =C2=A0 * Read or write from an __iomem region (MMIO or I/O port) with a=
n
> > excluded
> > =C2=A0 * range which is inaccessible.=C2=A0 The excluded range drops wr=
ites
> > and fills
> > @@ -155,34 +169,38 @@ ssize_t vfio_pci_core_do_io_rw(struct
> > vfio_pci_core_device *vdev, bool test_mem,
> > =C2=A0		else
> > =C2=A0			fillable =3D 0;
> > =C2=A0
> > +		switch (fill_size(fillable, off)) {
> > =C2=A0#if defined(ioread64) && defined(iowrite64)
> > -		if (fillable >=3D 8 && !(off % 8)) {
> > +		case 8:
> > =C2=A0			ret =3D vfio_pci_core_iordwr64(vdev,
> > iswrite, test_mem,
> > =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > =C2=A0			if (ret)
> > =C2=A0				return ret;
> > +			break;
> > =C2=A0
> > -		} else
>=20
> AFAICT, avoiding this dangling else within the #ifdef is really the
> only tangible advantage of conversion to a switch statement.=C2=A0 Gettin=
g
> rid of that alone while keeping, and actually increasing, the inline
> ifdefs in the code doesn't seem worthwhile to me.=C2=A0 I'd probably only
> go this route if we could make vfio_pci_iordwr64() stubbed as a
> BUG_ON when we don't have the ioread64 and iowrite64 accessors, in
> which case the switch helper would never return 8 and the function
> would be unreachable.
>=20
> > =C2=A0#endif /* defined(ioread64) && defined(iowrite64) */
> > -		if (fillable >=3D 4 && !(off % 4)) {
> > +		case 4:
> > =C2=A0			ret =3D vfio_pci_core_iordwr32(vdev,
> > iswrite, test_mem,
> > =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > =C2=A0			if (ret)
> > =C2=A0				return ret;
> > +			break;
> > =C2=A0
> > -		} else if (fillable >=3D 2 && !(off % 2)) {
> > +		case 2:
> > =C2=A0			ret =3D vfio_pci_core_iordwr16(vdev,
> > iswrite, test_mem,
> > =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > =C2=A0			if (ret)
> > =C2=A0				return ret;
> > +			break;
> > =C2=A0
> > -		} else if (fillable) {
> > +		case 1:
> > =C2=A0			ret =3D vfio_pci_core_iordwr8(vdev, iswrite,
> > test_mem,
> > =C2=A0						=C2=A0=C2=A0=C2=A0 io, buf, off,
> > &filled);
> > =C2=A0			if (ret)
> > =C2=A0				return ret;
> > +			break;
> > =C2=A0
> > -		} else {
> > +		default:
>=20
> This condition also seems a little more obfuscated without being
> preceded by the 'if (fillable)' test, which might warrant handling
> separate from the switch if we continue to pursue the switch
> conversion.=C2=A0 Thanks,
>=20
> Alex
>=20
> > =C2=A0			/* Fill reads with -1, drop writes */
> > =C2=A0			filled =3D min(count, (size_t)(x_end -
> > off));
> > =C2=A0			if (!iswrite) {
>=20
>=20

Well, overall this sounds like it creates more headaches than it tries
to solve - and that is a strong hint to not do it.

I'll drop this further refactoring in the next version.

Thanks, Gerd

