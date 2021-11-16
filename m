Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E6C452F14
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhKPKdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:33:05 -0500
Received: from mail-bn7nam10on2078.outbound.protection.outlook.com ([40.107.92.78]:63201
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233028AbhKPKc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 05:32:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IW5k1E0OS0gWWqp+KKbskm4Wb9/u8Ry5Faxc/NCBvF/xSlOlGZGOnWsxuvzTerEyBfAPlKoKM558gPKTVf6qV6y+YaP750fWUIi/k7fwiOeAVdVc2ICg2kKKlYTHJl2IQGMkAjsjpHfPQS4UX8cYn7tiNW/7WZyj96rsaCDhOtjRqNlLobrRmlzLi895saCI5nXOfh4K2R/+RtroCb/dmFzUpnGRUC29YTSG22eDhCnLVV8kuCUF11yAkLmITl8Hn+KSLBXSQzwr7P4FHkMpk2bcAo5Y0vhfNa2evotrkm4kymdsnkTHo7gZjXzV+6nLDGs6TmTdXHvSlbZTLfru2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9/WH8RMykgxH4HQ2KMjxSg6Iq7CuMlzD5+WMogbh0I=;
 b=iQ0/3rYpx++5X9Dwu3ncH4bYko2TRVzexbfZLovdhym0pO4FjiRvkDbVH5cfbpTfVVGzCeBzyP4HPPaUw0TMOsUIhp5KrT2CvKlj5nP5E+jPIGC1LdcpB42EsMTgzLbdvqVF2sIzWxdq6cj7/yGDh5zjQQoweNHFChEsKdr/ZKKJD7iVZmNPt6771iwRSg88Zx9pei7tgh6K4XcRAQTwxcx5I3HhWmWJodG4CEKf1W+OfMGFxQdQugbIvpkA3B7qbMrot6nEeQz7ELmTINVzVB8zScM7eCsBEDVgIM1vLJpSwcn6mpDHaj3CiApHF0CeJJpElZWqTAKTFNUQBwVz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9/WH8RMykgxH4HQ2KMjxSg6Iq7CuMlzD5+WMogbh0I=;
 b=G84f/S764soMamLQXQpr0K0Ryt2EmYnGsr2SS0SXgQV1wmFsYZnaX4eXf9gBjjyQQMP+a0T/UtNV/+fvIZSIl4VwJ4N2OwZll85WVrOrSIePFNreyTTW4JDQ9D+NXM8OengLHYGrU6hzUUC6EnNfGzLLO1kKq/Pb3Oo/OqlWpWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5117.namprd12.prod.outlook.com (2603:10b6:5:390::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.15; Tue, 16 Nov 2021 10:30:00 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::c884:b4ad:6c93:3f86%9]) with mapi id 15.20.4669.016; Tue, 16 Nov 2021
 10:30:00 +0000
Message-ID: <34b8a586-d64e-01d0-eb95-93b7be241a4f@amd.com>
Date:   Tue, 16 Nov 2021 02:29:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 2/2] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, peterz@infradead.org,
        hpa@zytor.com, thomas.lendacky@amd.com, jon.grimm@amd.com
