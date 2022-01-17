Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981A7490EAA
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243447AbiAQRL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:11:27 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50100 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241764AbiAQRJX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jan 2022 12:09:23 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20HGbSWp011503;
        Mon, 17 Jan 2022 17:09:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZjjBenFnD47YAKERmNfbBqZ8noj9M+u7EEX8vKmo46s=;
 b=cfy9REJ6KfCjNHLn9HGN+QADqvGAPvl2ObJzh5vtntPC/RzhBIsHx6GGY0EG8EOe/3Ut
 IvOlXWBB+3bIhBeh26cEj+2ExEPEnU4wJQa7K15xn6vApepSuNVTzXd2YrulRfTZpwZy
 8XSNqTHqAzXHM/7rq81x3PQ33KlKm9UW3RysZnrPtUFXtnJDU6E3RpdC4Hz/OV6OCcO7
 z4Dv+Y6wyQtRqXVPBlnO60TqvDv3d/XACKRv76dQ/IOdDt209kMWkSdHJw9REBZLqFHJ
 EXsyAJh/bHab3tujPxKFdP9dipdAyS57xUCA7Z6JcAsEC7rf0wBM9gpF6oYne6PBLxxu LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51825x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 17:09:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20HH5w6O035604;
        Mon, 17 Jan 2022 17:09:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by userp3020.oracle.com with ESMTP id 3dkqqm2f09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jan 2022 17:09:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR/pUYgxkyIpmonJqhf40V1QzosmaZhnGNxKZgp9cjY2hLc6yQ0EC3SAmd3+TiJrpPtZ8oIw61hllSEMW7+u8GuQ44JQHEztBzGzrC72HEHSTLgsBo5z39AOyXgCICe6ohqQ5//RVehf2pvVz6zJv5pfPbxsOTsWHfpok05NEJ6IQU8Ne8eqAJNZjXRn5nixbD/b0EFGXXoUIzpRNRLFZEOXwvAHk7FtJF6hW2DX6sP/EPzXQphqL464MUuRiElz6xk85MZwO1LQjeIodqHVnu4ZxQZmLgzp8SWuBciPJF5GC/B4q0TB43BVbe6he5oiykG5pDltv85umMyNOVHOJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjjBenFnD47YAKERmNfbBqZ8noj9M+u7EEX8vKmo46s=;
 b=h2Y7BCizAWh7aG1thDNa9tTQ89RITi9GUQxa4E2QAlwgFiBVzAexJbJv5/kcgwaOInqExpMvxdEzaMeBlXIdg5tEzooCRADu/xOUaqCosVb1DFUBcMmDAbAdQH1X2bXQ0mSJqDxSIqwQtsUWOaLMrBFEUl7ahMUbUlPnGJ+dLymazqk57WIswM7rOuq4pruaZUwGsnSCAsDlc4Wt/DcLLa66zIiy7ml1wVuF8hJuyJmwhhVi9qAFpAk0/ppbW1NbdYFnJsT+W/atweFfsIMkFRuG1bQPreYgYlMJkfiw+YJ9C6nrkg1b/lyubx8qE5ElJMxHSFozuGGnRyDKFtwTbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZjjBenFnD47YAKERmNfbBqZ8noj9M+u7EEX8vKmo46s=;
 b=hXMtnZ0J9yqBUFxTUBzkpekDIddyybN0GZPGtMJApfPEo82+jwu6MLehnb27a4EROl0HVZl1zLsQw8nJRPypkG+hKIqovMs2T0ZsLTYC5nkJI83UZB8Te/87Z6YVInBRokFuGT6uxM2UOxbQ3ET5VigE0+9ywBfECwpfrmxu8BI=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DM5PR10MB1771.namprd10.prod.outlook.com (2603:10b6:4:8::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.10; Mon, 17 Jan 2022 17:09:09 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::5cf2:f465:3a2:3ac4%4]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 17:09:09 +0000
