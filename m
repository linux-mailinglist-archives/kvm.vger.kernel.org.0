Return-Path: <kvm+bounces-58740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C1D1B9ED28
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 12:54:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2675D3A70D4
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 10:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FF52F5A18;
	Thu, 25 Sep 2025 10:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iQj3bhp7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E7F2F3C19;
	Thu, 25 Sep 2025 10:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758797659; cv=none; b=NDpSlt/rtqmJqydipSJnF8+X/+c24rZaJVKN6Fm6KQ3pAf+g+rOC2753da9uEc1TxSf5vNQGtFJLqJ8FZQZESoRtkv69V0DboENO+c5GJ5cvx+sMI4IRrU22l/gEGc8WVxuzAtX94Ed5D4TL1fv9S/M/FDqL/Tga2OkJsFM8mtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758797659; c=relaxed/simple;
	bh=gW6yDLpg5QpPBsovHx4B+NFb3GnUvfRZXCdEZ5L04VU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tLBcV77R+Of6ypMwEqV9m14Sfi5DyFrR6oq1sB8EpkikYlKZ3MAsb6XVcZJCQbPeSGSK4UD5qvmMRO5fHmqYwf18UVO7KF0L/OxUerYYNDy8+vVzP4MPionrXG7P4ggR0Tp0A5U77D6b+YqmMJql+1VzMt2IsOTAbZVHTgbHkNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iQj3bhp7; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P1wIWJ015399;
	Thu, 25 Sep 2025 10:54:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ja5yQQ
	PjRjo0/Spx00gHL7pBWaoCv9NSzwf105E6Huc=; b=iQj3bhp75uOv7dlu81Wqx7
	WWG1NLGwbP7XXxTwV8FETGSQuRMRnS/YTafzgfYlGFUUUupnzFesEa7uGaCCT1EN
	DVo7/KwkObEdZ3U41wJUYGEXLxWsW1j9P9C+1DpNE8/ZAAoULFfhNIYpaXBzYJo3
	dBMOiE5mppSK66arPrpn6U6tL1tx14531SVsZ87aNiDgK2IN89Ed8BuZPOQ0tDsr
	Jmrv4BmZVwqmkI1PdsnZPgiazD8+diPzQ4T0gLZr+3C4/iRGbI+utzEHXWngf8JH
	agjUSJADPEzRk8t8Z4rCRdiKKoqT1nGMWCWIrPrxTGRwDdVdIaqB09y3ReF6/UbQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ksc58tq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 10:54:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58P9gWIb031139;
	Thu, 25 Sep 2025 10:54:11 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vdeer2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 10:54:11 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PAsAG818219714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 10:54:10 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 469D758059;
	Thu, 25 Sep 2025 10:54:10 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B1FE58055;
	Thu, 25 Sep 2025 10:54:08 +0000 (GMT)
Received: from [9.111.71.247] (unknown [9.111.71.247])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 10:54:08 +0000 (GMT)
Message-ID: <2d049d60868c0f61e53e70a73881f8674368537a.camel@linux.ibm.com>
Subject: Re: [PATCH v4 04/10] s390/pci: Add architecture specific
 resource/bus address translation
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
Date: Thu, 25 Sep 2025 12:54:07 +0200
In-Reply-To: <20250924171628.826-5-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
	 <20250924171628.826-5-alifm@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: Rfo0fykP9xRX2Pu2mp6z6SyfxKLFvXsM
