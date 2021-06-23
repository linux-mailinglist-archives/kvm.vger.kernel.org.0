Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E653B1A3D
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 14:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhFWMff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 08:35:35 -0400
Received: from mail-dm6nam10on2040.outbound.protection.outlook.com ([40.107.93.40]:51218
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230061AbhFWMfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 08:35:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipfIKg1jWQSSBAQvpZtkG/4eHUPq21T4VZ1f7wiAHJ40kOfPdT2nVaxmEuNmKtBhK3h+RLte32tCmBeFWjdVrkWcVEy4ettOCGBYKSSQC8HpYCISG1WmAybb/XlNoU5bWAbs/PE5CfmlbWtr3Q77NdgjsnnN1bp16Rv3PlJciuiKleOqRckyGgQLjvKrMJDFGW14VlXWUFpVBj/mObEt+xKELbOb8Qs17XhlMJd9KnfNY91Vt2F2HS9NE1y3EO07kgp8s+0TuTLym5kDJJp2ZZfirdJZ1FHmrzB2XfXDTh4XlbqDIUo+8CQ2N88zC0AA9iXP4WYaCxalTTbAs5RFlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqwcoLCE5gf+7txchdEBLKfMC8F5yRIDkHnD1r9JP3s=;
 b=L7prCtoQw2XwmNaalzyU6KZXzUYCfLknSXjmY1sUaE3SRyssK7xKM+0/ygf3cAmMdRQSYYCQl3mY8PqhhCNZvYgi2PHS8ximBMo3m69ClxfR6OCCyfFhs5+nWEaA4387vkYXpoYdT4HhiTClgygDuuZ1GcUjJ2U+V92tqWnnlKzpyWGXpx8EMQeQTa7EFZzuSXS7LHksD2tIGd9DGJuzXKN86PmK99muhcgfCv2o7z9FvR/K3x8LSq/Vbkk3JPq7ns58QZck/kISfTbwOPFPaMWcRxUTMUfWk3DWc048dbsOLKuaEvad1/Gcs1kRGGACKAPpWZC+lK4Vct9SU0ZpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqwcoLCE5gf+7txchdEBLKfMC8F5yRIDkHnD1r9JP3s=;
 b=HjvEtuxpr1uZNr/crrF6e32y+SfxSnlUYT6Fu0cFpEDF0mIwDtIVswzGUwblG8e7TJxGjouOYsE7M9p9CjJCEfsW2JrFQg4aOzsGjEewQIFnz7Ms0WVfg0p9Ih+R0W46APi2/FIYqUfi5E/3wl3DHOmWyx9JTYjhZxs0I40HmDc=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=amd.com;
Received: from BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10)
 by BY5PR12MB4020.namprd12.prod.outlook.com (2603:10b6:a03:196::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 12:33:13 +0000
Received: from BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed]) by BYAPR12MB2711.namprd12.prod.outlook.com
 ([fe80::40e3:aade:9549:4bed%7]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 12:33:13 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
To:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
References: <20210622144825.27588-1-joro@8bytes.org>
 <20210622144825.27588-3-joro@8bytes.org> <YNLXQIZ5e1wjkshG@8bytes.org>
 <YNL/wpVY1PmGJASW@zn.tnic>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <93fe4681-eb0c-d901-9497-336efb4429a6@amd.com>
Date:   Wed, 23 Jun 2021 07:33:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <YNL/wpVY1PmGJASW@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN2PR01CA0030.prod.exchangelabs.com (2603:10b6:804:2::40)
 To BYAPR12MB2711.namprd12.prod.outlook.com (2603:10b6:a03:63::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN2PR01CA0030.prod.exchangelabs.com (2603:10b6:804:2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 12:33:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 755f0747-c503-4ed7-3e17-08d936431193
X-MS-TrafficTypeDiagnostic: BY5PR12MB4020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB402018710A4683E038E7C525E5089@BY5PR12MB4020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpVSScW6VjnWGG3PydcBw3BwPYkfAHbwItPHQs+fEo2lVfAuDlmwGMIZcSHpnPGFc1LnTVoyQa8/XoAhDCydwX+SrNpLQt2siIB71ZWE4WgwC3WJk1tFqHygbrHioNwiNxJw1eQHgkOXCaxg7fTPGOkr/z/GbYquqqDHjuffBba/m7NTCR9herxVQ6jlNSzTi4LG1TlxTeKogwCQ0CwLZOmN7bxrGYjkLtGgn/v35aZCVbcnSFF/vKz8aKwOC1g8Z8Fje1KBCs9yoy5uJ9MSaojSdEMTxl+ewM2feSUX47F1G2q5cgfet7N/ibv3bEhivAoX8HVjkMpFKWuemJurf2JOjRpte9Gl9f7z0PLiNmtiCJynnQumkqBtZkB6IZNZSP+nMKm97hYojxaPLIYlcypyGOrHK0BO7NSc4Jb61UvHf8fo4CRC3LYa+Lv5cz+GbiG10gKj5d5QZJJhvje2Tqcyd7dADHpDaz0XfAE04a1xtDzeBt9gdO/Os346Chk+Y1sZ/STjLYITqLZ+10EpstYcrp/p3ai643N+86wRJM9DUN7bwCPCAn4Zr9e5+8BZjm13E854cBgBbmyyvt+HA7jImFsKQsq6qSjbn7E56m4GkxYg4NeXcNBfYNT5hz40A79gqQOehJyTcZAiZX7smq6KPMgCNMp2jey6NsM2zTFlnCojrW4Z2jI//ZRPb/Ju
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2711.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(136003)(366004)(346002)(31686004)(2616005)(38350700002)(7416002)(52116002)(66946007)(956004)(4326008)(8936002)(6486002)(5660300002)(186003)(44832011)(478600001)(38100700002)(83380400001)(16526019)(8676002)(2906002)(36756003)(86362001)(6512007)(54906003)(6506007)(66476007)(66556008)(26005)(53546011)(110136005)(316002)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzFhTE0xc0hVcTNyY1VkYXdrWGlqUmdEaE4yY0IwWXp4RE1kWVJYcC93Mnp3?=
 =?utf-8?B?MmwzSE5PQXJ2M0svL2cvOWlybTlCSk5rMWkraTJuS2ZxMENhNlB4dFFDZ0ZW?=
 =?utf-8?B?UC94dWExTElOcnFaQldmSkdLa3YxTDBkRy9heTJjUjI3WUVyZEFtd00waWpZ?=
 =?utf-8?B?WDVxMkJ5WDVqTVRWemRkTnNDbklUQXYvTk91bkRMVlpLMG1GcGpOUFJEQTMv?=
 =?utf-8?B?VTZYQllRcGMyMkVmOXhuUjh2UDVyc3JYUncvZE10bTA1YXpLUjRrWHJ1c2xP?=
 =?utf-8?B?SElhR0dxdk1CWVRDVytHZ2xvbWxlblJrOEErSjJ6b3B5Tk1FVjBZaUJ4S0sx?=
 =?utf-8?B?YjNaQUFEWXRCbEpsb1JWSjdOR0xlWEJKSUphOHhNcU5XUWlFR3lsU0Z6aEtE?=
 =?utf-8?B?a1V4U2xiaFhxKzRpSFJVaHdJbGVUU05Wem1pV0d4N3VOMVhzN2ZQbmVJczJh?=
 =?utf-8?B?V0pZQVRKRU5lQndWUCtBMjFLQVJSQW1pQ2hVcHZGQVhGU21tdEdWMGYwaFNM?=
 =?utf-8?B?dktrYmxQMDZlTDdzNW53YnQ5Mjh0bkJHc3d2WklvWWNBVXczN2ovOUF5b085?=
 =?utf-8?B?WG1JV3h2dGltTGlyWVBWNDBVYjMwU0V0WkdaVXVKYXB2Vk1RQTV6QlN3Y1Er?=
 =?utf-8?B?TnNNQ0hHSHpYWDlhdzhLdWlqMXpxbEpFdzNFemZOQ3N1TWczdEFLOHg4VkFn?=
 =?utf-8?B?WVpRako2WUFySS91QU1MeTRTRGlUTHlUSitVYjZCWGErblpEMTZqYWZ3KzEr?=
 =?utf-8?B?VDdtZHhqYm1yL1BaUFQ5VFFmdlgrZk5KT0VaMVRrdjI1aTB2OGtPZXowd0RV?=
 =?utf-8?B?NDAyeGw4dWR5UTJVZENjQlRVanFRb0IzZmFTZWQ3NTZsQ0ErWU5NbVZ5c1Fy?=
 =?utf-8?B?WU1tcml2czBPWDUzS0ErYmIrSm9nOUF1NjUzcTY0U0x6UnVUdUU1QkkrajFx?=
 =?utf-8?B?UjFUYXFhdTJRT3JCYXFvTUh4cUNxNlNiV0pBMWU4WHorcS9jMkFZd0NwZ0t1?=
 =?utf-8?B?bUszYXBTemVZRTE2dEhBRnBOWEtmNGJyVlRKb0RtVnVsZCtjV2FtWkdKTlV5?=
 =?utf-8?B?VkNGN2kyUHR5cGxyYW85L0VaOXlSRVNjQTJkWGR0dVk1WjNQRVF5VkQweml3?=
 =?utf-8?B?dnNleGlzZUxqcGNkUjJrOWNiTmJoRkZUenJGR1dTdUJsWDdUdUJxd2h3WDNk?=
 =?utf-8?B?QWVLekFSM2ZoN1RSQ0lvMVhnZEUrazlpMTd0RkdhQ25pUjJWTFZ1SHF3QU1C?=
 =?utf-8?B?a1cwUHpIc3NVV0p1Rm5SbERLZ2dVSTM2T3hnUlc0aVNqeE1odXl5Uno1eWtx?=
 =?utf-8?B?TXlMeHpyS0lwYnhRU1I0U0N6ZDFBSG1pT0Vxd2ZVejVoUlcwT21XaXRkLzdy?=
 =?utf-8?B?U25QN3pYUFBZa05weWkxWmpId0w0SmRGUk9mYUJWTmFpLzUvTVZCMEY4U1Rp?=
 =?utf-8?B?a2FMaGMyQmJJdjlLR3AyM0gxMGZNZXh2MVVIbk12THJCczcyTEovVmJiU3pY?=
 =?utf-8?B?Y0crSDFvczFYMjVDWlhXNlRPMHlkdVpYRWtIUEthVDFpN0Zmbkp1aVVxaFdG?=
 =?utf-8?B?UnVueTlUdXVUbE01T0Y0K01jRms0bm1pMnYwaUlTdmZzZXV0WFR1QTBEb1J1?=
 =?utf-8?B?N3hYRXJhT2llc1FTWWxCU3JielpEMzY0OW9hNHFtOUpNY3haTW5JNEV0SERv?=
 =?utf-8?B?YVBaTS9qMUtBbnN0cXNYYVp0WkI3TGVkdGJzQjlST3RMU0hnY0toTXB1dEtm?=
 =?utf-8?Q?byyPIvXWtyCZGJnUTXk6GR3E8MbUf12HqlIf1Fo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 755f0747-c503-4ed7-3e17-08d936431193
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2711.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 12:33:13.7705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9hxWfFmH/IrSIpTebH+8BM6xJE94g9j4htOgneXQGeDYj/RGI8x3BLpdUX9xsYmxU9K2BRHTtG97Mnn1GFzFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4020
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/23/21 4:32 AM, Borislav Petkov wrote:
> On Wed, Jun 23, 2021 at 08:40:00AM +0200, Joerg Roedel wrote:
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
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Co-developed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Joerg Roedel <jroedel@suse.de>
>> ---
>>  arch/x86/include/asm/sev-common.h | 15 +++++++++++++++
>>  1 file changed, 15 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index 1cc9e7dd8107..9aa2f29b4c97 100644
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
>> +	((unsigned long)((v) >> GHCB_MSR_HV_FT_POS) & GHCB_MSR_HV_FT_MASK)
>> +
> Ok, so I took a critical look at this and it doesn't make sense to have
> a differently named define each time you need the [63:12] slice of
> GHCBData. So you can simply use GHCB_DATA(msr_value) instead, see below.
>
> Complaints?

Looks good to me.


