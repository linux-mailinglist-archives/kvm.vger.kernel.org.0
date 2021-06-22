Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A010B3B0A6D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 18:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFVQgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 12:36:41 -0400
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:25984
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229791AbhFVQgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 12:36:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZmX5a483zA/vObHmqyoneLZfPCIj98MPa+jxt4bHxJSJ27LyVQdWy22Uye1avbqDAa+kxUhfjQcfXz0QMyxM0cMEhMEcp0fza1vqRMhwd40lvgywagB13W11VRPo6z8n3aqOH92t4Uih20NGyXJSF/1cgfDAaBzdfZPogNN/jDX6WM4kampZKfZshjHGq1nz4fDQUoguK80x/K00MKThWZtFMkAztszyAH7sNpXQK6toX7cuAyUnq3oa43dtndWIOFK1l+y4FI6BFs5/dD4z+Bd+C4JGk+lPuV8vj6z7DJ84VQt+NeIAa38CbsQv11mZ8hLMVlL7vi13vutSB1DNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nClrXP5j4XxGdGGEuOxqe2egyO/ZW8EsBc1J2xh17VI=;
 b=DMMrhztnZuQ6xtXo7eqL+ImOQGw8ncaYChP/G1edhz5KxQ1lQO2/C3aZuoyKOw9CPR5X23F02VWJsDE6ej7/wLedUewNMrxLPIQE3HRr9JybXjhskSQH16CCbnxBUd9DJKZCXVVO6GHWtD0m6mVNWy27KkgWn4PjB1vphj3SVCClzOkfNBviEaO9CV6cHTGCFiHT5zJo88CHRj/uBP2XVTVbDrjIgh2Msu919ALHTh5dIBlmcGvlvRP0IqeV8hyUxeTS9D+S/F/32vpxVLDaoaf/3o7u8xmkOzzZ9wfA0NXPrLDeKVSCsVxsHzO/h677FriNZz4CCDW1be0HU3op+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nClrXP5j4XxGdGGEuOxqe2egyO/ZW8EsBc1J2xh17VI=;
 b=PStBlvWqcsaLHZmpSj0R1AaGO/gnf4gSiHY+clE4fkL9tGDpfYbJBWYo00rg5Wo7q4qo3MXx+Wiry8hNvHIMhKuOYTtep7ImC0cLBMQriwFQ6Bb+cWb/ljOqaCTaQH55MZJ7Y1uZAyZalKN5EsVkvinH50ivUl7jbRYqoYsIoFs=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10)
 by BYAPR12MB3302.namprd12.prod.outlook.com (2603:10b6:a03:12f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 16:34:19 +0000
Received: from BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed]) by BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed%7]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 16:34:19 +0000
Cc:     brijesh.singh@amd.com, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/3] x86/sev: Add defines for GHCB version 2 MSR protocol
 requests
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org>
 <a0d38ffa-e5dc-7e50-fc18-fc10ff19309f@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <e033453d-430e-17ab-ee2b-ee3b3e67c7b8@amd.com>
