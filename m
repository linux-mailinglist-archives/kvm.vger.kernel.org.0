Return-Path: <kvm+bounces-41792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E31A6D87F
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 11:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 933637A7608
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 10:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEC825F963;
	Mon, 24 Mar 2025 10:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E7PW/KYI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E9325E804;
	Mon, 24 Mar 2025 10:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742812831; cv=fail; b=r2xCLM6OcyyzJtUb681ZDcCs2OvNhUfrbTj+opK5m+uMIwrScYjkAfSC564jNgDprqpWgf8xkzOp168Y03cep1ryKZDF+dFqt5sNWBxsBqv1IjGsEnK2bdepo7n95nihKRJccZ30wHI6/yY2vfmdCRZbJ4FKIGuogRq13JMISgE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742812831; c=relaxed/simple;
	bh=yf3l1mVHBA0mdRc8060j7m1BKakAV43SQowvY4j6fQQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nj5iW1KZSH/KeUCDcScrYCvnek8kCOhZzdwro2SWwpmWay3S/T8P68YY7du/+vg79n9pd1p4cyCZVKOHIUFf4sHJSPUAhf4S9LKMhp/gDFOPbXIvPBRWIrIEjunYjhVluEH6zAIhBNg7qFCtl91IsaYmtPxYKgAIRwbiyyMoBbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E7PW/KYI; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742812829; x=1774348829;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yf3l1mVHBA0mdRc8060j7m1BKakAV43SQowvY4j6fQQ=;
  b=E7PW/KYIaOKtl/sfmkcVJf6Y5rpM062EXbWdzzHnuDiKFbAi2vjn5ZaS
   cGUyUaHsrHvpMkd6IfMlI+ZI+fGvIZmj44f4rW2aYQ0lbM1r7++6cSPlx
   /U+FytYqjXJ014r4x9Whwq3nOFPwU92y1jn5/YBDaGMH7d3D4toZW27EX
   i0WPsZHw2S6iLzhsLWLFLLt8cXo3gxxBHRNr1dPPDiaG+M8MvFDaPMp6p
   3E63UBZJQ3tfBGi4JrkyjqPL+SpfOAW9KnVwYHDsgif0mW4J45UrPQaNS
   12zj1rknsPRNRkYgJ9mgSZo0Abxi9KLm/x0/6vb1KAcAwTLVL7Uy2vcTM
   g==;
X-CSE-ConnectionGUID: LIupyF6cRfi9Mc0MOLqF8A==
X-CSE-MsgGUID: yB3fpBAFRE2lTT9Cw14Fhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11382"; a="54217136"
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="54217136"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 03:40:28 -0700
X-CSE-ConnectionGUID: qsGcsJjUSr2WKIj+Uj94Ag==
X-CSE-MsgGUID: apTP8jDQRZur8JtJlSDIaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,271,1736841600"; 
   d="scan'208";a="123735314"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Mar 2025 03:40:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 24 Mar 2025 03:40:26 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Mar 2025 03:40:26 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Mar 2025 03:40:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PlgcNAMXlAZ2BIEg5NbUy8e+jEv/cW2QWNpAb3hQvTAMbbpoxyMyi2uKXflaTzSsbvj/M6PpT3U8R6xib/RMPz77c4L7HSc6+JkPW3mk/6v3hOnSfL8qwqxExdtCwSPAH3R/jyhoUrGaU0XzFxEvAZoV2fhb5bdr+EBHtftcoaVr3qo7Dz0Mw1Qt6c0fdEFpNbN4sGDnELcOPdQgdzrhrCoR5v323R9A1zwOvu8qE4aPekjC8NZpq84anUXrI5yksF3+retBCKykKJEJtXdCUXGIlBw8Zxtq9fKH1QdAOSrLZS+iZ8nawK+o1HLbUx84sqcafNmIiVGz1SXrmdSzfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VTzMBSs5ja9uIHz1q3enuKdwflZgbeyvExUUSwXQPIg=;
 b=h/4cI2V4zqfDfesrjpCnFTlbJoM9lHqGqan4El/7c0Cpz0ve/x+B+e0Tss+oSMToCBTSB11bswa9rkARyqo1+ANV8NykAor/01R1anbYlbK2J1pasJKy9xkwxOsutHSu0dk+7WzH0tH3gC8S4YRNq8JNgN45wYR/bko07GBtDmhVD0jccyX+KEEw250Q0ne00zPKQOaHfHa6GyFZRD32YxTmvlJJ0uGBa0DHbTI563tH8pIWJ79936ZffA8nh9HrloICCg2csgm9YheHS33tQBqwTy5kh07vsu3mQyL+QNpWjNd72pKkQ1TCtD7kAOc/ZtYmfuXe5mXmC04vk3M6Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by SJ0PR11MB4896.namprd11.prod.outlook.com (2603:10b6:a03:2dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 10:40:24 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8534.040; Mon, 24 Mar 2025
 10:40:24 +0000
Message-ID: <c625a52c-f251-4540-8e8c-6cc61df8cd84@intel.com>
Date: Mon, 24 Mar 2025 12:40:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] KVM: TDX: Defer guest memory removal to decrease
 shutdown time
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>, David Hildenbrand
	<david@redhat.com>, <michael.roth@amd.com>, <ackerleytng@google.com>,
	<tabba@google.com>
