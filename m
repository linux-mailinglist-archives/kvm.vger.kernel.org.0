Return-Path: <kvm+bounces-14901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9A18A7770
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7DE61F22B15
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D8078C7F;
	Tue, 16 Apr 2024 22:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NHk7LpGK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F6B1DDEE;
	Tue, 16 Apr 2024 22:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713305180; cv=fail; b=gB09Dd2+IfkvFoSrSd+WIn+YvXkIa4kOvnfJWxWKKnSdqKyTttbEfrv3wp2k3VxtEeYx9choECKSNBKHCF59eIluC4MMUdg3tkxAdj1beB+WQ6AhTrI65CBMT9fQtwaUK6cj6fnD6Oyyf/pqJerdENOQwomP/6g1cuv+JpQ9F7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713305180; c=relaxed/simple;
	bh=z/CP8rA8Cyg/3D9IAaZvO7SNQxFd2IIyL4NJHJC/8IU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=inP0JKwmO2ldxG74hkC/4dqvGAW9FI3J8bTfkX2uKoEPtzXBu4JMurI5lOZZ8W5WBMmVdrYYdx67iAHkM1+LXm2ew6u3ODb5r0vaqt4wHfJs7Nd5601/KafYYNGGjZ+gXneF0tHlnwR3Mn3+LhUmF5/4icqvhkqXnj3iOWru4mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NHk7LpGK; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713305179; x=1744841179;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/CP8rA8Cyg/3D9IAaZvO7SNQxFd2IIyL4NJHJC/8IU=;
  b=NHk7LpGKQyvSHcJhKeHpQ2olfUHFd9cLmmHeSQuJmelIgbCdvF1IWbkg
   LySq/bm5DJgujbUzewvMW1pdOq/HonBuIwaEg7iIACrx1WRXgXz0mTOw3
   6Yu10MxxDCoYrpvi4gQBxKGaqgqvTNLQ1siBT1Om4k63mjQ+fy8Dl/cLC
   m1KmCWsbAXjY2aecWo+lmNF2n++k4NpJkbGXOhzHy+JWMOYeRHEr68S2Q
   KvMdV5YLWNXng2K1QjaY7H9QT2ghPVkgmNJjCcpvI4JKE/rtlnbbD0chC
   3yV2UcBoypOP9u8C9ZDOzGjaYT2myhhLczPbdzoLGg9hnKb6wbXGdXmPy
   w==;
X-CSE-ConnectionGUID: L2R4QUPSTUudlo3d5U4hiA==
X-CSE-MsgGUID: CrLxziSiRFODMYQxZJfDIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="34162246"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="34162246"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 15:06:18 -0700
X-CSE-ConnectionGUID: rERuwALbQoOgeWVcAqzakw==
X-CSE-MsgGUID: qZ6AdF8NRgaQvhQV8kRcMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="26838909"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 15:06:18 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 15:06:17 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 15:06:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 15:06:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwZw1FbdifVVMTdzlMyHLRIo8KjdrcJ/ilUlP2dl6j+7Z2lq24gnsxyMgnl/cUX6yQ1DNQ6V8XrWQ3yf5HDEGWw189k7vUsB9TECxO2w9GVSBamG476oFRFwS/1kwyg8FvpxfEFlpWWv4EtZ77vcPSlkqMq6yRwtmeVIkDnDl3tiKco+YSHC4vS2/cI9BNKBik1vaAfLp/AVANICzJstl/ByAQxy2Dz0yQzvafofIeiDnFVpaypOiVf51j7VmbtJ2AMWIhakCiXwAN62ZSHclbMGqavfRr+cj7eXNAC1SnFIakb4I8+A4g7Yvtj0QJCYribiiAckPs6JaVmQBzelFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H8y62Km2twqI+8iHNHbvMellDR0dftkl6cS/4AweA0M=;
 b=STkFeYjHYdfUDoKw18xrtA4vdSEK9k98W//wRTzQkR0nF7ODwhjf2rb+Jaa0ZD2oP4MCBA37VsiSgdAFBeNlVRz7w9ohhCgHx7szht8twIAs9z2+1Q2vB12ZILBwMx48xB/iMQ/mEKmZN9Jbu0zkTQQgyucdCi4w8HbnaM+inUYNVS9P+5mOLuPUyx4xunvh1bbH17qse93/QmUQ+FT8/n2BrBRym97CFjDMXPjGf1mGQzwojpzi7yDVP9akBY27/pIspbdT6HQrJgghTCP5xNnY5mutXyvD3x30mlcXSGSpAGkb0A0Fl03BnihnM9s9ztpzr13PGAf4ZRYPms4UkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7755.namprd11.prod.outlook.com (2603:10b6:208:420::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7430.46; Tue, 16 Apr
 2024 22:06:14 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 22:06:14 +0000
