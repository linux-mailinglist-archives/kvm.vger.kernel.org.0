Return-Path: <kvm+bounces-30551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 277309BB64E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 14:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48E401C21E9C
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F7E224F6;
	Mon,  4 Nov 2024 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E9ddnbQu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221AF182B4
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 13:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730727409; cv=fail; b=jS0VaE7SuCIdZ4xm0n12mYjY1DB34Faapbbfqaht/dBkBDshITH6yrQScWZDIbp1ZelBuumzzAjS6FJsCSR18JlRzVHg/a3CRhcRAwFeEDpFIZSt3FzG3PrYXBWFlznRibgWsyXGsoUXShcDlVeZc1b1Hdpw8dO2sjnLFfS+8y0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730727409; c=relaxed/simple;
	bh=vdM9InzD6GfW0SYDMNCW2F3EHwFf8TrwtnSZtEV9RZc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rQ15p8/VIa2ku1dxi1JsGhBvP0eGy8I9IRrCyKEN5rYZDlP0ISBI3BapKHzZr0BcRDc6hOqwLPpnycLlsFvwMfE5xQelXD8Q4QBcE7XrMmpvXx7OUOWd+Cx3og4yMb6q0CqF0f+IvBs6vjIVCrGwUbtQvikr1WKj0f0V2Tzv11k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E9ddnbQu; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730727407; x=1762263407;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vdM9InzD6GfW0SYDMNCW2F3EHwFf8TrwtnSZtEV9RZc=;
  b=E9ddnbQuoq2dBF1FGgeFMEEKqpg2wV23ZOVLj5Cefh1bZgf7d9nldLNG
   rYHwyzqkw1X03jBjdZ3aQL38iaQ7w9VfvmI6WvwyxTZucaEWlZQs3wdyy
   mSaWCpt1woojyX/L9OiIOCrnvvVFUQ6HQ1HDXOptjqyc8U8brF+PUkohD
   GbsAGv1s6kMSRH+LnG9mBQ4XFsgOJhatSjoHpAHzesylayssI22i5BKVN
   bXvChrOQCJqgXSAn8pn7GC/YmtNKycwbrfrqqgBnboiBgW1QZ2erU7vEH
   +6lOI91ZN/ERFME+sKH6FWgZWt2e5X/7uvxy+55J9SBFCFY+cD9a9ATkt
   g==;
