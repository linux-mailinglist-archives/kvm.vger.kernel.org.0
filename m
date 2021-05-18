Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F76387BEE
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344884AbhERPIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 11:08:12 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:31841
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343837AbhERPIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 11:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXrfaZ8je2eo8lLRAJDgS2Yc5BKQfU2Hhk1pHazMkurwdUzgCscFFBxsyVDhhQsrQKJYN7VgZ0m8mV/4uMuTIrFqttwNNGr5dqJUKMs8Gad4BuHYgrONihw1rltTl+GvaPbqIB2mW3hNH2XolFx73PHelfFIhIpf10I6oNIUQdu3p3AWWDkqsfwcPP8VMh3+tMwL86qz0wUX73kmApKU5aJ1afDJR1VwdDBQGIVN67on6PFffOGA+P/a+W1zWI1d2scdhyyGRduu7iJFRh/HmkaGZiba0XFwzrAsS2rifskVnW3TKa/c8a91ifTcRFQuf1q6zuOuEP0YBDZ4o2rkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUl2OUJpG53WwgMA/wXWJysqxnfbiE/gECjORRXH3cU=;
 b=UpofbwSL3YL2JkGjUZvPt1N31huFA36Vuj7tPMdkGrsIiW9NVD0iCHaYJfkojHHInCeOMiNdhWz2cisxkl50QeZX314pXO2VG/Qt1ozc9/bE1GrZ8iQXnQDaLl6OaZ/9nItWdhXX+gLy/bUi0dVWZWyOIjUmK3VNpydcb893POkGLyGTkiDDUACrJMiVqufZv7gQqwm40zO7NvBN43TGqQAg7KyIvgn5AxlhI9V2kncGIvGSqZyxGzurWb2yu/3hWpy7YTyv2TusZ1fUF34PsjTiU7eqYDt8wQrjAzHRO7VkhTw6ErbhY67fFwEfs/zSXbUry6eA4/TYj5M8zkZqew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUl2OUJpG53WwgMA/wXWJysqxnfbiE/gECjORRXH3cU=;
 b=cc5mPZeFVLEvF+QA0Fb7CpaV14V9grRHz8Xm0Zsf/OyE+uNe9t9ogWdDbqVz34QXfsykw/ixqPNanM5w6M/HJdWszKRwWX+vWL/PVWdDl3w0e9ZVquu775mxQ3P4vTdghL27beLTnz9XVqCw/tE9Kx9esA80CaS//lPaarVX69A=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2542.namprd12.prod.outlook.com (2603:10b6:802:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Tue, 18 May
 2021 15:06:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4129.032; Tue, 18 May 2021
 15:06:51 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 05/20] x86/sev: Define SNP Page State Change
 VMGEXIT structure
