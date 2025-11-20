Return-Path: <kvm+bounces-63836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1075C73FD0
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:37:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 50A16302BE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AB7337B8B;
	Thu, 20 Nov 2025 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjfNMc4v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23973128DA;
	Thu, 20 Nov 2025 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642240; cv=fail; b=m3wL/DSXOrhMBd+otAuiVvckelsBHTxtgmqk3N1Hf9NOIeMSPj1QbHVJV0fEyx0m6yXU8NOitVIC5bknGGIZsPCvU4JCHxDQCsbWcG1vkyaYLzzMA8LbZcd6F06N1xWKdCvn6gGlOMWzNM6YLBL2DthWPpQlO4IUHhqX/XikHyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642240; c=relaxed/simple;
	bh=kADOPs+MBM3vAkaNpdCqGEj7oHDxYO41uTEHNE6Jumc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sQzwjjZei+OzhmBaPDhcbNRFKGdy10chwNJx38fTeyM9jVxT9smGa95mHtFc3AMHk7yAv3Pi72P7t6p7Fvf6jN4U7PoFqcocVb2FSJNnHOYI8BlkNJ7lykwolQc2+hRZAHnPj52Xup5YbOiWRqIpzJVH5IfH7bV2loL09IB/Aic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjfNMc4v; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642239; x=1795178239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=kADOPs+MBM3vAkaNpdCqGEj7oHDxYO41uTEHNE6Jumc=;
  b=MjfNMc4v87ivF1M+MocbxqlRMcu7rBnJzKu60U1mVyqCHEQs/3a8qzm+
   sMppD+C/hjepQV+DSs3Zr+C3LSb21eHXjYn99JQZLvuN9w7m99NI987Hj
   Pl+WSKUCd6wsfZpOgSPTRbv83Ccz/7c49Yve1r9EbpyXqHBPD2YC+/amB
   AgXXbPx2vSrcymUcR0cWK9jVn4ARZ5bB26Sij7kjrGTB/u20QVlnJoDkq
   JjBHBRqU4lLcuSYjTMqRciLTaG5rqvq5f7Im5LvWkBuZNrj99kUpq+OW8
   RxZNR8C6LNpVWG2z6ve5nxNXSmPjtnWYYdSwGmIi4gehH0OiGbsc0vNQK
   w==;
X-CSE-ConnectionGUID: ZJ8uzKLcRJqZ0Erg1j1Ygw==
X-CSE-MsgGUID: wXelI+QZTtSvEyuQJ6/IsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76037833"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="76037833"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:17 -0800
X-CSE-ConnectionGUID: h77xGmGURzu48kBNJmv8PQ==
X-CSE-MsgGUID: Ed43JiNvQK+aCBngFHVe1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190633867"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:17 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:16 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXCV2XiSo+lU+OMsI8y5IAiWsaU/IYhc+UE3VWEyfsz25pmFS2JOBItqRPkMiSk4UT7+7rG0GYCWEkyKRV7MkEvDDjT/NXxN9Zw3Eedm7cqnXiQR0iM78fGV9q1YiRngRdAZC9UTVMMqcL3lo1MGcwVeSNabTNBhznYhP2kZMJUoC41kWOKEM2WzCtUMKvlsxGTdyrG0L8lxk7/OCc9/4AFFXcsJG3odxx3+5KV1Q0VJVUpubR+LCC+jiHUr4uVxl7ldMEZyDASXrqG75ES2qi3mBQczIOzqNYLqW3NhloVgmDis6Aynl38WyIbpc2kl5Gu+4++Xlf1y/lq/gDx5pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PmAqitC5/HnaDc3C75JS9DjJkk5I65ywWV3oCGsImu4=;
 b=hgd3vgr2V2A55PiwFvp/WsYI8VocKEfpKsCN8ApkekXYxGn6olyPrSkYB/6mMsilBBYmOqZmA8cO241nOyAgCOgg1FeytFu53G2rTlDr80bfW6izOV7Ao1uu9zNE+ZTjPbLbVsNLP+SqJSgDluGe1fahgmw1H9i/rzjsg4JjO1eqO51gEsegwoWcFsWykqVWAA86CFBS6LJ/z/rngEODGQkTXhHvZXLW6bqkujjpRkwnvqFJlEt2MrIvQd0rVQeycU8gxUxdY+9c5hGWMua1/dRhv9jzN1SsV8Hnv0jq5bUdf/8TlL/oUA7susVW4jl+vP8aPSHXtoX5CoN3+OWsGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:13 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:13 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 2/6] hisi_acc_vfio_pci: Use .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:43 +0100
