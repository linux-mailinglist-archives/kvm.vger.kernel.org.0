Return-Path: <kvm+bounces-38538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15876A3AF0E
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 02:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11933170310
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 01:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC7113D891;
	Wed, 19 Feb 2025 01:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiYzV3yQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EB91DDE9;
	Wed, 19 Feb 2025 01:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739929492; cv=fail; b=WHVhNd7th2XVVBkUjDokpNGapymby/m99qNJ3g/lpJe6WV66YSNPGfswOXLSQAKRTaj8WMyVPmbO1wHjTN5i6JjgyjzBqH7U15RhrJshBznvyHpNx96nBnDMIUzsWBQuwnDLZj8y2h9uw7v2GlpX2Imrru1McNlSCiRcoBFZw5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739929492; c=relaxed/simple;
	bh=tmw3lPkDmBTL7ZHSDJ+soetfW+PWHvlxPOOads89Wu4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Rzc46COTxKHze1R454usA8FQ3WBNDt/tTRnHpNLYwBvWXMsCxM67GtG4votzXA1azAkEyzYuw6fByeQk257LGrtYLhI5aoCnvcPgCkQ36VQrRxClH6LKJzvB8k/UfNmdzWATyDsFwVHOPGNWAHF7Lz6txdhuK+ywpEM1TrKaqeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiYzV3yQ; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739929491; x=1771465491;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=tmw3lPkDmBTL7ZHSDJ+soetfW+PWHvlxPOOads89Wu4=;
  b=fiYzV3yQDFepd9QhKiy7jQwriOB8KsDBilqtfxWKTGfXrzeEjLPyHjws
   hsqHwssBlp/Fd4rlrMIPEzHO499YFxaIEsDt2+R+PK+f2PchCd670dteC
   NnuPxHk1PrW8LvDaMQZ1QNYCr+/bXWSXYfvPrJKQRhJu4NPba3qFgOwrb
   2gHbCT7YSojIcgdj+jSXtkKUp6SOYa2JF++lNmiYINJl48vTianTtEXIa
   ZevLjkeTpuLd8D/uQxZLeMeK9GRENu+ex2hpjFi5bVbzVWZP7qQfuMSTt
   9c6xvwGCWzuF50VaZ4yM82ZU3deZ5BP1zqiTjMh5ZerVRtyq49mMSvoVV
   A==;
X-CSE-ConnectionGUID: fP7W/iKMTgGronyzAxstZA==
X-CSE-MsgGUID: vexRm2LjRzCIvpPr66Kh4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11348"; a="44568264"
X-IronPort-AV: E=Sophos;i="6.13,296,1732608000"; 
   d="scan'208";a="44568264"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:44:50 -0800
X-CSE-ConnectionGUID: 2v1eo5eDRjqSZU2m5cSCcw==
X-CSE-MsgGUID: QCfGs4y5SDyCeG2l1oZRzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="115044745"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 17:44:46 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 18 Feb 2025 17:44:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 18 Feb 2025 17:44:45 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 18 Feb 2025 17:44:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XN7I/ltVBqmDz46hudnfCRrJHw55+VaPyVLvnQecjwkGBcDsAoQxlet1p9/GF8dSTvHIoPLSrGxmy6QzHuf6ymZW+V4ulH6uAntn2RU4hG1ayKzCmSPA6Pkd9qqGWSOUVNFJdDOlLBifSbIE7RvfPTHJgMhTqMCQqFPlTYnx8uYP7His4FDNayfRrSa2BUU36GsBoexv72apTiRXphcOBVertj8XoRqau0x33uj6XOvPlAhLRHe4Un/rS6BdpJJs/xGwz49aGxEWM6LxoXu4y0Rpmh54x5cm/DjH7jkwJPuEBnB9bOTvAWEn+qMqnUAmhztZiTFRTZOII6gUdTiGsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmw3lPkDmBTL7ZHSDJ+soetfW+PWHvlxPOOads89Wu4=;
 b=f3Dei7ZfiUHcFcJp3jWS1tns868X7pHn/RpVPhGV9p8dZ075LP0fnjQU0xDiSJpvJGFiKrgTN11/5XStNOMc2XvPxv4ruLDBOlCJ04ttLfuV8xfky7Nc+6B8qHFGuK4R0NhvRTShHvcDtUbumq852LK2xcmJ/BaVyvaa/7h+kZoYmSPNIn0WY/dkyYaPhiSVlIWEUswl4TfRpIQINNh/rEqFq/rk3/jtD0lPpQf0nnrE55zERyP4J6BzYdfI6JGknvy8m7yXFnBx9laNCZZEuu6UDq8OSryVn+KmQZsCyZbNQX2Itm6Q6J9QJs6PS2GBb9qIM0AJtIEiJ4O2PNeo0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 01:44:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:44:16 +0000
