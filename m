Return-Path: <kvm+bounces-30696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CA089BC736
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 098731F2201B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88291FEFCD;
	Tue,  5 Nov 2024 07:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gSgQSvpt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5061FEFC7
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 07:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730792707; cv=fail; b=O3lARSIrjLEM7ISPLtbL1G9M4UIZ9iJMIPAighN2LMqCyPS20E7+ChrqEstOKaSYg0tqfF8wzYtq49YNgZmgVQ1QMkbfcaicxi4XO+eVcTZG9xU6Ev5kNuxvV+iJPLOaaZX0LRbAsbFgh6Xeee/PYHC6JzkQ1cGXakYGKPkx31c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730792707; c=relaxed/simple;
	bh=S9g0IYCwdJu2eCudhrPzDZz5Ek7SocfgibOjAJFeIJA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NiOcqMPXx3w2nWjUQaHag65g+MyJiLrRF60HcXNgobClkNTaQzW8cirbs7cwlqh7cHGUS8CcpV3DlmG3vi670DhNP+yARpUOaV9ZRZxBSNd3d5kqJT3Ju6E+vMl7fklPzIMDk6Zi/HQev9PTIQLodpbRLoW3SGgfqxXKBUfOp2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gSgQSvpt; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730792706; x=1762328706;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S9g0IYCwdJu2eCudhrPzDZz5Ek7SocfgibOjAJFeIJA=;
  b=gSgQSvpt504FPc20jOkWiby8rw9LtX51/1wCCZ38wYgvnIG+nBY2JW+T
   LWBQiwOQxt4Gv07qAeA/wQ2y2pDSoBcBXf8CREwE+e9bePh8mZdZ+OeSa
   5+GUDammnCscSGZ+/qsg3tWJwX5q2LCCNCkUBDZq4LuwdlLyUmPOzqP/t
   9Ed9SI39PNeVnveboRZlc8TIXHMXipl56C5QOu74S+AWdTMXI4JbOlcAM
   yE+LTz7NKQsDlbdnAoZHOEKq0mX+vkd7ajPBDbDby6GqqqsgSWPqgZACm
   cz/kXZHzN9jPcinZd7PujFzz8UpcY5ztCm1WQ3iwc32Mq5YAYSi/kct18
   w==;
