Return-Path: <kvm+bounces-32724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD919DB2A9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 06:59:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDECCB21C55
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 05:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFB6142624;
	Thu, 28 Nov 2024 05:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GNEpfiYy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D431D13DBB1;
	Thu, 28 Nov 2024 05:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732773562; cv=fail; b=Ig61e07SDg3mlayzLSdsVQnivlvqFj4NJPnrwgXOL+QcJeqYpGF7/fjuqLY6f842N7M0sPC9gFlkla1FU9LMjS3cwxsSjmzbrh6B4gO9PhuVcXbMi5Sh5D1ZeQ+FMqi8Xmh6Y0kVTJUW+GeXNIEnt10fpk9lGw/RplZ+6aMBtIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732773562; c=relaxed/simple;
	bh=NKctYtcNHHupLn6ZXducLlG+eABdJNlM7tgKW4MDye4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NGMWux5ZU8ZA/UUWeaiC1EQcLDrsQPabWK2WPbo2lQwjfns+7h/Z4YUDqXspfI7TZD+9r1UImXhdIvdwjcTlQEQvgdaB7LL1IaThA7QdmrM0SquAm//ns2udbQ6Gi0DMaG4rXsNRzAdrkjULaBv57ne+dW73ImQfsR/KaMpcwYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GNEpfiYy; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732773560; x=1764309560;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=NKctYtcNHHupLn6ZXducLlG+eABdJNlM7tgKW4MDye4=;
  b=GNEpfiYyZHJlrBnbfSyBOCZ6nMg/9NJwAmoi3urBu9Ux6hLCGHUCsOUk
   qIHqM/9Hdnq10YUTQxa7uSB1FlmY2OZcYOkqnx+J6mVk/UHhgt8vPUDvO
   1i4+oCqJBQJmhyv282Z3uqhMsj2U2IscUtpAcpcB4NnoeZvCgjKCpfv+9
   NDfiFGqGOX1SoMozIbXl4YnWk01n3fkZZIFbDKCnWwupnyDXP4NcVFnuj
   uZynoSq2VMqulgOzgVdFodSwWJJ7y8DcPEiewOgg9Tvc/ZlE9jJYIKeAq
   mqOh1jaJ/fpOXLVSjh4prcOVSwOr1gnXtt9k+0+p/cSkNXzQpMnFpRGPY
   w==;
