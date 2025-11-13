Return-Path: <kvm+bounces-63091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FCF3C5A867
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2C01E347786
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B35328608;
	Thu, 13 Nov 2025 23:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="exQ0Bgur"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B915327209;
	Thu, 13 Nov 2025 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076171; cv=fail; b=nMbCPCxwgaXc1hT8cK0CwwfRNo8e74YxMF5o+SdX9XApdazJdfEB0DV/aibEv/NC1O7WxtweLZPhWXFW1Nu6RNn8r1Apt8YuImOwX9peuQj55RywgJZyuerBZw6un6XIZE1sbhg4GzXNfGr5ubuYu/Q1uncL1Sqqddb33jJJDs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076171; c=relaxed/simple;
	bh=qr6ExwgAIrTcu5iPXgGaaMy+E4CNiKMkEDYCJx+hHKw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KUja7ATAAyrA/XiMnjAbG5/qx8L+mwFQSM8coqUITCTuNpl2DgZK1rwl4eDgif1yq/OFkfo0XX8n/XZ4VZmbRHnZOPDlB2ub4Lu/PL9iYpYkWLGH/YiED4doL8QFoalp2qthPwf6iOA2/ReFFLKgktOAAbjgsHhNQh38FEl+s0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=exQ0Bgur; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763076170; x=1794612170;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qr6ExwgAIrTcu5iPXgGaaMy+E4CNiKMkEDYCJx+hHKw=;
  b=exQ0BgurLytOqBdUX07mbNauqL5UtJlFKI7QUoGngpTkmwwtaHBLNqJq
   u/N66n8ZO23Gq07AtUCZLkEe1X/BI6/9Hr/Z/elMm5C1tUD2cLv3SfbgI
   xYhUXYJCyPC51N2W9GYiDVxLZ9s08e9AYemMpRBaVhGeqkbEPICRvIbkG
   Nr+yzEtFndub97oAaOuMYWe8/UWvEjpMY/VAPw10EJeRocw96kaQ4rx+L
   Kb9b/S899erConucfw8UDmCAzy+o4iDDC3ou1cUUqFJJ0sVn5OyZwV+2M
   lEr5xFotT9qBoaRKlDYKH2a1eTtnaL9bejkxIHXjV/o3RwKKko2lfVvyh
   Q==;
X-CSE-ConnectionGUID: js1OI/8DS6WA0dkgHQKw4Q==
X-CSE-MsgGUID: Gf3QPkBtRcCDwceBYem+rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="75777560"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="75777560"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:22:49 -0800
X-CSE-ConnectionGUID: pN2QBLFySSqSNqz8DKi2AA==
X-CSE-MsgGUID: WOxkF0SZSruRtg4Y08O4PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="194066514"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:22:49 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:22:48 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 15:22:48 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.50) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 15:22:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v7FdbRmZfOPEdQypV7WzmrsXkr4y+N9jJfs+l9WBPt7HfKtViQU7x/149lz17gVhi8qEXe5kZDOogfApi+FVcrja6XPVjxRLE/wP5CxdCCSs7NkVj9hIlzOus+2xmf6TlfRr0x/MNEs6Ox/FlPy1RBYC1u9pyHeOMm/K4OqeUYrdLwjpnUbHEC5GVrRJI3brV4RsG8kqg2U1wFtn9egJFnwlfGi2+M+uA4dvgBLI0SulwSRddKVLDzc+72j2A1uEdY1aNmeN1/p9sOpQt5QsFIpwr/iq+jxIa36K4SB/OwAgSXO0gMdoLbdNE5ydrxOieqWumdtIt+vjHpoJ1YBQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ExtaMZYIAoNvPn59TWJQXLzbXv09GbC35Ychb5PXT4=;
 b=xH++haN57TjBpDd5edsVcBbq6v0Eutk/X09YfG/oyBFCvPK71g92Y+HXf2IgbkdZKpX9mJSmhS+2heA1jEpFZ0/DTeHOhWd2zbbh+62/4OiqVO3aEWrkYcfjdrgKUesMONvKvFH1WIWDu7zMe/8s1IDwdRhTpw5oMawA8i3OaDWRxREvjJDCZMEmzU8i46zG/VL/bqiqK6SvwYKfaG96reRLriINUuk/TePIjUtV/0yhvBCDXGTRuwXX0EbOCZ3Bg+ISxZJF2mRwGJPWMAaJcq1Ezr6ouwGbrz7msrNA5jdnBbTzOyjg49v/YiRjMbPB9Rwa7lNwsr6KJnQtFGgvcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CO1PR11MB4962.namprd11.prod.outlook.com (2603:10b6:303:99::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Thu, 13 Nov 2025 23:22:38 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 23:22:38 +0000
Message-ID: <b27f760c-e17a-4cbc-b9e7-fefff07d16d7@intel.com>
Date: Thu, 13 Nov 2025 15:22:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 08/20] KVM: VMX: Support extended register index in
 exit handling
