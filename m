Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C97665B411
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 16:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbjABPVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 10:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236292AbjABPUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 10:20:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA8BC10;
        Mon,  2 Jan 2023 07:20:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V7SVmJJdeAaO/Mdr6kkPwd/XjSz/8oMQiSCAou0dVGob4Q4w61Ps4pkZJUArEceddeCwqkhf+fq7nWvFyuuteHl1Rhlnvu6X0Z84wLlWf/vDYNc8Iqk8gdySBELcH6rr1aAFJ++MvEb/CXe/IXA4woZ0ClJ/A8hxq8GwHInRGUgFaj2Tmo88d19LHK++YJhNdtClhVpkrUZhxsodsE7Sw0LG80FMNfoJuyEnJMGGkpbjBIV5HzKBskCmI4cArBoXo1PJw64QZhWHdBdBvauuEz1KbEqfcXJdCjFSpfA/BJatVdWqdBHGaenIyXrER08KhB+TtvpBdmzT7AXLVhH6BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzHY8MTLSULuPd05Z7ShK8/P+Jb8+cOcpOeY/P2d0NU=;
 b=R3RSmqZriJh31yz9XHu0nmNz4TE8MysEa78uCWykxA5Odop5D2xwSr7Xet+GTWRcf3u+3AE1sk0G6jDfohlCfreEzZKdUP0dX92w8ow5hQgR+PIP5bEaXZCGw+9jJkQChRZJuN6Pp2rdEhnLL4MAKzKkXNSSvn28KXjFp/CPX943IgO1TU0XZEzcb8h76vS7iNZkSYYN10ERO/l5K26viucDJJOa6Kqs9qdQIf0KDaEjAZlmsn9MbKahCwBao3pDBUcWrqKv9nrBsImcMqHad6hoc79ahCAZkwXKkO+TdRLr5qr4+TBlE6DxDB6eqAx9AlHnJEqgHLYKwU7kBiuXNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzHY8MTLSULuPd05Z7ShK8/P+Jb8+cOcpOeY/P2d0NU=;
 b=IQnUNfdAMPlICZOEbJ0j0A5M3AW9KSNFY4Mb4JgqCriBGuaroe9mrFPk+dX0BPKj2eo/e4QXWNBoy/f0UbYSPKv52sA0Ku3qoxyHDz4ccyaTCfqBG1rANpd9ofq9Ylw1vdkHQGC1tb3fLgZO9AcAFGcSJxN1ytLB5QF0RY4HDYc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.18; Mon, 2 Jan 2023 15:20:45 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%6]) with mapi id 15.20.5944.019; Mon, 2 Jan 2023
 15:20:38 +0000
