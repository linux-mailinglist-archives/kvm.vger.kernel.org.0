Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A373251D2
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBYO6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 09:58:30 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:36192
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229466AbhBYO62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 09:58:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmcIC7uuyBUuNLb+IIOwDLzXzDzJa/GIkMxEW+r6ff5gCpxCG2huPdpLKOCt0BuM5Hhu3uXvwhSWptIJ/lbaPgBuHdKiZV8SIQA/FoDAn2sCZfDDEL6lK4ITk8gl5SpZM7eFCyh5+nIOmsztT6/GTdRSkao8W38boFA35Tm6CzygGe0YiKkwR+X2hYFrYznhpue3DLyvwNUJE08/J1TO3q/uODYBmB4F+EVwkyLRU2C6684IcRE0Dn4rroqoqzvesApLqy68CcxxkCmTaZGDlqW9x6oaimrLIZTQuiiNyk1odfwRLatSAB10mGUVwG5vgFEmVjXZba6EpyocF84/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWXx3/ZaBhbIGg7crBFEcbDUw3xxahEXdFinxAKoVk8=;
 b=B8F94CIauGM+BqxhSbb/Nkt2C0V91Y1SIqHwDs3IzcUuxOsc7kGVIkmMIQKPbesXtWhQwG21Gil5rca5TjRghw+D0syEWqWRTBkTTjGeU5s3KRxVXyAxabQwOKM2t6H8ICwqfrvCK7cAZSZ12pRq4FVgqSqVHIZj5I+H6Gy1hd60ru4vZPX2Ll9/dC+NCzDNyhwDm7PIsGkckG1tmCvsyE6ZH0d94jvE7d2knJzYnrYu+xhDEBVgHvAroFu4t4rV60L09YLm5OrHz5pQ07AoKCT0/77u69rQuv0pG44KE57b8YuD9w2br2oSUJ56rtKln2pMmxg+d+VuUnUyPaMOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWXx3/ZaBhbIGg7crBFEcbDUw3xxahEXdFinxAKoVk8=;
 b=xgUzVN6u1y8Qge3Q9T5qFv5AJQqLcOhiUUQkbO88Cm8qgrglJwefN1A07Z8cZXxx2wgjw+U1pti5k+6yZ3tjmfTY9OgZ7kGek5kmO+gg7wkJPmglaIOOVDsYQUxBBFSP7id3swS5EoG10zGOKk2mAWG87yuPGxcIVG5exfKjQGw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Thu, 25 Feb 2021 14:57:35 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3890.019; Thu, 25 Feb 2021
 14:57:35 +0000
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Steve Rutherford <srutherford@google.com>,
        Nathan Tempelman <natet@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
References: <20210224085915.28751-1-natet@google.com>
 <CABayD+cZ1nRwuFWKHGh5a2sVXG5AEB_AyTGqZs_xVQLoWwmaSA@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <9eb0b655-48ca-94d0-0588-2a4f3e5b3651@amd.com>