References: <20250313181629.17764-1-adrian.hunter@intel.com>
 <CAGtprH_ag0RXU4pJKCkcmyjwxRj1pVJN0rm91XTvYnCmDxjKTQ@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH_ag0RXU4pJKCkcmyjwxRj1pVJN0rm91XTvYnCmDxjKTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR09CA0129.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::13) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|SJ0PR11MB4896:EE_
X-MS-Office365-Filtering-Correlation-Id: ff1ca06e-757f-4e2f-4461-08dd6ac04878
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWtlOWd6MlpmeUxsVmdLNmlkZWxnK3k4VVdKRGN5Ky90dkNvZncyRXpxRjAx?=
 =?utf-8?B?VDdETmptNEwzNTdMNy90dEs3UTlZakZFSWQ1ZEE1dE9uQWRnK2UvQ1FqUktH?=
 =?utf-8?B?Z3hTSGd1UW9iYVVDbDJUSTZKd25rYU94Zk1TTGpxQklwK3VMSzhDSUJ3WTJv?=
 =?utf-8?B?ZUJPMVlVSFI0OWtrb3lya05EOUUva1dGNGxhSklJTDBZOUtqZ2ticjExaE1h?=
 =?utf-8?B?SHpLSEhmVHd0Vml2ZTdvb1Ewem5YZ3FJbzZVMXRVekZGK0s2N2J0bzVZaG1M?=
 =?utf-8?B?SFAxbUxBOEVETHd1UzgxdTRsQ0xHVFYxNWc5aXU2dEJFNjJaTXVrWWhUUDdl?=
 =?utf-8?B?VFhFQWx4d3loQ0l5Q283dXF4Q3d3cHJjU1dHWFBkd2VQTnYxdTdWVlJLZmJF?=
 =?utf-8?B?UnJvUG5YWGsvQXl6cTl5Y2RxQWRLZ1hoYm8rVDlkWWV4L2F5Qkg5dXYxaTNF?=
 =?utf-8?B?WThxblcrV2JxVytDc1I1VWpGTG5sUGpuSUxtb2R0RmRvNzRjc3V5TGtpMnVz?=
 =?utf-8?B?a2pLSFJRK1Nuc3ZEYlo1R3JSZUE1Y0FWc0Iyb1MwZ250QU9TT3BPbWF3SFJJ?=
 =?utf-8?B?TktXZHJWQ0lFRE9HWmlpRENmKzhvWXkrbUhFNnlZTXFVVkFUSTVncEI5bnBa?=
 =?utf-8?B?eXBKVVd3cFdhV2tVN0t4QmU1RW5ibm9QUDVTeU84L2tvVXllTVAwSG9MRGd4?=
 =?utf-8?B?MHZsZlFOcTJQbUpFREpWcE1ZSDJCVVl4SGMvb0JzanY5dmN3WFlycXJyWWZ5?=
 =?utf-8?B?YTFQUy9JelVnNG5FcExqUmdtc3lZWkJpTFNkZm1RMkxkUWx4b2duSVFkM2Mw?=
 =?utf-8?B?NXV2ZEFwUnkzTXkxZUxtOVlPNkllUStNQmlzam5sd2ZDdHhzT0l4bDkra2V5?=
 =?utf-8?B?QXBObWNkeEI1K05NaTFYOEVlTjhDVTVHK0NmckozWmp6c0U3NmgzaWJlSmdZ?=
 =?utf-8?B?Zlpnd2hIRWsybVA4Qk5JQkJQV0kzbitFMHpqMU9GN2FSS0p3VWx6aWtBdHRX?=
 =?utf-8?B?ZlFRRnM1RU9EMVduNXdpNmJ1a0lONGViSElWZTkwNEFXVm1DWFg1eU9OMkxE?=
 =?utf-8?B?bHZTRWVYVytiQjhXRXo1WkEzTjQ2b1p1SUhVUVRnOXhSRms2SnQ5c204VzBu?=
 =?utf-8?B?TVJ6STR0S3c5Qk1vN3ZhQkRrdXFJMEVMT24yNTAxN3VjTzFvY1VVdVpaOERL?=
 =?utf-8?B?eERBVXVxako5MlZnZFhFQWpQd3lFRmdpNThMbGRyc1ZtL2NoK2wyTFd5VytU?=
 =?utf-8?B?VW5MZy96WUpJaU9SWnA4WDR5YTIzRnpqQ2xScmw3Vmt1SVYxdUpBc2cwZDBZ?=
 =?utf-8?B?UWM5TEl1NEtCcHBNdlhOV1VTa0toZ1FOU1IrVFZnSmxWVFZxYWdpeWp0Mjgv?=
 =?utf-8?B?QUlmZVg3NS9VM2RvTmNaeGVTS0xKRi9FR3dsYjRjWFN2VE1DVGZUaVNRenVJ?=
 =?utf-8?B?bkNReFdDTGE3bFdKMW11L3RobkNlK0Z1dFBzLzd5VGhWdUR0SEtPdXlDNFdB?=
 =?utf-8?B?dHBtTXdmNjI4Wjg1MFc1SGlvM2c3SHJYTWpIQ21yOFlHdndSeHlndTBoL1VS?=
 =?utf-8?B?a1d3WGowZ0E5dStDVE1nMGlmYWpwVkdsdzBUWHpuMVFGSzA0VEdkeVMyeXZq?=
 =?utf-8?B?dGxvYXNBc3R5WVI4ZnFnc2pyYmtHczFzazZxT1dDQWdqK0dqQ00ydUhSaDA4?=
 =?utf-8?B?MXBCOFFzUHZ3OGJZY2hHTUNLSndEclBnZzUvWSthbXZGeFJDOFBQUjI1Rm95?=
 =?utf-8?B?b2NYalNMdHBXcWtlVlEwVS96V1R2N21xdnJyQUpubDZxTkJwOUxEQzVuYy9I?=
 =?utf-8?B?Y3NRYW04Rm91WjV4bVhXRDVDOHprZjNNUlhGSkpuT0xsL1NqenBtckRmRzM2?=
 =?utf-8?B?WFN3ZGVHMzNTMlE5SDc0NXdHdlVvZm5FWElvQUh2SE8vMmc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3I1MENtY0ZVeXhMbS9zOGIrR3Evc1dJSmN3b1p3ckJKMStESHVidUM5THVG?=
 =?utf-8?B?RUlrRUljZW1vLy85a2lsVElSbkVValhiUEFSN2NLNk9nMWlkcEVLQ2VPVWJl?=
 =?utf-8?B?SWtCaHVWTEY2NW5HSU5Fc0pJYThFL0hsSmFJaTNXNXNneCsxRmVXWVVSUys3?=
 =?utf-8?B?dW1uajcxODVpdmVPbXJCZFBrTGpmNGt4SjJWc2NRYTltMFBUc2locHRQd2tE?=
 =?utf-8?B?MEpnTC9NendsSHZ3ejBZMmxDcVA0WmVxeGJaZSs5TU9XaisxanpsRCsyQ1Nq?=
 =?utf-8?B?L3VuQ3hleEtVK3VrTVVmd1JmcDJLZThHeC93b2x2QXRJR01neUZyZHF0ZmQy?=
 =?utf-8?B?WWRqYi9BMmpXdHliQm9EN3lNdkt4clFKYzd6a0NxdzhpR2dpUnY0V25WMzNh?=
 =?utf-8?B?RDJIU0dsU0RuZE43TkRnekt1VjJVNGtJeWN0N0lKQlFLeVhGdHFrZlBLR1Zw?=
 =?utf-8?B?bTBKU3lncTV0a3VkbzVPVUs2Y0VobElmc0pNSFpwQ1ErREJDRmIxT0J2VVEv?=
 =?utf-8?B?YW5nc3JCdzJwMzVONExPb2hMbGhnZ1UrdWQxNTNmR2xtOC94T1E1NkdkUGw1?=
 =?utf-8?B?ZlFlOWpUVjJwQVdRZ3Y0UGhzanM3RktvSm5ZM2Z4SzJqbEwzcHdzQ1hrT29y?=
 =?utf-8?B?K3BNaTZLSk03Vk85REZ5TlFBMHhYaDdSKzNwRVZrSVUwR2lDUW5yTFUvV2Jt?=
 =?utf-8?B?VE1qa1ZsakNKb0xkVlF5REMySU1hcklndGw0R1hLL3ZQbHBIU01ENHVRbW1R?=
 =?utf-8?B?bzBjc3R1Rk5VT2NoVmNQYytvTDBqWlZSeGRRSHd3c00va2hDcHhESE1vMW02?=
 =?utf-8?B?N0EwZ0JpRnJyZUNyaHZVcWwwN1ZaRjhUQTNuQkpEb1p5VGNSaTJ5Y2RUdUNx?=
 =?utf-8?B?dTQ5VFJub2NUM1QvbzNFaTVBYTBkdVlIMmdEUWtPejdGQmdQYTd6dzlZYzBL?=
 =?utf-8?B?ZUZQV3R2Wk1DTFdFTnhwTFI0VjI4VTZBV0JBQnRXQU55ZXcvb3hvL1FyelFD?=
 =?utf-8?B?V3VUYUx6aVNiemk0NHY4RklyNVoxTHpiTFlNSnQweWRIclI0dWJYUkVXeTM0?=
 =?utf-8?B?MjdRaDNFS3phaTFma3BaczBBOXUvZmkzY0ZOTE01K0o3d1ZIQjlJN3Myd2FB?=
 =?utf-8?B?VVNQYTZqajl2N3pzWFF6RUlGZmlyRnM1ZDlUZis3d01Rd1hraGpFU0lwRmxn?=
 =?utf-8?B?NkRWMVpqN2tQWmpJWWFLMFhOMzZsU3V0b2UrTGJFWlVxZGJDN3k3TzU5dVB0?=
 =?utf-8?B?bEZTR01EZlJ1N2JuQ1ptcXZwZDd2UzlCOXIzUE5IMTVNV3BMeHZSRTBZNE5E?=
 =?utf-8?B?OFBiMDJsQlZXcjVzRVlDQnlUek41bnZYalF0N0ZrSFUvT2IrOElxTndmWWVl?=
 =?utf-8?B?Kzk2ZTZKZEdRQld0TS9NYmR4cVdnNDBNQURNcS9qTmFTWlNEbThlQkRJSFpM?=
 =?utf-8?B?ZVlIRFhWNUhBS29pY1RBNDZYVFRCKzVMRzJISDlkV2lWTXNlekhtb0xJZHlu?=
 =?utf-8?B?VVVxVW45TXJBanRJVUJsd01FeUZiMVhVVlRHUjJ6OU5QdjZ6N1ZwWnBtWHEw?=
 =?utf-8?B?WUJ2UGxaenVNcll6UGdUNU5WYXFVM0UyblJGSG9zSTlpV0lxbE83c0tnUFVI?=
 =?utf-8?B?RnhDMlR1c2NRblMzMGhWc3d0ZzJ5TDQrT2lJWm9TS09WMEtFaWF1aml3bEFj?=
 =?utf-8?B?c3ozYTIzcm9pYUtlT0cySmNWeS9jM2hmcklxTnZtV29ZdnNiU2NSeCtIZUo1?=
 =?utf-8?B?Z1F5dVFJc1ZhZ2Z6M2E1Z1VNSDEyaEE3UDhEb1cwOE5DcFEvUXBVc3l3eVpS?=
 =?utf-8?B?WS9VMG1UNGdKQkh0akhuVTBEOGlNZUVIb3o4dXJKYlJEYjN4UFl2aER6S01T?=
 =?utf-8?B?d3VhT0lvbVlqN2xXMXFyYkV3TWl1WWV5aDk4SjhUK25ZeGUzRVBPWHZKaHI4?=
 =?utf-8?B?VTFOVVFsVDkxSTkvR0gvNERqVWxSSnNRRWFUWkxqUW1Za2hwOGtHWmtzTk94?=
 =?utf-8?B?ajVLeWRpWURXSWp1VGZ3SEgzUy8rMUVGU2NTVEplOUVuaG9udk0yaWREUjNZ?=
 =?utf-8?B?dEtFVlpabEM3dUpic09QTldtaTVGTW5DM1pKQ0lLcTF1Y0Y0ak1oelBuUUZZ?=
 =?utf-8?B?LzJOWnIzMjNUdVgyQWw3YVhnRTB2QzAzSmpiNjN2NDdPRnRDYUczck82VEtw?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1ca06e-757f-4e2f-4461-08dd6ac04878
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 10:40:24.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: als9ew+zcTOsGp+e6AqMfK+ovhjm+v1/BOSUhDQT2qiMnSmEvt7z8QCc5TGBUNbyBRC4y3fBRMd0dwKhmTRp/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4896
X-OriginatorOrg: intel.com

