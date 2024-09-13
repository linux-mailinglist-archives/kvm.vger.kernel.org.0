Return-Path: <kvm+bounces-26784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CD9977869
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 07:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E091EB2196A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 05:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E7D187355;
	Fri, 13 Sep 2024 05:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WQlRXGX0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE83183CB1;
	Fri, 13 Sep 2024 05:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726206007; cv=fail; b=TE2Lu2AUCexSR6YcrTjO4leYDy0WNsi7ii/ZDmND/bgP0BaBNx3RLjc0TxdzgOw5sFAH3X8iw+ImkzEeL65qTPEn4x461Q7Fm6dc+HeWhLpnZOb0MhDk2a9Odam/hoA6JmeTi3oh3o04aa0wD+wUUWgWCWbxFulwujAABvbwpbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726206007; c=relaxed/simple;
	bh=/ARFYYVRTFDopaCXxYMjABarx8W1H6l3xILusKWfOIY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CFyaNYO0CbG4N4Gw0ebBMKczUhdm2oCTR6UCpTYt3Wr78yPwavbAxOBtjGVOLefBvsrnVXrBemNvJNAQiwi4gOLI2lOZGNT0Qx+I3BLyq6ntwWEbq059ZGmVok8VaUB0mKmJRp9E2R04hlLos2D7Rcb9PRO1ym0gEmUNmzKnDgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WQlRXGX0; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726206006; x=1757742006;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/ARFYYVRTFDopaCXxYMjABarx8W1H6l3xILusKWfOIY=;
  b=WQlRXGX0Q1VKz8Isc2EBeCIktnR2HSv9TwbBMINVPIT5oJUhzwFem/aN
   XxjDCK1bJ42JHjVrOQMUTVExS5Fb44S31z/npYqZ+2RpKg7wV6wXDX9Fi
   LJAPxaaMplJaUjlhmzlOqsjqDsuySlGf5Rizkk5Cv5yKiCHoxApr8f7+U
   vSMFyzbPJSS1MuVPqijlrXXAnMh3pUkGqG5CL0U3FozUyoyyEwZJBo0G+
   2AJHvnGhMKcXs1DE7YDroSVdPRSu/W4b2HONr3sUCmEc9CmnmM8rz3IBi
   IHeMkvo+djbMYhVeab9LQTdohdkUEZ8bSM7jMZcHOxEa4kYwLi5g3zB+H
   A==;
