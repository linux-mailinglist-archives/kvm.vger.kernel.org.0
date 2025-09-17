Return-Path: <kvm+bounces-57903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 716D2B803D1
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 16:48:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E0583A4BAD
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2756F32E734;
	Wed, 17 Sep 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mRaLDjks"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1BF3233FF;
	Wed, 17 Sep 2025 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120496; cv=none; b=fCwiOB2Jm+LpnJuHfZLwuqttV9350aXWom5tTA1W7ckUbPCa8K25Z+1yqXQ4Tw+mcY2XEaDGCyTi29Cskj0GrOmhNWuHOqbNbsRI5SBGpS/D9fA9aSp0bWkzw2BejyimjOsSuOrqA4u58KcoYJHs5MeC8pMRq0/VcxZnxPnw4cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120496; c=relaxed/simple;
	bh=Ml6O6w497nU6tE39XHfyycoKFCgDfhxLtanjGXr9EkM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lwWD/P2nEFBifzv6AKRuYv7xbjxDFRt2RWYJ753+lRP6G4ptNpR1QmKwcwj57+bwD46q2/M3X3JzyBhxGgB+HqI5b3ImsZm52tidZzg/pACJk2leH+CUHwnx0wPduCc8oQDcCoB1P4Ni2n8+IoEUjQnBDV/QUiTzWGyG+Pchx3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mRaLDjks; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9xmQt010516;
	Wed, 17 Sep 2025 14:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iM6K4B
	rf2n4FI280Hqoqbsetmqxy4maAo/oHD6XB0wQ=; b=mRaLDjksmuDmOTqmOwLsYu
	YYI6p+1vyXn9QU3INhZ7DZ4nZC3JRIiT4TctyNLNPgsVCQPUJx8aKmrqQUzcq7PO
	vWctTk1IoRHfW5jGVvcLMQycZ890ibfUaPfd/e0xfR3sobGsX9uadNR9TC/9BVnz
	n2STl+O2X1mCC8BXlQt22l3aW8SSDV/m24Wn7Sompmd+KV39RmIuKS5ie1DDB1Nl
	vUgezlcXrmPSoX2FSyQeC4O9kPEDJE/BUKrEs0doGM4xjzRaJsORUzzN36Ev3hgv
	IMsnia7S5wq+UPAlUvmkM8zb16Ryzop0pM+QNljdjOG5C3UxDaBh2bMsuCtGXUwA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nc5ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:48:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDLA9L006385;
	Wed, 17 Sep 2025 14:48:09 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxua05k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 14:48:09 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HEm74T19530266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 14:48:08 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA6FF5804E;
	Wed, 17 Sep 2025 14:48:07 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B96C45803F;
	Wed, 17 Sep 2025 14:48:06 +0000 (GMT)
Received: from [9.152.212.194] (unknown [9.152.212.194])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 14:48:06 +0000 (GMT)
Message-ID: <f60b86d08a4ad0feef32dc8e478f3bd3a8d26019.camel@linux.ibm.com>
Subject: Re: [PATCH v3 04/10] s390/pci: Add architecture specific
 resource/bus address translation
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Wed, 17 Sep 2025 16:48:06 +0200
In-Reply-To: <20250911183307.1910-5-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	 <20250911183307.1910-5-alifm@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68caca2a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=LO_JpcyrgH6vAt2cTOsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: x_gz8bpcPmknrLXED1ZXCv8W6cmxjDZW
X-Proofpoint-ORIG-GUID: x_gz8bpcPmknrLXED1ZXCv8W6cmxjDZW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX65UoeWKf/8O1
 w333gMa8pVY80gZFdM6q3+pSY0bmWsrw5G8O9+TqAO95oxC0V+hO/lM3JInaVu+7Vy0dtDf7hvS
 O3APEc//fHcwmI2BbPXYz3eZnL7lGaRIomfYdX2gV/yDV2qNISPCphaXNV7f0RyisM0cji8u3Rv
 iQQyTK9FfDhAa9hYs0ufzTE5nhm9o89XmcYd+C0SPj2zgcQBgnW/O26JJ6jnYwpkcbp2INwuYWx
 UevhpVjAIL9S2pG3XkqkmgzKGQhlqBcmKoZkTqxCKft1vqL3gE/qkyuWMA971YXCGNZc+dAsJok
 Jhv0yoqrFXizmaRAcyVnhWixLOEkEQh9cEorXJWPvGL1v7DDLdlCkzpYL+vL80OqPuewyANwLHA
 G+LktPbF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
