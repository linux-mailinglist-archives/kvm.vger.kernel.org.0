Return-Path: <kvm+bounces-18187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD4A8D104B
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 00:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 572EE1C20DC2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 22:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629A5167D81;
	Mon, 27 May 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrdVXjYR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08772208E;
	Mon, 27 May 2024 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716849386; cv=fail; b=metYDFqL7wBFyr6vPJxtWrzPnonFy76TzfRLie2iJTz0iIRLO3ZgHQDIdS2WpMpxP54fGpMkZxexRJPcHN/Kylm+RY7HB1mb9Onw1p/OULfLbSlrJS18pXPCFk2pSRFcQXZCL68XHb+nSLBil6JJQEFt4h3kCzATsfBBX4uJLZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716849386; c=relaxed/simple;
	bh=eg1694Jnpzgz2hA++5XUz4xK/MUN/3v9t8iEKReG31g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tm9KUDNvO8UIq4QV5Y34SzkjCUT7sZU/WuD2rYmhE6YMO0aigF4aXlF4MFc4BQtJEed3lC4apeVNPnR+DTIRNXMplRdULcWBf4wIo8JqZP0/ThELJP2Fmw7C+zQmCE4Oy7Fc+ZLbvs86TH/V4QixmFzLZhvZ0ZYmTrHM+hSts2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrdVXjYR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716849385; x=1748385385;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eg1694Jnpzgz2hA++5XUz4xK/MUN/3v9t8iEKReG31g=;
  b=QrdVXjYR5QMtrjcJDpWUGZ2FGqReCE3q3YIvjbgAqvVJ6/ME+jRI09f9
   xIyBJU4lfZvzlH8rlneybxAJy1dQuBXkh9OF5kNt23tdcJUyLQx6wNbVU
   G3HIqpo3+V+pzjjwGaVPg69VmYney8WmgFj6Wkpa7YwXYwlTOr7Ucxq5c
   TpPZ4BxgOx5kp5tsGshuPtWZIsIySIAy6gLjEkeJugtfpfCe+nVdoIRWn
   P/g5lKJNTch7Uy899F4mNVoT/hmSfIPHIsh37d6H/F0QITDbJAOXWAKdC
   9dik3id8jCAnGxybTziE4G+YyqRcoqbV+6m3ybg2qjdsojiUptzJKhC4e
   g==;
X-CSE-ConnectionGUID: wDSCcHCQR5OomRD7ZR/aSw==
X-CSE-MsgGUID: Q3rUZ2GLTgiPNLrzg3nJCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13121694"
X-IronPort-AV: E=Sophos;i="6.08,193,1712646000"; 
   d="scan'208";a="13121694"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 15:36:24 -0700
