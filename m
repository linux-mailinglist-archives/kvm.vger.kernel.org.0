Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C826F512D
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 09:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjECHVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 03:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjECHVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 03:21:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F92D10E7
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 00:21:41 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3437AYck008498;
        Wed, 3 May 2023 07:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KicJbVmbJ8ewX6kRY7wabsR8Esn8XErVu5CUOm+ghMc=;
 b=nB+LbqPBxFAOtSyl/gVXR0zcHsoWXeqxAy/wjsxPG82IPDOOmL9NJT9IGL+65ucTuDqN
 dM/UwGgb07jfTDzRffuaamjrXP9vr23yX0iIKEeLBzscP7cTQWcNVlYU+vcYFkXMr8DS
 VJM613FQ2zIOWal2ekaBY0KGnJD9dJVyatssiSrv7nPw9kH+RIA9chK5Z8yfkyGu/GRI
 aWTzaxpaqqzHPr1jC+B5+irhMB6qmyDrat/0ZmXsnRyZFWdNygOAKIO8CRMPndRBeLnD
 snsnLVZxEEH+NRd3E8B4nqSGzeQlsGVNti5CNkHASBc24izDaqkNRtXUtUSOqPMrqQca sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbhjbaba2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:21:28 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3437KOpK025105;
        Wed, 3 May 2023 07:21:27 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbhjbab9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:21:27 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3434TIoq014099;
        Wed, 3 May 2023 07:21:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6speg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 07:21:24 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3437LJY860555632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 07:21:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E70B20040;
        Wed,  3 May 2023 07:21:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E694220043;
        Wed,  3 May 2023 07:21:18 +0000 (GMT)
Received: from [9.152.222.242] (unknown [9.152.222.242])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed,  3 May 2023 07:21:18 +0000 (GMT)
Message-ID: <76ae6b1c-9195-b63a-ba90-6a0ce3718990@linux.ibm.com>
Date:   Wed, 3 May 2023 09:21:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v20 02/21] s390x/cpu topology: add topology entries on CPU
 hotplug
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
 <20230425161456.21031-3-pmorel@linux.ibm.com>
 <7940b2d6-8b72-18e8-83a6-de3f122e416e@kaod.org>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <7940b2d6-8b72-18e8-83a6-de3f122e416e@kaod.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PyWMHuKIsbQvyunKGywJYTFsdksYiFSY
X-Proofpoint-GUID: dktC1ih92ocnmchZYJs5S00A5hjNmbYB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_04,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=929 suspectscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030057
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/2/23 14:30, Cédric Le Goater wrote:
> On 4/25/23 18:14, Pierre Morel wrote:
>> The topology information are attributes of the CPU and are
>> specified during the CPU device creation.
>>
>>
[...]
>> +
>> +/**
>> + * s390_topology_init:
>> + * @ms: the machine state where the machine topology is defined
>> + *
>> + * Keep track of the machine topology.
>> + *
>> + * Allocate an array to keep the count of cores per socket.
>> + * The index of the array starts at socket 0 from book 0 and
>> + * drawer 0 up to the maximum allowed by the machine topology.
>> + */
>> +static void s390_topology_init(MachineState *ms)
>> +{
>> +    CpuTopology *smp = &ms->smp;
>> +
>> +    s390_topology.smp = smp;
>
> I am not sure the 'smp' shortcut is necessary. 'MachineState *ms' is
> always available where 'CpuTopology *smp' is used. so it could be
> computed from a local variable AFAICT. It would reduce the risk of
> 'smp' being NULL in some (future) code path.
>
> Thanks,
>
> C.


So I will use directly current_machine->smp

You are right it is more homogeneous, there is no need to keep a pointer 
here.

Thanks

Pierre


[...]

