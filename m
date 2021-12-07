Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37A046BC16
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 14:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhLGNEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 08:04:51 -0500
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:26273
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236717AbhLGNEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 08:04:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVmrOmIa53vIL1lSaWoIrvRiKEJXMTmwRjCJomu/WHYA/sqpoSS9zLMnTprCMx59aoLLduY9ifQ6PnovUb81G8h654vxYszN6MoeKvOexkvILoCIW53wpLIn6h4rmD4Uog7lv0IyFTmEzk7Sim9SXYgjqcKdCcVL7SUSDhKMGkmTSG/kJtdwQo7Kp9RtGCRxe/L6vXvd0KhPQSRnmpoN3dgS5B+98936JM7FIiWO/6/COCwveyNPGHh4qFovV/oFy20ZeLsd+mzc4LefG7g+BmnxqFkLCp51T/oQwoig0E284PGBKyeiJx5xTfPj6jxuop/aQJP4oXqruaOq/pTswg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QREOpK/XIrRnaP20sOgJ/z4uQvp9zgJ/iquRMMxtCCE=;
 b=N2HdInhrfO/qtLhVXZQT6YBj5b2B/AfiRhHw+qQUH6GhCBpHIGSu4YzDwPseZuY3kyeW9+UBv97aXH4vEyS7fiVbiUjs0ReP41Uh8PnGwyW3eyWSN1vnaiTIg/A6uoVw4K+hZ2QUjOM2aR7ViquhWoCNDzSo5cKkPxde3NTV6J2vAhDoVmYgWiinTJUNiAqS2XV8GCbmpvYvG50R1Dakub12QSuLDQWAZNePLY4GWN67pVKhTVdqwYiDpxdD5GvTA5y2iB1B+s09PPYUvVyK/fY2EdDUAMG+xF/RSLtIcVPVyoGdmcWcbuZh8BzFeksRA88ogovx4gCRbc2n5SVLBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QREOpK/XIrRnaP20sOgJ/z4uQvp9zgJ/iquRMMxtCCE=;
 b=2NP43021uufcjy+5cKAMxtNdplF5shx2F2P89ogaOVbxYAMFtxqtrPv/Le5RLSvLrX9DUD7bhur9LewYCJY6ivF4Ub1aLKWRela4bRVe98zTcBxWF7VBv9r9gsMw+UB4vmB1VUn5TXx8G/1KNLCR1tjkQYihaAOmv8y2LTX1Yq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Tue, 7 Dec 2021 13:01:18 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e%4]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 13:01:18 +0000
Message-ID: <bf7c4447-8474-d0da-3692-b6447e6c3e1a@amd.com>
Date:   Tue, 7 Dec 2021 20:01:04 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 1/3] KVM: SVM: Refactor AVIC hardware setup logic into
 helper function
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
 <20211202235825.12562-2-suravee.suthikulpanit@amd.com>
 <6a97d0ab100e596c3f4c26c64aaf945018d82a5e.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <6a97d0ab100e596c3f4c26c64aaf945018d82a5e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0019.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::10) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
