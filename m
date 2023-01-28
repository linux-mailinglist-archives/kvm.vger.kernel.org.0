Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAC67F786
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 12:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbjA1LZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 06:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjA1LZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 06:25:11 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20630.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8FF10249;
        Sat, 28 Jan 2023 03:25:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9RJGTwne9lKMncWr4OF+G4h+h/wQARRn7FwCQz1mPz9BcxBxwagPrprc/arQ46YjVHlIEHQomszR5smoHpjxnRTYzTbGqGk1XCttY9Qewf2/gQWPxMxd49qPSKDVY/yPqa23Gyg816pEp6MJpM7Q5hFKUBTXqnd11of0xS23POFXHgVKP6EumuZd7kheUyi7TWQOL8l/HsgmRXd4A3+XSbMLpbqeTuwVeZbgueiENGXcUYLnmzwSQuGPA+r1Tb8IhW5+8bVlj6JGI9CKuP5At5l6hEt4M27U9DdjwiKM/A9/a83ts+fEsOaWu4Rj8H52mBm4rOZD4AjRICQ9GLiNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1Ckzko2p/vhjKwtp6bdleuVJrwkqli4nAI+QUuel7Q=;
 b=NMDJ1cYaZxGJVxpXf2fGoGreroSC625bUW/eG/tz+LJZYJZ3mT+wR8bS3PCtuRi4UA7zLJDoV49z6+oVa8BiVDDBvkZfvoDcHoZ5BduZHeirlpVkrAWHcZwPIzbHyvyfddwqj3kC8UYU4mEcRa8Bw7ZNnclhBZ2h5dgkH7V6LZGtkIsekbsoy/3B0KMMx6dVeV0hcsbawLbwPgwTilh+fPPA2cVcmpY58nZttRQ1c0RfeeJnieRfhPU74uemXB/ZDQBP0nybyi/F4EQAbvpQk932cn4XgDmQhh6njBWbo9TwZfLVeSdaaDRTWBcsJog56ZNRlSA1RZeQRVT7Q4gGIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1Ckzko2p/vhjKwtp6bdleuVJrwkqli4nAI+QUuel7Q=;
 b=1zxDPVg/EpC6QpzpqoC4KqLCr1Mblwl7dT/nyNrqKCRM27aPJG5ewztNYM7Ozrp/EFzTLovt4SXmX+jPd3yrBzAX2qQWEzHBfmMdN9e1oDmUAAkz0wdaH6VJuKf9GFrbRMnxatP6SZKg/KSyy1VdCbz5SiEjRlNZ1OuJ3bTJiAY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SN7PR12MB7953.namprd12.prod.outlook.com (2603:10b6:806:345::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 11:25:07 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%7]) with mapi id 15.20.6043.023; Sat, 28 Jan 2023
 11:25:06 +0000
