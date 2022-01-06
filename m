Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958664865C6
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbiAFOGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 09:06:22 -0500
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:63168
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231302AbiAFOGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 09:06:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ON13Ngdz8r27F8P1cmXqVHz+W15JSCactq0WqwMHLBzskmGmtJ/khaLJ6aeKN8pfmSBXPidkNXK11iQWENYd/50/MRDB4xYdS1bkZRRUh9QEW1hJL3zx2sqdf2km7blmRF45aQXZfU4MmVXMSBULAgdLp8X/jI9ibFFLbldsRei8uXQ5Frh/6PcCYCETBi36JkLpbhq8ICSsNmRalYQmxQVc2U+CdHsxwWf5cmQKxQcrjPAJyzQ1vJexle9slmLrmRX2pmbS5S7zKiW8HtTNQPrE3njcAFvktAjWfkCI5FcUx74eCJ+wJcWya0Y4yPh/jq8DRIKKtrJ2Dh97M2oFUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JLPb4hgf3TU8QwJdzyWtQ5u4VXfDYveztSASpkHeO4=;
 b=Z6L2COzQJGRzhIxVN+jFJW0FHED7YZ5N5tjbqFkaZmjfWHlg7vda3TDwjtSUKJsdga+lBqJa9WfVkmN34UKLnovbtsPTPMr0gGzeHoucMuRm/ooYqawXrYv/RG6Ldb8Wgxh3eOh0ZhhyvXguIBG7nPeKqFWNX9hRDdD5O25n3xMh4xVgaaeKUIoqHTJTYTQq5WEkLvmQBJpMYnguF4nbObobqXYryHHOZmU1hndpK1eBbDvy7iPvkHYupPAj2RatTwMLCiJd27B4b0KWQuU8ig+xknBS9hfHX4XvUfvYUvngJZf2sCdvdRmRp5QlkojFeP5VQnMYtAdAZgp+XbKvAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JLPb4hgf3TU8QwJdzyWtQ5u4VXfDYveztSASpkHeO4=;
 b=RPUovSt4m7/Rc7/5DlJpYm4Lzf0m2tmlVWlYNNFGfR820adcim98tPbcN3sFsXVLluYxgtqTP7lula2qx9VWD8WnK7P7UJQriioFk9frUusLOlpkqmZMzXnzcRYm4VHubqMMMU3mhBziYzZsads3Oo8ZN0nJkWSQTQ/M8YuedBE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5152.namprd12.prod.outlook.com (2603:10b6:5:393::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Thu, 6 Jan
 2022 14:06:19 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::ccd7:e520:c726:d0b%5]) with mapi id 15.20.4867.010; Thu, 6 Jan 2022
 14:06:19 +0000
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when APIC
 ID is changed
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-8-guang.zeng@intel.com>
 <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
 <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
Date:   Thu, 6 Jan 2022 08:06:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0009.namprd18.prod.outlook.com
 (2603:10b6:610:4f::19) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c06575e8-e67e-4a7d-5b02-08d9d11db605
