Return-Path: <kvm+bounces-32355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6949D5EED
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 13:40:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 406742831D8
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 12:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DF41DE8B8;
	Fri, 22 Nov 2024 12:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YCRvpdgl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770A1386D1
	for <kvm@vger.kernel.org>; Fri, 22 Nov 2024 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732279217; cv=fail; b=OJ/QZMKrvB9O1WhEkVyCHQCqP4H0aYC5TkULaQzl4/umV55voMiZLcVyR4+VICEfuWOwizAazFH+HPmNuoLBeuAjCqpcvBDaCj8Qmr7sC5maj4xNgfgl+PJCvVbZehkIlvnYbS5pWXFMX+jwwO4oHVL7P7IztGfi+nTqZtdlZL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732279217; c=relaxed/simple;
	bh=ZiSfOd+8MCfnN/eiiPO/p2R1D7xYDpZR/U7TxuiiztU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u4mAh+wUzgC+qRyrSWSFk9XP3HY7YTlgPli7Un2MqJQR3Sma5EZQ36+642e/08/N2JrdS0s493cNQd9CM9PL/Ijls363u4jQHX1Nn6HOUZvN7OWDY8WrFfLNmWnROX5kmT1ROTEeDUDSuZaQifaQzF5Sbnj6iSlDDkBcQ6j76mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YCRvpdgl; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732279214; x=1763815214;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZiSfOd+8MCfnN/eiiPO/p2R1D7xYDpZR/U7TxuiiztU=;
  b=YCRvpdgl4OazTLfyxC37guIwoqe4cQOUw7tMjl6+Gl3QkEsIG6k/HvE7
   jA8UxRsHbBlEHwHa495S2roSS0BT7zLwlHNDgO44xiqPtp1+ojVWzk3gP
   yhel5HF2pe5VsQz7xNTafWJXMS0ijYoQjsZWp+TI/RzXPRypnPpTzUSxt
   PBq79iyYVUsp+b3njOsJ7pkCsSMoMWXLUpcPblxytDCQ25x3G99OHsjys
   IECRdP+IRG2RuyRtTEb7J/oCO86/URfOYyyb1o2vid2gXjg9+xKN2sWVZ
   8eWyfHmf/gYAx6e/JF51IKfYst8iVyF6Zx5xrasVZ5ydH5+lUVlhzj6lU
   w==;
