Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1974F69A6C8
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 09:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjBQIV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 03:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBQIVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 03:21:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825045CF24;
        Fri, 17 Feb 2023 00:21:23 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31H6Y4g1019928;
        Fri, 17 Feb 2023 08:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8Y/uQ0C2Vq37cI9U+XphcblnLu2cI2NzDDwTAJTHmok=;
 b=kN0qAPwvbTZy6rfyKTPtuVxiXl13UuYId26oxxrDMWblDGEFskNeyrhv0LdcBliL4Z1G
 MCNsZYpIjY5D+u5ftN4ktBtVp/7nUlKNtuNJfxzQyWAZVrV2NaGN3h/f+vXzWYcQBXwi
 u+b/SoisJBbY28E6EZXi3z3im0pl8maxrY5W8WrcY7ssP82F991j0loSJw6NMP0opyBC
 Mp4u0yjtAey8EYIdKO+kCjmfnJdMlK7KuNej7gst0eOOG4LHfDLRjstGEMaC7hBHVDKL
 T/aDQiI76xt6xpzP6i6BnD+rM1CXMjC/8LUZiMqx5/arlSrJSooXsUvTPcuFd82J8NEo Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsv6evy7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:22 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31H6XRot013268;
        Fri, 17 Feb 2023 08:21:22 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsv6evy6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:22 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31GJW3lZ030392;
        Fri, 17 Feb 2023 08:21:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3np2n6dq7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Feb 2023 08:21:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31H8LG6F50921732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Feb 2023 08:21:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A8E620043;
        Fri, 17 Feb 2023 08:21:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D01DE20040;
        Fri, 17 Feb 2023 08:21:15 +0000 (GMT)
Received: from [9.179.29.70] (unknown [9.179.29.70])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 17 Feb 2023 08:21:15 +0000 (GMT)
Message-ID: <faf9b6aa-a72b-3c61-c720-6b972792f720@linux.ibm.com>
Date:   Fri, 17 Feb 2023 09:21:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v3 1/1] KVM: s390: vsie: clarifications on setting the
 APCB
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        svens@linux.ibm.com
References: <20230214122841.13066-1-pmorel@linux.ibm.com>
 <20230214122841.13066-2-pmorel@linux.ibm.com>
 <2e1d3f81-9cc0-bf96-abde-a270a58701a1@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <2e1d3f81-9cc0-bf96-abde-a270a58701a1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MzZSutRHOZgqZyxSEDKn0RKjdJHvEb4p
X-Proofpoint-ORIG-GUID: nQ1UDkYSjspkejkbQQt95x-2A_n2CDMM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-17_04,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=804 clxscore=1015 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302170073
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/16/23 14:04, David Hildenbrand wrote:
> On 14.02.23 13:28, Pierre Morel wrote:
>> The APCB is part of the CRYCB.
>> The calculation of the APCB origin can be done by adding
>> the APCB offset to the CRYCB origin.
>>
>> Current code makes confusing transformations, converting
>> the CRYCB origin to a pointer to calculate the APCB origin.
>>
>> Let's make things simpler and keep the CRYCB origin to make
>> these calculations.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
> 
> Much better
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