X-CSE-ConnectionGUID: LsgpnRjOTqWAnNoiHNqwwQ==
X-CSE-MsgGUID: d2iHan7tSbOdYqHGx61lew==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41057978"
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="41057978"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 05:36:47 -0800
X-CSE-ConnectionGUID: AuEJP21BRW+5AlUzREzGGA==
X-CSE-MsgGUID: NnWXkldTRaqqvZTozaRepw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,257,1725346800"; 
   d="scan'208";a="83336730"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 05:36:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 05:36:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 05:36:45 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 05:36:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZW2YUXvzEv4SFwZZuCn8iq2C+Qg3P4Cs3KcdtnZ5W2OgIEZkV4f5M3+wfDK5b7J+xpnakIbNlmgdO4tqSC63ZiTnhaJUk4iBqtk3JSVQJDBK0iIiExBZ+cqAPNZJ7SMU+Y3UH3co+2GivBmmARM237PpLq9G1aUAtfvR4mRm70if0f5aBnKgRN0gWZ2PtOO5IzmNHZRQzYA5Ofv+IkZ3xRnBMw8xKa4c3PVVkrqPoUO3SpBpZkQig/IfhO4qGRpXyjqe85EK3qc+1ECQg/x3Q6GV8Zmz9jrprZCw+si02Z0DLqZwGKELtZzeMmYxhJIFJnn9VPDXM5TeUZQKJlrbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ztynpdl5z0uPF9jHEvbnBdA5didWo39yv+Su/eDsS+0=;
 b=UbU27n9C/f7GLLHyBmn/0y5mYKvlTMWg+dxHqQeEyR6cwPbg6MOpNaLJcSXHFl6H+LclV5gab2zfTjFT0qBzyKU+9bEEk4z8whVYmovFabxKz0/77Hg0LM8Kwvxc4OVik2Zxkn6cKNwRkS3QgMgvLIaj3SYG0oqrJD6tSDnPO/MjsdJ+kabbSk/tNnJSolc9V3dWZVnGx7JmGxq7lJ3XUVBzMH2uvry7NtAUUAvywxQY+d5l7aXofVaq3kQolr9KwgsUcaGWFyWZqtuPbs5Ex8Muthd+a0KjbLfZ2xaghs+Upu4QnTKGCHq8CDVcQmqTQfq/yJCJT8w8CICTGZ8HWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB8523.namprd11.prod.outlook.com (2603:10b6:806:3b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Mon, 4 Nov
 2024 13:36:42 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 13:36:42 +0000
Message-ID: <509078e4-1bab-4ada-99ba-81ea00779ceb@intel.com>
Date: Mon, 4 Nov 2024 21:41:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] vfio-pci support pasid attach/detach
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <baolu.lu@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>, <willy@infradead.org>
References: <20241104132732.16759-1-yi.l.liu@intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241104132732.16759-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB8523:EE_
X-MS-Office365-Filtering-Correlation-Id: 59bf0502-7ade-4755-6f2e-08dcfcd5b792
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SEZYUDhESCt4SGtUSUJYNGg1T2xncnFaVS9Uc2phWm5mWWJXUHJmc0pHU1Nw?=
 =?utf-8?B?c25QczVUYzhQQTlDam1kQUpqYWRKaVVPZS91ZE1IY3BUY1R1QTF0NWszclhL?=
 =?utf-8?B?dDFHZ21wRWFGZmVBWTloNHBueW5wK1lFT25MZktPMG9rMjBEc21CRjNwR2dr?=
 =?utf-8?B?bUJrOFBnM2dFZDEyUldvSlZvNHgxdmdwaGF1bmxWd1Nkc0UzZHlYRjVXK0pa?=
 =?utf-8?B?WTlzZ0E3a0JDTEh4VjhVNitpSGU1RVpVKy9DNklmTXEvVmF6V3ZoS3FrejhF?=
 =?utf-8?B?R096NEEraktSOG53TjBDMndLY2JvTTljY3d2amVaeER3cHlrSUFnR29iY1pV?=
 =?utf-8?B?VStxNHBsYjMybGQ4enByTHZLa0toYWRYYkp3ZFA1UXNoWFpCaDNYaFN2TE1D?=
 =?utf-8?B?U2s1R1JydUtVZEIwL3BPOEtpWDU3QmhpY0locWxLY3prZmVPVHhMTXJtTDBP?=
 =?utf-8?B?QmQ5UFZVdkE4aDVhQ0l6NmZyOGREeUx5cFd1UVE2enFrRGZXeTArdFlib05I?=
 =?utf-8?B?R1ZFT3hEY3d5YkNGUWJNYlI0ZzlmdmJHZG9oZmRIOFlwNjBlN1hsWHU3dFB3?=
 =?utf-8?B?UjFiNENKYS83U1Q5azE0Qytzd0RIcmd5dXV3Z0xsQnBVT1hDSUhJa2FOZUxO?=
 =?utf-8?B?dmdaQUxqc09mQjBEMHhjMmlOaHZNalpBZVIwdFRWSFVHMVdqdDZlWnd3WlU2?=
 =?utf-8?B?blk4akl0Q1pXSG1NcVRFc1ZKRHdkTTlNVENJSzg5KzdTTWc2SUJ4RHVnWkww?=
 =?utf-8?B?WGZ1bHMyZkxSL0xUNFJ0aE1IM1VHSVJuSk9ha3E1emVMUjZuSFNoa0RLbE95?=
 =?utf-8?B?NitOVUl2QzZKMkJXdFJSQ2lLQi9HV2pvb1FMUFJISzR5d2czWmRCOFFUU2tr?=
 =?utf-8?B?Vm01YzZYNXhDa1VRcDNaSE12MWxVaHR5dnRZZlNqU2FjekFIdjE3ZFVLNmIr?=
 =?utf-8?B?RmY3WkswKzBpWE5wc0xlL1BpQ2RaYldKdDYvZVZnZjFnK1RyYVlhSHlUOHRn?=
 =?utf-8?B?ZTRGdmp6UUJMWEpmTVBYak5LYlNVUHo4c0NLQlpURTcrRzV5cS95RDRpUkRv?=
 =?utf-8?B?NUJoUFNlZzRnQkdOaktSUTZ0OHU5cHJleUFaSHgrRmVDa0NuRHdpUHAyWEgw?=
 =?utf-8?B?OEVSQ1hOL0VxYzNxaHhYTkcwUEtnUEJuMVJ4b2NQUXNmdzVPOHZ5cC93WkRv?=
 =?utf-8?B?N0xTTVBPelVvV2FIUFdpcVNXd2M3QWc3YzFSWXEyQTNEN1NNVCtrUHJObnRw?=
 =?utf-8?B?b3pmSkxrSXpmUUVwQTNwcjRsZ3I2Z2MyNThVcmI0SDZzNlloV0hOOUFmNS9n?=
 =?utf-8?B?cEQ1dHVUU3BBazQrU3kwUHZyNENBZVJ5S1pwUk9ldUd3SDdPdmhVVkpOclNi?=
 =?utf-8?B?YkZsdjFFbCtaSTZHUXhkblpNQXdXK3hsaU1RMzQ0dklQdERFM0VhVzA0dUJh?=
 =?utf-8?B?Vm9EYmtWRlk1eFV5STNTQ1JBT2d0dC85RGl1b1dtemQ3bERnbmYzKzRobU45?=
 =?utf-8?B?OEUvdzg5ZlpyUHhJUUNuc2M5Njd4Q2RQWHNFOVlOakNZVlJyRkM0Q1g5Qy8w?=
 =?utf-8?B?TkpTd0IyS3M5QkYyNEt0R2pva1hmbjhselZlVUxUaVp6Vi80UmwrWWFDaXhU?=
 =?utf-8?B?M3VqS1UrU285VmJ2bklJblFqWjQwWmpYT3JLaTJUWUpMQTlpL2RMemJRSG1h?=
 =?utf-8?Q?j4QR3cmRDOBZz07/0vUX?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXMxS0xhZ3V0QXp4ZDFLcWZsLzNYTVYxa2J2QmtvSlNmTWRzUnYxbFNEYTRw?=
 =?utf-8?B?UGVRRitvVVU3QzBOcXUxZGdFVUtSVEhtL29jNkdIT3AxbDIvL1hMODF0OUlB?=
 =?utf-8?B?NDlPV1BCMTcrVWI4T3J4YWNaUHhkdVM0cUtBVUJ1SG9ZRkM5K0dIRnhYYXBP?=
 =?utf-8?B?Smg3NTZEY3gwMzlLMkRqb242UGlvUlFHSWNqYVZLM01WRjZoSVNhUGlJbm9N?=
 =?utf-8?B?Sy9jZ2RqZkpJK1JxZ2QyWElKS01LM3hXT2U1V0t1c0hYeUFsZ2EveUI5T0kr?=
 =?utf-8?B?WUN2L29Qa1RrV3oveFN1NVZVdG5YVGswcDIzaFhVSTRMQVRvdHZYdDFEOUJF?=
 =?utf-8?B?N3lZQ2o3TVZGbXdMRHE2Z1lMVFlINTlHajNBMkdXcmJ5UnBkbkhPY3BxMWk1?=
 =?utf-8?B?WnZXb3E2THIxR0Y2K2tTTyt5N1FWeURyTWNreHZreEtTdTRWMXY4U2hDbFlC?=
 =?utf-8?B?aktLblkwUlcwL2tjcU5wQ2gwMk1tbDJpcGlCTDBISGcwdXNOZUNnb2Jnb1Vi?=
 =?utf-8?B?dEM5WEtKY09Ed0lNMEpVck5wTmN3cGxvRHpsTmZ0STZocEtSRnRKeTNMdGRh?=
 =?utf-8?B?YXhHR2hoUkE1YldXVDZnSXdLckNTT3lmVVlJTHpWTGkwVEFtWWZWeDkxeVRl?=
 =?utf-8?B?cHBlTElvZWJ6VGZjN2FINFljOXRxY3N2RktrbktrS093RjlBaTVWMS9hZDZZ?=
 =?utf-8?B?VTZjSUFQbmIxaUZzSHVsdTlIejFKKzJoTis0Y2tQc29zZEdWTTRyaGNoTk1F?=
 =?utf-8?B?V1pUbVdlOGVHSjVuTHZrTkIzTSt2V3h4Ykc4cDkrKzB2eEZoZXdMWDVRVFdi?=
 =?utf-8?B?Mk90cTJ2SjF3S1YzOWpmN0RrdGsxV0hONmVHeFhIWWNIckJLb0lnUGN4QUFh?=
 =?utf-8?B?Z1pESE16SjBrU09ydndCcHp4QWlJVkZnUmduWGZocWRhVnZsUEw0OXdSVUpL?=
 =?utf-8?B?R0JjYWNvYnE5ZzJCWWxtZWRPdE52eUNHZWFpVWxTb2VyNWxzMnlzeVZ3VVdq?=
 =?utf-8?B?NkFWUFg0WWlBWjNxNTE1OG1qY0E1NjR2YmcxZmFSR3c0VFBmOVJHczlwQW85?=
 =?utf-8?B?UUpvelhLSnhGOTRDaHR4OFpKeUE1cXRBUTNnVjdKVVNBS2hrTFFGamc4TEFu?=
 =?utf-8?B?UGlWd1RTVGc5OVdLQWYyWS9uZzJ3dHROeVJtVUwyczJxMHo4ci83cUoycHlw?=
 =?utf-8?B?MWRqSnJCc0xFMkF2NytZVzczNlBlMFJhMVp2b29RcDBQVkpjbWx4YVczRHM5?=
 =?utf-8?B?OGtBL0Y5bE1aTjdiVXFQcGFFS2RuUTZpOHVOSXNvL29vV25Hc0poWXJqZVVl?=
 =?utf-8?B?K0YwYUZ2OThwQ2JYT3dxZXkxQXArdFk5RDRMcy9lT0pYd1FOSEROQlJkSkpP?=
 =?utf-8?B?TDlMTmdZOEpqZGJJNVUySjFUOGVvVmJIRzhEZmN0MjdiVERzVXQzMzJSZUNi?=
 =?utf-8?B?dnNTSEN4clB5aXFZeGFFR2QxZXpHQm9ORVNUTFhSV2Jhb2dSVlNsTjJRQ2FU?=
 =?utf-8?B?NUJTV3BaL0djRldaUnVXMlFRci9ISTdwV3gySzcrd2lFVjVHVkNwdERJdzlU?=
 =?utf-8?B?b1ZvcnJSL0orRGUzR0M2QkY2emtMK1hqMWJzelhNUE82Qi9JTzRkUE9tOWQy?=
 =?utf-8?B?YnhZSTEzZnM3UFZ5a0RqdmFObm5HQXFHQlBSZ2w0ZXh0RUQ5eWh4NzFxdElL?=
 =?utf-8?B?dFpiK0R3YjVSY2NtSzUrb1lIdFkwQmNoMnYrWERQVXVnZ282a2hSS3cwZkd5?=
 =?utf-8?B?U3ZDdlBWa05kc3NtVngweGFmcGlwZi9QamdHL1VVS09OV0YyaEUvUE5FVFF3?=
 =?utf-8?B?bWhjTFZCZ2hEb0FLWmlXYjFhbnhCWDA3aDFJMG1qanBBSHlSRDF2d01PL2dL?=
 =?utf-8?B?ZzVYODF3elhBVEpVK3c0TXZlM0lBYldmL3VXZ0poRkxDSGlLT0xnbG9tK0M5?=
 =?utf-8?B?UVYreWRrZ0lMVUJ5QTRpME1pNmtnQXBHbGtEQ0tWOVJRS0llNlVrUWZsZ0ZT?=
 =?utf-8?B?c05KQ0pJSDJDOFVZQ1Y2OUNHL1BJcVVxZ0F0R3VzWVdOUXdYd3pTeVIrUzY5?=
 =?utf-8?B?M2dqelVEM0Z6WmNnYVNMcjcvTGVvbFhuOE5wSnVmK1JZeXpodmwvUERKYkhQ?=
 =?utf-8?Q?ClDBaHP4Ctn4ku9V1Q95imfme?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59bf0502-7ade-4755-6f2e-08dcfcd5b792
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 13:36:42.1032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HeQIxzUxUqeQur8NCxUiJMp4IisNK4xsR7fxhyua6dgChXu6xDe012sFZWB+1EbpJLtRohScNNE8rwhjR5eZPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8523
X-OriginatorOrg: intel.com

