Return-Path: <kvm+bounces-16705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 339ED8BCAAD
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A1081C21709
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:31:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F54A142621;
	Mon,  6 May 2024 09:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CH/jgnBw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584031422D5;
	Mon,  6 May 2024 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987880; cv=fail; b=S0Byo3ZlWuhNwsBuq3HWojU8PYj8fJv6pJlwMzquKEkVdxbQHSICZHzMvid1KBo+sr1Mt+ozEg9npg2M94rr6IGroHtApc/VEwMFBlp5oqIElRjvhQubUjk/j/W9muzkfdYghsO2ug1DuuEHLROcptJy3rG905/OAHLthDjKnEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987880; c=relaxed/simple;
	bh=7B4FvvqEn3Ox6dt3QiFLpK18lbxEO2UEfpEJK6c14Es=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ILgK5wa7gln3gVJIQi0jvA9Xya3WxNBu3mulkibUQIouvwHvkxUM5huUL+1xDlDtNFAe9hytHQn6zVCJjg+6Zu9LY8Lj9P8qTc07OZ2CheJ+RbcApGKzLMdxrOYtyMO1k0LIKODk/vQdJSyi6kcoHh7dcvqYHXOTCV5qorpBC88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CH/jgnBw; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714987879; x=1746523879;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7B4FvvqEn3Ox6dt3QiFLpK18lbxEO2UEfpEJK6c14Es=;
  b=CH/jgnBwatLOJNzhQaFt73K+kTDAb6cp8VwMcN0W/TCFV/bFdorYf6Fu
   mjWA3RUhjg3b8/+bI7yj+CTrHFLpkwsLr4oXzKyYycJuzPASXKcA9JC1v
   zO6/RBiJjs+2eRtTHCh4pC1DE0Nmhk9C3aGWDeR1RF0u82T1QUHlLf0qZ
   dZQveJit81/fJourhginGfyI00dmD5SiFcGB/ZbWaewm62N8VOVqzmgMO
   go+lIqal0GOie9j2skPMrgmjsRtOkZIY5wCNS15+kgIjTScIuu/Q+9L8a
   gcbvRVykZpFbp3BeTxJ55faAr9kCKkIW4WJV86SWOreD98yQ1NwweKR+o
   A==;
X-CSE-ConnectionGUID: sMBw03sjRdCM6blsFakDAA==
X-CSE-MsgGUID: ZG4M3sQKTYOtQMdizVWnug==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="10849706"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="10849706"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 02:31:19 -0700
X-CSE-ConnectionGUID: b6opHK0NRN6GlfaexHIqpQ==
X-CSE-MsgGUID: rLXghuIrR8W65CQ9KDyncg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="32918400"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 02:31:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 02:31:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 02:31:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 02:31:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGRb7Q5HbekxL3hDMKPTqY18MPp3DVawopmuRnhe4nKSmQWA14AbEY9UKnHpKgBS0tAl4dF09I1m0/IfMLWq2ZHo30AMu4lpe88VczUPIfEHX49O9fM8gkXjHqluGFFA2Ni7UOud2pc6jVvCCsab8dzem7OmQGsyfadbPLqxoWtjAVHnFGyKqHtC1XSzr4Z6EFbmDiPoE28YN8K02mlM460I2o+viXTVI+5Noo4PIxYkNss8vwnNtkD7bQPqAAG7hrCVWyNngd6vVljv2nryR8Uapr5CwuwgALGb1dBSboYtRzCAtSWoUzXKhs64MXbtDkcjkChReEP35F4P0vIykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ei+J8DPCp/SRb7wVJp4ySsWaSbZQZSNq9SlBOrEtWsc=;
 b=SzT4o6/HED9FHzL2TBBOE+QyXfbrXYJid2hSQLQDa4XpJy3cbUR0sESZGxum9ftrAzxIc26o+XsGTjqctTqm48Hx1DiM9D9UsVBH5kHfcnKqTKjWUaE+0HHNRvEX8ipVV0zgIqNJOnokAePa4AYuZ1GdFZQzFJmApjkop3VpfKnHFJwlEWNK+t4X7wxe1qESnSma6Vgul0SwAPcNjDvgYYRyfuSQmU6H2Yg04QpZ+2K9B1jHYkc/+tOmAwyI//KqR8ou7ZKoJ+4zfq3bcCbo4xTBOlnRtZwdOc1ZCRKvOGy+aIxYaQ79EKu6CNT0DTAmmwZH78MTMHBrjcGQnccJIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by MN0PR11MB6158.namprd11.prod.outlook.com (2603:10b6:208:3ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.40; Mon, 6 May
 2024 09:31:15 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 09:31:13 +0000
