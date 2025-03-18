Return-Path: <kvm+bounces-41385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B11CFA677C8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E380219A76D8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486B920F091;
	Tue, 18 Mar 2025 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/h9vYwm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED17E20F075;
	Tue, 18 Mar 2025 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311495; cv=fail; b=eC60tK+Y0u7IiK2N9ocBF3UkC8uP0sm+T03pL2Fmy3ywfRjS//eses4AM7sM+JfEho/h+Eusg1WjaeROYPQbhZauRgPSmGgUREMSzb+kCw9aH7EN0VN5G+JCOkRC4fctfn+LRpf6yiarSK4ddVXe/L+M4a7wyXnrV+T7n881F/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311495; c=relaxed/simple;
	bh=niwh9hEpVb6vjfgwVQCKuWIuPSjraZGqSnsU0w2IzBo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fc7jVnX0sCRMBSXvMgNXdnV1xDBh+1E2/ohGI2XNaCIWIHL872nl4uIjuRJaTNG2qGM5vVkzTrRdHuKJrgTcLAlE8ejdcNxz5Ld/NRq1oWorVODynS2Z/JwPN2qzg+TC+R4FRsh4JE7ojC4UqmpdZ9dFUP3efpJTVe2x6J6pRUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/h9vYwm; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311494; x=1773847494;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=niwh9hEpVb6vjfgwVQCKuWIuPSjraZGqSnsU0w2IzBo=;
  b=I/h9vYwmtDxxhN0XO/GAEQNXL2WQhIni7XOaVamsEL/8LeNMNfU1/5dn
   zHwoDV++reStpDU1vWiOPF9++VgAPrKkyF25enYPUJGKAyuKNCM+ndFnF
   ZQQZq7rC7kN7WDT/xECo2qm+510nKKZftKgH/UogcFzhKnZpByW7nER8J
   AsB6goo+pX7oJLM98s2KURxqUN8aMb3uVpMGX9K5rUHC+/TDfPtGrVyE4
   p9Y4At2+zvU2c7qWcqlusYBW2KnOLhHVjEli2+NuXr9K2i/y2SkhZLDVU
   gnnLCa1N6cNXY3wVQrmJY9Teqd4YozcecIWjJRmybX2PJlKCCSBZCfx2f
   Q==;