Date: Wed, 19 Feb 2025 09:44:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 0/6] Introduce CET supervisor state support
Message-ID: <Z7U3ZTL/xcVPnxDM@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241126101710.62492-1-chao.gao@intel.com>
X-ClientProxiedBy: SI2PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:194::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: e17059be-5e54-42e1-7c50-08dd5086eb6d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?b60lEonHiH8k0HLTZJAqKrlAKbpWcgfK8y25KRfl5KFuY9KRhACYfV1tztsP?=
 =?us-ascii?Q?cQ6HAv8QtBYtIJjKHGstui3NSFAon4DgImvPrTerU1xgy8zyCn8+gj+urZII?=
 =?us-ascii?Q?Gib4vbI+Eh7ZagL/GmjYXcLi4cZ3k4p2GGmMt65ZjGdLy1hivIc3gL+7fIFx?=
 =?us-ascii?Q?t0am95Cxrobh6bneHu6Sv6akNhn8ZHe3Axuh+1d18szqcMa/vjIs2PqH8aT4?=
 =?us-ascii?Q?nxAdnO4N4YEhkepKPRvI3zCuJsmbZJX/scuBTVPT6rvsXidpUX1CYO+rfS6E?=
 =?us-ascii?Q?kodKFQCCkOPTv+XjFnRGLIVyhp7FavD86Sp1V5UwTMzZ7y2q6/8N0dxIeP1V?=
 =?us-ascii?Q?BPQV+nMdDkCiUYI+wqgUmLmCU0sH1PPq61d8sypchNzB/PWILMs4AVlmuXnu?=
 =?us-ascii?Q?0GH+QNCzveaYmOX9G5ktCWEmqH/ySW3mmObC9D44eqG4yxUv3GlV2gaES8J/?=
 =?us-ascii?Q?y4vovnX/iUSJ3nPFlzxekTTCz3rsfX5p6t01yw1FKp5U/tRsbtZeZp2+qqEw?=
 =?us-ascii?Q?IIPQGAW75qgloOVOLnbQwy8jfNsvgOQU3uE1N99cNfGSwgIs+CqTHdyEwCet?=
 =?us-ascii?Q?mkLTlRIY4ytqzDNdmoD5zxYBLiI5i6ZvppoZz4U6DQuvRJC4DWr9rOOUXEfF?=
 =?us-ascii?Q?i+MEdFmesH5B2X0fFukDH0c7Yw1rOKA+fCYo3xrCUlzSojMoJmN4syLLZnwa?=
 =?us-ascii?Q?evBaxzIGxvrGr/ShHMh70cU20wLBAC6DRrbGr/uOBzoYKrR5GK1cjSqfcb5k?=
 =?us-ascii?Q?iGkAP6y+dG3mrc8y4ry2WmcPJurltY2+dAsTRU/u5I22PBXscEAJl1NX2QBp?=
 =?us-ascii?Q?58aEQipvWKAY/30Rv3uMnp9ELepMvcoIoQDEDew0YSa7HFLTDp2bbx2aBzMc?=
 =?us-ascii?Q?HDUN+pAof+CYaEnhuMiqm3//ECMaxCDfM58dxnIym0rjP+cuzcNSXHwRP73d?=
 =?us-ascii?Q?wN6nbV9lcHTWCWcP4lzJ6tgeN9mfCxtfMx3pwjMYvDk4lfGQwtvF8jK+VNtb?=
 =?us-ascii?Q?KgcJbYx7bE5kCaNSRY6OmVXx/6vVH27vakI7itUE8kGs0DOlM2yPdW9CF1hQ?=
 =?us-ascii?Q?MhtLmQ6TyXDUHPHJCMJqyMRZ3IY2RRIqipHmWC4pBcONnILEbJw7vzVaKdbt?=
 =?us-ascii?Q?puSUlZe/ciAJLIj5c9S+FWcDVPFsmZUaXDlDb1i9GwsQ6wvE19rTjGSauX1t?=
 =?us-ascii?Q?w1NvTT+TLjfQbyxmy1c4PKS7tu/EC0kQ4D1TeCzS7nlEZR0kJOkhrxXsB54B?=
 =?us-ascii?Q?ppb2tHQzm+hX6DWvMSeldjnYYrZgHfnMfrF16aSINmLmMY/jw9zRrISjkCGr?=
 =?us-ascii?Q?mgFbPO5FIrfUzFX2FBQ8J/ugUsavouQd0rPQcVMlsnX2x+drzlnk5VVBhD6a?=
 =?us-ascii?Q?kYnZEQTqG01O4FiRAfx64+l7qTPU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yBEeCh8GKZqez1qit65631snxZgVK2xUVtcOz9mQEUw125xGaub7kEyqYbDz?=
 =?us-ascii?Q?SUyv5qVwP72F7IqYA34X1tyKwkU6xUXpSmbe+82tMMTtLc7NEF9HLuFrtGuZ?=
 =?us-ascii?Q?xec407lanPRGGIzUTSKIIg2bjNrCROQWuMp0FzE5kUAVkLNKDsUoi7RGLqYX?=
 =?us-ascii?Q?H49VUB4DAc4v9nymMheY6+hposv1PdTL9NZYi+roF+dyRVsAgB/QiehkOQ4Z?=
 =?us-ascii?Q?mks5PpcWu7sEuc937deDgubvgNIqxibUt78nSyHDsEVpPs0oRKDWFSQ8fttl?=
 =?us-ascii?Q?zGOyynO4bkh8UpTFbIk0pvZSYxGw9GWIJFQ+hhavJCKbv2AtfAeYCbgo4z0a?=
 =?us-ascii?Q?cfPfTKRjjuuY+3CO/TDf5z4sgcGY+3ws9v2cmSfbFpLoMU3i2RTsIYDPcX6g?=
 =?us-ascii?Q?HlB43i8XVZyGk41AT21CvtlOEVLbGp3i0CHKcuy18AucjpQDVDkkvU7tK6Sx?=
 =?us-ascii?Q?DJQbfKQvSAQC+b56DxkdTAMX20RFBZJA2sYJgqGZQ3e1mfeIfq86X3ykCKxW?=
 =?us-ascii?Q?T2o0eWJhHCGS6m97OJV6mi+QU/4EkexrBX9+xBgyyld8w/2jhW9qKiK25+CT?=
 =?us-ascii?Q?mAS+52jHF9agqtFSspdzEb6igPs2msjrMq9udeJJM4Z03IkYKc5xOQFYabwP?=
 =?us-ascii?Q?P2LqdaV+E8JEsnRUk04O2/ID7+tp33zgKGiJ1PyWU1X4oJLzgeLYw5eAWq/Q?=
 =?us-ascii?Q?vnq1RZDeTGw2lIrLDVA89KzB1Z5HO6qmKEb2yEnHkDmc2+GYSbKDHp+g96G2?=
 =?us-ascii?Q?2CmESntvcQFK2OnMNvs5hxKOr1/1t6+Pg9Y0c9LmRxW/+6qZyvAAdmnREufZ?=
 =?us-ascii?Q?UgEHJSvn/6ijSj6fArVw6SiMUHn3VWZSNEmQ17St5GE9iVO6VUTsIC53Glrs?=
 =?us-ascii?Q?cre075X41sogBWtM6/61V/qI8zsupx8hha31BRwDbBEwRBUWehUIBUrbsd6U?=
 =?us-ascii?Q?MxGGMS/3PyBO/KKcBnWgMVrGeYAHc+fBc4P6fP4Q7U3Ct3NfhMAl5nbmBEwu?=
 =?us-ascii?Q?ZREO+F02KajAFRKmjtHUGxj6lsKA92JnDIjNUD2L/CxY4/JNQNa7chotbWKX?=
 =?us-ascii?Q?MPFY2QmnSl+bqgMpCxhNFjzm67O+ovQeCMN2t+AULMw54FZ0esaUuiGKsz2c?=
 =?us-ascii?Q?Xbjwq/Z+amzTZsEzvyru8/CqvxUgBnrIwEcwZBhL5FySCa0mfAkE9mhDrGH0?=
 =?us-ascii?Q?mRNkTidiba+7nS4uhICU8v04HNIWoozlK68aNqjNURr5YgZf7rtpC5gYUajT?=
 =?us-ascii?Q?cMSpE/pG/0aay4B6Cvd7UPsZRKpPoRETg3d/0EWE8gwK6BWau1ccM21aqfmN?=
 =?us-ascii?Q?aYD1gqXybnmCRH/fqIvkXfT1IgIHknIK66w8XAZ9Ga6CkYnVKVSdZbQZ1WVL?=
 =?us-ascii?Q?DjHBLDU+SyLharv9U+vB2W0RtL4x4513rFm/5DlMzCvniG1ctvtpyKydnE9S?=
 =?us-ascii?Q?P0iGQWec98mkc5joI570i1x2XGUvWPkNYywJspAJhqd5uW2qyJRSQwSQMGBp?=
 =?us-ascii?Q?d+Zc9zNtGnGxi++EJWWSx9mXFH8Qbe1S8cOnQonHOa2qz7+Sp30jarsoUg0q?=
 =?us-ascii?Q?f0jnPcHDl/2a9Fi5wxyQXE1smIIw9+ZCD9FQFLID?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e17059be-5e54-42e1-7c50-08dd5086eb6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:44:16.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3l5KnKiuKzF5CyUUErPErHcwWQrNrruD2mK0hdr0dJHTmsjQjw4vN6Txt3KVOx1wMylvdINKjPWSzFYTIxvqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com

On Tue, Nov 26, 2024 at 06:17:04PM +0800, Chao Gao wrote:
>This v2 is essentially a resend of the v1 series. I took over this work
>from Weijiang, so I added my Signed-off-by and incremented the version
>number. This repost is to seek more feedback on this work, which is a
>dependency for CET KVM support. In turn, CET KVM support is a dependency
>for both FRED KVM support and CET AMD support.
>
>==Background==
>
>This series spins off from CET KVM virtualization enabling series [1].
>The purpose is to get these preparation work resolved ahead of KVM part
>landing. There was a discussion about introducing CET supervisor state
>support [2] [3].

Gentle ping.

