Return-Path: <kvm+bounces-33703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B539F05FE
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2119C18837BC
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA5419DF53;
	Fri, 13 Dec 2024 08:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="leN/fXH/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B53192D7B
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734077210; cv=fail; b=lLvVlQuyGEmr5Zr7HptjgtX4G4PJ7DM/fY9U+BJLIWp4tgUtaAqKesZ0XC3yEo3QPBuPhrlCXdndL4w3rRlLKt+P9X4pxSbFoYxvyu1D2dyp+BPfcefqGyFJGoY04Y2QXbjHr8bcYok3EilasOpHiDOPzPctPu42NuEI3gahqPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734077210; c=relaxed/simple;
	bh=HPvmTKryBtgyiMIl4i3pHVvYESwIvMs713LRnW6NIuM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HQy9iexYxKt4VC5kEm3tj17lfF2xRFuke1NBfIsVBrigYFE1+W0egtRJlZIwlLz7ljnJQkKaTiT0StAYC3GDwvJu+9U3wKTBz6uUlpdtZIcrH60LakrqCPWh7XCtw44kwA9FnjMaANKznU53eOD8hiM4WdN7zugu4HVpJo6C/kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=leN/fXH/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734077208; x=1765613208;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HPvmTKryBtgyiMIl4i3pHVvYESwIvMs713LRnW6NIuM=;
  b=leN/fXH/t+itNoIr+pmw/cYVZqyCwqD0FrUPLTAvKoKDf9R97dmq6RUy
   1pFN/5lHNAU+8rquQgMLJQ0mEnryDk/bkxni8igbUHvO/Cxf0yIQSaMcP
   HOw6rQXblkqQZrxsxV4wuvtX2vgyAnE9SQQgteWBja2ZqyXX+/vp5mZPc
   7HcCuFaNMv30Q1pc8MEubpOiyr4aiJRz7TOORFgFYL54KULgnyuCQCJSS
   d0MYCnP8fIZg8tJmorMCfUcuNwpGJtBgC6qB9j7gV9+d/JKeMOxYM18IV
   4BhH7QDO0JstJP5J0Otr1yNi8Cnh1GblmaQDh+dUueFw+hlz+k90uI/Cu
   g==;
