Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16BE66BD18
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 12:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjAPLoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 06:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjAPLoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 06:44:16 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0354ED8;
        Mon, 16 Jan 2023 03:44:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIakE3MC5IYeaaWtLQvRmcjuw36+3MDkNKUqb2a+luv6LZtg4TQDhHewtBbkD8KSilC5USjvsSa+gWSY/PRF5ilgjRhl1IGqsM15hA3Ochl5HTwE6Wx7DBLF6MSbuFlqgYGNsQR9YWd29VAYe1uKdMCVpI2es8AiFKwHJcn617fvk3Pew5jtXO/oeg5W2UCpTVwarg+hsxZWCtZP9I9ovxqWkeV2luXWINCuGsLu1TjbPjgSgvL3wSGdfBaZvVnyxdPeKS0EjwTBmcCxdhBXFgSvJH5LY7667mxB2A9vnv40K2cSU4AE3zxi9M8eHO8e6whbjEtlgmwt5+Zp3tVBFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iwu3xG2+vTKYNmfK1wX6FKJMU7SBh65irVblb2rmrrE=;
 b=fMvdm2UmDyvF0MYwCoTGNHHSi24Cp2KOO0XsLYN5Cd329pahCLqWfQSNCC6fkZ3cC5KzpdIiWnelZp/yJt7rl494Dnl44KV5bkZygxyYrEjDx6ydWmzMph3+K+wh4GvuEUSIeeCcY38VmNsprCHjgP2+vldIzydHkCp/omZ1VbhdalsOqn2WTrDhdxM6pPldZGh3jFitoe+CouUHFwukJkoyKXPx2BtZrT/OcEySZq7cIQQ02ARtsRNJtR3SpaogpGADIxA6xmRs6GRr3p4P8+oByv0pR8KEAlSQYbbavUEYNVtP8knp0cM40Zp1PBFqytIeIHwJ6yehtVPHO+whiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iwu3xG2+vTKYNmfK1wX6FKJMU7SBh65irVblb2rmrrE=;
 b=hNPLwWBoFlY+eMOVP4GpcnYM6/wMVknj4HZL7eFZOpVYVUNqWS/U+nwh73hVIB4ylMSY5Ooj16uAcOwZGJ0X0gBFJYkWGEz+ejZsPRDn9iOrGZ74mNpgNr2N6Y9RV4RUlG0wgPu1fA/S15plSxwowEXdZsy2cfvxgrIDXGTVEpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB5004.namprd12.prod.outlook.com (2603:10b6:610:62::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Mon, 16 Jan 2023 11:44:13 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Mon, 16 Jan 2023
 11:44:13 +0000
Message-ID: <65a8732e-a569-517b-67c6-8c3670c0aab6@amd.com>
Date:   Mon, 16 Jan 2023 17:13:56 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230112084139.12615-1-nikunj@amd.com>
 <20230113135326.00006f06@gmail.com>
 <4bca96ee-3665-5503-bb88-baae98e700e2@amd.com>
 <20230116133948.0000474b@gmail.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20230116133948.0000474b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::6) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: 24ed2e03-9b70-450b-8d72-08daf7b6fd1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qv0rJ21R2OJFVCGTd4ssJSvWYsUmcHnWwWU4XWLHlXogAIm6sXw/iVE6j/jXUst+YJ2kCnCQp+c62YMNhLMpNi36Z4kfdAnvpE1+xH2Cjb0ubGZ/QjykDi77gEKLE+locFt9Zb/KS4a3A5aZTBas2+9bscnnzLhTF+J/Ur7RpW7g57o6Tv7fE0GLpM54IPM7+xOQPZpv5SRsc0FuXKG0UXIlpVsTpHqEKSX/ujnCPvRwT9x28HMIEEwi6iqStMu6EXJ83eb6mbFB26olok5uJgWto+pJuA6OO9x800Zw1swp0wTteVLTET1HqCp2YAIhhWpU8Y9KCXe8SvabJHawXFcT+2Y/Z7Ws+HZ4GnSLp7v8/hUbzA/DR4Z1GYMs2uNF5BBbYy84cR9OOyiweaEDAC+7u+bOxcSeYkPelOuGmxTkrWklL0Vwde/fsxCCcgFg0cmPRtsg1ddFtAtESNakXm6/kY3umAmyQiQ2XKCfKnz4lGcQfDjF+INpRlcWOH3i6oHMCenrZWm7UOaXuPuJ6YlHwRCqQU/KwahjAnr2pG/HQ85cElI8/fhamw1mZgxqiw8xUaWg6w0WunPqSAd0y/X9SG+Osv8YsE8q00BiZlz7h/qUju400qqRWjUAmWHrvZ6OCWI9zyycvCC3zn4uGEThmRLioyDnRuH/lwbaM7Zhewc1sXCDDCfuKM0tdjnvDTnjMKa0xuZFViRDYMLd50mOBaJGhrRvFegakxnoBT8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199015)(2616005)(186003)(8676002)(6916009)(4326008)(66476007)(26005)(6512007)(66556008)(31686004)(66946007)(478600001)(6506007)(41300700001)(8936002)(5660300002)(2906002)(7416002)(83380400001)(6666004)(53546011)(316002)(38100700002)(31696002)(6486002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFVSVG5ENWtoSEV0eUdWRFNtUkZKRkpzSUFQOG1GVnR1emk2amNaVnhEdWMv?=
 =?utf-8?B?c1FRN1RFb1Vmbmp3bGlUcUdDMCtrNFVEa1NTN1I3WUh6S3lDZVZ5Q3VzUlFa?=
 =?utf-8?B?R3h1M01FKzJQU0tpUHdmY08wVmxFMTU0N1gvMHVab2N5bEg2TnlaOVByRExO?=
 =?utf-8?B?OGZWWjVtdGd1MFJRaEdrMjFrZkdzcU5oMEpRcmNMdWpCdTVza0dwZVQ0N1oy?=
 =?utf-8?B?OWpXT2xnelFIK2JObDJOMHRvSTRTS0FQek9kYy9LQXNyUm96WG5hR2VwS0NQ?=
 =?utf-8?B?TmEydnVCSjdaZm9lRnEyelk3cFFQRnRvQk1UMHNlanB1Zzk0MTN6WGNIVXhV?=
 =?utf-8?B?MU9hSGdNK2d4UzFYdWN0QlJCZFl4ZFlYU2hkM3ByejR4NDVQYjVMVU0vaFNp?=
 =?utf-8?B?a0J6YlJPQVlaazF4Yk5iM3BiQUhEKzVJUytoaXpxRjlyaS9WVjdXZ09wbm93?=
 =?utf-8?B?VUpDc3BmYVhkLzQzRC9PYUlIY2JpeTlmQnl5R2RQRXZJN2Zvb0Y3MEZmK3Bp?=
 =?utf-8?B?L01yd28zZlFiVXcxc1lrZkxLOXZ4cDEwVjlxblZEaFVxNUc2Y0xSM1BBcGhO?=
 =?utf-8?B?eGxDSmF1M053b2prdUgxbERTSGxJMDlteVpESWRaaVhpUjZ4dHNVWitBbG93?=
 =?utf-8?B?dlAvTU8yWXRjKzlKdFprRGpNamlLOTFpWEx4bDA5aUlDSlhTRHB0SlM1c3Zk?=
 =?utf-8?B?V0UwZnVoUkpWWHdKcGM1UXoyUTRWREpZN25rcW12UzVlU0Q3ZFJlcWJncnBu?=
 =?utf-8?B?eUZQYWxaUkdOWU5TdUk4a1Z0d0VaelRWeCsxZ2wwd1A2OUp3bVhzdzJvQVJi?=
 =?utf-8?B?VHhWUndXQmJUQkdpUldONTZDNGtHU1pwVERZVlg3ZFFwbHgyRHYrdjRBMmZz?=
 =?utf-8?B?OXk4cHUrd0t1RFF0dTdrMDM5RVd0RU11OUhjMjE3SzByR0J1bVRtdEJCZkJ5?=
 =?utf-8?B?ZW1DY2xXbkN6elFLMHNYb1h3VzhlN000SjUwcXpKaDZPcDY2RCt3ME1XcU81?=
 =?utf-8?B?VVlOaXFaUHBSeTF1TUdNYUtYd3Z0ZjVUSldSWDZ0clZ4eFAxZlBOc1Nyam5U?=
 =?utf-8?B?VkRpUmtUQ3pvZFBQVTQxMW01dzFFaEdybmJYckpyaUU0eXRMLzF5d3UzdUJi?=
 =?utf-8?B?K0RDcVVBZlpPbjJZaWlJbEg2WEZTZUE4d1pFZnBmM1A5WHp0ZmtYbUlrNlNn?=
 =?utf-8?B?VVFDRVA0RVllMjFjcVJkWFc5ejA5SkVMT0JlSkhNdHFva2VPZzVJZ2NybXFC?=
 =?utf-8?B?bjJzelZXRUpTODJVVWdUUVptOENTY1Z0ZjZuZHVFUEx2YS9vK084cjRFWWVt?=
 =?utf-8?B?eTR2TUN3MzdPaEtTSHlheXVnRGJKNzR3ZFVDU2o0d1cyVlNpeUo5clAwdzI2?=
 =?utf-8?B?Qm96eWtRRmVzSjFpSm9ERGEydm5SUHBPSHRsUDg5cVFDU0lxYTdDNS9QQTYx?=
 =?utf-8?B?TE5LWTJkOVIzTnQrQzlzMVFyaTE0Y2lIZ08rRU1TRlRYMWR3T0p3T2hWSFZK?=
 =?utf-8?B?TEFqNGw0WFdLSjdXZXdmTCtWNUVGL01HUGFxWk9TaWNuK2Yrd3NEZDQ1d0V6?=
 =?utf-8?B?ckVhNHJ1c0wzZ0UySmVSdUxLSDZ1Z1hOZGYzY1J3MURFbTd0d1lVR2ZUdTcy?=
 =?utf-8?B?VEhtc3hFNnVmaUNtMjdHQ2pJZGxqRC94MjBSbHgveXJvTFRFVXlEM3BMTjRx?=
 =?utf-8?B?T1lTNmJoQzVrRnROd2NhQmVKRWREYmc2alIwU3B2dkRQZG1QRDBpZWY1UXVN?=
 =?utf-8?B?Nnd0NW5pRm5JK0h6emFsWHhkZmZ5ZXhqK2M4M1F0Z0NSd3g4cnU1dElHRGJX?=
 =?utf-8?B?emY5YWtheGhFbHYvNU1BSWlSZmxxVTdPdUtMQkZrK2t0ang3cGNISjMwVU9N?=
 =?utf-8?B?c3pzWEs1WHZGbUFiWVg3b0h6bnNwUnRoelBvOEs0THRGdTFya2lNUXV4Q24v?=
 =?utf-8?B?aHl1WFdHRmpYQzQyVUpDTnVTbFVsbVJheU9BTUF5ODMxcCtNY21TNmFUZnVs?=
 =?utf-8?B?Y1V6bDk2a1VyNnl4dDQvd2xQMCs4VEl0czZhV2Q4Q3VSTmV6SFN4d2FReEhl?=
 =?utf-8?B?Y0dnUk1WNDdJaUFPTlhkRTBhRWs3bC9EVGNoY21NaXl2dkIvOVJiUW93YXdz?=
 =?utf-8?Q?6zhY1n/bwa4mcvWCaoyEHm50r?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ed2e03-9b70-450b-8d72-08daf7b6fd1e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 11:44:13.2998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8heElon06Pn2zfHFF3WJjEnE//Th9ZlBvIdc+tEm2JYjLjPYc3imVVxx7TJPKuMXYFc3b7zJdvOYczYB2pRpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5004
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/23 17:09, Zhi Wang wrote:
> On Mon, 16 Jan 2023 13:53:56 +0530
> "Nikunj A. Dadhania" <nikunj@amd.com> wrote:
> 
>> On 13/01/23 17:23, Zhi Wang wrote:
>>> On Thu, 12 Jan 2023 14:11:39 +0530
>>> Nikunj A Dadhania <nikunj@amd.com> wrote:
>>>
>>
>>>> diff --git a/Documentation/x86/amd-memory-encryption.rst
>>>> b/Documentation/x86/amd-memory-encryption.rst index
>>>> a1940ebe7be5..b3adc39d7735 100644 ---
>>>> a/Documentation/x86/amd-memory-encryption.rst +++
>>>> b/Documentation/x86/amd-memory-encryption.rst @@ -95,3 +95,39 @@ by
>>>> supplying mem_encrypt=on on the kernel command line.  However, if BIOS
>>>> does not enable SME, then Linux will not be able to activate memory
>>>> encryption, even if configured to do so by default or the mem_encrypt=on
>>>> command line parameter is specified. +
>>>> +Secure Nested Paging (SNP)
>>>> +==========================
>>>> +
>>>> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be
>>>> enabled +by the hypervisor for security enhancements. Some of these
>>>> features need +guest side implementation to function correctly. The
>>>> below table lists the +expected guest behavior with various possible
>>>> scenarios of guest/hypervisor +SNP feature support.
>>>> +
>>
>>> "guest needs implementation" seems a little bit confusing. I suppose it 
>>> means the feature is mandatory for the guest. 
>>
>> That is not correct. None of these features are mandatory for the guest.
>> The hypervisor can enable this feature without the knowledge of guest 
>> kernel support. So there should be a mechanism in the guest to detect this
>> and fail the boot if needed.
>>
>>> If so, on the second row 
>>> guest can boot without it. Some explanation? 
>>
>> In the first and second row, HV has not enabled the feature, so the 
>> guest should boot fine irrespective of "Guest needs implementation".
>>
> 
> Feel free to educate me if I understand correctly or not:
> 
> There are two kinds of features in SEV_FEATURES:
> 
> 1. Features that HV can freely enable/disable and they won't distrub the guest.
> 
> HV   | Guest needs impl | Guest has impl    | Result
> Y/N          N            X (not necessary)    Boot
> 
> 2. Features that a guest has to be aware of and handle when HV enables them.
> 
> HV   | Guest needs impl | Guest has impl | Result
> N            Y            X (Dont care)     Boot
> Y            Y                  N           Fail
> Y            Y                  Y           Boot

Yes, that is correct understanding.

Regards
Nikunj

