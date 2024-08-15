Return-Path: <kvm+bounces-24224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1829527D2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 04:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 669081F24545
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 02:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF04BA53;
	Thu, 15 Aug 2024 02:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pb8uI0ve"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63CE9475
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723687733; cv=fail; b=S/mDRBN1hM5SlbGMoQpglNpE4Jc7tdYcMLVU8PWafiie9sURbWxbMwKBAgy4vr/wJNEwRtS4pU0KrDvONzmiSgfrsruv1usmqRm81CuEQt53CWXB7aWx6zwo4147cljX6uwTBAPSV8mlHRBrk6T/cp7UgDNPfACB0i2bsyRY/m4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723687733; c=relaxed/simple;
	bh=KLREpxma8krDMJW7Q2x6/PjWD3GHUdor9Yo60pXBlKI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aobm7mYEApHxjAt5r5tAPJJeq0JOFyN6YofrIxl4SV/9iRtiLSaxwv44iHAxFOyVFTE1YoS2zU7f8dlJyHdx7Zd0wjioaDUc4OpulIehLmy0nAHWnqfK0spofRjj6zxn4H41zsTS94wi3Jke9ooYSnzmWxQccPv794Eak+ucmgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pb8uI0ve; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723687732; x=1755223732;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KLREpxma8krDMJW7Q2x6/PjWD3GHUdor9Yo60pXBlKI=;
  b=Pb8uI0veIoeqyonAQIgPxpJmjyE3vhZUxfDscW3BFCe893zCeMG5ZoHT
   lM1DbEUsigEETaG06qqumyxG/PpFzHNQ61EPvqxBB4c5l2+QthwzfLGOL
   bMxq9X1S/XUo8rCMe7PvWAaPzpMfRy9Bq/oqcqUqGDjsZ58Vesp5BA1iv
   PSDrPaI6ORrdmumKazEsyssv97Ii1nnQ0Uf6v6diC71UhgbHpVVvh28eZ
   0Hp2NqCotcID1gOVu/1f0/Lq0BGxXYW8uaeQtOS3pAlKq4+CHWTebfmKY
   0MdNVu/gqmTPB8KueZ006NXp3KuTPrslgmlnCN+0Gnz3NCPOT0WskfqOK
   g==;
X-CSE-ConnectionGUID: HEBs76vTRDiSyJFiiYkp9Q==
X-CSE-MsgGUID: M0MlsoIwSCGbzy79cd3b1Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="24837447"
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="24837447"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 19:08:51 -0700
X-CSE-ConnectionGUID: 0U9ijUCfQg64d4kJo9vj5w==
X-CSE-MsgGUID: Nr7ju0TFRyCE1X0OKWbvUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,147,1719903600"; 
   d="scan'208";a="58877947"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 19:08:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 19:08:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 19:08:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 19:08:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 19:08:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hUQT6Z9JSDhkBp5Z1M31pXG8nDmnmTlNLUjg8lCVR269p4Bom7EVO2HbUfB4yLmHd71KwfwUSm8DwvizJtZt1951RxeqDWOu3MUHQEuZMKB0fswTKvUQMNATzpbnaQFUebOyOb6haC6ZNFzVPJf1cxUfxg2JiahBlr3PBa4qO/1iWkwYK3KQOPQU3ImJdt879rwe7nBtihqOKK0RYKCs9J/2xI5RXR2XMYZcksenUjq/Yy2cNeJ048pA56tlm7vIluON1HZ+/ESNjiPiKyQrTY5x50NjB/kr2OK5c/+XSu+L00ceBqbAYUL3XVY0uCYVt9bvkE3MFtZAFksXNA8bpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TXOBRMoGtZCIpj/6engdvbZFwaxRrqbNhJREXv795xM=;
 b=GB3Oo9f81YKfGZXD62Bz3ZNESjbVhHJ1Uqm3OIKnNaeRQO8hcnM960lm0EQKg7aeiMt/cxarnnY7kd95qaRxn+4gifF9n2JQKb8LfD/yTJBh7QddkCU8B1qLK5eG6mN+uCQsxzTHF/M+FtAPJ4UIuzKrLndwe+wpqvjjaJqh+cJnOgZ2wEkBnbkngCAALKfpq9TIGihO95wRYL6e3bm84dw8fwZh3NifhL0WHQ/LP4nJT+OTiHR8DHkLRuWpUCxHEZZ0XwQKzF2rUJSy9PcWjuq+lxyOgP+vEPKbuPQt64hsMf1KF+4wiKEnLS+L99iwcMmXeiCUy4jmutiDOclExQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 02:08:48 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 02:08:47 +0000