X-CSE-ConnectionGUID: Fw9CulqpT1yJBzC/jKG0CQ==
X-CSE-MsgGUID: ivZpphtCT12fG8l8ZO/NDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="34395824"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="34395824"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2024 00:06:34 -0800
X-CSE-ConnectionGUID: S7l39TtoQTONx9JjsDo1Og==
X-CSE-MsgGUID: UogKAhp0SL2Gx+wrhC4Xxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96543351"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Dec 2024 00:06:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 13 Dec 2024 00:06:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 13 Dec 2024 00:06:26 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 13 Dec 2024 00:06:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awjSv2XpwG4VrdNDHHAKPvLZtWo88FX+H86kesi2iU3ZKJIqPnQEIaTHewIa6dTwWQJgD4XZRBiqcZrQlFn5Y05YPRY9f1FbW+R4Imxq9Fp8jtLbY/B6VgQHx15aaBnjM+/jzkP9+u5oIDzNCmb7t+75rz89/YdXqFg5moTKlANyQWfEAYx99Bv7A9u3to3qzlf3CqxEJwhFLLcbFQTeq0xLAX563K3K67lEyR44qQxS7GTYkb5YmP0v9W1T6pjDzhvEa3EGEsN6+Vtw5u8zi4xyygard5rF8fhOGjTMLbYe928Cw97AIjMUi+n/GLIxjUp4Px2xX7MnTx26pZB+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQ1uAO+g/6xYRD9FckgrIx+2godnW86Y8lnpNFYF1mo=;
 b=N31S4WBkhVztUoC8N1OsZx4qArMgU76h6jAp6JvoYycaEzs+2i8TcaPRIvdvh8ytLuqwqLrK48vGmOPYXM6oOUCSAcxpqLbupWhmz0CDn8MyKAM604j8tQcRW2I6yH6XkmrKuSSc3RPVTbii13rNRAiLzdUBmPIMOVEBe3nBH4cnNV3JtRyehu6Q1zIyfKGK9vPNXW5amtKAlAehA/0rdleXDMhl1vOK8WM9URW9yhdvcj0Gut634qxXWa62T33ipH5Ops92r8qS3tMGx4iH+oIlV22LS2QsElG5OmcSld54BkOCyPNvne80988YLjBwXX9Y6OmzlawaG+OcUkk9PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by MN2PR11MB4712.namprd11.prod.outlook.com (2603:10b6:208:264::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Fri, 13 Dec
 2024 08:06:21 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 08:06:21 +0000
Message-ID: <d4d959b7-3260-4e03-a0b6-078ae2ea4450@intel.com>
Date: Fri, 13 Dec 2024 16:11:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: "Tian, Kevin" <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::22)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|MN2PR11MB4712:EE_
X-MS-Office365-Filtering-Correlation-Id: e1305aaa-d3b4-48d2-a56d-08dd1b4d07ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Y250bXRPWjBhcmVwUDVHY1NIb3A5V2FKM2ZOS3RzSnZaU3pXZnNzUW95UldI?=
 =?utf-8?B?V2NMSitWMWRDSzlRZVcrRys2bzVacGF3Tk1TOGcrL1J3d0wrZUh1WERSNWY0?=
 =?utf-8?B?dWlma1hOV0Mwa2V6Tml2UmkwcStqTlpxZUhZK0xlM3lBSE52cnNrZ0hQd0xU?=
 =?utf-8?B?S29MRmVxS1dXL2d5b3RVd1hLK3ZpZ2NwNkVLbXdBUWJmZFdEN3BUTHEyZWFQ?=
 =?utf-8?B?bjhpMWUwbXZzaTgyR1FtRzJzVk5SR01WdG5pZTgyVXc5WkJzVWdBOC9YRXY5?=
 =?utf-8?B?VGxGdm5KV3Q0TzV3MHhiVTZQQTRDTjBKZnFyVGFTUHpTSHBITDNMQWxCbHlF?=
 =?utf-8?B?RXZ0TVl2NVJPa3B1bXhBM01zRmR0aUVPdmRHVm4vQ3hKdzJUVXpwUWE4b3kv?=
 =?utf-8?B?c3pMa2g2VDUwL2o1U3BBZzZZeU1zTjF4YUtYbGtRaGRBRVlTSTVPNXhTSmRz?=
 =?utf-8?B?dkN1aHBwcGJjdDBHUzlmL1p2cnB2VGNBM3RPaEhjRWZVemw1R09OUmdvUVNY?=
 =?utf-8?B?YmdJN2RwNUVSbzdmL3J0T3E1Q2pRNDdIclM1c1BRS2RwWWlLSGhsYkNuODRw?=
 =?utf-8?B?Q1BhTEE3czNxTWJGdndwcHd2cW1MMGFMNGlWWjZYNGpUbEdDb0tQUFE5SHk2?=
 =?utf-8?B?V1pqSnJWYlUxempEOFBQYVkxMUdLdFo5RUY1RFgxMUVRRDRxd1FpeENOUkZL?=
 =?utf-8?B?ejhZeU1JYUV1TUdXUWhicXlMZjF3VHAzaU81T0FYeGRkK0tlVU5nekNyUkh4?=
 =?utf-8?B?MnF3MUJja2E4SkwvYzI0YjNrQWNwSThTMnY2YVlpaTViSHNKaXRKaVpEWkY4?=
 =?utf-8?B?b29za1BFQTQyWmdYQWszdUVrdFB2R3FuZC91cWZhM2N1elFQZ0VnTnFaa05E?=
 =?utf-8?B?SnRYYklKZXNKUytILzJTTzJ4ZTlCUjM5UnVzVGxYQzg2dlZWU3k4Qk82dFZn?=
 =?utf-8?B?QXN0YlEwUnhJd2JGZkQxUEVLYlhkNS9LVFZKMXVyN2VqTEdPK1F0OFZYVXp5?=
 =?utf-8?B?WjlsMXFVMUt1dmdnOHdSMmR0STNXUTQrMWxSUFdFWTRKRGtQOHUrak9ZWld5?=
 =?utf-8?B?MlQ1a0U2eDBieTZaNnlFOVRVVy8yNWowZk5sbXlsd3huSTBiRGhXTlprK3lM?=
 =?utf-8?B?ZE4yWHZWekJhODdTQ1poeXJHNnhxNi9JSmQwMlBielQ1Z0h2ZnNIUHoxenZK?=
 =?utf-8?B?WXRORUJhaDlZWG9jZEtEMldqNHlueU1Od3dtWDBYZU1pVkM0NGF1VE51ekpH?=
 =?utf-8?B?R2pQczJEcThkTVZPa2djV0JRaG5YRmtPTkdQUXpSdHN0QzdsU0x5bkNIajdm?=
 =?utf-8?B?YkNQUW9obldGTWZ3OVJZZnhLWGtXTkhmOWg1Zi9mcXIwQnF5YzdqSU5oSkR1?=
 =?utf-8?B?eVpaQ1A2UjNCdlQxb2tVL1hZVFdSWXNjTCtWQjVEcGk1YkdxTUpEK3NPUS9q?=
 =?utf-8?B?MjRscnN1SFVsRFVVcGNoSGVUcW5ZSGZhVHdURUF4SE9waXUzbDhPVnZ0R2h2?=
 =?utf-8?B?bmF0R3psRkNQNzdlSlpIajFMV2ROdE5HTXY3QU9jMlJJOWp4d01Wdkx5bC90?=
 =?utf-8?B?NlhFQXZLbEp5cFVGeUl1VThWUUpnTXNpN3BnK2hDZ0FERWZPL2tzM2pYcWxr?=
 =?utf-8?B?UkMxTUZWQ0dzbkNMcVlMc01WTWprb2xqR0VDRzhsYVgyUGFwY2NYMnh1MW9w?=
 =?utf-8?B?RllnRWdqUEs2YXZHTlZuNEt3dlgrMURnaTd2b2l5Y0hjeXp1NHV0Y21pd0Y2?=
 =?utf-8?B?ZnVPWURDOFBvUzdUdWdHdjMxczFkN0NIVnJxUWkzL2NEbHVDOFdrY2lobS9N?=
 =?utf-8?B?cUduU1J0SEVSYXhHMlI4QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWlDOCszSXY5OUhCeStIbkgxZXJzWC9kQnk3alViY2dxMGI0YUtoaURtMCt4?=
 =?utf-8?B?alJrYkFkMlR2cW56NCtHNWo1SjBtTXJZOWQrVk9CL3hFbjZMRTlLOEQ2NkNN?=
 =?utf-8?B?VnI0eG8xM0RENXhDZ2Q1UUdvTmFvOW0xOE4yS256NDhTbk9JaTJHdFpqUkNl?=
 =?utf-8?B?dkVEZkdGWEJ2aEN0NytleFNzRERNaGJuWmFhVTNmMG5abSswOHRwQ2xWM2o1?=
 =?utf-8?B?LzdZSS9UMmplZEhyYWQvL2pLNFRyL2ExdGhpbHZ0bWtPVytRWDcvaXZCOC95?=
 =?utf-8?B?aGhUTHdFOE13RXJMdFpESDdralFkSVR5QlNxTUZLaHB4SmFCbHpGNGR2YUN3?=
 =?utf-8?B?eVFRcDNscnZJNExrb3dhdFhrMFdmV01DdzZxR3F0dFJucEpxNFVZZFBrQXJu?=
 =?utf-8?B?dFpueEFvVFdGVXI4K09ZRVU2dWVNQTF6TzNCc25pZTFmTFprdzJvWWlqOWZE?=
 =?utf-8?B?dDdnWHlWaDF2bkk2bGhuV0pNZFJrLzZVL0NHSmJxU3c2cFB0T3JvVzRwKzZY?=
 =?utf-8?B?cW5JQ1RyQktoL3Ayd3BvbjlVWFZYZzhmTzQ5WWNrazFqTG1haWpvRkZGeVI1?=
 =?utf-8?B?dWg4SGNKUURtelo1cXNTejFzYmhvL1dadWZvSHRjdnhuWFpjc1cwaVp3eExW?=
 =?utf-8?B?QlNoTXhUeTlJeU5BdjRTUHJ0Mnl5TTdadDlJd0QzbnRnZld1bmFVbzZkKzho?=
 =?utf-8?B?c0V1eGRXUDh0N0xBb1loTjV1bFFyd3JIWlBlSmdUTnFrR1AxcEpLcmY3d1BF?=
 =?utf-8?B?VVRYcGFUNC9VZFRqcFBwanFwRnBpaFRKRUhNMHRaTjQ1aEVPczNaaTgxWUI3?=
 =?utf-8?B?aUNWTGQ4WlMrcUtXRVhoVmVoMTRZLytoTmtwZ05QVlB4b1ZFeit1TXlYcFdm?=
 =?utf-8?B?dHlpMnZPNzBPeE1JeGJUaXE1OWMrSFUvMUQ5NWhVZ1NXd2JSRHBTZzQyMlpi?=
 =?utf-8?B?b2d6c05tekRncUJ2cE9Yc25yT0hSVXpvZzQvNEZ5S2FrQldpUk5VUDU3ZGdE?=
 =?utf-8?B?anpNUUpXUG9DZzZFdUhSRGErT0tURUtQbDJrWURHeTg5RmxxR3lNSjJzczRD?=
 =?utf-8?B?ck0vbmRKNnM2MG0vVC9wQjJ5dlJiT3JMV09nRnJDbG9pWWEwc0crMVZIankv?=
 =?utf-8?B?KzNQZ3dSdjZ6WDNmTU4vKzNZekFRR1FhRWh1c292emZsV3FaSlN0NFBseDho?=
 =?utf-8?B?K211VW9IbnVOOVF2eURCbG50WndJMzNQQ3RnN21abDdneDRjaGlPZFgwamF5?=
 =?utf-8?B?WGhtMDZ6dERkNmtXRDBzZTY3elFFVEFUOUxmUC94MlJMYzJrV0FyS2o1czdH?=
 =?utf-8?B?bGJSclNKWjZwcVN0Q1lZcXdrd2pCMldYc2plUVVKcTQrZzVDMGJSclFRVnVL?=
 =?utf-8?B?dVIzTmMzaCtPdFIzMkQxUWJDNEZQaWVHUGx2Z09KNEZwSys5NkZzYUdGVFB6?=
 =?utf-8?B?TSs4Z3paSnQ3L3VGVHZEeXRhcDFBRTNXNWJQNmFuQ2I5ZWRRcDBnejdJK2E2?=
 =?utf-8?B?eHFrQTJwVkVUcnpSbksxZHQrQTNQY1BNcWRraG9QZXUxUWJydXdSRUJNdGRH?=
 =?utf-8?B?dTMxQ2xHck9pMkQyUnZrRVEwMTJudU94SGlEd1pTczY2blVhd3oxVFFCZzVB?=
 =?utf-8?B?WWlIUFlTdlZkRHBVUEs4dk5UaXkyTjdic05FZUN2Qmt6VnJxUlRjQnVveWl4?=
 =?utf-8?B?Uk4wcmxQT2RIRzY0R3ZFN0FlWSt4UFk0ZjBlaDlZQlp3eUdQNVJYdjhBdmV4?=
 =?utf-8?B?b3V5VGIxZElYR2RRaTNxYVhvc1JRSG5kUWRTWXRhRncrQ3dQNWVId0JQNW5N?=
 =?utf-8?B?bWpwTng2RXh4M2pwN1pMejhvZFd3STc5WjYvL0FDN3gwNG1UZlRvdXIvR1Er?=
 =?utf-8?B?MXZpOUNHdFh3cDFieWloeXBObjFsYkhlQWxEbGMvK0g5cUJScFF5UldWakV0?=
 =?utf-8?B?T0VOSjNaSDFWYnFQM2YzTFBRWmRvczJXNjI5Y3NLM0xlUkF1MmJDZ1BRNCtK?=
 =?utf-8?B?SWJDd1k4U296R2JjQ3Fwb3AwS3ZZbTFIVUdhMWtIbkZSbjhOOThVaUw0MDdx?=
 =?utf-8?B?elVxbG9DeUhjVWd5SyszWENwd1pvTzI2MVdScnp6WTFYNHZXdzlqNGZqaFBQ?=
 =?utf-8?Q?ZUuKcm8Fa883tBRBfQvv1Q4vs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1305aaa-d3b4-48d2-a56d-08dd1b4d07ab
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 08:06:21.5030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kk9WDp47UGR9qnn+hnmy8Z2nUrb0lpGsQ/HWkB7CLn5YHZlNMB1LRK6fkRqii2PZmXDQzWql7S6TwOz61yAcUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4712
X-OriginatorOrg: intel.com

