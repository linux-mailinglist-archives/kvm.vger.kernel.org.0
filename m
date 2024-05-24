Return-Path: <kvm+bounces-18098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 003568CDF8A
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 04:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F62C1F21DF1
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 02:39:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C155B3838F;
	Fri, 24 May 2024 02:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fG9APhFs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496D4381AA;
	Fri, 24 May 2024 02:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716518354; cv=fail; b=K04XR0nb8rDnHeU8gA3UsRDMPL9A26yxlD6qKabFFVZSZJvNWah+MI7Q6tQ717PaHW1FOVIKKOqSZ3SFixYv18zsN8DoBSExfjI9izPW22UcMdOs5ACiPcXV0NfK2V5nyTI1mePT5DGy0TilumeN3+B18vR9QT1TuQhrf6adO4M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716518354; c=relaxed/simple;
	bh=wxm2TxSKfKeMMqfV/n5IEHKBgnJwV/yDEzD5J2RsuEQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lP7e1jfGWtLF24o7JsDmX3kiKbl9+8o8qA5VNCB7DdUQ9ATmFU9jq350CP06KpLuwYwPq9UdTkm5lVhPpfbQQ3nMZ1N8rLsZDVTaOkSwQ2RnDlPbc4bmgigyYMSf3nEQ7pgytCHqE7WP47IkLvsj1qoqeX96izoVEShghrT4Ipk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fG9APhFs; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716518352; x=1748054352;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=wxm2TxSKfKeMMqfV/n5IEHKBgnJwV/yDEzD5J2RsuEQ=;
  b=fG9APhFsnnrjJDFkwVF31tKURo28ezF03D4mG1nTevepn+y9G3gvhDFF
   6cRGu2ToOiC57SZeGSqhJj9PPr1B0NAK6YFO6TirkKPaIkgMTum/o1e6/
   Sn1jOuoVVt0oHnYAqoKWDU5WoiG+hKnFcV1bLIaIkVTwNcmwWJkU/3I9C
   bgOARbJvTuImpWQdM79EWCWCowZWt5bZ69M4KGMGSsXRN67fBY99Be/gO
   aP6pXPYRgh5p9a9jYOGYsX3E8yNbVG0HZzIcr4RdhJVfsSWh1FWlOH83S
   RxBeisr6P48xB5hC82D5V7j2GSY6y8d7OkEy3wKNOvyB368HRvZVCTPWX
   w==;
