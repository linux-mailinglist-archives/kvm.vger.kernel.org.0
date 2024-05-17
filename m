Return-Path: <kvm+bounces-17597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFA58C85C7
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 13:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A07DF1C21C3B
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0BA3EA68;
	Fri, 17 May 2024 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h98qVrDv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F133C068;
	Fri, 17 May 2024 11:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715946117; cv=fail; b=ga446+qoi286H7BuW2NonvldNKTQNOVVsGMYawXNPaBet+MNbMLAvLnhH1BT6CcwUaCnhGg0wtjXptI4Zi2KQ8RcHzMjFnJnDLJbySX8HtzCdWk84iU63N4Z0sQW0VrB/MdJWDPC8l46rFNaIxpWSPsLiDXIF+uV1P4BhzY0Usw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715946117; c=relaxed/simple;
	bh=nD3W68KtuzkuTKhyIHLXKUeZRFHFiOZ28G+oEh9eFek=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iP3p45C06aRzuA5f3pZIfZyTdxqzfD+VQmSs+EP7OKqVmZTo8z/sscJQ0cccuYkXnA+RAJEDc1THmRGYtNz7JQLqv+5lwqLCPuJWkWa6kk59PSgGW+yZJg+ekiS0mk8SiM9M+Tfj5GT8fsEMUXOnPET+sYGBNZlbOuhcADNagfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h98qVrDv; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715946115; x=1747482115;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nD3W68KtuzkuTKhyIHLXKUeZRFHFiOZ28G+oEh9eFek=;
  b=h98qVrDvpBHfYVXQ8ysOLNDeJ88O/yF6VEbq2G3cf2sbE4HF44Xna2Tb
   SNlthW9siuS9pVZhosFmjy7zUb+qdiv0U8X18upk4sxdAERT0P4TWe1ut
   vlm/1sQbk70KmyhFYPTNX13vlO7nlQmYZOFuMMMVLFGsDjyEQrvynIcXj
   tBzDW+kX9gaHdt1k4cByfqUVG/IDU5hFd5buEifTyyn0CdCY97NU82dzy
   KL0SYqtf/LTYJa5FWfbbbNxHgguFgcEiPg0lUNPnKsS/u+szR4nJ0m7cU
   jFLUm5RIaESSIUsst/ZDCvmkJrJbby85Rx+b46JI7fQwkfNDne33gHg03
   A==;
