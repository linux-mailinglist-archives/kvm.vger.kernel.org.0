Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E90A76B5F3
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbjHANey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 09:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjHANew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 09:34:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973E02106;
        Tue,  1 Aug 2023 06:34:51 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 371DRKG7001250;
        Tue, 1 Aug 2023 13:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cK429b0FcGCFUk2aLPITRcBVYx+mW7Fievvdn9e9caU=;
 b=jrcixVzVPyZAbdsJbhRjESSnSHUu7pPAjoXR6E1+tg7rI9M5uFGvR5UIxyVvU7R3D123
 cAor0PFvH76boHAYFIhn9BIxBBEQsmEt+rJ1oSVzyImIO66OgP7X1K93Eu/SggDG9EGX
 zKsqfFeqYR/80IH4Cjb8e1vmFlBtbWQScBp/FPhdKU84pTQy4pjZvBg4GwSoKjOERQ1Q
 JqbN8GYUwftJcbmfeUznv463Kt+zmVxSig1XATEKAUVmKr/trgtFcBjwhqfUM0qzmHdW
 vYtQFsyzu09iE8JKHhGgh6wLt0thAiVc+/cCiw+MmcXHSOoWcsyvAXDKK7Os9WoJqpwQ Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s72xwrapp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 13:34:50 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 371DSHnD005549;
        Tue, 1 Aug 2023 13:34:50 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s72xwrakf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 13:34:49 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 371D1W5A014545;
        Tue, 1 Aug 2023 13:34:47 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s5ft1bhue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Aug 2023 13:34:47 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 371DYiQq19726912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Aug 2023 13:34:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE6D02004D;
        Tue,  1 Aug 2023 13:34:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55A8620043;
        Tue,  1 Aug 2023 13:34:44 +0000 (GMT)
Received: from [9.171.20.151] (unknown [9.171.20.151])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  1 Aug 2023 13:34:44 +0000 (GMT)
Message-ID: <b5c1b495-cd59-e42e-a902-50f5fef0fad0@linux.ibm.com>
Date:   Tue, 1 Aug 2023 15:34:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 1/2] KVM: s390: add stat counter for shadow gmap events
To:     Nico Boehr <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        borntraeger@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230510121822.546629-1-nrb@linux.ibm.com>
 <20230510121822.546629-2-nrb@linux.ibm.com>
 <e0b2195a-6f60-6a49-cf3f-4a528eb2df43@redhat.com>
 <169089049005.9734.15826596498609647664@t14-nrb>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <169089049005.9734.15826596498609647664@t14-nrb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cQv0XrRboZ4ou3iJ2lmyQ3Wkk-Vg6061
X-Proofpoint-ORIG-GUID: QQ_78cMSH7Tiy63XkRAEQKFCznVfLBlM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-01_09,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308010123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/23 13:48, Nico Boehr wrote:
> Quoting David Hildenbrand (2023-07-27 09:37:21)
> [...]
>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>> index 2bbc3d54959d..d35e03e82d3d 100644
>>> --- a/arch/s390/include/asm/kvm_host.h
>>> +++ b/arch/s390/include/asm/kvm_host.h
>>> @@ -777,6 +777,12 @@ struct kvm_vm_stat {
>>>        u64 inject_service_signal;
>>>        u64 inject_virtio;
>>>        u64 aen_forward;
>>> +     u64 gmap_shadow_acquire;
>>> +     u64 gmap_shadow_r1_te;
>>> +     u64 gmap_shadow_r2_te;
>>> +     u64 gmap_shadow_r3_te;
>>> +     u64 gmap_shadow_sg_te;
>>> +     u64 gmap_shadow_pg_te;
>>
>> Is "te" supposed to stand for "table entry" ?
> 
> Yes.
> 
>> If so, I'd suggest to just call this gmap_shadow_pg_entry etc.
> 
> Janosch, since you suggested the current naming, are you OK with _entry?

Sure

> 
> [...]
>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>> index 8d6b765abf29..beb3be037722 100644
>>> --- a/arch/s390/kvm/vsie.c
>>> +++ b/arch/s390/kvm/vsie.c
>>> @@ -1221,6 +1221,7 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
>>>        if (IS_ERR(gmap))
>>>                return PTR_ERR(gmap);
>>>        gmap->private = vcpu->kvm;
>>> +     vcpu->kvm->stat.gmap_shadow_acquire++;
>>
>>
>> Do you rather want to have events for
>>
>> gmap_shadow_reuse (if gmap_shadow_valid() succeeded in that function)
>> gmap_shadow_create (if we have to create a new one via gmap_shadow)
>>
>> ?
> 
> Yeah, good suggestion. I'll add that.