X-CSE-ConnectionGUID: wW0ZiI3DSuutKwa/FaCZyA==
X-CSE-MsgGUID: TafvDPxKTIq+jBrKnacmRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="32490618"
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="32490618"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 04:40:14 -0800
X-CSE-ConnectionGUID: XNPAy/BpRlusFqU+b0flvw==
X-CSE-MsgGUID: L61Hst/GTCew1fByjG/ULA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,175,1728975600"; 
   d="scan'208";a="90983411"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2024 04:40:13 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 22 Nov 2024 04:40:13 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 22 Nov 2024 04:40:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 22 Nov 2024 04:40:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X00rLYcXUUjHmlxtZ9a0jbcigXJRPqYC2nlh72dCq9tEaWzoGtT4hH6S2EzxXBPZAfNF8MkXgeCGWgqjxVh7yzfNsNWXNEszqBav3p+U3G4gtTiWjIDrNCEHEQM7dL4Pt/aWUY/iUrv+IL+62MWbuOhNj/cZp+FnApFQCKUaXAd7yV2NYplRKH8z/qy8P+Qrrg3iEDtPOsy7oCjYSDZkb6D77ennULbno0q1yRus7/IA9ZBJi8uNUqi1gBcPYHLWvxGy0e18XDKAZKQtQwPuA6VdGNNSe43X+FjKx1yX8O7WeMwTY5fqbaH2JybpWUFPsKKWPeAGIFY1C4ziJSHztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7cKQeiDR3hLiHAqjSncD+LFYkPFxvp0JF0xDzB6vRc=;
 b=vTfZo39lZOzw93NoyOdNl/32JZ1kCEsWuh1xdxLJOIS/17lW8m2KZ5J1gA5VW+VHJRLjo8oRiF/na0UzVycA1qR52ceE2t4SLU4pFzjgl3MYQwu1jF2Az71dkj9IMmenbCRqf1W9fAKpAJHz6TdJyssrevzGyz6UiIZq2f2DicfB2fR4gjbuT0EDnEtuQCbpAk9FzXFG0C2LtpZ/UHGeDLpwRxOloQ6J5EUFNe+bOwRWYKD/Lz3J3IYbvCR922KkLmuPt0zZ6T7Mc5JmwU9QVURWD0T2TAqFErbu5pGPswo9AnxVoOWEDLKwAHBmFfDwH4fku1FL+b7IuHbQ7cxmBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6777.namprd11.prod.outlook.com (2603:10b6:510:1c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.24; Fri, 22 Nov
 2024 12:40:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.021; Fri, 22 Nov 2024
 12:40:10 +0000
Message-ID: <14709dcf-d7fe-4579-81b9-28065ce15f3e@intel.com>
Date: Fri, 22 Nov 2024 20:45:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: Properly hide first-in-list PCIe extended
 capability
To: Avihai Horon <avihaih@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
	<jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
References: <20241121140057.25157-1-avihaih@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241121140057.25157-1-avihaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0179.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::35) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH8PR11MB6777:EE_
X-MS-Office365-Filtering-Correlation-Id: adb42305-18bf-4117-dc1b-08dd0af2cd78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlRSOWtKYzJjOS8vdHBxSlo0NDkxdW9CdzVxQms2QlZxVGNkSXZJcEFWNlJr?=
 =?utf-8?B?VzNBTzdGU0RhMThuOGhMS05ad0FYa2FiK1VBZDZGNHdGcmtaeDFsMUsya1FH?=
 =?utf-8?B?eDR3cndYQzRCcHpRcXN6T3NJaFoxSHFsR3B0eG1KZ0NQd2MzSVR1WDA4UEla?=
 =?utf-8?B?d014ZVFjaEV4b2lFNmRROXh6NXZZTmZLVjVsK3dRTTJueVhKbk1hcTQrYTFp?=
 =?utf-8?B?WlBDbTlKa2g5RmhWb2Y3dHB5YUlkc2tub0lKbmJ2RjNSUSs0K245cDQ2bEI2?=
 =?utf-8?B?QTQ0Q0cwMWRBQnRSNkxmY0tRKzNDSU85TXQ1YmFrc0NtZTZQZkNZVmtIb2Ra?=
 =?utf-8?B?OU9HTThGR0ttWlNIejlnZnkxUU9nRk0xQnRpak1iZkJDbmNueEJCQ2dkZFVv?=
 =?utf-8?B?N0dvaHJNK3B6bGF5amU5bjYvTlVaN2FscVZUeWN6UWxKU0xrWTVUUlh6YXpk?=
 =?utf-8?B?SG5UZlo4cHg1QUMzUFdRcUpCS0pYdnM0bnZDOHd1WDJFSWdFNU1FbzdDRXcw?=
 =?utf-8?B?ZlJjNTZlQmRWUE9yZEM2VitrRGw3WkVPMHJWOVRjQkNvSW80b2Zyb3pNbStr?=
 =?utf-8?B?MDlKZUV5bC91aVI2TGo4RDlmQWxOR1RISWhrdnBUaWU4T1Z0cnJFWDcraFJ2?=
 =?utf-8?B?cEJWbVd6QzN1bzdpbWl4NVE2c2x6aFp4VDNNL2JxalhGMVgrZkUwU0hESXdn?=
 =?utf-8?B?SnJPV2NFZXNhRDdvcTNERTJEOG9Oa3R0b1Z3b1J5MUVUZE1XVFRkc3dFSE5K?=
 =?utf-8?B?NzdFZ3BDcGRYRVQzU0UyeVRjQUZmZ2l3Y1ZSOFRhQ29paFBCemlkUURmOFJr?=
 =?utf-8?B?ZlhneDF3TG8wZGhmaHJVdTNIcG5oTzZ2UEtxMHVhNy96M3c5ajh5OWJmbHlO?=
 =?utf-8?B?d0dBZklveTNqQlJrTFhNVy9EUm0vSkRjVDRqNmJGbGxkRm5qVzNiREt1bEFM?=
 =?utf-8?B?aW5IdnlDRHRrN3dzcG9zSGwyckk4RjNMSWNMZ29XWlhtbmtWUUgwWm55eHdE?=
 =?utf-8?B?cmVYWFJNdFZwcDA0OUFxOXJTR0ZSTllmd2xqRSs5Nmh2czlXMFVtaDVYb3pP?=
 =?utf-8?B?YlpmVjhpK3NNSWRLdWxoL0QwWEwvdVVSL1UzZWtMQjVURGxZeVRVd2ZYaG9z?=
 =?utf-8?B?ZnpKdVgxcTlreFdKbU9OcDJGTUdQNWhVZFJkcUlsWFZwSXBiTnNPVE5EejNs?=
 =?utf-8?B?Tk12dVMxMEZLczA3blpPZ3VKMjZHei81ZTlDU0JVbFBCQTNwMHR6K1BBMm1M?=
 =?utf-8?B?eG5RMjJYSkhOREhySEdscVU0V0kza2F1STZ5aFRsb01xcGVEandJbDRxTHND?=
 =?utf-8?B?WWlZZTJwNW1yS1REbEJ5RVd0Ly9qZ3hXMTBDNkxZSWc1OTZCL2lKNjljcTE4?=
 =?utf-8?B?SDZNVldqMjFtN3VKR2xrNUdTenNTTWFuazZkOXRxRXluM0Z5aE5VelAzUFlB?=
 =?utf-8?B?SFBlbS9jVCtyOXF2K1N2cS9MTnFFVnhZUDBhTHhCb1JCVUgyellWWnNNTmxC?=
 =?utf-8?B?RnBWdGR3Umk0SGV3eWF1Y21zMWFFVDE0aWJIWnptZnZqTFRkRzJRam1OY2pU?=
 =?utf-8?B?YjUyNkpxM2dQTm1ibG9zVjZSSUFXMmt6aGpUN3psSW8ydjgyTW1wSjk3YUtI?=
 =?utf-8?B?M0lhSE5DeEFvYzc0aFBQL3BmT3FnVXFJWU1NRmpDb1RBd2R2R3p5Z1l5Y1Fm?=
 =?utf-8?B?MHZoKzBSK090MmxpakVqT1BmZHZTdlNFbHdneGwwYlZ2Ky9YZVNaUnIyN1FJ?=
 =?utf-8?Q?xsskrIGBsQUvJau5/fBYhBasSXPBk/L9DBcQoqA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eno2T0xqVmpvdExsaWM0c011ZHRveUpPd0lPQUtJMHBjRTFhakl4YW5VbVNT?=
 =?utf-8?B?VU1NTDA4NjU2Q0U2RTU1dUJWU1Q3YXR5UHExa0llSFIxMGkzdElYWTMwZFlv?=
 =?utf-8?B?WXZlWjFNS2hKeU11azA4VFB0TjBJbEhCSWhlTjJMMTZTaGRMY2gyWEk5ZXBl?=
 =?utf-8?B?MThLNnJXenNTTnB4a2l0TVhNTGUvYlBXb00ybWFUMi90L2gzeGFqNkppYmxv?=
 =?utf-8?B?bU05WWVFRjZTRTJjdlNyRk1iVXA5OXArQjdXVzBrRHl4VGFmWW1ZanlSYmN0?=
 =?utf-8?B?aHQyWmJxdVJEM0taR2hxUUMrZWRxdkRmbWlRcHVTU2lTMlFWbnFWd1VJZnVu?=
 =?utf-8?B?YzEvZm5qdGNHa2pzWnB2NnEzSGVQamE2eW1IYlFYTFVGK1RsOTdocGt1THdz?=
 =?utf-8?B?ODJBZmFQNjI2emxPZ01ocHlyYWtOclJEd1RZL3JGRll6a0tWRjZvSjA0MHhl?=
 =?utf-8?B?RkFWeGw2RHUrODNZQ0dldlpsY096OHNZZDN6SHdoclB4MGZjUHJNdmxLVy9Y?=
 =?utf-8?B?eTJ0Kzl3dmZQQ3FjbzR1eWFuN3ZLV3lPcmtOOGRyeDlqbUozU0Vudk1hbTJy?=
 =?utf-8?B?UzBRR1ZHVVRINjNMc1IyU0l3SVAvQnNqclNIRnBxc2RkZ3B1OW85a3VicU5k?=
 =?utf-8?B?c3QzRjRnQVZYK0Vsd2srS3FCQ0dFZkFyY1I5UXNjeWtMdlJRS3RrMEN4OXNL?=
 =?utf-8?B?eXhjZmRCYnAzcDRnelBNODFGU2dlZGVvdy81dnJ0OWNWd2QybStaM2I0QmhX?=
 =?utf-8?B?aFd2TkorVjFDV1ZUUTgvQVE0Vmt0bGsxa3l5ZkJYVDlveFRNOXBUQ1BLOUZM?=
 =?utf-8?B?WS9IZVVRU0t1cFBKL25mSnhvWnUvMzd4ZnVpQ1k1VkdvYUM2NXpYUDhFUzZ4?=
 =?utf-8?B?ZlFhK0VzaEFoNFJJM2F6ODQ1SnJaTGJTNDhNUXROTk1CTXJGdDVJK3ViV2ZY?=
 =?utf-8?B?T2VlaGp1OWV6ZUV2TythRW9JcDd6bnM3OXE2VUJPcHQ2dGVudmxBQ3lkOW8z?=
 =?utf-8?B?VERNV3V5NzgyL0JBSEc2cnVsbUpSeldmeUc5Tkl3dkpkVFIrcWlIWkk0Slly?=
 =?utf-8?B?dmRiN3VzVU13M0NFNFF6Q2NrZndGWXlWdCtvMlVPeEd1NnRTaFh4QmExd1d5?=
 =?utf-8?B?eG5SYW1NZUZ4dk9MY0VkVXpIbk9IQkl2WDg1ZXBOSXZaUk80NmVPblU3eGkx?=
 =?utf-8?B?am1aUVdGbHdPSzdzYlRBaHdibzRxV25hMXlzajRMUFpLb0hrSnNxUXQrYTBS?=
 =?utf-8?B?VjlJQU5YSzR6WDFBbHRkdGx2ekdlM3RUaE83a1BWeWFrZksxeEtEMGNIbjUw?=
 =?utf-8?B?czJkTG4wR1cwNWI0WHdsNi9vallIcEIrUDlKcW9Rc3o0b2QxWE9qcEphSFIz?=
 =?utf-8?B?YTM1SUFTNkduOGk3S1FUbGZlVUpHREdCMm5kQUtZYllZQVRaWGx1SHR3SFl1?=
 =?utf-8?B?M3k2Tkp2ekU5UmFTTlJ4VTZFeXNtTEZFNUVZYUVwZmduWHA0QXlCMWE0UDUz?=
 =?utf-8?B?RmZiS1RwY2lzYk9hZHNuSGFuUXhlQ2pxS2Y1aE56UXlwZFJldFo3aWR2cGtF?=
 =?utf-8?B?bGR4dFYyOWtIYWVuT0ZULzBKSVZsRjBXa3M2QU5UWk5tZ0QyS2xoOUFURURq?=
 =?utf-8?B?ME1WSVhMK3J1QkNuc0JlZG1sdzZIcWJFV3RFYm5waktDUTY0K1pvRW4wRVlB?=
 =?utf-8?B?RzU0NmpYdG5jS1BtWWlrR1FsbkNoSFg0N1VIanA1cTJDRk54Z2IwVjdybkdE?=
 =?utf-8?B?eE1ycGN4TFRtTkhTQ1JiSGw4RllYWFdGQUVkcDlWc004R250Q2hEYVlnZDR5?=
 =?utf-8?B?cXdXZ2FNZ3lvcnJXZUVqL0ZVWlZ3RVVqM3UrOVNKMlhpa2ZLMnpPR0VxWFpG?=
 =?utf-8?B?Z2JUUjFOUXgwYjdybHlxMExWWlZmU3M0aDVPRy80WUNtNHo2a3pVMGVjcFl5?=
 =?utf-8?B?emFuMytONG5aZEhRTVNNZ0RwcEoxdVhqcG5oblRSY2ZGcVBxTzZndldwUUpp?=
 =?utf-8?B?TWNnZWY2RlFQOTdxWVVNVUFpK2k1VUNpMExCTDJlcXVjMFZudnc1eUxVRE4x?=
 =?utf-8?B?OGF0bVpYamJUYnVROCtSbFdBWlExYlBtOEFRME54VTJHV2NVMEc1endNcGdD?=
 =?utf-8?Q?KCE/wSR5k/Axvo1Nk5eXSPxdO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: adb42305-18bf-4117-dc1b-08dd0af2cd78
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 12:40:10.5377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HllRk9s+gdYeEPogc8KtFiC9CxktWH4rdt2qr2jKKPjZeNThD5AM/Nzi/db6rEH6XrCbLmack+ptYa8LGAQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6777
X-OriginatorOrg: intel.com

