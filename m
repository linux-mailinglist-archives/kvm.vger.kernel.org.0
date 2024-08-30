Return-Path: <kvm+bounces-25560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E8E966965
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 21:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 684991F24987
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747C11BC07D;
	Fri, 30 Aug 2024 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNDmM9Lz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276D213B297;
	Fri, 30 Aug 2024 19:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725045396; cv=fail; b=CsQ/GdWd8WvA7y5MfOKTqDbHnmxypeORr2WAZZsmtDk2dMLzPJv8OblC+BShCxLvHH0e4LXCSobd7dg+0rf4XaN3lAdXI5nzXtxIrodhhePtfbPuQgVQMe/xVm0g2aS+5v3iTz19+k//FslqwHKilKD1zwo7v5P1hXUk2b0Nt4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725045396; c=relaxed/simple;
	bh=f1LYPvyqD8hWMdJIURz5AHtFhxf9Vl50T02J7EmZl9E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eTYDcv2YQEFrjROxFsNGqnrB9ZXtd/G7UqTXektmL7YyIFamMe6yK1O1YVIz7sJB/gNOIbgpT4zzbpj0WB6zJcvsyVZr9nVsA1qbmWLxIPP/RtD4FTBWBhOpaOoJdHsqF0juPM9OxkRGSShpCSoKvu4p2BqPmwBVcePO/5GB/8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNDmM9Lz; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725045396; x=1756581396;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f1LYPvyqD8hWMdJIURz5AHtFhxf9Vl50T02J7EmZl9E=;
  b=kNDmM9LzLRL7+xjL6L5Q0NQsqJqu1fL0WFG3L4i8MuWkqpbsQfYc35qk
   ysg2CMkuz8wkq1lKP4TjelUesPqI3pv5xcCC68jfmOmooM1brMd69CPec
   b6TBKYY44dZXZ1gCW4+6pozSApRUSiMdSUN/OnTdqt/s0ywGOgbSZWAY/
   ULhcLMFm1clkt27M9LaAkU2PjuX/f3lLMau0dD1LZCAGeHK9p+kw+A7BO
   7McmfSnvjXfWMmy0WCUZXkYuFa2S73UqBHiv10gCVVzxIm56agKTAwyor
   RYmAsdiW0IwjAUs727h8OhJOj+rFeqZGSC8mMAnrs9WmaCTJfRDIpWU8s
   w==;
X-CSE-ConnectionGUID: 1cZnPIZ3R0+GimnXSFkJQQ==
X-CSE-MsgGUID: 2hrCqLYKQ8a5pfZ/SDxuvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11180"; a="23564827"
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="23564827"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 12:16:34 -0700
X-CSE-ConnectionGUID: RDPzT3vqRSCQG1HMxrM+Ng==
X-CSE-MsgGUID: bo+pcY+MQISYui6G66m4zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,189,1719903600"; 
   d="scan'208";a="68128746"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 12:16:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 12:16:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 12:16:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 12:16:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 12:16:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zF7k29YIpMhSaMB/oW3HpX397VhjGxmcqYxAwh6y5s05U6gD0tJL3FIjbOZmWz5ivwo1xCddhonTznH4yXCZw+jq2bngL9FdMB1jCqN9HhAJsVFPoaP+Up81E8WICUeRjOfz0qb4U2qTksn9UHqP50MBDVSrAkhXpuIGYttY++VMRCTf6WGBzazDUCddotBv559mIX9oWndonk3EbffNVDmnVZzKYh8vKhM3IPcLXWJoYb7IEF0JHUcOkVplgrqdFL40Fx/PyI11OKbQZ6xQrdIYfqFY8PspxfsbwuKnQClU7HDb3GUd8x7EU4Roa0uo7Pn9Byz1TP8QuEaZe/gnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1LYPvyqD8hWMdJIURz5AHtFhxf9Vl50T02J7EmZl9E=;
 b=moT3Bd3AESR54mXILX6pPiqkZU95j5eqgoJ22uGmxw+2tOcPtvV8Sn01m25CwoZax1V9Aa88w2K2VxPcuQuWBusizhlY87q8LLKDn68r4RAR/Wwe8RwM/c4wGnVBbf+YXL0TYFztoSlRN7wz2uvytLh5qB97LBu5+WWPIgETkzEOpobDEdpvKTADS0WXhjhol01DtldL45Gjz7ZpqCjjdSzonst9VisvmvBt+AzblYHLHQ/qqE5L4Rni6vXKh1wk+OJ4PvSeO9ukKcQHgUdH0s4jRNtUNde1dgHuu0rH1y4HEylwlCX1arayBHm7pzWgkR+NczNURaq/a9cCm5RnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 19:16:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 19:16:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/25] x86/virt/tdx: Export TDX KeyID information
