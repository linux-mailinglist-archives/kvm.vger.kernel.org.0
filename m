Return-Path: <kvm+bounces-62076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61AA5C36534
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:28:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A8F51A239FF
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A594233F8A8;
	Wed,  5 Nov 2025 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VmIFAXAW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F6433E37E;
	Wed,  5 Nov 2025 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355556; cv=fail; b=TFwAUIpnEEBYB7LVdSRjins40C1WsA4Rp/X11FP/p7a5XYcXon3JwUdJnaodcdWBbyRAPnGDai76xwWStjBvUH9Df9yzWYr0g8iqRbJ6WA+8i22OwH7EByWVYEnElMTaxkU1xhDt7s01EXxvga8yT4iAYXo2TiZ9RltiIq4lf3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355556; c=relaxed/simple;
	bh=sy5RpFsbdh0+jlzLuDDdRops8jm3C2IrobkwYzwFWYE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fSKwGH1+mLhYqdLBDRZWODS+U3IIdU/gP31t5pNrn4VW+hb1XYpZITdY7hc3E8Khy65NlgQGb0Kmm/bpCmJwjyGrXZNy5L7ues6if1nsyDesUnqRuyGgt8HkCc4hda3ui/WuLNzbhdIoBr/28/+KFUaqaaumLXdelxrSPEIfXzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VmIFAXAW; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762355556; x=1793891556;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sy5RpFsbdh0+jlzLuDDdRops8jm3C2IrobkwYzwFWYE=;
  b=VmIFAXAWCDW3KHaE6S/YOqehYMMc0zTVPAMqlV4MpZR+0pGZkyvugLfX
   hzxceBCw5mfcZEOYoJtiVbk1nyv2R7WK546P79PtdJALUUB5uzyXC0YCO
   zlDzQUmUg02nIik0QFKGQCbpL27mGYjjhr7J+9eFdDemL4qpNSIfE/6Py
   Clkoi4FgDHqOJwt49EOUMPV5Zw53O00o2NOiflQXzxTYi3frd84lsVWwY
   ixugJdkQDAlnUPDrR91qkqDfMrMQuL09QtMmL/vlSE85wjdJu/84G/voR
   VdugH55NzjLb41D0XRzNErG8smcFa8flVFHozAGepOpHos8T6PA/z/RMS
   A==;
X-CSE-ConnectionGUID: 2uwEAoDMTpuXhxUTtqzkYw==
X-CSE-MsgGUID: e4aS8gUDQYWQt/fjJHXR+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="81875885"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="81875885"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:12:35 -0800
X-CSE-ConnectionGUID: zRr6eWoxRiaf8FD+eHjruA==
X-CSE-MsgGUID: Iw+uHLPzQpqItfukC5wwXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="224725772"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:12:35 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:12:34 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:12:34 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.5) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:12:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rl4xx9OYrjQOFK8B0LvXsSeQfSPRk2Tefn/jemI8cdWTTY8Cex/p57ygrFV80dj84v+T3xvy4Xymj9I+YsJ27hxGh/5mRXYW+oBl4+QgA95ulp2Jl4/C5JViNkDozwJs/D3C6mu3XSt4pmverRG8s9KyazmWZWsT0JRQKYBX7xtQMLaB86NB5UOh7mQIVS6RhpNggmjGMqsAfUqIKlE/CFB9eiKrx1KRWj5VxCNktkEvX9DgvikzEAGBMYSdTAZ3hMkJG/3dpJj+rtyJ1TLZVhMcnZeu6xNJbTnqMRpDeyqCQl4xx/IlzW+P+5rduq+mURpLLI3WM6J2PRzuK82ppQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UdVYbj5gEwOs26hzcnkdmCEMWY2uRI27YQVc4IVT6Jg=;
 b=s1upPqrZ6DR3788l5CihfSWAhvuUNE+/K6povqn9QWeX735BIHG+XE2YLsruR9aSp7W+5CaEKl53Mp0S+xPNekHVq/oUzqIfL10SyLrNt+aTpcHTFQyA4bzeh/z3Xmg0Fjxvg43P2bay3rxLV3+z2p0CMH+71Psju2gpEtlovZxsYPNfyKbDXDKMA7EkMYmCaLFOEUjcH/mi8/UXZDsYrFL4VVxFuJcZUIWOgrO+Cxp4CbDs0TVLuNFMBQqf3XYxHBANde2c5P6u7hXIbyOsC/cq3c8xmfF64A6jW7s/ZBHzmw4z/gb0rGwVcV1SeYgPExAng5jS5beZDlRBsJlb2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM4PR11MB8226.namprd11.prod.outlook.com (2603:10b6:8:182::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.9; Wed, 5 Nov 2025 15:12:31 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:12:30 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v4 20/28] drm/xe/pf: Add helper to retrieve VF's LMEM object
