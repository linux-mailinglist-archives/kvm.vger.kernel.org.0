Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DD655E6A4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347281AbiF1OCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 10:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiF1OCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 10:02:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A567369FB;
        Tue, 28 Jun 2022 07:02:44 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDilM0016406;
        Tue, 28 Jun 2022 14:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5/QMaliZipWecbQgYNAZovL+fmzTZDinlxHWslcC+dE=;
 b=blp9Kq+BwBf/teu6/ZuMozeByp2hkXTtZ4x80qjpPHH+V7unWG7lr3OZo6l7z5Kr9TNm
 F3tMOu8Xuu+993lDWbTuNoSxbv+f2I1+6fA2Im7cc5/0tAVeZRLkzrIs6iykr/ewHr8H
 FlNOGKn8Gly4InXAspaUfx5d62R3N8XhwzYVIgNcY2OwP79h1LQuy9JcsKFvJr5VmzAa
 nN68y1xQQmauz6Y9F2VrUuO7z9S7V2YgP3sZS+o+Ut3sGETnVX56K/b8UbrdInjh1CuM
 Hk5yu9Bz9NFwjT/wyuZ5SQsnjaIBiM7aZN2XZnJ5+FN9miYwaN6bCuluas8qHnTw91gq Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02swgprf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 14:02:39 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDk5xO021402;
        Tue, 28 Jun 2022 14:02:38 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02swgpq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 14:02:38 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDplhr013472;
        Tue, 28 Jun 2022 14:02:37 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3gwt08upq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 14:02:36 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SE2Xe520054336
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 14:02:33 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 99F7FA4062;
        Tue, 28 Jun 2022 14:02:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79CDBA4054;
        Tue, 28 Jun 2022 14:02:32 +0000 (GMT)
Received: from [9.171.60.225] (unknown [9.171.60.225])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 14:02:32 +0000 (GMT)
Message-ID: <66447089-921d-3665-963d-b9303b411f7f@linux.ibm.com>
Date:   Tue, 28 Jun 2022 16:02:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        pbonzini@redhat.com
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
 <f86e2e05-114a-cc9e-8f3a-96b36889063d@linux.ibm.com>
 <c98e7c10-272c-2bbb-6909-046d57d721d1@linux.ibm.com>
 <425d3030-94e2-efeb-60fd-08516443a06a@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <425d3030-94e2-efeb-60fd-08516443a06a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: imExGSBWA-3QoTOSX8w9x6m5dWp2eZ1V
X-Proofpoint-ORIG-GUID: 46GAodoAsTfTdwPcHQQxYfJKwqZuuSvK
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 suspectscore=0 clxscore=1015 mlxscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 28.06.22 um 15:40 schrieb Matthew Rosato:
> On 6/28/22 8:35 AM, Christian Borntraeger wrote:
>> Am 27.06.22 um 22:57 schrieb Matthew Rosato:
>>> On 6/6/22 4:33 PM, Matthew Rosato wrote:
>>>> Enable interpretive execution of zPCI instructions + adapter interruption
>>>> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
>>>> when the VFIO group is associated with the KVM guest, transmitting to
>>>> firmware a special token (GISA designation) to enable that specific guest
>>>> for interpretive execution on that zPCI device.  Load/store interpreation
>>>> enablement is then controlled by userspace (based upon whether or not a
>>>> SHM bit is placed in the virtual function handle).  Adapter Event
>>>> Notification interpretation is controlled from userspace via a new KVM
>>>> ioctl.
>>>>
>>>> By allowing intepretation of zPCI instructions and firmware delivery of
>>>> interrupts to guests, we can reduce the frequency of guest SIE exits for
>>>> zPCI.
>>>>
>>>>  From the perspective of guest configuration, you passthrough zPCI devices
>>>> in the same manner as before, with intepretation support being used by
>>>> default if available in kernel+qemu.
>>>>
>>>> Will follow up with a link the most recent QEMU series.
>>>>
>>>> Changelog v8->v9:
>>>> - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
>>>> - s/kzdev = 0/kzdev = NULL/ (Alex)
>>>> - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
>>>> - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
>>>> - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
>>>>    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
>>>> - remove notifier accidentally left in struct zpci_dev + associated
>>>>    include statment (Jason)
>>>> - Remove patch 'KVM: s390: introduce CPU feature for zPCI Interpretation'
>>>>    based on discussion in QEMU thread.
>>>>
>>>
>>> Ping -- I'm hoping this can make the next merge window, but there are still 2 patches left without any review tag (16 & 17).
>>
>> Yes, I will queue this (as is). Ideally you would rebase this on top of kvm/next but I can also do while applying.
>> Let me know if you want to respin with the Nits from Pierre.
> 
> Ah, sorry -- I assume you mean Paolo's kvm/next?  I tried now and see some conflicts with the ioctl patch.
> 
> Why don't I rebase on top of kvm/next along with these couple of changes from Pierre and send this as a v10 for you to queue.
> 
> While at it, there's one other issue to be aware of -- There will also be small merge conflicts with a patch that just hit vfio-next, "vfio: de-extern-ify function prototypes" - My series already avoids adding externs to new prototypes, but adjacent code changes will cause a conflict with patches 10 and 17.
> 
> Not sure what the best way to proceed there is.
> 
> https://lore.kernel.org/kvm/165471414407.203056.474032786990662279.stgit@omen/

I think Linus can sort out if the conflicts are trivial. As an alternative Alex could carry these patches, but then we have a merge conflict between him and KVM.
Alex/Paolo, shall I do a topic branch that you both can merge?
