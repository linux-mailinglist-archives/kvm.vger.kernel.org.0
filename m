Return-Path: <kvm+bounces-55849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBEDB37C35
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:51:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12ECE7B1435
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 07:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D019321F28;
	Wed, 27 Aug 2025 07:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TlWxhkQb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF9131CA42;
	Wed, 27 Aug 2025 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756281046; cv=none; b=pbcDKRbCmKPzBMmQBfqiQexZ6rxz6OICH/w/xodNQhYqsTMWLy+gxY98aFh7coWkV8tZF70gai69KJ4LNREsnq9X22FarBhABNakCVMQnfAZjh13N6WrLyxDKIIXcZqbFKA06Hblc6jEw6v8aDuFYbfScPFO3Ab/h3yFz6ChVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756281046; c=relaxed/simple;
	bh=E13liiV1vn68rNIA25MCsUZqiJwzIO6wW6GFVuzr3PA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OR7QcGksnmA0sfs352YO1rDbHw8KF8hbzUYWNJsy6BcSssLVziCqqzW1kt/A+htBWiVhI8BLvlmrDWt/ONL6xTvRIoGMMEC5PKT9edNOJFE3rSnMAQBnWU7qiaDK1ppRLSzhTH8tmIlSAjXwQ8CEt2cX//OiOrKw72oxbbYm0So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TlWxhkQb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R739Ou001329;
	Wed, 27 Aug 2025 07:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VFhNfQ
	KPr2sy+yxCip+9sXGk5A98Q9PJI58g61iOqPo=; b=TlWxhkQbtYnNvUYozAVp3i
	ECR8Fp0P+2OrIgOEFlwOhqBUAjZSI3x6G4pXIA7XspH5ZB5QSNRtR9Y8T1sehysv
	+ApWHUPQ3XTClRwpliPylmaA+C1zvnVoJxTm7C/Vx3V2DNisOxniwnenmxX2ttZS
	1vFBkxp1wR/gJb4wnZ/auhDX9Q8LPcU9mBMZTE8KgeK7WnHEP/eA/kqapU4BFzu9
	kuatQEf/lYCe6ALehvzoDjg8FK74CJ6S9hN/0wFnwTQMWua3/5uqbiiDxfL6gRVX
	sRBsv6il509/GExFFMpADatK7wMEdkCiRJPV6XQ11JUAyP3oTu53Q/6wNHmN5Mmg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q5hq2rhh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 07:50:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7honi002543;
	Wed, 27 Aug 2025 07:50:39 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48qryppy4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Aug 2025 07:50:39 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57R7obuI31064680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 07:50:38 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC1795805D;
	Wed, 27 Aug 2025 07:50:37 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D38758056;
	Wed, 27 Aug 2025 07:50:36 +0000 (GMT)
Received: from [9.111.77.147] (unknown [9.111.77.147])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 27 Aug 2025 07:50:36 +0000 (GMT)
Message-ID: <cad13ef2b958b70f7242e2ee1c89e2c458c8a5e5.camel@linux.ibm.com>
Subject: Re: [PATCH v2 3/9] PCI: Allow per function PCI slots for hypervisor
 isolated functions
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Wed, 27 Aug 2025 09:50:35 +0200
In-Reply-To: <20250825171226.1602-4-alifm@linux.ibm.com>
References: <20250825171226.1602-1-alifm@linux.ibm.com>
	 <20250825171226.1602-4-alifm@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX3NHg/1iYwkKt
 D4/r1B8c8bJRc4vU2xluer12IuDEwueF4HxnmXKeKCJvkbtdBTGawT9nZnvlD5RlxHCtdUWyqQz
 EYJbH59U1UoaLGPIGapiW+WVe+PqSfGDA7wyApH6Gnl0d6w1IZdi6645DldSNxG2FicEhWBVf8L
 /9TxwukD/tXfD8/Lum2LJpGMU0xZIqMoeqSZ+hszPQ0Xfhv77g7PElz2jC5eOJXy2g8+zqa472s
 5KQugjfzjjKx+DjJHrP3pLC2DtgHxV88QPEPS2Wd3NcxD0v42FVf36c674E9FBUJ7YtH1BOextB
 s15tlSgiBt7JHfvgPeLbbshfzXX8FKDQySTxvq1i70b6iCeSCtVHTfSdrKYty7SDEQJfMJYdC/z
 QqLrb2Bp