Date:   Tue, 22 Jun 2021 11:34:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <a0d38ffa-e5dc-7e50-fc18-fc10ff19309f@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SN6PR01CA0012.prod.exchangelabs.com (2603:10b6:805:b6::25)
 To BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.11.236] (165.204.77.11) by SN6PR01CA0012.prod.exchangelabs.com (2603:10b6:805:b6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 22 Jun 2021 16:34:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225d4b44-f72b-4ffc-9310-08d9359b955c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB3302DF0CC267857D22A0D85DE5099@BYAPR12MB3302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oI00AxXqFJcd8F4HDpg16000rv0MvILnk0VLnVZedqPuIb2zYK16N7xmD1bRJ85devyz0skHhfsu2GD4GBfoyfIkPZ/LjEqj3cNAW5tJB28cg0nroOwg9nhHUTWtml9rM1vZE7Ym9fXKrQ3B4VdfThhS5PEzJ7AB6Yc50fcdYk8LIjBg/jBS8WuhFqq8uJKNEwLxdlJf6y//hRLoJj0w4+bGJXouxfVtRnuob4EbN340dbfwOSRw6AcF62IFTtzN6RinEl1ZT0OAAI+wUeZe2iaQfivjK+2PIhoZ/wTicq+x02DzDUDF+uFC9G3gDo/WJGbP7+SVZUuqQAJ1EeO6o4JWBENiJjLKRiwkpyxFdkyZramndFEytwtJZSTUyzM4lXabdhfjljsp97H3vrxaEVNwfO+Spk4Z6esHY9pNhycUk3aakLEVVntD6osiVvNLv7yqWEjBdPHce1Ge40pnbtq87ylzd5kc+Q+R8nd8VWeVA7o9Ild6nRqcQ1sVmJDG51u+MUiee/TnOobvEj/wOxoiH7wEDq16utAdffmqJ8JZS3En4lawo1mP/n+jA46/3Qpud7bRND21auEg4idzER85eDgakg89/VqtBZtJEzMLto6zl2hKs7IFVyb4E49X6ttLyHHYJ0ZzWJPa/TybKpSESxhZt3CgziG+IjMnKempEzoTEgB6rJ1cMYzzw/4D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2711.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(376002)(136003)(16576012)(2906002)(316002)(44832011)(5660300002)(8936002)(6486002)(31696002)(478600001)(86362001)(31686004)(54906003)(110136005)(38100700002)(38350700002)(52116002)(83380400001)(36756003)(26005)(53546011)(4326008)(7416002)(186003)(8676002)(956004)(2616005)(66946007)(66476007)(16526019)(66556008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3FnLzdoQXZiMVNzeU1XUGlGalF5dnNKQ3hKcjg4Q3Nxa1dOQ2FFOTNCcFpE?=
 =?utf-8?B?VStRTERQYnhWZWZjbHJjcFZCcnRYVHhiWEZkcG5hQXVBRXV6TzNwR0Z6SXBD?=
 =?utf-8?B?T0luRVV2TGJvQjZ5eXYwTVV3eVlXa3BjL0VvaHllNS9UYmZxZHYxeEE1a055?=
 =?utf-8?B?VlZXdlBFQ3ZyS2QxMnRETWNUVGxQekNhalVIdlpkQUNiSFVieVoxeEZoZEYr?=
 =?utf-8?B?RzRRb3lkcG84WnZVVU02czdhNmd6KzlVbGxvV24zN1lQdFNjaE9Ob0VKWU9I?=
 =?utf-8?B?N0VNT2hoMndndklyN2VPN0RvamVxQkdOVXpTbGYxUm0yenhsV0pScGNYWkd5?=
 =?utf-8?B?Y2NqYTQ1WmZrOWl3eGJ0bG9ieERUdHZOeWZPeUdCNWZWVDFSeTJjSURmaE9w?=
 =?utf-8?B?K1VyM2xJZ0R6eDJwWUdjT0FsR3N6b1BRQzdOLzYrWVY1OEJFMGF4RGs0MmN0?=
 =?utf-8?B?aXVMVmVVQ2FENUNTM0hKeCtLTGpYcm9oVjJ6N2hMRlhEdFZOKzVRbTJtZ1ht?=
 =?utf-8?B?bTFKVnN5MkV6T0pLNGpHUWFpeUd6dkE3YnFzcHN3T2s2anhwREQ1OG8zSGJ6?=
 =?utf-8?B?UzJCbFZ4aENGS0kxWkVRdXFZTDBZVEVVWFdVenVIYWJ3YmxTa1hsTVIwd2JD?=
 =?utf-8?B?azBFMnJadUxqa1ZWcmJjbm16MVdpSU8waFZEdXliYndUKzlYWHM1RTNld1lt?=
 =?utf-8?B?ekRhZFdyYVhHSE9BVmtNREcvM1FQaFEvNG1UalRoS2MyM2lNQzEvV1ZYVFhK?=
 =?utf-8?B?YVZ5VDlOa2Myd2hmeGxOSUNiMVpsd0xpWnltNU9LZnA5bmtFNGNJL3MzWGN5?=
 =?utf-8?B?dHhNSThLeEdzNnU0S0JnYS92NTJVcUhoZ00vN1JGS1dYajJzUWVPdjQwRWk3?=
 =?utf-8?B?WUxiRU9UOU4wSTlDSnpRcm85eEFLbDB5b0Vld2RzQURXRm1TcVNEUmdaQ2Jn?=
 =?utf-8?B?RFhodGZGN2hCSlQvaURvZzUya2dOb3FqYnJXQkllSlN1b21aWkN5Vm9uUGh4?=
 =?utf-8?B?cVZtT1VuSFpLczFHNG1mVFhJam1LWk1yYVVPME1Eb1FZQnFKdWtDbXg5YU5m?=
 =?utf-8?B?N3hhM0l1QmJjR1JNM2hSVWp5YzU0MXhVSVp3Yy9LdXpteFNvMG0xMk01NjZw?=
 =?utf-8?B?MTZYakpqenpER0srT2lIOVVNOVg5S0I0WnBRdFNPNFFwdldhU0NiT1YzNlNw?=
 =?utf-8?B?VGZIaVhidVA5eGYyekNoa2NxNGZwcEVJUE81Zkw3RVRPSDllSFd3K282cHc3?=
 =?utf-8?B?c2R1bjdFU05SSktjZitmSUZmc2YzaHAzR3M3N3g4MGE5ZXNFeUVvczVnbCsv?=
 =?utf-8?B?TC9QY3dIa2VQTWwrSUFPdHo3OTlhT1F3enhKdXRNYTA2Q25qRFFOTnBrZ2hV?=
 =?utf-8?B?ZFo5Q1IxUG1CWXZHaHh3RzBlN3RtWEJGS1kvMERQbXBEbG80WmxSeC9PcTdI?=
 =?utf-8?B?VEp0SkJrSzhWRGZway9wWGZyOGphQUlCeFVvbTg4VW03eTdFV25VaG9UWDZY?=
 =?utf-8?B?OUkwK2wyMEhwWmtRYk5RWnJZT0czT29jczBjRzRuZGFpdnYzaG9RL0dQT3lr?=
 =?utf-8?B?dlNENlA2Uy9HVHB4bkZGaVhFRTdqb3JWTThyRVkyYkdrNWpQcVZuU21DVGZr?=
 =?utf-8?B?NWg1RzVienF1dmRJMHhvT3BkYkdMZCtRZ1doa1RSSXBtdWtqTVpwdi9LVVc5?=
 =?utf-8?B?L3dmczFOM2pVQlpYZkdCWHdXVXB2aVBOcFpZVmZOYVBzN1VnTjNVYzVaaHRO?=
 =?utf-8?Q?0oGB9uugz46HW6IHqkMfXG3w5MNvxNq4XQQv0EQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225d4b44-f72b-4ffc-9310-08d9359b955c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2711.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 16:34:19.4649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdvhXULbSqDGeOrvMw9cdtueUHfJp0LY0Bxv9Bkx8KMFE85ukCArg97D2WwBLfPM+jxe9F/jjNfGYM8Ahxrljw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3302
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/22/2021 11:19 AM, Tom Lendacky wrote:
> On 6/22/21 9:48 AM, Joerg Roedel wrote:
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> Add the necessary defines for supporting the GHCB version 2 protocol.
>> This includes defines for:
>>
>> 	- MSR-based AP hlt request/response
>> 	- Hypervisor Feature request/response
>>
>> This is the bare minimum of requests that need to be supported by a GHCB
>> version 2 implementation. There are more requests in the specification,
>> but those depend on Secure Nested Paging support being available.
>>
>> These defines are shared between SEV host and guest support, so they are
>> submitted as an individual patch without users yet to avoid merge
>> conflicts in the future.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>>  arch/x86/include/asm/sev-common.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 1cc9e7dd8107..4e6c4c7cb294 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -47,6 +47,21 @@
>>  		(((unsigned long)reg & GHCB_MSR_CPUID_REG_MASK) << GHCB_MSR_CPUID_REG_POS) | \
>>  		(((unsigned long)fn) << GHCB_MSR_CPUID_FUNC_POS))
>>  
>> +/* AP Reset Hold */
>> +#define GHCB_MSR_AP_RESET_HOLD_REQ		0x006
>> +#define GHCB_MSR_AP_RESET_HOLD_RESP		0x007
>> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
>> +#define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
>> +
>> +/* GHCB Hypervisor Feature Request/Response */
>> +#define GHCB_MSR_HV_FT_REQ			0x080
>> +#define GHCB_MSR_HV_FT_RESP			0x081
>> +#define GHCB_MSR_HV_FT_POS			12
>> +#define GHCB_MSR_HV_FT_MASK			GENMASK_ULL(51, 0)
>> +
>> +#define GHCB_MSR_HV_FT_RESP_VAL(v)		\
>> +	(((unsigned long)((v) & GHCB_MSR_HV_FT_MASK) >> GHCB_MSR_HV_FT_POS))
> 
> This should shift down first and then mask or else the mask should be from
> 12 to 63.
> 

Ah, that's good catch.

Joerg,

Please let me know if you want me to send the updated patch or you will
take care in your next revision.

thanks
