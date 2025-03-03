Return-Path: <kvm+bounces-39846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92342A4B668
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 04:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C98F23AE580
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 03:15:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4EFD19D084;
	Mon,  3 Mar 2025 03:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HzBoPlW/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3941D7DA6D;
	Mon,  3 Mar 2025 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740971732; cv=fail; b=ZflSA3Dz2gezZzGq3mN8ogT6e1sPLWaw0PETNpcFOA9xkfIQh0UmRerAbyEtDU1FLn3u5+6TklHKCgo5Ub1iS1ZoHfHbnE47L/whUKIBrMz9t4GFRaf/AbGjfzf8oox/mSbT89R3XKEYrcRWrK6NH9oCc71SYlELUwdxYyNRoNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740971732; c=relaxed/simple;
	bh=1go77Y9C6jyMvDTfh6fGzDhKEeRPAqQyfdgeAu/wG4w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uvSyukdxIWp9A21ZCJ90ZlWByd6C+rS95LkggpauxnBwTaAJ4+U2DRnqTXD1DLcEWgvsbtdx7qRGtlSYAFJNp7dPQsiIXRGGIgg3MBaewHnPL1F7iaBFrxrAn+2/OqaI3pbqnhSEgwlvVI6CyOUGELee8cExegtF24iVr2oF2WQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HzBoPlW/; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740971730; x=1772507730;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=1go77Y9C6jyMvDTfh6fGzDhKEeRPAqQyfdgeAu/wG4w=;
  b=HzBoPlW/JEs1S3ofJL3qFkqaA+Qx3uLhSnUfbBXxffDAZD8gfpppINiW
   KKWVc+McCWvECuwivyIskEzdVJ9yXavrRHuzx3yoFx8tV/q3Y2MyWY93C
   ZltI+AUF49A6zBO/CcwFOdkX1+keju/IniQqgTLPOhmth8wkDi8fwViD8
   prbYvvvzrGk7FeSy5ZoH77M8SNS+WMH0gBDvnqP7uq6bJqBImVQQNK2HB
   d+OvAY8e2YfnfXl1r+KaXdAwING006vdOQxjcB0TICI1oUxsrUffhMH18
   /pSM9zig55VJcHJnCqj7xROXzuKDRYR/b5iy3hYGBa/AqxjxSlMIJV66R
   Q==;
