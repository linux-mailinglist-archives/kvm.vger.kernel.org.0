Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4796730F1
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 06:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjASFGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 00:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjASFFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 00:05:09 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE6AFB;
        Wed, 18 Jan 2023 21:00:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UY/6aDOnpIjO95llJaxJypwbL5sPt9aLAUjtApqKTm2nnhLji4yS8PL1rvkt+KYU4QKO9XB4H/tQjhKctqBw1TtZGLrijz1Sv5pBTBjOMRosbodw2p5Dft9fdE1PQP8JUXhDJdfTMoZI9mLL4C/G8mQkZJZoVc5OB042CnQDHPJkn84Z8TX+i8IhDQhO+b6ZaoyZeqbq3AT2Ds+DIFnnjxoemSJYX9aUkWqDI0KhvHHDKdVWa031c/LdDY/D+flOCEuhuCFxwCqZQRojZCKEqUg11CfOpCOYWYzgatGn5vU9op8jnwpxzbE0FQvQ6YwFA779YE+cSbO68A4vMeRbcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2AF+6LsN34IHbuXzYJ8U4rtXU0Z3Z0QNCver9J2wwU=;
 b=Z7pdp1UFE7BkakoZ96tsLoaTG4WuxAamSAh71VbnCtiOj/EUyatBmEKg3ppGFzaBreJMl17kmPpiysw9IMMt2/4g6UNvkn+ViejYUs3XYMItpjdD/z/y1XcW6uT1SQech2x4Vml5/08I+1DxLlforq3rt8OqIORYp6/XcJlLGCXfRKH/NDqDSeuu7GCEgmO9BvHfn6Y38R+m3LwNereCBzLs2uN2eo9WMr+oqMNwTzO2Jo6746Q9xYWlwT1QPjf8KIMpJIFwI07AXeYStiyjxo/wqocdigkzaUxislIls6PFc7OWsYuOiWHC9vXvU1rZVRs7wiFo4yyn4AUX1ZZ3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2AF+6LsN34IHbuXzYJ8U4rtXU0Z3Z0QNCver9J2wwU=;
 b=Gq1Kx9WvcjicWhJ9HIdRbtoGzo3RlfzB9DILpITxv5E8ZCjaoa7SgsEEFhdm1YpcOq3AznORc3KZpxwXej7i/K27X0N2TLqMC9X40lFl8jrQncEr5GXZIL43g1OyHIJqpefWJM7zbmRsMjKA005Ds8HSbILTWo7WfvIIGE4UZpc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 19 Jan
 2023 05:00:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Thu, 19 Jan 2023
 05:00:08 +0000
Message-ID: <75531440-7dd0-8afe-6142-999cb221e9cd@amd.com>
Date:   Thu, 19 Jan 2023 10:29:49 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v7] x86/sev: Add SEV-SNP guest feature negotiation support
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, zhi.wang.linux@gmail.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230118061943.534309-1-nikunj@amd.com>
 <Y8h+7yb7lq/HCWdB@zn.tnic>
