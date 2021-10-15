Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D942FD09
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 22:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbhJOUi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 16:38:28 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:21088
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232036AbhJOUi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 16:38:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe4/yKJndVWIAh+pwzKJjH7lcI3VkdIjxKA1XIbx1DSgBTKJ5xJeTjhLkz9j3F5lmNv3E7x5AvD+3xomxZYF8rrD76pCT6gHrMA1/JvzBJeGpxGBODQWKkyE/vKASA9vFBlZzneKOyFP0aEjetRnC9dRAz5wZL5v83T54E28ohobEN+Mwq9cfNg3EFyuD5vJPJNmKf8aHlKaMQojR+6spvqkwsVH9YFENZq5spHwwjkW6dqyJtOO6C4WM3PM5MGMRnWhvcNv/VWHd/GGt0caNDE04OsvgM5BK7LCYs54ZOehnU1gB0uvVoWWnqEpyqOkG+D6D7ayPyWj/fPWKfqbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9Lr4EzFyIKy8DaGyyAww0sfAaQlWSbepQ3jxvVETMk=;
 b=jf3QniX3DBh9hv4jHdOKjHgJ+RB4zDQ1PxsZT5K8VHENeqFS8Dx46lcEZSp+Oxk75334BRwhtNvf31zp/mlm7P/YLltnt9kcZ+RQ7dVkNa8VAivSPfZqd/tsPY1kEOF0Hur6Iq1nfoRyX28uPcUS40HC0Yf1a5r9GCP47vvg054qDQy9SJnRoNs7uhqO8NzFXgE/QS+isNJ70WxfYZ90ba4F4CccsaoQ6BwXBYNXBxcnDbPHzu3AzetjOZTj6IjtYFWJoZ4UmFoU3ngrDTUngmvS2kRvjw2+7qHQR3TBWGXEhaZFfNLk/0ZwTrBXzsZgqoqoHQOoikKAebemsOOrzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9Lr4EzFyIKy8DaGyyAww0sfAaQlWSbepQ3jxvVETMk=;
 b=5dOWigfKw4RZuFJ0UySwOKpABUD4C+Iu3vBFrZD6ECNUa+rS8R0Xtuvvt3QP/4+m26MAtnPrKELpvdx6MYgjUO33gN3jzdKSf/r5UQHZFc+u59B/gBQJKUaQSFGBi5VMx+Pq/cNnfBh3cNkkZ/XF/oxF9Qw1+r8MjazjpAiLSNU=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2413.namprd12.prod.outlook.com (2603:10b6:802:2b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 20:36:17 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.032; Fri, 15 Oct 2021
 20:36:17 +0000
Message-ID: <25a0711a-8d33-9e9b-d9cc-8618971db4cd@amd.com>
Date:   Fri, 15 Oct 2021 15:36:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 05/45] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-6-brijesh.singh@amd.com> <YWnC++azH3xXrMm6@google.com>
 <3fc1b403-73a1-cf2e-2990-66d2c1ecdfa3@amd.com> <YWnkMXdL89AHPF10@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
