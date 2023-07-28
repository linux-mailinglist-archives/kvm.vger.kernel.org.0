Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49CF766F78
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 16:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbjG1O3W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 10:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbjG1O3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 10:29:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF993A95;
        Fri, 28 Jul 2023 07:29:19 -0700 (PDT)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36SEBKKR032628;
        Fri, 28 Jul 2023 14:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RrjmBYTAqfz/8WQ4mG2EH7E/i2FnI2ZvWdqZuxb0iFI=;
 b=jOkmOxsMowxFq6hhAtwoZAsB6W3UXQuKpOp8RMxQEudAPurWa0rn9Hbf0ePEBFlS+YAf
 bF/8Aa43XRCqpNHVAaPnllPk0/dFVeme34zYL9/8BA/sy9ut6g4dQwWGPeh3VZ6CoKB3
 eqcshSiIMR5AOEuiWhnMV5/K+4I0yMY3OVxq+boIOat+nWpNQ1GzXqnGEFOyF1RXXQRY
 DnNV/gp56chZGGRXzWz9lxy0Kutj9yPR8VmazTG9h5BRDtYfmcQ8+Ef8gYFeYO8Cr7TN
 DKqSClXSDCAR2+CClTWitBa0/yrHAMCStANx1KvfYI3ZBvHvO11U9BQw2JgBb9zlEFWs 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4ebp9xt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 14:29:19 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36SELofh005970;
        Fri, 28 Jul 2023 14:29:18 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s4ebp9xss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 14:29:18 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36SDJZUM026227;
        Fri, 28 Jul 2023 14:29:17 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0sesq54t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Jul 2023 14:29:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36SETEoW50462978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jul 2023 14:29:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C448520040;
        Fri, 28 Jul 2023 14:29:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D4692004B;
        Fri, 28 Jul 2023 14:29:14 +0000 (GMT)
Received: from [9.152.224.114] (unknown [9.152.224.114])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jul 2023 14:29:14 +0000 (GMT)
Message-ID: <1c767675-3ab6-8e4b-e92e-e408b19e1c49@linux.ibm.com>
Date:   Fri, 28 Jul 2023 16:29:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: s390: fix sthyi error handling
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Mete Durlu <meted@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230727182939.2050744-1-hca@linux.ibm.com>
 <7fadab86-2b7c-b934-fcfa-61046c0778b6@linux.ibm.com>
 <20230728091411.6761-A-hca@linux.ibm.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20230728091411.6761-A-hca@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f9z5YhUKjce3Up5pnh-qsbLNl8vPFFQx
X-Proofpoint-GUID: tEV2qk0PF3L_dNscXWfWwuzw4YKTp4wr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-27_10,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=853 lowpriorityscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307280130
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 28.07.23 um 11:14 schrieb Heiko Carstens:
> On Fri, Jul 28, 2023 at 09:28:58AM +0200, Christian Borntraeger wrote:
>> Am 27.07.23 um 20:29 schrieb Heiko Carstens:
>>> Commit 9fb6c9b3fea1 ("s390/sthyi: add cache to store hypervisor info")
>>> added cache handling for store hypervisor info. This also changed the
>>> possible return code for sthyi_fill().
>>>
>>> Instead of only returning a condition code like the sthyi instruction would
>>> do, it can now also return a negative error value (-ENOMEM). handle_styhi()
>>> was not changed accordingly. In case of an error, the negative error value
>>> would incorrectly injected into the guest PSW.
>>>
>>> Add proper error handling to prevent this, and update the comment which
>>> describes the possible return values of sthyi_fill().
>>
>> To me it looks like this can only happen if page allocation fails? This should
>> not happen in normal cases (and return -ENOMEM would likely kill the guest as
>> QEMU would stop).
>> But if it happens we better stop.
> 
> Yes, no reason for any stable backports. But things might change in the
> future, so we better have correct error handling in place.

Feel free to carry via the s390 tree.
