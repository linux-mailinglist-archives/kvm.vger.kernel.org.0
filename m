Return-Path: <kvm+bounces-64294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3FEC7D5A4
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 19:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 167913458F8
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 18:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6E029B8EF;
	Sat, 22 Nov 2025 18:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ghFYEXRT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D976296BD7;
	Sat, 22 Nov 2025 18:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763836731; cv=fail; b=oO8f8Q/GNs9AKDMh9rKlHouCBzFzmxzdcnEdweQRRqZE/K8xX60a+CCR7sPLH7o8YAfBJmAnnSZsMC+YG7qLYadC1maZ8MdbVRSLDm82OaO/vQD/ZoVMhOR6u42YrTuWYj8FSrK+dB9Gx31+9StJzgTjOTxzxzfw/Btf2FPbUbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763836731; c=relaxed/simple;
	bh=pFde7Y2x7rAtLvIrJRNG+0scAgXwBZqSYBWpj3mJrn0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lGCRvh5MxXkIRL9Sk3alyK1UhuUBDHligVHlmo+u+KX6rvpWRvSMaXJ3swoyAERioMFWaIFKFhLB6wMVX/Te2VhFejxIa0Zc1/5ym/76DKmBa8sBRZtYaZMdmreAnhW7gO/K2tQEhvZF4bTAvegDQomhDFJvhRLqYF0kG7EVq60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ghFYEXRT; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763836729; x=1795372729;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pFde7Y2x7rAtLvIrJRNG+0scAgXwBZqSYBWpj3mJrn0=;
  b=ghFYEXRTmZBE71sB0ItyGhhjLWp3mO/6w2RHfmnQ2z1s+lAWSWhUiTY1
   h0tnz9fklcWCQpKZU8KYxrbtRJ5W/z76lGQRV6j93CdUDS4mlxzEG/yhU
   RHhEPAoTE3EGA+a5q5wmr6QLidJVU00Zp5xuiYWv6Mz5JREtdWDHJvRGF
   4LbSjB80GuOfbqAYJqLnyfZyavXy4nZXFQVz7/K0JArgacL5EVkF1ZdiP
   6DN78Z8+q0f6DCY8eE1/8C4O9IBFyClToT39lC0gbkvTmZhE0jGeobdTL
   DWGnNqpj8TxJsdKmJDKrcTglX5jaAlqVCzEL7dhb2baQOZgDWCjqpUIRP
   Q==;
X-CSE-ConnectionGUID: pRGNvF+KTv60SowUeNzqLw==
X-CSE-MsgGUID: miWjS0o6TwSiX2qx8UPHIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="64904072"
X-IronPort-AV: E=Sophos;i="6.20,219,1758610800"; 
   d="scan'208";a="64904072"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 10:38:48 -0800
X-CSE-ConnectionGUID: nKgo0sqnQsmnR1YQ9SGnUQ==
X-CSE-MsgGUID: 5ZRjK/0OROukaE5XNntvfA==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 10:38:48 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 10:38:47 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 22 Nov 2025 10:38:47 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.61) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 22 Nov 2025 10:38:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=owWkCJkT06XnWSvXuyDiqtPVxnDwhvblWiQEvBzEYJ6YbnVT6kDWNHL2aQZ3b24kVxTpUSFGC36h6FGHIBplXQv6/muO0v8DyQaqFvJqgeLit5cfP6VaPii5WfuxMIyTAcMdjE13W4ZepktWGRUujuPPSoG9NFgowtLOIGZQXLtaAlVY6VcE8yWeMckOZ5MLtX05f93OPc2HicJWQbHh8FNGTHQ7mO88A6HWAWnKCRLQT6eMaz+rsq33rRtw4jhv5z4Rk4ml7pxMwsNT0Q54jXBHatN5yTOU3PtkjYiPltqYDkrybTxTfSwq0lgFZk3DtdubwcvJc8S6DDbQFhdIIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/FpeC7SzFw1LotDjbBdaO6Q47FRgz8TbHzfoskdCcQ=;
 b=M4zsw15NLgAfhm8ahEoigPfihrShndYLDSy0ieJcqyO728ObSE6bHBJFceXyxnnWl63QWtaHLLTfStxe4FQHe5o4Kd7rjWrQ1ptKauOOxKDpTDrg/VXyobF0WVGUFhjQMs8XUHxiJifaMMHSmbjGGulCcuooYYAksYjapBpnfTdlw7taUbpoKbjLTTbbqsWbelkZAOjiBp6rD0daj3fm4tNIRsaVu6R9C2fWDSXeVMFiB0wqYi+oUtZk387gPDewo1UOwlSJdqxher/rjLFkaFS9QnCTgWC9zekGhjvQV41o38ugLm0Qd9kjAqyr08J2aWdAbutlD2/8eS7FWWwOBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6)
 by MW4PR11MB6762.namprd11.prod.outlook.com (2603:10b6:303:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.14; Sat, 22 Nov
 2025 18:38:44 +0000
Received: from MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267]) by MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 18:38:44 +0000
Message-ID: <582e26ce-4579-4c90-9fab-40f705e89cc9@intel.com>
Date: Sat, 22 Nov 2025 19:38:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/28] drm/xe/pci: Introduce a helper to allow VF
 access to PF xe_device