X-Proofpoint-ORIG-GUID: jGfNyVBr-pMLjG7oNTtEg484WoZC4iah
X-Proofpoint-GUID: jGfNyVBr-pMLjG7oNTtEg484WoZC4iah
X-Authority-Analysis: v=2.4 cv=Ndbm13D4 c=1 sm=1 tr=0 ts=68aeb8cf cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=cH6R9-kdAAAA:8
 a=NsU5iuw7hqHUjNsZKVwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021

On Mon, 2025-08-25 at 10:12 -0700, Farhan Ali wrote:
> On s390 systems, which use a machine level hypervisor, PCI devices are
> always accessed through a form of PCI pass-through which fundamentally
> operates on a per PCI function granularity. This is also reflected in the
> s390 PCI hotplug driver which creates hotplug slots for individual PCI
> functions. Its reset_slot() function, which is a wrapper for
> zpci_hot_reset_device(), thus also resets individual functions.
>=20
> Currently, the kernel's PCI_SLOT() macro assigns the same pci_slot object
> to multifunction devices. This approach worked fine on s390 systems that
> only exposed virtual functions as individual PCI domains to the operating
> system.  Since commit 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> s390 supports exposing the topology of multifunction PCI devices by
> grouping them in a shared PCI domain. When attempting to reset a function
> through the hotplug driver, the shared slot assignment causes the wrong
> function to be reset instead of the intended one. It also leaks memory as
> we do create a pci_slot object for the function, but don't correctly free
> it in pci_slot_release().
>=20
> This patch adds a helper function to allow per function PCI slots for
> functions managed through a hypervisor which exposes individual PCI
> functions while retaining the topology.
>=20
> Fixes: 44510d6fa0c0 ("s390/pci: Handling multifunctions")
> Co-developed-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/pci/slot.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
> index 50fb3eb595fe..991526af0ffe 100644
> --- a/drivers/pci/slot.c
> +++ b/drivers/pci/slot.c
> @@ -5,6 +5,7 @@
>   *	Alex Chiang <achiang@hp.com>
>   */
> =20
> +#include <linux/hypervisor.h>
>  #include <linux/kobject.h>
>  #include <linux/slab.h>
>  #include <linux/pci.h>
> @@ -73,7 +74,7 @@ static void pci_slot_release(struct kobject *kobj)
> =20
>  	down_read(&pci_bus_sem);
>  	list_for_each_entry(dev, &slot->bus->devices, bus_list)
> -		if (PCI_SLOT(dev->devfn) =3D=3D slot->number)
> +		if (dev->slot =3D=3D slot->number)
>  			dev->slot =3D NULL;
>  	up_read(&pci_bus_sem);
> =20
> @@ -160,13 +161,25 @@ static int rename_slot(struct pci_slot *slot, const=
 char *name)
>  	return result;
>  }
> =20
> +static bool pci_dev_matches_slot(struct pci_dev *dev, struct pci_slot *s=
lot)
> +{
> +	if (hypervisor_isolated_pci_functions()) {
> +		if (dev->devfn =3D=3D slot->number)
> +			return true;
> +	} else {
> +		if (PCI_SLOT(dev->devfn) =3D=3D slot->number)
> +			return true;
> +	}
> +	return false;
> +}
> +
>  void pci_dev_assign_slot(struct pci_dev *dev)
>  {
>  	struct pci_slot *slot;
> =20
>  	mutex_lock(&pci_slot_mutex);
>  	list_for_each_entry(slot, &dev->bus->slots, list)
> -		if (PCI_SLOT(dev->devfn) =3D=3D slot->number)
> +		if (pci_dev_matches_slot(dev, slot))
>  			dev->slot =3D slot;
>  	mutex_unlock(&pci_slot_mutex);
>  }

Doing some more digging, I believe this also needs adjustment in
pci_dev_reset_slot_function(). Since commit 10791141a6cf ("PCI:
Simplify pci_dev_reset_slot_function()") that no longer directly looks
at the struct pci_slot linking but instead assumes that slot resets
don't work on multifunction devices. With per PCI function slots the
slot reset should work with pdev->multifunction set. I think adjusting
pci_dev_reset_slot_function() may be easier if instead of using the
hypervisor_isolated_pci_functions() helper we would set up a struct
pci_slot::per_func flag as we had considered as an option.

Thanks,
Niklas

