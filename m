Return-Path: <kvm+bounces-20791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D3D91DDE4
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 13:30:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3478F1C225EC
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D26613E043;
	Mon,  1 Jul 2024 11:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwC7wb1C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4062B9C6;
	Mon,  1 Jul 2024 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719833433; cv=fail; b=I32VwUWxLOX1LH5fejjj7WKXvsT4kVJ6JlDNVNYGDpdL5Ya2mMpZYOD17M3P8Fax3/y9ZGVTMMohPqdrX2WiEx4YSL4aoCN8JoW/rlZWlPRkm1tQhzGDEEn+Lb7zC5S5duXJr3Vco+NEaCsu2r+0rVgsin2rWP2IGg/+d/4IVRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719833433; c=relaxed/simple;
	bh=HC/TiN6xQYufu6i6azvjyyL0YsaAgQ6DUxSRP3hGo30=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jwJ7jjs7rkDVlDKg5U741ZEWB2xfsI5VuyUDpVjol44d9xzTzahcDl6w1AtzbmbYbzuNAlcMXacsc1TpkeNiJMxSz7VKHikPCoqb5H5MmQ7Ekh4J0NIin0xAXpUyK5S4f9Qdni9iadwHvXEvQz/33HLORtsZfCpKaI5BpPfOUIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwC7wb1C; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719833432; x=1751369432;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=HC/TiN6xQYufu6i6azvjyyL0YsaAgQ6DUxSRP3hGo30=;
  b=bwC7wb1CI1sI8+MfyY9J7Cb/zh4Vz714YJe783jO6wzKwnq2Z8wX5EmB
   hf2WHdEQAntcaXCwgHiqjhzo4EEBofWZB4QmNDHp2G2352xBl6WNwrg1l
   Y0iVLLJFQsJxvFL6b5XPje6y4Q3RDI7IEbT1k4paXNDzsaSgOIDcbbUMD
   SdZ4p7thCUx/fDfM0bZIBKg9tlV0qgsJaAV0z1cZkJteQ76fVkFyn/E5Z
   Im0wOjusIEQc7LaJ4xBui44UiFfN2raRHCPTA8za6nG0BvHfZRsSI/oLg
   W09a/yVXtHMGqDY4hfpO/e3zQ+hTGwggDvZGF6UDkfMpOyLVvlNsv+ekD
   w==;
