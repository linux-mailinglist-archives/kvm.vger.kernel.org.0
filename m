Return-Path: <kvm+bounces-17814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE1F8CA53A
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5A581F21532
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764021384B1;
	Mon, 20 May 2024 23:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pqi50KUi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7381B1847;
	Mon, 20 May 2024 23:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716249006; cv=fail; b=XS7y9M/eTeDygMowi1YU+JDVOU92B3hTT+bW7X2Fv7gTYuUqBvwMtpKY3+bRcpIojNwbey7QHt6Pjx3NgSuBJn5U5aGSPf8He9ohR8vSPeE/YU3B8OFLsO06cqskvh/z76d7tOwYMojvpCgbtnIhewQZVEW3ZqnNTUrAyCggvO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716249006; c=relaxed/simple;
	bh=y2YyjGO63KjQPMl2POyy7IeRbwycvg3bRmMmmqIvCaw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gOCl88ljNagabvCpE8j+fpNW3AjaaFYg6Be+Nq3eAMIJDrpTdymK5Lv63Y8lR2BMbwy5KmxwdirO/d6tD1C6w3MO3b6G4AY4jptRwPi0cgoYQrc1b9Z5ewhXpT6fghMWQOkwscOpMhU/s9pbMCnIpz+XZImUZDBZuovpIpbpSuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pqi50KUi; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716249005; x=1747785005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y2YyjGO63KjQPMl2POyy7IeRbwycvg3bRmMmmqIvCaw=;
  b=Pqi50KUiA3hKICHBAH+OeRavi3APD6GvP1Uuf3aKmZIwH4Yqg+9gR0XD
   yBiBJgDpwhRZYuVmG05gNiJauKqUNksJyGiK9QYKmuHUBc04tqKJ8vwee
   hG7BnyCCny6Ml6lyFW6Ac1gcuFyuoln4yALzRRpNWVvpSrW/s0oS4cc2L
   61bnEBCoXJ9jI4CS3MMYrltLIOlNg/c+8MrU9n0UYaurWbtvsc/UlWIXG
   n8XujZDwyP48dvKBR63GCnaADYUEcgfjaMJ3EH7fp1cSgX/8Oeha9D4Fr
   gBD+e3cWCqChS2lXa0FgvNlaoofXkeFmR2ggr56HHRbAeT1V6nkD8rcE5
   w==;
X-CSE-ConnectionGUID: CNlb/N7/TDq+4KSyEfnx4w==
X-CSE-MsgGUID: UjBxCaDRRMKJ1bzYOT7ytg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="29934925"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="29934925"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:50:03 -0700
X-CSE-ConnectionGUID: LjMhueHaTuuwaL8cuOJZTQ==
X-CSE-MsgGUID: f3/VEPsMTW+58D+EF/cBxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32884551"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 16:50:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:50:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 16:50:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 16:50:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 16:50:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeBVW8sGtAL0vsZAthgEfaedTXX7644L/YS1LFsgaJvjVYxv8/IEnYqT2bGoUi8Fs7JzHh2sWrkoueUFQK4rDsJSNS8OFn36XlbZAUVUZorbwLpYaZE/wbgOg4a8U8yqNIRd1/XBVskH+TUHqB4E87C1AI1iNO77gsaPpkJp8SU3iOv4zPU3xJcgp+GMMTbDZ9ZELPqbAZsviqRpNQ5FVDq8SEoojpkwj55iu7B7V6nTHdLHQQRnANm2LC+HgXqQnxkH55e+uI4Cuc7764Yvc77yB1Nppov046nTveoxn72C8xiVErUpF1jArjBwSdplg3Oc2Tcc8eLBv/5RfjkvTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ErM27msBQyWg6GgcnC8hOix2be/71TRK5XhiZt4v03I=;
 b=SKRispcUCinDWVtyQWk0feQpgtMotKWABjtYdGSrsjFIeACQkgtLPnRBeuXWC+GiGLHL7I5g7xHkY1untAxI/knNL0AXXZwx61KyOjGILF+MMHFYCAVuDjju1mhj/dEHfoxRd08+YXZ5e0PK+Q0LwBVwfukItyt0a6YlguF6ZA11ByX8h0VrHAjYHZTvAjIC7Iv9zOywz6TGfzYBoXVXKScTUOnjSDIubcyv9pE7wGohOADPSOvR2r7mUsIyJX3CU5Y7zRDS0cqAqoryPGUuzkub/NgrYwjpWMSUYXLD3moLb+NWWt9RTwNuFcecaeqL58hkCMlCDf/xtTD6IF209Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.31; Mon, 20 May
 2024 23:50:00 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 23:50:00 +0000
