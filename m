Return-Path: <kvm+bounces-25916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BCE96CACE
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 01:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6720C1C24BF4
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 23:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD90F17BECA;
	Wed,  4 Sep 2024 23:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LOmNCGjK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC351372;
	Wed,  4 Sep 2024 23:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725492537; cv=fail; b=MFH754VRy20r8Km1La1LKQ46xsNyxCS9p3ESJfvp6b9c4zwwJWb1trtsJXX8iU84sWXYM+KGgcFuDFiW0Iq5vSC2etgBbdRCUealnSiOF+px3mWj993CNZrV/o9KqKU32XyvM5v7YEL8MOpPYU3xmsuGTLRpVzolDBJKtvT3h0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725492537; c=relaxed/simple;
	bh=axNHKuSUEHSCAraLqN3K9KmWqy3AfpP51yYTLKA4cwI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hOoe8SXiPtDp5JSI+oW2OcG3bwsqWpVthIaIPer9/PED2KbwHz6QBGZLUCa1k4MGGEEtoXp2VDj6n4duqvXBobBDevwGI+ynsnEWBRcoxFYKBUCQMe6Ee3esEUT0R5l9AS47aYWiuAoq299UboJsSq6nKFLrAmPaCyRkKXNi+PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LOmNCGjK; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725492535; x=1757028535;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=axNHKuSUEHSCAraLqN3K9KmWqy3AfpP51yYTLKA4cwI=;
  b=LOmNCGjKkWiPc/Ba3SKDGHlVZ8ky6e6S8h1iv69V2vc/Hg5B1sIlAsdn
   9XmCXE3KQI4wuSauiO7oXjtF5M22xQPuGDWUtdAxiz+0dmM0Jv9U80/jP
   cJdtl4we2tlmhMN+ggPWxw8+d6RJhrWOLgMfsQObpjq8GUTkwFDr2EV4S
   KvRupFD9JDnJJPvN2mXSsNeZkysZNvNvTwXA1cWK5l9leWnnpk9hpLrKu
   OK5yUYqzGftR69qXXU9wbo5LSo2+R32ZUlXqlAcm+HoC3jaduAMZzYjNa
   v4GkdRDYukrDmJJSvqlFEKAfMhSPDsquaJ4HlLRHliv60UTpSLy4MWYNY
   w==;
X-CSE-ConnectionGUID: AZjXAULlQI61R5IJ0RdqOQ==
X-CSE-MsgGUID: VoxKA+jwRGK9XxeHYF128g==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24340070"
X-IronPort-AV: E=Sophos;i="6.10,203,1719903600"; 
   d="scan'208";a="24340070"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2024 16:28:54 -0700