Message-ID: <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
Date: Thu, 15 Aug 2024 10:12:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
	<clg@redhat.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
References: <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240814144031.GO2032816@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0061.apcprd02.prod.outlook.com
 (2603:1096:4:54::25) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f3b3957-51d9-498d-b4bc-08dcbccf3235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bTRYc3NCZHJJaTJBYVJDV2RIRFhvaStOR1V0UlFpdVMvV0s3Y3JXSTlFa2dP?=
 =?utf-8?B?eTVRc3QzaGk5cTBxTFEzOElnOFByZCt4MGpmSll6Z21zMDNwdUdHOXl5V3Rz?=
 =?utf-8?B?cHpiK2dJUUpFUFFWSklldkoxSitwdk9wNDI4RTdTS2pUNzcrTXZNSUtrUzlV?=
 =?utf-8?B?aitCM2R1V2NiQ3YvcFRVZmt4Y1JQMGR3WS85d0QyaVg2MGljandOS0hXSUR5?=
 =?utf-8?B?M3VrT2dQeVgzVGpFSS9tZm50WTlsb0dxRkNEYnFHZmVuV1N1bWxNdFAzNWYr?=
 =?utf-8?B?UU9sTFdGYjUrWUNUMVQwanFhSGJCQXh1S3p0YWRLZUdWL1FMblk4K3FhUkd3?=
 =?utf-8?B?UWxVUlRNaFdJVW5OWHQwTG9qZDNKaXhnQmxBYnZwRFJva1k0Y20wMWtza2FX?=
 =?utf-8?B?a2N4OEFncUlhQ25saEs2UnRVTyt3NDY2dDRmMTNUbWtkUkErcWxEWFh1Ykkr?=
 =?utf-8?B?em9BV2JkdWVjMEI0cTZ4Umk0L0lPeERPUDBEejBRU3Q3MEZUZVphY0gxRjd1?=
 =?utf-8?B?dElhc3lPWkZQOHhhL3ZDVWVLdzkzcU1TMUxLSkdLQWNnRVBPNDBHNTBoeDFG?=
 =?utf-8?B?Q3lmcEN4eHZERGhkWk40eXNQQU50Q1J1bnQ2TVRRMXlNZjRpMkNzMG1sQmk2?=
 =?utf-8?B?d0ZjaW56cldocnk2WnNvVk9LTU9NUERieTh4K29YcUNuZ0tmclhpOWl2Zjhl?=
 =?utf-8?B?YzBPdUFlZlRtQ2YxaUZlU1NwN3RCeG0xRE0zTlpiajZIV1ZjV3VwTWw3Y3JW?=
 =?utf-8?B?UWRNRjRhTnV1b0VVZ3ZhUjVqWDFGOE56bzJjWGEwcUc2YkFxY0dRYXEzbE1L?=
 =?utf-8?B?SEsvTjNvNmVmSXZXbGw1ZmpzMW05WnpoMEF1NlFRQzQxUmhySVZZSUN4dFlr?=
 =?utf-8?B?QlpkalpmcHFqaWJPZm5kWjJ3clVnWU53WTF1UnpwNEQrcWlnbG02Vm1JZkZN?=
 =?utf-8?B?aFlXalpsWmVta0g4allzTytNT1EwN1dwRmhKZU56QlhoOTAvNEdqZTlSS2tY?=
 =?utf-8?B?aStvMm5rSEl5N3c2RlJ6cVJqbnNYNkIrL0tMQkdRdzY4aDh2UlR0Q0VZakZN?=
 =?utf-8?B?ZDBXNzNpc0tobHVid2JkS2tZSTFoWFo1ZGF6SktHM25MK1dqcUJOQVpHZmtj?=
 =?utf-8?B?YkVWV3BZSk5hWStEN1FlN00ydUg3YkZvZmNOZXF1R0hFWXRrUURLZFJtZ3JL?=
 =?utf-8?B?ZnJMSFA0VTZMRHdxemhvemJ2UUNzUUZtbUZzeG5QWVFPUEU3OUdLYzlwMm5o?=
 =?utf-8?B?b0UvTy9MdXVhMGV3SGo0OVVJWDhiK2xOU3NNTElYajVvWnhiaVJjd2dMQUdM?=
 =?utf-8?B?VC9iUkQva3p1d2kwVmxIMjQ1YnMwSXBoMTg5WmJyMFlSU09wZXRRcUNZRjNY?=
 =?utf-8?B?VE9FTks4WDUxVzlnVDZyTnRCc24vRGdLMmx0em5WY2pIeHZybnlCaGZVbEFW?=
 =?utf-8?B?UEhaMHZKUWRZdEptbyt6Y2hJL29hZ2gzSHNRWjdha0pNRS9RK3phNStoZU5Q?=
 =?utf-8?B?RGhoSFdHLythOHlhcnZxWUE5VlVha3U3Qm9hUmlPU3R5N2dySElZQnRSYmIx?=
 =?utf-8?B?aXBwMnBkcVpNZnJxOVJseFpyQytxY3hJUjlQcFdSRGpxdWt2dE9TYVRJNVI5?=
 =?utf-8?B?aUo5Y25oRHJ3Z2daemlnb0VvS2Z4SWtXeHZ1RUpnWVJMbXB0VFcwNEFtWmxj?=
 =?utf-8?B?OTR3TWlaMVFjbDFLaWtVbFhxUTNvUFdESnpJK2xwcWdyczQ0YW14UWdiRlhR?=
 =?utf-8?B?QXJMRjl4SGZPZ2dUVjdNUGxoUk4zVnEyNXlCZXF1WjNZbFdLM2V6K3pudjdN?=
 =?utf-8?B?bXl4dERNbHJyUU5IV3lqUT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YktoblkvVmw1R3hnRTR3dDJSZFdEUXMxNUlQY3kvbjdHRXNOTkJHcEh1dmNW?=
 =?utf-8?B?azBNTFdJY2VLZXJjazJJN0s3NFhZaWM2d2JjSSt0cHdCZ2dmSW9IeWEzd0J5?=
 =?utf-8?B?Z1Eyc3U0c1ZJUWRoZm5RR1l4QUFMNU5DeHZXa1NVTjIrNDdKMUYyY2Y5Z0w3?=
 =?utf-8?B?b3ZQamg1RGFndzZoNTlCUDZIM2k5azJremgyZjJpUUVlNGYrazVsemxHK0FO?=
 =?utf-8?B?b3FyR1k4QjArSE5EaHV0Z0E3cm5tU0ZzV3JTcHJUSWJvQVQ5dmtmOTgrWk5L?=
 =?utf-8?B?U3FEYWxUbjNoUXFOc21IZEVSRFg4cndPSWU5MnFTblh6REhIV09tL2hJMEJk?=
 =?utf-8?B?RU5BUklJS1Q3eERqakNmWVNGM2ltYyszcVlYTHgxaTF2cWVpOVl4eEs2MHJm?=
 =?utf-8?B?MldvRFUraUxUUm1ObzJNbFc2V3lPYzZTUHIyN3h3ejlxdjZSd1crT0E1SEtH?=
 =?utf-8?B?eG9CeTZBdHFHMnVkME5qWHl0N3Y1Qm9KM1NuNTVONGFOUHlxemtmTW8wZ0ov?=
 =?utf-8?B?UnpxMEpUekJJampQRFhwQ3ZNdUZFZGFORFptaDlzMHBjUUVHaXFGN21UcG5U?=
 =?utf-8?B?S1kyWXcyWGlja2thcWVTQTNML3F5aWhGN0lTN0JMZnFGbjloV3VEWFFpVEto?=
 =?utf-8?B?SWR3eitFY3FtczkvU0RJMlVDMXE5R2tGQkc4NUJUTlVSL0NsQ0d4YW8xZmh0?=
 =?utf-8?B?VlYrNEdKZy9VQlg0NGVWOWFyZTE0TStBZjFQdHExbW5XK05sNjY0V0d0UlVY?=
 =?utf-8?B?MFlxMjd0RzhGMEh5dVA0ZHpRVVkvb1VBZ21KcmVaUTQ1em5uS1IvcmlWV0FJ?=
 =?utf-8?B?aFRiVW54L3ljajJmcUM1S1BXTHJvMzFZbGYySXEyTnF4T0ZUZkpJNThTT1o3?=
 =?utf-8?B?UU5aNjRKMllnbm9mZ0Q4R3h0MzRGMmRGN3diS2hKdHdBZ0NiOWY5ZnVkaEZn?=
 =?utf-8?B?N2hXVVpLd2ltTkdONExtM0x5cGFGdktoTnJ4L3VGaXFET29IQWlsOU5xQkEz?=
 =?utf-8?B?UWIvTVRYdUo4R2VwMHh2UWY0UFBWa21jeUhPUnJHdm8zRWttNjZhdkZoNjdJ?=
 =?utf-8?B?L3JYc3dpR1lRMlRMSFhhNU55MVgxZktnbnpGdEdhQ1BNeUdDUEVzVlN4aTQ1?=
 =?utf-8?B?bzJlc0JRTllsN2N4TnNpN2V2TXN0UzFSY3c2eFBSWUZiMmYrZ1pFSTduM0Fs?=
 =?utf-8?B?a2xmYmVjRWFmc1ZTMHAyQ3hJdG9QcjFDMEplQVhPcFJTbUFPZUNFcHh1Sk44?=
 =?utf-8?B?cGFUdUpLWUlKeWdEVjJhSXBoM1Jvai81bUl4Z2dTQUgyRUs3VFNpR0xydnlu?=
 =?utf-8?B?VGJScUVQVVlpdDljQ3Q5YzlkdTM1NEJTYkpZUDUydXhwY2VDRDFLTkJGTWFI?=
 =?utf-8?B?ZTdOQ0k4NGRvNjBVK0JtS1RyRW15b3RrdHJROVJTcDJSTnFoZ0tQUFhiZ3V2?=
 =?utf-8?B?bjRCaHlOWHU2a1BJL21EWnB4ckdaOUg3T0lFRlIyeFhZYzBNd0tWWGtiT1Rh?=
 =?utf-8?B?WGFtNHZVYlUrTDc2ajBSdURGdkt0ZTZhTk5oVUtqMmFqalNncm1ueEZ2RUZW?=
 =?utf-8?B?eThBVmJIV1Fja3pqZEFkc25XaHZSZEd1UUhjbjRQU3ZacUFGWXVUTmFoUVlM?=
 =?utf-8?B?R1AzYXpCaGhDT0ZMUmpUOGpOMWhuL3J6eTd3cXZMeGlsUGR0dkZuRVF6b0Yx?=
 =?utf-8?B?KzBFazZWV3RZb0wzekFuamlLT2g5ZUU2OUN4UC9NQ0djdXlKYldScjFvOTJO?=
 =?utf-8?B?bDRGL1ZlMjA3MWsyeU9pWCs5eU9MNkw2Rzh0bTlFQXBqSWsyRFNBWGI0TzNJ?=
 =?utf-8?B?aFBTNFFYdHlSTzVSckpnTCtTZUkxZWRHOEs3T1lxT1EyVTlLNXJYbFcxaXRV?=
 =?utf-8?B?dlZpbHFFVmh1R0hyQnFWKytCM3lBbmtVUEU5RWl4NlVOK2dFeXE0N3VuZUw4?=
 =?utf-8?B?OXM4WWhlOFNyRzRHQVZybklKZ0ZIRzVFNmdXdU9oZVMrTWFtWlBycVU4c2hI?=
 =?utf-8?B?R2FTUjVPT3BtNSs2NWJrbWxyMFlSd3J1S2lobXV5ODhSS0EyUzZFaEZHOHg5?=
 =?utf-8?B?NThEWmpPb0htaVFvc1h1L2EycUNHNmNTTkd4ZTN0V2FtckhJbFJwR2RQWjNn?=
 =?utf-8?Q?w8lICphuCWwY+d9fEWVcwIKMF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3b3957-51d9-498d-b4bc-08dcbccf3235
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 02:08:46.9584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bxLDwIj1bFWN2Fvachlqd/HUQUtMxcU5UgW3xhT1ArmjwbNW7m6MCirU7c2FnJSCsFfDlxDp1h09m4DDAkXZ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

On 2024/8/14 22:40, Jason Gunthorpe wrote:
> On Wed, Aug 14, 2024 at 04:19:13PM +0800, Yi Liu wrote:
> 
>> /**
>>   * enum iommufd_hw_capabilities
>>   * @IOMMU_HW_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>>   *                               If available, it means the following APIs
>>   *                               are supported:
>>   *
>>   *                                   IOMMU_HWPT_GET_DIRTY_BITMAP
>>   *                                   IOMMU_HWPT_SET_DIRTY_TRACKING
>>   *
>>   */
>> enum iommufd_hw_capabilities {
>> 	IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
>> };
> 
> I think it would be appropriate to add the flag here

ok.

> Is it OK to rely on the PCI config space PASID enable? I see all the
> drivers right now are turning on PASID support during probe if the
> iommu supports it.

Intel side is not ready yet as it enables pasid when the device is attached
to a non-blocking domain. I've chatted with Baolu, and he will kindly to
enable the pasid cap in the probe_device() op if both iommu and device has
this cap. After that, Intel side should be fine to rely on the PASID enable
bit in the PCI config space.

How about SMMU and AMD iommu side? @Jason, @Suravee, @Vasant?

-- 
Regards,
Yi Liu

