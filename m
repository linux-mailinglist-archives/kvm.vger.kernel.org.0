Return-Path: <kvm+bounces-63838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 58F1FC73FEB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 420EE4E6F62
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BC4338F36;
	Thu, 20 Nov 2025 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csNiPcto"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62943128DA;
	Thu, 20 Nov 2025 12:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642247; cv=fail; b=DXEsA23v9fTQlV+EOxV3lthyc3kbSZQiL8yd9PCcywxxP66+ORq2NPP1nfETe0oA5rCUKqtMf9P90NoKiJFY44zY11SD9UzlIf2w4uLnp9bbY6DTJ4xZeReUrPrG8fnDhJnU3lt3w+fGnvS5vHnbHtxe16vhwkWFNhcpWoq3ofY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642247; c=relaxed/simple;
	bh=2SkxTVulthy6uWaGOxmbDZOWxLN2exasqLVURNtHRGw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V6E1M+mB7flef0F3gA1A2jUeQpTp9l7hGaOyvF72xf5pPtyjHh716NXHgDUmB7T21+eWGdxtNUu7Z/4XNKzLTMFX5gGJ02BfWjMU5AyQLdBad+Vnk9/yRU3V32NaUJYGS1GZ0LbEkzKmkRhDX4BaGJNQ+qsh/u0QfvYM3iBjITc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=csNiPcto; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642246; x=1795178246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2SkxTVulthy6uWaGOxmbDZOWxLN2exasqLVURNtHRGw=;
  b=csNiPctoKD28PfX5E8Gqn8jGauoDJWhRwinEmIsdLBNkpj44fMyoVkSa
   xWknLJ/JlJGf6HL7PGVNIDsup170J5UVz5xOgUh/IwfOVsdrEACYamuVW
   Oqr/WcgwLXy86DtboxNte4fhHsgV33xtMpGTq7fDNsetYKhfyZm0TOvBH
   lc1oUPuyyn35rr9avBbQm0iAoNTWNxwGHlfvLQPOBrwajgNOtJBNyTXyX
   sWEPLcGLygvOJbWDVBu1wkaqAyDkIvHR6eigSpAMGJADJaGsBOYXhiqdE
   LV4d/ZUcNoBb+E5G6DE0VMEIeZTp2SjIom+mpzN1hv8CFP1qOcJuO/9cd
   g==;
X-CSE-ConnectionGUID: +5IupLvTQyWysEU49l1A3g==
X-CSE-MsgGUID: GdmFSbUgR6eflxh+i7gwnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76037897"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="76037897"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:24 -0800
X-CSE-ConnectionGUID: Ww4qjgjPTT6CK5ZCQonOOA==
X-CSE-MsgGUID: pz8g7VgJQ6ukIwv+HVHxbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="190633944"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:24 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:23 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:23 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PCThl/jkMjdcdnr3dx2LvNy9l3XDpq7FeUt7d+h7WBTwp+Xdf4UyPxRbDu/1qyA+7R2NBJU7lATNzzuheF4K4nKzffXcdoJaW51XDacqbWgrF902NOmvM4w1pDvsHGvC0gZagQYGi20EV52nMRfSLJdXJuIlX4wa6wDNlRo9b1bIl6bAbHx7ehYZkl+/r10srKfav+UfNlM8Zzd2wrSCRpcRlYtr58mstrKmkEPj1IgCaY3K9O0IW2cL+KImZhRupN3/++f6DitZVXWKdme40sMPNhqU76idRGG9QqxekGMp/IJiNYehgExE9rdnCqondX2bp5KTbDTZiN+bL4SsGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLQKvTxlOtTGiNv4W5sigwR8ALsh5u1shNnPVpQKzAk=;
 b=JiKa6BZo/XMYgyB01d0ms9pAngCTuhZI2uT0QCnazg7xU19xU5+x0dtven2RBlmQVWALj0zuH+4H/qGNyyHOLnT4JsF5Kv5W92CdKTJXXl3nYE3UkU6ohRINYnGcdyQJGaO276FHEo3f63RyApdXpVpRMcxUk7PW/mUa8jKO0EdrBV2nI1Dk6zBWQ5XCD0oKTTPGiCDfhdNWB7a7n13DerqXBQnbpmVivS/aHk1lxVAi0UzJliMN+Kig9te6dZuLUqOBYFKhR66zpxbZI93jEZD+X6lJShcuyOqzT4IM5LQ1Y9Im2mS2noyZuWWLrujP/+lhB0vxOZZLkOhcldWjew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:22 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:22 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 4/6] vfio/qat: Use .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:45 +0100
