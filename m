Return-Path: <kvm+bounces-30617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2589BC498
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:19:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A60881C213F4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5623E1B4F08;
	Tue,  5 Nov 2024 05:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LR7Y5b6p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D73C6BA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730783954; cv=fail; b=bmoDojlYZFRpTEPgRji+w8+B2KzOZzrvG4V9muN0/E9S4rROHgsQEC6XDRO29qks19wl6C86hXz8/Gvc78oMavwJ8Y94bqj93Wps6a7wVRqspOG4Jt05agxFt5TfZ84tCOC20cEcpjGNs3KVTAxLYZ2lNNIiHQYVEEVU/CR4cPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730783954; c=relaxed/simple;
	bh=X5R4gV+YWksAusX3JJ99w4ey5N2ru4a8RY9TJO+0HsE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EU0mdkM9vY4Are638GAvdLyTXcsPys5mJWfHE/CTfiLwvLI/6FSBKAJVYfZZyWLC5VDitvRRPZHOjY5ZwY4kBzszd9jkgGhdCEGFmCS/H4lz0a3bpnmtYcohVQLNAGoXPYDc3EwZ9PWNFOyaJ42J35sEj/4v9IqEgLHYe579TQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LR7Y5b6p; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730783952; x=1762319952;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X5R4gV+YWksAusX3JJ99w4ey5N2ru4a8RY9TJO+0HsE=;
  b=LR7Y5b6pXGMwfx0OP1ui+OHLIWcLwgZYbIAsONkqAJWR8fxrScLz8N0c
   Z0LsWN/6zOQE5Xhldzxw8+WMMIX6lsJwuUln+zCJVW60c26bF3hiAsgkn
   PnwjnxE/+gwtHWJOHz2SzelZUYygk5ztSyZMSjY4ilm6KU2ROnXhuSi3y
   EWnwmqA26kG+z/cSrwz9loFR0IxJgW7TW1GlXb7cleSjVOl9aCVZ/n9Zo
   2js5mifOv8aQJxF/EbP774zomQx0MRAcQoEUzVRXk1xrwqWG1KDdxAlMS
   qFhOngdXeoF7/USTFfPGq4fsVr5wxZ5IHSxycTaFlxqfmb7u+viXgkJuH
   g==;
