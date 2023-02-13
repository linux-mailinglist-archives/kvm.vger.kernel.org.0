Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED169450D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjBMMBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjBMMAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:00:54 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8361A955;
        Mon, 13 Feb 2023 04:00:32 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31DBhid2002957;
        Mon, 13 Feb 2023 12:00:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RwxiAnTqBHUPOpKdR8qJUfKKzLpebM0sFU7M8zvLwoU=;
 b=SCHhKE8RmvXEptkoQ6y7kEI4wE2MpNh2EGWhb5+p7AEI+6RMPQZwKD0R0QlTW+7KkVKT
 GMh0o63lGKaPgIs/id/fRDdH4A/JwpSd/IADKydIUbyYGsnnvflxJn7N3eQFpxCbbDBi
 +AWbhBLKU5EiU7UB1e1fxE8XTXbA5uWhXmSAu+qJKYAOCXltLPaGd0nkN+lAMrWOlfTV
 rvHAziCd5atLnN7scT0LtK+Ko1do1p87nSaXCE/UfvMYZo58B4h4PHwzbW+GvTeuY7ao
 TqT00nPJpYS5UbjYzoBw4ld/kBBgmnVclVjnqNgoXH5Pc4A67u4vhThuzexwfC33Wlr4 WQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nqmk50bqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 12:00:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31CJ0Nas010953;
        Mon, 13 Feb 2023 12:00:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3np2n6tkjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 12:00:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31DC0QpZ35651996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Feb 2023 12:00:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AF242004B;
        Mon, 13 Feb 2023 12:00:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 250662006C;
        Mon, 13 Feb 2023 12:00:26 +0000 (GMT)
Received: from [9.171.76.240] (unknown [9.171.76.240])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 13 Feb 2023 12:00:26 +0000 (GMT)
Message-ID: <914807eb-ec75-0de1-abe4-2b928917edef@linux.ibm.com>
Date:   Mon, 13 Feb 2023 13:00:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/1] KVM: s390: pv: fix external interruption loop not
 always detected
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230213085520.100756-1-nrb@linux.ibm.com>
 <20230213085520.100756-2-nrb@linux.ibm.com>
 <38deba59-ac91-0196-d7f0-e7846a7531b3@linux.ibm.com>
In-Reply-To: <38deba59-ac91-0196-d7f0-e7846a7531b3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NvacTS6GVXfm95Lsccc1BZofBYceHoeY
X-Proofpoint-GUID: NvacTS6GVXfm95Lsccc1BZofBYceHoeY
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_06,2023-02-13_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=759 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302130104
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/13/23 10:21, Janosch Frank wrote:
> On 2/13/23 09:55, Nico Boehr wrote:
>> To determine whether the guest has caused an external interruption loop
>> upon code 20 (external interrupt) intercepts, the ext_new_psw needs to
>> be inspected to see whether external interrupts are enabled.
>>
>> Under non-PV, ext_new_psw can simply be taken from guest lowcore. Under
>> PV, KVM can only access the encrypted guest lowcore and hence the
>> ext_new_psw must not be taken from guest lowcore.
>>
>> handle_external_interrupt() incorrectly did that and hence was not able
>> to reliably tell whether an external interruption loop is happening or
>> not. False negatives cause spurious failures of my kvm-unit-test
>> for extint loops[1] under PV.
>>
>> Since code 20 is only caused under PV if and only if the guest's
>> ext_new_psw is enabled for external interrupts, false positive detection
>> of a external interruption loop can not happen.
>>
>> Fix this issue by instead looking at the guest PSW in the state
>> description. Since the PSW swap for external interrupt is done by the
>> ultravisor before the intercept is caused, this reliably tells whether
>> the guest is enabled for external interrupts in the ext_new_psw.
>>
>> Also update the comments to explain better what is happening.
>>
>> [1] https://lore.kernel.org/kvm/20220812062151.1980937-4-nrb@linux.ibm.com/
>>
>> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>> ---
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 

I'll add this when picking:
Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")