X-CSE-ConnectionGUID: cgxGepHBRk6l/libm1ULCA==
X-CSE-MsgGUID: 0YI3SZgcQ2aM8/I5/HH/Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,203,1719903600"; 
   d="scan'208";a="88664618"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2024 16:28:53 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 16:28:53 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Sep 2024 16:28:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Sep 2024 16:28:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Sep 2024 16:28:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OEe7nLdPId40e+hRTNY6uEia0DTmULOyctsMILQ85ahU8LY1Jx9Q4OhFylwDhxCAlO2e5WLSa6ScsNeBxFc1wQ4Dp4AmKH2HpA7RmrSAnCWAUvFSAsNFtNj8Z38faqt7tGvBHk08hNWmwg8cnbmfExt7WSZeqAsu5IlQshtUw+p2uARuM6vCQYKTQkeLJwyEkMkWdjbS0/Ks0XptLq4KAEOQfRlsRihOk4lnRrxAGm5uoalyA6r4YqbHJEfobizEZeRIgQdtS1L2ovKPu+Vh4b9H2bVeLtq+By9pjpuVXuMb0+LZdWrsjhGAwQg2axGV/1PjXxOg1qAcuNRYi43kLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CBXxiepl9LumlOn//rRrQemKYfHk28j5uD2+ZAfblN0=;
 b=fyu3TgCFGqi+fnirItg3dJbudf7iHHScNOS+NHnhr0zCI7s8FTARF2CBvU+Ukd5jaQZhtWa+fNhIQ4StTJXTOhmX4ho7jawXc1BhWYgQ/rfepvAZH9TBHsswv+CAk5PoctzPlhYwZLufvZ6KCPXLQNeu4Su1rxLPdWFNtumgb0I2OSsVI5pOQ+xaFGfTP0/7rv4UJtiSi4d2S3NtrpHPbN6Aa55LGvd8HZNVxRosVHn7enLA3cob51xr78KOOLy4/xTob7QJl/RDh4lf6WkZ8mbUFEKpp8D55HBPZIqjHVzH1V5z3BeDhiB5RbPGDmgXaNRhOPH8PKRwCnLdUs6FIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5310.namprd11.prod.outlook.com (2603:10b6:5:391::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 4 Sep
 2024 23:28:48 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 23:28:48 +0000
Date: Wed, 4 Sep 2024 16:28:45 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Dan Williams
	<dan.j.williams@intel.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, <pratikrajesh.sampat@amd.com>,
	<michael.day@amd.com>, <david.kaplan@amd.com>, <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <66d8ed2d5a719_3975294c4@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <66d7a10a4d621_3975294ac@dwillia2-xfh.jf.intel.com.notmuch>
 <9c0bac09-f663-4592-b954-259aeb7ec268@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c0bac09-f663-4592-b954-259aeb7ec268@amd.com>
X-ClientProxiedBy: MW4PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:303:8e::21) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5310:EE_
X-MS-Office365-Filtering-Correlation-Id: fbcf3e80-483e-42bf-c28d-08dccd3953ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eEJSUmtSdWlpNmxOTnlxcURhWE1jOFptUk9YTWw3MkwxSU5mRitxTDk0UGdr?=
 =?utf-8?B?WDl1WlRIaG9HdmxBVERkeWZsV2pCeXB3d2xkZTV5ZEhNNHBPVHBvQWlmdG42?=
 =?utf-8?B?QklGTWVRb1d4Y2kvTzJESHU2eHpkd3FwaDQvdDNXQ0hsMnFLOUhaVVlTUUtP?=
 =?utf-8?B?elgrUFJBekVnTlM2VFNVVDZvaUJNeEFMWmEzMSs0TVdEdmt5MDJveCt0TGNv?=
 =?utf-8?B?Q0ZVcGUxblJaZXBMcGNJdktJQ1BNd0JDTzZHaFlmbEsvVUM3ankxOVY1TEZZ?=
 =?utf-8?B?c21mZFpJc2hWcTVwd09VUW4xeUQyZDJLZHQ1T21TNWIxM2xvT1VJYTdXMWsv?=
 =?utf-8?B?MDgwQ3VpRXFoVWJld1hoNTg3WUFmTFpOSVZyOUl1TzVOZ2FjYVFoZ1pIdjB2?=
 =?utf-8?B?OCtSVkJmUGIrOUFjWmY0RkRRNXQ0MUZweXB4VktoekRvODZnS3FBTG1adm9P?=
 =?utf-8?B?NGlReC9JSnhJQTE1YlFyZUV0OHpnTW5SbmExTTBra3ozeFM1SkJpSkR1RDcv?=
 =?utf-8?B?Qlprb0ZjTDBXTWdRNE9hQ0hBdGlzd05seFZSRVQxNGZJeHZxb3BINFJDOXFv?=
 =?utf-8?B?U1dwejAybDRyYmtTTFE0ZzRkRUlZUzh6RVN4bGs5ckR3QWo0THZuREF3REhJ?=
 =?utf-8?B?SEpNSy9lVlR5VTA3Q09obnY5V1F4RnBHczZ0aUtwNGVSMTBjTFZidHNibmNO?=
 =?utf-8?B?eTd2WXRQQmNiN1Z1dXZCRTRBOHlCMCtIT0thQWVFVkptZzI1QkUrZWUxR0hv?=
 =?utf-8?B?bjZUdTVFSnU0bmVpZzFHNGc0U1EveU1FbWJpbkdDU3ZXTTkyOVlQOGpjR0dl?=
 =?utf-8?B?MXpHMlRadnN2UE5LTVNpa1dtazBZWXRqdUpCMmEybkpVOHJTQnBMZEcrbHdh?=
 =?utf-8?B?L3FVM0gxclZ6emc5RWFRMUJTVlBDZWRRbG9JUkVkUHBNTm5aUnBZbjZCMlls?=
 =?utf-8?B?MkZLUitqa2E2UTNwZlVUTmJlbzdkUkF2aDdRU3RiRGZnZDBHY2lLOGg4b0pu?=
 =?utf-8?B?MHE3ditwQ1NtdGErZTRzckhBUGRSZFNDMzFqNVdMelVRSFExK3NOa2JWR2lJ?=
 =?utf-8?B?cmRyQjR2Y0JqOXRmakF4RFJxM1VTcjhhMGtxbUFoaE84WndmMVcraTVTaEtG?=
 =?utf-8?B?RnBBWHFKakl5N2N6SG4xUVhZaGlUTjk3Rzllbm9mbWJDN05tVUJqS1p2TnNp?=
 =?utf-8?B?WkhKai9mRm1sWHBPdnFpZXE4NWFYano3eTJ2dnlmcGRKOGtyU3p1dnYxVTZp?=
 =?utf-8?B?OWd1OW53cEVEbjJOOHBITzA0OHBGMVErV0s0RnBZQmlXZUxTMWRSUVJQMUdQ?=
 =?utf-8?B?TFFlWnZULzRCRGZwL2Zod3FCeXlTR2UyYlNwanBVdmxLajBqRjU1TGdRVHFv?=
 =?utf-8?B?ZUlWOTNPTzBPWUthaUVLMUpPTC8xOGNyQzl6QjRIbWZIY0FXa0VMbVdzWG1i?=
 =?utf-8?B?VWNkOUx2aHpXZFd5eGZUQ1BJczhYcGpLTCt3U282bEp5ZzhpZWNKNnlOQjIz?=
 =?utf-8?B?cGVDWkZBM2EzQlZnMGhiR21ST1ljQkRnS1BQNjZJcWU2dUVJMmlrYkVhVk1T?=
 =?utf-8?B?OG9sTmhQNFgxTTYvU0xmeE50YzNyYzNTQzR6S1B3RS9hRWlPalg3TmtMN3JG?=
 =?utf-8?B?cWZiWUwzeVZhUXlKSzZjOERkK1FGcWtvZGhLbDZnSHhCL1hXUHdGSXpPT2dx?=
 =?utf-8?B?MGEvMlZoSTIydWdTWC9jZW1sY3RZdFNrbFdkUGpTK29HdFFSK0hibXVrZ2R3?=
 =?utf-8?B?UGpDOEVNaFlXT1pvNGo1QjlxRXEvSkRScUZJdHRaRmk1Y3BpZ1dlNmllaHJD?=
 =?utf-8?Q?dFH5qrP5fbH5og2ZdaxanRvfw4otGA///t2Sc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dCtMQzFTeFRIVlN0dGNNbkdINXoySnhPbGRWWnZ1Q2RNQ3N4Ulpwd1VvcGZW?=
 =?utf-8?B?cDdDSWdqMFgrSFlRbEo3akVpVFhnZFZiNVo1Vlh0dGRIZkU3SmovU2NueTNu?=
 =?utf-8?B?Mk9wZ25laEpWY1F2RjhTUlVaS2U5VlF0ZVN6N2NYRHFLamhjbmZNL1dYT2hX?=
 =?utf-8?B?V0FUWm84dS9HRkJoRG5iSTNEUjA1bkZBNHJYVDB3enhqV3REd2pOZURHS3JK?=
 =?utf-8?B?ZUN4aUdDZ0phbStxV3JyaU5rZFVJVXNhS3drb3JndC8zT2hsSVpiaGhJUS9z?=
 =?utf-8?B?R2xFU3hXWEp6cCsycERKYlByQjloMzhHY0VLOGN1ck1neTBHbG11czZQNkpr?=
 =?utf-8?B?UHJIYXJvNE82Mk1kR3lFUHhZWmk5NHk1ZmRwNGFEVThxNFp2eXNoci9pZlcw?=
 =?utf-8?B?SEs0czMrRmg3RndWSHkyNWF2NzNERjJRRndQZmJPVHJjY3NuQnc2MjZ4Mk1w?=
 =?utf-8?B?Z3RtNWt4RlM5Yk1KVjBnMm9xR0Rtd1JiQmlBVlA4YmRhWkdPVVhiMy9uL0tR?=
 =?utf-8?B?NG1ZT25xQXd0cmtvL1BJRVhZWG91ZFJwWS9SMVFiNmpXVWxtbzJwdFRlcjNB?=
 =?utf-8?B?d2d4bGdrUnlNMjdCbVJlQ0NGKzVOVGNQWElnY1J2d2tSaFlWUU5hSmYrSUM1?=
 =?utf-8?B?cUVjT0RUNGV4SVc4dHJ1RWNkQk11UGpQYzdDUUNCeVZaa3A5cThhYkNYTzRL?=
 =?utf-8?B?NDZraGd4dU5mUGxFcmVrOTIvYTJ4THY0STFuQnpBMHlHaWJOa2MwdXdMSlBL?=
 =?utf-8?B?OElvRWlEQ1hidnlZc1AyQlFjWVovbHpQa3FOZHJ4TGhLaG9reDhHRHlsK014?=
 =?utf-8?B?MEMvd2FDV05HcGh1d2pkM2ZCNGlxcWhId2dnWkdDa3p6bk8yU0VQSmVCdWhY?=
 =?utf-8?B?WGdvVlhuaEZYQUhFVzFGaVBLWXZFTi9XRndjTWhEZHd5aWtjSmR0TjREWjds?=
 =?utf-8?B?V3lMamFwRVc5Tzlwb0JSSFVydjFoQ1FpeW85NzFwZDR2K2JjT1AwOGpzU25I?=
 =?utf-8?B?UjZGVTF4RjA5VituN1RpKzRvdXFDRXhzTWdOYXhLSWNSSUhjQ0dTcWlTOTRa?=
 =?utf-8?B?elJONkhQZCtYVE82V0xjK3IzeXkxMDEzQ3BJN3V3WnJUY1doOG1CNWpRd3Uz?=
 =?utf-8?B?R3pKanlPSTVEK0t4QjhPalE5eko2cmovd3lsZS9JdXlzZmJDVGlXZGJuVDFO?=
 =?utf-8?B?TURveXl3WHM4VkVMMG5nTkt4Q1FPQjRDR1YwRUltaEx0Y0NTb29ZMEZjb2Vj?=
 =?utf-8?B?WUtuUjZzb2F1MFZwK2NZbC9LeStjeWpHWnZ2eUtYWmpzdk1PcC9vYVRvTW5D?=
 =?utf-8?B?SHBkdUlyWlRXNGtWamJ1RVZUNzVoNDArU0paOURoQnNkWVVtSW1EbVFrSmRV?=
 =?utf-8?B?RFgzZG15M2dWcThrZHgvVGNOSlptdVZ1OG5vUGFOKytYdEVhTGRibEVldkVR?=
 =?utf-8?B?Smxoa1V0bW5kVW5mNzFBbkM5ZUhVSSs4UVc1QU9KUWRrbGRHbDFMbGZkMGww?=
 =?utf-8?B?VUozREFqRXFMaUIreTlZYUZxR2cybUVzZCtpSlBCcS9ZM25kK3BUdWtGUlhZ?=
 =?utf-8?B?bEpZTkpHc3RLaUxvV0J4S1hhbDUrNEZUV2RCZXJXL2FwZnhUbExEWm1BNVpJ?=
 =?utf-8?B?emlvYWI0THpabmx0c0U3UVIvdnFURDhTRmR0SW94bTNkTUVsdHlhcjRkVVVV?=
 =?utf-8?B?VkVPU0x5ZWNwWVRKUm5uK3Z4aFNKa29kcGg2bTZXKzZrZjFZaytUS2ZFci9s?=
 =?utf-8?B?LzZzTFpKMGEwZDZoRGFFMUlxTmI3VlZDMWRXT2FCWE9HbzVRT3QrbGR0bG1L?=
 =?utf-8?B?SVlldVk2anpKUm9MQml1U3VlT3pERVBUQ0JqMU50M3JQZDI1bDZOU3R2MjJs?=
 =?utf-8?B?a1JkcjV6TjBma1pPOHUzZ2lnTkhlQWMvaE1DQkZ3UDZ6NnV5MkVINWZHSXhQ?=
 =?utf-8?B?RHltK1lzcHJyWG00NFBPZ0dvQjlnLzBPaExrc2NyWGFJQW11WHBRd3c5V3N1?=
 =?utf-8?B?SWl2a1hwcHBGUFltbkN2ZE5wbG9WTnBCd2U4b2tvWis2bkZXUUFKTlRPS3dW?=
 =?utf-8?B?WkFRTTlQSkkwRm1EQmFMZzZENDNudzJVZDVOdnh1a013MmlzNU0zMmFHcnRz?=
 =?utf-8?B?bG5LdEphZmI5cFVzbUUyZDZuT0YveFJ4ekwzenpUOVJxYTY2c3RmVkh3S1JZ?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbcf3e80-483e-42bf-c28d-08dccd3953ce
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 23:28:48.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odsv8jKHIAWvTGOrB5aDrORN3qa2yfjsla91861Tlp17WZku5d/fNkPQ9vw8n0Y7sq/1NA9hGYAAYuHiDzQblOu7nI4Xts1YmK139WgSOnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5310
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> 
> 
> On 4/9/24 09:51, Dan Williams wrote:
> > Alexey Kardashevskiy wrote:
> >> The module responsibilities are:
> >> 1. detect TEE support in a device and create nodes in the device's sysfs
> >> entry;
> >> 2. allow binding a PCI device to a VM for passing it through in a trusted
> >> manner;
> >> 3. store measurements/certificates/reports and provide access to those for
> >> the userspace via sysfs.
> >>
> >> This relies on the platform to register a set of callbacks,
> >> for both host and guest.
> >>
> >> And tdi_enabled in the device struct.
> > 
> > I had been holding out hope that when I got this patch the changelog
> > would give some justification for what folks had been whispering to me
> > in recent days: "hey Dan, looks like Alexey is completely ignoring the
> > PCI/TSM approach?".
> > 
> > Bjorn acked that approach here:
> > 
> > http://lore.kernel.org/20240419220729.GA307280@bhelgaas
> > 
> > It is in need of a refresh, preview here:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux.git/commit/?id=5807465b92ac
> > 
> > At best, I am disappointed that this RFC ignored it. More comments
> > below, but please do clarify if we are working together on a Bjorn-acked
> > direction, or not.
> 
> Together.
> 
> My problem with that patchset is that it only does connect/disconnect 
> and no TDISP business (and I need both for my exercise) and I was hoping 
> to see some TDISP-aware git tree but this has not happened yet so I 
> postponed rebasing onto it, due to the lack of time and also apparent 
> difference between yours and mine TSMs (and I had mine working before I 
> saw yours and focused on making things work for the starter). Sorry, I 
> should have spoken louder. Or listen better to that whispering. Or 
> rebase earlier.

