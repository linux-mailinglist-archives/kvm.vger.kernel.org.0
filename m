Return-Path: <kvm+bounces-23927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CACB994FC17
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82633283226
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 03:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828901B948;
	Tue, 13 Aug 2024 03:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fL8k+sSQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894FB18E29;
	Tue, 13 Aug 2024 03:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723518414; cv=fail; b=ZGK/qYfbxinbP3mR1sNuhzcXCdYX4g+NfXM3BWEy/J9JLt7yZuqSpfAegHPu0r6wjln8oBCcMQ0Y5K7Qg7YDW6SAXDNBZXypKhgGSmXgbF9COIMakussRh5TeF/HTICHBoBaYzViJJm1zd3lLDuV09QBdzIX0qtpBSA0Nq/CayM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723518414; c=relaxed/simple;
	bh=FRhEme+nY6ij6KOwPJ5XL4Vi8K2/i5xUY/CVDzW9Ui4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uttyeXnysM85ZMryAqG/R6Z29vcHTNCdydBEQMFSZfQ+vFBYr0IuZj1hE29Or2XAAHrX27DUw/4y+Hyl0ovLjOImYlgmXhFULqovSVGDJAytWfezRx61LM8jNV+w7H0rN3ZfAA/6l2/KRETeoFTwiRLsQjcExcjs5x3Hqn0wHtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fL8k+sSQ; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723518412; x=1755054412;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FRhEme+nY6ij6KOwPJ5XL4Vi8K2/i5xUY/CVDzW9Ui4=;
  b=fL8k+sSQD4MFY/Trb9EHlqaUnJ+eQ2Bt1AuDO1SUhoCxPNkE+36PUNO8
   phsMZ1gKV2rdVYOTo21+Z4okXpZpMVwj45lD37+wO/puh2dBMTvdLx/wi
   hUUpsZN04LsOI7BDpVxlHr0Of3lyEk1D6Zk7AwZPMIg0pZw29iSFIij3B
   Chjc5BXxCy52dzPCb+94V1yn6cUp8Hp2D4CCZtMYb4+0sumb4KA3iHuDk
   cf2pNzyrdftegesiOQCqJuiY+woIDWXWDdMP3Zt1oibw3Y0iZfxNTKkUi
   qyvmn1AXP9nAHD4lN2b62bx84HXva1lufNmwhOWiGWMd/cAKdTsCxYBEc
   w==;
