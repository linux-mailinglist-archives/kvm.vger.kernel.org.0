Return-Path: <kvm+bounces-52398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1F8B04BE2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:12:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3824F5601D6
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09FC29B20C;
	Mon, 14 Jul 2025 23:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NbwBZW4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA59A29AB0E;
	Mon, 14 Jul 2025 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534485; cv=fail; b=iLIxge6rSN+o9MBMpI+8/t1E/aDoKB6AVCp+2XTg+0rhnQEUtpaCfsD7r6BImMMmFEGUQO16YKrBlyx1rGM+SaUz2605DR7Oqa28UF9U2nE3SVnIjGJO3pAv1e3PkO+T+70Z+wwEBxjWBAs9WQVM+cgXakP/E8qwPrym86rIKV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534485; c=relaxed/simple;
	bh=W+Trc7RbyomsP6MZsQZDH+5zqz7aQMe9/CBKt+hNXMA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mh2q8ILRuDnjB3RhgDiQBG63ns1mS+BnD6Gk9RQdMSH28cyNzuUzGyPVqIcuAulKOyy7Ng8rWr0C4NQ9wnG/UeSkst3MCgrdSK5tmnrZDF1/zcjVLKv5nrEHxLNRRXzndy5qucSNG5c7FobOcFH6cZEBrZTJzbFRgihQudLVLJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NbwBZW4Q; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752534484; x=1784070484;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=W+Trc7RbyomsP6MZsQZDH+5zqz7aQMe9/CBKt+hNXMA=;
  b=NbwBZW4Qnisoh2P4f/9MxlyBXkAtvj4se7UokbKUcoyPii6QGavOewiH
   qaSpJmP5m/YnNCw8TJIEtPsHbafOt3J0XiHyEvdfcgVhfTK9taOqKdVxS
   vld64xpRnnQzb1PNxxWSaBdUDPSf7PsrffjxroBK+TknyWi5fcE+cM8hF
   HZfdSPmiT4IZ4rkU6qzPW23/arkNegLJlH99jF/va/D2rVO6wspX2UR2E
   qDxj0YnV4CzEl4Cr9O42dx3nG6AbWjy4E66mBYG1v4LZ+Kq+Ozu+w6AHr
   eDgr0dM2Zy06D7OEnq9Fp+36qQKx+S7WIPzBoD97sKw3UFiOLWHMVx3Yi
   A==;
