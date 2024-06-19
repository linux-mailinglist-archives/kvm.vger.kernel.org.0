Return-Path: <kvm+bounces-19933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57B3F90E535
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 10:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B469B21507
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB76778C66;
	Wed, 19 Jun 2024 08:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FFUoW77r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1850817C91;
	Wed, 19 Jun 2024 08:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718784444; cv=fail; b=edDC/BWnyjYJRvmCmOilr21ztB6CPcGWD3F8LN2lnveUJYHWE4CGMxCY1OdyBxmwYu3VZPyjW6Fxc6gPiBeBIy6K1YQMsjgyLVB/HovGi2E5eOimyMRN3++ROVbj/WBCZa5HjrZoyfE6K3CWvyV1+5HZgRbLq629PcNcL67/Kus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718784444; c=relaxed/simple;
	bh=LUfDMLoR+Uu7MTZHMPZhl05kKKOzuG6XQlozwoM3NuQ=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C8VLmPjiCvcPMw2dyBUIDpMlm6tMen6Ezq8rgpQQlwYkOIFp/e6yEXigWMBirCd9sAyUU3rhb/Spv8So78w9/jiX+66nKJUvYX1YVLZY1PoQxX+028H8RZ0M2ibUT8oQbrE7q11ol9xIzXiryo152knbKBLCWOjmpzhHZpZKiAY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FFUoW77r; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718784443; x=1750320443;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LUfDMLoR+Uu7MTZHMPZhl05kKKOzuG6XQlozwoM3NuQ=;
  b=FFUoW77rX6gi+ipaDMItge+tX70VPO7aOuAMTIiFSMhh6LawNszzx5OG
   oyuq6mHZJhBWjuoKqeKbuDnMEGlfmouTYiCIa6AgzSp5RrgjFliKhdilS
   eqQdihVlreWXFbZOqaqTOElNJjJySzHrPGHdsrCFkbrStIMAC0pSdxQeN
   cfRFW8wVOBHPUG7ixlkbRTvZmYlAtccyX+btlW/hwiMRmOlMBYrpZaRch
   zMhkWLW/VQYvFheTefxWxz+Oy//7rCh2b4ZyM5Ca64gGoGzfBPwk8l3Rt
   PR836ZVVxmqbF1QxrRqNpP1Hch7aU1vpQoqY2URHduf2ISfZpReKci5wM
   w==;
X-CSE-ConnectionGUID: dkXu8fSiQiKUnaB7mrCLcA==
X-CSE-MsgGUID: bng89M+NQlGTEqaEb5/Hrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="15540609"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="15540609"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 01:07:23 -0700
X-CSE-ConnectionGUID: xBZeiK7tQh6xBVFON1alGw==
X-CSE-MsgGUID: +2eeDVv1Qh+u8M7hWaheNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="41938981"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Jun 2024 01:07:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 01:07:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 19 Jun 2024 01:07:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 19 Jun 2024 01:07:21 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 19 Jun 2024 01:07:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8yJRwI1JOk65WKSmk0iKf9wPa4Q7BL26rUg7DUoogtK2pHfntuFjetXjQDTE3Y8OGEFwkSJfaUOgnWHKwy6KBllVNAFpB8X0NINflxkVS6VHTus3M/C8n2SJ9FMRUeeKS/dmcQbB9Ae64ex7F0MGA7mY/QRoKgmc4HjX7j3MMhG6sY762Yb3otzBhb9c31JbyF8PrpGU2FQ/sU65eUubXakEuiGECXFvIil0jBwduXVbAOtBFZ8BegZ+5ioCKLb/zf+EV9LrpuU6/dLna1FTKJ0+1jxabPzvl1AwV+sJTS5ZPvBjI4FRWPn5peIt32itIKDyDiTJyoaiJy1OFoAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUfDMLoR+Uu7MTZHMPZhl05kKKOzuG6XQlozwoM3NuQ=;
 b=iz/c3uDrcmeZaYQ6op76GNbTbJBTeW8tnEx0hb4dXkmrMyiKlgpM9ZfwHgcW3Y90QaWh+0Ko85tW53XFvelpmxvTrTWRkSMjCUkz/b6pF84XOTERMro9Uo37u+7Sg1QP0KP2qYoDY/Wx9Swf/rcm8gs0Rk7lq7lW7ADf8G21JjZTx2/+3fDv8XYaCbfWiY6rE23x3WMLusF/+735rYaEWn384P3eEakwjis/kvXBlVlIQRJPsVZh4xcskwrAC+ZCsAz1CEmjjdPkUG0FF4Le7cgkU0wUc1iAXVJtbO3rD+PNh92qbksC163VVC7z5BDwtZ1gHRRYahm+reRdYmYLvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV2PR11MB5998.namprd11.prod.outlook.com (2603:10b6:408:17e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 08:07:19 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%7]) with mapi id 15.20.7698.017; Wed, 19 Jun 2024
 08:07:19 +0000
