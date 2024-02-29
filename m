Return-Path: <kvm+bounces-10512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B7BF86CCA5
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 16:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 356F8B2686A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:15:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51E513A265;
	Thu, 29 Feb 2024 15:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UtrslPk9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27541419B5
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 15:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709219693; cv=fail; b=gAkGKFGoOTjcjA3Y94Vf/5pRVQqjQbwvdl0aSV1riwNw2/q9pkOZi/Rkxx2FLBU71hIFFqoKo4w2J3WQjagDe7nYAbUo6wkB7eciCWC32i6K2RyzlZxJg2M6rZl1WsSWZ6ajopckwogP+FOEPYERcvJalRgMNC2g8MeX54Aibyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709219693; c=relaxed/simple;
	bh=7Q9EivAHXJzHLvedu5MUv9ocqhnwnDeEYaD/tkcmPWk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C+8vC28S/OIZeEFwJ3ptsuUSQdjmwLb6UpJdIKwOS0HaHHNC9YH8/LDL30vayYyYBij64Cnf0XxeVOaYIed0qaFWiMP6f6V1YT7SAL2zGJvgzEkGvAUGizLrcEkAOsMumTj30O7sVvpahfS5ewFTLEqUEaG/eKxOl2rJXb6OImw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UtrslPk9; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmuR8ZAuNcmW+s9fFgGvC2o4urj397br3Z/By7WqDUsmYsJhbLi/Q3hKtFwPDWpyk+ko5fvZzW5aNXSljv707HZWR5KgN+kNVYC5ypuzAZD5Zdwi9Sl/s5RlLPb0Um0IsLYKjtbylpsXhlUoTuMxPp/VzlqIs7Ub4hAtio7Q68Aeok3tnJ8fWyGol0QWNOGrSYc1fjblS8pNgLHHkwUurM3Zy1BdBa2boehr6QSGQHsgnZdMZJs5AkC20GuYuM8mg1iPnnLSXubpRf/pVD3bsdieM7BsFnmjZWCi8xVG7HMoxCVTvQeRGI9lpvSfoViodmbGlqFj+7+2Xei08JrP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxMWNYTLFEO0/rJt1hoii6KtnNpX62z4XxAB0Tvx+dg=;
 b=X3bDpcgr0QUKP0z7+F/QwrSDicjHRjRY+wbPTDSK1jTC/t8UwglrpyJ8P0WGYpkRFfYErO6yDCBWdRy4FH9G1NOxXZy7NHi/+L2NEasGGwFRyW4oTSHVfMqp+ozGNVdsOQ3n9bLtmFI8I9DKnZQPJOYqsqXg3OCfPH/ErRHj4hd+tFYL88ABKNjyf91Vmb5m8V9yn99hWsYHItkSlFqxzu0/J8y2TcpIlawjof8I7zCzW2wDc7k3jWqH1zeyVVjUyxp15Sl6slmKQgP3rCSUFtxLnZmdUVc6YNWoEWQVzyoRXe7dHXrmu8pHDkSfZIbJNGDP4/UjIDAoamiuNfFBIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxMWNYTLFEO0/rJt1hoii6KtnNpX62z4XxAB0Tvx+dg=;
 b=UtrslPk9kw3+i9sPFTCyolqqQ8swgaSvPWuPtiiasKLZVoOiEvUn2B7kRbwyGQ1BkXpoZeAYqk4x+5MoxqKv/kBLeSljtCnyMhWkx7CobBZRYKvEn0N7UDKGDkUR9kDrtZevwHghzCC5cSoeauncMd0wv6tuTV75vy6ciuwvGpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB5734.namprd12.prod.outlook.com (2603:10b6:510:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 15:14:48 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b49d:bb81:38b6:ce54%4]) with mapi id 15.20.7316.039; Thu, 29 Feb 2024
 15:14:48 +0000