X-CSE-ConnectionGUID: PgeMkZjxSWGab5b6Rx5iAg==
X-CSE-MsgGUID: ku/0Xr0nQwmpwIQBMyUuFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,193,1712646000"; 
   d="scan'208";a="39271832"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 15:36:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 15:36:23 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 15:36:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 15:36:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhMaKQpLiWOz7vvBmO33A7uQnqmgQI+B8EXDjVFptSfMjT//jz2w753RUHle5UVukcC0zrjW9dyLsUI8lJSSicDAbv6+0OzprDjLoI2nRBm8aVPaEpkve3KohAQWeeYf5jEAy9y20bEe7jeJdS4CrdeZPBOyjR8VdYPfSmB6ZRKTtyfGypnBIS4PTsJmkJq1GYPmEyznJYMscnbnbI1dtaLpl4j/vzpO7lomYhlGrO3cggwswNRYI4VAIUKXmWTQhk6395GAxT1j19YEPsv2yMU9d0CW14T8rA6FhBIAk7Xy8O4GAbfpuDBfutgZckIXPOIr3lVF90bElmOozrJUXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E203caU2aGVepdbOgmqBsztAMHsN5xth0sX8OUD4Wrs=;
 b=MvcvDfuMYlKiHpAF611Me4t4q5+nhFUAPbnS4HlBGBnGQzydDjgDB/l0Lu+W2ImBLP5QA3cmxkAwqDlG23ztXqqYrGU73vQCrH8Uxsf2Mf+a5i8tTFn0WSMoaW2SaRa1qR5oh2To+LEfxtMDwXKOeOYVOghrmhN1xWC6prbuR1pQeh8dOPXMcN+i+agTuO1ZpCicWFQI3AtOFtIEaIjUzk91n2PcKEyIgC3TrSBvn8YHfClAfqVVdTekF7qrlo9SqCR2QFH0UDnkUYVJdKneTQwVOkc8uPAtt63jQgCRYnNFne3UrSR3j77XRVjfZhRa90L2pryEACWglmzhac3BCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA2PR11MB4955.namprd11.prod.outlook.com (2603:10b6:806:fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Mon, 27 May
 2024 22:36:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 22:36:20 +0000
Message-ID: <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com>
Date: Tue, 28 May 2024 10:36:13 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
To: Chao Gao <chao.gao@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
 <Zk7Eu0WS0j6/mmZT@chao-email>
 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
 <Zk/9xMepBqAXEItK@chao-email>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zk/9xMepBqAXEItK@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA2PR11MB4955:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e3b0207-190e-4c06-c2be-08dc7e9d6e0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ukh0WVU1a2pjWU9CWHVNRGFEcU4xdVpGVFNyWmw2WEprMHlkVkhvdExCUi9Y?=
 =?utf-8?B?TlNYeGRJQTc1bEErSTZFSjZHQ3duN0RjblEwbHg4RmVIMHpwNGZ4dzBGRHNt?=
 =?utf-8?B?NklGNGJDTVpFbjZtRngrbzhMWXFzUy9DMVJRc1duTktvbEI2MFQyMXNXR0lZ?=
 =?utf-8?B?R3BKa0RKNTNJMnluQ2hocytuQ1BMbk1lNTFVMnFUOUJXZ1hqR1FSdjFzL0dp?=
 =?utf-8?B?Tlg3OWtmNGpDbjVEWDhCdHlIUnJ5MWVmWTI0WXZmYVRNdGE4NVh5U01QMC9S?=
 =?utf-8?B?RjY4QThkbFFSTUxlbDdaL3cwWUJyQndjS0E1a25SNk5PZnl2emdiVklSRnZ6?=
 =?utf-8?B?TjJZc0JxN2UvalgwUVZza2x3d29qMk05dFdhQUF2T2RzZ0hSVk5IK0VmaTdH?=
 =?utf-8?B?YkVMNEl0ZzN1MjJWR05jRnRld2ZTd0VUV3BWNExlQVFaYkJKOEQxd1dqRUpt?=
 =?utf-8?B?SGdrT1E0Y2djZENYSXZYajl6WERjV1M1c2IrZzFXWHh0d1EzV3VlakR5Qlll?=
 =?utf-8?B?bTgvR1A1SUtWY2xjZE1VTHhkMW5zUGh3WWpXNXJ4Y0VIcU8xUmp3cTh0USt6?=
 =?utf-8?B?TDVId0NaN2hrZVhLTEkyTDhEYkhENGd2YTl4TGY4bFlaMXR0YUJXWmowVnhx?=
 =?utf-8?B?QXFJUkV5TVdta0dVMDBaUUZuYlJ6QnVTN0RxZHprTndhYmo3SjE2Kzk4TkdH?=
 =?utf-8?B?T1J4MVFVWnZXeEd6OUN3dU5WalU0Nm1uS2VrOTdsSzJ2dG55Y3lMeFd3cUNH?=
 =?utf-8?B?VVZwSE1GOGZScUxCV1liTnJQbkdtUmplakM1RFRXOGRHaDRaZy9vaFdLQU5q?=
 =?utf-8?B?MnlkTDAxUEpySWZmajZZZzhFN1ZLbk9DcmJWeFRXb1E3WmR0WndvSk5SMlh5?=
 =?utf-8?B?UXViUURBU3dLdllObWJhOFk1amloUU5vcHNEcTEvcmJCMDl4eCtyUm5tcTJv?=
 =?utf-8?B?ODVWNnZNbHlaRFd5QlV3NjNCclZvNjhxSkZEU2JDRWtGY29kS3F6NnJBdVRV?=
 =?utf-8?B?WGpBV3BOTEVvWklXNG9qblVxRkJOaUt3Zm1HaTZYTytYSndTcGhtaS8zSENK?=
 =?utf-8?B?dE9pMTYwaVc4MW1WcGVwRDBNODF5RUt5U3U2Rk1ocG9zRVplcDQrV1hyTXZh?=
 =?utf-8?B?ZXJpRjdZbmo3bXNjQXU0OEZndXBxbWhmT1NOd2FCUStXRDFVU083Nk1RUHBu?=
 =?utf-8?B?eHBFSlBQSmtZSVZmeXYya056MTAvRjN3c3VMQTFKa2gyVUNvbzRkNERxSUdG?=
 =?utf-8?B?U0ZuMnhjbzhQVUhjTjNCc01TeUR0MlEzdzJiQmFJKy91WFpWeFZnQTNIb0dZ?=
 =?utf-8?B?TVFyaW1vSFN4U2laQnpiQ21RaUl2Kzhodnhralh6UUpTUEtLTnYxRDA4TnJX?=
 =?utf-8?B?aHZwK3R4U3NBbEtQV3FyMWZEaTNvR2Q5MzJYOVRoQ0hSaDZndjU3UzVoSzhV?=
 =?utf-8?B?NW9FZDY3bHdNR1VxcW5kQ0FNbXNqVFA5UW8zeXNXdnFib2p2aFJqUFZyMXJM?=
 =?utf-8?B?SkpENHpyWFNYZDVDd3N4U216OE1GTGsrRUQza1dIRzhMbjBzczV3R2I1UW1q?=
 =?utf-8?B?YUJJdmRDVjdESzZwbTlsRFN1QXJCbE9tSXExbDB0dGgwWGVreGZuSFZscVh1?=
 =?utf-8?Q?eP/kTGTMaXI2+340v7SNumcbwFdYtoKS+3lSu6f+tHtw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3RTdk5MazRIWTRneUROM0lhZElvNUp0WnJtaGlLblgvWk5JSWJNREVmS0JJ?=
 =?utf-8?B?S2plMlFtV3Y4U1pzeWdDRFYzYzRnRmw1NGx6U2VRMmdzOFBJRkxhN0IybCtj?=
 =?utf-8?B?S3hwVkhNMm81angzc1RJWDFtSTZ2WC9WNk9xSkVhYzBkTDlienRpV0hqcHcy?=
 =?utf-8?B?OUdYVE1tcHhKa0VmM2EwNVZzVkgwbzNwdVVhbFlKUTJoanJ0Zjh5ZzZDNnh3?=
 =?utf-8?B?NXB1STdZenU5akJQOW1LOHZ3VTVCQnUvdUdhY01Vdkw0YzF5UHBkRmdNWThp?=
 =?utf-8?B?dXZ2c1FXS3phcnY1dVR2c3dqUGViM1E1bld1SmFSeDdpU3l3K01YNUFCK2x3?=
 =?utf-8?B?dnJ5UktrL1IwSEtnNWl6cktEMUFxQk42ajJic3ArelhqWlZrd3l0QkZFQjZv?=
 =?utf-8?B?OTBIcnpWTlptZU5CVW9PdGdNSmc0ZmpsSDE1S3dER0RIWEkrb003aHVSU3NQ?=
 =?utf-8?B?cWhjQkJnd1RBNHdlZE9QY1pJeHR6UHhJeWJmN3ZRTGcrRG9aQ3k0TDB2L0NH?=
 =?utf-8?B?K3pIeWZPOG9lRngzcS9NUUYvNHRIZ0I3VDhyUnBIV0ZodGV1Y1BEUko2ZnhE?=
 =?utf-8?B?OFJvVGxPeFFISnZRNEE2eUxDWHFERkl2aXFkbXVNTlUxN3lCUE1jeUJwck9T?=
 =?utf-8?B?cW0vTEdDSjRQRE5kb1J5ZmpLN0VlRGMwSlRWYXNkcjJjbCtoVnZIbUN1TXIx?=
 =?utf-8?B?V2FLOU5LTnh3WmE3ZlpFMDZnWGQ3T1VWc3N2dXhQQjV2SWkydllqM0FqVERY?=
 =?utf-8?B?Ulg5S1hEeWkvWjNNcU5BdlRucE85R0EzNmxxRXZWTjhwcjQrelFHU2xwMlRq?=
 =?utf-8?B?dlNpaHZWakcvMzJ0ZDl4bE5pZmFqaVI1N3p1aVJVTjh3Qit6S05WN2NWb2Zz?=
 =?utf-8?B?QlpkTm5qcjJKa0RLOHExK2V6UFZBMTJhYXBuMndpT01TQ1V5RUZoWWprWTAv?=
 =?utf-8?B?Q1ZCSkRPVjU1L0dOT3c0cjJ5NXFQYkZYV1RpaS8xOG44NmZzNnpGMEw4K3Jv?=
 =?utf-8?B?MVZjK3k4ZUd4OXRsTHEva0xUY29LYjhPRDBFUlN1VG5rTzJ6Qy9KNDBuN0VW?=
 =?utf-8?B?cm9hckYzVDZES0laL0NGd0NFNnZJM0ZFdDdQOGhrNlhNeGlxZG9lYWc1YlRo?=
 =?utf-8?B?YlovRDE0RjN3WEhEdVh2ZlM4RFVYNTd1elNoSUM0TmhGdTl3dmZBdWxDc3pa?=
 =?utf-8?B?LytqZ3dRTWhMS1hoT09HSU1MczdFUWdKcGZrMnpDQmg0U3Vjdit1NlRwbHVk?=
 =?utf-8?B?aXhMUjFueW5LbjY1ZkhrcWRnQkkvYWNFeHdGUkJwUkxnd1BTSENKd1k5K3Vh?=
 =?utf-8?B?enJDZHZRWWkrN1ZiZUswWEZxQTJNNHFrN1JiWHFrQlFDRXg4MEtheFBLdDJV?=
 =?utf-8?B?QktiTmFwNUdDcHBtNVNGYlh0SUpkQ2h2WkFOWW9oRkpoQzdMY3BZUE9ORFFF?=
 =?utf-8?B?eVhVTVlJUGdPdGVyaDZXL2FNYndzaHc3S1hIbHNuRmdIbFo4VEZod2ppQ0w2?=
 =?utf-8?B?ZVlPeFFBdm0xa204NUVmaHVDbmdjdlVWNVdRMEtCdHhIaDcrbFNlV0IzRFpm?=
 =?utf-8?B?V2FNL21sL3Qzd1hObUxDWDQyZzU1RGZjQnlvQlFLNS9yeGhuOE81cHZEQUJK?=
 =?utf-8?B?WWJRNUFENW1uM2d1bnJxNnhwRnVuc29GcGIycllLdWtRNVFIcDQ0QjgxSSt6?=
 =?utf-8?B?SUMyb3JxaGR0aTBhaTliQVhiUUdUODNybk5EMFdob3A5SUY3NW1tK2gvbUho?=
 =?utf-8?B?ajZDWGFqbnZhQXJtVnFhaDlWbmlVeEt2WFgvTkNuOGwvT1hFeTVxaTFGTG91?=
 =?utf-8?B?TnhZL1NmZncvUmF0Y2pmdEJHbjJpT3NrZVZLZWQ1bDBGUU0yRWtZdjRRM0gz?=
 =?utf-8?B?VnEyRmEzd3JyVzlEMnVLT2FRaFNhWWw4dnpMR09VSnc4eVhrR2p5QzZERGl2?=
 =?utf-8?B?RTV5dFd1QURVb2t5TXRCdDE4K2xMTlE0Q3ZpWm02RUUvcDh4Z0dMWXR6bjF3?=
 =?utf-8?B?b3dVR3dRaWozMVJsQWR2K3JxdlppRm9kSGJGOUN5N1piSEpzTS9UR2ZZUG1G?=
 =?utf-8?B?SjVMRDJ2alEyc25lM2x1dUJhVTN4SStTM0FCaGlxZEppQ0RndzZWU0FwSHVa?=
 =?utf-8?Q?AGnSl8rif5Wy9uydZsxjr/82/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3b0207-190e-4c06-c2be-08dc7e9d6e0e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 22:36:20.2974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uaa/ifJaZCjlIxGBWvYuRW2Thhk+rWj0rGPFSIH7KG356r8ewv3KBZEjAsA0bE3vVDfCGdsRnMc/TqTaDemAHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4955
X-OriginatorOrg: intel.com



On 24/05/2024 2:39 pm, Chao Gao wrote:
> On Fri, May 24, 2024 at 11:11:37AM +1200, Huang, Kai wrote:
>>
>>
>> On 23/05/2024 4:23 pm, Chao Gao wrote:
>>> On Thu, May 23, 2024 at 10:27:53AM +1200, Huang, Kai wrote:
>>>>
>>>>
>>>> On 22/05/2024 2:28 pm, Sean Christopherson wrote:
>>>>> Add an off-by-default module param, enable_virt_at_load, to let userspace
>>>>> force virtualization to be enabled in hardware when KVM is initialized,
>>>>> i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
>>>>> during KVM initialization allows userspace to avoid the additional latency
>>>>> when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
>>>>> framework to do per-CPU enabling, the latency could be non-trivial as the
>>>>> cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
>>>>> be problematic for use case that need to spin up VMs quickly.
>>>>
>>>> How about we defer this until there's a real complain that this isn't
>>>> acceptable?  To me it doesn't sound "latency of creating the first VM"
>>>> matters a lot in the real CSP deployments.
>>>
>>> I suspect kselftest and kvm-unit-tests will be impacted a lot because
>>> hundreds of tests are run serially. And it looks clumsy to reload KVM
>>> module to set enable_virt_at_load to make tests run faster. I think the
>>> test slowdown is a more realistic problem than running an off-tree
>>> hypervisor, so I vote to make enabling virtualization at load time the
>>> default behavior and if we really want to support an off-tree hypervisor,
>>> we can add a new module param to opt in enabling virtualization at runtime.
>>
>> I am not following why off-tree hypervisor is ever related to this.
> 
> Enabling virtualization at runtime was added to support an off-tree hypervisor
> (see the commit below).  

Oh, ok.  I was thinking something else.

>>
>> The problem of enabling virt during module loading by default is it impacts
>> all ARCHs. Given this performance downgrade (if we care) can be resolved by
>> explicitly doing on_each_cpu() below, I am not sure why we want to choose
>> this radical approach.
> 
> IIUC, we plan to set up TDX module at KVM load time; we need to enable virt
> at load time at least for TDX. Definitely, on_each_cpu() can solve the perf
> concern. But a solution which can also satisfy TDX's need is better to me.
> 

Doing on_each_cpu() explicitly can also meet TDX's purpose.  We just 
explicitly enable virtualization during module loading if we are going 
to enable TDX.  For all other cases, the behaivour remains the same, 
unless they want to change when to enable virtualization, e.g., when 
loading module by default.

For always, or by default enabling virtualization during module loading, 
we somehow discussed before:

https://lore.kernel.org/kvm/ZiKoqMk-wZKdiar9@google.com/

My true comment is introducing a module parameter, which is a userspace 
ABI, to just fix some performance downgrade seems overkill when it can 
be mitigated by the kernel.

