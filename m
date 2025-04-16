Return-Path: <kvm+bounces-43385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A901DA8AE6E
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 05:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E318C3BF854
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 03:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0D81F30B3;
	Wed, 16 Apr 2025 03:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNswYCK5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6092DFA31
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 03:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744774345; cv=fail; b=aQ6BaRTme9w6f3MsyGKsXUUcyJMlcSnK74yqOCEXT7D1Y1Ifi9ZwSabiLL1eNFLLOZWP80N/4B/Y1sS5+GlpcRSsJvWI+gCnuI/IyzxGj21aHOZtkurTO9QRXv8kBRZ3gONe3nqiSgJTayJk5aqbBzuDpxHCNtEdjB1Iw7cINK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744774345; c=relaxed/simple;
	bh=QTpwsbieWbhcLQrl3ao2QzDwHHuNXogRFXrQ0btHP8o=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LZ3p0QEv+uWwr+X9N8VZZNbKbKJuRJtSp7L3mfGP7yH2JQi4j5W5Wv/JDnsLHdm/OWiNdyXUW+f/bZ2x30N6qHd6TwVVShPG8yKpzJLKLUiAKZk+1l0dPPHCZV80t1Sl8Nt1kmUaMQrivqH8fD9S9mp0WcN74UDwmdvaQ2/9zwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNswYCK5; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744774343; x=1776310343;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QTpwsbieWbhcLQrl3ao2QzDwHHuNXogRFXrQ0btHP8o=;
  b=VNswYCK5X7AEfbdf/ByDdpRSKdOXNW1QGwI8uJgFMbnGCoGHRIQpncvQ
   ZSVYxCmxmeQ7r3jNLzBNjVZPx25vrFNcWmnWWExw8ia0TuDAo3MbVNC9t
   ANj/0xZo6b3mchIVjrg/Z9WX2hR+aj6C4RMPvdVMLMWo4p8KcGH5pALZV
   Yx3/56MMacLzJCJ88oqOuJMMCe7THgXpl0RS2XqQFZCsV+SVWh9TpcYOz
   Ks5C8k0hraB/SDHHlZ43fspXd3pGfuT61m3LQNIZUqtwCMVLxlDT6SnSu
   I7H4DuYrtOmulbazIdo+SweliAXDVqnSu78C8PpJo/eDZKD9ezuTQrElP
   g==;
X-CSE-ConnectionGUID: 6e1d9idmSXS/vqdWZyQO3w==
X-CSE-MsgGUID: 8TkQSGEQQkOeVLBjAnS+Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11404"; a="45441936"
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="45441936"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 20:32:22 -0700
X-CSE-ConnectionGUID: BRAiweQsTWair7emkAM73g==
X-CSE-MsgGUID: JJN+apA+TIiGXox5dnPqhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,215,1739865600"; 
   d="scan'208";a="130851849"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 20:32:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 15 Apr 2025 20:32:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 15 Apr 2025 20:32:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 15 Apr 2025 20:32:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=inPj92AH6evT29lOT/nPpnnS/MWvSEazxlFbCR8EwM966EbzgLwHWHbDwdiBVHiJeo4ZuZ6x/l4ZNkBTbUOyOrrUl65d4+4azSbUU489WSAykR8dE8dpv4o8PgSkDlqjBxms/hMq1V2qDTa4TrjOFgjE31pUU/3UTW1G2QfjZb6w/8weVwNoR7ft7P5ofjGEux6p0lyJmIXDbNDVtPBl3iQbsNzAIZZP/KzewYp/mhFG/gQ1uCSY3Ou1hBjWBSIMacWkJ2ozITQ1oVXMSuZBR1541ZrHbYeXlonE0hZ7Ukx8DPzZdwH0AK/VZ8Z8S0vh+OK+1yx55Vc55aR1jAa/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gn2WUTs1V/d8nPsKQ4mFpZNFT3ZHvRRDNnzL9gIkN6A=;
 b=GmNbnUMTaQCj0yc9epzIGm+0s4Z4D7b3g2/jWv3SeKH9n49G6S6KTfaUzTOVKeBXrXS72KL1c9NcjCUoJTrkPMr6/vK51IdEsRU7mxB5SdyBfx+NZ+WdmiYenqUNvDIPQ397bqnRAlyx3LmFjNZjAExdXXlDjhkiRfODscQ30Z5vhIivTnma5JreqmTIY//GACZY0JB/M9c33sx7d8W+pYeduWXyN9YZKWEZSHOfJozUEsKbputkp7pZ0TfIFrV/MO2i8AsGCBDfmAvuZd1x0Vv0rWL9SmiHZ9UbFhal3uV1moW8CewfjlsQLw3QFZ7xHs8+5bTq3pSQRrT9Gaw/yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DM4PR11MB6502.namprd11.prod.outlook.com (2603:10b6:8:89::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Wed, 16 Apr 2025 03:32:18 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 03:32:18 +0000