X-MS-TrafficTypeDiagnostic: DM4PR12MB5152:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB515282755C9D4B0AF03E2619EC4C9@DM4PR12MB5152.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPKlJ3rbBxzSoktB9Pykmx9dASHAsjFrb88YCGqV2lSHSatOrRYPcR1bH4m8EVNEtrhuGIr9FJ6w0rNW6tW1w+/pvC4zbCmnHlh2P1sWEl+9GdSgFnzBxDRy8pa2Fco3neURMgXuPYWhOAkeyHoVZSj6Jtoo+jfiaLK7WWa4ujGJVQ2Yr/6mpWfIAR4u722NkmrGyRJoHsBlGp5BWTfrHd6ewn5+uMfCcAUxJQMZhdVyOzhp2F630ntXDESH10aq0/TyuDBK4E4XDaELX/CTH7779LB8RmxL9/5ADFdRVjCc9XZPSFRoeRJq5zNJjQhNwpA3wgpkgmw7rhdgZCY1k7zY9brJRDfkHWt2VDGWDfjLcbbrH/KmSnnHqt3dDj3lPfQAu/DRxVMKWhf0ezdHoT3VeL6J54feERpMV9Ja4rpacLwYDYG4puPsQeMGKh9ZAQKZXEKJf2cfDlB3+Ai9Tjz1BD1OFzXr1RPBhSJ2upc5dv6V9NkiQWVYtpYUq2bQImMZhMZ9tILwhtRsnqdmbYGGNKhfDXcNRKTnYgmczEpK4RVKIfEzabHaBKyGq13q46go7/UBgEWf8I76/bNwmiaYTkiHNlYkJ1uaQGXTeztZOto1wZOBY1yPHokM32Vk/woQ72SpuG4Ae7jGllA7Y0gfi1P+9qqgVmedMw5uJKEdAkSvDyUhFQgf36cTc0OiIw5mamro62Zzs9lfqQZp5ap7QtfgHYHW/AJezLv2AlsOzdNcETdwquLj3KyCRf4P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(2616005)(66556008)(31686004)(86362001)(110136005)(54906003)(26005)(921005)(4744005)(8676002)(508600001)(7416002)(36756003)(186003)(6666004)(6486002)(53546011)(6506007)(8936002)(66946007)(66476007)(6512007)(2906002)(38100700002)(4326008)(5660300002)(31696002)(316002)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTNIVGlqZ3ZzNzVXQ0NoK05YOVliS0FoZGRWenBlZ1hmb2ZkeFFtQjgwc3BF?=
 =?utf-8?B?WkhGckk1Z2xUUithRGJwR0xmdk8yTFNQeWVMVnVRYzhSR0VGNlZxWTJJUkNl?=
 =?utf-8?B?T1h3YTExQTgzOTNHdXNKM0pCMkp1RlBQTnRMWEZsK24vSFZRa1AveG9ScENo?=
 =?utf-8?B?cUJKNHBiMjJ4d2pXTzQrZyt5S1cyeTRBaE9CMnFtNVVBZi9reExmWXByTGxU?=
 =?utf-8?B?djFDR0Jtb095WGV1YXZNdWQxSWRkL2JVM3pUVjdtejAxU2hpV2t1ODVMQlZj?=
 =?utf-8?B?WlJmNjVOQUNxbmtMNG9TZitjNXljSjQ2ZHZjQmxDM3FEUUJmMkNrOW1KeW9y?=
 =?utf-8?B?ZHV3ZEQvWGJJQ0wwSlE4Zi9YaTVtbXhocDlremZnTWlSd2luakZ3Ym9Kc0tP?=
 =?utf-8?B?V0JRSnRGVnU1bWlaTVEzR1dpZmdXWkFzUmI1M0ZpV0FWVzk5a2dJSHNaZEh1?=
 =?utf-8?B?c3Roa0hoZ0RSdXJSRmppUVJ6N2U5TFZVVmJZdklLWU1IblJCWXhDNjRETzRv?=
 =?utf-8?B?QjBLU0JoRXdVRVRzNmFIdHl0V2txK3JvdnNGYmpna1hKNHNIVmQ2b1drRFd5?=
 =?utf-8?B?WGhMQ0JSSmZVQnIrYlk4NUZoK29MN3BpbmhEYmNzbklGSVFYcEdOMlU3eERm?=
 =?utf-8?B?THBXcjN1dER6ODM5QzVsRGU3dDVBSHp4TVY2ZkhKb0ljdEJnZlIvYXlvQXZK?=
 =?utf-8?B?K2VEVU5XKzJSSmlRL3BwUUN1Nml3T2FqSnUwVFZGbEZ1TnplOEtGb25Vbm5k?=
 =?utf-8?B?b3FHUnNsNmF3UUZ0c1ZRWVQ5aUcvckh3RFFqd25UanFBcVVIL01TYmpUWDFo?=
 =?utf-8?B?T1BoSWZXT0RPK2VtOTRFUEtlUTY5a0FXTUlEVDFrSGJWMkduUytETVVSZjAr?=
 =?utf-8?B?QVBuWFBYRWRzanZiMDd2OGxkZUNZcVV5cW5lb2pXRWJVV3B0ME1RQTc5MUlu?=
 =?utf-8?B?MmV4RkhuRkV0QmhvdXVuMEZ2bVgzZEd1WDIvN1h2MEVKSUF1YldXdWJMemE4?=
 =?utf-8?B?WC90cTE4blBNZkxhOTJkN1o0bEZTdmlKb0NCSVYvbm40SGVINzlEVnVnTmdv?=
 =?utf-8?B?d0w0SElZNVh3aUlXbDRZL0NGZ1NxRGdLYkFKbHcycXpWRXB3dk9Sdk5YMkNt?=
 =?utf-8?B?MzBiVnAwU1ZxR3pqTFF0cDJjZzNua0tmNG1UWlZzb2Fvb2FYZnZrZWl2R1pm?=
 =?utf-8?B?b29zRXdaeUZjdVQvUHB2NnJlWFdkazcyd05TTGxyM0tVYnMzZWowRGx0UHNs?=
 =?utf-8?B?Q3IxZ0V6cTgvZXZ5bXc4TDBvZlpGQ25tSHNNWkk2WVd1M0NYTDNOajlpT016?=
 =?utf-8?B?NVdQaDVXSmUycThEa2llVCsvS2E1d3hzZkUzYzMvMjlmK1pHdzFyL2FyaDNz?=
 =?utf-8?B?T1lUdEp6SWszRzMwL29rYXptUXNGVHl3WFU0OEk4T2RuVzRvUk1oUUNuSFd3?=
 =?utf-8?B?YVRkQXRXNzRZU1gwWW5nc250NEVsS3Jkd0dKeW5Xbm5ud1Q0b0w4ek85aU42?=
 =?utf-8?B?ZkxJcWUxSUlseFo0RENLUytKMmljNzNQWXpycEUyL2tTTHhQM3U3TEZqQlFF?=
 =?utf-8?B?aFhFbTdFWWFmcXdUdE1CajlsWFZ0ZmJRU3ZTUm5WTmFsdzY5K1grSElaZTV0?=
 =?utf-8?B?TXg1SFlBcXpWaFp2VTdycGt1ZGl6S2UxdzkzUWkzUHphaTN2c0JWaUdudHBa?=
 =?utf-8?B?REtmZ3dxaW1yT0Fybk9XcDdlcWtqb0RBeGF0a2tiU0kxeHhOcDNYdW9vTks2?=
 =?utf-8?B?RkxDZEd6a2xxbGlJaWNnNmRleVZhbDA5T0VndnhHMU0zakNwWEJoQUVPeUY5?=
 =?utf-8?B?RGVFRElTaVgzTC9uTDNXQ3hlSXR6WUJaUnJZcTFTVzA2REtEOW5pSi9sbmJY?=
 =?utf-8?B?Qnd6d2YzZzBkWUhybkRFZXlxSnFSNnkveHpNTHViU0FSVjBiUW1aclc3dEJF?=
 =?utf-8?B?NldqbkRraFVyZ2lKLzU1V0dKNWQ0d25nR0V4a0xFYkdtWC9TVVUvRXVGVVBB?=
 =?utf-8?B?VDNWc0gzUEdDTTBhM2p2NkdkQkcweVVkZHN1NytzRGtKd1B3ZDArSHdHNGRw?=
 =?utf-8?B?VjZwN01WQ0JsS1BoOTRRVXZBc0pqYVF0dDIwRUI3UmRpeFpXQWtUL1ZYZUJa?=
 =?utf-8?B?d2Vvd1pTZ2ZLQ2o1MFRNRXVMQXA5cEQwVXJEeWJiN0pTTEE1K2R5ZHhBdlhE?=
 =?utf-8?Q?ix4m0Ni/yX2p4d1h4mN9E5Q=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06575e8-e67e-4a7d-5b02-08d9d11db605
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 14:06:19.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUZ/t43mHeaTI8Dneeb5MFZrZVDdOTsTYv+D2zUj7z1btbH0/3SFUx9m4kidTfTJkpNmdm2J0JVMg31GBKW1tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5152
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 7:44 PM, Zeng Guang wrote:
> On 1/6/2022 3:13 AM, Tom Lendacky wrote:
>> On 12/31/21 8:28 AM, Zeng Guang wrote:

>> Won't this blow up on AMD since there is no corresponding SVM op?
>>
>> Thanks,
>> Tom
> Right, need check ops validness to avoid ruining AMD system. Same 
> consideration on ops "update_ipiv_pid_table" in patch8.

Not necessarily for patch8. That is "protected" by the 
kvm_check_request(KVM_REQ_PID_TABLE_UPDATE, vcpu) test, but it couldn't hurt.

Thanks,
Tom

> I will revise in next version. Thanks.
>>> +        } else
>>>                ret = 1;
>>>            break;
>>>