X-CSE-ConnectionGUID: uUCRgiGJRuCPAngIa1QO3w==
X-CSE-MsgGUID: 1jhOPto8SPqDNCEZ648VUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30631198"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="30631198"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:45:05 -0800
X-CSE-ConnectionGUID: y8LEMJG1SPu4LfOl+u/LmQ==
X-CSE-MsgGUID: 715lcmsfTYuJVe1UfK/cqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="84022513"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 23:45:05 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 23:45:04 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 23:45:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 23:45:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UKuRW70kqGxlKzvlAR0niQlt9nFgc9+0Ah/7turCQ4SEI6UZiUHz0nHK3bcbXqOE7yJib8J2nP9bdV0yGpfg8Bi57KtKQGljTpaxXdenIDC9fkRYxXLeVZbnpf1R65ioPHV29fWAJN5ljwJ8y6Lg6HVxO2saxXCjmEefRqB2cZGYmfbl/R0pYgXSK/N0CBJjUo2Kqt7lmKf+TtJOjXJXa0QxsopGDpmJTQuOm6kFo9VgZoV9Eai22h7PGH3g5zJpIvnVd1D7x6v9TC2K2mNCRL/LJ2hTdC/+5vycwzlpIW0Y1js8buvd+9C5ry4ZkF8xpK+vn0G3XnViXYmfZ7BKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoD3uuReeby30oVe/Iu9C56cMUQCIXwQ6J8UWyL/ocA=;
 b=j4M5tQ6am5b5HymUHg1Q+c5mHyjsAz52zLYv1jvyBzilRxOm3iw17ZP7UphsktFCP2yLked/0nv8v85qk7IyNRQqyuz4VTxGL7rH016GZvYbm/Q91aUHJVRpo1buq/MfEtMLjkpDryRtyF3n9KLsffNLYb+Uafb2AqKZ6X+TvikCqeiunJ2qbwYA+DSCu8GUiot6uWBZ5E4ifC+xifF8JKCqfUmO6SvCWUtPF8P+pqKmg9MkeiXhe7lEpQF4OANj10DrFuGUi/A7Z8FMYm9yq3tVytkhL/ZgN0aSP8aeYrG7MoBUe3kxLvQnNctcrfZfj6jUhkjSnoJI/ORDnT4y/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by PH7PR11MB6905.namprd11.prod.outlook.com (2603:10b6:510:201::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 07:44:55 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 07:44:55 +0000
Message-ID: <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
Date: Tue, 5 Nov 2024 15:49:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/12] iommu: Introduce a replace API for device pasid
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-2-yi.l.liu@intel.com>
 <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|PH7PR11MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: d5355f8b-10f0-4d85-224f-08dcfd6dbd8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cm9EcUg0YllrVkFHellPRGJjdWJWV2pUbm9LQy92L016Sk9sSktTR1dyNkZK?=
 =?utf-8?B?N1VWSXhEQkIyMXRwMEllZy9hVG92NUMrZjFqcnk2ZWxadmZKZE5IYXZ3YmtH?=
 =?utf-8?B?a0g0NVorZlhXdnoxK0tXdWpLMGVKMkhaaGFoSEQ4SzAxT3NvRG10S1hVSHlS?=
 =?utf-8?B?T2NONW9ia0NoeVFMRDBwSXdtWVZiOTlVUTNqemlTQXdRRmJXa1doOHFtWnpi?=
 =?utf-8?B?cm5IbUowYUtObFhUTGtma0ZQQ2hCc0ptTGFzeEhZRlJEVGpqR1l6aTRLNjQ4?=
 =?utf-8?B?TFJoOGdUVTN0d1ZkRW5LRHRRd2hUTWlKRnQxR2d2am42QnNtS3l2TE9WSndw?=
 =?utf-8?B?THNEalhkVFhEYm9QRnA3VEFBeHVraHQ0UHlYNzQ1OG02cWo1WHNzQW1MWWF0?=
 =?utf-8?B?d25WOUZ1VGV3YnhRRTVsQjRScDNPOWsrbG9zWWN2ajVEckg3d1dSMWh6R0tW?=
 =?utf-8?B?a0UwVzloUW5IeGVFWXVhYTVPT2V2R2I2ak5QMlMxdHRHNzdnY0hPRVdYSUox?=
 =?utf-8?B?dDkwMUZZaTQ5MFlJdytEeTJORk8vQ25mM2NBM0Q3ZnorSGpzYm1ROXFHaFNU?=
 =?utf-8?B?NVNmdG14K3h2MlErSHJ3U1pHc0xWWEhqbEZPNjNmVTU5U3N3OEVwWXU3dDRy?=
 =?utf-8?B?MEhwNTk1QWVtVTZET2t4c1VWNjJZWUlYcFdxakFhM3IxRTRuNFpudmRLbHBt?=
 =?utf-8?B?MXBQcGthdXpzV1RuZ2hudmE2MlF2UkFBTXpiYjBQajN4aFd3MDBHSjEzUmh6?=
 =?utf-8?B?S2paeUhkVkdmYWZabzB1a3pqMEJYMVJqM1J0Ykh0SUZVSlBJK2drSU5seVFl?=
 =?utf-8?B?N3dOeTk5a2ZwL2tQTis2Y0t6RnVPalBZQWFyZ1JnV2JKc1hZYWJZNDZ4L0RO?=
 =?utf-8?B?ckxTNnF2SXYvbUF0c1kvYUJUQ3JMam5IUjR4MmxSVUtBcFdBOWJPRkZXL053?=
 =?utf-8?B?MTlTdTVvMS91STV4ZVdLNHZuQURHbnBPT0ZPc3I5RmxRbGZwTVp6TWZmM0hR?=
 =?utf-8?B?eDNtRkhmK2NUTGxILzVkRHd2cmRPNG82ZW9lM1dYWXFJOVMyRlNCV1Z1MzNq?=
 =?utf-8?B?blZzRDM2dlNEdnJFRm15YmJxZFBsV0ZLSHZYbXl2cXk0MStaenJ2cmlqSVpG?=
 =?utf-8?B?NnIxVlg0d3ZZbGVmMjFvbU5SbTJVTkNzd3lPalBnRFVIelVhajRBdVdkSEpW?=
 =?utf-8?B?bVozQ0ZQb3haOWdSckhYRTU5d1lWTEszc1JwVHJaaDVQekhGSUtvTEpGYmZo?=
 =?utf-8?B?bUtqMW9aSG5mbXJSS0RoN0wwSEF2THNzYlVxcExGZmRzQUF6YU1RMGRMV24v?=
 =?utf-8?B?L0NHWWtVNjROZDJTK1VGUEVqL2hMKytsYVpISGxxZG81UWxRZXFIVUp5d2k3?=
 =?utf-8?B?T1kwQU9KU2VibDJCelpPdWU2bjM2TytsRmFBWGQ5L0xsRVBOUmF5NlNOOHZO?=
 =?utf-8?B?cWVjSFpsQlE4UGpoVFFjQzlzTTJXOTV1R3drVnhOU3cvMGhSWVRSTVRqSEdR?=
 =?utf-8?B?RlcvYngvdmdhMUVLREhJa3N2LzdNTWtVNS9yc1Q0RlBEZDQyRzNJd1o0SUFh?=
 =?utf-8?B?MkxSWDV3MDgwci8wUkg0eWdoa2NEVlptSUpMTU9oWVZ6WDdxQmEzOFBsQ3dW?=
 =?utf-8?B?T1BqeGE3Y3NJSEJKNmtJb0ppYmNwdi9zVlErdzd6SFE3SVZCa3JDM2E3Sndt?=
 =?utf-8?B?WVN0cjRWVDZmZFl5TWxNZzNhTFAxQnJES3RZekZNSXFQZVRCY2xyUUoxUEFL?=
 =?utf-8?Q?l8NeMTU7phcxmXSOGLPYt9SoOej12vIA+XUWFvB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K051cFhzMDFaa2phYzVvRU1GL3ZFaUZML24vSmNQeEV1VFZVMlNGb3p0aWRu?=
 =?utf-8?B?V3BCRHROdlY0cFRDWEJVR1hncWVOWVVVVnhqUE93UUFoVjVqeEpnVHBIOXpl?=
 =?utf-8?B?dWYzT0xhdE9PRUxtbUpPeUg3clpsV3JqdWFIZUJab0o5NDErNkQ0KzQ4N2px?=
 =?utf-8?B?ZUFmM3VJQXlVZlRmWTY2WkgzOUg2YzBLZzlNUTVadWdZN1lNdHMxY3FZS0Vv?=
 =?utf-8?B?czg3ejc5MUEvb0tvbmk1Vmgzd0Z2WFNkT1pPVWpnejJmM3dNd0JWNlBLbFF5?=
 =?utf-8?B?QnVjN1FNRGY3eGZJcjhwTnVzU0ZTekdreG1XNXVWS2duYi9pcTh6RnVETWZh?=
 =?utf-8?B?YlJzZzFWc0N4RkhLSkd6WWFmNG94b2VsaFcveDJ4Mmk2aWp6N3d1VHE3YjN6?=
 =?utf-8?B?VVBxdkVxYkNuUEIrR1c3dU9OejgwYVB1VGw1cjIweWsvOGVlaGZZVG1hU2xo?=
 =?utf-8?B?SWgyNlNYMXRDdDAweWpRRWZpeTArTjZ1SDgvRGkweFU0RU5SK1FQbksyRUVI?=
 =?utf-8?B?dFVjQmg2YVBqTFRyTzh5Z0NNRnFRc1pxR2hGeHhsanYxWjNJaGV1YkRheEdL?=
 =?utf-8?B?QzNLZlRNRnIvVmgxaUtDUWJjTGI5VldNQXUzY2VnT3p6ZkF4UXdWcGl1Mk5N?=
 =?utf-8?B?bzlzc21JK0tCT1Zsb0Q1MG5VNHdtT0x0U05FdlhYTFR3MVJkZWtQdk9HUW0r?=
 =?utf-8?B?WkRwQzIyNUFRU1dmaGc3UFRmR2RnTlFTY1lOVnlKL3kzSXdLVy9XdGJPb01V?=
 =?utf-8?B?ZTFXdW11RTdOK2lKVHE4NTZpZDNBblQ5emJiSVFvVWdSTW5OTVBGTXFsQkVt?=
 =?utf-8?B?SjlPNWhUVnpSZWQ2d2c3TDU2MnkyUTJsUHlSd1J5d1Ewc0VWSmZZSjJrcjNr?=
 =?utf-8?B?TGxHcy9wV25TekgyckRGbkE1TDZ3am9oNzd3N1ZMME5sZlk0aXJwTXVhL2JC?=
 =?utf-8?B?SUpzMCsyVm9JNC91OVZQK0lreEp0SXk0YkI0aFU1ZmQ1YzNXVWpRTFF1cFFu?=
 =?utf-8?B?RGpTdkhqeGdGclVGMmhPMzJaVGtsOUF6eUk2OGdCUEU1aXhjeVp0VXIvZ001?=
 =?utf-8?B?amdrSmFVaEVjWExadjBEQTVVZFNieGVRVXZOcGR5M0xmZ3pyOFVESEVuTjU1?=
 =?utf-8?B?MTdYQU0zT01ZY3UzdytTcVVlLzNmcTNYUVRSR0JRbzZQcVExNFlLVk1HWHlj?=
 =?utf-8?B?RUN5Uk5BamF5dml2NjBlQTFBZGhYZGhLWWlYR0tMQ3hCblN5OGdZUjVIaThY?=
 =?utf-8?B?Q3FXVWxKa1RuMWlOL3k0MURkeCtTaXN1NXBZMUJGbVBMUExpRXZDR0JLTVhS?=
 =?utf-8?B?SjhkL0daczlLbGR5bjlIUnFzYUNjaHhwait0Ni9TazB1QW9JNW1aZUtweGFy?=
 =?utf-8?B?NjFIWmZYZi9DdVNrdnlOVnIzQ2t6SnpVMmF6RjNoVzlWV1daQys0eGJhMEsx?=
 =?utf-8?B?cHduUndPN3JPQ2dpVDduTm1hL1JkRXU0UTRkZlg2L25hZmdMTXVEL25VVzRL?=
 =?utf-8?B?d2oyeFFhZ3AwYmtTV3JDM0p1elBJNEIxNyszcDJjcG9xM1ZFVFFpdmRWM2l3?=
 =?utf-8?B?OXF3WTQrcHYyZkphdkVmdjlDV25VMitpM0h4d1BkaHdXblJlamtFa0pyeWlM?=
 =?utf-8?B?bUs2aXFrbG5DR09xZWZ2YUE1KzA5eG5POUtPbUhabzJIT3FlRlhucHRFTDht?=
 =?utf-8?B?ODJMVVNKbmRwYjRwZXZoWHpPMzVqV3hEczhSOG1HSGJRb2NUNlV3NmhPblRm?=
 =?utf-8?B?YmdDSk1ZengzYVREVDVCMTNucEtKUmlMcWM2c2N1UllId2tsckxFeTlDak9E?=
 =?utf-8?B?TkJES3BzcXNlcmZSaUZVS21teUNVclRoNUR3K0dybEhVVmtmZEFQeFdXZ2xa?=
 =?utf-8?B?Y2dYRnU4TndaUTBrY0YvQ1QzcURjOWNLRjc4VmtLT2dMNFZ3UmhLMVcyR1lk?=
 =?utf-8?B?T0pXTGxrc1IrQTFYV2dyRDNMVTE3UGg0MDRhVnhBU3MwQnltMTNiZ2tibzZ6?=
 =?utf-8?B?VXU4cC8vdlFlbEN4UDY5ajdIeldNOWYvSzc0YUlNd1BwLzNtdWpaWEFNNlpu?=
 =?utf-8?B?UXlpVEtJS1hTSFpKNDB5d0hOSzB4b0lUbWF0a3ZWUnhaaU91M0VHbjErbWJH?=
 =?utf-8?Q?1BuRwTO+vdPiEifNDqG3pegOR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5355f8b-10f0-4d85-224f-08dcfd6dbd8e
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 07:44:55.6172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzYR/CPc0rLsDWSfxAxrq027oRzJ9Q/5Vr2WOJMUMmbGhHNSYGVfZmIn+WQexHqLONBklSVJiZl6SKXQJSYFZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6905
X-OriginatorOrg: intel.com