X-CSE-ConnectionGUID: FLIz9uZSTUWYB6qRjC9PKw==
X-CSE-MsgGUID: wL+6EiyVTUqoB7/q71Lw8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11119"; a="12335574"
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="12335574"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 04:30:31 -0700
X-CSE-ConnectionGUID: lBmhck9MSny7i6iOkgrWKQ==
X-CSE-MsgGUID: bDZ3tst8TqC14q+Qv/sa1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="46152805"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 04:30:30 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 04:30:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 04:30:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 04:30:29 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 04:30:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+kWjLINz458A1ZQnJLQf+ug3ECuKfeF5ccWo61ZXWnnX/sRXfq5uLQ0hX3x+YH2/KW9naP1vj1lEuoMkyhX+u589tiDc8glFCae30REUtmbqKSamAcVqlK4sahxC0aRhN/iske5R6hOl0iFrmfwnVmMjtkCN/vGUT/LHhMafaRYsYOzO1mLPOYDlcpiYx3c84Lvqu6i/lrcTrD1fNC38okSMNbaCzQ9ygeO15bwMQsnK1/fkwlWK7YMs/iFa2SbTtPniF7brCYZay4+6JQQQnNFMhVuMZOiQCZq5bUrcUeyMLDJL7JHgzWrE6EQszdW0mT7sFQEz1TPB4TfNhebYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTTVyeeS+47SbJ8BzPmOLo2klrK3Uv3F5VDj29jMxO4=;
 b=R5qaTmD7krqwFK/0cGFfuuVmWjUsiKF0PK4Zxc6jeqdZFPEbrQHtvUsEHlTWsxr4Wi4JTDdVnx/FUs3L4pG3EMuGYiMS3d2T62ER83W6ReJQf1a1tZdvRF6LnhK5ynTsUZthy0R8qISqRKboLLj4XpRebX8NOG/RXfzzv/krs+A58o6DtTh9gcebjW6voEee/cEFVHl5n/QPmsLA4MbEhNGtECSMpvMNg/ICoOXTdw9xM1A9RaKCYdmxiHFsEMljLBD9AKlBtDLWRHAMi8OwknKpeiblqWgkCPHu9XntB0XRqJDn01tyQHAT6WXgRdojoK6mtNVnvCcHdP2IO1r5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB5823.namprd11.prod.outlook.com (2603:10b6:303:186::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Mon, 1 Jul
 2024 11:30:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7719.029; Mon, 1 Jul 2024
 11:30:24 +0000
Date: Mon, 1 Jul 2024 19:29:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<peterx@redhat.com>, <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZoKTBU2VaW0IazUi@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240617095332.30543-1-yan.y.zhao@intel.com>
 <edc71108-2e2e-455d-b109-4542a845cf6e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <edc71108-2e2e-455d-b109-4542a845cf6e@intel.com>
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB5823:EE_
X-MS-Office365-Filtering-Correlation-Id: a322b11f-5944-4204-68be-08dc99c132fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?KoIX0pElepIk+c56IgolKLry8yQ6MgEnyNZ4phpvDrxxGuVpkTfo3CtWwILL?=
 =?us-ascii?Q?sA3ilgpNzD/i0lGqu7H3k3ibY5ODXT3scLtnB9pT2airtR2PvJykMVRZhLzf?=
 =?us-ascii?Q?OWHwVc1MoFrn5/j4dodjgEOjKXDY2u5hGJZ00LI2Dqb0P4/GbkVb8Wt1Y7n+?=
 =?us-ascii?Q?OXHXx4H6y6CjUKqM36mZ6wuGwveBzVRHeVv9xagui64/PesyKZG3jkXdGGvd?=
 =?us-ascii?Q?0OibAzcVma6mC4LKUQZjYOPeVnGD6L19GH5PLx65T+vMrhbdDON8XXj6qiUH?=
 =?us-ascii?Q?A5Sl+lxKXdqcH+zzSWMEYLZEFyLKjUnMgMAEJWbXh1TgIH3dSQ5SNiMM3R1z?=
 =?us-ascii?Q?mF0ON8sEMZ+97z3ixOwhIxhoioL1w3yKflyr0KezSQ6DLJLzNMgHyG48gOqB?=
 =?us-ascii?Q?EQB4+I9JiMrh8z+D8OnOH0BhF33NoWYCls6cs2kA3V2R329pe+LQG3UElPZ5?=
 =?us-ascii?Q?TDFhpYjAyfVtiVj1Jc35YN150efj2tXsRaCKD92R9CArkjP3KjZUJ3ktHtd2?=
 =?us-ascii?Q?BYzSCgYXBy2enH1bOvGesHZ+MmScie3nINq33N7gJC0eBxISVtt3r8gdhsaN?=
 =?us-ascii?Q?yB/9x57gH6iTZNlomAKOabO5nl2sYBHrQktnt227/NErBqZmhHMnpFydmXsi?=
 =?us-ascii?Q?Jt56kaE/AR4fwFO0qptcQZdi1rYo9R6GNMEcNh22NWUFO7kbhyRq34+dgmsq?=
 =?us-ascii?Q?JtJSI7J7AjvYuGneQ+72a52JYor4UeC9JdpMeuUH1ck5+/6b7Ow3an8iK5iQ?=
 =?us-ascii?Q?hHTHwj09WEXnzxR/6gFM6iO8uzlMvbqFRBc6lC0Ff0xCP+bYQ0J72nQFCDj1?=
 =?us-ascii?Q?fGDW3ynUL1pmilsljfwgoosp9zCCXgxvdkxaCnAZw2p0ZX/qfhQXvYy065Qs?=
 =?us-ascii?Q?BfGZRFRlbt7vBgoDOvhECd9FS8Qbkp/mfuSiFhfg5nZobZexJ/rH+slXrKK8?=
 =?us-ascii?Q?1WtGI+5LFEKHqyVkSeOT4j19Izl0qXv5DIMC2eZQpQ5/S32Irbv7ogpEm896?=
 =?us-ascii?Q?8+zie/3+UMvqidLHgjcBy6mJtv4oxzJRA9nYQuu4Gx5QAl9yu5UMN5A82z4u?=
 =?us-ascii?Q?4TDOVJkbDspe5JPgoPHYDCCIMaPptaW4h7S60JVDQk9Or4x4YuCz5liBs61C?=
 =?us-ascii?Q?dMWPqdPM6St2eaFXYPEvPe1dv5HGQN49OG5i6wQsDxszzem+R31BPi4X+pmb?=
 =?us-ascii?Q?ZbJ3dDGb5Plrjv9K+RGCAq2mEIgcDuKWN2yZbm5DK/rXfXG6UvR1Jb7BqJTr?=
 =?us-ascii?Q?T2rIDbek5Dnb6IIgcnGcSp9hilBqT6098GqlTQpFjwJXJm6ssUu83OtvHtIp?=
 =?us-ascii?Q?IN8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZl2cAxxW96eMBYZ+mWFVA2GmjR2RWGtelEyy0sz2su/ukt18O6IrkTsgmit?=
 =?us-ascii?Q?g6eW5K/Yxj31/4l5YgZBEEBhQctlfAfqBlWR9mmX3uWCWLRGnyMdTu+EHonF?=
 =?us-ascii?Q?MQt5+TRdgyazOpvUiTI+E6EJMwy06K5cYDrP7HU8cSgUrkUhhq0FTsK5BPFB?=
 =?us-ascii?Q?W7hS+13CWHhr06vjHn1+6hkbofaZ84DpIVooySNWJUOgDhpUzMuy3edi21ev?=
 =?us-ascii?Q?UZuOswU9sroztK60saan4HXZRxT6uIWNf4CEJXoI0kLI6ByFZzxlzWXpJGbJ?=
 =?us-ascii?Q?IpW2B1hC7BLJdd3XONwlapw/XZffjgSAG+8cL2sJrrIVXkPVxOr/ychNWvHZ?=
 =?us-ascii?Q?7Kvgh8pv31am3KvST1URQwpXSlWCYOIiZsKx0Wfdi3kA6Oo1O05DNRe50Xqr?=
 =?us-ascii?Q?0HNCco3NkYRIks2Wr8jtcQSvvGOVWFNWEL8BEW3niXQkyhOnx5/3a1V/c5Ky?=
 =?us-ascii?Q?GlfJWrfz5GSFerDZ4ge0aE8qFNfnobOxVN2JseL+j+0t5LjfzYuhN8IjvU/u?=
 =?us-ascii?Q?4loDX0rpL4Bg8ghmqT1gSMD+UtXc0L9dNR7cMdjpJJp+D7tHe7zbzEXGrlRP?=
 =?us-ascii?Q?IOKRPK3sEOs9ypC4cUWo964ZhL78lq6ZGw8DMm4npjx1Yd8IeLQiCHXDOCxi?=
 =?us-ascii?Q?CuSgzLkdGI3BCIRTEMzOPe6ExeZDn8cOHBumoDamAnyl3l3tels7b2o2nGbR?=
 =?us-ascii?Q?HEO6HadQ0HoY6Iv00qXCKZsQbviW8S3NzfoP2dZefQikpkr1ePTmx4dKJJP1?=
 =?us-ascii?Q?ZUfpA/A4RcTrJ58LBlOv8R2wF7KKAWdefFKkG2w5d3U088fSIYOF6BEs37C2?=
 =?us-ascii?Q?L8knW8Im6Zqykeha3/4hALk8RBzerBkDEvr9/bRJNNY8V2Ju0q5+j+f65JJ6?=
 =?us-ascii?Q?4xythWURJNVYyeTZac/fnYXt3bTQYLtYU2S3JQf7h1eefYlUeB6rRvgj629/?=
 =?us-ascii?Q?in2O+mpehsgVckx2yBbVropJAnxUA9sCy/kkVEXN8dFLpPsOEtr9GcByavP/?=
 =?us-ascii?Q?0ZIdv34h64u45VZlKxk50AZM/k420n6LVym/M9jSp7bX/Q2sI56pFlXbOBWd?=
 =?us-ascii?Q?2N7lnxI1g7l0/84x3bmMJpTv9u7ooXCeCG7T3LC62CdyfnlMvJNpIHFLeiud?=
 =?us-ascii?Q?z2ODZ2p71fTp2BDBWHKV/6RVE1XeVQws/PkCP9UrsxbJvZpnuOnzgnme/vjj?=
 =?us-ascii?Q?klJF5qM1Fp5a6Qo6YSjAyQaYhxbxp9aINKq4vSj2AgYhmBiHzFcwVMtFq5Am?=
 =?us-ascii?Q?qpqv4DbbmPNqm6kFah0MLcROdLUIfjDpuwwn2WeOY0LrBWjGgq8ytXHOwMcN?=
 =?us-ascii?Q?niiP1fXXH5kq+z9OenYQWANZ3IMazaiZBhAcCQoTIX91XQtiOvZXxOpcUs7E?=
 =?us-ascii?Q?pmv73Zl4gAmiVBDAVuG6PjpV/IlX5wJiK+xaXCZVIxiyFenB46edmo336YrC?=
 =?us-ascii?Q?kKZAGz3jywcXFvkN8JzABec7mD6fQvo1G60gyLK+yRupeXxTHvoR/2jQKa1E?=
 =?us-ascii?Q?NPsN01YnfQ1fzQaKzyO9QE2oO/XQxZ1CR1KXsEB1f4DMAMSboYaGyfrj+3Xr?=
 =?us-ascii?Q?nI5t9ifEqWxwPyvyfdlDCGToK7eYCCd5acFKojQp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a322b11f-5944-4204-68be-08dc99c132fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 11:30:24.4866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: za0CLjwAZpWnw2hyiFMTUDvknMArGNDhnq/6u+Po1FepwWYSLvYZhiWRSCwICqaLaTI1H7SJawscTiPReVOwNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5823
X-OriginatorOrg: intel.com

On Mon, Jul 01, 2024 at 03:54:19PM +0800, Yi Liu wrote:
> On 2024/6/17 17:53, Yan Zhao wrote:
> > Reuse file f_inode as vfio device inode and associate pseudo path file
> > directly to inode allocated in vfio fs.
> > 
> > Currently, vfio device is opened via 2 ways:
> > 1) via cdev open
> >     vfio device is opened with a cdev device with file f_inode and address
> >     space associated with a cdev inode;
> > 2) via VFIO_GROUP_GET_DEVICE_FD ioctl
> >     vfio device is opened via a pseudo path file with file f_inode and
> >     address space associated with an inode in anon_inode_fs.
> > 
> 
> You can simply say the cdev path and group path. :)
Ok, if they are well-known terms.

