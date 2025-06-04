Return-Path: <kvm+bounces-48387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3864BACDC46
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E8D0A1744F5
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C4328E5EB;
	Wed,  4 Jun 2025 11:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vVdDZPRW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9347262F
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 11:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749035062; cv=fail; b=I3xhkC7/MMnChLxVzj5k4AyeZXKt4XA9jFgAyhYb/jbIDXE+ooa7ZPibzP/TEPATFxBpI5PTZFuoEdWPFFWO/bAO7f/MXyj0ettwM5yaG/aL74F3LEKarabP6PrgOqniBAoLP7eR6cl+7K8I7Iu6fwHPJ9tBkfiwgV8aFQ722Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749035062; c=relaxed/simple;
	bh=QSw0mXWOgVZtPN3eVKmNhq0IMjbMwQ+UlcTZyx5JmoQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tX2cryR9AbNThvK5mHxSyJls/rbbiUJIadoGUMCxS1q4AyvHdZHi/4sszFVBkPPSm8TG/vsvHR1JKmV9csBlewyiOOUPdfBQ3a23vxtTTH9HATjV5w/3zM5c51327KQuQTHT3Gey3ZVU6Hi3G/LFDJ4BlWPNqD7Rtqd8z64MOZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vVdDZPRW; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPG53PDRt2/CpWNO9f9MCQD0WUh7zETJ44XpQ2R+JLboAl8cHsl2fAG4Okgq18z1ZXe9GZBU9Wf4cYhCFdswfrToDVxiEDQe21DBjfd4jIAssTGY1QiLeXM2bgMBp3TkyD+c0x1PW4AjL9M+zl7ULHspjjs1BIyohW7Of+MI7mjd2ARIjqNBrYfkoSphY5kKsLhyi9hRSmeSIBSw54pU5lHvBaFckivn3IzKWifecHrKKNER4i/BwW+sLxicDfuIKisJB8xKWu4aysUkk/lGEuI1sTPtkMWL9GVr7X9D4orteB284R0vdi6Mg7BproT3rCe9VCP2y7UmGPFpP55sfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KUDn6cXNTJnIjN56kEqXwyfh71NSh/9D/thd3FGkQhc=;
 b=gYxQ4de96MOMA3oluMwA3GU87HBQupakaztURo2VsZVbeo2ywlaBNX/C5q7XJ9ed9ikJDvRUf7i1W5kQYPJaVzGm4vrPmINFhWlKFQi6CgLkOYOCsRsVZ003uigNgHLgJqqXKStMP2FyW0y0pWZKeFfGdEwV9ixxR47HC2m2mR/1iGsgyfBiLOx8bNYuILOc7t32baq6j4Pu66+35H2D/0yLjPMCwgKDZkIMCK3KuPzixCDWiiVe8PH/Iqe04YqesghYR2mMc1VYyGEnegKuA+obV0vdilbMzbHMI18K+atTX+YvBjTcFEsqMFINIt/dGMHFelfTrxDjgdNzYqwKKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUDn6cXNTJnIjN56kEqXwyfh71NSh/9D/thd3FGkQhc=;
 b=vVdDZPRWSqN5x0lVcS49wwSM8brLsQgy3OXQPPDsqgJGBLSiyMD/mHIPqLo+ypy7qw6xV6YOKGH25mi8+NAmrp1vQG4abnnqy63FWBozIGu+XoPN+HtgjvUn+tbxSTg/ry3KzWjJ1m3/P9Ry5brlItiF2b/DcdyVREV4357YQf0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 11:04:18 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 11:04:18 +0000
