Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557E565CC5F
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 05:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbjADE0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 23:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjADE0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 23:26:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8731812AAF;
        Tue,  3 Jan 2023 20:26:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmkPZyTeGLgJtDDp2SOQ55tVMOsAZsIa913y7xrqpVhSsrlKevpU3V0MJNLJJ9Ewh84amSmbOZ30RdJZxGOwFgN+AU6Iy6ZIx3yN3tzvvGxzy2Kog4wcWbMn6CLLnoPxHxCPdzkOFfU2Aj26WjPmQpWfbN1mY0T/VLEPSwSp2GUENiEYacyaKLYviZuOLjy5dCLE0JVCLxeIIoAyeHWx8PqdNUDGbK+rqwDNjVjxKRCYV+gKK0hP2Hk7QtqkSutYuE6wJH+S3MSwvsYg/DxWUPQq1T5FpSOM6cmO8u7h65l8ujZfB4gK/oQj3t39QUnwax2prHHWuzA0lfFpMq4sPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anLEN99Fxv1Pns5TJeiumJV7ITFoIvTOUvbCucYbKSg=;
 b=f0Bti88/JFoo+1UG2eBrnY77c88MuBg8Kk4IP+0NIctLnnaC+UwbkIpSyl1CMTDvoxYzagnrf2H1lNVcTMYOpq9q7rBEIbaw3Y0yCzzxDaoU0MBZU7ufCkLdyK9uTgnJ3/goa/nFKHjbZ5VMCCvK4lMLnbvkQToiFxWwwjw7UHaJDHmwZYrDwsbkFgzTAkyzqJNxFNDLgXMGz6n/F5bXBfbvV33BhSCqZgxuOlx9Js5pyRi2fEwju4U/wgXGieMiYXrjofk/0LJyszLBz0b+T5mI8LEDG+VkDNgVZndi14FsyMeiDiAReldRMr7JUSclOlhaUTvPhPs/qxXLnEDFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anLEN99Fxv1Pns5TJeiumJV7ITFoIvTOUvbCucYbKSg=;
 b=e6IASXaI3tKYWTmLXYapTONzsBEaBMu059pjy1BWi8ixQzN2AbUmz8mauDpoOWOsTdwrxFQmVv2mTgwPwfA4VlIzSvRqBmgmS3/0FS89FD5P1slWHGDWHgKxa+JhfkOy3/bb2Z0hbDgfoCwXaZUnc+kRlyprppARAzUcXMhvvxg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB8522.namprd12.prod.outlook.com (2603:10b6:8:18f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Wed, 4 Jan 2023 04:26:35 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::15a4:6861:1131:87d3%6]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 04:26:35 +0000