X-CSE-ConnectionGUID: l7uP1QsURFmXC/Cz8A+0Ow==
X-CSE-MsgGUID: v+8VRW/RRIWWveeVdeB1Kw==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="13110029"
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="13110029"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 19:39:12 -0700
X-CSE-ConnectionGUID: ngDyY6wcRrSLMiSCOoIBeg==
X-CSE-MsgGUID: SCNDT0IZR4WsSq9GwQKKqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,184,1712646000"; 
   d="scan'208";a="33988302"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 19:39:11 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 19:39:11 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 19:39:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 19:39:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 19:39:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2+yYWtcfQl+Dc78IqfaY/mAKhCS7ti3OcHTuBmx+HfuBKeLEld+f17RZ2zypo3ijXhIHsOyj5t8OF+J5u8qqyMgkk+SymEJPfE8SYTSajOgoPybqG8VPvcM1gnePEtzrOVbkT+BUCX+ahjzh1otNajvDY/03iXm9KpCrpORrDkhU66ss7tXV41XYYAKEu4Cp5swCJMz9NNWbAJtkMgfbWbigKWaEIxjymrr9BT+wUHIJ1rPwBRTIeMS2jfWmeZUPw7K0bzNiFwpV2/eTuC4qztQK7jV57lFSyLs4H+Lba4usjIl5/ij+uzLGETnoysyRKjTJ1U3Un5ipT+TxW43bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6IxzXUlzE/a03SEoewZeaUMgaV/bvQhJlUepBF1+hk=;
 b=GdpDr3byPsrV8AMiBtD9Vhq01s/sfdMZ4roWgI1fQFQ9p5uu2x/NOxsXBgmTzzfBQs7shs8I3cy4n3F3v4TaGY2KoTsXmDA8Rgdz0KfiRh9RaH4oVQdeq3BgEtsT/9ICygnDF+48o/XQkp4x2P1/JQxCvix5Kom4gL1fdcV68LVfTkKieP3XCkMTAM/CQoOCzZz7LN0QCszHzQxCH7nFFsSOkHBRmZW76nCfBaIcvKJwhC1jBSNGPEvUs4wTYQbBtYRhSoYNE8IbSAoEx7NA79OgvP4aQvrKnRQzVpT2HLDeuVCw/pAifA3We1LsmBqxX1Ou5lpF0DCeZBBk32OtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB7124.namprd11.prod.outlook.com (2603:10b6:510:20f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 02:39:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Fri, 24 May 2024
 02:39:09 +0000
Date: Fri, 24 May 2024 10:39:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Message-ID: <Zk/9xMepBqAXEItK@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-4-seanjc@google.com>
 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
 <Zk7Eu0WS0j6/mmZT@chao-email>
 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
X-ClientProxiedBy: SI1PR02CA0059.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: f1c53587-7bc5-4914-6ae1-08dc7b9aafc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7FDd2Yf2oKL28IHc6Kov9q4UoH9Dd1TaJnfgIUwOA8LCn9ZEqc8H8UjAMu3h?=
 =?us-ascii?Q?VkLoWSGrsPz2PtF0yoGCzwtOytsFYPXrPC07HuoQJO/1K7BN1g6TGhVk53LP?=
 =?us-ascii?Q?UQKB5jkOk1gF1UTtz9ktnufuTKYXa247f6qXC34YDNDiTcwLEo1vTw5sSdhW?=
 =?us-ascii?Q?Hf1XCRoXy/jNYc35VGnpJXo2s0S8QoTwnxkl7JNXtv2P/RURgqO+4DNQvaUc?=
 =?us-ascii?Q?2rZMorOeqYHgBOQxldQQBcrsWPV0CPWnRAVdrVAU72VMVjBY+/PZiPLAoL+u?=
 =?us-ascii?Q?hEQaHmpomT1mRVueNTL3QK5zuoLlnNSjvELVu7/92s565e4sGNu4FycGQBhM?=
 =?us-ascii?Q?rrvhyWmQWkaDhdFRn2AGBLWcbTpFaRAh06qYIJsEJJOsvFKujRHBsg3GQEA6?=
 =?us-ascii?Q?1qB6J5/8/TiJ9pNHHL9piiYSumQNsxP9I/S3kKzJBgCHs9xdM+LM8cxvz8P/?=
 =?us-ascii?Q?R4pAT86sJUflNh53h/3cAhc716zTEMvxZjbcfLqUjWUPwp2x/k8OfnmRaWnO?=
 =?us-ascii?Q?oA6B+pfUDvDtkJ/Fjui8aRQFa1NmMqrpz+vnJx6qfXBzsVConcol+oX7yhvs?=
 =?us-ascii?Q?jBj4rg7OiSBKL7g/UAhWbYGOuJ2YYYP6jVi8Sn/JkWNmZvrUzwv/IhfFgFqJ?=
 =?us-ascii?Q?UqQOZJdohKLjDaOC/3xhMKWKpDbSNCLFc+dLclfHK/fXZ3Cf5+bE/Ixf1rYf?=
 =?us-ascii?Q?yl2PCbSvjIL9rbKHhBJUwqQQPG+uBEaVhvlDKZCFJqR+ldJ/wvbhZZhoOdnx?=
 =?us-ascii?Q?dTby+QBSxK8YA/fHRyM8Y77vnbgz+0m0CsBSubJPHKe3gbWcMZt2s/qx1WAm?=
 =?us-ascii?Q?tJhV+x/WnFqUXafjZEIoMAsjBHWuLhEeRdc48sqmHJeyN8wy1yyS5BhPC3/P?=
 =?us-ascii?Q?v+FOSU7OQ5XMcsns+Dypsk0ZUqNHr5Gd33Zoqfjd7LVL9OmzFbsLqQZ6LaH0?=
 =?us-ascii?Q?MfVpxYzK8e7BLQWYjgZFswRs9VXrprRJ+AnUhBsNf0P/fBOQJOYBvpnzgBka?=
 =?us-ascii?Q?7iIMPl0Ru7EunyG92K5h+yqRmvWN5/Joq3rZXW6KL2EwntHkzAu0PrLKxAql?=
 =?us-ascii?Q?swWImAUqbztz4XXafNk+kUgVLGGzNCeFnhK7O3eoYFXhd3cxMwFqTMPGCB3k?=
 =?us-ascii?Q?vqOTTqGOJA6x3uRW3Cx9Vsando482RZiXXDhIkb/c0H2b8fgKpD9wZQWvQUK?=
 =?us-ascii?Q?/kXa4r6pY/uRXvNLg/MAVOxmVVcJVv9XL5INfBijVKWDcuGyzigMhwdUmr4Q?=
 =?us-ascii?Q?/nQjG0OpTiIdLyEQd8OPNAT4t3OaGSm83M0yCOq3zA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftMkiGnTENVqcGyiZJU3fp6Tp3xt05oJ9mWBmuU42LuOqBktrbEDbRWoCorf?=
 =?us-ascii?Q?yPdBANisCxQfyU0fDAjuG7K/5wqdgBOmXA+LmNUgvi6MXpqUHhxRUZFQuvA5?=
 =?us-ascii?Q?AJzq3QbRqa4DV7uqButrA3ui1/MhG4fhz5eM22Q2cfLaRpyhfieGewYdBaGI?=
 =?us-ascii?Q?8EvVR9zpHBh++dNAHdficOI0V9gaW1oNNvcfRpi4z3MAIEWJG7KPQ9lJ9brA?=
 =?us-ascii?Q?NrLA9YPben5aui9xQp/K5igrFjvGeN6AYmFg0w1t/GzshGtUBZmMSYKKoVqF?=
 =?us-ascii?Q?p22JlUauj1FVfg6LnFWME4oVDL/u2TyvSvCkqZ1JZKzVdtguvQJFpI6gPTqW?=
 =?us-ascii?Q?qDut36/5QHPi0TJ7GijEdYkgMhKka9+ZtQfPQ2lcUSZaf4losaNRxv+h6bC3?=
 =?us-ascii?Q?6gEWSw2miLEXBGmiv544cFqbNtlXiicWOXP71EgHxsnopwGvosxiPMyYvMCF?=
 =?us-ascii?Q?ba1hk23paNuzITo2rosE1uT9lpOmhIVtBRLdEBu11CaqCl+np5OLH/KayFC1?=
 =?us-ascii?Q?HkyGhMDZ7B/WWKBKNoFhISvYDX4vONGv2V34KpcBkVR/CXbnPH2ZWqH59E+9?=
 =?us-ascii?Q?7MCvCqMa4DD8V9nuTuUzK5GK15nZsa6/gBEth2gEvLognIFsnGVUPq5BGwkJ?=
 =?us-ascii?Q?5wxFFmyVdwqJH07bGRz8XksRvDrchc3LDcdlJ+mILDQ2f3CImFzTOZyJ+xcG?=
 =?us-ascii?Q?chh+s5Z4FQCTt+E5h3ylq8sU1pTmqfpmv3Axbb2KJ7Yh7VnkOjCfxs1zU3qx?=
 =?us-ascii?Q?+0G0dK4lmddS4k7gWFqCapbrY+bop2BxTc6aEwcsqvFOpz79ntnfH5IcK6ZW?=
 =?us-ascii?Q?CN38triR91jArwJ+QZs41fZSDyp6bOu+BYLTX+DSOztH6O9GMWwIoGWyXpIa?=
 =?us-ascii?Q?jJUqe0vTiwAD1TcOgouLIAfF1RIqwyGax17o8LW2TXbSG2WSPrw8iRq5is1A?=
 =?us-ascii?Q?6neshkV71Tf80Mb/WZu/9UzKT5Ce+VvwM3TD61RJ+mBOMJyHXqWvkiEbz2xW?=
 =?us-ascii?Q?Svtm4bHrFT+0A436aVF5+GfftvvZvPAvPrK2dVNCFim1Ocm3U2nV+Ua2USqC?=
 =?us-ascii?Q?ToYEJ8QFsLrZf/j7E74o8NmKXjnPxLvxeVOXvO6pKMAW/ZJoaU+eJwbJsDQk?=
 =?us-ascii?Q?nDROnIac+L/lD2rOQOZxcHfrJ6btb3kngHmKNXxWrjFHkrJmrBsg/SKXV/9L?=
 =?us-ascii?Q?m86THca/mAaNVs3XcUBET5yjPe64RIaXhjdp+q/a1O2P0gA4RMky0Q4/AjZz?=
 =?us-ascii?Q?leRY1WMTdgSkvOcehlAOv+SVCqxWNoacDwoHNe+1hNs6YT7zwLkUaSdbkeIV?=
 =?us-ascii?Q?gQ2FvYdFZ23QFuPYCPeGr67iUAkH9NvZGHBFqXhxGF4IWpA7idasBj6rqqQZ?=
 =?us-ascii?Q?wyMtIMH8wvA0+L1lwg3C6eQ2/MZVc8Acp4QCVXx2pOG//21fEFTtrV/gZmPX?=
 =?us-ascii?Q?D4QdwH5g1pH1pP65wJ1yqRs8iHlWpKdOGhebH362zO9RwAtrnRHn+ZeSZDQj?=
 =?us-ascii?Q?QxAGtPYSofsjlq0oCHRDU+CrHyo60HWdoVDJftdnfC9k4YBuDILNkD/rxTWp?=
 =?us-ascii?Q?F/QFOCIHKyHXpL9Pq+yymVxE/J8mREsDMVeC4uui?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c53587-7bc5-4914-6ae1-08dc7b9aafc7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 02:39:08.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n+pYbtP3vzzH8G7pNB7k8AEh3Iz12rcBItr55mUxZ0qLrlrcfSkpNxgeRZOT4i9igxGtKwV1tyC31qjnHYSdtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7124
X-OriginatorOrg: intel.com

On Fri, May 24, 2024 at 11:11:37AM +1200, Huang, Kai wrote:
>
>
>On 23/05/2024 4:23 pm, Chao Gao wrote:
>> On Thu, May 23, 2024 at 10:27:53AM +1200, Huang, Kai wrote:
>> > 
>> > 
>> > On 22/05/2024 2:28 pm, Sean Christopherson wrote:
>> > > Add an off-by-default module param, enable_virt_at_load, to let userspace
>> > > force virtualization to be enabled in hardware when KVM is initialized,
>> > > i.e. just before /dev/kvm is exposed to userspace.  Enabling virtualization
>> > > during KVM initialization allows userspace to avoid the additional latency
>> > > when creating/destroying the first/last VM.  Now that KVM uses the cpuhp
>> > > framework to do per-CPU enabling, the latency could be non-trivial as the
>> > > cpuhup bringup/teardown is serialized across CPUs, e.g. the latency could
>> > > be problematic for use case that need to spin up VMs quickly.
>> > 
>> > How about we defer this until there's a real complain that this isn't
>> > acceptable?  To me it doesn't sound "latency of creating the first VM"
>> > matters a lot in the real CSP deployments.
>> 
>> I suspect kselftest and kvm-unit-tests will be impacted a lot because
>> hundreds of tests are run serially. And it looks clumsy to reload KVM
>> module to set enable_virt_at_load to make tests run faster. I think the
>> test slowdown is a more realistic problem than running an off-tree
>> hypervisor, so I vote to make enabling virtualization at load time the
>> default behavior and if we really want to support an off-tree hypervisor,
>> we can add a new module param to opt in enabling virtualization at runtime.
>
>I am not following why off-tree hypervisor is ever related to this.

Enabling virtualization at runtime was added to support an off-tree hypervisor
(see the commit below).  To me, supporting an off-tree hypervisor while KVM is
autoloaded is a niche usage. so, my preference is to make enabling
virtualization at runtime opt-in rather than the default.

commit 10474ae8945ce08622fd1f3464e55bd817bf2376
Author: Alexander Graf <agraf@suse.de>
Date:   Tue Sep 15 11:37:46 2009 +0200

    KVM: Activate Virtualization On Demand

    X86 CPUs need to have some magic happening to enable the virtualization
    extensions on them. This magic can result in unpleasant results for
    users, like blocking other VMMs from working (vmx) or using invalid TLB
    entries (svm).

    Currently KVM activates virtualization when the respective kernel module
    is loaded. This blocks us from autoloading KVM modules without breaking
    other VMMs.

    To circumvent this problem at least a bit, this patch introduces on
    demand activation of virtualization. This means, that instead
    virtualization is enabled on creation of the first virtual machine
    and disabled on destruction of the last one.

    So using this, KVM can be easily autoloaded, while keeping other
    hypervisors usable.

>
>Could you elaborate?
>
>The problem of enabling virt during module loading by default is it impacts
>all ARCHs. Given this performance downgrade (if we care) can be resolved by
>explicitly doing on_each_cpu() below, I am not sure why we want to choose
>this radical approach.

IIUC, we plan to set up TDX module at KVM load time; we need to enable virt
at load time at least for TDX. Definitely, on_each_cpu() can solve the perf
concern. But a solution which can also satisfy TDX's need is better to me.

>
>
>> > Or we just still do:
>> > 
>> > 	cpus_read_lock();
>> > 	on_each_cpu(hardware_enable_nolock, ...);
>> > 	cpuhp_setup_state_nocalls_cpuslocked(...);
>> > 	cpus_read_unlock();
>> > 
>> > I think the main benefit of series is to put all virtualization enabling
>> > related things into one single function.  Whether using cpuhp_setup_state()
>> > or using on_each_cpu() shouldn't be the main point.
>> > 