Date:   Thu, 25 Feb 2021 08:57:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CABayD+cZ1nRwuFWKHGh5a2sVXG5AEB_AyTGqZs_xVQLoWwmaSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0119.namprd11.prod.outlook.com
 (2603:10b6:806:d1::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0119.namprd11.prod.outlook.com (2603:10b6:806:d1::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 25 Feb 2021 14:57:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c83847c4-cc31-42fd-6130-08d8d99daf86
X-MS-TrafficTypeDiagnostic: DM6PR12MB4353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4353EA873A3756A15B5C756BEC9E9@DM6PR12MB4353.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpnQSDuZGfzeFTgYIbvy+K1Xha6QOeJoFClCxSzTzsVaNYyWELSNbb9m8OJfeEZR3nZ4ABcugKXgzOVJYjhWDJ5AMShR0b0HkMQjBKcsRzdlfEbQfkJPWu7kNVHi2RkpwjGrHL8ZOIGUciveDzgqqDvI60Aallc4ucHgsuN2yqeKN+Tps9H+TlFi2T0i5dsH2JcK38/g+4elhVqeK8/GaOolQU8iSBYLj8Fc/pEP6xsM6aCfMu4mr+9vhTAwJdvPUV+FHiov5DawHoPhD2B7gWpWafprsOF22UUF6RQ9m3igIHvDju5uHDICLMD8a9HnrySF6KQaMgkjJWjBIQAa8xJJ9xrJmmU5mvRx4reMK6yx1yvqs9OoUO6rnJzc6gonUTGQRcwePRxlAGEMteMbdkWsaAd3LT9cDqAiCt0gFI3SuxoCdTiZGnHDIAFUN3lKmJTNA7wDW4bybgK4Pb7z5a3wl0FaSGkMHRgAM2sOpXv5PbnnIwCm1bp2rifHxzNx0LqiIJ6MsKuUcdSxTE/Nct0WvBzkaMoptXkzhOXMtzCz9wzdnB/br21UxuBR6pJppl/zGd1IwXA8KEARappfjzjO78VJ5jR7dzWzHEF/cJE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(5660300002)(86362001)(4326008)(26005)(16526019)(83380400001)(2616005)(186003)(31696002)(36756003)(956004)(31686004)(6512007)(6486002)(8936002)(66476007)(52116002)(2906002)(8676002)(478600001)(66556008)(66946007)(110136005)(53546011)(54906003)(6506007)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2pWRkdDZngyd3VWUlBqUlVUVllQQlJBL0VmS0ZTRGR0QXdMNkJGK0hNamJI?=
 =?utf-8?B?TFNpNVc0R2pwWmFzT09mbmFPWkRxNUtZVTNMRGs0RjErU2JVbFg4aEViV1JR?=
 =?utf-8?B?T2lSZE5iSFRyTDlaQWRRK3MxZVZjUE5GbWRmM2dMSldseFNPS1dOaVhxZTl1?=
 =?utf-8?B?YVRXSWZIQWxwdUlKSUl3WjZ0T1N4TGhVNk8rbFdhZzN1RHJKZ0hlQ094Y1Mx?=
 =?utf-8?B?NmlWZWM4Nk1Jb25oRkZTSzF0NE95VzFSN2VIMXQyQS9hbmpvbjNIWXZ0ZlJT?=
 =?utf-8?B?VTRHOHlHdGIzUXRFVGh1akcrdHIzUlBOQmN5L21RRE5QZVpQcXJWdVFqR1Uy?=
 =?utf-8?B?M0daWmVXeGZWcGZsT0VLVkx4Y2NkRHVMdzJyb21zRHlaL0pRcTE0VTdHdWx5?=
 =?utf-8?B?UHdFeEQrQ21KU3NuRmRweUZCcENydkJTVWZRSlhWSVk1V0VjOUcyRi9RQkpO?=
 =?utf-8?B?QnBPSjB1eldTdHNBRWMzU2FVR1VTVUplUVUxalVhb0U4WkkyU2VYbzM1QWJ2?=
 =?utf-8?B?ZkMrcGRoeHRpdXYrMkFsa1hRNGd5MDl4cTJUemNQcFlRZEpwMldnOW5oVDVw?=
 =?utf-8?B?NVR6dTM4Vjl6eWUrOUhlbmdTZmhDRmRpUThreUxuRHpoYVo0SFU3UVpTbjg0?=
 =?utf-8?B?TGc0a2MzK2lkUmtGU2t4Zmw4MGdFTUZWS09FMFh0VTIzLzJKbkJ5cmI5SkpI?=
 =?utf-8?B?NWNDMzQ2RlRkVmxmaVJrZDdxVWFKRTMzVXc0clYzbExNOGY0STE1SnZkRDRm?=
 =?utf-8?B?VWNQUnhRY2FlT2ZHb2F4V2syblFwTHRXclpUYTFhUnp4dHIzWUhKc2UzVVFy?=
 =?utf-8?B?SkVHMTB6dUI5anNETDl6c2d2WnZETVJvYUhveWM5bUxxMmorTEg5OE4xbVM4?=
 =?utf-8?B?RDNMbnBiSkxMZGU3Ty9Ubm0wOTh2WTN3TU9OcHVuVUNwNFBMamljQnRrWlJ2?=
 =?utf-8?B?NXpLRFErVTdkdHNqNlZ2bHVqSUgvSDVNSFVSMis1NFdRMVI4dEJjQncvbWhw?=
 =?utf-8?B?a0NqQXIrK1kvcC9tQnlWSHgrU3hUMFFmSjllMEpHbHhLMVQ5MGtvMXRkbE1O?=
 =?utf-8?B?YllBeWZHMmNaZnVRM3Y4NW9Zam9rMVlXMzIzMUo0cjdtUTdWemtJWXg0NTBG?=
 =?utf-8?B?Ui80VEZLaGR4eVhNRkdEZjlCaWlmVm9CYVhDbDJjK3BmaUpFRjkxNlJLdGtI?=
 =?utf-8?B?eldkMkp2ZGgzUmpETU1IZVN1Q3RPbFVQNzk2UExCSU4rM0VDSktBUTVOSnZS?=
 =?utf-8?B?dGdIRW1ZaEZPK2t2c2FnLzhWVmNqdnBYRjNSSVk4NVI0YzA2MkhPZjRPQlNs?=
 =?utf-8?B?S015MkFCbjM3SU8vUXZHZVdzVnVYdXEvSktFTEdRakVMUXdKR3VyK1pkV1RQ?=
 =?utf-8?B?dll3ZDUyTUNKVzJCNWhrS2VBa01yalNHL3lBaDMwN3cvU3gvbldiZ1FCcmdn?=
 =?utf-8?B?RjRXeWRvdzRRZ0w4Wm91d1lVSGR0RFFETGdvM0xwYS90WE9uTUJIMmhjcUNr?=
 =?utf-8?B?VWF5dHlWLzhnTUs1bmpuSUhkSkVkMTE1TnRXcWptQ0Y3VnUxRWpzbjVPb1Vl?=
 =?utf-8?B?MjRnZjNXemZ4NktCem5ORTgrbXZ6TjBuMnN1TERrVnlqMkZVckhyekxyMUhr?=
 =?utf-8?B?bjBQNlBEeFBVcWpzeUV3YmE0K29SMnBEV2ZkbnlxS25xeGdqMnMvU3JJMGlx?=
 =?utf-8?B?cHdzWnlaYTllalhRTHdlU09ySW1FM0VTM0kvS1RLSlZyaTJWZ3JHWjBYR0dW?=
 =?utf-8?Q?5NvfVvP5dluVIL3gcb3X4VHFoSdOOeEkw+bq4NH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c83847c4-cc31-42fd-6130-08d8d99daf86
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 14:57:35.3616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuhBNF7arSdn9zw3iwQh0UUiQouAK7ZCI5VjwIWQom09KaXhCdceoGpk/PMh/KG9WGxP7Gpzwx93UpV0vOLudQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/21 9:44 PM, Steve Rutherford wrote:
> On Wed, Feb 24, 2021 at 1:00 AM Nathan Tempelman <natet@google.com> wrote:
>>
>> @@ -1186,6 +1195,10 @@ int svm_register_enc_region(struct kvm *kvm,
>>          if (!sev_guest(kvm))
>>                  return -ENOTTY;
>>
>> +       /* If kvm is mirroring encryption context it isn't responsible for it */
>> +       if (is_mirroring_enc_context(kvm))
>> +               return -ENOTTY;
>> +
> 
> Is this necessary? Same for unregister. When we looked at
> sev_pin_memory, I believe we concluded that double pinning was safe.
>>
>>          if (range->addr > ULONG_MAX || range->size > ULONG_MAX)
>>                  return -EINVAL;
>>
>> @@ -1252,6 +1265,10 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>          struct enc_region *region;
>>          int ret;
>>
>> +       /* If kvm is mirroring encryption context it isn't responsible for it */
>> +       if (is_mirroring_enc_context(kvm))
>> +               return -ENOTTY;
>> +
>>          mutex_lock(&kvm->lock);
>>
>>          if (!sev_guest(kvm)) {
>> @@ -1282,6 +1299,65 @@ int svm_unregister_enc_region(struct kvm *kvm,
>>          return ret;
>>   }
>>
>> +int svm_vm_copy_asid_to(struct kvm *kvm, unsigned int mirror_kvm_fd)
>> +{
>> +       struct file *mirror_kvm_file;
>> +       struct kvm *mirror_kvm;
>> +       struct kvm_sev_info *mirror_kvm_sev;
>> +       unsigned int asid;
>> +       int ret;
>> +
>> +       if (!sev_guest(kvm))
>> +               return -ENOTTY;
> 
> You definitely don't want this: this is the function that turns the vm
> into an SEV guest (marks SEV as active).

The sev_guest() function does not set sev->active, it only checks it. The 
sev_guest_init() function is where sev->active is set.

> 
> (Not an issue with this patch, but a broader issue) I believe
> sev_guest lacks the necessary acquire/release barriers on sev->active,

The svm_mem_enc_op() takes the kvm lock and that is the only way into the 
sev_guest_init() function where sev->active is set.

Thanks,
Tom

> since it's called without the kvm lock. I mean, it's x86, so the only
> one that's going to hose you is the compiler for this type of access.
> There should be an smp_rmb() after the access in sev_guest and an
> smp_wmb() before the access in SEV_GUEST_INIT and here.
>>
>> +
>> +       mutex_lock(&kvm->lock);
>> +
>> +       /* Mirrors of mirrors should work, but let's not get silly */
>> +       if (is_mirroring_enc_context(kvm)) {
>> +               ret = -ENOTTY;
>> +               goto failed;
>> +       }
>> +
>> +       mirror_kvm_file = fget(mirror_kvm_fd);
>> +       if (!kvm_is_kvm(mirror_kvm_file)) {
>> +               ret = -EBADF;
>> +               goto failed;
>> +       }
>> +
>> +       mirror_kvm = mirror_kvm_file->private_data;
>> +
>> +       if (mirror_kvm == kvm || is_mirroring_enc_context(mirror_kvm)) {
> Just check if the source is an sev_guest and that the destination is
> not an sev_guest.
> 
> I reviewed earlier incarnations of this, and think the high-level idea
> is sound. I'd like to see kvm-selftests for this patch, and plan on
> collaborating with AMD to help make those happen.
> 
