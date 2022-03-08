Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED24E4D1BE6
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 16:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347847AbiCHPkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 10:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiCHPkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 10:40:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7177D3134E;
        Tue,  8 Mar 2022 07:39:16 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228EbFnV009983;
        Tue, 8 Mar 2022 15:39:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=CM6kiWJAiPT9mC+Dod5De+bPxG2c0/kN9DmKhg/1EXU=;
 b=G9XKMNjk4/8MgXBDKglny1+HFu3u8hsAos7MTF6i7xHZI5TIGwMswBrpB5U51JKjFQYW
 7Djdyjljb17hJsmW4enz5tIXPlEnZgYviQUjcKkucIIJY/MR8oxRDXv73wO12cumcKmV
 n23fGS+/sX0UvuX04osf7dRdeY0+LPqTsK+I7u1H8lloqMktZgLE8SNjwKrXddqtd5gQ
 VnjAoqCuQLvIW4WDgY3jT4Un6cNzU/XJAReY8TzeSzMz0KAxqbyrGBplix/01Hl2/T9Q
 hpgADo1HujQccGrYylOPRW9MJqsRby6pyhAv87+m47VNyYFBKNR51WKftiJDvm9EXpaa 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eny9k5v7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:39:13 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 228FBqFJ007052;
        Tue, 8 Mar 2022 15:39:13 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eny9k5v7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:39:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 228F7nxw001363;
        Tue, 8 Mar 2022 15:39:12 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3ekyg95yt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Mar 2022 15:39:12 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 228FdBOU51446118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Mar 2022 15:39:11 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1892AAC062;
        Tue,  8 Mar 2022 15:39:11 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B31EAC05F;
        Tue,  8 Mar 2022 15:39:09 +0000 (GMT)
Received: from [9.160.101.128] (unknown [9.160.101.128])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Mar 2022 15:39:09 +0000 (GMT)
Message-ID: <439f929f-9d15-c33c-b40d-88dd06cebd85@linux.ibm.com>
Date:   Tue, 8 Mar 2022 10:39:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v18 08/18] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-9-akrowiak@linux.ibm.com>
 <97681738-50a1-976d-9f0f-be326eab7202@linux.ibm.com>
 <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <9ac3908e-06da-6276-d1df-94898918fc5b@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rc5-eKYUXwHhura1Um6mUyUgGeqFHTah
X-Proofpoint-GUID: 1E5L0lbB7A5F2Z6AEhlQ7i62A1kmJPHd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=637
 phishscore=0 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/7/22 07:31, Tony Krowiak wrote:
>>> +         * If the input apm and aqm belong to the matrix_mdev's matrix,
>>> +         * then move on to the next.
>>> +         */
>>> +        if (mdev_apm == matrix_mdev->matrix.apm &&
>>> +            mdev_aqm == matrix_mdev->matrix.aqm)
>>>               continue;
>>
>> We may have a problem here. This check seems like it exists to stop you from
>> comparing an mdev's apm/aqm with itself. Obviously comparing an mdev's newly
>> updated apm/aqm with itself would cause a false positive sharing check, right?
>> If this is the case, I think the comment should be changed to reflect that.
> 
> You are correct, this check is performed to prevent comparing an mdev to
> itself, I'll improve the comment.
> 
>>
>> Aside from the comment, what stops this particular series of if statements from
>> allowing us to configure a second mdev with the exact same apm/aqm values as an
>> existing mdev? If we do, then this check's continue will short circuit the rest
>> of the function thereby allowing that 2nd mdev even though it should be a
>> sharing violation.
> 
> I don't see how this is possible.

You are correct. I missed the fact that you are comparing pointers here, and not
values. Apologies. Now that I understand the code, I agree that this is fine as is.


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
