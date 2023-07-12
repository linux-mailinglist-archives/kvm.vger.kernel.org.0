Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6E4750D7C
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjGLQG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjGLQG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:06:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841141999
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:06:26 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CFwSmG027186;
        Wed, 12 Jul 2023 16:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Gp2YqfsYUz4wUcxJP8bUg17GBeBKTkwwQfgJONjVPCg=;
 b=QaCQlm5n+XQ81tN/Mqor1CIvftHqhoNl+IIrNbCPeLkrdzoejKrJCNPd9dmGSzD23iP1
 jNYXrLcVHhkVlYjR1HdTJVpLDxiwtNd0HfMIB0T3VDEpajCCenddAxyCh5mwh+uVJ2AX
 PDjCW26A6Qx9HbegrJEpX+Vb3X0sDuByYAE3+eXhQ/zGOKEjnpDaSZhzfxgXIjyyDQZN
 EKuhxWAurSLjnMmncz4jDVQ4mC3OC5nDNtd14el+bQDxj/4rGNHAxQZLwoeykwbXiEg5
 8S8VoU0Iz8+EMWDh3xbh2CsTwdpyNaC7ZzkX6FN06duhxW/tj5Bo5/FSwHFo5ODSc6Pe iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsy4h0kmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:06:09 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CFnuOF030937;
        Wed, 12 Jul 2023 16:06:04 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rsy4h0k94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:06:04 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36CBmn1u027667;
        Wed, 12 Jul 2023 16:06:00 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye51yvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 16:06:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CG5tS37799370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 16:05:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 517AF20043;
        Wed, 12 Jul 2023 16:05:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C584720040;
        Wed, 12 Jul 2023 16:05:54 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 12 Jul 2023 16:05:54 +0000 (GMT)
Message-ID: <139d1b79-e6d2-a6cc-6dcd-8e500cee1f1b@linux.ibm.com>
Date:   Wed, 12 Jul 2023 18:05:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 11/20] qapi/s390x/cpu topology:
 CPU_POLARIZATION_CHANGE qapi event
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-12-pmorel@linux.ibm.com>
 <579d40ea-50e4-4d84-699b-25268749b138@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <579d40ea-50e4-4d84-699b-25268749b138@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Xg94q_D67M0Hu8twEH7UunvK8lSqgqox
X-Proofpoint-GUID: SKVYBsm4yHM71CVa7ZbeHtp9VO8Se5C-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_11,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=972
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307120144
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/4/23 15:04, Thomas Huth wrote:
> On 30/06/2023 11.17, Pierre Morel wrote:
>> When the guest asks to change the polarization this change
>> is forwarded to the upper layer using QAPI.
>> The upper layer is supposed to take according decisions concerning
>> CPU provisioning.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   qapi/machine-target.json | 33 +++++++++++++++++++++++++++++++++
>>   hw/s390x/cpu-topology.c  |  2 ++
>>   2 files changed, 35 insertions(+)
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
>
Thanks,

Pierre