In-Reply-To: <YWnkMXdL89AHPF10@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0085.namprd05.prod.outlook.com
 (2603:10b6:803:22::23) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.0.0.5] (70.112.153.56) by SN4PR0501CA0085.namprd05.prod.outlook.com (2603:10b6:803:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.9 via Frontend Transport; Fri, 15 Oct 2021 20:36:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a695867-e57a-492d-7335-08d9901b7002
X-MS-TrafficTypeDiagnostic: SN1PR12MB2413:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2413776C18226F2262E16678E5B99@SN1PR12MB2413.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8RAed/H3MD+ASVC2eY50suCrPNGSXcUP3eDqp/ucGkmqC5b4flpKXp2X+wf8DasuAlahwEu0gPTn08NeCEX7tfDhkoO1xPSum8qcXJYMwiFSQJVkR2Du7wXofgAiW3e+JQDhggcbINryxPCc+8WsOv8CsZ8cIV6vhOQPC/uF8BmsUWlonvUWndJeI1NDdpGR6ApRnSfdvPbQCFhLMmvdKu2MGf8Ekr30W84laAdO+x4b1XOLkLRe4LkFAFZm5PXN1PkX2TjY54HrIa6mOCOxGU2iB1unO4yzIs2p51rcbn/xLLYbMwEvpHzUhUqaDM94xsia/D0zceqctIpvEaYfPmZa2gU5j2BV/HLDTZ0ZOGfbQD210v6rZHcFCa/OmQ/c9kVT+j/T1k2xB4nJzkTWj/xeuhWmtVKweg2yop1xw7TlkjYkQoGuKTUd/J31TBpT3QnNiTbBQ0dnDisNJomqjJ5o9QVaaHqt02aYE0M2Ca81KDDFsfAXw7/Mr233E3jCvbJWbKopiPBzKwOIojJbDGBIOsojRCd0NewTpZVM6n5HQiEmd9mQD4/zLxApqTOesxgB5H9XZhjO044CjzPCtiWZ2L/as4ubTBTtOGIGt2cL7580hyMXCpox7QyJILxpdAUP0Yk4nue535L0RZPpeYDAaIuaiKRLrH5E0OHqBEVzGl/y2c5SK7OHFSOsCqo+OA1Hy9FRbxHMdgza4U2PbQtXLIJNEvzIah29BlJUR3vonN2/N4crdjmC/3I8t+Dh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(16576012)(2616005)(316002)(8936002)(26005)(956004)(66946007)(36756003)(66476007)(83380400001)(5660300002)(66556008)(31686004)(44832011)(186003)(38100700002)(6916009)(7406005)(8676002)(508600001)(53546011)(31696002)(86362001)(4326008)(6486002)(2906002)(7416002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2VHWDlYMmJsSWc2NnRUV2NrKzFCUEFwU3Q5dERicjBybSsyb1lKRVJZUTdx?=
 =?utf-8?B?NDJQd1hWamZRZXZBNmIxMFZCMXJnZ3VrSUJuR05zN2RUeUZtYzdkY09DeDB1?=
 =?utf-8?B?MExpOXdRbEtob2RsYUZkQy9Mc0lZMTRPUmZNcUhaTlZOWlZqZzdjVzRTMm1v?=
 =?utf-8?B?UUExOEtKbmZIRXFGT3VFQkJzVnFYUmtBZENpejdzbjF4QUY3T3Z2a3Y3R0tt?=
 =?utf-8?B?N28rdHpvN3ZXeHBEZ2xpZzg1TXNvSWtyWVhISmhLMk9zT1RvMjl3eW5tQWxo?=
 =?utf-8?B?YUNRTm9sVyttY2J1ZWwyR2VzVk5peGpuYzN1MTBlYU5MbEY4ZXd2cEJwbkVs?=
 =?utf-8?B?NWhSem1pRExhdFo1VUsrV3BNdUlPSStjVlFJN3ExaldUcVA2c0ErYTZLMXRE?=
 =?utf-8?B?RjVhNjV5UGIybDdTdlhrY3dpMzF3UDZYU1FDYmlDZE1pd09SSHhsaVBnL01u?=
 =?utf-8?B?T20xcy9Cci9wOVpsQVA0U2pKZG5ha25wUDB5emtrSGtEK0ZsUzJ4YTJONVhM?=
 =?utf-8?B?NWpBbjFIVUVWcGtEK1o3U1V2WEVTQVJkeUhJVFlXTlRmSFNWNzRPYkZLcmRz?=
 =?utf-8?B?bGphZ1ovWlZidFRTeGY4L0gyLysrUnJIS3FYdlRrTXVaSTFuVWVxcVZWWHZQ?=
 =?utf-8?B?VDJhN1dVVTNkT0luL2tEM1ZnQTVia1dhYkFGbTQweG1WU3psMk45WFVrZkgw?=
 =?utf-8?B?TnMzZW5sMUNXQ0lhN2JDYzF1ckdBSVQzblBPN3NucDR5dlF3ME1pTmxhWG1q?=
 =?utf-8?B?WkNtSVpKWDRESEE4TXg4Mmp1S2FBb0RvbGxkVmdGNjVTeWMvNXFNclRHWG1I?=
 =?utf-8?B?UGwwK1N3Y3MzVDVIUDE4VXoxeFRXSTZic2RxNHVlaEJVMWNnWTltR1pZU1Bw?=
 =?utf-8?B?V2pYY09UVlNaL3p2NGNpeGZrTHFtUk5MOVFhT2t0MjBqdU96aGljRHN2c0Ux?=
 =?utf-8?B?YmtCUUo3UFRsazgvcDZkMFZIaHAxTi93K043dG5pcmRUcXo2MUNNWEJvLzZM?=
 =?utf-8?B?U2UzeWRvRFVFSkVHS21ReVk2dzRxc0VWaC9FWkxZaXlZQXVha2ttbkdYTzNm?=
 =?utf-8?B?QlA2RVNTSVVNb3BMbDE3a0NpOXpYSkwzR3pGSW8xS01CV2wvQkp0VENIM05H?=
 =?utf-8?B?R2pRN3o0eXBLNitRczhMbVRUekh5NEI4WlI1aER3RjJPcUcxdG82UHF2blh5?=
 =?utf-8?B?TWJXZ3Y5bllrYjVqOE45ZHQwVTJ1cXdkSXk4NlVpUDdYWHR5RzB0NnN0UW9X?=
 =?utf-8?B?SjhZL0wzWVQ2TEZsck9XTmExK1Y1RkNQdytwMkJzaFNmcVV6NVZhSW9EWm1s?=
 =?utf-8?B?NlI0Z0lldXllOGlRUUZoWDdSV284TDB3MkxGcDdLSE9jZk5FZk1IV1VzOGoz?=
 =?utf-8?B?eENlV0V3cENvZm14ZEVWQnhtSE5MYjN3RGQ5MzMybERrUGI0TnlBdktrMUdt?=
 =?utf-8?B?OFhmcTZSKzB3bVhON2s1a2d6L0E2SjdPUkYyeUxBcVdHbk5wbGdicHF3d0VD?=
 =?utf-8?B?UE5QNTFoZW5yT3ZuTDE2NFpHRTFGeHFiK1lWZGRzb1pQenRDZVk1QlF3dTd0?=
 =?utf-8?B?YU1jS3l2OEw0YUpqL0owRTRhNWljbHVRRnNJRkltSm5kbzZsQTE0ZHFCTWRI?=
 =?utf-8?B?dzJoY3hlN05aUFNycG04L0REa0NDUkdEbTduM2xqZVpEM2lXM1FEbFJ3ZXht?=
 =?utf-8?B?OHZ0b1dwVUliVzJZbjhjYWFDU1hzbHZjOXBDblJUMFdiRTNQa0lJWHF4TmtY?=
 =?utf-8?Q?5sKB3xH+y7XahgPJtgCnWFKUOtdeUt/I/6CPUVb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a695867-e57a-492d-7335-08d9901b7002
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 20:36:16.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9nQ34QbvnhzUxpFgLC0p8zAs/jEqo62hsAf//WDzbjSRcE7QJWnE4RazKCaFOAa4oCaBwD33VgIqByFcSv04g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2413
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/15/21 3:27 PM, Sean Christopherson wrote:
> On Fri, Oct 15, 2021, Brijesh Singh wrote:
>> On 10/15/21 1:05 PM, Sean Christopherson wrote:
>>> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>>>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>>> Shouldn't this be a WARN_ON_ONCE()?
>> Since some of these function are called while handling the PSC so I
>> tried to avoid using the WARN -- mainly because if the warn_on_panic=1
>> is set on the host then it will result in the kernel panic.
> But why would KVM be handling PSC requests if SNP is disabled?

The RMPUPDATE is also used by the CCP drv to change the page state
during the initialization. You are right that neither KVM nor CCP should
be using these function when SNP is not enabled. In your peudo code you
used the WARN_ON_ONCE() for the cpu_feature_enabled() and return code
check. I was more concern about the return code WARN_ON_ONCE() because
that will be called during the PSC. I am okay with using the
WARN_ON_ONCE() for the cpu_feature_enabled() check.

thanks

