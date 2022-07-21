Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA2857C652
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 10:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiGUIe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 04:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiGUIez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 04:34:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA90D7E321;
        Thu, 21 Jul 2022 01:34:54 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26L8HSmb016045;
        Thu, 21 Jul 2022 08:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=I4hdz5aV02CanBccTjVVgDZ51WswlsgpjqvfxnsTS1Q=;
 b=PRW/oiX4ONdSyj9eWZdc/g6OOhwPrCF489dA8DhxMCWzQIQGs4pEY+vUHbuXBYXfvz5M
 FlcntNk10NNJnBJxM9mQJ7FKlREFhGMuobtwnTMqGwBJ/lbH6qo5zv2gpk0rZ764W32z
 P9m/2tg5DcosXOYSwPzgcaQCr1/y7sKZjgho47K7gkTe33wUC2VVBqcBkSDfJP/m9/UV
 +qIaJ0mnDFMME+fOHUIbcVT+weqAhHVXqM3NWZ6SOs9b3gOplgk5umNhSLPlD8lGKxa8
 6DyXOkKzv1bllq1qTsCNDU5mPSVhiRWBcZijIuEQT+yngB/vs+3TSiOGsa0ZZc0apGbJ 5g== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf35ngcyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 08:34:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26L8LxYJ012860;
        Thu, 21 Jul 2022 08:34:52 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj6n38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 08:34:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26L8YmmH20316540
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 08:34:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA25552054;
        Thu, 21 Jul 2022 08:34:48 +0000 (GMT)
Received: from [9.171.90.65] (unknown [9.171.90.65])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 961A15204F;
        Thu, 21 Jul 2022 08:34:48 +0000 (GMT)
Message-ID: <ac235132-e7cf-eb24-c8fa-23a27af1ec25@linux.ibm.com>
Date:   Thu, 21 Jul 2022 10:34:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v1] s390/kvm: pv: don't present the ecall interrupt twice
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220718130434.73302-1-nrb@linux.ibm.com>
 <16b8d198-9f5b-7124-e9bc-69209a0b49ac@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <16b8d198-9f5b-7124-e9bc-69209a0b49ac@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 68l-UDoPAHC-wfvKdEhu5kcLx0JEM32Y
X-Proofpoint-GUID: 68l-UDoPAHC-wfvKdEhu5kcLx0JEM32Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 mlxlogscore=667 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207210033
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 19.07.22 um 15:07 schrieb Janosch Frank:
> On 7/18/22 15:04, Nico Boehr wrote:
>> When the SIGP interpretation facility is present and a VCPU sends an
>> ecall to another VCPU in enabled wait, the sending VCPU receives a 56
>> intercept (partial execution), so KVM can wake up the receiving CPU.
>> Note that the SIGP interpretation facility will take care of the
>> interrupt delivery and KVM's only job is to wake the receiving VCPU.
> 
> @Nico: Can we fixup the patch subject when picking?
> The prefix normally starts with KVM: arch: Subject starts here
> 
> kvm: s390: pv: don't present the ecall interrupt twice

KVM (uppercase) please.
