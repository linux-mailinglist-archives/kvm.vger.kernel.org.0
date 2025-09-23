Return-Path: <kvm+bounces-58443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 518BBB94099
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 04:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 405AB189480A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 02:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A2C2741AB;
	Tue, 23 Sep 2025 02:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DCd/Ymae"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4951D63F5;
	Tue, 23 Sep 2025 02:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595453; cv=fail; b=AmdOaL1ow1ONe7ZGCPfIoQtn3L57ig5ZDz0yLODQRvIYeZr71v5OGlIhQq/EzawAsSHmod7snxZrlClh5eQloq4sPQZ+jkL8KovbXPEAdPV3rG1mlnxpV3/iepHdaVRMV9XDJBFcDKybHmQjEoplB4KDaPZ6D56IIZqB1UOCOyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595453; c=relaxed/simple;
	bh=BUJkWvxzWcY/LcVMD5xhJQcbp3zHi0mOguDn1+kZXek=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HTE+IsJImWF4Q20h7V8wFoCePtluCWGk4rOGKuksiPtUEHNDsdE9vybJuf/GJs6KH/hlNe99nu14Dx/N6nKYzBWIkp2uRcGLvLszZZOrsYsxkIYSl4qSu1U0NdT66ck2NM10PSk+n4d+5uOwq8CW+L887pxMbLY7gEOlSiBrdoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DCd/Ymae; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758595452; x=1790131452;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=BUJkWvxzWcY/LcVMD5xhJQcbp3zHi0mOguDn1+kZXek=;
  b=DCd/YmaetHL6Lw28Z41szBLcYnzyk1+Xxtpgq0mHdZNBcB/UrNkeEp9h
   zDmjRASbIehstJtd6e5nC5xcOkTOAZC8FnD+dL0WGtXvAuWCO48EAS7ch
   8x28Fpk15+ulNLIIuZON0lmjoq/bW/teydKlh+sNGlvODVR8icN2cVonX
   GaY4Ue1Pdk1l4uH/MTIqX2VUPd39rDom+lscr4M7SvQPoRVf519ABTxsJ
   f87ySWMX6TZPPpYoqk8Pp/UpKgTPpZA6GVAaSHXUawwY6Jd4RdCnK+8SP
   UR+Ruy6cJLtUXc+VaPiJUvfThcqfP+NL2j1MWnJ8SQd+5QqH32ZpUJyHz
   Q==;
