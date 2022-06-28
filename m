Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C25955E857
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346644AbiF1NkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346388AbiF1NkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:40:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665C227171;
        Tue, 28 Jun 2022 06:40:17 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDB1Sn016705;
        Tue, 28 Jun 2022 13:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=FBgDUWz9zu+SVcHFsLwmqLmheCUV+tCagUD444+K/iM=;
 b=nP9nGTSpJTTxLCM/e7EHiIx/Ndo31kBdhG01AiT+nVxGGOIJd+VYZVpA7fXPpKTNr8JK
 /l/54zwUbAFYlGGx64R6SFaLrZnHYD5PIseGAUQykf8TjO8d0h7b+rWGKVzSRHNHT9wJ
 Sxx9ZG1Kwhg4BMHR/dLp1+6xhPFq7sZHJnpo4ZWDe0dGXiJsQ6Fy/UonAOXQ0aXSEq8X
 dF0D8+rbJG3YU66L9xcBB9mTfMcGWNA/IdbhiFAsG1ozb8eg7vTcGuo1FzK/8gdGuyNN
 BkroJEpsq1eUs4k7bFbEk9xRt7UNEms7wnhXIi6IaTh/IY/jjnpFV5gh/7QA9quWN9h6 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjaa5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:40:15 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDC7x4021996;
        Tue, 28 Jun 2022 13:40:13 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h01tjaa0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:40:13 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDb8C7025960;
        Tue, 28 Jun 2022 13:40:11 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3gwt09857t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:40:11 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDeAWv32834002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:40:10 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C2B9AC05E;
        Tue, 28 Jun 2022 13:40:10 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE79AAC05B;
        Tue, 28 Jun 2022 13:40:02 +0000 (GMT)
Received: from [9.163.8.193] (unknown [9.163.8.193])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:40:02 +0000 (GMT)
Message-ID: <425d3030-94e2-efeb-60fd-08516443a06a@linux.ibm.com>
Date:   Tue, 28 Jun 2022 09:40:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
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
 <c98e7c10-272c-2bbb-6909-046d57d721d1@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <c98e7c10-272c-2bbb-6909-046d57d721d1@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jBnlD9HRmTZN25V0BQZsmMSBZ2YhhOAb
X-Proofpoint-ORIG-GUID: 2Jd4WNhrYwTB9D6Hdj11r_eT12oohFQV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/22 8:35 AM, Christian Borntraeger wrote:
> Am 27.06.22 um 22:57 schrieb Matthew Rosato:
>> On 6/6/22 4:33 PM, Matthew Rosato wrote:
>>> Enable interpretive execution of zPCI instructions + adapter 
>>> interruption
>>> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
>>> when the VFIO group is associated with the KVM guest, transmitting to
>>> firmware a special token (GISA designation) to enable that specific 
>>> guest
>>> for interpretive execution on that zPCI device.  Load/store 
>>> interpreation
>>> enablement is then controlled by userspace (based upon whether or not a
>>> SHM bit is placed in the virtual function handle).  Adapter Event
>>> Notification interpretation is controlled from userspace via a new KVM
>>> ioctl.
>>>
>>> By allowing intepretation of zPCI instructions and firmware delivery of
>>> interrupts to guests, we can reduce the frequency of guest SIE exits for
>>> zPCI.
>>>
>>>  From the perspective of guest configuration, you passthrough zPCI 
>>> devices
>>> in the same manner as before, with intepretation support being used by
>>> default if available in kernel+qemu.
>>>
>>> Will follow up with a link the most recent QEMU series.
>>>
>>> Changelog v8->v9:
>>> - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
>>> - s/kzdev = 0/kzdev = NULL/ (Alex)
>>> - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
>>> - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
>>> - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
>>>    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
>>> - remove notifier accidentally left in struct zpci_dev + associated
>>>    include statment (Jason)
>>> - Remove patch 'KVM: s390: introduce CPU feature for zPCI 
>>> Interpretation'
>>>    based on discussion in QEMU thread.
>>>
>>
>> Ping -- I'm hoping this can make the next merge window, but there are 
>> still 2 patches left without any review tag (16 & 17).
> 
> Yes, I will queue this (as is). Ideally you would rebase this on top of 
> kvm/next but I can also do while applying.
> Let me know if you want to respin with the Nits from Pierre.

Ah, sorry -- I assume you mean Paolo's kvm/next?  I tried now and see 
some conflicts with the ioctl patch.

Why don't I rebase on top of kvm/next along with these couple of changes 
from Pierre and send this as a v10 for you to queue.

While at it, there's one other issue to be aware of -- There will also 
be small merge conflicts with a patch that just hit vfio-next, "vfio: 
de-extern-ify function prototypes" - My series already avoids adding 
externs to new prototypes, but adjacent code changes will cause a 
conflict with patches 10 and 17.

Not sure what the best way to proceed there is.

https://lore.kernel.org/kvm/165471414407.203056.474032786990662279.stgit@omen/