X-CSE-ConnectionGUID: ziN1NOnkS5CGHp2QOLjl+Q==
X-CSE-MsgGUID: S7ZR5UpOQtGtd36v59Lytg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32806102"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32806102"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 20:06:52 -0700
X-CSE-ConnectionGUID: KgP2DT69Rpe/uw54n/elSg==
X-CSE-MsgGUID: w2FQxbgaSVqAt+dR3BZZEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="96051963"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 20:06:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 20:06:51 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 20:06:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 20:06:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 20:06:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HP3Aq4x5kVg4KH4gVeGkx7u8wmz61vtA7Jt1V/9UzYosqoH4c1OlKa2DD47ShnFIXKxFyo1AdW0xanwfzN9n/JW2TolToJt+4s9E1aHZufTpZ3/wQ1kRZvqmBA+NHCKqytLZqZUTd4sAYboxrJCrthCUX1+SF92DcvQOlpaC14RLPZqVy0iZXjd6Gio8GLFUgUInFIJhMP6LXn6hSkV0vbjCts8p1faNbRn/wvPoSLM7ni7pSwULcosdP6X8iDrxKRbjByN/LM55TReAqdSR/wXZREZMUnrMWkzZ9KPMVJ8irNrGYNabRcpkHeVciFUmRk4hDLH7W1r866HiCbGFjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ziUn8JTlPFRV/e393Z1xoCy2A5heNWGFHm8bJ8Eg9o=;
 b=X37rjF7ScVBxCt4It4VIYyYW+u0vJeckhssFrTHm8oFFso5YhS8l2iMbkOAOrshZDfHR0XsGo/oBHVsXD5B40hXGM1ZwEV2XUWFgbnGXVhLXtP/cfpjjfyegbMwVsHwbJLUz+Tq6/aTb2JVMwXQh1XJylsAqZfLMKQ98YvKdtX4/99uG5uMRaB77mbiIxLsh8IBHmHWJGMe/fidpdxzwyW/b/D0o5b9Ang/nW4EDR0j33ucZWSIYKfy9O/vBmimZPyDl5+Uah08Y3WC7gqcPVg0aMjgIguX5CoqOr3hKSpxT5/7xY+uUO9utM+evuT0rJBnsBpmTIO3CSBiDGlgLGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7340.namprd11.prod.outlook.com (2603:10b6:930:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.29; Tue, 13 Aug
 2024 03:06:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 03:06:47 +0000
Message-ID: <a4760303-02cd-4c4b-bd23-eba4379b2947@intel.com>
Date: Tue, 13 Aug 2024 11:11:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw2@infradead.org>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-pci@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>
CC: <patches@lists.linux.dev>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::8) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CY8PR11MB7340:EE_
X-MS-Office365-Filtering-Correlation-Id: 12a04a33-f446-4a05-278c-08dcbb44f7c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFk1MnR6TEhLbTZrb1RLckRMTElFRU1rZmc5bHNQRnBuRmVFbm1EWXR2NjdS?=
 =?utf-8?B?YzhmemN1c3NoVjhZQlh1bjNoRjhMYWRWQ0hMdVZBb1NoV1o2OHZVdy9HMXVJ?=
 =?utf-8?B?NXo0RS9SKzhpZm42NUpDK2k0YWtyWmMwdkVkSTYyaGZNRDRvbGRZMUxyR0ZF?=
 =?utf-8?B?NEJld3BWZEJVbkRLS2tVM3psWDd6YUdSclAxN0NQNFZrVlp2UHVjd1ZXZTFV?=
 =?utf-8?B?bklYOUp5OTdBaGp2em1EM055amJQbi9uYll6RTVrLzFCQ0dpaEVHdlRIRkty?=
 =?utf-8?B?aTh1YVpacCt5RzlqelRoKzZtQTI4WGpPYThUb3pKcTczSmYrczNHSjZVQ09D?=
 =?utf-8?B?WCsxaTBOUFZFbTk2c25UeGx6RHlwMkxRTnc3NGFYWnlJU0dKOGE4UUxPT1lG?=
 =?utf-8?B?OUR2K3lIL203YmVIaXY1YlBEQ1hLYVdYUDBYVSt5c3ExaVM0RkVZR1haSzlp?=
 =?utf-8?B?NlRrck9oMiswVHVieVppWGRqV0tmNVFwV2VFekpZeHkwZDlOQ2wzS2ZxSzda?=
 =?utf-8?B?YzJsYTIxK1A4eWtseHVuL2VVSk13YjE0anAzZUhnRWtxaGJEWGtHQm44L1VS?=
 =?utf-8?B?SGNldzdsS2tlTkZPS3hHRjI2U2RlTzh0dm14U3dTL0thdHREZUNEZWs1NVZz?=
 =?utf-8?B?V3g0ZFRTcVJMcnZPMFp6d3cvQ3pmZnNkeEFTWi96RXBNSDdiMlJvbGtOYWJN?=
 =?utf-8?B?ek5PQ1dZaGdMNnpkSFA5WHE3cWUwVjQyTWJHUlFCd1A4UEtVSUJRWDB3dTU4?=
 =?utf-8?B?c2FNMUtFZmM1a3hTUkpySXpCdHFXaDJVUkRzOWRDSmN0cTVHczFSaEliZy94?=
 =?utf-8?B?VjVkYW40b2daV25xbXZJaWlyS2huRHptSldWNjJ0MW01UFNNVVFuQ2hKWE9E?=
 =?utf-8?B?dmpiVUY3VkEwa1dmVWorZy84eWFNV08wM0pVRHJqNjEvR0oxQmZXRWxkN2xF?=
 =?utf-8?B?dm5LQ1FySnFRUTNGaDNyTEh4aHcydGdqWHJpeDBNS2FnY0tFZUNIdXBzTzhl?=
 =?utf-8?B?VTFGMDJCZlJHeDJ0WENBeUg1MFZSMWYzWW9EbXpQU3RkTFhNNHZVWVpoZ3NG?=
 =?utf-8?B?SEtia29teFFiRGVoelZMa0YvWU9jM3gxNW52aVFkMjlhaHNVQW5CL3A3TEsv?=
 =?utf-8?B?Q0tVQWxVN1IrUVdDeXlXT3VnaGdtVDRuWjZNN3dnMW5lSnFrbVE1Vm5lYVEr?=
 =?utf-8?B?RlBLYmwvSlA5NHlldFJqOUJFTlRyVTAxNkVKTStqRndhVGpIbC93TnZXZmJq?=
 =?utf-8?B?YkJDaERDekxnQmdYVFp1RTRhb1drNXRsRmVzUkgrdXJEU2dSbUJ4OHlaUE9t?=
 =?utf-8?B?RmJpNHJWVE1KRTNSR2QzaVZNVzBpVGJkbll6VjdHNzhOUm5IQ1RyaDYyVGVC?=
 =?utf-8?B?OHNOSzlEQTRUd3Y1SWFWVUMwOUhVbmRFUTk5L0RJK3p6RU1wNm94dExTTm1o?=
 =?utf-8?B?T1dCRUNWanVmVFg0REdoYUxGL2hMNnlraVV4SEZZcXozQWVUOWV1OE85WDQz?=
 =?utf-8?B?UW9mc0ZrdG1PZzNqcFpGS0ZXSkR3VExsTTFxUVdxRFUrUElwL3YrYVlqTGZw?=
 =?utf-8?B?cUxIajNic2hETDhOQVR5aklsVUE3aFFCYUk0MFdQZ1J3YUJzWUJHR1JqY29U?=
 =?utf-8?B?bzNPSXhIbmREKzlWaUJXMFpjdU0xNFlRUW9hMlN2WnZYMUxnOXRpNEtRVHpa?=
 =?utf-8?B?UG5ZcFVZWnFLVXFaV2JoVmR1MENYcXJJUWxLdExxbUpSanBTVXp0VlJZMGhE?=
 =?utf-8?B?cUNTSzV4ZnljRWlmQUtaek9JQ0dXUFM1eFAxS3JCb2pGV205aWhJNitGUmVt?=
 =?utf-8?B?dHAyRks4Y0VHYVpaQVd6R2padWJzSkFCYXloSmszUEl3Z2ZEdlpTWFBKVVFw?=
 =?utf-8?Q?hTziZs3gSFo2X?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUM5MnNxYVRLM1hNN0poQWNScmR1Vzd2cVg4d2h2dXJlMFpBRUNTbWhOOWVh?=
 =?utf-8?B?Zkpub1hIci9oOUVWVkVlZWlXNE9BaGR3YjRCMCtnUmhCaGZVckxRSW5Vclh5?=
 =?utf-8?B?Z3RPeWFoTVptY0Q2Ymg3Q0xGSUhJeHIwdWZWazAvcktvVTM2UDRscjNwVEp6?=
 =?utf-8?B?c292eHdhcDVmVVJpL2xTTzk1MWNGMHpRL2JRQUJvZWlWUWRiWTk5cnNHTkVB?=
 =?utf-8?B?RWlGNFlDbXM5Z3ZwemM2cDFyUnRFY0lRWko1eDlrRDBLWVJCTi9ob0dUS25R?=
 =?utf-8?B?cXZWUzZuaEpHT2lQaDVNMHhWZ3ZicVA1WSsveXdhKzRIQitvT2s2TWd3bHlj?=
 =?utf-8?B?a2Y1aHNiVXNTK1dPU1hBWmZXdlp0V2xyMnpma2V4THdFREpoOVhtY0pRMGdy?=
 =?utf-8?B?elhNZ2syZmtHY1crU2FZSXkzYmlITHh2V0ZCc20yUGdIbUdDdWtYb0g4N1Fl?=
 =?utf-8?B?SUhxQm1mdDROaC9aaDhmSkdJRWhjUTY3Rlk2bSt2THRJOTMvSGRPemE2MnBv?=
 =?utf-8?B?REtpU0tCTFI5TGMxOEdpbmIwRmhITklCU2pya3NoMWY3RU1yZXIwbEVJSU9O?=
 =?utf-8?B?cVprL2VVY09uVXZGbVdVVVRjNHZ5Z2hlSzRqeTBwWU9zUkc5NFFqdnJuSUw0?=
 =?utf-8?B?MVRzWUZtckk5b0VaOFRneWNEUmZqUXZEeTlGUDBISEMxUTNZZS9ORzRTdDNx?=
 =?utf-8?B?UURyTVlkZDQ0K29VaUFybldYNURZUjJNdGY1UDZjaDdSeW5OSGM1cm16WXFr?=
 =?utf-8?B?U29rSEMrUVdZM3dOM3ltMTFnN3ZOV3hTQkdDTENZSlZZWENIZlgwSlRGNVgw?=
 =?utf-8?B?TVZ5ZDV4ZWFObFNZTFltWGxlTzhUTStlV0ZVellhK0NsSzRpc2hOYTFTcGVn?=
 =?utf-8?B?Z3Y3T0IrSGdLdGxhOFhsRVhZOEpSTUxtSlNnejgwNVVtRmQ2aFJFT1daSWxP?=
 =?utf-8?B?Q3pWVW1CZzBWK1h3L3pwQ0RiR3cvN1pXd3BqT1FOdFBsK2hrRk9nS1dYVDBi?=
 =?utf-8?B?NkNhLzVMQWxZcXduYTFzMnZjNlRBcTk4TDJYazNReDR3V1hhUy9aMEdaTGdQ?=
 =?utf-8?B?WG9WYTVRcjF4R3JpTHpQS2N3cys3M3BJZlhmUFhqcG9VR2FrbmJKemxNbFo2?=
 =?utf-8?B?blZRbmVyaHd1Qm05OU1UcWxPUEtOM1hkUlVWbGlFeVpWdER5UHpWRnF4ZGxo?=
 =?utf-8?B?YnFSZXg4eFc4TlNqc2MzYzE5T1hmU2QxM2V4SWlyREZTRk10QlhFOE9oVU5J?=
 =?utf-8?B?bG12cTBZRWxEdTh2c3dzTS95cG50UEFxRGVrY3hlU2Rka0hzd1FqSVpwUEhQ?=
 =?utf-8?B?U1JhNFp1cEpYWFZvVEJBSC9mdVdiMnVsQWs5eCtGWjRjN0JQQWJzWEtuZmpG?=
 =?utf-8?B?WGRaaWoySmJKWWZDclpTRGdnTXlVUmZ1KzFVQlhGSXRtb0VZNFQ3eDdKNzVy?=
 =?utf-8?B?YU95d3JQNkxHN1I4TkxIQ1lCL3BLVG04ck5Cc0cxcSt5V2NWOTAya1BJV1ZS?=
 =?utf-8?B?TFFMNXhzL2pXajZwRU1mS3BVUzNqUnh4Z21Rbm0yM0cwbzA4WTI1TkFQRzhh?=
 =?utf-8?B?NUdTc3hZRkF1TzR3VWRhTVRVOWxIM0dZOSt3WlRzclRSYy8va0ZWNkVZeXdU?=
 =?utf-8?B?MjZJbzU2eHA5MGNVWmRTU1l4WEZlMUcvRXpJNWsyT1UzMTMzMlpnNFhpNmt5?=
 =?utf-8?B?K1crUU9XY3RUa2o1Y3RReGM4ZXJzaU9pU1pOWGRVLzh5cm5xQjZPVWZFM0cr?=
 =?utf-8?B?WTNFNkVUQk1LcGMvazBNVHB1M3NGb3R1VjdnWjlXY1NuSmcvbzlyZnZhR0Ru?=
 =?utf-8?B?SGpxc05VMmdiKzFXKzQ4MUtYd2ZabjdpSXd1UnlQUnRhME9WRHB3VVhsYmJl?=
 =?utf-8?B?ZUVwUjVwYjdDM3VYdVAreUI2OHZjblEzQnB2ekx0Y0VRMTNraU5vOG4wOUQ5?=
 =?utf-8?B?TXZ0bWVZcUhXdlp5TzhxYUJ2QXRXSXNRUEJqbUlsUDRvYVZGZ3IwVEFXRUJv?=
 =?utf-8?B?M3N3U2xlbUdDd1M4YTY5L1ZERG1MVjdjdXo5VFNrSVBFa2I3RTBoVFdQaHpu?=
 =?utf-8?B?b01ZRDkySW5MRUdpUnFPS0dBbkVxZEl6L2VSSzJjQUJGQ2I4Qm1zRTRUZDRp?=
 =?utf-8?Q?0Z+ZS9t3So1NIhAgV0w8Azx0G?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a04a33-f446-4a05-278c-08dcbb44f7c6
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 03:06:47.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jder5/t0mY8VH4XkulJonDysrbym/CQnV22Lg423lLh+Ovm+Zna2WXDAFxMhvu+ewC3ryyAJ6lhVWjKhPOcerg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7340
X-OriginatorOrg: intel.com

