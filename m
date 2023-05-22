Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8DF70CF00
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 02:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbjEWAM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 20:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjEVXyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:54:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34F12121;
        Mon, 22 May 2023 16:52:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFu3TFFxy4Y1mt7krBhido6bvBZYRUmgepsrsgOzmE1soyWYR6fmu+x0hkVZIjUDQVXPsmQxzL0UukGx18I79I0BVS3FWy6sG3tpp3TYeZr1ejViISwKMnQoKDQjgnXp53BcZ2XKYMjo5TbtXdKEzg3WEjuFSnglfhmrCuAp64je6Iz+AFbJlgYWlWdvA7dmHZ6vWgsgT+4Aq383CQKEif1s8UUn44qNIOhE1UFbl7UgR8KdQnhWg6UNcBBacuHLrXpnFV3N/p9pL+XJ4IHCpKy3asKMFIyq5nyuyJXwFgbL1Qv4VN6HCy3fEz7vG8NL9dvAP2mDOXj67IrGlrjMiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1dvYbbyIB+uQG8Yahnkw2okBXGyXdzO634XafFh1enk=;
 b=abHRB4T07bJE01liQfgSYTItZog/hs+Vc6mU9kPcJhsNXgI9stsR2K8u4KLRzK/OdsMichp0J2XCbw0kT91dqVNCi3DD1g/7ucrmBAUfOfh/1perjoo8MKyzFIPrdN8U2vko82914zXlSGT5hSsTpQuU7U8AnMntEa1EZOarhrTJuXZZn8+1H9CVc1ZXTAxKqRjffeiTp5tNdi6VmMXYEVPvVRwDw7lBSd67AEaH71qXs27Ss+sk8XSXkv4/PaAmlzoCdTl7eTerFaNIAmY0xyJzODd4J5nDH4Y+IyB1NahPw6sNeO8YPYLYw5iqUfHHn6/VECq1lQFUUhgM/LtasQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dvYbbyIB+uQG8Yahnkw2okBXGyXdzO634XafFh1enk=;
 b=oO5F6VauC4c+MUi2ffHBWrYb/sLf21vT8820nx7b4MQbwBFLG/xqVUBSZQacKZbBmFZ/sJKRBZQy/xV7yS00dXTqZGLQGM5iScr0l1vzf+4+vOV45++hyDjdTfGvbPFBwM+/rBPuAL9N1hvwVZytzzIMNeLYl1/cBHTHf+zqlW1RRhO91vA7c0IHow9RiKLgZtJWlVOpoUJ9EtPQ6kbMm5wZAIdUKpKnsjgh+giVYhW4jGqeWNCycrEUde8BecZxfjiRy5V/wIva9wPHBeJATpHwsJMcgokDgyt74Iotq1MjHN5KLuEaxThorhpQyf+65EwLuBKT0ctlY8Xqa213Hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by DM4PR12MB5181.namprd12.prod.outlook.com (2603:10b6:5:394::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 23:52:47 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 23:52:47 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <ZGu1vsbscdO48V6h@google.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Tue, 23 May 2023 09:50:02 +1000
In-reply-to: <ZGu1vsbscdO48V6h@google.com>
Message-ID: <875y8jappz.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SY2PR01CA0021.ausprd01.prod.outlook.com
 (2603:10c6:1:14::33) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|DM4PR12MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ecfd1c-fa16-445a-28c9-08db5b1fa4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuZEd37SblNWAv4N+rRCPmfjR/aN0eOrIOA3F0Tg2k9TN4CbAXL9fiNMV/ZOrrNzGMDh/MjLK9rknvH4ihMMSuNemoV69KmRhQALOEZC2MGL1GH2S2RbSNFa18azvIHv9FOYmf6jIrariKj1fp4uGOtsutiAiv9aTLfKcbVsfZKIcd0ZNGK+TfiiPlr0G8NymQAbl/58YTw9MAjQSoz3jEGZd8jQQx1u217NnpG9+LIDMtTrpVG0bhJd4kZQqvNrSuOKT9GQvXmTfe1Inth89FkuOrNiYeo0/sRY8ZATM4ku+nJIh9FfYgYnwm/rJCzLQKn918eAvpA3GeWhzHOQYgoOyMCf3/NUoojDhKpRQDwrEBfV0Fk2lwI1Giss9q2rSHWgHNBDuImcN6UroRbT7z1Fu2NBwKTO/jk6UsO5tXM4TpVXHL2IG/zVmNOazDhePQKrkc51PH//9tFTDTe6m4W2cFM5V4lx38isXHWkLqs70ouQEhMahinrQc2R6xdtCcCJEqa3noCRaRxEIjU/6UQLUmq+P2CcciDOO3zM2go2TBHBXpQ/ADHAPqsAZ3BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199021)(54906003)(41300700001)(6486002)(478600001)(316002)(4326008)(6916009)(6666004)(66946007)(66556008)(66476007)(86362001)(5660300002)(8936002)(8676002)(107886003)(38100700002)(26005)(6506007)(6512007)(186003)(2906002)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0lipqwfo3g6EpGfD9wNXl8P/3Y2cVxeEH4GD7Eh/XhNaq+zolhka06BT0gj5?=
 =?us-ascii?Q?IVLBKvPrYNROpCrBhPF2LqKvE3BxBoM1aOg78GxHcSMLttW/LkiO2ZWyuVWV?=
 =?us-ascii?Q?Tl3w3msecJqrvcPNicFM+anOmldbohMSA/79LsoYtTiho9JyS73RrqRAqifs?=
 =?us-ascii?Q?RFL8SGU8RjKeJFhi8ItQOekc8PK4y2rP0NPAXYuVKWrdnLDiSWiAL6L6PAhc?=
 =?us-ascii?Q?Lpf5PC9HxAowkefXuDS3ZvzPiFeHmpn+MmbNCM48UDvLY7tAh9dLgObxWnRO?=
 =?us-ascii?Q?0ch+OL2TQvLUWjUvUkzy1CUFJOIlm5h3J98f/TlahnY9rZIdxFaWsc1u3GQM?=
 =?us-ascii?Q?mGZUnXf6yFFww05/QpaHf9uiP4BP2YtuZ2W3/VW5ADVdHm30sn9KxeT1EwkV?=
 =?us-ascii?Q?AxVQLijzeM6Ue1pkyIdi12YIHPrX82rGJxiIuu6JV3Hg0UdTkOOkT/iF2zy7?=
 =?us-ascii?Q?tlNYFAD8s5bC00Alm3qc8EKhTV27+PW5mN5YFjeVR5CxhcHs/3ces8v/Isam?=
 =?us-ascii?Q?c7n9MtuOFQkeWi7D9Ad549Jpv7d+o0kHbMWFtJwgKeuVN//v1XbNJzNoDwNQ?=
 =?us-ascii?Q?RPykWsW0mpYSSjT6p899MtDzrhhtW3MTOIZyLYLGBb9FVyDV64jrlXfRgyPF?=
 =?us-ascii?Q?5wb1M4ZlN/m6nT3zF5M/d3jKjjNYWndiuQmHeukC/vNvfjvaSeEvY8qKLOot?=
 =?us-ascii?Q?ZZZ2M6SCaT/4ljrwc3QnbR3p2rd4DhrK/qkKZW+B6y7KwJGEleJqYymOI6dM?=
 =?us-ascii?Q?EnRLOh/xtAjRYb8IOfa4L+8RNaMDxszTUrWw8NIS93IOQGpod9JASaBms1QL?=
 =?us-ascii?Q?OCBpT8ZIneONAkxhxA6IkrBwQaBPlngZxdIX8PAY9X6gIwnhPWUqqOvlpWSD?=
 =?us-ascii?Q?kg0Ib1dyEyPLMb3M8oMhtKgB48vw3nUr/fT2MCOc39MjDgSLXSSZwaTtVTKQ?=
 =?us-ascii?Q?buqlxTR++G3aoUFnsMi9/Z1khodcsO5Vkb+kwUv8IDIj8Rv+oZb1uE4zZ+5s?=
 =?us-ascii?Q?xhVA32kKos/ISQ+ztBYVbgYUhJiXei/+3dVOoaxC0QHvlpudr6jZHqdV68A5?=
 =?us-ascii?Q?btrPxZ0CCk+2Zxco7uYYzERpD8cOu8Yddkw5GvV2vHrTqAiJEhLr4V1wH8XN?=
 =?us-ascii?Q?HOtYmHz0gdFh9BNL2XIARCkug7At1Kb4IJ3W9FMm+XXSyJayhQOnB8qijtvu?=
 =?us-ascii?Q?EZFYxvUJ/tlItEwQXk3TknDakKUTkrF2RUFk7KiOnaZMOeUozPSfs0tUPqMj?=
 =?us-ascii?Q?wL3jXibkvZl46hyRdbJRW9TMlOrAmpp5a1fXZzaCRBU+6kJ0UMo1cofBd5Lq?=
 =?us-ascii?Q?1N+X8LD28Gd2u0aUv6sh/if4QlnqKX7XXdaLOPN/Gx+B74S+qTcwL91XNOHx?=
 =?us-ascii?Q?+0D3vf7ofvi+FtPA7qgCaN49Vb2FoK87MtO3RJPoL3GHwE9dGdFE10g6Btxs?=
 =?us-ascii?Q?p6+VQHcj7reGkX6NHDDCPvJQ16AfhvunrOmtijDM5ebRvcvDQgcJLg14ywRy?=
 =?us-ascii?Q?NRUw8ApfiusJRxbfFpMl4Ql3j0HY1aOD+j2sDjk0T9QzRVMdZO4oUC6H61/s?=
 =?us-ascii?Q?5LdzFpv72VA3TTsJgV9PLNhrTusDdpf0z/mHGg/R?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ecfd1c-fa16-445a-28c9-08db5b1fa4ab
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 23:52:47.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tGouy7S8MRT0NWMWf08rLdFKZuJ0VztPk+0mBT58tKB3rLoeaUu9fObg9ncr+JjTbB8/ImI8YB+EitjeDXVuCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5181
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Sean Christopherson <seanjc@google.com> writes:

> On Mon, May 22, 2023, Alistair Popple wrote:
>> Some architectures, specifically ARM and perhaps Sparc and IA64,
>> require TLB invalidates when upgrading pte permission from read-only
>> to read-write.
>> 
>> The current mmu_notifier implementation assumes that upgrades do not
>> need notifications. Typically though mmu_notifiers are used to
>> implement TLB invalidations for secondary MMUs that comply with the
>> main CPU architecture.
>> 
>> Therefore if the main CPU architecture requires an invalidation for
>> permission upgrade the secondary MMU will as well and an mmu_notifier
>> should be sent for the upgrade.
>> 
>> Currently CPU invalidations for permission upgrade occur in
>> ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
>> directly from this architecture specific code as the notifier
>> callbacks can sleep, and ptep_set_access_flags() is usually called
>> whilst holding the PTL spinlock. Therefore add the notifier calls
>> after the PTL is dropped and only if the PTE actually changed. This
>> will allow secondary MMUs to obtain an updated PTE with appropriate
>> permissions.
>> 
>> This problem was discovered during testing of an ARM SMMU
>> implementation that does not support broadcast TLB maintenance
>> (BTM). In this case the SMMU driver uses notifiers to issue TLB
>> invalidates. For read-only to read-write pte upgrades the SMMU
>> continually returned a read-only PTE to the device, even though the
>> CPU had a read-write PTE installed.
>> 
>> Sending a mmu notifier event to the SMMU driver fixes the problem by
>> flushing secondary TLB entries. A new notifier event type is added so
>> drivers may filter out these invalidations if not required. Note a
>> driver should never upgrade or install a PTE in response to this mmu
>> notifier event as it is not synchronised against other PTE operations.
>> 
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>>  include/linux/mmu_notifier.h |  6 +++++
>>  mm/hugetlb.c                 | 24 ++++++++++++++++++-
>>  mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
>>  3 files changed, 72 insertions(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d6c06e140277..f14d68f119d8 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -31,6 +31,11 @@ struct mmu_interval_notifier;
>>   * pages in the range so to mirror those changes the user must inspect the CPU
>>   * page table (from the end callback).
>>   *
>> + * @MMU_NOTIFY_PROTECTION_UPGRAGE: update is due to a change from read-only to
>> + * read-write for pages in the range. This must not be used to upgrade
>> + * permissions on secondary PTEs, rather it should only be used to invalidate
>> + * caches such as secondary TLBs that may cache old read-only entries.
>
> This is a poor fit for invalidate_range_{start,end}().  All other uses bookend
> the primary MMU update, i.e. call start() _before_ changing PTEs.  The comments
> are somewhat stale as they talk only about "unmapped", but the contract between
> the primary MMU and the secondary MMU is otherwise quite clear on when the primary
> MMU will invoke start() and end().
>
> 	 * invalidate_range_start() is called when all pages in the
> 	 * range are still mapped and have at least a refcount of one.
> 	 *
> 	 * invalidate_range_end() is called when all pages in the
> 	 * range have been unmapped and the pages have been freed by
> 	 * the VM.
>
> I'm also confused as to how this actually fixes ARM's SMMU.  Unless I'm looking
> at the wrong SMMU implementation, the SMMU implemenents only invalidate_range(),
> not the start()/end() variants.

mmu_invalidate_range_end() calls the invalidate_range() callback if
the start()/end() variants aren't set.

> 	static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
> 		.invalidate_range	= arm_smmu_mm_invalidate_range,
> 		.release		= arm_smmu_mm_release,
> 		.free_notifier		= arm_smmu_mmu_notifier_free,
> 	};
>
> Again from include/linux/mmu_notifier.h, not implementing the start()/end() hooks
> is perfectly valid.  And AFAICT, the existing invalidate_range() hook is pretty
> much a perfect fit for what you want to achieve.

Right, I didn't take that approach because it doesn't allow an event
type to be passed which would allow them to be filtered on platforms
which don't require this.

I had also assumed the invalidate_range() callbacks were allowed to
sleep, hence couldn't be called under PTL. That's certainly true of mmu
interval notifier callbacks, but Catalin reminded me that calls such as
ptep_clear_flush_notify() already call invalidate_range() callback under
PTL so I guess we already assume drivers don't sleep in their
invalidate_range() callbacks. I will update the comments to reflect
that.

> 	 * If invalidate_range() is used to manage a non-CPU TLB with
> 	 * shared page-tables, it not necessary to implement the
> 	 * invalidate_range_start()/end() notifiers, as
> 	 * invalidate_range() already catches the points in time when an
> 	 * external TLB range needs to be flushed. For more in depth
> 	 * discussion on this see Documentation/mm/mmu_notifier.rst
>
> Even worse, this change may silently regress performance for secondary MMUs that
> haven't yet taken advantage of the event type, e.g. KVM will zap all of KVM's PTEs
> in response to the upgrade, instead of waiting until the guest actually tries to
> utilize the new protections.

Yeah, I like the idea of introducing a
ptep_set_access_flags_notify(). That way this won't regress performance
on platforms that don't need it. Note this isn't a new feature but
rather a bugfix. It's unclear to me why KVM on ARM hasn't already run
into this issue, but I'm no KVM expert. Thanks for the feedback.

 - Alistair