Message-ID: <156fa6b3-9bef-4147-bf99-82d3010ec2d4@amd.com>
Date: Wed, 4 Jun 2025 21:04:13 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v6 5/5] physmem: Support coordinated discarding of RAM
 with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-6-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250530083256.105186-6-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0070.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::26) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d7aa06d-ef57-4217-3f94-08dda3578cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3JZK3ZjOWVLNVBkRC9ya0dETk1oOW5HengyV3ZEV2J3TnhoNTAzZTZyUTMz?=
 =?utf-8?B?QStkMHFSeE9TWG14dHNQNkY1Z2VORnJ0R2FlZFpCaXJ6cllCa3d0UURTNnhJ?=
 =?utf-8?B?TUVLb2I0QjNxSHM5K0tRaVJYVklIc3RhczlDU3hkODVYVlMwb2dJMXNqVThi?=
 =?utf-8?B?Z2lNN0lkcWZsTVFoc05SbDArajhjOGQxb0dEaHp4cDlUY2k1TFVUTEgxOVpE?=
 =?utf-8?B?UWJNVVlNaWVOaXJ0UlM2c0wvMmo2Q0hnSjlRY3NEMFk5SzdXN1hmRkRkWVJM?=
 =?utf-8?B?enZrc08yZS95MU9YMUlid0dmcGliQmtiL2xDUFJDcE1qM3plZWYyNG96NVZE?=
 =?utf-8?B?ZjlVUStoUEo5SjcrU0YvWUp2MSszaGJnTHpFZnowcG9jclluMjJvTy91K2dP?=
 =?utf-8?B?TVZmRHZOQ1Q3NldwOTl5QW1aQ1dhNGxlNHJ2UkVjdmFOMVNLVUVjZjdubGs3?=
 =?utf-8?B?WDBxSDZUR2VGYTQwbGYvRnpnRXlTYzU1U1R0dXIvbmR1Vlo1c0xQMExpMkZ4?=
 =?utf-8?B?R0RhZkpod2FSY3VTUy91clg5bVo3UDlZN3doNUU4UDhDZVYrb0FQQzF2bW12?=
 =?utf-8?B?bC9HZ2FSbkp3a2xQSTRhUTJ6dkZlKzNDNHllTVUyd3Z0VHNjL3BRa3VkNTZM?=
 =?utf-8?B?VUw0UG1PU3NvVGhCZVpqK25MTGFqeHEvOTJWMThKOFFNOTFGSTBXeC9hdW1m?=
 =?utf-8?B?SlJEMUZlcDloNUtidTRvc3VaNkZzbWdnQWY2ejFGQXVySHkwbk5iUkx0cmNp?=
 =?utf-8?B?V0kwbEZFcnNrSjFjNXMzSXBLTGVFcWwzd1hmeXBvRE5CSXhUWWtPMFpDY2hV?=
 =?utf-8?B?VkVFR3gyUndJMUVZb0NpWUVhWWt0VFhOcWROOFJRTlpSWEZxYmJRR3g4SVk4?=
 =?utf-8?B?czhOazJOT0I3VGllVGJNb3VScENVY3E1dk5zQitEUXdFdUlkYU1ZazQ5Vks2?=
 =?utf-8?B?MHdlSXd5eFBnWVRTM0orNHhRTURWM3Q2bE02eWlzdUFhZUZoV3NYbVF3anEz?=
 =?utf-8?B?bUQzRGQvT0dvbzhDbEtkR0ROVEFaR20xUXJ2NWg4NTRZVWFTVWJmOTJyVjVP?=
 =?utf-8?B?UzNKMlVjU2U1c3dCMTg3Q09WR2lPUHRPK05VSTFBR2NUS3gyN2FCVXRWN1B5?=
 =?utf-8?B?amREV01GWUlreE5PMEdFYkRKNzdSVWF5WURINUtlamx1T1N6NEJjdkJkdHcz?=
 =?utf-8?B?b0hGV3V1ZVAxa2V5cXU0bzlLcS9WNlhPUUozdVR5Nmo1d3B6dnR1eTg2SGsy?=
 =?utf-8?B?YnU4b0ZlVlZIMmZnU2hQb1NBSXdueXNEcmg2V0xRVm83MHFuK2Y0ZHdFMmlI?=
 =?utf-8?B?aWpUZ2swenNKcUVzbGthZUZUd0xyMi9tN2JGZ2hzd0l3R1Mrb0xEZ3VqOGpi?=
 =?utf-8?B?S3VwNnltMnF3WGpqTmZLOTkzcFBzc2ZjU2RKRWF0SWlGMXpFZnJndEpvVlNI?=
 =?utf-8?B?SEE5TEsyNWE1UWZ6cjhTbUQyek14WGlBbUdERHJNSFFkbG9qR0N2eXJ4WElE?=
 =?utf-8?B?Y0JBc0lwbmxEMGZ5MHlWMks0eVFxa2I3M0FkemFBZ25jd09QRUlPakFPMy9w?=
 =?utf-8?B?ditNeWdINXNFOCt5NTFvNTJzRnE3cGU5UElYL254SVRscXp5enVieENybndN?=
 =?utf-8?B?WUlBbnJhYkJEcHVVTjdnR0hNWFhYcHVhSGNqWmxkOEVtV0k1M3JEbVpXL1pq?=
 =?utf-8?B?d1VxY1gxUTUxeU1RcnRvWExKOGlDRnF6eElTcFRyaUdOSkVkWXlYYXRDNEhY?=
 =?utf-8?B?R2pBa0NEbk42Z2xmTzZsZ1k5dmJpQk1CRWY0RGRIK0FDby83ZEtNMDVRUzVj?=
 =?utf-8?B?aXorQmZyK1ozd3d1Zm9EUmFDMmNpMzlZbE1iZUNGQkpranRqWmdOcjJMcWZZ?=
 =?utf-8?B?aWxXSWtGKzROVmZNdEl0SmY1SlVyZHBYUWZWb2Y0aFZlNUpRd3ExM1loT3Jr?=
 =?utf-8?Q?wCA8UI998KE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YUorMEJoNEhBaVJLWkliWkJ6RUNCL2RkTWY2cHpUQjhqa2tlbTdyRGhQelNF?=
 =?utf-8?B?V1FPUzVTOE1ZblU1eFRMN3NDOEluYTNYVis2eUFZZlVBVzAreFVteFdBVCs0?=
 =?utf-8?B?RWJkWUx5NTkycDZuUkp3Q0xkZkpPVjRjZ2JGWnBEVHdHbmpqbytMaGw4bHVG?=
 =?utf-8?B?T2dqVXgyKy9XV0RKdS9xOVVSTnhMbnZBZVFjTWU1R0dGS0tEQVVuMEMwczJY?=
 =?utf-8?B?dElQeTA1bXB6R1UvSlQ2cFh5OWN0UnFqSWlTeTd3WGNUTHRxdjZQSmpLR2U5?=
 =?utf-8?B?RXR6cjN1NGVOWm5ySCt6Rk1vVzdocUxLdEhyVi91VUg4Mk1YT0lvRGVJcnZX?=
 =?utf-8?B?WDhCY2QxTVhJVEt1RVZJZWxndEtpYnljQWpnQ29PRk5jSm9EUytkMTNQOUZ6?=
 =?utf-8?B?TlduNWJXWk92eGdYTFlxTDhwZjhHdExTMGF4ZjdkUEFWZHJFb0g0M0hHVkg0?=
 =?utf-8?B?Qk1FVXY5WFprb3lxYjZ4YVpFSzVpT3dYUDJFMFRlOVU4ZlVtand2emJiNTVU?=
 =?utf-8?B?NkFZNC90dVBCL05QUlI3cFZwdU13UWhiK29vd0pKT0J3VDNtRTk2dGJOSUp0?=
 =?utf-8?B?cU13RTl4dThpbzM0MWZTeGlXYUo1S0k3Q1F3VmhPY0pqS2RkU1FZMFBVRk5v?=
 =?utf-8?B?MzF6K2xBRzVEemFKTVN2TzRBSWk4M01YNGdzbVdNVmIyamIvZUtpVUpsSVF4?=
 =?utf-8?B?cWRXZ281MU00dk5na3p0T3ZBTUtPUzlVTnd5RkZYUU1BNHJ0NGFEZmJzZkIz?=
 =?utf-8?B?bHc1RFVRMnR2b0VXc2ZUamRPSFVZYWM4ZW5LTjkyUDAyejc0NVpOYXNON3VW?=
 =?utf-8?B?V0Q0Ulk2NEZqWHhvMlJDQll5bG9sbUR1SFE5WXN3VHRycWNlalhJOGF2Uk5i?=
 =?utf-8?B?TmdMZU1UOGsvb3VyYVEwQldxV0Y0WnlpMllER0RKODZJQjJ5cDhrVGZVbWdq?=
 =?utf-8?B?RHFLYVd4eGs4NXVUdkI5d0xzTHI4VE9vSDJSVnlPbFQ0TFRGYXY3RGJpbm43?=
 =?utf-8?B?eW5OUE1VaVFONEwrREtDQTMvenNNNDZieUV2b21RUVJDVThVZ1RvSG41Nkh3?=
 =?utf-8?B?NVdtRkp3WHVNTW1Wb2g5TS8rclFSVjZIVFZLU1o4TzQxd3oxR2p5WnZ6dHFW?=
 =?utf-8?B?b3A4L2x4VGZSbzBWS1hXNzdKZi9LTTJuM0pHZlgzWHgyd01uWEEvTEhYcEFJ?=
 =?utf-8?B?VWVQNnRmd3NxbGx2ekNvRmM0elZRY3lxYzV3UmlIbFJFaWF5aUNpeXFqMkhH?=
 =?utf-8?B?TTZpWXBIaUJaZGUvYUJWaTBMdjlWTTl2WXovVlVIRXE5SDNsa1NVcGJMRlVp?=
 =?utf-8?B?UGQxdkFWZmtzZkFMZW1mbWs2anVKSlJ2SW41VEJXL3FVQkNMa0RZSDVFL250?=
 =?utf-8?B?cEh2N0huUDV1a2FySi9xTXRKdm5pRkVlcGpLMnFyMzN1WUhzeFloZUh2VjJF?=
 =?utf-8?B?RGNteHVZdVJXTmNCWFZxWEpvUVJBSVN2OG9iMktIaEtUam1UZkplWVIwU3lX?=
 =?utf-8?B?ajhGRnZOejZoQjZJbUF0TGJ1ckoxUDlES2ZyNmR1MWppWkhqNzhleDgySzZa?=
 =?utf-8?B?WTFWQjlJMlU3QlJZL094NkdCYUVQWHlYOUZaR2I3eHZqTDNta2VWc3kxUm90?=
 =?utf-8?B?RWJ4Tkl0N2JycnZEY1B2dDcyNTFvOE5WUDhkTEF6WVpYWlRGMmtyUlN3cGJ1?=
 =?utf-8?B?VGRlUFpPMEpwcEVwQndVeWt4YWh5ajQ5aHdxN2ZnTmZnRTRjeDZRWi8rMlVw?=
 =?utf-8?B?aVN2RVkzd2NIM280R1VCc2lZYmQrZWIxald6QlRJdzdGMkdBZDhvK0xYS1dv?=
 =?utf-8?B?Y0t6bkFTREoxemJENmZITzdRYTVDMTF0eTNBcjNNckQ0UFJvYnNKa3NYUmZK?=
 =?utf-8?B?U2M4RjVlMnk5QVNZNVJRQkVSckdHeXJwNzZkV2tLRU1TTkljNDIrWDZ4WHE5?=
 =?utf-8?B?QVovK0JxWElaNmo3ZjZCbWkzejdhd1VPQjJvNmlKZmRVWlJFMXRJM0c2bzZj?=
 =?utf-8?B?V0hPU1hMaWJqQkVrT1NnK2hXUXozOTVHQ21FSGhCOFE5MWxWMWlkM2N1SzhV?=
 =?utf-8?B?ZDhOWk1DSHNJUFpVdGZZTVpRV00rZllWSmhMNmZvZnRML3c3VDNrTkVza0tT?=
 =?utf-8?Q?DgFt0RjQ3pOaM2yzysdbveZV3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d7aa06d-ef57-4217-3f94-08dda3578cf2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 11:04:18.2453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0g/IlSOhJisColpYyj6Z9qycL3WgDe618Ukz4mOJjjWbeNC/ziY3lv5x39vZBAXXoSwSUeqMEAR1J1dzFRa7cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444



