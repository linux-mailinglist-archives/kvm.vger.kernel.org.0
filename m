Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C423526909
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383260AbiEMSL2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355221AbiEMSLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:11:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B88D562DD;
        Fri, 13 May 2022 11:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZnSKQNVqqIT0A2LbHecyb7ORgYy1XeRHDt7JMEux6Dwk7Wo0j2/zbJpMl5N6RfVknkyGvTSndrHelm50VIwjnVPJhoAH85vNuuIQTegiYskomkXKuQ/BR9pNcoAxIyfZmQQvTZBt10eL7tWHnYf0NDBIidCjDTjt3lGSzL7l+lsEY5q2gZCBuxVNaZjEnz3HTiUwT8XuwlfuyzUnrbGxH8uxgijg0cLFszUdj91TFxljexZ5QbPfEVWMcEhQyVmozLTxQlqabRqTou8bHeIkQ3s+rCQfbKFbe/UXkZsUiplHOw4Byf5ZI1hzQJQHXVQ90O/rKJ2K1lUgGtJkiuVwQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGFc1BjDvP8R2BfhH/V4ktNlbfCN+rCz/8g4EMejUzA=;
 b=Z+ICtuVzkIjn2VQeVnavvvRm9p33zxYjQFRiCHJFiz4V2IF1flvW1Jl9rKbf9bXJ2y6XK/WoMDOBS21fo/Oa1SL3LamhWs+wX5oDDYBfksK/y/A92A81kAYKN/MxaDlPjThV6bNDdx7stzrRfKjNo2rU1a1t0oD7AKteHrAYJD9tPKn5/lB02ugtml2TKsGiQuI4D42ersxjHL5ya44bdPFW575U6k2H9RCYifxJEVlUXC8P61a0aBMYAYTFmtoes8iS7lC1Q3k2wAPesXCUZspTq8IeXn+HWnl5Ap4nlojVu0FewsaRqMjE9xmx+vMaShurKwCgsD+7h4GHqQnSbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGFc1BjDvP8R2BfhH/V4ktNlbfCN+rCz/8g4EMejUzA=;
 b=AIninimO97HQQIu/IvmcA9x1mgrzZvQf9dFofPt1gtqijjMXMPLowm2QSU8cfCOW/Xy+c0Vbwfa2IzHoKyY0IyiH8e9617XwVQ81iMUwuXNXWb57UEb+fdwMe6HZINzDY+mEaeyqzpvXsubB2LPwUfvu1CVX2+bIV/4/33g44/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 18:11:18 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 18:11:18 +0000
Message-ID: <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
Date:   Fri, 13 May 2022 18:11:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent
 kernel memory leak.
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
 <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
 <Yn5wDPPbVUysR4SF@google.com>