To: =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, "Alex
 Williamson" <alex@shazbot.org>, Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	"Rodrigo Vivi" <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>
References: <20251111010439.347045-1-michal.winiarski@intel.com>
 <20251111010439.347045-26-michal.winiarski@intel.com>
Content-Language: en-US
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
In-Reply-To: <20251111010439.347045-26-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DB9PR01CA0009.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::14) To MN0PR11MB6011.namprd11.prod.outlook.com
 (2603:10b6:208:372::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6011:EE_|MW4PR11MB6762:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6d37b2-57e5-4442-0b3c-08de29f65d78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anh3ZzNGQ095R0w4NmhwOHBEbGRMbWZjVXhsUVNGWnZtYk9CcEN1QkpRdlM2?=
 =?utf-8?B?OG1JemVCZWIzeVV1UGhqbTFvZnJvQXYzQmpIa3JFQUMwNVlobTFodHlZQlE4?=
 =?utf-8?B?N0FZeEZnRVpvOGpaNjMrOHM4N3Q2ZndiM0pKaHBXNEhyZTdXTkpURXAyVVZB?=
 =?utf-8?B?R2p6R0wxU242NUVVYXROb1hBWHVzR3JOK3ZLbllxRUFTUHRxNm5ZbysxVzBs?=
 =?utf-8?B?UFI0cWRDZytGdnNjWUh4STl1OU13MEUwRkJla1JPS24wM1ZBaDRWZUM3TUdM?=
 =?utf-8?B?QXB3bnBmdjFSbE8rWjFMMWVQSWxvb0JKYVVxWVN5UkZZS0xBRk45bkswYUJ2?=
 =?utf-8?B?Y1ZYZm9WMU41aWVKdXJMOHpzSnNaYWZTU3BkSjFDbHd6d3FuRm9heCtjMlda?=
 =?utf-8?B?dkJqWkY1RVViRFU2WUc2WFZuVk9NdTh6d3ZVb1E4SjZRc21RbFkzT3NYN3JD?=
 =?utf-8?B?OGFtRURWQ2g0eFlNK3ZrTnBWYnowZTY2eEV3Z3gxNEFtVFgxdzJYNjhUam12?=
 =?utf-8?B?TTVLSEllVktWQVVmSWIvT3g2anhQMnhQM3BzR0VSMGJieEFma1I1U2l6VjBn?=
 =?utf-8?B?RlBHK0tERDV6Ni9vRTFGMUpSVTRlNFFuMHpVUmxTU0ppZVNMWTBCMHd0WjBn?=
 =?utf-8?B?aWdKeVJHbVBZL0VoY3FWSDN4dFZsTGZJalZJdWVqRlUzQzBEd0YwY0dRWE9I?=
 =?utf-8?B?L1ZUTmVWUEMrMXBjb3piVXhhVEs1a01XaDdQVEVHS0FRdVA3NzJEZm55ajlu?=
 =?utf-8?B?ZVZSZWpQZy9WdnBPYmxZWFRFSUtzdVZkWjhVZkFONTNSTmVGaVJLcGtmWkdp?=
 =?utf-8?B?Sk1ZUXYrMEx2QUJjRWlQcXRQekh4TEkrQVUrYXlVYkErMFlkU21PaVIzVnJh?=
 =?utf-8?B?WWNiVUtGaGdqekxBZmt6V0l2bXljV0IwTys4Z1RmbHM1emhoQ3lpT3VMYzNh?=
 =?utf-8?B?SjMxQ2YxNjMrMzd3a0QzV1liUWZicHRydnVIMko5Z2Z3ODFHaTdjWXIra0pH?=
 =?utf-8?B?YlMwRmNtN3VpYnVJb2psUVRUSEFnMzVOUGNWUXFhSzB5TG11eTBTQTNvRVVS?=
 =?utf-8?B?czZmbzlQQmJPd2Y4Wjd1VDNBbDhaSUxjVFBlbmtKRGpNbldTYVY1YU1QNHYv?=
 =?utf-8?B?ZjhrclViMmhZc0MwRy9pbzVzaXFQYlhWVjRrbGFCVllsWnNKTzJzdEpXMkZo?=
 =?utf-8?B?R0swcXhhaTdhaUg0QVFtMVNCUmVueTN0d2RtQXRQQUpBUEVkdmU2M1ViMENV?=
 =?utf-8?B?UVU0aERzQkI3ZGVWOVNuV3VjcXVkeWVzK25lTDErbjRHUVJFbGJxa3ZkT0tH?=
 =?utf-8?B?bjF5dVBqaDU1Ym50VDhoM0ZFT0ZWaXRxb29WbjVQVExIeG94UTJES21NbXFC?=
 =?utf-8?B?aHNNNDk3N05QTGFtMU1ESW5GazMxWkZ6ZTZYVXdGY3IvaFlQUnlCUmZ0ZjRs?=
 =?utf-8?B?YTJvVWgzcXVjRUYwSTVSd0tlWUo1N09Jcm5VN25BTnZHcDVOM0Y4T2lGejg2?=
 =?utf-8?B?YUEzbnN6TmFMTi9QaE5Gc2VkRHVKYy94U0RxTlM1Q2wrR3lwVjZmNUtmSDhn?=
 =?utf-8?B?TUxPL2tCL1ZPYU9JZGdVa01KUEU2UjJHRXdTckxjbE8ycUR5MXhWcTVydjFG?=
 =?utf-8?B?cGFGMU5PbjgzbFRqeWVGQjZXYXVTQ0ZlVFkxeGJMcVRkVDFsVVhpRnpDQzFi?=
 =?utf-8?B?WmR6T2o2VmdmVmZOTXFHSU0yRWw1VXB0cDZFT2lxVkt5QlltNkp4NmlhMVNC?=
 =?utf-8?B?NGMxVjFDRjhtN3dCWjhiSjhwRFFOY1N2czVJWkorUjFtZmRLbGcxby8vdWMr?=
 =?utf-8?B?dVpuL00rUHZZY2RCQ3JhUE9jbTVQL25OVG1SQk9HVHNKbXJRd1VMR2U0dFRO?=
 =?utf-8?B?elRpMnFGbXVOUVpRSG1lblpVZ0RhZ1ZYMjNXb0ZxdmtjZjNidVRFZEhpcG56?=
 =?utf-8?B?OFQ0UFBJWmd3U2pMbTVwa0pZcXVrOE81RThQRnBmRitxTktidEVXdGFzVjgv?=
 =?utf-8?Q?MyyJZHrEod4Ya7HZuy3fVQuykrn7f8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODVGR3pRQ01TdVFqYXNSOFdTMm92M0dHUXZURFhoZlVEU2I3cDdzUjE2SkZt?=
 =?utf-8?B?TllBL1hIU3FsQ2JBa1VuT1JvRGVRL1Z2RFFOa3dJZXVhd1BtRHI0NDBtZFRu?=
 =?utf-8?B?aTNXaWtqdE12NWdLamtOanBIL2FpSit2aC9URENUK0dXdTdXMG96WUw3ek1i?=
 =?utf-8?B?azFkVnhiemZOZGNzeEFXWnlXSHNaRGV3aHo3U0hBMHFiQUFnY1U5ZW9qU1lY?=
 =?utf-8?B?cjZZWFJtS2RhOGtHT3NlcTlPc1JzNUV2RlNFeGJEeG9YREJ2cEYySEhXWDQ4?=
 =?utf-8?B?Y1RFcWt6UmVKZjR4R216eFAvZDd3L1BHQjYvQlEycjh6MGtMMC9nWEdqOUx2?=
 =?utf-8?B?dFVIYit4NVVHOVRnelpBck9CRDdkYktIVG5Ydk9ERVgxS1pjRTdSQTdDR1pq?=
 =?utf-8?B?bXpkYk1jOTg5UUYzOG1rS3VyclRhSWdXM1RhcVB2b0o1dXNHanBTQXJDRnpz?=
 =?utf-8?B?d0VCMk1EWnVxR2t6WlZaY0tFYjE2bCtqK0FBd3NZZjVSc2QxdlNMQlhDNFRJ?=
 =?utf-8?B?VXFsZm9hd2VoT25iRG1PVERoRFlZUHJvTGRXVEhNS05LWkV4NGlhMWcwWndJ?=
 =?utf-8?B?eUFHbk0xcnRud0crTm5lSnBBbE1zSzVUTXJHNVQzL0EzMGtpM3RZVm1nZUFH?=
 =?utf-8?B?UUp2TEpUSWdvNVVXRGRZUHlmYkJOS0hldDhydmRyUVFuUTQ5bEFUYmRLZnd2?=
 =?utf-8?B?ZDY0cG1NYll5aW1uQ2JnZlMzYkFkQ3QwY2VCSmVTdThXUE9URWhjRi83SGc5?=
 =?utf-8?B?WVhIS2tqMXZ5VHhSQUZHektWUzdnTDRSVkc0UXlGS3gvQ0Q2a0ZJSDZWYU9X?=
 =?utf-8?B?bnVVWVJFOWJzRUhpU2hvTHlEVkYvZmNKMGpvQmFvbjFrQkp3OHM3Zk9RM2JV?=
 =?utf-8?B?azVhT0tQRE5BQTB1dFExQ2RRWWdORnRnTW9hdUdUQ1M2KzZMcGxJVUxTZGw0?=
 =?utf-8?B?TU9HbnM1Z2E2S3ppMUx0ekpvdmY4dVRSTTdGc2plcWhKTlZNOHBHMjM1Titv?=
 =?utf-8?B?RGI4alN1OVBuc1Z4WHdRQjdCYlVWQ3B2b1kwUFZUWk9yeXd0eDdESkdYUlFL?=
 =?utf-8?B?djMzMUx5aUVPSVNidGFRSUFjbWZDN0RKRitYR1J2TVQxUDl0UlBVN2hhM2Vu?=
 =?utf-8?B?dXZqelk3UndwUTN5bnBLOUhURENYdmtmVnVVUjNPK0g0VWN2WlAzeG5JakVW?=
 =?utf-8?B?VFpPaVVxNWFBSjRXdkpzM0JpNk1VaEs4MzM3eHp5K0FGdjluc043WG5aL01Q?=
 =?utf-8?B?TEk1ZnZtQ001Vm8wODRKZ0xCT0dXc2ljSENhdzBad0VwRGtIbEZMT3RoNy8r?=
 =?utf-8?B?bEs2NDJCVWFJbU80cDdOT0JzcUN1WnRTSTdOK2hHUXhjUDc2QjJRTVVhbEQ0?=
 =?utf-8?B?UWJyOTB6V21lMUd5Qk56dk5HS09nbHhDTHZlS25yWXlPdU1JWW1WdVZrY3NW?=
 =?utf-8?B?eUdSSDRtY0FyNFRGdG1mZVkxNDBPcEp3c01YMVIwN2dOVDR5SHdWKzQ0NWJW?=
 =?utf-8?B?V1E2N0FtTzZ6YnQxWnRNRkZhaUdaKzVXcWlRKzNJSjNWYWd0YUhCT3dnTkRz?=
 =?utf-8?B?a2xxWUIrR2NBM2pDU0Q0RGtDalNqRmpFWkJNbW9sQm1CWVo1eXFGVG5zdXRR?=
 =?utf-8?B?NGwzWHZXMk5ybkhRVFVEb3h5R0xXNmlYSkpnZVVlNGZoYklaL01POStIbmRN?=
 =?utf-8?B?K1VPNld4a1dzeXlXRi9HcUd2VEZpckxwR1kxYUIvcUlCL2JlZUtRRkhIeGd5?=
 =?utf-8?B?aEhMRmdjcXV3VEtIT2UrYjNhVjFjY1ZBaS9LbS9oZDZQVHJWL3NjSUl2Skpl?=
 =?utf-8?B?M3RiSGNjTjVxOURITy9YUzN1Rys5UnVNYUZHUTlUZnhRWXE3ODJnTHJKKzQ3?=
 =?utf-8?B?TW5hZFkwQnNXN0laa1VRT0FINnBRY3llcG9ZYUpzR0JGZktrWXo1YzFrT0Zp?=
 =?utf-8?B?ci9mQ052aHJISlgzWWxJQjZwNGdhcTNNeGlqRythQW5PMHFBbWRjSVFBbVVV?=
 =?utf-8?B?U3cxMU1WVzZRelEwU29JbldzY3RyMlZvUHpjTmZLdVhIVVVob29hWWdXbzg3?=
 =?utf-8?B?TG5lMVcwU3RZWDFFMGEzQXp0L3RQL1pzVU5Ld2tMemRIWlMraFREZUE3amJq?=
 =?utf-8?B?VGE5SVdTTk9ZTmE4TnVDQm5VRUt1MlBIM1hLR2FaNDhwMVA3dGpDS2xTNTZj?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6d37b2-57e5-4442-0b3c-08de29f65d78
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 18:38:44.1241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuypuBMj+kaRM3Y9LXUrOdWv6Ic/X3kzLWAD4mY4tL/PJ/TggRI4B9IBISJqSuKmfT9A7EBDOe7zTC32638XoT0k5z4Ng02gkhlG8mdp80Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6762
X-OriginatorOrg: intel.com



On 11/11/2025 2:04 AM, Michał Winiarski wrote:
> In certain scenarios (such as VF migration), VF driver needs to interact
> with PF driver.
> Add a helper to allow VF driver access to PF xe_device.
> 
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> ---
>  drivers/gpu/drm/xe/xe_pci.c | 17 +++++++++++++++++
>  drivers/gpu/drm/xe/xe_pci.h |  3 +++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
> index cd03b4b3ebdbd..5107a21679503 100644
> --- a/drivers/gpu/drm/xe/xe_pci.c
> +++ b/drivers/gpu/drm/xe/xe_pci.c
> @@ -1224,6 +1224,23 @@ static struct pci_driver xe_pci_driver = {
>  #endif
>  };
>  
> +/**
> + * xe_pci_get_pf() - Get PF &xe_device.

nit: xe_pci_to_pf_device() ?

as "get" is usually used in simple 'getter' functions
while here we perform extra checks

> + * @pdev: the VF &pci_dev device
> + *
> + * Return: pointer to PF &xe_device, NULL otherwise.
> + */
> +struct xe_device *xe_pci_get_pf(struct pci_dev *pdev)
> +{
> +	struct drm_device *drm;
> +
> +	drm = pci_iov_get_pf_drvdata(pdev, &xe_pci_driver);
> +	if (IS_ERR(drm))
> +		return NULL;
> +
> +	return to_xe_device(drm);
> +}
> +
>  int xe_register_pci_driver(void)
>  {
>  	return pci_register_driver(&xe_pci_driver);
> diff --git a/drivers/gpu/drm/xe/xe_pci.h b/drivers/gpu/drm/xe/xe_pci.h
> index 611c1209b14cc..e97800d5c9dc3 100644
> --- a/drivers/gpu/drm/xe/xe_pci.h
> +++ b/drivers/gpu/drm/xe/xe_pci.h
> @@ -6,6 +6,9 @@
>  #ifndef _XE_PCI_H_
>  #define _XE_PCI_H_
>  
> +struct pci_dev;
> +
> +struct xe_device *xe_pci_get_pf(struct pci_dev *pdev);

nit: since this is just a helper, move its declaration below core
functions register/unregister 

>  int xe_register_pci_driver(void);
>  void xe_unregister_pci_driver(void);
>  

just nits, so

Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>