Content-Language: en-US
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y8h+7yb7lq/HCWdB@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR01CA0110.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::28) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: 53eaaa91-eda2-4b12-5b6a-08daf9da0888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pKmI1vqzfPItup/XyN8ono8MhdkJLgu+G+CP+zX45XbbeWMky/NCEoNa4AKGBHSLZTNDG4ibqnb3r4OMcTX7MRhDaPaNWGXV1n2zkkgsPq4/cQ0l0IuymkMTWVkjB0eQDxbQPxV8NVZpFf1GujTGeN2H9mdKlZGwtt0APcFmQKGM93N+F3pjBQFBNkL4piBeMK4yE4Ql7/40uZmI5+qfZY2ISGzSAHsHtGk+nnoyazb+TC88eBrCGR1WN17A75Rj4n16jEx2VvNyr66UT20fSaTCdqXb9heSGfr3KN5bMKs1k7uLMtPavwoJedOnASL2WNRz5uVriDwfkkr/SA7W8Cmj5MFaI4X3H0iyc3t+9LEL8r3ZoIHmARIVDa6tim2XySX5vgqdg87mgkRTdWKtdhyXuuoWbJ4oOhx7Rk3usU5j4V4PVxjDq0cLBKV5Q4Dal8FxTG54EE1B/fu7gBRHenVj2nPSA2wqCYp1y3H99Sv1009yuuyGdh/+fnxZpcFaDMAIAKO6oPAYVipWWsQiJfada4JafA5reohkK+Hx3R6yVAtV4ompgZ1iTZI6zXnB2Amxv4vrlzkzZGhMMNbk4nXFo9LiPFq5xVoKGYGgOS0skHdtXGl3Ws1Ooo5TFEYWdmIqzNUvbJZHACTGRJS5sBC+i0CtzttPkqPZx5Sjw1vTzv5cAXBQyd6p5qev6M34nqgaz8NF26Qe4XtVqZzP1QfyRFvDDhPeY1GglLHAjLinzptewkY+Sj2ONxRsHaksdv92XGMyBdaeYZIHcBjgZWsWOoGz2i3MO6RGWlPFe7U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199015)(478600001)(8676002)(5660300002)(6666004)(7416002)(66946007)(4326008)(66556008)(66476007)(2906002)(38100700002)(36756003)(31696002)(316002)(966005)(8936002)(41300700001)(53546011)(6486002)(83380400001)(6916009)(55236004)(31686004)(26005)(6506007)(186003)(6512007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm5DNDB3M1NSTHVDcno5ellCYWFTQlpRNU53bm5KcHJQaWJ5bzY0aVNiRDVO?=
 =?utf-8?B?c2tuM0tyMW9IeDVwZE4vZDRJaWgvdHJsTkNrWjZCWmVjM1pFZDdwSHB1YzFl?=
 =?utf-8?B?K3ZKUDJ2WHI4dllWSFY3NjY3Z2RRMi83bWR4aUFYbFZSVFNCMkNsUmpRZXlF?=
 =?utf-8?B?a2tNREhlbjhJWW5mMzRMUS9JdXQwNlo3QVhVb1E3T3RsdjdwQ3drN3JBZTlp?=
 =?utf-8?B?YytmRUNtTUFsZVRCbU1KMDRJS3FvRmxLT0gzQnk1OWZJY2NmL3RveTlRUGJa?=
 =?utf-8?B?dy9zS2NOQW41U2FNMkVVY3dRcXhoMWQrb0h6aXRwNmVHdHdHN09HZFVCTVNY?=
 =?utf-8?B?OGlDVjNRVlBxZ0YxVHliMGVGT1V6cERkb2dRVEdpRWp6QkhzVk5XdnlZZzlh?=
 =?utf-8?B?WHhLU1ZUdjByZC92NndkYlFNRHZUUjUyL2ZNV01UTWloMW5NSVdVNGc5ajlO?=
 =?utf-8?B?THRNVHh4K0hOazRtL3hQbzR0aHBCbTlQeWZ6ZDE4UlZCVk5NUkIxVjBBNkFj?=
 =?utf-8?B?a0JVNHcySVp6NisyNCt2dXpyOWh4aUNjWlYwR2xtQURIeDNTbU5BYWtYc0sx?=
 =?utf-8?B?Nlp5R0EzUmRuSkp5T1NUUi9xUHZNUFYva2VzT3lZcG9pUzNFUUpNKzNrUHZX?=
 =?utf-8?B?cXEzYUNJbGVUUGY0N3ZhUFlwVldJcFVFbHBCRnNuaXZFcVJoTGp5UVN5WkJk?=
 =?utf-8?B?cFl5aG83YjJ4ZXFmU1VXYWxmeS9VWWdvanJVemFKNy9oeHhwcEc2dno5VGI5?=
 =?utf-8?B?NlVVc3ZIVERNelhDSW5WSlIvVUhDVFNNMFhGMjdHRWhTVEk0QUVnNElNNExB?=
 =?utf-8?B?dnRnU2hLd3hvd1crMFAzWjlwWHRMU2QvUW5ick1BOENHRVd5cnlwS3pFUHVw?=
 =?utf-8?B?YlZlbDIvOTYwV3FlclhQT3B5blZkY0ZDV296N0loUlhQRlZJQlpMZkl2QjJT?=
 =?utf-8?B?dmhhSThDRDh6czJLSHRSREJEZitiYUtNQnRhM0JUNnh2VmlsQnN2Z3lLZU1l?=
 =?utf-8?B?Q1BHYkJOalV2eElGUmRUUEtwTklTQzdBRDFublBXSm9CUkhFYnp0ZTZQL0pB?=
 =?utf-8?B?ZlRUelpRMWJRYVRXUHFSOUhkY2ljMUxrTlB5QmxDdzhRZ2dwS2NRV2pNYVpU?=
 =?utf-8?B?ajNxUDcxYXFNRjRmQUJLV1BtdlBCT09BbmgxMVpBSCtiNjd3ZndpSTlERlF1?=
 =?utf-8?B?K1QvMUM2djdmQ1JPeHZvYWI3TDU2aldnbGdtdkp3UjAvMUdFZklab0xmTHR2?=
 =?utf-8?B?WW5RRVkyMld1LzNpd2F3U1BqK1AxblFGaDFxY2xxOEtHc2kwMitvTU1Yc1VP?=
 =?utf-8?B?TEl2WjBkMi9jUDJ0cEdyWWtyU3NHaTZoOTRZTGdOajJBZ0U1dlc4d3ZQc1Qx?=
 =?utf-8?B?SnQybUY0d0pDK3p5cUJJU3VSSjZwUHdMU1IxSG5wemJHc3R6Vnc1SVdlaVdW?=
 =?utf-8?B?eksrUEdaZ0pKcWs3SWZVTFkxNWpGKzFvam1MbG5YNWdoRWdWbFVoOTJ0Q0JO?=
 =?utf-8?B?UVUxQllSaW5UUHNHb1ZORllrMDF5azRJUVFGWWxKeDA0MUJ4a1RRL3IrS2Nj?=
 =?utf-8?B?aC8rSmxJNUFCSnp5WW5EYmEyN1BXcFl6V2FYaXNuOGNaU2Z6dkNIQ2w2ZnVR?=
 =?utf-8?B?M3I2SW0yZ1RFYWZyV1JXNmdxVnFLdGxNWFJMRWhGRFB4ck10UjNOb20wRnVh?=
 =?utf-8?B?aUhxU3Y2VmJiVUFaM3dLMDJmR1dVTnBBVm1VLytHWnFBejVoSE1iRTliNU9q?=
 =?utf-8?B?MktTRld4blovRG9EanlHT081SGpmQnFWeGp3NHdtMVZPdk9yMW1jZVhKTTI4?=
 =?utf-8?B?Ump3ZGJDM3VKbXNmQSswcGZTQzI3Z1FBMlhBS05WTVJIK3UwZCt6bDJZdzhW?=
 =?utf-8?B?V0ovMEtqTGJkaHd6VFVzejZDeUhINW5FTnFCOGNTelBjNmFtOTVUdGUzcXV6?=
 =?utf-8?B?NnIyWVN4azF5M0tRSW5IZFNPYU1MUEFTZjVYWW1mS0Vhb1BJaG5PRHFwQnZ3?=
 =?utf-8?B?VWRlYzdhWGsvYzNINm95RWJCOEptcHhOejlOR09FeWs3TVN3L2d4bXFlSkwz?=
 =?utf-8?B?RkpGSTErVzVkaFRPRHRTaEFsRUVXQVJmRWlwRlhvRlVKK2ZjSW5sVEVwQklt?=
 =?utf-8?Q?tJvzJmyQl2VYJUIcFCVk8v6Kb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53eaaa91-eda2-4b12-5b6a-08daf9da0888
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 05:00:08.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j60QJYDpUC04xh1wegm3TOsE2ratJpi1uWuGHtrJ2/OjZOZE0po5veWO5OXCTPm08vzJxmhj1oslGF0zwzr3UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19/01/23 04:51, Borislav Petkov wrote:
> On Wed, Jan 18, 2023 at 11:49:43AM +0530, Nikunj A Dadhania wrote:
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
>> SEV_STATUS MSR indicates features which the hypervisor has enabled.
>> While booting, SNP guests should ascertain that all the enabled
>> features have guest side implementation. In case any feature is not
>> implemented in the guest, the guest terminates booting with GHCB
>> protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
>> SW_EXITINFO2 with mask of unsupported features that the hypervisor
>> can easily report to the user.
>>
>> More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://developer.amd.com/wp-content/resources/56421.pdf
>>     4.1.13 Termination Request
>>
>> [2] https://www.amd.com/system/files/TechDocs/40332.pdf
>>
>> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: <stable@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Ok, did some massaging. See whether I've fat-fingered something:
> 

Thanks, looks good to me.

Regards
Nikunj
