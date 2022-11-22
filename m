Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226A663316E
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 01:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiKVAiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 19:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiKVAht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 19:37:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FD3C31;
        Mon, 21 Nov 2022 16:37:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Az2f7CszSmb4Ys/TGAgIyC+UDzwtPL400yh0as5pRTqXArFRh6xwMKIUk3O439GIedSYFWyYQOq8pcaJ00+6+EElmnSFymw2SkELvqlCzaOEGKTePZDUWlfBm1HfcVK1EJz2vsa+1HmXkIL1ira5qo5VQxO/C8/jdOhqTAmzkx6Pynea6QwFsFJPXnL1cXPThMIm50L1rmc/lxEWowiPsiQjDTmPkgemKz35/SEXPx5m2J/drCaCnODb50+M4LJTgTxCLrVrDDfMenk19gd8qy0Um5fuig7JnrT5z9o4PHYGxQ4swZvxIZSO0H40lugMTyyHV1vZWM9k77POfCcKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HreI4jtUtuy038xcIc33bu0MKJagnYaoATVeC7dapLQ=;
 b=cPEfz1QqS5KFaWHXuxobcOfPhwvKDYoPU+YPB3PG3x8py8/yVcfTCcPukwk/f2ttSNeX8GhJEQuVxtT24NPVPBFfUVDEkce+wOl3ztrwbvAEo1IcAD9Tv/DJYgE/KPld8BW4c64plW/kGFQnnmbNQYIIKts5t1yzelQljPh/sYkQgvFbjcJh1lj9bRXqK4bdqp3kMv5HqR6YUgPIFl97+2GMidqBr1W1YbOt2RpzP4Vx4XhiY2QkLaPHptPQ2IT2FNMU4WXelsnny6XubWAo7nSfN6CuV0qGyJy7Pdcg/E2EVtUm0Otntmpz/v0Qfy28n7P3Px6AMtW1LiwBMJLyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HreI4jtUtuy038xcIc33bu0MKJagnYaoATVeC7dapLQ=;
 b=pc90BuUcTkgAKkgDheEgsTX1JY9pnqhGPrcbEzFNjfknfB0gCUM3NlHsl4ZwfXsnaVDU4crRADDE8Dvyk/7JDJyYciPzZsawOExXY4unPwajoLH8sPy/JHgW4fL2vCmZCZ26BeUdrfFm2kEYNCOD7udI3zZJY8pGjgCJAAibHL4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 00:37:22 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::395:21e6:abfd:7894%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 00:37:22 +0000
