Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F369D7AB574
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbjIVQEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbjIVQEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:04:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9599D18F
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:04:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPCINf4dPTGM8ovKhHN++PBZtbPhfjc7LW7HoYjaMM1ITGWq3XJKGuITiRwLlSGlvU0olhsLCdd8yvc0XfVsaRR0ByqSzqkPkUFZ75xRqdx47DSCgcLmzR9GVXxvAB6G2AR89P83bY8yQ6k71M7MvziH1OgEMPb14TyeR/SMS36JTjSys5W/VkadY1XCfcnav3F65RLJUfw02UQVElNgWBavUJR/PVaIfqSzo1var7y8SWNK/xW0N0nY17EM8Xd0qUkyK1Hk6NzGUwU81+qXiiAEy4bDODJQRXjmlRAFv7BW7/jUigsI25/Rl8xu4Y+fAdTfsPgbmK0iG1sHEyUVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nG8yCyz4DN+Sfl4TfQqCRpn/IG9V7paN18YXNgAz/g4=;
 b=DL8ZGp4HWcVoWNOuy2uWkoqetOreZwOF6CFwuwFKLyxwmhA/1Z9Mx8DUqKWcMsvA4qXokhoN8EPq4a6Uv8YCnz3xVcR4LrAF12b2OxiUdtFEavMbnwZIirhL1jQf+zknKeGtUKJ/DVAEVPOG5AKJp7l7jUG2loIqDFjdVaG8Ymvl92BlL5zhAluv1ESj3GcjgVn2c94O4T1gBVLv1oLZu36Qz+4bB+Hb/Qho7iCqFnWZ9dLp/lsmi+Kk9yOgdl9llaVY7ksk6xqPyXR5iMM8aPT8HDROtjZzF317qGDVdkHa2ptEK+yXSphzPez3pSvAtXE7C35qscxy/6JuVZOeKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nG8yCyz4DN+Sfl4TfQqCRpn/IG9V7paN18YXNgAz/g4=;
 b=An6o5xSSwyMGEKUbIXliNWJ1A1j2SUGXMwlPudz31tT2sCZD9DOg/23Tis4V7F0lJm3/eiJag8iqs0/Q+KkmBZ6mR+f8sq3PjPYEZRUUyYUIUtX3v8Xm0PmSrcqyauR/BIYo2d7Z1S/v+/uU5O2qVxEbqQXnCQL9W1yYqO5CL3o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by IA0PR12MB9012.namprd12.prod.outlook.com (2603:10b6:208:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.21; Fri, 22 Sep
 2023 16:03:59 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::fbfe:ec9c:b106:437e%5]) with mapi id 15.20.6813.017; Fri, 22 Sep 2023
 16:03:59 +0000
