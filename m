Return-Path: <kvm+bounces-63841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3809EC74003
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 1881730DA6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5AD337BBC;
	Thu, 20 Nov 2025 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FFeHbgMe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D893532F751;
	Thu, 20 Nov 2025 12:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642286; cv=fail; b=m6c09HgLp/cswvq95MefG9Iph/K/9QIDhALXseUe3DneVMwdVJKYMdelwd+PqFtOLzfJnymk4SpWWm3S7hxFxFzRg5YLbWqO66ltfVbqgX6iI7GsV1Dg25D50rveiQRn7SIT7QZjQrwWfLXaPSzjvr10pEbHvOWktEhaWwMs4tQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642286; c=relaxed/simple;
	bh=r7P0rec1NhIh79hdr7JNM3Rdut3BsAgZFydLhrk3E6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OhOMiYxgh1Bi9IaYbgaopOyQdpNkfGwg/S5otZ0UiqfmrliUd9aePhv43e1Tb+s3disgH6uB9kbXi8CyI5RQBBd7TTL1EmCWWoU33TefCUaMIVZ2DAx0jXtr0vOgFm5bJN0cbASxp+nMznJRnuOIIZd1xXo+Rq2ZzlGhWUSuLs8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FFeHbgMe; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642282; x=1795178282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=r7P0rec1NhIh79hdr7JNM3Rdut3BsAgZFydLhrk3E6s=;
  b=FFeHbgMeH6AcVoyfRgBBneX+IMq+BN7xdeTUZWpkiBu8Ms8Fp6keOIac
   qtAwSnxgP85HN4QpHyOPp+1dAfj1BQHu1l2b1kBKR7Cq2wT2SRJtMWfWM
   Eq9OcMD7GAXdEjxzjsdJfJ3PiV8C5ue/nWbMkdDDtsewBJWi49Et+oOup
   7u00EczuUW/aP/2iozN2GN2YyIgIE9WPz3UbhxSsLeOt0bRoq+IsIMyb/
   I6KNtQwGwWwjuEI5uo/SL3oW56e+pSHZ/go4+SkCZmVEtPVUW75JqZM0E
   CvFCy2KR+C+o/xCmmCPJMULsRyiaoXx61G8zKsEbu38lSAyIj5jS7ernU
   Q==;
X-CSE-ConnectionGUID: zXQpKs4rQ3aPS4TZYy4uJQ==
X-CSE-MsgGUID: hXkjsa6wS+C85R4LbpYjkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69565185"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="69565185"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:36 -0800
X-CSE-ConnectionGUID: B3xwiEVCSc6QYydEjwQBpg==
X-CSE-MsgGUID: qgtMs9FvTmum+4EW9WBWzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="191034278"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:36 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:35 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:35 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WnYUaLvQinQ2IvoW3JfShUFe4fofysnzb1z+KFDIoKsghliKtmef7Rv08X84OUxdsRb8xIWSaYSQlf6918k0Q7DGqM0RBiVsKOMHDhBU1+6Pec5TLw6Svjt9OconYMCNqyZr1nq9UUgHPsJ1D8lcTAPOFDALf9TVQTEY1iUWzOHdj6clsLn9+OhrGO/7QdsJMc5op6s3q1+VEKnviMbOgTljyWEDo4KHAkai+iAoKLFAvOWhaLSHuxkS/niVXeW23rhMHrzMPKfo7TMMqgtRYyI6REteefXVmsfnfPxsv+lbVVG+L1S6JxmmcLTySFloxa7lvoVG2YZ5ktOuCeIPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtOhmoDknTlRNKh1Tx2SKpxJ8ZqsiWa50UfUeFRcPmc=;
 b=QHSlJF+oF4CB4sPoR3H8HY70XRBgEixmMgOK+3WZigkHFQ2wZ9HWaNqIB4EtisyTTQyh4OifGjGZQW6Tp5zvypkOMLMdpM97qHWc7S2hvBcKDEhu/sP0Fl4DjHDYjJg712lQBbJMzLZWSNBZZcxr000GiKmPQBVNsULBmcfOqbj2uMd973SpMqZM5Klp437AP1P0Rm3QscXggja/NPGkq6XXQDbTamoYAPYtuOuLDvqPCUXvgpSQKXoZQT0Kp2+T4I7sHq+x/G6GZFGuJDmrW9w0e2guD7pG/ctxGo/K4aQMIKrapSpD23yE9qTAKVUc+mTWdvTmy9nXEn4xaQMQ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH7PR11MB6031.namprd11.prod.outlook.com (2603:10b6:510:1d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:32 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:31 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 6/6] vfio/virtio: Use .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:47 +0100
