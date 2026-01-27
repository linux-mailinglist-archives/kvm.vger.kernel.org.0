Return-Path: <kvm+bounces-69213-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMKUDbhteGlSpwEAu9opvQ
	(envelope-from <kvm+bounces-69213-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:48:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD9290D2F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A722303B14A
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27FF30FC35;
	Tue, 27 Jan 2026 07:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bRP2gNt8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A33B1F4181;
	Tue, 27 Jan 2026 07:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769500072; cv=fail; b=F4A1kjhEVd0oHTPEENVnUTD4amWJbuZgJCk82Dp3WyC4MFLM/QwJSdf8VGAwkCvCBxUg8U6RR6ptvZEJDbmqwCDaKGXgKER7LK0PI15FfKOcxXhAcUeO7cMBIg4axz3lj2HZlbEH3EOaZiTEbsOaBn7v/WFRfVKBKcsnIRSyp9s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769500072; c=relaxed/simple;
	bh=J29QFFcWVbNLK1xvvfIhMSsJVQj2lMeGHkZfNcwLEb0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BeOeXr7VFSuEKPKOuy97HaYhmuXPPN0r45UA7hH5ftzp8G2hf9a4sR7IPGuOTMcb7tlzCLy5k44nA3370eSUTU0w3AEptXerlrX1gZVPfY1+xkXh3rAPvsZNWsegIgvw+lB8OuUR/AW04ovqinxS8xmMS/8Xu0W3cg5LF74JvKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bRP2gNt8; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769500071; x=1801036071;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=J29QFFcWVbNLK1xvvfIhMSsJVQj2lMeGHkZfNcwLEb0=;
  b=bRP2gNt8thUhzRBcH5lvRfRFlUhuDHx/XPdPNFhh7l4WSa2CKegcLtJn
   rPiZqvqpKrmvy1DmJhjAFG7ceX/fIcJ+iH+bxqaf0Y0n47Z3uPEj8nfLK
   3Rl3arvpnDB1xlRPHG5wqsoZbY/esShcnnoLt6fDGFxVSNChFxl+Ym62m
   qD6bM6PkI8iu1tFrZ6u+ho0DKOLzCYEF8jtwMouKyOQoWwOifxYnO5B5z
   3hRvsf9yon3L0dgcmL/nZ40C9kCj0s//iVPOSjfKapTjMbRT0SqZ/Tn1+
   5gAqNm2y5EBMJ10E1PAji/k3QG0VwF7aqA/Z4BVpyx7RLyj/vMRAbA9Vs
   g==;
X-CSE-ConnectionGUID: NohRLjtrRZygDdw27bV1ww==
X-CSE-MsgGUID: fh0HgHvoT3i2gOgzagnDVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70404331"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70404331"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:47:50 -0800
X-CSE-ConnectionGUID: IyDxbFRBTBaJVINNXunV4w==
X-CSE-MsgGUID: yFcjJjRiRf+WIlbvs8O8KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="212766498"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:47:49 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:47:47 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 23:47:47 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.64) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:47:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+njsR9dyGlo/cx12m9asdTZYCu5PJPBHj46nj5OAadJHNX+xZBBC+V8e2gLxg/ROdmcZd4NfZdcf9r04SQfARfIIuXjDHeG0tITDIpLUrw/v6iXU691niXFn1BR8BnSYhJxTkEMmLPiYwKML+tUHzlGfgEfoBzvrzEBSrwbywxttV22FWiLL9eaR7wSVKODS5xHUWrGdldyK1pO6zxlAYcrUPfcxrwXdOQPpT4g3R9GERTmMCYASp0V1caPeI7nTXGwSXZYUj/6viMAyJbhmmf0wlN0mTi2uu5OkPWogkpaJ339c1+ExnklZ5FnpbM4NFqzTsyiheFP+MRxkYM3ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J29QFFcWVbNLK1xvvfIhMSsJVQj2lMeGHkZfNcwLEb0=;
 b=VyKkP+F6G9JiM+Ki3twm4y1BIutttzNDwMVDtSMs1kdihqx6y0a/YjGEImNuPs8FsmXb+iwtV2HllU+obW8SF9WWplIjL6sgo1cUOS/Dwr6ZjmPD01T/kYETCX0LwQ22Cuu5wUtqIKfFdmVoaNn2qrR6dEatz9Ls88ANFWgmIBVT2wdOopOFspuEXA9k/Xn/ZWJC5xvCP+zfIq+2NxHkyd5ojwlfW9Dat93BCvg6yUaYmZqsBiN8bQkmt1ORVKWvxSBZ4CsBUqOInm1fky2snPzBAMQ3fMpLUJb0FMaD2Gvjqyoh35zNRWCdmZV9JZh4LFpGe4hp0I4J7BxaEs5RWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5172.namprd11.prod.outlook.com (2603:10b6:303:6c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 07:47:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 07:47:43 +0000
Date: Tue, 27 Jan 2026 15:47:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Mathias Krause <minipli@grsecurity.net>,
	"John Allen" <john.allen@amd.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao
 Li <xiaoyao.li@intel.com>, "Jim Mattson" <jmattson@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Harden against unexpected adjustments to
 kvm_cpu_caps
Message-ID: <aXhtlcLi+M1MUT3t@intel.com>
References: <20260123221542.2498217-1-seanjc@google.com>
 <20260123221542.2498217-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260123221542.2498217-3-seanjc@google.com>
X-ClientProxiedBy: KL1PR0401CA0032.apcprd04.prod.outlook.com
 (2603:1096:820:e::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5172:EE_
X-MS-Office365-Filtering-Correlation-Id: b0293f69-94dc-4342-9ecf-08de5d785a98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VJiNYFAerpJoGR5/QuXDYj8W7NfgG4Fbr7XnHBeUxhsUjnM7qlR1D6v2xe5Z?=
 =?us-ascii?Q?zhDkWdwq/FZ2+sbfR37wZo2QXWMgd/y4oVEkvx9p1rOyM62Bzk+D2gTnzPO5?=
 =?us-ascii?Q?uXTUmJH4t9jEbYImZEhY6tc6NJ+AVwxb4WB3b3h36jnNIeYYNFL3E4dl2zSV?=
 =?us-ascii?Q?LvTJN9c2ObMdKTpZTuHYXNrNxS9urCWEsZCV2vUMxCZb4PeX5uIwd6q/Kspv?=
 =?us-ascii?Q?aYUjArJP7dsciyrShnI7ZX8l5E6KLJOpVYU1xuLYRGh1LN0CDibu16HnTiIi?=
 =?us-ascii?Q?jM2RHwxM1wWuQTAZlUHdicFFMeuUcpr3V07IPzCqRPDnl/bRxMO+R6Odw+4S?=
 =?us-ascii?Q?zxQXrcj/DwaOS3EQCCkDZzxK+O1LRumqxXopbhe3X1h/bUDnhCRGk2A+I36V?=
 =?us-ascii?Q?7b+Fw1Jy5XSwgHrVz9xhWZjxkskRth79Kks6G8Bf/ovDltkbcC/UBoNZve7c?=
 =?us-ascii?Q?VS/OIQGFFoNS13LGMKOrZwYAvigL4r0UdelUqZWP0qvtPHL8knOzLDNYeJZR?=
 =?us-ascii?Q?v7L7TyxkDAfI9FXE92GKy2Pw4dBsLzSChzAL39dKKy4lqNa6ePbcW7jxEslM?=
 =?us-ascii?Q?Mi/Y1B8/fUXkD7wGDpB5Y0M7Muq32c5fDL4cfbELOHhU5uy7HX2lWQj4EAAm?=
 =?us-ascii?Q?h9QUFHroVkfmgqx3x41gL/qPWB7huz9y8SwPeFyBAGX4uWJ4KT6eyXNmrGJD?=
 =?us-ascii?Q?lsjonGXHoBxsLvzWdO9i3HeAAWlSNncRzsGtoB+dtlT7Pt+XQpEbckTQjIGt?=
 =?us-ascii?Q?49ogeOCpffKO0C2Mv//NUYaw8wZdIizNOElinW3lUMC/CZQYJEOJKBnxiTY+?=
 =?us-ascii?Q?Lb2oniAX5kJnCap9jdPwgb7Ki6MrkFJ4XjyI4cTG/lZXkL4JytFOSrQWBbyS?=
 =?us-ascii?Q?6+cfzTsFQ5FwiMcw5ZEs74m9DgC6iIZDfYXUYOMB8Hfl1++Xs2Gn1b9ClsfI?=
 =?us-ascii?Q?zxmGzSiixLuEXa/yQYrqzMZV+fA7forqcuY/qFgujbNdgdV9ChyojNCm/nrp?=
 =?us-ascii?Q?hTqHmOa7txFmoSV/ejk8yb5QSR/ghprrOF+RG8E9ArZUg9GPtOLVk36Nsvv8?=
 =?us-ascii?Q?hhoRS5mmwbapaNgkTQK/FX7C9TUEiK7IJ+lnapD6Wd/9tsHYDck0Tm2ioAez?=
 =?us-ascii?Q?1ECpFUG/hNs500nStfITuS+NAFvpzX/cnPTRwBWFjWyjxcdFnTzbz+w4Ug+j?=
 =?us-ascii?Q?TKsDeK/t9efEqT3WqKD2S5kCh0bh0PKtW5ANyEv+cGML2n/Ah0smiZC56SX+?=
 =?us-ascii?Q?e+AqgpFeZSGrQGI/n2m7cDLp41ZYwG9YvgwAyryvu7oLGNq6ydX+Bf+D0+UC?=
 =?us-ascii?Q?rQ4fpiFCXhSN9ug0BxiIKn3zAYe88jawM/c5jddFKwpwLzqGdy+fUakqhlYb?=
 =?us-ascii?Q?8crP7TaKZrFe0lmZk2A+ofsIihk8cLFxkNe7S3EL2A5TvuJRdpZyo1elrN7u?=
 =?us-ascii?Q?kT2DoDnK+LDf6WJYVc9EogSleQwNFXlb1wm/AVZyGu2bXyyiOsfc50E9DzoU?=
 =?us-ascii?Q?x0iHDyU+FQVUEB+ma5KegUphvdofxhyv9TuitwpEvsrE9lu8Snfltjak7KJF?=
 =?us-ascii?Q?OJcpMBeRAxyfEOKbR0M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X01UWryRqX/Y/R2vJI/YhvgedeQGy8FjYUem28zXBLgLwHO2UawR19e+VSN8?=
 =?us-ascii?Q?vMvmmmyvLXCe7jvA3c99EGFhdYo3I7P1fyUNcGMofUuuadF2ZZVnsrCZGTc6?=
 =?us-ascii?Q?solvmyHqGfRqjNoiIkydH5GWT2P/cKwmQSYtMUAW/rNsvg2ywaJYdpFdyDhM?=
 =?us-ascii?Q?d5TZsvYnGUBsT0C7ZooJx2xJnUEfs+uk/SQwx7xVUbhenW3rD/Ivv6b+HdNc?=
 =?us-ascii?Q?ghg1aMSQZkq6/KdgSCYSEmEOW67r9MIu2cEKEopKiH5T0EBWgQ7ZXG/urCyI?=
 =?us-ascii?Q?zDTXxvGAY44kEbkMaDbEwFDa8MaHx7bTM2wqyRx42S6otVWUkrxYUI0bEvbP?=
 =?us-ascii?Q?I8KKUTXnH2GzLT6oBMrqMl/PpyMiIUoam/JZH16H0RWwtUd09JK91uGmH/84?=
 =?us-ascii?Q?YkOXx54q7Q532/UjkJV28kTt8l2kTEomt1IjtaPSNOng0JxilaMr5ah0dcHf?=
 =?us-ascii?Q?vw0a+TDnM60GKS62APDiHRSRvkLXzb3BOhCpINXSjzzBIxD83hfb9q0cc487?=
 =?us-ascii?Q?vo1Ia6x1il6YV94E3taiVHSwZCRGrB0LItGk17Cchf+EkFYPjoFqpUhTeBak?=
 =?us-ascii?Q?zZnh0ZdCH5bT6C6RcNIY8vmboQm7xK2o8kxVMETgT6V2ddzlPQGWePVYWXGn?=
 =?us-ascii?Q?x+EIc/rJmsGuCDBfKi/kHmIrHi1LR+SP+RfpKXs2USflo2E0Qmtb8vEYxj81?=
 =?us-ascii?Q?SFoi+EaONnsFlmqtsSVa5RZCWdMN/BjA8zus5PHttRQMFH7V81qdhbLwrdi9?=
 =?us-ascii?Q?gucYwc4mwSmIqUqKp6fuRMJ5vg1lgCB+XhC+MUsycdRAzptWy0hBmdMvybLz?=
 =?us-ascii?Q?yw32oHh4TUsd8qL5MtbSLmZDbR6Mpq+ySoyHKQ5+K28w0ED84/Uu3cLioXIW?=
 =?us-ascii?Q?OyW2Jr1gfhUquvDo3O3beh2Cr7v5weOLBTi0S5SGEZ10RTkKezWuTl9cloRe?=
 =?us-ascii?Q?el1Yo2nefv5zCaPNgJtb3AKUWBVZxEY4vrSd+qolortYmmx7dyCNsearAmTo?=
 =?us-ascii?Q?mqcUA1NrIa+B1C2g8YC6n5toyFbDWD80KI78ifwt60fsKiMe5hlfMRtmFljc?=
 =?us-ascii?Q?rE7M1n1+IGxVTOvwqtbW1I8qAAYapTEhNlajfnD/vtXtwsnOXKSGDyiT5DP8?=
 =?us-ascii?Q?imAPZwwKq2kya/5U9JzjT4uuSjmhei20D1RwJRIvTw6YmSlWej04am5l+y3c?=
 =?us-ascii?Q?5WimYplE/k3fUjQ3OG7Sw0+bvFpH9VtxhExi91lbYGKDxb6dT7EbeG5wSxx8?=
 =?us-ascii?Q?rV+0DFnp9eLIgA63qd5kduEij1TXYThhXbfy+RH4yOEzrpcKuXxJ+kfmc5/g?=
 =?us-ascii?Q?84pl7BrXsPDzwrZ0ba4a0Z0G/28Fx+/5gnmQdcsT0o8DITgZcNgZX87WgLny?=
 =?us-ascii?Q?Bngm5hLcwpHZLEP4q/P/J2JOIQrzw14MswbJ4KuzrJ1ikGMxTrsJ7iG1/ZL5?=
 =?us-ascii?Q?uoZMTZCYvMn7p79XT6PehLbIA2A5b8afsfVTQSGSdDRoSwVvjcLzFpykziDn?=
 =?us-ascii?Q?VHv/GRhccEroFQAID6TmbJjQCW3g8MtW0aE2Bj9rwT4e31Yn3/gy8Q4CGsoQ?=
 =?us-ascii?Q?fn3uQD13gR6j+Gsf+SNNZ8YNVQadq51MhZY4a38R6Qcn84KNcj26m0A3SavI?=
 =?us-ascii?Q?9OyQKfoJ5Ez0Ex0KUF2MtGe4WZoSjFTVbao+qbfb3vEaypV9j9s1sK9O0i/S?=
 =?us-ascii?Q?B/MXg+jeHLIX6IfXujLjBgB46iGzHI4ezcgvOC/jsXfsOp8JNqW9qFdcHNig?=
 =?us-ascii?Q?bBT1HRE49Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0293f69-94dc-4342-9ecf-08de5d785a98
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 07:47:43.1751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mn6qKHXrAfgNRLVxvgVf6XMb591qur9cosvE5/DG+wx5yW8DwpkjKocvs5qPUaMTXOCxSQ7LhSx6i/F5xdwqig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5172
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69213-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9CD9290D2F
X-Rspamd-Action: no action

On Fri, Jan 23, 2026 at 02:15:41PM -0800, Sean Christopherson wrote:
>Add a flag to track when KVM is actively configuring its CPU caps, and
>WARN if a cap is set or cleared if KVM isn't in its configuration stage.
>Modifying CPU caps after {svm,vmx}_set_cpu_caps() can be fatal to KVM, as
>vendor setup code expects the CPU caps to be frozen at that point, e.g.
>will do additional configuration based on the caps.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