Message-ID: <a82a9b64-9b24-c592-96d9-2248b8a10acb@amd.com>
Date:   Fri, 22 Sep 2023 11:03:55 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v4 00/21] Support smp.clusters for x86 in QEMU
Content-Language: en-US
To:     Zhao Liu <zhao1.liu@linux.intel.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Babu Moger <babu.moger@amd.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
From:   "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <20230914072159.1177582-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0030.namprd05.prod.outlook.com
 (2603:10b6:803:40::43) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|IA0PR12MB9012:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f7b8a6f-3331-403e-a3a4-08dbbb858801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zA0s8rKs04jVDqD06iSt4s3HLuf8vO5sNlrnGvumLKKc3BZimioYWZ/FEsrfhKj0vrjmpRs/0QfHADVFSsKlTLCNcbcZyhNfwRw2WGGlpSIDfA/fqxo38v0oFyRygR0MXNNaS07hrdtZOIwY/uwNJLTtbnNgIV4JwPbi5Az2vCXr7Q/+WNoKkKpk9XkdnTOmd6/SpBi5wMu2t7OUA1A2IrZrWYTNzG7u+X5/EHQdlWfMkFVh7ktVaEV4Wn3cBPawIzdGNq6Eafbg4WekLsvsSonwB5zWZME591+YU0GXmQb/WlUJYo2pr1p79VvbWj403LlMmZZQhZhUez5pwB8cs6zlayYtg5slRjSpdbctbpLvgZ7RMl0YpT9nP7d9uo9acaBZkWwoUmJpJwx/1ovVcj4feX78YDO3Zz1FTo1g66MpP21MYvtj3pcJFQoIpDMYfIkJgssLzmw3TtFT42AE/24tDQP2uulkSJxcUyNg2KQ2ES9gvIziu9eOmAwKLgoZZ81eLaUhukLs4kedhw1ixABicc6X3wG8RPtkCGcicJVC+t/i8HgVmaLd5e5Eq9BFL904DY+WUvVrRM+695LHThZOZ6OUID12UkdHDaG9lmiBy60sqbc/I6aemXppxBX4jhGTLfQvo9ixVT5hjTiIhJRTFwQcDrg/7+OMiA1ae0E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199024)(1800799009)(186009)(53546011)(6512007)(66899024)(6486002)(6506007)(83380400001)(36756003)(6666004)(38100700002)(31696002)(2616005)(26005)(110136005)(54906003)(41300700001)(7416002)(66946007)(316002)(66556008)(66476007)(2906002)(5660300002)(8936002)(4326008)(31686004)(966005)(478600001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L24xVGEwcyt4TE02Um1FY1BsRmdFWmxxUjdjalFwVjEvOFN6eFphK2c0NnFV?=
 =?utf-8?B?NXVsUmhKNHJPdk9ITmpsYXczeXB3c3JzVi9wMUxVcWUzYVlZaG1PbWt0eVdP?=
 =?utf-8?B?dlJXQ1VnZHBCYmFDK2F6Um95Y2h5RDNtR2Mvam55TDFDR0FORFZsTW5lak1W?=
 =?utf-8?B?MlZoNlpNVlpGVXMySHpjVTZQYkUwUTJ0c3pxc3RQWWZqbW5BMXJaM0RIVk5l?=
 =?utf-8?B?cjdIMnpJams4RmQ4NVZTRm5DR0tZNXFNV3lhem1YSkRzMGc1VjBGdHA3NGE1?=
 =?utf-8?B?cXdJOFh0Y1RVVTVrR0J6K2tWa1R2VnFJVjIvaUVvTnlKT2JIUVZ6V2lYcEJh?=
 =?utf-8?B?U0QrTTBSbnRaZHllZ3FZVXV6MVh1eFBqUHZRemdUMXc0YWQwUDRzK2c3OG5l?=
 =?utf-8?B?cUxVMkwzd1lWM0lJanNQVHJxZzFXKzg2YmVxSkVYcFlJZzM0UXJNcFhGVGNn?=
 =?utf-8?B?OHhmYjVNOGFRbkhySmVMaUphaWVlc2w1WmZaWVlRYXB4dGlGTW5VK2E5QjJB?=
 =?utf-8?B?bVA3N1NCV1ljM0N3WjZObzRUR0I4K0JCdmpQNWFvWDdBYlkxQ3Q1WVpxamM1?=
 =?utf-8?B?VFFlWitmamZPRnhuTk00d0hNQW95K1NubHNIekZrWkFvWkFoTzZrSlNGcjF0?=
 =?utf-8?B?UG8vdUZCNEp6RE9tWSs4KzNnbDhGdVhZUUV6RGtvWmIvYVAyVVY0MStwdHox?=
 =?utf-8?B?Yk0wRnNVMm55MVdWbUlITDNPVmllcTdIbHBvQjRHcmsrRzlWU1BKMkhQcGg5?=
 =?utf-8?B?OHZnTC9YNU90NzFVVTJJdDdtZ1c1TWJ5UFdkUzE5WkxmTzM3WU5sVktrSHla?=
 =?utf-8?B?SnVFeVY3M2FTS2x3NWJZZW81WUdWSktjWERwcjdSZHJqaWl5TUdadjNsc1o2?=
 =?utf-8?B?aE43WWZEMUpocXhmdFB4c25UOC8yTjFuZmRJOUpwYVgveHNoTkl5eEFmQ0dm?=
 =?utf-8?B?MjEyS0hueHpQOFZLWlFrRTdTRkQ3MGd4NFRWZ2tIUUNremluTWhmdEJqQ2p2?=
 =?utf-8?B?MDZHVzlDU1FRRzJUMGxlajE5dUFLWWx5NlYwcXBNTVIxQis5MHBQU0ZLV3Jm?=
 =?utf-8?B?MWpBYW5JWXBlOVRLcjR2S3hmVzRmYm9YbnV6cWEwRTNvV3hRdVJzckRBc2dC?=
 =?utf-8?B?TS9ESkk3dTZDZm5SampVU1YrTnd2cHVvTzF0bFdRNHYrUEhrYVdONlM3emN6?=
 =?utf-8?B?NkUzSk52Z2Ivc3pUcndYV3loOFZsc3EyN0l5bnF5a3hCWjh3N1N1djBJS2FL?=
 =?utf-8?B?aTEzeDNlZTg5UzdPUGhLU3Z5amZQMk9MZktucHUwQkxGNStvcjl5N1JORTBF?=
 =?utf-8?B?c2dGdGpqYSsxQS9IWE5BZktHT3Q1TVlSOVgwNXl0MW5DQVlCOGR3WFhvc2dM?=
 =?utf-8?B?bG9CT3R4UzFLc2d3akp1cVl1NUZ6NVFLaEIyYTV4RUg5b2REQVhVZ0hQbmw3?=
 =?utf-8?B?Q3REUUxTUFR6aWdKa3hoMHhaZG96Qmhmc25nN0RoVWxRUHpsN0Z6c2czRVcw?=
 =?utf-8?B?VTRNTWVoM1h0aFRmMVJGL2Z4V0tTSXRzeDFHTWRXcjBTeE8wZEJxVEVsL1lZ?=
 =?utf-8?B?S2hraGRWWUtCa09tUHg2aDBoVE1OaUVXTSt2TzNKSGFuTTRESEVSeWdvK1dM?=
 =?utf-8?B?QTB6MCt5bjZ5QndwYmZtdEZJaVVHUEVCUnZPTjcremZ3dnBnWnh2ZlVHenBz?=
 =?utf-8?B?NXVEcm1XQTRjcit3UjBLcFRUTjJ2L2tiZ3NqaGVNL2taYTE0cW1uUDVtWXRT?=
 =?utf-8?B?QUxtZG01VWU1aExRbUx4dzB6NDJtMTJWS25DcUpaZHZzMkd1QzJkY296SmYr?=
 =?utf-8?B?NWZOWlJMcFFOUERSREtIRDY3VE05K21lODFEeEF4LzBpQ0h4WVhkVTdFWTRW?=
 =?utf-8?B?MmNSWTgzMnJaV2grUEZMWm1ZSUkzZ2FxQXN2UjAvWjlNL3dtT1FGeTNzdHpR?=
 =?utf-8?B?NnVXaTMwUk9HeW0vczJWdEl3YW5NTklNbi9saElNdkt2SldHV0h6ZXFBQU1T?=
 =?utf-8?B?dDVZZkhEaTB0dldTSDBlZi9wczUxL3cvdnlIUit6SDhSN2k4dVNpejA1OVlL?=
 =?utf-8?B?NjQyRU9UZDhZMmtOOWJWcnVKbXRQWllSNVk0azJ0clBqYStsVmwrU0NJTXFB?=
 =?utf-8?Q?bH3VvPtj0uVxUUW1JtLKVabfe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7b8a6f-3331-403e-a3a4-08dbbb858801
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 16:03:59.1305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bgTHLTLMLjNJ8XBtaNvlakq6K9bQXh7ERqUGKVT0HWiGIN9jqnO6NGd5aT/06Em5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9012
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested the series on AMD system. Created a VM and ran some basic commands.

Everything looks good.

Tested-by: Babu Moger <babu.moger@amd.com>


On 9/14/2023 2:21 AM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
>
> Hi list,
>
> (CC kvm@vger.kernel.org for better browsing.)
>
> This is the our v4 patch series, rebased on the master branch at the
> commit 9ef497755afc2 ("Merge tag 'pull-vfio-20230911' of
> https://github.com/legoater/qemu into staging").
>
> Comparing with v3 [1], v4 mainly refactors the CPUID[0x1F] encoding and
> exposes module level in CPUID[0x1F] with these new patches:
>
> * [PATCH v4 08/21] i386: Split topology types of CPUID[0x1F] from the
> definitions of CPUID[0xB]
> * [PATCH v4 09/21] i386: Decouple CPUID[0x1F] subleaf with specific
> topology level
> * [PATCH v4 12/21] i386: Expose module level in CPUID[0x1F]
>
> v4 also fixes compile warnings and fixes cache topology uninitialization
> bugs for some AMD CPUs.
>
> Welcome your comments!
>
>
> # Introduction
>
> This series add the cluster support for x86 PC machine, which allows
> x86 can use smp.clusters to configure the module level CPU topology
> of x86.
>
> And since the compatibility issue (see section: ## Why not share L2
> cache in cluster directly), this series also introduce a new command
> to adjust the topology of the x86 L2 cache.
>
> Welcome your comments!
>
>
> # Background
>
> The "clusters" parameter in "smp" is introduced by ARM [2], but x86
> hasn't supported it.
>
> At present, x86 defaults L2 cache is shared in one core, but this is
> not enough. There're some platforms that multiple cores share the
> same L2 cache, e.g., Alder Lake-P shares L2 cache for one module of
> Atom cores [3], that is, every four Atom cores shares one L2 cache.
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
> "cluster" [4], this level is at the upper level of the package. Here,
> the cluster in x86 cpu topology is completely different from the
> "clusters" as the smp parameter. After the module level is introduced,
> the cluster as the smp parameter will actually refer to the module level
> of x86.
>
>
> ## Why not share L2 cache in cluster directly
>
> Though "clusters" was introduced to help define L2 cache topology
> [2], using cluster to define x86's L2 cache topology will cause the
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
> We can configure CPUID.04H.02H (L2 cache topology) with module level by
> a new command:
>
>          "-cpu,x-l2-cache-topo=cluster"
>
> More information about this command, please see the section: "## New
> property: x-l2-cache-topo".
>
>
> ## New cache topology info in CPUCacheInfo
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
> four Atom cores share the same L2 cache [2].
>
> Thus, in this patch set, we explicitly define the corresponding cache
> topology for different cpu models and this has two benefits:
> 1. Easy to expand to new CPU models in the future, which has different
>     cache topology.
> 2. It can easily support custom cache topology by some command (e.g.,
>     x-l2-cache-topo).
>
>
> ## New property: x-l2-cache-topo
>
> The property x-l2-cache-topo will be used to change the L2 cache
> topology in CPUID.04H.
>
> Now it allows user to set the L2 cache is shared in core level or
> cluster level.
>
> If user passes "-cpu x-l2-cache-topo=[core|cluster]" then older L2 cache
> topology will be overrode by the new topology setting.
>
> Since CPUID.04H is used by Intel CPUs, this property is available on
> Intel CPUs as for now.
>
> When necessary, it can be extended to CPUID[0x8000001D] for AMD CPUs.
>
>
> # Patch description
>
> patch 1-2 Cleanups about coding style and test name.
>
> patch 3-5 Fixes about x86 topology and Intel l1 cache topology.
>
> patch 6-7 Cleanups about topology related CPUID encoding and QEMU
>            topology variables.
>
> patch 8-9 Refactor CPUID[0x1F] encoding to prepare to introduce module
>            level.
>
> patch 10-16 Add the module as the new CPU topology level in x86, and it
>              is corresponding to the cluster level in generic code.
>
> patch 17,18,20 Add cache topology information in cache models.
>
> patch 19 Update AMD CPUs' cache topology encoding.
>
> patch 21 Introduce a new command to configure L2 cache topology.
>
>
> [1]: https://lists.gnu.org/archive/html/qemu-devel/2023-08/msg00022.html
> [2]: https://patchew.org/QEMU/20211228092221.21068-1-wangyanan55@huawei.com/
> [3]: https://www.intel.com/content/www/us/en/products/platforms/details/alder-lake-p.html
> [4]: SDM, vol.3, ch.9, 9.9.1 Hierarchical Mapping of Shared Resources.
>
> Best Regards,
> Zhao
> ---
> Changelog:
>
> Changes since v3 (main changes):
>   * Expose module level in CPUID[0x1F].
>   * Fix compile warnings. (Babu)
>   * Fixes cache topology uninitialization bugs for some AMD CPUs. (Babu)
>
> Changes since v2:
>   * Add "Tested-by", "Reviewed-by" and "ACKed-by" tags.
>   * Use newly added wrapped helper to get cores per socket in
>     qemu_init_vcpu().
>
> Changes since v1:
>   * Reordered patches. (Yanan)
>   * Deprecated the patch to fix comment of machine_parse_smp_config().
>     (Yanan)
>   * Rename test-x86-cpuid.c to test-x86-topo.c. (Yanan)
>   * Split the intel's l1 cache topology fix into a new separate patch.
>     (Yanan)
>   * Combined module_id and APIC ID for module level support into one
>     patch. (Yanan)
>   * Make cache_into_passthrough case of cpuid 0x04 leaf in
>   * cpu_x86_cpuid() use max_processor_ids_for_cache() and
>     max_core_ids_in_package() to encode CPUID[4]. (Yanan)
>   * Add the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
>     (Yanan)
> ---
> Zhao Liu (14):
>    i386: Fix comment style in topology.h
>    tests: Rename test-x86-cpuid.c to test-x86-topo.c
>    hw/cpu: Update the comments of nr_cores and nr_dies
>    i386/cpu: Fix i/d-cache topology to core level for Intel CPU
>    i386/cpu: Use APIC ID offset to encode cache topo in CPUID[4]
>    i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
>    i386: Split topology types of CPUID[0x1F] from the definitions of
>      CPUID[0xB]
>    i386: Decouple CPUID[0x1F] subleaf with specific topology level
>    i386: Expose module level in CPUID[0x1F]
>    i386: Add cache topology info in CPUCacheInfo
>    i386: Use CPUCacheInfo.share_level to encode CPUID[4]
>    i386: Use offsets get NumSharingCache for CPUID[0x8000001D].EAX[bits
>      25:14]
>    i386: Use CPUCacheInfo.share_level to encode
>      CPUID[0x8000001D].EAX[bits 25:14]
>    i386: Add new property to control L2 cache topo in CPUID.04H
>
> Zhuocheng Ding (7):
>    softmmu: Fix CPUSTATE.nr_cores' calculation
>    i386: Introduce module-level cpu topology to CPUX86State
>    i386: Support modules_per_die in X86CPUTopoInfo
>    i386: Support module_id in X86CPUTopoIDs
>    i386/cpu: Introduce cluster-id to X86CPU
>    tests: Add test case of APIC ID for module level parsing
>    hw/i386/pc: Support smp.clusters for x86 PC machine
>
>   MAINTAINERS                                   |   2 +-
>   hw/i386/pc.c                                  |   1 +
>   hw/i386/x86.c                                 |  49 ++-
>   include/hw/core/cpu.h                         |   2 +-
>   include/hw/i386/topology.h                    |  68 ++--
>   qemu-options.hx                               |  10 +-
>   softmmu/cpus.c                                |   2 +-
>   target/i386/cpu.c                             | 322 ++++++++++++++----
>   target/i386/cpu.h                             |  46 ++-
>   target/i386/kvm/kvm.c                         |   2 +-
>   tests/unit/meson.build                        |   4 +-
>   .../{test-x86-cpuid.c => test-x86-topo.c}     |  58 ++--
>   12 files changed, 437 insertions(+), 129 deletions(-)
>   rename tests/unit/{test-x86-cpuid.c => test-x86-topo.c} (73%)
>