On 2024/11/21 22:00, Avihai Horon wrote:
> There are cases where a PCIe extended capability should be hidden from
> the user. For example, an unknown capability (i.e., capability with ID
> greater than PCI_EXT_CAP_ID_MAX) or a capability that is intentionally
> chosen to be hidden from the user.
> 
> Hiding a capability is done by virtualizing and modifying the 'Next
> Capability Offset' field of the previous capability so it points to the
> capability after the one that should be hidden.
> 
> The special case where the first capability in the list should be hidden
> is handled differently because there is no previous capability that can
> be modified. In this case, the capability ID and version are zeroed
> while leaving the next pointer intact. This hides the capability and
> leaves an anchor for the rest of the capability list.
> 
> However, today, hiding the first capability in the list is not done
> properly if the capability is unknown, as struct
> vfio_pci_core_device->pci_config_map is set to the capability ID during
> initialization but the capability ID is not properly checked later when
> used in vfio_config_do_rw(). This leads to the following warning [1] and
> to an out-of-bounds access to ecap_perms array.
> 
> Fix it by checking cap_id in vfio_config_do_rw(), and if it is greater
> than PCI_EXT_CAP_ID_MAX, use an alternative struct perm_bits for direct
> read only access instead of the ecap_perms array.
> 
> Note that this is safe since the above is the only case where cap_id can
> exceed PCI_EXT_CAP_ID_MAX (except for the special capabilities, which
> are already checked before).
> 
> [1]
> 
> WARNING: CPU: 118 PID: 5329 at drivers/vfio/pci/vfio_pci_config.c:1900 vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]