X-Proofpoint-GUID: Rfo0fykP9xRX2Pu2mp6z6SyfxKLFvXsM
X-Authority-Analysis: v=2.4 cv=SdH3duRu c=1 sm=1 tr=0 ts=68d51f54 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=LO_JpcyrgH6vAt2cTOsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX3gqL01phd10O
 PwbAiQZRuz/Nzj0/Lqdw5/4qJq0dnuLE5mNoPmdRapH1N03f+R2GXEvvUgoi+8Pc8VesKHrJ4/U
 6R22w7g/cW5R+KwEZEZMGLq0GD3t3K9VUbu2BZ7MACux7Nbrde3y5Bd/WdpUWTyzSUx3OkHqAwS
 Pr2ZuDH30Z4cE0HJ0SkKR1Cg5i47QDof/F2XLHsGudyBInF/zlw9ZJdYRI4PdRr8GKZz+hXRvap
 P2Bpo01IjywtGP4K4/xp5NHt7QP/JS5kVDItAMlXjy8vg3HuR1O/J9EKSGZssidoHa+z7Hi3+O4
 v2seJ297wL+DiO64SU+ZQuVxdZqIUC1PExeKtjls6B1paKWF4G6gHJDyCX6HcWkfPEShgSbQtp2
 QiEU6tIC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> On s390 today we overwrite the PCI BAR resource address to either an
> artificial cookie address or MIO address.=C2=A0
>=20

I'm not sure "overwrite" fits here. Maybe just "are" and also use the
plural "addresses" and drop the "we" so:
"On s390 today PCI BAR resource addresses are either artificial cookie
addresses or MIO addresses". Then also adjust for the plural below with
"these addresses are".

Backghround: The resource addresses are CPU addresses used for MMIO. On
s390 we either have to adapt the old PCI instructions, which are
distinctly not memory mapped for a memory mapping based API via the
address cookie / zpci_iomap mechanismm, or if we have memory-I/O (MIO)
support, use the MIO addresses + memory mapped PCI instructions. Even
the MIO addresses may not match the bus addresses.

> However this address is different
> from the bus address of the BARs programmed by firmware. The artificial
> cookie address was created to index into an array of function handles
> (zpci_iomap_start). The MIO (mapped I/O) addresses are provided by firmwa=
re
> but maybe different from the bus address. This creates an issue when tryi=
ng

Nit: "may be different from the corresponding bus addresses."

> to convert the BAR resource address to bus address using the generic
> pcibios_resource_to_bus().
>=20
> Implement an architecture specific pcibios_resource_to_bus() function to
> correctly translate PCI BAR resource addresses to bus addresses for s390.
> Similarly add architecture specific pcibios_bus_to_resource function to d=
o
> the reverse translation.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  arch/s390/pci/pci.c       | 74 +++++++++++++++++++++++++++++++++++++++
>  drivers/pci/host-bridge.c |  4 +--
>  2 files changed, 76 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index cd6676c2d602..3992ba44e1cf 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -264,6 +264,80 @@ resource_size_t pcibios_align_resource(void *data, c=
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

When we don't find a BAR matching the resource this would become the
region used. I'm not sure what a better value would be if we don't find
a match though and that should hopefully not happen in sensible uses.
Also this would keep the existing behavior so seems fine.

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
> +			    zdev->bars[j].res->end =3D=3D res->end &&
> +			    res->flags & IORESOURCE_MEM) {
> +				zbar =3D &zdev->bars[j];
> +				break;
> +			}
> +		}
> +
> +		if (zbar) {
> +			/* only MMIO is supported */
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

Similar to above. One thought though, I think we could set res->flags
!=3D IORESOURCE_UNSET | IORESOURCE_DISABLED. Of course that would have to
be moved after the loop so it only takes effect when we don't find a
match.

> +
> +	for (int i =3D 0; i < ZPCI_FUNCTIONS_PER_BUS; i++) {
> +		zdev =3D zbus->function[i];
> +		if (!zdev || !zdev->has_resources)
> +			continue;
> +
> +		for (int j =3D 0; j < PCI_STD_NUM_BARS; j++) {
> +			if (!zdev->bars[j].size)
> +				continue;
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
--- snip ---


With or without my suggestion this clearly looks more correct than what
we had so far, even though that hasn't caused issues as far as I'm
aware until your BAR restoration change.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

