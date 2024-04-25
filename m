Return-Path: <kvm+bounces-15897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDFB98B1DF3
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 11:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68594284EB7
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 09:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E495B85277;
	Thu, 25 Apr 2024 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJm/w+sC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E178528F
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 09:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714037006; cv=fail; b=j0VSnClJaovepymqn8c2pcKBfDpfyUd+Dk6L8O4quuPyAEvKLuvMkuruXLFihd2Y6aJwvnusW5V8U+RynBQMkwavBhJO4PgajDN4Nm/t3+jf6+lcBvD2miYrVcq9jRBllR7pbcYBVWiN7roGT0vyFbHxEZPbcR1UUpcqMhcLdA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714037006; c=relaxed/simple;
	bh=sBP0TwnRBJ0BujIz/nO/BqN7einqh+KUrX259Q9MRSI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rkhpENoqytIcq6Eav+mIh96G2WyHn+9B3JCTQ/VoSDXaDlli57g6kq5sXkSNgrdcnYjKPfaPEI9XxToRfHOHvi0AeAhhsCchy4jTl/7SlwZF/iP5R73R9TFOz/I1uL3TIsUXpxDZWUd0ILujFefgspXltk48iPJLIv40tFMEF8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJm/w+sC; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714037004; x=1745573004;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sBP0TwnRBJ0BujIz/nO/BqN7einqh+KUrX259Q9MRSI=;
  b=oJm/w+sCu59sJNpWX/jee+lg+DMKSE3xNbpRmdfLBgCcxd/UP+ngaehb
   F/qIgmTGhRENSuA+BUcqWTz3ZVP8pPz+vQIswfzjOWPFniToD3+3jKvj4
   n/Edyjidd9TaOGro1uxbZgUtG52F10vhCn7fr4F50xGw5MLDDNu19J+V4
   UCCRmL7YNq/k/upUFY1iDDCKImw3qzEUBSGit/jxNCok4LmusX2mFayr2
   cDt0X4aHsmI0EvZSK58ntmzM3B+mb0lSN2nuZ6TzBHnlO+p84//OyucaX
   vZHdONq6HNvGGVGbRW8n7qoVMFlkLXjwbCVwjRRt1xiYEVH6pcip8IKHs
   w==;
