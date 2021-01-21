Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC232FE708
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 11:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbhAUKCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 05:02:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21278 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbhAUKCj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 05:02:39 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L9hgfd057440;
        Thu, 21 Jan 2021 05:01:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fWmDxwr0lY5cxX6xfLHH7j/5gs2HRvrd8TewAEyWzGc=;
 b=KGFXq0y+NMAue7EbfhxufiNso8/jVRVgLfC0F8qB4oFOhcmGMsitYROWw9aXQH6uoT/i
 OFfwmNVEOFaOzHdbvdpy7OtOJUMqhaXay2PM+pmtMMwtlBpQzIztmGnsVveJbiFMaMX+
 VKpIsAGjYibtCCI4e+6xNuFtE0eurYoDwZoxrf/j5dA6He6UG+la23M3hjOfVIdD1BAG
 q4aC1qoJ0EjAwNBrKyBZbohszU1upJSbmN8HeqIdEUAFlGyMixSAkzM5Yri3YBr+scuy
 mEzij8hhGPh6wcZb8w0Tx7HkhuzLK/B9wb8yfX2frFq6E67Sg2F0Gwgi3qiyynPMony8 MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36777sgetm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 05:01:56 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L9i6Tq059476;
        Thu, 21 Jan 2021 05:01:54 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36777sgemp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 05:01:53 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L9bTbk014203;
        Thu, 21 Jan 2021 10:01:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3668p0sh5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:01:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LA1c7W38207796
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 10:01:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D6EC4C04A;
        Thu, 21 Jan 2021 10:01:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 896304C040;
        Thu, 21 Jan 2021 10:01:37 +0000 (GMT)
Received: from [9.145.88.16] (unknown [9.145.88.16])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 10:01:37 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <5d048eb9-72e5-e713-5c1a-56a1c3d957c4@linux.ibm.com>
Date:   Thu, 21 Jan 2021 11:01:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=803
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 9:02 PM, Matthew Rosato wrote:
> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
> specific requirements in terms of alignment as well as the patterns in
> which the data is read/written. Allowing these to proceed through the
> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
> way that these requirements can't be guaranteed. In addition, ISM devices
> do not support the MIO codepaths that might be triggered on vfio I/O coming
> from userspace; we must be able to ensure that these devices use the
> non-MIO instructions.  To facilitate this, provide a new vfio region by
> which non-MIO instructions can be passed directly to the host kernel s390
> PCI layer, to be reliably issued as non-MIO instructions.
> 
> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
> and implements the ability to pass PCISTB and PCILG instructions over it,
> as these are what is required for ISM devices.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         |   8 ++
>  drivers/vfio/pci/vfio_pci_private.h |   6 ++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 158 ++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h           |   4 +
>  include/uapi/linux/vfio_zdev.h      |  33 ++++++++
>  5 files changed, 209 insertions(+)

Related to the discussion on the QEMU side, if we have a check
to make sure this is only used for ISM, then this patch should
make that clear in its wording and also in the paths
(drivers/vfio/pci/vfio_pci_ism.c instead of vfio_pci_zdev.c.)
This also has precedent with the region for IGD in
drivers/vfio/pci/vfio_pci_igd.c.
