Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3A5B1D79
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbiIHMoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 08:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiIHMnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 08:43:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AC1C480D
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 05:43:50 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288CMdpq032512
        for <kvm@vger.kernel.org>; Thu, 8 Sep 2022 12:43:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BquNXv48im+fdNLr/lgDbHv4KPtAZJphY0xUqwJ5ves=;
 b=m+E+WEat3BdOv0qdAbeR2m/+dAGTpUxPmaF2Pt4cbhG6zg3b+6Zqz8pBb4nhVYKTzUr1
 ht+yHHppybjHG3VGhiFUojoYuvyST6qWaVpAyX/+KIkoWPa/ARIz6qOMB1ZtqJkw036A
 FPnMfF5zk0XJPRSYoIQwuYi9BkpZ9FvtXRO2RhA4o0xtaMV7Etryap26Z9alASx+XxLR
 5pQV1dV0qV36ErG2o0gN60R9jsXmHf2iQQBVh5d2LzIv9BxHB52qgpDBn1AqxppdJ5uL
 8443Hz28y6hMNRJMSg8gCvXzgfPeSZv55i5wvIIlMsmX9x3refSr9kTTLBoq5QmCRF3z eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfgbk0rst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 12:43:49 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 288CZBRZ026674
        for <kvm@vger.kernel.org>; Thu, 8 Sep 2022 12:43:49 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jfgbk0rs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 12:43:49 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 288CKMf1005500;
        Thu, 8 Sep 2022 12:43:47 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3jbx6hpku8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Sep 2022 12:43:46 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 288ChiqL36700612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Sep 2022 12:43:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3F7311C052;
        Thu,  8 Sep 2022 12:43:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1A1311C04C;
        Thu,  8 Sep 2022 12:43:43 +0000 (GMT)
Received: from [9.171.66.190] (unknown [9.171.66.190])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  8 Sep 2022 12:43:43 +0000 (GMT)
Message-ID: <003c5ac1-5215-0529-b125-e3fbd478d6d2@linux.ibm.com>
Date:   Thu, 8 Sep 2022 14:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is
 unavailable
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>,
        kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com
References: <20220803135851.384805-1-nrb@linux.ibm.com>
 <20220803135851.384805-2-nrb@linux.ibm.com>
 <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
 <b238301e-3f43-062e-920d-d322548c55ba@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <b238301e-3f43-062e-920d-d322548c55ba@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2vCPKX9pxL2omyaMuSFVKc9eZtMcjQXF
X-Proofpoint-ORIG-GUID: 9Ote2hS18OvkkyjRcStQDOjtMLGJH_ez
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_08,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1011 impostorscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209080045
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 24.08.22 um 09:40 schrieb Janosch Frank:
> On 8/4/22 00:17, Thomas Huth wrote:
>> On 03/08/2022 15.58, Nico Boehr wrote:
>>> QEMU doesn't provide EQBS/SQBS instructions, so we should check they
>>> result in an exception.
>>
>> I somewhat fail to see the exact purpose of this patch... QEMU still doesn't
>> emulate a lot of other instructions, too, so why are we checking now these
>> QBS instructions? Why not all the others? Why do we need a test to verify
>> that there is an exception in this case - was there a bug somewhere that
>> didn't cause an exception in certain circumstances?
> 
> Looking at the patch that introduced the QEMU handlers (1eecf41b) I wonder why those two cases were added. From my point of view it makes sense to remove the special handling for those two instructions.
> 
> @Christian: Any idea why this was added? Can we remove it?

No idea why it was added (in an always fail way). Yes we could remove it until we need it.