Message-ID: <fcf4c5c8-aa13-11bf-ec6d-1775b3bd9cd2@oracle.com>
Date:   Mon, 17 Jan 2022 17:09:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Query about calling kvm_vcpu_gfn_to_memslot() with a GVA (Re:
 [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20200417163843.71624-2-pbonzini@redhat.com>
 <74de09d4-6c3a-77e1-5051-c122de712f9b@oracle.com>
 <YeBZ+QcXUIQ7/fD2@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <YeBZ+QcXUIQ7/fD2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0268.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::16) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1791e55-0a4a-4d4c-df2e-08d9d9dc132b
X-MS-TrafficTypeDiagnostic: DM5PR10MB1771:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB177140C8D7ADC1FD36545D1DE8579@DM5PR10MB1771.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0gSHx7X4p/KEPJtdlJXR0eTCRoa92Oziw6OYhxKRmqbI7RknN0ptF0TfitjwpQIXuU2x5sf4XXGZXKBL594CbkY8F4RvCoMo116zC6fexOqPsUSXy06rCYzESr7+xxqgGlLW1f6KIHh1eXLeb2GKeCchrxNWvVugCrmgkMKpU1WEXmqcP5Cosohi4zqBfJj0dUQ+QbOCRKQLOhLYVbNc/MjoiQqqg6H9hfEnbfto/dZyI+rc/HADrG6exDHG6HNOpkZ1UFFhMtGZrb+BTP06b5dRZIP9Xkh+x9AZNcQg0ZglxExCNc01KrD78IkBC1LH2N0yz5rFEQ+VSkPTon8DTNmpY3bh7vFa5fd7+db5/J3N5qK4E1oxbOlBvGl+ZH/oT937+DD/qP/S5csAGPxAArY2zY6yz6JD9173wB4hfH+M76tt+tgusV3QnA2c6El+3LHmj+XxphQ4RQC4K5qBG1urrzxXkSwZDD0Q4fdW2Fo2h+BpHpXOns/+GrxqWlp8ngWk/cbbD/eGVW7jjHzfFVU7cR+SJPPLbZRE9ffCy9f2F5VktfY/vw3wLyZ1JUxBGCLSt534JCxBWzDSkvELB8/2bE7EEnBo82vtNSKclOLOz5YUHADXxQBIF69TrDWnyXrbUh6kAlsYUDGMT/Cjma7rV0SeAGL0GdDoVEeN4M0tUCjjqtxIY2nUPy6W+qehANz1ChbDh1b6bsZTo1Liaje7vrlQGWYeUp514/2j+zpHR95IRFcm3trUsImOMTl0a+oXI49qRqsSMAybNrNow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(6486002)(8936002)(316002)(8676002)(38100700002)(38350700002)(54906003)(6916009)(83380400001)(6666004)(2906002)(53546011)(6506007)(66476007)(66556008)(107886003)(52116002)(508600001)(6512007)(26005)(44832011)(66946007)(186003)(31686004)(36756003)(4326008)(2616005)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0pXU1Y3bHVJNjVzTlFwdXM3NlVkUDJHQzFrbmtLUDRiRjNMUG9UNzBzVWdM?=
 =?utf-8?B?Ykp0c0VUWmtGK1VlSE1BRlVHOXFLTlFWOGo1MXNTSHJwcVEzQUN6RzMwbmhr?=
 =?utf-8?B?TFI5aUtxbnFJWkgzSFdUT3dENWd3UU9KaUlXQnhMUHNhbHQ0elQ4cEZTa1BE?=
 =?utf-8?B?ekRMb21jTGtLRlp6YWthL0F4Zy9lTGZLK1BDdzZ5bFVEcU8rMERqLzJtOEls?=
 =?utf-8?B?SmcxSGJ1Y25uQ1BSYUgrMkNIUkVlemhNNER0engwMSthK3hjcmdNNHVGamxm?=
 =?utf-8?B?UTgxQTlPeHh0UStnTTk1cnFTR3c2QzlWUXo2Y043eVY2WFBRbU9YVFhubUh1?=
 =?utf-8?B?RlJsR1Z3MmtHZm1GQ0xScDFXYmM3Nm1hV2ZuS0hmTFZkRnNhM25vZmJrQkdH?=
 =?utf-8?B?cGJWa2YyMnc1YmFSUUZQS3BsNlNoUEhhbmRLbkNQcHdZU25weDBLU0V0RTJB?=
 =?utf-8?B?OVZFWm9ZUmVka2ZVZ0ZZR3hISjk5UVh5T2hvRTZqdG5NTFg1ZEJqbEdOTVJx?=
 =?utf-8?B?bCsvd0lwRngzN0QzbzgzeFRXTmhtSWpYU3JUbmpLMUc2aUdBQkIxRHV5K3dz?=
 =?utf-8?B?VC9RQmpFYTBuTGtaQnNoaUlsOHpYSXFTYkFQN3Ezc2x2Z0krRFFFdWNzQ2kw?=
 =?utf-8?B?TStzMW5WYmZaeWI0bXZtZ1lqTUVCTzQwVjVZSmsvU0xVNUxrSHpHUDN0V21S?=
 =?utf-8?B?b3NvZG1nUGljNWdjVHRzQTRob0IyZnRoTUViM2NBS1B0RlRKTy9veFBHT3FM?=
 =?utf-8?B?ays1RUhIVFpoQThreWpTUzlZbHJRZk1udmJrc21xNmV1VDF3L1F3a2gwdGhJ?=
 =?utf-8?B?VDhNVDJGZ2xNTlNTc1pEUys2Ris4dkxnbzhZZHNqV3dqMnE4WHhxQ0J6Tk0y?=
 =?utf-8?B?YmVtaUtRNTZaaTBybGMwc0NxTTNVZU9DbXZJbEVVQ0pZYlJmeFRTVm1GeXl5?=
 =?utf-8?B?OVgwWHkrL3k2N0RjQmwwL2hOazdYandoMnlOaE1lOGhwRnZROENkQ3owWmJr?=
 =?utf-8?B?Q2pUNlNxa1dYbXZSU3hlRkZlUkcyZGdFT3d5ak4zWDZRdzlHTUtwTm1BOXY0?=
 =?utf-8?B?REZKS3JPZ2QzSStaRzlGQjIyRXRTOHMzT3BPKzhScytwUlhEeDM0emxkQXhS?=
 =?utf-8?B?eVhyKzZwcisyNWVHcjR4ZnNsVDVZS292UUd2bnozUGF3SDZPclpnZGtOTUhG?=
 =?utf-8?B?YUc3dEloV2dlaTVwdmtYRnFHdlE3U3R3NTljd1pPUFVsWXREd3VsTjhuY1ov?=
 =?utf-8?B?TDYyOHVSVWNrM1Bacndhc3NFU2FSTGowY1B1QzVUMXJ2dElhVWVsMDYyek1o?=
 =?utf-8?B?dXJDUnJEck1nZmRrSm5vUG00QmRoOXJiSFAyVldRNnY5NDJNc0UrMGxLTGl0?=
 =?utf-8?B?TUlwcUJQY2x3eTNHeDhoekpvN0k0TVpPTzNLRU50OUhzQ2NkWkZkRFVlU1hL?=
 =?utf-8?B?V0JRVmlGWGs4Z0RaM3hKSHQ4SkRJZVNLdFRFNXdGVDJhK09HaXR3S09WNlI2?=
 =?utf-8?B?YWlnU1pUWkJMTFlzeFNiR1lIcHFxU0VBSjhQR0MvcDhuaXdBQ0pQdHpsdWdx?=
 =?utf-8?B?M210VVlEaU16bmp4eGRwVGtSdkF0TjA3WHphNkxZdnQrY1hiZkVxN3ZXK24r?=
 =?utf-8?B?SXBHVkxQek1IY2NMckhsR245UlRuYlM1cDRaUDNDMkdvYkRORmxFR0JZRVQ5?=
 =?utf-8?B?NWNwWTV2WDVubU1WZUYxNnRMU3NTRWt0Nk5FbnlVcHZWYXQzWEJLU3RhK1lv?=
 =?utf-8?B?cTF6bTVVRnd0TURmOWFCZDlVMjBIVzRHZ00xYTdQUDIrUnZpRmxoa2ZnRmg1?=
 =?utf-8?B?dEpTSEY5NUJ5bmV6WERyVHpZTTF1TDZDeWxTeFJreksyOG5leUNEMkwrc2Vk?=
 =?utf-8?B?U3ZlK1MzTmUrTk1CUFZCNXZWWklsTEJtRkNUdTF2aktMbWY3dVUzdnNNUXpy?=
 =?utf-8?B?MXFvb3BtVUluTktnS1FvVzZoZFVCTEVnRmRTbUZ4QlcweklPd3ZNajk1U0Er?=
 =?utf-8?B?M2xQREpNUHRlcTVHclJwV2ZhWlZibDUxN3U1dEkzM2VsZTZOcGY4OEY2ZjVZ?=
 =?utf-8?B?Wit4ajFGYzVsS296TXZVZ0RwZ3hjcmJzOHVVWEVjTmJUcXJPRGYvRjdiUlVq?=
 =?utf-8?B?R0VrdlNmeTBveThvd2JkT25aNW9yUDdaQ1dYT2VvS0hleiswTWxybWJOR0dJ?=
 =?utf-8?Q?aAtdWGTKikR8KbqYPh6kX+0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1791e55-0a4a-4d4c-df2e-08d9d9dc132b
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 17:09:08.9653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZANEO86k7xHDMeAjgGnzCId7fexCaEuwxSNY/NbqUGoYPO5ujJswjaLtzuTQY1XZctdNg1/Vw+RGIQIJwE7Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1771
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10230 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201170107
X-Proofpoint-GUID: nPKnLd0f-GsxMeGwB8jbStsiGqZwsGEL
X-Proofpoint-ORIG-GUID: nPKnLd0f-GsxMeGwB8jbStsiGqZwsGEL
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/01/2022 16:57, Sean Christopherson wrote:
> On Thu, Jan 13, 2022, Liam Merwick wrote:
>> On Fri, Apr 17, 2020 at 12:38:42PM -0400, Paolo Bonzini wrote:
>>> When a nested page fault is taken from an address that does not have
>>> a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
>>> (via mmu_set_spte) and kvm_mmu_page_fault then invokes
>> svm_need_emulation_on_page_fault.
>>>
>>> The default answer there is to return false, but in this case this just
>>> causes the page fault to be retried ad libitum.  Since this is not a
>>> fast path, and the only other case where it is taken is an erratum,
>>> just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
>>> common case where the erratum is not happening.
>>>
>>> This fixes an infinite loop in the new set_memory_region_test.
>>>
>>> Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe
>> zero on SMAP violation)")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>>   arch/x86/kvm/svm/svm.c | 7 +++++++
>>>   virt/kvm/kvm_main.c    | 1 +
>>>   2 files changed, 8 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>>> index a91e397d6750..c86f7278509b 100644
>>> --- a/arch/x86/kvm/svm/svm.c
>>> +++ b/arch/x86/kvm/svm/svm.c
>>> @@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct
>> kvm_vcpu *vcpu)
>>>   	bool smap = cr4 & X86_CR4_SMAP;
>>>   	bool is_user = svm_get_cpl(vcpu) == 3;
>>>
>>> +	/*
>>> +	 * If RIP is invalid, go ahead with emulation which will cause an
>>> +	 * internal error exit.
>>> +	 */
>>> +	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
>>
>> When looking into an SEV issue it was noted that the second arg to
>> kvm_vcpu_gfn_to_memslot() is a gfn_t but kvm_rip_read() will return guest
>> RIP which is a guest virtual address and memslots hold guest physical
>> addresses. How is KVM supposed to translate it to a memslot
>> and indicate if the guest RIP is valid?
> 
> Ugh, magic?  That code is complete garbage.  It worked to fix the selftest issue
> because the selftest identity maps the relevant guest code.
> 
> The entire idea is a hack.  If KVM gets into an infinite loop because the guest
> is attempting to fetch from MMIO, then the #NPF/#PF should have the FETCH bit set
> in the error code.  I.e. I believe the below change should fix the original issue,
> at which point we can revert the above.  I'll test today and hopefully get a patch
> sent out.

