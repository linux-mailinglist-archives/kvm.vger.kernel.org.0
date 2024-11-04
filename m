Return-Path: <kvm+bounces-30452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 703479BADDC
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C5DCCB21A3E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B5AC1A7AF6;
	Mon,  4 Nov 2024 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uq/x89YP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE9165F04;
	Mon,  4 Nov 2024 08:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730708276; cv=fail; b=Zp9GedQsJ6sBDgytkzRmjT0s4wq6l3e9tVf1S11aG90+RoQ794bQAiTfpfGdhCgc54NXhpLk3I/p69G99s8nRCwUBosQi/TvdXWLl2Yh0tNEJLQMcqn50u/p2phcP98VTUvql3Wi2QATDEOGQ/T5j8H4/xFABPqD7JMECFmvOcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730708276; c=relaxed/simple;
	bh=LyjEJY3fFobSln8NulQFAPn+E5fEgDKWS6LfpHGu5K8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Duzw6pCtqU0Q5AsQQihm9AVRWzLpxeX8CZSBpPSzzL1m3EEnZ8+UO4qdSmtIttambVHxmEE/2qie3przGSulOZf7i1pNQMFZzh6Ic/APAcfK+Dab3b/htqvOgT5QzFAAzunXRx3VPtSGNydGMO3SI+I0oQJxxlN70p3HLxX+i58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uq/x89YP; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730708274; x=1762244274;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LyjEJY3fFobSln8NulQFAPn+E5fEgDKWS6LfpHGu5K8=;
  b=Uq/x89YPkR2y8k93OlGDS4ESFHTNbaSBiDO2s5VT8yT0zUF4Vgz5yEpM
   8Z87o1VZ0i0EjHq/LVTGXZDRdMpzPIZZfUPOTP11K3IkoBWJtG8K9xNQN
   Kndsf2W4ql7SzYXyVXmYCsYPs0X5dOL8nOxgth6nogA3qGetm5oA7dumH
   T7bIv6zUBLt75M+VGLR3H2IQmuEWrHeTyFa6g/zo0MGtYg59rlG2OS9tO
   kK4R26YNYeendFTitrn/AjSCq969C3EwjBfyKzi5sxO1N3d1BBv3fxOrp
   ICxRCQr5gzagmK3xMcAkXwnIUzP1SRR9vWSJkQhFKVecKNfBo/62LoB73
   w==;
