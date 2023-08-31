Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF32D78F173
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346832AbjHaQuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjHaQub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 12:50:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D3193;
        Thu, 31 Aug 2023 09:50:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RqA6WRWsFEClVhN+3cCEjqjVAawVmwae81udtNYhJK/+he0ukx+oUDekO3rLv+LFI5fNpfG/57dIUeor7WbcKG8IMyARG3lCkuqGymRfHd/+sDGCmEbcejoyGr65qqT+wxNgGV6fbOj/6ZdpBlNbY/lmFSx+vzTpWFBPSrN27c//PYQJ8deJZbpi4Ja/O7MZrThtnfH6QuE+3KVUe7eW3k1EWkv8WnEREwS1VvfwQNUmRKUMkgm7/bLg+Za81WmXjLAHgiAmGM7+A/XHNPOTu1M60V7pb2cl+I/hS4A34AzdEp+/3SjGbgqSbS8HXRSeNTx5xukRHtJa0XHpgFGr4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RoP9Mj7EDXGf/nByxHU6r3tbHUoCV3gRwDt9Nbds5CQ=;
 b=SVRnwM90cWCw5IeL+q66PphHdBleb3ROtEcJz/xI/2stIhCsGdB2fqTijM1fQXUUZumIk6UmzP/jBMt/Ki/Ubmk3rxpBAOVAfF9qtUTDU7d9jT2tO6V7XQ3BKhBIOe4V5JtNjKRrWm4ktPM3NvR6Qisj5zjQevxYPjOWSG3+YbPmjdp2crjgGCy4K4ZVvg99V9+VklI16vFcPQ0OCNMcUyuDQSk8xRnpS0TwH2NdGa/twSZmEE+wBe1k986y+6MgoO2ZsTqIEvrB9VlIxH21h/sHwFoUeX3vMNZJHYKxTzMey+yHJ6LBTZNMm3pRAcqoEaUdw4Hp42UOpomMUfRXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RoP9Mj7EDXGf/nByxHU6r3tbHUoCV3gRwDt9Nbds5CQ=;
 b=ARn7t0ljuyiSTvVGO2WcBKog46m2hEUw/p1+ZPEldvM92YOCZ2lxF5/Yn990XHh1v32gbN9Gf3HQm2Iqr+IFfuUWkLiG1CGgc7LAg+Oq99wuR3wByZWK2+hp5y7QxXvBBAsJkygj5F1ta9sTAS/ed1oJTiPSaDj3UqAS76mrJZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MN2PR12MB4533.namprd12.prod.outlook.com (2603:10b6:208:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.20; Thu, 31 Aug
 2023 16:50:25 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::af15:9d:25ab:206b%3]) with mapi id 15.20.6745.020; Thu, 31 Aug 2023
 16:50:23 +0000
Message-ID: <26760cf0-4c87-6228-2287-58a99ac08b70@amd.com>
Date:   Thu, 31 Aug 2023 11:50:20 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Mingwei Zhang <mizhang@google.com>, Jacky Li <jackyli@google.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
 <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
 <ZN+whX3/lSBcZKUj@google.com> <52c6a8a6-3a0a-83ba-173d-0833e16b64fd@amd.com>
 <ZN/0aefp2gw5wDXk@google.com>
 <CAL715WL9TJzDxZE8_gfhUQFGtOAydG0kyuSbzkqWTs3pc57j7A@mail.gmail.com>
 <df49bbb2-92c0-7792-ab90-e748be570b5d@amd.com> <ZOVCAweRM8Es6rJ4@google.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZOVCAweRM8Es6rJ4@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:806:a7::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|MN2PR12MB4533:EE_