Message-ID: <b1def408-f6e8-4ab5-ac7a-52f11f490337@intel.com>
Date: Tue, 21 May 2024 11:49:53 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] KVM: nVMX: Initialize #VE info page for vmcs02 when
 proving #VE support
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20240518000430.1118488-1-seanjc@google.com>
 <20240518000430.1118488-3-seanjc@google.com>
 <78b3a0ef-54dc-4f49-863e-fe8288a980a7@intel.com>
 <ZkvbUNGEZwUHgHV9@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZkvbUNGEZwUHgHV9@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0044.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 22f660db-989f-475e-c1ee-08dc79278fa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZXhlN1N6SStpNEYrL3B3Sy9YdlBSdVVxZ2k3RVZRQ2toSmJEZGJUOEJRdGlW?=
 =?utf-8?B?Y1BKVVlMZ3BtQnIyZ2svalJyU2dvREMzY0dzdGkyWUZ0ZGtjUjlHNHlvdE1G?=
 =?utf-8?B?NndzRzRHYmkveEpmVHgvTllTcEdqWi9BcE40UzNiQTg5QVBJNUJiZ1lOaGpu?=
 =?utf-8?B?djRnS2hQeGVNNDJwMmVCR3RTTGxwbzNCNG45djFiTHFwMmprL1E4UW83U21k?=
 =?utf-8?B?OEc3Rm9KNklDUWM0M3AwN3RGTDE4U1M1S2wwUWk2NWpvNzhqNG5DN01vOHNt?=
 =?utf-8?B?TmVraGR4VVRSSTNQK3dWOU9WcXZ5VnVWOGl2VkhPbmVDak10M0w0dys3MnNy?=
 =?utf-8?B?dFJ5RXMvWitvN0xHRkZMdGdjU2U1Q2lrWnNBTFAzTE5lWTdNRzNWRWU4S0pt?=
 =?utf-8?B?NDRqdGJITFp1OS9ERUxFWHh0UHJ6Z2hUdjMzN0djN3lzVGdKaE9McHdFbmZQ?=
 =?utf-8?B?T0x0Nm5hK1dEUndjY3I2WWtKdG9zYjk2M0l0REpveEM2R2M3MFNRU2lBUWt6?=
 =?utf-8?B?bkRrclBXY3VxOWpzNFRLNFg1WitVTytrRm1UTXRZSE5tL3NpZzJxbUhBVy95?=
 =?utf-8?B?N0xRSFVFRGg2WnNXUTc3OVIwSlRoVmZ2clVSNEVndUs4a0ZrelR0YWNHWnNX?=
 =?utf-8?B?UXdIZFc0K3lUVlk5NWRDOUMvU2txS1RRMlhIekQwN05FMGx3U0xJTG9XSHdr?=
 =?utf-8?B?ZVdLZ2YzMUVJbzdGcjVlTU54SHYzaHY5OUZ0WXhPNlN5MlRWYU1GUDhXRmZw?=
 =?utf-8?B?VXRuL1JnTHlIZDVrVUNVVzJqZDhxNGtGcFpsWEtrdldXOFBsTUlIRGQwTUhn?=
 =?utf-8?B?YTRxRXJYb3VpMFVSWVcxaGZ1bVVGV0VUN0paZURnVHd0U1ZDRUZNSGt1UUsz?=
 =?utf-8?B?S2VSQ0o5ODBDRjd6UHlNK0g0a0poYytTK1BEckcwVDhhdGYraW5TSDlMdGxN?=
 =?utf-8?B?ODR4S3VwNHJxb1dOVzI5NXdGMU8xNTY5V1Y3L2tmdU5pWEJFS2RpY0tWSGx3?=
 =?utf-8?B?dDBTdFZCekY4aWhTOHo0em9mcjBkaEhkVWxhWDFzdkFiRHhxRmowOFRjb0VO?=
 =?utf-8?B?MXlVUTYrK3NVRXN5U2dhUVFKQSswYjVoblpLUVZZQlEyRjdsMVh6cnlLL3pu?=
 =?utf-8?B?emlhSThmbWRmaHNlTG1rbjAwanQ4b0xFWVFUTjczZmZHTTEzWVNURzFBSlFJ?=
 =?utf-8?B?bXh3aEhSRi96bjJYTW1Md3M0WXZGUGZEWXZUMWhUWnh1ZFQ4Z3o0VkJPTWFu?=
 =?utf-8?B?eVFhMzhXWmhWdE15aFFsTU9QSjZwb2hmN2szb2FGS3htT2xEbXpFN2h3WWFK?=
 =?utf-8?B?cDY4Rmp4cUJWQ3JaTlNpM0I2VFYrUjlTRG84S2krL2loRVZJUVlRaEdrY3l3?=
 =?utf-8?B?RWowZHZ6VlFpY3hZKzRKblI5VmtiNlNLZVVNNWpvU25mSzVtbVR5a3o5TkpF?=
 =?utf-8?B?c2xUczI2eTJ6b0NOUFM3VlUyZjA1RXMxeGVySm9PZUE1L2JGenYvMmU4VWJR?=
 =?utf-8?B?Z1pCMXkyc29FeGZ2YUNVcFg1MXBzV2ZDUndYM3BzVllLTkZZRmhrclEweXBu?=
 =?utf-8?B?RnhzcEVqLzNEdmpRbDlybzRaOUN2eXVRZnhKQWZYWVFQVnpNTGY0MmZOdWlK?=
 =?utf-8?B?Qm5temM0WkhHc2hCbU9rMld5T0ZLeTNlSmh6dWJkN3VMdmxYUHovSkpLeGNC?=
 =?utf-8?B?YVpIVlNBMzlXakRMckRuVm9DL2Fac2I3QjBodllXdklUSXpxUXpYV2pRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUw5N0gyRkZycDRDZ1BYWHFNc2hES3YyVnBuWmFKUUZIQW5OZG94a0NpTUtt?=
 =?utf-8?B?NFNObktNZjNkTmczUDFoYWxFaVNBejdKdXlJRFhKbzhVMFpCTWFWNkVGaWdh?=
 =?utf-8?B?VURIeW5rT2hLeVlOUU82MjJaZTBIYU81STNXcEdzSTZuTWpyMEVQazA4ckdP?=
 =?utf-8?B?UWJWdHduaEh0Z0Y3QW1reVRGNHlHSzI2eHJDMnZuREVIL3FyRVJqTzJ0NGZK?=
 =?utf-8?B?azRiVCtiM3IrZ1BMSG9vaXVseDhDWXhUVmU3aGlhbUhyUmtYRkR0NkRGVkhV?=
 =?utf-8?B?NGdSUEorMmZLNTFMdE9IS2JER3VwWjFXVTFvMU5tcHpQc3YzalppdnZKZlVO?=
 =?utf-8?B?RVpLMWtwcUtXT2JHRXNCcUNHYm4wUTFlYnFNNnZPeXRaNkZFV251ZFNIQXo4?=
 =?utf-8?B?ZzNKZHNmWWJOZEVPam5nU1BvWU5LVXlVS0FMT0ZRNUczS0hNT096bHVqRUYr?=
 =?utf-8?B?T1IxVHhmM1cvUzRCNkFpMjZtWXZTWS9Ob2VhSHZrRU50T2JTU2NJbFlMMVcr?=
 =?utf-8?B?UGJxRi9UU0Q5NmJDbGE1cTZxdHEySEhCUExnZGFqNlE5NTZwOVBaL3pLVDVV?=
 =?utf-8?B?VktWL0tPMFNyYWxCTzlLOXBXdFJWbXg0b014MGsvZ3NwUEdCNHBlRmpiY2U2?=
 =?utf-8?B?SG42d3FkR0JTVGNQaG5YeEN1UlFlTTFRaHdOUld6RTlkMm8zdW5GL0plQVFr?=
 =?utf-8?B?dzQwZThLcHZmdmNDekc2eVB3RzdKc2hoN1ZxRFAvSE9taVpCdTBzTjExWmtO?=
 =?utf-8?B?N2tRQ3JGZFNubGZHNy9vWmR2MGlQV2RJUWVVbCs1eGhPNWlGMU5SR053Rlk0?=
 =?utf-8?B?eTZ0KzIwS3NXREg3UXJMVVQxOXEvTVBpQ2ZwUkVpQlhaemhtME5ndDRzYkMv?=
 =?utf-8?B?TWpkUHNsSS9kNS9zUWpZcGozdDVKUk00WG14Q1loTk1ZcVNwZUt2MjU2NGMz?=
 =?utf-8?B?Y05pQy84QWhnSnp6MUllLzhUdXFMMHNUOWEvSXlSMUhUMVl1a3B3Vmk3QWxi?=
 =?utf-8?B?MkRiZFJnaFVyNlZhVXZNUFQ5RUV6ektlMGw1Ri9scVRxa2EyczU1SVBMbkxx?=
 =?utf-8?B?NStQVGFac0dIOURpKzE5MFBTUk01YVNVaS9zSXZkQ2ZrRW52RFRRcFVEWnpJ?=
 =?utf-8?B?N1JRSTNmZWs2TVlKVWxmN0xTbXZPcFZVTGpHUUkrc0hLWGZoREQ0bEQ1eEJu?=
 =?utf-8?B?SGVuaUlpblpIeVNRSm9yQ012V0dRanhIdHhCbkkwZVZhNXdmdWhzUld0ekFr?=
 =?utf-8?B?bENFT2pzNGxHR0tpaTVlS0Q5RjdTWkRVeTErVHV5c1V6dkJhV1RaV0tKalVI?=
 =?utf-8?B?cmxaTjllcHBVWGIwYlBSRkVScG83Q3NLUGkzSzJFK0c1bWRIWHRWdGc5c05l?=
 =?utf-8?B?VE1QOEptWk00cXpiTGlnanRHQjVwMHJEcUsrNVV5ZEpGV2ZOb1FiWHU5UWJj?=
 =?utf-8?B?bVZ1Z0NGSndISXFwR1dCRTVFbDBZODNtSjlnSCt2U1NmQ0FNTW9EWmN1VWlj?=
 =?utf-8?B?VzhzVnFDRnFwNTlvbUh1cGUzNWVHT2VJQWZLR2pHaDYyMndIUDRrN0JvbFdU?=
 =?utf-8?B?b0pESTBERVFtaE5nS1k2QmtIVnRZSlU3eVo4eGhUNEk2UFkrSEgwMFdXc3dD?=
 =?utf-8?B?RDNVZmpkdGdUbXBSZWNWbnV4WDd6bnorazVUM01lMVUwWGRYNkxxbENsRzNZ?=
 =?utf-8?B?Y1dwV1RWczhSOEtGcjdVUm80cFlmRHhXRURYdW4ycGFScFFmUVpSRlRyVzMr?=
 =?utf-8?B?dExOMHh0YytaakQ2clRKT250dnI3a2REWkZBZmZuVDNTZndyUGNzaEVDMEdh?=
 =?utf-8?B?enZVcE5CVmZGNzc4TExtZllzTTUrTm9rR1VVS09QK2o2OWxTUVJZOFFGWDIz?=
 =?utf-8?B?UDJYdE9BM200cWpEQVlObFUvQndUbk54aGJKd2xpTDlBc3BvZmZOcXNWWmg0?=
 =?utf-8?B?dXhxV05qY3JDS0ozQWZ0N1BxTVpNR0lFNitFbVFhMDY5THZiQVBPSjhYaDRa?=
 =?utf-8?B?eG04VVJpb0sxN21MVzcwTThML1ZmYXJPMGlXWnhrWUpPeFloUG5lVUU5RlRi?=
 =?utf-8?B?SlJqR0tiSmFjdTBVSnlOMyt4TGhIZmlBa2ZCeC9HbHYwOXhvT3VDdlRHUi9B?=
 =?utf-8?Q?yKcdaKdRqlQy8pdu6mDNUqlcX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f660db-989f-475e-c1ee-08dc79278fa0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 23:50:00.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eXiw5xPHh1HwL7L+N+IWzBt9R6fCE1udTVbGv0IX8STYaNVAv9izUskkwfG21dB0KtUzt8UqnLN7iQBd+qe0ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