References: <20211110101805.16343-1-suravee.suthikulpanit@amd.com>
 <20211110101805.16343-3-suravee.suthikulpanit@amd.com>
 <YYwiBbyUINIcGXp3@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <YYwiBbyUINIcGXp3@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [10.252.132.84] (165.204.140.250) by SI2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.6 via Frontend Transport; Tue, 16 Nov 2021 10:29:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72b222e6-78ce-44e1-a39d-08d9a8ec0ab5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5117:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5117D888D597708742B0D7C3F3999@DM4PR12MB5117.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zsBNrJkj7vBmVGaSomQLN9oOn084+2LnihBfrNmQchcUPiZgNrhWpK2H6mwfW5G4Fs1BW15sfBTpAKn4pDg+v3YKS0czhY8EnLPW84x7I4NAYrl8m9w3QFliIR5lZaV0eEIIiHl6vqbIFcw0enGy2jTBjZdnzDIIutqXjRf9fGIw0uxuy6GSzZjIc9YhKbb3IYXeA7KX77qOMoC10ct+x5skMHdEt59W6OffsWlaKS5MIoS9XADpnZZEtcx2Hk6Si0DnrC9O9CviANMqShFnZVIPWnnRQdLtrwXEchZ0pv7yT8iRgwclH66WqH1XGo66uD2qGg+tCWyiQkGV7Mt7LmSH+qjNgMYBcIx+HvN3HhS0WV+RmZcljvUOT7y2X/v5r36GUdf/1geui2XnnaxpAKmncgttqgk7hMVQUDbKp85bd+BV3jYOe/0gsImYqR1A0BiJT8cypmw/jJslOY5JGkWP/AI89eEtxD+kU66Q+3zdT6Zh196VFqF1yeThzZb6qNpeGKEjZp8hUmClgMSFs7vcE9vRW2EDsHNchrl9C201BXLXmskmFIJC5IT6FdRepTXhdXWhIgMqGN9tC3LLymBTOgmndkwmkM3+NxiMsb813xKhOn+1bPULX/fFyhY2EbRhO3xXW6B6QsKrgwYx4R/DJfcz4LB2xx5aCILZdz9zk7FFpKHw98crtySr9GR8JkJdEnCkHwixFZr/SMFV5A5IE6fNFK/wo7nLOwwtNHWw02B1zKbu+l9YpaHRWJf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(31686004)(66556008)(53546011)(36756003)(186003)(86362001)(38100700002)(4326008)(8936002)(316002)(83380400001)(6666004)(7416002)(6486002)(2906002)(66946007)(5660300002)(6916009)(2616005)(8676002)(508600001)(66476007)(956004)(26005)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEVWQWxoT0x2a1B5djFxQUNPWm1QWksvRFRkOFZrdXhFbDlvMEx2QmswbWU5?=
 =?utf-8?B?TXRYMzkzUFNRamE4TU9uNG92M0pIYzlQbXlSdnpOOHNTVy9RSTA0Rk1XNy9q?=
 =?utf-8?B?am91VFpDUGNmYnRCM2ZMS09EWjdKTWpZWE9CMWp0UUhUekJqZ1JqbWc2Q3ZE?=
 =?utf-8?B?RHRtMkZSa3ptOG05ZjRjWi9JcE1VSTA2YjJTZXVFbWcrZ3lKNDJjZUprc0dY?=
 =?utf-8?B?R28xL0d5NENUSjFNbTAxMWFYZllKOVltajVYdks3Z0RNRkl4ZzhRSXBHK0lr?=
 =?utf-8?B?bGM1ZWtDODlUNFlJLzFQcjN4eGxnNitxUEpCaVlvRm5xNGJGWGtndDg1TkVn?=
 =?utf-8?B?dVIzTFdsUWdoNEh6b2JGM3NwSVA4THRhcEZVMEFVZmdLbFdreFlERTFtckNa?=
 =?utf-8?B?aTdYaHVvbTFJY0U2U2RGY05zbnBTMGRNVEozenpiRVFuMy9TMnhoT21ISitU?=
 =?utf-8?B?Yi9hbkZPOVU2OGNSdHFDdG55anVlczlTakh1NzI2ZEZjKzFRbTAybUJDd3BN?=
 =?utf-8?B?TXRMS0tPY3JYOTNNWnZMTXJZcEo3SWkzMHdJcXJodzFIMTZvbll5RVBuK05m?=
 =?utf-8?B?UjlrY3p2NWtTWktDSFlOYng0MUFPZjBBM1dVNWhPc0tFanB3ODV3N2FFSlRL?=
 =?utf-8?B?L2lORnFuNFg2TVhPaTR4cVA0ejFmSjVmZHFtd3NOVng0aVV5aUJoTjF0SkNZ?=
 =?utf-8?B?ZFFZRHE1b004VEV3ZGN1WHk5V1B2SDdITWNmTHBiS1RGZmZqL2NzVkVxTjlo?=
 =?utf-8?B?OU1KelhDSUZnZ1BUU1VmMGM4a0ZJS1gwZ1BLcUxHMU52VlRIdlhoVSt6OFY1?=
 =?utf-8?B?NmhZcENsSE5QcGJOeWNXaGlKaHlRSjFiVEVQS0FucjNZZHVEVnI3a25HSG04?=
 =?utf-8?B?ejRJdnY0TGM4RTJ3QzQ0ZUxUZVI1eFBtZEh6ODM0QkZXS3kxcE8zQ1hRN01M?=
 =?utf-8?B?K0RNQTJJOGVyRCtSMGk4d1hsL0FBWjVXb2NQQTcrWUtwS2FuTC9ZRVh4YW9r?=
 =?utf-8?B?bGlaZTg5bFU4UXE2ZmMyT0p1TCthL0lEOUQ3WTBlOUFuRWtVelJHUHBhUFFJ?=
 =?utf-8?B?ZUExejR1MHlLRmV2dVZNOUZmR200K1RMdy9IUm9rdnQ3c2xLeEcxMXh0NzY3?=
 =?utf-8?B?ZzlRNlo2K0U2MnlwdG8xdzJpcHFhSS9NTWRGc1JNNnpBRmhsRlJOVFl4OVBl?=
 =?utf-8?B?RGp4VXBEbEVYWncwbHV5cEpZYlFuL2FvcWFSL1ZLamozWGg4a2p4eXNxU1RX?=
 =?utf-8?B?dlhtNlRYWnN5VWhXKzlsVUQvaUlZSjA4dGtvR05hbmluZEF5RGpITnYrSDE5?=
 =?utf-8?B?TVloV2NZNTZwWmRnbFNpYWNtY3ozaVg5Nk9iejBmS3dPbTEyUEgya0w4UGNE?=
 =?utf-8?B?Nm9uL25Pc3BDZXRabGxjMkdEQWxBdi9VQkc1RnMydDg0a09CdUUrVHN1V24z?=
 =?utf-8?B?bTZ6YTluN1JIQ0E3MVR1SlltRkVNZjRvUDJNTURwQ1BWdGJ4cW43U1UxY2p3?=
 =?utf-8?B?SmtPSjFrSzBaeTFlTVdWZUN2ZlpFY0I2VXkvTlNqaGhaNnJ6YWhqRWtMQ095?=
 =?utf-8?B?ZnkwTGF0S0o1YnhnRjVZOTZScmtnUS9FUlZXQVBkRmJ3YkJzMDB1Qk9NZ1Qz?=
 =?utf-8?B?WW5XYktWdE5YRUVZOXlNQjd1TGhvcnJHQ1JWdlcvdVRMUEdMc2ovM25Sek1u?=
 =?utf-8?B?akZnOEhKanAwVnhUcGJQTnhYeGdSOE5RYTdzcEJKM0RHdGRJa3NWT2JLbTBD?=
 =?utf-8?B?UTl4azRZRkg5MGFrd2E0ajBtMTFkVHBqOWovY1o3Z2V0RHdRRitPcXlSek1v?=
 =?utf-8?B?YWtiUjNUUnBRTmpNSlFZaG4vaC9Jc1RVOWN4aG9iUG01TE5DWW1FMk1aL1o1?=
 =?utf-8?B?cEhzYVIzZFA1bXZCTjhndU5nTk1WTiswcGZuMXIvTG82S2kyWUFGMVgyajEv?=
 =?utf-8?B?L1JOV1p3Ky9LQ040emprY1Q3Q3ZYZmdFMWp5czFrYVVzZXd1aUpWZy9HVTFD?=
 =?utf-8?B?NUJlaVphS21WaENZTWREeVpqRWwxTjNEb2EyMyszR0dYNW5pS0wzNGxibGZa?=
 =?utf-8?B?SXFTVG1WQ3J3UnB6UC9FSEVmQXJzK2NWbEltNytWbnZtUGlBM20rdnFnYXhW?=
 =?utf-8?B?YXBLS2U3RXJhek5mblRVdlZrSlVUZi9LSnVLS2t6V3pQVEhpTm9VV3NmT1lv?=
 =?utf-8?Q?1wdu578o4SZSkIplkUuAews=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b222e6-78ce-44e1-a39d-08d9a8ec0ab5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 10:30:00.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1gIpkVt0s6qs/ZGtVBPXoZGPzHRPlrOJTt5qzRO9zJGCK3jRpreHQkpa3xRGrA0ZA8vKsvqDabMqTs8V2mLOIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/10/2021 11:48 AM, Sean Christopherson wrote:
>   Wed, Nov 10, 2021, Suravee Suthikulpanit wrote:
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 989685098b3e..0b066bb5149d 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -1031,6 +1031,12 @@ static __init int svm_hardware_setup(void)
>>   			nrips = false;
>>   	}
>>   
>> +	if (avic) {
>> +		r = avic_init_host_physical_apicid_mask();
>> +		if (r)
>> +			avic = false;
>> +	}
> Haven't yet dedicated any brain cells to the rest of the patch, but this can be
> written as
> 
> 	if (avic && avic_init_host_physical_apicid_mask())
> 		avic = false;
> 
> or
> 
> 	avic = avic && !avic_init_host_physical_apicid_mask();
> 
> But looking at the context below, combining everything would be preferable.  I
> would say split out the enable_apicv part to make it more obvious that enable_apicv
> is merely a reflection of avic.
> 
> 	avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC) &&
> 	       !avic_init_host_physical_apicid_mask();
> 	enable_apicv = avic;
> 

Yes, we can do that. I'll update the logic in V2.

Thanks,
Suravee
