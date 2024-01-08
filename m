Return-Path: <kvm+bounces-5852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7049082769D
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 18:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 602FB1C229B2
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66B5454BC0;
	Mon,  8 Jan 2024 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aZG1q48c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2072.outbound.protection.outlook.com [40.107.96.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FBD54736
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1cBeSwV929qIjVnIXYialZFdeNc6F6NMUC+M3/yEfgFdQSgUV86NQKzb51JLTCImD7V6V4mp8hrkbTjigM0aL4s4057+YndyNluYfpkadEtKwIwX/FQemjawO64WGRufCI41c5US8+7X7oxi1FezvnbpPgZfKwCCv9Dkyk6oZTeWMsMF08q7jNrKSYx8CMo9B1OBBUlLPtOFkggU67WxwmM0D6IIrkY6hfzRbTSmSadsh1CG/No85LVgufU6WCCpnXKVRNRNtsX2KNxFzE+lIAlHRiFfS2uP0dt6uhryGUzG1jTrCa1gg5ZTSfYqi6Av1Sc+T8tniWtRLFZmuamNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sp5r1aPwUb+7tSscUm+hKNhkWHfiSGvB7pBHtD309fc=;
 b=hAoTTutNNCig3ChkXxceFA+rzI/rPYGe5GWIzfYdz2j2GJtC4KowPQheeHNTahjDNmx5KrGGRn90m0tdxN4IYSIUDiLT/ntaCbHYiJJ/ToTNvrh5EW0+RE9AO1U9/rCZdA0fZp0wEZ9EDWOPA53kfoVI3nltBT9TdYGDLce87JUyKvLnrpPOlwopGogLXewbi1kxJW+YcVBFtg42OP5SD+aFEkK04kbSlx1eyGpHnxfr00F6WcXURXN65Jaf7vvXdyZPurvOeS1reaTocefD+1NEpsncsJMLqoPvB2cghjoCJzjn2xo4cviR7p6gjvqzCY2Me4Qo3l/7FPqCFIi7fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sp5r1aPwUb+7tSscUm+hKNhkWHfiSGvB7pBHtD309fc=;
 b=aZG1q48cQgsFIT16WrkOlJzi8A8xlxAcUaKVe/wDdCgofmc/kxm1ap5tJsjSllnZuNjnq4k8z8EhQofvdUnkmNUeXORTPAFqIzGD7tImmWtaRq01TD6+Eyha29eHhe+gc+KysRGlSMMfYGr2Pne7fMCPfFFvQsSHh47r1kefTeA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by DM6PR12MB4896.namprd12.prod.outlook.com (2603:10b6:5:1b6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Mon, 8 Jan
 2024 17:46:52 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::1549:8c93:8585:ca1b%5]) with mapi id 15.20.7159.020; Mon, 8 Jan 2024
 17:46:52 +0000
