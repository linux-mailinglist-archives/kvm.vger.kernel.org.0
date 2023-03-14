Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0278F6B9AB6
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 17:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjCNQJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 12:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCNQJf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 12:09:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6453B3F6
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 09:09:27 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EFH40l025071;
        Tue, 14 Mar 2023 16:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YOiWtaNzms3LN/vTqd3NR543A+ISPYIWok1v0FtjtSo=;
 b=EgkOD+Jx4o1zNXT9EJ8iiJdAZNdZ5LgxQ9zuE00lxp65Fn0/kHu3L0E5fNNckCsjh6iM
 RTjmHnB1FTCck15Wq3zmwAdZbnod4KcaZ/nlYGFPDoFxfoqrxM0+jiUgSPBHLwNQRP8a
 cJHhUQGKLuPbnM9nolHFSRGyCBBD3fnsKCa7JoXexXY++fEv5spG0DKe/zc93LFJJ1Yd
 TBRnZf83BE8/HYJJIvw5dKY0U+sWrcGJPRkOySW7IWzU39QeSfDO6tAIQMXqqxiBItYD
 oL3VMYkMmNOqaTuM6qv0+vpcSUmFgwrdCmYmL+rMjjsPbTkJ7aWgXQx+OkwP97qx0Ouz nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pau6mtc8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 16:09:12 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32EFH4gH025051;
        Tue, 14 Mar 2023 16:09:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pau6mtc7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 16:09:11 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32E7mhck018985;
        Tue, 14 Mar 2023 16:09:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3p8h96m0nd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Mar 2023 16:09:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32EG957O44171602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 16:09:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C12020040;
        Tue, 14 Mar 2023 16:09:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55D822004D;
        Tue, 14 Mar 2023 16:09:04 +0000 (GMT)
Received: from [9.171.84.250] (unknown [9.171.84.250])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 14 Mar 2023 16:09:04 +0000 (GMT)
Message-ID: <8f153115-f12c-8434-79bd-1623555b5875@linux.ibm.com>
Date:   Tue, 14 Mar 2023 17:09:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v17 06/12] s390x/cpu topology: interception of PTF
 instruction
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230309121511.139152-1-pmorel@linux.ibm.com>
 <20230309121511.139152-7-pmorel@linux.ibm.com>
In-Reply-To: <20230309121511.139152-7-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 974_Xllzw97pycuPhtllFE7TKvIrFOv5
X-Proofpoint-GUID: GnYisdVTAyPOdkoOfRXS6u6UXOXtZRqb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_09,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303140134
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am currently developing tests under avocado to help debugging.

And... it helps.

There is a bug here in s390_topology_set_cpus_entitlement for dedicated 
CPUs.


On 3/9/23 13:15, Pierre Morel wrote:
[...]
> --- a/hw/s390x/cpu-topology.c
> +++ b/hw/s390x/cpu-topology.c
> @@ -87,6 +87,84 @@ static void s390_topology_init(MachineState *ms)
>       QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
>   }
>   
> +/**
> + * s390_topology_set_cpus_entitlement:
> + * @polarization: polarization requested by the caller
> + *
> + * On hotplug or when changing CPU attributes the shadow_entitlement
> + * is set to hold the entitlement used on a vertical polarization.
> + * When polarization is horizontal, the entitlement is horizontal too.
> + */
> +static void s390_topology_set_cpus_entitlement(int polarization)
> +{
> +    CPUState *cs;
> +
> +    CPU_FOREACH(cs) {
> +        CPUS390XState *env = &S390_CPU(cs)->env;
> +
> +        if (polarization == S390_CPU_POLARIZATION_HORIZONTAL) {
> +            env->entitlement = S390_CPU_ENTITLEMENT_HORIZONTAL;
> +        } else  {
> +            env->entitlement = env->shadow_entitlement;
> +        }
> +    }
> +}

This should be something like:

static void s390_topology_set_cpus_entitlement(void)
{
     CPUState *cs;

     CPU_FOREACH(cs) {
         CPUS390XState *env = &S390_CPU(cs)->env;

         if (s390_topology.polarization == 
S390_CPU_POLARIZATION_HORIZONTAL) {
             env->entitlement = S390_CPU_ENTITLEMENT_HORIZONTAL;
         } else if (env->entitlement == S390_CPU_ENTITLEMENT_HORIZONTAL) {
             if (env->dedicated) {
                 env->entitlement = S390_CPU_ENTITLEMENT_HIGH;
             } else {
                 env->entitlement = env->shadow_entitlement;
             }
         }
     }
}

Sorry.

I provide a new series including the avocado tests.

regards,

Pierre

