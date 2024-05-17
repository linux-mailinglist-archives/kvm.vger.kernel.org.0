Return-Path: <kvm+bounces-17593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6178B8C84D9
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 12:30:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8433D1C2175B
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 10:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48FF383B1;
	Fri, 17 May 2024 10:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ghvyyfIx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F571C6AD;
	Fri, 17 May 2024 10:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715941803; cv=fail; b=DLhHJCm1cr7ZARnkewbBmO5Cj//Z5Nk6DCC7FzKGCy0xs5Fk1KPEp9ohkPhSm5x81fdFGk626vTBS8cBUvZRiiNYqng+nVAVLFp38/DhTwo5s70X22QeOfi+3AEbHj/V0LTPB1dRTUXyx6BnJHZRKHEijtsCHiQz40Y80Ha/0oM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715941803; c=relaxed/simple;
	bh=CTm+AVBicrE2jXgp4OYxLvO0loqpOvXDtLgP9Ovd/a4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ONUB8fpLB7RxBF0kCeC9njmdyXIyyjYnz13u+rxnCrUoLd5yGSXYRB1javkNUHnR+OUzEtIVIO9aWGoigTxfh8abkcjyW/a8reMOhoFlpaieb0asR8PN5uNQvlfZfQ3BG0zl42OcpoH7Us1JLKBuNF4hcWnI5z6Ya7yjsXPlK4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ghvyyfIx; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715941802; x=1747477802;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CTm+AVBicrE2jXgp4OYxLvO0loqpOvXDtLgP9Ovd/a4=;
  b=ghvyyfIx3Rsr9L/AzWlmK9uW+TwoZCKWOQNS1Jskj6DJKgV1WC4nJsl9
   s0I/8IiOEEuOZJXplAvnXxFeipFQrElQ/lMgnXIku8xUiISqDrHPef8WC
   Hy4kLcH/8efrl8foP1RPEayaZs92ftGDB+mNLDFh38zniR3Yzm6Up9dxO
   X5idjPPUY+JApAthIU+8htrq53eZKgwKHsk0CSJSMdZwIfbNKclLn+EfO
   EDqBd+JY3SbHbXDrec3+o8WgZDLr/ny5Cjp3TtoON3dybNrZGfvcetJMZ
   iYeZ4rgc/taf4Shm/xi83VSSPF9KvRmVXCvM5STEYE9d46UqNd5DotTGS
   A==;
