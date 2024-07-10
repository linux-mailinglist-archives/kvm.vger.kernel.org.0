Return-Path: <kvm+bounces-21248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9FC92C7B0
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 02:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC3C4282C42
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445553D7A;
	Wed, 10 Jul 2024 00:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ul/ygr/d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFD0A5F
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 00:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720572363; cv=fail; b=nzkFel8gl9ARomI9GdyKpB19agzlFBPGuf4A1AAlN2xozkubUPcw2Nvd8y65qKWLPysUVhZ9ThIYgEQerNc3d3vVekAVZ8+oMlMnpWWLNplue4kRqliUVuRQNn5cO9jUj+VBeI2HRKJvbAKB9ToBUH4ONps/y+xK7hAhop5kPk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720572363; c=relaxed/simple;
	bh=ZBROMHnrCz3upfmOpPIWpsu6ohC2KoGN8WmgUOV1Lq4=;
	h=Message-ID:Date:Subject:From:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p8WACqlS2qu+DEPU7lqRcqGoRKZkpY9XMp899ig/wlqP0P1ZqBTLMcqJb3zMT43eG0mEw/tBYj7VwLcXeJnY8qKans3RnT0Uj4TIfo8Swkgu5PTxLysCSQthpk8g+5XEg/DFHADeGxaJJQVh2kLrlXP+alsOSe1kd3jGo5ias2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ul/ygr/d; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720572362; x=1752108362;
  h=message-id:date:subject:from:to:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=ZBROMHnrCz3upfmOpPIWpsu6ohC2KoGN8WmgUOV1Lq4=;
  b=Ul/ygr/dgT3RnenT9hD1hqzJeDrcSPGvk8IeRkHk00ewHUjFHZN0kmPG
   tzPUO5Ljs2WFwltSfdG8N4OFSV96bwd+eExWKwDG0yjV2UgffEx75pDzy
   ucHB+T/4v2wpAmuE97lGiLitaw8L+k+qSFnn835ypoFHjqJIL1HmwMmo8
   hLmznE1PfWcWJZfq3iYSo7rrBwLD7iuWna+2KWqszEWR5n8mdDTmnlenf
   tPDyAFp05Wp/XOdJrkdALBMgLFk17r7gioGcBFWcCkhMhcYvNhHrSFD6e
   uzMcDTM8cSNfFkFoA60UAjgaDRGwz20cKEUB3iUPTTP+egejKNKhCL18f
   A==;
X-CSE-ConnectionGUID: 3b89f/gESsu56Gw3ZH2LiA==
X-CSE-MsgGUID: arB0idFNStSu4wj8KPJOIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="35297189"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="35297189"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 17:46:01 -0700
X-CSE-ConnectionGUID: zrN3NF+pR5q8vZQIu2T+rQ==
X-CSE-MsgGUID: a39THRGpRLKieEmCAxow1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48482035"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 17:46:02 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 17:46:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 17:46:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 17:46:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 17:46:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLntDqiEkj4kd1Kpc2ui7MbCXCr6DdL4iSci1JGJDcqIunHPs0E8UZs6r/XMHRfv+AyWvNz0HozeVQ7clvB4r97BCdDlomIiMyokAuJDGqyETRZAdUteo+Y1+trSy/eEtTTDqBHZgRhyE34ramkWpC9jxBUXseY7rkp9kgoUU6W+SzKnLkchUx+JPh42aF+Ih5SMSGfTUPh+CAUYwKw+ExAhsJloSxruoIX6i28A8llll1rSuvbeGCi7uopLWdJj2+R5SmUyK9rUMmVgEMSJR076DwYeUp422ouizR78crNXlY+OhUDR1b2iysC2fjEW5/cGc1OCmB3DGrFq5LxnYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJdWOcjkD2rqphrD46ozqDAT3xR/MedVgXU+40/CzI0=;
 b=XJiz3GN6viAiDvBosrMPnWsK3nH8eG10LKeqeLQYJstRkBDhXidbPPGFx6JNG2BCtdzXNxly1f77ogimaW0XntOYM6WjiRP3hU7zpUt/a29I0gY6ANcm1Jou5LnzQoXbDvd/tTGFNRn1k1huPPtFJUubzl1RxcpKu8HN8+3HDzP+2lAToJ4TaSNcWAC27x5PXE8zBxnP1fX+rzJa5V68u91DTg2LNKa7IXDMHfuAVMg0MXTz0ahoirL1ag+9KaLnT+ot/MyOvV2J0PJNN3Y7Q/7nOnqTKQZDfFkV0qmkdECE8A9XvRgW6o2BZlLAw1EW54XcIUAboS1q24ZcuyTz9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4983.namprd11.prod.outlook.com (2603:10b6:510:40::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Wed, 10 Jul
 2024 00:45:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 00:45:58 +0000
Message-ID: <023e1f00-937c-4d20-9007-701f05eab1ad@intel.com>
Date: Wed, 10 Jul 2024 08:49:55 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 219010] [REGRESSION][VFIO] kernel 6.9.7 causing qemu crash
 because of "Collect hot-reset devices to local buffer"