X-MS-Office365-Filtering-Correlation-Id: 8146c568-f773-4647-299a-08dbaa425e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEm9t3Z36VGy/mJ5zHPtiCbfvQ4RfO2Yh3VYOuHHHpag82PB0O3cRfjxQouJTqJ77yIx/DI9xEbiHqfPB8lv/UduaReYIyIytJcJDSh4JkxcWyRqQ2hy+ki1w2jyLu+t8FmStcy8MhNiT04FoDtp1rRg6Y4IHVQfIHGumx52cGd0uye2XPDHqCyhGttp1ISt4Ik1YzvcbPgSQHWh54P3Oe5V3Q7RWJ80Q5CSvp+0C073qFWgSyRhJ+NVd487KoN25MIUcBTvkDsq2HkTOcfgQFH3C0iREZGZ3o3/yGgA1WfMVqxaCa0+IzIfiEkJFSFzsFQAVvhTndVZn+AEkmkSp4ywP2TGHqgXf4aGWne6RCSeg7OBG/AEyRfc+zztI9XccNwRvYUknw08Bl3hRTqo7gY7eY49KA9nvWuHCtC12GRg50AvzNUidBHSoU2NAPfLJuwZzb3QHQGOIczvJr3o+q6GpOjvucQkgWcfISgHnJKE6/mEdZiym6roQutknKQ5eQ45aGi7L+VQnt+5ykS+gp0zzxOYWbOHSiypNj+bQ2aCqGT0RKSfg0XkGOBQR30+Ul+CO8JU05rxxlgjD1XIIWBzmaoto/c6x5SvVYxB8a1dYYOY1zchzYNetRJFbRXLbRLcQes5t9DewvGicXJC9sAcPHLb2OZj2wp8bvCVv3gjvDw+bsM4eBD49/ZIFKru
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(376002)(39860400002)(366004)(186009)(451199024)(1800799009)(36756003)(31686004)(83380400001)(4326008)(53546011)(41300700001)(86362001)(8936002)(5660300002)(7416002)(31696002)(8676002)(26005)(6486002)(6506007)(6512007)(2616005)(38100700002)(478600001)(54906003)(966005)(2906002)(66476007)(66556008)(66946007)(6916009)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkNnc29JeW95SlRxcW1RNWV4MTlPWkZESDMzTTlIaGt1cnFHbE5mUzViWjdw?=
 =?utf-8?B?R3UzRzRZbEh4OWpvd3dteWk3MHdGajdZWUkwcDVpTjNURHhaVVpvTXhPNXFP?=
 =?utf-8?B?RnloVE0rM00wTzh5NUN0MTZtL3M0MGRWdUwrSzZPbXNmdkx5djY1bjY2NHNX?=
 =?utf-8?B?dzZNMCtqdHdQZCtqd3BPZVJkdmc3MzBBMStQcjc2K1JQR1V3dnpLVU5zWFJ5?=
 =?utf-8?B?L2h2dG4rWjhzZUU2YnZoTkpMb3ZpSmVGUmc1S0krOUx2cUlwSE9RQ0Qxdmgw?=
 =?utf-8?B?bU1zdzNCSEQ0TUQzWG1pa09yTmc4bWVOSzlWTHBhY0xjdFk3eUFTQzRzSkpy?=
 =?utf-8?B?S1F6VWl0bm1WR09vcXVpSlZvd0cyblJNRlQ2UEgvdlRjNGhheDNFV0M2Ym9H?=
 =?utf-8?B?S25BRU16UFIzT1JqVzhsbExjc1h2bklndGtJZTNxMy9iN2F4aHBpVUpRa0Fi?=
 =?utf-8?B?aEdtU05CM3gzWHNPSEVRckNaeENtRWhmTHJUYzdOVm1iTFFEY0FWMit2Y1Rv?=
 =?utf-8?B?K1l3NFdjcm9ZN2FjRVhjUm1Cb3JHQnEzMFdqRzRJeEZLelFFb1dxaHQ1N3dO?=
 =?utf-8?B?WDcvSW1sb24zM0VEVElQNnNJcWcyQWRjUzdrUkM2aE96ZVVZb1BobUFIWnZG?=
 =?utf-8?B?L2lkalRSSkVhRlo4TFpsbDd1M3NmK3hPalZKQ1BraXdJeGk5bHF5d0liVXR3?=
 =?utf-8?B?MzBDTUNNZnV3cXBLTjI4WEZ2WU5CVm9pM0pxUmpta05DVWJJV0VvdkpJQ1ho?=
 =?utf-8?B?WkxBd2lJY3FXZWYxZzMxUzVncld4cHc4TTlYT0E0YnZ1RnlXTkdoRURtQ3BB?=
 =?utf-8?B?MFpXVFVQWEN3dVQ1QTAvOXpKTjlmNDE1QkdUNjBKTmtjZ1ZYVXd3OWxFTU5Q?=
 =?utf-8?B?SlB5SlM1UkpGa3dhamY2SHd3dStoOGF5NlZQcWZaclJwZEJEV3c2VTJPNXNs?=
 =?utf-8?B?T0g0YzVLY0Z3ZGtHbUFDOC9qOXJUWE9mdFNGZStuUzhwVFRUM1hHbklNQWl5?=
 =?utf-8?B?SlJ3R0ppNlp4UkhobUdXWWdXTWVPU1JhRFZSa1QzcEFrOFV2SlNrK0pnN1ps?=
 =?utf-8?B?Z2dHY2k5K29Vb0Jud01IcnROMUd3MWNsTDlET0NuWklzYlpvTWZiNVFveHQz?=
 =?utf-8?B?SUpwU2lMbEkzSnluUWJ4a2h5Q1RNN1BNYng3NHZYeXpkYStQRndXN0xnT0lr?=
 =?utf-8?B?NHl1NmFoN2gxU3lyb3JyVGd4aVdxRGZZelJla0pXeGwydTVnVUl6VzFxODFh?=
 =?utf-8?B?S0lsRHZTR2FubWFaYU9zclB3ME5Pb21ZVU04QWQ3cHFIeWdtSGNobkRFSXNW?=
 =?utf-8?B?YnJoYU9LaFJ1eUZDTVJJUG1PVVdFZTVFQTEyN25WYlo3d29VOTlJVnJsLzZ4?=
 =?utf-8?B?blZ4MEo0NkFRTTJ3WGpsTTM0amVsdnVKcm04ZVZDVE9Hb21ITHhpTGErOGUr?=
 =?utf-8?B?MWVydlVzYkFxcVpIcG15OGtHWDFsREdvRGZXU3dic1RlMTEvQTdnS1ZubTZt?=
 =?utf-8?B?WEw1aEQzTnVXMkI0aFpqd20zUkEyeGdQSThzckZuZnNNS0VZZmJpQkhCOE1h?=
 =?utf-8?B?OHpYNHFiWStxUHZldFo3SXpPMWVqM0pxUzl4ZHMvaHhpR1ZrSVFsQVNRazJt?=
 =?utf-8?B?eXVKa0Vxd2VuWisvVVEwVlZDSGE0QmhCMVkxb291U1UxY3FqcGZROGRqV3pF?=
 =?utf-8?B?MisxaE9qWFh0dGlLVzlrVXFqU3hTM2FDdzR1ZEsrZDI1OSsrQmFMUXdzN2g5?=
 =?utf-8?B?WUZicThBdEJQRXpMS0tZcjJYcjhqd2RFNGFhUEV3VDlYZDJ1Ym1iWWlHbmh2?=
 =?utf-8?B?b0NMRVExTnY0b1RTM094Tm9XbXpwQ0o3aHBYVXBvY0NwV0ZpemlZT3ordUM0?=
 =?utf-8?B?Qi9sZU1adGJHTEgxTjhBd3V0OGE5ZWdYNXZoMi9RM1kycG9CNUUzZWhDMk5P?=
 =?utf-8?B?NnhTOHNEYnZDZTNFUTRvK3c1dWRDYmVEa0pmWlNMTU1qNGx6dmN0NFE1OGQ3?=
 =?utf-8?B?OTdQL2RBM3ZiN2lEbzUzdEFxZG56dWc3M21GRGlTanZSaDFZbGhxNE5oZEZT?=
 =?utf-8?B?ZDJyWElNcCtWY25OZGJjcG9kNVFld2pvZDArTmtMVUNQZktweGM4YzhKS2pJ?=
 =?utf-8?Q?Lhf2qbx2Fd0WjKCfFgZCQGTE7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8146c568-f773-4647-299a-08dbaa425e58
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2023 16:50:23.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKNI7uGDgZ6VVVE/2lhFf2Ijn7FzjrAet3U/UCUZbOm/wZKR0kGLzgaVaSokvPZFoxZw+ZP6IXZb1EZGWR4sDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4533
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