X-CSE-ConnectionGUID: AWuf91uAQ0i792IR6Zk2Qg==
X-CSE-MsgGUID: N+kE6hoqTH+/mG1bILVHNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41616867"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41616867"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:19:12 -0800
X-CSE-ConnectionGUID: e6xZ6P7bSFSWInUIbFt4Zw==
X-CSE-MsgGUID: mV9rke3NSr++l0FlRDQyzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83817438"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 21:19:12 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 21:19:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 21:19:11 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 21:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEl6br5vsZwLA0Axkc/ryIzP2+BAaG4XJtF/pyQrhMwulI8MVrAsKkdPZ1LFse7E9rnnCH7w+7gxNqgiBS4rmTUOVwp8DoPfsV0QkQo0skxW2XXt/95UchKNpnXrNA3Vqs01tk5WFq0RpOCJ3dk8mEUVVT/C26hCkmmMk3/fMMIOF3DleEQwjLJgY3tmjdymHDgYE/llBSw/jg9tNgfugv3PYDtCVIsFs7hcJpUnQs7bu8ajEkZO6qxIURR21p80UtpsL+8ChoLULps68z32x1HgAQH2OQqsWpjMJoo3Xck6dbdBjebGvTpVcu3/3m625NLM0EOu1Pn+hV2StWcvZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s757WvfJ6/NJWFM31Gb5YzCNwlWr1+wZk3PxRFAYYbE=;
 b=yZsmeWZ6iH7BXV44OUAflg/mSN5Bikq3pxjVaBGYDf38KKRJkSMov/YYiXFR5Bfs6zy5cvWOUfuom3NWNQyexiMWQ0a+WWIOINDSj849TO29CirrZn9/FL7ObQOGk676zQwK4fhNmd407FAm2aJquv4RELroQk3MfPadRttQMi2roYjmlrdlt5qLK27K94EkyxzfmCO6ul4up/shy/5POc+kjVI11U4TNwLGv1DbHSxF3X5fnR6yyzRwMSTZ2yRwEK4rSDu9FztnhAvqeFzKfU+W+QX8yvnNkwkDbmXpLaWyvVRLmu9GZ2wWixJ/nm+3aIpG0q0U+wqOFeG0QG5CNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV8PR11MB8748.namprd11.prod.outlook.com (2603:10b6:408:200::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 05:19:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 05:19:08 +0000
Message-ID: <0538df75-fb90-4bdd-afc2-c539cd948ddd@intel.com>
Date: Tue, 5 Nov 2024 13:23:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
 <63b941ed-4f46-47e8-9fdb-211b6413137d@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <63b941ed-4f46-47e8-9fdb-211b6413137d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV8PR11MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 23339236-8216-4ab6-073e-08dcfd595ff4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHFKalIxYnFwWVJ1NHZLeVdCdTA4MFRGV0VQTEhqS0RmQ2dlYll6TCtBMDd0?=
 =?utf-8?B?QUYydEVRc3dvNjdFdjZNTkRXcmtLUFkyRzBRS0s0QXBuTUVzeXVNaEJ0R3Bu?=
 =?utf-8?B?LzF2UGMxcHlHY2YvVnZPMWJKRDNoMFNNazV4TjVuUTVjTERPaWxTaWF2aDV6?=
 =?utf-8?B?T1JrcUJlUnVNWnNIRFdJaDRZbUQvNXF5ZkNZczN1U1BObU14ekdoMEQ0bExO?=
 =?utf-8?B?eHJPKzQzVUw1NUhxQ0xwOEJYc1EvRHNYbkd1Ym5WUWdnbVdDdGFDaVFrandF?=
 =?utf-8?B?UmhKRXNHVWF3VFQzd0JhUnpGOHZaRWpNOG5jVUxXRkZCeWk2OE1INlJUYWp3?=
 =?utf-8?B?TGJxVFBRcXNKSTU2WWZraG9xckFrNTNibEZMU2JUUk1RU0JFUTY0NnZIV0Qx?=
 =?utf-8?B?QnBkZTI0ekxQdmFwVU5XODlSMzhxNlVRQlByUkhvM0pySnRlR1VwMC9ieHZp?=
 =?utf-8?B?UWFRSlU4a2Z6UGoxY0JYcnBLUFFyYUNFeVA3RzNxRHV0c1oyR3BVV1FIMG1K?=
 =?utf-8?B?a2NvT3pFTkwvZzB1ZU5pcld0R0thRkRrUmZiYmZpRERuSjBSU1F6alcydlll?=
 =?utf-8?B?Z25UcXpMVHJPWGZBNlpvN2xNdEtGR05reXg4V1U5dlpFaVkxTHQxNDhZclFU?=
 =?utf-8?B?c2hnNCtCY2ZHSkdkNDcrLzlNL09oMXJaSnYrMExtWFZUYk82ancxUnlwMWZo?=
 =?utf-8?B?SkVqeGlVTTVyNGYxd3ZnbjJhNGhFU2l5dGZody9wTUhWcGFXbzFST2svenUr?=
 =?utf-8?B?K09MdkdyYXhTcUtqb2wrUjFwWXZWcFhnOVBkeUFzRno1NnFFU2FjK3VncEZZ?=
 =?utf-8?B?bTZTcjdpUERrUXhlK0JMak5EQ1hpRjRvOVh0Zm9WSmphdXRYRTBjZmpNNVlh?=
 =?utf-8?B?dGZjNWdaVUxCU2g4T0xDZlc3YVV6OS9jZ3p6ZGFTMFM0VndqTnNoeFJoMEpo?=
 =?utf-8?B?OHNjb0FvMGxhamxMbytLOTBzZnlvMXJHcGpLZ3ZIR1pNV3N0bTJpZFhRb3gz?=
 =?utf-8?B?QnhLN3YvSGJsTjE2OFUxTnprVlZWY1NNTjBtMm4rU3M1MXBiRnY0NGRFdHFV?=
 =?utf-8?B?NjZxMWpxWk9Dd0Q2MEhhc0F1VUtKRmxRUUFha25oaHk0aDhLTkZPNTlPdVZI?=
 =?utf-8?B?SkZhNVlKV3VtSWZPVjlmQ2M3ajREOVI2QnV6ayt3VGorQmNGejVnUE4wZDYz?=
 =?utf-8?B?eTNsQVBOMGhweVI0VUNqYld0MHJTaXFkcGNvVHhWUnZVaGhwaEZSei80ZE5S?=
 =?utf-8?B?U2N6QTVYSU5HTFlwY1BLd1dDaDlGRXYxL3ltRElqSFExQlFwZEJMa0NoaWp6?=
 =?utf-8?B?bkQ0Y0M5YXBVSTFoQlFsODZYMU9SZmVEUGhVY2hpcnl4bytOZmZnNkg1NEtx?=
 =?utf-8?B?TCtBU2VSWW0xU2NTRXl5OXRIa0gzL0RDZkphMHBOZ0cyVlhBRWJ0cndLQSs1?=
 =?utf-8?B?eTVGYlpjWm5OUnYwSkFyZjlmaEF4bzAzdXNKS0hnQ2E0NitlVUN0Ly9UMStk?=
 =?utf-8?B?Y0pZSU9HL2dZN0MzaGl0bU5jamM2R2tTZUxoTUd6NjNUcW5VN2F6K2JWM01x?=
 =?utf-8?B?WlpLTnUxVGdsTEVBRklyYlNVQXNrZE9UMEdlS3Bha1FjZVh2TGs2NU10Wm14?=
 =?utf-8?B?MTN3a2RRajBKWEEwTWhKa3dMNWN2K2d4R1cwZEFnOVc5UUlMd1RxT1pDZXF2?=
 =?utf-8?B?L0NBKzhGczZEVENscWFMWjR3N3haUFNnM2RsZmF6aXNEWC9rTUV0dG8xdXRG?=
 =?utf-8?Q?n/CzIkugScnGe13JP3L94D5DeN9w39jqlqbR6wt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blA2UldqRmp4b1kyMGc1dmZLb3hTMkdEQlpFMi8raExHVE5lMzQvL2tROHI1?=
 =?utf-8?B?bzgwVGVsWDc1MVBRZGdOd3Q2UDU3eGt1RXoxV3djR3JuOTJMeU0yc3B3UWJa?=
 =?utf-8?B?RDdQVXVjL2lpakpFOXU1RUYxY2s1VitPYW40L2o4L0hVUGEvZ3ZwVWl5SElP?=
 =?utf-8?B?ZDR3V2JRL3dpTGpYNm4zemJMMmJwS1ZGVy9zd3k3emNjWU5mVWtwMm9kMnc5?=
 =?utf-8?B?UWhmRGJxL0daY0xBQU8vZVpmSUdmYUdJZEo5dVFOUUNZZTFORlFKcGd6eEw1?=
 =?utf-8?B?S1BRbWJ5a2o5Q2NTY0NQbWNKaDFmdEQxbGhnRVVnS0VDbC9YdzlGcUZDQjd3?=
 =?utf-8?B?KzhHdG9iWVlBMEI4bGJhUGpVSUZDaU5jcEJyL1RxRDZpSmxJRXAvdjhNaGdT?=
 =?utf-8?B?cWFHbU1Gc3U0bmEwKzB3cmU1SlNqLzZlRGJIOUFRRVFtMy81ZmZacDJOY0gr?=
 =?utf-8?B?WWZNbjl6SjlSVG5qWmRGWDlSWk9OKzB6TmpCNXFNd1YyZ3R3d0NQcVlENyty?=
 =?utf-8?B?b0U1Y2NUSjByU2dMOW9pVTh4eWUyb3RkcWtCNWhZcFlJejBmMjk5eG1PR2JW?=
 =?utf-8?B?bHhVWWVaTzVKcHZsa2o0Q1ZLVFRzaTlRcWZ1RDJDWEZwejV4bVlQRDc3RFB4?=
 =?utf-8?B?UmpLUlBKQWNjNlo2b2lVbkRWaG5PL1lRRVR5Q0JyNyt1R2JBUFI4R3RZWlkr?=
 =?utf-8?B?ZjJNYnRnYlhIY0Q4ckROUkhSZEhYZ1FBWGhjS1haUkFPcnc4VnI5Nk55elgr?=
 =?utf-8?B?ZDF0SEN5RW5LeFdNZXZ4b0M3VHVUdncyZUVLSFU3MEliVXpHd01wNVoxeUl4?=
 =?utf-8?B?eXJIL0I2VWdDOVNWbnp3SXhBK0tscDJvT0JOZEx3YXhCU2IrTjJuT08veUdD?=
 =?utf-8?B?ajdYQVJEc3hxaFJoNFBGRS90aVQveXZqQmZGdFAxVnJGU2JVbkF6QzVEcmFU?=
 =?utf-8?B?aTZlOEJxT2g0V3c2ZDdkZlBxUENSTzJyMDNPcFNIQzgvSkt0WUxsNWkxMUF6?=
 =?utf-8?B?c05xSytUS2ltem9RVG5EZ3EzbVVUTmN1aWNVZkJrdGdzMFZRZk5CeFhValhn?=
 =?utf-8?B?NVgwc0xQU01oTHlraC8xbnRmWkYvanN4ZmFvVkV0L3I1OE5JL0hMVmh1Q3ox?=
 =?utf-8?B?OHAzdWxEMUUxSlA4U2t3NUNRRzlLOXViU2xla2dleWtIYU92Um5aVTB3dW1J?=
 =?utf-8?B?Wmx2SEN6ODI5ajUxVWcydzFKcDc3ajFWSWR1VHlDZTQ0SDN1NzAwUlNvYWZy?=
 =?utf-8?B?c05LcUtFb3IzV3ZsdHljcjlWVHJyaExSVi9meGN3T2RYWnQzdnN2Y1k4WjRX?=
 =?utf-8?B?RW40NFdoRTBJRGJTbEdoRkJrRi9VRnNqbDFNQzA4QmtTdU4zakZkRmIwdllJ?=
 =?utf-8?B?UHZKcmtWak4wK0JjcytQMzQ4SzF6cHUxZ05iSm14Mi96eElIOVhhczcvbCtT?=
 =?utf-8?B?K0lya0RuR0htOFpDWFg5TksraHp3MXQzU1AxZEtLMnVkTU5FZGtiS1d2RnZU?=
 =?utf-8?B?ZVo2VnNDT1hLbFRsMkw4YzQ4bmVUT3oxeUxYRTdJOWVNTUdvaGkvdmNKaWh4?=
 =?utf-8?B?MzFWNnRvaEpTTUhlUlo5V1ZEUWFvcmtvVVdqTjUvOGpRUmlzWkxrdEM3NGli?=
 =?utf-8?B?WUEwZnFNUDExWEhmeUlZRERtUTBsZkZqU3JKQjVVL0FYTTRWdGxLQkw2b2V6?=
 =?utf-8?B?RktkZnQxVEFhYUZjVGFuMXlmVjR5ZFNqalVpQzlIeGdMZ25uQSsxVm4wWmtT?=
 =?utf-8?B?QW82eHR6bzNRRklZSFBreWREK29hL1hYV1Y1dzRZVHMvRzFWbkRremlKNmJo?=
 =?utf-8?B?MzdHUjNPMlRZdXVhZDk4dndJaFIzTDVmdFFkb0JpUVM1YnlXNTlVTjZLZkdp?=
 =?utf-8?B?aDltVHJDZWN4a2psdWU0N3dMdURPcHdLSCtXajZ6NkpGQXpnQXZwVzBCQW5I?=
 =?utf-8?B?cTJGRnpaRnQzU3AxTytSNFN4enppOTRpaVBoVElYTTA4M2FsSFByNDJkcjhQ?=
 =?utf-8?B?aFFWWWh6Q21PKzk5OW9HVGJ4cTRUcjBMYms2b2xKKzFXdHExcWV3NWxxSWpM?=
 =?utf-8?B?UlQ1ZEFtbGgxdFQwTFFUeHgvWUdQY2JGMldaMFJ5R1ZlVXZ4Ky84S0NtOW5O?=
 =?utf-8?Q?tX+l+XwIFIjXt0EYMW0XkLiES?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 23339236-8216-4ab6-073e-08dcfd595ff4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 05:19:08.6493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OuVndfthSArVha0mFkr6PnMLaDBC6ubrhcepdMLIjDeIErvFLzSSn4GBjA721trwJn1EASk1nuqoWSbuxOvs6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8748
X-OriginatorOrg: intel.com

On 2024/11/5 10:49, Baolu Lu wrote:
> On 11/4/24 21:18, Yi Liu wrote:
>> To handle domain replacement, the intel_iommu_set_dev_pasid() needs to
>> keep the old configuration and the prepare for the new setup. This requires
>> a bit refactoring to prepare for it.
> 
> Above description is a bit hard to understand, are you saying
> 
> ... the intel_iommu_set_dev_pasid() needs to roll back to the old
> configuration in the failure path, therefore refactor it to prepare for
> the subsequent patches ...

This is the partial reason, but not the most related reason of this patch.
Say without this patch, the intel_iommu_set_dev_pasid() call avoid roll
back to the old configuration in the failure path as long as it calls the
pasid replace helpers. So I chose to describe like the above. Maybe another
choice is to name this patch as consolidate the dev_pasid_info adding and
removing to be a paired helpers. This can be used by other set_dev_pasid op
within intel iommu driver.

> ?
> 
>>
>> domain_add_dev_pasid() and domain_remove_dev_pasid() are added to add/remove
>> the dev_pasid_info which represents the association of the pasid/device and
>> domain. Till now, it's still not ready for replacement yet.
>>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c | 90 +++++++++++++++++++++++++------------
>>   1 file changed, 61 insertions(+), 29 deletions(-)
> 
> The change itself looks good to me,
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> 

-- 
Regards,
Yi Liu

