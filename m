Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6F37599F7
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 17:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjGSPj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 11:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbjGSPjY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 11:39:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F46E47
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 08:39:14 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JFchVW030031;
        Wed, 19 Jul 2023 15:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Hsz8iEIMnGZA8sKmY8pXiTLJal7GaptU9/1zZPPU1EY=;
 b=qwykmQOaz/ibWXVNGfkW27c1tUFynI+cKs+qx+mAZxsBUKA38FyEJcGTI2Gpvpq6eI7h
 diJiQYjvvUgtH73HRch1B++HSafnL5I/ON8ulz3kkZ/WLkOIqR8TZvRpi98ObAM0io/j
 bkYQnzEekWLwSk1fbfAsHhcokCq5OgDERg9637WxfL4lCQe4jPtpNBbpoZUQJQN+S8Or
 1YbfmUug8i7r5akVY1m6TE8Mm9FLLfzjlsigZcqTxnCjD9j3aTNNKbsaImp9wqDLhkeQ
 jQGQ+JORRkfEePTUSfgQ6k0qir4tkXMRoptx2J6biqwsbu+nqNYahqaMRxk+pObaMx5q VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxjfq889h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 15:39:06 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36JFcxoM032128;
        Wed, 19 Jul 2023 15:39:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rxjfq87te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 15:39:05 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36JCqrSg003352;
        Wed, 19 Jul 2023 15:34:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3rv65xjcdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 15:34:36 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36JFYWDe43123152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jul 2023 15:34:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32BD020043;
        Wed, 19 Jul 2023 15:34:32 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C36862004B;
        Wed, 19 Jul 2023 15:34:31 +0000 (GMT)
Received: from [9.155.200.205] (unknown [9.155.200.205])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Wed, 19 Jul 2023 15:34:31 +0000 (GMT)
Message-ID: <3aba5eac-d5d5-80da-e955-864c80065c5d@linux.ibm.com>
Date:   Wed, 19 Jul 2023 17:34:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v21 16/20] tests/avocado: s390x cpu topology entitlement
 tests
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
 <20230630091752.67190-17-pmorel@linux.ibm.com>
 <dfeeeaa1-0994-9e1e-1f10-6c6618daacff@redhat.com>
 <aa1fbe820f23bc487752ee29ee114f5d4185352a.camel@linux.ibm.com>
 <88070b30-36ea-8112-41c4-0d93fc76cf80@redhat.com>
 <dbb17fa6239774d80e697ed771514b345faf5486.camel@linux.ibm.com>
 <ba0767b8-0273-898e-6aaa-1e2318b09304@linux.ibm.com>
 <b4f789852e124549e2b30d25ad1268ed011c7263.camel@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <b4f789852e124549e2b30d25ad1268ed011c7263.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RF22WIjhij5Dl1FBBQc_YfNojGD7qWRl
X-Proofpoint-GUID: mM0Kom8NotsFxPjaAp5RgEAmurf-jJdf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_10,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307190139
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/19/23 16:13, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-07-19 at 16:08 +0200, Pierre Morel wrote:
>> On 7/14/23 18:30, Nina Schoetterl-Glausch wrote:
>>> On Wed, 2023-07-12 at 22:11 +0200, Thomas Huth wrote:
>>>> On 12/07/2023 21.37, Nina Schoetterl-Glausch wrote:
>>>>> On Wed, 2023-07-05 at 12:22 +0200, Thomas Huth wrote:
>>>>>> On 30/06/2023 11.17, Pierre Morel wrote:
>>>>>>> This test takes care to check the changes on different
>>>>>>> entitlements
>>>>>>> when the guest requests a polarization change.
>>>>>>>
>>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>>> ---
>>>>>>>      tests/avocado/s390_topology.py | 47
>>>>>>> ++++++++++++++++++++++++++++++++++
>>>>>>>      1 file changed, 47 insertions(+)
>>>>>>>
>>>>>>> diff --git a/tests/avocado/s390_topology.py
>>>>>>> b/tests/avocado/s390_topology.py
>>>>>>> index 2cf731cb1d..4855e5d7e4 100644
>>>>>>> --- a/tests/avocado/s390_topology.py
>>>>>>> +++ b/tests/avocado/s390_topology.py
>>>>>>> @@ -240,3 +240,50 @@ def test_polarisation(self):
>>>>>>>              res = self.vm.qmp('query-cpu-polarization')
>>>>>>>              self.assertEqual(res['return']['polarization'],
>>>>>>> 'horizontal')
>>>>>>>              self.check_topology(0, 0, 0, 0, 'medium',
>>>>>>> False)
>>>>>>> +
>>>>>>> +    def test_entitlement(self):
>>>>>>> +        """
>>>>>>> +        This test verifies that QEMU modifies the
>>>>>>> polarization
>>>>>>> +        after a guest request.
>>>>>> ...
>>>>>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>>>>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>>>>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>>>>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>>>>>> +
>>>>>>> +        self.guest_set_dispatching('1');
>>>>>>> +
>>>>>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>>>>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>>>>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>>>>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>>>>>> +
>>>>>>> +        self.guest_set_dispatching('0');
>>>>>>> +
>>>>>>> +        self.check_topology(0, 0, 0, 0, 'low', False)
>>>>>>> +        self.check_topology(1, 0, 0, 0, 'medium', False)
>>>>>>> +        self.check_topology(2, 1, 0, 0, 'high', False)
>>>>>>> +        self.check_topology(3, 1, 0, 0, 'high', False)
>>>>>> Sorry, I think I'm too blind to see it, but what has changed
>>>>>> after
>>>>>> the guest
>>>>>> changed the polarization?
>>>>> Nothing, the values are retained, they're just not active.
>>>>> The guest will see a horizontal polarization until it changes
>>>>> back
>>>>> to
>>>>> vertical.
>>>> But then the comment in front of it ("This test verifies that
>>>> QEMU
>>>> *modifies* the polarization...") does not quite match, does it?
>>> Yeah, it tests that QEMU reports it's own state changed when using
>>> set-cpu-topology.
>>> I think it would be a good idea to get the guests view from the
>>> sysfs,
>>> also.
>>>
>>>>     Thomas
>>>>
>>>>
>> Yes, I think you are right, I rewrite this to check the guest view of
>> the changes.
>>
>> As you said the values are retained when not used by horizontal
>> polarization so it is a non sense to check from host view.
> I don't think it's bad to check the host view, you can do both.
>

OK, then I do it.

Thanks,

Pierre


