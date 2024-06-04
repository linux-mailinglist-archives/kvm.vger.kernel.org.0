Return-Path: <kvm+bounces-18764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C580F8FB204
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 14:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5A681C225E1
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B71A145FF6;
	Tue,  4 Jun 2024 12:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K/RHtxXd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74771266A7;
	Tue,  4 Jun 2024 12:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717503575; cv=none; b=QH4NTsEePhLmotkq+axsfGRTqN1E0xeoryHvnh0KLa+kVpL4Wk9YgfVHn8pqivRdp8K7e8iYEApRIqfznrUGYnUNCp/Ako5jeQitz/8fWhMNdBxc7+zyZCGAoZT2ZAM8EGlwlUAjpl/BFAgWFViFPKy9AjArwsb7TbvK9m5lMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717503575; c=relaxed/simple;
	bh=51TQgt7iJryMU/lIwxSXLIcTzQ+aQhdFdHpQWK0Ig70=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MERfFp8aJ9lTmuf6aqJVZQd0h7Q0ACbuMWd0AprwA4XjF4yca5BBngN4SLCrdm4g/MVClNqAJziMQWCqBvfLE8rnQXSv1tE81lvkGo8s1DMWojUzoqHNY5W1AUvi1fIyQMUKW3zdnLLZBRZ6kAdmLbE1RluYOR1BN/HNQRGqeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K/RHtxXd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 454C14Se012850;
	Tue, 4 Jun 2024 12:19:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=51TQgt7iJryMU/lIwxSXLIcTzQ+aQhdFdHpQWK0Ig70=;
 b=K/RHtxXdr5lYdoDgt5vCvFy6GqKAHBa6KEBJV+KghabqxQXNuzeiFI+xA7Av4DqaEbQY
 mqaq/WnU8vazbNr2ELHW248sibRfLaLT6xgQFcHbJJk6csSQbwYytiqSJR3RFV7IW/IM
 IA41hDgTSTxl+cC5vG5yiYhrvuqKkmu9P8KzdXbsHpNbykPCWyQGL3BP8DnouRsoXKDl
 sEhV0tXOk3orpIkN6bDfj3mt4/Evp1DJURYsFORbIfXEqFN/DWnqY4eYj1gmuLW2jmoy
 BYjBfEgdtyMz03mxdEHJBd4HID0MVz+SS6zs6JjzfrSIiTKD0XJsVznoiumAeaKBoTRZ 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj1pu86ut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 12:19:27 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 454CDHZu031680;
	Tue, 4 Jun 2024 12:19:26 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yj1pu86u5-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 12:19:26 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4548QN21008458;
	Tue, 4 Jun 2024 11:46:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec0nyqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 11:46:53 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 454BklYD34996880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Jun 2024 11:46:49 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25EEB2004B;
	Tue,  4 Jun 2024 11:46:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D34722004D;
	Tue,  4 Jun 2024 11:46:46 +0000 (GMT)
Received: from [9.152.224.39] (unknown [9.152.224.39])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Jun 2024 11:46:46 +0000 (GMT)
Message-ID: <7dcc8e25c81c03effc8f23c2022a607c8040ea8d.camel@linux.ibm.com>
Subject: Re: [PATCH] vfio/pci: Add iowrite64 and ioread64 support for vfio
 pci
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Ramesh Thomas <ramesh.thomas@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: alex.williamson@redhat.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, ankita@nvidia.com, yishaih@nvidia.com,
        pasic@linux.ibm.com, julianr@linux.ibm.com, bpsegal@us.ibm.com,
        kevin.tian@intel.com
Date: Tue, 04 Jun 2024 13:46:42 +0200
In-Reply-To: <bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com>
References: <20240522232125.548643-1-ramesh.thomas@intel.com>
	 <20240524140013.GM69273@ziepe.ca>
	 <bfb273b2-fc5e-4a8b-a40d-56996fc9e0af@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.52.1 (3.52.1-1.fc40app1) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XzY_Vl9aOUyyXXbRTgAoA3RO8eDKSzXo
X-Proofpoint-ORIG-GUID: qAi7gXF4nl8Q8tqrLcwLL-rNYTUe0teN
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_05,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406040099

Hi Ramesh, hi Jason,

being back from a short vacation, I think I'm sold on enabling x86 for
the 64bit accessors in vfio/pci.

On Tue, 2024-05-28 at 15:48 -0700, Ramesh Thomas wrote:
> Hi Jason,
>=20
>=20
> On 5/24/2024 7:00 AM, Jason Gunthorpe wrote:
> > On Wed, May 22, 2024 at 04:21:25PM -0700, Ramesh Thomas wrote:
> > > ioread64 and iowrite64 macros called by vfio pci implementations
> > > are
> > > defined in asm/io.h if CONFIG_GENERIC_IOMAP is not defined.
> > > Include
> > > linux/io-64-nonatomic-lo-hi.h to define iowrite64 and ioread64
> > > macros
> > > when they are not defined. io-64-nonatomic-lo-hi.h maps the
> > > macros to
> > > generic implementation in lib/iomap.c. The generic implementation
> > > does 64 bit rw if readq/writeq is defined for the architecture,
> > > otherwise it would do 32 bit back to back rw.
> > >=20
> > > Note that there are two versions of the generic implementation
> > > that
> > > differs in the order the 32 bit words are written if 64 bit
> > > support is
> > > not present. This is not the little/big endian ordering, which is
> > > handled separately. This patch uses the lo followed by hi word
> > > ordering
> > > which is consistent with current back to back implementation in
> > > the
> > > vfio/pci code.
> > >=20
> > > Refer patch series the requirement originated from:
> > > https://lore.kernel.org/all/20240522150651.1999584-1-gbayer@linux.ibm=
.com/
> > >=20
> > > Signed-off-by: Ramesh Thomas <ramesh.thomas@intel.com>
> > > ---
> > > =C2=A0 drivers/vfio/pci/vfio_pci_priv.h | 1 +
> > > =C2=A0 1 file changed, 1 insertion(+)
> > >=20
> > > diff --git a/drivers/vfio/pci/vfio_pci_priv.h
> > > b/drivers/vfio/pci/vfio_pci_priv.h
> > > index 5e4fa69aee16..5eab5abf2ff2 100644
> > > --- a/drivers/vfio/pci/vfio_pci_priv.h
> > > +++ b/drivers/vfio/pci/vfio_pci_priv.h
> > > @@ -3,6 +3,7 @@
> > > =C2=A0 #define VFIO_PCI_PRIV_H
> > > =C2=A0=20
> > > =C2=A0 #include <linux/vfio_pci_core.h>
> > > +#include <linux/io-64-nonatomic-lo-hi.h>
> >=20
> > Why include it here though?
> >=20
> > It should go in vfio_pci_rdwr.c and this patch should remove all
> > the "#ifdef iowrite64"'s from that file too.
>=20
> I was trying to make it future proof, but I agree it should be
> included only where iowrite64/ioread64 is getting called. I will make
> both the changes.
>=20
> Thanks,
> Ramesh
>=20
> >=20
> > But the idea looks right to me
> >=20
> > Thanks,
> > Jason

So how should we go about this?=20
To keep the scope that I can test manageable, my proposal would be:

I'll post a v5 of my series with the conditional compiles for
"ioread64"/"iowrite64" (effectively still excluding x86) - and you
Ramesh run this patch (add the include + change #ifdef's) as an
explicit patch on top?

Thanks,
Gerd