Date: Wed, 5 Nov 2025 16:10:18 +0100
Message-ID: <20251105151027.540712-21-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105151027.540712-1-michal.winiarski@intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0335.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7d::28) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM4PR11MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 8538dce9-3feb-4ef0-eb9e-08de1c7dbcbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YWJ4WC82aEhmM3JKaVM5QXVKaEw3MzRnOTgwcXhzMXpHeVJGZWJ0dTdZTlMr?=
 =?utf-8?B?YXlJOFBZaVlndDc0S0xUYk4weldjYVovK1VMeW1FdmVKNjRLWlRkZjE1U3ZB?=
 =?utf-8?B?bXBxanNZWTRZUDlFbm9scUxFSGhJUGswbXpOVzVmZHREanpIbE85ZTJLNDRX?=
 =?utf-8?B?aVV4TWZpNUZkTmxIQ1RIM1pUaWc5SUdkZEx6bW9OVmkzUUY3VGcxWFdPTSt6?=
 =?utf-8?B?S3NGTGhQaWE0SkpVR2x2SzNDRFk0cDhhZmZVUitTR2hiaGp4N0RpU21jZHNt?=
 =?utf-8?B?WFFQQjlIT3VkWjlDWFpweUdkWTJIN1BuU0NucElibXBJZng1Vk5vZHlndS9L?=
 =?utf-8?B?amJ4QUljK0Uxa252N1FEaFN6dDZkNmFibDN4WWZJYnhPbXh3NjlyU1dSNzFR?=
 =?utf-8?B?ekVsWTUvcHR6R1cyTjdKUUloUFN5YVRvcFVDck91QmFTUXhKWncycVhHMVlG?=
 =?utf-8?B?NlNwcWUxRk5aWmxrenVyRWdnTm5zNW5qRmVDeVJLcmJvdEM2QS9IVVJYS3Z2?=
 =?utf-8?B?UlllQ0R5TlZ3aVd3YVdhYk41VkFQWVhySmtQU01ZdTE1SFFhMWlLZHY2dVMx?=
 =?utf-8?B?L056T28xMkZ3OEVzQnNPWFRhdVkraDIvdjllN2dSV2FnOTRrWW1XL3RXR2hu?=
 =?utf-8?B?QkdGbElHWUZkUy9LcWtIVTFXem0yUUcrclg5dkJQeWRBU2thcDNINEJCUTZs?=
 =?utf-8?B?R0pISFFVc1RQL0Z3TGpVb0VKOGtFWkU2b210clgwY04rREExaTdkY09hdjJJ?=
 =?utf-8?B?STFQcUc3ck92Nkg3My84YzBlRkdUQmhMdC9tTmJxOElJbUtxWDk3K0dkcEw1?=
 =?utf-8?B?OFhTaUk0VGNMSEwvOWd6TGMyTUNqVTU4cXl5U0xPRDNLOXFRTHFZblRjeG5X?=
 =?utf-8?B?ZlhBZFpDUmo4cjVzYTJWNkk1aldvWHRFVGdCem12OTZNdVRuSVVFREYyTExU?=
 =?utf-8?B?SjYySG5uUUpCeFV4c2pxRGVYa3o4MXJDTVkzZ3hqNFgxeldnUE1HNENUUzJy?=
 =?utf-8?B?NGNmMk9MOTRkS1RlY2tnUkZ5V0NFeUUvbFNPQW1KUUFqaklxS3hpVGRuc2Uz?=
 =?utf-8?B?a0lKSmVlcTNEYnBrZlVIZkpxV0RuczRsRlZ0RHgrMEx2TFRPTjdzMjAwcVlJ?=
 =?utf-8?B?Z3lqMmxFdVlBbG1XQzY4K3NOMnJaU0h4eEtDT0ZBR0ZpZCs0K2hYVmsvczJu?=
 =?utf-8?B?TGFlVEJqTHVxaFpSZ3pGYmQrODFxWjB0UVBUVlQ2dlNwVUhIc0FSSnBtdnlG?=
 =?utf-8?B?R09CN1JiZG5DMXpoOUlPNytxTEthZzZzLzlVZ1Q1RTVzaGQ0UHFYSVdFYWpI?=
 =?utf-8?B?N2lYaEoveE9mbE9KampyTlQydXRka3pHWjhyOGVUWUM2djJGRXo4NXVhYllq?=
 =?utf-8?B?eE1VUThETloxcWsvWGxoMHgvSlBjVUdzdVVHZld4YjBzdkVHUisrRTRIR1Fm?=
 =?utf-8?B?U1RUMG50NmMrZ1RhZk92R0NOdGFDZmx3OTFHK0VTSDEranhZaVgwV0JScjJP?=
 =?utf-8?B?enFjMUdaZUFXNW4yUVVpVFl2ZHkrSHFlQko4ZUdhUGg1cHlWVktxcnF0UnlH?=
 =?utf-8?B?WVREYjBoNXVHZkxiQVFoU2xxc1pFdEUzT0pWeDEyQnlIUDdTenNibEFOSWVl?=
 =?utf-8?B?OHJIWWEwcUYrN1lJMEJEVlZBOVdjSkdnVTJZSDhCYit3TlRJVGhCZlVqWDlw?=
 =?utf-8?B?U3FLemt6OEJhYUtGZWpnNDcwTlJIQUtlWXliZ3BXeis4UElYNXhHUTN5Yk1S?=
 =?utf-8?B?RzY3ZXlFbHNBUnBaSi9ZNVoxaGpIaVoyRlVQa3E3OTBVdUlFeG5mOWlyWTRL?=
 =?utf-8?B?ZUwyR2JkbTF6RlRRRXArRm9VQnFXaXFTZ3JFd3V6WFFhWDV1cFF5VkZoZHVr?=
 =?utf-8?B?ZkJVWXBtOHF2d1ltZm44MDVlRmY3bExLTzVNY1BWOURNWlZEMENURjI2aU9a?=
 =?utf-8?B?eGdndVE0QmdzaStTbnBaUUw2by9UbzR4bWF0YmhsMU9yaVI3bjFRd2oyc1hQ?=
 =?utf-8?Q?YbIAqXvDnx0mBqjmGYwn9rMKjFVgnk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVVlM1N5bjNwRlJuZGkrZSsxNXVmOXN6dUdjZUQ1RVVTeDFoY2dqR0JGdmVv?=
 =?utf-8?B?b2NGWnNOK3VCUENvc29zRkNFT0hjNUxFUEJFb1FBRGh6ckNxNGJUYXlaUmpP?=
 =?utf-8?B?L0NNUHJ2L0dZR1lIcjdKeEhiRDQ2U1h4Z1V1TUZ6UXp5a3NCVG8wcTc5ZExa?=
 =?utf-8?B?UW1Zd0pSUFpRRTVlQlNYOGdPb2orNXpldGljV2FGME0xTDBKbDRiS0lDQndq?=
 =?utf-8?B?ZmVvYnhkamR0ME5FRXZ6QWtxR05EK3RwMUdqY0YraTJkU2hZbDhLalNqQ21t?=
 =?utf-8?B?V3VkZ2Q0ZXlSN0VXUFRKeVM4SVJOQnc4bUpYN3J5U2EwT0t1azY3QUh2dURQ?=
 =?utf-8?B?ZGZ2ZDZtaXBIKzhOZnRldWdzdFRKNjNPVFplaWJldDhvblNZNXMrQUxiNG9a?=
 =?utf-8?B?Q1M0RnNTcDdweU91d0pwd1dVVXUwNHZWVFVwOURxYXcvSnArbHNPWWl6dU5z?=
 =?utf-8?B?V2x0ZGpOdXlLSnB5V2FVNHdKUWZ2NHFjbW9mZXF6SlZmZG1RUkd4OHkyT3VZ?=
 =?utf-8?B?eDI0WkJkN2RRcmczcTNuZEd0NlQvQ0gzdkxRbVl5TVdMQVN0RU5ocTZuRVZC?=
 =?utf-8?B?aE81V3hjdGhZUjd3MlZOMWd1SEszOXVKUHB3c1B4RlBkR3JQaWRNeUNlWDNV?=
 =?utf-8?B?ekh0QVVvYlVvNTRYYW45VXBCM2JHOVNpMk51ejNTNmN4N3Z0SWtwbXdNTDJo?=
 =?utf-8?B?SWhibk81MWt0a01DRGJ0QzJXS0ZER1BWSVdsYlZ0S0F4OTRvNHA3U0QzZ3pp?=
 =?utf-8?B?QTBRaTZ5YWtwaTkxT0VUeTVsUmdOMktJNUVBdHJyU0N4KzB4U1VGUmtyVTZr?=
 =?utf-8?B?em9QRnNGL01SdFFvVXcxdktwOG1XYWRsMktCWG9qQVVpWVBTRnM5UjAwT2sr?=
 =?utf-8?B?VGN3ZmxPN3ZOaS9QWHIwb3JrRXFDTlJZSm5DUWJsMVpPcFhWYzN3WW1zUGVt?=
 =?utf-8?B?ckkrTkszZ09FTFRQYVFQc3pFdDYzejRjUWdveGRhTHFUTGJqS0tqQmhwU3Jt?=
 =?utf-8?B?WExiaUx0QlZibHJySnRqYk1WTFpLMlZYVXFHUldCdTcyenFoR0dBNnB0VzBO?=
 =?utf-8?B?czdDWlBMQTdEeVljZ3pzS0NCWEVKemhVTy9LNzcrbEtNVzdxYnFXdThMdVQx?=
 =?utf-8?B?VExnL1NSREpqd1lqY3ZWSHBINVJjSzB1M2JwdHNSbFlmWXZEWnlINWlHNFRn?=
 =?utf-8?B?eHpsSUsrb0JIMWRvQ3pyM3BvMTdUMnBFNnZCMUJOTG5MSCtCdXB5U3ZWSllI?=
 =?utf-8?B?TjBwTkloZVZhYnZFMUlBUEVCNVBKemVVV0RQNWFEM1ZOM2h3K2Y5REhxZ1Vv?=
 =?utf-8?B?VzNzTWhyTDc2dkJtTXpnR3NNaWVMU0pZeDdJYTgwWTRvT2lodjVyTWwvMjYw?=
 =?utf-8?B?empoSUZuK3gzYWdIK243aTlyVUlLODlVbGt3TWRGcGRzeDh3YnlXZFY4S2VE?=
 =?utf-8?B?NldXVGltV01EcWJRTmVLNk02cnl2TWdIenJ3QjJwV0hQd1J3NVcxMzVuNUp3?=
 =?utf-8?B?NGpWM2V4K3VQVHZ4ZU1yb2svQW9pY3VWRjlvSytpSXZQaFljdUZFRVdzSUJn?=
 =?utf-8?B?ZG9PVldQVy9xSU5HK3NlL3JhRFFabjJEek1USjdDb013ZHdhUVdKUWJqYWt3?=
 =?utf-8?B?djNrdjR3SjVkdVZxVVZVTU9VVHhxbDZLenByeDMxYXE3L25OMnhQdC9FSHdU?=
 =?utf-8?B?cmYyS1U3Wi95OTR1V1dua1I5cjZpbDBnalBkbVRzQ0t5U01GamVpRWM0Kzdj?=
 =?utf-8?B?Z0hMeEZwN1E0cTA3SHUwUWcrSWNXSzJJTjZKR0QzNmRnL2xMLzltTHhGdm1U?=
 =?utf-8?B?UC9HQUo4enE3Q1g0R3hCdEV2YlRQdkx1MzllalFBanBHQ1EwVVBrMHBibFkw?=
 =?utf-8?B?aDBoWnZ3TzJSNGh6bHB0bEtCMUxXajZZbGRqSU5Dek9rVlRsNVVabXQ5bG9U?=
 =?utf-8?B?dU9tT3QvWXdVTldSUDExSWpPcWltUDU3SEFTL3BQSXFZc2hORlJ3cFdqWTF4?=
 =?utf-8?B?WU1NbGFEVk04T2todHJwUlZFOEducnNnYzBiaVNlOHRYNVlvcGlReG15MCtJ?=
 =?utf-8?B?amRVVzVTUjBlNTI1Tis0VEZyT0tReU5UdkRyQkxETys3NE5CTTRBS3J2ODBP?=
 =?utf-8?B?MnNzWE5KNnFmY3Nsck1iTXdLeTcycCtQcXBDTTZQbW81bFZFY1hXQTR5SFhO?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8538dce9-3feb-4ef0-eb9e-08de1c7dbcbe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:12:29.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2G1kIEkZkIbjhZg2tdJY4uEBQTIDhiQWeN2mnxGZ6EgC/iFN0hwOtb+caK9rWvbtM7slt9PUKR6IlJFISa1aEWgXRZl/J5qsNusrK6LbSpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8226