Message-ID: <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com>
Date:   Mon, 21 Nov 2022 18:37:18 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic> <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com> <Y3qdTuZQoDZxUgbw@zn.tnic>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Y3qdTuZQoDZxUgbw@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0105.namprd04.prod.outlook.com
 (2603:10b6:610:75::20) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DS7PR12MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: 090f8403-8f1d-431e-d55d-08dacc21b86e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZqf9A1a7LeL0TW5SxwKNLC8xkoxzYjuTo4PEnz5fweP36lthAJfXOlederegIxbu9Becpoe6Ft97E5FnCIPxD9g0nLoRBLrUf+vaQ0zLSNE3RYYoJ5vPWDz1GK3ajtZJH/lyhBqGeEr2FQgG2gC2o5aRRdFn/DvfsWZdxCpQ2a5ctWj+P2re47sNaHLBQQKBmHd5ZQBmdKC9qE9ZS86J3KAwgAqxCd/urojlMPkZKNfEittHbKmc8h7ZrpBDbtudx1BU3Zl4xtFBJ25mayfSmrxzPLAk8MmmeyI5GbLU3Qr0j3iDtcrll6fzfWCtswnmkEsnYbLRus4tfmVAbhMbFZIe14nEzkAjULHDk01N4O+Sr40iTkVnzHjH3N419wwSiK98Pmqd4LdRPV+a5kDVzuigmNpyFlSDyjJ/5JzzJ9t5JjbdJgVBHEttP6ukjgWtjua6Z5ON8iqUjkUvcYCYQxNG2JzEviVX7V3hLW0vJLxaaOXCxmidWD6swAYuFdyKBTtBUrlkgU63/AW59d7mgSCWvOh9JT/wYvetvCnfRFMQnJsbiMeRmYOepKeuX9/o1YsFUjYSyEVHSmzcBx8l5MV1ixUoRUK0j9gmiQD9rpNbDNhAazfh06yNK4ZeDd7FqGqsK2AR2WdQ6THxgO34mN00fLVgPvyQkRoFlXBfBUy7NtY5PtVHmsMdi5cogBKmEEE3iEdp5OukRLwKloPHvaWKRmDGkY2u4YtN1Em0m4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(83380400001)(31696002)(86362001)(38100700002)(8936002)(7416002)(7406005)(2906002)(4326008)(8676002)(66556008)(66476007)(66946007)(41300700001)(5660300002)(6506007)(53546011)(26005)(6512007)(6666004)(6916009)(2616005)(186003)(316002)(478600001)(6486002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlNZT09vUUlsbEgvNTVYcW1VYzB2NmJnMll3UDhrUVorei9tKzlvcDB5M00r?=
 =?utf-8?B?NjJyalpjQ3VUM21ZQ1ZyTEFXR3JCcmFEU3p5R05BeVVrTURWb0lOUm9pcTZV?=
 =?utf-8?B?WkVKbWxPc1ZnR2JQM3JWOVVPTmM0Z2JUR001NkxIczdia3doZXdNN01HUHdL?=
 =?utf-8?B?WDh2bloreVVKSHdHZU9zT05xMHduOHBibSsyeElsMWdxU0ZQc1RmTi9pSzNo?=
 =?utf-8?B?MTEwcDk2TVgwU2NrUElYZ0pqeVVOdWtWc1dxTzJsQ3hzMjg5TUhaVjMyeE1B?=
 =?utf-8?B?eGg5U3FGMTBUUjhiRDRITm9ZNjJCMi85b3FkNWtnSEV6QnBxVlBZZGFZTWlU?=
 =?utf-8?B?N01JbXJUbjIwZlE2aGk0R0VyTWYxck01VEZaVW9ySi9OVHlxcXJGR3FDUzNw?=
 =?utf-8?B?MkJ2WXA2dmwyeDZ2TWxHRVNsL2NrVENDVExNSldNWU5QWUZJS1FQbFpXNXQ5?=
 =?utf-8?B?UVBsck1WYkRMU0ZUWmJieFpHY0E1RFFIWklmS3R5ZnlhR2k5d2ZkL2pzaldW?=
 =?utf-8?B?ZU1aallQUnRRSWxqV1RFTlUvK1dQcHIrdGQvSWxTTlZFYUEzTktSZDVuOFNu?=
 =?utf-8?B?N2g4VDZNV0VNL1BPampJOGF5ZVhqS0JuVjN0SlRzY0R4Y2FzQTh2ZG4zT0ZT?=
 =?utf-8?B?ZWR3OG1hMnV6VXNxbVpFTk1wS0xIcXBhRVY3VnUxSWlickJvM2ZJaE1mU3ph?=
 =?utf-8?B?RTFpVFQ3a25OR1pXU25qbWtCRDEzcG9oYWgzaHk5MkluK2s0MkUyKzdKK3Q2?=
 =?utf-8?B?ME1XSThtb1B5T3RsRlhWUnFoSWowVTA0c0s4Sm1XaTU4UVRzUXJEUW4xM3oz?=
 =?utf-8?B?L2hjZjVyV0ttNWtaWFRHWnVNeXpsYUJkd0tWMjBtNzBzREt4NFhGQkM5ZGU2?=
 =?utf-8?B?c1FDSy9JR0oySE1jdVdkdGxFemR4Qit6djJmbkhFK0htSmtJbmVQTk1aVHpX?=
 =?utf-8?B?OXZrWm01dktqdm55Um0rRXVUUEg4OUpQSDVuK3hBSUV1S0o3bHhHTjAxVEZk?=
 =?utf-8?B?UDY5bHFGbjJwNmVjTlg3SVFzaklhWm8waVpSNlpVSDNzTHlSY2JQR3dvZzh4?=
 =?utf-8?B?OE8zQThRRUNsRVJ2NlVkSjlwTWJ6VTBaNDZnNUxBV1ladTE3MEhIWitaMUF3?=
 =?utf-8?B?NXJxZ3lKNGVRMDNTbEVtNi9ZSTNkQWRXYndtZDE3YjM0S2pmS01Zb3RxdmUy?=
 =?utf-8?B?SThsZDQySVROQkhFUEE2OXJxU0dNWm1hMXZmSE53R0hCN1NXcS9ndUk2WGZw?=
 =?utf-8?B?emtGNFRPMkUvRi9LWmM0YzZ0Y28wQmZJVXFUVG82WkE5aTJpNU1Uc0JNeFFh?=
 =?utf-8?B?N3gwamhjbmFwTHJReEI2dkloRytxZHZ5SzdwblN0b0RNOG90Q1pQVGhLYW44?=
 =?utf-8?B?THhLVHd2aXI4N3Y3TFYydm9OYVJLTkJSNlJyWkpDcy82QXNqZlJoRXF6dTUy?=
 =?utf-8?B?OVk1SXhWYk90S21hS0pFNy9mN2w3dkR4RHBiRGRHSlBFZzV2T3JLSjI1a3FQ?=
 =?utf-8?B?N1pzaXpqTnora3k4Z0pPK2dKR3FEN3dxMEEyNFczMkVUeHJsZGQ3VWY2V282?=
 =?utf-8?B?cWpJMVMyRjZHMkVuak5NNE1EVGdyTjVnZzg4S1Rtd0lwT0xkbmEwMnl3cERM?=
 =?utf-8?B?d1I4Y09iZVNtTE9QdEhlQWd3d1ZLbDZpRGVYcGJrcUY3cWFhM0d0Y1ZpZnhC?=
 =?utf-8?B?cUhjeXN5OGowR1BVbStnMVN0dFRqK01Pd3l0SWdzSURLSHJTUFZwRnRaMkh6?=
 =?utf-8?B?L296QXpLNjhpK2dzSGw3aVRlbWNqeFRGYnY5WDROT1I5V0YvdGlZbkVrWXpV?=
 =?utf-8?B?dXJGdVZCZ0N6MEkwSHBjTVRwZit6YVBRWDVJWHp2clBWRFFvNjJPSVE4emhS?=
 =?utf-8?B?RTVPTWxpcVU3V2ZRei9BSksrbjNTWm9tOEt2R25QcnBFWVV1ZGt2eDlvWWZ2?=
 =?utf-8?B?K3N5Um1GSjVkUnNSb2pkQ05LR2JTckVwQzF5YkMzN0trSGdpZW1hTE9yNVd6?=
 =?utf-8?B?UDIwYzlzWms1eXNFdDA0NmN6YVVIMkhmZUtZUXlxZG9rQ3BZNHlrVFdrWERk?=
 =?utf-8?B?UDE2VlJBVkJLdElqdWlZWnhKUmhLMTltczJ3YTBjdDBvRlR3Z3R2SGF3Zlhy?=
 =?utf-8?Q?jmx4mUHkPx9Q8FmVGX1zVGZHa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090f8403-8f1d-431e-d55d-08dacc21b86e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 00:37:22.8011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nG1k7BBt+cRxHA1sv2a5gaSIW0f5favJ+Jig3RFkxcqmnzmOa1cJrpfdlm8VAl4VsaOuw8EUyp7R0dmdZDKHSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris,

On 11/20/2022 3:34 PM, Borislav Petkov wrote:
> On Thu, Nov 17, 2022 at 02:56:47PM -0600, Kalra, Ashish wrote:
>> So we need to be able to reclaim all the pages or none.
> 
> /me goes and looks at SNP_PAGE_RECLAIM's retvals:
> 
> - INVALID_PLATFORM_STATE - platform is not in INIT state. That's
> certainly not a reason to leak pages.

This should not happen, as there are sev->snp_initialized checks before
any firmware page allocation or snp page transitions.

> 
> - INVALID_ADDRESS - PAGE_PADDR is not a valid system physical address.
> That's botched command buffer but not a broken page so no reason to leak
> them either.
> 
> - INVALID_PAGE_STATE - the page is neither of those types: metadata,
> firmware, pre-guest nor pre-swap. So if you issue page reclaim on the
> wrong range of pages that looks again like a user error but no need to
> leak pages.
> 
> - INVALID_PAGE_SIZE - a size mismatch. Still sounds to me like a user
> error of sev-guest instead of anything wrong deeper in the FW or HW.
> 
> So in all those, if you end up supplying the wrong range of addresses,
> you most certainly will end up leaking the wrong pages.
> 
> So it sounds to me like you wanna say: "Error reclaiming range, check
> your driver" instead of punishing any innocent pages.

I agree, but these pages are not in the right state to be released back 
to the system or accessed by the host, because they have already been 
transitioned successfully to firmware state and the reclaim has failed. 
If we release them back to page-allocator and whenever the host accesses 
them, it will get a not-present #PF and it will panic/crash the host 
process.

It might be a user/sev-guest error, but these pages are now unsafe to 
use. So is a kernel panic justified here, instead of not releasing the 
pages back to host and logging errors for the same.

Thanks,
Ashish

> 
> Now, if the retval from the fw were FIRMWARE_INTERNAL_ERROR or so, then
> sure, by all means. But not for the above. All the error conditions
> above sound like the kernel has supplied the wrong range/botched command
> buffer to the firmware so there's no need to leak pages.
> 
> Thx.
> 