Message-ID: <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
Date: Wed, 16 Apr 2025 11:32:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
 <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
 <25f8159e-638d-446f-8f87-a14647b3eb7b@amd.com>
 <cfffa220-60f8-424c-ab67-e112953109c6@intel.com>
Content-Language: en-US
In-Reply-To: <cfffa220-60f8-424c-ab67-e112953109c6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:194::11) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DM4PR11MB6502:EE_
X-MS-Office365-Filtering-Correlation-Id: 79bea3c6-14b0-4f39-fdbf-08dd7c974a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aUkyNEZjdGNIL0EwbVpVaXNNNFlFd1lNeVlHV2gvaFYxR21kTW9OR1B0Tm9C?=
 =?utf-8?B?YTY4S0J5YTk2WjhkdDBWVzdvTWsyRi9yc3ZpMHZ2VVFUK0drbnVVTkF4aDdr?=
 =?utf-8?B?eDZNYmZ2NzQwdUhRMUY5SW5wVTIrL09aU1NzREVtL1FuYWlXbUJFVWM4ejdn?=
 =?utf-8?B?MWdiZXRkV016R29aa2F4L0ZTLzU5aVcvWDdJRVc0S3pCK0d2YlZ6QVo4b0tn?=
 =?utf-8?B?U3BBS3VMRnc2Z3piaHBzRVR6RUZ5ODMydmk5MjQ1NThzZFg3R1VncGpIaEEw?=
 =?utf-8?B?aWNmeGUxcXoySktOQ1g2R3lLU00rY0tUOGp2UC9QZEVDZHhhd1FCQWh6OVJK?=
 =?utf-8?B?WUU2VVlIU1ptdXljeXRzSW1VcmZKcmFrdDJtNUd2Ly80Q3pUUVY2WmNzYzJl?=
 =?utf-8?B?am1rbDI2SHR1UGRzeGgwb0hkMjRzUmZhS2tzdElySERCVWxSbVRZdzI0Q05t?=
 =?utf-8?B?K1RxR3hQR2ZQZDJaaGNZS3JmRW1Ta0FPcngrVTdaOFdCYk9OamdsSS9xS3pt?=
 =?utf-8?B?dUt6NHhFdkUrY2psOUFDQ3pVeFltN2cwaDFuSzhFNTd0QmFiWW4rWUtuTHhv?=
 =?utf-8?B?Mnh2bkRvYlk4NHVlRWRFYzB5WnlXdERNSW9sS2Zwdjk2V09WYVlUSlFyRHFo?=
 =?utf-8?B?ZjZIY20rQjdFa1grTDZGbzBELzVwTFFsMkFPaWh0SkNpMDZOT0pOMFA0bGpk?=
 =?utf-8?B?dlNzQS9nZWtZOUdKNm5BQXA1d0hyY2dnQ0RGQ1h3WkkrZHpsUWw4MnpTbVhY?=
 =?utf-8?B?S0VZdVVuUkRJbFI1UVhYVUc5K3JaUHJRZGN6dzdXaExLdUNLVlB3bHN0UTZY?=
 =?utf-8?B?bUd3TnlXVlJHSlZDNFhvcGtEM3Q2dFN1OEFjYVZ6U1pGK0txRmhIR2FKOWI0?=
 =?utf-8?B?OURheHhmcGdQVkJaUnNXc2ZPNHlESC8vQTJSMXV6dTJvNXBQZENyeWZrRXRu?=
 =?utf-8?B?d1JTejY2Vi9CVUpQWDZPQVBCb0UremJ4UTJYUEIyb3FpcWFFMldtNlYwTzUx?=
 =?utf-8?B?R05KY0R2ZGdkc1RvK2NwQkNmLzVCcDZCQWhSMzE1NEE3Y1hTMUpDUG5JR21x?=
 =?utf-8?B?a1BDL2d3bm1Lbjl4QkpCejc4OU9rdXZ2VHJVSVI0SXJzYURhNTdWbVRyRGpW?=
 =?utf-8?B?Y2N4ZUhaZ0c5czVTQXpqRlo2dTdJSXZyWCtDb3JTemNOSDhub2VQWm81Y3Z2?=
 =?utf-8?B?NlJDc2UvVE92cEF5RCtBZVFaOGIwY2x6UUFaODJjbVVhMXRRTVBUSUhZazM0?=
 =?utf-8?B?S2YrVkt4QUNwcmZsUWQxcDlOSjNWN1dmaURoeXRXSXVwNkN0ZlUwbEJSNkp4?=
 =?utf-8?B?Z3JXN3JIMG5YcDNWVUd1cXJSMkJLQzZiTFk4SHFWVHZQakMxc3NjaUgrazBF?=
 =?utf-8?B?T3d2Yk5GRHM3Y0VqUnNydWVOc1NVaE9TaDZVNmNYYk1LeFhJRjNsY3ZJRmRu?=
 =?utf-8?B?TlJ5V0pQbDk3TDA2bW55YnZkbG1VU1ZkMDVMekJNTngxc2I2d3NubUtkK1NK?=
 =?utf-8?B?QTRuSG1CanZpTDZSdFgwYWw5YTlNMW0vTnI0R0p4TTlCV0xoakJUc3BLZGlM?=
 =?utf-8?B?VUF3MklOMjVoeUtSOVBUUTVuamhpNU1ZWElXUVAvTzEra0VsYjNoYUJqd3g3?=
 =?utf-8?B?RXhOVVJ5MmRIanpKbk1uN3FBL1VLUVdIT1NUY2Vha3kvb1czZjY3Rm5vaGo4?=
 =?utf-8?B?KzdycG5HMDc0b3dLZUxQcER4cTU4VXNGK1E2MVIwd3FLa1hXUlFIcVIzTmVo?=
 =?utf-8?B?bDc4c2J0UC9WcmZMTW5DbGcxVWttS1k1Rk1nU1dOMkM1T1dGUXM2dkx3dkps?=
 =?utf-8?B?N2JVT2hDVlJqdURmTzFORWd2UDBlZDhpMloySEpRNVN3ZUFJcklkTTNLdmYr?=
 =?utf-8?B?ZDRsTU8yWk5Jc1dPSzlRUUkwTmtnc29yeFhmZStTa2FBZ3FNUWNWSVJsV0Fj?=
 =?utf-8?Q?L/BgEDCoIGk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0liU2k5cml3NWRkZHhEZmlsTWd5OEt1OTZKb3E2c0lBUldwZldyUHJHVDJV?=
 =?utf-8?B?cXRQeU1MbjU3eG5xcjJuUElDbWlJZzlBWVFiNWZHWU50Vy9YT3NmOGE2dTgr?=
 =?utf-8?B?bHBRRzFBVmE3bVBPQ2JmUWNYaFJWZlFjcXlUaEZOWFZLZXBYMTJBVzRoM3FP?=
 =?utf-8?B?Vk50MXg2bXc1QU9PVE1MZlFqa3dYT1E4TmJrdU1CcnE5Umh6MDJ2QVhBMDY1?=
 =?utf-8?B?QlRhMm5tbDc2T1dybkltVTR0TGhWZGpkMGlIYjJqdkZTV0dxVzR2cmJyWUJZ?=
 =?utf-8?B?U1VFS0tBZlZiT0RPRjh4YytzanZxQ1Z5eUgxZWFSb1gvU29PR2dEalpvQ2wx?=
 =?utf-8?B?RzlRdWFsVUJyczNvU2xXMnU2TE9NdUwyM2VhTm1VWW8wemFYL3pERGNQejNK?=
 =?utf-8?B?SlUrMG40cUlDQUhDUXhRb2g2cWlMc2tGNGpHQWZhYmwvQk00S3kwemIzOXRt?=
 =?utf-8?B?YXJjOWtDQy9rM3Q5a3RpT056UGZDT0pVM0RueTAxWmhHdGFabEdwUjZmU3Bt?=
 =?utf-8?B?UnUreHpRNW1yWlFRenE5MUpHUTNnQXhjaFdtaGdZTTliQ1E2UXVxTzcrRGNK?=
 =?utf-8?B?dVBRM01VOVBFaW56YmZWSVNVMnR2RWIyaUNiazhreGtrWC9rR2QxaDJzS0Vz?=
 =?utf-8?B?UUZDbjBrUWpBZHRMOE9BaENTM3c0bGE4ZU9sdDliNFVlUkJkZzdHbCtqVUx6?=
 =?utf-8?B?OU5ZNElLOHd1NTkrVktHcnR4WTVnQUY4L09LY05sVGR6NlBMUzZLNjFva3cr?=
 =?utf-8?B?QWR4SVBnTHZ2VHZLNUI1cnRzREFvTGc2eUttYXV5OVJWUGIvWHlIK2pBdTdn?=
 =?utf-8?B?cEI0VzhHQkNjSTVndXVtelNjUmh5cTdFVkNZYng3c3RKRXROM3ByMVRzOUR3?=
 =?utf-8?B?NXp3NkZwT2F1c21uTVVuR3hZTWlJRVNOTU9ZVWloYkxZUVlLYjVsQlNFRkJh?=
 =?utf-8?B?bThHaHdLNVFSVjVNMlBPclRiM3JDVGhCeWFlK1hndGxjN2l1SllLaDkzRG1q?=
 =?utf-8?B?eGxyRGk1dlNlSlA2Y3R3RThuVng3THcxeUhGZHBlN0FLbjVGQkJ3cGtKUUU0?=
 =?utf-8?B?STNWTFBuQU9TNjYvQmIwS1JCNXdaNTJqZjBoN05IZk5GWEVXVXF5V1pISHRJ?=
 =?utf-8?B?ZFM3NjdrYXB2cGJLN1ErZHBYMmVBRnB4djF1K2FmeGFEVHlyNHlSNlY4OHda?=
 =?utf-8?B?c3RMaHJWQmx5K0JST3g4THlTREhHWFd0NlFnNndRalJTbUhJU05PRjQ0c3RF?=
 =?utf-8?B?dUhBbHBxWm5CenRvb280NmZJSHRmd0pCNGR0WnE0M1dLbHMxNnAvNDJyd2x6?=
 =?utf-8?B?ak9sNDVZb2M1bkZwS1k3QW10VTRMWFQyVUY3MENHQzNQNFJLYU81cHdDd2hN?=
 =?utf-8?B?MnZwS3JvS3BHZzlCeURuMXQ3djZZZHdENmVid1c4TkhJVWc3Z1ljbjlTZCts?=
 =?utf-8?B?d09CSmNyK0VFZjV4Ym1jaC8wUVArNDNvQXplM1N1bTNBMzF1djE3eUlGclF1?=
 =?utf-8?B?S2UxYlh0Y3ViWm5GMzE1YUEzbGtMT1ZoSnhlYjJYOURFQUZOSHpOeldiZ0xw?=
 =?utf-8?B?TWNrNklMVDExdms1S0ZJdDVhVkxCV3ZjYk9YS3NDWXdSaFlDUkVIclZZN0FT?=
 =?utf-8?B?akIvbytDMnlsS0hwckFLdWhPajA5S1ZmblZTSktZM2ZwTjFTOW9OUVZmOEZX?=
 =?utf-8?B?TlliUURRZWQxSG5IaS9sUjQwbGxHb0JnL2EvelAyTVArRWxzamtOY0pXNy9x?=
 =?utf-8?B?SnRtK3M1eGkxZHF6bzE4SU9JZWh5UkdvQURqa2lZcWU4czY3Mm1HRE13MCth?=
 =?utf-8?B?Q0IrYmtCSmZ5T2RvK3p4aDhOdXlCRDRBbWxLVlpvNWRBM1NOZk1zR216RmVI?=
 =?utf-8?B?MHZSUkg2aFptWG0vZWRUWGhOYVZWTkhLeXBTK0p0bkdpb1o5ZmFhdW90Qlhq?=
 =?utf-8?B?bXFSSHdqU2xSYUY5c1BGTlZtZCtTUElGNng1cXJFQm9JUllJWEVLaG1uaU5S?=
 =?utf-8?B?QWpmVWJRYVFKV3FGRG1PYW9LdWFrNWxJZ094VzByV2Jja1FYeUtGTHJhZ0Jn?=
 =?utf-8?B?eE9pZ1orRVFFTkxyaDJoR0xkRWFidUtvT2laamMzTDBwc1hrbllIcXg1dXl5?=
 =?utf-8?B?a29FRUxYN1VIVGl1ZW5mZ3R5cHFka09oUVI5N1NoT2Jpa0RJWkZRb2RmU3dV?=
 =?utf-8?B?Q3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79bea3c6-14b0-4f39-fdbf-08dd7c974a2e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 03:32:18.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YPvCEL+h8ft+gWnwXD4Nr0ZK/hFTRRhCTqYExbWmDecxXikHndM0XZontYr69JT4jhrS0/Fzb5Z0vOxSM/qI1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6502