From:   Ashish Kalra <ashkalra@amd.com>
In-Reply-To: <Yn5wDPPbVUysR4SF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:610:e7::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de4e8831-48c1-4822-0e0a-08da350bfa0b
X-MS-TrafficTypeDiagnostic: DM4PR12MB6302:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6302D7A47AF7681FC00E88328ECA9@DM4PR12MB6302.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /wesFWCOsHFP0zKq2sZUyTS6TIh9NY0JiqBs4qMPbOz49KTqNDFYJorS6OwgJAB2r9bHdXClkrdceKcKlw4pzq9Hbsp+39IeTstIGN5WxQplGviJNd8BowP0Pp7pvb42p/xWbrrdImejYd4eZq/8tFhC1tFFUWUWaWyrkpsAK4kcCYxpM6qbEKsJgSeaG44uFZFvjDA9aIv4TnOfppMmb0LG6YT5QWqcmWSQcXl580YD8uVPSdYs9X94APCcC+jFo059LdsffipGM6STHUKdsFsymr4IMZarAhSL14A4XdmTCKBvrevH6ZEchV4SLL4BzziNeZsT9MLZipYsMupiVTIr4UhVYUsWLOhyixdP3hLbxyOsRLM734cwl3on62/cEtJ13GJI9XPTzIIe8osHFp4bZdizYz2V5miHfF1EGkX4ibBxnS8xXzGRPLnR1XEjWqJQ8iXdyDo/P/bXC42PH0RBG9a1Hmbcgx9JnIHE7VF+/UEaFSiGn3lRnibaUHXqu8M2g6Sq2QedCnDiELxFRztq0tLTanpJSoWGjpzTPup5tLNE8l4ixkozqoz0QBIJ/QzJ8Hfy9LLmnl4Aqx9u0tBob4a8yyMu2cIzpcQGzjmpYQJRz1rK0FFC42kXj7ztSjmV128cAYKEysLq1tiHN5ckGnCCBStEqCk5CR/5SVLd0L7cJlwM6WLDNLpe8neVx2xKvX6yXDyaDyywQlIE8nKWZtkH9irgqO67Jxk545g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(2616005)(7416002)(8936002)(186003)(508600001)(31696002)(4326008)(83380400001)(8676002)(66946007)(66556008)(66476007)(6506007)(53546011)(36756003)(31686004)(6666004)(6486002)(26005)(6512007)(54906003)(110136005)(316002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTBIU0ZIUVE4VTZDSlduUmFLbHQremJQQnVSUnl4UVhWT1lnZ0JFRWZMNyt4?=
 =?utf-8?B?VDBDMTRwUHEwbWh3eFNlb1diOFVqQnArNm5VMFdsYVFsZ01qZFQ4ekUrQlJ2?=
 =?utf-8?B?bDRkcE9GLzdzaGJ6TTMvZDFWdy9RbjlLTFpWdWVRcFYvd1Y2ZWdnZjRoZW8r?=
 =?utf-8?B?U0JTOHdyZkQ2a2JEUW4xbWNLRXFYL09RTnVEcWFPSXZWL0xBNnlhK05CZVV1?=
 =?utf-8?B?SzBwbU5sbnFITmlIeEpvdlcxQlpyR0JkYUNjU2lLRUZnVTlITHJJV00vZTZ4?=
 =?utf-8?B?TlY4bUF4TE4xVCtlM0x0TzdNN0pveUhzdVVWL2twVHdBWkFjR3R4Njh0ZWZG?=
 =?utf-8?B?d3RaU01EZEtvRm9HcXQrbDNLZm9KMUJoTWQ0Q3VUQ0lvSWQzekw0TDg4S3Ji?=
 =?utf-8?B?eHQ1ZjFqRzRuekpQNEo1cndsWUxyTXRxdzNjVmxrYlZ3N0NFWHRraXBXS1Vv?=
 =?utf-8?B?T29ENWlnNUJXeVRTMXVFUEZFY2dLeG9uazVnUTdmL3AyNnBOcGZXNGtMWjQ4?=
 =?utf-8?B?U0RGT2hCNExKaC9jZXdoaDVQZ0U5TjZtNUFJT200RUJHdk9DdUNhSnhNdUcz?=
 =?utf-8?B?ajVucXBqNXY1bEM2dTF5RFEwcHg0Z1V6VVBtSmQwOGsxY1dNYU1PcFliS0JH?=
 =?utf-8?B?SHpqdmhGWjFqUzNERk1tNEZna0dEY2dNU0s3SkU1TGF3ZTZueTJicGRTQUY3?=
 =?utf-8?B?WlBZVDk3azhKQkVkWlpyLytrTUtlYnlOWkFnT3Rmb3hUN0RkRnBPQTBrdEpL?=
 =?utf-8?B?OWEvVm9SQTBwNzltWFpUM3Era2JLdEt5OXlPQnFXem9wZTVJeTRSeXF1ZXBa?=
 =?utf-8?B?RGJzcHVtVlAxOXVNUVZpQkJqdm5kbzJZQVVhWTdVMlQ1d3ExQXQzUXlET25h?=
 =?utf-8?B?Tll3dE95VnNtZSs5MzRmUUpSY0FnRklhUHFpcnlDMHFDbUc5eE9BMis4TWtN?=
 =?utf-8?B?WWFmZHZ1WHBFeG9ZckVDRnBkdFkxQkt5YmQ2M2dZVWtFYklGYk1pVkxqMnVy?=
 =?utf-8?B?RjB0Tkppalc1YWNSbXlzYWNJa2RsREE5dFpLV0dmWTQwamE4MDk2M0pFT0Jq?=
 =?utf-8?B?TVYwajFQdkFERnZXalJHQmNUcjcwaTVPeU53eGU0QkZEMmUvUEZyV29aTVBy?=
 =?utf-8?B?NGdhcHk5bEx5b0E0aTdIUEMwOVJqSk0wMVpPbDdhaTZBRHJTOGlWbTNkZUVP?=
 =?utf-8?B?NTk4TEJNei9TUlFjTVVPMnhQYmFqTkZnMHJaRXR4cy81UmtRZVgzQTN4Rmdl?=
 =?utf-8?B?VU10cDJ0N2lBbUo5V2NVODcxSkpOYllxaHVMMUxNQnQxY05hV2VOWGd5ZmRv?=
 =?utf-8?B?Y0Y4Z2pJTFlsUXhYUEFqVlZ0b2JlKzZsTWJ1dVpwN1VINk91eVIvakVnaWti?=
 =?utf-8?B?Ukh1dHhxNFN6US9BOWV1NE5JOFdxUEI4YmFWakd0QTFYam1rdmY5dWU4b1FS?=
 =?utf-8?B?KzN5SXlZU2Z5SzlXcytjVHAvRDc1R1BQZ2FPendZbEU2Y2xCblI3OVM0MkxW?=
 =?utf-8?B?WWgyOUZuekVndlVPK25mS3o4SGhKNlhXNGFSdTJPcGJDbGlqblgzTGcrdDlE?=
 =?utf-8?B?ODZNcDdmVVNDR2IrKzFqVDdodjdwc2VFTXJZZ3gvQ0RMbVlmeUhrQzg4ZEV0?=
 =?utf-8?B?RC9OM3pqdHRLZGhveXBWYzJpSTRTSzlWUDJSU0NwaFJKQkpyT0V6NzB5TmpJ?=
 =?utf-8?B?MzJpQXRGRVZrZ0NPaWRGVWVlcC9wenYwVStzVFpjRzdnMjVqamV2ZFFNN2NG?=
 =?utf-8?B?KzdKWVNPWlV1UTdwSXJjTUVTb3VlVEhzY1VwM2Z2YVpYcUQyLzN1dlZRVEtn?=
 =?utf-8?B?MzF4bVNNYjJOZ0FqSmJqNlI3eHp2eGExUmNBeVhndVJaMEM3dEVFNkR1NTB4?=
 =?utf-8?B?OE5OMXpsYy9SckpMcmQ1cUVuOXk2Tk9od2RPS3RyZC9DNmF0SjkzOWl0RVJm?=
 =?utf-8?B?dGxxQ3I2NEMwT0N2dmlnTUQ3MGhmeGtqSTNqTUQ0VDVPZllKSVV2VWVITjU3?=
 =?utf-8?B?V2JWdjZyWXUzWm1Qcm5GaHNrMjZWcEIvdFBXY29GalpRekpBSzh2Sm41cW1r?=
 =?utf-8?B?MnV1SS9VUXp2eEF1bnhlMjI5djFDWFFoWGNVV3FHa3BOY0RnRVFYaGVEK1I1?=
 =?utf-8?B?VWcrRWVNZ2lZaVY3Zmd1cUtQVGllYzB1eXIxcHNpQVdvR0hsSzhURUpJNUtK?=
 =?utf-8?B?ZFoxN1pwaHlJRlNGNXZEeGttNXgwME1vVmVZbVROTGpNd2tzK0xtb3dJOG9l?=
 =?utf-8?B?M1c5bUpvVGJTVTdhOFY1OHZWQ0VxcnV1ZlRGMFVqcXptOUsyQThOd0k3N3R1?=
 =?utf-8?B?dG5hRmNEdzhGbUdqVkk4VGJGaGkwVGUyOElqV281aTBpdWl1TlRNQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de4e8831-48c1-4822-0e0a-08da350bfa0b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 18:11:18.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /C8bfhU2JVMBNVVfP2IJYb2gEfZzYro60rG/wC4yEMnLMqoHs0u9LeFcXPvVB4McCHKjPvkCxYtuUm4nuXPIiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean & Peter,

On 5/13/22 14:49, Sean Christopherson wrote:
> On Fri, May 13, 2022, Peter Gonda wrote:
>> On Thu, May 12, 2022 at 4:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> For some sev ioctl interfaces, the length parameter that is passed maybe
>>> less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
>>> that PSP firmware returns. In this case, kmalloc will allocate memory
>>> that is the size of the input rather than the size of the data.
>>> Since PSP firmware doesn't fully overwrite the allocated buffer, these
>>> sev ioctl interface may return uninitialized kernel slab memory.
>>>
>>> Reported-by: Andy Nguyen <theflow@google.com>
>>> Suggested-by: David Rientjes <rientjes@google.com>
>>> Suggested-by: Peter Gonda <pgonda@google.com>
>>> Cc: kvm@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>> Can we just update all the kmalloc()s that buffers get given to the
>> PSP? For instance doesn't sev_send_update_data() have an issue?
>> Reading the PSP spec it seems like a user can call this ioctl with a
>> large hdr_len and the PSP will only fill out what's actually required
>> like in these fixed up cases? This is assuming the PSP is written to
>> spec (and just the current version). I'd rather have all of these
>> instances updated.

Yes, this function is also vulnerable as it allocates the return buffer 
using kmalloc() and copies back to user the buffer sized as per the user 
provided length (and not the FW returned length), so it surely needs fixup.

I will update all these instances to use kzalloc() instead of kmalloc().

> Agreed, the kernel should explicitly initialize any copy_to_user() to source and
> never rely on the PSP to fill the entire blob unless there's an ironclad guarantee
> the entire struct/blob will be written.  E.g. it's probably ok to skip zeroing
> "data" in sev_ioctl_do_platform_status(), but even then it might be wortwhile as
> defense-in-depth.
>
> Looking through other copy_to_user() calls:
>
>    - "blob" in sev_ioctl_do_pek_csr()
>    - "id_blob" in sev_ioctl_do_get_id2()
>    - "pdh_blob" and "cert_blob" in sev_ioctl_do_pdh_export()

These functions are part of the ccp driver and a fix for them has 
already been sent upstream to linux-crypto@vger.kernel.org and 
linux-kernel@vger.kernel.org:

[PATCH] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent 
kernel memory leak

Thanks,

Ashish

>
> The last one is probably fine since the copy length comes from the PSP, but it's
> not like these ioctls are performance critical...
>
> 	/* If we query the length, FW responded with expected data. */
> 	input.cert_chain_len = data.cert_chain_len;
> 	input.pdh_cert_len = data.pdh_cert_len;