On 2024/11/5 11:58, Baolu Lu wrote:
> On 11/4/24 21:25, Yi Liu wrote:
>> +/**
>> + * iommu_replace_device_pasid - Replace the domain that a pasid is 
>> attached to
>> + * @domain: the new iommu domain
>> + * @dev: the attached device.
>> + * @pasid: the pasid of the device.
>> + * @handle: the attach handle.
>> + *
>> + * This API allows the pasid to switch domains. Return 0 on success, or an
>> + * error. The pasid will keep the old configuration if replacement failed.
>> + * This is supposed to be used by iommufd, and iommufd can guarantee that
>> + * both iommu_attach_device_pasid() and iommu_replace_device_pasid() would
>> + * pass in a valid @handle.
>> + */
>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>> +                   struct device *dev, ioasid_t pasid,
>> +                   struct iommu_attach_handle *handle)
>> +{
>> +    /* Caller must be a probed driver on dev */
>> +    struct iommu_group *group = dev->iommu_group;
>> +    struct iommu_attach_handle *curr;
>> +    int ret;
>> +
>> +    if (!domain->ops->set_dev_pasid)
>> +        return -EOPNOTSUPP;
>> +
>> +    if (!group)
>> +        return -ENODEV;
>> +
>> +    if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
>> +        pasid == IOMMU_NO_PASID || !handle)
>> +        return -EINVAL;
>> +
>> +    handle->domain = domain;
>> +
>> +    mutex_lock(&group->mutex);
>> +    /*
>> +     * The iommu_attach_handle of the pasid becomes inconsistent with the
>> +     * actual handle per the below operation. The concurrent PRI path will
>> +     * deliver the PRQs per the new handle, this does not have a functional
>> +     * impact. The PRI path would eventually become consistent when the
>> +     * replacement is done.
>> +     */
>> +    curr = (struct iommu_attach_handle *)xa_store(&group->pasid_array,
>> +                              pasid, handle,
>> +                              GFP_KERNEL);
> 
> The iommu drivers can only flush pending PRs in the hardware queue when
> __iommu_set_group_pasid() is called. So, it appears more reasonable to
> reorder things like this:
> 
>      __iommu_set_group_pasid();
>      switch_attach_handle();
> 
> Or anything I overlooked?

not quite get why this handle is related to iommu driver flushing PRs.
Before __iommu_set_group_pasid(), the pasid is still attached with the
old domain, so is the hw configuration.

>> +    if (!curr) {
>> +        xa_erase(&group->pasid_array, pasid);
>> +        ret = -EINVAL;
>> +        goto out_unlock;
>> +    }
>> +
>> +    ret = xa_err(curr);
>> +    if (ret)
>> +        goto out_unlock;
>> +
>> +    if (curr->domain == domain)
>> +        goto out_unlock;
>> +
>> +    ret = __iommu_set_group_pasid(domain, group, pasid, curr->domain);
>> +    if (ret)
>> +        WARN_ON(handle != xa_store(&group->pasid_array, pasid,
>> +                       curr, GFP_KERNEL));
>> +out_unlock:
>> +    mutex_unlock(&group->mutex);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_NS_GPL(iommu_replace_device_pasid, IOMMUFD_INTERNAL);
>> +
>>   /*
>>    * iommu_detach_device_pasid() - Detach the domain from pasid of device
>>    * @domain: the iommu domain.
> 
> -- 
> baolu

-- 
Regards,
Yi Liu

