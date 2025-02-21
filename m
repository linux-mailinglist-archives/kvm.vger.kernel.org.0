Return-Path: <kvm+bounces-38841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1368CA3F12B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 10:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0048D7019AA
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 09:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F9F820469D;
	Fri, 21 Feb 2025 09:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dgm2Flvx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367891E0DD8;
	Fri, 21 Feb 2025 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740131856; cv=none; b=KHngZUWjxyuZjexcyWqGM9Bwszl+g1Onqj2RhUujkflfLJGcRP9Fk7a8+ohdYYQVgsLWA5R6kNbAJKr1NLuNEqyUYWv3xOd/dGMPX9kHP8wflZUdh1isRFdDOaXddNFXhHPe9Y4Y0qNCqOxvsMQQ681ZNbrkoeMBz4GKSXPD5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740131856; c=relaxed/simple;
	bh=sXVw593ZoC57ceMork7Q3pTrmmGOhTUQ6LtS88ZFKaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tOPjWzlQy/URFI6qaTi+G0vQnIAHiP5j3bPoLKU+QrvqHFpH2gzYm//flgczk+8CSNn81EfkDAKu/iVcee1dtOs646HUkBM0o4PBesPX/I4V7WG0q6RbFyKk8xC4/CZona3BUR/eLey8a4T/Wb0vU844Kk02RWdRixcdy5lexMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dgm2Flvx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51L21f7W003042;
	Fri, 21 Feb 2025 09:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NI12m+UKWkD+/nsc1GrJ/rdFIwb5em
	pNDly47W5Tu6g=; b=Dgm2FlvxbI0rVlJsHTUoBjwzrYWTLyBrCao6PDXzpjRaWd
	DKeNhY6q2AcCpYKwlwfHKS7eX7N0LIf3Va84MiDAfgnRR8ye3SdLRWzmwL3/xelt
	l9JeUklrNfP/1W1XHBR5E+8NurIxqxg7SZtFPRZ2OkdZ3d1jvNgZa5Ct/gJWM/cc
	Wmy4X7DKKebRm9jKA27dPoHICgL7Da88l234pvbHT1ZhHv97WYLOjsLbpvBJ4zHr
	C57ucMx8AXrPgjaTSbFMSDTu8IPgfwVuymasYCTjJLp6sbyTF636Q0VoLn+cCorv
	G3N3RhOdjF2UdOhh7apIbQCuOSbsvYCLhQS8uJog==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44xgb09t08-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 09:57:30 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51L9CtSm029303;
	Fri, 21 Feb 2025 09:57:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44w024q6dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Feb 2025 09:57:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51L9vObT35848822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Feb 2025 09:57:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1ACDC201E6;
	Fri, 21 Feb 2025 09:57:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F359820158;
	Fri, 21 Feb 2025 09:57:20 +0000 (GMT)
Received: from osiris (unknown [9.179.14.8])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 21 Feb 2025 09:57:20 +0000 (GMT)
Date: Fri, 21 Feb 2025 10:57:19 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, agordeev@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH] s390/vio-ap: Fix no AP queue sharing allowed message
 written to kernel log
Message-ID: <20250221095719.11661Ba2-hca@linux.ibm.com>
References: <20250220000742.2930832-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220000742.2930832-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5QZpml_tscZqj1DV_1L5BLOlkKU3zM-t
X-Proofpoint-ORIG-GUID: 5QZpml_tscZqj1DV_1L5BLOlkKU3zM-t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-21_01,2025-02-20_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=934
 malwarescore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502210072

On Wed, Feb 19, 2025 at 07:07:38PM -0500, Anthony Krowiak wrote:
> -#define MDEV_SHARING_ERR "Userspace may not re-assign queue %02lx.%04lx " \
> -			 "already assigned to %s"
> +#define MDEV_SHARING_ERR "Userspace may not assign queue %02lx.%04lx " \
> +			 "to mdev: already assigned to %s"

Please do not split error messages across several lines, so it is easy
to grep such for messages. If this would have been used for printk
directly checkpatch would have emitted a message.

> +#define MDEV_IN_USE_ERR "Can not reserve queue %02lx.%04lx for host driver: " \
> +			"in use by mdev"

Same here.

>  	for_each_set_bit_inv(apid, apm, AP_DEVICES)
>  		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> -			dev_warn(dev, MDEV_SHARING_ERR, apid, apqi, mdev_name);
> +			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
> +				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev)));

Braces are missing. Even it the above is not a bug: bodies of for
statements must be enclosed with braces if they have more than one
line:

  	for_each_set_bit_inv(apid, apm, AP_DEVICES) {
  		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS) {
			dev_warn(mdev_dev(assignee->mdev), MDEV_SHARING_ERR,
				 apid, apqi, dev_name(mdev_dev(assigned_to->mdev))
		}
	}

> +static void vfio_ap_mdev_log_in_use_err(struct ap_matrix_mdev *assignee,
> +					unsigned long *apm, unsigned long *aqm)
> +{
> +	unsigned long apid, apqi;
> +
> +	for_each_set_bit_inv(apid, apm, AP_DEVICES)
> +		for_each_set_bit_inv(apqi, aqm, AP_DOMAINS)
> +			dev_warn(mdev_dev(assignee->mdev), MDEV_IN_USE_ERR,
> +				 apid, apqi);
> +}

Same here.

> +
> +/**assigned
>   * vfio_ap_mdev_verify_no_sharing - verify APQNs are not shared by matrix mdevs

Stray "assigned" - as a result this is not kernel doc anymore.

> + * @assignee the matrix mdev to which @mdev_apm and @mdev_aqm are being
> + *           assigned; or, NULL if this function was called by the AP bus driver
> + *           in_use callback to verify none of the APQNs being reserved for the
> + *           host device driver are in use by a vfio_ap mediated device
>   * @mdev_apm: mask indicating the APIDs of the APQNs to be verified
>   * @mdev_aqm: mask indicating the APQIs of the APQNs to be verified

Missing ":" behind @assignee. Please keep this consistent.

> @@ -912,17 +930,21 @@ static int vfio_ap_mdev_verify_no_sharing(unsigned long *mdev_apm,
>  
>  		/*
>  		 * We work on full longs, as we can only exclude the leftover
> -		 * bits in non-inverse order. The leftover is all zeros.
> +		 * bits in non-inverse order. The leftover is all zeros.assigned
>  		 */

Another random "assigned" word.

> +		if (assignee)
> +			vfio_ap_mdev_log_sharing_err(assignee, assigned_to,
> +						     apm, aqm);
> +		else
> +			vfio_ap_mdev_log_in_use_err(assigned_to, apm, aqm);

if body with multiple lines -> braces. Or better make that
vfio_ap_mdev_log_sharing_err() call a long line. If you want to keep
the line-break add braces to both the if and else branch.

