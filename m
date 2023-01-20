Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4516756FD
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjATOXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 09:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjATOXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 09:23:48 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E73F749
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 06:23:22 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30KDMGsi004257;
        Fri, 20 Jan 2023 14:22:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=fbTDpz0/ozxIhvj4DA6UKvzCfCYbFE9WLsOcCeP99u0=;
 b=OfmTJGi5dA8MNL33ul89Ol22dEsFJDgE3m9V3KQviiu23KaiRPUF+y3KQuDY9ZkAXin8
 be7Bauvyd8BfKa6kqy06zGqijB8hH0LJ2PNPdQw/FpzmAfUR5WoHvrPKSZsGfDOiQevD
 zeLDXj6zoiPRYEEa2MVDC2DrKHp9nMKBWhWKIYBbJu0BphxJPEBMSEE6fs7r99YqRNr1
 68R+nlAIkyCMa5SDGVJ84Gr5/F9PJ8zz2bjdRgiC5levMF/5+oTT5xDmhOj4V9co3gQE
 v7EGKyGNiP6v12Vm12q1VmdUWaXgaE8FCYdRenAWxEwCi20eroy4p9uuJJT3527hPdXI sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7usghe2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:22:19 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30KEBUe3023838;
        Fri, 20 Jan 2023 14:22:19 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7usghe1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:22:19 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30KCVaJK009485;
        Fri, 20 Jan 2023 14:22:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n3knfr37u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Jan 2023 14:22:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30KEMDjF25428656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Jan 2023 14:22:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F83E20040;
        Fri, 20 Jan 2023 14:22:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56E9720043;
        Fri, 20 Jan 2023 14:22:12 +0000 (GMT)
Received: from [9.171.50.198] (unknown [9.171.50.198])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Jan 2023 14:22:12 +0000 (GMT)
Message-ID: <772f43f2-9dc3-befb-9061-effda2e357eb@linux.ibm.com>
Date:   Fri, 20 Jan 2023 15:22:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v14 10/11] qapi/s390/cpu topology: POLARITY_CHANGE qapi
 event
To:     Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-11-pmorel@linux.ibm.com>
 <c338245c-82c3-ed57-9c98-f4d630fa1759@redhat.com>
 <5f177a1b-90d6-7e30-5b58-cdcae7919363@linux.ibm.com>
 <648e62ab-9d66-9a5a-0a03-124c16b85805@redhat.com>
Content-Language: en-US
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <648e62ab-9d66-9a5a-0a03-124c16b85805@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QamKRmy4ygtsxSOgYeNiAnPHfRD0siJz
X-Proofpoint-ORIG-GUID: ao9lXoyzQK9iV_tQHhzkFiIHXeijHB40
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-20_08,2023-01-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301200133
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/23 12:56, Thomas Huth wrote:
> On 18/01/2023 18.09, Pierre Morel wrote:
>>
>> On 1/12/23 12:52, Thomas Huth wrote:
>>> On 05/01/2023 15.53, Pierre Morel wrote:
> ...>>> +#

OK

>>>> +# Emitted when the guest asks to change the polarity.
>>>> +#
>>>> +# @polarity: polarity specified by the guest
>>>
>>> Please elaborate: Where does the value come from (the PTF 
>>> instruction)? Which values are possible?
>>
>> Yes what about:
>>
>> # @polarity: the guest can specify with the PTF instruction a horizontal
>> #            or a vertical polarity.
> 
> Maybe something like: "The guest can tell the host (via the PTF 
> instruction) whether a CPU should have horizontal or vertical polarity." ?

Yes thanks, much better.

> 
>> #         On horizontal polarity the host is expected to provision
>> #            the vCPU equally.
> 
> Maybe: "all vCPUs equally" ?
> Or: "each vCPU equally" ?

yes, thx.


> 
>> #            On vertical polarity the host can provision each vCPU
>> #            differently
>> #            The guest can get information on the provisioning with
>> #            the STSI(15) instruction.
> 
>   Thomas
> 

I make the changes.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