Message-ID: <46ec426b-e6bb-5286-77c2-1c4cf1fdda93@amd.com>
Date:   Wed, 4 Jan 2023 09:56:21 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
References: <20230102083810.71178-1-nikunj@amd.com> <Y7QwXcAUmS3VZcbH@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y7QwXcAUmS3VZcbH@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB8522:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ed2c74-b4fc-4d25-2243-08daee0bdd12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZHR3PVyegPLITPNshFw8YgtQ+V5pKrDzI7IixY2X0v1YaiJJbDt9hxm0dmVExMoVwhfi2df9+WqxIPWexxAK4+ujmTnZNJg7nVj3XW57H0MA64Ar16+uRp9ibpgKIaQWuahKxlwWcwih+2vBO8+AUTfiIlZW57rfJIPH3YrmuwnjbeFsx3n08haodSvWojxB9/NcRv1mUR8BBuTWWRTXytcALKiGyvyaPUR0yfe7TrPouCRInPmRZ+EX9oyASQIwKvw1wlg3jKyinTfzGCvm6mKJFNA+mlH+Owqe953Im4LIXBeNw3vZ/j2XXI8NA4fO6F5yDu/z//vXik1MYa7bpnYE6jwdvHXd2mLjnxM8Rb6uKa+caiR0Ygk42vVBZReVzCSZamiMcAwFh01U+Um3y3NccK409epZjoZTKojYOjw+37WVmIhEWEqFMqejo66c3WVJDUyXg3GyShJ0ybGuyOjKoPDd15Ko72L7cfu58pIu6pFoBG4mGe93H3X/7oRG8UmIRGi0VHvRaJSplF3GF7VXncZh7CUHfBvHSTMHRC9DsjRBA1nPwxTbZbIBQWiw9gdaCnh97/1GSX1hw85M16JjB0+1wWOri4ViOyZM/wWegUUb2YVNXGK1H4+FRLpfBeTpxyh9y6uxwrdRWzYz60ApY3fOszlZ35olFkpTPckRNEwt1+C/IHlfu5aaGUs7BrsMKASIrfFbAPbOhiG8DD3Cq0yI9OXoHEAz1G7nkuzMTtOPbOurf9pnlmc3RsmC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199015)(2616005)(83380400001)(186003)(6512007)(26005)(31696002)(38100700002)(36756003)(316002)(2906002)(5660300002)(6916009)(66556008)(66946007)(8676002)(66476007)(4326008)(8936002)(31686004)(7416002)(6666004)(41300700001)(53546011)(6506007)(966005)(6486002)(478600001)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmtkQmxMUFNyMEJ1WWMxOEErSmxFUnZtTnNaQ011Y3l2NlEwQnhmcHM4aUdI?=
 =?utf-8?B?Q3AvTnZuRlNhbThTTHNuUzBTYVBEbnlCdVZIR0k1d0Y2ejhEUTdXSzVEY1dn?=
 =?utf-8?B?dkFHaTFmVERLaEpxMWZsZjlPdWM5Q2pId0ZpZ0YxbFA2MjYvMWczVUFNMHYv?=
 =?utf-8?B?eFNQMDVrR0tJYzJGNU5tMERQU09KbEtRaTVMV2wrYXNDczhBWDM5d2dIOFdP?=
 =?utf-8?B?enp2NUJQaWk3WkVrZ0doUWs0NDNjOFlkRE9XT2RmMU5uYTNHVXRlTVFpYmNU?=
 =?utf-8?B?bzZoMEJqUldITUJWTzRGcDNqQ3JPc1J2aGEwbEd1Y2pxU1AyYjJhcnVTcnNW?=
 =?utf-8?B?SUpFeEp4V0R4ODB2TmYzVmJmTmp2T0pLdEZ4QWQ0QWYrcVNscWttSW1HL3BP?=
 =?utf-8?B?SjgzemFIS0Y0d1V6Ym1Yb0ZzWUNJQnpDbnR4T3daNm5SOFFGZUVqWTlHZzNa?=
 =?utf-8?B?UkNMdHZuVGlmNmNOWUp1SWgva0V6dVZsK1dkWTV2MjZFWTBhcVBvYmQrNURj?=
 =?utf-8?B?eEltcWVmd2VpMHRSZ21ESnVGSXdOd0NIa3NsM3IxTmgvUHpXRkdzRFB5M1Vi?=
 =?utf-8?B?NlBIcyt0eTlRVG1kN1Exam5HWm9iTHpTbmRpN3pBZjVhVVF4OW91ZE5iRW1P?=
 =?utf-8?B?MnErcTdsUDNNWGR1MVh6WG85L250VncrRkZlSmlCVkx6Z1U4L0FrRGhFbzYv?=
 =?utf-8?B?dk53Y2NsR1RkWE9vSXBDNnpwRVpMRFo4K0VzR3FRWTNuTmpTQnNXNkp1bjdG?=
 =?utf-8?B?cFNEK2ZlUEZHdk9JTHlLT2ExVUVMUjZvVENxZDg3M3Y5aDlxWmUxeVFPN2ov?=
 =?utf-8?B?VWZRd1doMVM4cEVRU2VvWjNKZ1RjanljMjNFL1RyYVlPVjFuWTQ1SExnbkF1?=
 =?utf-8?B?ZWJiNkZHSTJNWG1wckhOWVFzRzdYVVhYK1FNSDRoZDA0UFFXbGtLN3FQbDdZ?=
 =?utf-8?B?WVBHZW9mbVVtbVBqV2VKRnBEVVRsa0V5WnNGOEo3SkZTaThLb29uRU5aWjBz?=
 =?utf-8?B?T2h6cHQ1MUUzZmZ3WXBCalpmd01yNUIyYXFNVFY4QzlQWmpKVFVzd0RGUGxw?=
 =?utf-8?B?eFR2SHlFYmsvZjd0V2pIQmo4R0hYZ21IdzFWc2ZsTjAvcXFiajA2ejQ1V1lp?=
 =?utf-8?B?NjdYWW52a2tGRm5od0JYVDZsTWpGVEVxc3FUWWUzMjZ5TWZGNHJiOER3dUtm?=
 =?utf-8?B?dW5oL2VLUWlMNGVRZngrOEVMRTNRVE1hR04wd05zK2lZU1pISzVIY0o0MDRK?=
 =?utf-8?B?Wlp5ekRnUGlRdGdzODA1by9VclVKUEdyRDA1d3p6Tjc5M1R3VThNQlVHUjhi?=
 =?utf-8?B?aUsvMUxCc2JSZDd5Z2p6M1ZNQWowRW1PS1NQWVFPdjc4cjlRWmE1cTZCemlI?=
 =?utf-8?B?U0pjc3FwWDBiZ0RjNW1EY3MrT2crVG0rMHVXQSsvd3lnemc3eEFjbG42dlFs?=
 =?utf-8?B?YThSTzVjZmlKbUZMaEF1aXdZL2thaXgvd0EzditRRzZUSlFIdlNSMlRMeDUz?=
 =?utf-8?B?Y0Fnb1MrZERMZlZRenNBcXMxT0xubkhWLzNYeXpKeTE2bWNYcW5qMUhBU3hi?=
 =?utf-8?B?ejBzNmtucWhVaGt2U3ZrSmtvcFB6RHFObWpnWEg3TGR4RkJxRVIyTEVCLy92?=
 =?utf-8?B?TWtua09TakRXbzRhQUlEeGJLcE92OGNzT3AvZHNSQTVxdzdzcXlmU09rczRq?=
 =?utf-8?B?bG9lNUx6RSt5YVMzQXhRNkJOMDltZ3hmTGRpa3ZQcHBDVkpIUnFhMkcxY0Vp?=
 =?utf-8?B?bFQzRFRvZ1RIOGJLdS9DUWVpOW1FbE1yYTkzb3QyTUI1Sm4rWE1wQ2hUVS8r?=
 =?utf-8?B?Tk1QU2VpVXBuUCtVVERESGR1ellSUk5vNnlGR0hIcEgvNWtXWmpPeHAvTlNn?=
 =?utf-8?B?SHoyS0kwR0Fha0N3YzJjempZRUNjMmN3bU96eXIxaEwwOGpRTnlEZGE5T1Ro?=
 =?utf-8?B?YXdnM2p2T1lwa3VXNFFBcWZkTG96bzZRQXEyS3FudGUxSEE4ZXVNcmxtQlBF?=
 =?utf-8?B?Ri9nSkJFc2M3MmtScDZDTmY1eE1DWVI0QUNrZGxkTXZTZ0N6Y0VHbnBGK3pG?=
 =?utf-8?B?QnN3ZGZ3TmFab1RhUGQ3NXN5UU1rTG5pdjYvWElCWlBZT05MOWp4V2dEdW9U?=
 =?utf-8?Q?5mw55Jw9MVsBRoMnE5GfRqtdr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ed2c74-b4fc-4d25-2243-08daee0bdd12
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 04:26:35.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zS3GUrrZYVk26u8SudZkTYmrbadCtzQUFWpSEPIjrdFnEMoz0GzHrNUMXJf0CHMeZQlU0YzlTtIB9ziKpMM1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8522
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03/01/23 19:10, Borislav Petkov wrote:
> On Mon, Jan 02, 2023 at 02:08:10PM +0530, Nikunj A Dadhania wrote:
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
> 					 ^
> 					 the

