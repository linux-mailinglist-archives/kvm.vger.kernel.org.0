Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C594C3C9896
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 07:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhGOF6F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 01:58:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6752 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhGOF6E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Jul 2021 01:58:04 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16F5XYWN088105;
        Thu, 15 Jul 2021 01:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Fi9hQjQUcA9Hyz7d7/Ubs0EUDvS2qcumowwBVxCMS6o=;
 b=byT7k4zODNuXgKXLNocgLKqAWDLiQJrym6m53CGCgZX459ZxMDRCzgL+LVd7b2yfEli/
 r+CSVNLRT+vF0G2PMRMq1MVECIBVJuz6ujqWAKjF8NvsgZJlrsKZvPe+RDkUDvNCngp5
 N4NyYnD7BcwbBZOucZoRlNz8Nd/B3YpPSih6AQiP50k/d3UVxSYENu+B4p5KbfufzhIB
 25N4JHDg6NRCmw8Ti6FRLbak03em0S0pz/0aZ278Vosm4DJQgrbopNklQDPLe57l6zs7
 mydwrP/Fv8etufGu05QGWrn5HXQcW2n4/mCpfqKuGviwel6A8tfeMHKUR5BwDb9BDAc6 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ssjy9u7k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 01:54:54 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16F5rhHq002689;
        Thu, 15 Jul 2021 01:54:54 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39ssjy9u6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 01:54:53 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16F5n495015801;
        Thu, 15 Jul 2021 05:54:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 39q2th93qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Jul 2021 05:54:51 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16F5sn7j34079072
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jul 2021 05:54:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDDB1A4053;
        Thu, 15 Jul 2021 05:54:48 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90AD7A4040;
        Thu, 15 Jul 2021 05:54:44 +0000 (GMT)
Received: from [9.160.50.212] (unknown [9.160.50.212])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 15 Jul 2021 05:54:44 +0000 (GMT)
Subject: Re: [RFC PATCH 5/6] i386/sev: add support to encrypt BIOS when
 SEV-SNP is enabled
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Connor Kuehl <ckuehl@redhat.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-6-brijesh.singh@amd.com>
 <3976829d-770e-b9fd-ffa8-2c2f79f3c503@redhat.com>
 <866c2a6b-8693-a943-fb06-45adf2cdcb92@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <cfa95bf4-9d20-8d43-e6e0-6e5b9752d27a@linux.ibm.com>
Date:   Thu, 15 Jul 2021 08:54:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <866c2a6b-8693-a943-fb06-45adf2cdcb92@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IAfuLmj2Ukorpr1e2ZZKc-sEVJSo7q1O
X-Proofpoint-ORIG-GUID: c4F22pNZyhf2ATb2VkDUy-zczwePk0-d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-15_02:2021-07-14,2021-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107150040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/07/2021 21:52, Brijesh Singh wrote:
> 
> 
> On 7/14/21 12:08 PM, Connor Kuehl wrote:
>> On 7/9/21 3:55 PM, Brijesh Singh wrote:
>>> The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
>>> image used for booting the SEV-SNP guest.
>>>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> ---
>>>   target/i386/sev.c        | 33 ++++++++++++++++++++++++++++++++-
>>>   target/i386/trace-events |  1 +
>>>   2 files changed, 33 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/target/i386/sev.c b/target/i386/sev.c
>>> index 259408a8f1..41dcb084d1 100644
>>> --- a/target/i386/sev.c
>>> +++ b/target/i386/sev.c
>>> @@ -883,6 +883,30 @@ out:
>>>       return ret;
>>>   }
>>>   +static int
>>> +sev_snp_launch_update(SevGuestState *sev, uint8_t *addr, uint64_t
>>> len, int type)
>>> +{
>>> +    int ret, fw_error;
>>> +    struct kvm_sev_snp_launch_update update = {};
>>> +
>>> +    if (!addr || !len) {
>>> +        return 1;
>>
>> Should this be a -1? It looks like the caller checks if this function
>> returns < 0, but doesn't check for res == 1.
> 
> Ah, it should be -1.
> 
>>
>> Alternatively, invoking error_report might provide more useful
>> information that the preconditions to this function were violated.
>>
> 
> Sure, I will add error_report.

Maybe even simpler:

  assert(addr);
  assert(len > 0);

The assertion failure will show the developer what is wrong. This should
not happen for the end-user (unless I'm missing something).

-Dov