On 2024/8/8 02:19, Jason Gunthorpe wrote:
> PCI ATS has a global Smallest Translation Unit field that is located in
> the PF but shared by all of the VFs.
> 
> The expectation is that the STU will be set to the root port's global STU
> capability which is driven by the IO page table configuration of the iommu
> HW. Today it becomes set when the iommu driver first enables ATS.
> 
> Thus, to enable ATS on the VF, the PF must have already had the correct
> STU programmed, even if ATS is off on the PF.
> 
> Unfortunately the PF only programs the STU when the PF enables ATS. The
> iommu drivers tend to leave ATS disabled when IDENTITY translation is
> being used.
> 
> Thus we can get into a state where the PF is setup to use IDENTITY with
> the DMA API while the VF would like to use VFIO with a PAGING domain and
> have ATS turned on. This fails because the PF never loaded a PAGING domain
> and so it never setup the STU, and the VF can't do it.
> 
> The simplest solution is to have the iommu driver set the ATS STU when it
> probes the device. This way the ATS STU is loaded immediately at boot time
> to all PFs and there is no issue when a VF comes to use it.

This only sets STU without setting the ATS_CTRL.E bit. Is it possible that
VF considers the PF's STU field as valid only if PF's ATS_CTRL.E bit is
set?

> 
> Add a new call pci_prepare_ats() which should be called by iommu drivers
> in their probe_device() op for every PCI device if the iommu driver
> supports ATS. This will setup the STU based on whatever page size
> capability the iommu HW has.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c                   |  3 ++
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++
>   drivers/iommu/intel/iommu.c                 |  1 +
>   drivers/pci/ats.c                           | 33 +++++++++++++++++++++
>   include/linux/pci-ats.h                     |  1 +
>   5 files changed, 44 insertions(+)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index b19e8c0f48fa25..98054497d343bc 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2203,6 +2203,9 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
>   
>   	iommu_completion_wait(iommu);
>   
> +	if (dev_is_pci(dev))
> +		pci_prepare_ats(to_pci_dev(dev), PAGE_SHIFT);
> +
>   	return iommu_dev;
>   }
>   
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index a31460f9f3d421..9bc50bded5af72 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3295,6 +3295,12 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
>   	    smmu->features & ARM_SMMU_FEAT_STALL_FORCE)
>   		master->stall_enabled = true;
>   
> +	if (dev_is_pci(dev)) {
> +		unsigned int stu = __ffs(smmu->pgsize_bitmap);
> +
> +		pci_prepare_ats(to_pci_dev(dev), stu);
> +	}
> +
>   	return &smmu->iommu;
>   
>   err_free_master:
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 9ff8b83c19a3e2..ad81db026ab236 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4091,6 +4091,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
>   
>   	dev_iommu_priv_set(dev, info);
>   	if (pdev && pci_ats_supported(pdev)) {
> +		pci_prepare_ats(pdev, VTD_PAGE_SHIFT);

perhaps just do it for PFs? :)