X-OriginatorOrg: intel.com

From: Lukasz Laguna <lukasz.laguna@intel.com>

Instead of accessing VF's lmem_obj directly, introduce a helper function
to make the access more convenient.

Signed-off-by: Lukasz Laguna <lukasz.laguna@intel.com>
Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c | 26 ++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
index 2786f516a9440..79e15bc009337 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
@@ -1654,6 +1654,32 @@ int xe_gt_sriov_pf_config_bulk_set_lmem(struct xe_gt *gt, unsigned int vfid,
 					   "LMEM", n, err);
 }
 
+static struct xe_bo *pf_get_vf_config_lmem_obj(struct xe_gt *gt, unsigned int vfid)
+{
+	struct xe_gt_sriov_config *config = pf_pick_vf_config(gt, vfid);
+
+	return config->lmem_obj;
+}
+
+/**
+ * xe_gt_sriov_pf_config_get_lmem_obj() - Take a reference to the struct &xe_bo backing VF LMEM.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function can only be called on PF.
+ * The caller is responsible for calling xe_bo_put() on the returned object.
+ *
+ * Return: pointer to struct &xe_bo backing VF LMEM (if any).
+ */
+struct xe_bo *xe_gt_sriov_pf_config_get_lmem_obj(struct xe_gt *gt, unsigned int vfid)
+{
+	xe_gt_assert(gt, vfid);
+
+	guard(mutex)(xe_gt_sriov_pf_master_mutex(gt));
+
+	return xe_bo_get(pf_get_vf_config_lmem_obj(gt, vfid));
+}
+
 static u64 pf_query_free_lmem(struct xe_gt *gt)
 {
 	struct xe_tile *tile = gt->tile;
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
index 66223c0e948db..4975730423d72 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
@@ -36,6 +36,7 @@ int xe_gt_sriov_pf_config_set_lmem(struct xe_gt *gt, unsigned int vfid, u64 size
 int xe_gt_sriov_pf_config_set_fair_lmem(struct xe_gt *gt, unsigned int vfid, unsigned int num_vfs);
 int xe_gt_sriov_pf_config_bulk_set_lmem(struct xe_gt *gt, unsigned int vfid, unsigned int num_vfs,
 					u64 size);
+struct xe_bo *xe_gt_sriov_pf_config_get_lmem_obj(struct xe_gt *gt, unsigned int vfid);
 
 u32 xe_gt_sriov_pf_config_get_exec_quantum(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_config_set_exec_quantum(struct xe_gt *gt, unsigned int vfid, u32 exec_quantum);
-- 
2.51.2