Message-ID: <e0713aaa-0537-403b-9abe-db267e21f0b7@intel.com>
Date: Wed, 17 Apr 2024 10:06:03 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: Isaku Yamahata <isaku.yamahata@linux.intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, "Li, Xiaoyao" <Xiaoyao.Li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
 <ZeGC64sAzg4EN3G5@yzhao56-desk.sh.intel.com>
 <20240305082138.GD10568@ls.amr.corp.intel.com>
 <34d64c12-9ed5-4c63-8465-29f7fdce20dc@intel.com>
 <20240416162829.GX3039520@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240416162829.GX3039520@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0009.namprd16.prod.outlook.com (2603:10b6:907::22)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: 96275577-5444-41b5-b82e-08dc5e616eb6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qAFfdbIAyOdV2qw9rhhpr89mfRGKjHLpgSV2stDahqlKIYF7dlxsMD6c0b2XQmzMaQX2Mtdu3racaR7wC5nzDEV9Y3mUwYY89FsPolrMC9Qu0GM2InTLYyj281YxjdgxEOhwN0Z73MEKKzdbHEntQMbCP2JMeQTLmDZG/gF0umEIxP8lj5ML9ZmoGNsEdP46mIgUmg3GMkUdp6NzHzmx/y/T24mcosbI5RQRWyRGmD+plFELjADR8uHkW4a6ztjhQ/gdmHvg5u0/FCcD1ccH/8nJxWRj6RAXcdUm95XdXpaaVxKIthG95YIFWUI4EdNbL0wDp3jq7e8vfSSuAmqikjU3CzrS+TP5rGEjaUgqXNgMZDsqjiIgDJyD1U1tW1XlDOthdeY67m4zhCCmpCCKkVPFlcu/BunYy3nzdmwB904IFeYztkyrBUZYjZjmTCINONErNiShcQUMdEWDiUUMh6POGs7R7pZsZhecdxGyGzO6x+g6bCNO90HML4yQODql0GtzWs+jl2KpV3KMaf+vMQTETO7U5aen0cUR+Q7bKKZ5NdC5n9I2LDuY+X/DucqQIfL7DUrWo0YnbTFeXpfyqlB6KuTJqwc2jEG7yAqOBPy2w0gRH7uGRqgpaSAH8W6LHNi/9bFiHLkDcxsPHEy4BckHPlfDyn8PxtpbgxPkBjI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckpuUDF6QzQ4aHY5aURHZDVETlVUSjlDeXplREF0b20wdmRlK0lScWIrdTFs?=
 =?utf-8?B?dTk1a0NWNWoyeml5dmIwdmxRT0w2NXE2VlExR2NxRUsrZkpEeFI3QW85UXFZ?=
 =?utf-8?B?ajQ4MlhmSkxUZzUxRGt5NmtDZ3ZCWWxnWnlVaUlJalg0N1VENnZBV0dOQ1Ex?=
 =?utf-8?B?MlBjeEZ4Y3daRENMbnZxTWRlOVl6cjZMUi96MytNYmgwRzRHZTdYWXZ3aWtq?=
 =?utf-8?B?cGZNVTdVVnNyMmx4L2l2VkZaM2ZOWkt5cm1ucXYraVlVRElpVXlMeW16dkw2?=
 =?utf-8?B?NWpTM3pEeXRNZnI5cDFoemlKdkJ5dmo2Q0N3Tk1IS3JzekE4TXMzd1kxS3NX?=
 =?utf-8?B?WnFqWTkveU0vYzdHRkxIdEptYnVSWkExZHBOS0N0WVlZbUU5WXFadHgrcHA5?=
 =?utf-8?B?TWxyTDYzUTQ5NDlickJOZG55bkdGeUNXZmRmTExERGU5Mi9OL3ZFQVNUNkJX?=
 =?utf-8?B?VU8zN1VITUNHT0MrcEMzWndORFY0VXJRb3dZOVhqRHVrSmc5cEpxVzgvK0dV?=
 =?utf-8?B?eXdmcnpKZnFWdUZ5MTIyd1RQYlQwZm5ra2FlZDhrQUtCZUV2L3FKL2FSWjZn?=
 =?utf-8?B?RWQ1M2RBQUU1QzR3UnltWE9ibjBnOTZKL3FCTllkOUpUOEg1WE9JMVp5NnR1?=
 =?utf-8?B?Wk1HeDN1Ujc3emlSOUhlbkR5RTNGVUZhMjBrNzRBS3IwcmRBRFJlelZuQWho?=
 =?utf-8?B?TmFiU2dWYm5zZ0ZHbmdZTWgrejh0cm5TZk96NDNvTWRJZ0dXZExwbHlYL2VQ?=
 =?utf-8?B?aWd4ODFORDJiUVRXemI5WEdGQ0RodEM2aHlYL1B0Q1FpVjN2UVNmQmlJTFhr?=
 =?utf-8?B?STZ2SjhMcHNjZHp3aVdPdmNVdTB2T0ZUL0RoODU3dGExYUdMNkhvejloZFA3?=
 =?utf-8?B?UHpJYkdTZGt2c1BoVTBycERiZnROMTlvQ2NYNVIyM2tZOUZveWRSUHFiTCsx?=
 =?utf-8?B?bitUSk9BMnpianltVzdFckh0c1U2cjlrNGpmeENmRHlYT29UcnBONTV0NCt4?=
 =?utf-8?B?STZ1djZQbkljM3piSFhyRGpRb0IvOThrNE5TNkNGcHdzUTZWckZ6SXdlU0RF?=
 =?utf-8?B?VVBTWmY4cDIrQ3Npem5tWlEzdFFwTXVINnNwSmRoME8wZ0V4WUJySXdZeVB5?=
 =?utf-8?B?bmhGWVZzTVhRMzRlNTVpVEJVdHI2OXU5SnBVRnFYOXFrS2xxWmwwd3lMekEy?=
 =?utf-8?B?dG5XRjUxZjFLU3NMQlZMUHVDNk4wT1JjaEswcm9lQ2J1eHlTYS9GNWx4MDNK?=
 =?utf-8?B?bzh1QnZIcHM5ZjV0TVRST1VnYVB2SWJROGMxVFNTQ2NSQks4VGRqVEpXa1h2?=
 =?utf-8?B?VnNWZUJtZXQrQzlreU5BNi9vUldNMmtPTHIrSURKNU5wQTZhWUJ6SkJXZDVH?=
 =?utf-8?B?K3VQZWtjYjIyMFFCQkE3V0cwaVZnRzlVbUR6VktYcDFNQ2wxYUMvS09rZUo0?=
 =?utf-8?B?WVJyeThzN0xVRWFRaGovNU91OU5oNmZVK0EvNklOeTA2QzNGZEpnN2lyaFMz?=
 =?utf-8?B?b0J4WWNIdDBUTnZXcE9iS25pZEt0NDNaNExzc3dZNHU5WW5JK2tZb29Od2Rz?=
 =?utf-8?B?ZXA4SStRc3FVN1hVNFc1Tk83OCtWMUJUaEtGMlVSZUNPM3RBeHJyUnNpVTFt?=
 =?utf-8?B?cG4xcTQxZzdLNVIyTy8rRmtyZXMzZ1NhMmQrRWtCNm4zWG4rejRGT3pKcjU4?=
 =?utf-8?B?MVAwOTVYS1c1VmxJd3JKNXJQeG1DSW9SRWQ2YXFOdlMyNHdYSWRLNXZPYUxX?=
 =?utf-8?B?V2p4clh5UElkTVVrdm9JYXhvaHZrY3JoOVpDNjlUam5nTmg3Z09wOUJmcjRh?=
 =?utf-8?B?SEphc2dabDFEamZoanUydlZ6b2RybCthaG5hdm9PNEt6U2tPZ0RscEorb0hs?=
 =?utf-8?B?ZCtyNTFMOEFWNHA2NGpwVWdMQTRRczM5SnZzOGV6OEd1dkJPbnRPNFJiVmlH?=
 =?utf-8?B?eVlObU1jTW53V2ExVG1TVUZXVHV3ZkZoTUVrRzJOZnQzc1Nnbzd4ekI0Mk5m?=
 =?utf-8?B?bjBwRHZaVENyVG56RTRXYmlDMHVRWWlqQUF2UTB4M3Q2bDUyaUQvdTUvemds?=
 =?utf-8?B?Z0U0ejNZbWVPNDBvQ2tSb0F6UEhmMER2SlUyUFdFT0JDYkFoeDFVRGdwdWpP?=
 =?utf-8?Q?a3optrhEVg/dqPzStdZxKSIAn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96275577-5444-41b5-b82e-08dc5e616eb6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 22:06:14.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zc+3t/d6bVAgdusxiZQDpVg3w78WPNnyzFdBxO9N/bbI/MRvi7rqWdLSDdBIzXDsi5CBcSQR5M07wT1bBLbrFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7755