Message-ID: <20251120123647.3522082-5-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE0P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::13) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: ebcaaa7d-2871-4f10-5a7d-08de28318d3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ek5hbE41WktpV0FCTUYxdFhQR0NUem4xYi9GZWFPUkVpaks3anR1eVBMeUpq?=
 =?utf-8?B?dDhSNEdMZnJEUDJQakJ1cTA3UzIzbmxiNlQyUnlIRHUvV3FNeDJZOG1mcjk2?=
 =?utf-8?B?K3Ezak9JQSsyc1hsa201N0d4OWVUcEk5RkJDY0krditia3hUTlBaN1RoQ2VM?=
 =?utf-8?B?LzQzYk91MFk2YTRrcGhpemkzN3krZ3ZqWEl1MUxjSmY3K3d5ZjFUR1UrMXNy?=
 =?utf-8?B?a1ZielYxVlhoTnk5K2wwbFBlNWtIN0hvWW95QTR2MHJSUWU3ZCs3ZjJULzl0?=
 =?utf-8?B?VjcyWHN6cEtSNkgvcXpIL1JlVUtvemFWMW8rTlNXR2FTTnpNWHZpcjgwK3JP?=
 =?utf-8?B?NDVGZ1pJS25KR1RHek9LaHE2dHBaNG5FLzdUN2EvbDJ0TFUrSkpkakVqMWN0?=
 =?utf-8?B?OGcxcWtNU3V6NkZEeUpqaGZ0MGNsQy9JQkhjRlB4TGVRUU9CbHpEcmZJSkUv?=
 =?utf-8?B?RDF5Q3JNZmpSVG9yOUFVOEpXUUJyQWVNdmV2R0h1OExQcUJGYmNpTzFEMlJW?=
 =?utf-8?B?TlVqNURrYTlNR2Zlcm1vL3hSRDByc1M4ZUlKbHM3OGRtcVFlcVNoUlZRVEc2?=
 =?utf-8?B?RVQzOEFDbTJPem9uMlM4R09WZklxa0lCTWY1UCtwejdldlAxSVNlZXJLMjc0?=
 =?utf-8?B?SllXM29wbTU4aTNsRlphaVRQb0NHVkVmeENLbzM1MDc5S2xQY1BuOW9RcGZ5?=
 =?utf-8?B?cnJBbWtNRzJ5RFRMMTZubHZlbGNnRkVOcEhwVElibXhTZDRVS1JUWEJXaGFn?=
 =?utf-8?B?bjZhbHZCQkh0Wms0SFVNdGpFSTJWRTkzcU5KNHN5d052WHBzUldKeFQvUXo4?=
 =?utf-8?B?RC9tZmpNRVFHVzc5OTNFMExWd3ZqZjJMTDNHNEdSQngvQmpxR21FN0ZadFB6?=
 =?utf-8?B?NEFjMEhVU0dLbVc0aUdmNDZ6M3F4b1YrTTAvZUtwNXFPNmF5L2J4Q2Nmcmlu?=
 =?utf-8?B?NlpScy8xNzErbjdpNkYva2FFakoxYkF2RzBXc3hxRWcvUHNyUUEzQ0w2S1BQ?=
 =?utf-8?B?RDUveTcxNW9kTUpRQ3FTb0ZXQldJRUY3bXMvbzZMWUloVnVROW1qOG4xdWVu?=
 =?utf-8?B?dzROZDR2SlhkTzNhaFRUMVhsczZid3U3a1hsbE1ra2lyZGFMOVhMZXcyNkpo?=
 =?utf-8?B?b2VOeVRHclRIcDdtYVAwdUFHc3JyMkszZnNLWHhKU3Z6RTZyYnpnSUZMOHR5?=
 =?utf-8?B?VUJja3kwZGNoYmRqdDlJNWhLNWt0clFLdWc3Yk8rbjcxeFZRbXYydXFGQ0s0?=
 =?utf-8?B?b0VQVXhkTVp6YkwxYVFkaC9kVjlNZmZkUUVXUVRkS0dTUnVGeEpjdFBuSDda?=
 =?utf-8?B?VTJaSXhFUWM5bVN6VzNqaDFLem1MVm9EVktUMWR3M2xhQ2w2UG9ORkE1U3Yy?=
 =?utf-8?B?V1Z4UEp2OUJiL3V2SjhZdGNSdUV3eXNvYVg5dHFncWxVNlZqZTA2d2k0WlZv?=
 =?utf-8?B?UkEvUWJCT2ZQcjhkUDdkbW9wTTVuNlBLWUhiV1QzMjJrSDJzNW9uODJTcWJD?=
 =?utf-8?B?eGNkakl6ZUZOSmVpbWkrVitKMnowM1FaOGR4RzNRZUtETHZpWmd0eW5vZVdy?=
 =?utf-8?B?RnBIYTdkUmQ2eUdoSTNKeXp3OHBBSU1lRFQ2WVdTVjBERVFsK3diUFJPR2FD?=
 =?utf-8?B?dTg1Z0NBOTZhRFZ5a1JHRWZ4N1N5OTNJdWl3WEJpQ3ZrVzZ5aGhTbzhrQzRn?=
 =?utf-8?B?ckNvVW9GRXQxS1VCQ0dudEl5OHc4REZuWStCOWF1d2J2aHJDMi8zM3VjWWpv?=
 =?utf-8?B?UjY1YXpvMWtnNWdwOWNwWUZ5M2E4SnJmWjhNZlJXSm9JRUh1ajE0aEJRR041?=
 =?utf-8?B?VDdibHRZUExyaFNueDBBOTM5K2MyRUZkazVERkpOMDNtOUd2QmxBSS9UanQv?=
 =?utf-8?B?T08zM2JoVzF4bFVxZjZDTE9NQ2MxMkVaVmRzRlF6TStoK0xwVWZMVHZUVlF2?=
 =?utf-8?B?YitUeVhFUU4wYU9WR3RxcStIK1hvSUdUSVpQOVdyZlFZUUdUQ3hYMXdhdWND?=
 =?utf-8?B?VitEZnBKRk5pMWtiY2MybU8yZnB1RHFYK2VFNHM1eUQzSENPb1ZUT0FxaEY5?=
 =?utf-8?Q?2HRe/Q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K25pV2YvaFRkMkowV0FxQzh6Qys0YVc4T1FNeTBxU1pRbDJDdUJaY2pxSGVz?=
 =?utf-8?B?RGxpbzhoTURsajh0S0ZuUUQ2bzJ6cXBLeVlTeEJ6UDMwTWdLVFB1K3FHWEJS?=
 =?utf-8?B?VHI0UDN5VU4rT1NCTDRDWGJLMGgza3FiaUFVV2pnTTBkSTB2RmNjajdtbDR1?=
 =?utf-8?B?VmtPWVRTTkt0M1NjWk9DdTgrbWpmamFScTZPUlczZURXVTY5UkVzWUsyV3FL?=
 =?utf-8?B?UWdjUHowWnd4MTg5SGFXWEFGK2ptNFRSbSs2THhYbzBmTURWYzRnczU2c1dr?=
 =?utf-8?B?VldQeEhaazdTbG12WkVtc3pLMVNvRUZ5c3YxdWRCTy9UaXE5bTBHcFNWK0Nm?=
 =?utf-8?B?RjdjQlQ2Yk00ZEhlbUtjbFljbE1jdGlyMENGK0FiVE55eTdRWU1aZTFLWGZ6?=
 =?utf-8?B?RitlOFRqaXN0Wk9kSUE1MFU4RDBZZTJ3SEFkRENOR0E4enBIRDk2REJBMXhN?=
 =?utf-8?B?cDFvR3FSSzJyc2ZSR01BeEw5eitPenhrWGZQbXZiTFltYWlUckhSUldQRjJv?=
 =?utf-8?B?eHhvQTQ5VkFxMjFQS0lkZ1Jna25FM2tkQjhWcmR0bHpsTmU2cU1QSWZrdmdJ?=
 =?utf-8?B?OFJFblhRVzdhL3F2VFJ6Q3RUcmRSUk1sWUhqVUdTOEtxVno1MmZ2OUV0U2tT?=
 =?utf-8?B?ck1FdUJxT0pIcEw0WnRTMlJWd1pBd1REZlZ4b2NuSytLeW9Wc3hJMktzK0o3?=
 =?utf-8?B?a3B5Nms5VzYzMXE1TU5GTkxlZzlnVkFMSFM3TW4ycDNWN2RmWEpEalFCeFZ3?=
 =?utf-8?B?K1BkRnhqS283a1VTeVE3WG1CVDJoaUp6VGZhVUNGUlcyQWQ1SVhQRDFXT21I?=
 =?utf-8?B?a202S29aRERXUko3MWVBWWVxMHkyZEJHK1ErZjFQUTczVnhwcXMvVGEwSlUx?=
 =?utf-8?B?elNWQ2oyWTdrZDUzVkwyODlKd0xBNzc2aXJCWXVoakg5RUhTOXdlYUhQRmdv?=
 =?utf-8?B?MEJWbkdOMjN1MG05T0h6a0xtMWMxVUEwVnlIVm8ra3VGZThuR2FSQ041N21K?=
 =?utf-8?B?Y1dGSmhjN0w3NDlUU3RVbmFJS3JNdjNITnQ5cTRnb0pjdnpxanJjaDJjVXdK?=
 =?utf-8?B?SnNqVmMyU3dyd0lOcjVvazlEWWlBcUQwVWVOS3V5OGFUMzlhNk9kQit6MDli?=
 =?utf-8?B?V0JRSklBTTZQdFZ2OFlkcTA4UnJqTVQ5L2xuWGFpZWErV21mbzdkL1JYOGll?=
 =?utf-8?B?ZEFZQ0Rrb2owekFxdXowbnE2cWJpdzFvRENwa3Z4Y1FPSFBrUG1FOS83N3px?=
 =?utf-8?B?Q3QvT2pkTFFRMlVnN09iV2wwUnNDNDAyNWNQZ3FTMG0xYWlkM2ZwcjgzZG9I?=
 =?utf-8?B?ZmR0QmJ6aGZSWjJrUnNJdkw3QW9RL2VrSkJqNTZ4cFExZFpuT2gwWFFEcFg5?=
 =?utf-8?B?WDk5SGMwL25DWDRrVnFvcUc2NDhmVkN0SWxTdW1WM3FIWVAwVnNhWGpjMjBK?=
 =?utf-8?B?cnZXS1JtamdhUSt2QXkyOEtWT2xGR1dhWjFiVW14cVIxMkxBWXpaTyt4b1Nu?=
 =?utf-8?B?MmpVS0Y4ek94V2Z6YTVGVmNFcFVsbU5vOHlrYWxyb2ltazc1LzhmK1hmUkFW?=
 =?utf-8?B?Sm4yMERIQW1iakFpNmNQeEF0QWx6ZE5YVUd5UFJLYnZaYmRLWDgwa29mYW1L?=
 =?utf-8?B?M09vTVlNQ1B0NmRGU0RRNGRrQmUzLzUzRlVuUzRlZXpWYXlObTRsV2Z0dzgx?=
 =?utf-8?B?SlJPWnllQmFUd2taRm5OMlZnR2VramhYVmFoRWFNN01pQTQwdi9CRXkwN1Ex?=
 =?utf-8?B?aUR1bkdnYU5jQ2RxVVBiTURqMVRtMGVNbFQ3YUVpVGxUMkdreWdIR1Uydjg5?=
 =?utf-8?B?Uzk4WDNVU2ZKZXo1NGEzQ3dxN1B5Snh0TUw5N0tOUlpHVCt3RkcrSXJUSWhB?=
 =?utf-8?B?bXNrYzVEZHF6enduNXp4RVhxeU1HUGg1RWZFSVo3dlZYWXVWTHc4SlYvVTI1?=
 =?utf-8?B?ZERUMDlSdlZ2c1ZHR1BhVzdMWFhkczBZYUJpc21QclN4QmdtWmpnSnZxYlRH?=
 =?utf-8?B?cHU0ZE4weEJ6N2Fxa2lyT3VjZGhEWXZRclEwWTVpdWJGL29vcmNoVFREUlo1?=
 =?utf-8?B?bnMya2t5YkJGaWJpMEJYUjEzZUlYa0QydkJKbGZuMi9TTlRCSGhNVGFjdklC?=
 =?utf-8?B?SGd5dkxPUXVhN0pZM2s5SWhlOWFJQWd3Zk1aWnlXdGNlMGoyOHZsTy85SEVB?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ebcaaa7d-2871-4f10-5a7d-08de28318d3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:22.3577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqwWwRQWdtoU8Q9dV62I7v0OC0l6gTQJnZ9OAWg1BEmoqYCZM77SugqNOVVjw5bGJIP5TurkPr7I6z6T/3/4/9Tf/sLOj+79WzycwHJdmXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Move the migration device state reset code from .reset_done() to