X-CSE-ConnectionGUID: L9p6VtoKTdKUcBR67WYyDg==
X-CSE-MsgGUID: MBtIdW2USE++jIfn/o1Pqg==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="60991412"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="60991412"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:24:53 -0700
X-CSE-ConnectionGUID: VMKvcnPwS+mORBMPZ89KKw==
X-CSE-MsgGUID: DIUGQaaXSGCHXyYEVZefpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="123234036"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:24:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Mar 2025 08:24:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Mar 2025 08:24:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Mar 2025 08:24:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f67vKXYsdlzR69WE32VzMDGLRpMya1WKq6jSUG4tZXT41rgpVf6fwyXizGNqDdC1uFSLaBaYmHnkPyAZkR1bzu8HYRDeCj8Zzqv4E2CLwBB/sDKQ0NkkCyZYk311XeDdZH8l3wnPNO8XTvwIyXCUU/yHIzrm+T49EQzdTVifSbDPzbO6ipu8dCvaEGcG6iL5d5xnlpSv4SCSVHb/STm3xZvq8O5F0YzHnXnXea7SgblFKSaAabeozR/4DjuOSL5dd7B4su7u/A2+ZyUsT03MmghXa7bWCE/Yea7vR8uqWzApU/4qwlYMPKmgOesNWHeCqjd1gQEwVPtdMGoWVazwjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7Zf+aX1Z7vy/GoceGgRxd36axXyFQPhaLSa5no2qek=;
 b=AUvLpzJr5UaKuNsj+De0b2aOsqxi9kvipD5EcMIjHtpgewCGdUQDVuXKodg+RulFxH3KeX+1EC+K1+KvcO1IYyQLw78OVqClRCWhbNbJ27QBHqaH70f9ToCT2c4dxzSFKXtq43x19uZtwYuMJUovDhPTijhTZsBqmwqGEWtHUhQobA9IicMqcG9ow1PznZWPDjsI+G9khA9Z56NMR6qhfD32B3BOlOMFdMpTNkLwWMx10e4yVch9XhkvSPcMgy+9pwhhK2RzXJhYyfxW1PmEq9xEGCkZLnXOaIWQLtCEL1YHkpCHBBiz8x/LmITurwCm/dZhgY19dm7d48TGgAM7bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB8098.namprd11.prod.outlook.com (2603:10b6:208:44b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 15:24:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.034; Tue, 18 Mar 2025
 15:24:50 +0000
Date: Tue, 18 Mar 2025 23:24:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 00/10] Introduce CET supervisor state support
Message-ID: <Z9mQN3gPpcWPGTwA@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <b9389b35-c1ef-4a53-9eb2-051df0aaf33d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b9389b35-c1ef-4a53-9eb2-051df0aaf33d@intel.com>
X-ClientProxiedBy: SG2PR02CA0085.apcprd02.prod.outlook.com
 (2603:1096:4:90::25) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB8098:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b5ccdb-2867-4200-969d-08dd6631060e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aE+6fqNUj+QpH8LZjeCvsWLRlX/i6J82UgAnAMGQQgLHfVjy5dT7pAKKCyMM?=
 =?us-ascii?Q?+V6uDLj0Sbe8GW/2qn3sWc6RIQA1Y/Z90vuliBiudPhYIQcwpaHy26RawnkP?=
 =?us-ascii?Q?4eMgFm4btPJmjH8x7eMjRvwU6HVkVfo6gY8Fm56f4CWEnC5wEm5sJcrqcJqV?=
 =?us-ascii?Q?lGH9Dsdrh2PinszIngitnT61+pcy4N/zu4zkZ6ZKaaun3+aJiKowhWTHp5BW?=
 =?us-ascii?Q?8AHDJ92YhafMiF9II/l1YeKNLc1uWu+53a/Do/fcFoZZ5no6fz0tlBjXdiXz?=
 =?us-ascii?Q?+/d2/T4g85JKsmsF8nRLthTuiKFU/Zq3XfuEnV23A2+uwZZOf+/ZYaAVV9rn?=
 =?us-ascii?Q?qba81xpqVUYJTMbEI9U/r12Zw3ynb7iC+f4IOGJuv7p10m2UjTz3QxKzOciZ?=
 =?us-ascii?Q?ngxgexxGUvn15bwBmbbSctQj5d3+yTsMps4vlw/VtLAccwRbl7nI3QIEFgAd?=
 =?us-ascii?Q?XWj6YUN0W4eNhnNpRe9WpKGwdXlGR9mBFWd7Z5LPJVFK3EQrDgU95LyeVkX8?=
 =?us-ascii?Q?mrvHPHRrT2kjGy1lP0CKz+wwnIVWHdoIgjWRxhEXpmt9Ybt/J2oXEKRixycc?=
 =?us-ascii?Q?asyXB8EMXr1x2W8mfTSNkK3oewPMg9TS/zSmmIYimvohW05qIHy74qn4jEvl?=
 =?us-ascii?Q?v2M6vP3cupnX7ysZC04d5yo4blVNFaX+eWXQjOJpRpV0w0jMv+CdmeGoYCxk?=
 =?us-ascii?Q?QljSoqKfhemqqo1CLo5o2MRJuM4pGtBXrHoGBlBs6zcdN1D4TjF4Iry3tAr/?=
 =?us-ascii?Q?Oh03BnNZplTrS0sWuQwR+E7ov/9HXSB5XJnDlJ4XBZcaLXVQUihBQmpqGmxa?=
 =?us-ascii?Q?9DzFtP4eOY4xYHykE5JZFQeQdy4IDAFGgJGDK4oG24TxeX0zh8tnKaq5Vy5p?=
 =?us-ascii?Q?aEtVrreWewZW9PHwIl7hHF1QVBM7iOrBcRdU+ewtAqkRutgJoxAhJcx5QXzF?=
 =?us-ascii?Q?bRuKy0YGOPusTmTVtBhJCcVSayBTLtPJfq2MnjDkSxE7aebVfVvh89KgSC44?=
 =?us-ascii?Q?g0DMyz7cuv7pTRfNHVo9w8FcU32VSlE637d5qdcJ0u+57gpUX6bV1c86L3Bq?=
 =?us-ascii?Q?Z1GRaKslSG/ogkK03YAi2fjCYvtjgOwY6bGmevEPWb3xU8iOfIjcVhB7M65u?=
 =?us-ascii?Q?91aG2b951GzKMufVt8UMyQgSj1BLfr3WGb/iDk/RI/1x6xY1ng+99VugGmLe?=
 =?us-ascii?Q?1LOVUWoCdSJUy7A8OJhygTw2/jeQsw6DxsDsPKfVE/eaSyGfxO6M9hsSVk1L?=
 =?us-ascii?Q?lKCfsKKydyBcX9B+dNeqhiZD9Vs8ceQJHYmqqGp7BvEenA+P/PDZfhAhjxIn?=
 =?us-ascii?Q?gfc/DiOPqTyq1T3vZjjyoHGttDRVEWulMHTunmvfV4mBLQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEkANHF4v/FIo64B8bW+QjCd0S+VLgfkauSEgmU3BslQGakiq8HX6jNm/u21?=
 =?us-ascii?Q?0bQe2XapbXbe1+1jMr5qq+oNw3ewDMiuWHmk9pAbVx5E2i2NKQMm4zg1PNlU?=
 =?us-ascii?Q?1xMi6OOosjOQ4GOQ83zyH7ZG9eXqGiM4VqsIa4rAwntAjPRREhhXJLDSGV+8?=
 =?us-ascii?Q?7IFEh1uy/dgB2GA6MSI2iVVrm6gIZ2cf3gIw7ph1KQMDjk0dDutYl4iuDSpC?=
 =?us-ascii?Q?1pR64d//HBbwc6CBK4mdQwlYeyIMpzHEuFFh11Cqwmy0EZQGQ7K73w7lEvnT?=
 =?us-ascii?Q?nUzS95dyS3lRRRjlWVubn1ZC+LI4do5IB4/Sq9FfQhZN4c3QJrJMuryMIOxy?=
 =?us-ascii?Q?VLXKY6DXEXtgoRt0pGrcQDOOwI54OowreL6x0ri09bJX3y7cm8OEaUK+yEuB?=
 =?us-ascii?Q?rA+XVMkXprZZlG+h4qKHSgNeLffvdakh7VR9R/wbms/3zpzIr0bhSLanEKe3?=
 =?us-ascii?Q?Y76L1E9QIdBDT2wZtSW1pIl/BYMYlany2yK7+q1dQwB+CGj3V1qugNUzhvqm?=
 =?us-ascii?Q?peJVLz39adZXMxqfpX5j5LIDXKmIGt01MRtf2CQwGy8APsQwe4Pag+srcsrE?=
 =?us-ascii?Q?Q+QnUAjUpKcABZx2gTrTl9RxdaxY1gaPUyVeztonUKfujWX4a1gOKAi+tc22?=
 =?us-ascii?Q?3/l6qtwBJLG4mU2Jcwmrcx2skdxDgjnZ52FRLS+ANKlFoF7pLVxGypaj5eyE?=
 =?us-ascii?Q?X/53dmZJqORB1JXk6Psqe3uuYb6ZsJa+KwpjxJtpRykC8w38/6MkfdeH92J7?=
 =?us-ascii?Q?KkBnLm7VehgfxXFFaLNGiCYXNfZ6LNw/gF8njeITlmzWYBGd2qCY41iRzRGA?=
 =?us-ascii?Q?+RlLs8L/fQJdU90SxbImAegtV+8btUrOXnNqcytFLhbpdfq/5EDbHU/80Str?=
 =?us-ascii?Q?d+U0P7uYWWH0/pVCDJJ+qi1yfgJ8yzBUS4Kq2XpvjHMTrMyWqfCXbR/v3Qfv?=
 =?us-ascii?Q?xMH3HNLFoRZs/QKD2bADiLc//736oOJkXLQloAkBZKviXvnQZCp8okr+gE5x?=
 =?us-ascii?Q?ZKP2NDmt6hiI8ZDWrOrWDJ2SFn6GnTaDecIjlUGlN2vFBb7C3VhLR3LI4gnj?=
 =?us-ascii?Q?CLEuj7OH/hUQK6eg52uCWQ97/xJXdrEnxp6qpPMNhXkEIMK7MrB140VTbi0o?=
 =?us-ascii?Q?cqaFO2B6VPCtDYLfrNKG9jpW7IwV9O24It+AHejWIOsTx3pxWiBkheXBJhX4?=
 =?us-ascii?Q?hMJQDd8okfu+Oqs0DsQyNx7zZNh31fGxfeNGR/YFfe7xyho1srUZDzmqik9x?=
 =?us-ascii?Q?4w+OntDvtLJcDw/eH94TWjzHWFmEtab8+vhCtWubUlIgxQAEYzzQe9C9iFUH?=
 =?us-ascii?Q?zH+L+Bv2OPDzGVkouGxR7uxKONlz6vXXLF0FAwwyELsrj+zLLqwUoeY+8iGy?=
 =?us-ascii?Q?VSPpN62j/uSDqMS8V1xTg8eMOqVjAXaJUytvJuWZb0gLARhD6tqYaSq79Tn6?=
 =?us-ascii?Q?2FdcHT3R5cZTDjJdb7vFTy8IcAix4wIfE2b9N20EEMDnYXmntSAEt6BuDHbv?=
 =?us-ascii?Q?k/tgD2dgZIBcipXAV8lTGsyJHSTxz8kc9AZFSmK7lpNioi00Iue3s1ON5tev?=
 =?us-ascii?Q?+Qqjbd+q1jV/kOSiYVYyLLNSmWybVh/mw9cG4OQK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b5ccdb-2867-4200-969d-08dd6631060e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 15:24:50.1881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HAdyoj07p94cH1wtvVBOAVWvFDcTbFWN3HyiL5TPKYQcs1hEwl9TUexdXkUuo4vuU42bduGCAA6u5Q8Mr+b0Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8098
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 11:09:42AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> case |IA32_XSS[12] | Space | RFBM[12] | Drop%	
>> -----+-------------+-------+----------+------
>>   1  |	   0	   | None  |	0     |  0.0%
>>   2  |	   1	   | None  |	0     |  0.2%
>>   3  |	   1	   | 24B?  |	1     |  0.2%
>
>So, 0.2% is still, what, dozens of cycles? Are you sure that it really
>takes the CPU dozens of cycles to skip over the feature during XSAVE?
>
>If it really turns out to be this measurable, we should probably follow
>up with the folks that implement XSAVE and see what's going on under the
>covers.