From: Yi Liu <yi.l.liu@intel.com>
To: <bugzilla-daemon@kernel.org>, <kvm@vger.kernel.org>
References: <bug-219010-28872@https.bugzilla.kernel.org/>
 <bug-219010-28872-K77I1WzEsi@https.bugzilla.kernel.org/>
 <573f9453-3a2b-4058-988e-b99f1f55d4b9@intel.com>
Content-Language: en-US
In-Reply-To: <573f9453-3a2b-4058-988e-b99f1f55d4b9@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0188.apcprd04.prod.outlook.com
 (2603:1096:4:14::26) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac8b659-d683-4b48-dd80-08dca079a9d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SzdrWmZhWjZVTC83TnRMeER5bXRjVnltd1owNys3bHQ5MEVWc1ZTeWtRMUJk?=
 =?utf-8?B?b3Rpa3NVMXlTSVpadU8ycXJVQUVxdlhKbzlGVUlHSjhkZjgwL2hvdHZPUGx2?=
 =?utf-8?B?K2tQSnpLWDVXNC8zNVZzUklNOGZrRGtJMVN4WUJRQmZLUkpUM2haVmJCU3Ev?=
 =?utf-8?B?TWJ4RU1FZ2xNQVptclJRTHluQTJRSUNmUVBKa3RQakluQjBGZTlScHlKdmpT?=
 =?utf-8?B?UGlWOUlqL2NkcVBaMXorQmRHYit6UHMxcGdBZVM5M2k0Q3Q5RFFobmxUTHdo?=
 =?utf-8?B?aytGQ1NUOUtlZkZkVmV2REkvRmJRQ1gwZ2p1TWVsNno5UHNaUWxPT1R5MGZI?=
 =?utf-8?B?L0RjZGNNalZEVE5TL0VOOFhKcFdJNC9ORG5aUW5mbk5VVGpiWk5rOFZReEp5?=
 =?utf-8?B?RWRPc1FObEgxUEdMRWpSSGpPMUtZNkpqUWpHNjkyQ2J1WFkvTHVoVTlsUmZE?=
 =?utf-8?B?SWpQR0c4UHJLTzdOeFRQa000SEdTaTNWc3BLVjVka0ZOc1VUazBlb3E3TmZk?=
 =?utf-8?B?b09IdDVjMTNTZ3BGOUhaYWkwNEh2cVdHOFpERFkxcHlKRUZYS2tla0dsZWtT?=
 =?utf-8?B?VExGQXdMQnJITlZBa2FjamlGSWhvaHJCNUlmbGZNeGhVYXZCZU15QUtXejNM?=
 =?utf-8?B?QUpuWEE1VklzbUtkZFN6bkdWSkpncFN6aXFZRkFidmdpWGU3ZzhkaEVBNEZ0?=
 =?utf-8?B?YmZxYXRjY2V2RS9YeGUvczduczFNZ09nbElRMXJsQjVBT2F4dGJ3WTBCcjFa?=
 =?utf-8?B?WGpkOXFwSTNycW5RUW9DbmVGWmNZSHBXSXBXL2RjVFJRbm5RSk5UUytUcEJp?=
 =?utf-8?B?TjdHSmhNaG5VS3pJSU5nVFlRRmVXakZJdko1SkhCU1ZJeUlHYVh5elk5eXVG?=
 =?utf-8?B?cU01TGZuLy9QTVVob3dGUjduMXArRGl4eGpXVmk1ODRLSHFPMFB4WVdmWnlq?=
 =?utf-8?B?RWR1YkRaemd0TTl3em9PV29hSFdJRXZYVWpKQWs0amJpaFRZN1FzTWJURGRV?=
 =?utf-8?B?QkxhY1BCTWNhS0tvQ1Y0TVRvbUVLYzZ6VjRmQUVzV3J0R3RqYmFLeXNVM3p1?=
 =?utf-8?B?UGFrVWRJYURqTk1xa3BUTDZJNGFqRVdEbFhRZEJMNnJ3alpva1FuTkZKcEg1?=
 =?utf-8?B?VkJhdG1uRzk4RGlzZTF6Q3BvWlZEejRNVUxkTXJUeFoxRVg0RHh6akhHcG5I?=
 =?utf-8?B?TXlJcVZ2c0V1b1NEbVNMQXNSdUJ5K0pqNXgzNnc5Z21ZVi84L21XQkR0cXNJ?=
 =?utf-8?B?K0dCMlBJdmw3UHVsNnFLOFpuVnA1U1pTRUtITzNBTUlmcUxnTWxReEY1VWtE?=
 =?utf-8?B?dEVGNnE4dHpNMWp3WlBoZnYzcnpBaUwzb0tHeHVVRjVIaTloTnFXUytGL1Fh?=
 =?utf-8?B?ejc2VDJLMllPeXN3b3hLbjYrbFhKWW5maWtzSVBoRXVlOGs2bUZhYjdhbnJS?=
 =?utf-8?B?Rld1N1RjQks2QkVQd1Nja2VxaFR3Y1VDZ2NTYTdzQlNHMnRUT3h5Z3MvZlN6?=
 =?utf-8?B?NEZwcnNiWlBLU3N0ZVhxWEtISU1CRG90TTI2dUxNdW8rVXBoS0d2ZWZMRWp5?=
 =?utf-8?B?ckdpMnRvZmtlN21FTXhlSGdoNFZDcHZJcGJqbFUvOW5NN1Y2MVd1cGZPOC9R?=
 =?utf-8?B?MDVBMlgvclJnUTYrcVhTeldzdGROTzNmV05MK0N6aGwwRERaN1cvZC9DS0Vv?=
 =?utf-8?B?dnYwV2pIU3lPSlllSlRJaXMvang4S20wVnFFQ1BYRE9vdVlQOWs2WHZlZXNM?=
 =?utf-8?Q?r+gGTEPMDprJVcSVFQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHBzS0RDREZFbTBUdGhpUFVoVjUzWDUvQXFUYlFEbVdvV0JsQnVoUWx4UGcx?=
 =?utf-8?B?R1JLLzFpdUdWYUU2elBBcm80TzJRVXRJQzI1QWFKczZzT1RQTkZhWXNPSEZO?=
 =?utf-8?B?cW5ydFh0UWh0bnJ2VFpQdnRlZ1plejh3YlNiVkFOTzRVanp4eGE1ZGRQR1BU?=
 =?utf-8?B?THJLbS9xSWFFcGZ4WjhRNGtmYmxJUDhVbFBRUXBWU3p6bSttYzl4ajdSdG0r?=
 =?utf-8?B?VHA4RTNHaFh4b09ad1F4L29SaWtGekh4Ri9lVGFpZEtHNjVWQlhUQUk5T3gv?=
 =?utf-8?B?LzFHdEJKaFd6WG5WUllQdkFZanZFUzNKakhLbzJOa3R5K1o4OEVBMHJCemZv?=
 =?utf-8?B?TlFVdmExakxOaWpSZ2UrNy8rSjkvN0dFK0V3b2JuVTRmVjBtUmRpbmx5WHd4?=
 =?utf-8?B?citPWjd3VkpxdmRTQ2xHbzJXRWRHUy9wNDFMNFEvZjhpcnNLS2Y3aHpYZXlZ?=
 =?utf-8?B?UXRjdCtPNlpGMWpyb1FuSXZrVHZrcmpSMjFmWU1nWUF0YkpZeC9MQ3VNczQz?=
 =?utf-8?B?UVVEdTBadGlNQmx1ZzJ1ZWpkWlhPZ3pDeXVFSWpIY1p0N1gxdTZiMlRFeWNt?=
 =?utf-8?B?dnIrOVJUZlRCbVJ6cUlWV2hwOHA2Y05GNVZTTk9ubk1oczRoUEJvZmF6TmtD?=
 =?utf-8?B?ci80bDJmNnNST0VKUm5mbFJINTNNNjhhTlhEeXBxT2YxNU00QlZaRWV0TmxJ?=
 =?utf-8?B?Y0krOFp1R0xEK2lXTFMwMG5tdjhmNE1WMTAveERieEg5Z3NhRWVlR2srUENF?=
 =?utf-8?B?NEZrVXBBRVJLTkRWVjNoeFl2d0hRZTUrd1FwTDRRTEppZTVTRXc4WXVQSEwz?=
 =?utf-8?B?bFd3eDBUd2pwdFg5a3IvSHAyUzVUVFhjQ0VUeFM4OVQwekx4amhRSXB1SVRP?=
 =?utf-8?B?ZkpXOHVMZzl2bHZQdnlNZ0NhYlhTTGJKQU1XYjY4T1g5Z0prcjVkQkd3eE9r?=
 =?utf-8?B?RGlvWjRYUDZrV01zS1N2Z1lPeFUxQmVwS2Q0d3U2T3AzZ1ZXL0hQcm8vendm?=
 =?utf-8?B?THlJc2xVcXNEV25sYUVqQ0JOVE9JZ0hyZGZjcWFQa05tdm5Ta3JBcmx5YXNG?=
 =?utf-8?B?QTVtVEY1SFl4UnN4M25ZTEwxTk1BNkpjdGZobWVkUW1aaFNqcENYYWcxdEMy?=
 =?utf-8?B?YmtMK0YrdEYvK2lwRkJiRlorYzN2ZEVQOVFIcUZIY21XUldXd1VCZ0RraEcw?=
 =?utf-8?B?T085MHRuTSs0UHBhSzc1cEdpcVBibmdzRGFxcVgrc090R2dTYXZOdzkrSWl2?=
 =?utf-8?B?UTVwSVl0aVA4eUYzS3czNXRBSUtIMFBmZjFvVUtma3VocmNTYm90THFsb3Aw?=
 =?utf-8?B?ek5wT0h1d05kZlF2YXJYWWZYaHQyUkJrd2tTdWcrSDdCc2FvM2l2VGlsY1RD?=
 =?utf-8?B?V0lGOTZjZjlvZFJ6TTE5cDU1UnNkNWg4YTJyNkptUWVCdHFSbEkyL3ZNeEsx?=
 =?utf-8?B?YzJzV0xLR1dSc0Z2WFU5QVBlQTBBRVJCa2JlMkN3NlpJTHd1UXZKdTFlcFFW?=
 =?utf-8?B?STRqMTNZTElnZGY3bjZrUTdGblQ2ZFF2clNrSUNuRkozQ2FSVDZvWHdUbnYz?=
 =?utf-8?B?dzJSR3RVYkNtN2dRdXYyV2JoRk5MdC9uakZxNDcxUlN4N05PYmhKM29pVnA5?=
 =?utf-8?B?cktTQkdqK3djYStTazJJMlJnWWlleER6ZHNrVkJINGpwZzdZcFJYVDB1ejRQ?=
 =?utf-8?B?bCtocHQ1ejB5RHo1cGdyWlRya2pEOHZ1QWY1R09BaDdSV2xpWkcvdWhoWitk?=
 =?utf-8?B?RjZ1cTFrejkvbSs5L05tWmVhSnZtbFRnUis2by9Mdi9QZjBjNVFUdjQ3L1VV?=
 =?utf-8?B?UllsQmxzblRZOGlzZ2xueEtCbHFSWmN6RUlBREw0ZzFBNFpKeFI5c3lVbjd6?=
 =?utf-8?B?RVFranhEd1U3QWIvcnVRZkhDRWxWaVltdzV5cWVOSGlTS29IRlVwTDYySGFX?=
 =?utf-8?B?VDJrMUhQeEN0NWg0d2ducXEvVHdYV1RyRERQL3NxNlpjazlJWVpOd3RDa3Ry?=
 =?utf-8?B?Ykx2aHlKZGl0MGtkb1RRb3BXRWYrckxNSktuVlVUeTYxaXZydTQ0Tnc0elVr?=
 =?utf-8?B?WUZscHBwTDNmb2FPTmdqZ3doMlFkUWxwZS83QXpPc05xd2wvZUVoNTJVcUsz?=
 =?utf-8?Q?UJwJdblmwhLKv8XnKSzhl351q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac8b659-d683-4b48-dd80-08dca079a9d8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 00:45:58.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRA7LGEApTo0S2LPegUq8i8wO6En0ZuLrlL72whcNDHzrFyACF02pI3UwCdyMmGUmK3gPEjbtLcsK09S7YnCCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4983
X-OriginatorOrg: intel.com

On 2024/7/10 08:48, Yi Liu wrote:
> On 2024/7/10 04:49, bugzilla-daemon@kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=219010
>>
>> --- Comment #5 from Žilvinas Žaltiena (zaltys@natrix.lt) ---
>> (In reply to Liu, Yi L from comment #3)
>>> It appears that the count is used without init.. And it does not happen
>>> with other devices as they have FLR, hence does not trigger the hotreset
>>> info path. Please try below patch to see if it works.
>>>
>>
>> Patch fixes the problem on my system.
>>
> 
> patch submitted to mailing list. Thanks, and feel free to let me know if
> it is proper to add your reported-by, and add your tested-by.
> 

forgot the link. :)

https://lore.kernel.org/kvm/20240710004150.319105-1-yi.l.liu@intel.com/T/#u

-- 
Regards,
Yi Liu

