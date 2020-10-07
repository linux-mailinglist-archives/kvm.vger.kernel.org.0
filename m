Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6933286825
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgJGTSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 15:18:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46702 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726111AbgJGTSa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 15:18:30 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 097JCIM8077366;
        Wed, 7 Oct 2020 15:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JJ/LXoRz0pu4Rw1PUxwfzjwrdgbQmhPd42lBF4MfwIk=;
 b=SR2luMIp+4HlhjlQ6SXsXo1M6FMbaQ9nbQUBuLx3RKPXqYlwB7phHnTHGs/Zyx9A8qOj
 bmihEM3KYtO/MqSbCpH85huVLsA/gxMLqVg4RyG2Y2tMID6sKrBye89KzmhaFCl9LLAz
 7QrvZu9RwsUaW6dIx+FgR7A0ONPJrYOw8V0IVdmMReXJwO5SZzR0GN7E+BB28SC1C+Ro
 KmEXBpnBOUfEd6CgODTX/pPMF15ApBUAAKGa8aXKolw+dI295CAQaETwdd8GM4/iu3q3
 NAAR6voiZc9UEDurEnOZpTxPQp+5B/EnooYHSee8iuMnhgn0ng0YEau3MH3Zg8VFIAu9 Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341kmd84tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:18:29 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 097JFRa6089753;
        Wed, 7 Oct 2020 15:18:29 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 341kmd84t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 15:18:28 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 097JHd5M020834;
        Wed, 7 Oct 2020 19:18:28 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 33xgx9sr7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Oct 2020 19:18:28 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 097JIQwe54329734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Oct 2020 19:18:26 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C9A6112061;
        Wed,  7 Oct 2020 19:18:26 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 936F0112062;
        Wed,  7 Oct 2020 19:18:24 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.60.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  7 Oct 2020 19:18:24 +0000 (GMT)
Subject: Re: [PATCH v3 0/5] Pass zPCI hardware information via VFIO
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <7bff9eac-2704-438a-89e8-f2f4cca60757@linux.ibm.com>
Date:   Wed, 7 Oct 2020 15:18:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1602096984-13703-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010070118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/20 2:56 PM, Matthew Rosato wrote:
> This patchset provides a means by which hardware information about the
> underlying PCI device can be passed up to userspace (ie, QEMU) so that
> this hardware information can be used rather than previously hard-coded
> assumptions. The VFIO_DEVICE_GET_INFO ioctl is extended to allow capability
> chains and zPCI devices provide the hardware information via capabilities.
> 
> A form of these patches saw some rounds last year but has been back-
> tabled for a while.  The original work for this feature was done by Pierre
> Morel. I'd like to refresh the discussion on this and get this finished up
> so that we can move forward with better-supporting additional types of
> PCI-attached devices.
> 
> This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry.
> 
> Changes since v2:
> - Added ACKs (thanks!)
> - Patch 3+4: Re-write to use VFIO_DEVICE_GET_INFO capabilities rather than
>    a vfio device region.

Link to latest QEMU patch set:
https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg01948.html

> 
> Matthew Rosato (5):
>    s390/pci: stash version in the zpci_dev
>    s390/pci: track whether util_str is valid in the zpci_dev
>    vfio: Introduce capability definitions for VFIO_DEVICE_GET_INFO
>    vfio-pci/zdev: Add zPCI capabilities to VFIO_DEVICE_GET_INFO
>    MAINTAINERS: Add entry for s390 vfio-pci
> 
>   MAINTAINERS                         |   8 ++
>   arch/s390/include/asm/pci.h         |   4 +-
>   arch/s390/pci/pci_clp.c             |   2 +
>   drivers/vfio/pci/Kconfig            |  13 ++++
>   drivers/vfio/pci/Makefile           |   1 +
>   drivers/vfio/pci/vfio_pci.c         |  37 ++++++++++
>   drivers/vfio/pci/vfio_pci_private.h |  12 +++
>   drivers/vfio/pci/vfio_pci_zdev.c    | 143 ++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/vfio.h           |  11 +++
>   include/uapi/linux/vfio_zdev.h      |  78 ++++++++++++++++++++
>   10 files changed, 308 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>   create mode 100644 include/uapi/linux/vfio_zdev.h
> 