Message-ID: <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
Date:   Mon, 2 Jan 2023 20:50:23 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
To:     David Rientjes <rientjes@google.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA0PR12MB4575:EE_
X-MS-Office365-Filtering-Correlation-Id: 5516f340-d009-4ad0-2f39-08daecd4e755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZueEU8USAQLloCZY8MqhFG4wEJzBn8sTvFddRdAcl8+3RIivyNYrNf66wF9640g8poYEEXEjjkqZT+f+ZZ5ARzYhsECrArwVB7EaIGZ8vAkzcQaL7emwvKbsyq99ga5qXKX0YsrufLqi8ozX2DU8m+BV86PZpm71566QrR3ffLw3PjG2xdOD4rj0kHup6fcPYBPQ2WvrQKh9740i/OaeY6IggnT9gQiDAJ9UlQUuOoDcP7fAiOfU7LcQq9hZWJLWCaBCus9mQyKzqCuznhzrYLMahovFDqLfJPg6xoSItyIgVouWfRh0zlp7ToaJ9RgQvF4mDK1q+wGzBKfFpOBj2PiJtMJqi2oQQaAoWPadzDxpNF6fAL5xC2WbIBvCTkUT3ufyNLdxvJFkJLNnyevXwLJaAauO6TYtcGDivKdOnW0R3U8ATGjxoFy1N6WaGmmCvs+iJ+CEnDrzGc5TTYf3oRxWtUn/6ZGVXs9ZoTj4OucdcoIjs58eWgbrXNXGTfVaNykbB3cHphF3c9iqCm28RuEd9OtZr4WF1B+eXdmR32uRgF+BKTomoIWWe8+17AIOoGCKuBMpWwaPnwCUnjnIyKj6atquNNNWy+S5V+KCSj3yTIheNpenyizs8m6lcOuv0AobzoYvwO6EhtT71nnoMnDXQul7gRZvLxLlHjHFnaDNAXr5W2YKR9t5VnAOT0NZXpO+fc2UdsUpO7VazJqihaXysXKg7nyUYUHd2tOEYze25HMiGJJWY+E7X5VNfwuG4f18Wy0Y68V0FOxeqQmTRe8a+OzBAoqRXz3cLCfMHuQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199015)(38100700002)(83380400001)(31696002)(7416002)(5660300002)(2906002)(66946007)(4326008)(66556008)(66476007)(8676002)(8936002)(41300700001)(186003)(26005)(53546011)(6506007)(6666004)(6512007)(2616005)(6916009)(316002)(45080400002)(478600001)(6486002)(966005)(31686004)(36756003)(22166006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjdxNUNnaWI4WFZCTVpqMkYrc1VCazdjZEY1ZG12VnkzTll5UzFiQURieE51?=
 =?utf-8?B?aWF0Vm9CcUsxUkNBSUpjSVBoL3BVZWN1SVlibkZPTk92YXRzbG9MZHJDN3dJ?=
 =?utf-8?B?alY0dk15OWNVQW5TNHdYakhVTmdyeGltZ1ZTMStkb0N4NzM4UDRIclo2YjBW?=
 =?utf-8?B?Vjg4NHNTRHdkN045WWZoQXdBV2J2amNldUdST3V6ang4Q2RZbDdqLy9YUGxm?=
 =?utf-8?B?UlhYMGhxaTNFRmJkSWpKRUhYay80UU81WjdiSk02WGRhMjd3dkJrUVNmN1JD?=
 =?utf-8?B?UkphRjJEVThpcnEyQi9VYyt6NTMxU3ZSdEhuc0FlZEViZ3JjakhBQTR5RnNT?=
 =?utf-8?B?TGQrdzFrUDN4TzJNc3RjbFBnR1ZtMTlkQWk1clU5MDlwMUVBSk0rUDNTYlky?=
 =?utf-8?B?aHdkNkFDWi9lU0ZyV2N5dXpTaDZUYXZBK3lmVjF3TDdnU1ZvbFc0Mno0cEF4?=
 =?utf-8?B?M3lGRWFPMjVQZEpNbFJsNTd1Z3ViRk9BTDg3UWg3Um5wdlRoNzB4cTExem5j?=
 =?utf-8?B?aHZmK2NZN2JTdmpJSE1uV0EvZzJudlcwTVRqZ1NRQW5iOHhZaW94WGVablpX?=
 =?utf-8?B?MmFjUFl1SGtMN1ZxRnIwTjF1NWl1bWpZaWtMc1NKVU04WlZlZ2dod2pGbEJV?=
 =?utf-8?B?OFBZR2FhcWZJeHBwN0FXSVExZk1uVjNHQXcvTERIYkNrOXZQVTN1ZGFBaUVN?=
 =?utf-8?B?cVNKRDdKSHNLR2dXTEQ5R2xzTi9POGUrenRnaFJ6MTMxNGtNcEJJSHlQWlFh?=
 =?utf-8?B?S2xDQ29TSEJ1WmF3NmM5blNpN1lNb1RhdHR4RktITHpZTDFqVUw5b1NOaXdC?=
 =?utf-8?B?ekRncUg0QS8rTFEvKzA5cDFaUVlIeG52dC8rTCtwRU1rUkd2R0t4aUdLdkhE?=
 =?utf-8?B?V29YUW5YRGFxdzFyOWZhcm5TODdub3FEM1pqdk1LeU9zMTgwcVAvOEx2b21S?=
 =?utf-8?B?ZUJpek9ITUZJWFphMkxoc3FkaE5DMlUvV0hmNkE1cUdYTlJ3b2c5bkUyMy9O?=
 =?utf-8?B?MXNZeHFIMitIbHdkRTc5ZVdWbVVIWE13VXZqa3U4bnh0VElsTVh6Y1FzN2lz?=
 =?utf-8?B?OVpTaDRocFpUNkNKeVo3SmxpVFdzdXp1MGxHTHpMUmpUbGo0UmFWbGMvc2hi?=
 =?utf-8?B?Uk0ySE9rdkJqN2F6VFl3OVBhdkdweWg5RWpzZ1B5RHZreTVYeUc1RjRuVVFh?=
 =?utf-8?B?K2NndzBzU2VzOGpQSU1USER4MmNvemxORUNFZlVMdmtCLzZFNlFuT0h3dFli?=
 =?utf-8?B?WjZJTGdnOUI0OEgrb1JiaGxVaFB4dEtpb2c0Q2dxTzcvUkY1U2pTekhOOWVz?=
 =?utf-8?B?ZDVDeVFPWTF5dm9ZWHpQdWJ0V1UrYkttSk5KUGVlaGRGUDlKNUt1cnB6SldK?=
 =?utf-8?B?cGxTejhDNExkdEFHL1AwWlhOMkY3L2Zwbmo5MHBwRkx5MFQyUW9TVyt0TmlN?=
 =?utf-8?B?M1BmYW5vdVdsdUZCNHBDWWgycTNXZTk1czI4WXBnSVVOUHorTG4wb3EzZXVD?=
 =?utf-8?B?QkNuYno4YnpZQVdlSGNWSUpHazgxdGxzSmlKajE4ZVVnQ0tlc3JWUWRoMHFw?=
 =?utf-8?B?OFZvV3Z5bktKS2YwdnlaY2FBUDVWTXAzYVVscWtyZkZZd1hWVXhqZlVidHJK?=
 =?utf-8?B?MHBNZWJtRUpTcllPNnpFUVoyTFZvZjJabDAzbkhPU05TWHRQYnMzbEFWQjNj?=
 =?utf-8?B?RW1iSjBCSndEY1RxTXJaVkVtT1ZtOVJrVG5uVTVaeDNRY0lWTE9KUFFXTEZ0?=
 =?utf-8?B?Y1pOeW1rU1hvTFVCTzMyK1VrSFoxTTdPU1AvYm1PcUZJSzloUFlsY09uSWZt?=
 =?utf-8?B?R0M1bWQ5TGwyWnJydDRoTVdNdXk1VHREaXhBRlNnRFh3Z3E3OHFzaW1TWDd4?=
 =?utf-8?B?d1B3R1hDRkRZZXhzN1l6TERiWWNwUHh3L3MvQXpSbGJHZTRGLzROcGp1MFVD?=
 =?utf-8?B?bCtNTEdFakY3VldySHBhc2ZlbEs1K0I3K0dod3M3aW43UzM3aU1FenNFMTY3?=
 =?utf-8?B?VW5KdXlnUW82WUhxSTM1Ykt6bXY1SFdqSHViL0IzZ29kNWdocjh6Y3RhVXZk?=
 =?utf-8?B?Zm1LZUpzamo5bjBlL3lSQlFMUk5qL2JnUW9tVGYrMjJ3b3dMOFJZZTFCUjQy?=
 =?utf-8?Q?PKiXkpwZrxhwyfasRjaMrQlXe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5516f340-d009-4ad0-2f39-08daecd4e755
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 15:20:38.8124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlBryYTgoSpBmTNfw2Y2DMX8+6rFuaFnKyY7PsZ2B0L86XwSCGGogyqqMkHNmJosru+pkLqnw4r3q/Znz6T9AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/01/23 16:53, David Rientjes wrote:
> On Mon, 2 Jan 2023, Nikunj A Dadhania wrote:
> 
>> The hypervisor can enable various new features (SEV_FEATURES[1:63])
>> and start the SNP guest. Some of these features need guest side
>> implementation. If any of these features are enabled without guest
>> side implementation, the behavior of the SNP guest will be undefined.
>> The SNP guest boot may fail in a non-obvious way making it difficult
>> to debug.
>>
>> Instead of allowing the guest to continue and have it fail randomly
>> later, detect this early and fail gracefully.
>>
>> SEV_STATUS MSR indicates features which hypervisor has enabled. While
>> booting, SNP guests should ascertain that all the enabled features
>> have guest side implementation. In case any feature is not implemented
>> in the guest, the guest terminates booting with SNP feature
>> unsupported exit code.
>>
>> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F40332_4.05.pdf&data=05%7C01%7Cnikunj.dadhania%40amd.com%7Cd4d286d55435487f7d4f08daecb3d3e6%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638082554474351848%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=TLBCkg20WCaF77YrOzGC%2Bn9V3JFgVl2vs1XMPmSWHcM%3D&reserved=0
>>
>> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: <stable@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>
>> ---
>>
>> Changes:
>> v2:
>> * Updated Documentation/x86/amd-memory-encryption.rst
>> * Address review feedback from Boris/Tom
>>
>> v1:
>> * Dropped _ENABLED from the feature bits
>> * Use approprate macro/function names and move closer to the function where
>>   it is used.
>> * More details added to the commit message and comments
>> * Fixed compilation issue
>> ---
>>  Documentation/x86/amd-memory-encryption.rst | 35 +++++++++++++++++++
>>  arch/x86/boot/compressed/sev.c              | 37 +++++++++++++++++++++
>>  arch/x86/include/asm/msr-index.h            | 20 +++++++++++
>>  arch/x86/include/asm/sev-common.h           |  1 +
>>  4 files changed, 93 insertions(+)
>>
>> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
>> index a1940ebe7be5..b8b6b87be995 100644
>> --- a/Documentation/x86/amd-memory-encryption.rst
>> +++ b/Documentation/x86/amd-memory-encryption.rst
>> @@ -95,3 +95,38 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
>>  not enable SME, then Linux will not be able to activate memory encryption, even
>>  if configured to do so by default or the mem_encrypt=on command line parameter
>>  is specified.
>> +
>> +Secure Nested Paging (SNP):
>> +===========================
>> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
>> +by the hypervisor for security enhancements. Some of these features need
>> +guest side implementation to function correctly. The below table lists the
>> +expected guest behavior with various possible scenarios of guest/hypervisor
>> +SNP feature support.
>> +
>> ++---------------+---------------+---------------+---------------+
>> +|Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
>> +|     by HV     |implementation |implementation |   behavior    |
>> ++---------------+---------------+---------------+---------------+
>> +|      No       |      No       |      No       |     Boot      |
>> +|               |               |               |               |
>> ++---------------+---------------+---------------+---------------+
>> +|      No       |      Yes      |      No       |     Boot      |
>> +|               |               |               |               |
>> ++---------------+---------------+---------------+---------------+
>> +|      No       |      Yes      |      Yes      |     Boot      |
>> +|               |               |               |               |
>> ++---------------+---------------+---------------+---------------+
>> +|      Yes      |      No       |      No       |   Boot with   |
>> +|               |               |               |feature enabled|
>> ++---------------+---------------+---------------+---------------+
>> +|      Yes      |      Yes      |      No       | Graceful Boot |
>> +|               |               |               |    Failure    |
>> ++---------------+---------------+---------------+---------------+
>> +|      Yes      |      Yes      |      Yes      |   Boot with   |
>> +|               |               |               |feature enabled|
>> ++---------------+---------------+---------------+---------------+
>> +
> 
> Couple things:
> 
>  - I'd assume that the documentation would refer the reader to the
>    SNP_FEATURES_IMPL_REQ mask that defines whether the guest is required 
>    to have a specific feature or not.>
>  - Don't hate me, but I feel wanting more from this, such as a rationale
>    for why certain features are required in the guest.  

The guest can boot without any of these features provided the hypervisor has 
not enabled any of the SNP_FEATURES_IMPL_REQ features. But in case the hypervisor
does enable them, the guest needs to react in a predictable manner.

These are optional security features provided for SNP guests which the hypervisor 
can enable. 

>    When a guest fails to boot and the reasoning provided by a cloud provider 
>    is "your guest doesn't support ${feature}", the natural question to ask 
>    will be "why do I need ${feature}?"

I think the "why" part depends on the user. Whether or not the user needs a 
certain feature enabled for the confidential guest.

If the cloud provider(hypervisor) enables the feature on user request, the guest 
terminates with GHCB_SNP_FEAT_NOT_IMPLEMENTED when guest kernel does have corresponding 
code/implementation.


> 
>> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>> +
>> +[1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F40332_4.05.pdf&data=05%7C01%7Cnikunj.dadhania%40amd.com%7Cd4d286d55435487f7d4f08daecb3d3e6%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638082554474351848%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=TLBCkg20WCaF77YrOzGC%2Bn9V3JFgVl2vs1XMPmSWHcM%3D&reserved=0
>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index c93930d5ccbd..43793f46cfc1 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -270,6 +270,36 @@ static void enforce_vmpl0(void)
>>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>>  }
>>  
>> +/*
>> + * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
>> + * guest side implementation for proper functioning of the guest. If any
>> + * of these features are enabled in the hypervisor but are lacking guest
>> + * side implementation, the behavior of the guest will be undefined. The
>> + * guest could fail in non-obvious way making it difficult to debug.
>> + *
>> + * As the behavior of reserved feature bits is unknown to be on the
>> + * safe side add them to the required features mask.
> 
> If one or more of the reserved feature bits turns out to not be required 
> for the SNP guest to function correctly, is this the correct choice?

Yes, I think so. As they are undefined at the moment, it is safe to assume 
that a guest implementation is required. 

> 
> IIUC, legacy guests would fail to boot correctly (and unnecessarily, 
> because of this change) if they do not have an implentation for a 
> non-required feature.  Absent this change, however, they would proceed 
> just fine.

True, but the other way around guest behaviour may be undefined.

> 
>> + */
>> +#define SNP_FEATURES_IMPL_REQ	(MSR_AMD64_SNP_VTOM |			\
>> +				MSR_AMD64_SNP_REFLECT_VC |		\
>> +				MSR_AMD64_SNP_RESTRICTED_INJ |		\
>> +				MSR_AMD64_SNP_ALT_INJ |			\
>> +				MSR_AMD64_SNP_DEBUG_SWAP |		\
>> +				MSR_AMD64_SNP_VMPL_SSS |		\
>> +				MSR_AMD64_SNP_SECURE_TSC |		\
>> +				MSR_AMD64_SNP_VMGEXIT_PARAM |		\
>> +				MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
>> +				MSR_AMD64_SNP_RESERVED_BIT13 |		\
>> +				MSR_AMD64_SNP_RESERVED_BIT15 |		\
>> +				MSR_AMD64_SNP_RESERVED_MASK)
>> +
>> +/*
>> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
>> + * by the guest kernel. As and when a new feature is implemented in the
>> + * guest kernel, a corresponding bit should be added to the mask.
>> + */
>> +#define SNP_FEATURES_PRESENT (0)
>> +
>>  void sev_enable(struct boot_params *bp)
>>  {
>>  	unsigned int eax, ebx, ecx, edx;
>> @@ -335,6 +365,13 @@ void sev_enable(struct boot_params *bp)
>>  		if (!(get_hv_features() & GHCB_HV_FT_SNP))
>>  			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
>>  
>> +		/*
>> +		 * Terminate the boot if hypervisor has enabled any feature
>> +		 * lacking guest side implementation.
>> +		 */
>> +		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)
>> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
> 
> We can't help out by specifying which feature(s)?

The purpose of SNP_FEATURES_PRESENT is just that, at present no features that need guest 
implementation is part of the kernel. For e.g. I will be posting patches with SecureTSC 
enabled, that will make the following change.

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 43793f46cfc1..cd0948c6db50 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -298,7 +298,7 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT (0)
+#define SNP_FEATURES_PRESENT (MSR_AMD64_SNP_SECURE_TSC)
 
 void sev_enable(struct boot_params *bp)
 {


Regards,
Nikunj