Message-ID: <1766d543-8960-4f92-970e-d05975c53e90@amd.com>
Date: Mon, 8 Jan 2024 11:46:50 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v7 00/16] Support smp.clusters for x86 in QEMU
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240108082727.420817-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR10CA0016.namprd10.prod.outlook.com
 (2603:10b6:5:60::29) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|DM6PR12MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7fd604-b146-4392-9566-08dc1071cc39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y3Vhc+koxpKoNScbzR1PdsMyji2xdDteLSZUrIrtafkaa4iC0mSsxaTXdlV+PM5XVS2It51iFX7/pMvzCuCIhync9GtmQ6bXY4Mvm/B2c15MJJoRhcZxpDSAJZ/J1bi1g/6uupA88V3u0sKgiOhV++0liKImUB4Y+7GaLKLKSwdcSG/veVJBf76Q6vEqysqATDi+wS+xebfW4i/5ZcC9O2x6xwAkK+gBy6+L8KO08u6xtypZQJR5UTurW01dpCws8/nLJlqXOgVPvHlc56HCQQG1Bwndbw9LCnt4tMUnI5tD1gyir2ZBQPENV83GPISXmpZ0J/U3c5NFXH2++HMdLgi7j74CsiobLwwwxlhh77Nmit6NSQoIewHEudBQe5T/ShrFhQRJje8TVnk4I2NZKv304VO2W/EGlyeh856nud36ZQLLp2u09N16/JoDio+1VP08xLYtYPmVAjAhe+kPr4NJ94lxi3OKQ/HWBqDCeIVjSKr4L7ePMzoJP/niE/KYwW7F137A8L514QWVOWvumsApBCtaWX4YVV4U6f9PptogADnQOTaDZdDWmE2ceGNG29zeuBgs+Mvc0eZSfeX6Yb3j1qPbJaYfv6SESzsRL0E0xav7B1M258e+16fkUm+8JDxMZ567DDdICIR4jjFzjrmDfxSgdpHV5B4UwHWtC+k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(39860400002)(396003)(366004)(230922051799003)(230173577357003)(230273577357003)(186009)(64100799003)(451199024)(1800799012)(31686004)(66899024)(2616005)(6506007)(53546011)(6512007)(26005)(966005)(478600001)(6486002)(38100700002)(86362001)(36756003)(31696002)(2906002)(41300700001)(3450700001)(83380400001)(5660300002)(7416002)(110136005)(66556008)(66476007)(316002)(66946007)(54906003)(4326008)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkxGVGZKY21CaW10VklkYVpxZ2ZRWSs2UHN6ZG1ZK0Z2SWdTVm55L2txVGVQ?=
 =?utf-8?B?ZWo0ZkJLeHg0Z0dtaVJnWUV1R0VlUUkxTWV4SnNWYW9td1JQSitVQkdDRG1z?=
 =?utf-8?B?YmJybXJxTGdYYk1QNnpVZ0Iwem9FWlgyOXhzVm1hb2JPVWkyTXE1aVovRFdY?=
 =?utf-8?B?eENBSGJmVFowdXNuS1lvQkZubktQbEhOVXh3V3pYUGcxRTdqdmNIL2M0NCs2?=
 =?utf-8?B?TFpyVE84SkZudmNQZUJhNHI3bml1QkVkdE1VQUVEUlQ0YnpYeDAyc0E1c1ds?=
 =?utf-8?B?eG9IWEpSbXB0c29sVkpwb2drMVRrUGlXZ3RmeUxRUzRmS2o3OFZEK0s5SmRa?=
 =?utf-8?B?L2hrb3ozQ3pvVStHcWY2REpBTFUxcktWdU5aaTRWeUphaUJoaHgwREtJTVcy?=
 =?utf-8?B?bzdKMWtOQklSRld2V1ovb0FpNmJ6aDhQWThjL09Yakl3K0lURjNKbjBRckNp?=
 =?utf-8?B?aHUyREhkcDNvemFvdFMrYlMra1dPNzJRazRZQ2NNMXp1Y1NFeGMzT0ZpQ04v?=
 =?utf-8?B?QmFhSE96TGpnYk9neXhOaVlxR0ErWEpIaE1WSlNtWDhzZTVMcEt0RmtBZlZ0?=
 =?utf-8?B?eUw1djFuMmhYd1YvaUJNVEhtMUlicXgzU2hXTEV6amV6Y2E4cFd2ays2QjFn?=
 =?utf-8?B?bmdkVlpoU3hzV055UENXYkNjOWFKY3I0MkdwdFR5dFlHODhsL2htb2lzQ0Mr?=
 =?utf-8?B?Z2RHblNZOFlqUlVoNWpwUHZTaW40Y3VzRUt5YWNONWRlNXJpOE5PTVVRUVRv?=
 =?utf-8?B?VWs3K2o5RjIySWl5NkVGZ1NvVUozdFhJNkhVekdSODEwejRKa2l1R1dUQTFz?=
 =?utf-8?B?NnVjQ3MyN0FkQmhCQ2RWUFJaRlRVSW5rNTZ1OWRpd0tHWUordEdWSlhhUXhJ?=
 =?utf-8?B?RjF2V3NHR0FFaGVIMlZtUGNjbjRCVU1EeUFPdnNVZGIwTU82bWlDcHdOb1Bj?=
 =?utf-8?B?a0F0OG9pRDJuR3h5bmRUUDFBWEtMN3BRa1d5cmk2VDI3ZjJ5WExmRXdrL2Jm?=
 =?utf-8?B?VE5ZQ3gzWWE1ejZsWlhxUnlXVG5TYkRVZ2k4YjdtOFZ1TC9XeUxxUjg3VUpk?=
 =?utf-8?B?WndBT1ZEL0l3Nm5hYXFHR3A5bkE5Z05RSmxJU3Q0alhHTUFUNFR6QloyYTdp?=
 =?utf-8?B?bHdFMnU2ZTFPVDlldWZwL3JhQXl6c3ZKSnFLdXg1Sm5EQ1RYY29ERjNROEcr?=
 =?utf-8?B?KzYwV0Z6RHB6TWYvaG0rTlpNcjY5V05EZTk3WFJhQndYdllMK2ErWUdyN0Nr?=
 =?utf-8?B?NUQxbFdMYmdYUVhrbVBWREtKSUZ4ZGt0d3IveTQwZjNFZ1Z1bTdYemZpRmpP?=
 =?utf-8?B?dFhIL1Z4alUwRlBNNm9zWllDR0lOYnhSSmpFQWwxUUdCVXpJbVpKVWl4b29u?=
 =?utf-8?B?ZU11L0JTNTBaenVEcFhLVXR1NVgxWmhvTUdKOEtadVZHUGJibzdZc3ZsZURS?=
 =?utf-8?B?WWMram5mb3FmR0JyOXhKb0JpYjY3ZnQ5N0FHVTZzQ1pIWVBWM3hBYlgxWS9s?=
 =?utf-8?B?S0tXN0U3SXBudlkxNzUybzByV2haRWQwMmlXSHdLQm5nVDUvcmZiVUNmOXM0?=
 =?utf-8?B?Y1lwMDF5Z2c4Rk1nbGRWN3BSelVMdk9TY0ZnZkhQQU5IODExV1grSEh0c0RC?=
 =?utf-8?B?QXo2V3lHNVRaWGl4aUFISmhhZWxlOHpRMHU4cU9mcnhOMnpyTndRZEdScm84?=
 =?utf-8?B?cDRQNUpENmIvYnA2WVcrdVlma0ZMU2xnVGw5eFZ0OGljWWdIbHFvSUFjTEZL?=
 =?utf-8?B?ajREbisyOHdHUFIxNnJ2cUpjRTBRMUZwU1Jva29jKzlSNkNvNW1ESEpRRUQ0?=
 =?utf-8?B?SjB1cTljVGgxN0ZPTWY0RGJ0eG1RcDBPSS9CSDZTbVd0dUdmZTllOFF2TWRu?=
 =?utf-8?B?YjNHOXpGK09EZnhIVS9HRkVtQnc1TE14ejFBSGFCY1N4b3R0R2FUSFFrYVlj?=
 =?utf-8?B?Uk5yMHE2bCtaZWNEeGtlQmxlZEJURW9HaVpwV0lpOCtHRWtDM01GUDIwNWlK?=
 =?utf-8?B?R0NVaE0wK1pIU21XQ1lxRHFXMENwSTRaOEtrYVdXc3NLUTAwNHM5eWxsaUdM?=
 =?utf-8?B?NWVxSzNydWdDL3ErMklRakxqUi9qeTZlWXkyM2lGY1p2cVFSQjVIaFZMcDFT?=
 =?utf-8?Q?W0ys=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7fd604-b146-4392-9566-08dc1071cc39
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2024 17:46:52.5334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EyRUs1cdv23ZEZaZnTrnYUGp9Rk2laIO3TDv76pZuS7aQhF72vnx7E/WPfOVAf43
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4896