X-CSE-ConnectionGUID: /Do2mk0qTcGd/ZH3fkEs9g==
X-CSE-MsgGUID: d73AFbLxTGq8+1MDBsvbLQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11245"; a="34181673"
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="34181673"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:17:53 -0800
X-CSE-ConnectionGUID: kkNOMBHZSCiI8KiatRRsfA==
X-CSE-MsgGUID: Q3wKmodtQCiveF2eih/3Rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="83107369"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 00:17:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 00:17:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 00:17:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 00:17:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SqI+Flx5rpst2VtMNMFVrInxJuZZytPO4Ct5fIuX9gwxN+YGTQ3cOmv+SeuXyZHaDFnTRidgFfjz1025kWCK5TeXmg+m8G54OSAqo4GKxrNgy7rUDDn2TWDScF/15DwLBnQE21f5LXOkSA3FrVzDDBQKug6wyw0DxkAdOKfdyfLF+JRj1dCMXcGNajxT6vb64qzysE5etKOJXpZQE5oOmDDKtrGujPtHuCeE3TP9Bim36IMlQjTSiISCCP9uLs0J4urDBmDZOvWAAsUzDXnsNA4ry/KvQXS4y4fkk8U0dIwKVnOPESdJJ9f3y0wcLeU8mtWevMbwS/oBBEnfoLgVmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ep1MheLdNP464XcFEr97n0Ftkp0v+oGi96T3Ewy07KI=;
 b=E4/Jix7uKicv11W1hBBZQBnweW1IEQYyKPKztPAd17VIlBr5tumFMpAtZkextghMEqemMJaQBQnEptb/1bVcH7lBiEcFkrzFSPywF9sP1l8f1EnuXFw3fhDAhG0Gcj8FBkf/wWn8TbzmHY0NCvM75cYXq3iVKDgTApUigCobWjYvmuEQORrzGR8BuCyy7O6DblVmlwNqZLIsnvN9RbpJZPbl7Un1ZBx7H/X0tfLA6mbBOL+SXYRWTcblY9PwFcxEeG4gx8loh0mMmjdC9A6eDzGDuyZUBsCq9hU3SIqVNZPTMl8yDnfTWFA5wQPhMbu6nuF4dfA8toeTwmkWJttiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ0PR11MB5893.namprd11.prod.outlook.com (2603:10b6:a03:429::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 08:17:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Mon, 4 Nov 2024
 08:17:50 +0000
Date: Mon, 4 Nov 2024 16:17:42 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Markku =?iso-8859-1?Q?Ahvenj=E4rvi?=
	<mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Subject: Re: [PATCH 2/2] KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2
 is active w/o VID
Message-ID: <ZyiDJhTkPclSQYIk@intel.com>
References: <20241101192114.1810198-1-seanjc@google.com>
 <20241101192114.1810198-3-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241101192114.1810198-3-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ0PR11MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c94a20-9cb7-4078-5537-08dcfca92c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IOcH4hXkxi0VcxOlLUmwW3ZWkSfa7SYf/4Zqh0yWFhJbPDE19r1rdsrJ0NsI?=
 =?us-ascii?Q?WPtAE7a7OK8+vUFG++HOZRXtDfDMTdLGKZTWCO2S5NHPkzki3Eu8mdCDUyd+?=
 =?us-ascii?Q?95jyeEuBzYBOGWncAt8HDJb3vVO5w+nNKZMsq7byP4oj7K2L4/OPVSTTrIBJ?=
 =?us-ascii?Q?GmH/NfbwXaewaCAiXBRY4vPjLneSA0QmrHNL8kqYY1lgahXm0mfoCYF6oe6l?=
 =?us-ascii?Q?SmRCYrJZuyC/P+nA8vfJDhFoBZYt98uxcwB56YjMO1wtjSTi9nYn6ajJgaDN?=
 =?us-ascii?Q?o6o60jq4t6NJsxbLrdcWdUz5ymtDVRGxeI4VXKnyygMeyEb3qeR6ThNSes3u?=
 =?us-ascii?Q?bCkiLsKSVv+4xkH2VK+Zp/E69XHs9Z+IOmgg6gzg6IIYAw0dh3rT0ee166U5?=
 =?us-ascii?Q?M+/C6ztCQ1EULtqkUqhq9uyQRcquwhLdM4A/mSezsQ8rMlAgAJ5d865fYvnd?=
 =?us-ascii?Q?NNSxpkEm8qzJcs+N1v5yv4dSB3oBE4CuSCwmW68HutRCpQME3NriF/aLwIkK?=
 =?us-ascii?Q?8W89//k248L07lcFJEUKs4X1spo+uQhUEgShpZpZBw1/rRdVFCJyZbXqsNNV?=
 =?us-ascii?Q?Q5yGR5pHAgZwUZPj9iV7vDWZ/brUWP7gGxJkWQaFE7p0zCQ0bTuWxNIK4LcB?=
 =?us-ascii?Q?q/dqJ1Gh3BQnUg7kZGcjBdVFnfEVp8Ui2dcZCRnN+a1xNEX4+XhFR2dulHAs?=
 =?us-ascii?Q?DWlhGTtO8PYD1/EsRBscgFQhtrOzbfszBtPYxYyzJObO9jjLevo9m5MxpiCI?=
 =?us-ascii?Q?Rzc1tfPhtQwccC3M9Uq2jiDy/i+bJYTwYtDD3Cx9s2znmD+6rv0jkENsNzIn?=
 =?us-ascii?Q?TPS39eza3UvsTQZzQMzmsB77ecH/AITIAZYIytZtqDarQwcPGZL0zJXX7fJp?=
 =?us-ascii?Q?1V6iGzW60flQijBaYX5ULvl+y9TFG2upZRSRsuUezSGbWp3caFkaoHE4byll?=
 =?us-ascii?Q?A3ctgEuH1ltcPfBs1jcOqHhKdc4e9EF2QYp7SM1O4dNCWuKMxBm+KpHtqC8n?=
 =?us-ascii?Q?Se1XxxHx+HLIgrT0JSkcx1LuwLIaE+/pPfDWsj9bxzNSIWL2NrvhAA1UPNQ2?=
 =?us-ascii?Q?XXLeb2FE2Mfs654rYB5Z2SEQCZV+0WXegjTfVGrG2h1tC826u2JZHQCivqdx?=
 =?us-ascii?Q?ZJthgG+6Quml87t4V7ygYgQZIjhJN+mv0Dek2Ted0C7dsc3WtnHwyBwafTz1?=
 =?us-ascii?Q?EEw3+ZBDeTAoSqpgOyMcXK7x/Ihrj9VDPs0Bd6CUlJ6RyvLXW1RkjtLcZ87Y?=
 =?us-ascii?Q?OriPZmpSgZCnwXV8AEtegdx7VEMkjUG/HiMrwpUPsQQamfAyD5bQ3SBLMl3S?=
 =?us-ascii?Q?560dfHKGfCfI00Fxa0zuDacT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g9XQ85hSkP3+qMLCgtgJUKHpCFu/yC0qzdo9RFNH4DZ8Dvf9I1gVqIaIs2kx?=
 =?us-ascii?Q?f/90Om8Lc7M87xup8IShKYUPiaym6HSmJVwK+FAx8oNi+pct+nGouT8QQFWF?=
 =?us-ascii?Q?vmfNgUR42keaPRykkmi3bY7r49UhB3zStJVM22oBH1dV4lHrCOK624ddEiMg?=
 =?us-ascii?Q?lu78E4RCZqqaFV8U+OUxCfObuEd9lhRc/fsqw6aR9QREdPCMpvzAhZNg3046?=
 =?us-ascii?Q?DEMl9djB2FvaYfo+zbSYPtez15aVOqDzLOSgFaYl+CU+B4EMy/Y1+sw1UXIG?=
 =?us-ascii?Q?5yCK8F/OEQyfDic30/7XAb2GHHXZS60izc5ulc8sU2CpYqy1Sd4464WpB9/7?=
 =?us-ascii?Q?P0LSrAhYNaBvlyK1JcPNMD/HNJ4kFkA4gRtzgh7oPi9VmvHtrdzclkfbBsPd?=
 =?us-ascii?Q?IEauZaYS5VGMFGvkuR546SLMahmTCA1VF6Q6BIc2o8DHS75x8G8+5084hk+h?=
 =?us-ascii?Q?XZ/6SQKl9Flyn8t6qKdkSTPkg2S+nS1zY+s5mCfZO1DYXbMsxO+egvaUdft8?=
 =?us-ascii?Q?EMfDLBXEyDqdYoubQg33xG7wy39bIZDaylYa9dSUQam1KN4p6Ct8oMRxjR2J?=
 =?us-ascii?Q?pHvtPA3zXgLUIhNjlYQZIHhHb/WtbWiyBkCcLEVsjYK3+X/mRO2MK6b5TafD?=
 =?us-ascii?Q?mmy94YQgvA1XXxKTWKvLU13v7IFri1xmH8lKURFuOOflOtY0Stum2rPRozCV?=
 =?us-ascii?Q?59ofLsVCbiWncAKq0URDr9gCw5eg/PfsmPDzgaChuR1dPW3KQRfx4XS7/t3m?=
 =?us-ascii?Q?S8h6J6En3viVIyNwgGOFB+WKxMV3EyAWb4nfJWQQEugQk7B6Ei/vG9qheGrm?=
 =?us-ascii?Q?jqHWlTm9i1X32Sx7SUcUmNJsaGp5kL9ccoL1yQOhH2cUkqJ0+5RCGrC7BF1M?=
 =?us-ascii?Q?GbIj3SqgizgyEosDrG1kRnh50P9Dvubcp8jUrSHDHmfC++7OHKBOIa49y9W3?=
 =?us-ascii?Q?lkSNusDS+Qy/xRajOujBSlo3a2vZCe3tffzkWDvVJx2hSJyIMmFrTcJMnv3s?=
 =?us-ascii?Q?uJnwDifRmhes7oZOK2S84o8uHaMVHbS056kWSM3NNoMbhPs/VIyFWqLUdkOj?=
 =?us-ascii?Q?DYYiax/pGpzEO6fFDPnpFddB2IwbzwDqhQ+CnFem0fV+N/omBHnmy12NaFZx?=
 =?us-ascii?Q?BMHAkO2xlviDzoayfI113F8bnnDDzZf805Y4yMuUJYkKNXjtRJ0pcnrRnlFg?=
 =?us-ascii?Q?VQQW2VZiKbzABFKolvia+GZDebLOdie9EtlOShwhdUyF7XRiXDhcqTRl8UIc?=
 =?us-ascii?Q?Zct5/EPwouzWttF7lKlbzuilmgUr+r2Q4fzgUzxoCH6bTaEkz6KN390eQEMY?=
 =?us-ascii?Q?wgSZFJq9ThWMfljubQ+OR+Or8x4t7EnMgZUOZsG81Yty9v5/vlQ6+8kVcIbl?=
 =?us-ascii?Q?bGbJmT3GTRNo2/XQAb7ZWQ7xOL+78iSM9HAr07Z7+7A2qehZdI495cS1ShqC?=
 =?us-ascii?Q?V1YKQukJ5q+vhZNx/nNc4hux8xn3jrekGok/HJEvwD9x473CB7cWhOaZ5VmS?=
 =?us-ascii?Q?p5z35iX4P9Cd7i3uopXz3TD0vvz0jFjrigQ3mRuQLqMqEnWfYB0a/PNAA4gn?=
 =?us-ascii?Q?Iy1JwjHAdFS4GSkWbJZoKeKRgS4f0tRoKFz4zTow?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c94a20-9cb7-4078-5537-08dcfca92c3c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 08:17:50.2924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xb7gW+vpz/iQ2SP8Oh7XHkU4eSpdp2Pdx7XM2WMx5jSDRXV1/AAAle90UitVUVENHPoTdjzL+ITdhCOx1QDz5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5893
X-OriginatorOrg: intel.com

>@@ -6873,6 +6873,23 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
> 	u16 status;
> 	u8 old;
> 
>+	/*
>+	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
>+	 * is only relevant for if and only if Virtual Interrupt Delivery is
>+	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
>+	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
>+	 * VM-Exit, otherwise L1 with run with a stale SVI.
>+	 */
>+	if (is_guest_mode(vcpu)) {
>+		/*
>+		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
>+		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
>+		 */
>+		WARN_ON_ONCE(nested_cpu_has_vid(get_vmcs12(vcpu)));

This function can be called in other scenarios, e.g., from
kvm_apic_set_state(). Is it possible for the userspace VMM to set the APIC
state while L2 is running and VID is enabled for L2? If so, this warning could
be triggered by the userspace VMM.

Anyway, I verified this patch can fix the reported issue. So,

Tested-by: Chao Gao <chao.gao@intel.com>

>+		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>+		return;
>+	}
>+
> 	if (max_isr == -1)
> 		max_isr = 0;