Received: from [10.252.132.84] (165.204.140.250) by SI2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::10) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 13:01:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fb9deb4-b400-47fa-6761-08d9b981a8a8
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5040D332DC97BE71FFFDA4B7F36E9@DM4PR12MB5040.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgkOPcsWDTS4bwTk/qMT3z+D/crzTfrYCAk0fL+bqDhW5onasDKSLOzJWKf3s/aeDYyw+avdktJoXjK34Mr3U8rI7S1o0YYToOCyQOQOA8KDJQL0a01qraBFuR3p5N5fm6OO4fQc1kDywK1TxyELwNd20an7lTYZPgwFl+T1ewTnM4rhuCuPJ8pj7Qx+YiDMGBWlemWtgA2GyuA1wL8IOWS+K3Xp0Ikpg5d90vDNwRmyHzHt8bacBlhLP+BZGbHLEoqJI6gwTCVNn5UcVDkZADh5+pzly9qbngIbZit89t9crjSXhfr2VcMQiZabzwkGAZU0wxMDhzhKv41RxBSmkHwEP2G3sZ1YCHz1ybyA6/CHcggK2iIUGaA8cLJC2fCtqKcWgfHlRWTrMnYa8aegpa4+lRonMubmBvh5cJK9UOYTaO4Xj1RtsxoP5qqKu3CSpMjB+Sk7/k0KkY+/eUI8V876EXreHBn6m28MVxfp4AmjBuDThxqVXNtB7xGTjqshP9EagWKZyG1rtBHcFV3Gb9D0FWiEGAVJFEnvGnOa9n9t4W8kb7nP/+8VlLos4yK0S9wjP2MiBGqqKC6U8KzUJiuanCoa/yxxHFVkmkGSgXuAXN80hXOSFNjB0gxXBKAQ5IR6N5MLa4qQ5sA4dutyniEIjv48cycrde3tBw49ui4/Vjen0kGmONV9Gp40nci4wItL+2m7lRWgsqa+3zXVNvPr+AAf28DXpn2rJOxO6fo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(36756003)(6486002)(316002)(186003)(956004)(53546011)(31696002)(66476007)(31686004)(2616005)(508600001)(83380400001)(6666004)(8936002)(16576012)(7416002)(86362001)(4326008)(26005)(8676002)(38100700002)(66946007)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDBZbklDeFBha05tOFB5S1ZXT2dYL1N3REVhUTY1em12SHp3S281cUtxbklF?=
 =?utf-8?B?SDhiQlFlQlBnUkxiZk5EMFc0ZTZJakx2N3B0SXMzUlRmalVXYlUxUmRmQm4x?=
 =?utf-8?B?dU51SUZRTm5ZMVdnQ3JpN0h3eFZjeTUzMDN5Z2tDTVZHdHVHQ3BXSkFUczhV?=
 =?utf-8?B?d2RpbU56OTZpNUlkblRCajcrMkFVWTZ5ZlBkVEoza1VEQUJNZ1RCcCtEc25X?=
 =?utf-8?B?TU41Y2lqbTBrR29oZVBYVXMwaFl6ekdvNVorRVBkT1hybGMxY1JtNFRERG80?=
 =?utf-8?B?UHRQemJROENkN1pDb1ZsZFNpVXkyWm10alRLUmZ1WWVtZkxtbmltNFBBTC9D?=
 =?utf-8?B?ZXhyRjFKcHY4VUdhc0cra1VVK1Y4SGZjbDNBa0ZmdG9MT0hxeC9LRXFzV0c2?=
 =?utf-8?B?aUlqQXJOSlVTNjN1bXRSK1VsZ09tZlVDdEhqL1pVeHBremRWQzZMN3ovNTdh?=
 =?utf-8?B?Q0RrQ09vRnpnUXJURTcrUmlLTGNiRzhEckFJckRiQkNIaEJCSjUvTG11WjNO?=
 =?utf-8?B?dGhkTytxNCtuS1R2cmpJdmVONlF1cDhKM2kyZ0Jmamx3WHVEbWpEbWdyak91?=
 =?utf-8?B?L01udmVoNlFXa29XWlNYdW9wOUg5Q1FvZ2dGKzFEeHl2QWQwcnVBRWI4V0l4?=
 =?utf-8?B?ekpiUCtIMVViblhmSzdFTDhDT0F6Tjg0MVU3MHdzYTBkME1aSlRTWU1NWGhn?=
 =?utf-8?B?QWh0STRqVHNmQWpMSmdlRDE3bTY0UWU2d1MxbDRNbllKdVlNNUZWUUN3MzhR?=
 =?utf-8?B?UllPK0ZEd1Vkd0xVWXRVamZGQ21pUXE2aGlYZi9JK29hVmxkSGorc3h2dlRM?=
 =?utf-8?B?U2FGRWRGVWpLSTZ5L0VlYXRjWlNteXlHVkFBSUhaUUwzR2xrY0FFbkZsSmhR?=
 =?utf-8?B?dnhoakI5ay9JVVJqQ1RBM2poUGRLWmF6YzFtSEsybHJnZmVTVU1tOFFoYWdH?=
 =?utf-8?B?NWJuT0NpcndmS2VHQ2JNVEc1N2pRZ0lGdVBReHgzMVZsY2d1QWE4bGZ1Rms5?=
 =?utf-8?B?WmxKUUZ1TTNOaVFRaUFJYVNiZDVCUUREVzlDZTVwVEl3U3dDN1YvL0xmZ3Nr?=
 =?utf-8?B?YlRlNmNoMTlXN05EMTRqWDRObEpUNUZmbDV4YjdHaUdheXBlaUVZTlgrM3Jw?=
 =?utf-8?B?N0NjWDd5czFJTmhNcUVZM2VoV3owcTBISWhXU3Z4SkRjc2xsWEt0Y3BncFJw?=
 =?utf-8?B?cldjRTU0cjR1Wm1nZkRLMjBVOEF4YXYyem4xVGdXMFgrWmFBWURHUndWRUxx?=
 =?utf-8?B?Z0YxNWFtcEFPMjhOYTBkTnIyMi91T01oemI5NFNxK0tXTjc3aVBnM1FwdGVB?=
 =?utf-8?B?dUlQekZvNjBGUlY4OVZKbFk1d2laWnBhTTNIRlQrVGsvQ2lnM0RVWlVjM1RC?=
 =?utf-8?B?MWw5SWhFRUJ3V3FLazFUZjZodVRCYVhiVEx4SmRWZlBESVppbkpSdHBzWmg5?=
 =?utf-8?B?MWtWTy9seENrM0QvbzNnVnp1OEJGRGFBSjJkbThXeWtKeldRUmRpcTlGM05D?=
 =?utf-8?B?aWJjN1FuZGZVMDJSVEsvNWtxTVJ1dlJ2QjdXRndQQld1aWNQTW5zaWdTMlJJ?=
 =?utf-8?B?Z1ZaYk9zQi82akxZenp0ZVRuWG9RK0Ixd0dORzZVNm9DYTFXdkczaW1ic2xY?=
 =?utf-8?B?d2xiTG5rblRYdWtlRS8wMEZocDFvNVBrYmZFaHhVei9lY0kyakk1RWpiYkx1?=
 =?utf-8?B?RTk3RXQrMnR3UzZ6RjlsN1NzRFprbHZtSFBlUnJvVjBFTXBQWWxidTR5cE94?=
 =?utf-8?B?OWtyYmM1ckN4T1pscGNqWE1pb1ZtMUkxNmpVaHdCUmdYK2Q4SXlEdnhDTExB?=
 =?utf-8?B?Nm83cWthdVROM2FDS1ZKRTBnbmdIQTVzdTZiSVF4c21naEZ0bFRyTjZDWExT?=
 =?utf-8?B?L3V5UWx3b0U2VkR3WWI1Q0xiMllPcFpZc3RVdlJvOVNOT09hS2wyM0ZycjZo?=
 =?utf-8?B?ZkFNUWJobmtSM3NHZFhnbUNCK0wzUEZkSnlGbkU3Q3VaOFhjeUorVXhJclNX?=
 =?utf-8?B?WEdmUmc4WWtmdk9vYXVBdlQvSTk3WkFhdTJTTUF2dmtXaG1tUWF2OE1LYmtK?=
 =?utf-8?B?RmRRN0J1ZzQzR081TzdDbExBZi9NVFVTb3FBMWpEZkNRcmVScDlzYiszN3kz?=
 =?utf-8?B?NUlZNllPUGVSVkkrQmJ3UGVFY2w5bjBaa3JKTUErYlBZdVVJTjhzR0h3UjZs?=
 =?utf-8?Q?XDOQeO0lClohUiNYY8AGrjQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb9deb4-b400-47fa-6761-08d9b981a8a8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 13:01:18.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c/O8HqaVX7FayKk0wjbTtXrwHvW3JJtvlRzc27BVMZTRSIlshFx+fQWxV6b8K844mku9+hEzNEt3qVQ5e2TSgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 12/3/2021 2:39 PM, Maxim Levitsky wrote:
> On Thu, 2021-12-02 at 17:58 -0600, Suravee Suthikulpanit wrote:
>> To prepare for upcoming AVIC changes. There is no functional change.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 10 ++++++++++
>>   arch/x86/kvm/svm/svm.c  |  8 +-------
>>   arch/x86/kvm/svm/svm.h  |  1 +
>>   3 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 8052d92069e0..6aca1682f4b7 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -1011,3 +1011,13 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu)
>>   		kvm_vcpu_update_apicv(vcpu);
>>   	avic_set_running(vcpu, true);
>>   }
>> +
>> +bool avic_hardware_setup(bool avic, bool npt)
>> +{
>> +	if (!avic || !npt || !boot_cpu_has(X86_FEATURE_AVIC))
>> +		return false;
>
> Nitpick: Why to pass these as local variables? npt_enabled for example is
> used in many places directly.

Good point. I didn't see that it's already declared as extern in the svm.h. I'll update this in V3.

Thanks,
Suravee
