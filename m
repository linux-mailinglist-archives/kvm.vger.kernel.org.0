Return-Path: <kvm+bounces-57524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAF1B57330
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C84B7A1963
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 08:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740CA2EE294;
	Mon, 15 Sep 2025 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UDOiJeOV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58F21FC0EA;
	Mon, 15 Sep 2025 08:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757925554; cv=none; b=XX3ZWYM8ixoeIz2STD7N0fcPqK/ympeeV0bxOvaWDZZOfZsGfllpEGJ8eIQUOaU1XIucFWpL3HVWuj3jTjizHaDMKdT8+vZiNnTRlXRrF49YBL/fajtwhIklPA2Q7vKyVskplpFcoOiqsGC96XZ2Wo1/YMzkv3ZNNQmeAwTyjdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757925554; c=relaxed/simple;
	bh=XwSSQEnYlpWmAoL0MLbwOHTAKQNNwW81JyhsG/oCuic=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=osD1Oy04sXU9I0f5jl+ltSlCvD2K7PVfwCSLF89X4HVNjMSyDAc+AVGDTfgGY7cf2NlG3lK2OwKniPmPz0CDLaN7gaxxoK+6tn0/ucJ0RJVKtJAxfamHo22rhkI5vrCEZMSIxJetA8LRTVLy7vTi21AqODP+u65avuIpJkIlYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UDOiJeOV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F4bjPK025901;
	Mon, 15 Sep 2025 08:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cvCSuC
	eqSHCrlEFU23pYCZv1puHfKvN8alIIudy5V0g=; b=UDOiJeOVCfNM2Y/CRjX4lD
	gttdlYSgO+b2NSV86Qf9cuD7kYOPcORNFcav63lv8Gi1gVSaiSkcEORct1G5RIJc
	Jf7aRrcv4W/3/VdX3kfA+Cq7mDLuMUkz/gi08CaAw8o9c2DMNF1m+UkKl2MIB7Wu
	yj8Cajn37YgIFMNZ0nLZYjBDjtZgcUhcL9FMaM1XrGiMtwyQakQZE4zkQ0gIUJ34
	2QauM3CRT8v5oEaX66THt5t+V6b/wPYIg6h2o1XuDnvt87HAYWEVQ4+PZC+E3nyr
	BtdyQa2cBs8SZh65O/UvNrhSVPIeEJRmED/cN9pqPWj9wDjWj+dkogMB2brrZlkA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496069ber8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 08:39:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8ADwc018821;
	Mon, 15 Sep 2025 08:39:07 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5m58yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 08:39:07 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58F8d5nw9110226
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 08:39:05 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D13DC58053;
	Mon, 15 Sep 2025 08:39:05 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30DE658043;
	Mon, 15 Sep 2025 08:39:04 +0000 (GMT)
Received: from [9.87.138.96] (unknown [9.87.138.96])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 08:39:03 +0000 (GMT)
Message-ID: <d4ae1aede3a62ad60626e9706d11ed3c48f5a30a.camel@linux.ibm.com>
Subject: Re: [PATCH v3 05/10] s390/pci: Restore IRQ unconditionally for the
 zPCI device
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Mon, 15 Sep 2025 10:39:03 +0200
In-Reply-To: <20250911183307.1910-6-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	 <20250911183307.1910-6-alifm@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE0MDE0MiBTYWx0ZWRfX1EE0tTJk8YYe
 +YwKuP9Wag91u6WmdNjoexkraoCMc9GZSTrCY3+NIn2fHsWn5KC0o7MJcG0mBd9V0Vc7eurYAPA
 42LKYUizngIZv43KGfLG+PKn5OIBk3/GIRs+n3cccDQuhnS+0BBt8+FwRMcESF3lGO3OV+XbLpg
 cg6W6mo86koJ1mxJfpMwKhT5mma0E91mFwwL133eIhKRxCL2AQy34EcAotx2Gby+lly0xed+efF
 G0tZxkkmzrHI+qoEjmZ35FZYqMEL3On8gOg7ltDc8JEZ2rXrs9jhsJx0u1PIRetDIH+EeACSQoU
 iCnj+tTioZwPiTE74cbLlKwWNjNcw8gzcPfR2ClVrWT1K1UAawDOAjY4K1ayRi+J8gGeIhY7epv
 byDyGpEx
