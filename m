Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 199426639BD
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 08:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjAJHLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 02:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbjAJHLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 02:11:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8F427191;
        Mon,  9 Jan 2023 23:11:37 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30A6779s013749;
        Tue, 10 Jan 2023 07:10:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=VSjizcn8Nb/xOdg7Q+9O05K2fmHm/gIFN2OnNbbP1i8=;
 b=mue/qpjaCSrVomTJMKLjamt0h9Ft6dHMYrvYNDV9VOwq+1sFfbZG3zOL+PcTc6uolLnx
 7/EGT0aErDKNSy/pJdzkq22PJxY/jKaXKs/kR4voMs0hgSNWMqv0AHvaZV4Tr/V4k6GI
 TOPKtBo82HKqjDEES0Ofe6q80Xg5eEw9FdR0RS18K8wKeujBzsgKgt4BYgJXLAIPDQtV
 VjkNNLQLjf2KUPaQJ6Bcl9xATrjcd02ETYMyqE6YzfOmsMutcu4PyNsNvqkWaOnDt6Cm
 s4HJWN0ZRK1MDV8NL/yjA43TWEcGhEcKwT3Hp3WRBabnHlC3p7ZfRCTknmBKsu1YsDba Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjkq4pp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 07:10:35 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30A6eGuP003606;
        Tue, 10 Jan 2023 07:10:34 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3myjkq4pn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 07:10:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30A4ciVf017136;
        Tue, 10 Jan 2023 07:10:32 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([9.208.130.100])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3my0c7rby7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Jan 2023 07:10:32 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30A7AVgm9044538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Jan 2023 07:10:31 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5544658053;
        Tue, 10 Jan 2023 07:10:31 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D303B5805F;
        Tue, 10 Jan 2023 07:10:21 +0000 (GMT)
Received: from [9.160.182.241] (unknown [9.160.182.241])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 10 Jan 2023 07:10:21 +0000 (GMT)
Message-ID: <a3ecd9fc-11f8-49b6-09a2-349df815d2cf@linux.ibm.com>
Date:   Tue, 10 Jan 2023 09:10:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-63-michael.roth@amd.com>
 <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
 <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
 <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
In-Reply-To: <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bxKKz1gst0IJ3EYH60CfHPJKPKe-mPqD
X-Proofpoint-GUID: fypJnNLW4fAKBlW0G-v3LX4iLGhYraA5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-10_01,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301100046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,

On 10/01/2023 0:27, Tom Lendacky wrote:
> On 1/9/23 10:55, Dionna Amalie Glaze wrote:
>>>> +
>>>> +static int snp_set_instance_certs(struct kvm *kvm, struct
>>>> kvm_sev_cmd *argp)
>>>> +{
>>> [...]
>>>
>>> Here we set the length to the page-aligned value, but we copy only
>>> params.cert_len bytes.  If there are two subsequent
>>> snp_set_instance_certs() calls where the second one has a shorter
>>> length, we might "keep" some leftover bytes from the first call.
>>>
>>> Consider:
>>> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
>>> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
>>>
>>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
>>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
>>> 1) & PAGE_MASK which will be 8192.
>>>
>>> Later when fetching the certs (for the extended report or in
>>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
>>> filled with 4097 BBBs and 4095 leftover AAAs.
>>>
>>> Maybe zero sev->snp_certs_data entirely before writing to it?
>>>
>>
>> Yes, I agree it should be zeroed, at least if the previous length is
>> greater than the new length. Good catch.
>>
>>
>>> Related question (not only for this patch) regarding snp_certs_data
>>> (host or per-instance): why is its size page-aligned at all? why is it
>>> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
>>> is never sent to the PSP.
>>>
>>
>> The buffer is meant to be copied into the guest driver following the
>> GHCB extended guest request protocol. The data to copy back are
>> expected to be in 4K page granularity.
> 
> I don't think the data has to be in 4K page granularity. Why do you
> think it does?
> 

I looked at AMD publication 56421 SEV-ES Guest-Hypervisor Communication
Block Standardization (July 2022), page 37.  The table says:

--------------

NAE Event: SNP Extended Guest Request

Notes:

RAX will have the guest physical address of the page(s) to hold returned
data

RBX
State to Hypervisor: will contain the number of guest contiguous
pages supplied to hold returned data
State from Hypervisor: on error will contain the number of guest
contiguous pages required to hold the data to be returned

...

The request page, response page and data page(s) must be assigned to the
hypervisor (shared).

--------------


According to this spec, it looks like the sizes are communicated as
number of pages in RBX.  So the data should start at a 4KB alignment
(this is verified in snp_handle_ext_guest_request()) and its length
should be 4KB-aligned, as Dionna noted.

I see no reason (in the spec and in the kernel code) for the data length
to be limited to 16KB (SEV_FW_BLOB_MAX_SIZE) but I might be missing some
flow because Dionna ran into this limit.


-Dov



> Thanks,
> Tom
> 
>>
>>> [...]
>>>>
>>>> -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
>>>> +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
>>>>
>>>
>>> This has effects in drivers/crypto/ccp/sev-dev.c
>>>                                                                 (for
>>> example in alloc_snp_host_map).  Is that OK?
>>>
>>
>> No, this was a mistake of mine because I was using a bloated data
>> encoding that needed 5 pages for the GUID table plus 4 small
>> certificates. I've since fixed that in our user space code.
>> We shouldn't change this size and instead wait for a better size
>> negotiation protocol between the guest and host to avoid this awkward
>> hard-coding.
>>
>>
