Return-Path: <kvm+bounces-38991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 150C8A41E09
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 13:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD3AB188ADBD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 11:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DDF221F20;
	Mon, 24 Feb 2025 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OIQraCGn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF5C219304;
	Mon, 24 Feb 2025 11:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740397313; cv=none; b=SRLyYeH8w55xpJd3XCzBt+nraoI+zp4RKV2m/xJeyUa9KrwqgyZxSNJHmoo7MQOStWLEiKm938fE7FTq+QtpwxL7sbhtpNeNg7UkQGJlrhTuww7D0rIbuRTfYq/98OKNd2ZotoNE9sBmPD0lCO5+FC4WaCkwWkmskTU+GX0Au7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740397313; c=relaxed/simple;
	bh=WsP5FQ3mCxBuTuBJKt0Zgz1NOMSmdPOTyzHp2koIBSY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sdtlX4aL3Ot418odAXMatUjMzmFQbc5+2hix1xcMXRE1S7Hf/hK/qIrC4H/I0XeO7zXfFnl5FqO+RnORDCG6tLzcBRRedfrNsRq3QVnaMdvA1FCARb0UrGfztGB+bQ86I0+dshfStAq1nD73z+0Er2WfLG9jECHyXX1hhn3Bbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OIQraCGn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51O5Nm3Z011957;
	Mon, 24 Feb 2025 11:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pa8u11
	GqThDw32jZlbVb07uGCAT1/zYQSHpQEKFFjHI=; b=OIQraCGnlz3urYGwNY3DdS
	I3hCHB3NXNf3LBunpPm5vgsrekpQoBqPM3YELo9sVeii3oe2AfyQqtEMr3SAaYZw
	q5u6BCVs7pO1Gdjs63AuwMcx/Nyh75TEn/tkqN8selSuyO60Pv1TNzcT0paIMLSq
	p0o2lLaRs+PjwMovMSf/SyiDEgTS66XkJ8uJdzy5fHYX9hSl492fl938Vxl6X5ww
	56O0EwN9pRau+mZ+//wtHCPZ8/6Oad94EoMHlVSiuNE9i6niC30X2gqJJ0YYZk1A
	/+sAvMGroV5B7AIhXg0dKPKvJEOlCO6uZQO1y0k4vnWCYR6rOMr6eBPPHy+/ms6Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450jk81hfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 11:41:41 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51OBY4AK009101;
	Mon, 24 Feb 2025 11:41:41 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 450jk81hfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 11:41:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBKK53012515;
	Mon, 24 Feb 2025 11:41:39 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44ys9y7378-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Feb 2025 11:41:39 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51OBfcZ820054704
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:41:38 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B622D58050;
	Mon, 24 Feb 2025 11:41:38 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C25DE58045;
	Mon, 24 Feb 2025 11:41:34 +0000 (GMT)
Received: from [9.171.81.103] (unknown [9.171.81.103])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Feb 2025 11:41:34 +0000 (GMT)
Message-ID: <16f499d3b04d0f56463b4b09e722f1900d21858c.camel@linux.ibm.com>
Subject: Re: [PATCH v6 3/3] PCI: s390: Enable HAVE_PCI_MMAP on s390 and
 restrict mmap() of resources to mappable BARs
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Alex Williamson
 <alex.williamson@redhat.com>,
        Gerd Bayer	 <gbayer@linux.ibm.com>,
        Matthew
 Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten
 Winkler <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Julian Ruess <julianr@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Gerald Schaefer	 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Mon, 24 Feb 2025 12:41:33 +0100
In-Reply-To: <20250214-vfio_pci_mmap-v6-3-6f300cb63a7e@linux.ibm.com>
References: <20250214-vfio_pci_mmap-v6-0-6f300cb63a7e@linux.ibm.com>
	 <20250214-vfio_pci_mmap-v6-3-6f300cb63a7e@linux.ibm.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oY8kH1XTy1ewNhu2Y-ZEr5Rb6UsG6lpl
X-Proofpoint-GUID: l2-s2rE6QjaNhJvvGedEd3NHf88j0tTe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxlogscore=765 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502240084

On Fri, 2025-02-14 at 14:10 +0100, Niklas Schnelle wrote:
> So far s390 does not select HAVE_PCI_MMAP. This is partly because access
> to mapped PCI resources requires special PCI load/store instructions and
> prior to commit 71ba41c9b1d9 ("s390/pci: provide support for MIO
> instructions") even required use of special syscalls. This really isn't
> a showstopper though and in fact lack of HAVE_PCI_MMAP has previously
> caused extra work when testing and debugging PCI devices and drivers.
>=20
> Another issue when looking at HAVE_PCI_MMAP however comes from the
> virtual ISM devices. These present 256 TiB BARs which really can't be
> accessed via a mapping to user-space.
>=20
> Now, the newly added pdev->non_mappable_bars flag provides a way to
> exclude devices whose BARs can't be mapped to user-space including the
> s390 ISM device. So honor this flag also in the mmap() paths protected
> by HAVE_PCI_MMMAP and with the ISM device thus excluded enable
> HAVE_PCI_MMAP for s390.
>=20
> Note that most distributions enable CONFIG_IO_STRICT_DEVMEM=3Dy and
> require unbinding drivers before resources can be mapped. This makes it
> extremely unlikely that any existing programs on s390 will now suddenly
> fail after succeeding to mmap() resources and then trying to access the
> mapping without use of the special PCI instructions.
>=20
> Link: https://lore.kernel.org/lkml/20250212132808.08dcf03c.alex.williamso=
n@redhat.com/
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h | 4 ++++
>  drivers/pci/pci-sysfs.c     | 4 ++++
>  drivers/pci/proc.c          | 4 ++++
>  3 files changed, 12 insertions(+)
>=20
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 474e1f8d1d3c2fc5685b459cc68b67ac651ea3e9..518dd71a78c83c74dc7b29778=
e299d5c8cabcc59 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -11,6 +11,10 @@
>  #include <asm/pci_insn.h>
>  #include <asm/sclp.h>
> =20
> +#define HAVE_PCI_MMAP			1
> +#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
> +#define arch_can_pci_mmap_wc()		1
> +
>  #define PCIBIOS_MIN_IO		0x1000
>  #define PCIBIOS_MIN_MEM		0x10000000
> =20
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index b46ce1a2c5542cdea0a3f9df324434fdb7e8a4d2..7373eca0a4943bf896b4a1771=
24e0d4572baec2b 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -1257,6 +1257,10 @@ static int pci_create_resource_files(struct pci_de=
v *pdev)
>  	int i;
>  	int retval;
> =20
> +	/* Skip devices with non-mappable BARs */
> +	if (pdev->non_mappable_bars)
> +		return 0;
> +
>  	/* Expose the PCI resources from this device as files */
>  	for (i =3D 0; i < PCI_STD_NUM_BARS; i++) {
> =20
> diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
> index f967709082d654a101039091b5493b2dec5f57b4..9348a0fb808477ca9be80a8b8=
8bbc036565bc411 100644
> --- a/drivers/pci/proc.c
> +++ b/drivers/pci/proc.c
> @@ -251,6 +251,10 @@ static int proc_bus_pci_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>  	    security_locked_down(LOCKDOWN_PCI_ACCESS))
>  		return -EPERM;
> =20
> +	/* Skip devices with non-mappable BARs */
> +	if (dev->non_mappable_bars)
> +		return -EINVAL;
> +
>  	if (fpriv->mmap_state =3D=3D pci_mmap_io) {
>  		if (!arch_can_pci_mmap_io())
>  			return -EINVAL;
>=20

Gentle ping

