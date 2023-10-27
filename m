Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B247D9EB4
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 19:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbjJ0RQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 13:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbjJ0RQk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 13:16:40 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FCA728C;
        Fri, 27 Oct 2023 10:07:03 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RGxmjE014112;
        Fri, 27 Oct 2023 17:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9PiBRvuTQVipxlh/1jsfRJuy0oTJAEeGNzQ1zi8CZWA=;
 b=ab+/CCMjyO0AYDXi1iMOh3K3l7Ez7Mak2ETNklXC7Uv5YBtQBVTqx4llM6d/lIqJsfry
 x7l3Oxqw7OdtX7qNHv8UsLHictFnpdnNo3ueEZZSV5eE5+FKPxbfsnNS+Gj82gvXlC0H
 VlAnlBas6rD7m0PojUgChKSO+gZv2VyaUmBRbl6tlpN837bhePfXfXanFNsxsc94jp1C
 PHCo9mMYZKba1mZk6Q2kpHTJnmfzoJDvWfaGQXry4pXi9tvPgwLaj2e/LIcXF6Pgmfjv
 oXnKhGDlSyhkCXk4A3VFhw8fEFBiQJ2gSNduCboFA7ZPvAagDZSJ4NR5g9baXl5FcIfc TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0h76g5q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 17:07:02 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RH2SSe024216;
        Fri, 27 Oct 2023 17:07:01 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0h76g5pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 17:07:01 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RGDip1011341;
        Fri, 27 Oct 2023 17:07:01 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqr6fwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 17:07:01 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RH6xB132506552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 17:07:00 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D81A058045;
        Fri, 27 Oct 2023 17:06:58 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2DCF58052;
        Fri, 27 Oct 2023 17:06:57 +0000 (GMT)
Received: from [9.61.163.200] (unknown [9.61.163.200])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 17:06:57 +0000 (GMT)
Message-ID: <1aa17b46-18ce-403d-b511-ee6c8f7142b3@linux.ibm.com>
Date:   Fri, 27 Oct 2023 13:06:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-3-akrowiak@linux.ibm.com>
 <20231027125638.67a65ab9.pasic@linux.ibm.com>
 <8eb41445-1eff-4da7-830f-156f420afd5d@linux.ibm.com>
 <20231027160347.05c6cd60.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231027160347.05c6cd60.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XyDmZpMoXmLgfpGRua-eqUyAGojE7jEm
X-Proofpoint-ORIG-GUID: 9Uz6woctzq8CYCJX1jkkdMRQTRpqYpv-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_15,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 phishscore=0 mlxlogscore=988 priorityscore=1501 mlxscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/27/23 10:03, Halil Pasic wrote:
> On Fri, 27 Oct 2023 09:36:26 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>>>> The interception handler for the PQAP(AQIC) command calls the
>>>> kvm_s390_gisc_register function to register the guest ISC with the channel
>>>> subsystem. If that call fails, the status response code 08 - indicating
>>>> Invalid ZONE/GISA designation - is returned to the guest. This response
>>>> code does not make sense because the non-zero return code from the
>>>> kvm_s390_gisc_register function can be due one of two things: Either the
>>>> ISC passed as a parameter by the guest to the PQAP(AQIC) command is greater
>>>> than the maximum ISC value allowed, or the guest is not using a GISA.
>>>
>>> The "ISC passed as a parameter by the guest to the PQAP(AQIC) command is
>>> greater than the maximum ISC value allowed" is not possible. The isc is
>>> 3 bits wide and all 8 values that can be represented on 3 bits are valid.
>>>
>>> This is only possible if the hypervisor was to mess up, or if the machine
>>> was broken.
>>
>> kvm_s390_gisc_register(struct kvm *kvm, u32 gisc)
>> {
>> 	struct kvm_s390_gisa_interrupt *gi = &kvm->arch.gisa_int;
>>
>> 	if (!gi->origin)
>> 		return -ENODEV;
>> 	if (gisc > MAX_ISC)
>> 		return -ERANGE;
>> ...
>>
>> Just quoting what is in the code.
> 
> Right! But it is not the guest that calls this function directly. This
> function is called by the vfio_ap code.
> 
> The guest passes ISC in bits 61, 62 and 63 of GR1.
> 
> So the guest can't give you an invalid value.

Yes, I got it the first time you said that.

> 
> Regards,
> Halil
