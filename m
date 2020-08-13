Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD8243707
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 11:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgHMJAm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 05:00:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7756 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgHMJAk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 05:00:40 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D8X4sf187654;
        Thu, 13 Aug 2020 05:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RNVxaGhJE62uYyK1T5cbH64KJh6t1reKdoD/1B05iHs=;
 b=OIXZj9FLA7fXm9rXKu+Wu03qld/AJtDoOsL02Ihi6rtiu+w/iyf42OElVlWTob4N3t+T
 WFw+a6J0wEENbxJ00i+w/KYR5uwcW4rIzLRtSlx4lW8XiPcqRZAG1MfSvQVclfBBFfrI
 zIfHVktbIPFbNjEt0k43JkWI+vGXq1Li3/jwzVbiDBpdgpbxo50p9orHHUWmqbXstO8R
 QMgs+czR1aAkkd8U8I5Sz7lN6djBHIs0H7H1unggzV5sRDO8cRmyqcG9hQrX+P5KKgT0
 oGDtE+O4SfW4r6D6dtnQhWoJ0FSLTSy/TdYlHTxZ1Q5F295vhcJZdTVqxtNi3eT1xCg3 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32vcsyp7uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 05:00:32 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07D8XEdF188447;
        Thu, 13 Aug 2020 05:00:32 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32vcsyp7s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 05:00:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07D8uPhb012111;
        Thu, 13 Aug 2020 09:00:29 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 32skp83a2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:00:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07D90QHx61669846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 09:00:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81ADD4C059;
        Thu, 13 Aug 2020 09:00:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA2264C076;
        Thu, 13 Aug 2020 09:00:24 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.93.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 09:00:24 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     "Oliver O'Halloran" <oohall@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, pmorel@linux.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        linux-s390@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
 <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Message-ID: <2a862199-16c8-2141-d27f-79761c1b1b25@linux.ibm.com>
Date:   Thu, 13 Aug 2020 11:00:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOSf1CFjaVoeTyk=cLmWhBB6YQrHQkcD8Aj=ZYrB4kYc-rqLiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_06:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130060
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 3:55 AM, Oliver O'Halloran wrote:
> On Thu, Aug 13, 2020 at 5:21 AM Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>> s390x has the notion of providing VFs to the kernel in a manner
>> where the associated PF is inaccessible other than via firmware.
>> These are not treated as typical VFs and access to them is emulated
>> by underlying firmware which can still access the PF.  After
>> abafbc55 however these detached VFs were no longer able to work
>> with vfio-pci as the firmware does not provide emulation of the
>> PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
>> these detached VFs so that vfio-pci can allow memory access to
>> them again.
> 
> Hmm, cool. I think we have a similar feature on pseries so that's
> probably broken too.
> 
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>  arch/s390/pci/pci.c                |  8 ++++++++
>>  drivers/vfio/pci/vfio_pci_config.c | 11 +++++++----
>>  include/linux/pci.h                |  1 +
>>  3 files changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
>> index 3902c9f..04ac76d 100644
>> --- a/arch/s390/pci/pci.c
>> +++ b/arch/s390/pci/pci.c
>> @@ -581,6 +581,14 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
>>  {
>>         struct zpci_dev *zdev = to_zpci(pdev);
>>
>> +       /*
>> +        * If we have a VF on a non-multifunction bus, it must be a VF that is
>> +        * detached from its parent PF.  We rely on firmware emulation to
>> +        * provide underlying PF details.
>> +        */
>> +       if (zdev->vfn && !zdev->zbus->multifunction)
>> +               pdev->detached_vf = 1;
> 
> The enable hook seems like it's a bit too late for this sort of
> screwing around with the pci_dev. Anything in the setup path that
> looks at ->detached_vf would see it cleared while anything that looks
> after the device is enabled will see it set. Can this go into
> pcibios_add_device() or a fixup instead?
> 

This particular check could go into pcibios_add_device() yes.
We're also currently working on a slight rework of how
we establish the VF to parent PF linking including the sysfs
part of that. The latter sadly can only go after the sysfs
for the virtfn has been created and that only happens
after all fixups. We would like to do both together because
the latter sets pdev->is_virtfn which I think is closely related.

I was thinking of starting another discussion
about adding a hook that is executed just after the sysfs entries
for the PCI device are created but haven't yet.
That said pcibios_enable_device() is called before drivers
like vfio-pci are enabled and so as long as all uses of pdev->detached_vf
are in drivers it should be early enough. AFAIK almost everything
dealing with VFs before that is already skipped with pdev->no_vf_scan
though.
