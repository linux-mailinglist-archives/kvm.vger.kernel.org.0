Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AD1762FC4
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 10:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjGZIZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 04:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjGZIYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 04:24:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFCD769B
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 01:11:28 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q896bG010385;
        Wed, 26 Jul 2023 08:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dvGHvVbYkHPVvTXABzFmGUDgWDF80ODMOIc5XYLzDtg=;
 b=rjuwfFz7P/cTBd3npFIS8AubZ9Nqs8qd0DJ1KOVBKbqV2G4EOxOpgZHf58FZKVWLaFfH
 3fb7819pHJjvGdec7caV+HCahf2Xz50ZGISojrLnAn8AbqZU+/lzxldjxxiT615nJL6M
 NUtu1TS+/ClkiqXOYYPv9clhDndSkVVflaLIv5mmGAZmfqCI57prskVXL3ZxAXIF9XIP
 l4DcIeD1wKfQv8/QaPnzPmRh0uCW3v9RWCEyvRxuUjvFw80IwYYcH42wwitWgq/1I4QM
 QlDtmPIcW1KQ6raEfPLUc6PitQCfkkS3ORqMAdEqg7R1Tw/tXBShj8KyargB/W0ctAdQ rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2xvvhbyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 08:11:20 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36Q89qPb015172;
        Wed, 26 Jul 2023 08:11:19 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s2xvvhbxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 08:11:19 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36Q7hkbv014374;
        Wed, 26 Jul 2023 08:11:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0sty3fjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jul 2023 08:11:18 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36Q8BEZG46137620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 08:11:14 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2723420043;
        Wed, 26 Jul 2023 08:11:14 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A66820040;
        Wed, 26 Jul 2023 08:11:13 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 26 Jul 2023 08:11:12 +0000 (GMT)
Message-ID: <cba8a01d-4b03-df1c-78ad-258a45452fce@linux.ibm.com>
Date:   Wed, 26 Jul 2023 10:11:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 03/20] target/s390x/cpu topology: handle STSI(15) and
 build the SYSIB
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-4-pmorel@linux.ibm.com>
 <667c700b3739f1dada06bcf70b91952d9dd5352b.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <667c700b3739f1dada06bcf70b91952d9dd5352b.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: j1botvLr16aIKRWsK_2xO9QH1MUyMLyY
X-Proofpoint-GUID: nDyPh0aVarllnmTOKnpKeXRZgCf5b0Vv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_01,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307260070
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/25/23 17:41, Nina Schoetterl-Glausch wrote:
> On Fri, 2023-06-30 at 11:17 +0200, Pierre Morel wrote:
>> On interception of STSI(15.1.x) the System Information Block
>> (SYSIB) is built from the list of pre-ordered topology entries.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   MAINTAINERS                      |   1 +
>>   qapi/machine-target.json         |  14 ++
>>   include/hw/s390x/cpu-topology.h  |  25 +++
>>   include/hw/s390x/sclp.h          |   1 +
>>   target/s390x/cpu.h               |  76 ++++++++
>>   hw/s390x/cpu-topology.c          |   4 +-
>>   target/s390x/kvm/kvm.c           |   5 +-
>>   target/s390x/kvm/stsi-topology.c | 310 +++++++++++++++++++++++++++++++
>>   target/s390x/kvm/meson.build     |   3 +-
>>   9 files changed, 436 insertions(+), 3 deletions(-)
>>   create mode 100644 target/s390x/kvm/stsi-topology.c
> [...]
>
>>   typedef struct S390Topology {
>>       uint8_t *cores_per_socket;
>> +    bool polarization;
> You don't use this as a bool and since it's no longer called
> vertical_polarization, it's not longer entirely clear what the value
> means so I think this should be a CpuS390Polarization.
> That also makes the assignment in patch 12 clearer since it assigns the
> same type.
>
> [...]


right, I make the change

Thanks

Pierre


