Return-Path: <kvm+bounces-23310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1B1A948889
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 06:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9847928185E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 04:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612831B9B5F;
	Tue,  6 Aug 2024 04:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V3XHQDYS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A7515C133;
	Tue,  6 Aug 2024 04:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722920113; cv=fail; b=XY9dGoIf3m/mjSBWuhJ6KzwV8L1d2T+fhihphd/Rd7/6o3Zz/ii5FPQIdu460PyR/EJihBfnLUyGHDMi9JezodUoab+D5+GAJc2XvyH6U0yLWkQyTI0R1PnqhJ+UWlWK47FG5VEAvy8Y23eJLrzH73qRQZvHqc7odcObUQ2qrGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722920113; c=relaxed/simple;
	bh=+uLAJl0zereZaqkwpIp6kiNKaA1lZpSjAe353r4l0nQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PkLNxBtHpTQ+bHb5D5nReHHq0ymDdXjL28dDQZjXIw9whUTdqqumWhbVSr37L/oCZXmvGynSSJIp/n6+9kUH8vjSOiRKqHK0HCEgdxO+PCVC6lI2crO9a2EmXky8QMHP8rn/8bwTPtU/wNznIbfHPgj6m33MIUiJl+oI0XQN4/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V3XHQDYS; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722920112; x=1754456112;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+uLAJl0zereZaqkwpIp6kiNKaA1lZpSjAe353r4l0nQ=;
  b=V3XHQDYS4DZP/K7JVydfuLjojCVjIaSlDJiI4NSfRj8vroK+ezQjQg3x
   hfUekohpyGHeSaXvMH5eZ6vbdeHFjIKfFeHv1Cah3fF4xJsvL1xqKmS5k
   h6IDePw3HFc87ozKJKPyIH6HoSfFbsKUYQYm+qP2s+FGGgi90KVBXn46j
   0Th6Pupq3s/8vaXfONgnURl+n8VVpl2PHu8urSWH/ZWVROiW+lJzNf0F/
   07K8qVUJUUJWBzn6mHzz02Kiu3Nmq/KhvRFI8EwICqu/owGxHSCfRxnkf
   eMPe1vNu+IMSfrzLOGxtIhPDAAm0QQjapzEnSuH0r7MWzH52WRdmL32GI
   Q==;
X-CSE-ConnectionGUID: iGa63nZPSCWn7rWGRANGpw==
X-CSE-MsgGUID: bk5psRnXQpSrHcXnI+K9Aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="23827931"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="23827931"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 21:55:11 -0700
X-CSE-ConnectionGUID: /yktoazCRty0xeE/mDO4JA==
X-CSE-MsgGUID: sHsoVd2UQ46GAA3xp8sB5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="56952921"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 21:55:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 21:55:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 21:55:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 21:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nk12gOiSFf3xwgVVIc6ehVnDaD47lHdgO5FppjWC3x/0STUCFbqC1KhcpAVv1pIMe+vixd719PLScBOu+TzojlU+0cNT8w7uxrLK01EXt6/IFv6JgFfjLJ9k97BAFpZJ1M5bQRleGfUlnPBnP6Ot5sossg8WCEWTW+auQBMPYq9U7twCs9bXa50hKnBppjrhNcPLFQ/rG0j8cmFxWtSGlqyh7DMDsWGpi2Hu2O7DpxJzYyRxMNB3uFoAA84rmzekXTQqfRSq40F8nBGi+hwU3UQGc69146guTLn1deyQJm3jHLpKV4BrnY2JmnXzRFHgw8+6j3Me7lhqiXkzUjWkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVaQRq5vydhmX14eOuCnWscpTCLfQfCvYWuuG5Lsv1Q=;
 b=lJKoW678Wn+RyyOEzpqY4JpnxeprIfHOp0xOJX/bwXVkNXIxX2xjmPqH4kynmjNyNqoo4HXU8gwNNv3Kb4oX0fTGkq4IHa0E7d2i18aQSKm6zUYwpYEgXOgm4vgoXDKLv4VBT9vX7DrCI6AlLEWEY6ewdLUR1zqdvEiN+UNVdn8q1E22JHYextE4gsvotr3mntANWPt6aMytzOVxJbilBmUzwoKhvTvuE904YSWpWWMS6edM1ERDTLyo+ArBv8//e5HQDVl5LzgeO5C8Sk7fyy2s6t5s3zY9xeEXLZo2e6scs+pp2kBmkHOVA7K+7Xa0+TB3NK8M7ZN64B9troOCfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ1PR11MB6106.namprd11.prod.outlook.com (2603:10b6:a03:48b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 04:55:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 04:55:08 +0000