Message-ID: <20251120123647.3522082-7-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::14) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH7PR11MB6031:EE_
X-MS-Office365-Filtering-Correlation-Id: b59cb772-de5b-4b05-57a2-08de28319274
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UlQrQVdOd0tnNXhyMHJEcXdsQXp6WFpLeWtnTmNKUWdNc09aeHptc0p5bEdU?=
 =?utf-8?B?dlhHQU5rTEd0eFpxdWd6S3p1RVV2REZGZHRENkxYbzhkdlVwZHdIMm03cnFU?=
 =?utf-8?B?aFdMU3VnTjRrRXdiaEwyOUgybU5lczhvMkZOb1I1d2F4ejNrKzAxRnhPRzB4?=
 =?utf-8?B?SWJIWEM1eEptaU43ZzFZRHcwMTcrV3VackJnMGZUb0h5ZG5jS1VTYmhKSUdX?=
 =?utf-8?B?U2ljby9sWDdiT0tFcGI5cFlSQiszUnREcDRib2JFN0gzWUhjSkI3UThVTUdk?=
 =?utf-8?B?UlJUb05sbUpMc3dvakN0ZDhUd0trSDBEVW5LT2VUSTJ2b3llbkpOTTcveGFK?=
 =?utf-8?B?TmV0Vm5id01CK21IUFZwZ3pVR0lwZHN2Wndha0hzUnVaL2ZnUWVMR09wY3ll?=
 =?utf-8?B?REllUjJKai9kc2lHRkVMT1NBZnYydFdpM0E5TitIN3lHbVlaQWdycjhJTFhE?=
 =?utf-8?B?ZnJPUFE0T3FnK3pyY2VJNE9KOGlJbGh6bGJ2cjBlTEw2YTM0SUMxVWFVRU9U?=
 =?utf-8?B?RFFXUGVudGNDOFZRSlNaN2w0a05TcG1sV25PY3lXUCtzMHk3QjQ1RmsrVkMx?=
 =?utf-8?B?cXRsT0dzSzVqck54RWJZaXMrbGY5SVdsa2ZMOUF0cnlkb1NCdEZtRlVvaXhK?=
 =?utf-8?B?YWE5Njg2dTVCQjRSSUY3UzJoQkE1MENjZXk3M1VHc1RHRHAyeWFYSFlsUzdz?=
 =?utf-8?B?dEpaU2l3K3J6Q1hCZDVjRDFaWG51V1prM0hqYTN5TVFZS0FTbXNjZTRwdEFo?=
 =?utf-8?B?YXhTRm02NnFxcEgwOEpMOENST0NKT0VOQ1hHc3RtYXdrbVBMSkNQMXdxb2N0?=
 =?utf-8?B?QllrYjZnRnV1amlpa1pxdnl2RUdVZnhONERNK08wV0lMZ0RHRUs5QkJmVGpR?=
 =?utf-8?B?YUpuNTc2Mmc4S1pXUGdPZ1FydEdJWmxsZkg1T3BPdFdvTGROcVkwaG9nUEtp?=
 =?utf-8?B?a09tWTZFQTVITEswdHBBb2Z2enFaTFFKcjlNOVlZcGNhcEgrdnZBdTZFVE5K?=
 =?utf-8?B?ODM0dCs5azNzcE5NTXhtbEJWOXJrdGhGZnIwU3crUmpaZ2dreW5lZ0toeTNH?=
 =?utf-8?B?NGc5Z1Z4SUlralBFU0hKSVZ6SGhicmpncnVoQU5pUERieTk4Z2krYjJKai85?=
 =?utf-8?B?VWJEdGp1djMvQlBGNUIySkRrb1ExK1lESG40a3FPTmRBSSs2cEd6bVBQRFFo?=
 =?utf-8?B?elRkcWdCSDRHSDRNdnlwZEthblpOUll4WkJDSjV4T1dUdld4S0pCTm9iRFVL?=
 =?utf-8?B?QXFRUDQ0QUY3ajRhbGJRa3FaUVVyNWZjdFdxTUZFOFVOd201M0RjeUVTaUxh?=
 =?utf-8?B?VXpsZy9UQktDdnZUR0Qxd0pLakg2aW1mUkU1a1FFOEdKVmFsbnJhazYxaXpi?=
 =?utf-8?B?ODFuamdkWFhRUWg1WTU2MWl3QzNYYW9JK0c0aVBXQ3U2OXBRNCtEeXJadkRt?=
 =?utf-8?B?MngxWHp0bmRYd1Q4S0xWWldSekNTTHh0Z0pkTTFtT2tTbkZOOHF2dkt1ekdH?=
 =?utf-8?B?SG5HZmZpRDNrbks4cFB6eHJ4MEg2d0M0ZXJkQ0xYa1BxUWhJeTVQUCtTUm9k?=
 =?utf-8?B?OS9VeUFIaTk3OWhLYjdPQlhPU21GMlhUTFd2QS81NWhDSUl5alBYaVc1QnBj?=
 =?utf-8?B?K0VrVXVxY1pMN3ArRkZES25ySURCbkF4L0VSR3oxcHhWd0xNWVRWNDlSZDdh?=
 =?utf-8?B?dkRBNktQSHVPZHJ4bFJ2MGNIeDJEbDBEQm5qdHpkek1DeEpveGdnQ3pjWGwx?=
 =?utf-8?B?eWtraTQ3ZFkzSG1CdGljUlIvMUpPUGp2TCtSaGdFeGpLSU5zUy9jcjNTRkVQ?=
 =?utf-8?B?UnlyaWhaM2h5S0MwVW5GV0RKcGtMeU10Y25SMW5WUWZsdWhtQmVmeTBibFBV?=
 =?utf-8?B?ckxGVTRnUS9RaGQrWkJKNTYrOFVsa1RBbEJxNzV5anV4RVZxL040RThwNDkv?=
 =?utf-8?B?bDNkLzY5MHJ4MVZsN1FkZU9NZTJoUWxwWWJIWEF6T3ViTWNJNktBaTdpQjJ5?=
 =?utf-8?B?bC9kQmFzejVuZ2xQZ2JUREJoM2p3aks4WDVLc3FvNHNTSFdySUVIV2FCclgv?=
 =?utf-8?Q?o5A46K?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW1aOVlTRFl2cFdDRG1qdnNwOUFTQVRBTmVMZTVQaTZsZ0l1a01JMmZlT1VH?=
 =?utf-8?B?cmtpM3FBd3pyVlNvQ1dXM3JaWXZjWTlUMVI4NzNwalRtK2w5WlJSVS9jZ2Zs?=
 =?utf-8?B?dVZUZVZoUmNHOGUrYldBWjVSV3NMU2p5UzBJcXUyTXVscnFtRXNXeHovS0d3?=
 =?utf-8?B?NTlJRUV6dmNFZXRTdWE5Sm51cHFqZUpUQ0d3QkxhUk80UUFTd2U2enpIaFdz?=
 =?utf-8?B?NUQzSXgrUmpjbmNINHJ1NHNSMWhxd1hMRE41Y1VyUENiWXdDakdwM2Q2VWgx?=
 =?utf-8?B?TTM1VmRCRzIwY0NuakdwMjh6U2dOZXZIZFRjaDUyME42QWlQRGJsK1hlZWEr?=
 =?utf-8?B?dTh3QlBpT2kyT3JHc3VFWmlRQ0tMNThKMncySE1yYlRzZnhNTmllWHV4MEJr?=
 =?utf-8?B?ZmdXTFlNQ1g5aDA5U01ZNDhCdmJZK1NTVGRZQUQ5dnRvaE0xc1FXVTk0UUVj?=
 =?utf-8?B?Z1NiYnRFbmNQL2hHUWc2QVFPWUpSbEJGeDJoNWpOK3RCT2xBR3FCRGJPV1dN?=
 =?utf-8?B?K3ZsTXFEMGFWOXMzckluOEMrV3V0WFEvUVNDNktOK09CSnhPMjlFZmhFWG95?=
 =?utf-8?B?Q2l6cXo0UGFqdFpqOFB4MDgzZzlna1FheDVJb2ZMR1RyQXAwRVZqYmRma2J6?=
 =?utf-8?B?WG51L1BIMXByakJZZDJvd3lMQVgvVGRhTXN4UGpXd25PTEpEaUlHUUZWTEI1?=
 =?utf-8?B?dWM4Wm5EZ3ZBdE45ekZPbXVBWmgyKzkwRGpIcGRqNFVEbjVPTS90djVIQ3ZO?=
 =?utf-8?B?V0pFc2xvSWxsaFJyMWdBdHl6QlR4TzBqN2dGSE85cVZZb1lPUmswa2lUWjl5?=
 =?utf-8?B?aWFIdjRVbVI4c200Mmp1cE9iNys1ZDRLL01iQjc1WlMrUWZwR1ZOcGRjczhi?=
 =?utf-8?B?cjdXK1NhUzhLN3JtV1hVaUVVU3NrSE1qd1JSampVdFVCMWVnenh4ZVRxZERG?=
 =?utf-8?B?dm8vbmdZOCtMUldtS21EbzZKM3R3ZTJnTUtSZ2RtNkw4TEtscWVJNEZxK2J0?=
 =?utf-8?B?aHNMVzh0a1h2R0hOR2F6TkxuRWFkZW44U2p0NFVjMlgxdlUrbzl3UHNtQjlO?=
 =?utf-8?B?TkdaeUhXQjgzNnFwS0Q2Mkg2VDc3ZXhSQ09HdXJUbzNOZ1MzUGxRNC82ZGFa?=
 =?utf-8?B?YTU0V2N2S2xHcktKdkhGYk9OUkpLMm94dTh0a05yZDNCNXNWbHZwdkxEOVhy?=
 =?utf-8?B?T0Q2a1Q1ZEd3MTdlSkd5cWZjZVBDcVJNQXlobGZ0UnRST055dEM0RytWaWJE?=
 =?utf-8?B?LzV3VmlJUlhLZGtlSGNrNDljekYxNGlkRDdQUzFDUnVwNkdJaVZiejNLSkJJ?=
 =?utf-8?B?YjRBMmlFYTNaNnFvL1pwWUR3dEtuUk9kT01oRURTRFFUckp0ckZmcXgxVVBF?=
 =?utf-8?B?Qjk2OWp3TUd0SUV6NzVSVVVVODl6N0ZqZ2t3UUdUOGk4QVhZa3FoMjNjTnkx?=
 =?utf-8?B?THN5YmRFUlJ6SXFvRFhqUUpiRDlieGpuSlRMSXYxVXV1SjBBWlU4bnk1ZDVw?=
 =?utf-8?B?eWQzN2FOTnNLTWNnNzVlSkpQeVR6MjRtUWs4ODdtTitKOVgva0tva1FXcUxG?=
 =?utf-8?B?TG5paTNFcjNMY2ZDNW9JR3hmaHNITnNodkRBbnczc0dNYThJUlZZaFlSeGNr?=
 =?utf-8?B?b0RSam9YdzNQZjc4ZVVYR3RVbHpFZnNLMG54aTdMaXJwSXI5cXBJcTFwdTJO?=
 =?utf-8?B?SUdBMTQ4dHlZcllwODIyMGZiaHNqOWpqOEwyblVXS3JFejBDL05sZlcyam5o?=
 =?utf-8?B?UGpjcGlFNktUQlp3cmI0eEVLVkpBT3hRZitFZFhRVngxK3VmYzZrZW9rRStY?=
 =?utf-8?B?NFNiU1NpL2lXRWdPbzFUbXVKZ1JuaWp1TkpNRzNobzhvSWJHYStSSUNSM0xR?=
 =?utf-8?B?ZmRJRU5wUnpMeHhNVFcvR0JqMGpxL1JYckk2NkNqY2wwcUFUOHI5OHd2U3I2?=
 =?utf-8?B?WUtmcjRLclNRVGFsVG5tKzNUeGhoTStzcWlzdVRQZkFQczkzaHVhRGxrcU9E?=
 =?utf-8?B?TFNWdUpzcGtQc05BNDY3MEZGWnExcnNvVEk4dWovYjNVVG5CbzlPbjNMYXE1?=
 =?utf-8?B?Wm1BQ0hqVXBzNk1lWlcvY1JUbDYvWFZpNFFsbmNxVzJJOTluRDhiZGNEbUhC?=
 =?utf-8?B?UlVvNEtibkRuS0hTc0RyUFhMZWFCenBZQ0FxN05maEZweEJUS2xOd2N5L0d1?=
 =?utf-8?B?NFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b59cb772-de5b-4b05-57a2-08de28319274
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:31.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTc2wzHZYvPsOVujQTbQFX0BzgBrCE/mEStKHCqAV9EOv2Di3KW+bBf/toO11JYYVbDNMuKayFEB1a6dJ0lvatbwEHr9RynLWOSUjs8d2E4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6031
X-OriginatorOrg: intel.com