Message-ID: <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
Date: Mon, 6 May 2024 17:31:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <ZjLP8jLWGOWnNnau@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjLP8jLWGOWnNnau@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0242.apcprd06.prod.outlook.com
 (2603:1096:4:ac::26) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|MN0PR11MB6158:EE_
X-MS-Office365-Filtering-Correlation-Id: 7efe9a49-f2a2-4842-62af-08dc6daf455f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VUROMWx0V05OWG9IWEpkY2FLWnl1MHQ4REg4M0wxamd4OGtnTnE1ZVNSRUxL?=
 =?utf-8?B?SDJ5QTRadUlQUzVBaGlSWTFYWTRmblIxWkVWNHZ6WitQZVduazlLZHNtSWdr?=
 =?utf-8?B?ZnVFczRMb2VITWVhVXNVS3B1SWh3eG55NTk5OWpURmlPSTJzVjZ6cktrVUMy?=
 =?utf-8?B?STVpaUlSUmMrYTBuT3VoeFR1bUREeEFzTjNXUFFzVDBmYkg0RmVyWmhrMlRW?=
 =?utf-8?B?YndlcUtSR0tCSE5oZkRBNUZDZDNscG8zT1puL2dxbmFNMDRxM3MwRlN5WlRO?=
 =?utf-8?B?dlJVeWxMdU4rcEVzY1FNQ0JSYlhHNTVyRk0zbjJ0WmdReFVIRmlFbko0clE0?=
 =?utf-8?B?akhYRUs2TEZPUkwzREpXMDFOZE5IRHE0TjBjQmcrOWFDb0R5eFdmRUpVYksy?=
 =?utf-8?B?UG9BQmcrU1NVWFdxc291dXdRT0p2OHNwRE5pQmxBcGZ6enowM0pKSmhCL09C?=
 =?utf-8?B?Y0VWNzluKzNJRjNVRlVlaU9udWpPcVJ6cjBmSDJRMWtyN2tra2lRVjJ4RlU5?=
 =?utf-8?B?S3ZtUUl6eWc3M0htQ0xOSEcxMEhDSHEyV2tEL0h0dWhKa2VrbXozWElhai9a?=
 =?utf-8?B?VTVUMHNsVDNzQStWS2NWYVl5bmJwTDBoY0c1bWpaZDdrdTE5b1Zld1ZyeWpy?=
 =?utf-8?B?UHN1ek1IbkJvN1BMN0Uwa0tKMVlidWNCdHZXdkdraElCdGszSUxkUjhxa0VI?=
 =?utf-8?B?WXhXTmJLS29JMmM2K3M2MkVHQ2NYY0ZUVmdZWGo1YWhiSytZZVFISk9BeTRY?=
 =?utf-8?B?UVg1M2ZrcU54ODhkalI0dHZCc29YTXlKcmFKQWhORmJ0dnhwN0tmY3hNMmVF?=
 =?utf-8?B?eGdWa3B0UUgzOW14QU1jNThrelVqWXJmL0JtN280Y2VweU1zVFRXQjFOL0RU?=
 =?utf-8?B?UGNKakhDSXRYOU1wOU5pZlZ3dzFuYlBzZCs2N1plSTYwaHp6UTZlWG1PVGlj?=
 =?utf-8?B?azR4L28xTU16Z3NXb2pGd0VTNUgyazlhL1BRVlRzQWlER1UvZ0U4YWt3b0Vv?=
 =?utf-8?B?R1pRYWowalk5SFNoNzRhVGg3S3YxUW5Tdlc1dDliZ2pzRzZxMmJJaWZoZFFz?=
 =?utf-8?B?cjVlOWNubDJaNWlKUnN2elpHNVFUYTlzdnlzWUJQaEZHemwyaTltSnc3aGda?=
 =?utf-8?B?eWlVMC9YaGhVU2JFZzNab2ljdWs0NFlxcUVrVXdpekRVekQzV2lxdFhMM3ZY?=
 =?utf-8?B?NWN6eWFTYjBRciswSVQzNTlTNnJFMkdqYi9BQ3RYVEtGREkrRm13QURQKzAz?=
 =?utf-8?B?MHZlN20zN1c2dk1KZGl0aDRRRGtxM29sMkw3azIxak96bVArY09iMGZ3b0pF?=
 =?utf-8?B?RFNmVzdIQXQyQzk5bnlwdFFaRVl3WE1ZcDBXWTd6S1YzQ0VFaTEvSG9OL25t?=
 =?utf-8?B?SDAxQW0xdno3Q0Zud1ZZV1gxdEhTNHNFSFZzQnlib0VlZlBETFVuczJNVlQ0?=
 =?utf-8?B?Sk1UbWFIU2tabkR6ZFU2ZUdRWWVLWW9mdkpQbldUUjIyMlJob1A1OUQzQjJ3?=
 =?utf-8?B?ZFp3SDUzUXVPZnduWjJEWVFEcG9LS3BwNlBtZmdDSWp3UFIyUmtPTUtLbDk5?=
 =?utf-8?B?aVlMWElRM1YxaUkvNTdFWlZLTFkxemFwV0F4S0gvWTlGVEMrcG40OGZYNDRi?=
 =?utf-8?B?Wm1UbVdaNUlWK0FyZ3RvNVZ0RTVqRXBsQWpZMGNKeU84eThickVVY2c1SHNw?=
 =?utf-8?B?UmV3UURTQ0xJNml2NWUrWTFlT2dCeTU5bXBpb0VML0oxVDFJTHhTZ0ZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE8zYWhTZG1XQVFGc0UxeVhUL1R1MjFndGhiamQwSlgyN3dtODBuZTNlZ0ZZ?=
 =?utf-8?B?UmovMjdvVDhkY1Z6bjBYMWhkaHptQUZOeWtmV1FuczMyWWVHa3o4SlNndGFj?=
 =?utf-8?B?dmlsRC9rUVZoOW9MT21Ra2FNa2NSTnRpTDkySnFKRzY2UG1vV1lxZVhMc0dL?=
 =?utf-8?B?cjFrZCt2R01rUmRlNkJlZkJaVGNQK01uUVFqN1dSc0hYNGNDT244OGN2dGo2?=
 =?utf-8?B?V2tUYzl2Z3RvclBwbnFDOGtkZnQ1WXVPZzRRUmxta3BQcDYzc29CK1R3b2tx?=
 =?utf-8?B?VkJvV3ZDTjJBdnVnMjZ6azJqcFcwUzdnSHJNNTkrb2JjNlJwREhLMTJmK1or?=
 =?utf-8?B?QjNtRmsxWGk5WGFJbis1ZXkxd3dqbmx5OFB0ZVhJMFpRV1FlQ2NyQSt4Y3Vp?=
 =?utf-8?B?Sm9LbUVRRHltbmVNTlFzUE5XODJ6VWZlVHFKTHhPRS8yYm5Ia0h6elVIM3pD?=
 =?utf-8?B?UlFxeDMzVU1La1lGL0dkYWo3WHNFc1hqV0RCTGlaQjdpUGdVcjREcHhqU3dh?=
 =?utf-8?B?dGlsMlF5SXNKY1EvRmswUFVOd3hiTE4wOG1INUlOVUZaSzVXTUg1RjIvQUN3?=
 =?utf-8?B?WWxRSDg5b1kvdTZ4NzU3Mzlsak52LzM1cHdOTk05eVIxRHZTUmtVR2s0a3p5?=
 =?utf-8?B?c2pnYXN2cDZpR2MyeENQN2ozWkV4RVJuM2NSbGtORXpUN3E2cXYwVXNqM240?=
 =?utf-8?B?U1F2RzhVUk1wNjJoL3VLVzViT0RTZWJ2MlNnZ1ExNFFYSkd3NWQzbjhNUStL?=
 =?utf-8?B?WjRWR3pubENmL0xkdHRkTUttZUhlWjZvRkNBWHN6NEZQbkNoTlJaM2twYmpa?=
 =?utf-8?B?UjJnQ2FDT3RFZzhYcG81dFhJYkJ3MXY5cmhzSHJnSHplMWE5SGNFY0tFcFlT?=
 =?utf-8?B?NGpldDNLZkhTTGkvN3pZaXIxR0JQYVhpMVJzanFoMko0TEdwU1pMTDd6MjNO?=
 =?utf-8?B?S2RWRTdnL0hUZkRlbGlYSVFqdGlibXdWQWE0QlQwdkdFemxPQXV1ZkZjUXo4?=
 =?utf-8?B?RzZ2UTlsYXY5d0p2VGZRcVQvY1ErcU9pN21NK3kxQWYwQlNOS3pQbm5DNW9G?=
 =?utf-8?B?dzRqZUZyZWM2bG8vZzJyZ0o5TzRiSW9DOWRwUFU4aFVPdXZTbStQcmxTMDdW?=
 =?utf-8?B?cVAxc05DcEtwUmJPTXE5YkJkRDYybFF5QlJMb2J2N2YrV3VGUGdUeWJFTTFq?=
 =?utf-8?B?SGdZVXBRUjEwOEdmMU1QWjF6VkhxeElxTVF6SGQ3TVZkZG44ckRFeXdZWG51?=
 =?utf-8?B?SndHTmxPSVpNTiszdFFKaGFjMW9XWkIxcmYramFWSE9TVk9vZVF0MmxZWGFn?=
 =?utf-8?B?akpBOG9NSms2OVFyNXBYVGhtSC9uOEc1L0VRMjh6T1c5Y3BrQmhjVy9GM1pD?=
 =?utf-8?B?MWFTM3FEU2JMU1NlU1dvckxwM21KYTB6WWxCY3QrbnRIbmxBdVpIMERSTmZy?=
 =?utf-8?B?bnlvNFNlcFJPVHRSV0c1VTZpNHk5NG5uajJ5Tmpic2Vvajk3NlRud1NoeE9P?=
 =?utf-8?B?MlFtbTgvMWp5RzlUYlEvdkJFSlpydVpSc3BSejhZenFHR3JaM3F1NjFuYU00?=
 =?utf-8?B?VnRXWWV1Snk5ZE9JRmozWlM4M3pYS1J0Zy9jWWJQdGFiQjVqZVFtcEp1cTQ4?=
 =?utf-8?B?d05EUjlMSmhUNnd2M3I1ekV2UWVXdWZqRklxWkpMUGZkZytnalhpY0kzRWxa?=
 =?utf-8?B?V2lWWmI3Rm5wblBGcFVvbzdCT0twNE5HWlpMcERGbEhvMWVIWEduTmtjYXVD?=
 =?utf-8?B?WXl5SVk3Z25WUWJ4R1RkcndHS0VPWTlsMjMwV28wMkRYaXRubXpDY2luRG0r?=
 =?utf-8?B?V2xGUmpiMUxFcHExc2JTS1M3aE5sTFdLQjgyYTZ4NFc4SkV5aGpmNDR4K3ZV?=
 =?utf-8?B?TGpIbDY2cUJRL2pFeVN3a3pvbWhJSmRtQ1RQTS9VV3pTajlHS3NoY1N2UTZH?=
 =?utf-8?B?RzFMc2NlWU9QTEZMRk5odUxsYmVmSEJtcjcvMU12MEE3dlI4aXhGeUx5MnBs?=
 =?utf-8?B?UFBrbGhCNEN0M2NORWxBR3g3elczMlpNcDZPSlp3dkIwTThWU3M2NWtXWkpx?=
 =?utf-8?B?UnMxSlcvWWdEQmhGdGh6M1Z4Nis5ZkVJSVlnRnVRS2ZoTVN2SDViQmVzcklL?=
 =?utf-8?B?amM5MzNhVERQVmhWVnR0V0RXY0VDU2tDZTdER0VsbFlNSndPZzgyb2NYNmRx?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efe9a49-f2a2-4842-62af-08dc6daf455f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 09:31:13.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cg4n9KuuCuhNhCQcHNlyPzKI5fJThSMYqFpnw8fLvDH00GOEwGtYaEDh2/kPWLgg6PKaGb4zTOKwoCl4HrkNiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6158