On 2024/12/13 15:52, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, December 13, 2024 3:20 PM
>>
>> On 2024/12/13 10:43, Tian, Kevin wrote:
>>>
>>> Here is my full picture:
>>>
>>> At domain allocation the driver should decide whether the setting of
>>> ALLOC_PASID is compatible to the given domain type.
>>>
>>> If paging and iommu supports pasid then ALLOC_PASID is allowed. This
>>> applies to all drivers. AMD driver will further select V1 vs. V2 according
>>> to the flag bit.
>>>
>>> If nesting, AMR/ARM drivers will reject the bit as a CD/PASID table
>>> cannot be attached to a PASID. Intel driver allows it if pasid is supported
>>> by iommu.
>>
>> Following your opinion, I think the enforcement is something like this,
>> it only checks pasid_compat for the PASID path.
>>
>> +	if (idev->dev->iommu->max_pasids && pasid != IOMMU_NO_PASID
>> &&
>> !hwpt->pasid_compat)
>> +		return -EINVAL;
> 
> shouldn't it be:
> 
> 	if (!idev->dev->iommu->max_pasids ||
> 	     pasid == IOMMU_NO_PASID ||
> 	     !hwpt->pasid_compat)
> 		return -EINVAL;
> 
> ?

no, this check is added in a common place shared by RID and PASID path. If
it is added in place only for the PASID, it should be something like you
wrote.

>>
>> This means the RID path is not surely be attached to pasid-comapt domain
>> or not. either iommufd or iommu driver should do across check between the
>> RID and PASID path. It is failing attaching non-pasid compat domain to RID
>> if PASID has been attached, and vice versa, attaching PASIDs should be
>> failed if RID has been attached to non pasid comapt domain. I doubt if this
>> can be done easily as there is no lock between RID and PASID paths.
> 
> I'm not sure where that requirement comes from. Does AMD require RID
> and PASID to use the same format when nesting is disabled? If yes, that's
> still a driver burden to handle, not iommufd's...

yes, I've asked this question [1]. AMD requires the RID and PASID use the
same format. I agree it's a driver's burden but now it's defined in the
ALLOC_PASID. So, I doubt if it becomes a common requirement to all the
iommu drivers. Otherwise the ALLOC_PASID definition is broken. e.g. Intel
may have no need to enforce it, but it would be like Intel is breaking
it.

-- 
Regards,
Yi Liu