X-OriginatorOrg: intel.com



On 21/05/2024 11:22 am, Sean Christopherson wrote:
> On Tue, May 21, 2024, Kai Huang wrote:
>> On 18/05/2024 12:04 pm, Sean Christopherson wrote:
>>> Point vmcs02.VE_INFORMATION_ADDRESS at the vCPU's #VE info page when
>>> initializing vmcs02, otherwise KVM will run L2 with EPT Violation #VE
>>> enabled and a VE info address pointing at pfn 0.
>>
>> How about we just clear EPT_VIOLATION_VE bit in 2nd_exec_control
>> unconditionally for vmcs02?
> 
> Because then KVM wouldn't get any EPT Violation #VE coverage for L2, and as
> evidence by the KVM-Unit-Test failure, running L2 with EPT Violation #VEs enabled
> provides unique coverage.  Doing so definitely provides coverage beyond what is
> strictly needed for TDX, but it's just as easy to set the VE info page in vmcs02
> as it is so clear EPT_VIOLATION_VE, so why not.
> 
>> Your next patch says:
>>
>> "
>> Always handle #VEs, e.g. due to prove EPT Violation #VE failures, in L0,
>> as KVM does not expose any #VE capabilities to L1, i.e. any and all #VEs
>> are KVM's responsibility.
>> "
> 
> I don't see how that's relevant to whether or not KVM enables EPT Violation #VEs
> while L2 is running.  That patch simply routes all #VEs to L0, it doesn't affect
> whether or not it's safe to enable EPT Violation #VEs for L2.

My logic is, if #VE exit cannot possibly happen for L2, then we don't 
need to deal whether to route #VE exits to L1. :-)

Well, actually I think conceptually, it kinda makes sense to route #VE 
exits to L1:

L1 should never enable #VE related bits so L1 is certainly not expecting 
to see #VE from L2.  But how to act should be depending on L1's logic? 
E.g., it can choose to ignore, or just kill the L2 etc?

Unconditionally disable #VE in vmcs02 can avoid such issue because it's 
just not possible for L2 to have the #VE exit.