X-CSE-ConnectionGUID: 2ELKZ+T6TOuM2YfZruaIxA==
X-CSE-MsgGUID: BAmtvcnASXaXtH/rInelZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="43483315"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="43483315"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 21:59:17 -0800
X-CSE-ConnectionGUID: LqTx/NuVTT+pfAmzWid7SQ==
X-CSE-MsgGUID: yMzE2cdCRv64wZfk3PQsqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="92237010"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 21:59:17 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 21:59:16 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 21:59:16 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 21:59:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w5VmEXPgajXQ0SKVCkJKySHJ0SFFRatzqji0QuAnQ0HoWUKMgd9zYLse0WeEh4wi+xMDsfktbsrkMl1UiTTYEqZPGfj7oOsBI5M45upE+J7pPTpgLgvCDMoOqR95L6p13e/wPflBg88u3LbUZ0OEuSJ765FFcd59bTau5D5pH4SbgZr5sVQwYXf/lOMXZ9RSab87ggIlPDIEcvVbzpAj9LKeduJdz/G6Msr+kyFFEpM+t4ZbEI1XDrablFF0KPVIFdLCM78Pck/Bc5mq9joLm+VrRm6G5nsXwIc8TEMbo4vTG7i8hdei5q4OARdZ2SpsMWo+AqPRvJmTSxcwFVjF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYfYO+dhIBdLtCNOnZ6JfGeoZ+lg2ICNvRPu/f8EKxs=;
 b=FjWji0Uw3znyfynxqgABG81Vt5IIV4UFUhUxHvlHm2KCeMmpVwwKc5AC3cFmirdif9XbqblDoJFS/ClLm+/pNAMGFToBJ7HG6HooQkSsb57pcxCtsVJfVFZPEU9RW9YXlAbm2dx/QcttR9hZ3+H+2HbsVPcyJqBdHudXDuqpAP34x0ZVvWS5jRroD7yppKs1gNFs1X8w5C8KY2MznmeYCoIAcOJ834xg3ySMYE9nfJ5w/93Xjfl4cosqxKnpkXyLWXQxmkhlMeNilW4JoddLVoJ4TVSquFc75ffTVerS1wNYgGlOk0RnTH1eLBh4FfKLq7PXNt2rNqCn66GZx0JsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7415.namprd11.prod.outlook.com (2603:10b6:806:318::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Thu, 28 Nov
 2024 05:59:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8182.019; Thu, 28 Nov 2024
 05:59:08 +0000
Date: Thu, 28 Nov 2024 13:56:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH 2/7] KVM: TDX: Implement TDX vcpu enter/exit path
Message-ID: <Z0gGBnTcFzY99/iG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-3-adrian.hunter@intel.com>
 <2f22aeeb-7109-4d3f-bcb7-58ef7f8e0d4c@intel.com>
 <91eccab3-2740-4bb7-ac3f-35dea506a0de@linux.intel.com>
 <837bbbc7-e7f3-4362-a745-310fe369f43d@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <837bbbc7-e7f3-4362-a745-310fe369f43d@intel.com>
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7415:EE_
X-MS-Office365-Filtering-Correlation-Id: 26906ce0-2f6e-40f7-c4b5-08dd0f71c5df
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?oEGFd2HB/vozTsJi2jY0XthE+oWw1iKoEDtuYovWTOsWT14txb1jXhL+oO?=
 =?iso-8859-1?Q?Som3MoDCnYsgM6TSlgNQhLADHdjcOLoWnpVr7CN7p3H3ia0cZDBG4dJzQW?=
 =?iso-8859-1?Q?ur4hCZFAVlLfirHEazmX5ZPykiznNU6W2Wp/MdHTH5AV1HiTTGnwwMU4t+?=
 =?iso-8859-1?Q?9OyezYhgpNNrrCRodOqD4GmbEX3aegprNimA69O1pYfkZRCqYjHiQo1Md/?=
 =?iso-8859-1?Q?9GKlvzPd4ydCYU54MgR2V8TrYmjWA3u91SmyONtNYjE2uOXTFfC2lONQPO?=
 =?iso-8859-1?Q?FW7Bmp9+IrQF977qnoDDBycOgvf6FmP0bndXWr14n37khvyxMV/wYYHPGl?=
 =?iso-8859-1?Q?Fkh8eurv1X8Pjssd9zpVof51/uhlO0Y54fv6DIdtg+Y6YjqXbU/IA3Vc07?=
 =?iso-8859-1?Q?cIm4Q7zE1BP6mXtr+4sx1QDwduUivrCNvzeQj2rmsP5F1s0AYfY7h28+TI?=
 =?iso-8859-1?Q?v+pqXkyOmffjPhmYi2VptFLqRxz2ff/jHNu6Wlgv8ExvqM7tRXeaLL4sk0?=
 =?iso-8859-1?Q?AQgPgj7E2MU5xFVsCWBBRevKmnM2CaFyfTkENJGH2CNJE7VP9r/YnIAbZM?=
 =?iso-8859-1?Q?EZr70RLNrgf2g2VG9clCYJrkVrM7zzlMGwo/6axOC/+4uV6MxCjt7JrYn6?=
 =?iso-8859-1?Q?tTkjcTWZoc5LL39ssvQbG1s9MNdbIq8/V72QBbaCE2B5GDnX+WbWX/PWL9?=
 =?iso-8859-1?Q?nMG1S55WlJ8zSNbA9CAjdhxrw9cxeliqBs2v3rkgbr+9DK8TsI20XMaLOc?=
 =?iso-8859-1?Q?Q95qMHfbThKaa39flfigA90Kjj+FCTF1K7Ih/6M4vo8/UfYA8N+DXXS/cf?=
 =?iso-8859-1?Q?4gYNOq5Y2jNzNSZBv/iNJrILuic+IcsV1C7F/j6nRE734fNij7pvvhYEeL?=
 =?iso-8859-1?Q?TUvUMqlnpH4ETv0GvsMsL8BfY692BWtNObBGddQkYHAQlkYyE6iqZ8tHkC?=
 =?iso-8859-1?Q?ByykCrCTmXRAVh8G+oiDXWoklP/YUeUSe9/NL8Ot90VPOWB8hlJFcEOudJ?=
 =?iso-8859-1?Q?Va+ncIa2Pn8AO4YoRe0kg8qgS5DJPk4K5JGr67Ugr3YTsPvAEx9QvWtChf?=
 =?iso-8859-1?Q?7HdWWmDi/GUBQ7vckQ4zJeqeqc75DaFvv2SvNjqy5Z/An6yxB0jFxj+CUx?=
 =?iso-8859-1?Q?HtAGB/eFVGjmSVL16sacYG61YQO66WWzvAQ4TTRuBpRi4VfYbMkpPNlriq?=
 =?iso-8859-1?Q?NQEtKRfdm1xSFt6+LcCS/LfYwM4aXtHktHSRjAgSbzxHMqnDS+Qm91k/jZ?=
 =?iso-8859-1?Q?MAVOESgq2xK0j//3vrMDBZ90yZAzWt29jyrbzzHgzWK9ieN/RgBWYQANdL?=
 =?iso-8859-1?Q?RkbUZrUMxORrK7g0h8pSJ/fYWqsXuM3K9+EPdxfpRWjPguz9H/f/NuW5dI?=
 =?iso-8859-1?Q?A/1nTlL2ODIM2pij7WNdUxsDU1lXWQqQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?l+A1m8c2KHmTPw4Szpp+dKgxM23LSZovFixDSNpXdmPhcldsUGSnA8QzDW?=
 =?iso-8859-1?Q?BHE8O1LG5PSU9qyPdjQk54+kDVr9DW2LHgdWcyb9D1cZWoUz3SpMoRrKR0?=
 =?iso-8859-1?Q?G3EIohemE2MP3E7jwkTPwO7aeEzVN0HfYRHNtbg1HQscwyGfUfSIL5uRfh?=
 =?iso-8859-1?Q?5aT1f4yHzbR8ee1doWm/Aw16nMlTNQhcfr/7nJ6cEMZRXZBvRQGqDzMEaJ?=
 =?iso-8859-1?Q?IYoGHYm55aFaKvTXWT791txWQ0hTKsWtgpK56kZYH5aId62W28kAs0GY9q?=
 =?iso-8859-1?Q?/sHS4bDxWRIhK2kLjatyA7Ije2T9lAXKBLIhkmbON9lhvhWFB7ILC2RuAr?=
 =?iso-8859-1?Q?uH1u2Nc2Xy0XtF5TtEoyV/syFENT6/j4pRyLAf7HXZQHwJfLFu5bYW2MYE?=
 =?iso-8859-1?Q?EGX9uLxO4K7T5vbbsDcIor/3B0azklSkcW+ooNVhpXgDEaE1aejg9Y1xqs?=
 =?iso-8859-1?Q?usCQ5yYWfL9aQOLUv5n7Ew1YSUJqvcRWZ6vmTFGHkBIn2Ps7wHl13f53Fu?=
 =?iso-8859-1?Q?Q5Ie769Ll4zdgB2tc32sxLTNH7KhmOi7rXo59vkQrmJBpul/QMz0ManQI2?=
 =?iso-8859-1?Q?Aew7+jTEO9U3P2wjg/FYwH2Vf0Xw1a6pwcRjHFpowp89hq/JtwDgQcYPk/?=
 =?iso-8859-1?Q?iYf8DhNMcb26oFXK6NI01rEFHLP7SeV7GJiWY2jEUgSc8iIYERe4i5h3M8?=
 =?iso-8859-1?Q?vPcQ6qyIX4hR55cghtTv3QEAPRg/ptFE8/HBUtQcRwb786a2npr7NApD2z?=
 =?iso-8859-1?Q?BeNTMUYRJuIJWwLLFzWyCsL1PHYft61h22VY3xeJIXdMDo4w2G4LgDOTRS?=
 =?iso-8859-1?Q?mo+11hiOp/JcRgxJ1yMRReTGrVE6DqZVOhHFPyNNb7+YeqrKopqfb/2o1D?=
 =?iso-8859-1?Q?RXxu6gpvPofPZYwHNGZ0lSLEeX2U5Y0qRPDdr2xacQsOfYcyO4SIgYuZcQ?=
 =?iso-8859-1?Q?jwWHC2RWlwf5zT7AZrgXOM3zDgCTK364ZiaY3E58HSjkrd+L03bYqbwVgi?=
 =?iso-8859-1?Q?pNX9PoaEhhwW0kVhWMdPKs8DO8MZn7C5mwcvxjCDM4lX7rIxiQ2S4nNWgH?=
 =?iso-8859-1?Q?K5M7IB5TurJE3gEZbqoaBUf0wLAsmJx0yY4r3aQMqBRPGH2CX6EPTYMw9n?=
 =?iso-8859-1?Q?mPlk3mRnctr8UMtUbBjWfw9g7b56dpcBz0Z73/lVOz44zBvtC+5G2Gd/T+?=
 =?iso-8859-1?Q?Td8Ibb0acRwU3lrFRZWlz5LnLigsTNDDn+yGMgUpGV8K9yIph0SW4mmNQF?=
 =?iso-8859-1?Q?+81cVS8p/fxgnC3Qprbcj8K3cbwKBlPAg8Yqr6Hv4FrtHDrS7lJWf0WgZG?=
 =?iso-8859-1?Q?stlBenpTm2ZdzGltinrJfnbsM6x+IXwgVaT1hJo7WH+9EsvoWsBdxpDseO?=
 =?iso-8859-1?Q?TkNNsTgN4ZgWAn4xOyrVJi56+AkrcJkxytNggm5RLwZa9UcM2dfbdMPTbF?=
 =?iso-8859-1?Q?g+Mc+AcaQwCEpRsDoYCtU8XdDW+v2F2rvu+2e1K4u0o6yAjlIwLFWhgYR2?=
 =?iso-8859-1?Q?ZGAZ7G8+2pcwQk4vjaN4nLBH56e0sRx+AUOJiJUmZUwbN7c5s2Fet1f0dp?=
 =?iso-8859-1?Q?zHLgvg5DmA+4WUNbAG7MfwtbtG5/ZiEuNlQ/KCID9gKzOc6YFzh/NW/AIj?=
 =?iso-8859-1?Q?msxCyGGnyksAgNxpq94U15TA2W+pqrbYv9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26906ce0-2f6e-40f7-c4b5-08dd0f71c5df
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2024 05:59:08.3494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xv9HkJYu3eOcvWXuc6jyu4IWwpYPjQ0VVvYTAnP4s5uBijblW8d+xiKk8q0TMfVQ5I3q+6SxwqHL2oF0geKc3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7415
X-OriginatorOrg: intel.com