dedicated callback.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/qat/main.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
index a19b68043eb2e..fe65301a4cdc8 100644
--- a/drivers/vfio/pci/qat/main.c
+++ b/drivers/vfio/pci/qat/main.c
@@ -474,13 +474,6 @@ static struct file *qat_vf_pci_step_device_state(struct qat_vf_core_device *qat_
 	return ERR_PTR(-EINVAL);
 }
 
-static void qat_vf_reset_done(struct qat_vf_core_device *qat_vdev)
-{
-	qat_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
-	qat_vfmig_reset(qat_vdev->mdev);
-	qat_vf_disable_fds(qat_vdev);
-}
-
 static struct file *qat_vf_pci_set_device_state(struct vfio_device *vdev,
 						enum vfio_device_mig_state new_state)
 {
@@ -526,6 +519,21 @@ static int qat_vf_pci_get_device_state(struct vfio_device *vdev,
 	return 0;
 }
 
+static void qat_vf_pci_reset_device_state(struct vfio_device *vdev)
+{
+	struct qat_vf_core_device *qat_vdev = container_of(vdev,
+			struct qat_vf_core_device, core_device.vdev);
+
+	if (!qat_vdev->mdev)
+		return;
+
+	mutex_lock(&qat_vdev->state_mutex);
+	qat_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	qat_vfmig_reset(qat_vdev->mdev);
+	qat_vf_disable_fds(qat_vdev);
+	mutex_unlock(&qat_vdev->state_mutex);
+}
+
 static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
 				    unsigned long *stop_copy_length)
 {
@@ -542,6 +550,7 @@ static int qat_vf_pci_get_data_size(struct vfio_device *vdev,
 static const struct vfio_migration_ops qat_vf_pci_mig_ops = {
 	.migration_set_state = qat_vf_pci_set_device_state,
 	.migration_get_state = qat_vf_pci_get_device_state,
+	.migration_reset_state = qat_vf_pci_reset_device_state,
 	.migration_get_data_size = qat_vf_pci_get_data_size,
 };
 
@@ -628,18 +637,6 @@ static struct qat_vf_core_device *qat_vf_drvdata(struct pci_dev *pdev)
 	return container_of(core_device, struct qat_vf_core_device, core_device);
 }
 
-static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
-{
-	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
-
-	if (!qat_vdev->mdev)
-		return;
-
-	mutex_lock(&qat_vdev->state_mutex);
-	qat_vf_reset_done(qat_vdev);
-	mutex_unlock(&qat_vdev->state_mutex);
-}
-
 static int
 qat_vf_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -683,7 +680,6 @@ static const struct pci_device_id qat_vf_vfio_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, qat_vf_vfio_pci_table);
 
 static const struct pci_error_handlers qat_vf_err_handlers = {
-	.reset_done = qat_vf_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
 
-- 
2.51.2