X-OriginatorOrg: intel.com

On 5/2/2024 7:27 AM, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Sean Christopherson (4):
>>    x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>>      __state_perm
>>    KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
>>    KVM: x86: Report XSS as to-be-saved if there are supported features
>>    KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
>>
>> Yang Weijiang (23):
>>    x86/fpu/xstate: Refine CET user xstate bit enabling
>>    x86/fpu/xstate: Add CET supervisor mode state support
>>    x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
>>    x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
>>    x86/fpu/xstate: Create guest fpstate with guest specific config
>>    x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal
>>      fpstate
>>    KVM: x86: Rename kvm_{g,s}et_msr()* to menifest emulation operations
>>    KVM: x86: Refine xsave-managed guest register/MSR reset handling
>>    KVM: x86: Add kvm_msr_{read,write}() helpers
>>    KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
>>    KVM: x86: Initialize kvm_caps.supported_xss
>>    KVM: x86: Add fault checks for guest CR4.CET setting
>>    KVM: x86: Report KVM supported CET MSRs as to-be-saved
>>    KVM: VMX: Introduce CET VMCS fields and control bits
>>    KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT
>>      enabled"
>>    KVM: VMX: Emulate read and write to CET MSRs
>>    KVM: x86: Save and reload SSP to/from SMRAM
>>    KVM: VMX: Set up interception for CET MSRs
>>    KVM: VMX: Set host constant supervisor states to VMCS fields
>>    KVM: x86: Enable CET virtualization for VMX and advertise to userspace
>>    KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery
>>      to L1
>>    KVM: nVMX: Enable CET support for nested guest
>>    KVM: x86: Don't emulate instructions guarded by CET
> A decent number of comments, but almost all of them are quite minor.  The big
> open is how to handle save/restore of SSP from userspace.
>
> Instead of spinning a full v10, maybe send an RFC for KVM_{G,S}ET_ONE_REG idea?

OK, I'll send an RFC patch after relevant discussion is settled.

> That will make it easier to review, and if you delay v11 a bit, I should be able
> to get various series applied that have minor conflicts/dependencies, e.g. the
> MSR access and the kvm_host series.
I can wait until the series landed in x86-kvm tree.
Appreciated for your review and comments!



