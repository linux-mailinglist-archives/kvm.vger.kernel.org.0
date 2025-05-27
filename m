Return-Path: <kvm+bounces-47735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2143AAC45D4
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 03:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB9D9179FFC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 01:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A342E78F20;
	Tue, 27 May 2025 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXYsLai2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4443209
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748308569; cv=fail; b=V9U150RYboLRO8OCXXxLVJmA0k+NOTDbz4xscrvJ+LgpQfMlzLYzRRykKQBifBqWMQERxIa3f25Md45rSiZ7XF/DN0LE1NIkcl//jH9fswh1zxP9MizTPy3UkmFYTP+17NKHlPSh7IoMUfXg9PXMPdDpZWx1kVBSHzvWOKIK9kw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748308569; c=relaxed/simple;
	bh=ERFd5FdvlUd8fxhi9MkDmyfVb+bB76hVmNrXNx4KxS4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j9woAaoBRh25sPEg1Hqbsa5e0iCHpUAi3+8mCNYq4TRTZtZZ0EeBTWuSJ5x16oFkM1Q3/p99IO1CpFs1acXvpqSaT79sy3zcYNBh2bP5UotOpvlktTyZbsEoaU3UmRdUEH9xOeNmJliqGcMUmTe7o40OMcqadmVVNEmGl2jD2bA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXYsLai2; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748308568; x=1779844568;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ERFd5FdvlUd8fxhi9MkDmyfVb+bB76hVmNrXNx4KxS4=;
  b=HXYsLai2WmLTmYnt6iTxBeKEV+d189eZSM06G2i1Xvfld3SEXoCoWqAO
   WECLjufwD1LfTEwT/9YwkttXb3GQjIm7eQZZZVmTgMrlxOvOoYs6WlyoG
   cTN1EaAZDzj6CaOBZtUEzfbNsSNt/rWgMbCTIaqFzNueofcHzR4cglUx2
   GI1kCWYIMp7LgWN4zjOcE/nXh5c7da0gcHK7/4Xi+2gGaDJLqxHNwfEW1
   VMJfLyiajgYd4kL1H6/EuznMT08hpqadeEHknHpEwNYFRZzpLBJyDi+5i
   PrAhMyEmk9KPFlO1RZaDgRpDbrSzBIuVuZRPyxdwZjZPnjntW6CIMDvLN
   Q==;