X-OriginatorOrg: intel.com



On 4/10/2025 9:44 AM, Chenyi Qiang wrote:
> 
> 
> On 4/10/2025 8:11 AM, Alexey Kardashevskiy wrote:
>>
>>
>> On 9/4/25 22:57, Chenyi Qiang wrote:
>>>
>>>
>>> On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>>>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>>>>> mappings in relation to VM page assignment. It manages the state of
>>>>> populated and discard for the RAM. To accommodate future scnarios for
>>>>> managing RAM states, such as private and shared states in confidential
>>>>> VMs, the existing RamDiscardManager interface needs to be generalized.
>>>>>
>>>>> Introduce a parent class, GenericStateManager, to manage a pair of
>>>>
>>>> "GenericState" is the same as "State" really. Call it RamStateManager.
>>>
>>> OK to me.
>>
>> Sorry, nah. "Generic" would mean "machine" in QEMU.
> 
> OK, anyway, I can rename to RamStateManager if we follow this direction.
> 
>>
>>
>>>>
>>>>
>>>>> opposite states with RamDiscardManager as its child. The changes
>>>>> include
>>>>> - Define a new abstract class GenericStateChange.
>>>>> - Extract six callbacks into GenericStateChangeClass and allow the
>>>>> child
>>>>>     classes to inherit them.
>>>>> - Modify RamDiscardManager-related helpers to use GenericStateManager
>>>>>     ones.
>>>>> - Define a generic StatChangeListener to extract fields from
>>>>
>>>> "e" missing in StateChangeListener.
>>>
>>> Fixed. Thanks.
>>>
>>>>
>>>>>     RamDiscardManager listener which allows future listeners to
>>>>> embed it
>>>>>     and avoid duplication.
>>>>> - Change the users of RamDiscardManager (virtio-mem, migration,
>>>>> etc.) to
>>>>>     switch to use GenericStateChange helpers.
>>>>>
>>>>> It can provide a more flexible and resuable framework for RAM state
>>>>> management, facilitating future enhancements and use cases.
>>>>
>>>> I fail to see how new interface helps with this. RamDiscardManager
>>>> manipulates populated/discarded. It would make sense may be if the new
>>>> class had more bits per page, say private/shared/discarded but it does
>>>> not. And PrivateSharedManager cannot coexist with RamDiscard. imho this
>>>> is going in a wrong direction.
>>>
>>> I think we have two questions here:
>>>
>>> 1. whether we should define an abstract parent class and distinguish the
>>> RamDiscardManager and PrivateSharedManager?
>>
>> If it is 1 bit per page with the meaning "1 == populated == shared",
>> then no, one class will do.
> 
> Not restrict to 1 bit per page. As mentioned in questions 2, the parent
> class can be more generic, e.g. only including
> register/unregister_listener().
> 
> Like in this way:
> 
> The parent class:
> 
> struct StateChangeListener {
>     MemoryRegionSection *section;
> }
> 
> struct RamStateManagerClass {
>     void (*register_listener)();
>     void (*unregister_listener)();
> }
> 
> The child class:
> 
> 1. RamDiscardManager
> 
> struct RamDiscardListener {
>     StateChangeListener scl;
>     NotifyPopulate notify_populate;
>     NotifyDiscard notify_discard;
>     bool double_discard_supported;
> 
>     QLIST_ENTRY(RamDiscardListener) next;
> }
> 
> struct RamDiscardManagerClass {
>     RamStateManagerClass parent_class;
>     uint64_t (*get_min_granularity)();
>     bool (*is_populate)();
>     bool (*replay_populate)();
>     bool (*replay_discard)();
> }
> 
> 2. PrivateSharedManager (or other name like ConfidentialRamManager?)
> 
> struct PrivateSharedListener {
>     StateChangeListener scl;
>     NotifyShared notify_shared;
>     NotifyPrivate notify_private;
>     int priority;
> 
>     QLIST_ENTRY(PrivateSharedListener) next;
> }
> 
> struct PrivateSharedManagerClass {
>     RamStateManagerClass parent_class;
>     uint64_t (*get_min_granularity)();
>     bool (*is_shared)();
>     // No need to define replay_private/replay_shared as no use case at
> present.
> }
> 
> In the future, if we want to manage three states, we can only extend
> PrivateSharedManagerClass/PrivateSharedListener.