On 2024/11/4 21:27, Yi Liu wrote:
> This adds the pasid attach/detach uAPIs for userspace to attach/detach
> a PASID of a device to/from a given ioas/hwpt. Only vfio-pci driver is
> enabled in this series. After this series, PASID-capable devices bound
> with vfio-pci can report PASID capability to userspace and VM to enable
> PASID usages like Shared Virtual Addressing (SVA).
> 
> Based on the discussion about reporting the vPASID to VM [1], it's agreed
> that we will let the userspace VMM to synthesize the vPASID capability.
> The VMM needs to figure out a hole to put the vPASID cap. This includes
> the hidden bits handling for some devices. While, it's up to the userspace,
> it's not the focus of this series.
> 
> This series first adds the helpers for pasid attach in vfio core and then
> extends the device cdev attach/detach ioctls for pasid attach/detach. In the
> end of this series, the IOMMU_GET_HW_INFO ioctl is extended to report the
> PCI PASID capability to the userspace. Userspace should check this before
> using any PASID related uAPIs provided by VFIO, which is the agreement in [2].
> This series depends on the iommufd pasid attach/detach series [3].
> 
> The completed code can be found at [4], tested with a hacky Qemu branch [5].
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com/
> [2] https://lore.kernel.org/kvm/4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com/
> [3] https://lore.kernel.org/linux-iommu/20240912131255.13305-1-yi.l.liu@intel.com/