> 
> > In commit b7c5e64fecfa ("vfio: Create vfio_fs_type with inode per device"),
> > an inode in vfio fs is allocated for each vfio device. However, this inode
> > in vfio fs is only used to assign its address space to that of a file
> > associated with another cdev inode or an inode in anon_inode_fs.
> > 
> > This patch
> > - reuses cdev device inode as the vfio device inode when it's opened via
> >    cdev way;
> > - allocates an inode in vfio fs, associate it to the pseudo path file,
> >    and save it as the vfio device inode when the vfio device is opened via
> >    VFIO_GROUP_GET_DEVICE_FD ioctl.
> 
> So Alex's prior series only makes use of the i_mapping of the inode instead
> of associating the inode with the pseudo path file?
Right.

> > File address space will then point automatically to the address space of
> > the vfio device inode. Tools like unmap_mapping_range() can then zap all
> > vmas associated with the vfio device.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >   drivers/vfio/device_cdev.c |  9 ++++---
> >   drivers/vfio/group.c       | 21 ++--------------
> >   drivers/vfio/vfio.h        |  2 ++
> >   drivers/vfio/vfio_main.c   | 49 +++++++++++++++++++++++++++-----------
> >   4 files changed, 43 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index bb1817bd4ff3..a4eec8e88f5c 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -40,12 +40,11 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> >   	filep->private_data = df;
> >   	/*
> > -	 * Use the pseudo fs inode on the device to link all mmaps
> > -	 * to the same address space, allowing us to unmap all vmas
> > -	 * associated to this device using unmap_mapping_range().
> > +	 * mmaps are linked to the address space of the inode of device cdev.
> > +	 * Save the inode of device cdev in device->inode to allow
> > +	 * unmap_mapping_range() to unmap all vmas.
> >   	 */
> > -	filep->f_mapping = device->inode->i_mapping;
> > -
> > +	device->inode = inode;
> >   	return 0;
> >   err_put_registration:
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index ded364588d29..aaef188003b6 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -268,31 +268,14 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
> >   	if (ret)
> >   		goto err_free;
> > -	/*
> > -	 * We can't use anon_inode_getfd() because we need to modify
> > -	 * the f_mode flags directly to allow more than just ioctls
> > -	 */
> > -	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> > -				   df, O_RDWR);
> > +	filep = vfio_device_get_pseudo_file(device);
> >   	if (IS_ERR(filep)) {
> >   		ret = PTR_ERR(filep);
> >   		goto err_close_device;
> >   	}
> > -
> > -	/*
> > -	 * TODO: add an anon_inode interface to do this.
> > -	 * Appears to be missing by lack of need rather than
> > -	 * explicitly prevented.  Now there's need.
> > -	 */
> > +	filep->private_data = df;
> >   	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
> > -	/*
> > -	 * Use the pseudo fs inode on the device to link all mmaps
> > -	 * to the same address space, allowing us to unmap all vmas
> > -	 * associated to this device using unmap_mapping_range().
> > -	 */
> > -	filep->f_mapping = device->inode->i_mapping;
> > -
> >   	if (device->group->type == VFIO_NO_IOMMU)
> >   		dev_warn(device->dev, "vfio-noiommu device opened by user "
> >   			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 50128da18bca..1f8915f79fbb 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -35,6 +35,7 @@ struct vfio_device_file *
> >   vfio_allocate_device_file(struct vfio_device *device);
> >   extern const struct file_operations vfio_device_fops;
> > +struct file *vfio_device_get_pseudo_file(struct vfio_device *device);
> >   #ifdef CONFIG_VFIO_NOIOMMU
> >   extern bool vfio_noiommu __read_mostly;
> > @@ -420,6 +421,7 @@ static inline void vfio_cdev_cleanup(void)
> >   {
> >   }
> >   #endif /* CONFIG_VFIO_DEVICE_CDEV */
> > +struct file *vfio_device_get_pseduo_file(struct vfio_device *device);
> >   #if IS_ENABLED(CONFIG_VFIO_VIRQFD)
> >   int __init vfio_virqfd_init(void);
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index a5a62d9d963f..e81d0f910c70 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -192,7 +192,6 @@ static void vfio_device_release(struct device *dev)
> >   	if (device->ops->release)
> >   		device->ops->release(device);
> > -	iput(device->inode);
> >   	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> >   	kvfree(device);
> >   }
> > @@ -248,20 +247,50 @@ static struct file_system_type vfio_fs_type = {
> >   	.kill_sb = kill_anon_super,
> >   };
> > -static struct inode *vfio_fs_inode_new(void)
> > +/*
> > + * Alloc pseudo file from inode associated of vfio.vfs_mount.
> 
> nit: s/Alloc/Allocate/ and s/of/with/
> 
> > + * This is called when vfio device is opened via pseudo file.
> 
> group path might be better. Is this pseudo file only needed for the device
> files opened in the group path? If so, might be helpful to move the related
> codes into group.c.
Yes. I also planed to move the this to group.c in v2 :)

> 
> > + * mmaps are linked to the address space of the inode of the pseudo file.
> > + * Save the inode in device->inode for unmap_mapping_range() to unmap all vmas.
> > + */
> > +struct file *vfio_device_get_pseudo_file(struct vfio_device *device)
> >   {
> > +	const struct file_operations *fops = &vfio_device_fops;
> >   	struct inode *inode;
> > +	struct file *filep;
> >   	int ret;
> > +	if (!fops_get(fops))
> > +		return ERR_PTR(-ENODEV);
> > +
> >   	ret = simple_pin_fs(&vfio_fs_type, &vfio.vfs_mount, &vfio.fs_count);
> >   	if (ret)
> > -		return ERR_PTR(ret);
> > +		goto err_pin_fs;
> >   	inode = alloc_anon_inode(vfio.vfs_mount->mnt_sb);
> > -	if (IS_ERR(inode))
> > -		simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> > +	if (IS_ERR(inode)) {
> > +		ret = PTR_ERR(inode);
> > +		goto err_inode;
> > +	}
> > +
> > +	filep = alloc_file_pseudo(inode, vfio.vfs_mount, "[vfio-device]",
> > +				  O_RDWR, fops);
> > +
> > +	if (IS_ERR(filep)) {
> > +		ret = PTR_ERR(filep);
> > +		goto err_file;
> > +	}
> > +	device->inode = inode;
> 
> The group path allows multiple device fd get, hence this will set the
> device->inode multiple times. It does not look good. Setting it once
> should be enough?
Will make the multipl opens to use the same vfio inode, as in [1].

[1] https://lore.kernel.org/all/Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com/

> 
> > +	return filep;
> > +
> > +err_file:
> > +	iput(inode);
> 
> If the vfio_device_get_pseudo_file() succeeds, who will put inode? I
> noticed all the other iput() of this file are removed.
On success, the inode ref count is moved to the file and put in
vfio_device_fops_release().
The prevous iput() is only required because that inode is not associated
with any file.

> > +err_inode:
> > +	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> > +err_pin_fs:
> > +	fops_put(fops);
> > -	return inode;
> > +	return ERR_PTR(ret);
> >   }
> >   /*
> > @@ -282,11 +311,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
> >   	init_completion(&device->comp);
> >   	device->dev = dev;
> >   	device->ops = ops;
> > -	device->inode = vfio_fs_inode_new();
> > -	if (IS_ERR(device->inode)) {
> > -		ret = PTR_ERR(device->inode);
> > -		goto out_inode;
> > -	}
> >   	if (ops->init) {
> >   		ret = ops->init(device);
> > @@ -301,9 +325,6 @@ static int vfio_init_device(struct vfio_device *device, struct device *dev,
> >   	return 0;
> >   out_uninit:
> > -	iput(device->inode);
> > -	simple_release_fs(&vfio.vfs_mount, &vfio.fs_count);
> > -out_inode:
> >   	vfio_release_device_set(device);
> >   	ida_free(&vfio.device_ida, device->index);
> >   	return ret;
> > 
> > base-commit: 6ba59ff4227927d3a8530fc2973b80e94b54d58f
> 
> -- 
> Regards,
> Yi Liu