X-CSE-ConnectionGUID: 5WplYFraSRmYESbpC0aoxQ==
X-CSE-MsgGUID: Ucs9oRwlRGmeIq2BwKRwtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60782803"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60782803"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:44:12 -0700
X-CSE-ConnectionGUID: Yp1t76HqR4e4/vt4/j/Fcw==
X-CSE-MsgGUID: lCBGBIdORi+2iYyrPduafw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="181887452"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:44:11 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 19:44:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 19:44:10 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 19:44:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKCeqJFza0rcwgHKob5/Bxoco8pdZhGvU1us8N58lGbhifcJV09PiFKuMk+2xSSzFG7Jl+xok++P5KwcP8Qjl8E+EU3yfrHYoIAjNrIiEGRFPJY9NvQ0RE8jn1zGmO6UirMfzCzeP28i/nmSooxobzvuBxetRh4aF6eqXA1vJjrTFBkjLy7HiExhVoRWUw75IxsJLyqlGJyBz42uqWkQPYCF0AxdEJhphjMqTj/Pvld1xW/qGQV5+613eute1b/kOVWPvBxK6vu7uRK3xhCcNOxSSiArFiA91elk4YE/Eobon3MyBFSVIU1yVKSv/8LwewEM70S8kl9nNDcm/vKesA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xSBV2TeVMufV6ENXFaOFWHhs2C+Ctni6sVQvibzWG98=;
 b=GMyr4NGiwh+UU0hrGo4t/BZKopw2RqnliktuwklbvSszBKByMd/xDRuKWLY+kXfb7XE+5UC9ltD5YXDr0gGY9lspc1k5m9hx2Jnl5OkMaMWhuGAS4vHiVTILhLEDW3byRTTuIVjPw2smBQ+OZrep1E9j5uOvy84A7+cRea9tAG1ZyRW62k3ROclqXXcvX6CeTOLxa6lXQ0PA5MXXw7+/ipWiBrZr4Kr7ih4gG8b6nL2ydmbSKxL9xGcsng0q815LteAz32Xgv7YN0sPc32HDY42Lp6U/7c7xTz+iTLaIXNSYnF8ONaAgcxjwyIAhdBsN9b/h28ykMHu3oKKtsaAJcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4514.namprd11.prod.outlook.com (2603:10b6:5:2a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 02:44:06 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 02:44:05 +0000
Date: Tue, 23 Sep 2025 10:43:55 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>,
	"Xin Li" <xin@zytor.com>
Subject: Re: [PATCH v16 34/51] KVM: nVMX: Advertise new VM-Entry/Exit control
 bits for CET state
Message-ID: <aNIJawIapU86zXZG@intel.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-35-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919223258.1604852-35-seanjc@google.com>
X-ClientProxiedBy: TP0P295CA0007.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:2::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c64056-5ab9-48db-eddb-08ddfa4b0fff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nw5xjW1J8u9NWjEmecy9DvN4xH5GgNIL4++hzRZ7jpZeHTh2hKiJCqKEQ2u1?=
 =?us-ascii?Q?29bEsyrF9yUC/Tv8PJ0F0rHviWbeymeaiAN33J09ielwNXk9B+AzvcoHbswM?=
 =?us-ascii?Q?xBV5CO2wjeqECLzCA6gE7w0XLMvy8NgP2iGyFOaHXCXGAO+BQIeKknrBtWlT?=
 =?us-ascii?Q?OxzOka5M5zBFr/4txMGrUzJI0HnNf6LuVPjqBIDjQibXdMWXIVOdtb69mVUO?=
 =?us-ascii?Q?kPW80s/3gK+QfXU6wT8yV5O1dCyR4i73nwm/+uRcwaZZN3/O476PaWyr/Njv?=
 =?us-ascii?Q?knqyFCG+KjiYPMY4m4hOfD876FZMJNYHITUjSuox/7ikR1PdrtXFrQ8dxyNX?=
 =?us-ascii?Q?pnKqa0K0UIa0h2za7KsSbirJHYmuTPm/nzI2dhf/skXuDZSygg/n0wM0Ut0f?=
 =?us-ascii?Q?YAOrOiBozZsShI05xNoeEMrTPRYtLPq5N39+xLv4TfAckpuq1d3JHK6XdvwO?=
 =?us-ascii?Q?5Z/lmawwU62qb8vWUnhwHFM31y3Rawn/hyavSAw8HvUgrCCqqaDfuBRDHNW6?=
 =?us-ascii?Q?SJx/cySdYl+awULQryB6WNV1JkCcjrPleUb9P0+W0Z0JIFs8UNqB+KakEmfe?=
 =?us-ascii?Q?SkxqdPZ965DoAdYyGnv7gL3y2w+5n2W2HhQXQCBEz50yXhqxWV7CPh1uTyxQ?=
 =?us-ascii?Q?+x1etFYitci58Q6fRtElKwhWTwdC5USaG6A/FHERZQ+gFtOCCmk0GwKUoR8K?=
 =?us-ascii?Q?LUwis3ooepcHLmEYAA9RdSC+heov+tetWSJBTjO73EMQG5giY1tGWv7DDhUb?=
 =?us-ascii?Q?3zOEdgFgDsUfkTlSXGC5S3xdTr6lqMsd89QlWNEirEwe/LlJN3BZKR3avhTW?=
 =?us-ascii?Q?u+NmJUbE4rOUvnBQ4P4kQoaLT+gvJz+pYldrqT3l3IjmSMur7r5+ZwG4iRKK?=
 =?us-ascii?Q?W1+3CUe0klqGLG2EnpsHMwpF27cam7iWj75HqRzCmOeT8npahJ2ZQNzODMs3?=
 =?us-ascii?Q?1I4Ke1QuRQJIHiEXn9dvJqLjDyA2WOP6g/AxQZFbztCiGF64FSHcIxMCMU8t?=
 =?us-ascii?Q?QEbgC5UziOdoXgiUEyjEL4Kh8azNulZldyMo8uT4LzcGpQfa86GUgsmY8rmw?=
 =?us-ascii?Q?xw2x7lXrQAVFBKjWDDzdbzKK9trzxLvnx/o5a9fH+sQsfASkZEDyxkI8i/pf?=
 =?us-ascii?Q?9Jt34jUMeE7Dsu8CK+feCcRfheiotJIJJH2G0dQ46XXRwodLYwsHTIEM/SwJ?=
 =?us-ascii?Q?9RGCBi4hg8ZdrrJa6cGCKYIOFJB+2kfkQy4gAaubJc0MA9N6b7rPmrQSAlrh?=
 =?us-ascii?Q?lpRFYJmRZEkPHMWLxhqp2VqD1RrWJFCIZi4lqwBmA6dZx8N5tv24AmrRcxiw?=
 =?us-ascii?Q?huRK8Nh6roNHpnXE5UIiQQMJYVgl1SkA8eZzqY63OpyVtrty0OtQzTqtIxAP?=
 =?us-ascii?Q?tI+9CNOyNeuFPK1nm3cLu8sbmC0E/YPZ2PREBzswbXzYoOKWJkG97p2XJJYR?=
 =?us-ascii?Q?+aLYDdhQzIQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5McZP5hANL5h6+YnHRDM1dNn8WCvq5gKgNvGD1L16A8wAuH8+YEYjBETaW3?=
 =?us-ascii?Q?R800Uwb+XpfnHmrflGCkjbLPPVmTsU/qybVyPWjxtazxvt0MqKQ0K+9rHC1K?=
 =?us-ascii?Q?de1ujsvlJx4T7vLqZvCaT2/XlguZ6ZrhRtdlS2KK2+TQo+Kc5Y+aPkYP/Oen?=
 =?us-ascii?Q?kVs3btU08keF7AESd6CBIwRQRVINH11LtQSCPIN4pixazrD0rCzMhqL97Sxn?=
 =?us-ascii?Q?hOz3gZj7bnZK9bVUDiFK2e1Knlwxrxrd2WUIRPzJtK3Vp4YleZFgZBRQT7ff?=
 =?us-ascii?Q?9Z867HyHgNTJAUZCdbIBco3xln/i49Y82fRx3CKqVWjLRF3BNaHBSsSYhXCV?=
 =?us-ascii?Q?5AuDIgw6tqWErGvu6UQ/ropfsMRc0xGVM8RVrritFzyKsWD1h/a3qHP276in?=
 =?us-ascii?Q?DmC4Gq1yRlm/su3BtULtpR+yCpNcXGrIfAG0ix+1a4tlYKUw9xzUuWSzHR9+?=
 =?us-ascii?Q?b7zKNr4oWhsW8jGjuz1rqCJWLF7OXo9L/Kgaishq+3t6VPYJe1FeWZrNvXbG?=
 =?us-ascii?Q?/Jzn/sIzZIDNULd7gjLxRojaAUkTSCQwY/cd1/pU9rl1aHVbUvI2FQngUABP?=
 =?us-ascii?Q?rOi0YcZ7NVm6QdBA6MT7d907Y+9w80iSHByWb8zmOpGdj1l7bOhj0kLKSk2n?=
 =?us-ascii?Q?WRae+ZxDIy5Zs9s0N7ZJeQ7vvjBM3V5qKkzRFCZK+FWtLtUQD0YhgUZS5W6I?=
 =?us-ascii?Q?2zrRcLEWAzQcHPmBbXnrSQHQHj/sWB1ZKkW9PbPXcqgG1bThUOtxodlaVVCn?=
 =?us-ascii?Q?M+LtW+auzPo9PJaja/BN9axe9XFjjuZXKAbmLu/F/p6tB6Ka8MxQJWBx+veL?=
 =?us-ascii?Q?vBGUZzKAsJAIcFYIJKurGPAlc3z6wuXjpc0MCfNOIdA9VVJh24qZ2mMOK1jh?=
 =?us-ascii?Q?52lf1kw8lX90UsWbFAzFq6XWnLyzFkd0z4I7USI85tYayWLUdW6k5WvJvUW6?=
 =?us-ascii?Q?G+5FSNvS3vp2QrNOnP6SjiP2ssijnCCQJo8QdY5W10tgpSKpEi7/nBEPv6c/?=
 =?us-ascii?Q?VOr6ckpC2dypRzrzsk65C653zIMSoRbnK9MpnYx6Z4ht5Zzh26yedhAcqa5Q?=
 =?us-ascii?Q?yLJQ4gMi9Eg6ADt4BB3k++uuN0/QjMbf5pvtgx/cSRLj/Wpbf5+/dV1k4WTR?=
 =?us-ascii?Q?Pk9BFFhGDmT5e+0JSWT2ocecRhlSzrqQTU5DruOd4ulqDAMe2g6soO/DfKGX?=
 =?us-ascii?Q?2ARD9ojxCl4vjNPP6NI4LP6R1lmYD2pc8L2SDyXKBwaFe/TPUqzRvrYHfeJW?=
 =?us-ascii?Q?9/ZiCQss0++aKUJWZKDRZUEaXdmpAk99vWTQgc5MRG1ck9AhAbAXFZzPb1Jh?=
 =?us-ascii?Q?8sJxsafPXWOrreTPAthgSW3Q9w+b9H1JgItBuEaKcFk/2YK+Uzj27fA51jUN?=
 =?us-ascii?Q?zODfLDYIYMC9A8wFD1FuXoD7WyWktPgStktu++iAILeJyJNDkcGXPcBWr8q7?=
 =?us-ascii?Q?tKHfn/1wA2VV11J/UQ8jqZMiykUIwv2JrQiB4vggeVFTwzi5rZZiO7CtYoUe?=
 =?us-ascii?Q?QfmgGAIOv1njGycxQ6m+cvD13h0r4b+7xz/OVD45d2x9oV261axXA7c+60LL?=
 =?us-ascii?Q?7ktIOpSa4hc2+uJ0yDj6rxgzRmRFNOXDIb04V1fQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c64056-5ab9-48db-eddb-08ddfa4b0fff
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 02:44:05.8041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/N5IHukO2NU4CGgL1CdaGbIKix/oL8oGIRjCTh/f6E36dI6X7PdjNUutustDDHj5uQoB0NCdy0mCBcx6pIx9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4514
X-OriginatorOrg: intel.com

>Advertise support if and only if KVM supports at least one of IBT or SHSTK.
>While it's userspace's responsibility to provide a consistent CPU model to
>the guest, that doesn't mean KVM should set userspace up to fail.

Makes senes.

>@@ -7178,13 +7178,17 @@ static void nested_vmx_setup_exit_ctls(struct vmcs_config *vmcs_conf,
> 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
> #endif
> 		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT |
>-		VM_EXIT_CLEAR_BNDCFGS;
>+		VM_EXIT_CLEAR_BNDCFGS | VM_EXIT_LOAD_CET_STATE;
> 	msrs->exit_ctls_high |=
> 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> 		VM_EXIT_LOAD_IA32_EFER | VM_EXIT_SAVE_IA32_EFER |
> 		VM_EXIT_SAVE_VMX_PREEMPTION_TIMER | VM_EXIT_ACK_INTR_ON_EXIT |
> 		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> 
>+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>+		msrs->exit_ctls_high &= ~VM_EXIT_LOAD_CET_STATE;

...

>+
> 	/* We support free control of debug control saving. */
> 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
> }
>@@ -7200,11 +7204,16 @@ static void nested_vmx_setup_entry_ctls(struct vmcs_config *vmcs_conf,
> #ifdef CONFIG_X86_64
> 		VM_ENTRY_IA32E_MODE |
> #endif
>-		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS;
>+		VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_BNDCFGS |
>+		VM_ENTRY_LOAD_CET_STATE;
> 	msrs->entry_ctls_high |=
> 		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER |
> 		 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
> 
>+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
>+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
>+		msrs->exit_ctls_high &= ~VM_ENTRY_LOAD_CET_STATE;

one copy-paste error here. s/exit_ctls_high/entry_ctls_high/

>+
> 	/* We support free control of debug control loading. */
> 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
> }
>-- 
>2.51.0.470.ga7dc726c21-goog
>

