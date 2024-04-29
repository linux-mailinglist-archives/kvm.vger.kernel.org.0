Return-Path: <kvm+bounces-16169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C828B5DB1
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 17:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C75261C21E1C
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 15:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E74839E6;
	Mon, 29 Apr 2024 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YAXTYJiH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D18B81745;
	Mon, 29 Apr 2024 15:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404400; cv=fail; b=teFGxek8tVJtY73TyjXr1x9vkcwvMAiCuBWQAcQww/z/efGY31iTXUFWHg5zsIEbOMZpR/K1WClyvWhvMpuDLVQWD+6L/YMpE5kSXuYeIJgE60P00IoFuCcjWAtFTI3Op982goGdfR8wXFvEmqzY6RfaDrpgh2Gt52hqcNeC1R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404400; c=relaxed/simple;
	bh=vRRUBRxLjA5vNECBm4IaSYvjxwueVJWwjTolm41bHk4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y2QggHf7LhbjOEE5azcpYckzmcmakcghjr7ttfHX3bTJDVgLfQMmT0bnbVcRnqTCOUkGiVTRjvxSwT1qI3i0PUVaAdN28j+b1arWORViUc4DaYJF+6bOMAY1jg3PquR2p5Bz7J59Q06nRkB+IwBVdFC3qwScyV4vy+DJqLKyxa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YAXTYJiH; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714404398; x=1745940398;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vRRUBRxLjA5vNECBm4IaSYvjxwueVJWwjTolm41bHk4=;
  b=YAXTYJiH3yMDJokwRA6D2j8oIJjBISrc6DYVs1PdDKvHnGHmVlCcSLU2
   ahmcgCRePwOG6mCgXYtDspJK/+xn9+1xrOQs/CcUKR6DURhFp6PLzOmwd
   nQTb4OBkY8N9bse5eCDm2tsb1ANd67KITbdY4ySLb8ZPuhTW7e5yB6UY1
   ACXvsgBpdgM9F0kYaszJKR9/R+eJqbgow6pLHYF6KnopL9xTofuYMYcrM
   gWUQCjHPh2WGbnlM2KIuPRlqGnhat86BizP7PPCaCu/92wXpBDewxxfpf
   sHMjQvQfLxRqvuBQ+luqTbcqD+T6lUPTv5th3MlLwGt77D8S53/FlZVFE
   A==;