> On s390 today we overwrite the PCI BAR resource address to either an
> artificial cookie address or MIO address. However this address is differe=
nt
> from the bus address of the BARs programmed by firmware. The artificial
> cookie address was created to index into an array of function handles
> (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmwa=
re
> but maybe different from the bus address. This creates an issue when tryi=
ng
> to convert the BAR resource address to bus address using the generic
> pcibios_resource_to_bus.
>=20

Nit: I'd prefer referring to functions with e.g.
pcibios_resource_to_bus() to make them easier to distinguish. Same also
below.

> Implement an architecture specific pcibios_resource_to_bus function to
> correctly translate PCI BAR resource address to bus address for s390.

Nit: I'd use the plural "addresses" above as we're dealing with a whole
range.

> Similarly add architecture specific pcibios_bus_to_resource function to d=
o
> the reverse translation.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c       | 73 +++++++++++++++++++++++++++++++++++++++
>  drivers/pci/host-bridge.c |  4 +--
>  2 files changed, 75 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index cd6676c2d602..5baeb5f6f674 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -264,6 +264,79 @@ resource_size_t pcibios_align_resource(void *data, c=
onst struct resource *res,
>  	return 0;
>  }
> =20
> +void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region =
*region,
> +			     struct resource *res)
> +{
> +	struct zpci_bus *zbus =3D bus->sysdata;
> +	struct zpci_bar_struct *zbar;
> +	struct zpci_dev *zdev;
> +
> +	region->start =3D res->start;
> +	region->end =3D res->end;
> +
> +	for (int i =3D 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
> +		int j =3D 0;
> +
> +		zbar =3D NULL;
> +		zdev =3D zbus->function[i];
> +		if (!zdev)
> +			continue;
> +
> +		for (j =3D 0; j < PCI_STD_NUM_BARS; j++) {
> +			if (zdev->bars[j].res->start =3D=3D res->start &&
> +			    zdev->bars[j].res->end =3D=3D res->end) {
> +				zbar =3D &zdev->bars[j];
> +				break;
> +			}
> +		}
> +
> +		if (zbar) {
> +			/* only MMIO is supported */

Should the code that sets zbar check IORESOURCE_MEM on the res->flags
to ensure the above comment? Though zpci_setup_bus_resources() only
creates IORESOURCE_MEM resources so this would only be relevant if
someone uses a resource from some other source.

> +			region->start =3D zbar->val & PCI_BASE_ADDRESS_MEM_MASK;
> +			if (zbar->val & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +				region->start |=3D (u64)zdev->bars[j + 1].val << 32;
> +
> +			region->end =3D region->start + (1UL << zbar->size) - 1;
> +			return;
> +		}
> +	}
> +}
> +
> +void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
> +			     struct pci_bus_region *region)
> +{
> +	struct zpci_bus *zbus =3D bus->sysdata;
> +	struct zpci_dev *zdev;
> +	resource_size_t start, end;
> +
> +	res->start =3D region->start;
> +	res->end =3D region->end;
> +
> +	for (int i =3D 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
> +		zdev =3D zbus->function[i];
> +		if (!zdev || !zdev->has_resources)
> +			continue;
> +
> +		for (int j =3D 0; j < PCI_STD_NUM_BARS; j++) {
> +			if (!zdev->bars[j].val && !zdev->bars[j].size)
> +				continue;

Shouldn't the above be '||'? I think both a 0 size and an unset bars
value would indicate invalid. zpci_setup_bus_resources() only checks 0
size so I think that would be enoug, no?

> +
> +			/* only MMIO is supported */
> +			start =3D zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_MASK;
> +			if (zdev->bars[j].val & PCI_BASE_ADDRESS_MEM_TYPE_64)
> +				start |=3D (u64)zdev->bars[j + 1].val << 32;
> +
> +			end =3D start + (1UL << zdev->bars[j].size) - 1;
> +
> +			if (start =3D=3D region->start && end =3D=3D region->end) {
> +				res->start =3D zdev->bars[j].res->start;
> +				res->end =3D zdev->bars[j].res->end;
> +				return;
> +			}
> +		}
> +	}
> +}
> +
>=20

Overall the code makes sense to me. I think this hasn't caused issues
so far only because firmware has usually already set up the BAR
addresses for us.

Thanks,
Niklas