X-CSE-ConnectionGUID: 58eAj7OfQhucukRkxsbBSQ==
X-CSE-MsgGUID: l8vI1FBhRLWfmTYkWuamXw==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9576348"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="9576348"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 02:23:23 -0700
X-CSE-ConnectionGUID: 2UiAVwzrSKKIlHDUNbmyWQ==
X-CSE-MsgGUID: Pn/lOiVbRk6cT4fzMdQ5Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="25067557"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 02:23:23 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 02:23:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 02:23:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 02:23:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCLOAPZbADkpAM2TJIQTDsOv9zxUtvErLbXnpP4DAg13FoOhRro585tqX3jjrwSTbDWMCDMgNr1+dtqO9vxGwuI3wdbsMJ11l7capp5BZmX4V+IMEA477P3Hl6OtXrRQ/zUcxR3+vjQjLCYk/WhjXNYMXpeAEv/VROJ0ckLtCVpY17qpOP8ZRyZOp+5/Xru1MAXQ7x7N2vwbvMoGOkd6pAJk6njoNe9T68wv9kRDRyZ0mYQBXJ80DV6e4JsMxnsZ1iUENnUQQJt9bmJjZuolCwGwhDjzMtHBUYD6zNpwQhqS0XE0UApC7ivb6AHgNVYnPHxYSY84qp/wsBRCy/uJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qN/gjKWhzYLhjz3lzW2/Olv3165kPsZqZb/2iI8E/9M=;
 b=jEerXhin/MR9xROTM3NrLnsUS1Ov9moAUvu4ItHEBY9xsVFa6DqGnWOmrrsGsaPSASTuGMIYJhkQ9sIDnZkpRNF0LXFq1GukiBKmeywEqcdB31fh9Oj9z4TSBQN+hR42tgbHSs6+517fd47XvWxbiignSSd4P0O3oWgCfnjZh9R9G3aZM4OrPUPGV7fHHGHVuzT+KAKBUSyGdDfVA9D4q4Gll/CGnlQ+G8poXhylFcesKRg2F6EJqd9KwfYRQqR/7W2bipR12fSBKX+Tky+FAOoTON8gsqt98iXscEl+ih23rELnwsza8dOneIyTalLBOvUE6rdUd98e6AXCAkJgig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7199.namprd11.prod.outlook.com (2603:10b6:208:418::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 09:23:20 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 09:23:20 +0000
Message-ID: <07fbea50-b88d-46d8-b438-b4abda0447bb@intel.com>
Date: Thu, 25 Apr 2024 17:26:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
References: <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240424001221.GF941030@nvidia.com>
 <20240424122437.24113510.alex.williamson@redhat.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240424122437.24113510.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0072.jpnprd01.prod.outlook.com
 (2603:1096:405:2::36) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7199:EE_
X-MS-Office365-Filtering-Correlation-Id: bf377765-cea2-4dfc-fac3-08dc6509591a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aTdDV3lGcWxYcFhzamI4Z1hFcGoyMnQzRmFicEtnUU5WZzczMzVaT0lVa0lt?=
 =?utf-8?B?YVVicVNRVHNiM3ozRHB2UVJ1Ykg4VG9SWVl4Nm1iQ05xSWlSaU5MMGJEVnM5?=
 =?utf-8?B?dnF4YzN3SmtkK0dhSnd6VFBMQjNpTllMZGtMcHVmdW96TmhsanN4Tld1UTls?=
 =?utf-8?B?SXlRc0VYbVU2ekZPYnVQSjJST0ZxbjA3QThvNitGNTI2TVZ1UzRhMzFUaW5o?=
 =?utf-8?B?c0RjUFR4cGYxbzltS0NLeXkyMmxheHV1YU8yN0J2MEpENXRBZnhncWZSK201?=
 =?utf-8?B?c3UwS3R6TDlmWHFKMGVVM0lUeDUxY0Z3QWVGRHZoZ3c0clYzZUNDZTR5T3V6?=
 =?utf-8?B?eDFqRG9lbkRKcktYZHl6NEZjQjhtOW5JQnYxWkVGTFJLV2hsamRCcVpPZzA5?=
 =?utf-8?B?Z0hlUFdpZVZvVnlqRmhuWUNXcVF6cnFOcktzazdEaUMraVV3TEs1SnlIZklM?=
 =?utf-8?B?OVFzOThyODVnNFkvbS83TjNRSnY0MzdGeTU0bGNoNUtyUWttTER2V0tvdHhE?=
 =?utf-8?B?MlFMQmpLR29ZTXgwc3ZZeGhxa2JzY2RIM09MMndUTzFmZFpYT0o0RVRvay9D?=
 =?utf-8?B?Q3FZbXErNExzakw5bkJZT0xXRW5aSm1OMkNNQjlKT0VMdk5jbnI4WHJTWUg5?=
 =?utf-8?B?UDlqNjVaUFFYNVE1SVRTdGIvNzNQWXBTS3A4WGprY3FCUWV1NWtiMHoxM0th?=
 =?utf-8?B?QVV4YlhmenJuNWxDUTZWMzdMRE1Ua3pBeFUwNWdjYzlEZ3VMVEpjcGowTC9i?=
 =?utf-8?B?N0ZNaWdlcjlCajhvdFBJZUNRZkdBTk9NVHBYandtRHNrbmZIQ2FlMXdvZmw5?=
 =?utf-8?B?cURsUUJVanhVRmttUHN1TFdrZ3NDZmxXWDZ4aHpVOEFobEJ2KzZvVDdTWnJz?=
 =?utf-8?B?MGZWT294ZE41Y3FUZjBud1hiVi92MDRUci92TkIwVzZVTGM2R3BlSjEvOWRq?=
 =?utf-8?B?TDcyZjRvTkRDaE5xbDBrbUtmT1U3TEZNZm5FZmxjLzd3Y3FtRjZseGJ5YVNY?=
 =?utf-8?B?NkhhU01aRklFekt1WVVJZjNyUlVXeGVvNGRwMEwxMlZ5c29tU3JVMU1KL1ov?=
 =?utf-8?B?K3RLenZQcTYwQ1pHUk9sNEdIbmpOcnl6SldqVWcwTXFWTERkem5td0tORkVs?=
 =?utf-8?B?NzhlWVFyblVlOG00VGk0R2xaMGlYdnpDZm5UY05WWEQzQ1F4VThYeEhIS0Jh?=
 =?utf-8?B?U0hBZHBLUEw1dzBSdUxhTmpOTXFpakR3YVVrelcxNHhEbEtwL05SZ1I0WW5m?=
 =?utf-8?B?Q2IwWHN0bE1pUEpoTm1BcXNMTllycmg2c2t6dFlacmJTNGoreHZoeDdIV2lP?=
 =?utf-8?B?cWphMGp4ZGRTSGw4UGMvK2s4L0JnSFF2dmI4R1pzY3R6ZGZnMVRpN013VzZF?=
 =?utf-8?B?WmRBWTBFaDhEcVdlcTArYnMweTAvb0t1UXQ4VytMRnRIR1pPM01jeEFPcE9a?=
 =?utf-8?B?ZWxKcDA4aEZzT0FvdmNubUErWGhwK2JKMEFOUEpacG1OTTVFbE9LR01wSXVS?=
 =?utf-8?B?WUNIdDE0V21qVnVpTE15cU9XTUI4OVBtenliUUkyejZOVkhYY0lNY0Q1UHNV?=
 =?utf-8?B?QXlEZGM2b1lEYURrWnhNMkFDMGI4bmkvcVhnUGNnR05TYjlVS2c4eUx5QjA5?=
 =?utf-8?Q?4OElT4v8aZd1Vn7SEfd1XrpqGbWlT6cuqDfhagUPnRbw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3pXT0tGam1YY3NMSS81NVk5WG9xVWovWjI3THJKVjRYUXFKMzlBTEI5WnM3?=
 =?utf-8?B?ZzVBeHR1TU8zdno5a1d2SFNRTG9GQXRzSG5PZ0k4YldMUWZSTng2bW5DczVx?=
 =?utf-8?B?eTFFcDhWenJ3R3lCRlNQa29jR1k4TjArMzFjTGR6d2p5Y29rZGpjdDhqVkVt?=
 =?utf-8?B?SVRHcmo1L0FVMzJFSmo0RHlEOXdBbWl1RWFhMnRScUEwT1FPNXRwcmd1VEpK?=
 =?utf-8?B?RURYWDVQZG9xQk8rZUJXeTcyUDZOL1pGcU9lZmNaVDh5WHdZbkZXcUltS3F2?=
 =?utf-8?B?d3p5SWxhVzV2dXNrbk5EWTRNWkhWTGVGMlB4MjEzc3dOWERYeWtHV0JDc0Ey?=
 =?utf-8?B?RnQ2UHFZeWRaTDIzNjV1Q1JBS3Y1MVhMZXNKbGxXREtES0ZlNVpqcVFLT3Jn?=
 =?utf-8?B?eVc4VDA2M2h1akdHa1JSOS8yTUxyaHJVNkRZUzBqdmZvU1dVRkcxcmVQelRO?=
 =?utf-8?B?SlpBbVRFd1kwOG90TFpqb2FzUmpqNmVJNkYyZ1pjcXdQa1R6WVJaZUYzQkVV?=
 =?utf-8?B?SjV6VHJaOHphWnM1QUZWdmlSYWxHTWNaRHZ0cERNZWk4NThhZzVMaUV2NmFo?=
 =?utf-8?B?N0J5TUtzNjJaeFV0Ry9BSUR6bTRTTFZlejNPZko2VVBvL0N3Um9aWXZtOUIr?=
 =?utf-8?B?MUJ4NWM2bmhlQyt2MEJOUTg3V3lXbVg2cEMwUU9pcStDWmZvZkhYVVRITWxn?=
 =?utf-8?B?ZzM1UWZlYUNPNFFXMk5tQm9zdVNrcnJZZG0rR21WRlVKTnRpTktyQ2FMWml5?=
 =?utf-8?B?MjJ0bStVMTVpVktlOGpnTWtxMlFET2lwZVlDaU5CbmRDWEk4eEI3N20wV1Bo?=
 =?utf-8?B?SE9GTE5XSDRzcURjdWJnak1ScmdHU0E3UDZtV3ZqVEkweE1ic005RmkveUdx?=
 =?utf-8?B?SmQyVkJzTkhiRHFObmoxbkNhMlhnYTJpNlpMRHdXUitIa3EvOEpwMzQrQU1z?=
 =?utf-8?B?RkQrK3k2N21KT0IxdERaeWxrU3hUVGloc2taODNwRzFPZS8yYlBrcmpIeGdI?=
 =?utf-8?B?d1gvanJ6ODYwOHRlWEZ2V05wT21lYlZRSGV0WndoTXIwL2VLaDhoa096ekN5?=
 =?utf-8?B?em1icUx0OXBIbllrZnF3VTJFL0pmMllteHVLL1BFSmpIczZmb2NJUmtETGZv?=
 =?utf-8?B?d1ZwWGt0eVc2c3AxQ3Z4bkR5TFVCcmtWV1VLSGpBWG50MDRHVUxSMnp4T2kv?=
 =?utf-8?B?OEpxa0p6WTBMTEEvbXovazdSUkgranpSaGlaVzN4TEJjTHVYbjNkdjFNUHZ3?=
 =?utf-8?B?WklIcE1XNjIrYW1sRGJIU1daaExIbVJRajZmUmtLWjdDUUVKT0pUYXV3dVhW?=
 =?utf-8?B?U2tqVDVLMG5HWFUrbGlHRW5uR0lpS0JnblpxMDYxZ0NjZW9zQTVNeWUxT3lJ?=
 =?utf-8?B?ZjRWYnl1aXBpdVZtQ0p4dTd2S3FBKzloNXBvaFBFTURoQTdnUUNaWlBwRnYx?=
 =?utf-8?B?WmtPSk93QWNaeDdIdStib1lrVjZ1OWR0ZDVkSmNUUy9iOFVVY1lzQW5sT1lj?=
 =?utf-8?B?dUtMUXVsVXkzU3VhckFLRitobW5oaDZRcEFCOWs2ODBjbVhUM0lTRjhnY2RF?=
 =?utf-8?B?UEMvSWJrcytXdUVJb3dDaDBMUDNzUXZrVFFkcXc4NkhvMEsxOUF5Qlp5VTlS?=
 =?utf-8?B?Si91cU9vRTZ0TGxTcjVkVmhxOVg5SkVaa3ZSUms4Q2xvcXdCR3B6SlZEdFFk?=
 =?utf-8?B?ajVKVS9hSjRibVZGeVBxYTBYdGtEdjVaMjd6ZEpjWHR0VVlBZXcrVVgyUlhr?=
 =?utf-8?B?Wk5zM2I3UjNFQ3B1bU9jRnJUZGdoZ1E0NmZIeFpkS25NdnpiM3lFTVFhd3hL?=
 =?utf-8?B?bjByMDNhQy9xM2JlRkZlcVcvTW1mTng1SGNUK1pLcUt5QUg4MDdlbUtJZnFI?=
 =?utf-8?B?bVZZODFvUXk3QkMxR1JaQ1VSMEkrL0lzU0puSjZNZ3ZvbXN6VlFTZmh6T2pt?=
 =?utf-8?B?ekZVUGtmM0pQb2lMSWdRQUZtWklqU2N6YUFBcU82RU5CdjUxckhCT0RMMEJs?=
 =?utf-8?B?QS9OL2RyQThUYVZKTDVZS1JuelF2Z20zdVNabTZlTys3Zk5nd3lDOUFla09j?=
 =?utf-8?B?TFJPTi96clRCQmVsei81TkwyL01WMVduM2hFRXN3cm4wTjZ2Z2JoTDZjblBO?=
 =?utf-8?Q?Lrb/Lb875IIdzG4rF6B99oRnQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf377765-cea2-4dfc-fac3-08dc6509591a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 09:23:20.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: avU0g7VqM7MD1wuSRL0tjuDVIXWSeAx/VJ1RzmrkMy480dwpuQob0HBDt1Em4zMP/8tf5xLL5mcD3FbFpxMzTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7199
X-OriginatorOrg: intel.com

On 2024/4/25 02:24, Alex Williamson wrote:
> On Tue, 23 Apr 2024 21:12:21 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
>>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>> Sent: Tuesday, April 23, 2024 8:02 PM
>>>>
>>>> On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
>>>>> I'm not sure how userspace can fully handle this w/o certain assistance
>>>>> from the kernel.
>>>>>
>>>>> So I kind of agree that emulated PASID capability is probably the only
>>>>> contract which the kernel should provide:
>>>>>    - mapped 1:1 at the physical location, or
>>>>>    - constructed at an offset according to DVSEC, or
>>>>>    - constructed at an offset according to a look-up table
>>>>>
>>>>> The VMM always scans the vfio pci config space to expose vPASID.
>>>>>
>>>>> Then the remaining open is what VMM could do when a VF supports
>>>>> PASID but unfortunately it's not reported by vfio. W/o the capability
>>>>> of inspecting the PASID state of PF, probably the only feasible option
>>>>> is to maintain a look-up table in VMM itself and assumes the kernel
>>>>> always enables the PASID cap on PF.
>>>>
>>>> I'm still not sure I like doing this in the kernel - we need to do the
>>>> same sort of thing for ATS too, right?
>>>
>>> VF is allowed to implement ATS.
>>>
>>> PRI has the same problem as PASID.
>>
>> I'm surprised by this, I would have guessed ATS would be the device
>> global one, PRI not being per-VF seems problematic??? How do you
>> disable PRI generation to get a clean shutdown?
>>
>>>> It feels simpler if the indicates if PASID and ATS can be supported
>>>> and userspace builds the capability blocks.
>>>
>>> this routes back to Alex's original question about using different
>>> interfaces (a device feature vs. PCI PASID cap) for VF and PF.
>>
>> I'm not sure it is different interfaces..
>>
>> The only reason to pass the PF's PASID cap is to give free space to
>> the VMM. If we are saying that gaps are free space (excluding a list
>> of bad devices) then we don't acutally need to do that anymore.
> 
> Are we saying that now??  That's new.
> 
>> VMM will always create a synthetic PASID cap and kernel will always
>> suppress a real one.
>>
>> An iommufd query will indicate if the vIOMMU can support vPASID on
>> that device.
>>
>> Same for all the troublesome non-physical caps.
>>
>>>> There are migration considerations too - the blocks need to be
>>>> migrated over and end up in the same place as well..
>>>
>>> Can you elaborate what is the problem with the kernel emulating
>>> the PASID cap in this consideration?
>>
>> If the kernel changes the algorithm, say it wants to do PASID, PRI,
>> something_new then it might change the layout
>>
>> We can't just have the kernel decide without also providing a way for
>> userspace to say what the right layout actually is. :\
> 
> The capability layout is only relevant to migration, right?  A variant
> driver that supports migration is a prerequisite and would also be
> responsible for exposing the PASID capability.  This isn't as disjoint
> as it's being portrayed.
> 
>>> Does it talk about a case where the devices between src/dest are
>>> different versions (but backward compatible) with different unused
>>> space layout and the kernel approach may pick up different offsets
>>> while the VMM can guarantee the same offset?
>>
>> That is also a concern where the PCI cap layout may change a bit but
>> they are still migration compatible, but my bigger worry is that the
>> kernel just lays out the fake caps in a different way because the
>> kernel changes.
> 
> Outside of migration, what does it matter if the cap layout is
> different?  A driver should never hard code the address for a
> capability.
>   

But it may store the offset of capability to make next cap access more
convenient. I noticted struct pci_dev stores the offset of PRI and PASID
cap. So if the layout of config space changed between src and dst, it may
result in problem in guest when guest driver uses the offsets to access
PRI/PASID cap. I can see pci_dev stores offsets of other caps (acs, msi,
msix). So there is already a problem even put aside the PRI and PASID cap.

#ifdef CONFIG_PCI_PRI
	u16		pri_cap;	/* PRI Capability offset */
	u32		pri_reqs_alloc; /* Number of PRI requests allocated */
	unsigned int	pasid_required:1; /* PRG Response PASID Required */
#endif
#ifdef CONFIG_PCI_PASID
	u16		pasid_cap;	/* PASID Capability offset */
	u16		pasid_features;
#endif
#ifdef CONFIG_PCI_P2PDMA
	struct pci_p2pdma __rcu *p2pdma;
#endif
#ifdef CONFIG_PCI_DOE
	struct xarray	doe_mbs;	/* Data Object Exchange mailboxes */
#endif
	u16		acs_cap;	/* ACS Capability offset */

https://github.com/torvalds/linux/blob/master/include/linux/pci.h#L350

>> At least if the VMM is doing this then the VMM can include the
>> information in its migration scheme and use it to recreate the PCI
>> layout withotu having to create a bunch of uAPI to do so.
> 
> We're again back to migration compatibility, where again the capability
> layout would be governed by the migration support in the in-kernel
> variant driver.  Once migration is involved the location of a PASID
> shouldn't be arbitrary, whether it's provided by the kernel or the VMM.
> 
> Regardless, the VMM ultimately has the authority what the guest
> sees in config space.  The VMM is not bound to expose the PASID at the
> offset provided by the kernel, or bound to expose it at all.  The
> kernel exposed PASID can simply provide an available location and set
> of enabled capabilities.  Thanks,
> 
> Alex
> 

-- 
Regards,
Yi Liu