X-Authority-Analysis: v=2.4 cv=QaJmvtbv c=1 sm=1 tr=0 ts=68c7d0ac cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=l7NxTris-NvtxcoyapYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: K4x_GmkNbGNnICsYI5BtMLf8b0xbjVTf
X-Proofpoint-ORIG-GUID: K4x_GmkNbGNnICsYI5BtMLf8b0xbjVTf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_03,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509140142

On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
> Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
> introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
> resetting a zPCI device.
>=20
> Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
> mentions zpci_clear_irq() being called in the path for zpci_hot_reset_dev=
ice().
> But that is not the case anymore and these functions are not called
> outside of this file.

If you're doing another version I think you could add a bit more
information on why this still works for existing recovery based on my
investigation in
https://lore.kernel.org/lkml/052ebdbb6f2d38025ca4345ee51e4857e19bb0e4.camel=
@linux.ibm.com/

Even if you don't add more explanations, I'd tend to just drop the
above paragraph as it doesn't seem relevant and sounds like
zpci_hot_reset_device() doesn't clear IRQs. As explained in the linked
mail there really is no need to call zpci_clear_irq() in
zpci_hot_reset_device() as the CLP disable does disable IRQs. It's
really only the state tracking that can get screwed up but is also fine
for drivers which end up doing the tear down.=20

>=20
> However after a CLP disable/enable reset, the device's IRQ are
> unregistered, but the flag zdev->irq_registered does not get cleared. It
> creates an inconsistent state and so arch_restore_msi_irqs() doesn't
> correctly restore the device's IRQ. This becomes a problem when a PCI
> driver tries to restore the state of the device through
> pci_restore_state(). Restore IRQ unconditionally for the device and remov=
e
> the irq_registered flag as its redundant.

s/its/it's/

>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h | 1 -
>  arch/s390/pci/pci_irq.c     | 9 +--------
>  2 files changed, 1 insertion(+), 9 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 41f900f693d9..aed19a1aa9d7 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -145,7 +145,6 @@ struct zpci_dev {
>  	u8		has_resources	: 1;
>  	u8		is_physfn	: 1;
>  	u8		util_str_avail	: 1;
> -	u8		irqs_registered	: 1;
>  	u8		tid_avail	: 1;
>  	u8		rtr_avail	: 1; /* Relaxed translation allowed */
>  	unsigned int	devfn;		/* DEVFN part of the RID*/
> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
> index 84482a921332..e73be96ce5fe 100644
> --- a/arch/s390/pci/pci_irq.c
> +++ b/arch/s390/pci/pci_irq.c
> @@ -107,9 +107,6 @@ static int zpci_set_irq(struct zpci_dev *zdev)
>  	else
>  		rc =3D zpci_set_airq(zdev);
> =20
> -	if (!rc)
> -		zdev->irqs_registered =3D 1;
> -
>  	return rc;
>  }
> =20
> @@ -123,9 +120,6 @@ static int zpci_clear_irq(struct zpci_dev *zdev)
>  	else
>  		rc =3D zpci_clear_airq(zdev);
> =20
> -	if (!rc)
> -		zdev->irqs_registered =3D 0;
> -
>  	return rc;
>  }
> =20
> @@ -427,8 +421,7 @@ bool arch_restore_msi_irqs(struct pci_dev *pdev)
>  {
>  	struct zpci_dev *zdev =3D to_zpci(pdev);
> =20
> -	if (!zdev->irqs_registered)
> -		zpci_set_irq(zdev);
> +	zpci_set_irq(zdev);
>  	return true;
>  }
> =20

Code looks good to me. With or without my suggestions for the commit
message:

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>