Message-ID: <0306b83f-b183-45d2-91c2-7a4df6dba1aa@amd.com>
Date: Thu, 29 Feb 2024 09:14:46 -0600
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Yongwei Ma
 <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::22) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: b6c41fa2-9b9d-48b2-9ad2-08dc39392b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DFI3Hjsw/PN7ZJZby7TZBopKc2Xb12SnGOsjNmT9T2XZajVC4TadozzukExMbYhx2rhTmLcuCwl1F2axSQGGhTtvZ93N35JedY86a5OoER7gsYE5hJpBYSF4x+uWSGpHbGhVGqClHCadaECkh36WIWXG5241lyg5IWFba7a7J4gsMPIk+zXLA1jDXMceRKLwRqYBiJaQBcjJ+bUcGqz9jKb0rfIN+v5vI3h2VIXvzi9in5mPKkQl6LOiRJtUQ4qs5rOb7vmh0nHZQsqmCXwDTeSjg/TCnib8nhCsVuxa7KTbzjx1bLylrL1uRS06tQrKL01Ye45qZVqbTF6w8LdTK/ZDvhz6VLghvXIoG7dyN7mSBmr0M4MaFF38NiBAh+o1g7DURCkYu+cDHuo9a9dj8DECD21KkVEmJ9UDugvUN/y6sYT3FQkEa9Escli+fyfqIPta3eIYHIC9qVJWKvvrY9VI0voru6hVNdhvQEH/DFN0cfUx5FGk4RMcQk4ddfdaFVlOKdBBBtlvYpqUU57ksuWcVHEwWqQ/B+B1KaHTDV4l0XBT1i1TJjVOmltRIJ6kyHNX15W2ToTdImHYW5pyczDdBYnAyWYt1PDhHQ4d46cp1qFa7Xyd+F3qtDmCJVz0r98Ryoru0Gg70n4Pr+kw1HrITWPPOwyuAHfH0FQufCE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S00rNFUyVi9HT0dEWVkrczh5VWd0SHhuSEdNd2Vnem9jdlV3VzVIVFZ4OUg2?=
 =?utf-8?B?MVNFVXRqbGk0QWRRWW9UcytNejdnUDRZenQwU0RiT3VVZXlrWnBLN0gydDNo?=
 =?utf-8?B?WDlDVE1hQmdxYmV6TmxIZlNqeDMzeFI3Y2U3Tmg2ejhSbGFIaWcyZCtlNmNG?=
 =?utf-8?B?NjBFZ1d0UWZDUkoxelM2WDFPNm1LYmRQSHJzdjNUSWU2WXIwL05LSS9jY2ty?=
 =?utf-8?B?ajcvT3Fnd0RUOThkeVN6a2xhRlFFMDNkMmlVY0huRVJLeUF6bEVrL01VeTBl?=
 =?utf-8?B?V2VRYU1GUHVWUkU1ci9uWXdod3ZnenFCdWxHaE14Wk14QnovOXViQUlmUFRi?=
 =?utf-8?B?WFp0ZldmdEdXTWVCSnVQdHVUUzFWREhLc3ZuRGlrM2VlaHpqY2xoQlZlZHha?=
 =?utf-8?B?U3B0clRIK0hVR0lSL0lPZnlBVW9wVzAzMjNXd3o0c2tqOGxpOHlJZGlsS1Nu?=
 =?utf-8?B?Mmtrc0VKc2N4eWw0K0FRUCtwZHpHOUxHdk9qOGxVM3V2QUxkNFFFc0gvNVM4?=
 =?utf-8?B?QXhIUThhb2NZK3ovbGJaRmk2djIyVFR6MGRqOGNJYXNlNmZ2K3NXN3ZNY0g3?=
 =?utf-8?B?MFI0MWdIZmNnN3dNdkRHNnZuMDljNXhzVGFLU0Y1S2hsVW5FNmFDMUFzbmMv?=
 =?utf-8?B?dWhKeFhGM0ZIeFc5R2t0Yk9uS28rV3g4TnY5aVlCbC93TzBWeWJPay8zRGpO?=
 =?utf-8?B?YVZrSWNQTW9CRTgxa1N4VkF3R2pDWFpyZnUrYmNKaDdBb3RrcjE2cFFMMEtE?=
 =?utf-8?B?enhkVFBhb2FMZnMzWDFzdEtlSzVzNUF4cW9KekQxUVB4eDhHK2lQeE8zd1pU?=
 =?utf-8?B?K0QxdzJKamFuNzUxckRET1JoOHNxNnpoU1U5WUxFR0Vza2xmc2Ewa3lweVZq?=
 =?utf-8?B?MURoSDJvS0l1Qmh2My9jOGxtMWY3QjJab0Vjdmp4SVBrRkdGb25HOFRLck11?=
 =?utf-8?B?MnM3Nkw4YlIxSThqV0wzK2o2RDNDcFdaQ1Yvb1N4bmI0MW5qVU1waGRjcmJL?=
 =?utf-8?B?SFY2RFJUWnk4TkxVVHdCb2tIYi9seUJNeGd0d3V2RjJMSWtMSG5vYzRNTU5x?=
 =?utf-8?B?VVV2SGlmaWJhTWh1cExqbDgxSERXUTZ1YWNkcy8xRDZTTTZvSldVbG0yL05k?=
 =?utf-8?B?RWRFNG1md1ZZekticHJ6dWQyMWZpRC9OY3FLNm45bERuNkhCVDJaK0ZSb0JE?=
 =?utf-8?B?QU16VUpES2JiY0RsVWZHV1B3Qi9BZ3BQWVgwZ1RYTmRveUxVU1VvUGxjRW1E?=
 =?utf-8?B?K1BMcWVxMDAzVTZVRkxmd1lZWmxsdE1HUk9NalcxNVVTWGJmblRLeGVwUnI0?=
 =?utf-8?B?T1cza3B6ZWlvMHhPZVNaVkxiVzVzRjdubWQ2VVd3TmlwZGtuemV0cExDSVJt?=
 =?utf-8?B?NUNwTlpocnl1Y0EybFZLR0FJYmlEYjRsV1NoMy9ac3phKytVbGcvUFYvUlpR?=
 =?utf-8?B?bTZGeHRJQW95TGNrVGgxQlZsSHlFOWFtK2RTOGVRQzZJdlVYbHhsRXo0T2k4?=
 =?utf-8?B?Ni96YVN5S3RpaVZ6MHR2ZWZWbUZlQ29ZQUNMV2JoTlY5N3duYnV2SnhLRk9m?=
 =?utf-8?B?U1lwOVBtZlY1LzIxZi90aTdZK1Flbi9MZGxkc2MyMmpwLzlaRHFOay9pTU5q?=
 =?utf-8?B?MlVFaXJLeVRlM0s0OVgrdG9GRXdMaVZtSWpBS2FIa0RseHRoTDZpWHZ3Y2Vy?=
 =?utf-8?B?T1FqalFoclczN3NmRUd4bGRTUHBrOEhNMHcxcVFqaWE1MlJWRTI0c3FoTUNn?=
 =?utf-8?B?NnVQMEJvcVE4cFhHV0Exb2FOZ25HTzIxay9pemtTeE1rSllOMU5SaUJwZVRG?=
 =?utf-8?B?NEdYbjZwVGNiWlVkUkNScmNvLzRsRlgvYlErTFdFVUdIQnBwTmFyYWtwSi9n?=
 =?utf-8?B?Zk01Wk9vSDQ5YzBkOTQ0TjI3RzhWQlZ1SmJvVllkK3kweGtBYTlwWEJJN1Uy?=
 =?utf-8?B?OEYxZ2NUUDdWVDh6K0NUcGtPTERpalBmbDRXdUFqNmlSeGtOL0dURnErSmRj?=
 =?utf-8?B?N3haaVc4dDhkemNoMUU0RU90QkFWYngyNHYva3R1TTVSWHhnRjd1eWN4eWxj?=
 =?utf-8?B?dXV2ajlBbVlxU1dwL0NSOEpYVGZjMERLU29CaXdBK0tZOU9UZUdmZktZMTRN?=
 =?utf-8?Q?KqqA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c41fa2-9b9d-48b2-9ad2-08dc39392b35
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 15:14:48.1367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TUVfTwVi2jut1yBfIqDo6m7vKHnjZNL0CT/i0fB/DW8Iohlq9ZIK3Nh16txd4tlu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5734