Ok, this makes sense. This is definitely changelog material to clarify
assumptions, tradeoffs, and direction. The fact that the changelog said
nothing about those was, at a minimum, cause for concern.

[..]
> >> @@ -801,6 +802,7 @@ struct device {
> >>   	void	(*release)(struct device *dev);
> >>   	struct iommu_group	*iommu_group;
> >>   	struct dev_iommu	*iommu;
> >> +	struct tsm_tdi		*tdi;
> > 
> > No. The only known device model for TDIs is PCI devices, i.e. TDISP is a
> > PCI protocol. Even SPDM which is cross device-type generic did not touch
> > 'struct device'.
> 
> TDISP is PCI but DMA is not. This is for:
> [RFC PATCH 19/21] sev-guest: Stop changing encrypted page state for 
> TDISP devices
> 
> DMA layer deals with struct device and tries hard to avoid indirect _ops 
> calls so I was looking for a place for "tdi_enabled" (a bad name, 
> perhaps, may be call it "dma_encrypted", a few lines below).

The name and the fact that it exposes all of the TSM interfaces to the
driver core made it unclear if this oversharing was on purpose, or for
convenience / expediency?

I agree that 'struct device' should carry DMA mapping details, but the
full TDI context is so much more than that which makes it difficult to
understand the organizing principle of this data sharing.

> the flag and the pointer together for the RFC. I am hoping for a better 
> solution for 19/21, then I am absolutely moving tdi* to pci_dev (well, 
> drop these and just use yours).

Ok, so what patches are in the category of "temporary hacks to get
something going and a plan to replace them", and which are "firm
proposals looking for review feedback"?

[..]
> >> +/**
> >> + * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
> >> + *
> >> + * @function_id: Identifies the function of the device hosting the TDI
> >> + * 15:0: @rid: Requester ID
> >> + * 23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
> >> + * 24: @rseg_valid: Requester Segment Valid
> >> + * 31:25 – Reserved
> >> + * 8B - Reserved
> >> + */
> >> +struct tdisp_interface_id {
> >> +	union {
> >> +		struct {
> >> +			u32 function_id;
> >> +			u8 reserved[8];
> >> +		};
> >> +		struct {
> >> +			u16 rid;
> >> +			u8 rseg;
> >> +			u8 rseg_valid:1;
> > 
> > Linux typically avoids C-bitfields in hardware interfaces in favor of
> > bitfield.h macros.
> > >> +		};
> >> +	};
> >> +} __packed;
> > 
> > Does this need to be "packed"? Looks naturally aligned to pahole.
> 
> "__packed" is also a way to say it is a binary interface, I want to be 
> precise about this.

It's also a way to tell the compiler to turn off useful optimizations.

Don't these also need to be __le32 and __le16 for the multi-byte fields?

[..]
> > Same C-bitfield comment, as before, and what about big endian hosts?
> 
> Right, I'll get rid of c-bitfields in the common parts.
> 
> Although I am curious what big-endian platform is going to actually 
> support this.

The PCI DOE and CMA code is cross-CPU generic with endian annotations
where needed. Why would PCI TSM code get away with kicking that analysis
down the road?

[..]
> >> +/* Physical device descriptor responsible for IDE/TDISP setup */
> >> +struct tsm_dev {
> >> +	struct kref kref;
> > 
> > Another kref that begs the question why would a tsm_dev need its own
> > lifetime? This also goes back to the organization in the PCI/TSM
> > proposal that all TSM objects are at max bound to the lifetime of
> > whatever is shorter, the registration of the low-level TSM driver or the
> > PCI device itself.
> 
> 
> That proposal deals with PFs for now and skips TDIs. Since TDI needs its 
> place in pci_dev too, and I wanted to add the bare minimum to struct 
> device or pci_dev, I only add TDIs and each of them references a DEV. 
> Enough to get me going.

Fine for an RFC, but again please be upfront about what is firmer for
deeper scrutiny and what is softer to get the RFC standing.

> >> +	const struct attribute_group *ag;
> > 
> > PCI device attribute groups are already conveyed in a well known
> > (lifetime and user visibility) manner. What is motivating this
> > "re-imagining"?
> > 
> >> +	struct pci_dev *pdev; /* Physical PCI function #0 */
> >> +	struct tsm_spdm spdm;
> >> +	struct mutex spdm_mutex;
> > 
> > Is an spdm lock sufficient? I expect the device needs to serialize all
> > TSM communications, not just spdm? Documentation of the locking would
> > help.
> 
> What other communication do you mean here?

For example, a lock protecting entry into tsm_ops->connect(...), if that
operation is locked does there need to be a lower level spdm locking
context?

[..]
> >> +/*
> >> + * Enables IDE between the RC and the device.
> >> + * TEE Limited, IDE Cfg space and other bits are hardcoded
> >> + * as this is a sketch.
> > 
> > It would help to know how in depth to review the pieces if there were
> > more pointers of "this is serious proposal", and "this is a sketch".
> 
> Largely the latter, remember to keep appreciating the "release early" 
> aspect of it :)
> 
> It is a sketch which has been tested on the hardware with both KVM and 
> SNP VM which (I thought) has some value if posted before the LPC. I 
> should have made it clearer though.

It is definitely useful for getting the conversation started, but maybe
we need a SubmittingPatches style document that clarifies that RFC's
need to be explicit about if and where reviewers spend their time.

[..]
> > This feels kludgy. IDE is a fundamental mechanism of a PCI device why
> > would a PCI core helper not know how to extract the settings from a
> > pdev?
> > 
> > Something like:
> > 
> > pci_ide_setup_stream(pdev, i)
> 
> 
> It is unclear to me how we go about what stream(s) need(s) enabling and 
> what flags to set. Who decides - a driver? a daemon/user?

That is a good topic for the design document that Jason wanted. I had
been expecting that since stream IDs are a limited resource the kernel
needs to depend on userspace to handle allocation conflicts. Most of the
other settings would seem to be PCI core defaults unless and until
someone can point to a use case for a driver or userspace to have a
different opinion about those settings.

> >> +		if (ret) {
> >> +			pci_warn(tdev->pdev,
> >> +				 "Failed configuring SelectiveIDE#%d with %d\n",
> >> +				 i, ret);
> >> +			break;
> >> +		}
> >> +
> >> +		ret = pci_ide_set_sel_rid_assoc(rootport, i, true, 0, 0, 0xFFFF);
> >> +		if (ret)
> >> +			pci_warn(rootport,
> >> +				 "Failed configuring SelectiveIDE#%d rid1 with %d\n",
> >> +				 i, ret);
> >> +
> >> +		ret = pci_ide_set_sel(rootport, i,
> > 
> > Perhaps:
> > 
> > pci_ide_host_setup_stream(pdev, i)
> > 
> > ...I expect the helper should be able to figure out the rootport and RID
> > association.
> 
> Where will the helper get the properties from?

I expect it can retrieve it out of @pdev since the IDE settings belong
in 'struct pci_dev'.

[..]
> >> +static int tsm_dev_reclaim(struct tsm_dev *tdev, void *private_data)
> >> +{
> >> +	struct pci_dev *pdev = NULL;
> >> +	int ret;
> >> +
> >> +	if (WARN_ON(!tsm.ops->dev_reclaim))
> >> +		return -EPERM;
> > 
> > Similar comment about how this could happen and why crashing the kernel
> > is ok.
> 
> In this exercise, connect/reclaim are triggered via sysfs so this can 
> happen in my practice.
> 
> And it is WARN_ON, not BUG_ON, is it still called "crashing" (vs. 
> "panic", I never closely thought about it)?

You will see folks like Greg raise the concern that many users run with
"panic_on_warn" enabled. I expect a confidential VM is well advised to
enable that.

If it is a "can't ever happen outside of a kernel developer mistake"
then maybe WARN_ON() is ok, and you will see folks like Christoph assert
that WARN_ON() is good for that, but it should be reserved for cases
where rebooting might be a good idea if it fires.

> >> +
> >> +	/* Do not disconnect with active TDIs */
> >> +	for_each_pci_dev(pdev) {
> >> +		struct tsm_tdi *tdi = tsm_tdi_get(&pdev->dev);
> >> +
> >> +		if (tdi && tdi->tdev == tdev && tdi->data)
> >> +			return -EBUSY;
> > 
> > I would expect that removing things out of order causes violence, not
> > blocking it.
> > 
> > For example you can remove disk drivers while filesystems are still
> > mounted. What is the administrator's recourse if they *do* want to
> > shutdown the TSM layer all at once?
> 
> "rmmod tsm"

Is tsm_dev_reclaim() triggered by "rmmod tsm"? The concern is how to
reclaim when tsm_dev_reclaim() is sometimes returning EBUSY. Similar to
how the driver core enforces that driver unbind must succeed so should
TSM shutdown.

Also, the proposal Bjorn acked, because it comports with PCI sysfs
lifetime and visibility expectations, is that the TSM core is part of
the PCI core, just like DOE and CMA. The proposed way to shutdown TSM
operations is to unbind the low level TSM driver (TIO, TDX-Connect,
etc...) and that will forcefully destruct all TDI contexts with no
dangling -EBUSY cases.

Maybe tsm_dev_reclaim() is not triggered by TSM shutdown, but TSM
shutdown, like 'struct device_driver'.remove() should return 'void'.
Note, I know that 'struct device_driver' is not quite there yet on
->remove() returning 'void' instead of 'int', but that is the direction.

[..]
> > Why is refresh not "connect"? I.e. connecting an already connected
> > device refreshes the connection.
> 
> Really not sure about that. Either way I am ditching it for now.

Yeah, lets aggressively defer incremental features.

> >> +		ret = spdm_forward(&tdev->spdm, ret);
> >> +		if (ret < 0)
> >> +			break;
> >> +	}
> >> +	mutex_unlock(&tdev->spdm_mutex);
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static void tsm_tdi_reclaim(struct tsm_tdi *tdi, void *private_data)
> >> +{
> >> +	int ret;
> >> +
> >> +	if (WARN_ON(!tsm.ops->tdi_reclaim))
> >> +		return;
> >> +
> >> +	mutex_lock(&tdi->tdev->spdm_mutex);
> >> +	while (1) {
> >> +		ret = tsm.ops->tdi_reclaim(tdi, private_data);
> >> +		if (ret <= 0)
> >> +			break;
> > 
> > What is involved in tdi "reclaim" separately from "unbind"?
> > "dev_reclaim" and "tdi_reclaim" seem less precise than "disconnect" and
> > "unbind".
> 
> The firmware operates at the finer granularity so there are 
> create+connect+disconnect+reclaim (for DEV and TDI). My verbs dictionary 
> evolved from having all of them in the tsm_ops to this subset which 
> tells the state the verb leaves the device at. This needs correction, yes.

I like the simplicity of the TIO verbs, but that does not preclude the
Linux verbs from having even coarser semantics.

[..]
> >> +/* In case BUS_NOTIFY_PCI_BUS_MASTER is no good, a driver can call pci_dev_tdi_validate() */
> > 
> > No. TDISP is a fundamental re-imagining of the PCI device security
> > model. It deserves first class support in the PCI core, not bolted on
> > support via bus notifiers.
> 
> This one is about sequencing. For example, writing a zero to BME breaks 
> a TDI after it moved to CONFIG_LOCKED. So, we either:
> 1) prevent zeroing BME or
> 2) delay this "validation" step (which also needs a better name).
> 
> If 1), then I can call "validate" from the PCI core before the driver's 
> probe.
> If 2), it is either a driver modification to call "validate" explicitly 
> or have a notifier like this. Or guest's sysfs - as a VM might want to 
> boot with a "shared" device, get to the userspace where some daemon 
> inspects the certificates/etc and "validates" the device only if it is 
> happy with the result. There may be even some vendor-specific device 
> configuration happening before the validation step.

Right, the guest might need to operate the device in shared mode to get
it ready for validation. At that point locking and validating the device
needs to be triggered by userspace talking to the PCI core before
reloading the driver to operate the device in private mode. That
conversion is probably best modeled as a hotplug event to leave the
shared world and enter the secured world.

That likely means that the userspace operation to transtion the device
to LOCKED also needs to take care of enabling BME and MSE independent of
any driver just based on the interface report. Then, loading the driver
can take the device from LOCKED to RUN when ready.

Yes, that implies an enlightened driver, for simplicity. We could later 
think about auto-validating devices by pre-loading golden measurements
into the kernel, but I expect the common case is that userspace needs to
do a bunch of work with the device-evidence and the verifier to get
itself comfortable with allowing the device to transition to the RUN
state.

> > I hesitate to keep commenting because this is so far off of the lifetime
> > and code organization expectations I thought we were negotiating with
> > the PCI/TSM series. So I will stop here for now.
> 
> Good call, sorry for the mess. Thanks for the review!

No harm done. The code is useful and the disconnect on the communication
/ documentation is now understood.

> ps: I'll just fix the things I did not comment on but I'm not ignoring them.

Sounds good.

