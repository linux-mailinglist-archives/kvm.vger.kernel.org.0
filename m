Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E64631CF8
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 10:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiKUJjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 04:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKUJjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 04:39:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC3627924
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 01:39:16 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AL8DAId011389;
        Mon, 21 Nov 2022 09:39:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mVs7gG5HuNz9PVjFaXtV3U7CqU5sh5NuykIZdpy6HCw=;
 b=oMZgTJygq5mDcEfibohOaLMVSVWOSe6znZgo6qeDwLXD/Z+zGw4lLdakGNhbNW0Gff61
 ne188R6Ol+ebLwqFAI8fIamUbRzh4xudG4lyaw3r+c9wC7sSi1+kXw5ncDvj/quLGWnw
 17u7eXWLBTt5bOw4Sh6fRBCtEBu7kEvvOmJfwsxaqBJsjA0SKSfB92ufj1iFPckhxlLd
 8Ekro4T26Nwffl/5ZUlMob79AEKMhHlPxawb8ylqBTNGsNBx357xbip046XMjiYuvVBU
 zt7cl+UZUfMnKOc1Mlv0un1bUxwSDfl9TV3eIr1U5r8RzweDAj01WYEmJznXNOG1A2UQ Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky979csku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:39:09 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AL9d5fm003929;
        Mon, 21 Nov 2022 09:39:09 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ky979csjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:39:09 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AL9Z4AJ012266;
        Mon, 21 Nov 2022 09:39:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3kxpdhtemk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 09:39:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AL9d4Lc2359964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 09:39:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11B38AE053;
        Mon, 21 Nov 2022 09:39:04 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAF66AE045;
        Mon, 21 Nov 2022 09:39:03 +0000 (GMT)
Received: from [9.171.18.226] (unknown [9.171.18.226])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Nov 2022 09:39:03 +0000 (GMT)
Message-ID: <e0be8e13-8e89-92b4-dac7-b52af387fcbd@linux.ibm.com>
Date:   Mon, 21 Nov 2022 10:39:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using
 KVM_CAP_HALT_POLL
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-4-dmatlack@google.com>
 <64be9403-b46f-3805-35cc-d1b6656709da@linux.ibm.com>
In-Reply-To: <64be9403-b46f-3805-35cc-d1b6656709da@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cX_nQWwuWvwu-SitJtrRLKuvi7zhWl-T
X-Proofpoint-ORIG-GUID: 5ptoFjcu1VDkZctHdiuFw3VsCPSu8oa_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210074
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 21.11.22 um 10:22 schrieb Christian Borntraeger:
> Am 17.11.22 um 01:16 schrieb David Matlack:
>> Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
>> rather than just sampling the module parameter when the VM is first
>> created. This restore the original behavior of kvm.halt_poll_ns for VMs
>> that have not opted into KVM_CAP_HALT_POLL.
>>
>> Notably, this change restores the ability for admins to disable or
>> change the maximum halt-polling time system wide for VMs not using
>> KVM_CAP_HALT_POLL.
>>
>> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> Fixes: acd05785e48c ("kvm: add capability for halt polling")
>> Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> One thing. This does not apply without the other 2 patches. Not sure
> if we want to redo this somehow to allow for stable backports?


One option would be that Paolo, when applying uses the stable
syntax as outlined in
Documentation/process/stable-kernel-rules.rst
for dependencies, e.g.

      Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
      Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
      Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