On 20/03/25 02:42, Vishal Annapurve wrote:
> On Thu, Mar 13, 2025 at 11:17 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> Improve TDX shutdown performance by adding a more efficient shutdown
>> operation at the cost of adding separate branches for the TDX MMU
>> operations for normal runtime and shutdown.  This more efficient method was
>> previously used in earlier versions of the TDX patches, but was removed to
>> simplify the initial upstreaming.  This is an RFC, and still needs a proper
>> upstream commit log. It is intended to be an eventual follow up to base
>> support.
>>
>> == Background ==
>>
>> TDX has 2 methods for the host to reclaim guest private memory, depending
>> on whether the TD (TDX VM) is in a runnable state or not.  These are
>> called, respectively:
>>   1. Dynamic Page Removal
>>   2. Reclaiming TD Pages in TD_TEARDOWN State
>>
>> Dynamic Page Removal is much slower.  Reclaiming a 4K page in TD_TEARDOWN
>> state can be 5 times faster, although that is just one part of TD shutdown.
>>
>> == Relevant TDX Architecture ==
>>
>> Dynamic Page Removal is slow because it has to potentially deal with a
>> running TD, and so involves a number of steps:
>>         Block further address translation
>>         Exit each VCPU
>>         Clear Secure EPT entry
>>         Flush/write-back/invalidate relevant caches
>>
>> Reclaiming TD Pages in TD_TEARDOWN State is fast because the shutdown
>> procedure (refer tdx_mmu_release_hkid()) has already performed the relevant
>> flushing.  For details, see TDX Module Base Spec October 2024 sections:
>>
>>         7.5.   TD Teardown Sequence
>>         5.6.3. TD Keys Reclamation, TLB and Cache Flush
>>
>> Essentially all that remains then is to take each page away from the
>> TDX Module and return it to the kernel.
>>
>> == Problem ==
>>
>> Currently, Dynamic Page Removal is being used when the TD is being
>> shutdown for the sake of having simpler initial code.
>>
>> This happens when guest_memfds are closed, refer kvm_gmem_release().
>> guest_memfds hold a reference to struct kvm, so that VM destruction cannot
>> happen until after they are released, refer kvm_gmem_release().
>>
>> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
>> reclaim time.  For example:
>>
>>         VCPUs   Size (GB)       Before (secs)   After (secs)
>>          4       18              72              24
>>         32      107             517             134
>>
>> Note, the V19 patch set:
>>
>>         https://lore.kernel.org/all/cover.1708933498.git.isaku.yamahata@intel.com/
>>
>> did not have this issue because the HKID was released early, something that
>> Sean effectively NAK'ed:
>>
>>         "No, the right answer is to not release the HKID until the VM is
>>         destroyed."
>>
>>         https://lore.kernel.org/all/ZN+1QHGa6ltpQxZn@google.com/
>>
>> That was taken on board in the "TDX MMU Part 2" patch set.  Refer
>> "Moving of tdx_mmu_release_hkid()" in:
>>
>>         https://lore.kernel.org/kvm/20240904030751.117579-1-rick.p.edgecombe@intel.com/
>>
>> == Options ==
>>
>>   1. Start TD teardown earlier so that when pages are removed,
>>   they can be reclaimed faster.
>>   2. Defer page removal until after TD teardown has started.
>>   3. A combination of 1 and 2.
>>
>> Option 1 is problematic because it means putting the TD into a non-runnable
>> state while it is potentially still active. Also, as mentioned above, Sean
>> effectively NAK'ed it.
>>
>> Option 2 is possible because the lifetime of guest memory pages is separate
>> from guest_memfd (struct kvm_gmem) lifetime.
>>
>> A reference is taken to pages when they are faulted in, refer
>> kvm_gmem_get_pfn().  That reference is not released until the pages are
>> removed from the mirror SEPT, refer tdx_unpin().
> 
> Note that this logic to pin guest memory pages should go away to
> support in-place conversion for huge pages [1], though you can still
> pin inodes IIUC.
> 
> [1] https://lore.kernel.org/all/CAGtprH8akKUF=8+RkX_QMjp35C0bU1zxGi4v1Zm5AWCw=8V8AQ@mail.gmail.com/