X-OriginatorOrg: intel.com



On 17/04/2024 4:28 am, Yamahata, Isaku wrote:
> On Tue, Apr 16, 2024 at 12:55:33PM +1200,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>>
>>
>> On 5/03/2024 9:21 pm, Isaku Yamahata wrote:
>>> On Fri, Mar 01, 2024 at 03:25:31PM +0800,
>>> Yan Zhao <yan.y.zhao@intel.com> wrote:
>>>
>>>>> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
>>>>> + */
>>>>> +#define TDX_MAX_VCPUS	(~(u16)0)
>>>> This value will be treated as -1 in tdx_vm_init(),
>>>> 	"kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);"
>>>>
>>>> This will lead to kvm->max_vcpus being -1 by default.
>>>> Is this by design or just an error?
>>>> If it's by design, why not set kvm->max_vcpus = -1 in tdx_vm_init() directly.
>>>> If an unexpected error, may below is better?
>>>>
>>>> #define TDX_MAX_VCPUS   (int)((u16)(~0UL))
>>>> or
>>>> #define TDX_MAX_VCPUS 65536
>>>
>>> You're right. I'll use ((int)U16_MAX).
>>> As TDX 1.5 introduced metadata MAX_VCPUS_PER_TD, I'll update to get the value
>>> and trim it further. Something following.
>>>
>>
>> [...]
>>
>>> +	u16 max_vcpus_per_td;
>>> +
>>
>> [...]
>>
>>> -	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
>>> +	kvm->max_vcpus = min3(kvm->max_vcpus, tdx_info->max_vcpus_per_td,
>>> +			     TDX_MAX_VCPUS);
>>
>> [...]
>>
>>> -#define TDX_MAX_VCPUS	(~(u16)0)
>>> +#define TDX_MAX_VCPUS	((int)U16_MAX)
>>
>> Why do you even need TDX_MAX_VCPUS, given it cannot exceed U16_MAX and you
>> will have the 'u16 max_vcpus_per_td' anyway?
>>
>> IIUC, in KVM_ENABLE_CAP(KVM_CAP_MAX_VCPUS), we can overwrite the
>> kvm->max_vcpus to the 'max_vcpus' provided by the userspace, and make sure
>> it doesn't exceed tdx_info->max_vcpus_per_td.
>>
>> Anything I am missing?
> 
> With the latest TDX 1.5 module, we don't need TDX_MAX_VCPUS.
> 
> The metadata MD_FIELD_ID_MAX_VCPUS_PER_TD was introduced at the middle version
> of TDX 1.5. (I don't remember the exact version.), the logic was something
> like as follows.  Now if we fail to read the metadata, disable TDX.
> 
> read metadata MD_FIELD_ID_MAX_VCPUS_PER_TD;
> if success
>    tdx_info->max_vcpu_per_td = the value read metadata
> else
>    tdx_info->max_vcpu_per_td = TDX_MAX_VCPUS;
> 

OK.  But even the SEAMCALL can fail, we can just use U16_MAX directly 
when it fails given we can see clearly the type of max_vcpu_per_td is 'u16'.

if success
	tdx_info->max_vcpu_per_td = the value read metadata
else
	tdx_info->max_vcpu_per_td = U16_MAX;

So I don't see why TDX_MAX_VCPUS is needed (especially in tdx_arch.h as 
it is not an architectural value but just some value chosen for our 
convenience).
	

