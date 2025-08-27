Return-Path: <kvm+bounces-55882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5267FB383AA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 15:27:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFF444628DE
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 13:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7778435208B;
	Wed, 27 Aug 2025 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WEMfg7xR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F337934DCCA;
	Wed, 27 Aug 2025 13:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756301261; cv=none; b=eQreALwP8sNeNH1dsu/ps5rg6kwgh5jOaFj6dfAIkSGORgF13DsWfkj/OrEg6dMIwXjpmBwEuM9eeZTvdJRqzcGEHyN27k5je3R3JRXOGmzkvR5KT/mDkgq4i6x61CHu11o+oBbjmwhbVbg6BXwbZv8H+vDFJkuEMjfo4Ak8GPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756301261; c=relaxed/simple;
	bh=B/a9Cw35FsEI8LuGkmTjgJ4mx3HGvYwCLgEvVfd4KOw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z7rkEf5pZLH8dvlrEvWjnzsqYZjPZve2bBZm1AOMHmpFiFobLQtm2O8y7z3WKxD+JgvIe8eM3/7CRjJPXRVv5LUtdUTRVSwmCqgmk9NeM8vEoCHAFGnW37ZUgKHjoSHwJpcyDJmj6sPkSoejGEJvjsPIRxPuExAbkIrP9YS3HIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WEMfg7xR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R82RIl006043;
	Wed, 27 Aug 2025 13:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xzw4JW
	Zm/NKxEJETbd8yf3HerzZssj+NuITssYPYYKk=; b=WEMfg7xR9eZMHnSx2Qazzx
	EHziJful61Vi6jyYBwXTqWiXMxzFa47o5+sVUsymgtSkvIVayHHhE7QpI9CAyN3u
	fqyhOdIN2wI47FO0SfErdPiMaMSoaz2J9HRe2iz+tAvfkur2yOfp11ydrK6B8/g5
	KdFIP0piUfHYGcgjZ7lnUIC9wDt0L3IHk+cWBDtvrZuzaXbMoFxYsY/W9Hd0s7cH
	0HJOmkD6Rc5golJkBGoarrr+alko79ZGp7T3j/ambrtj8/RfTLxmFolgu6ByIsVz
	hhfL3aUV7UqkMUq3pYyN0CEjYrwHmJruda437UQ3pgXtHqpr64ZbgGFcrCK1yMpA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q975bjpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 13:27:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57R9YWsp018009;
	Wed, 27 Aug 2025 13:27:34 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qtp3ftbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 13:27:34 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57RDRX3v10617986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 13:27:33 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5E0A358052;
	Wed, 27 Aug 2025 13:27:33 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B223158050;
	Wed, 27 Aug 2025 13:27:31 +0000 (GMT)
Received: from [9.111.77.147] (unknown [9.111.77.147])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Aug 2025 13:27:31 +0000 (GMT)
Message-ID: <052ebdbb6f2d38025ca4345ee51e4857e19bb0e4.camel@linux.ibm.com>
Subject: Re: [PATCH v2 4/9] s390/pci: Restore airq unconditionally for the
 zPCI device
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Wed, 27 Aug 2025 15:27:30 +0200
In-Reply-To: <20250825171226.1602-5-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
	 <20250825171226.1602-5-alifm@linux.ibm.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VBhOQStGjCijLlShYRDB4O2KjWfKUB7J
X-Proofpoint-ORIG-GUID: VBhOQStGjCijLlShYRDB4O2KjWfKUB7J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX2qMoVz+BIODC
 FD7rGg9c1B0ZXDu3OnW6WII+hmI1mTvuFQR3l2I0q2KGgEVl8fg35p253FRxAsnbgmKbvzk9BoO
 9PIK/qEq9P/3JRBiL2npW1ehUtm039faZdfIKszQ3MhgllJIMsrKQlT0PpizOxGnJrbHtiKk5Sg
 zwvb72zXSAxyZJh5kNaMEmV0+2uHddhgYWWhQhR4cjtEmT1Cw++Pt+Y4/mqkpZNrAccLTNScr80
 QPCSJIpxOsAy2tTTC9FqhBZcWSm9qIVEXLonYpt9UnMvSHn4SpO1TwNNnu6nJO/SxoP+XAxWK6j
 IQIMGi9PpPr83LuLxJ7j5KsAR8CH+/JMZuvx9MiTqyd6fv5IexnPoHTWaDiCqkH49VErNqQhLWz
 PxBuYrCt
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68af07c7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=UAdS6kkTSP8u3R-jiBMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_03,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071

On Mon, 2025-08-25 at 10:12 -0700, Farhan Ali wrote:
> Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
> introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
> resetting a zPCI device.
>=20
> Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug slot"),
> mentions zpci_clear_irq() being called in the path for zpci_hot_reset_dev=
ice().
> But that is not the case anymore and these functions are not called
> outside of this file.
>=20
> However after a CLP disable/enable reset (zpci_hot_reset_device),the airq

Nit: missing space after ","

> setup of the device will need to be restored. Since we are no longer
> calling zpci_clear_airq() in the reset path, we should restore the airq f=
or
> device unconditionally.
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

I dug a bit to see why this isn't a problem for the existing non-vfio
PCI recovery. It looks like the drivers end up calling
arch_teardown_msi_irqs() and then arch_setup_msi_irqs() as part of
their recovery handlers. For example nvme calls nvme_dev_disable() in
error_detected() which calls pci_free_irq_vectors() and ultimately
zpci_clear_irq().

Similarly zpci_set_irq() is ultimately called in
pci_alloc_irq_vectors() in nvme_pci_enable() as part of=20
nvme_reset_work().

Additionally zpci_clear_irq() returns success and ignores errors when
the IRQs are already cleared allowing zpci_clear_irq() to set zdev-
>irqs_registered =3D 0 even if the device is in the error or disabled
state. On the other hand zpci_set_irq() would not ignore trying to
register IRQs if they are already registered.

So I think the commit description is somewhat confusing because the CLP
disable case works if, like with the existing recovery, IRQs get torn
down and setup anew after the reset and because the zpci_clear_irq()
isn't needed in zpci_hot_reset_device() because clp_disable_fh()
already does this. I believe the mention of that was because in an
earlier, never merged, version I had an explicit zpci_clear_irq() but
this was removed because it is redundant, except for flipping the flag
of course.

On the other hand I think the code change itself makes sense. The zdev-
>irqs_registered flag hides when someone tries to register IRQs twice
which I think we would want to know about. And more importantly the
flag doesn't correctly mirror the actual state because CLP disable
doesn't clear the flag but unregisters IRQs and then
arch_restore_msi_irqs() doesn't actually re-regiser IRQs because it
assumes the wrong state. And this is just hidden because none of the
relevant drivers seem to solely rely on pci_restore_state() but do tear
down / setup regardless. I think thus the commit description should
focus on the possibly inconsistent state and arch_restore_msi_irqs()
and then it all makes sense.

Thanks,
Niklas

