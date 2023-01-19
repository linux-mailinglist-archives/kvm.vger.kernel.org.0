Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3952067441C
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjASVNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:13:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjASVMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:12:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C8A83E8;
        Thu, 19 Jan 2023 13:07:35 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JJxKIU011215;
        Thu, 19 Jan 2023 21:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=L+X3DXDCuhVM9Vcsx9GYVQBzF5Z+vgs3gSmPdnHr2hw=;
 b=p3ieh/FaVtY+yP8csbVHBjzEcOy+8MUCW0+AOCbq5+i+RezI7/HqBUho6f65la+joePE
 RZnmU3gEfPSWbnK/Br4zjjDKKrgFM9p18OV7nKqhU0Q9eJSx0Zr/ijAqjA5/L1QKd8bB
 jyK8EiLxAFckz2d0GE7P2Kxr+HtN5qjJMl/GeVzC4b/HCHDKOUVE2WAVJVXbHW1VtyQQ
 ztcEHgjl7V57MXf0Zx1rNh//8YUKjnvjUfldLbt2n+3AO0IIqT8Va8ccNJO2ni15MnPT
 MJ4nLEmfy+kpvWJoXeRkI8eIw96Rilkp6E8PmfM0e4AyjE10TOHkzoHLULxMjJT5n/gx +g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7cgm1ey9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 21:06:41 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30JKtsN1011348;
        Thu, 19 Jan 2023 21:06:41 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n7cgm1exh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 21:06:40 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30JItQhe024166;
        Thu, 19 Jan 2023 21:06:39 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3n3m17xf3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Jan 2023 21:06:39 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30JL6bxp38208052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 21:06:37 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A42C55805D;
        Thu, 19 Jan 2023 21:06:37 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44BCC58043;
        Thu, 19 Jan 2023 21:06:28 +0000 (GMT)
Received: from [9.160.127.29] (unknown [9.160.127.29])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 19 Jan 2023 21:06:28 +0000 (GMT)
Message-ID: <52e31e39-e384-3c5e-307c-652926275099@linux.ibm.com>
Date:   Thu, 19 Jan 2023 23:06:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <CAAH4kHYoWtM=Xe0kgmtKw01-45DefEikdLz0qUJRRMLdZHzkwA@mail.gmail.com>
 <e75569a8-6b15-780c-a7fa-945f1cce576c@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <e75569a8-6b15-780c-a7fa-945f1cce576c@amd.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VbAr4XuiHnxpbti04kJMcSjCudXmouKI
X-Proofpoint-GUID: 4DLi_8nYQcJkqJ4G3xq-1WEWs9LXQnQG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_13,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=892 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301190176
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,NORMAL_HTTP_TO_IP,
        NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19/01/2023 22:54, Kalra, Ashish wrote:
> 
> On 1/19/2023 2:35 PM, Dionna Amalie Glaze wrote:
>>> +
>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t
>>> req_gpa, gpa_t resp_gpa)
>>> +{
>>
>> Both regular,
>>
>>> +
>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t
>>> req_gpa, gpa_t resp_gpa)
>>> +{
>>
>> and extended guest requests should be subject to rate limiting, since
>> they take a lock on the shared resource that is the AMD-SP (psp?). I
>> proposed a mechanism with empirically chosen defaults in
>>
>> [PATCH v2 0/2] kvm: sev: Add SNP guest request throttling
>> [PATCH v2 1/2] kvm: sev: Add SEV-SNP guest request throttling
>> [PATCH v2 2/2] kvm: sev: If ccp is busy, report throttled to guest
>>
>> http://129.79.113.48/hypermail/linux/kernel/2211.2/03107.html
>> http://129.79.113.48/hypermail/linux/kernel/2211.2/03110.html
>> http://129.79.113.48/hypermail/linux/kernel/2211.2/03111.html
>>
>> But I don't see these on lore. Would you like me to repost these?
>>
> 
> Yes, please.
> 

I think it's this series:

https://lore.kernel.org/all/20221117181127.1859634-1-dionnaglaze@google.com/

-Dov
