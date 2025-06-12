Return-Path: <kvm+bounces-49262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B750EAD7016
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 14:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 662FF3A13CE
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 12:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34E3B239E7B;
	Thu, 12 Jun 2025 12:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BN8qD6l1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51F9183CA6;
	Thu, 12 Jun 2025 12:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749730814; cv=fail; b=bJxkrJiyI2sZ/nMj0Yppe2LYobHw9lP2lkHO0yqc92/aDfIXM0FNbjKe213IrU8L2uxYjCYX+617xUu1lX6P/t6YW57jds2v0v+5D+hbUyzYsFVpuh/L8v0cv4hHO6+a2otaRCCMFhxOyNEzmutAFxFqre7IsxGjpy885ZNjbX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749730814; c=relaxed/simple;
	bh=InR9lQS+/0nb+aovSnesCLxTg41XHB64CLFPtF5AO4U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=adbSMgaMD0CU0TeSuTaP+SCWRszWv6zVhADeYqRnIYFCwZTWCDU0zPHN+YW5CulAMIZqti1uF3PkoovSPmUf74e/zwAI9fVNSFjfp96mKjNfzWjg70iEDxPYDmCYkP28f2TO0QE0Avxk01OVc5eQ8EKoowWHyPYYZjqOIA/gK98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BN8qD6l1; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749730813; x=1781266813;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=InR9lQS+/0nb+aovSnesCLxTg41XHB64CLFPtF5AO4U=;
  b=BN8qD6l18s2R07hYzIUSchptWA6OOwpyr1McvjhnbfXWDdY93bqaxqhI
   loEmzAivPtbKhzJuTckjPOAoa5wvGQc9tKiF9RgmMSazdZq1p4EFy2uSR
   Yb7t9qHi5zoFJtKLdtOvZh3UbmdS3C6AiekTypyBYlp7Pv3WBVxf+t1k+
   Vet1qEI85oKaYGu8Tzu5eXMpjyjqk62gfx7GKEDK+tys7PGtSG3MWIaFc
   AJDcCJ4rm9JfMj7mowZyeSXPxJjEVn05iU5fJZqdxTLWL/z2+vZuiTe7u
   xL9Fy7t1ysjVcW5Ja0ap7+bYncGGfJflEdev4TVkcNx6L8Imsy3QBi666
   w==;
