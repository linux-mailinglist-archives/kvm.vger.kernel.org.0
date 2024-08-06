Return-Path: <kvm+bounces-23380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24D369492DE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA21C282BFE
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6741D1D27A3;
	Tue,  6 Aug 2024 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kKlZsDsH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B160F17ADE0
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722954060; cv=fail; b=iI3Ee2QDLZfnOGD4U3k7OtPGl0udoR10MzMw5p4LTcGui+Jd3nsqjdgWSRdb8+rAprlQy8fWd65g+dRRyWHx+VLC57BPxy1d5Ix/pJarS8GIxV0aO9pYaulcenzJPotgFh4SH3+NcXABLCdmp/NjpORNB5w0+vdiegAMR+bHhug=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722954060; c=relaxed/simple;
	bh=duvX/b+VJW+ssP2Am+zSxeT06PLawARa9tpAFEQZ41o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gBjg1nS2hWFC0gerdCU6hEAGFn5ljtw0VkLxs0fG0C0ChD4oZZro9G9aXmJmNtODA7c9xn0EauFf8gvbL4DoJ7vqYekKrN+NZLzSkf80eJxq8YtvxjGbW7liem8e6NJjofn3Zaf+DMIW0xgxIrDBiBTVWdWD8j2xS7fwE7nixzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kKlZsDsH; arc=fail smtp.client-ip=40.107.100.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9N+NP1wAa+PX4yzrHgTyiX9deHdfZUGoIHTOvguCV8exiTYmMPBEdFt/jTwFh0TxV38smdeL+s4IAQX3/L5kMEf1PsBrrx4dHMY14Iro1XorHnHUVmSq6S+CUXGMNsT3OmTtOBIHeJe1i7MjJaPaga9jFe78SlPOwCpupgSrLHT6qcHPo15Z+bgewPJwXLILWcliDXy+32vaHADZA8gTIh3FyEBtqtG0iNLbkAx358LmxTTagxyr64R0KRHG2/+IdZ7atqenJo586dKDzcO8JDmMfVERyOfTU99lNaU4CCuhnN3EUcJ11/hxsPjOdjbt6cKmgmspJSqtmIYhey0Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKZbcKk3pMDRcWaXLpz+ud9PwZDCsxDwOKY2T8Q/FhI=;
 b=onPLE2rSyGoIHqYgo+gN82ytgtZRrpvZOK49FEyWj2228azmGU8xvjM8PcwLR2HLkcS3R90pDjIatBWvNgQLpmM9rlJE+nTgBAUhHt9aLT9uJOyFlb9YLa8WrnR1K0lH/pjDhdUCm1QICztOjMHOWvqicyD+XrytTCynmr4shP0w6Yw3Z8kOxzKznySQmQ0DHY35l7a0s4KIA+KJ+C/PIZv8hep6Cucf2i60Di9LowsRPwJDkynQVN6n0kLI/Uy8EFq1AaPxMSR5DqVbS/W+lgQmSjQmi30XsxzhLcZcxL7vo5Y1ULxv0H/zbxvTBObgZruY3eqnH0GEIvKpQ8W6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKZbcKk3pMDRcWaXLpz+ud9PwZDCsxDwOKY2T8Q/FhI=;
 b=kKlZsDsH5hC3a2wQZj6QMEfh2/B528LpQi1E6mw7LvXRGxToU3k0Ozv91/q5a30kZBawSLupUm3Il4ea7eQz8+ZJ4mvExBwMakBXvl3v14aQ2mNSpvkejiWIYWp0llFDdOL58OadlSm7zxWKZ34TJiiLgGnIEaSEnAEP7nqa8i/LgWjUhjfvX10bAqjQ2JigQ9xUwA5aQsEsZJ+xY2tmO/yOeUgfamrpwh8E8dNchOxr9vK0fj/hY3pNw0kRFVZPinjoYH/5MSouVb3UGUzxWi0i0dSXWccZzhMhr6I1sOfFwOTHv8P8YPOq+CaycoFV/sfU33bkuaKxN3ohFXx6wQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB8150.namprd12.prod.outlook.com (2603:10b6:510:293::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 6 Aug
 2024 14:20:51 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 14:20:48 +0000
Date: Tue, 6 Aug 2024 11:20:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240806142047.GN478300@nvidia.com>
References: <20240426141117.GY941030@nvidia.com>
 <20240426141354.1f003b5f.alex.williamson@redhat.com>
 <20240429174442.GJ941030@nvidia.com>
 <BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240730113517.27b06160.alex.williamson@redhat.com>
 <BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240731110436.7a569ce0.alex.williamson@redhat.com>
 <BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB8150:EE_
X-MS-Office365-Filtering-Correlation-Id: cb549e53-204c-4b05-7353-08dcb622f7f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yCqosq+loPQFSIzOHLIWbHBvQLHb6oEhDjPd+04DyuiobCYdc+Qij0HrTHXb?=
 =?us-ascii?Q?TfAbKhYQ5ya9pAVaiZfH3SzFyr9B21TMRzLx8aGPWBbq3hxfjXt2bX0rFjiv?=
 =?us-ascii?Q?YmQeH7wX39Nnovv7E7504YTehzL9rmrSRUNVEDBeCKwj/a/eiKZlO8z2KDBM?=
 =?us-ascii?Q?PeCQoInzPYTh38b95IGHbK5WGwdP5/QPQufhOZeMGE357CsdgwXr4tL+5YOr?=
 =?us-ascii?Q?6LjtZz7M3LwlEtaeNOA/8xWgjAZbuQLtFa+tZ6W5pxbbRN1YfBkLp5XF06xY?=
 =?us-ascii?Q?M6hi6FitvKobNmnak78P/gDkMzkv3prtLOJROou/94hQfmlx90F+71wEv4nW?=
 =?us-ascii?Q?ffnn/vwS23H6rKVnnF15Amf8hFm3lTxfeWHc7/Vl7LEn9yJpAr0SIluBCpEY?=
 =?us-ascii?Q?cUSZsCcLTpE3FWdQYTNhXTuDfvLdObcpmD8W2A0mLW0dUjV2n0cMpNj7SDHl?=
 =?us-ascii?Q?oPgj9k/GqLeTGK/EnOqCX4e52WLlcMBjQaWMYLpWqcszM9mh+U/8tiovZr5I?=
 =?us-ascii?Q?wc8tmLS9HYAxQeKMaQRGnFo2TmYRhOFKpXqbA2UK5B+aWgrBEGamfe5BA64r?=
 =?us-ascii?Q?UjsQmDpBkhrwDM3uyThldBak3/EEiFpJV51aNrs9nGcivjXzdbZMedVctS/P?=
 =?us-ascii?Q?7BRHhEF2KWiKOpSHWa0VykyWm6Fm7Bb5d4Ob9oqGaVWmuFHkf6vBmnZ+BwN4?=
 =?us-ascii?Q?+IXQ7c73F9kxwCMPIr9jxCpmX3gldevapYiPF87fyrVeMHOdxklr0IeMhFKP?=
 =?us-ascii?Q?W7wWjZG3lFUG4Y0Vxb1Rp5L/LIBjY1V3s+HP6F6jYC6H0q456ZzvUuPXcVW/?=
 =?us-ascii?Q?ZI+wKvuHIgfClTR5ivn9+U60FIjL7mM6Dx+XBHyygBMTMvaopBd5QyM/GDlZ?=
 =?us-ascii?Q?+YPsqZvU8QpRiFtL7lQ5GdiRNyV/mEfkZSI5YG8HlmxkwZ/4WB8Y8oOM/MLY?=
 =?us-ascii?Q?n4gxt+iK7RPmqB7I7JlwCM/R7DZADM6ul58yDfhL9mmmAZ5RyDn+Jbe8sf9d?=
 =?us-ascii?Q?e+Z+KS2F3OUaJcTBbJoReCOyR6ELM3LWhwCmlqkB7/gi29zD21V1DSMmezS8?=
 =?us-ascii?Q?APBMLa7UNW0a5R4bx/IrOj5uRlMg9djC5nXVBTRx2vs+uNOMqVHgO1adyujA?=
 =?us-ascii?Q?HKcl9RsbcmnPJk6IWfVYTpk68okrPlwQu3f577XgAi93zu6kQvGaRX8ymxqs?=
 =?us-ascii?Q?gU2DpGMIIlEIpQaMGlSAWRDtIcqWLXp3UnqxcDQKO8yEASBncAC3HsvVy8zB?=
 =?us-ascii?Q?v4R/lRNXw71l0JbS0RrKFUTcOzAI+npk4Mr2xaWI4qttnVzfFHU2I9HYjWGx?=
 =?us-ascii?Q?TmY0lG0B0l0jLIT52yt5trT2Syx+YrOLqCsIpxRxhrGohw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zKtn3+Oen5pBdr9PQORQ76OBtfqEs8uagzYqkpGNSvfkZ98EDsTChSfOlOW5?=
 =?us-ascii?Q?PIrVUzymlrMz6Ahlzc9vfJVhBrjJEHf0qpVEM8lv+DUptN37NImwi4AuAWPT?=
 =?us-ascii?Q?JnuY34r4S5r4BF/ZgtoqdAUsfFjShYeLj2LivQr8yJpzeDcL+Jfu+27k8+bS?=
 =?us-ascii?Q?4BdFulT5qhSPVBFlfnW+29ZbslyKtVwen46bbKD+h25RkqwMrW0JDsusDdP0?=
 =?us-ascii?Q?mh7qRJpxUPkAN4BwocJTETm8BjGhrvx7duICFxMjT8g6U0Y2Euj/6cL2i3qU?=
 =?us-ascii?Q?RP3bqfsJ0CsFolixJkvYqard25e0moXSJJPtNB8yua/XhIfORwz/SLkgjy+X?=
 =?us-ascii?Q?W3gs5dCdV+pQ4MVYi4qQMihlbbY5y0ip5rn7eYv/CRpZiLvrNv63ra8N4GK8?=
 =?us-ascii?Q?Ks8Wnq+wmBmWHKA9MotrsbiT1O1dTELI4r5pv4dcG/4jSfwYFMzxTW3DFY6B?=
 =?us-ascii?Q?bSiZ+YFu3HBfE9yRYv0UEPtUWjn+LpemuahK+V5rAz1wkN5X6JXJf7O7Yr1b?=
 =?us-ascii?Q?tQjojIEZwYDkoso3677EKYS2rSmJ2hzSQ7iNyH1SrXIGhA9ex+xFJ3I/PZWs?=
 =?us-ascii?Q?y12cPlLwpo/h9TusIq0w/f0fOkYLJEoADn1BlIFf3aUG/LiyYvI3/mHKfyLH?=
 =?us-ascii?Q?AKK29eA3wb9YDud8MiscSojJ2f4+SnfLX5H7hGvLLZdWdjFZ5n3c5Nz+qZ9k?=
 =?us-ascii?Q?8/DU1o6da13eAXBNUUIw9PBjbC5VHVWA7+sWUBBuva27zRuOT5X0D9KSuW6b?=
 =?us-ascii?Q?Z6tfEZB1RquK2C67BPL3C5T11V1SiUHqITkMBOQzT6EQMjnalkCTQ3e7rYX8?=
 =?us-ascii?Q?doivles/pGfGPAcA/0pOad3y1zNnwTXhqvmg9GqPh8WRQVckMSwJz2ivvQQ5?=
 =?us-ascii?Q?PEUVfJ0L2rs7K3vRziDdVyl9R+DMpyD/rK9ObQCYmDdbGoYva1dzqpG2hme9?=
 =?us-ascii?Q?hJ7uLUquHunp/EdcAkXjZLCPtzt8XGvpsgxQ8XLYKeW1C4whb+Yl/yWQOrUl?=
 =?us-ascii?Q?j8pTTW4EtDjuRe+1JqklJ9tn2Gk6IxCYnmQCCKMC7wjh6R5L7f/7/8jDvavZ?=
 =?us-ascii?Q?Rogc1zr4Yv8JBj2TgJB5CW1OXRql3QFv3ND7GX78E/Si+EdtYIkkm7w554pW?=
 =?us-ascii?Q?NzSevWqMfuhcg5TXLxdiuGtAaUay8nk/hgrkpMcKkVi4UOnG+Rjp3ly7LgOw?=
 =?us-ascii?Q?5RMZWx2xluKrAJKHwNjeohbvhnF7tUP4zZLvWlZRhQIvZafxgHJz0RW0iAVH?=
 =?us-ascii?Q?M/dD/Bmgjk2jyhJFhk8rSePjUwJecAKnDbZTYoyROcVSXEn9M4A2a7cUg2F3?=
 =?us-ascii?Q?dM+0zOFTpF3w5+6BW+UEfDgN3qoOnGxriDXDEsdqTQxP87KHILlGxVf9llCi?=
 =?us-ascii?Q?0wSt5TXx8rz3qe1dJinAB/rkMlSLXhnZo+C/T9EKiaZA3IEQJBzsePw/Y3Zh?=
 =?us-ascii?Q?ZElrwmpP+qyE05GlBM//pMpxlQyEiJOVrR3PBKBKrEZI0ABWqJM9C0wJiXSK?=
 =?us-ascii?Q?DhfE9aLuKOeTa+eRUXDEJLixyjU5qz66wr3p3LE/aCnzviWtsny10f3/mT2r?=
 =?us-ascii?Q?uWz65Ba/R/+y7AngHGxt0OGJfgd3TdLCkRkqrFhT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb549e53-204c-4b05-7353-08dcb622f7f2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 14:20:48.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9U0fxV4fBAEDQOYp6lJmuYnKvNH+aWgrhcvwx0LqbRlOVk3pC8SmvXvUGnMmZzw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8150

On Mon, Aug 05, 2024 at 05:35:17AM +0000, Tian, Kevin wrote:

> Okay. With that I edited my earlier reply a bit by removing the note
> of cmdline option, adding DVSEC possibility, and making it clear that
> the PASID option is in vIOMMU:
> 
> "
> Overall this sounds a feasible path to move forward - starting with
> the VMM to find the gap automatically if PASID is opted in vIOMMU. 
> Devices with hidden registers may fail. Devices with volatile
> config space due to FW upgrade or cross vendors may fail to migrate.
> Then evolving it to the file-based scheme, and there is time to discuss
> any intermediate improvement (fixed quirks, DVSEC, etc.) in between.
> "
> 
> Jason, your thoughts?

This thread is big and I've read it quickly, but I could support the
above summary.

For migration, where we are today, it is completely up to the device
and it's FW to present a new config space that is stable across
migration. In practice this means the device needs to have pre-set the
PF to whatever config state it needs during FLR, and refuse to migrate
if things are not correct.

Moving away from that limitation toward a VMM created stable config
space is definitely a long term interest. I understand other VMM's are
already doing things like this.

It seems we need more time to bake on this long term direction. I
suggested a text file as something very general, but we can do other
things too.

What I see as the general industry direction is toward a very
perspective vPCI function, where you might have v1, v2, etc of a
device that present different config space/behavior/etc. I expect
standards bodies are going to define reference vPCI functions for
their standards along these lines. This would specify all the MMIO
memory layout and every bit of config space right down to each offset
and bit.

This is the sort of restriction that will be needed to allow more
generic live migration between different devices and different
FW. There is a pretty clear role here for the VMM to synthesize a
highly perscribed config space. How we get there and how the libvirt
stack should support this, I don't know.

Jason