I reran the performance tests and observed a run-to-run variation of 0.4%
to 0.7%. So, I don't think there is any measurable performance difference.
I will update the performance statements in the cover letter.

>
>On a separate note, I was bugging Thomas a bit on IRC. His memory was
>that the AMX-era FPU rework only expected KVM to support user features.
>You might want to dig through the history a bit and see if _that_ was
>ever properly addressed because that would change the problem you're
>trying to solve.

I went through the email discussions and found only one relevant thread:

https://lore.kernel.org/kvm/87wnmf66m5.ffs@tglx/#t

where Thomas mentioned that guest_perm would be set as follows:

	guest_fpu::__state_perm = supported_xcr0 & xstate_get_group_perm();

If implemented this way, KVM would only support user features. However, the
committed change is:

980fe2fddcff ("x86/fpu: Extend fpu_xstate_prctl() with guest permissions")

In this change, fpu->guest_perm is copied from fpu->perm:

+	/* Same defaults for guests */
+	fpu->guest_perm = fpu->perm;

There are indeed some issues with enabling supervisor features for guest
FPUs, but they have been addressed by recent changes in the tip-tree ([1],
[2]) and patch 1 of this series.

[1]: https://lore.kernel.org/all/20250218141045.85201-1-stanspas@amazon.de/
[2]: https://lore.kernel.org/all/20250317140613.1761633-1-chao.gao@intel.com/