To: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <seanjc@google.com>, <chao.gao@intel.com>, <zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-9-chang.seok.bae@intel.com>
 <7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <7bb14722-c036-4835-8ed9-046b4e67909e@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CO1PR11MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d433e7e-d9fb-4e88-e150-08de230b8912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a09jUWxHSnJwaVk4STBjVGptQmdMamRiUHIyd2hXNzcwdUk0RlBnaHVlc1NN?=
 =?utf-8?B?eTNZTDBpZ0dXNzA4T3hqRVpBL3FLd09TV2dWY2tEa2o4M1lNRU4rL21ZL2JO?=
 =?utf-8?B?N2lMa3FOUW9PT2JJR2JaMTVpWDcvdVdQcE5HSjU2bTloU1ZJMlM1SjJOcDVV?=
 =?utf-8?B?SFZ6K0p0dXJqVDUyTjlWRElnN1VubGplSG1hdjBaL0NBWkdDVnFYb0ZWRnlZ?=
 =?utf-8?B?QnJVbmZQVURIaFhabjdoOWZ1Sm5LSXpsV0lUVG01bEp6aFFaNFVneDAwc2Fa?=
 =?utf-8?B?ZU83RTgrTFBlUUVZZDQxSDRsZ2VINXVGTmFwc29SNVl5VDRtNG1QMUdZbVhB?=
 =?utf-8?B?Mzg0UDVkeElhdTlGWmpENHdKYS9xYVR6bzF4UVpMQ215dWNEZ294UUp1b2FZ?=
 =?utf-8?B?aUpjUUwwaU5Yd0dTbE92RjZJY2paUHRCWURJQldhVEtEODFBMkd2YkprSDEv?=
 =?utf-8?B?MVVRQ2N5YlZIZ1ZFZk5Ud1dkbXpOTGpQUDFGVGl1d2VraEZubE52UUJWT0JI?=
 =?utf-8?B?QXlQNWZaTmpJa0NYalFVTkRnQUdpLzM2Vjd1QUNRQytScmt5MUk5Qno1eDRs?=
 =?utf-8?B?bnBVcDVxd0Fyb0NHQ3NnZmxhTzVpajJQRmdBMDlVell3bWlRdUtWVXZ6cG1w?=
 =?utf-8?B?Z1RtVFNBcEFVbjBHN1Vxc2U4ZTlrK2xKTy8za0hBakY0cU1OV2FwaTA2eXU4?=
 =?utf-8?B?Rm51R1lqcFFKK0lDQTY1S0VleDltaXRORnFnUUNTNXk5MThXMVVHT3llbVJQ?=
 =?utf-8?B?S1plMmx3akJBZUpNMEtFKythSkI4UExjNW50UkxMbzFFQUNYd1JqSTVVRFZu?=
 =?utf-8?B?WHdONmE1TDZIR3VmcEpUQnpzalpsaDYvUEp1SHBFMnZ1RUtKZS9yQjNuRzFH?=
 =?utf-8?B?SUZvelY1OGhtMFl5NnpVK2UzNlc1UGZxaWFBSDFhQXY2QlVmSGdKZEU1aVBi?=
 =?utf-8?B?cDZnZHN1SXBHdjN4TGpveGl3dVpNcGxzbk5oTE1lY0tHTnY5NGZQT0daa05R?=
 =?utf-8?B?RFk0aUxYZ2tnSUh1Q2lWZitpYy9TTk84a1A0SWJxYXJWNmpraVJWZWltQXF5?=
 =?utf-8?B?UGxndmpYYXJKR2lZa2ltNWd1a3R5ZDZKcEVDQUxEOFJmaGZCYzd2ZjFhVUNK?=
 =?utf-8?B?MUdodkVsT2pKVW1xZzVVU2dCWDhkRkp1dFdwWnp1T3pocjJtWDRPN2RsNE45?=
 =?utf-8?B?c0xEY21EM2pMSURJNWh5SFVKZEREVnZDOXpUR3g1VU15Zkt0Mk44L3hjT2dm?=
 =?utf-8?B?ME9QZmdsZWpBM1A5UmFkWm1SSXllRUNIQktpb3lOd0xYRkEzNkVFNFFNcFMr?=
 =?utf-8?B?dUpMQ0M2YlFSaXROV3dyb3dLQ0FkSjlqMUlkek4wZzhuakZBRmRRRnVaamZ3?=
 =?utf-8?B?dmFuNU1MVTZEMWIrUHJ0b3lyMXRVdlNXdEVGSm5oaUZJTjJleU5XVWV2NEdG?=
 =?utf-8?B?VHpVMmJTVWFNcm8rTHFpTzRzRzJFdlFuYnFwY3laNWsyQWZPUFExeERHNVli?=
 =?utf-8?B?WTVIbWZINmlLVlJ3YjBwUGRTc0RXUkdWbWJzdWNQM2EyN2x6WWxaNUpiY3Zj?=
 =?utf-8?B?M0MzUlhEUTlOZHVqeEQ5Y2dhT1F1NzRrNWxsUDBTR01KeXpIaXA2SVhybjM5?=
 =?utf-8?B?QVdxVkkxV0NmcW9LN0ZWV0pOMUNCOC8wY2ZJcEp3aWxFSE9kR1duM0hLMjc5?=
 =?utf-8?B?aDNUbUxRZHIzaWpIYjhjdU9mNTQrMDJBWHJqeXpJN3J2TS9pQ3pRejJOUzlT?=
 =?utf-8?B?WnJDRnQwaFpoL2hhbXREQUtWNlNoZW1DZTBrMUd4QlVZV3dSejFLUGxlTnZF?=
 =?utf-8?B?ZDhScUNIazVZa2hFQ2s3OW5kelc5NjlwMzRnMWcwcy83Z3owNXlTVnFvM2lI?=
 =?utf-8?B?eGlpakRqWnVrOUo3Sk5KQmdIcG9RdWpxODc1RlIxNk1Wbys3aU8vYjJ3WFhF?=
 =?utf-8?Q?lqvjFjMzv2YIWHYeWKbS8OVmGSNyDsfP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1g4YzFtMHBjY2xsSHB2L01vMlQ5cTVueTQ4QzZYUEV3U1VFN1FmSzBXbHdF?=
 =?utf-8?B?ZXpRZDhaSGQxSUI0MkhmcjkrT2R6Zk5vVkpVM3lhdG5jcGlZWlY3MjhhbVhQ?=
 =?utf-8?B?WjdDa0R0VDdLUm8xMGkvVTQ3OUNMWWxyb1VWbENTNjQrQlc5NHh4L1F4Ym9F?=
 =?utf-8?B?M0N2K1BEeklyNEFhOFlnbVRTUjh1aERGL2t6TTBveWRKVTVoa1BVek12YXJB?=
 =?utf-8?B?cFlYejVEZ3RXZm1Ld2RJN0NETkdaV0I2L0hKTmN5VktmVmZVMzM2S0V3QUtY?=
 =?utf-8?B?Y1V6bGU2NmE3V1RSZnB6bnp4YWU1Z04wMFhteTBsTEdmamxIU1Fyblo5ejN1?=
 =?utf-8?B?akRrZzdlRmpuR1VvK1RaSWFiYk9MZWY4aGhjQzEvS2F1RjRuOFFNWU5DUzdH?=
 =?utf-8?B?ZjY4dm5KSE8zbDk5WGg1YUdHSUNqaGEwYWsvNE10MGNKdncweXFqK0F2aGhv?=
 =?utf-8?B?UlhSaWtRQjluUVBvU1FYVXNseUkxZ1lCTmEzdjNESndmN2hwaXlMekMyZ3cr?=
 =?utf-8?B?aFJ3bEVobmNMZFZRRGpjdWZxTUJHTzI0QXlRV25aTUd0S0NvbStuU2VoeUVn?=
 =?utf-8?B?eWJTb29XdlhMZVVBNytqcisyMWVBWFBsdlNqbHB5REZwMkxQQ1RyZDNiVnlF?=
 =?utf-8?B?Yjg3cm9JMW5oWjd6ZFdweGJwUzhaajFSaTZMMnM0aldiUUgrL1UzZHdrUVRv?=
 =?utf-8?B?QVJKclVXNkhEbDhqR3JDbmxBbUR1RjNmcnoyVm9jZ2FLb0FSbnZsUEwzWmF2?=
 =?utf-8?B?VUVxU3Z6QTNYRWE1TWN2ZDNoSkpVbk9Uci83ZTJEdFVLcHBMbTdGQ0M4TEVl?=
 =?utf-8?B?QjlSUUZjWTd4TTRiUkpUbit2RS9QZGZNbDlkNE1aM0xhYTZtdzNteGthTVps?=
 =?utf-8?B?WGZUMDdEcG5PNEF6WXlpNGNRK2xmOERHV2Nhbk1HNHJDejhrM2F2RjQzSi80?=
 =?utf-8?B?OVZJcWt4azd5anRnQmxCcTJTQXNtMWRKL25obEtNcDVicC9yelBtYmgrcmV2?=
 =?utf-8?B?UWxWRHo0WjRHbFM5Yk16UFJsWlh1UjF2QWhUWDdTVFA4NGZRbGNJaUlKSzAv?=
 =?utf-8?B?SFBLd3BoU25renNXblJ1L1YvRjlWc2NpVHFRREdJZkJrZmFoV053eHlZQmdo?=
 =?utf-8?B?d2dOMFhjUzdGQ2FiYllLM3RnSWcrS2ZrUE5ud21GTVJYQ0crU1BZMUVhRzVS?=
 =?utf-8?B?Uk1PZTIwMWh5ZDdIcHVlYUNSL0MzS0JVK1VRYW9pWFZZdG8vMmRpNXhuUXhS?=
 =?utf-8?B?aUUycnd1ejJGTk1wRE03aFZSMzIxOGEwRWp2UW52ZXV1dmd3R2NmekdMZXN2?=
 =?utf-8?B?TFhVT1VmNHZtMmJsVXUyKzZhUU9VczFBdUJLcURxdmUxVkdwNDZyRktNSUhj?=
 =?utf-8?B?QkRFU3R4aDdhbEFGMXNUUXhDbDBGbWxabUM0Tk4xZncxUmUwYXV2TkZBVmtE?=
 =?utf-8?B?VmRBYU1ib1RIY3ZKalp2WnpXWEVRaE5sN1gzVnNFQ2Z4MW92d3p0ZmFic0ZK?=
 =?utf-8?B?TDJKYXExbndwQzhPWWh5bGN0T1dNS0hLWVB6TEU4ZW9PYzdNbk9MSy9WY0NI?=
 =?utf-8?B?Z1hTSTRhSFFzN2NtYTZ0SnYvbHZYc01xdURYbzEwN3cvdG5ESDJxcTRXVVYx?=
 =?utf-8?B?WHFQc1laclVoM1dhd09lQ1pxaEU4eFo1OHZEOE43aG1QMjd4MUIxZFQwVjVR?=
 =?utf-8?B?aGU2bTVIKzFkTzFReUxNMEhpd2k2blUrc0VFY0sxTTBDbWR5NldsWWRhYnR3?=
 =?utf-8?B?bkg5U0dwWmJyM1Nzd2NFOU9oMDErRFVrd1ZqL1lTSXZqcFY5K291R29BWk9l?=
 =?utf-8?B?cXJma0wyWEx1Rk9DWmlZaWdjNUR1dDdncklVd1YrcjQzTXVWelpsMTFwUm5Q?=
 =?utf-8?B?SzhwS0k5LzdWOWZ5UU9rL1pUeVp3d0N5OGVLWTZwdlNjaEkwUGZMOVY4NTFq?=
 =?utf-8?B?a1l6MGxuVlRjRE0ydVBscmk4bjFxZzkvV2NHVnYyTDBhWjZRd21JcWNZMDdY?=
 =?utf-8?B?SUxRUWJZTEhPVnk0N2grUlFMTGtsellmR3dTd0xpTmZGaE5nbm1XSmlIT2xz?=
 =?utf-8?B?c3N6Y3p2NnVibGFjbE9saHhjVFNLSy9ITXdEYXRpYjhyUXljWXZpdlFHVEdh?=
 =?utf-8?B?aVZtSkNNUno5U052MGRrQ2VscENtejFOWmwvNExvMGVMbFREYXRPdk9iaHk5?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d433e7e-d9fb-4e88-e150-08de230b8912
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 23:22:38.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYXVnOcPmQtBmGdjTbuYAlt6pdqx8iF1m5Kzrab32gvS7jVqsZc+EGmshO9ToiS5s9u9YIusGAB3W1CnYOfG5UjObw917ydtOACk2m24PRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4962
X-OriginatorOrg: intel.com

