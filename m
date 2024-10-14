Return-Path: <kvm+bounces-28823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D6399DA14
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:22:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C74031F2324A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 23:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAD91D968D;
	Mon, 14 Oct 2024 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="euohplkT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C6B1CBE82;
	Mon, 14 Oct 2024 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728948168; cv=fail; b=E5D6RjF1FAyk8ho32XhmlW8XDFj9aQXaZdLYjokaHXoLizOM4VQMibuciP2DuGsbuZ6E8TvfSpk5hc1qofx6eZKQyP1ZiDUGNUBR3EmofE/HwqsN+uwg7BULk13rhkfeMZx1stm+/DfaQ5Du/Y0TVAfx7Pw4E1vgK7eC47BuClY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728948168; c=relaxed/simple;
	bh=DtFL2kfezP2UE4RvnhZdqwmHjZunRt45cXg+09dHPtM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J7oHLCw2ZmZZ/IKLJLRyEc6EfBU04nNfVh0jWM1lr82L0U5CslSVUyQjTbY9hOG5hJJAy1A5oofJf71eVhGKx8DNYtpoyj9tQhRyzSCZYJxkj2Uswt4vdM8Azt6kucDe3ebLpux99WZUeDWz356jT30FmPCWKfMzFd4Qj7qc/ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=euohplkT; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728948167; x=1760484167;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DtFL2kfezP2UE4RvnhZdqwmHjZunRt45cXg+09dHPtM=;
  b=euohplkTtR/OuzIpXUAIA7Gcruj9SxW5WDAaNV9bTV5AjPeIKvqv14jV
   TnUolrqyNWTfuYSobxS6/wvlC4XqzFCaYhQp/Awqbjn4/xVpjZ6ksAT/B
   5plnxNlfwRZhZRWnYx/F3/q/fdPGyMHmltfQufFdCR2dM4GaAOOVW0Pg5
   iSxq7RkXhb1p/GwjT1AUJ908y+gFxvWinJx2Pme/biz7ZT1+Gy9m/fixc
   NhlD5dhUG+VLm9H9xsuihgaqzDGUEnIvv6U+KKpDgl17pmbBNKbUEXoJI
   Lj6b3KX6RjMsUm2qQp1zYM6zfdKT7wxfGtW+awkjFGrh8gwZR7URXhgex
   w==;
X-CSE-ConnectionGUID: 8qLdN37/QoC0JwcRsY568A==
X-CSE-MsgGUID: 46zDZ7KlQhmhP8YPqxXXDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="15940683"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="15940683"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 16:22:44 -0700
X-CSE-ConnectionGUID: Ep3BZcApQh6e7HsVIPZp4g==
X-CSE-MsgGUID: GB1eP2STSaq6YaXrjz1weQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="77720198"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 16:22:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 16:22:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 16:22:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 16:22:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 16:22:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GmUjMSur2Kag6CAZQot/NRMfuMc4GRoAa99QiSpIeUwB3EVSkEnFu8vMxLqr+PCevgl8v9R4P0S3WzQItbSGQpP3YsbWDkQb4kVkGPS3lVIRVnYeQFzYMVUZpxx6sHRbuoAbqMU2K4YMliMb8vQSwQtHgt4wgOj2xIAo4htL3p7ip3DhiU1lERVMH6EaCahdgdSrqd7Whm8Wg1DuQRmHpLK0LuF/AuaMyAH4qz5xua2ZlmP20M46SIip74JVCivvdcTad4gCudNrM1vyYyegXxPlQlxyfv6BVAtkyNgT/amtei4hBuqwZP2irhxHDmI47Kj/A8zG3T2M9sFv6eeIEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhenzZJAtZOSJ5sCk3pznLzHgRkgorL64xYrnFFXx0w=;
 b=XatN2Cv3kVrRzJpxrvNscN6ZCB3YZumM5mdT/DqhaIs9az8Q1w0EgwU8kVcAQYmgs4ZnMcYg/pj+aGjpXP4z6MWXH9Ss3+/YLjrS1tdqNyagXe51cqDzN2ooqBOz/vcplodGvyjAItmI1WgQGOnrH9EvduIXp188RZIYIPOTdmMuo6NdRDDij7XWGL+mjC5dBptaaXBTVseTzxSXhSI93/uvSIDOvbbd9FFMrmeZQ6WMwiOu9pTOgOHfzbOFIKBnKXEUuOxqT+26qIubJAUSkeR57IEvEByHkyd0rSRIvPx2DKym6hNfQFWLZmsL/w65Doqev/uQhSn1z0P1i5EUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5226.namprd11.prod.outlook.com (2603:10b6:408:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Mon, 14 Oct
 2024 23:22:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 23:22:31 +0000
Message-ID: <931cf82a-a375-4c6c-88c5-a4cd83723711@intel.com>
Date: Tue, 15 Oct 2024 12:22:26 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] KVM: x86: Move kvm_set_apic_base() implementation to
 lapic.c (from x86.c)
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20241009181742.1128779-1-seanjc@google.com>
 <20241009181742.1128779-6-seanjc@google.com>
 <d09669af3cc7758c740f9860f7f1f2ab5998eb3d.camel@intel.com>
 <Zw1rnEONZ8iJQvMQ@google.com> <Zw1znGMufMEL-cuw@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zw1znGMufMEL-cuw@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::30) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BN9PR11MB5226:EE_