X-CSE-ConnectionGUID: QbnSvvAzRBe19kXMGMAuXw==
X-CSE-MsgGUID: pcU5f+S2QRWO4enh533Opw==
X-IronPort-AV: E=McAfee;i="6700,10204,11193"; a="28836372"
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="28836372"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2024 22:40:05 -0700
X-CSE-ConnectionGUID: NS5ejnP2Ru6pagKU1rrmgw==
X-CSE-MsgGUID: 1k0KPpZaSGum5//iXf4kOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,225,1719903600"; 
   d="scan'208";a="68440373"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Sep 2024 22:40:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 12 Sep 2024 22:40:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 12 Sep 2024 22:40:04 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Sep 2024 22:40:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OqKekDSK30Qka9oInOLhGRn39Wvc4g+ypSKUJwiXCFBT+N4JLcqL2Ti40DeRPGYhQ0UPYuTPJNwvZ8EUza08gGqS86v18lwniEyxXEXO3UlEpnVDU5i46xjvBK9/y11JxgFOiAImp4/1JSTeLA/euvxOooqV6ITZxkhsglEAombpwYxyGJrQqqrSRFnQlpsfYCMjF6F/oKCaDEWUpHofYNWaKDwlkvOYio2IQaBWBbN8Eu1o8iHb3AaXDXaxM6/LjIYovTg1xph6qc3SUz6yQlHit52b8lgmnCxLe4zz23jVFb8LjUrovsb2xkZz8+aEyZuGUXxIhLFnjGNKx/19QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gDyVQ/gwyiuuK64ch+5C2qNnkCY567TWiKV3iV88f8A=;
 b=o74K61BLcHN+SeGngGSG0O0fqkhjwt7blzRumOWbqfPNpLOkPzDCku8gBciqeM/LVuvbnNonPLrZ3fXJBtgo31HiGUqOtaxOOxKgiHMRXcbFU1OyGX/PVnAFdEA69mJYKkh4x5S+TZzXDXNdwVuSeryAqP+bf3/pjk/mk6ed2ri4obcPXlLVjy8F7cv28/Iwh7LSYYc98gsPPOaYZHPHz/3hoQwNxU0XjbmNtsgYSzCo4wzNeXthlCk8cvT8wjjRWtN9VOuSGFY0Lbe+EWgOWs5kT3sAJ0z40O4uiZ1DVPAlkuD95c/lzACQ/5LLMo/lWB/ECpEfWu6Qs8eVmg/big==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB7732.namprd11.prod.outlook.com (2603:10b6:930:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.19; Fri, 13 Sep
 2024 05:40:02 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.7918.024; Fri, 13 Sep 2024
 05:40:02 +0000
Date: Fri, 13 Sep 2024 13:39:52 +0800
From: Chao Gao <chao.gao@intel.com>
To: Jon Kohler <jon@nutanix.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Message-ID: <ZuPQKHrUcC/YejXx@intel.com>
References: <20240912141156.231429-1-jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240912141156.231429-1-jon@nutanix.com>
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB7732:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c12d30b-858c-4a46-4917-08dcd3b68388
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bNtw/k5kXjAjX4R2YcYzk0JWcWh+UJZbgTmCJjE7dKWQJklUYr8PZXRcSpxT?=
 =?us-ascii?Q?nvE+PtZDw79mdTa8biF3fBhcVr8ecV6EHyTyxHWErNWo1HJOwpGmuPw1FoR/?=
 =?us-ascii?Q?bs06tI/yv37qGMw9YBsMfT9hfKQckE72VKGIAl5GpUyh0uNS3HUXzgcJv9Ko?=
 =?us-ascii?Q?eQkXB3x9LmWB++0FHnATWMmghvZ+Y3UA+9nt+4binlFpLH9p71oDPR0rDo64?=
 =?us-ascii?Q?G3BVL3Enm5LwkQGaOfAOqhVgcs4jFBIMLEix6g7uMk+YJ9oK+tgwNQ0zoAJR?=
 =?us-ascii?Q?+0fqKVIFHqhjZv3Kkc7sJicsEYxyVDcJOSab4iOGZALqhV06xOK+Hbrso+UR?=
 =?us-ascii?Q?CYoDUtfSDoorrAPHKU5oDxqEmxb75V4hLAG3olYKn5rlhrCEWB57y1c7GdJv?=
 =?us-ascii?Q?T8fRY0OWTC5e+osixVnGRum2/6pUrYliMnOmcFkOkwbCrcInmNDdVX0jJ6S7?=
 =?us-ascii?Q?gJftr6OZB5cME9N8odTQHp1HxVkgx8fk9t6qIlZs7onZ+gXn1lOiUiNLCMHI?=
 =?us-ascii?Q?OhbxH3tt5ULvdl2pp3tmhygkW5RiuDlRKaSgKQhWYa0ujAX02RnUOTGkalGZ?=
 =?us-ascii?Q?sC+zUNtkNLtj0ACCb8bDRRx+XJ4V8445VCboF1UBg9SuyIHGy9sXHfr4wvbG?=
 =?us-ascii?Q?Xj0WkbiV0dLfLt6jdfU8vv8/alSIwTh9WcmHwmnpKlqfyF1iQFih8WmqAPSx?=
 =?us-ascii?Q?gRv11Bse4bydxbmYe6uhclHRGcgxr9kvzONkJKx0F+HPQjo3e0Qq67tNxjt7?=
 =?us-ascii?Q?bS9m4cuALgzUpNitESbd2sEdr2oMhv4XuTeU4CKp7AQ6z3X8djcc5ObQySU4?=
 =?us-ascii?Q?Ia4lKKYRHlOQREUswulzOcnzaGZ0y4MFUFA6yoyOY4LqbnkEl9ZFinjCAfRF?=
 =?us-ascii?Q?2BNGNLfObTZ9KUp1Z94uO2uSyybcxO8qqvbqPsKk8jXPKq8mTMxoLsrRSRAw?=
 =?us-ascii?Q?TA95BTHqslz7wECyAwNFyXHyXMt1VUFHNqsuGaOX/r5koVL7gZ634HEDwq6b?=
 =?us-ascii?Q?SWnWTC3+OMCoJ7d6YmluxJBJDv6dztH1VgIo7LhWTaLIUrqRS4MJqB3yNsPl?=
 =?us-ascii?Q?godJ1XlDU6KhLPkHMxHkr/Q5IfZnsAp4wmc1fHmGLVPJwuYjnIdDU6SfjbFo?=
 =?us-ascii?Q?HhbPwMAtKAlEmMpGn6q6Bl45KuNJdOi46Ar7FRvSysmKXLmQT2N2fS76vZgc?=
 =?us-ascii?Q?57qV2lWDFBII/pbVDDzzCyd6lgUQ23rbOO5mRfKodL2F6EnIiz4A3egOlVMc?=
 =?us-ascii?Q?crgLWhJk336qUoCPaLPYBYgxwo0vGs55UmyHbwRbJwUv3bj8jmj18l3GfWYJ?=
 =?us-ascii?Q?U2PbV1gpnLFSj5Egrd1yjpkxmtOX3Gy/lDHs4+qr6ZJBEg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yPosuJ/mSr33HUTVvXedovbZ9VCV+mMAl+gcJi2+ep0MvYKlEVPcncCowSja?=
 =?us-ascii?Q?DLQVXUNL4pNWvB5aYPdFTy43HiOaicqT7ErbQqlwW4NFedz3TZsH5Y6fyZIz?=
 =?us-ascii?Q?goZmyV19q+msOh3RznHSQNGAfzgRrlZrizsXiYyCPKqsoby/dq6LEO6qE5rd?=
 =?us-ascii?Q?Xu0owlDK/8PFQrgT36AcqdqOhWw0wuIF9NvkemsBcfurBC7QDxeA1da5KK7X?=
 =?us-ascii?Q?yLRuX6HkSeuMId91yeE74l61HnabiL8qmZzP4I8L/ljYAVYx3UyrVbeR6+mD?=
 =?us-ascii?Q?5OfrjcCinlhT1uEpm0Feha3I3Di6vyz6im36qPd1CwcVxWrByy3slpGGMzRs?=
 =?us-ascii?Q?vJ2cWk2cMgCmYv5yTM30Pt5PXr/xGkRQUqXaoTbnbgO+7Zcwr+ze5vBaLoaE?=
 =?us-ascii?Q?vgOI7yjtgtDkOfLhuUEZ68PpmjZULFdRzi/xm0awd//4ltAV65AQnZTcRLBY?=
 =?us-ascii?Q?VNSG6NLEdcSrPBnjLID9a1UO7uOmzOQCy1VQt5kCrf+XIlPXiLMx6lpsYq0t?=
 =?us-ascii?Q?t5cd3y6yp1Xz4EgfUUXexcn9GpaH0NnDMnJzTY36o/xg7HZ5bq7AjKOqkHS6?=
 =?us-ascii?Q?RDbjgyEiOLKIQFWv/BDqyy47Vhy/Q3CCbe79H1cPcdrDXHXkx3rfZ4A76uUc?=
 =?us-ascii?Q?hG9FOfp465eaAupW+sf0q5VHVWIobuRFm6t2LFqaJfJcTM/q5sNdMdAdnBqG?=
 =?us-ascii?Q?h2STxo+En0v2KqlqjMU3hoheeh+MXQYAEu8Whmisu1GMf2zteetQYnUlyydX?=
 =?us-ascii?Q?D+TW4aE1HsN0rwUWvg/dW3AMFPLySYbi1AVLi7nNXYc6yKxh3zW4Yk6gBrdu?=
 =?us-ascii?Q?DpD5Wz1IHZCFF4nEblMbtj/DptC6GZN2NVjzh5gigwhXWGCKAguQOdmDOPBS?=
 =?us-ascii?Q?AAEE5T45xzY0ASTA+sdgS5EG2HGdBKiFREhhGZ1caFJev8n0YfKp/PBRhzUH?=
 =?us-ascii?Q?WShT+sfpsaMZrRACbxNFRJEAsKwjJuSinRHfYzJu3pxZ2OdokyskPUhiZyFs?=
 =?us-ascii?Q?bnuW+7OMTWWcNdAHwCS7LHR7Kp43tMftkKt8+cgcHkW7SiyCgNXjuOCeLI0l?=
 =?us-ascii?Q?xFoG1cbZuYirXA6wDBct2rMwsA2YWU1giYkoROuW9nLgYLojnUKqsZMxnkmV?=
 =?us-ascii?Q?a4irg+3lUrK3YKHBjp6jCidFk/jtFtdILNRJQanQelQrBO8iwLcO5PyiOeIO?=
 =?us-ascii?Q?1vb/zQ8F2rcCfsoqeP6W3FHaep+ltdjyRJ7fD4NsThIPnu+UzhQjSeUNVDmR?=
 =?us-ascii?Q?F1OflWZ4aMDlQGFeiQ13gOUL7F2NQ5w0KOynR+oNkwELFp6dIs++87SO4SEu?=
 =?us-ascii?Q?w+2FH9jIC1ftmffWWel6CHNkMoLuMWpBiBVO5ILqWr8LbMltYMYSTisazzgR?=
 =?us-ascii?Q?11owblpApOZhLfEmyxxLS3jDggQG6iPnh/51dgqdzvvN7KVQa/2u0RsWPJSY?=
 =?us-ascii?Q?hXrkaCklGPI43FOgkJwOld0qBy0QVFEETs613Modbl3ya4F+EpiOULNWj82j?=
 =?us-ascii?Q?AtSm2Cs1ktmVUchTVbaZQzr1qS3fW3gG0M/Xw5AABELl1lyRtzc+oGBzhnEA?=
 =?us-ascii?Q?QmzyKXxQLRM/0VdxCWKTikIyps1lenwTcNfSr4I3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c12d30b-858c-4a46-4917-08dcd3b68388
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 05:40:02.4908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShllJPaYBYTEhjWGUwVvU+S23/fFMStTMlSYr8FRnR39pqdu5PlW/2iiKRGcTelJf/Tu1NVCbKvCGQyElJ/eEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7732
X-OriginatorOrg: intel.com

On Thu, Sep 12, 2024 at 07:11:56AM -0700, Jon Kohler wrote:
>On hardware that supports BHI_DIS_S/X86_FEATURE_BHI_CTRL, do not use
>hardware mitigation when using BHI_MITIGATION_VMEXIT_ONLY, as this
>causes the value of MSR_IA32_SPEC_CTRL to change, which inflicts
>additional KVM overhead.
>
>Example: In a typical eIBRS enabled system, such as Intel SPR, the
>SPEC_CTRL may be commonly set to val == 1 to reflect eIBRS enablement;
>however, SPEC_CTRL_BHI_DIS_S causes val == 1025. If the guests that
>KVM is virtualizing do not also set the guest side value == 1025,
>KVM will constantly have to wrmsr toggle the guest vs host value on
>both entry and exit, delaying both.

Putting aside the security concern, this patch isn't a net positive
because it causes additional overhead to guests with spec_ctrl = 1025.

>
>Signed-off-by: Jon Kohler <jon@nutanix.com>
>---
> arch/x86/kernel/cpu/bugs.c | 12 ++++++++++--
> 1 file changed, 10 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>index 45675da354f3..df7535f5e882 100644
>--- a/arch/x86/kernel/cpu/bugs.c
>+++ b/arch/x86/kernel/cpu/bugs.c
>@@ -1662,8 +1662,16 @@ static void __init bhi_select_mitigation(void)
> 			return;
> 	}
> 
>-	/* Mitigate in hardware if supported */
>-	if (spec_ctrl_bhi_dis())
>+	/*
>+	 * Mitigate in hardware if appropriate.
>+	 * Note: for vmexit only, do not mitigate in hardware to avoid changing
>+	 * the value of MSR_IA32_SPEC_CTRL to include SPEC_CTRL_BHI_DIS_S. If a
>+	 * guest does not also set their own SPEC_CTRL to include this, KVM has
>+	 * to toggle on every vmexit and vmentry if the host value does not
>+	 * match the guest value. Instead, depend on software loop mitigation
>+	 * only.
>+	 */
>+	if (bhi_mitigation != BHI_MITIGATION_VMEXIT_ONLY && spec_ctrl_bhi_dis())
> 		return;
> 
> 	if (!IS_ENABLED(CONFIG_X86_64))
>-- 
>2.43.0
>
>