Hi Alexey & David,

Any thoughts on this proposal?

> 
>>
>>
>>> I vote for this. First, After making the distinction, the
>>> PrivateSharedManager won't go into the RamDiscardManager path which
>>> PrivateSharedManager may have not supported yet. e.g. the migration
>>> related path. In addtional, we can extend the PrivateSharedManager for
>>> specific handling, e.g. the priority listener, state_change() callback.
>>>
>>> 2. How we should abstract the parent class?
>>>
>>> I think this is the problem. My current implementation extracts all the
>>> callbacks in RamDiscardManager into the parent class and call them
>>> state_set and state_clear, which can only manage a pair of opposite
>>> states. As you mentioned, there could be private/shared/discarded three
>>> states in the future, which is not compatible with current design. Maybe
>>> we can make the parent class more generic, e.g. only extract the
>>> register/unregister_listener() into it.
>>
>> Or we could rename RamDiscardManager to RamStateManager, implement 2bit
>> per page (0 = discarded, 1 = populated+shared, 2 = populated+private).
>> Eventually we will have to deal with the mix of private and shared
>> mappings for the same device, how 1 bit per page is going to work? Thanks,
> 
> Only renaming RamDiscardManager seems not sufficient. Current
> RamDiscardManagerClass can only manage two states. For example, its
> callback functions only have the name of xxx_populate and xxx_discard.
> If we want to extend it to manage three states, we have to modify those
> callbacks, e.g. add some new argument like is_populate(bool is_private),
> or define some new callbacks like is_populate_private(). It will make
> this class more complicated, but actually not necessary in legacy VMs
> without the concept of private/shared.
> 