correct the latest link.

https://lore.kernel.org/linux-iommu/20241104132513.15890-1-yi.l.liu@intel.com/

> [4] https://github.com/yiliu1765/iommufd/tree/iommufd_pasid
> [5] https://github.com/yiliu1765/qemu/tree/wip/zhenzhong/iommufd_nesting_rfcv2-test-pasid
> 
> Change log:
> 
> v4:
>   - Add acked-by for the ida patch from Matthew
>   - Add r-b from Kevin and Jason on patch 01, 02 and 04 of v3
>   - Add common code to copy user data for the user struct with new fields
>   - Extend the VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT to support pasid, patch 03
>     is updated per this change. Hence drop r-b of it. (Kevin, Alex)
>   - Add t-b from Zhangfei for patch 4 of v3
>   - Nits from Vasant
> 
> v3: https://lore.kernel.org/linux-iommu/20240912131729.14951-1-yi.l.liu@intel.com/
>   - Misc enhancement on patch 01 of v2 (Alex, Jason)
>   - Add Jason's r-b to patch 03 of v2
>   - Drop the logic that report PASID via VFIO_DEVICE_FEATURE ioctl
>   - Extend IOMMU_GET_HW_INFO to report PASID support (Kevin, Jason, Alex)
> 
> v2: https://lore.kernel.org/kvm/20240412082121.33382-1-yi.l.liu@intel.com/
>   - Use IDA to track if PASID is attached or not in VFIO. (Jason)
>   - Fix the issue of calling pasid_at[de]tach_ioas callback unconditionally (Alex)
>   - Fix the wrong data copy in vfio_df_ioctl_pasid_detach_pt() (Zhenzhong)
>   - Minor tweaks in comments (Kevin)
> 
> v1: https://lore.kernel.org/kvm/20231127063909.129153-1-yi.l.liu@intel.com/
>   - Report PASID capability via VFIO_DEVICE_FEATURE (Alex)
> 
> rfc: https://lore.kernel.org/linux-iommu/20230926093121.18676-1-yi.l.liu@intel.com/
> 
> Regards,
> 	Yi Liu
> 
> Yi Liu (4):
>    ida: Add ida_find_first_range()
>    vfio-iommufd: Support pasid [at|de]tach for physical VFIO devices
>    vfio: VFIO_DEVICE_[AT|DE]TACH_IOMMUFD_PT support pasid
>    iommufd: Extend IOMMU_GET_HW_INFO to report PASID capability
> 
>   drivers/iommu/iommufd/device.c | 24 +++++++++++-
>   drivers/pci/ats.c              | 33 ++++++++++++++++
>   drivers/vfio/device_cdev.c     | 62 +++++++++++++++++++++---------
>   drivers/vfio/iommufd.c         | 50 ++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci.c    |  2 +
>   drivers/vfio/vfio.h            | 18 +++++++++
>   drivers/vfio/vfio_main.c       | 55 ++++++++++++++++++++++++++
>   include/linux/idr.h            | 11 ++++++
>   include/linux/pci-ats.h        |  3 ++
>   include/linux/vfio.h           | 11 ++++++
>   include/uapi/linux/iommufd.h   | 14 ++++++-
>   include/uapi/linux/vfio.h      | 29 +++++++++-----
>   lib/idr.c                      | 67 ++++++++++++++++++++++++++++++++
>   lib/test_ida.c                 | 70 ++++++++++++++++++++++++++++++++++
>   14 files changed, 419 insertions(+), 30 deletions(-)
> 

-- 
Regards,
Yi Liu