Sanity tested on AMD machine. Looks good.

Tested-by: Babu Moger <babu.moger@amd.com>

On 2/27/24 04:32, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This is the our v9 patch series, rebased on the master branch at the
> commit 03d496a992d9 ("Merge tag 'pull-qapi-2024-02-26' of
> https://repo.or.cz/qemu/armbru into staging").
> 
> Compared with v8 [1], v9 mainly added more module description in commit
> message and added missing smp.modules description/documentation.
> 
> With the general introduction (with origial cluster level) of this
> secries in v7 [2] cover letter, the following sections are mainly about
> the description of the newly added smp.modules (since v8, changed x86
> cluster support to module) as supplement.
> 
> Since v4 [3], we've dropped the original L2 cache command line option
> (to configure L2 cache topology) and now we have the new RFC [4] to
> support the general cache topology configuration (as the supplement to
> this series).
> 
> Welcome your comments!
> 
> 
> Why We Need a New CPU Topology Level
> ====================================
> 
> For the discussion in v7 about whether we should reuse current
> smp.clusters for x86 module, the core point is what's the essential
> differences between x86 module and general cluster.
> 
> Since, cluster (for ARM/riscv) lacks a comprehensive and rigorous
> hardware definition, and judging from the description of smp.clusters
> [5] when it was introduced by QEMU, x86 module is very similar to
> general smp.clusters: they are all a layer above existing core level
> to organize the physical cores and share L2 cache.
> 
> But there are following reasons that drive us to introduce the new
> smp.modules:
> 
>   * As the CPU topology abstraction in device tree [6], cluster supports
>     nesting (though currently QEMU hasn't support that). In contrast,
>     (x86) module does not support nesting.
> 
>   * Due to nesting, there is great flexibility in sharing resources
>     on cluster, rather than narrowing cluster down to sharing L2 (and
>     L3 tags) as the lowest topology level that contains cores.
> 
>   * Flexible nesting of cluster allows it to correspond to any level
>     between the x86 package and core.
> 
>   * In Linux kernel, x86's cluster only represents the L2 cache domain
>     but QEMU's smp.clusters is the CPU topology level. Linux kernel will
>     also expose module level topology information in sysfs for x86. To
>     avoid cluster ambiguity and keep a consistent CPU topology naming
>     style with the Linux kernel, we introduce module level for x86.
> 
> Based on the above considerations, and in order to eliminate the naming
> confusion caused by the mapping between general cluster and x86 module,
> we now formally introduce smp.modules as the new topology level.
> 
> 
> Where to Place Module in Existing Topology Levels
> =================================================
> 
> The module is, in existing hardware practice, the lowest layer that
> contains the core, while the cluster is able to have a higher topological
> scope than the module due to its nesting.
> 
> Therefore, we place the module between the cluster and the core:
> 
>     drawer/book/socket/die/cluster/module/core/thread
> 
> 
> Additional Consideration on CPU Topology
> ========================================
> 
> Beyond this patchset, nowadays, different arches have different topology
> requirements, and maintaining arch-agnostic general topology in SMP
> becomes to be an increasingly difficult thing due to differences in
> sharing resources and special flexibility (e.g., nesting):
> 
>   * It becomes difficult to put together all CPU topology hierarchies of
>     different arches to define complete topology order.
> 
>   * It also becomes complex to ensure the correctness of the topology
>     calculations.
>       - Now the max_cpus is calculated by multiplying all topology
>         levels, and too many topology levels can easily cause omissions.
> 
> Maybe we should consider implementing arch-specfic topology hierarchies.
> 
> 
> [1]: https://lore.kernel.org/qemu-devel/20240131101350.109512-1-zhao1.liu@linux.intel.com/
> [2]: https://lore.kernel.org/qemu-devel/20240108082727.420817-1-zhao1.liu@linux.intel.com/
> [3]: https://lore.kernel.org/qemu-devel/20231003085516-mutt-send-email-mst@kernel.org/
> [4]: https://lore.kernel.org/qemu-devel/20240220092504.726064-1-zhao1.liu@linux.intel.com/
> [5]: https://lore.kernel.org/qemu-devel/c3d68005-54e0-b8fe-8dc1-5989fe3c7e69@huawei.com/
> [6]: https://www.kernel.org/doc/Documentation/devicetree/bindings/cpu/cpu-topology.txt
> 
> Thanks and Best Regards,
> Zhao
> ---
> Changelog:
> 
> Changes since v8:
>  * Add the reason of why a new module level is needed in commit message.
>    (Markus).
>  * Add the description about how Linux kernel supports x86 module level
>    in commit message. (Daniel)
>  * Add module description in qemu_smp_opts.
>  * Add missing "modules" parameter of -smp example in documentation.
>  * Add Philippe's reviewed-by tag.
> 
> Changes since v7 (main changes):
>  * Introduced smp.modules as a new CPU topology level. (Xiaoyao)
>  * Fixed calculations of cache_info_passthrough case in the
>    patch "i386/cpu: Use APIC ID info to encode cache topo in
>    CPUID[4]". (Xiaoyao)
>  * Moved the patch "i386/cpu: Use APIC ID info get NumSharingCache
>    for CPUID[0x8000001D].EAX[bits 25:14]" after CPUID[4]'s similar
>    change ("i386/cpu: Use APIC ID offset to encode cache topo in
>    CPUID[4]"). (Xiaoyao)
>  * Introduced a bitmap in CPUX86State to cache available CPU topology
>    levels.
>  * Refactored the encode_topo_cpuid1f() to use traversal to search the
>    encoded level and avoid using static variables.
>  * Mapped x86 module to smp module instead of cluster.
>  * Dropped Michael/Babu's ACKed/Tested tags for most patches since the
>    code change.
> 
> Changes since v6:
>  * Updated the comment when check cluster-id. Since there's no
>    v8.2, the cluster-id support should at least start from v9.0.
>  * Rebased on commit d328fef93ae7 ("Merge tag 'pull-20231230' of
>    https://gitlab.com/rth7680/qemu into staging").
> 
> Changes since v5:
>  * The first four patches of v5 [1] have been merged, v6 contains
>    the remaining patches.
>  * Reabsed on the latest master.
>  * Updated the comment when check cluster-id. Since current QEMU is
>    v8.2, the cluster-id support should at least start from v8.3.
> 
> Changes since v4:
>  * Dropped the "x-l2-cache-topo" option. (Michael)
>  * Added A/R/T tags.
> 
> Changes since v3 (main changes):
>  * Exposed module level in CPUID[0x1F].
>  * Fixed compile warnings. (Babu)
>  * Fixed cache topology uninitialization bugs for some AMD CPUs. (Babu)
> 
> Changes since v2:
>  * Added "Tested-by", "Reviewed-by" and "ACKed-by" tags.
>  * Used newly added wrapped helper to get cores per socket in
>    qemu_init_vcpu().
> 
> Changes since v1:
>  * Reordered patches. (Yanan)
>  * Deprecated the patch to fix comment of machine_parse_smp_config().
>    (Yanan)
>  * Renamed test-x86-cpuid.c to test-x86-topo.c. (Yanan)
>  * Split the intel's l1 cache topology fix into a new separate patch.
>    (Yanan)
>  * Combined module_id and APIC ID for module level support into one
>    patch. (Yanan)
>  * Made cache_into_passthrough case of cpuid 0x04 leaf in
>  * cpu_x86_cpuid() used max_processor_ids_for_cache() and
>    max_core_ids_in_package() to encode CPUID[4]. (Yanan)
>  * Added the prefix "CPU_TOPO_LEVEL_*" for CPU topology level names.
>    (Yanan)
> ---
> Zhao Liu (20):
>   hw/core/machine: Introduce the module as a CPU topology level
>   hw/core/machine: Support modules in -smp
>   hw/core: Introduce module-id as the topology subindex
>   hw/core: Support module-id in numa configuration
>   i386/cpu: Fix i/d-cache topology to core level for Intel CPU
>   i386/cpu: Use APIC ID info to encode cache topo in CPUID[4]
>   i386/cpu: Use APIC ID info get NumSharingCache for
>     CPUID[0x8000001D].EAX[bits 25:14]
>   i386/cpu: Consolidate the use of topo_info in cpu_x86_cpuid()
>   i386/cpu: Introduce bitmap to cache available CPU topology levels
>   i386: Split topology types of CPUID[0x1F] from the definitions of
>     CPUID[0xB]
>   i386/cpu: Decouple CPUID[0x1F] subleaf with specific topology level
>   i386: Introduce module level cpu topology to CPUX86State
>   i386: Support modules_per_die in X86CPUTopoInfo
>   i386: Expose module level in CPUID[0x1F]
>   i386: Support module_id in X86CPUTopoIDs
>   i386/cpu: Introduce module-id to X86CPU
>   hw/i386/pc: Support smp.modules for x86 PC machine
>   i386: Add cache topology info in CPUCacheInfo
>   i386/cpu: Use CPUCacheInfo.share_level to encode CPUID[4]
>   i386/cpu: Use CPUCacheInfo.share_level to encode
>     CPUID[0x8000001D].EAX[bits 25:14]
> 
> Zhuocheng Ding (1):
>   tests: Add test case of APIC ID for module level parsing
> 
>  hw/core/machine-hmp-cmds.c |   4 +
>  hw/core/machine-smp.c      |  41 +++--
>  hw/core/machine.c          |  18 +++
>  hw/i386/pc.c               |   1 +
>  hw/i386/x86.c              |  67 ++++++--
>  include/hw/boards.h        |   4 +
>  include/hw/i386/topology.h |  60 +++++++-
>  qapi/machine.json          |   7 +
>  qemu-options.hx            |  18 ++-
>  system/vl.c                |   3 +
>  target/i386/cpu.c          | 304 +++++++++++++++++++++++++++++--------
>  target/i386/cpu.h          |  29 +++-
>  target/i386/kvm/kvm.c      |   3 +-
>  tests/unit/test-x86-topo.c |  56 ++++---
>  14 files changed, 489 insertions(+), 126 deletions(-)
> 

-- 
Thanks
Babu Moger