Message-ID: <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
Date:   Sat, 28 Jan 2023 22:24:56 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org> <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Y9QI9JwCVvRmtbr+@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0157.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::22) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SN7PR12MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: c89b7aa7-b0f6-4472-aec2-08db01224e8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VLUsAg5S66Db1kuck+AAD2Dh0C5vGKXukZq5SDJfLC7NZKTHvqoFbG6FRmHqHjbPH8l6LQbcvAVC/9jOUfssBnGjoVU1aeFcqZBSpi5pf39r2q5S3o+nBekwL2pDCed8R3q/r0FJ9ayNj2fdMgCeRh+er0vLHD/bLw7DBnVCNeQi0Q18nx+Ih8lgh0BkA6/6oqx3R/0A6ajO0fE+2/7G8FQOXd73tWH3X3Iw11AXkccLMw2xFhCwPSoIWTB5AfxdRDS56ZzNPFxU1BsArwLjgXTnrOFZwAaEoseYTW1nGNDnXXWm9X9tmTW3yS8H1opmBZJ6WM2lXYC35rOuA2k7InD/2ksLoUV1llmZjrXNJzeB1jTJYahZtInSG+V7c7zFhXcNqPZ9IGlrwsdCRwwBriswD0UTltjUxpZl3AS9S+G4kBPh6eOoZ9CsCBuiGfgxud9W6f/SG1OISDyooBuyV/BdAg80tRiDeCqmp/RSZCYB06gcqAB9iZLK7mf203LQMphi/+okchYkmk965qpxSD4s1wGB//ZLD89V044YOgF75fVhwCZUKr5cWnWnotTJx6e9zABPwKGqAbi6BC+9n9c4dnBGE8nXLo6d7yfyen86fmTYB09wS0WtCTPxqL5Ln6FAz5yD7kmJsGtC2S2nMyy8AWEzsTDJBf5D+8spwztvxLENT1+A2BtHHIz4b12hBe5WwjzakkcNRYwmV3i60DyL+8pMH7N6XacDs3iwDUzxqjAi++x61trCxXMAKDKFTZwtkP6vfLKRaYplwgUGYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(34036004)(376002)(366004)(136003)(39860400002)(396003)(451199018)(54906003)(41300700001)(41320700001)(38100700002)(8676002)(7416002)(66476007)(36756003)(6916009)(8936002)(66556008)(66946007)(31696002)(5660300002)(4326008)(2906002)(6506007)(53546011)(316002)(26005)(6512007)(31686004)(186003)(508600001)(966005)(6486002)(6666004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REVScnA3Mk1KcHdXVzlwalI0b0lRb0ZZTXcyY0xmWktPejFzVktwS2tDUk94?=
 =?utf-8?B?TWpDNVpZY3BnSkoxRU1yeEFnUEEySWZXM1VTQlAxVnpnSWJINy9RaTh6MUpy?=
 =?utf-8?B?Y1UvYkJBWVo2dkV1cnUzWU43NzFRVGtlRlJ5YURvNWhZb2F4VEFsbWQxdDVF?=
 =?utf-8?B?ejBReGk3L1MzR2NCRlQ3bmNrVEZTTlljbk12bXVmeW5Ra25SNjVBT2FiTm5k?=
 =?utf-8?B?NWg0VFh1NHI1YzhBblpjUGs1cnM4MkdBRXVnTjhNSFhQUFFJT2pEcTdFNzUv?=
 =?utf-8?B?WGsvMSszeU9RcTdWRFR4UTZ2T2RzdHRpU0lMd1dFeERSNWRONTVxL2g4Ukha?=
 =?utf-8?B?Q2pOTVVjK1FrMFlSTDVSbng2bnN6TndWODFhQ3grbkVOUVEwMzlJMkJrR3JU?=
 =?utf-8?B?ZjFwbm9hS0dqdHRCb1ora2lJOWh4c2RnUUpPbUNaVlFWQ1BkcGsxVGw0TW9X?=
 =?utf-8?B?eUIrN2p1Y2h6RGl3Q2c3YXc5ZUk5Mm9keGtWK2hsdzM5eEp4eFpBU2t0Yktq?=
 =?utf-8?B?VUVjdFlYR0M5dCtIOFR0VWpCNFRpUTgxMndwaE5VWUJXcWlLRkh0SXMyQkxO?=
 =?utf-8?B?NTNKZ2V6ZmxYdHdsUWgvbTFCVExnT3RWRVRkdkdUTzJWczJIY3hzQjNvNXQ3?=
 =?utf-8?B?aDBTSkNQNnZJV2xma2NYZzRQOU9yczVvTkpFL2J3Z1hQSmdyUFJ0czU1NlFZ?=
 =?utf-8?B?eEprVkhVZUYvM05TTnNTS3hiamIwMHlCZnMzcTlKS3dPSmwzWjZVaUh0Snl1?=
 =?utf-8?B?SXhqaEw4akhFalVldlk1dXRYbG9qbjlCdEI0RVFXSHFaMk00Rk1BbUo5NjNq?=
 =?utf-8?B?RlZ2Um9UZEZROHNaS1E3M2R5R2NqT2l5YjFtdVlqbk1RWkdkdHh1VHhreGpj?=
 =?utf-8?B?WlJndlZleVJWVjQreHhVTklLTmliQzdwUlFScVBKK1FjTE0xYXFRWWR4WDEz?=
 =?utf-8?B?a0ZkVFk5UjRRdit5TitHcElwYWFzNXNMVXI3SXBWVS8vZG1ac0creUtxNzJK?=
 =?utf-8?B?V0ttSHMyeUZqMUZibUFIZTB0dXEvYnJYOC81RVE0N3BQQUlaV2VxNzE0SDJp?=
 =?utf-8?B?Wm52cmc3VDBxMXRybStGRVY3OWZQNnRvS2VubHRXUGpYd09TY3ZHMDNqdERr?=
 =?utf-8?B?MkpXckMrUElLelQwM3dpajZNOVpURlo2UDhFa3hqQ1BIdmJId2d2UzZCRjlj?=
 =?utf-8?B?U1cwVUFDaTRqZDNLUkJsWnRDY0lNcEc1NlhjejgzcGNDWlhVTThabHQ0aHdL?=
 =?utf-8?B?T2F3K1g3akV3bWlGMzNDSTBtOUtqUko4OTI2Zmx2K0UvUjRDL0ZEaE91bE5M?=
 =?utf-8?B?ai9zYzc5ZnhpTndLTjNNR3RNSkNTbUJPQlFTRlh6Qnl4eWc0SnMvK3dwZGgr?=
 =?utf-8?B?NGxIRWc4cUtndjFob1F5Vm9ZSXpkdFJINXFoSnp5ZW5ySGFLYVV5K2UwRVBI?=
 =?utf-8?B?RmVHSVlCOGlLM1AzU2ZWdjdobkRjV3diSjZ0VVNEczJsNkQwcTNwUzFNZVNX?=
 =?utf-8?B?dkJTeHZTOG1YQXpRNWE1bWVJSlM1ekJab0IxbllIaDhQc1pqWEp4TXNoamVk?=
 =?utf-8?B?dC9yZUhYeUlpck9TQnc1bnU3dXc3Q3orZGFRei9mN3JnMkl0RkttZVBIN28v?=
 =?utf-8?B?RkwvNW9Ldy9TRWl5TEgweHpteFZwWjBQRFRxK1JZN2sxSCsvZW9ZWUlSNEln?=
 =?utf-8?B?V3FVMmdPK0hzaGs2ZWRVNXp0em11dCtsNzVDdzJiRWxNVWx6U1BBenpSMXJn?=
 =?utf-8?B?RXRZc2ZFVWQrM0RSNmcvNnlRckZnelhXb1BDK2phcW50Kzh0UDR4V1BPcU9C?=
 =?utf-8?B?bklXUTNiUmtQWWxVYkFMSU9wN3ZRang4WXh5ZFVTaHlTbXFhQjRrNmsrdm8r?=
 =?utf-8?B?cW9QRERGa2Vzc3o0S0hSYjZiby80cWJ1YWxDb01wZE0rZjlnWTdYd3dsZXJT?=
 =?utf-8?B?cFdlNzlNMmJOUytpZ1NIdzlpSUs5YkVNOVVrWlhPcHVuNm8yMm50dmZzNmZD?=
 =?utf-8?B?UC9GZmhYb0NURW51dVlydEppMW9xc2NtMytFS3laNlFUQnl3Y0wvaStTVXhh?=
 =?utf-8?B?aEtsT1JmY3d1NUxOL09NTmJDZFVhbDBrWWhzRTBBQUNPQ3lUcnBkZGh2cTNO?=
 =?utf-8?Q?vCoSRFCR4WvrNQafhu6dhj4FY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c89b7aa7-b0f6-4472-aec2-08db01224e8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 11:25:06.6637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRuPGNXYI3iQMpRwIw/X44FB9WnyM/qxDKYcYB8pO4eu5AB6IznwPK18A7m5j8wNSaHOnbFqB7MZ46QOUUW2uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7953
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28/1/23 04:25, Joerg Roedel wrote:
> On Fri, Jan 27, 2023 at 10:56:26PM +1100, Alexey Kardashevskiy wrote:
>> https://github.com/aik/linux/commit/d0d6bbb58fcd927ddd1f8e9d42ab121920c7eafc
> 
> Okay, I reproduced the problem here and the root cause turned out to be
> that the compiler moved the DR7 read instruction before the 5-byte NOP
> which becomes the call to sev_es_ist_enter() in SEV-ES guests. This is
> guaranteed to cause #VC exception stack recursion if the NMI was
> triggered on the #VC stack, and that leads to all kinds of undefined
> behavior.

Cool!

(out of curiosity) where do you see these NOPs? "objdump -D vmlinux" 
does not show any, is this after lifepatching?

Meanwhile, this seems to be doing the right thing:


diff --git a/arch/x86/include/asm/debugreg.h 
b/arch/x86/include/asm/debugreg.h
index b049d950612f..687b15297057 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -39,7 +39,7 @@ static __always_inline unsigned long 
native_get_debugreg(int regno)
                 asm("mov %%db6, %0" :"=r" (val));
                 break;
         case 7:
-               asm("mov %%db7, %0" :"=r" (val));
+               asm volatile ("mov %%db7, %0" :"=r" (val));



-- 
Alexey