Message-ID: <20251120123647.3522082-3-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::19) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: f33637b5-5602-4b2c-f0e0-08de28318808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dGh5d1pTa0tlMVQ1bHN6QnFsUVlYRmFHMlNDQ3JDa0lGa29SQUwvOXZUdDc5?=
 =?utf-8?B?UUk5RHN4NDlGVHA0RTQ4a1lURDdCNVJZQmZHZlFhQmlNZkUyay94RHAvRlla?=
 =?utf-8?B?UWxWUFVENmF1VW5tck5DemtqS0tCRmNuZ2p4UmxjTUE2UEhQc2ZwY1NXMUNE?=
 =?utf-8?B?Z1RJN1FMUHJJMll5cTYxUlQ3cTNlUGZPQW10a0RKMjZuYmwveGRMNEZGU0pX?=
 =?utf-8?B?b3pXVUE5UFhvK2IrRlhrcTZvVXlMMUl5VWZlU1ovRDhlTGFQMTA1SjZ5Q1N5?=
 =?utf-8?B?K2hWdTBjQUlPejRPblZFNnh3a25vYWNQN0R6OUs3ZEVaaEVLclNRMnNjaXRz?=
 =?utf-8?B?TkhsMzZkQ3lKRFdiRnRZeUcrdUt6eEpzOFNrMGtXdjVxZ1E5Z3R6cVpZRUdN?=
 =?utf-8?B?TitaUm1jdUVvNG9qb1BxN1lYTjhYSjhUb1hHSzBJNDFQbFJPNnd6bzRqYjdR?=
 =?utf-8?B?K2x4c0RWbWJIcTZUZ3V0V0ljb0VETmxVSXl2KzVuVEdvekFvZXFFT2FIemFG?=
 =?utf-8?B?aitCMWRzYkZHN21kKzhncml2T2tMem1OcjByeVVyR1Z6eEZsbDUxVzlLWWNU?=
 =?utf-8?B?d1JSd2lHUzFDQVdEN2M5QjVpb1hUeXhKVTJTRnk2a1NNUVJ4b3AvYUJKRG4r?=
 =?utf-8?B?djFoMjlaMlRtckFLSE13S3V0SFdVQ3dhWlBwcjF3SDVYV0g3S0JrQTcxTnpY?=
 =?utf-8?B?MkFXK3dCUFJSS0xsZ3U2LzBDL25CSUlzK3MyMkhCV1p0U3NVdDNlUDlQNkZu?=
 =?utf-8?B?ZGtOZzBkdUlZa3JUMy9hZGZ5cHI3U2k5MUEzWVd0dzlKUy9CNTdVRUlJQmtO?=
 =?utf-8?B?aWlacDlmWkRDanljUlNLUTUzSExUTmljZWFFem1lN0JPdFEvS1ZuRlVYWjYx?=
 =?utf-8?B?ZXFka2pJd2pVNEYwZkpldEQ5MHpEZEZRbCtkaTZlSnZXdExHUHcra2g0OVR6?=
 =?utf-8?B?Y3dsUXg5d1A3NXdtaWxMamFKSjRXWUJIOUZSR0RMV1d1MVlzaXU4N0JJQXdB?=
 =?utf-8?B?NE8xanBkekdNSUo1MWV2SFlXaWsvSU9lY1A4UElTVzJxWEZVRUhsV054eG5W?=
 =?utf-8?B?dnZWbUNEUDM0YUVIOElNUEc3UjBUeEVNZWlZQjRxcUdESnlJSFROZDMxRTJZ?=
 =?utf-8?B?S25QRUFaUzlva2hQb0FsUjdRZ2N0N0JMQzMwUlJTdDlLSnJKcFhjR2JGZDl4?=
 =?utf-8?B?OUhCZmRWL2pVeDllMUFDVWp6dUdNVVlyOWtiMENFLzRKWDkxYVZXaDJ2RGN1?=
 =?utf-8?B?bi84UEtZR21ycDlBbWE2SEN0cDZpSHNtQXdBRzBTaXdGb2pZVHNQM0p1REpE?=
 =?utf-8?B?TUt2bTRNVnNKQ1dMc2hibFgyUDJLMXZYOU5HRk5ienNFai9SQlBaSGtHRjdS?=
 =?utf-8?B?bjdWSDI5SjlvMnVPaDNSbkJ3QXpwbk1QcjYveDVhWEtFUm9nNU9pdzN0S0xz?=
 =?utf-8?B?ejFZMCt2QktpbEdVSE5uS09KTWY2eEpkQmRvYTJuY004M1FYL2x4OVZrUXJ1?=
 =?utf-8?B?Um1zaEswZSsxdy9ONzlmdURoV1RNbUUxNGQrUjBkN0NmcWRieXBDNTZvNmc5?=
 =?utf-8?B?eWR0TEcwb0hxREJWTGh5dEZINkY0ZklkRHRESlhDU2x2Q3lZYTZTQktLQ0dl?=
 =?utf-8?B?MlU0TmIrczdrTFJ6RERuY2ZrWUJRWG91c3NhRFkzZWZRSzluNXArTzc3Y2dj?=
 =?utf-8?B?VXRTYmFHbDFYZml1OWlvY20vUTc4UjQyWEVqLzhUUVF6MmxJV1U2L29SeEY5?=
 =?utf-8?B?SjRqYWhvMmtRc3hQZjFYMVd6WVhxV05jUnM1N1FFbVlHSlNKYmRFMVhWNlU0?=
 =?utf-8?B?V3N4RGFZOFJjdW1hQ2NqSkwxS3RRQ1VFblVySGxlUEhWMFhSSnpVckxiSVg0?=
 =?utf-8?B?bzNZdGRkV1dRc2VNb3Fyd1ZIRHJnZndmYzBmNXBWYWJDdXhrMCs4TldiZkh0?=
 =?utf-8?B?RDlEakpmakxGNkR6RTZvNm1ENHFMME9LdUFLR3BOeDdSTTB1aWt4ZGpvdXdP?=
 =?utf-8?B?QlQrUUVhTFVaK21QTjY1djZnVEdsbGVISG82NC9BTEJheEptbDV4dW5MbDNP?=
 =?utf-8?Q?d7J2je?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVAyNFBsZkJyeEgycUdWRGMvak0rUWhQNmxUNTFocjdZekpqd1VMaGxzMW5z?=
 =?utf-8?B?SG9HcWxvOWlQazNEZHU2ajlXNFpwTVlPaDE3UzVHM2RYOWUrWnlndEpUcDdX?=
 =?utf-8?B?SWJ1RFNGb1BhZFJvcGIxbWpOYnRoQ1A0cy9Pdi9XSGlCNlo5eUMveVdJdUhQ?=
 =?utf-8?B?bGZRNmJQbGppTmdUR1NRbG94Q0hVcTBaWWZtNDVCdUNiYW5KYnkrUXd0L25J?=
 =?utf-8?B?UlpnN24xNUQyNUVhZFkwV1pOZk5sZ1ZiMHZYQXI5SndHRkxYcTIrR2dYdjRn?=
 =?utf-8?B?a01EOTBkQ3VBYXE1TUl5WXFEMXRkVTl4T1RyTFVVaUhGUXNPakFCZ2o2VEJr?=
 =?utf-8?B?UFRYendnR0RmaHluR3d0RzZWcW1qeDg4Mk0wRkQxTWpGUDdLRllNdFpKcThm?=
 =?utf-8?B?VkhsSmdWMklsaTU5K2cyM3FhYUtHV1hOMFpEdXZ6UmRHSkNCdkoyNW93ZDd0?=
 =?utf-8?B?R2lCNG5vYloxRDJ6cEpHd3NrZGJRY0RmbkdyTVlHdXVKVHp5aE43NGlpSGYv?=
 =?utf-8?B?TU81Q3ZsS01pZmJXUFZPTkZzTkErSi9oQUJNbmZGdGZEeDhqR2QwUTVYaGtp?=
 =?utf-8?B?ZEE1WVJmdUk0R3Q1SVExNGtONjJmdFFITWt1cUdTdVFTSXMrNmFUaWo3bG9p?=
 =?utf-8?B?Mm0xNk55UFNwUFJrOEVFZDU1aTBWNDRrQitzWkdpSVhxcXpKTCt2SCtFRXYx?=
 =?utf-8?B?cmZpQXZld0ROVmw5OXNxaFdxQmhhSFNZTU5OcFdQanFwMlZOVllIZTY4UE5x?=
 =?utf-8?B?OTFhbUpXdGlTcXFQSmtiMG9oVTZ1Z2FXeC90cGo0L3p1K0VZSWp3Y2QrQUN1?=
 =?utf-8?B?ZGNLYTZHWWJaRW5kVWxvRWMxcUxSMEVoMklnYzNFTHgvd1VZcTJYaEU2a01o?=
 =?utf-8?B?TFduZWkzRHcwNENxdG96RXNpZ2Z3VjliTTBxdGY1d2hyd1R0ZklxR1BhSmwx?=
 =?utf-8?B?M3Zvb2h6a1NaemR6U1ZYUU9PZW1BNjFveWdxckE3NndaTlAvRmNES2diMVVv?=
 =?utf-8?B?Sm5vTmFUdWk5WUVXazNCZWVWMzZDYTN6TlJDeld4cXBYVCtPTTNWbnljUjBX?=
 =?utf-8?B?ZGhyM2lqWkxDN0Yvd3lRdDA0R3dpRXllTUNRMlJRMDZRT1BDWnlRY1IwT0dy?=
 =?utf-8?B?YmRvQStJZ1JLUWRFNlVqbU1lbi9xY05JUG9WYlJKYWZxZGhwdE8yOG8rdXVP?=
 =?utf-8?B?cUlsSjF0OEt1dmZ4QjUxTWlXN2t1ZVpwVlB3T0FOai95bkZQSFA3OWhjYjRY?=
 =?utf-8?B?c29MaGFLNm9XRnNtbUR4Y1BDdi9LeUxwVytjV2ZucHl0WmRRU1Y1cUFRV25R?=
 =?utf-8?B?VG1Uc0pNN0N5MW11QndVQ2VnYXNBNnRxTDAxazVrdEFDT0cyUlpTZ2lEWkV2?=
 =?utf-8?B?WWtMNnRIeUVQeW1uMWhWbDNWUEtlbHlxVldlTzVwUE41SGk3blJDMnNmUk4r?=
 =?utf-8?B?WXJ3andQdGNSRjc4cWVWVGdWejZUcE4rKzVrcUZJS0ZXMTdPLzA3aCtrMmZt?=
 =?utf-8?B?all1YnQvUUN6WHAyQjRtQnphUXF5T1N3NFhCWW80WTJGTGhJTy84RkZDc3Z4?=
 =?utf-8?B?ejA4ZHlRMzFwWG5NdnBoSVl3b0N3elJoZmJITlJ6YWhVam4vM1U1TnkxUUh0?=
 =?utf-8?B?YUtoc1FRRkdmbDR4Z1djUFBLRTJGZkF3c25LcThScy9RNHFnY244OFJMS0J1?=
 =?utf-8?B?Z1c4V09nSTlWY1dwS1hiZ0RqOWlpdmpzY1hndHlLejNjWUNBSjZselJzQjZj?=
 =?utf-8?B?dEVhL1JSbjFiOHYvQm1uczJFL0xleUl1K1NZc3UvekVvUTl0VXdnamlpaEpZ?=
 =?utf-8?B?QmdrY3hpZzlzYnE1Sy8vOGk3UUYzdnB1VVM1VGNDSklha2YyNEhqcWZ3ZWF3?=
 =?utf-8?B?NUpjUEVOd1RWUERwenNVcDNyWHhhRTN3WmNGRkF2RE15azB4MlhCc0xZTFY1?=
 =?utf-8?B?c1JZcTNKN3RHYkdsQzhCYlFUVDRrVFZ4UE9HQTJVV3dFNXdFUUZ5dGVaOERj?=
 =?utf-8?B?TnRpNE5nV2w2NEswMDlOMGZrOEYyUExXUlFPTERUMEpKZFVRTUdBSnVaa0N2?=
 =?utf-8?B?R29mZ1lvYlJyeFBFUVQ0MjJFR3lxSnBTK1VCNUlVYXV3THlOdU9FRHRWbUVF?=
 =?utf-8?B?WEhJL05XN2tMSkpweUZEZHVQM0JEbEgxeG1vMUhKcmU1MW9OZEdYQ3pPekpP?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f33637b5-5602-4b2c-f0e0-08de28318808
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:13.5911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFz+byiIjjO4aHmu9/Jdo7EKNV06sMSu5pGFdWvtb72NM+yrgJq+B4nd5/0ppUxggO/G6MC5oomW8Zh+uBOZOMSsNGAnhsNEfRoTDAfUVXY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Move the migration device state reset code from .reset_done() to
dedicated callback.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index fde33f54e99ec..eafdf62ee29ef 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1169,9 +1169,10 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 	return 0;
 }
 
-static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
+static void
+hisi_acc_vfio_pci_reset_device_state(struct vfio_device *vdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
@@ -1529,6 +1530,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
 	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
 	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
+	.migration_reset_state = hisi_acc_vfio_pci_reset_device_state,
 	.migration_get_data_size = hisi_acc_vfio_pci_get_data_size,
 };
 
@@ -1689,7 +1691,6 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
 static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
-	.reset_done = hisi_acc_vf_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
 
-- 
2.51.2


