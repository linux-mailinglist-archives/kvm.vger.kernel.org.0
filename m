Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ACD78B07D
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 14:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjH1MfJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 08:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjH1Me4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 08:34:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05C2EA;
        Mon, 28 Aug 2023 05:34:53 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37SC66w0020784;
        Mon, 28 Aug 2023 12:34:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : to :
 cc : references : from : subject : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=7vN2jjv/tE2UxkRZt2u2bmyzhdvpEQu0xKwb8XqGe9U=;
 b=ho7pYXvtG7ZclGi9exdmjxfRL+yhxkomjWF+0jjUdslpKiDvdSfYyMc8ZWbwl2Vs7712
 oKQzDwGQxkUQoAlM4rR+blwEToYw6Zn7kxVvYrfuJyExQHziJ4LYP0LvficwqwPWsc89
 SDAEEpcr7gZW/Rb8VBTl7SHuI1hREr4JlNj8dx1+KZdeq9s/BcJ+mVmK6YHrwsO6jqfT
 U9i75UV2ywj/0xPPeqfe7Kwf01nhxpG3bJJs3qtVTreqPPlXlG9vFfnt360KtXqyw0u6
 MW76W2KN4l+vW7Mqsvd2DV2kJ03erSzPpoAxs9nGraz8qnv+6qAvLjxFgtHpHp+O32fV +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr51tq0hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 12:34:53 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37SCQMrY005497;
        Mon, 28 Aug 2023 12:34:52 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sr51tq0hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 12:34:52 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37SAHRV1009897;
        Mon, 28 Aug 2023 12:34:51 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sqw7k2ehh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Aug 2023 12:34:51 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37SCYltR22479486
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Aug 2023 12:34:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DECC220043;
        Mon, 28 Aug 2023 12:34:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 625F120040;
        Mon, 28 Aug 2023 12:34:47 +0000 (GMT)
Received: from [9.171.83.213] (unknown [9.171.83.213])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 28 Aug 2023 12:34:47 +0000 (GMT)
Message-ID: <49514ec8-667a-27c6-a8d9-a41dd41b85d6@linux.ibm.com>
Date:   Mon, 28 Aug 2023 14:34:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com, Ilya Leoshkevich <iii@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
 <99289fd4-0a1e-3c05-8934-732ef7815942@linux.ibm.com>
 <ZOjPqhpejWWJrEgE@google.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [GIT PULL 00/22] KVM: s390: Changes for 6.6
In-Reply-To: <ZOjPqhpejWWJrEgE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tn5w3lObbvqMk6NbKlq50PeO8nwYb48Z
X-Proofpoint-ORIG-GUID: uOarsFUuX8iQiDpr4cVqobkk2D1dD4qZ
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-28_09,2023-08-28_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308280110
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 17:58, Sean Christopherson wrote:
> On Fri, Aug 25, 2023, Janosch Frank wrote:
>> On 8/24/23 14:43, Janosch Frank wrote:
>>> Hello Paolo,
>>>
>>> please pull the following changes for 6.6.
>>>
>>
>> @Paolo:
>> Seems like neither Claudio (who picked the selftest) nor I had a closer look
>> into the x86 selftest changes and Nina just informed me that this might lead
>> to problems.
>>
>> Please hold back on this pull request, I'll send a new one on Monday where
>> we'll pull in the selftest changes and have a fixed up version of the
>> selftest. I've spoken to Ilya privately and he's ok with Claudio fixing this
>> up.
> 
> If you haven't already done a merge, I pushed
> 
>    https://github.com/kvm-x86/linux.git tags/kvm-x86-selftests-immutable-6.6
> 
> to guarantee a stable point (I have a few last minute selftests fixes for 6.6
> that I'm planning on applying "soon").
> 
> Thanks for dealing with the conflicts, let me know if you run into any problems.

Hey Sean / Paolo,

I've pulled this in, fixed up the selftest and pushed it to the repo for 
everyone to have a look at.
I'll give it a night in the CI and send a new PULL request tomorrow if 
you guys don't complain. :)