Thread-Topic: [PATCH 06/25] x86/virt/tdx: Export TDX KeyID information
Thread-Index: AQHa7QnLi9HqQ6XdR0CyzoXxbqL5lbJAP5qAgAAIjYA=
Date: Fri, 30 Aug 2024 19:16:29 +0000
Message-ID: <43af672ad0dbdeefaa45f72fa7a4ae68bc5d0fb6.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-7-rick.p.edgecombe@intel.com>
	 <614ab01d-eb99-48b8-8517-7438ca6cfef2@intel.com>
In-Reply-To: <614ab01d-eb99-48b8-8517-7438ca6cfef2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8035:EE_
x-ms-office365-filtering-correlation-id: dbbc456f-3468-4cd3-45a2-08dcc9284072
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Znplb3JpbHpBc28xcHhvRUVWcjRtSm9yM083Y2JVVEZ2cW9uZExMN1RENEJL?=
 =?utf-8?B?enZxaHNLRk1ablFZa3RhVlROK3lHakxqT3l2bGtyRUd3bk5scEFQMmFMbDd0?=
 =?utf-8?B?dUIrTTNwT0Zta3ZRbDhzeFpjdDFBYlFXdDdJQUlXdGtUS291T0Y4OVZaTkpt?=
 =?utf-8?B?VXRXUW5GaUxtVGhnbFJldWcva3hKY3lKbWFkT3dSUjFmN3RqTlorZGh5b01S?=
 =?utf-8?B?N0R6b1hQRVBzYm9yWndXRk84ejR2dXNkQUNPa1VsTThHQVRnbU1IaElQUGVX?=
 =?utf-8?B?Ujh0UU5FT1R5RjBDZnI0VGh5NG8zK1UyRDFPOTFWS2xTZmtwUmdhY1JTZEVo?=
 =?utf-8?B?eTBIVkdWQjAyRjh6ajB3MGEzL29tMWNFTGsvLzNFc1hjYkhEV2d2SVE4UTN3?=
 =?utf-8?B?ZnplTWxsUGNDUW1VSGo0YnlwLzFDYVAxY3A1RmhCSmMxbmZYQVkwN0lmajNE?=
 =?utf-8?B?bEd5eUJxS0FzUTF1M2d0bm5YVjFDaFV1blhhdkdOR09GeVB3N0UwbnRJaDhG?=
 =?utf-8?B?SG51VXQ0N1FKdTRKSzNzZkFXWkJOYWgrcVcxVG1EaXNzcC9TRmJIcncyZlJW?=
 =?utf-8?B?cmw4UWJZVlI3MXVla05LQjhPQVhla1h2Q3JyZkk4bDB0TmxFY201QmJUbk1D?=
 =?utf-8?B?TXNORUxSR2xYaW1LZmgxblNDNnJsQjNOOWpDRUQxTW8xR0FPdWxhRTRKZk5y?=
 =?utf-8?B?Z3JBNTR3YnFVMU5BWGo1blV5a2JtQTJhNEVQakhmOFlpU2VjTkZ0MFpMM0sx?=
 =?utf-8?B?SFpicEduT2JFNWR2Nm5oRG5xU0FLYXdKQkxJeURoekZ5akxISHdFSCsrRGN6?=
 =?utf-8?B?MTNFalM4L2tjMEdHaFlsZFJacy9NM2xvOFJyTlFpbzhXUm5PT0d6Smx4VHdX?=
 =?utf-8?B?MW5zVUtmMUl4RDllNG5aNUpCTlNGSldqZkUvaWUvN3pmVERnd1JzcFh2WVJ3?=
 =?utf-8?B?eFFMMmEvY0ZsTVVvcUU2UENETUh4alM0enhUQ1pBZVhDYXpyc3I3cHhsaFpn?=
 =?utf-8?B?UlZDR1YzZjFWMnRNVFkxWjE0TUYyM3VoUE11MXJCN0JoMnJ3SjRlT2c5RWdl?=
 =?utf-8?B?YUJ4RmkyV2Frb2ZSTC96Wi9MdjVYQTJJYWxPYnBCLzk2cGk2RjQvVFh1aHVG?=
 =?utf-8?B?TE9vL084eGtRL3JpbkZyaCtNY1o0RkJtOE5POG95aXE2T1pqeXBxb2lBL1kx?=
 =?utf-8?B?Z1NNVFhEbWZkZngraWwvVEFoRFkxNHI2U1RRN3BocWo3U1FSbnVFdk1QU1A1?=
 =?utf-8?B?THpOVEtSaGNzcUZkYXpUbTd6MmNFdUs2OWYzdnhnbld2ZnlqZGpQS01RRk5q?=
 =?utf-8?B?S0RiazdURVhWckUwS3JSOHRjaDY2cHFYcFV0Wk55cEhQdFl5blVyQ1R2RC9Y?=
 =?utf-8?B?TUwzYTI1SlBUNmkxK1ZWKzlmK0J6MjZxY05uQkQ3ZU5IVi9Da00xWGVRREFF?=
 =?utf-8?B?WDVGRFVRcnpaRTNCZE9KRUc4TWhDL05XWFR1V3ErOVlnUnZaT1djY0M3V2Rp?=
 =?utf-8?B?Y29rR1hRajhHVDJXb2srVkE2Mms3TWUzQ0dzN3A1Qk4ydzhTRjVsK1oyYzVM?=
 =?utf-8?B?Nm5iYUNIWGlQejdEc2ppN1REKzFQblVqYndyRU9oczJRU2pSN1l0cXJCVVg1?=
 =?utf-8?B?aW1qVUJ5MlBaNVl0OWJSQmpHemhzeC9RbTE4L2IvVmNFcC9jR25uaEtQNmE2?=
 =?utf-8?B?anFOVXNNaUtFRHkzS0hyZ3h6Q0VNdFBnSXNmdDd2YjBVU3FqbkRvZURzaVgv?=
 =?utf-8?B?NWJHMno0TlBPZ2pMNjQwVVFGV3dHblAyMjdtSnh5UnRTd3RKRnZvamNUVzI2?=
 =?utf-8?B?bktsUHNjbzAxWEZPRExwYzBPU2JUZVFjMVRqc3hselRsTXdjVHJVdTZLMDlh?=
 =?utf-8?B?RCtwOVFwRlpqVXN2TDdUMEZSWW4yaXc1VVFPRlFlWjdZUlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NlNCTDBJTWZhdTRGRENZVVQwWGZVYzM4SUYvVVdNY0MrMGNtTzVwZTBsVFNK?=
 =?utf-8?B?Und1VWVEdGNvNUhSOURRajZnQ1hJeGdJOXByV083NDA2YWlpaVcvbUxrbzdC?=
 =?utf-8?B?NitrSHpJQm9mMWFLcExMa3ozQkEzdkZtZHFLR2VVN2xFY2hVMWxFUjU2QzR5?=
 =?utf-8?B?VVNjcVo4QjY3YXVSamdrenBKN1cyQ3ZFVE5GNGNWN3c5elNnYkpnUytjYUkv?=
 =?utf-8?B?bTgzZnB1R1orNGVtVExhY2lEVHFDVlVaZmVXN01NY1JicTVQMlJvT1J5VTRR?=
 =?utf-8?B?VElqMW0yZzd2UW1xSlpTMXhEbG0xTkZFY0NJR2EwSVk2UFJRaXN3Vy9CQWRz?=
 =?utf-8?B?dGN6a3VKeUdrazhTUll2RHpSKzdFVnVWUGZrWXlNcXYwT2JhdWlPVWtTbHl0?=
 =?utf-8?B?a3dZcVNJcERtMytXL1RYSFNvazVjS3F0SXBjK3NpbW8xUS8wUEVzdm1GOXVp?=
 =?utf-8?B?V0JBcDl0RlV1amJtRUZNSlgxV3hrdWVrcjNvR29laDFCMHJyWC9BTEFNQXJm?=
 =?utf-8?B?ZHFDS2VmTktJMjRVNFB1elk3a29lS2hiNXJNUjRmRFAyTWxtL2tXOHJ4WDEz?=
 =?utf-8?B?aGtzTTRDYUpsb0hxTFpoUHhMdmQ0RFZKYjJmOXhkbno5cFh5Q3NiZkh1S2Ux?=
 =?utf-8?B?bHl1ZFdpWWhQK3FuU3BGYUR4WmRXTFNOZU94eXNPdVdMOEFTWXJ4cnRyNzVp?=
 =?utf-8?B?MERpWWhzbjJiNitDSjdHeE90UXQzZUhwdWZ5UHBCa0xVWmVxejNlV0JpR2No?=
 =?utf-8?B?YTdHVE1XMklUbDN2QW1ZL2RNaDRHbFpvdVRIQng1aXJmWmxJUXZkNjRuWUVG?=
 =?utf-8?B?SjNoQWp6VmNpbkJXYnFGSVNWZTdsaWc0K2NkNFRsbWZEMTg2dHcwbDZzRXZ0?=
 =?utf-8?B?Umx2YjM4ZXFhNkFsUGtMWTB5U3RBcjJtWGNKa3FkMVhSenp6YUx6OGQ5bWFM?=
 =?utf-8?B?WW1EaTE5YjdOMkNVOFNjcGpEUUpCa2g2RDdySTRaM3VjSWt2TFFkZGprY3pa?=
 =?utf-8?B?RndBSVBTaUNqb2t1ajVXOTcyUlhLWm1OQ21ndmRXeS9taU5tWEdzMVNwMUU1?=
 =?utf-8?B?T2I3TVNWeTZZTnJZNjRUMFJ2Qm5HMHA5RldTL3F5NnRGbDhvQm9qY3dhaWM4?=
 =?utf-8?B?aEFaMUl1eXArUGQ4c1ZmdDV6K0dPVDR5QTRKcTd4WEJPOU5wMktnOHZjSEw3?=
 =?utf-8?B?Kzk2NGsra0NabEZ6dnJ6bU13Z21aLzE3cWk1NEhGTDJTVk5PcWxkSlg2VWN5?=
 =?utf-8?B?d3kyd2xkTndxMHBYNEs3M0ZFdnFiVUNBYTVmZGNtdDJBQ0YrczNlTHRrekZG?=
 =?utf-8?B?R1BGL00wak83RGdUQTF1dmM1ZENwallpY2xCT3ZsbEhyMkQzMVRkUnZQc2JU?=
 =?utf-8?B?cDhUeGluelBPYytYcjNMbDk2UTJBSHJPc2dXK3ZDOFRPNHRSUTZaUDJmV2tu?=
 =?utf-8?B?Uk1EbnVESENROGVuRVF3OVZ1REpKVTJaRTAxcmxtcGV6aXFaWHJ0TDNhMG1Z?=
 =?utf-8?B?OTRzR21Zdjhha21aYkJySEMwTlppR2U4OWVadnBpTWhqbUtNUHpPemVkTVFo?=
 =?utf-8?B?Qy9yODMxZnV0TEEwYkk1RHMrREJVZENHWnpDcmNxUldCa0poZUtvRGlJUzZG?=
 =?utf-8?B?azdGNEJ3VmxBUkhlNWQvbCtJSVVJRE9RanlKUFh6Ni9FbTJEak01SHBiTWNn?=
 =?utf-8?B?a0Fhd0lyVG11bkdkN3hUdE5raFB6enpkTStFbFhxaThnZjBwdGl6ZWxJc085?=
 =?utf-8?B?ejlQQjVGNlVXVlkwTGtzRkU2OFE1N0xhY0FUZktIYWRJVkNFMlJ4Ym1uMU5P?=
 =?utf-8?B?ci9ybU1TZnVNQms1NUV1NXR3dGZub1dVSUk1VUFHY0pWRkIxR25HdnlWVU8w?=
 =?utf-8?B?eEpUckFRRzAxdk9hTzg3cnJCejBiaFJ5T3l6OVdZZnd0M2Zva0UwaVUwSDRS?=
 =?utf-8?B?SmUrWWpvZkloT2lxVFp5M2IxMTd4N282ZFR2cHU5Q2hxM2tiRUQ1aGE3dFJv?=
 =?utf-8?B?VU1GQUdSclVjb201RDhNUVFYTlIwSTg5Uk9TZUtHczZlMVU2bWJBeW1YYjFn?=
 =?utf-8?B?bHh4UEtwZVpvNVBUb3d1UUl1Q3FPTXhMVExacGRXVUhGT1lDSmpVV0RHVnVh?=
 =?utf-8?B?OXJua1BkaWlGWGRSMU9ZNXhmc0thUnE5QTgwaEZKeEhUQWxCdzFWY0pCYkJm?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1A8D843518343543B55367AE81A4C64D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbbc456f-3468-4cd3-45a2-08dcc9284072
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 19:16:29.6755
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wHugaXz5X5P+Xya+bc1tcCbaRMTpGlz2XPNV0IDcKKf08diLTtvG2ik8aIeoohrSlNS8xQ81MuNL9q8RIlmMJe0+VZ5CO5G/sj2p0X5B34s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTMwIGF0IDExOjQ1IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gOC8xMi8yNCAxNTo0OCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gRWFjaCBURFggZ3Vl
c3QgaGFzIGEgcm9vdCBjb250cm9sIHN0cnVjdHVyZSBjYWxsZWQgIlRydXN0IERvbWFpbg0KPiA+
IFJvb3QiIChURFIpLsKgIFVubGlrZSB0aGUgcmVzdCBvZiB0aGUgVERYIGd1ZXN0LCB0aGUgVERS
IGlzIHByb3RlY3RlZA0KPiA+IGJ5IHRoZSBURFggZ2xvYmFsIEtleUlELsKgIFdoZW4gdGVhcmlu
ZyBkb3duIHRoZSBURFIsIEtWTSB3aWxsIG5lZWQgdG8NCj4gPiBwYXNzIHRoZSBURFggZ2xvYmFs
IEtleUlEIGV4cGxpY2l0bHkgdG8gdGhlIFREWCBtb2R1bGUgdG8gZmx1c2ggY2FjaGUNCj4gPiBh
c3NvY2lhdGVkIHRvIHRoZSBURFIuDQo+IA0KPiBXaGF0IGRvZXMgdGhhdCBlbmQgdXAgbG9va2lu
ZyBsaWtlPw0KDQpUaGUgZ2xvYmFsIGtleSBpZCBjYWxsZXJzIGxvb2tzIGxpa2U6DQoJZXJyID0g
dGRoX3BoeW1lbV9wYWdlX3diaW52ZChzZXRfaGtpZF90b19ocGEoa3ZtX3RkeC0+dGRyX3BhLA0K
CQkJCQkJICAgICB0ZHhfZ2xvYmFsX2tleWlkKSk7DQoJaWYgKEtWTV9CVUdfT04oZXJyLCBrdm0p
KSB7DQoJCXByX3RkeF9lcnJvcihUREhfUEhZTUVNX1BBR0VfV0JJTlZELCBlcnIpOw0KCQlyZXR1
cm47DQoJfQ0KDQpUaGUgVEQga2V5aWQgY2FsbGVycyBsb29rcyBsaWtlOg0KCWhwYV93aXRoX2hr
aWQgPSBzZXRfaGtpZF90b19ocGEoaHBhLCAodTE2KWt2bV90ZHgtPmhraWQpOw0KCWRvIHsNCgkJ
LyoNCgkJICogVERYX09QRVJBTkRfQlVTWSBjYW4gaGFwcGVuIG9uIGxvY2tpbmcgUEFNVCBlbnRy
eS4gIEJlY2F1c2UNCgkJICogdGhpcyBwYWdlIHdhcyByZW1vdmVkIGFib3ZlLCBvdGhlciB0aHJl
YWQgc2hvdWxkbid0IGJlDQoJCSAqIHJlcGVhdGVkbHkgb3BlcmF0aW5nIG9uIHRoaXMgcGFnZS4g
IEp1c3QgcmV0cnkgbG9vcC4NCgkJICovDQoJCWVyciA9IHRkaF9waHltZW1fcGFnZV93YmludmQo
aHBhX3dpdGhfaGtpZCk7DQoJfSB3aGlsZSAodW5saWtlbHkoZXJyID09IChURFhfT1BFUkFORF9C
VVNZIHwgVERYX09QRVJBTkRfSURfUkNYKSkpOw0KDQo+IA0KPiBJbiBvdGhlciB3b3Jkcywgc2hv
dWxkIHdlIGV4cG9ydCB0aGUgZ2xvYmFsIEtleUlELCBvciBleHBvcnQgYSBmdW5jdGlvbg0KPiB0
byBkbyB0aGUgZmx1c2ggYW5kIHRoZW4gbmV2ZXIgYWN0dWFsbHkgZXhwb3NlIHRoZSBLZXlJRD8N
Cg0KV2UgY291bGQgc3BsaXQgaXQgaW50byB0d28gaGVscGVycyBpZiB3ZSB3YW50ZWQgdG8gcmVt
b3ZlIHRoZSBleHBvcnQgb2YNCnRkeF9nbG9iYWxfa2V5aWQuIE9uZSBmb3IgZ2xvYmFsIGtleSBp
ZCBhbmQgb25lIHRoYXQgb25seSB0YWtlcyBURCByYW5nZSBrZXkNCmlkcy4gQWRkaW5nIG1vcmUg
bGF5ZXJzIGlzIGEgZG93bnNpZGUuDQoNClNlcGFyYXRlIGZyb20gRGF2ZSdzIHF1ZXN0aW9uLCBJ
IHdvbmRlciBpZiB3ZSBzaG91bGQgb3BlbiBjb2RlIHNldF9oa2lkX3RvX2hwYSgpDQppbnNpZGUg
dGRoX3BoeW1lbV9wYWdlX3diaW52ZCgpLiBUaGUgc2lnbmF0dXJlIGNvdWxkIGNoYW5nZSB0bw0K
dGRoX3BoeW1lbV9wYWdlX3diaW52ZChocGFfdCBwYSwgdTE2IGhraWQpLiBzZXRfaGtpZF90b19o
cGEoKSBpcyB2ZXJ5DQpsaWdodHdlaWdodCwgc28gSSBkb24ndCB0aGluayBkb2luZyBpdCBvdXRz
aWRlIHRoZSBsb29wIGlzIG11Y2ggZ2Fpbi4gSXQgbWFrZXMNCnRoZSBjb2RlIGNsZWFuZXIuDQoN
Cj4gDQo+ID4gLXN0YXRpYyB1MzIgdGR4X2dsb2JhbF9rZXlpZCBfX3JvX2FmdGVyX2luaXQ7DQo+
ID4gLXN0YXRpYyB1MzIgdGR4X2d1ZXN0X2tleWlkX3N0YXJ0IF9fcm9fYWZ0ZXJfaW5pdDsNCj4g
PiAtc3RhdGljIHUzMiB0ZHhfbnJfZ3Vlc3Rfa2V5aWRzIF9fcm9fYWZ0ZXJfaW5pdDsNCj4gPiAr
dTMyIHRkeF9nbG9iYWxfa2V5aWQgX19yb19hZnRlcl9pbml0Ow0KPiA+ICtFWFBPUlRfU1lNQk9M
X0dQTCh0ZHhfZ2xvYmFsX2tleWlkKTsNCj4gPiArDQo+ID4gK3UzMiB0ZHhfZ3Vlc3Rfa2V5aWRf
c3RhcnQgX19yb19hZnRlcl9pbml0Ow0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfZ3Vlc3Rf
a2V5aWRfc3RhcnQpOw0KPiA+ICsNCj4gPiArdTMyIHRkeF9ucl9ndWVzdF9rZXlpZHMgX19yb19h
ZnRlcl9pbml0Ow0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfbnJfZ3Vlc3Rfa2V5aWRzKTsN
Cj4gDQo+IEkga25vdyB0aGUgS1ZNIGZvbGtzIGFyZW4ndCBtYW5pYWNzIHRoYXQgd2lsbCBzdGFy
dCB3cml0aW5nIHRvIHRoZXNlIG9yDQo+IGFueXRoaW5nLg0KDQpZZWEuIHJvX2FmdGVyX2luaXQg
d291bGQgc3RvcCBtb3N0IG1pc2NoaWVmIGFzIHdlbGwuDQoNCj4gDQo+IEJ1dCwgaW4gZ2VuZXJh
bCwganVzdCBleHBvcnRpbmcgZ2xvYmFsIHZhcmlhYmxlcyBpc24ndCBzdXBlciBuaWNlLsKgIElm
DQo+IHRoZXNlIGFyZSBiZWluZyB1c2VkIHRvIHNldCB1cCB0aGUga2V5IGFsbG9jYXRvciwgSSdk
IGtpbmRhIGp1c3QgcmF0aGVyDQo+IHRoYXQgdGhlIGFsbG9jYXRvciBiZSBpbiBjb3JlIGNvZGUg
YW5kIGhhdmUgaXRzIGFsbG9jL2ZyZWUgZnVuY3Rpb25zDQo+IGV4cG9ydGVkLg0KPiANCg0KTWFr
ZXMgc2Vuc2UuIFdlIGNvdWxkIHJlbW92ZSB0ZHhfZ3Vlc3Rfa2V5aWRfc3RhcnQvdGR4X25yX2d1
ZXN0X2tleWlkcyB0aGVuIGluDQphbnkgY2FzZS4gQnV0IGlmIHdlIHdhbnQgdG8gcmVtb3ZlIHRk
eF9nbG9iYWxfa2V5aWQgdG9vLCB3ZSBjb3VsZCBhZGQgYQ0KdGRoX3BoeW1lbV9wYWdlX3diaW52
ZF9nbG9iYWxfa2V5aWQodm9pZCkuIEknbSBzcGxpdCBvbiB0aGF0IG9uZSwgYnV0IEknZCBsZWFu
DQp0b3dhcmRzIGRvaW5nIGl0Lg0K

