Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE146E621C
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 14:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbjDRMaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 08:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjDRMaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 08:30:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35391B45F
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 05:29:48 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33ICIMg7014050;
        Tue, 18 Apr 2023 12:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QpZYidjndUqVd1Mii+cFllLm07y/WYPFtXd2CK3zaZw=;
 b=eCwfdec8W1I6BBFLDUtMMRIeGNlpnVPNJnYMkZd7JogmTgqQ3eiY3+D6FOMP2afrn8sN
 YIw9g5CeNrT4quamdhoW7/ml+VljH5CYtT6Fha0Cl+NrNoxEW8n/xFSTlqywtoI+104c
 ezfW4+fR+28NM+RWiT57KctoIHYHDqTjtAWYt4uUeib4uM0dW3LI0zGvHGE04r5EdUXM
 Tktiq4oCqT1+5o/VS8mWvqhxAiHk93Y0rY0yjulKSh/8nhVYRjE+qERY6y3d1hsEI+uy
 hkgFCDW8zsNFKBjw1CAv4X27wFvORRDPyACzBaxjynyl6/EKUvWSEEnYTSSag+o2cylC /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1psxgdu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:29:01 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33ICBeGh036397;
        Tue, 18 Apr 2023 12:29:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q1psxgdt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:29:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33HLaio1026665;
        Tue, 18 Apr 2023 12:28:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pykj6a11g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 12:28:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33ICSshw47579604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 12:28:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51D2D2004B;
        Tue, 18 Apr 2023 12:28:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D20FE20043;
        Tue, 18 Apr 2023 12:28:52 +0000 (GMT)
Received: from [9.171.38.31] (unknown [9.171.38.31])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Apr 2023 12:28:52 +0000 (GMT)
Message-ID: <de346db4-2ea2-a001-6758-bcba22b6c0c8@linux.ibm.com>
Date:   Tue, 18 Apr 2023 14:28:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v19 01/21] s390x/cpu topology: add s390 specifics to CPU
 topology
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230403162905.17703-1-pmorel@linux.ibm.com>
 <20230403162905.17703-2-pmorel@linux.ibm.com>
 <e96e60dade206cb970b55bfc9d2a77643bd14d98.camel@linux.ibm.com>
 <d7a0263f-4b27-387d-bf6c-fde71df3feb4@linux.ibm.com>
 <80fce082-b468-2c9b-b370-a9de349d0860@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <80fce082-b468-2c9b-b370-a9de349d0860@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6dBTfQeSMVsivFtR-SRrppMS9kEAT0AS
X-Proofpoint-ORIG-GUID: RuKdpQkDXOjULX6xgWFDWUfrrPvEfh5V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180100
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/18/23 12:15, Thomas Huth wrote:
> On 18/04/2023 12.01, Pierre Morel wrote:
>>
>> On 4/18/23 10:53, Nina Schoetterl-Glausch wrote:
>>> On Mon, 2023-04-03 at 18:28 +0200, Pierre Morel wrote:
>>>> S390 adds two new SMP levels, drawers and books to the CPU
>>>> topology.
>>>> The S390 CPU have specific topology features like dedication
>>>> and entitlement to give to the guest indications on the host
>>>> vCPUs scheduling and help the guest take the best decisions
>>>> on the scheduling of threads on the vCPUs.
>>>>
>>>> Let us provide the SMP properties with books and drawers levels
>>>> and S390 CPU with dedication and entitlement,
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>   MAINTAINERS                     |  5 ++++
>>>>   qapi/machine-common.json        | 22 ++++++++++++++
>>>>   qapi/machine-target.json        | 12 ++++++++
>>>>   qapi/machine.json               | 17 +++++++++--
>>>>   include/hw/boards.h             | 10 ++++++-
>>>>   include/hw/s390x/cpu-topology.h | 15 ++++++++++
>>> Is hw/s390x the right path for cpu-topology?
>>> I haven't understood the difference between hw/s390x and target/s390x
>>> but target/s390x feels more correct, I could be mistaken though.
>>
>> AFAIK target/s390 is for CPU emulation code while hw/s390 is for 
>> other emulation.
>>
>> So it depends how we classify the CPU topology, it is related to CPU 
>> but it is no emulation.
>
> Normally I'd say target/ is for everything what happens within a CPU 
> chip, and hw/ is for everything that happens outside of a CPU chip, 
> i.e. machine definitions and other devices.
> Now CPU topology is borderline - drawers and books are rather a 
> concept of the machine and not of the CPU, but things like dies and 
> threads rather happen within a CPU chip.
> So I don't mind too much either way, but I think it's certainly ok to 
> keep it in hw/s390x/ if you prefer that.
>
>  Thomas
>
Thanks for the clarification Thomas.

Pierre