Then the virt code should handle the pinning since it becomes
essential.

inode->i_mapping->i_private_list can be used because we only need to
pin inodes that have no gmem references.  Although it is using it as
a list entry and elsewhere it is used as a list head.

So perhaps like this:

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 0d445a317f61..90e7354d6f40 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -96,6 +96,7 @@ config KVM_INTEL
 	depends on KVM && IA32_FEAT_CTL
 	select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
 	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
+	select HAVE_KVM_GMEM_DEFER_REMOVAL if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1f354b3dbc28..acb022291aec 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 #include <asm/fpu/xcr.h>
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
+#include <linux/fs.h>
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "mmu.h"
@@ -626,6 +627,7 @@ int tdx_vm_init(struct kvm *kvm)
 	kvm->arch.has_protected_state = true;
 	kvm->arch.has_private_mem = true;
 	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_IGNORE_GUEST_PAT;
+	kvm->gmem_defer_removal = true;
 
 	/*
 	 * Because guest TD is protected, VMM can't parse the instruction in TD.
@@ -1839,19 +1841,28 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt));
 }
 
+static int tdx_sept_teardown_private_spte(struct kvm *kvm, enum pg_level level, struct page *page)
+{
+	int ret;
+
+	if (level != PG_LEVEL_4K)
+		return -EINVAL;
+
+	ret = tdx_reclaim_page(page);
+	if (!ret)
+		tdx_unpin(kvm, page);
+
+	return ret;
+}
+
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn)
 {
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
-	/*
-	 * HKID is released after all private pages have been removed, and set
-	 * before any might be populated. Warn if zapping is attempted when
-	 * there can't be anything populated in the private EPT.
-	 */
-	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return -EINVAL;
+	if (!is_hkid_assigned(to_kvm_tdx(kvm)))
+		return tdx_sept_teardown_private_spte(kvm, level, pfn_to_page(pfn));
 
 	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
 	if (ret <= 0)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ed1968f6f841..2630b88b0983 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -860,6 +860,10 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_locks (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
+#endif
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+	struct list_head gmem_pinned_inodes;
+	bool gmem_defer_removal;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 54e959e7d68f..f56a7e89116d 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
 config HAVE_KVM_ARCH_GMEM_INVALIDATE
        bool
        depends on KVM_PRIVATE_MEM
+
+config HAVE_KVM_GMEM_DEFER_REMOVAL
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b2aa6bf24d3a..a673da75a499 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -248,6 +248,36 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
 	return ret;
 }
 