To:     Borislav Petkov <bp@alien8.de>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-6-brijesh.singh@amd.com> <YKOZxMusqBLL1nP6@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <23f69827-4279-34ca-e8b6-655963c28c49@amd.com>
Date:   Tue, 18 May 2021 10:06:48 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <YKOZxMusqBLL1nP6@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0201CA0029.namprd02.prod.outlook.com
 (2603:10b6:803:2e::15) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0201CA0029.namprd02.prod.outlook.com (2603:10b6:803:2e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 18 May 2021 15:06:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87d41f40-742f-48cc-a56c-08d91a0e90f4
X-MS-TrafficTypeDiagnostic: SN1PR12MB2542:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25428A8E79B6DC99D31AA1AAE52C9@SN1PR12MB2542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHztSNlNHujwpZ7Jr0nvmvysru9qMdESORMvwMa2hX6S05BnbIT9B+0XiMDyqlpOQScI0Ut/PbJLMb2fneNwyfzrwRaEOm7n6+9sFz7Fo0X1+O2PJq1LfMFDYxX7USpTJ8JYf9iOWRj5p7mFR4TMNDVfXPHTGtXfjAns1i6Bg0GOu0DPpfrcJzcM8ldZ5rkefJ4zZ9aU03nr4J7zVXqEHKcg0i0Pr350Xkb4mbpxjgwPf19lh7uG/2Jiew8yejCnCMy31vTDbzWoM5ICqVf9GJCXXit9Ivw3MJf+LGNuAq6INk6ohJTsbLklqFSbSor4wMsdPmxfHwoFdRJVFI3A8ei2wGCoMxHhtloWOa6hlNErY8P7MroGlDe91AtzMmeKuFVvT3XEUPy9ERywvniTe4j5BDDXU2Ahz6b5dbbzz0ZMkD0+4nHv8U3BsTwv0n+AtqNpMIXmlYMT7xI/TnhPB4q5corcfH5Y+VorajsV6aJK2G+SW6fISdEXwoKcsHMJBjO09ZAYrts7h7AGQH+WjlROYf7mnld9017LS6au3wgywv38Fa4y4xvn263b+FCbejFYsCNSKQ8G+NJq62EcgB6/NhnDVVh75DZmpK0SseF4YzOnuEBtk4r1A6NREr5PpCimnHVRCP0SXHL7kOcA/taGJ5ifu4i8PDMnsA/AROjQLapqEsJmZ1cLLB/VRnW8wkJSfaitoR69fdDbcgysPsDZ99Ty2TTJubH08TCxJEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(346002)(376002)(396003)(2616005)(6512007)(44832011)(956004)(38350700002)(38100700002)(83380400001)(316002)(6916009)(2906002)(86362001)(26005)(66476007)(66556008)(36756003)(8936002)(186003)(66946007)(6486002)(52116002)(31686004)(31696002)(4326008)(478600001)(53546011)(8676002)(6506007)(16526019)(7416002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RHpLYm1LOUhWckJJc0JtWXMxclZBL3ZkaXhQT2dJRi9wSWtmZXFVWWNzUy9j?=
 =?utf-8?B?ZDN4WW9uMjQrTStTRCtoRnBzUUtGOGhJbVQwanRpdE5WYTVjTjlxQ3Byb3pz?=
 =?utf-8?B?ckJZZ2FaY0NSNXdZKzdhbkJWVXZ5a29pWERBeDNWOGx5dUlVaHhGbnJIMzJw?=
 =?utf-8?B?Y0NoWStzTUI5VnN0RkRTYlJmdG40WTI0NkpZbmszRVpVYllDM1FDNysvanVl?=
 =?utf-8?B?ZzVacE5XVDB3MmxBZTRGWGRWdHpFTkc5TzFjbXkrZFVEOStGRGt1dFhDV1Jz?=
 =?utf-8?B?UWRlKzUvVmM3cTg2VkNIZzJGTlNpeDN5c0ZReDI3QzRtaHBhZ055VmZ1V2l4?=
 =?utf-8?B?b1V0L1lsb0kwcllRaFhWMmVITmQvWjlHRXFoNDNzaHcwdWZ1TDJNQThpN3Iv?=
 =?utf-8?B?dVd5SWZSclNTV1VBcmt3TlpaTXpLN1Q4YXRJT3VZeVlZbGZ6U0JsSVpzU2hC?=
 =?utf-8?B?RnkzYkx0L1Y0UlRGRFlOemVCMUpNRzBrMjJGQ2dyZGJZSGFzeHJvSUFvVTcv?=
 =?utf-8?B?MGI2Tk9kVVJoNVlDQ2ZzcGZ4K01xOUQrd0cyZzRtVXhPZmhLOWhUeUgxLzZ0?=
 =?utf-8?B?blRyd0lXS2tiaHEwZ0V4UUJGcjBpMGtiSE5iWmh3c08zVFl5Y3ZSSzFscHFr?=
 =?utf-8?B?cGUxQmlrbWVhWW00blZOSnVNNUdnTmJGTi9nQndackl3MkttcVN6WEdReVRs?=
 =?utf-8?B?RnpSc0V4U0UyQTdXSHorejdsb1p5N2pJTWJQS04vSGNxZVZNNmgrOUIxMWJY?=
 =?utf-8?B?SnhCaVRTTW1BazVYVkh6STU0QlRNSmJOc0VORyt2RWMwbFl4ZURNUW9vc0Fn?=
 =?utf-8?B?VE0vaCtBcGxvQktwazBSQmlIMXJSUkw0Y0ZLVGNYMjREZ2hWUWdsODFWUGZ0?=
 =?utf-8?B?UDMrejhwYkl0Umd4dk9zQXVrQm40cCtlWkpPRG5SZTVzUDJuL1NOeXFjbFVZ?=
 =?utf-8?B?M3pDd3VBTEkvQTlhUXgrMFdoVWdPb2xCUll3V1dlTEZwZ3JvYXR6OGZadEVO?=
 =?utf-8?B?SzFKbGR5VjV2Z3RrMFhKM20zcTNtdnpMeldoVWZRbnZLU3V3N2ZWRGEwS3dn?=
 =?utf-8?B?NU9RalNGajNnbjNiTG5FMVBMTW9YdWRETUhUczBKK05TeWE2ME5XdGZRaWlB?=
 =?utf-8?B?TFlnTGMvM3BRQVk4blRCSERtaWpxMlB2MzRNWVdzNytPSjBvcEtpTm5rd3VN?=
 =?utf-8?B?Rm1zSXdUUW42Z2ZIa2I2bW1USUNIcVk3Q25kbjJlL09INUZ1Q1paajUzcm1O?=
 =?utf-8?B?bDAxWnIxNDdKdnFEUVdqcTduNWxkME1JeUtzY2N5dlF3NUVZQitwOVBuL2xE?=
 =?utf-8?B?VmNERXhWV2xFaHljcnA0ZEFJb0hva0FvRFZzcWpqbkd2N0tZOUZhaGlpellR?=
 =?utf-8?B?NGFIVDVQakl6cEFXQjF4aWx4MVlvNmFqVVhhMTcyMjBUSEM3Znk3djQrZjRx?=
 =?utf-8?B?OXErOHZqSngrQm5IV1hMUzhUb0k3VTNKVFhHZytjNzE0SEFHU2U4UzhQN0NG?=
 =?utf-8?B?alg1TGQvSG04ZjRrMGtnYnZGSnlLSndINDVjTktabkF4bEdGclpJMzN2VDBQ?=
 =?utf-8?B?S0lSMXNEdXY2UTRJMC8zcHE3TUNmODRwUmh3ejgrazZiSWYrR1RpMlJuSzhk?=
 =?utf-8?B?MFhEL0NHcnVPQ0JqcC9kdGlGUmwzeE5YK0tNSEpZUjJPUlNuQXIwZXNscXRC?=
 =?utf-8?B?eGhBMVBITlFGNGpWdnJ4U0RtTXVCM2tZbUV3NXF3VkFjbFlvWFFXbHh6RlN3?=
 =?utf-8?Q?396NsC7mzDm4iXa223RwwSKnRKW6JZ/r3qwH25F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87d41f40-742f-48cc-a56c-08d91a0e90f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 15:06:51.5241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MxItwskaISwfm8Y13oZGh4TZfleULPfNqLixLHG+FEcxkR1alf8mQ2KrbFwakwIfOdUK3DMch1zAWpp114VY5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2542
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/18/21 5:41 AM, Borislav Petkov wrote:
> On Fri, Apr 30, 2021 at 07:16:01AM -0500, Brijesh Singh wrote:
>> An SNP-active guest will use the page state change NAE VMGEXIT defined in
>> the GHCB specification to ask the hypervisor to make the guest page
>> private or shared in the RMP table. In addition to the private/shared,
>> the guest can also ask the hypervisor to split or combine multiple 4K
>> validated pages as a single 2M page or vice versa.
>>
>> See GHCB specification section Page State Change for additional
>> information.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> ---
>>  arch/x86/include/asm/sev-common.h | 46 +++++++++++++++++++++++++++++++
>>  arch/x86/include/uapi/asm/svm.h   |  2 ++
>>  2 files changed, 48 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 8142e247d8da..07b8612bf182 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -67,6 +67,52 @@
>>  #define GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION_TIMER		\
>>  		(BIT_ULL(3) | GHCB_HV_FEATURES_SNP_RESTRICTED_INJECTION)
>>  
>> +/* SNP Page State Change */
>> +#define GHCB_MSR_PSC_REQ		0x014
>> +#define SNP_PAGE_STATE_PRIVATE		1
>> +#define SNP_PAGE_STATE_SHARED		2
>> +#define SNP_PAGE_STATE_PSMASH		3
>> +#define SNP_PAGE_STATE_UNSMASH		4
>> +#define GHCB_MSR_PSC_GFN_POS		12
>> +#define GHCB_MSR_PSC_GFN_MASK		0xffffffffffULL
> Why don't you use GENMASK_ULL() as I suggested? All those "f"s are
> harder to count than seeing the start and end of a mask.
>
>> +#define GHCB_MSR_PSC_OP_POS		52
> Also, having defines for 12 and 52 doesn't make it more readable,
> frankly.
>
> When I see GENMASK_ULL(51, 12) it is kinda clear what it is. With the
> defines, I have to go chase every define and replace it with the number
> mentally.

I was still adhering to the previous convention in the file to define
the values. I will submit prepatch to change them to also use GENMASK so
that its consistent with SNP updates I add in this series.


>> +#define GHCB_MSR_PSC_OP_MASK		0xf
>> +#define GHCB_MSR_PSC_REQ_GFN(gfn, op) 	\
>> +	(((unsigned long)((op) & GHCB_MSR_PSC_OP_MASK) << GHCB_MSR_PSC_OP_POS) | \
>> +	(((gfn) << GHCB_MSR_PSC_GFN_POS) & GHCB_MSR_PSC_GFN_MASK) | GHCB_MSR_PSC_REQ)
>> +
>> +#define GHCB_MSR_PSC_RESP		0x015
>> +#define GHCB_MSR_PSC_ERROR_POS		32
>> +#define GHCB_MSR_PSC_ERROR_MASK		0xffffffffULL
>> +#define GHCB_MSR_PSC_RSVD_POS		12
>> +#define GHCB_MSR_PSC_RSVD_MASK		0xfffffULL
>> +#define GHCB_MSR_PSC_RESP_VAL(val)	((val) >> GHCB_MSR_PSC_ERROR_POS)
>> +
>> +/* SNP Page State Change NAE event */
>> +#define VMGEXIT_PSC_MAX_ENTRY		253
>> +#define VMGEXIT_PSC_INVALID_HEADER	0x100000001
>> +#define VMGEXIT_PSC_INVALID_ENTRY	0x100000002
>> +#define VMGEXIT_PSC_FIRMWARE_ERROR(x)	((x & 0xffffffffULL) | 0x200000000)
>> +
>> +struct __packed snp_page_state_header {
>> +	u16 cur_entry;
>> +	u16 end_entry;
>> +	u32 reserved;
>> +};
>> +
>> +struct __packed snp_page_state_entry {
>> +	u64 cur_page:12;
>> +	u64 gfn:40;
>> +	u64 operation:4;
>> +	u64 pagesize:1;
>> +	u64 reserved:7;
> Please write it like this:
>
> 	u64 cur_page 	: 12,
> 	    gfn		: 40,
> 	    ...
>
> to show that all those fields are part of the same u64.
>
> struct perf_event_attr in include/uapi/linux/perf_event.h is a good
> example.
>
Ah, thanks for pointing. I will switch to using it.


>> +};
>> +
>> +struct __packed snp_page_state_change {
>> +	struct snp_page_state_header header;
>> +	struct snp_page_state_entry entry[VMGEXIT_PSC_MAX_ENTRY];
>> +};
>> +
>>  #define GHCB_MSR_TERM_REQ		0x100
>>  #define GHCB_MSR_TERM_REASON_SET_POS	12
>>  #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index 7fbc311e2de1..f7bf12cad58c 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -108,6 +108,7 @@
>>  #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
>>  #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
>>  #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
>> +#define SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE	0x80000010
> SVM_VMGEXIT_SNP_PSC

Noted.


>
>>  #define SVM_VMGEXIT_HYPERVISOR_FEATURES		0x8000fffd
>>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>>  
>> @@ -216,6 +217,7 @@
>>  	{ SVM_VMGEXIT_NMI_COMPLETE,	"vmgexit_nmi_complete" }, \
>>  	{ SVM_VMGEXIT_AP_HLT_LOOP,	"vmgexit_ap_hlt_loop" }, \
>>  	{ SVM_VMGEXIT_AP_JUMP_TABLE,	"vmgexit_ap_jump_table" }, \
>> +	{ SVM_VMGEXIT_SNP_PAGE_STATE_CHANGE,	"vmgexit_page_state_change" }, \
> Ditto.

These strings are printed in the trace so I thought giving them a full
name makes sense


>
> Thx.
>