X-CSE-ConnectionGUID: 0sZXct4BTPCzwUtFjdsbdQ==
X-CSE-MsgGUID: A3X5zol4SQqPvJGsCiwKFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="49982193"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="49982193"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:16:07 -0700
X-CSE-ConnectionGUID: Nq6BiumAT1aWiEr5IWGjEw==
X-CSE-MsgGUID: hcNIxXa4S8uYvoW4PrjruQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="179762437"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 18:16:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 18:16:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 18:16:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.77)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 18:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADDH3lpdcqqgxvJ+w1nGG/qkD0Eziv5ZFHZrAYJiede1KrUObIoKwq/mY5+gnse2xVFPtZ5LmkJcMRZuQr3rj3SwWsiuEHupKQL65vQeC9wmS/WMnb+JKoVXq8ckPcdvlEEKs+5IR7TFZ7zV+a31D+6bJpKOAuOi2n1uj3M/Qe4KbVBToclzOLkOsOAPQkjbTKhZ+Z5enVwZmbQfR5Qztbgrp8pq4TPniUb/N/WokyhLmZjHaFWMtVY0VvAJ/LyXj1+Nq77NzfbxWL9BLnPxyBtUlOlMccF7UH2WFbnBEAcD5XDfwfHio3aVDnM9NniJqSXfgODRwl1e0iwPPos6NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IiM9OzeLZoaYAB+Optz3yFLeO/GeFVraHnMbHkekJYg=;
 b=mHRpcELwfAuAbWH7fjrI4EbthBi8ZbNvhGGw8A0VtcoRXyscaLup3nqc08fdkrLxoSrIIMReHUXGyr1bwwLYvdvg+vdhG87DM7JIRcGA6Cju65IRz5cJ51Im3YSIKiQy8b/QNNTlRSkZzye9J+eDpt81pK2nCoDgheo5hXRlbQEVu9A/j/eObMCPx5EPQ/PQ60z1LE9hI/HiXFYuXsyuI0yVSH3uY9bjJmrpos62tPybWq4ZRfzAsIi7N1v4jvn7UdzMUZHsHaxZvnwUOjvp9mZbnU+4MhlLxMcVS/E8zDXS3PYCxxDLoq4x64fjf7+atAY2W0XhVgPZF7sJSTS7Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 SJ2PR11MB7575.namprd11.prod.outlook.com (2603:10b6:a03:4ce::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 01:15:21 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 01:15:21 +0000
Message-ID: <6ebda777-f106-48fd-ac84-b8050a4b269f@intel.com>
Date: Tue, 27 May 2025 09:15:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBlock with guest_memfd
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-5-chenyi.qiang@intel.com>
 <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
 <0bc65b4f-f28c-4198-8693-1810c9d11c9b@intel.com>
 <f28a7a55-be6e-409f-bc06-b9a9b4b3a878@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <f28a7a55-be6e-409f-bc06-b9a9b4b3a878@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::18)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|SJ2PR11MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: 766a72ea-739b-4219-21c0-08dd9cbbf305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkd4QXVoN2t3ckpDVkRESmxMRzZaeXdpaHdOMVB2dENRT29lbzVlUmRLeGtx?=
 =?utf-8?B?cmZCQkdYcHNCTmtHNHZGTFF3WW0yaE5CL0cyTjBDRitaRmtLeDBjTHN1cGN4?=
 =?utf-8?B?RnQvTnFBMEdiU2RDNlJPaDNsRzFmTE1VWWZ1VnhIZ01abGF5Tm9CLzAySDZL?=
 =?utf-8?B?c1JzVkM2eDdkbGVNbERERVh3bXRZMExHM2dMcjE2YlJWVUVyRFo0YXZOZWZG?=
 =?utf-8?B?TEFmcWFmWGdKc2FMWHgvTWJnSE4wQXRVYS8wdjh4TTNXaFVld0hFek9pVmZZ?=
 =?utf-8?B?ZmRneGJRWG51M21IWVFwOFhKcWlWSE9tUW9YZGhpejZLTEZhcUVELy9UT25h?=
 =?utf-8?B?ZDhFd2xCN0dDbmY3UjRwMXdJTGFjWlQrUmgrQXA2bWdYS2JQcDVPVzd2M0hm?=
 =?utf-8?B?b2ttK1hVUGEvN1pjMlYvRjFmd0daOStNeiswdFYwLzR2TStxbXVhemRuMG5u?=
 =?utf-8?B?S1pOVkVwaG1MdHJXYUE0bnFmSWRvak5Rcm9ZVE9ZeUd6Y0JqQy9yRzVKRGlW?=
 =?utf-8?B?Vy8xbTJTTzBDcy9lS1lWeWMwdUpJU1lXTldGZ2hVdkpYekd3cHMrYS9QYUUz?=
 =?utf-8?B?NkRFTWE5R3dWQ3BkWU9oSlZ3cXd0b0NEcEN0Q2ttVU5FazFEU01CaGJ6QWdk?=
 =?utf-8?B?bkhONTRoVktkTTdmTGZFMnl2OUlDYWt1OTJCemJpaWwvL29NZFZuWUp2UUZ3?=
 =?utf-8?B?clJTanU0NXFLUTBUVVVHbzJER1g3VE83ZkJaWnk5ZzdOcjNTTHNrS3pJMU93?=
 =?utf-8?B?M0Y1dGZMYzJKRXZJelFuR3J5ak1PTGl4NlVOQ3daYmMwcmhlaDBpNnZCcmZX?=
 =?utf-8?B?N0xIaEI2MlVRNFRWanhVelZ2SnlsZGkvVXdVb0tqL2pIZmxkNVBkcklNVFJm?=
 =?utf-8?B?S0JRMHdqZWQ2ZENlalhYN0RkQXVKUjdXYWRXNHhwanVkZzV3QVhsaVZWSHVo?=
 =?utf-8?B?TkhpbytpSjFwZHQvamZ3RWIxdCszTmZRTmk4dFgwSkVJbXQ2VFRWSGEyc2ZF?=
 =?utf-8?B?VTVRMVRaZEt3OFp3ZVNOdWJ1emhEQkVlNHo0RENSSkF1RFFKUnc3SDJicnJa?=
 =?utf-8?B?RzhxZFZid1M3bEkzWmdwK2JUMjh0TUNoYXhxSElSVExyOEtIMklmOGZLR3ZO?=
 =?utf-8?B?ZVNURmV2eFhaRGNkSWhhR0FHcHhRTVBhZFRGaFVMSWZCRkdONWRiQXp2eDJl?=
 =?utf-8?B?VkJ5enU5S3FqNzRuTml0Z1FPOG56MnM2dFMwN3p5c2R2NnBiaEJoR21uL0tu?=
 =?utf-8?B?b0pYeTZkeGJlM01BaDFWbTMrdXRWZkIzRnIwZ2F0cHQ2elQySER3dWhON0Zi?=
 =?utf-8?B?TTBXdWZwZW1rb2orVXBvLzMwcS95ZTFXOU05a3p0cUszcm1US0kzMmZJUnZD?=
 =?utf-8?B?Q204VFFjbDR3NDNIVmxKUU0yWERjazEwcG5icVBYb1pLQjJGb0NYb2NoNjVs?=
 =?utf-8?B?eDhTL2ZnVytJczFPVVJNTTgwTW85U2RGQ3p5aEtJRk90SVF4VFpBQVA3THg5?=
 =?utf-8?B?YW1DdWJ3WnJKQTVFR3JPbldhd25LMVZieEVxRVh2c2s5bmVjR1RlVi9neXFk?=
 =?utf-8?B?Q05uaVE0ZjUrZ0IycjFpcXZyeWxmLzdBZDkrRFlyWkE5ZkJNaTc0dVBSOUdF?=
 =?utf-8?B?Qm9XMFJjU1pMVkVqS1lPUEkrWDA4dFVXWGV0UFE4L1R0T0NVNDFiUzR2aldJ?=
 =?utf-8?B?Y0FkaVhQbjhSb29idEpMTkM0eU5lc3F4Skh3WlJvb3dORW5tMXBHdWc1aU4y?=
 =?utf-8?B?aWxCYW9CU29VaUVHNEhOcElJemV4Z2d6Q21FdTcxL1N3d1Y3OTlWU3VTUVhi?=
 =?utf-8?B?alMyaUNRRGFOS3hSTy8wNkhtL1hzT201ekRrQTl6Vlp4VFNjQ3UzNUdrZkYx?=
 =?utf-8?B?djFKYURQaW1IY1NaSzR5R244Umk2Zy9zWmdBK1BSVFFOVDJtYXNaVU1XZi9H?=
 =?utf-8?Q?YQz5XsALKQE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVZFZUp6QURCaytsUlI4M1BUL1NjVUJ3K0R3OVRaOXhUSjc2cVF4M0UrY3By?=
 =?utf-8?B?MlRGUDh3em80QXNKRkFrNlhhZVhCV1hIbWg2Z3paeE9kK1BhZjZiNTYvbE16?=
 =?utf-8?B?MmVCSksxcEJpUEJPTXJJcGRJUlVIUmx3bk1ZeGFRTmtMYU81RkVVODBVbmt4?=
 =?utf-8?B?VE9NaC9kRTVZb1NpRkY5Uit4TlkxYnVCVHlNSU8vMmt0azVUUnd6UXl5WElN?=
 =?utf-8?B?VHJoYlkrU0JSNGVxa1NhUU5FT3dVK1NUbThlcE41WXhiUUdlZFcxRVFVWnhq?=
 =?utf-8?B?V3NqMEE1STBocUcwbnhrV1d2UW4wYnZITDlxSVdJam5BMjhYL0hFRHE4Nk1y?=
 =?utf-8?B?ZVBsTXZFREp1MGNFcEdmbG9ZSHlqc0NJSFhxVnFYbEFSSUVEL2h2YjU2MWRD?=
 =?utf-8?B?RVNzTnIya1NYUEttdVEvZ3gwU0o5aHdwRE5SZkZaYVY2QXh4YVV4dS9nVlk0?=
 =?utf-8?B?dmpSdU5xaHBPTUMrUW1qQ1FIcVhhOTl0MEROUktaUm9zM2xRSWtUQjZNbDFS?=
 =?utf-8?B?dU1pLzdPdTg2U1JTYTlmdkZ3aW5YMUNtUVhiamZXNS9TVGc5dmRyMEpDVEFI?=
 =?utf-8?B?MEFRTzEzRnFCMGJ4V1BGWkVpYjM4eG1FYmRFOS92cEdzYjVXTG1NeXZWZjIz?=
 =?utf-8?B?T04xeTdJTnNrNGRlR1JyOGt2MkxiMXMzZ3JTRjBlNy9iVUFmeHhDTUs4TDY4?=
 =?utf-8?B?MWNqU2h4anNIMUxVbzFBTEtmbVZyZ25MRERtVHp2VUw2V21pMzFGWi8waUtG?=
 =?utf-8?B?M0hZVndxVm5UMi9BQUxOcXUrcnNtQldQL0FGK2tRQTZtUWFDS0NleUVsejRq?=
 =?utf-8?B?Y1YrcU5sa0cwbWdIdHkwMjU4VmFkTG14aFNTT2puWUxjTGFENVBhcEgwUCsy?=
 =?utf-8?B?K29QYlBPWXJ0aGl1Qm5iMDEyM1hGZ2RGT1RwQjZpbkNiTDZmNEJUelZqVFJv?=
 =?utf-8?B?T0I4VXJCQ1ZPOHhBanBiaUtKeVJIL1AvUVUyengvbTk4VHIrRVVJakZKWjhu?=
 =?utf-8?B?ZC8yQ0dUb2RtOWVKNFliYzA0ZVRRWFJvSnVYeVB5cmlHNlNscjRoa3NjT1F0?=
 =?utf-8?B?a0lzK2w1Mks0RGljQmNJMS9jUHpOb21hQ1pWNkdyVkY1Wko5NG9tbDd4Q1Zz?=
 =?utf-8?B?S3R4MVZ1QnBsUlRoR1J4VkM3NXNKemgvN1BLVDM5eU9ZVXF1bHlpdUdTdmk5?=
 =?utf-8?B?TFNGRmRxa3ZKK1hkTmY4dWFiL0s3enJCM1g1VHdIT0FtRjIwUkxBdmZLVkxZ?=
 =?utf-8?B?MGFOZTNhbk9Gamg4ZENYNi9HWDFwN1RIajFaVDFFNXNGN25zaEZCMTQyNUVY?=
 =?utf-8?B?OWVueHd2R3NSVkIrUXVORkZrWXRZYXhNSVZicjVSZW1SQXVLNzNBNE95cUcw?=
 =?utf-8?B?U1VjbXpYMnRXZFNPVXoySnU4cng2ZCsyYnZ1ak9wR1IvYWd3KzdQZk1RTHJP?=
 =?utf-8?B?TzJmU1UzV2FJSGZaZ0xqTHRIeXkzdWlEUUlBZEZ3ck84alVsR3NVUElWWlhQ?=
 =?utf-8?B?OFdISVVpK0FsbXZMbEdSQnNTTVVjcVZ4ak5lRnR4SlB4QnBjMTAzN3pvZHdC?=
 =?utf-8?B?TkpPVXZYSk1Pd1VpbnNoSVo3aU4vOEJpd2ZrK1BYaVU2eHVqNW5DNGw1dllK?=
 =?utf-8?B?eHRHaHpmOGgxNHZVTDJlZWpzUCtiSzJqbHRkVEhKM1hoR1poaVlpMnlvR2ow?=
 =?utf-8?B?ellzT3hTSG84amRabkdzcUJvaFlsa3E4NVIzWW9GeG5lZm4wTGcwOG8xenlO?=
 =?utf-8?B?enFScUw4bW5rcXhjV1lCT2hzT1R2cVpYOUVFYVR5cFBINXduVUlPdkp3ajRD?=
 =?utf-8?B?b2V2L2NLMnFGbkpYTmg4KzJGaEFBOW1pRDNGdGJ1aXMyTk5zckJ5clh4NmRa?=
 =?utf-8?B?NWhsNU0ycEVPcVZ3WTF6UzNUMi81RWFPNWtYOFJSRWI1YzRmaml2ME91WHIv?=
 =?utf-8?B?ZExJTXk3bnZWSWZ1MlBUSC9NSlg1bVJJV0JGcTBzRitKZGhJeTg1NWpGZVRE?=
 =?utf-8?B?UDBCVlhFL25BSmRNSm9BaDZhRUhheWFDSU1NMXZsTEhiYUw3M0pXdXpoU2l5?=
 =?utf-8?B?aVV2a3lyQzBoWG5EcmV6TStjeEQzcGVlbHc5UFN0RnNvenpaY3lrSk91TVFw?=
 =?utf-8?B?OUtoMDVtbEtLQkRQNmN0MWpOb1UvUk1UN3BMMFZuWmRnTTZ3K3dLandQdmcw?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 766a72ea-739b-4219-21c0-08dd9cbbf305
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 01:15:21.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLFcs+xzbqSHWQq7YR9DyfR0WnccXtjuLWlrvLJMNUQfj1xhPCByHXoT5gXsSbA3cUkZHaq83C+cBjeFLDPm8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7575
X-OriginatorOrg: intel.com



