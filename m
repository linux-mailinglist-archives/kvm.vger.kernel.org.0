Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB1264B67C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 14:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiLMNmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 08:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiLMNmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 08:42:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59559B9D
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 05:42:04 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDDj6w024498;
        Tue, 13 Dec 2022 13:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F/KEmOXweGvq4YMRdFvjIqJZ9+DA1QClAeWZYE0spdk=;
 b=HmpBGH66pS8CXlG3BeHID8kvRGd+dEHuxg6mVNPMUUta9/+YjexyCsdKbrVw6suziOQT
 1YKNk1d6Ep72MDIax00SMGNYwAcF6gWhbUZvnJ2L+CaKltCXFgcoDcTpQhBL9Fy4mc2j
 V9N5qcPZMMY2zfUUBcS83FdXob6zn8HG0iWswOU0Ch42zf/kJzJ9FnlF/xVxw1vGP7hO
 ZXcHbeHP1ksTG8gkucKu7UYPqzUoBvYgxJehajRObNm3iMXgy3fJBiDIWmzNKMa0cQ5O
 Af9LsN6KpaCmWXBF+dGeFXj4cjhPBakM7l4clSEsd8x8+x/JsW7z7EW0pJ5cyR8VitH9 aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3met3ernqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:41:56 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDDEKdI025814;
        Tue, 13 Dec 2022 13:41:56 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3met3ernpy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:41:56 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD7QD4n024666;
        Tue, 13 Dec 2022 13:41:54 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mchr5u25r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 13:41:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDDfo1o45154804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 13:41:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6D1020043;
        Tue, 13 Dec 2022 13:41:50 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67E8620040;
        Tue, 13 Dec 2022 13:41:49 +0000 (GMT)
Received: from [9.171.21.177] (unknown [9.171.21.177])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 13:41:49 +0000 (GMT)
Message-ID: <b36eef2e-92ed-a0ea-0728-4a5ea5bf25d9@de.ibm.com>
Date:   Tue, 13 Dec 2022 14:41:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v13 0/7] s390x: CPU Topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20221208094432.9732-1-pmorel@linux.ibm.com>
 <8c0777d2-7b70-51ce-e64a-6aff5bdea8ae@redhat.com>
 <60f006f4-d29e-320a-d656-600b2fd4a11a@linux.ibm.com>
 <864cc127-2dbd-3792-8851-937ef4689503@redhat.com>
 <90514038-f10c-33e7-3600-e3131138a44d@linux.ibm.com>
 <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <73238c6c-a9dc-9d18-8ffb-92c8a41922d3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VsstP4T-x6V3Drk9ZvrQAcmXB8Hvkt7L
X-Proofpoint-ORIG-GUID: XEIWStx2gG2c01cu02BqiUxoOxOCyuu5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130120
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12.12.22 um 11:17 schrieb Thomas Huth:
> On 12/12/2022 11.10, Pierre Morel wrote:
>>
>>
>> On 12/12/22 10:07, Thomas Huth wrote:
>>> On 12/12/2022 09.51, Pierre Morel wrote:
>>>>
>>>>
>>>> On 12/9/22 14:32, Thomas Huth wrote:
>>>>> On 08/12/2022 10.44, Pierre Morel wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Implementation discussions
>>>>>> ==========================
>>>>>>
>>>>>> CPU models
>>>>>> ----------
>>>>>>
>>>>>> Since the S390_FEAT_CONFIGURATION_TOPOLOGY is already in the CPU model
>>>>>> for old QEMU we could not activate it as usual from KVM but needed
>>>>>> a KVM capability: KVM_CAP_S390_CPU_TOPOLOGY.
>>>>>> Checking and enabling this capability enables
>>>>>> S390_FEAT_CONFIGURATION_TOPOLOGY.
>>>>>>
>>>>>> Migration
>>>>>> ---------
>>>>>>
>>>>>> Once the S390_FEAT_CONFIGURATION_TOPOLOGY is enabled in the source
>>>>>> host the STFL(11) is provided to the guest.
>>>>>> Since the feature is already in the CPU model of older QEMU,
>>>>>> a migration from a new QEMU enabling the topology to an old QEMU
>>>>>> will keep STFL(11) enabled making the guest get an exception for
>>>>>> illegal operation as soon as it uses the PTF instruction.
>>>>>
>>>>> I now thought that it is not possible to enable "ctop" on older QEMUs since the don't enable the KVM capability? ... or is it still somehow possible? What did I miss?
>>>>>
>>>>>   Thomas
>>>>
>>>> Enabling ctop with ctop=on on old QEMU is not possible, this is right.
>>>> But, if STFL(11) is enable in the source KVM by a new QEMU, I can see that even with -ctop=off the STFL(11) is migrated to the destination.

This does not make sense. the cpu model and stfle values are not migrated. This is re-created during startup depending on the command line parameters of -cpu.
Thats why source and host have the same command lines for -cpu. And STFLE.11 must not be set on the SOURCE of ctop is off.


>>>
>>> Is this with the "host" CPU model or another one? And did you explicitly specify "ctop=off" at the command line, or are you just using the default setting by not specifying it?
>>
>> With explicit cpumodel and using ctop=off like in
>>
>> sudo /usr/local/bin/qemu-system-s390x_master \
>>       -m 512M \
>>       -enable-kvm -smp 4,sockets=4,cores=2,maxcpus=8 \
>>       -cpu z14,ctop=off \
>>       -machine s390-ccw-virtio-7.2,accel=kvm \
>>       ...
> 
> Ok ... that sounds like a bug somewhere in your patches or in the kernel code ... the guest should never see STFL bit 11 if ctop=off, should it?

Correct. If ctop=off then QEMU should disable STFLE.11 for the CPU model.