Thanks Sean.

I have been running with this patch along with reverting commit
e72436bc3a52 ("KVM: SVM: avoid infinite loop on NPF from bad address")
with over 150 hours runtime on multiple machines and it resolves an SEV
guest crash I was encountering where if there were no decode assist 
bytes available, it then continued on and hit the invalid RIP check.

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>

> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c3d9006478a4..e1d2a46e06bf 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1995,6 +1995,17 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
>          vmcb_mark_dirty(svm->vmcb, VMCB_DR);
>   }
> 
> +static char *svm_get_pf_insn_bytes(struct vcpu_svm *svm)
> +{
> +       if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
> +               return NULL;
> +
> +       if (svm->vmcb->control.exit_info_1 & PFERR_FETCH_MASK)
> +               return NULL;
> +
> +       return svm->vmcb->control.insn_bytes;
> +}
> +
>   static int pf_interception(struct kvm_vcpu *vcpu)
>   {
>          struct vcpu_svm *svm = to_svm(vcpu);
> @@ -2003,9 +2014,8 @@ static int pf_interception(struct kvm_vcpu *vcpu)
>          u64 error_code = svm->vmcb->control.exit_info_1;
> 
>          return kvm_handle_page_fault(vcpu, error_code, fault_address,
> -                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> -                       svm->vmcb->control.insn_bytes : NULL,
> -                       svm->vmcb->control.insn_len);
> +                                    svm_get_pf_insn_bytes(svm),
> +                                    svm->vmcb->control.insn_len);
>   }
> 
>   static int npf_interception(struct kvm_vcpu *vcpu)
> @@ -2017,9 +2027,8 @@ static int npf_interception(struct kvm_vcpu *vcpu)
> 
>          trace_kvm_page_fault(fault_address, error_code);
>          return kvm_mmu_page_fault(vcpu, fault_address, error_code,
> -                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
> -                       svm->vmcb->control.insn_bytes : NULL,
> -                       svm->vmcb->control.insn_len);
> +                                 svm_get_pf_insn_bytes(svm),
> +                                 svm->vmcb->control.insn_len);
>   }
> 
>   static int db_interception(struct kvm_vcpu *vcpu)

