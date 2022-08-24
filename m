Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E416F59F47A
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbiHXHkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 03:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiHXHkj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 03:40:39 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC703F335
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 00:40:36 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27O7SnX2029196
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LGPbWlxqoaon0sDTOVocq7tajtO+qanuIyfXczUEroM=;
 b=eCtX74FoJRP6O82cENU98lEeD1sARSHIS+aAPY0vDIszPHzy6cxwSPrQHh8YWidFZKIz
 jKYr1VDHc7uN7ZpQ92e8yR3X71IaB+f28CS1kNA6CY2M+BCBV7e4uzk27OBEkoCGxa7Q
 BMTJEah00n3uaKgWO7bfFA8iciDHibsslrr9gY9gMlY8Th6eiPRjnPnlBvwcBiC1FmEj
 d8jt1SQYOq9UOhcQvOOM5QWjltZP4vEfGucfH5cA76V2YVveXzIoZS9FOJea4WIcrDhD
 zDzBJ9XLpVtAzcxhTC2GSexyrCZQB4ZDXP0zmeNFZJJC/kC+xoyaloCPyAqDkn89HE7F +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5fmu0bn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:40:36 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27O7U5kF002363
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 07:40:35 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j5fmu0bjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 07:40:35 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27O7KPKD013502;
        Wed, 24 Aug 2022 07:40:32 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3j2q893gn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 24 Aug 2022 07:40:32 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27O7eTNE13500712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Aug 2022 07:40:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0A2AE053;
        Wed, 24 Aug 2022 07:40:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00CBFAE051;
        Wed, 24 Aug 2022 07:40:29 +0000 (GMT)
Received: from [9.145.53.141] (unknown [9.145.53.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 24 Aug 2022 07:40:28 +0000 (GMT)
Message-ID: <b238301e-3f43-062e-920d-d322548c55ba@linux.ibm.com>
Date:   Wed, 24 Aug 2022 09:40:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     imbrenda@linux.ibm.com
References: <20220803135851.384805-1-nrb@linux.ibm.com>
 <20220803135851.384805-2-nrb@linux.ibm.com>
 <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is
 unavailable
In-Reply-To: <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ut5xLTb8ukUBYNk2wO3e8xehfMYNRbuX
X-Proofpoint-GUID: hT7SaZdZZaV5hURjpeX3frmyEgud0M7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_04,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208240029
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/4/22 00:17, Thomas Huth wrote:
> On 03/08/2022 15.58, Nico Boehr wrote:
>> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
>> result in an exception.
> 
> I somewhat fail to see the exact purpose of this patch... QEMU still doesn't
> emulate a lot of other instructions, too, so why are we checking now these
> QBS instructions? Why not all the others? Why do we need a test to verify
> that there is an exception in this case - was there a bug somewhere that
> didn't cause an exception in certain circumstances?

Looking at the patch that introduced the QEMU handlers (1eecf41b) I 
wonder why those two cases were added. From my point of view it makes 
sense to remove the special handling for those two instructions.

@Christian: Any idea why this was added? Can we remove it?

The only reason I can think of to test this is the existence of EC* bits 
that control the behavior for those instructions. So if we set those 
without having QEMU handling code then we're in trouble.

But then I'd also expect that we need to set a stfle bit to indicate the 
availability and this test doesn't check for that and would indicate a 
false-positive.