On 8/22/2023 6:17 PM, Sean Christopherson wrote:
> On Mon, Aug 21, 2023, Ashish Kalra wrote:
>> Hello Mingwei & Sean,
>>
>> On 8/18/2023 9:08 PM, Mingwei Zhang wrote:
>> The maximum hits are seen with shmem_fallocate and madvise, which we believe
>> are response to shared<->private
>> GHCB page-state-chage requests. discard=both handles discard both for
>> private and shared memory, so freeing shared memory
>> via fallocate(shared_memfd, FALLOC_FL_PUNCH_HOLE, ...) would trigger the
>> notifiers when freeing shared pages after guest converts a GPA to
>> private.
>>
>> Now, as with SNP+guest_memfd, guest private memory is not mapped in host
>> anymore, so i added a generic fix (instead of Sean's proposed patch of
>> checking for SNP guest inside sev_guest_memory_reclaimed()):
>>
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -593,6 +593,9 @@ static __always_inline int __kvm_handle_hva_range(struct
>> kvm *kvm,
>>                          unsigned long hva_start, hva_end;
>>
>>                          slot = container_of(node, struct kvm_memory_slot,
>> hva_node[slots->node_idx]);
>> +                       if (kvm_slot_can_be_private(slot)) {
>> +                               continue;
>> +                       }
>>                          hva_start = max(range->start, slot->userspace_addr);
>>                          hva_end = min(range->end, slot->userspace_addr +
>>                                                    (slot->npages <<
>> PAGE_SHIFT));
> 
> ...
> 
>> As expected, the SEV hook is not invoked for the guest private memory pages
>> (no more invalidation from shmem_fallocate() + madvise()).
>>
>> Isn't it better to skip invoking the KVM MMU invalidation notifier when the
>> invalidated range belongs to guest private memory ?
> 
> Oooh, you're running into problems where KVM blasts both the private and shared
> mappings even though invalidations from the mmu_notifier are shared-only by
> definition.
> 
> The answer is "yes", but simply skipping slots that _can_ be private is wrong,
> as KVM still needs to zap any shared mappings.  I have a plan[*], but I completely
> spaced on incorporating the idea into the gmem RFC.  I'll add that to the "list
> of todos for merging gmem", which I need to get sent out asap.
> 
> https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com

Looking at your gmem TODO's post, i don't see anything specific for this 
support:

https://lore.kernel.org/kvm/ZOjpIL0SFH+E3Dj4@google.com/

Thanks,
Ashish

> 
>>> In fact, AFAIC, SNP VM does not track whether each page is previously
>>> shared, isn't it? If a page was previously shared and was written by the
>>> host kernel or devices before it was changed to private. No one tracks it
>>> and dirty caches are there!
>>
>> The skipped invalidation here covered the case Mingwei mentioned above,
>> where the pages are changed from private->shared and subsequent freeing of
>> shared pages triggered the invalidation.
>>
>> But, then why are we concerned about this, i thought we have concerns about
>> the case where the dirty cache lines contain encrypted guest data ?
> 
> Yes, that's my understanding as well (assuming by "this" you mean the case where
> the CPU cache has dirty lines for _shared_ addresses).
> 
