Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8AF4010FC
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 19:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhIERKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 13:10:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:27826 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhIERKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 13:10:49 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 185H3XZ8078653;
        Sun, 5 Sep 2021 13:09:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7+n/rZHRyH7CtyhKb6AyYY/skow/1Nd/K7rY6sENMOM=;
 b=EqtdiRnyTNyoO+p3MdZRmCrQ62JV0SWqJCr9j0mVjJKaxfWqdkg5WbJMEfoz2ul3WQtz
 ubD4EoyZ+zZwLhCIY1fFk60yZwtSkmTJMKOi0KLqoKOvUTwNT6aGuIGLHSs7UJ4U1CkW
 gxt2Jwhxend4T3e+AvXx68JF9ZpJ2P2EhLzkh/IcUAUvtyoRzLr38BUp2Vlpm1xTHeo8
 2ICZ6KhaI5swIuccdD2luF0iKNwnzfKjf5nsfXNMQ6iQkNRXAwqU7Sa1S0Gbn2gwBWLD
 g2cEv8wA3TyMXwNlrwQtZZOuVzpu273iN6sF/WkdUQZhueUc6yIEUj8StIKoQPw/6Y7L 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avt02x2x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 13:09:36 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 185H4DE1082752;
        Sun, 5 Sep 2021 13:09:35 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3avt02x2wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 13:09:35 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 185H4540030039;
        Sun, 5 Sep 2021 17:09:35 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3av0e9a9c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 05 Sep 2021 17:09:35 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 185H9XTU37814764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 5 Sep 2021 17:09:33 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB13CC6063;
        Sun,  5 Sep 2021 17:09:33 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15157C6059;
        Sun,  5 Sep 2021 17:09:28 +0000 (GMT)
Received: from [9.65.84.185] (unknown [9.65.84.185])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun,  5 Sep 2021 17:09:28 +0000 (GMT)
Subject: Re: [RFC PATCH v2 04/12] i386/sev: initialize SNP context
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-5-michael.roth@amd.com>
 <48bcd5d9-c5da-1ae3-4943-4c3bd9a91c7b@linux.ibm.com>
 <c930872e-8c13-55af-f431-1c99dd277f12@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <43a0d7d5-442b-84fe-2a62-574fb96d6ea3@linux.ibm.com>
Date:   Sun, 5 Sep 2021 20:09:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <c930872e-8c13-55af-f431-1c99dd277f12@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iKpeSljVrPBvx0nb-3vw1Hs7BRryk6hM
X-Proofpoint-GUID: M9tw5ux46rpruvkoRUn6N3vg-pvz079w
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-05_01:2021-09-03,2021-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109050121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/09/2021 16:58, Brijesh Singh wrote:
> Hi Dov,
> 
> On 9/5/21 2:07 AM, Dov Murik wrote:
> ...
>>
>>>  
>>>  uint64_t
>>> @@ -1074,6 +1083,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>>      uint32_t ebx;
>>>      uint32_t host_cbitpos;
>>>      struct sev_user_data_status status = {};
>>> +    void *init_args = NULL;
>>>  
>>>      if (!sev_common) {
>>>          return 0;
>>> @@ -1126,7 +1136,18 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>>      sev_common->api_major = status.api_major;
>>>      sev_common->api_minor = status.api_minor;
>> Not visible here in the context: the code here is using the
>> SEV_PLATFORM_STATUS command to get the build_id, api_major, and api_minor.
>>
>> I see that SNP has a new command SNP_PLATFORM_STATUS, which fills a
>> struct sev_data_snp_platform_status (hmmm, I can't find the struct's
>> definition; I assume it should look like Table 38 in 8.3.2 in SNP FW ABI
>> document).
> 
> The API version can be queries either through the SNP_PLATFORM_STATUS or
> SEV_PLATFORM_STATUS and they both report the same info. As the
> definition of the sev_data_platform_status is concerned it should be
> defined in the kernel include/linux/psp-sev.h.
> 
> 
>> My questions are:
>>
>> 1. Is it OK to call the "legacy" SEV_PLATFORM_STATUS when about to init
>> an SNP guest?
> 
> Yes, the legacy platform status command can be called on the SNP
> initialized host.
> 
> I choose not to new command because we only care about the verison
> string and that is available through either of these commands (SNP or
> SEV platform status).
> 
>> 2. Do we want to save some info like installed TCB version and reported
>> TCB version, and maybe other fields from SNP platform status?
> 
> If we decide to add a new QMP (query-sev-snp) then it makes sense to
> export those fields so that a hypervisor console can give additional
> information; But note that for the guest, all these are available in the
> attestation report.
> 

We have new QMP response for SNP guests (SevSnpGuestProperties, patch 3
in this series).  I think it would make sense to add the
installed+reported TCB versions there (read-only properties), for
debugging/observability purposes.


-Dov