strange, it is not in the vfio_config_do_rw(). But never mind.

> CPU: 118 UID: 0 PID: 5329 Comm: simx-qemu-syste Not tainted 6.12.0+ #1
> (snip)
> Call Trace:
>   <TASK>
>   ? show_regs+0x69/0x80
>   ? __warn+0x8d/0x140
>   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>   ? report_bug+0x18f/0x1a0
>   ? handle_bug+0x63/0xa0
>   ? exc_invalid_op+0x19/0x70
>   ? asm_exc_invalid_op+0x1b/0x20
>   ? vfio_pci_config_rw+0x395/0x430 [vfio_pci_core]
>   ? vfio_pci_config_rw+0x244/0x430 [vfio_pci_core]
>   vfio_pci_rw+0x101/0x1b0 [vfio_pci_core]
>   vfio_pci_core_read+0x1d/0x30 [vfio_pci_core]
>   vfio_device_fops_read+0x27/0x40 [vfio]
>   vfs_read+0xbd/0x340
>   ? vfio_device_fops_unl_ioctl+0xbb/0x740 [vfio]
>   ? __rseq_handle_notify_resume+0xa4/0x4b0
>   __x64_sys_pread64+0x96/0xc0
>   x64_sys_call+0x1c3d/0x20d0
>   do_syscall_64+0x4d/0x120
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Signed-off-by: Avihai Horon <avihaih@nvidia.com>
> ---
> Changes from v1:
> * Use Alex's suggestion to fix the bug and adapt the commit message.
> ---
>   drivers/vfio/pci/vfio_pci_config.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 97422aafaa7b..b2a1ba66e5f1 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -313,12 +313,16 @@ static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
>   	return count;
>   }
>   
> +static const struct perm_bits direct_ro_perms = {
> +	.readfn = vfio_direct_config_read,
> +};
> +
>   /* Default capability regions to read-only, no-virtualization */
>   static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
> -	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> +	[0 ... PCI_CAP_ID_MAX] = direct_ro_perms
>   };
>   static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
> -	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
> +	[0 ... PCI_EXT_CAP_ID_MAX] = direct_ro_perms
>   };
>   /*
>    * Default unassigned regions to raw read-write access.  Some devices
> @@ -1897,9 +1901,17 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>   		cap_start = *ppos;
>   	} else {
>   		if (*ppos >= PCI_CFG_SPACE_SIZE) {
> -			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
> +			/*
> +			 * We can get a cap_id that exceeds PCI_EXT_CAP_ID_MAX
> +			 * if we're hiding an unknown capability at the start
> +			 * of the extended capability list.  Use default, ro
> +			 * access, which will virtualize the id and next values.
> +			 */
> +			if (cap_id > PCI_EXT_CAP_ID_MAX)
> +				perm = (struct perm_bits *)&direct_ro_perms;
> +			else
> +				perm = &ecap_perms[cap_id];
>   
> -			perm = &ecap_perms[cap_id];
>   			cap_start = vfio_find_cap_start(vdev, *ppos);
>   		} else {
>   			WARN_ON(cap_id > PCI_CAP_ID_MAX);

Looks good to me. :) I'm able to trigger this warning by hide the first 
ecap on my system with the below hack.

