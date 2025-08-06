Return-Path: <kvm+bounces-54083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 923F9B1C03B
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 08:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFF4617A494
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 06:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B5020ADEE;
	Wed,  6 Aug 2025 06:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AoddKYK4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94442BCF5;
	Wed,  6 Aug 2025 06:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754460408; cv=fail; b=c+iKy7+usDuDc9CebR35+LM/r+VddVYoLnLOWklEvmLw+bskytWWGZJ+FhBLQcmJch9tKMNkkkZYMa+10kRbDO3jRY7Zx/qrS2R+oBw/uTLa089yABJeUf7RjFS47bH6iOULnF19iwoCfh/3jJAEweWoZchnr/YyCdCzKRherE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754460408; c=relaxed/simple;
	bh=IaEVB6Bm+orMAyTrDBPkbyXVR0sqPT5kiKuKM9wWwpM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fHjbLIAiNtO9nuVmUY6Z+Jj6wP1UmzIX1fovo3VACawUUpdWHI11PqyoFhHrz6/bOzuRtEdUwCWDh+A3zsYok2Xh2sRvOVsUuE943dI+YA/kr2UbaPUPzrV/lx2TQrQRMUuIieNARp5/AlS5I697faL5wqwpkrvpj++CtFGSTx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AoddKYK4; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754460407; x=1785996407;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IaEVB6Bm+orMAyTrDBPkbyXVR0sqPT5kiKuKM9wWwpM=;
  b=AoddKYK4c0qqUuouwjenkh1gLUcgwYEyAzDZi2LXxZsLkQp6n3wwhW+D
   sy1kKTEtx9Gkkl8Mqf7ocacujGMs7RNhw6kHVHrWZE0/rtyIHXdi6qv6g
   6gNnWx398XZCYebWdzkcoG97o3gUXcnf/+vIjYmr23kXYCoQQSz+XXuK8
   FLQdznSyWnakCPQxWCDJ5W2m5UvrK8mRRHnBPc58Rmfs0U9lsi8+NAecu
   k/vD5OpXQ7vvdfYbfB2Rp0Be4SSU1wQLrUv5pr79M9SLRUCWjZm5zXGIA
   kPoCfVO18G55tS4NZLVvAeQA2C7u119MTrGN7PGucwT7u08qdjUBuq6gG
   Q==;