On 11/11/2025 9:45 AM, Paolo Bonzini wrote:
> On 11/10/25 19:01, Chang S. Bae wrote:
>>
>> -static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu 
>> *vcpu __maybe_unused)
>> +static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu 
>> *vcpu)
>>   {
>>       struct vmx_insn_info insn;
>> -    insn.extended  = false;
>> -    insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
>> +    if (vmx_egpr_enabled(vcpu)) {
>> +        insn.extended   = true;
>> +        insn.info.dword = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
>> +    } else {
>> +        insn.extended  = false;
>> +        insn.info.word = vmcs_read32(VMX_INSTRUCTION_INFO);
>> +    }
> 
> Could this use static_cpu_has(X86_FEATURE_APX) instead, which is more 
> efficient (avoids a runtime test)?

Yes, for the same reason mentioned in patch7.

>> @@ -415,7 +420,10 @@ static __always_inline unsigned long 
>> vmx_get_exit_qual(struct kvm_vcpu *vcpu)
>>   static inline int vmx_get_exit_qual_gpr(struct kvm_vcpu *vcpu)
>>   {
>> -    return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
>> +    if (vmx_egpr_enabled(vcpu))
>> +        return (vmx_get_exit_qual(vcpu) >> 8) & 0x1f;
>> +    else
>> +        return (vmx_get_exit_qual(vcpu) >> 8) & 0xf;
> 
> Can this likewise mask against 0x1f, unconditionally?

It looks like the behavior of that previously-undefined bit is not
guaranteed -- there's no architectural promise that the bit will always
read as zero. So in this case, I think it's still safer to rely on the
enumeration.

Perhaps adding a comment like this would clarify the intent:

   /*
    * Bit 12 was previously undefined, so its value is not guaranteed to
    * be zero. Only rely on the full 5-bit with the extension.
    */
   if (vmx_ext_insn_info_available())
     ...