+static bool kvm_gmem_defer_removal(struct kvm *kvm, struct kvm_gmem *gmem,
+				   struct inode *inode)
+{
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+	if (kvm->gmem_defer_removal) {
+		list_del(&gmem->entry);
+		if (list_empty(&inode->i_mapping->i_private_list)) {
+			list_add_tail(&inode->i_mapping->i_private_list,
+				      &kvm->gmem_pinned_inodes);
+			ihold(inode);
+		}
+		return true;
+	}
+#endif
+	return false;
+}
+
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+void kvm_gmem_unpin_inodes(struct kvm *kvm)
+{
+	struct address_space *mapping, *n;
+
+	list_for_each_entry_safe(mapping, n, &kvm->gmem_pinned_inodes,
+				 i_private_list) {
+		list_del_init(&mapping->i_private_list);
+		iput(mapping->host);
+	}
+}
+#endif
+
 static int kvm_gmem_release(struct inode *inode, struct file *file)
 {
 	struct kvm_gmem *gmem = file->private_data;
@@ -275,15 +305,18 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	xa_for_each(&gmem->bindings, index, slot)
 		WRITE_ONCE(slot->gmem.file, NULL);
 
-	/*
-	 * All in-flight operations are gone and new bindings can be created.
-	 * Zap all SPTEs pointed at by this file.  Do not free the backing
-	 * memory, as its lifetime is associated with the inode, not the file.
-	 */
-	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
-	kvm_gmem_invalidate_end(gmem, 0, -1ul);
+	if (!kvm_gmem_defer_removal(kvm, gmem, inode)) {
+		/*
+		 * All in-flight operations are gone and new bindings can be
+		 * created.  Zap all SPTEs pointed at by this file.  Do not free
+		 * the backing memory, as its lifetime is associated with the
+		 * inode, not the file.
+		 */
+		kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+		kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
-	list_del(&gmem->entry);
+		list_del(&gmem->entry);
+	}
 
 	filemap_invalidate_unlock(inode->i_mapping);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 08f237bf4107..5c15828b86fb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1195,6 +1195,10 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	preempt_notifier_inc();
 	kvm_init_pm_notifier(kvm);
 
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+	INIT_LIST_HEAD(&kvm->gmem_pinned_inodes);
+#endif
+
 	return kvm;
 
 out_err_no_debugfs:
@@ -1299,6 +1303,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	cleanup_srcu_struct(&kvm->srcu);
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	xa_destroy(&kvm->mem_attr_array);
+#endif
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+	kvm_gmem_unpin_inodes(kvm);
 #endif
 	kvm_arch_free_vm(kvm);
 	preempt_notifier_dec();
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index acef3f5c582a..59562a355488 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -73,6 +73,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 		  unsigned int fd, loff_t offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
+#ifdef CONFIG_HAVE_KVM_GMEM_DEFER_REMOVAL
+void kvm_gmem_unpin_inodes(struct kvm *kvm);
+#endif // HAVE_KVM_GMEM_DEFER_REMOVAL
 #else
 static inline void kvm_gmem_init(struct module *module)
 {



