Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8AE70D044
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 03:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjEWBOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 21:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjEWBOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 21:14:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670990;
        Mon, 22 May 2023 18:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuL9ug6ZnaTmrXe61iT3jxdND0RL6DrmX+rUsfJ7xOxYtWCzvcmcR1ghCXB07o/2/3U8jEaQPmAE8Xw25Ri0TMsz3C/51c84LMzt1CxblPV93Axm0DabBceBzX92CzqnQ63jyUOsGtr3+84Ua5r5K+VNomWr+TQwtco7sKFCtXtAkoCJ/3ZjvTlqLjt+o2aiwgZkfksNKHOVcYnVZNJTL1jyzgk3NGtqLjutsex7G/iL5N1svjv+BdJ6pxx7rBK0A+N8N+EjAlJWjmN0PL+HwoP0J76Usz3vFprW4wBRoiBf8ulGSpHJ7fyQwN//IB4c+sT7BKc+1+5ZznThX+Zgbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyiKGMLMc+cg9e0XrAZcMyy3Age9OElBs3aWPdx3Sy8=;
 b=YrP7aXlI/9qgIK6cuVxnHLIiaTO/beaVgGC2r1qX/py7TtxWV9vhz92xmime+UqMOKIYtjHTyBpC7kJshQ4cA1lArSj3wZe9Hira479wVDpaMytwxeGSYKFnvClVoezG203W25OwaDGoMqWBS6Tfz/8/p1Gh//HPd5SQEp8GyqHTEmP+oQBi85/7w0J5ZqwjfCwkHsePM2n6XYUnSa4olF4mgMdd9piPqWuIIC+25POxHpcI18rNC3iWKJ6MJa9WSHXCUjWjjJk0NBZ2DRDd0InYSPIac6KxQuqJxuKwldk7R/RHuO7UiAqNiV/hcpPHY63QWRj/qYHwjtXxhqO+vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyiKGMLMc+cg9e0XrAZcMyy3Age9OElBs3aWPdx3Sy8=;
 b=GAEGvzdZewSn+u+JnBpj1lAfHcRDDe/r1sSbb4tx5q4Hgxu60WhWr5VsBgnT0BP+L60lFcEveTyCvEJePTg17NNcZ1Xc8dZZ9MSr7vMsQiYbv940FrNYwuHFEqSspS/u8v7gD34iNhCinlIPreDlCpiU9nR5jc1elAEt3Dl5/9qAHmylUaPe3okKA7Pwmfdl0LUyOEpjPMU0fn3Xw9rmJGh8fyk2VLICHXQXWCYa/j3kl1TOjncSl1+3eRrG7NLDpUgiUAbQV32dyrX5MQSSVf78zd3goERb9HZI7tvDysglW8xHqPE9piwpxoJNgpimxdHHzSCwCkIFPE5I9Jh7Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by MN0PR12MB5764.namprd12.prod.outlook.com (2603:10b6:208:377::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.27; Tue, 23 May
 2023 01:14:44 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::f6e4:71a5:4998:e6b2%5]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 01:14:44 +0000
References: <20230522063725.284686-1-apopple@nvidia.com>
 <cf2d7d64-8872-2b22-0b2e-8db96135d3ef@nvidia.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Date:   Tue, 23 May 2023 11:12:50 +1000