X-CSE-ConnectionGUID: uNDhqX+WQf6y1hcCU1yFUQ==
X-CSE-MsgGUID: ItkuUC7wS32U/PEOR19iRQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="10190144"
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="10190144"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 08:23:59 -0700
X-CSE-ConnectionGUID: Vbg7jf1CQWKwluPaI2CqRQ==
X-CSE-MsgGUID: /rQN71kITQSXBMOjVLJ4FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,239,1708416000"; 
   d="scan'208";a="26099725"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Apr 2024 08:23:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 08:23:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Apr 2024 08:23:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 08:23:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejGZ5N/v0vdlq2D9aBYyjfP/Ij3DG6jT4Hl0L+Rj4sdnwBdhFThJGuLLcyc7QPsTtPZODXbehK0XtHa3rKm83tKkBQ1NEHr8YWlDuNBKOcAq/qqILxk5bE+kGxaMeIX9mxwQvsXlMy7cSJptdu0IVteDK8ER6TTWHyeWuev+f/GYWBiPqqL7++JQ4Z4uPkzSsjt3t/geuc7V9gSyLV/i9vO3pJ9ypxOI+s6Qx3Sy1S/6C7zB25tKkM7Mknz4ZQrJ37rKjdAGT4HXqcP1NF1m064hGxzp6yVlcREk5u3RqijSVt3LiVNRYGSPXf2etn5f8D5m+/hjDRYm/OYSeZ1CbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bf1r8DPLHif1LfoJbdE9sDT4GXSN5Ewjmrh9J6J3Vdo=;
 b=H+1Oew4BXDma1ZUkDPToB1UTLkpOiYfR+4ce8QGDqMzEIkYhHCLgTBPXgbk22pmzPhBw9jubtVkQx2nsfCUsyMtoIbvqorf+8rqdNKNOmRQyzxY9KfiwRTcB1G3R6IGQROxtT6J71b2Lugk3ahWyW1kLMBsMjGECaPV/rWsJhTQJ/uekpNxO5ypgIDA/v5OctVLfDXv/fN48fwc34FikARbt3IKmYpfF3lSqz+23Zh9Hxd7u77NFNZsD5E0DVdlNeOprpbnebQI/YBRdkqzY/mneHqXii1KXsH0l+ijgs+nF2gUMdl9cLSff3LaGOPIfRXrcVSCErTZKWdevttel6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB6888.namprd11.prod.outlook.com (2603:10b6:303:22d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 15:23:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 15:23:55 +0000
Message-ID: <a65c696b-5947-45ee-a1a8-caa50c7ccf9f@intel.com>
Date: Mon, 29 Apr 2024 08:23:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: "Chen, Zide" <zide.chen@intel.com>, <isaku.yamahata@intel.com>,
	<pbonzini@redhat.com>, <erdemaktas@google.com>, <vkuznets@redhat.com>,
	<seanjc@google.com>, <vannapurve@google.com>, <jmattson@google.com>,
	<mlevitsk@redhat.com>, <xiaoyao.li@intel.com>, <chao.gao@intel.com>,
	<rick.p.edgecombe@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <eac8c5e0431529282e7887aad0ba66506df28e9e.1714081726.git.reinette.chatre@intel.com>
 <f5a80896-e1aa-4f23-a739-5835f7430f78@intel.com>
 <12445519-efd9-42e9-a226-60cfa9d2a880@intel.com>
 <002340b7-86e2-4be3-8468-71d59233c32e@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <002340b7-86e2-4be3-8468-71d59233c32e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR06CA0033.eurprd06.prod.outlook.com
 (2603:10a6:10:100::46) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b5ef4e-e2c8-4f6c-5426-08dc6860625a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3VXZ2VSek8xQXlLSkhFdHQwQ2grczNvUVQ0UzNLMGJOWlAzOFFVQmVGRDRD?=
 =?utf-8?B?cXNXZVQ3NUxaSEE5ZUh5WXk3T3lnRG92cnUzL2pIc2ZKWUFDZUNpRVBnRzlZ?=
 =?utf-8?B?R2ZkNTRjSTZEZlpXOEdOMys4N2dod3ZSVldJVmNaNERnWlhCb1RCSUlUcHRQ?=
 =?utf-8?B?a3RLTXYzSGo2YVU0bEFjZ0RWRlc3N2dTenkrN3prY2YxOEdYcnlIRGsvUmtZ?=
 =?utf-8?B?V2sxdVRmZjd3RFc2UHZiNDljK2JrMVhnVFltUlNVeERCN0hLdkd6eXdxQjh2?=
 =?utf-8?B?Q2FOci9tbWdBZmY5OElWV2pDZ0hoSU44OGt6b3JCSVNaOVMrV0srNllPVkF0?=
 =?utf-8?B?NmUxR0duZUErU2NyVmRsWmd1Q2JxTHNOZnBLdkVzRmZRV09wY3I2RDgvNDNi?=
 =?utf-8?B?WUd0SWJkUFh5Z0FJZzNsQWtTcGlVeUZWTURnc1lvVHJxYnJ1YjMxbXVJL1dw?=
 =?utf-8?B?VklWclAyVGtod1FPTlRzOThhaDZYUjBMU0FsYUpuOTdWZzMyRjZyMWwzRVI1?=
 =?utf-8?B?TWRFRWlhTmttNnEyVEhERTQ0aGpXY0szOVE1Z2czK3FmUDJZa0ZadThuOVdM?=
 =?utf-8?B?V0lHTGJvKzVZMmZoZHp4WXphOVR0Sy9PVmhxVUFqVVUrODBETDBPeTRqNDRp?=
 =?utf-8?B?TUNMWTRGYzNzNGVab0VBcE9oZ08yYmFQZUFnd2lZRERRSUNjYnB0N3pQSGNL?=
 =?utf-8?B?KzhXc3JWeDd2U0dZN3dSak5ldTF3SVQ1MjN5OTdGVHd4aVh1V3VXeHhIaWNW?=
 =?utf-8?B?NnYrazNIMnVIcm5IdnQyaGYrYWw5WUliU3BWUWxtTlNidmtpUCtqYjFqRVhR?=
 =?utf-8?B?c0FRQnlXSGJnRHFzbzZYQjk0MVNmYmRFeGRxNG5SZ250WE9JTjRWaFU5ZkZ6?=
 =?utf-8?B?Y05ERXNmaUhsNUFkZHRnOVozaVMrLzlXTzM0V3dJbFhSNlBTcXpobHNPeUtJ?=
 =?utf-8?B?QlRSbjJnUFpJV01HTTUxUld1TWU5ZXNrdi9NOWp2Y2I1RXZtTURqZUViL05M?=
 =?utf-8?B?bGwvbTJVa1RnVlNHRzlrWHNOZVR0ODlMdk1aQWY5L2syQWRkTThSc3l1aE9V?=
 =?utf-8?B?UkdxNWkvaUlKL1pNMXJnTFdZUk1NSjMrVEdsRFRDWnZOMCtBTFMwemJHQW5V?=
 =?utf-8?B?ZHlOTXJkeG9PeFdkTWNoY0hLZDcrbUpaUUNidytUR0R0SUJoUnN3NUliUFFv?=
 =?utf-8?B?VjgyMFZUcG4xblA4ZXZRaTAxTGN4UFI2U0xWbXNlRHdkUXRNNlJzQThoVndv?=
 =?utf-8?B?MFRVQWRoK3d3akN5UzlJSHRnWHl1NkdQRFdtMkRPTmRDM3Y1Q2x5aGRMN0xa?=
 =?utf-8?B?SE5sZms1MmNQZ3ZVMTdBVGdSeUVIUGZjZ1pmTWJINW5MTGZ5TmFiV3BSUjcz?=
 =?utf-8?B?TVNFUk12NkY3SElrZzVqM1dWcU1uTFBEbXhDUnh3N0J6K0dRWW02VkxHekZK?=
 =?utf-8?B?eEhGSVgzQzI2bkFkeUM5NUkreDc4NFZ2UUJFeGJ2VnhsakJFRzZKbUdCMFov?=
 =?utf-8?B?Q0I5Q3ZvaVlhQVpFc3poQzdENVJBSmR0Vjg5by9wQnN6eUdFbXNWczh0UmhR?=
 =?utf-8?B?eWhlaUl2NUY5dVJvTENUVzRINFozcTdJYU9sNWtrYWV0QXA5WTlqbjA1dXNz?=
 =?utf-8?B?Ymp4a3NLMzc4T0lML3lmMDA1SmZPWGpkUDI4NEpEY0d5Q0k3ZURyYWVyc0V2?=
 =?utf-8?B?K2Q0SXlJais0NGNMejhybnFHbjQ3OWF3d3R0YkhZUVl2ZFNzb20xM1BDaUp3?=
 =?utf-8?Q?3KddjQ3wRYMXKseyChed3WyBMWs8DUkw81jmRQC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3o2RE0rUDdJTXNRVDg2NGRONU42RElyNER0VEtIemdKbTVzZm9UOHlXbUQy?=
 =?utf-8?B?QlViUjdBZHhTazNlOEViZzR0MjhWRjRyTmJYTkdQTmJ2YTZrRlVLNy8wTncw?=
 =?utf-8?B?QW1nODRhK0dLQWR6TSs5MmRRVDZHbEI0MEtsM3dWZ2g0eTVKWVhoTVFCRi9j?=
 =?utf-8?B?MGtjaUpvdmtXaTRKNUt2cXpGa25OV1dNVDBXcGNpNDk5L1NlM0dBRW9LZlFM?=
 =?utf-8?B?SisxNzhRNjNPU2dQOGdXM080bHllOHlNR0o4ZXlvOVBYdSszM01PYTl5bzlq?=
 =?utf-8?B?RllsMWJYVUI5QWVXd3pldThiNE92cGhJVDRwajQrdEs1dG1mNSs3Q0FMYWg5?=
 =?utf-8?B?eU5HOG9VcTMwMmlDQUxOYkhFaFhhQXdDUnU2a0hpTkpzZ1BBSnB0T1J2bkpz?=
 =?utf-8?B?Z2dxdmdBenJPNmpqMy91Nm5BU2pxNXJTZk0rM2lyUWZ1elVzZThHbWRBRVU1?=
 =?utf-8?B?Rk01UVpwbDlGUkJSLzhaWE5qa052VkUwdzdqUzNrOFlBZWlNMUJIbGk5SG1j?=
 =?utf-8?B?aHBRU1JVa1BoSXFxck5uQ2xLVFVDV2FyWTZ3Ly9zREkrSU1iMzN6bWtLYUI2?=
 =?utf-8?B?eEY0N2MreE9rbmEwL2JxdlZGamt4VmFhbEVxTGhEYW5KWmI3bUpkelpxZTRn?=
 =?utf-8?B?Qk9ULzNTSHJqT2hXNWRVQzNlZWdVSy9xMS82RGNFQ1ZCUW1wdHBGRmxsTGt3?=
 =?utf-8?B?MHJuT3dPaS95WWN2UkZnbnVGaWFOZVZkQXBuSHhaNkw5WkxOa3NCMEZnVEMr?=
 =?utf-8?B?VjZ0NEltUzhDRVBvZDB2b21oT0JneGt6Y2psc2dzQ1hIdU01QWlrTnV3Ymxs?=
 =?utf-8?B?dVBaUnhwSzM4dHl5U0dvNnpreWorSE5ITGY1TlROdks0UU1DWFc2VktCZk1E?=
 =?utf-8?B?aTd0NHB2Rlp2YzMydCtMR0lOT205aXFDU1ROSHhUUThwdGRZQzFkbEpPeGhl?=
 =?utf-8?B?b29NY1NCQzNVY3BVK2llNlIwRmhIV3hsTFZ3WWIvcWxybHkrM21VNHNKdzNW?=
 =?utf-8?B?R2plR3N4KzN3dTVqL0NXeEdXR1FjZG9MM3NXQU1pTnlJTDdOcFcyT1VBNFRG?=
 =?utf-8?B?NHQvbUw0aUUvVTVGclVlWjBJRjNuV0F4VlZFekxCQU9nOFFMU0dUbEMwNUg5?=
 =?utf-8?B?aGlSMGZqMFczWk1Vc3dLeGVvWFNUeUR1K0NwbXg3NmFUN2RyVXNuTllQemFx?=
 =?utf-8?B?Z0hVMU5rWVJJeThrQ2k1R1dOSDNSSWZSamQrV0tGL3JVUzdTVFVaUHdPZDJV?=
 =?utf-8?B?R2hvaGhEL1p1a08xMWZ5N05NOE45ZmZuMy9UYVNLVmVrbWhZZ1JOdlFINmJ6?=
 =?utf-8?B?M3JEMXYrYmtJYjJ2MjRRb3V2cUxoRjhsOGo0dStvdEw3akdjY3ZzUnJ1Tmo5?=
 =?utf-8?B?bmh4VUNyK05lU0g5eGdjL2p1dGVRL2dFK3dxMzhSSEU1L1ppRDgrUVB4eVMw?=
 =?utf-8?B?dDJVcUxtK3hSNEhHMUVNczY0RUNIckozYlVjZUlsOWtmL3R3ZHpuYytCMTE4?=
 =?utf-8?B?NGE3dktrTXJ4c0FhZ0F3cnk5ajlZUEJ1Y2RHaVRLdEZsVk5mUzl4a2FINmlh?=
 =?utf-8?B?WkQ1a1ZOOGx5dnp0a1Eva2N4SjB0Z3h1cjI1OExrMWY1eUV6bU1jNWdtY1oz?=
 =?utf-8?B?WjhXUWpIN0xmazJwK0lXNjU0L2ZZbmwxanpHejI5L1FpdC94T3FiYVc4eFZW?=
 =?utf-8?B?ZVRvVFhKNXNMSG84dHdFUmxZK0VCVlVEQWJ6N1JtaW14ZGNRMjRqL0krbjZB?=
 =?utf-8?B?SnFrcGlYQ2lwam9kVStKOE5talBtb3YzQk1rdjh0YnpUMGl2YlJMRjFvQjZS?=
 =?utf-8?B?d1EwRldBT2xDemtyTGxrRjJ4Z3pQQUFnS09jV00xQW8vcm5wTjNkTGxIMGFF?=
 =?utf-8?B?dE9VVXJxRnIxVlhaZjVRYVp6eVNDQnV3dGp2R2NZSjNHTEovMnlBcldTUytY?=
 =?utf-8?B?ZlBaa2tLcGlPeFhaTURBYVd5N1RNV0pxYk0zaDNPMTlsSFlwR0RRSFlnblN5?=
 =?utf-8?B?aFBLSHFVZEpKdGNqdjFmY0szZGZVazZQS3Iwb3NzVm9nUSs4d0t1Y09WMUdK?=
 =?utf-8?B?eFN5TUFyWUl2M0N2djFGaE1qWUk2Tk5SRnREUjc2YWxYTFJMR3FjQlo0NzVj?=
 =?utf-8?B?OThNR1U1R3JQS2NTenBVbm13bzE0emJiWWQ0S1kzK05GV1Q4OVFuVXZKYUFr?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b5ef4e-e2c8-4f6c-5426-08dc6860625a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 15:23:55.9031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EiFIVDA+HW+M4fXR443aUev/8DSq9sotcin84eozkeS2tt3ZeE8B891j9efOGiKm0lAczorPAp5kqyEOX/XrHfs7N9ryW2PbkEUKhJKe9qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6888
X-OriginatorOrg: intel.com

Hi Zide,

On 4/26/2024 10:38 PM, Chen, Zide wrote:
> On 4/26/2024 4:26 PM, Reinette Chatre wrote:
>> On 4/26/2024 4:06 PM, Chen, Zide wrote:
>>> On 4/25/2024 3:07 PM, Reinette Chatre wrote:
>>>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>>> new file mode 100644
>>>> index 000000000000..5100b28228af
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>>> @@ -0,0 +1,166 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>> +/*
>>>> + * Test configure of APIC bus frequency.
>>>> + *
>>>> + * Copyright (c) 2024 Intel Corporation
>>>> + *
>>>> + * To verify if the APIC bus frequency can be configured this test starts
>>>
>>> Nit: some typos here?
>>
>> Apologies but this is not obvious to me. Could you please help
>> by pointing out all those typos to me?
> 
> Do you think it's more readable to add a ","?
> 
> - * To verify if the APIC bus frequency can be configured this test starts
> + * To verify if the APIC bus frequency can be configured, this test starts
>   * by setting the TSC frequency in KVM, and then:

Sure. I'll do so in the next version.

Thank you.

Reinette