X-MS-Office365-Filtering-Correlation-Id: e31e11cc-3d28-43f8-11a0-08dceca713d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UVJUVGE1Uy9uUjhQMEhJWDBWSWNXa2pJVVgycTZ5WVRvdTlDTm05V2U5ZmtZ?=
 =?utf-8?B?VHZuYUozZ2JOaG84dGFzQVg5TUU2K2o1NXNEYUEwelkvdGpCN0xlL0haRG15?=
 =?utf-8?B?UkwxajRhbjBMZHZwNTNqRHBBMmVISzRpdkJPTXN0dnJrWFk5LzM3RGo0YjZE?=
 =?utf-8?B?VGUybGJrSklnNGNuclhGV1ZJYm9wUm80ZWwxYVVWMCtXendyTmtIYUFUUEtD?=
 =?utf-8?B?MnlUV0gyWWVXZGNVNEdiQ0NqNFRsOFN1N3kzMnNNaEhjbkt1eXpwZmo0R1Fm?=
 =?utf-8?B?MXlUNWZTVlYyRWduTlJBbWRZRCtnL2lsZDVuaG5EL1dKakh6YUc5N0Q4SGhp?=
 =?utf-8?B?TkttYTQ1enY4ZnExRy9Fbm1QcDk3bHFPdGxwaSszK29SNFRUQWwxOWluSXAz?=
 =?utf-8?B?cEk1LzRtMVQ3ak1jK0g2K0pvSVhPRFJOdC84d2ZEd3YrblEzL2JnYWF1eWo0?=
 =?utf-8?B?d2x4dWpmOGErQkgwVXpuanJPOFpVL1pCVmhzOHQybEc0M3pvZ0NJZ3BSWEx5?=
 =?utf-8?B?WkVSK2R1b3hiQnZnUlJFalRndVk4bHVIMVoxbElhZmxXUDlyZGlZdVpvZ2k2?=
 =?utf-8?B?Q1pvRUNsREl2Tk5COERtNVBQYjMrSWErTUR2ZysveXFPVFpsd3pLRElYOFls?=
 =?utf-8?B?bTVGbWFCZkJ4U05rTHU1ZHJ1UlY4VXh4cmo0RXl2TTFtYVpZdS9id1dXS1Rw?=
 =?utf-8?B?NWV6QkRqRDNpemFQZEs3M2pHQTRWcnNpWklKZHU1bEU4eXN6RGVXRGFNd1U0?=
 =?utf-8?B?dHV6SjF3VFFUbjlWZlB1bWhOZmJqTXF1UjBWU1lsZk5uT1JjOTVSQTM3WDdp?=
 =?utf-8?B?c1M2VmJ6QlpNRkl6OGJQWlV4bXk2eHl2T2lZOVJmVURoVFdGSEplU25wRGoz?=
 =?utf-8?B?czYyeFlNYzAraWxnWk15aFFxdHE1YWhVVEQreHpHZ1hZbm1zZEVXOFVGMnh0?=
 =?utf-8?B?ajgwbC84S2k3Nld0OVdpa2FBZEtjT1NiWnZDQUR6TXFWamhzUFRKQzJOY2l1?=
 =?utf-8?B?R0k4T3pyTnQ4QkRyU1FYckNyUnRyejQwQS9LYW1BbXB2NDdVZVpoK21CNWZV?=
 =?utf-8?B?NjVRdmtDNzBKQVRqK1RGczNlYklVNmw1R2J2UG9wN2RjYi9CU1U1S3kyZFlI?=
 =?utf-8?B?Uk9tMHNNNkRBMS9na1ZLUmRVU2N5c3prUjdlMVNGU2RnNEl0R3lvdFIxZ3JI?=
 =?utf-8?B?RHFOZC9NcWIzZHZzSXY3a3BCUlhMZ0cwNVlSNmtzNGp6SER2NzErdmIxR2Fv?=
 =?utf-8?B?UThuMEtza3U0dHI4UkM0dGJxNnE1bWU5Qm5aNjlIZ3ZNTnZ3NHZvclNNTWFz?=
 =?utf-8?B?bGxTTVI1UG80eitSM05adHBTeFlVWkppamhRZlRBNUJXMXdGeFZiS1BnQUx5?=
 =?utf-8?B?akQreXpSQXd5L0haZmE3YmJjc1B6dUhHTlFXKzdadWlpV2tXekRWMVBvWFdK?=
 =?utf-8?B?RnJ6NmVQNlBRUkpyS1VKVXp5VXBoVUV0V1JEa0ZHWVQzcWo3Rk93bkIycktN?=
 =?utf-8?B?dTRMNUQ2djhFemNBK0E5N3JQeDJ4Umt5SGVRUCtGU2d0eFlLSGRpSFM5MGNZ?=
 =?utf-8?B?eGlXWTJkNnppN21yZFFLY2tlNmQ3SklubWVrcjdCbkZPQWlVRlJLOWFiR3B0?=
 =?utf-8?B?TGFTaGt4YnZWRjJoL1NyOGpBdGt2ckxtWmpuR2NIM3ZnaHJDZjNPUHoxL2k2?=
 =?utf-8?B?bWdwYTBOK09MdGJvQXg4RFJudVBaWDhFODZIeHJaYk9pY1lMOUFwZTBBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWFRYkpQZ2dVZXlMQmNTNmRZZXRKQ3ovNW15NDVBSHIxc0hDNXQ2aG5LdUdq?=
 =?utf-8?B?cUpNeUpuL2NmQ25Gd3NSeVl1V3BLWjVVK1dLUWZ2SG1KcnlwanQ5QzBlVHlL?=
 =?utf-8?B?M2c3bDZJbGFCKzlkM28xRmtQei9iRXV3ZEJONW1MNmcwbVdZTFdmUXhqN2hF?=
 =?utf-8?B?NktCeEVHc2VwMWswZWVZRWhWdnJ2ZjBkbGdlb3l4RzBiamw5SFZmUlo5Z2dN?=
 =?utf-8?B?cjRWditNYU1pQiswY1k5dmNYNkhlTEhib1luTUk5Qk43dXhvNHN2a1pUUDBx?=
 =?utf-8?B?T2RwWHNIK3lzS1dTV25IWVRDNDBmeXJMeDVLRVkzVkg0b2FRcDFWZVg0eWNE?=
 =?utf-8?B?SE1CbmNjVmhqemhSajQ0SzN0MU9EVjZSMmMxU3I5Zm4vZXFzeEw3ck11WnIx?=
 =?utf-8?B?cUNmbjAvTTRXdEZwdlFXWFF4Z2lzajNqWmZYR2FWOGxoVWNyekcyNHR2M1dh?=
 =?utf-8?B?c1RwNkIrbC93Tks2cy9mNGtCUjZJcERsVEE2MVRRVjEyMlRNUTlUZUpENWJj?=
 =?utf-8?B?bjBCSjJYWGpzOVJrbytxa2pneUtHdGJZTWFCMnVhK0dWdGdkek1VU2pXVTFV?=
 =?utf-8?B?WlZvd01CSGNtVDVnYTloNjd2ZFVjSTR1NWVBdU5iZlk5OVBDb2VyQmt3ZDAv?=
 =?utf-8?B?Z2VDM3h5RlludklMMlRkcG5FZTZnMXRvTzVWMFE0cjBEQTlVL0xqZm9WSVRh?=
 =?utf-8?B?dnI4bUMrQ2x4Ui9YVmoxOGhhcnBmTVVCdURFOEp2WnFGdXBvcVVGWFFoTGFX?=
 =?utf-8?B?dmd4ZHBIV283M0FXKy8zY1NBcWdVbEh5Rk1hdkoxNnlpQ1NBUHFDZzZJbC9m?=
 =?utf-8?B?M0I3M3VUNjlJalR1WktNOSt4blJiVnBSRklFUnpHNkp3TGwwNzg4WWhPL1JU?=
 =?utf-8?B?ZEMwYnc5QStoQWY3OCtLR0c3V21DMmdrUVpHRjd0bTRSd1I5Rzk3ejgrQWlE?=
 =?utf-8?B?enp3VmQ5TGRyZEQwSG9JRWtsb2Jyd0dVdWRlMVRVVWlzRjRjVHNxY0pzbXRN?=
 =?utf-8?B?b05iUDZqVm0xdVQ4bjFNcU1uc25hOUp1M1F1YWJ6Zktpd2xKbUZFQklTVDMx?=
 =?utf-8?B?eUJQZ3gyWDBqMGpQa1VYc0M1UU5GSnliaGV6UHkzR3hjT1pSY2srUjlKNWwy?=
 =?utf-8?B?em9XMWF3eXBzUlMvODZtZU03TDhIM3JWZExVVWFVZjE4cE05cS9hS1FwNHZm?=
 =?utf-8?B?Q2hma3VPdFpUVXNVM0ZmYmZpS3Z5c2ZFOHNva3ppYzlPRisyUm5OT2QxQ210?=
 =?utf-8?B?eCtTTGRUQ1pXMVI4aVBxUFcyMW9sNjcwWWhxQlNJYk5BZGo1K1h0NGR4VzZC?=
 =?utf-8?B?cHBjYlYvbU12Si82VXY1QmVYVnJaWmh3ZEVzaTgvc3JIZndmNFBRYzlyRlha?=
 =?utf-8?B?ZE9XT296TDBQa0ZhVTRqRW51TElRR1YvSFZwWVBpcXFUTDFQaTVraHBUajQz?=
 =?utf-8?B?ZHhFV2o1dVZyN3V1MU10c0lJRUdneEdYWlBpRWdJaFF0TGxQREJkSmt5cU1x?=
 =?utf-8?B?bEpmN0ZTVnE3V1h5M2luQWIwY0NkeVI3a3Z2eVlsOVBoTU9ibVRhSm1WUE5V?=
 =?utf-8?B?Z2hWMnFkUWxEcUZ2ZTRUZVNlVWpiZUptcTBDazNodkNIYldWMzRzLzRBcFk0?=
 =?utf-8?B?d0VJamRxdVQvdWE1WnFZNjBiUUlPM04rWC9id0RaZU5YcnlQOXpETkJFUitK?=
 =?utf-8?B?ZzQxWTZ6UG80dTYvVXZ1K05YUXJlemFpZWI5anhka29lQmE4NXhnYVZ5c3BV?=
 =?utf-8?B?RDh3SEtEYzZ3VHpWeWdDVnR6UnpGWmxwb0U1UXppMW5GaDdyZ1didHFZSldM?=
 =?utf-8?B?U0V3RW05cnRPSlFoTXR1engxZnpUdWtvMEtMd3hreW9qWWJ3YlovSEFOWnVj?=
 =?utf-8?B?M1l6bzBqQ0ZGdlQrUGJHRGllUVFJcFdCMURqRVdGMjRRMlY3NmNtRlAvSGdH?=
 =?utf-8?B?T0dUZyt4WjFtTXozdGg2VDI5RzBRWmlOdVFMRlU2RTVDRnVmdkkvRE9EbUpy?=
 =?utf-8?B?NU8wRjJMVWVEZEhRci9GT0hXK05VeXZJS2d2TGxiRlo3czN5eVRUYUlXU3Vo?=
 =?utf-8?B?YkhaZm50bW00MFFXejA3Z1I1eHprRnkzMHVTd1k5RjAwWkRzRmlzWk5vYm5F?=
 =?utf-8?Q?jUOOcbxcI2/bvonvxnfBp5uWJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e31e11cc-3d28-43f8-11a0-08dceca713d6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 23:22:31.7030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avBSmjsNYj1IipnCtHEsKZM/eBv7+NMoy5X7bOCrCwS5n7W9Wn9ntegov/pPe6S9/niJqC7y9iusXuLfG6A0sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5226