Sure.

> 
>> booting, SNP guests should ascertain that all the enabled features
>> have guest side implementation. In case any feature is not implemented
>> in the guest, the guest terminates booting with SNP feature
>> unsupported exit code.
>>
>> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.amd.com%2Fsystem%2Ffiles%2FTechDocs%2F40332_4.05.pdf&data=05%7C01%7Cnikunj.dadhania%40amd.com%7C6575db7c0d8f4f136d1f08daed902274%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638083500715058552%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=weTrXWfPxDBdu9OsFZ4FxlvlgbhhG%2F985%2Bii%2BM8vh6I%3D&reserved=0
>>
>> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: <stable@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> ...
> 
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
> 
> No ":"
> 

Done

>> +===========================
> 
> <---- newline here.

Done

> 
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
> 
> sphinx is not happy about that table for some reason. I always find the error
> messages cryptic though:

sphinx uses spaces before multi-line text as block quote. Also, found that after the table header it needs line with "=" and not "-".

> Documentation/x86/amd-memory-encryption.rst:110: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/x86/amd-memory-encryption.rst:110: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/x86/amd-memory-encryption.rst:122: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/x86/amd-memory-encryption.rst:128: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> You can repro by doing "make htmldocs".

Fixed, 

+-----------------+---------------+---------------+------------------+
| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
| by the HV       | implementation| implementation| behaviour        |
+=================+===============+===============+==================+
|      No         |      No       |      No       |     Boot         |
|                 |               |               |                  |
+-----------------+---------------+---------------+------------------+
|      No         |      Yes      |      No       |     Boot         |
|                 |               |               |                  |
+-----------------+---------------+---------------+------------------+
|      No         |      Yes      |      Yes      |     Boot         |
|                 |               |               |                  |
+-----------------+---------------+---------------+------------------+
|      Yes        |      No       |      No       | Boot with        |
|                 |               |               | feature enabled  |
+-----------------+---------------+---------------+------------------+
|      Yes        |      Yes      |      No       | Graceful boot    |
|                 |               |               | failure          |
+-----------------+---------------+---------------+------------------+
|      Yes        |      Yes      |      Yes      | Boot with        |
|                 |               |               | feature enabled  |
+-----------------+---------------+---------------+------------------+


Regards
Nikunj