Move the migration device state reset code from .reset_done() to
dedicated callback.
Remove the deferred reset mechanism, as it's no longer needed.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/virtio/common.h  |  3 --
 drivers/vfio/pci/virtio/main.c    |  1 -
 drivers/vfio/pci/virtio/migrate.c | 71 +++++++++----------------------
 3 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
index c7d7e27af386e..cb27d3d2d3bb9 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -92,12 +92,9 @@ struct virtiovf_pci_core_device {
 
 	/* LM related */
 	u8 migrate_cap:1;
-	u8 deferred_reset:1;
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
-	/* protect the reset_done flow */
-	spinlock_t reset_lock;
 	struct virtiovf_migration_file *resuming_migf;
 	struct virtiovf_migration_file *saving_migf;
 };
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index 8084f3e36a9f7..b80cb740f9a5d 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -203,7 +203,6 @@ static void virtiovf_pci_aer_reset_done(struct pci_dev *pdev)
 #ifdef CONFIG_VIRTIO_VFIO_PCI_ADMIN_LEGACY
 	virtiovf_legacy_io_reset_done(pdev);
 #endif
-	virtiovf_migration_reset_done(pdev);
 }
 
 static const struct pci_error_handlers virtiovf_err_handlers = {
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index 7dd0ac866461d..5c7f9091d84e8 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -247,49 +247,6 @@ static void virtiovf_disable_fds(struct virtiovf_pci_core_device *virtvdev)
 	}
 }
 