X-OriginatorOrg: intel.com



On 15/10/2024 8:40 am, Sean Christopherson wrote:
> On Mon, Oct 14, 2024, Sean Christopherson wrote:
>> On Mon, Oct 14, 2024, Kai Huang wrote:
>>> On Wed, 2024-10-09 at 11:17 -0700, Sean Christopherson wrote:
>>>> Move kvm_set_apic_base() to lapic.c so that the bulk of KVM's local APIC
>>>> code resides in lapic.c, regardless of whether or not KVM is emulating the
>>>> local APIC in-kernel.  This will also allow making various helpers visible
>>>> only to lapic.c.
>>>>
>>>> No functional change intended.
>>>>
>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>> ---
>>>>   arch/x86/kvm/lapic.c | 21 +++++++++++++++++++++
>>>>   arch/x86/kvm/x86.c   | 21 ---------------------
>>>>   2 files changed, 21 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>>> index fe30f465611f..6239cfd89aad 100644
>>>> --- a/arch/x86/kvm/lapic.c
>>>> +++ b/arch/x86/kvm/lapic.c
>>>> @@ -2628,6 +2628,27 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>>>>   	}
>>>>   }
>>>>   
>>>> +int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>>> +{
>>>> +	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
>>>> +	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
>>>> +	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
>>>> +		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
>>>> +
>>>> +	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
>>>> +		return 1;
>>>> +	if (!msr_info->host_initiated) {
>>>> +		if (old_mode == LAPIC_MODE_X2APIC && new_mode == LAPIC_MODE_XAPIC)
>>>> +			return 1;
>>>> +		if (old_mode == LAPIC_MODE_DISABLED && new_mode == LAPIC_MODE_X2APIC)
>>>> +			return 1;
>>>> +	}
>>>> +
>>>> +	kvm_lapic_set_base(vcpu, msr_info->data);
>>>> +	kvm_recalculate_apic_map(vcpu->kvm);
>>>> +	return 0;
>>>> +}
>>>
>>> Nit:
>>>
>>> It is a little bit weird to use 'struct msr_data *msr_info' as function
>>> parameter if kvm_set_apic_base() is in lapic.c.  Maybe we can change to take
>>> apic_base and host_initialized directly.
>>>
>>> A side gain is we can get rid of using the 'struct msr_data apic_base_msr' local
>>> variable in __set_sregs_common() when calling kvm_apic_set_base():
>>
>> Ooh, nice.  I agree, it'd be better to pass in separate parameters.
>>
>> Gah, and looking at this with fresh eyes reminded me why I even started poking at
>> this code in the first place.  Patch 1's changelog does a poor job of calling it
>> out,
> 
> Duh, because patch 1 doesn't change any of that.  KVM already skips setting the
> map DIRTY if neither MSR_IA32_APICBASE_ENABLE nor X2APIC_ENABLE is toggled.  So
> it's really just the (IIRC, rare) collision with an already-dirty map that's nice
> to avoid.
> 

I think if the map is already dirty, the other thread that makes the map 
dirty must be responsible for calling kvm_recalculate_apic_map() after that.

For updating 'apic_base' path, IIUC it makes sense anyway to avoid 
everything when 'apic_base' doesn't change.

Calling kvm_recalculate_apic_map() when 'apic_base' is not changed has 
no harm, but logically I don't think there's need to do that, even the 
map is already dirty.