In-reply-to: <cf2d7d64-8872-2b22-0b2e-8db96135d3ef@nvidia.com>
Message-ID: <87jzwz97cv.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:217::27) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|MN0PR12MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fb855b3-5bd3-40c0-05e2-08db5b2b175d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asYd3Uzp0lBgX5TqGhrHRBweXx/X+39QGNZwn9xO3srfTK/iG3Ko+FLngXzoGP6/eUj2mQJ3+7vELk8LHqxF1yobsW4Gca1zIOPGYP5eLl43/NYgi0EbFVhKvNsz7g1H08nv2bTSci7diaR5TP9dyYy208yLiadHCX94iJ2GPWevMnfQo7ScdcZQj+e46KdnIRMDghHAadeMAFbSYMr0Y5s0gv2PMp2bSPv6BhTIwspOK8JBNhdhn0EFVaP+cpQAwPvZubmoOdWAVB32hsHSsRYW2FiZq1GmHnMpVHJAX7XXxjXQZ/ezxCDFgLufbshNEHAdu8ZPpcRXgNbXVjO82ILy5IZNT/H/C0kA2nOo8UGcAeuVVLsv51geGIQalD+DB+V52Bm2/ZnyLvtCJb+qsABqir9tEy6fSJe3C08UbhhvjWXjDl9quOWHdkN5/cOtB8qBjTf0+ikd7PweDl2Wtq3bYR3fi75cSI2xi0TBZC9uoMvP+37G4ZluwPwrJry8mL7xEzgn1dKBRF9NG3PKfT0Ke4eyI6wcpxfOq29emaNmoDr1sJ6W86pwtZhpXke4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199021)(38100700002)(478600001)(6636002)(4326008)(66476007)(66946007)(66556008)(83380400001)(37006003)(2616005)(2906002)(6666004)(316002)(53546011)(186003)(86362001)(26005)(6512007)(6506007)(41300700001)(6486002)(107886003)(5660300002)(8936002)(6862004)(8676002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C2Gsbiza1Vpk9lMBQIfOsAxuAeqiEoB/XztK+EbHMbnMXugEheT9RWWOGlk3?=
 =?us-ascii?Q?CjzbJGAQNaalC0eGiq7CM+50CJTaIPVdkQwpNvCz1pV8n8ipjBPGlsOX5Tng?=
 =?us-ascii?Q?xVlc53uKV0GJiApH0+3gK3xszQIdedV7YLWe39ETXeE9ibj61xDzXx4zysEc?=
 =?us-ascii?Q?TdO3yYcStva5q0LzdpcotjpNj+B55iQ28MjOY4P5cP2zA/LOImjVMHttW9GV?=
 =?us-ascii?Q?1Hnd0+Qx75ROMJ6AFTLcyQhIXjZLtsdIvV6HAbz1PkGlm5MJCIiVPnHv97ZZ?=
 =?us-ascii?Q?bcS34mdr3WSfHrCva1htIfq82guRaDvYN7DzA2GhFexHQfJRPtNvMUwmvmlI?=
 =?us-ascii?Q?NeMNzIs1kqNTtlGNRjCQiMjcTcETLIOTX7GDpHiY36BUxVwdTww+yCyD9Do3?=
 =?us-ascii?Q?iaiQMJHjzgirasgLO6EDiWrRf8JI91KSEaR/+AlewXMP00RISU9zFqobXnJM?=
 =?us-ascii?Q?yaCR+L2FW4V0NvRZiRhgkyvV45gOEC313neU7XdYvXRk0ywhNarJvsquRXK3?=
 =?us-ascii?Q?+z+miRXcMdS+V8j0+8y3W15mKwuF9XHmMlo03vB8Cqa2V6LMg1kFv3x+aQU7?=
 =?us-ascii?Q?oCJvbAmkFU9cLjqW+ZEq7R/+HP2V/cZK6rMJV6WOwun/PWIDgI23At6YZ46l?=
 =?us-ascii?Q?RZsIunmMXeEQsbPReXFZIVBnmEpflkE9hz2Hc+YtDQcVlAdzuOTmTC5Hgjwn?=
 =?us-ascii?Q?QMpYhTkxsbBfreg7wZ8sSfq2lsSx084nTWEkcXZpMFqJa8WUX8zwpldpL43Q?=
 =?us-ascii?Q?hO3RGqv/tj8/dES06U6T34lnf0neF1ZOUg3OtqEfoxEHqwKZ9dbP/Y9SuAMo?=
 =?us-ascii?Q?MMpnWzSM4BLdYExGzIAETXcJ2DcPmDCfFYfjzXGkuqxLLkO6OlEZVODRKcXE?=
 =?us-ascii?Q?We851HQzcjoxdYBHPpVitRckQlxARWdQEdGjB9OT/lmg1XBkEqVwOSJ9UkWo?=
 =?us-ascii?Q?EQQ3a3Oh/NuCaqKfW69xfcYB9zFsBtMvO+6xQI2R4ABvPejo1qkxHw7EUxHo?=
 =?us-ascii?Q?6uSaf4Xf9BFifs7OJDFWULRimFjwIrSDuIdTmKOK2vxjaGCipniYIOgI6q1T?=
 =?us-ascii?Q?moxH55kyXzZ5BAPqPyJ4kl53AXzRZL4dWy1zOQQSkOR58hq8Qmjxp4YX3xR9?=
 =?us-ascii?Q?AM1KXhUhCVrz0KeaFR//xtViuWsJls5k82smOWPr9biSeghlxXR9UVtjSKoo?=
 =?us-ascii?Q?xA/B+TuweSoORSmJWsmzzIQmsQlvddh3g1Wp7Ay5Cf/eeGrF2f7fD7XpfacD?=
 =?us-ascii?Q?3D6MUrOgocT9xjdO876z3MnOyr2BwnNSFg6/s8IHDWbRKnTc7GE0wL8XlQ45?=
 =?us-ascii?Q?GHCn2Up3RqiyXgKeO0PTXZb93mU5POlW1pSpRYWGP16IEif/9Hn2Z3TFhTUe?=
 =?us-ascii?Q?YVmzZ/pdrEs9yso4KlbbzLUxxq8xPyWNmfu2LTi8QSV0Bg7N1mAdJJjj9U34?=
 =?us-ascii?Q?XvuxfnwKuCxpvdZ6qJ5GaQwuZFPnifzTiWIT22QndNAEIaexXet5KeTZpjsQ?=
 =?us-ascii?Q?WtkpiNoVxO5D0y3QOgGeoFYyx8B3xH8BFtPkgPMOke2sM4dZ74aE7IW6JmNt?=
 =?us-ascii?Q?jzOSn1uEEDP+UkZbYZUjWydkeapM87bug2pId0GT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb855b3-5bd3-40c0-05e2-08db5b2b175d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 01:14:43.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BcPd0IaqjPtcZ43rlG1qoJDHk1IzI6KhnMnYQROBhpx/td8hIZBkdZWIty/iA0kttgVa3kyegTvLJOPj5mCMjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5764
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


John Hubbard <jhubbard@nvidia.com> writes:

> On 5/21/23 23:37, Alistair Popple wrote:
>> Some architectures, specifically ARM and perhaps Sparc and IA64,
>> require TLB invalidates when upgrading pte permission from read-only
>> to read-write.
>> The current mmu_notifier implementation assumes that upgrades do not
>> need notifications. Typically though mmu_notifiers are used to
>> implement TLB invalidations for secondary MMUs that comply with the
>> main CPU architecture.
>> Therefore if the main CPU architecture requires an invalidation for
>> permission upgrade the secondary MMU will as well and an mmu_notifier
>> should be sent for the upgrade.
>> Currently CPU invalidations for permission upgrade occur in
>> ptep_set_access_flags(). Unfortunately MMU notifiers cannot be called
>> directly from this architecture specific code as the notifier
>> callbacks can sleep, and ptep_set_access_flags() is usually called
>> whilst holding the PTL spinlock. Therefore add the notifier calls
>> after the PTL is dropped and only if the PTE actually changed. This
>> will allow secondary MMUs to obtain an updated PTE with appropriate
>> permissions.
>> This problem was discovered during testing of an ARM SMMU
>> implementation that does not support broadcast TLB maintenance
>> (BTM). In this case the SMMU driver uses notifiers to issue TLB
>> invalidates. For read-only to read-write pte upgrades the SMMU
>> continually returned a read-only PTE to the device, even though the
>> CPU had a read-write PTE installed.
>> Sending a mmu notifier event to the SMMU driver fixes the problem by
>> flushing secondary TLB entries. A new notifier event type is added so
>> drivers may filter out these invalidations if not required. Note a
>> driver should never upgrade or install a PTE in response to this mmu
>> notifier event as it is not synchronised against other PTE operations.
>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
>> ---
>>   include/linux/mmu_notifier.h |  6 +++++
>>   mm/hugetlb.c                 | 24 ++++++++++++++++++-
>>   mm/memory.c                  | 45 ++++++++++++++++++++++++++++++++++--
>>   3 files changed, 72 insertions(+), 3 deletions(-)
>
> Point of order:
>
> What is this based on? It would really help if you would either use --base
> with git-format-patch, or else just mention the base somewhere. Otherwise,
> actually applying the patch takes some hunting around...in particular for
> older stuff. This is from Feb, 2023, before hugetlb.c got converted to
> folios, right?

Yes, my bad. This is based on v6.2. I had meant to rebase it prior to
sending but forgot. Based on the other review comments though I will be
reworking this to put the notifier call in ptep_set_access_flags() on
Arm anyway.

> thanks,