Message-ID: <ac52515a-164c-4ce1-a930-f3b9ffc6df3a@intel.com>
Date: Wed, 19 Jun 2024 16:07:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/49] KVM: x86: Account for max supported CPUID leaf
 when getting raw host CPUID
From: "Yang, Weijiang" <weijiang.yang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>,
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>, Robert Hoo
	<robert.hoo.linux@gmail.com>
References: <20240517173926.965351-1-seanjc@google.com>
 <20240517173926.965351-19-seanjc@google.com>
 <cb6e3c03-547b-4223-8dd4-3bc2e4fd4dff@intel.com>
Content-Language: en-US
In-Reply-To: <cb6e3c03-547b-4223-8dd4-3bc2e4fd4dff@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0035.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV2PR11MB5998:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5c7868-0739-4939-053a-08dc9036d74f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZE81MFU3L3dZYnN5REMvNTlRR242WTB0WVdKd2N6b3ZGU2x0V0hMTnUwbERX?=
 =?utf-8?B?aFJ4RzRSKzBUcjB5b1I2Vy9oeGovcjVBem43d2pDWU1kaktnTGFxMGxaTHNQ?=
 =?utf-8?B?NTRJbFpJaHg2Wkw0NHdEYkxJMVd3dmdhakFSMm5PeUdHSEIxb3lEeVp3TkNL?=
 =?utf-8?B?ak5ZTmlZYVJyWEt6Z2QvS3RjVkpINnZkYVJzQ1NnTGhaWUNnUDVLNTlqRDFx?=
 =?utf-8?B?N01idTM1NkNEVm1Jck5RdXBtMnNaSnE5bjFjUDdGOTBVMENscjdnVkVPWjRs?=
 =?utf-8?B?YUV4TVQxZGFJajB4SDdkU3ZwZkhjMjE1OFFjSk9GMXFHalF1VUhmTE1WbjY2?=
 =?utf-8?B?VDY0NFkxeFYzclRYdVVHYnZhN2tuNTVOeDd6V3VBc0kvMmt0bzVhWXBRRERs?=
 =?utf-8?B?SlR1L3V6VGZTZ0gzLzAyVGJhL0ZLYXB5Q0ZsZFhoQ3ZBcGJZSTZGUVhGZnRM?=
 =?utf-8?B?dzlveHJ5ak93T01SM09YaFB3b0gwRXZicGZ4SDVJMjk0Slc5TUhFTGVpcWlM?=
 =?utf-8?B?UmN3NktJYW9YaUtISHRFTzd5UU1vWCtsZkpFOGVVT2gvdWJGbjBYbmpxc2dR?=
 =?utf-8?B?aXVIN2VENHhSNStMcW1BNGRKU09ybUZNNXpmS1VWUytWOHNieG1HSXhEbk80?=
 =?utf-8?B?ODNlOFc5RFFrdnBhaXpQYWhUamRqbWtVWlQ4bHR1UGdhTEdPNHRybnNkOWlj?=
 =?utf-8?B?ZHdGb0hqVHNMN1FrWDMzUXNEZjRUM2t5Q1dUanJ6Z2xpQXRsZVBsWWFLdXVL?=
 =?utf-8?B?a0RvMUNOVHhidmJXNGNYNUZUMy9sWjBtemMyeFFwZHNOTEx1M3k2cThXSGdV?=
 =?utf-8?B?ZXphUjNZZzFwSFhtbWxnUFFmek1mVVBSdUVGRnlFVHIyd25uQ2V4dlRIbmF1?=
 =?utf-8?B?UU5OTWgwZzFOR3VXSDhEMTNCbW1tc1drNC9CcDd6QVBWc1BqaTBDS0xpMWJt?=
 =?utf-8?B?S01wR3hkZ29laDhrTFFEclVsSnVDTXhwQk4vRXJuVEg5TW8zQlFRZjdBLzY1?=
 =?utf-8?B?aVdhNHhTQVowcHZ4Mnd4RnlMWjFWcklpckhKQUJ4UUZiSS9qY2pCeUVnNW1X?=
 =?utf-8?B?Q3VVc1NmUklJSGlRVzMxNk5MOUozM2pDNWFLazh2eDFzRVZWS2VpcHNzTzVl?=
 =?utf-8?B?VEFRaFdYNUNDS2Y2TUozcHRJbloyS2x0WkhoNkxwUzRtN2Vaa1JvQ0gySWly?=
 =?utf-8?B?aDNIcUZrZ0tFcmthcmJmQWtHdm44NUtlcVdpVTFZclJ5VCtKUHp2Y2NyQlRs?=
 =?utf-8?B?Zk82K2kwcmQ5eVQ5NlpoVGo3UHRYMGhTNkVpcUNWOGNua2hMM2FpVkNRMUNj?=
 =?utf-8?B?YjlZUThnOGNQSnRmVFVjYmx1TXd6aUhmUzcvaUR6TzI2bTZ3eUVzbVB0bkRt?=
 =?utf-8?B?TUFOMTZLRFFGeG5sL1VrM2ZLYkV1Z0MxeTRtVmhkbG1mOTdIWHJ4bkpnRlNR?=
 =?utf-8?B?dW9RMndsWTMzNlMyTGpPeXFDcUlRRkdjd1JCdm9qejByalRoZHpTRmhqNlU3?=
 =?utf-8?B?NXBsOWRRR2tLc0hjbFJzQWxNL0FKMkVWektaMnl1R1hmR28rMEVaNGlES2w3?=
 =?utf-8?B?U3VJaTJNbGhUcE5SU2t2UlpTcEgvL0RNVWJ1dStYSVJHYVVQN3FlcHoxSC92?=
 =?utf-8?B?UWcySElwWUhEVlBFcGptUmhoVUtxZHVQb2VWVU1FSEhqK005dEdnM1VzK0tB?=
 =?utf-8?B?U1FHVmlFMHZKUnhPbTFCWGh4U3EzY1FNYjZMbnpBbVF4T2RiWkNDamFLWmFk?=
 =?utf-8?Q?7skiMt+9tGOILdp28cA7PozDLsTDHLn9Mpmdanb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bis4Ui9Rc0tOUEtFRGhWRjdPdHZiamdYTXQyVUl5bkxPYXBycnArY3labVZh?=
 =?utf-8?B?djN3ZDVsS2o1QWZGV3BJNnY3TEd2UThZdWNIUUVSL1lWdkhXYkpVYStiQUVX?=
 =?utf-8?B?SWh4OVFERC9ETlFnTzhkVFZhMUo4Slk5dmNzQm52TWRncGtmL0hLTllnMEhN?=
 =?utf-8?B?N0h6ZnpJdmdCcXBmemxDYWhuTEg0akFHdUdrMHk1SHVha1REbEdFbWYyWGZq?=
 =?utf-8?B?MHEreW9KN1dhbmRQcTZjRWNWOEk2d1cxOFB0NHlCbnFaazdLZUlKOEVsZUxx?=
 =?utf-8?B?ejQ4S05najIzSlY5NmE1YXV6c3gvdnNNTURxZDczbkFDdHJMODZmcjZKQ3Rn?=
 =?utf-8?B?VVoybG1vcXZhdmp6THJoSVY5MXBpYksza1EyZ1Ryb0RCYm5WOG11OUlpK29p?=
 =?utf-8?B?RUcvUGVkSmRxOUFGTk92NlNEQlJzalRoejcyNFpIMFc0UTd3QjFIcEVzY09W?=
 =?utf-8?B?VkVxWkpJRllrakhuMFlmbDlTM3Y4ZE1vS1VsSG00VGFXczRjU2lJa2h6ekhK?=
 =?utf-8?B?L0txUzR6ZWtzd3A3REhoRE1kT1UxeEFINGRiQ21LOXdTWlJobE1rUjNVM2Fq?=
 =?utf-8?B?cEh2dytlSkNPcTcyNjE0eEhZSVUrTmVSeTFPK29LMndoVmR2UmZ4RnJQdlZh?=
 =?utf-8?B?akxRZTBVckNnc3Y3dGRPQUlmT3VVQ3p6NUlwNFJieXFyandHaXYra3dOa1U0?=
 =?utf-8?B?cDFvYXNhanVPUUVmblI0ZGhjdlQ3N2kyUUE3OG1NT0tNOHUrUFQ5aDZCS3Fm?=
 =?utf-8?B?bzd3TEl3THliZFF2ekxrWDVnNE8rR2VIdVUvNERISGZJcVVkNEhWS21IbVJT?=
 =?utf-8?B?ZThIdEF4ZzZxWTRkTzBvTVhYT3hUZ2xsSzRJWW5WeGl0M2RWYWQ0VDBoemxp?=
 =?utf-8?B?dVE0YTNVcVczd1I5TURZRWE3eUxLdTJOVnlxRlZ3ekhESHkyMFhJampoVWpt?=
 =?utf-8?B?Ym1qQ2Yzam03bVMzbDdpaThPczIwSjB3SktxNW5XUmk4anVVNThweGtLQ2VK?=
 =?utf-8?B?Q2MrNU1VOXlERmI2VFBWNW52NWhheWJRTWJwWE9QOHNEOExjVjAxeDJLLzVX?=
 =?utf-8?B?ZU0zRHNHeXJRVVZvUVhMd2s4Nm1LNmJPUXYzOWt5ZjZIb3R5ckg3VWZzcGg1?=
 =?utf-8?B?UFRTMFVYY0tFUmM1cGNkYjQ2SmVOM3hLR0VnZVpoOG8yYzRoUmR6SisyMDRT?=
 =?utf-8?B?S2ZFVWFIaXNRejlFTmFSdEl5NXlDMEoxWXpqMlFJRjNVaVV0Q0gxSzFlWndR?=
 =?utf-8?B?TkI1YnZjd0ljZFpoS2YyWkMzcXBST2ROcmNmZ0xLVlhMRHB2dEtWcTdhTFJI?=
 =?utf-8?B?OVRhZkhoWG9ldnJQN2h0dURGekpHSWVKU3U1YVBlSTBGVXYzT3BEL0hjbDFO?=
 =?utf-8?B?WG50ekVoZnFuTkFKTUZKNzNFWWtGU3JFUTN0NzcwN3g3T3lodlUzSVBDbTk2?=
 =?utf-8?B?RkJYVkNWa1NnZE91TkpWdS9BdTU1WXFMR3lJeFlNTDF1VHV0Q3NtSG5WWVAz?=
 =?utf-8?B?TDFtTDBpVkxjNWliOVlmMXdjZDR5MXJnYkQzUTJrTWUxMEhMcFNuWEMrVGxH?=
 =?utf-8?B?RlNwMGtpbXdxQmJkU0dJbVZDdnJKV2tseWczQzhkbW5ObGhTWmRkZnplRHU0?=
 =?utf-8?B?azFOdDNodFA2OWhHU2RxbDZlTlVmRWRtckY2REpUQkdOVEp3NjFxQVBLNE16?=
 =?utf-8?B?Vi9ySitqL0JNUFpTNlBuazZRVEFXdFIrSHRYVEtnbzFjalgzbFU5RktlVzNi?=
 =?utf-8?B?Q2pCVk84ajdhWkNxWkM4QjZ0RjhBYzRpU29lNTgvVmpwRjYxeDdvRFJQMGJl?=
 =?utf-8?B?VzNIOENaSWVVRkFLeWUyb3Z3SGUzRUNmYTZFcktNTmQ5cUY4ZUhnRjJ4blVR?=
 =?utf-8?B?STJlTGkrRVBoSXRSMGlVRlozYWEyUjZDRjVBT1RBTjI0MUhlWmh2MVV4MUp1?=
 =?utf-8?B?b2NtaWJWM2lXNU5wbmVtbVRnUTJKamVCOU1XL0VJQlg2Sm12ZWM0alB3bHB6?=
 =?utf-8?B?Z2lXZUcrZzl3OFhhcXVvdmpoeGhIQlQ1R0R6NG1aWU1ZYTFIUUs3NVVaTHQ4?=
 =?utf-8?B?cC9yVXBLV1N5akh4VVFKZVR4VnNFSWc5NGsvZVJSQkUzWUpJcVUwUHVnRnZt?=
 =?utf-8?B?dFlvUDdNc1VhaFRuUXhmRVNLMFZ4YVgzYXNPaWNkZzBPV29paVd1eG1ockNn?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5c7868-0739-4939-053a-08dc9036d74f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 08:07:19.7735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: di3yECIeiIkAllCCwnrhkbQjaPtGSRcOFEt/5VtQjFwFy+JRq+mIDfzjmETb66by1Iz9zNV0LTBmrcrRAv1W2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5998
X-OriginatorOrg: intel.com

On 6/19/2024 2:17 PM, Yang, Weijiang wrote:
> On 5/18/2024 1:38 AM, Sean Christopherson wrote:
>
> [...]
>
>>   /* Mask kvm_cpu_caps for @leaf with the raw CPUID capabilities of this CPU. */
>>   static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
>>   {
>>       const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
>> -    struct kvm_cpuid_entry2 entry;
>>         reverse_cpuid_check(leaf);
>
> IIUC, this reverse_cpuid_check() is redundant since it's already enforced in x86_feature_cpuid() via __feature_leaf() as previous patch(17) shows.

Aha, I saw the function is removed in patch(23). Sorry for the noise.

>>   -    cpuid_count(cpuid.function, cpuid.index,
>> -            &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
>> -
>> -    kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
>> +    kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
>>   }
>>     static __always_inline
>
>