X-CSE-ConnectionGUID: hv5kMfzTSfyx1oqwRiCnGg==
X-CSE-MsgGUID: BA4d5PNzS8WnKkVJ6hfQXg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29627871"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="29627871"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 03:30:00 -0700
X-CSE-ConnectionGUID: XF95d75KSYmJDM3XdQVauA==
X-CSE-MsgGUID: CrNHfUEDQ6iVvLQ5kOCqGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31890746"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 03:30:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 03:30:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 03:30:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 03:29:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTrCy1bGWnugWI/H4m38Ee8RCwpa6VSqLCgC3Zm5G4duE6K59am6lYX6jy6A1ik+AR4I93i9MooZzI8xzSL2mXqhkCj8tPpXJ5tGiz8SEPGxFfW7UOx82rRng0UVXCwTT+UQFcAr8tDxv4t1FxmVuab9gOMmtkmTEYYoTneV4Pznr5cxdwTlx8/QFw9yCXJ6jpViL2TEyjd3DPGcMjJSer1XMhdUOx5mOzaxwmjkGIk+Xuev3/y8HOHtdjXcmgi4ZqhFgAb7TgG/guTlYsyW3hCgDByzXVRoaGs+Mv7yGYHEELoZhQUDwQXXu9dhA8ClKWv7a97s1bVnbKoAwOhidA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3e/ZJ+tXtT2AaSbdprELjdoLSvwiyyS6mFrOGSSKWo=;
 b=jjnAHZESUbzuMSn9uVpf5dbPQ+dz87F1EAqIVAX7u9DSm7AOOflYRxYABoDxUTOKae7f9O76MLHpq53OfXTNE1wHfZdSa+KZ2+twIf2UM5eGE/rDKVeNN/A8SJNNmOlTz2ZSeT3S59dC1ymwZedRYXPoIj1el2T5PIEBn3Asb8HGpjzh3LTnDWaUMFUcHYc5NQ2fmhSLlaT0a+M8CGB56e2YijjNEGZrMxQbxabvPA5+aUktCC+gAhk/SbBuLttSpyp4gePxf8XRdne195nSsucCSwe7QH/kl8bBmP1UXbN6/I9G8Ce+voQWW71S7Ukw9Yj0D09DGSWdonolGlqY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by IA1PR11MB6075.namprd11.prod.outlook.com (2603:10b6:208:3d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Fri, 17 May
 2024 10:29:57 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 10:29:57 +0000
Message-ID: <d29a8b0d-37e6-4d87-9993-f195a5b7666c@intel.com>
Date: Fri, 17 May 2024 03:29:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	<bpsegal@us.ibm.com>, "Thomas, Ramesh" <ramesh.thomas@intel.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-3-gbayer@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240425165604.899447-3-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0346.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::21) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|IA1PR11MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: 8307b00a-9c6f-432c-7960-08dc765c4c82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QzJocDBGUVU3bDV6aGpPYjgxSHFocld0eG14TVp6dUQ3RmNxVk8va2RXTTRs?=
 =?utf-8?B?Z0p3MVhyVTNIQm1CU2JqbDhrQTM1MEJBYUhBdkkxZzVBYWJ3cHk4cytmT1Nt?=
 =?utf-8?B?UHBNaFdMSmFEcGRDTWYwZGQyU0RhUmJadW1MWkZ6aTFUQmprbHhLdkt4UVJr?=
 =?utf-8?B?S2Q3QTZheThxSTN4MDhJbGtsMThMZUhieUlnd210NmR4TjlweHlQOFJJRzZ4?=
 =?utf-8?B?VUtXaDhzZjA2bVRmLzRHaU9qTW1CQ2lJN3ExUzVjMmVIclJySEpBdUozVlZW?=
 =?utf-8?B?QjI0OXc1TjhUQ1FrMXNrWXRMSUUxOVdvWUpEUzJLcFdtcWdsakw4c3JzN3Ju?=
 =?utf-8?B?aEs4YzU3SmFtUGhGZHJxUnJaekswSHo0dXk3R044b1VSUld4QlZvUCszL1cy?=
 =?utf-8?B?QmFsd0dyZ0JRRVR5TTdyeDFvNzJKZzd6RTNpbnB1amI3amNjbE5IWkVuT2tn?=
 =?utf-8?B?c1pOK1BYdnZ1Um5OakhUcjVxSlpxUVk0YjBkRk1mZGtMQ0F0VWsyWlRVKyty?=
 =?utf-8?B?eDREOXhtNTZGOWUrdnRTKzB5NGMxdjBlcXovUmFuTVZGUnREQTdzQ3BESDRZ?=
 =?utf-8?B?K29QbDJUeDdaekVDTnZnSmJDMEVUQjFLZE9ESEYzbkNOTlcrMklUWTVtd3lM?=
 =?utf-8?B?MXpqRmorVllTblJWdUNMZGhZTWpVUkUvNzcrMWgzMTE4WkorYTlBTEd1cmdo?=
 =?utf-8?B?N1JBTjFsMisrRHpzeFB6YVZHeGMxNk9sRGpCb21EdlJTZzUvN0VYNWhRYzBr?=
 =?utf-8?B?aURCQXNuS1d4M3ozS01vSTROVVN4SkJuK3lJQ1Z0RFgwUGFGZzVEdXQwUUNX?=
 =?utf-8?B?NjlXMUliZzR1UnlVZmFCUmhUL1ZoNUFzWGpNZkhFRXVKTWFlNjRGN3hDUTRT?=
 =?utf-8?B?dk4xRXprdTlIa3BtVm9WU0wrMGhHeTRIS3puajBWYWppKzVXVzRBam1JMERS?=
 =?utf-8?B?Q1IrMDZSV3hpbDNwUyszUDJWOU9wa2tGeENyZnpDMW5KS3N1YkF0UE1vTFZB?=
 =?utf-8?B?Y2cxZHFCN3RHYzR2Yi9MQkJIKzZDQ0hBN0tTOThYdXNBUGRNaGJhaE1sclZH?=
 =?utf-8?B?elpWbjkwRUF2MFd0eVRJL1didWN0MGMxYVNpMFM5YkNmcm1lSkVPRXFNOE9G?=
 =?utf-8?B?aXVJejZYUVVGd0h3eDliRXBrdC85T1RabkdQVUVnY3lGVnRMTmlJL2FoOVFs?=
 =?utf-8?B?SmoxWER4ek80LzlPVHBpRkxEZWdIZG9hMUpnbU9pOGJSZEZmNi90bWVJbVJW?=
 =?utf-8?B?cEgyYnJBdGtuUUdEVkl2VlN0WTVoVFNLSGVia05rNE9QaDJVdjZVKzR3RHM4?=
 =?utf-8?B?Z0xmWU9aS2VHM2lZN3lsMFJEbWVZK3NYWUFnNVkyOXBuYjRGTVczSkZmbm5C?=
 =?utf-8?B?dGZpOVlVY0dFaU04UmNKUVZCajk5b1ZZTUhsOFEwdWJyY3h1bmhkcytSVUVp?=
 =?utf-8?B?NllqZ1hybHh6TWpFMXZOdTZYZGZXdHhyaXlsbnU2NXBrbk1RdDQwRU13RUZh?=
 =?utf-8?B?Wi9RWnN2TDhjemN0cHFac3JCNGhRMnFUM2hXRlFtdTBrUzIxSDRsU204ZU5Q?=
 =?utf-8?B?SmFpNnU0SWlkSzU4N3QyUlZPYVVCUEI5UlFPL0c3cFBDS1ZjQUZHTFdIZm9z?=
 =?utf-8?B?a1VYTVBabG1jaWhhcitnN3hIck9JMkdNblIwS21YU3BjcXF6ZlE1bzJibHJl?=
 =?utf-8?B?a1c1SEc4OTNDYnl6QkxaL3FLQ3cvbTNmWGthU0k3MzhDT2FuQnZabWZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmhIK2J5c0grY1A1TFQ2eWpqbEZSTEdtZklnUE5aREJpNXQralNSZTBlVE5S?=
 =?utf-8?B?OWMxK3NhM0pzUEtycHR4aytYUmZqZnBLVTVDV2JZczFWL284R0Rmc3FlSTVN?=
 =?utf-8?B?Y0VmZ0EvMW9IajBJckhyS0xKTHo2ZUhHMlUrcDZSVWo1WXVQcjNIeXY2MTQv?=
 =?utf-8?B?NWtIcHk0NTBjbm4wdVNnN0FXMzlFVWFSeUszbU1LSHZRelVobXp1dlRScUFm?=
 =?utf-8?B?dUFkeWplZDNUdGJ2UFFHaUtCeDJ4aXNmN3pQcmtVQ0Y0Z2NVWlc3blc4Qlc5?=
 =?utf-8?B?RndKeXVwMlkyaHZIUURlY05hSkh3WHVMbUVhaDlxV2k4VXFIa25sbmc2Nk94?=
 =?utf-8?B?WkdycWd2TGNWamh4dGtJam5BYnV0dTZvNHpPYk1mV1JVc0JkSkUvenlQVkNJ?=
 =?utf-8?B?YXR5Yys2STRMdXNjTkk4UVJuOFZrSFlIeit6NmNhMlZkUWoyZkNycWxyTVRP?=
 =?utf-8?B?YWx5ZnBndmdVNVJKcVJiMU4vYzNZNjJRc2JYcXhrMEUxVDNrbU9aNjN6blJY?=
 =?utf-8?B?Tlkzb1c2M3FoTTdmOUJNZnlHd2xlbUJkYk9uOU1UNWc5bjFqMmZnS0c0WjRR?=
 =?utf-8?B?dU44NklzcGVEOHkxQ0UzYWIzbi9mZkF4WFkyQldDTEg2VVdmS1lSbmNTQ0Fq?=
 =?utf-8?B?eUVjekYvT09BMjNoblhHRTBodEdVR09nbjllMFhKTW9SM2RMU1VnSCt1YjZP?=
 =?utf-8?B?U0pQLzNRZlc3WFQ4T2dXS1A1S0RSNStVVWZZZG9ZYUtTTXNUU3hMbzM5N3RB?=
 =?utf-8?B?NWVsSUNneVFqYkw3SGdVNkp1aHpzZ3o2a2g0L3N6cFBULzB0WnRTWDM4YkNY?=
 =?utf-8?B?bFBoaWRCOXV0ZllGMkQ3NUJCMGtuVi9EQngyT2srWEhaa3J4MnY1S3VyTG5l?=
 =?utf-8?B?MG5YMFphR3JDenNaY1FOc1pHRWJoWjlnMWI0Ykw2ZURVREcyVkRPUmdmU3Iy?=
 =?utf-8?B?NVZuMDVIVEU3ZGttYXNNWVVFNmZ1WWJoTERsaUc5TUlabzQ2ZFkybmQwSy9z?=
 =?utf-8?B?TVlmMEFXWnVwQXBZaFlYQkRWdEJVRlVyWW9XRkovSGo1QnY3bGlwV2JvMEFx?=
 =?utf-8?B?bVJuK1NsamF4VDFBRVdpV1RCK25jcGsrV2VNWlNlWGdqYy8vY1oza1Nxekh3?=
 =?utf-8?B?UHAxZXoyMkNVL0lFazBZUS9pcEhRWnZ3NWI2Y1MvYUxpQ2tuamlvV0RHTFp2?=
 =?utf-8?B?Y2EwZG1venFUdFNUS3huK1VmWDQxMmdZWFJsNWFGTEJHMUNiTHdXR1hscHh4?=
 =?utf-8?B?am9lTnMzVldKd1FLWW90RlVpMFRSTTI4T0dYWHJ4RTFKTEYvMDVwL2QwSUtj?=
 =?utf-8?B?K0JJTmRtbGl0eWhJOEl2UktJMFcwZ3JHYTlqbDFENzN0OEYyV0lscDY0V1A0?=
 =?utf-8?B?Qytneit5aDVZejF0Y1BwYUd2blhUT1ZoUTZFeTI2Qm00NFV3bUlmaUhsMWRs?=
 =?utf-8?B?aUtWODEzV0h2VmJjWHdiWjA5ZytpMUVJOVBjTWNMaVNFSlVYL2V0ZnNrM01W?=
 =?utf-8?B?ODV4TEZTRXNFN1dGcEVvenhWSkgycTBzbUppQ1VtZ3dtaUtJUDBQMXYrYXRD?=
 =?utf-8?B?QnpXL1lEdVZSYTBjd2tKZXk3bC84dkVjQ0o5bHVCeUVjSmxPa3Z0N3ZDZUFa?=
 =?utf-8?B?bm4yQXl4NmhqbW5UNEV5cGQrc2pVNnpXb3RVamUwTGdmSlRQc2tPYWhxL2cr?=
 =?utf-8?B?S0swTVpPNXFJNExjVDBZVDZaVmV2SkFQM3JEdjk3bm0zRzdEd0M1TWNTUE95?=
 =?utf-8?B?UE95N3dVbXlSOHRYOFhDM0daUnR4aHkzaThDNDh4MklHbUFWdXpPMlR2QlpG?=
 =?utf-8?B?YmUyRzdXZExLczFUckkrRU02RnlYaWxKM2NXODEyM1JzK0hoTjBFUW4zcW1W?=
 =?utf-8?B?VTY5Y3EvU2FsNjlaQ3Q3Q3dWYkxLVU5XMldGOWRBUTZjem4zcFZiUktpeUxJ?=
 =?utf-8?B?TXJia2w0UnRhVTN0SWVZS2JLTTY3WEh5aUUyb1drcTcvdk5SUmptSk5wZ2VM?=
 =?utf-8?B?YjR0NCtCZ28ycVd6aU1sMVJ0TGtNR1RCckJFVTRkTVdpWUVwWjl5WS9PNndz?=
 =?utf-8?B?eFR5a1RpdkpBWm85cmxodW0wT1dSVHZSeTlzd2l5RHJMWDF6eWlZL214YTdL?=
 =?utf-8?Q?kqg9WrAfgvLeAZ3dUbvMYmNZ7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8307b00a-9c6f-432c-7960-08dc765c4c82
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 10:29:57.3466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+U2AadlpHZ2tPMiLvfNYbKDloGxExF19LduterVf1GsWsG34njNkXOfsfJRlxXFXNfb0ijkXXoc88mv6BJ9PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6075
X-OriginatorOrg: intel.com