Hi  Zhao,

Ran few basic tests on AMD systems. Changes look good.

Thanks
Babu


Tested-by: Babu Moger <babu.moger@amd.com>


On 1/8/24 02:27, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This is the our v7 patch series, rebased on the master branch at the
> commit d328fef93ae7 ("Merge tag 'pull-20231230' of
> https://gitlab.com/rth7680/qemu into staging").
> 
> No more change since v6 [1] exclude the comment nit update.
> 
> Welcome your comments!
> 
> 
> PS: Since v5, we have dropped "x-l2-cache-topo" option and now are
> working on porting the original x-l2-cache-topo option to smp [2].
> Just like:
> 
> -smp cpus=4,sockets=2,cores=2,threads=1, \
>      l3-cache=socket,l2-cache=core,l1-i-cache=core,l1-d-cache=core
> 
> The cache topology enhancement in this patch set is the preparation for
> supporting future user-configurable cache topology (via generic cli
> interface).
> 
> 
> ---
> # Introduction
> 
> This series adds the cluster support for x86 PC machine, which allows
> x86 can use smp.clusters to configure the module level CPU topology
> of x86.
> 
> This series also is the preparation to help x86 to define the more
> flexible cache topology, such as having multiple cores share the
> same L2 cache at cluster level. (That was what x-l2-cache-topo did,
> and we will explore a generic way.)
> 
> About why we don't share L2 cache at cluster and need a configuration
> way, pls see section: ## Why not share L2 cache in cluster directly.
> 
> 
> # Background
> 
> The "clusters" parameter in "smp" is introduced by ARM [3], but x86
> hasn't supported it.
> 
> At present, x86 defaults L2 cache is shared in one core, but this is
> not enough. There're some platforms that multiple cores share the
> same L2 cache, e.g., Alder Lake-P shares L2 cache for one module of
> Atom cores [4], that is, every four Atom cores shares one L2 cache.
> Therefore, we need the new CPU topology level (cluster/module).
> 
> Another reason is for hybrid architecture. cluster support not only
> provides another level of topology definition in x86, but would also
> provide required code change for future our hybrid topology support.
> 
> 
> # Overview
> 
> ## Introduction of module level for x86
> 
> "cluster" in smp is the CPU topology level which is between "core" and
> die.
> 
> For x86, the "cluster" in smp is corresponding to the module level [4],
> which is above the core level. So use the "module" other than "cluster"
> in x86 code.
> 
> And please note that x86 already has a cpu topology level also named
> "cluster" [5], this level is at the upper level of the package. Here,
> the cluster in x86 cpu topology is completely different from the
> "clusters" as the smp parameter. After the module level is introduced,
> the cluster as the smp parameter will actually refer to the module level
> of x86.
> 
> 
> ## Why not share L2 cache in cluster directly
> 
> Though "clusters" was introduced to help define L2 cache topology
> [3], using cluster to define x86's L2 cache topology will cause the
> compatibility problem:
> 
> Currently, x86 defaults that the L2 cache is shared in one core, which
> actually implies a default setting "cores per L2 cache is 1" and
> therefore implicitly defaults to having as many L2 caches as cores.
> 
> For example (i386 PC machine):
> -smp 16,sockets=2,dies=2,cores=2,threads=2,maxcpus=16 (*)
> 
> Considering the topology of the L2 cache, this (*) implicitly means "1
> core per L2 cache" and "2 L2 caches per die".
> 
> If we use cluster to configure L2 cache topology with the new default
> setting "clusters per L2 cache is 1", the above semantics will change
> to "2 cores per cluster" and "1 cluster per L2 cache", that is, "2
> cores per L2 cache".
> 
> So the same command (*) will cause changes in the L2 cache topology,
> further affecting the performance of the virtual machine.
> 
> Therefore, x86 should only treat cluster as a cpu topology level and
> avoid using it to change L2 cache by default for compatibility.
> 
> 
> ## module level in CPUID
> 
> Linux kernel (from v6.4, with commit edc0a2b595765 ("x86/topology: Fix
> erroneous smp_num_siblings on Intel Hybrid platforms") is able to
> handle platforms with Module level enumerated via CPUID.1F.
> 
> Expose the module level in CPUID[0x1F] (for Intel CPUs) if the machine
> has more than 1 modules since v3.
> 
> 
> ## New cache topology info in CPUCacheInfo
> 
> (This is in preparation for users being able to configure cache topology
> from the cli later on.)
> 
> Currently, by default, the cache topology is encoded as:
> 1. i/d cache is shared in one core.
> 2. L2 cache is shared in one core.
> 3. L3 cache is shared in one die.
> 
> This default general setting has caused a misunderstanding, that is, the
> cache topology is completely equated with a specific cpu topology, such
> as the connection between L2 cache and core level, and the connection
> between L3 cache and die level.
> 
> In fact, the settings of these topologies depend on the specific
> platform and are not static. For example, on Alder Lake-P, every
> four Atom cores share the same L2 cache [3].
> 
> Thus, in this patch set, we explicitly define the corresponding cache
> topology for different cpu models and this has two benefits:
> 1. Easy to expand to new CPU models in the future, which has different
>    cache topology.
> 2. It can easily support custom cache topology by some command.
> 
> 
> # Patch description
> 
> patch 1 Fixes about x86 topology and Intel l1 cache topology.
> 
> patch 2-3 Cleanups about topology related CPUID encoding and QEMU
>           topology variables.
> 
> patch 4-5 Refactor CPUID[0x1F] encoding to prepare to introduce module
>           level.
> 
> patch 6-12 Add the module as the new CPU topology level in x86, and it
>             is corresponding to the cluster level in generic code.
> 
> patch 13,14,16 Add cache topology information in cache models.
> 
> patch 15 Update AMD CPUs' cache topology encoding.
> 
> 
> [1]: https://lore.kernel.org/qemu-devel/20231117075106.432499-1-zhao1.liu@linux.intel.com/
> [2]: https://lists.gnu.org/archive/html/qemu-devel/2023-10/msg01954.html
> [3]: https://patchew.org/QEMU/20211228092221.21068-1-wangyanan55@huawei.com/
> [4]: https://www.intel.com/content/www/us/en/products/platforms/details/alder-lake-p.html
> [5]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.
> 
> Best Regards,
> Zhao
> ---
> Changelog:
> 
> Changes since v6:
>  * Update the comment when check cluster-id. Since there's no
>    v8.2, the cluster-id support should at least start from v9.0.
>  * Rebase on commit d328fef93ae7 ("Merge tag 'pull-20231230' of
>    https://gitlab.com/rth7680/qemu into staging").
> 
> Changes since v5:
>  * The first four patches of v5 [1] have been merged, v6 contains
>    the remaining patches.
>  * Reabse on the latest master.
>  * Update the comment when check cluster-id. Since current QEMU is
>    v8.2, the cluster-id support should at least start from v8.3.
> 
> Changes since v4:
>  * Drop the "x-l2-cache-topo" option. (Michael)
>  * Add A/R/T tags.
> 
> Changes since v3 (main changes):
>  * Expose module level in CPUID[0x1F].
>  * Fix compile warnings. (Babu)
>  * Fixes cache topology uninitialization bugs for some AMD CPUs. (Babu)
> 
> Changes since v2:
>  * Add "Tested-by", "Reviewed-by" and "ACKed-by" tags.
>  * Use newly added wrapped helper to get cores per socket in
>    qemu_init_vcpu().
> 
> Changes since v1:
>  * Reordered patches. (Yanan)
>  * Deprecated the patch to fix comment of machine_parse_smp_config().
>    (Yanan)
>  * Rename test-x86-cpuid.c to test-x86-topo.c. (Yanan)
>  * Split the intel's l1 cache topology fix into a new separate patch.
>    (Yanan)
>  * Combined module_id and APIC ID for module level support into one
>    patch. (Yanan)
>  * Make cache_into_passthrough case of cpuid 0x04 leaf in
>  * cpu_x86_cpuid() use max_processor_ids_for_cache() and
>    max_core_ids_in_package() to encode CPUID[4]. (Yanan)
>  * Add the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
>    (Yanan)
> 
> ---
> Zhao Liu (10):
>   i386/cpu: Fix i/d-cache topology to core level for Intel CPU
>   i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
>   i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
>   i386: Split topology types of CPUID[0x1F] from the definitions of
>     CPUID[0xB]
>   i386: Decouple CPUID[0x1F] subleaf with specific topology level
>   i386: Expose module level in CPUID[0x1F]
>   i386: Add cache topology info in CPUCacheInfo
>   i386: Use CPUCacheInfo.share_level to encode CPUID[4]
>   i386: Use offsets get NumSharingCache for CPUID[0x8000001D].EAX[bits
>     25:14]
>   i386: Use CPUCacheInfo.share_level to encode
>     CPUID[0x8000001D].EAX[bits 25:14]
> 
> Zhuocheng Ding (6):
>   i386: Introduce module-level cpu topology to CPUX86State
>   i386: Support modules_per_die in X86CPUTopoInfo
>   i386: Support module_id in X86CPUTopoIDs
>   i386/cpu: Introduce cluster-id to X86CPU
>   tests: Add test case of APIC ID for module level parsing
>   hw/i386/pc: Support smp.clusters for x86 PC machine
> 
>  hw/i386/pc.c               |   1 +
>  hw/i386/x86.c              |  49 ++++++-
>  include/hw/i386/topology.h |  35 ++++-
>  qemu-options.hx            |  10 +-
>  target/i386/cpu.c          | 289 +++++++++++++++++++++++++++++--------
>  target/i386/cpu.h          |  43 +++++-
>  target/i386/kvm/kvm.c      |   2 +-
>  tests/unit/test-x86-topo.c |  56 ++++---
>  8 files changed, 379 insertions(+), 106 deletions(-)
> 

-- 
Thanks
Babu Moger