X-CSE-ConnectionGUID: UNuOOMSBTOek6dkkpdx9kA==
X-CSE-MsgGUID: UXGWU7MVQ7aOaBtJV9XPzA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11571696"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="11571696"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:41:54 -0700
X-CSE-ConnectionGUID: AX2HPJqwRASY9x8Wrz13QQ==
X-CSE-MsgGUID: /KkmJnwFQY645w5nQhRpqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31908013"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 04:41:54 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 04:41:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 04:41:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 04:41:53 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 04:41:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ODYL03b0KpQ7y1OhueucLoSkStK6T0ePdryyYK/+whp7fxP6MANzQjDb9B+h1mJaNb9mBKqV0/Uq12w95iAoP6y2YXJqZUJKUKsuyMcscdKsoMdVRGUAFfpPWEvF3uPJzb4ecTfBovfK9/1BG119A5omRha8Xmy52BLfYeSIqL5H+adyD5ZQSaafKb1ioVU/mz2z4rnp6YpKhaJVfXvDdDsouOdV07D29XDOKz7RU7v5RNye+jjZECzJQXxSIGF8P2CfbxGCAB3Y+TEWKcNEwQ763aC4L+ZaTUHOuv42qHAo9sm2R9oYyNvueLLpvtev8cUh8ZlSq0vMaNW9kGdZCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ej+V+BkkOIcw38NCHWFgn/eDW1ZO7+5bUkvJ/xhmidg=;
 b=POcU2OIPXYd+22819WL8XqJm2Be89O+L0GmaGE5Atvh9KrXORFWCs0yG/is1Gko2uF/HEz8/h7s1CK0spLI+AbOvz0EMPNiVn42V0AUIBstKC26z3mqyBEpQMAG1Hs6emqenoWh5+tOgcWkRoFi/eXGa3oqVy+NCCZV/0s/H/X9PqhEY54B5y/Ue5m5gXcFcjErPjOAMgPaATt6bJ3luTaGVfdVGFB2ePxoMhUATsiicswmysRLonkk4PfY9VDNuxs7TEGfXyh0Cv8MKczH11CA8QcEmKnQhHYuu1vBbGDe6L8G3feOhD0E3qdAhVFfairCiM5QWZ5Nx3qL6A6OUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by DM4PR11MB6431.namprd11.prod.outlook.com (2603:10b6:8:b8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.28; Fri, 17 May 2024 11:41:51 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 11:41:51 +0000
Message-ID: <25a042d6-e1d1-47b5-a816-f409405174ad@intel.com>
Date: Fri, 17 May 2024 04:41:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] vfio/pci: Continue to refactor
 vfio_pci_core_do_io_rw
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, "Thomas, Ramesh"
	<ramesh.thomas@intel.com>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-4-gbayer@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240425165604.899447-4-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0331.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::6) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|DM4PR11MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: a6da81c1-24b7-403c-58db-08dc766657a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aU5TZi9XUkdHeUhDdWZlRStiV1RsUjB2MmdOdmZLd0cyZTFvaVIzQnpzeFd5?=
 =?utf-8?B?VS9IV0w4ellOSEw4UlNUeng0S0J1dWREenpDMDlXRG9DSFN2THVEdmFMdklv?=
 =?utf-8?B?TzVhTThTV0l4MTIzNEZpSmpBS01iY2xVb3BHaktVQUR4My9pTCs0YVFlQllI?=
 =?utf-8?B?aEUza1VYM2JUcEFFeFdqaHVjdjZwbEFSQVg5b2p5QWl6L2hvZ1krZ3htQ0pU?=
 =?utf-8?B?eGxqUXJPWUIwUkZkU3VJcnNnNnlvN3ZRZnpOMHBXSk9CbTZYSVl4ZWdVb0NF?=
 =?utf-8?B?bzNucGZrK3NEazV6ZzIyRlQ1dEJtbnIwbGtFdGc3cEUxT2pueXcwSm1laUZB?=
 =?utf-8?B?RkY0WUVZZXdhbzIxQ2c4d29sZ20zb1VqOVJ0YnNrWm5RZFJPVDBhT0xZMWlC?=
 =?utf-8?B?Q1lpNVp0NXYvWk1vdFNjVGtjZlAySzZaZmxLaE9lLzZuU2hDWjlES3Zmby85?=
 =?utf-8?B?Z2lVV1FEZ29ab2RwRUVCVEJjTHV5TGhNbUtKdXpHNE5wQVN0Slo0bXBEOWgw?=
 =?utf-8?B?N1lEL0cxNnlidmxlREU2Sy9PWjRCREw2ZTlvK3Q4a285YTNLcE01RklNeTJ2?=
 =?utf-8?B?RHMxZzNxRlFaVmlKTXlhL2hSK2RPWldQQTJjME1HMDUyTUxaYk9oZmFuK2gy?=
 =?utf-8?B?M3VSdW9GcGxBVDNsVERZV1dvb2Q3UyttWGFGWnRrNzkwamxEenF2c2JHb2hK?=
 =?utf-8?B?VFQ3UzU1clB0dXExTzBrYWd1WkhNcXNTT1JrVHFYL01SUkI4L0Z2K1BFa1JM?=
 =?utf-8?B?dk1EOVRqWnB4YnRSOU9pZ2ZvUWJvSVB0c3FnUTJGRHRCVEY3ZDJORVJESTly?=
 =?utf-8?B?eWJsc2J4SGtjV0RNMkJIYjRnNWd3U2poOFlTZ2piR0RIOS9mZ005eUJNNVRx?=
 =?utf-8?B?NHg2RkRPbm9nMzRqcXNkdTU5NGtQY0QxQnF2L3pPQXhEZnJ2STRjZ0FnRnNG?=
 =?utf-8?B?TlRhaG9IN05IVGlaaEFoc3lQaWVJL2t6VEM5dFdvS0VIQkRsditOUGZiTnYz?=
 =?utf-8?B?L09HRnh0Rnk1RlVmclN4OWJiREQwWEt0OUpuSitvWmtpam8xeFA3cW1XVHdF?=
 =?utf-8?B?cDRDQ08vZnk4SnFjbUdXZVFDc2V5M1RaRjN6dDlDSjJhdlJjMUw0eW1aM21D?=
 =?utf-8?B?VE1UKzVsQndqc2JBc21yaURXOFZkSk0xaDhzMVltNHZJMkppOXJZcitUTFVv?=
 =?utf-8?B?Uk9JTWFJMnFUZ2xPSTNTeHBEU29pbENJNW11TXlVQ3JkOWNtRTZKeGRaNmlu?=
 =?utf-8?B?M2w4TnArcFY1SkFHY2tQQ1A4QndOM1hBOFh3QzBuYjZMdFRxclFFN0VnWG9Q?=
 =?utf-8?B?MlhGbU94akpTSXBqeUVRQi9IVXVHbXJQRkRGdnJQQVpudVMwZTFCOHhwdFlv?=
 =?utf-8?B?M1dSRjZrd0Fwak5XbTZMSUJpUENBN0xZVWRZcmhKam1QbzRiZ2xGenZZYWVD?=
 =?utf-8?B?S2x2MCs2Nlk0TzBBWCtQZzk5L0pjQU5WZ1cxaDQzNGF6TU9RWnZtMWtxNkxL?=
 =?utf-8?B?QTROMFhKRmpZZjFqdllrQ1d1UjAxZXRRNmI5a21hVVdmNGZpRkszWk5WMU1N?=
 =?utf-8?B?L29ldEpvM3ZNYStGaHdQdGEzSVMrR2VCbXVoT0cxeEhnQkFtMzU0TXdydVRH?=
 =?utf-8?B?SmI5N0hJYzl5L29EWDN0UU5nelA1RWdhR0lFR2dXSzB1RWViL3o3VStlQ1Rl?=
 =?utf-8?B?L0Z0aWdNYkRjVFNES0ZyT2xuK1FCZFBxS0VrcmhDdVVwWE9kbndHdGdBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2hNTk5kVXlGVUk3U2paQ1dQU21aVkFxK01lVkRuLzhpdmNLSXdQSEhJdXkz?=
 =?utf-8?B?ZXFJbHBRc3YrYkVFeE4wUVRhVDZzWmVvdjFvUnJ3Q0xZdU4xZzRwQWJZNVVI?=
 =?utf-8?B?NHBiTXNzNlFUZU5WbUxpN0I4aUNITHNON1FCeW9lT3JqdkR0aGgyL0duTEZB?=
 =?utf-8?B?SlVidFNKRENoUFBUKzBrSmtzcXd3QXg4Zm9pWGNxWHloVTM0dFk0VVp4OWIv?=
 =?utf-8?B?OHBINEpLaHFDR1puL3BKZHNLYnZoN3R0czV1Zm1lTWNiazFQNU9QV2lEUWpt?=
 =?utf-8?B?OHRBcGFGUmhWK1JRYTczK09ibEdOdGtpaHc3Y3NWeDRsRldQUGFlRkxEamI2?=
 =?utf-8?B?N2F3dFIreFdNTzRMajlrMEQ4ZEZMR3pnZ3U2WkYvUm1hQi9Nc1NVR2NBQUJp?=
 =?utf-8?B?YXM0cG5Wbm9EMlFKenFKbnh0WHZOUHE5NnJISmUzWkV2blR0YUN1VFpGeitM?=
 =?utf-8?B?U0J5Y0R3eDQzOGxMeFlKR1RFSjFpS1hWVlZwOHovY0JsTlBWTzFmMHNLdSt3?=
 =?utf-8?B?V01pWGNmNXMvU29tU2JUekdLWkswY0p0czRGNUVjamYrbnoxQ24xdFRhNGhS?=
 =?utf-8?B?UW9SanA1THBROFM1SElBQkdoMFVHY3Foa2ZBaFZ5Nzl6bm1FV0lvVnYwdDVn?=
 =?utf-8?B?aFJJMGVzUkxaWE94a3FkbEo2V05tcGVwbFpKSkdwaGhDRTJ6ODFqUTFBTk1E?=
 =?utf-8?B?RHFZZUxiUUt6N3BkTEhFa254T2FCVjluVHozd1haRWlKbEhCc21kRi8vQ3JU?=
 =?utf-8?B?c1h1SldwekZrNG9KN0ZML0JNeFoxRkYvWU93TGRKalZseE1MWjhmbjV0b0Q4?=
 =?utf-8?B?T0VZcWEzU0FqTFRWcWI1em15OGRRTGt3YWpYZEx2V0ZseGkwRlJVcnIwR3E0?=
 =?utf-8?B?dDRWbXQ2d3NoRjd6NGhyelBpOE5yZUxGSjNIV29uVFdKaFpURm02czFPK0d1?=
 =?utf-8?B?YU9PTEZYZUlXZnNERGF1b1hoYWlpQldWUE9SZ3dPNktDTndaQjdwRmd3QmlX?=
 =?utf-8?B?aUQ2cnMxaVBYWWFneVljbWVLM1o0QktuNDNMY3BJTGY5WDE3N0VuZEpsVisx?=
 =?utf-8?B?M051Qi8rZkM3MHNuVzVxZ29vQ3RwV3d5RU5hWmwvRUk0RUpRUXN4VXpPMEZu?=
 =?utf-8?B?RnpISkdHM2o5UWhUaUVCQUk4VzEwTzFUV0tIc25iaDJiOGNaU0xzY1R4Tmoz?=
 =?utf-8?B?R2hYZzZXbHBDa3BkWSsxWjBQQ2I1eE1DaE54c2RsbVhYZ3hNKzZsNC84S2l0?=
 =?utf-8?B?ZVovYlBKVGF3cXlTUUUvWTZ2ODJ1Zkt4UjFVUE42YzVFTHVNeHgrZEI3K2Fh?=
 =?utf-8?B?Ynd3RUd3L1hodDNraDBaRTBLK2tNSTFZblptQW4xVUpjZmYzZG1wN3JpWmk0?=
 =?utf-8?B?eHZKZFU3VUZLdncvR0ZZVWZsNUM1YlExTjRXaWVBU2JwS0hpZkFaQlduNWRm?=
 =?utf-8?B?d25DZCtBcVh1dG1tRFVNSFNSWHhNMTBFckkrOU9DYVF2N0p2M2UrdTFMR2hw?=
 =?utf-8?B?K0dEZ3phWWlIMUxsUzQ5MTNmbmNlOFdUQXFZdmxuR00yV2xDWjZheU5yZzZh?=
 =?utf-8?B?MTkwUHJNd2N2aVc5VEJzajQ1eE1pNWI5K0RUUktLK0ZNcVhoLzZzYUMrRi96?=
 =?utf-8?B?VVRNelZSaFB3bkxrM01EV2NSL1I1OCtZemJnb05IUTZTdG8zaGpZanpUeEZt?=
 =?utf-8?B?T0I4VVpqdEhJazAxQXJod2FXSXhZYkhoWUFuMzJmN0xmNUJiT1FCVW5ocXE3?=
 =?utf-8?B?bUgrWXpZQldCKzJCUTNQOEF0dERHaVlBZzFjMDg0Zjh1alVTZE96T0lnVmtt?=
 =?utf-8?B?eGM2SWloS1k0b1lrQWRLdVEzeE13Wld6Qy9kc1B2dnM3ZDJILzQvUUNhblFu?=
 =?utf-8?B?Nm93dUxxSGRtdUxjSXhqUWZFbnVOc3pxVU9vZzVJVHVrZHQyWEhqV2FINVp3?=
 =?utf-8?B?a3ZwQ3ZyMkFtYzIwdGJwYTlibzFLK2N0RlEwZzhCZ1N6OW9rK1IyRzNsd2g5?=
 =?utf-8?B?K3lKWjFRblRZajkycnA0M3NHekF2WE1tR2VYcVk3QUlpcFdGcEw0UmNXU3hk?=
 =?utf-8?B?bDE5b1drdm93MlA1ZlRXOW5IUXlSbWZWWUVzR2xCK0Q2N3d4TEpVejZqOHRn?=
 =?utf-8?Q?O/jU1k2HTZq6yZZJqdtJia4eW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a6da81c1-24b7-403c-58db-08dc766657a7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 11:41:51.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tYjypCFfkThtQmxs2uWlL7nPjMR+cA3okmYStNcETQxwu9BNPf/QIPhuukQ/oD8/c8+Dkdno79POtPf+rvRkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6431