On 4/25/2024 9:56 AM, Gerd Bayer wrote:
> From: Ben Segal <bpsegal@us.ibm.com>
> 
> Many PCI adapters can benefit or even require full 64bit read
> and write access to their registers. In order to enable work on
> user-space drivers for these devices add two new variations
> vfio_pci_core_io{read|write}64 of the existing access methods
> when the architecture supports 64-bit ioreads and iowrites.

This is indeed necessary as back to back 32 bit may not be optimal in 
some devices.

> 
> Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_rdwr.c | 16 ++++++++++++++++
>   include/linux/vfio_pci_core.h    |  3 +++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 3335f1b868b1..8ed06edaee23 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
>   VFIO_IOREAD(8)
>   VFIO_IOREAD(16)
>   VFIO_IOREAD(32)
> +#ifdef ioread64
> +VFIO_IOREAD(64)
> +#endif
>   
>   #define VFIO_IORDWR(size)						\
>   static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
> @@ -124,6 +127,10 @@ static int vfio_pci_core_iordwr##size(struct vfio_pci_core_device *vdev,\
>   VFIO_IORDWR(8)
>   VFIO_IORDWR(16)
>   VFIO_IORDWR(32)
> +#if defined(ioread64) && defined(iowrite64)
> +VFIO_IORDWR(64)
> +#endif
> +
>   /*
>    * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>    * range which is inaccessible.  The excluded range drops writes and fills
> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   		else
>   			fillable = 0;
>   
> +#if defined(ioread64) && defined(iowrite64)

Can we check for #ifdef CONFIG_64BIT instead? In x86, ioread64 and 
iowrite64 get declared as extern functions if CONFIG_GENERIC_IOMAP is 
defined and this check always fails. In include/asm-generic/io.h, 
asm-generic/iomap.h gets included which declares them as extern functions.

One more thing to consider io-64-nonatomic-hi-lo.h and 
io-64-nonatomic-lo-hi.h, if included would define it as a macro that 
calls a function that rw 32 bits back to back.

> +		if (fillable >= 8 && !(off % 8)) {
> +			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
> +						     io, buf, off, &filled);
> +			if (ret)
> +				return ret;
> +
> +		} else
> +#endif /* defined(ioread64) && defined(iowrite64) */
>   		if (fillable >= 4 && !(off % 4)) {
>   			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
>   						     io, buf, off, &filled);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index a2c8b8bba711..f4cf5fd2350c 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
>   VFIO_IOREAD_DECLATION(8)
>   VFIO_IOREAD_DECLATION(16)
>   VFIO_IOREAD_DECLATION(32)
> +#ifdef ioread64
> +VFIO_IOREAD_DECLATION(64)
nit: This macro is referenced only in this file. Can the typo be 
corrected (_DECLARATION)?

> +#endif
>   
>   #endif /* VFIO_PCI_CORE_H */