On Fri, Nov 22, 2024 at 04:33:27PM +0200, Adrian Hunter wrote:
> On 22/11/24 07:56, Binbin Wu wrote:
> > 
> > 
> > 
> > On 11/22/2024 1:23 PM, Xiaoyao Li wrote:
> > [...]
> >>> +
> >>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
> >>> +{
> >>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
> >>> +
> >>> +    /* TDX exit handle takes care of this error case. */
> >>> +    if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
> >>> +        /* Set to avoid collision with EXIT_REASON_EXCEPTION_NMI. */
> >>
> >> It seems the check fits better in tdx_vcpu_pre_run().
> > 
> > Indeed, it's cleaner to move the check to vcpu_pre_run.
> > Then no need to set the value to vp_enter_ret, and the comments are not
> > needed.
> 
> And we can take out the same check in tdx_handle_exit()
> because it won't get there if ->vcpu_pre_run() fails.

And also check for TD_STATE_RUNNABLE in tdx_vcpu_pre_run()?

> > 
> >>
> >> And without the patch of how TDX handles Exit (i.e., how deal with vp_enter_ret), it's hard to review this comment.
> >>
> >>> +        tdx->vp_enter_ret = TDX_SW_ERROR;
> >>> +        return EXIT_FASTPATH_NONE;
> >>> +    }
> >>> +
> >>> +    trace_kvm_entry(vcpu, force_immediate_exit);
> >>> +
> >>> +    tdx_vcpu_enter_exit(vcpu);
> >>> +
> >>> +    vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> >>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
> >>> +
> >>> +    return EXIT_FASTPATH_NONE;
> >>> +}
> >>> +
> > [...]
> 