Date: Mon, 5 Aug 2024 21:55:05 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 10/10] x86/virt/tdx: Don't initialize module that
 doesn't support NO_RBP_MOD feature
Message-ID: <66b1aca950924_4fc7294f2@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <d307d82a52ef604cfff8c7745ad8613d3ddfa0c8.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d307d82a52ef604cfff8c7745ad8613d3ddfa0c8.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0238.namprd03.prod.outlook.com
 (2603:10b6:303:b9::33) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ1PR11MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: b16b4016-4a87-4e85-38bc-08dcb5d3f20c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FZMhTj2LYzMm7kgvLTVn+krBavoBjokbGiHS9Ws0LJ9dYokkcRdHGdh022Gj?=
 =?us-ascii?Q?VbGg0G8gjbbQc1u8hzpGfy8oRvfl1wuPWDQ3hWRGdDWuNI37uqPu0dtTyH6M?=
 =?us-ascii?Q?szER0JGErTCvb3CMZ0FG/zGVYvqb4jrwp1e0fO4qI+LpIzBh1S61Z/yjK9kc?=
 =?us-ascii?Q?tOBQ4G62BuiErhXo7GmIXPHr8VyPDzuSJuCEIsd0Ae32aj+z44QRs2cANFY8?=
 =?us-ascii?Q?HgQSy2rKiJG+iVGSfx9vWtZ83Z0vvpOPD65G7vhqavdUB0LGD8g9ZMTFv+Du?=
 =?us-ascii?Q?xo1RFJ02uRuLAsSpZRMMZkTyVWKa9KUAQmAY0mWylAz1iJHwUMJHZ8TJjGF5?=
 =?us-ascii?Q?nz9P+Yi3giYsCy7mg+iTqEJc5WD75Jvmfkhw86PqOVsDQR69iUEArWUtv1Li?=
 =?us-ascii?Q?Se0bG7zB6DLT25FzSjE2IJfF1N8fODmMVw1Ec5+R2STe9ycQMHcAGgS7BvPs?=
 =?us-ascii?Q?Upvkmqig7arY0I80qCiP0PVOQ/dxKKHFz2G0wgJTxDblq1M2cCqwj7TCnyc2?=
 =?us-ascii?Q?gz1Ig7MIJLmrh3pd2PF5xOvjHhBSSEesdkVNPn/PyoV6qLELPLIAbsWQ4zxh?=
 =?us-ascii?Q?XVuCC6KmjDGY4FTTU7OVjgqFIWaW5cU+mT9x72G09Cun68js2oK4UZOVGfgX?=
 =?us-ascii?Q?z3DNxWPTYxcFNMVkbeYp7HojcBbE9kZqQ68S6buKyx37VBlnF/lSS52IOrbZ?=
 =?us-ascii?Q?KYxSO92Et0hCloSr4UsAdmlXzCE3Xyyr+pIlcBklpuLn6i9Ftu3ZN5urQoba?=
 =?us-ascii?Q?X0pOMX/IPLZgumcP8oaQNM2oCCy4zUQ9TAEOTosWyu8SLX/XCq47Wxp/P8C7?=
 =?us-ascii?Q?Ux8jWyxQGXput4K3g2nm1BCwAARNXBFtcFl/I2rUsnG/mi9x0zjL/nVT9fnj?=
 =?us-ascii?Q?/eBMbQuQYOk65khpHjLRGNfMsjf8R3L5czDQ6u/S6t9wiWaiNkyh/TzDTPph?=
 =?us-ascii?Q?a+Vr6Gz038VN9TyurPNwoXqMOwN+XkqO+w7ErmzdeErtl2pDYmRcwBx9pqA0?=
 =?us-ascii?Q?VrLHLk4ijA+86yE5FEZo8dvR/ml4/N8CHVCpFzl45iDc9BN7IXz498X+2/2B?=
 =?us-ascii?Q?4BTddnd3A92UQt31+M+tsLX90eat4EUMoaDKZtydGLWntJvExgJTj829Rbwu?=
 =?us-ascii?Q?vuje79dj2cnyRLsLULfIgUZygLAKEVlN2/p7avBwI0u/dUsceJIDZB4AIlsk?=
 =?us-ascii?Q?f1z5mSYaZsQCzs8dcTHO6OHNd7QkXik0cMAIv87XsPt9hfeSM27PReKF/FzK?=
 =?us-ascii?Q?0hFXrRFzLFhwCJRYMhw0TFHE5/uE6w3WIwtqmshlp7iK5upN8Kd1FUHt968j?=
 =?us-ascii?Q?P0OzUbcuzpwLN55JxOw92EwmXtUXjOf1w2MMCubdsfzNzg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PWefwVPUHvSHwm1eabt8nHGj3zNMF03G6KdB0BLO+QGlDUlcI+U/yL0WIDCE?=
 =?us-ascii?Q?HzC61PDQTCTMErbeRHu6N3m2fxtmdrxoeRukD5384982mhu+mcKuFrkFZZLc?=
 =?us-ascii?Q?3W/rp8WbwKJubttiJwsFn5E8V2sfiEeka8q7n1OOLLxxhOVEhrCzQI3cAehj?=
 =?us-ascii?Q?76LhffGjhL94bi5+sSSp/BupwV378uASuHGjMdd5OBF4gkKwiLMNAdrHsHCk?=
 =?us-ascii?Q?p0Y/TPx6+FsN80DCpbIdt3cd3uD4Dv8JDs3e+PvPGDZY+109Xy4+LidPSTX2?=
 =?us-ascii?Q?gvivNHbaylEdFhufsixNu1gtke+NTxdDk4Upt2+y5cMINH/KOEEqklXHuYjd?=
 =?us-ascii?Q?T2T2cUkZzpXchVo+DIcNtN43xu240H/Zmnd4IDWKdAPKNdfjmlDphoH6TI/L?=
 =?us-ascii?Q?BNr0cxEwXCgi34A7CjyovqAOel0D/Wg0Tokughf3T8+ldEGnmkZDRZq7MZXw?=
 =?us-ascii?Q?2AC4bFB6bdbK40xdAwpKKI8EGXclr97JWOrnfz1lXaeXl3+u60BcgInVQ0si?=
 =?us-ascii?Q?uxtPw/Z1NYqURcXFC7g0deUZ3kUqjP+2+XA6uH8K6GWEiNR0AUNxAl9sb1GT?=
 =?us-ascii?Q?ph4KkgpP39QHG1yNmw+RVcAc44K2P247io8ei3deCfRJhEq170QEI4W+Ba45?=
 =?us-ascii?Q?hWwv5cuuPr0EoMdFScEou8czvjwbg7rDHgQFj8NmFJ9Vk2bsbNmKE2y4Xdpq?=
 =?us-ascii?Q?VSarsMdw/1oNm56oXKqzg9flBXm4r0oVSBmxqYlSUW7gemMpvLjnUIpHStw8?=
 =?us-ascii?Q?bDkQh2TAL1EulzEs1GeSzF0say7fublit4eL1VZVsaCWq53C6t3Hg0IdKv//?=
 =?us-ascii?Q?ReZSaSU+JQnuAhtnENTnPzIQEkENWH5PDw/LRH6B+fBxHiFF8sI1cZnALC9i?=
 =?us-ascii?Q?9Sr1GqzHEWBmZ0Oc9hCzoV3oSoI/GOSepT0DaRZqs+7NzDXGDj3q39ngEZ9o?=
 =?us-ascii?Q?KLDATxu2SjteZM2p6hIJqBozQc801+X1zZf0cHo25/TKBsMigZQ53vQgBSv5?=
 =?us-ascii?Q?j5j6+jDFdx1+xf6OOAkZ+gdjZKe5ROjEGCn8rhfvMHwhNMk8rKbdukY3HWrZ?=
 =?us-ascii?Q?dLvSaLUrWqxVuvEcp1/4RlmhaQ5SYaae8v8LbmnDjb/2oFaAXtLzu1kmtfFU?=
 =?us-ascii?Q?3bOOw1lnnvAuRGD8nb81XJ+VBfZ6Jvys+aUqdhrJ4ojySW1gr0rslXVewX76?=
 =?us-ascii?Q?LsnbRzxRw33jrM3GHWFUOgD8rTuqxXGmaKzQI9ZxyNi4AzvrT3YcYcJcwY2U?=
 =?us-ascii?Q?AftDx7DAaPlZrNa+QIilQFq4aLIL/7H3SJD4ccCJScsMxFK7gg+G0w0JRm4M?=
 =?us-ascii?Q?3wK9x61TLrTHY/hvtzrDEGrjp+WFaKmarXLttmfL6PIxvtcLcttQvB5AFybQ?=
 =?us-ascii?Q?y7TF1Qjce4o/LxM4/2oCoQ5nKl6zVLz9QGE3cI5ELGalaI1ltdDxfzY1Shgi?=
 =?us-ascii?Q?R/mRMN9OL1KkFN2+XslDEcAEO3FdtpXPqn7wxyQ1B/JxZ5+o6U6XSAenEy2A?=
 =?us-ascii?Q?5U+vAdbiUMLXyCSYq0VoZWbq5QovsEbo7HP7yZoZwZybOlC5g5g16oXC2EJE?=
 =?us-ascii?Q?6LtIOh/6cH9cBhWnHc54qZvKwDnBelQUqMC4l6Y8xfAS0unyc198DbuxhVDx?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b16b4016-4a87-4e85-38bc-08dcb5d3f20c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 04:55:08.4368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2D7hu9BzhoImFDXJqRL2pGv6U8NF2pZuF0iy4lcsfC7t+5dcg0oQWviBcXF2uJW9IcDPWDsXCGEDy2KpFr7Tn8q4StrzA9f7O9Oi6WsBfhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6106
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
> RBP is used as frame pointer in the x86_64 calling convention, and
> clobbering RBP could result in bad things like being unable to unwind
> the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
> gap.
> 
> A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
> not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
> metadata field via bit 18.
> 
> Don't initialize the TDX module if this feature is not supported [1].
> 
> Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> ---
> 
> v1 -> v2:
>  - Add tag from Nikolay.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  1 +
>  2 files changed, 18 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 3c19295f1f8f..ec6156728423 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -484,6 +484,18 @@ static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
>  	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
>  }
>  
> +static int check_module_compatibility(struct tdx_sysinfo *sysinfo)

How about check_features()? Almost everything having to do with TDX
concerns the TDX module, so using "module" in a symbol name rarely adds
any useful context.

> +{
> +	u64 tdx_features0 = sysinfo->module_info.tdx_features0;
> +
> +	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
> +		pr_err("NO_RBP_MOD feature is not supported\n");

A user would have no idea with this error message how about something
like:

pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");