X-CSE-ConnectionGUID: L+7ZxyKRS4SCLScOuPQFuQ==
X-CSE-MsgGUID: fNDu45IiTlOBpMZ1hRHbMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51993476"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51993476"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:20:12 -0700
X-CSE-ConnectionGUID: DRStGby5QmOVbQLBFs8O8A==
X-CSE-MsgGUID: KbrnlcySSfOIkPD9YWavaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="152414396"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 05:20:11 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:20:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 05:20:10 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 05:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/flEev5XLGP+wAkOO8TdyW3IrKHzz8JgNRqamXIQSKN8OiJs9D8Jfhy1vB9NQnl6/ZroDnvFPGR3sZNWHIgdiEstDk3XkAtndkNPiMuxKbHBmQUTk17PY15J/WyC2aQLHAGXBGv3OrUzWDqp9QUqkxEPyT3G75M3TF5cqegC7xQLanKrjtcIgI9InVRtvCaADEd0xbKlBxjlckxZyRfttHAhtZ98j682Yz4DEJeq7jLbVNvPOqs52tS7Y29Jp0sNvjNVovzDHLd+OTg99Tx5qmYUsbvGW0OQIOzUp7mzw08T9RbD++kd+QCDMl+H87Kdy+d7qohNLHDBLM06Zd6QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qERcL6eWWI0w8aPlrNrt9G9viPhVSz21c+dMCTDjEaQ=;
 b=EcxXP3lDZOpR4fPrQd4j4mcbLo97oFKKsPNHsBd4vTVvm7ElFUUtWZOSbinHVWDKy/8tXLu+4jfWWsKoTqmQs/QsUboU9TPOBz5P4cGBwO7hllzOY3rcS71CBGqv4jIgsSjXln7VChWJH0Sb2EgmhFKO9korKsmwV4BHQ4iFiV8g45Zcv6Qyh1ok5gVuSu8yljtA5Re3u8Ud0kK0XPol5nXsmDJWVmjBdivB3N2f/nvI/L7Imm6r2HjET4Pzosoz006/bhQ3nKo3ZaItzevZHTj5PLcDeU3KGwgahaACaQNfKorgWpye90m+cqpxtLa6pVTGUb0PsIbpgrcfDH3oIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7909.namprd11.prod.outlook.com (2603:10b6:208:407::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 12:20:08 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 12:20:08 +0000
Date: Thu, 12 Jun 2025 20:19:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <yan.y.zhao@intel.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 08/12] KVM: TDX: Handle PAMT allocation in fault path
Message-ID: <aErF7JXwjmsf5zYp@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
 <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250609191340.2051741-9-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KL1PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:820:149::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 4dc4e951-0e87-4eee-45a5-08dda9ab7868
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vJQ5AEUD5616vnYxuTCKmaL8gSdnDRC3B0x0n+8iEv9WehmZ95hJ52OpOPpl?=
 =?us-ascii?Q?300FFSbZkZGvodH0adnTTH0XM/J8FrRNq0qHSH7flajtEopYIZNLx4be30mL?=
 =?us-ascii?Q?w2fDgJCj740jXGn/zSdMr6hLtQVSqbDuyVqqVB1UVXesXB5D6BaWBzEaFxu7?=
 =?us-ascii?Q?CW7ShvHLKBNPk1X9lnsY3P8tjpNpGCXw+IKCHSh+UHLj7MIIjWE06ex1oXnX?=
 =?us-ascii?Q?J9Ro+PxHOmx3yHAolAH6Xjm8Y4Fpqdw8J64ROj5DRuAbjqxzosu6Gyam1LVM?=
 =?us-ascii?Q?YoxHamrl06DD2NbQwLbhmSXUU4OauIMGo4CiI2F2SdwaKcQ1YtXoTdT3DFwc?=
 =?us-ascii?Q?ZaWhD1OVgj/pEM2MATKiQoAKSo2kZfyC/QKGyGuEAB4SRB8Ut7fnecLK3s59?=
 =?us-ascii?Q?2xC4n84ug8g0sAC0vIe3WBBy3OQ2w4eQduEPc58PBVEtE0KN6ff9Rd7oJCrg?=
 =?us-ascii?Q?B1i7FDNHqFmIhM+L1SDzE4pUW7aKw2T6tlHfaoYQN+RcbBv3tqX2IYM9mof+?=
 =?us-ascii?Q?tgKqpHBd0loQqKGd+Ebc/lMVMVQyS2nrdO7srgyWrhntU8IIzE8pjbHzvWg5?=
 =?us-ascii?Q?JFmGT6Kj6ZwczO3ntY4gDVbV0B/Q2foJfKzQhIXU24Tpk0zn/ugXQ0elcLel?=
 =?us-ascii?Q?tDCqa2OVhxC3CCT+NWWXT7KSsND20bgOhiMlS5UsIKHK9rxvq9EBqU0wWAhQ?=
 =?us-ascii?Q?ik1RTsBwt/gKzB1kc5CODTmGzqC+EEgbCOe7BOD2EYkwFOX/dzMBVzPfCbpF?=
 =?us-ascii?Q?tCTwu0Wrt+PNKYh6SP9K69N4fb/cQKIlU18mgjYTP7VX3pDnbi3Y8OYQyXNe?=
 =?us-ascii?Q?r6kWImZCJz9SdBM6zlx9wed9RVyr+3Y/XjQq1ya7y3ddbdWFz7wkkzYIwviV?=
 =?us-ascii?Q?hDVap9cOyPDlmfimfSFCN8k1F0QhZPix3cwft3M/J5nQ3NFJdSGQaPQG0PHJ?=
 =?us-ascii?Q?ZQiNFkMHnFhwpKUBDOaa2wbC8rPHH9BcpuPWi3AOXQEb3/lwkamyESwmUbCW?=
 =?us-ascii?Q?G6mjfIkM06gBWtPPmkaytY1mjxbxbvy4BLWvvYUnC0DSn644/0gVPDWaEHKg?=
 =?us-ascii?Q?WQ+OLL78O+BydKBLy1XgBiHUzO8OxBe1ddV8bed4t/iCEI+xx8Uq4qCh82PC?=
 =?us-ascii?Q?9iz1oupbPRGkHVrZY+fUSw6Q54w4wDQ/euJBmkd9w1BvThLqfuRZhjuxXRMg?=
 =?us-ascii?Q?OrwI2ESW/9BEscbsjVFSicr9WVF346ijoLROc4TNwniPKozIzi5k11d6wif0?=
 =?us-ascii?Q?Zc21tHz2zWPufYdPqs9VEFFUJIMQF5hGutBGinLrzMbc/QkNcVJExTdVfFDC?=
 =?us-ascii?Q?tp/sGVXW0vqfyrNCEEWxdF8WY04hggYo3CG5nH0lQ3kLl/GaCCTv9oIgnrpp?=
 =?us-ascii?Q?eMQylRGXx7IAbV3TPN0FSqivIykuSpf8UyC2jQedtYmGkqmLBvQ7UUvap8oY?=
 =?us-ascii?Q?ilstWtORnTI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Um26hbG0giz38UsiigFnFVqvCH3PSFtuNlBrqb7MG7b5FQUgkyfh/03HxE96?=
 =?us-ascii?Q?iwJ4iNWYPQqE3qmCMUU95KF4FMkWhhLsoiVHyAB9/WiMOGsZJrj16n0sEonv?=
 =?us-ascii?Q?lTXdp3zmIggy1GbGwO6inS5e8u2OH+ncz+Dah8KAMOkBtkSZsO0aH5lu2UZT?=
 =?us-ascii?Q?Un6ROdo/CE53reJCTPp3+Lk3gTl1nkPcpzxev3f7sZLf3r51jTYf9GmJ8Af5?=
 =?us-ascii?Q?MjtZk6xEp2sUu3Lx64y31JgPxUkJ09+pqrObneCzgxAL7gnA0MPKvyxftqHN?=
 =?us-ascii?Q?9Hncmaj7pHlLpOUfmNTtQf8pzpUWLf22b0nReJ7YuRNlR93fHO89BidSC70u?=
 =?us-ascii?Q?B97N86R0U41xZP6Gx3KubswqymKamKp7Y15KgknyW/0cIzjzM1fF6RGeHCJh?=
 =?us-ascii?Q?zE3kXXkXKPDO+IhqoKpwcvygwNCUVvjxWJFpnc2A8Y6gh9zK6lIP1dVKQrWC?=
 =?us-ascii?Q?QgF7JTBylXUiNYcv4r3Xy5tXwi2v5tXrqqgVaiDLQJx6gS5f9PW4tz03LaCa?=
 =?us-ascii?Q?meVOhlZFWnlbSjGXzHpvlQW8rd9x4+YOsdSmXz3qqn0+9pIHvL8MYY7gIvHu?=
 =?us-ascii?Q?Q5nh7xoxBAu6rDPnJ5wzcplWghoqqMAPoldV4kQGfjR+sXZPtK+cZzdiLDWc?=
 =?us-ascii?Q?tfgdGXskHadHGfTrBh9nlgkivksGkKgqBBzRnu/wCmye4BkteYds6g2o3RKW?=
 =?us-ascii?Q?vFVyR50Ka82tuEJ+UsRrnquyOl8G/zmy1INqQF8uQ47Xu6XypJb4mQOL79/U?=
 =?us-ascii?Q?VTujczku+QJeICsLp1CdZgpJfZ42nvo3R7Kkt4CxgNUuT85nkitFZnJysXkR?=
 =?us-ascii?Q?+dLgMpeuyfO2qzUdojZm4MKYzhpa+OlcHWHmEZHkwYHALqqRtdvYTs5W6hxj?=
 =?us-ascii?Q?R+56TApKnyE7cdc1HO7LTBUzAwVpDojIOIU6q3TreHR3CvrnI1n6GMyFlYCu?=
 =?us-ascii?Q?HAR4kJF4tO0mYrhz6JoNX8rRq+2tqnc8FQEdWuRsoUv/MuCRsvtjQt8fNscl?=
 =?us-ascii?Q?qABz/apX13djmR5TvRFI+ba+WrARR8lDJignU1K8spuFGDajgDrtBJRf4chZ?=
 =?us-ascii?Q?fwlpT9Bh6e3oYSFw/An65LmNlbxlySAM7c4a/uABD94r4oo3PiwMJtAcc8IG?=
 =?us-ascii?Q?ph/dWp2LF+KhOoE16ieYzhzRcUtVE4RV9NzPDw3LIkv2+/ldOjaj4+X/Ml7F?=
 =?us-ascii?Q?R17eBOXFVR4Elzi0UqSXsTNLyMIs6QI9VF6pQuW6pqs1JHl551VtSZfd3hv1?=
 =?us-ascii?Q?iL2jrTzZSVikQ+iw+mG+/K3fORMdq26La91GE93du7DwL+Rk5O+tk4pXOPsk?=
 =?us-ascii?Q?reIkn317HOeoVVEnZurSMu1EKcot+Pl73dVrb5YN7Ifbuz3Tc71vxLsxOQDW?=
 =?us-ascii?Q?R/TwZKuuaoWfI4KeRTeDqV1dxahi4nuUChA/50xTNDjc/3fbzjVqmkTdJw1p?=
 =?us-ascii?Q?G63PjteEQKCDBrI8XCCvb4IbjEi+cNHJ7IyMXvt/71IvxSwq1jbENmSNMURW?=
 =?us-ascii?Q?jHyWPEnUEFHtan5P4tdFWLxemlREwW/jT7nBibxhLi5cHyxGX3VPGFJoDzu2?=
 =?us-ascii?Q?oo85w2oNjHHnKxhgKcBRJVfQMTM2acaouPdr9+xM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc4e951-0e87-4eee-45a5-08dda9ab7868
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 12:20:08.2666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIV/oDC6qdWBK5B5sIAysl46Bl2XH3lB5bc7NCXNJFHKczyhoXmim+Mom2jodF5sTqNOrj8txzbMEnJat0EGtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7909
X-OriginatorOrg: intel.com

> int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> 			      enum pg_level level, kvm_pfn_t pfn)
> {
>+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> 	struct page *page = pfn_to_page(pfn);
>+	int ret;
>+
>+	ret = tdx_pamt_get(page, level, tdx_alloc_pamt_page_atomic, vcpu);
>+	if (ret)
>+		return ret;
> 
> 	/* TODO: handle large pages. */
> 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))

nit: hoist this before the tdx_pamt_get() above. otherwise, tdx_pamt_put()
should be called in this error path.

>@@ -1562,10 +1577,16 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> 	 * barrier in tdx_td_finalize().
> 	 */
> 	smp_rmb();
>-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
>-		return tdx_mem_page_aug(kvm, gfn, level, page);
> 
>-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
>+		ret = tdx_mem_page_aug(kvm, gfn, level, page);
>+	else
>+		ret = tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>+
>+	if (ret)
>+		tdx_pamt_put(page, level);
>+
>+	return ret;
> }

<snip>