diff --git a/drivers/vfio/pci/vfio_pci_config.c 
b/drivers/vfio/pci/vfio_pci_config.c
index b2a1ba66e5f1..db91e19a48b3 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1617,6 +1617,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device 
*vdev)
  	u16 epos;
  	__le32 *prev = NULL;
  	int loops, ret, ecaps = 0;
+	int iii =0;

  	if (!vdev->extended_caps)
  		return 0;
@@ -1635,7 +1636,11 @@ static int vfio_ecap_init(struct 
vfio_pci_core_device *vdev)
  		if (ret)
  			return ret;

-		ecap = PCI_EXT_CAP_ID(header);
+		if (iii == 0) {
+			ecap = 0x61;
+			iii++;
+		} else
+			ecap = PCI_EXT_CAP_ID(header);

  		if (ecap <= PCI_EXT_CAP_ID_MAX) {
  			len = pci_ext_cap_length[ecap];
@@ -1664,6 +1669,7 @@ static int vfio_ecap_init(struct vfio_pci_core_device 
*vdev)
  			 */
  			len = PCI_CAP_SIZEOF;
  			hidden = true;
+			printk("%s set hide\n", __func__);
  		}

  		for (i = 0; i < len; i++) {
@@ -1893,6 +1899,7 @@ static ssize_t vfio_config_do_rw(struct 
vfio_pci_core_device *vdev, char __user

  	cap_id = vdev->pci_config_map[*ppos];

+	printk("%s cap_id: %x\n", __func__, cap_id);
  	if (cap_id == PCI_CAP_ID_INVALID) {
  		perm = &unassigned_perms;
  		cap_start = *ppos;

And then this warning is gone after applying this patch. Hence,

Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>

But I can still see a valid next pointer. Like the below log, I hide
the first ecap at offset 0x100, its ID is zeroed. The second ecap locates
at offset==0x150, its cap_id is 0x0018. I can see the next pointer in the
guest. Is it expected?

Guest:
100: 00 00 00 15 00 00 00 00 00 00 10 00 00 00 04 00
110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00

Host:
100: 01 00 02 15 00 00 00 00 00 00 10 00 00 00 04 00
110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
150: 18 00 01 16 00 00 00 00 00 00 00 00 00 00 00 00
160: 17 00 01 17 05 02 01 00 00 00 00 00 00 00 00 00


BTW. If the first PCI cap is a unknown cap, will it have a problem? The
vfio_pci_core_device->pci_config_map is kept to be PCI_CAP_ID_INVALID,
hence it would use the unassigned_perms. But it makes more sense to use the
direct_ro_perms introduced here. is it?

-- 
Regards,
Yi Liu

