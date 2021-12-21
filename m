Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4347C931
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 23:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237869AbhLUWZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 17:25:40 -0500
Received: from mail-co1nam11on2072.outbound.protection.outlook.com ([40.107.220.72]:63004
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230085AbhLUWZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 17:25:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtOWqLLtNppsugQqRL/RqkRGGQGtTwozjtpsMzDsxXc0vZXtupyCMj3PiSG28mMaspvMWnvs+SYA65MOYXJfzpFRpLpfTpY0J0f5s7zWJyvDesV6aKy3NPAQQXHQ2QkqQDwuUN1GuVHFmKxuGWHIjvi7IMm1UVgh+Pm8yWoEsDePwutlbGGmEWdzId1prDM+rAE2dW1h3SN8TY+yIe79FjIuymuLtE+Mmp+mZIZpmLQJoU99jud9KmrDX6/3odEgHHhXwyZSw3Md5Ls7BZ+EfNCrspoBpHk6VXjezcDsq65nH45LDkg4xbWEzwaMIgcg+wupmgBmvwERzbmhTYPfiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J8cTUI6sP8rauWJtihEx/RD3oy5PBbgRQZM5sY5XaEU=;
 b=ndqQt67ElD6090QyXp+tZVegCpRY//WerjnZb7bw8HFtaGvRHtM8WkLBaWVDgllj85/2oDurDcM0AWzul4B/8FZ3zPhc3bZE9Gy7rqlixFbH9tbuCCvGAt4UmLWq02ejWc5MxO84o8No3lEPAMia/iER61n/VJbKQHnVJZoouaLU/ggjHT755mzbe1+Lu0gnaumtnDGxHpSIggp1akSDk1b20oFg+tNa6h7q4F3MYvO21tWiJzbnbrFqSqUWIdEyAHGVhSHefgYR0JV0370nISqUjDVzVKyViu0zu8AXpltjAJN1vhz9sI6bjJJj5TQhFj0W+Gl9nPVXE4cSm3RI2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J8cTUI6sP8rauWJtihEx/RD3oy5PBbgRQZM5sY5XaEU=;
 b=jS0Hgtjrw62oOYikYb/T3YutFGzBu+WnMppcZuir8w2W2ocg8CD3+VD4dmdxgdUySadiA89Mib3AodX1u/EX/HmaCmgekP5XPXfil1eO86f2Sp09eV+OHl+/VYPUn0heaRiH3TZ1FBb3VOzSupMvMRpYpdHGx8+84BdaMs2vq3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5103.namprd12.prod.outlook.com (2603:10b6:5:392::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Tue, 21 Dec
 2021 22:25:37 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::2429:24de:1fd2:12c5%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 22:25:37 +0000
Subject: Re: [PATCH v3 0/9] Parallel CPU bringup for x86_64
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     David Woodhouse <dwmw2@infradead.org>,
        Igor Mammedov <imammedo@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "luolongjun@huawei.com" <luolongjun@huawei.com>,
        "hejingxian@huawei.com" <hejingxian@huawei.com>
References: <20211215145633.5238-1-dwmw2@infradead.org>
 <761c1552-0ca0-403b-3461-8426198180d0@amd.com>
 <ca0751c864570015ffe4d8cccdc94e0a5ef3086d.camel@infradead.org>
 <b13eac6c-ea87-aef9-437f-7266be2e2031@amd.com>
 <721484e0fa719e99f9b8f13e67de05033dd7cc86.camel@infradead.org>
 <20211217110906.5c38fe7b@redhat.com>
 <d4cde50b4aab24612823714dfcbe69bc4bb63b60.camel@infradead.org>
 <36cc857b-7331-8305-ee25-55f6ba733ca6@amd.com>
 <c1726334d337de7d7a8361be27218b44784887f6.camel@infradead.org>
 <02be2ef0-8a18-553f-2bd7-1754c3f53477@amd.com>
Message-ID: <7b079111-3185-e345-acc4-40e72fdd6e92@amd.com>
Date:   Tue, 21 Dec 2021 16:25:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <02be2ef0-8a18-553f-2bd7-1754c3f53477@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:610:60::36) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f142ac58-a92e-4ca1-3c3c-08d9c4d0d020
X-MS-TrafficTypeDiagnostic: DM4PR12MB5103:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB51037E1AED6B0EF17934BF69EC7C9@DM4PR12MB5103.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWBAG1pRxkYXQNJlq0TyyZ50SXPutO7fgPLiQBm46H4bhM4pfWBcWQTu+uKuirBmGYuJoaFSRuBDnlHXB0KD6/PQMiGDKZVpQbp2TWnlCEiANxJQK0pnE7IhK99aYYleCQIJ1sfCkMixsd89q3If5hkl3LKtyeqBRMQxDqL1fbI4l7/6N0JsyQIgmGMMZibBsCRLHnxg/RhivvwRTp6jQRidHjWGhEI3e5u7FupFYjrKxQAP3PGi0vmzcHczNRoGGK9GMjOYbipXP8T020y4kad5H7FHK+EzTOa5ntmz9rc+lkmcc6hLzt9osa2y461kB8Av2fpjAymeSoYl8qAGSJnrXwu4IFRSCQEyqiUl60Za8ImeIXE2Shogg/6Z1luZARm9x+9AM2xha0Kw3M69Qi0DhIqgpd/1Y8RJPoWSEBxOPqWcocQIGBn4LX+1o/tkIbZB0DUXp8k8BLF90ArcDrumeTmUB0/4L68muraRmq/hWnGLqdWrdbtHl8F1mniGIwEQf+CctXDoJUm9GDBk9DJtljBKfaT6C/RLOoEoaVxq/KE4moUG7pw3/zglAShAwjLLkxXyjZ++OfEHDpLOqnwAhLdLGAoJWncICBm9Cw/klp7RMHZGFxZaf2TePrTLyB4YLcfCZ4F4M7VMjV/c2EeTxdg6BlWFdY0MG3UmjARFSdBwaMe7EBZq6al8peupLslgFzf7Be6xgw5B0hCbwQ66hAZ0FWZye+CVGL5uexPMSqtC8DXP3ZHEHrHB8IJ0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(8936002)(6512007)(4001150100001)(186003)(66946007)(54906003)(5660300002)(508600001)(316002)(8676002)(31696002)(6506007)(66556008)(6486002)(53546011)(2906002)(86362001)(2616005)(36756003)(31686004)(66476007)(4744005)(26005)(110136005)(7416002)(83380400001)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVZhbm5YSnd4L3B0b3NXY2U2RWJocHdaTm5Ga3VqeDRlWEFxaTdJL2o4dXJ0?=
 =?utf-8?B?MFhRekFCV3Y5dFZORkhZWDNhMWw3TExqa1V0QmtyNHJaTzN0VjFwQUFoZThP?=
 =?utf-8?B?SXNBYWRCcGNzbXkxNFhFeGFRMDB0d0xXOU9aSkoyT0VZdW9iclFZbDNudElU?=
 =?utf-8?B?Q3lRNlhINUovenRLRlRYSjVQVXV4ZTBZQnpTQzRiN1VaWCtjd2VzWHpuQmlB?=
 =?utf-8?B?MkRlKzNJOHVGcnZlOWtDMllWTG9nQ1BqRWphU0tUY3Vlalo2WXhWeDZFeERG?=
 =?utf-8?B?UmZMeVZJeWduSTJwUUpwd2RiM3V4VWREelNTSWoxNXNieWpkQW4zMysydjk4?=
 =?utf-8?B?MzhWYVU2TkhkR1FuZlppbS9JKzRpS0FVQzZvd1BhMnVDampUWDlSZmtDb204?=
 =?utf-8?B?SFZUa1MxNUFZVEI5aVhBZzREWnRRMlhHTS92clFPT00xdjZiKzQ4RGszTVZC?=
 =?utf-8?B?TDN3eGVha3gvQVBpcUVkQUoyL0ZIQ2pBQTVqN0tYU212RkkvY2w3Q21jYVhl?=
 =?utf-8?B?RlNiSHdLR3JEZW5wZVBCc1FUNThvL3ZJaHIvbWJsOG5CalNFK2U4eWFSNktC?=
 =?utf-8?B?K21lWHFCTHAyeElkQkM4NEVnM1ZGZ25kblVOVzdabnNTbzFJRU9xV2VSaVM4?=
 =?utf-8?B?Q3FIYVkxTUo4SDFDM29XbWRtaFczbHV2VFk1dElxdlBCZHEyd3ZaZkg3bWps?=
 =?utf-8?B?OGVNV1pxU1Z6ck1md2ZYTlhUV1dnY0RDT2E3V1FVdXpXM2NxK2JiTHYwdXNZ?=
 =?utf-8?B?dVA3NXBqWjNobXcvbGh4R0Rqd2FJRDFDN1pITnZic0tpc1pLMldQaG9yWnhK?=
 =?utf-8?B?SXU2WUVMMDZJcEtiRHRjZk5IYUFZZUFQTlBvejZUeHZmQXczTVdUeStybWN1?=
 =?utf-8?B?NmIrWlRYSVdKLzRvTXlXYThLK0NDakk1WEJLUXZ2ZEF4U3ppQmNUT2hsYWZz?=
 =?utf-8?B?RlN4c3p2eGpRYnNKUkFVRVhtUW10T3hwYVphbEZSNVJNODhWMG4zYTdZaHpR?=
 =?utf-8?B?VWljNWNNdFdvVi9sK3Y5TnpWczhqRGlLYnIzYmI3NG8wc2hrT2diWDloZzRS?=
 =?utf-8?B?Z09qTVB0eFEzaERibkhmbGdITVllUzdTRCtLT29UWnJLSzFSaVppOCtyWWNG?=
 =?utf-8?B?RHVwbEcwQUFxNEdRQUZyci9ibDVDeWVEMDVEczdkbGFrZnhDYWN3TldaMGZH?=
 =?utf-8?B?UEViOXBxc2s3MHJrR2wvYTBsZmRJQWlLRGszbys4K0REY2N2SCs2eDRtOEJZ?=
 =?utf-8?B?VUUwckVjTUN6OUsvbUdTZEp4M0FUemJidzV4aVRHckV6a2R1aXhYYVJXU3Q0?=
 =?utf-8?B?WEY5M0tYU212T2svelY0UWZJNkd6TjhqMjNoT0RmVGN5bURtajRQYlZyZFpi?=
 =?utf-8?B?OHAzd0xtRjdiTWh1bmRIQlZPM24xMDF2dWJkdTRIaHoxWUdERDFILzVXdk13?=
 =?utf-8?B?Y1h2Y1E1UU1Ib1dTdFFNU0p5UkFkNE0wVU5jMWxOTWdpb3B3MHZsNFRhaGZ2?=
 =?utf-8?B?U1MvS1VoQUtHWmcxTm5YR01oRkRTeS9GRGxjZDBwU1pZQlFZcHpjNlVYd1g3?=
 =?utf-8?B?b1dVT0pHREpjN042RWZDa3RWdTVjanZjOVp3QmIvNWZ6dVNLQ2hwZXdZS3B0?=
 =?utf-8?B?dnRyemxnVmJLRWNRblZ5KzFkWFhyTFN6QmlYT2oyaUZjVlB2WGR6MTRhNE04?=
 =?utf-8?B?c21Sc0tyUFBBdkZUNyswcm8rMXMrVkN4UytDeWtDZlQ0THBWbnowdU1sRXV3?=
 =?utf-8?B?MXYzMkhUdko5ZjlSbFg1cWVQV2xQQzE2Rit2WXg2Q0FPR21qaTRnY2t2U2xw?=
 =?utf-8?B?QkpIcFpEVjVOeWJSUDEzYmIxWld2RWJqeVRxdzR0RWp0aEdlUmIzenJwOHpj?=
 =?utf-8?B?RU5iUlNvblEvUmx6Q0VZU0ZUSVpyVnRZSXIzd3ZWUk1jdE5vQnhvZmxPOStN?=
 =?utf-8?B?MlJCSWY0WEJhUHUrWVBjNGMzb0FYL2NRSzFwL0FFeDVWR3FuMEVRWVVwemlj?=
 =?utf-8?B?TDVFaEZyaEQ1bVVpRWhMTHZ5a2prMG93eFdpSGlFTUJJWGM2bjd6eVpCMEll?=
 =?utf-8?B?WEFQbHFhR2YwaWg4WWNDalh3ZkRnZCtpazl1S2ZqNXVGei9zTXZNYVRWVU5t?=
 =?utf-8?B?YTI1Zml2c0ZwK1FaaXpVcC9HczYrUXg0TXcyT0RjSHoyMWlhZTU1TmVCWTFX?=
 =?utf-8?Q?BUaztIbGikffj5f5nlxgGZo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f142ac58-a92e-4ca1-3c3c-08d9c4d0d020
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 22:25:37.5369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOnEW9ddHgL+7kJblMLOdtYhnZS11GmpYJC7TCWY91TWKHBsjVUWskL1ZhVTrFE5OCKsY/wpB8qduYtjKJjgUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/20/21 3:47 PM, Tom Lendacky wrote:
> On 12/20/21 3:29 PM, David Woodhouse wrote:
>> On Mon, 2021-12-20 at 12:54 -0600, Tom Lendacky wrote:
>>> Took the tree back to commit df9726cb7178 and then applied this change.
>>> I'm unable to trigger any kind of failure with this change.
>>
>> Hm... I fired up an EC2 m6a.48xlarge instance (192 CPUs) to play with.
>>
>> I can reproduce your triple-fault on SMP bringup, but only with kexec.
>> And I basically can't get *anything* to kexec without that triple-
>> fault. Not a clean 5.16-rc2, not the Fedora stock 5.14.10 kernel.
>>
>> If I *boot* instead of kexec, I have not yet seen the problem at all.
>> This is using Legacy BIOS not UEFI.
> 
> Let me try with a legacy BIOS and see if I can repro. Might not be until 
> tomorrow, though, since I had to let someone borrow the machine.

I still encounter the issue using a legacy BIOS (SeaBIOS).

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>>
