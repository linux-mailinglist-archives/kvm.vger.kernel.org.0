Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503EF364D02
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 23:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhDSVZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 17:25:49 -0400
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:43136
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229714AbhDSVZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 17:25:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8MsvHyIMqTUQdOMnyhqf+4DKXwqKaiAefq4EbY5ErXCDCxE2Pjjxg/394ARvr4qfbYySsaHJqNzMymlFYaeOJQv/ppgSXterCCzrPgyKJ4k1hsg6DvS1YZiT27BShzqdnwurNaW6rK/332Hj5xawEJthsYaLeRWy21BSPLLKOY3iBcZRziAS8DK3M9hXWllDWm8DQ22I+/e0tdMUn/PoVmQu1MzipcnhWlz4KhPAwFdNSwyQqkkZRc5xRbSJHtTEg2trYfceDeEuvdaj5h8/8eSjxsYUGj72yx4zcMj/bpKe4VFFVXsovyfOa8re3nw7aBcIvWCyglr69y2WmIwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD2UAD570KKbSXyaSWQtZ4Y1OyV++WClyDH6nl9A8jI=;
 b=V6aA1QO+q8RRJYJnfywOzgE9AiA4xobrI/9fhZsED4ErTVnfBXq5ILhdOqtfBSu4QVe4zYsVbLuu3Y3ZzygU/H/4n9DbjrmsFViVDwXkm+suuzF3CEWhYky5T4t5GP1ZTwSgd3s+nfDEELlsKtINo58wnWcEfBSySeLAmzTxl9UWKoJjnSu2Yhcd9KzRw5w98jC/gLVCtoXEocZ9RavA/1jV0EgAXiMkiI9cEVte4rDq8NcOvdl6bf/qxnt7LkbQvIR5KN6H7laL2wgVHvl3x84qolGLbarvAKE+mR2Cj4HCyGjFJtXWinduoZ7PMi3/+nYLvsyVJi5/VOUcS86G+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lD2UAD570KKbSXyaSWQtZ4Y1OyV++WClyDH6nl9A8jI=;
 b=Jc4UorFq7Uqi0lUfp5WVR6SGxBKBoBWLOF2g2vrTLcdAKFdVoakgPrwVMpTL2rz4QNfmhfou1Pt439gfLuEBzeLTUGyq8Wtr60bNMZqUjYWR48CUS16OZ01l3ISBTO+YDXM2tj3VDk5D3uYwp1ujQF152d4CuN7XVJogEPjVpvE=
Authentication-Results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 21:25:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 21:25:15 +0000
Cc:     brijesh.singh@amd.com, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding the
 page in RMP table
To:     Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@intel.com>
References: <61596c4c-3849-99d5-b0aa-6ad6b415dff9@intel.com>
 <B17112AE-8848-48B0-997D-E1A3D79BD395@amacapital.net>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <0f0a14bb-b32b-f27d-79fd-63621155e8c4@amd.com>