>   		ret = device_rbtree_insert(iommu, info);
>   		if (ret)
>   			goto free;
> diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
> index c570892b209095..87fa03540b8a21 100644
> --- a/drivers/pci/ats.c
> +++ b/drivers/pci/ats.c
> @@ -47,6 +47,39 @@ bool pci_ats_supported(struct pci_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(pci_ats_supported);
>   
> +/**
> + * pci_prepare_ats - Setup the PS for ATS
> + * @dev: the PCI device
> + * @ps: the IOMMU page shift
> + *
> + * This must be done by the IOMMU driver on the PF before any VFs are created to
> + * ensure that the VF can have ATS enabled.
> + *
> + * Returns 0 on success, or negative on failure.
> + */
> +int pci_prepare_ats(struct pci_dev *dev, int ps)
> +{
> +	u16 ctrl;
> +
> +	if (!pci_ats_supported(dev))
> +		return -EINVAL;
> +
> +	if (WARN_ON(dev->ats_enabled))
> +		return -EBUSY;
> +
> +	if (ps < PCI_ATS_MIN_STU)
> +		return -EINVAL;
> +
> +	if (dev->is_virtfn)
> +		return 0;
> +
> +	dev->ats_stu = ps;
> +	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
> +	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);

Is it valuable to have a flag to mark if STU is set or not? Such way can
avoid setting STU multiple times.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_prepare_ats);
> +
>   /**
>    * pci_enable_ats - enable the ATS capability
>    * @dev: the PCI device
> diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
> index df54cd5b15db09..d98929c86991be 100644
> --- a/include/linux/pci-ats.h
> +++ b/include/linux/pci-ats.h
> @@ -8,6 +8,7 @@
>   /* Address Translation Service */
>   bool pci_ats_supported(struct pci_dev *dev);
>   int pci_enable_ats(struct pci_dev *dev, int ps);
> +int pci_prepare_ats(struct pci_dev *dev, int ps);
>   void pci_disable_ats(struct pci_dev *dev);
>   int pci_ats_queue_depth(struct pci_dev *dev);
>   int pci_ats_page_aligned(struct pci_dev *dev);
> 
> base-commit: e7153d9c8cee2f17fdcd011509860717bfa91423

-- 
Regards,
Yi Liu