-/*
- * This function is called in all state_mutex unlock cases to
- * handle a 'deferred_reset' if exists.
- */
-static void virtiovf_state_mutex_unlock(struct virtiovf_pci_core_device *virtvdev)
-{
-again:
-	spin_lock(&virtvdev->reset_lock);
-	if (virtvdev->deferred_reset) {
-		virtvdev->deferred_reset = false;
-		spin_unlock(&virtvdev->reset_lock);
-		virtvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-		virtiovf_disable_fds(virtvdev);
-		goto again;
-	}
-	mutex_unlock(&virtvdev->state_mutex);
-	spin_unlock(&virtvdev->reset_lock);
-}
-
-void virtiovf_migration_reset_done(struct pci_dev *pdev)
-{
-	struct virtiovf_pci_core_device *virtvdev = dev_get_drvdata(&pdev->dev);
-
-	if (!virtvdev->migrate_cap)
-		return;
-
-	/*
-	 * As the higher VFIO layers are holding locks across reset and using
-	 * those same locks with the mm_lock we need to prevent ABBA deadlock
-	 * with the state_mutex and mm_lock.
-	 * In case the state_mutex was taken already we defer the cleanup work
-	 * to the unlock flow of the other running context.
-	 */
-	spin_lock(&virtvdev->reset_lock);
-	virtvdev->deferred_reset = true;
-	if (!mutex_trylock(&virtvdev->state_mutex)) {
-		spin_unlock(&virtvdev->reset_lock);
-		return;
-	}
-	spin_unlock(&virtvdev->reset_lock);
-	virtiovf_state_mutex_unlock(virtvdev);
-}
-
 static int virtiovf_release_file(struct inode *inode, struct file *filp)
 {
 	struct virtiovf_migration_file *migf = filp->private_data;
@@ -513,7 +470,7 @@ static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
 		goto err_state_unlock;
 
 done:
-	virtiovf_state_mutex_unlock(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
 	if (copy_to_user((void __user *)arg, &info, minsz))
 		return -EFAULT;
 	return 0;
@@ -521,7 +478,7 @@ static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
 err_migf_unlock:
 	mutex_unlock(&migf->lock);
 err_state_unlock:
-	virtiovf_state_mutex_unlock(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
 	return ret;
 }
 
@@ -1048,7 +1005,7 @@ static ssize_t virtiovf_resume_write(struct file *filp, const char __user *buf,
 	if (ret)
 		migf->state = VIRTIOVF_MIGF_STATE_ERROR;
 	mutex_unlock(&migf->lock);
-	virtiovf_state_mutex_unlock(migf->virtvdev);
+	mutex_unlock(&migf->virtvdev->state_mutex);
 	return ret ? ret : done;
 }
 
@@ -1245,7 +1202,7 @@ virtiovf_pci_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	virtiovf_state_mutex_unlock(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
 	return res;
 }
 
@@ -1257,10 +1214,24 @@ static int virtiovf_pci_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&virtvdev->state_mutex);
 	*curr_state = virtvdev->mig_state;
-	virtiovf_state_mutex_unlock(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
 	return 0;
 }
 
+static void virtiovf_pci_reset_device_state(struct vfio_device *vdev)
+{
+	struct virtiovf_pci_core_device *virtvdev = container_of(
+		vdev, struct virtiovf_pci_core_device, core_device.vdev);
+
+	if (!virtvdev->migrate_cap)
+		return;
+
+	mutex_lock(&virtvdev->state_mutex);
+	virtvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	virtiovf_disable_fds(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
+}
+
 static int virtiovf_pci_get_data_size(struct vfio_device *vdev,
 				      unsigned long *stop_copy_length)
 {
@@ -1297,13 +1268,14 @@ static int virtiovf_pci_get_data_size(struct vfio_device *vdev,
 	if (!obj_id_exists)
 		virtiovf_pci_free_obj_id(virtvdev, obj_id);
 end:
-	virtiovf_state_mutex_unlock(virtvdev);
+	mutex_unlock(&virtvdev->state_mutex);
 	return ret;
 }
 
 static const struct vfio_migration_ops virtvdev_pci_mig_ops = {
 	.migration_set_state = virtiovf_pci_set_device_state,
 	.migration_get_state = virtiovf_pci_get_device_state,
+	.migration_reset_state = virtiovf_pci_reset_device_state,
 	.migration_get_data_size = virtiovf_pci_get_data_size,
 };
 
@@ -1311,7 +1283,6 @@ void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
 {
 	virtvdev->migrate_cap = 1;
 	mutex_init(&virtvdev->state_mutex);
-	spin_lock_init(&virtvdev->reset_lock);
 	virtvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
 		VFIO_MIGRATION_P2P |
-- 
2.51.2