Date:   Mon, 19 Apr 2021 16:25:12 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <B17112AE-8848-48B0-997D-E1A3D79BD395@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:806:122::13) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0098.namprd04.prod.outlook.com (2603:10b6:806:122::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 21:25:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6952790b-2a7f-4afc-1c53-08d903799f77
X-MS-TrafficTypeDiagnostic: SN6PR12MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB271808B2126BB23B47DCA31CE5499@SN6PR12MB2718.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lOsckxg89aLGcnk/hzvJ44Q7nbZWHjZhFk0t2TzGl3w3NsohAUj0EVvVoul8A2dTeYrM7HWgUGuHYbaudaMY6uV0ReSBZj4Cm7PRD9rSnmaAMo03B44EomsNAlZLBKblGqQ01fyUT8adjV4SmtGlByYazlMgQy+otI3DDf/8qSyqssFUlpFKxvHsKIi8v6bkM5ULQ1+ykJrhCbsoZXnmi5MjPXe57dzi00ltjxMI5uy5ew6LMnzRIudS4wpBLHioAiobxCyYMLFFTlIj9uxWqWiEwKtz7ca+OlUAt766IxCyRUGyh6cx7+RRBESsDs4Z7GsVMpX+WByfSSoLbPjjKfcQlN9iK+1UVgJtPoa9RvXoN29a+l/YIIYGX6jQE34RYwWnBKG6k9OT1XQ9IunYNtaklfVsjY+aAcU3f7ODuaXOoFSpDe6LL5Jv2fKHBY3pDbi4OHYSxQSJQ9OpFpgJdcPx3g4kjabNYKsLGmH9zMyn2IpQ9v3sN/awfYX9Pwa03eXWziaRVyvRTDOC8sygzmGQwMU0mlY3uRycpt4FERbXb0+TtgWN/N8ZpwoJqE0AQKLR8nMLm82jIZAmV1XF/NVTJSLvTQPhyq+JnlIvkFmOyCxCnyYECW4HL/d3N6YCtx6PfU9L1RFg4OnWrIa0XTMq31BLyj3eqbVA2L4OV93uJ0gQPPjgZr5AY7ymD7KKcoe17BLvG6G3hVBCC4sS9PFgsfLTH651xoXMMQgMmvA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(8676002)(7416002)(86362001)(6512007)(8936002)(31686004)(6486002)(36756003)(44832011)(31696002)(83380400001)(26005)(54906003)(4326008)(38350700002)(52116002)(5660300002)(478600001)(2616005)(956004)(316002)(38100700002)(66946007)(66476007)(2906002)(16526019)(186003)(6506007)(53546011)(66556008)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bjlRcVR0dWVGWHZMUWYwMGpYQWtNdlh1dk5IU1U5Sy9CNHBLbmQ1RlRBVG1z?=
 =?utf-8?B?SFduNVRkb2ZXcEVpcnVNQzlRYjdMUld3cUhIckt1RTNPMDNMcHN1RlV0T3dJ?=
 =?utf-8?B?dmg5Z0k1NlgzMm9GS3NxZi80S2JLcUJiZ044b25xRjJ3WDhaazNXMmhPTHFm?=
 =?utf-8?B?bHFmS2ZwczFqT1VnNEFHQ2FZU0NCZ2xnZHY2QlRYNkNYQnVSMFJuNFpFaUkz?=
 =?utf-8?B?Ry80WHJHczByeWtFWnRHci9La1h3SkNaSys4NTZHQldBb01nS1E1OTJYMm5u?=
 =?utf-8?B?L1BEaEVXdVo2VHA0Tk5aSzRGRWNPdFgvdmFBbVhqa2VkQ3VjQnZzcnF4WjNT?=
 =?utf-8?B?QjlxR1hRTG4xNm85SXNvRUhXakE0bzhkeUplUXhqeHdodENHN1lHU1dTVnND?=
 =?utf-8?B?dXg2cS9xMGtQZ3AvRWVxY2JqVFljaWlieS9ydlZlaW9GYjIwbFhKdWw3N1d6?=
 =?utf-8?B?dkZRVUVpWmtJbkhiZzRBaWEyTThiZVlXZFhWR1NnQUtmRmZUM3NnQ3N2K3J0?=
 =?utf-8?B?M04yUS9jRzdWKzF5QjVscVBMYnZXb20vTzMwS3JReXExQ2ZHdzNuVDFTSEli?=
 =?utf-8?B?QmtKYlBUaHR0MDZSNm01SU9ZVGIzN1NhSmVLc1NrczQ5OWZ0R0ZRc0ZsYWF4?=
 =?utf-8?B?L3JFa0ljWEFaZ2hlY0ZmdVZ2MzM3aHpiZE5lMjhuKzE3UURWYVM5QlNOSVI1?=
 =?utf-8?B?NXpaSEg3U2NMTFI1NHJGbFN0b0FDYnp3R2IxaGIzaFQ3dTU4SEMrQ0Vydktz?=
 =?utf-8?B?RnJMUE4xYUF3bmVSYWJnMDVOMnI0enh4ZnVLOTVVL2VvOGc4TUNZWXZkMDU3?=
 =?utf-8?B?RE52SkdzUXFCM3AxOEFpKy9HYUJ5V0ZWWDVkK1NjeG54ajJEZVlPSEV1SnRF?=
 =?utf-8?B?Mnd6VWYwNlBTcE9hSjQ1cXJpdC9SZzExT1N0REVSVkFja2ZGN29TYkV2MzVO?=
 =?utf-8?B?YUNpcTNNRWRvMzgxSncza1J6NlU1Z1NGWjZTdTBZREVUYk1ta3N3K3Z3STVO?=
 =?utf-8?B?MXl5UnFObXUvWnV3a2tYcWY5ejVrMG1VdmthUU9qdDFGdGpuTHdKV3RQcWdR?=
 =?utf-8?B?VkV4Z2R6eVpQQVE1KzZYMGNzaVpYWmU5K3p0TmRSU3NDRm1qK0VtVjU1MGti?=
 =?utf-8?B?RWx0bHI0ZEV0czdhTldueGJnOXhSNzd0UTREYnprYTAwd3UxMFJZdHk0MG9G?=
 =?utf-8?B?d0lnbVUvT0kvRlF3NWwxeGhPYzRXMFVHalhuL2M3ZGMzcy9NZXJZN1NGb1hF?=
 =?utf-8?B?TnFCckJRRFk1TzdqZzVmT1NYTi9jY25mUGZIdSs5NlFnWm5VMW12b284K3dh?=
 =?utf-8?B?VThHbnVpSXNvRGM4cnlIOFJwYkpieC9UVWlFTmdVVlIvRDlvb1FGa25vWm1k?=
 =?utf-8?B?UG53aGNRNjh5SHQzSTVqNy83Mk8yM2x6czF2VEFmdFpBVVJLejhtQjBON3g0?=
 =?utf-8?B?bVZkNGRaRWMwb3FHZlJzNDVOM2h1KzcvTFd0OFZkcTQvMnlZVmZ6N0dPak9h?=
 =?utf-8?B?akQyUHFkTm4zY3ZZYlUrajNteHFYRnhHSFk5SFpaTWpvUi9VSmRIODFidXM3?=
 =?utf-8?B?NEFieE1ZTVl4VFBlMEVOdlkxNGNOM2d3WG0vd0dYWis4aUIxenB0blJiLzVt?=
 =?utf-8?B?Uy9sVFVJUlBDMU9Odm5GTm0yZmNjellFUTVNNlpTOFRwUktCQWpENnFQbzRh?=
 =?utf-8?B?TXVhOGU0SUQ0amVKZi9rTUVvUHNXcldnWmo5SlFWVjk0WFBDckpVYXgyN2Qr?=
 =?utf-8?Q?Srodba15PTs2GsmgcUGp52agtiAGOkYapEgikqo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6952790b-2a7f-4afc-1c53-08d903799f77
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 21:25:15.3004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6y1bIuLZHe/gJrJeZTsTmu/GJk4WGD1t8BrCx7dje3hYdj+LNFvxfEQ9iCoXsSOtUOcb+vzPZbQHnKu0fLUrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2718
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/19/21 1:10 PM, Andy Lutomirski wrote:
>
>> On Apr 19, 2021, at 10:58 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>
>> ﻿On 4/19/21 10:46 AM, Brijesh Singh wrote:
>>> - guest wants to make gpa 0x1000 as a shared page. To support this, we
>>> need to psmash the large RMP entry into 512 4K entries. The psmash
>>> instruction breaks the large RMP entry into 512 4K entries without
>>> affecting the previous validation. Now the we need to force the host to
>>> use the 4K page level instead of the 2MB.
>>>
>>> To my understanding, Linux kernel fault handler does not build the page
>>> tables on demand for the kernel addresses. All kernel addresses are
>>> pre-mapped on the boot. Currently, I am proactively spitting the physmap
>>> to avoid running into situation where x86 page level is greater than the
>>> RMP page level.
>> In other words, if the host maps guest memory with 2M mappings, the
>> guest can induce page faults in the host.  The only way the host can
>> avoid this is to map everything with 4k mappings.
>>
>> If the host does not avoid this, it could end up in the situation where
>> it gets page faults on access to kernel data structures.  Imagine if a
>> kernel stack page ended up in the same 2M mapping as a guest page.  I
>> *think* the next write to the kernel stack would end up double-faulting.
> I’m confused by this scenario. This should only affect physical pages that are in the 2M area that contains guest memory. But, if we have a 2M direct map PMD entry that contains kernel data and guest private memory, we’re already in a situation in which the kernel touching that memory would machine check, right?

When SEV-SNP is enabled in the host, a page can be in one of the
following state:

1. Hypevisor  (assigned = 0, Validated=0)

2. Firmware (assigned = 1, immutable=1)

3. Context/VMSA (assigned=1, vmsa=1)

4. Guest private (assigned = 1, Validated=1)


You are right that we should never run into situation where the kernel
data and guest page will be in the same PMD entry. 

During the SEV-VM creation, KVM allocates one firmware page and one vmsa
page for each vcpus. The firmware page is used by the SEV-SNP firmware
to keep some private metadata. The VMSA page contains the guest register
state. I am more concern about the pages allocated by the KVM for the
VMSA and firmware. These pages are not a guest private per se.  To avoid
getting into this situation we can probably create SNP buffer pool. All
the firmware and VMSA pages should come from this pool.

Another challenging one, KVM maps a guest page and does write to it. One
such example is the GHCB page. If the mapped address points to a PMD
entry then we will get an RMP violation.


> ISTM we should fully unmap any guest private page from the kernel and all host user pagetables before actually making it be a guest private page.
