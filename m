Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A6355DA67
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345478AbiF1Mfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbiF1Mff (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 08:35:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570A72ED77;
        Tue, 28 Jun 2022 05:35:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SCHCh0006869;
        Tue, 28 Jun 2022 12:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VzTRDib4zHd2FCU5EB+yWfonZTP7xYq8c8GPvJz6Hrs=;
 b=HPp4Ym3KfCxqGjisBYbAiWWX1hq7ezYIHhUU9QOYS28uxvSJ7OwP6jeZukK1z36RWi6F
 QP6RBcPZ/gJWQnicU9qZiGQ9TMxfsbAkidz/LmthAf26akmiUj+Gz0qVZgfgmAdBiz1q
 75I/vQm9RucbtkFVoX7x9JnJiG9HCE5FoIMbWVvxb/pEo0UdhkJPFx5BxZv3dpWz9SZj
 tYce6DyITtObQLdBdJmAQHxDRe53nMGNnAxFYU5HKjZ947C+MqzFJGishx5wAHgi1u27
 s/gMu46HUoYJ5WXBqVNTyo2700rf7jJ3AQRDA6fqt2AtMOQqZhUXpDGV3ZA7j4dGHBsU lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01h1rj8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 12:35:31 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SCJRgS017268;
        Tue, 28 Jun 2022 12:35:30 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01h1rj82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 12:35:30 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SCKc8u001772;
        Tue, 28 Jun 2022 12:35:28 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3gwt08vu62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 12:35:28 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SCZPUm23986648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 12:35:25 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BFFAA405B;
        Tue, 28 Jun 2022 12:35:25 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5794BA4054;
        Tue, 28 Jun 2022 12:35:24 +0000 (GMT)
Received: from [9.171.60.225] (unknown [9.171.60.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 12:35:24 +0000 (GMT)
Message-ID: <c98e7c10-272c-2bbb-6909-046d57d721d1@linux.ibm.com>
Date:   Tue, 28 Jun 2022 14:35:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <f86e2e05-114a-cc9e-8f3a-96b36889063d@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <f86e2e05-114a-cc9e-8f3a-96b36889063d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7kXy1VyFvROoymAGsQ27TyveRw3QZZwH
X-Proofpoint-ORIG-GUID: pBNTNyMgnNoCtr5oFZikyJQjgjvEXW8u
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 impostorscore=0 clxscore=1011 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 27.06.22 um 22:57 schrieb Matthew Rosato:
> On 6/6/22 4:33 PM, Matthew Rosato wrote:
>> Enable interpretive execution of zPCI instructions + adapter interruption
>> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
>> when the VFIO group is associated with the KVM guest, transmitting to
>> firmware a special token (GISA designation) to enable that specific guest
>> for interpretive execution on that zPCI device.  Load/store interpreation
>> enablement is then controlled by userspace (based upon whether or not a
>> SHM bit is placed in the virtual function handle).  Adapter Event
>> Notification interpretation is controlled from userspace via a new KVM
>> ioctl.
>>
>> By allowing intepretation of zPCI instructions and firmware delivery of
>> interrupts to guests, we can reduce the frequency of guest SIE exits for
>> zPCI.
>>
>>  From the perspective of guest configuration, you passthrough zPCI devices
>> in the same manner as before, with intepretation support being used by
>> default if available in kernel+qemu.
>>
>> Will follow up with a link the most recent QEMU series.
>>
>> Changelog v8->v9:
>> - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
>> - s/kzdev = 0/kzdev = NULL/ (Alex)
>> - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
>> - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
>> - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
>>    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
>> - remove notifier accidentally left in struct zpci_dev + associated
>>    include statment (Jason)
>> - Remove patch 'KVM: s390: introduce CPU feature for zPCI Interpretation'
>>    based on discussion in QEMU thread.
>>
> 
> Ping -- I'm hoping this can make the next merge window, but there are still 2 patches left without any review tag (16 & 17).

Yes, I will queue this (as is). Ideally you would rebase this on top of kvm/next but I can also do while applying.
Let me know if you want to respin with the Nits from Pierre.
