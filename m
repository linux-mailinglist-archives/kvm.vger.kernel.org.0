Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0930646D04D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 10:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhLHJsB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 04:48:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18958 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230088AbhLHJsA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 04:48:00 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B89IcaP021475;
        Wed, 8 Dec 2021 09:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=X106KzP5HDDfFU/aM/UB2UNxwHBMudb95OXKi1Xy1/I=;
 b=L97sxL3m9n9yAACNZArOT7SxUVQbg0dLyWgMSBOXwK8jM7fDuy4E3Xwo9KYkh4jI2TJc
 hmmlDYJ1g0IlH2xkKC5sDeqtnTysIY03ao4knGoWcHD5pmNQe8a8OU+EQyyttgRjRjT+
 tdlFLjwXxHJVautUukYEKx0wkqnTO7BAvLHmWSlB+RQ3D3w0KnV5CWrsQblVmP4SQ8Ub
 ro5MMfIVN10uOyGpE4b7gTRf/PO0JRJ+wS7ECySI+jVt20pg3AutTiob6H8YonYV3nP9
 vh+Rybr5sAFPXxOaY5Avd7CNfRX0uv5+to0ayUlcIvxaluu1yqRxdt0NtRFUOrC/ZWCg mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctsy7gds7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 09:44:27 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B89gNd2011547;
        Wed, 8 Dec 2021 09:44:26 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctsy7gdrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 09:44:26 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B89gqEJ012650;
        Wed, 8 Dec 2021 09:44:24 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykje6bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 09:44:24 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B89iLpO14877056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 09:44:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFAD6AE058;
        Wed,  8 Dec 2021 09:44:20 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BE13AE045;
        Wed,  8 Dec 2021 09:44:19 +0000 (GMT)
Received: from sig-9-145-190-99.de.ibm.com (unknown [9.145.190.99])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 09:44:19 +0000 (GMT)
Message-ID: <8c2f83d2186e93965eba74356126df7fd35d9a41.camel@linux.ibm.com>
Subject: Re: [PATCH 20/32] KVM: s390: pci: provide routines for
 enabling/disabling interpretation
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 08 Dec 2021 10:44:19 +0100
In-Reply-To: <20211207205743.150299-21-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
         <20211207205743.150299-21-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cjfpa-oblD2e2FpldvJHdLyEh8RdKqLb
X-Proofpoint-ORIG-GUID: spuxnzSjjEEHsu_lDU0Xh-s5OvFxKagv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 adultscore=0 clxscore=1011 phishscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
> These routines will be wired into the vfio_pci_zdev ioctl handlers to
> respond to requests to enable / disable a device for zPCI Load/Store
> interpretation.
> 
> The first time such a request is received, enable the necessary facilities
> for the guest.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_pci.h |  4 ++
>  arch/s390/kvm/pci.c             | 91 +++++++++++++++++++++++++++++++++
>  arch/s390/pci/pci.c             |  3 ++
>  3 files changed, 98 insertions(+)
> 
> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
> index 3e491a39704c..5d6283acb54c 100644
> --- a/arch/s390/include/asm/kvm_pci.h
> 
---8<---
> 		return rc;
> +	}
> +
> +	/*
> +	 * Store information about the identity of the kvm guest allowed to
> +	 * access this device via interpretation to be used by host CLP
> +	 */
> +	zdev->gd = gd;
> +
> +	rc = zpci_enable_device(zdev);
> +	if (rc)
> +		goto err;
> +
> +	/* Re-register the IOMMU that was already created */
> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
> +				(u64)zdev->dma_table);

The zdev->dma_table is a virtual address but we need an absolute
address in the MPCIFC so the above should use
virt_to_phys(zdev->dma_table) to be compatible with future V != R
kernel memory. As of now since virtual and absolute kernel addresses
are the same this is not a bug and we've had this (wrong) pattern in
the rest of the code but let's get it righht here from the start.

See also my commit "s390/pci: use physical addresses in DMA tables"
that is currently in the s390 feature branch.

> +	if (rc)
> +		goto err;
> +
> +	return rc;
> +
> +err:
> +	zdev->gd = 0;
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
> +
> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
> +{
> +	int rc;
> +
> +	if (zdev->gd == 0)
> +		return -EINVAL;
> +
> +	/* Remove the host CLP guest designation */
> +	zdev->gd = 0;
> +
> +	if (zdev_enabled(zdev)) {
> +		rc = zpci_disable_device(zdev);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	rc = zpci_enable_device(zdev);
> +	if (rc)
> +		return rc;
> +
> +	/* Re-register the IOMMU that was already created */
> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
> +				(u64)zdev->dma_table);

Same as above

> +
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
> +
> 
---8<---