On 30/5/25 18:32, Chenyi Qiang wrote:
> A new field, attributes, was introduced in RAMBlock to link to a
> RamBlockAttributes object, which centralizes all guest_memfd related
> information (such as fd and shared bitmap) within a RAMBlock.
> 
> Create and initialize the RamBlockAttributes object upon ram_block_add().
> Meanwhile, register the object in the target RAMBlock's MemoryRegion.
> After that, guest_memfd-backed RAMBlock is associated with the
> RamDiscardManager interface, and the users can execute RamDiscardManager
> specific handling. For example, VFIO will register the
> RamDiscardListener and get notifications when the state_change() helper
> invokes.
> 
> As coordinate discarding of RAM with guest_memfd is now supported, only
> block uncoordinated discard.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>


Tested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> ---
> Changes in v6:
>      - Squash the unblocking of cooridnate discard into this commit.
>      - Remove the checks in migration path.
> 
> Changes in v5:
>      - Revert to use RamDiscardManager interface.
>      - Move the object_new() into the ram_block_attribute_create()
>        helper.
>      - Add some check in migration path.
> 
> Changes in v4:
>      - Remove the replay operations for attribute changes which will be
>        handled in a listener in following patches.
>      - Add some comment in the error path of realize() to remind the
>        future development of the unified error path.
> 
> Changes in v3:
>      - Use ram_discard_manager_reply_populated/discarded() to set the
>        memory attribute and add the undo support if state_change()
>        failed.
>      - Didn't add Reviewed-by from Alexey due to the new changes in this
>        commit.
> ---
>   accel/kvm/kvm-all.c       |  9 +++++++++
>   include/system/ramblock.h |  1 +
>   system/physmem.c          | 18 ++++++++++++++++--
>   3 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 51526d301b..3b390bbb09 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -3089,6 +3089,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> +    ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
> +                                            offset, size, to_private);
> +    if (ret) {
> +        error_report("Failed to notify the listener the state change of "
> +                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
> +                     start, size, to_private ? "private" : "shared");
> +        goto out_unref;
> +    }
> +
>       if (to_private) {
>           if (rb->page_size != qemu_real_host_page_size()) {
>               /*
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index 1bab9e2dac..87e847e184 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -46,6 +46,7 @@ struct RAMBlock {
>       int fd;
>       uint64_t fd_offset;
>       int guest_memfd;
> +    RamBlockAttributes *attributes;
>       size_t page_size;
>       /* dirty bitmap used during migration */
>       unsigned long *bmap;
> diff --git a/system/physmem.c b/system/physmem.c
> index a8a9ca309e..1f1217fa0a 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>           }
>           assert(new_block->guest_memfd < 0);
>   
> -        ret = ram_block_discard_require(true);
> +        ret = ram_block_coordinated_discard_require(true);
>           if (ret < 0) {
>               error_setg_errno(errp, -ret,
>                                "cannot set up private guest memory: discard currently blocked");
> @@ -1931,6 +1931,19 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>               goto out_free;
>           }
>   
> +        new_block->attributes = ram_block_attributes_create(new_block);
> +        if (!new_block->attributes) {
> +            error_setg(errp, "Failed to create ram block attribute");
> +            /*
> +             * The error path could be unified if the rest of ram_block_add()
> +             * ever develops a need to check for errors.
> +             */
> +            close(new_block->guest_memfd);
> +            ram_block_coordinated_discard_require(false);
> +            qemu_mutex_unlock_ramlist();
> +            goto out_free;
> +        }
> +
>           /*
>            * Add a specific guest_memfd blocker if a generic one would not be
>            * added by ram_block_add_cpr_blocker.
> @@ -2287,8 +2300,9 @@ static void reclaim_ramblock(RAMBlock *block)
>       }
>   
>       if (block->guest_memfd >= 0) {
> +        ram_block_attributes_destroy(block->attributes);
>           close(block->guest_memfd);
> -        ram_block_discard_require(false);
> +        ram_block_coordinated_discard_require(false);
>       }
>   
>       g_free(block);

-- 
Alexey