X-OriginatorOrg: intel.com

On 4/25/2024 9:56 AM, Gerd Bayer wrote:
> Convert if-elseif-chain into switch-case.
> Separate out and generalize the code from the if-clauses so the result
> can be used in the switch statement.
> 
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_rdwr.c | 30 ++++++++++++++++++++++++------
>   1 file changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index 8ed06edaee23..634c00b03c71 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -131,6 +131,20 @@ VFIO_IORDWR(32)
>   VFIO_IORDWR(64)
>   #endif
>   
> +static int fill_size(size_t fillable, loff_t off)
> +{
> +	unsigned int fill_size;
> +#if defined(ioread64) && defined(iowrite64)
> +	for (fill_size = 8; fill_size >= 0; fill_size /= 2) {
> +#else
> +	for (fill_size = 4; fill_size >= 0; fill_size /= 2) {

0 anyway reaches default case, so loop condition can be "fill_size > 0" 
or at the start of function return 0 or -1 if fillable <= 0

> +#endif /* defined(ioread64) && defined(iowrite64) */
> +		if (fillable >= fill_size && !(off % fill_size))
> +			return fill_size;
> +	}
> +	return -1;
> +}
> +
>   /*
>    * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>    * range which is inaccessible.  The excluded range drops writes and fills
> @@ -155,34 +169,38 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   		else
>   			fillable = 0;
>   
> +		switch (fill_size(fillable, off)) {
>   #if defined(ioread64) && defined(iowrite64)
> -		if (fillable >= 8 && !(off % 8)) {
> +		case 8:
>   			ret = vfio_pci_core_iordwr64(vdev, iswrite, test_mem,
>   						     io, buf, off, &filled);
>   			if (ret)
>   				return ret;
This check and returning is common for all cases except default. Maybe 
ret can be initialized to 0 before the switch block and do the check and 
return after the switch block.

> +			break;
>   
> -		} else
>   #endif /* defined(ioread64) && defined(iowrite64) */
> -		if (fillable >= 4 && !(off % 4)) {
> +		case 4:
>   			ret = vfio_pci_core_iordwr32(vdev, iswrite, test_mem,
>   						     io, buf, off, &filled);
>   			if (ret)
>   				return ret;
> +			break;
>   
> -		} else if (fillable >= 2 && !(off % 2)) {
> +		case 2:
>   			ret = vfio_pci_core_iordwr16(vdev, iswrite, test_mem,
>   						     io, buf, off, &filled);
>   			if (ret)
>   				return ret;
> +			break;
>   
> -		} else if (fillable) {
> +		case 1:
>   			ret = vfio_pci_core_iordwr8(vdev, iswrite, test_mem,
>   						    io, buf, off, &filled);
>   			if (ret)
>   				return ret;
> +			break;
>   
> -		} else {
> +		default:
>   			/* Fill reads with -1, drop writes */
>   			filled = min(count, (size_t)(x_end - off));
>   			if (!iswrite) {