X-CSE-ConnectionGUID: nlR+NFYvR+2r0vP6q9cN5g==
X-CSE-MsgGUID: CyP1iGDWTNmIZMXW5oT2cA==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56910694"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56910694"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 23:06:46 -0700
X-CSE-ConnectionGUID: JsAA5uJgSM2v/9F94MsZkg==
X-CSE-MsgGUID: 8WXOBm1HSG+dPOrHH+2sdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="195523709"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 23:06:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 5 Aug 2025 23:06:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 5 Aug 2025 23:06:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.48)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 5 Aug 2025 23:06:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tONbkTz06t0+fkkfbPoWDDOOlyqf464hpsfxvjnoh3ZvLYjwfdcxHmfalzuMxrPH64hHbZbGu6EgfukwbtNmyTO0lvzAZXrr4ITX40/BUO973SpiZEpEuidW2RgQ9EB2ONJPbPylYHINKZgN8JEBy9paZY+z6zZSOr/cEiIKlsDuEQDHyVXnrvB7bhkNJRwyqpNVMfVowCoCEDGJBHY/0WJ6D+kj1rEgNfDm6c5qXiovuxW/xsbpMKN9YRkmPeXDHI1npLfw8mdyTcKwPcwZLfnpdBJuRjl5cEAXpFPZiV0JEH9nPwj1BORRaeR3Ef4kXpSvFzenHIIjHngwEozSRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBXSyvBYnRLDq3IqifQdk1Nhhx4BZ0P0e5sajOn4fbY=;
 b=xrlI4eNVsqhDvOrAHcILRScDO81i4TEeI/9Xn48vOkvaUFkFa9rR/Co7bCyW9RywCuhFXdAEbdmWa+Kk+h2F6PpG5O4bKUMeIxQfJeNrataFujl3kwBZnXyA/FLY59NfUieGSsffAHj4MQpYDppZnAbwpY2IHnggb9qAaf69JO96xBbtkXZA0BnXo1XIRMgPu7TIO45dGKVg9Krl4I7ikZw7n8MsSDndptWZmATeJn7fiR6eXnajZoSZJibRCZCjEJLBlV2dv9XbKpsEamPcmF4StWwlGAyP05Zhh/FXVSlRfRBL28QdAx78dpg9uc9siU9QgIATb/aLIcmFT2YZkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB7534.namprd11.prod.outlook.com (2603:10b6:806:305::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Wed, 6 Aug
 2025 06:06:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 06:06:43 +0000
Date: Wed, 6 Aug 2025 14:06:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Adrian Hunter <adrian.hunter@intel.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Vishal Annapurve
	<vannapurve@google.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Nikolay Borisov <nik.borisov@suse.com>, "Yan Y
 Zhao" <yan.y.zhao@intel.com>, Kai Huang <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 5/5] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Message-ID: <aJLwFaJ5g2WaMwql@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-6-seanjc@google.com>
 <b27f807e-b04f-487d-be13-74a8b0a61b42@intel.com>
 <aIzu4q_7yBmCIOWK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aIzu4q_7yBmCIOWK@google.com>
X-ClientProxiedBy: SI2PR06CA0001.apcprd06.prod.outlook.com
 (2603:1096:4:186::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB7534:EE_
X-MS-Office365-Filtering-Correlation-Id: 55679909-3594-41e7-39d9-08ddd4af6ace
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?r1H+7OavHH6ZFGwYrcibGRR38mjFCL1O6Js1nb1j3ZmkJ4zSSdmgzuMgHb11?=
 =?us-ascii?Q?s3XDG584NrabWmo4Tq8rTqNd+elSb3uXqPiINnlrWV4sNinYlqiUhyqphfKv?=
 =?us-ascii?Q?5sol1JCIpq1iR9nLpFIJ0EPJ8BODVbkbzHdePUIa5cSdb2ebGLpErv0+RjCi?=
 =?us-ascii?Q?RG0wta9yd+L0be5PkE+YUmEZ4Jf2Xl4Z3UnzcBFox8cuSGD+i5384MB/ClP7?=
 =?us-ascii?Q?dNq9zkzNJtCt4jJp0+e3ZMZcgza1o2uYeeOSWrDLrpR/l3juuqQpB2Dwu8zn?=
 =?us-ascii?Q?KtwB1MN2S3MHpwzyIjg3jlNROptlkvvoHHASfmwX95F45QhyaXTnRIjQKmqC?=
 =?us-ascii?Q?KwBHXC17Slk8YBF1xYOD3X80+sOVauqfjNANhFXJJNEng7SDruiuPzpLcjGa?=
 =?us-ascii?Q?n3z2N9ou1all6PEG7MogSLHSKsygFgKYx4j3LbsKlE3JtRm9s6dhi5FEAVwl?=
 =?us-ascii?Q?92GBbB4CO7cpiI/jUg4hur3YhnxH2WTcfP/R/Zmk+C46Q8mktGfIkMAE4y7/?=
 =?us-ascii?Q?nuxK/4KXxKw4bPQ1ADzNwnXmeujzzw7wLacxKSAGhDJSCU1A3FMFSLQYE5sW?=
 =?us-ascii?Q?lC4mMpj1tJYr6NLFe3F90++xkvThmF9lH9MDBplZ7/kon91mP1MtRH0Uk10o?=
 =?us-ascii?Q?FArCGUmEbq5zas5Jg6AlXlvuUGGVwAzpre4urIksKd08XRyBGM9zDTJ9fkRK?=
 =?us-ascii?Q?QU2WCFafF9Vnzd53RBlOCJKuvgO22cjhI8PEsAoe25kA0lje7mtJA2f17GKx?=
 =?us-ascii?Q?wnbTvLR13OQlo77YGIdTBTzDLwD7f0owpfA4hW5Eiva0hnHB6gbcBqKrPLRO?=
 =?us-ascii?Q?TalaETTg5xVqpQNH+nSrYr6du+qAzObkJwgjafmSEOLgx8FY8i2XvW8rT1iQ?=
 =?us-ascii?Q?jlHre/tMMoCxdeDMILhxF8K5uTyTFcgwndlucvPFcaVnvHdCoXlt4uc5Xxgs?=
 =?us-ascii?Q?1GRqyDXq4WRWKUbUUoJAeshp7rBbK1QXk6wNSXTthEAAoP6OqZmu4tSQtOwn?=
 =?us-ascii?Q?k01o8MdoVCsILxvXhmzetYUk66trQgDcQmrdFhCJvnJlltln06G5SetfOYpA?=
 =?us-ascii?Q?WGIYMgXo3wUDFPOvgdMBiExcNadVZWxIYxQQfqOqUu/1MEhHupWNB03RQDpu?=
 =?us-ascii?Q?vcCua28tA/j/kYSkVUWumOcxl1c3ftXoSmR0MRCyY4tLKCIoPx7xk+p/Kn4H?=
 =?us-ascii?Q?tZdutVGYtiLc3XSx4A+sVs6CRPM40gnY5C7dU0HSYU2QD71a0R6QZrpRufsp?=
 =?us-ascii?Q?y8dGCrIwxVRQ+z0PLCzU+BmafFYOw2zTzDD6ZKIQctr6TJVnhr7K/AltAumJ?=
 =?us-ascii?Q?0z/OZUHtmpRZkH8Js/12A6aGBfJwWfWbrUKY9lwIRHBzbsmgS6hkFDkDMKML?=
 =?us-ascii?Q?CiylDHNmcm5itw2NVnRLhMwWsmI7EXFRYkrIo+O5yJszj9CQdNJ6IETO/FQf?=
 =?us-ascii?Q?qSRNxnFg1AI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8hJ57mip4jf/oKwuYpPhkm/5WJtYZ+zuB84QINWLxIYpu9igR2UG+rZrTw8U?=
 =?us-ascii?Q?ocJlyMBUmOH1UI6g08lCOYKTBVOLTUa3d/DUuWB9tbtEnyxMjfWtzBiHakN2?=
 =?us-ascii?Q?SI0kiLEP0sFvz/6UHZJPt61jrXAuloZzs25HDhCvmdrxV185rh380LfUGHOn?=
 =?us-ascii?Q?YOPL6XSA7+FAJKg+FsN7kjFskuDDw5KTWvU23RHMyp5AKQ3/aIDoMANoMM7h?=
 =?us-ascii?Q?h/vf3e8k2RtcTUYzOQX0qsxMCgphW+qH3uXtu1zTIJh5tTuQMJdi1OOsJYnb?=
 =?us-ascii?Q?CP4ACzePUOdjWx1HQT0H3YzR89d8NhTGHxuTnUujL8by/LZ1mk55/IVmi4MH?=
 =?us-ascii?Q?NYzgcoEV7w7ou5/D/Y5QlT0nua0vt+BA2UcFCFAIpYNXN+9EtrxSD4assSw1?=
 =?us-ascii?Q?NmpdPnFfA8CSVPCpUVDpjdzlZRa6kjcQH3wo4v3PlhoXFUk/kQReNq+PIzRI?=
 =?us-ascii?Q?EJjQBjvgrAZbNM4yjxc6nFOFvMii7YFqNlNfq/vNpchR6PdTjVSy8Y0QIY2s?=
 =?us-ascii?Q?x8xgh6jNtKNMAOh0jt0GQ1876RZgVBXHbg/G8hlLhtulxSvACSW/uZ8dJ1VT?=
 =?us-ascii?Q?Uc4oS56iz/e5AmEAWZNYhTd4Zqau7zTnHF3fdQycPbGijAIZEWdPjHm+iXAl?=
 =?us-ascii?Q?xM67842bm7jHMebgSpwX9SzNtv9ZlkVkutLLQQBawGxsq59Pwyx+nZQH6qhr?=
 =?us-ascii?Q?wIwxI89wZSNaVAflemSyHaV5UWNkTQ4t03qKi9zr+RdJy77MJGxDBXJHK9fG?=
 =?us-ascii?Q?z6V+GQ3oywRQWVnwltdK6P5LfpTiyyPl4Wm4XUu8fxoJdV6o2bFtfBCYXsUh?=
 =?us-ascii?Q?OZokPVy5eQ0K2wGJD9fPOshmqjkLCDXPBkPpvoa50dKMOIU1rEIFYHgoUH71?=
 =?us-ascii?Q?6IF2whwWPo01XGwbXKlf0ItIbYyoOrll3TLkOibJWNtxSUhCo9u7W723spAL?=
 =?us-ascii?Q?NQBrPTFAW69UcqwsH4KZEKoykQVA63fv3hqcm0pg5H1CbCWAoH/VROf7M+16?=
 =?us-ascii?Q?0IllHFeJKumLzhBQpC87JNmnMhv7yhB1QNQCLclXSzMMQXUeJF94AKVjTuaa?=
 =?us-ascii?Q?jjkJ+5sEYrD+saEvk1jjWX+zT6vKTCL5snxfwZwTkFOdZJ3XByuYKVVb/MV4?=
 =?us-ascii?Q?j8vssPPiK00LSVhK0bNw8PzPPhon16SAnXUbZDDChqAY5GpOirzT77P5BWnW?=
 =?us-ascii?Q?weSDn/jN4obMvlh0Oe4D3iAwe7WgFpHtuViErKk45MKXpAlhJ0ljULXmsYuz?=
 =?us-ascii?Q?x7kShvZ0vr18y3+BbAXt0U0QHS7ERB6OWueXrbxIoiTGqyjjTDarNsPeSRlT?=
 =?us-ascii?Q?rZ6GVyk2syJImTE3CG8cYB3d5dpiFjnkGbJuMeEIKTCv2OPMmhNDtWFGmT6t?=
 =?us-ascii?Q?KgxbCEAFnMJep2TlSJf2KCPeuO5TnuJN89gJI1iQw3pO0tnsUP4tGYFNrzkO?=
 =?us-ascii?Q?r6rEro0xUNB6aBpTREkAVzc+C/dsW7EbaobLKOA8K7Eu3sgV/gajNtNOb/76?=
 =?us-ascii?Q?P0BrytbUu309TtDQ/s5+t5MGHdCBnRruHdmQrK5VEZsqdDaO+flgufLrHwIp?=
 =?us-ascii?Q?W5yP1zqWT2wacR2iZNYPb8VFAiP4iWXMwvlqdK9y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55679909-3594-41e7-39d9-08ddd4af6ace
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 06:06:43.4525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4pCGihqESFT79S70dhlTVbnX3hc4dIFNmvzusvW3qxPbqHe9YOjP6jO0RhEEHmrPktLE8MGEo5YfLYtUhaZtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7534
X-OriginatorOrg: intel.com

>Oof.  And as Chao pointed out[*], removing the vm_dead check would allow creating
>and running vCPUs in a dead VM, which is most definitely not desirable.  Squashing
>the vCPU creation case is easy enough if we keep vm_dead but still generally allow
>ioctls, and it's probably worth doing that no matter what (to plug the hole where
>pending vCPU creations could succeed):
>
>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>index d477a7fda0ae..941d2c32b7dc 100644
>--- a/virt/kvm/kvm_main.c
>+++ b/virt/kvm/kvm_main.c
>@@ -4207,6 +4207,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
> 
>        mutex_lock(&kvm->lock);
> 
>+       if (kvm->vm_dead) {
>+               r = -EIO;
>+               goto unlock_vcpu_destroy;
>+       }
>+

yes. this addresses my concern.

>        if (kvm_get_vcpu_by_id(kvm, id)) {
>                r = -EEXIST;
>                goto unlock_vcpu_destroy;
>
>And then to ensure vCPUs can't do anything, check KVM_REQ_VM_DEAD after acquiring
>vcpu->mutex.
>
>diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>index 6c07dd423458..883077eee4ce 100644
>--- a/virt/kvm/kvm_main.c
>+++ b/virt/kvm/kvm_main.c
>@@ -4433,6 +4433,12 @@ static long kvm_vcpu_ioctl(struct file *filp,
> 
>        if (mutex_lock_killable(&vcpu->mutex))
>                return -EINTR;
>+
>+       if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
>+               r = -EIO;
>+               goto out;
>+       }
>+
>        switch (ioctl) {
>        case KVM_RUN: {
>                struct pid *oldpid;
>
>
>That should address all TDVPS paths (I hope), and I _think_ would address all
>MMU-related paths as well?  E.g. prefault requires a vCPU.
>
>Disallowing (most) vCPU ioctls but not all VM ioctls on vm_dead isn't great ABI
>(understatement), but I think we need/want the above changes even if we keep the
>general vm_dead restriction.  And given the extremely ad hoc behavior of taking
>kvm->lock for VM ioctls, trying to enforce vm_dead for "all" VM ioctls seems like
>a fool's errand.
>
>So I'm leaning toward keeping "KVM: Reject ioctls only if the VM is bugged, not
>simply marked dead" (with a different shortlog+changelog), but keeping vm_dead
>(and not introducing kvm_tdx.vm_terminated).

Sounds good to me.

With kvm_tdx.vm_terminated removed, we should consider adding a comment above
the is_hkid_assigned() check in tdx_sept_remove_private_spte() to clarify that
!is_hkid_assigned() indicates the guest has been terminated, allowing private
pages to be reclaimed directly without zapping.