X-CSE-ConnectionGUID: lgp8xHfhTjmfQbCCUUFt8w==
X-CSE-MsgGUID: 3EQWs0mnQXyTl8YUlOoBMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66098769"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="66098769"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 16:08:03 -0700
X-CSE-ConnectionGUID: ng7hWHsvRTanfJf/N+ogQw==
X-CSE-MsgGUID: yfElRwc1RGejiVXm/PSKyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157155348"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 16:08:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 16:08:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 14 Jul 2025 16:08:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.48) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 16:08:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqPRuWka0VxsMqK3hGIXcIsBmL+Ky2mZgzYiqNRJFEl6zpzPEEwbqmUn6mELRhCPp2vfFvjL8+QCCptk2QB11HrLOc+E3Ew98Fsgo/hH+T3YiR/57P7azSepk3amFuMdh6ulCATPt6/4a2XsGq8/6+EzcFPtameKuXpODUo7EjvCVS9twLUhOgWRSmO2qawRm0TS4/D0CHip4HIBhnwKDLcX/2NOGxwV/j4QP79jGecQoBvqx9cSAUCbhQVfEIDpR2ecDE64/vdsCV57nZ1vtwEwlmdiLlGVPBOqWcTSWR3QMCh93Q9S6EG2RwQbw6ZkPDrT+4uK1G8QJDMhMh/VcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJoqP6LpT0rDwrDM4mS0G8GQli4bBJ4VM8e2vZz8q0U=;
 b=XFvZxMqI/lGmvdn1jCJZ2+M3JcxiA3TUeA8lfNzeYtZYkN3Ve6iVfeFzzh/etZU6OK8OCnSnZuAMAlOKRUY2YcNyPsBKaG8A6iT4axXMevmzwbfRESDcZXz6pJpC/7MOWENBV/BxaT/MBWQNRAH8dS/spUPnJsizHdeAyyJsSzn4jKh1QucW95lJKAV7Az7cpN4Qd1CvqINJRoHmfb8sH/vkY7oa54xCcDO/FiE/KRddAecTIG7qXxnMtpUb0LWnYVPWsS+7eHoVg6cKr+ThkA33KisPaUBCRQDWztUzcjHS8kM/zCHNz7aX4p3nqPSRzw+G4YHmgqYULJtFjASbhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB7755.namprd11.prod.outlook.com
 (2603:10b6:208:420::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Mon, 14 Jul
 2025 23:07:17 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Mon, 14 Jul 2025
 23:07:16 +0000
Date: Mon, 14 Jul 2025 18:08:49 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Ira Weiny <ira.weiny@intel.com>
CC: Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <vannapurve@google.com>, <david@redhat.com>,
	<ackerleytng@google.com>, <tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <68758e01d3ae4_38ba7129493@iweiny-mobl.notmuch>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <20250711163440.kwjebnzd7zeb4bxt@amd.com>
 <68717342cfafc_37c14b294a6@iweiny-mobl.notmuch>
 <aHGWtsqr8c403nIj@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHGWtsqr8c403nIj@google.com>
X-ClientProxiedBy: MW4PR03CA0271.namprd03.prod.outlook.com
 (2603:10b6:303:b5::6) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: da1abd28-db56-4322-f038-08ddc32b2cff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+0+IgdtUmLoL3HGLu6DZj9GD3D+T6lVb/32qQzRbf8ODlmqDbGJPVG5wEl1d?=
 =?us-ascii?Q?mj877qx3xgodjgWx/9jWls6UTltT7vGLHPfiYxiXe6E7swG4EWEJhV+Jdz3G?=
 =?us-ascii?Q?wQISoP6m1ykJqwYATuq3P15SrjiXRc2KR3uMt1/zD9b0+x2eSG36vuqxw1Dg?=
 =?us-ascii?Q?0rdQNxvB6aPONF9Lpr/UynAfs2gcQt6bpvlF/EQblaeben3QtjC3p0BR7ObF?=
 =?us-ascii?Q?YWiVS+M/TvhA37k15Tdxx+6o1SiB6laaUE8k5ROVug+9aSbAzC5N6K25heD9?=
 =?us-ascii?Q?zXffbhRvTkTyAd81qt5alKVxAo9CdbAn5N4gwR6ObuSgVhDZEAKGMHTVLvYX?=
 =?us-ascii?Q?nLNzvn2d+JJI638xfWDC7Am6yCdNlsg9lBGYwEZEk4sQb55/NAAhlNW3siHS?=
 =?us-ascii?Q?hFgAlJDtiyphJWO3lVHNjFSAg9cNEKsK/GXgzE/RR0hm6wuruZ79WQp71MJf?=
 =?us-ascii?Q?RcPulM+4sRsQNblesJyXXYqLYW2Qf2Bk4OC1V3g64EkK0XQKzsQWDrciPMkm?=
 =?us-ascii?Q?onYX5m3SaiYoZLDgafl7NywIAZtZfYwz3HBHNe92Qq8k5K6Lbp20h7hZft6p?=
 =?us-ascii?Q?XLnBM3emGJQcE4WdcPHo4TbGqO/0D7qf98JrsuAFyD1c7eMqEyOAz82VJfBf?=
 =?us-ascii?Q?h+EUST6tyVT3rLX7HhVpGpApeftccX/wAn6iEFsVWWeibHE34YCLjRTR+m+0?=
 =?us-ascii?Q?RHfUtVY0putXL8KboOlHSkjzQ06WxYdc36kGgPTG+FFUpWz8Vk+bUq7VVOWv?=
 =?us-ascii?Q?Ow69RTFFusub6P/uTMM7A/MlJKu6KsbH41cBXJwCVe8tgb1K/CnIeETrHi3Q?=
 =?us-ascii?Q?ny8IuuK9h8mYIyTbpekLMBWZygq5J2AsffiSTqmJadk0RdYSoX3j892Enl6W?=
 =?us-ascii?Q?yj+jr8ACd4cu8Nxyn64u3yK+0URSK2+mK2r7Ft2CbSzpgfmo/tunWtOK9E/F?=
 =?us-ascii?Q?wYd/j/fMuEEq9tzlFLJ+VuKn0SaWw6CykO8wEjkSaSVQF03YsEDfCLnniZik?=
 =?us-ascii?Q?bFjA4f7YK9rC7PHVXo+0zMc4Q/gxNc4QnDfTzch8cA0472zXsDwmCawAVsXU?=
 =?us-ascii?Q?qsixiUo3/7MduQxaNU+Vsd/HeqG0cDwZDIaIj7X1BBLHDdw183kQUQ0i1oT+?=
 =?us-ascii?Q?DLtUlM1KQki5m870aheaYlN8Sl3ai7Us5VDbEPxDfZwDBhMZ43Jq6fk2WdKC?=
 =?us-ascii?Q?CrH7MOVmdtW6kO1bcb5NbKeCZgdjuJeg1pnNdsKj/XH/+ov2cOxNts30cjaa?=
 =?us-ascii?Q?cNSmJqmnOOX5ruYjbY3WTUNuzC/kPEbMZT03H4vMRtq8L7IqczPIT+Qz7NK7?=
 =?us-ascii?Q?j9IMTWxcr1UwxAk+177+lDd7Cw2cDJn+PaXHIVrD6U+6pg1O/MK9rO95ENCh?=
 =?us-ascii?Q?D9p7mZ7KyZ2qdO2j1TxKJDyHC0QKijBBnpy54kK74C6BZDEaqPUT/HVs9xGz?=
 =?us-ascii?Q?xUgFBoWp5WY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uRFSlnOjpv7ApzccnDIjXwEjxRxKx4UjwUwxmMyZOlYVPqxCd9CVZXlB/H2O?=
 =?us-ascii?Q?Bg3SSy+eNxrqG958484Eut+wmEbAfuLUjppGrB8SZSyKg6jEl6XQucIy3drV?=
 =?us-ascii?Q?ssUs5BmZyQ/RxMTi9A4iWUiIZ/LaWj2wvxsSaqcTr98bkLX2WyiO7lgO0E8g?=
 =?us-ascii?Q?RTYofVwErxENhXSfiZ1glzoAOZBP6vUlkT6d5VFHy0sp4XFbzrBdlISRVM4H?=
 =?us-ascii?Q?v9kF7K9vTfeLaJD0JUe5bsMq42scaaZqpDjE2l3oC5Ah8jG4xrVBTCZu2NLJ?=
 =?us-ascii?Q?h95TQOdboK5eaw3ByYhe0e4V5duMbADf9/qWQCmNqHcmm7SbM9bY8NM/myuM?=
 =?us-ascii?Q?WtmrtyUN0SFeLFvE4cydzwFHti7k2Nqno0ZE5htGvIEOjIiNpkWomRDorJfj?=
 =?us-ascii?Q?kM0vUln/g05ojZ01e+E8Z2DBO2ZE+8339QK4hSCW4uv9NKLEZHopiv4NbZzW?=
 =?us-ascii?Q?hEAazlVC2ghLJAIrFOxC6YpMHMhIen98CuM+rNb6x+OzP93wGNjkmwPSyzGA?=
 =?us-ascii?Q?ZM0X9HK0EIXpEthN7dSwvdAKe5xB/3Dl7WtXjbWCa0mFUutHVUignxP0O/IG?=
 =?us-ascii?Q?d3nolLOXfuKWuL7WdFgISn+iHD7KnUv6FxdJukPSkPx57Y6Hoj4WxhzBTsOo?=
 =?us-ascii?Q?XYKli/tx8OYVtJB0WeY771YKyThNXahLjngvmVjgKPYEBFXocSziINPEKLVG?=
 =?us-ascii?Q?yw8mrj7HwNXVQ5pJVG2Q8cH6onkktromvT/QTdd4xAbji75Xkb7KiscyoRdy?=
 =?us-ascii?Q?r5GMkJZcReIaczp3TbcOE5EAKhVywdLMm7uw4N4BOEToQrYFpJJdblnOiy6s?=
 =?us-ascii?Q?12B/+uv65aLOU9I+nvEfk7pvPgF7VaeUrQgDsGjjl4PSK9aLNrtg/AlS0/i0?=
 =?us-ascii?Q?Pc0R0hkGnTTQy5/pFFg8w7mOuLtbOwFOVx5N3Yw5KGrYo7nefmCUgH7/0dnE?=
 =?us-ascii?Q?ymQlw2h7SaaJegnQgIMmAwZ1VhnWXALO03li6oWn03YSoYC6UqaLdcYQS0+g?=
 =?us-ascii?Q?7p3C1xsKATJ8WIR3vIoI3XSp1LELcp9fJ44NNOKEXS4t7VVTvBgFPl7rAudo?=
 =?us-ascii?Q?x+cuPx9aMH0AFzhIl41gwZ674nxn0Pvyje8j9UsOIGC5e8bBYIEVrP5vx3MC?=
 =?us-ascii?Q?rcCBRGiAI4eYe/H4PmAtmNkv3gTHsrCI+hoXQMmVQbs9qzEdX8lzcZQ2ZLyw?=
 =?us-ascii?Q?8jZJ7cfqTpTOB1XP4dzxpv7sbYqRg/ObiaTiubT/UGSTpWGHxrTE6+RM3dpy?=
 =?us-ascii?Q?I0Xt8uHLCUGgMH/am3gVRbdG2ejJZbWLIVbwUya+h+qBXtrlkSkeEe+WI1xc?=
 =?us-ascii?Q?bS4H2pD7mdJ0urBqNDu0HVnwj+Bw4sURe6nPm0/xUQ6ZzDdWT7WJyvBMK3C6?=
 =?us-ascii?Q?6zTSGfN6hf0DGzKvAlqLPV/Bnt9y1dV0SpHxmOjH7jg9mMpEev87fN4YCPJD?=
 =?us-ascii?Q?GQLl4LpsgfIr5UP0kHaq6VmakXBOo6Lo3kuLp3PRWPpLnDfJwoNEmqcFEf3k?=
 =?us-ascii?Q?NP0P0aUVyrLgQdN45GvAufXn0t5AJa6PGkbZ/qbElrWLOVNUHqy5xopmNEuI?=
 =?us-ascii?Q?0m9BHhjGQeX/y92DRN2BeEQynNg216eKHP/GMDCR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da1abd28-db56-4322-f038-08ddc32b2cff
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 23:07:16.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkQEtV21Ddw/1pgsro895yY7/h5dM90n+LK32ZYiYMACVj0waSNDue45fB1EZCX6ZGm5PDuGltgAFC+qIes20w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7755
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Ira Weiny wrote:
> > Michael Roth wrote:
> > > For in-place conversion: the idea is that userspace will convert
> > > private->shared to update in-place, then immediately convert back
> > > shared->private;
> > 
> > Why convert from private to shared and back to private?  Userspace which
> > knows about mmap and supports it should create shared pages, mmap, write
> > data, then convert to private.
> 
> Dunno if there's a strong usecase for converting to shared *and* populating the
> data, but I also don't know that it's worth going out of our way to prevent such
> behavior, at least not without a strong reason to do so.

I'm not proposing to prevent such behavior.  Only arguing that the
private->shared->private path to data population is unlikely to be a
'common' use case.

> E.g. if it allowed for
> a cleaner implementation or better semantics, then by all means.  But I don't
> think that's true here?  Though I haven't thought hard about this, so don't
> quote me on that. :-)

Me neither.  Since I am new to this I am looking at this from a pretty
hight level and it seems to me if the intention is to pass data to the
guest then starting shared is the way to go.  Passing data out, in a Coco
VM, is probably not going to be supported.

I have to think on Vishal's assertion that a shared page needs to be split
on allocation.  That does not make sense to me.

> > Old userspace will create private and pass in a source pointer for the
> > initial data as it does today.
> > 
> > Internally, the post_populate() callback only needs to know if the data is
> > in place or coming from somewhere else (ie src != NULL).
> 
> I think there will be a third option: data needs to be zeroed, i.e. the !src &&
> !PRESERVED case.

Yes, indeed.

Ira