On 5/26/2025 7:16 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 26/5/25 19:28, Chenyi Qiang wrote:
>>
>>
>> On 5/26/2025 5:01 PM, David Hildenbrand wrote:
>>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>>> discard. However, guest_memfd relies on discard operations for page
>>>> conversion between private and shared memory, potentially leading to
>>>> stale IOMMU mapping issue when assigning hardware devices to
>>>> confidential VMs via shared memory. To address this and allow shared
>>>> device assignement, it is crucial to ensure VFIO system refresh its
>>>> IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>>> adjust VFIO mappings in relation to VM page assignment. Effectively
>>>> page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other. Therefore, similar actions are required for page
>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>> facilitate this process.
>>>>
>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>>> have a memory backend while others do not. Notably, virtual BIOS
>>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>>> backend.
>>>>
>>>> To manage RAMBlocks with guest_memfd, define a new object named
>>>> RamBlockAttribute to implement the RamDiscardManager interface. This
>>>> object can store the guest_memfd information such as bitmap for shared
>>>> memory, and handles page conversion notification. In the context of
>>>> RamDiscardManager, shared state is analogous to populated and private
>>>> state is treated as discard. The memory state is tracked at the host
>>>> page size granularity, as minimum memory conversion size can be one
>>>> page
>>>> per request. Additionally, VFIO expects the DMA mapping for a specific
>>>> iova to be mapped and unmapped with the same granularity. Confidential
>>>> VMs may perform partial conversions, such as conversions on small
>>>> regions within larger regions. To prevent such invalid cases and until
>>>> cut_mapping operation support is available, all operations are
>>>> performed
>>>> with 4K granularity.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>> Changes in v5:
>>>>       - Revert to use RamDiscardManager interface instead of
>>>> introducing
>>>>         new hierarchy of class to manage private/shared state, and keep
>>>>         using the new name of RamBlockAttribute compared with the
>>>>         MemoryAttributeManager in v3.
>>>>       - Use *simple* version of object_define and object_declare
>>>> since the
>>>>         state_change() function is changed as an exported function
>>>> instead
>>>>         of a virtual function in later patch.
>>>>       - Move the introduction of RamBlockAttribute field to this
>>>> patch and
>>>>         rename it to ram_shared. (Alexey)
>>>>       - call the exit() when register/unregister failed. (Zhao)
>>>>       - Add the ram-block-attribute.c to Memory API related part in
>>>>         MAINTAINERS.
>>>>
>>>> Changes in v4:
>>>>       - Change the name from memory-attribute-manager to
>>>>         ram-block-attribute.
>>>>       - Implement the newly-introduced PrivateSharedManager instead of
>>>>         RamDiscardManager and change related commit message.
>>>>       - Define the new object in ramblock.h instead of adding a new
>>>> file.
>>>>
>>>> Changes in v3:
>>>>       - Some rename (bitmap_size->shared_bitmap_size,
>>>>         first_one/zero_bit->first_bit, etc.)
>>>>       - Change shared_bitmap_size from uint32_t to unsigned
>>>>       - Return mgr->mr->ram_block->page_size in get_block_size()
>>>>       - Move set_ram_discard_manager() up to avoid a g_free() in
>>>> failure
>>>>         case.
>>>>       - Add const for the memory_attribute_manager_get_block_size()
>>>>       - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>>>         callback.
>>>>
>>>> Changes in v2:
>>>>       - Rename the object name to MemoryAttributeManager
>>>>       - Rename the bitmap to shared_bitmap to make it more clear.
>>>>       - Remove block_size field and get it from a helper. In future, we
>>>>         can get the page_size from RAMBlock if necessary.
>>>>       - Remove the unncessary "struct" before GuestMemfdReplayData
>>>>       - Remove the unncessary g_free() for the bitmap
>>>>       - Add some error report when the callback failure for
>>>>         populated/discarded section.
>>>>       - Move the realize()/unrealize() definition to this patch.
>>>> ---
>>>>    MAINTAINERS                  |   1 +
>>>>    include/system/ramblock.h    |  20 +++
>>>>    system/meson.build           |   1 +
>>>>    system/ram-block-attribute.c | 311 ++++++++++++++++++++++++++++++
>>>> +++++
>>>>    4 files changed, 333 insertions(+)
>>>>    create mode 100644 system/ram-block-attribute.c
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 6dacd6d004..3b4947dc74 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>>    F: system/memory_mapping.c
>>>>    F: system/physmem.c
>>>>    F: system/memory-internal.h
>>>> +F: system/ram-block-attribute.c
>>>>    F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>>      Memory devices
>>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>>> index d8a116ba99..09255e8495 100644
>>>> --- a/include/system/ramblock.h
>>>> +++ b/include/system/ramblock.h
>>>> @@ -22,6 +22,10 @@
>>>>    #include "exec/cpu-common.h"
>>>>    #include "qemu/rcu.h"
>>>>    #include "exec/ramlist.h"
>>>> +#include "system/hostmem.h"
>>>> +
>>>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
>>>>      struct RAMBlock {
>>>>        struct rcu_head rcu;
>>>> @@ -42,6 +46,8 @@ struct RAMBlock {
>>>>        int fd;
>>>>        uint64_t fd_offset;
>>>>        int guest_memfd;
>>>> +    /* 1-setting of the bitmap in ram_shared represents ram is
>>>> shared */
>>>
>>> That comment looks misplaced, and the variable misnamed.
>>>
>>> The commet should go into RamBlockAttribute and the variable should
>>> likely be named "attributes".
>>>
>>> Also, "ram_shared" is not used at all in this patch, it should be moved
>>> into the corresponding patch.
>>
>> I thought we only manage the private and shared attribute, so name it as
>> ram_shared. And in the future if managing other attributes, then rename
>> it to attributes. It seems I overcomplicated things.
> 
> 
> We manage populated vs discarded. Right now populated==shared but the
> very next thing I will try doing is flipping this to populated==private.
> Thanks,

Can you elaborate your case why need to do the flip? populated and
discarded are two states represented in the bitmap, is it workable to
just call the related handler based on the bitmap?

> 
>>
>>>
>>>> +    RamBlockAttribute *ram_shared;
>>>>        size_t page_size;
>>>>        /* dirty bitmap used during migration */
>>>>        unsigned long *bmap;
>>>> @@ -91,4 +97,18 @@ struct RAMBlock {
>>>>        ram_addr_t postcopy_length;
>>>>    };
>>>>    +struct RamBlockAttribute {
>>>
>>> Should this actually be "RamBlockAttributes" ?
>>
>> Yes. To match with variable name "attributes", it can be renamed as
>> RamBlockAttributes.
>>
>>>
>>>> +    Object parent;
>>>> +
>>>> +    MemoryRegion *mr;
>>>
>>>
>>> Should we link to the parent RAMBlock instead, and lookup the MR from
>>> there?
>>
>> Good suggestion! It can also help to reduce the long arrow operation in
>> ram_block_attribute_get_block_size().
>>
>>>
>>>
>>
> 