X-CSE-ConnectionGUID: hdCGZ3RDTYqT18YNjmZ1Yw==
X-CSE-MsgGUID: xMJ2F+pqQFSpn7LMNu5VlQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41955383"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="41955383"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 19:15:30 -0800
X-CSE-ConnectionGUID: pDxeRbQSQiq6zSgGf6MyqA==
X-CSE-MsgGUID: l3rvpWKgTPOXsaQ2wnS/Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="122890510"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 19:15:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 2 Mar 2025 19:15:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 19:15:28 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 19:15:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuAktiQqjLRfTXPWfwSFG4Hy1MU/EP+W3/H+XSURIFOyPy3zIlFYLxfuPhinQycJbr5+a/daEF8n82ZZebOhDIgwG7WH/RSeBKdxlH37wRzROUHN/JgfCmE9PgYSsJ34H5Xj6KCnNZTWXZMM95APBhC3W79Hn2ghTGYUAd+RRsnX+iyAxrhzP6/SHjqhRsxiMkJqTeW+NFhnfcFcaSYSW9RrMknQgo6f+nwPrhLoH/lEVmuwl9/xvHG6TQ/E1N7o6b/zAh3yor0AFJKVdCc5zjRkZrfh5vYEigD8DzNcpFswao9lTot3cc+HWlweyKcAqaaXv8s7a2Rot9MI2s7YOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Km72tMQI0EvhOXlfcbnZD6qOaCebTD6hoj5l1cNeM+g=;
 b=WEljG8Zt4JUUZDAnfeCJexE9WWtNf11cflpZedj1Cwmtoz+T1WDlTta67t8vf7AVw0NQOA26hufM+4McGuXkgLZuIJYfe/mM3w9J4tCJPXOx9PqP6dp3sip5nwS9qqTG7l1FcKCFS04rfMLirxmODeWQjn0ff5WHxQUYZFhLJH1ckDhXYwG3T+xpb/WbBPFkvl75y/pOl4tRHCMGRdREZd9vk1GItbhz2gfgtBq5VH38DqdqNbkfucY0ROXEbJMDeP+ASiDSQnBmqct55RdOBkcOzKznkJqDddIoSpikDAZDYxp/R7eDMMjcJwy7mlRuYBgjp9ga/77ldCrFE/3fBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM3PR11MB8684.namprd11.prod.outlook.com (2603:10b6:0:4a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.27; Mon, 3 Mar 2025 03:15:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 03:15:25 +0000
Date: Mon, 3 Mar 2025 11:14:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z8UefSf8aVfPaojZ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <Z75y90KM_fE6H1cJ@google.com>
 <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
 <Z79rx0H1aByewj5X@google.com>
 <Z7/8EOKH5Z1iShQB@yzhao56-desk.sh.intel.com>
 <Z8Dkmu_57EmWUdk5@google.com>
 <Z8GWHkpSt+zPf+SQ@yzhao56-desk.sh.intel.com>
 <Z8HBh1WR3CqcJkJQ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z8HBh1WR3CqcJkJQ@google.com>
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM3PR11MB8684:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f949a5e-dea3-48fa-618f-08dd5a01a3eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UjDW5jpHbTCvnRKB5TiHGwzSSBl63BjptgGzAXt3olY9AHZi88wJln9BG8M0?=
 =?us-ascii?Q?BcK5AKg+MrkGj+pUpAJD8Ni8jL2bXdf6YhI40+2djcn8JljH9A581DS2Pdgj?=
 =?us-ascii?Q?2A/dPN8mk9AUihwbPTwTYajgham0wZiE7CkwU+Nn14J3cpjlqLQfw9RpWlGT?=
 =?us-ascii?Q?oJ+MX3QVs7LRNH/v3qGZTiPKU7+ZmInnP2jMg8wjPqq+eL3LfkQ9ReZkZmmx?=
 =?us-ascii?Q?dLlyFWM2PxiAdJ8lErtgjUQsi1AHXbLaeOptXAx8ZjyGnaRl40skzOvmOLgH?=
 =?us-ascii?Q?SdLW+EihcApOA2BOjQxHCODYp9uUlaVyCYLY1uhJin807xEv2ElXWezP7QDy?=
 =?us-ascii?Q?rejoS4UbnhYuQK39lkN8c5CR/tLngAYSINUqAVCp1Ra2miprWS8MG1kyWWbx?=
 =?us-ascii?Q?g9LVNJU0yVc5IszTWheika1iWvLzQoWXeNsv5zrtWQub+L+CcUnEi1ReuSDD?=
 =?us-ascii?Q?izx0oR2DgjZDznYOMHy5k4YF2q51rj6i8G7/7xzhKO0rHE1IGW/ubOvLExSv?=
 =?us-ascii?Q?4gXShheiT76cvUVcNvOWJ+KkeVBU/LzLE5jFfdTB0ia45/SubJmRhQl1TAQi?=
 =?us-ascii?Q?sEVGGFQEd0GlJssLZfLmk576LEhtcBckAcJNzRt4PuknPfwy4znaxF/XxLHT?=
 =?us-ascii?Q?AlVNS7w+ZwhMaKBx0Rm6vruDW58Onx67UOua7XBuEh+dv8kPlgnwf4mCRwn/?=
 =?us-ascii?Q?8sH8psO5Xa1LGEgpDZ/lkIch8qfzgeO3XQLAdzMinvNJV2KCuLzuK+zyrOxd?=
 =?us-ascii?Q?xGCyL73BaUyHByv22iR1R3k6EPFobadzs4VIVfvdqwLi+nboFk5OJ8DJKsRf?=
 =?us-ascii?Q?26lBK2SqyOBSXhOGjjzwi4ujYcMePfW3OGsGGZUr5Iozh8RlGuNH+6Xcs4yH?=
 =?us-ascii?Q?T5nS4I9homLo13zY3h4BdAij0kfVfyRj+7ZmrRT3MBqnwTpa9iannJxgtnZg?=
 =?us-ascii?Q?YnJMWKBMMgTvl9b6rY2J+r15qZhqtk5zEeG2BmSBplFEdmGqKyqXFM1ROzzi?=
 =?us-ascii?Q?hzgSfHOG4B3Azd7eOFKD+Pk3rWj1loECr8iBAMSUUCK0NZo8NbNK1lTHmAZf?=
 =?us-ascii?Q?1GEQm05xU/Sdkmsm130GN4XzuGXkT5nNcsg6BRL3uWMxTc2yrWT/TrkRATRV?=
 =?us-ascii?Q?z6TPsz65EamQ2gY5uzmckKAphI1L9bCUUxAfYze3jqJsbKFgWv+C7+9uQMv5?=
 =?us-ascii?Q?H+gALcxK5p+hvQiHvexUjORdElca40NFa1rnbp4uqAJo7KRdW6y6H3Nl74i7?=
 =?us-ascii?Q?HSyWlahcA16zm+JI7VxU475Rh87aB3MlKZ2PvzImv2U01jnQEW7HesUwUTGK?=
 =?us-ascii?Q?kyTCQW+LJoVSjwISjxKtEbXR166PUjoBLFNnoZmdSYUCQnkt8qrwADn7jC6X?=
 =?us-ascii?Q?GXeoVAnY/HzvdtF5qiB//L8CGnVL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ksfNrbSpRBoBEmN1dEXCFdX7T9n+TWH/NZ1GFwgoRzEo/1rMIIS2FoD7R76P?=
 =?us-ascii?Q?XSMT4dXY/DNkottP/XpByb1iFCceJ/HwkT0clH9q7VlciX+r9lZBmauCnmP1?=
 =?us-ascii?Q?a053Ys+rTEWN9Ro4uq8i2ehOJOMYFtq4X4hixG5+tix7nnXB/T/z8StBNy0k?=
 =?us-ascii?Q?j1OuNc1pADsxkHP6iXOLJm7HT/auKXcAK3oVKpCZoezTX6Uu41hHafNYKQK6?=
 =?us-ascii?Q?4SIcMr8FJ78SSMmaPnUop+Tb6E9EEjzjs94dGMn+R3f1nh1cQJi6GlxY59cJ?=
 =?us-ascii?Q?3PxswAD+JLUIPhsvWhSkORTnWH0k//ngZXeIX3W2sDoQ4cAgbUu0vMGXVxdP?=
 =?us-ascii?Q?4xn/hxxzfLtbfF8Hjg7HMDeg+RzW2QINgLpQc5ZEe8OHe9kZoAHp9rSJRhJR?=
 =?us-ascii?Q?8zAXuq3v1zJuVuitbME/ZyOQ1xW4YIakKtJXBqC/vlBulC+H2WfwAiN8FYUD?=
 =?us-ascii?Q?ICGDIcGZ8JzQXKsUoVcbzrOmDUFhSYjFSVct+icTqcHS9jJPctEdtiPfY+HW?=
 =?us-ascii?Q?zc1k9UdzonK0ANllQCHfL6F51pJW/sNiK2aQydeOPDtwQMQkzmnuDjLLavHJ?=
 =?us-ascii?Q?nIaq4fvRbrCqBJSJVXpMkhdMYHbls3EaKuaeE5OkkVjdt4ZMPUG7Lsjz1QM6?=
 =?us-ascii?Q?n8K78xgiMqrIf5cbijKghXMPcRrqUu7J1epOdvmDK0eH3JmXvEc2LJCFb47F?=
 =?us-ascii?Q?XxvbsFtxBHSaNb54Dw71VQ87qHrcyf6+Pqa2eMO4CkP5SSH0ZezZC4YmXJYQ?=
 =?us-ascii?Q?avfwcnK1wNjnUVKwEMIfi3rKc1byqiJQ3lGnCwqYCa90qar2zCDVsSwpzsQO?=
 =?us-ascii?Q?pu1spJ1zt28A7GJSPwjoAfJZgkTiHKJE9haQP+n38/F3OurrZedbjSyAMjEG?=
 =?us-ascii?Q?VHfuMtgwbwUcFnhU4f0BCMOfzZE0GTWn0NI1v2y/aQvZefAHYhH2Kv2qaAdH?=
 =?us-ascii?Q?y9j/Y9W9I5BrK+Eg3Ly2wclm24D16NhtP/uCDFsH7JycVQcUVCyEmv46jNe1?=
 =?us-ascii?Q?XRWI5OTqKvxr7K3JOXvhJ8gD7CCvMb/F+TSUZ6/0jXsQrTRcpSh1YX6HAtv4?=
 =?us-ascii?Q?lV1U1+nfg+34RBfYNLgLog9wa66HBnetoFHEx2pVgqlgOpzhGKBnt3dhhGHZ?=
 =?us-ascii?Q?/Nb7LIztTMrL8v05m8ou9Jhy+HAzZTHTpBnjxYd8dFNtgvFIzp37JFgWhlq4?=
 =?us-ascii?Q?jGmg/wtpLwNyDmCTQ+hLO8fMNsmpkoibiiw/LVLwJzCax4ItN9zVcudh2Qn1?=
 =?us-ascii?Q?25/QUmaXsD8P299QlNsYPCGD2K2snn8v9wWAPTrc0Gm338LOm9f2HHpHHMuU?=
 =?us-ascii?Q?fawThOIMeFDnU8GWOU6DJinKuHD88ixdIaKWq91qWWb2atmgYAxYPFdn1VJg?=
 =?us-ascii?Q?6X1j9m3GX09KrgKPh3wlNTATGN8tKJs2pZlGOsjm0mhJStVaDJbEb9aWhvPF?=
 =?us-ascii?Q?q0zogJVLBycpDCadR7/UJNQaglT1xri4nHfVWH16TCzxW2S4rBJJ9i/XFEtj?=
 =?us-ascii?Q?bTncwNS2cWc5KrvMoE+K/S1a9foPF727gSNvWNUQyLDCPedXCOlKvI8ur7sG?=
 =?us-ascii?Q?mC9zitnkUfF3JCOFm9f/5tdj2ixOe/U1ac//YNoO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f949a5e-dea3-48fa-618f-08dd5a01a3eb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 03:15:24.9762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htdP48kE8JlGmDkXXs6bMrCdnaI0nUeeaqkVfJlPaWTYc8/lITf+27E6nMK45G5NDXl2BvBi93CeJp+/SPybfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8684
X-OriginatorOrg: intel.com

On Fri, Feb 28, 2025 at 06:00:39AM -0800, Sean Christopherson wrote:
> On Fri, Feb 28, 2025, Yan Zhao wrote:
> > On Thu, Feb 27, 2025 at 02:18:02PM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 27, 2025, Yan Zhao wrote:
> > So, I think the right one is:
> > -	} while (!READ_ONCE(mprotect_ro_done));
> > +	} while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));
> 
> /double facepalm
> 
> You're 100% correct.  I did most of my testing with just the all_vcpus_hit_ro_fault
Haha, however, I failed writing code that makes you 100% happy in one shot :)
Your version is indeed cleaner than mine!

> check, and then botched things when adding back mprotect_ro_done.

