Return-Path: <kvm+bounces-35503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD3EA1189E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82183168168
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 04:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9068C22F383;
	Wed, 15 Jan 2025 04:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbT0cB1b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A053522E3E1;
	Wed, 15 Jan 2025 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736917187; cv=fail; b=E6crKuBw0Ehbr4EXO0MBoKxy1jhbempY9lBilxHxkAkWenXQxscwQ9mBTEgW7HeONJOojPBLs2j4AkB5ZJE7R9q6upE3ZEnIWj07DiQUDeMiJkCycBHLFNCu21m5CIg8ui/P/jgVVxlHN3YPVjmWEhuSicck9sguGegGUGdeRFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736917187; c=relaxed/simple;
	bh=FO8bLQrJkh+VVSlJ9YVVpgOmQGYNgwW7SRIq/gl7Lfw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WBAXvuBmfKnpj21z0mkOJ9x+6qNlystoXeVHxYoSC/r+5A7+51A2u1+4shKvUOxf7SNA0q6wXf1CrhzAhzp17TvaXlL3JpQ0uf9nd9RmDN8xOiIm24YyPfxoknnfBYVKSmz7Z5dJpE7ANl4JFUlWKLSBV/26j63DbrUwq7Vbj9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbT0cB1b; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736917186; x=1768453186;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=FO8bLQrJkh+VVSlJ9YVVpgOmQGYNgwW7SRIq/gl7Lfw=;
  b=PbT0cB1bpDrH1A6DykdGCFwhZu3qOoO91H3wcqCyNcJy8aQbsSUQWI4T
   /v+tn8z7Scg8gcuFYpZbynBL38nbc2uZwIa/GuINYY4ne8OLH4FYOmkQ1
   ZqXAkq9KQVpNsPukrFP5+O7JLXL/HQWHYAJ7ac2rfl8TcE1Up4Z7TQhYK
   9rX2uR/SWT/6ZrEIxB4g+qyrOSNbFsnIsyYpnxZHlEOvwY6i4scEnaArG
   jMzDlhjWKRjtlBCjzr4jU3Ua826Gzy1Tu10BorNdnAIxmpkzvbIfhciU8
   hyr849xvymFs5os5pqMdo3jep1G++BcNiaLCkgTU2ly17kCtdv4JLBJ0n
   A==;
X-CSE-ConnectionGUID: J7yWAPO4TZqCmGsCPqrlUQ==
X-CSE-MsgGUID: D30uJuzWTJSFh8tb+dQ0/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="37398196"
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="37398196"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 20:59:46 -0800
X-CSE-ConnectionGUID: zUrkUTFkTwOVv+sQjL9X+Q==
X-CSE-MsgGUID: iecp3aR0SUe82RxsH3RBmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="104888752"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 20:59:45 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 20:59:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 20:59:44 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 20:59:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sPKLW7UzKxqJarPNTyMF6xe1UoNBrOfZkU/LICL/RkuLJkRHj5m918KSY/kc6WxdgALFIWFeB862OddPR1UDWRo/pTgMCVxmF8DoFK1cv/OjJcE+jSdoYf4g02AfASdB2UCpor306LvEEJu+VC8Fn4LPxgb+HRiQwaNE889ZqWxjBIm0V2UZSiFxJIUHsweYyRUjo21TxG06nu4Zzi7Y4dSD6/4klLzNvgrzAQOHPoWJ+2BcziIb09M9JhoOdVS4nYqcz2EUSU7B9KpOX4EhsSUcI+JcFQdqX+oywDcMM26YE3NX7QAKhaz9Hcy0roC057mgScNzzGkM6Z6JSh0mAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3d+bUy/7A6F/co3N12UZODUM9G+DyC12R80smDkjVdQ=;
 b=leCMEeQ5QaFcCMaAno4zseCRcwLSEJRTXcE7YmvI/cbj/2Rm/atT2+CyVA6M6GrY6pkZnnGwbuIFGjs1Y0u9W5N0ypG9VULkrGoEOQO1dLADteHdMjFUxnsRSAcOidiu5HiOwfnKtpCP88B+iXUapecI1fvAAKl4/LUtbq1zaLDmkC4D2/aoGj2B3ofPLPAxaVJqftbA57OOouXaDD1QeYvyJyvfGAzP6aPVo55mskDJ0FIZdUqFWFpZLPWy6fFexGdWQ9urgKHJV3OLAkothLoHf9H+MvV/GNHuHF2+N3h6OBk6tF/HZ3E4wR1i86bM9RAJ8FSnro9JXhzH0tYS6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Wed, 15 Jan 2025 04:59:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 04:59:01 +0000
Date: Wed, 15 Jan 2025 12:58:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 2/7] KVM: x86/mmu: Return RET_PF* instead of 1 in
 kvm_mmu_page_fault()
Message-ID: <Z4dAXaFM1iWaTjDp@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
 <20250113021138.18875-1-yan.y.zhao@intel.com>
 <a7b8151808b82550c7c5b5bfba69d334383cb2ba.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a7b8151808b82550c7c5b5bfba69d334383cb2ba.camel@intel.com>
X-ClientProxiedBy: SG2PR01CA0123.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::27) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: 2157595c-e038-4701-f259-08dd352153ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9GDlLgz75uDogjywkt0W2KRCSH12a3IycyV0f+x/HZGFBsfpQLiKacXXCz0v?=
 =?us-ascii?Q?UOHLHbAi5laf2QwW8RyNSsNhCR5B3gGceZDOKHcDqGG3Rq62WaxHqm5AEB8x?=
 =?us-ascii?Q?UUFyBC/O04xl54Zqmnk4Z3lJ7Q2zSnco2v7H4mRqFc+Wgt0UFR0xKvweNacp?=
 =?us-ascii?Q?dTKDDNKUbIjonEslSMKFe+lhIL7CtPJ5gZNNtQVKTEMJMoO0cNW3Gnot5+pt?=
 =?us-ascii?Q?Le1vFls4E8gb9UyAP1PoeVAkl/vivBk8uNlcJonBC3PS8Db8FGTq2emBWuNu?=
 =?us-ascii?Q?juy8kKbw0d9QVrj7YN19QEZPTdNeV0HEVCv/QgFn+WT7aOcO0YBcL5Q256HZ?=
 =?us-ascii?Q?UE2QEGMzi+benmgyVnPxQjdAoKcYlqXKRvzQXBp6hLrUNPwU8RZFndLcnHtR?=
 =?us-ascii?Q?dShIxwN+bi1tdhnIGAR7QeBASmdxXFFHOwOMmHbaYRQfzXtbLH2WclxfU5Ae?=
 =?us-ascii?Q?zTTYayvhSUfjzkuhlm9Z6Lvf9V0bWfKIkcfXnyAhjVTXfIN7ZWRovYihCQVi?=
 =?us-ascii?Q?2qAfIUFOATKIKQBWTSlyLPd0cOBzXB2sPRuCSwi9/Pwn0zIA3xZiVLFg9iiF?=
 =?us-ascii?Q?/EqLPmWlsjom/WgzneFUB2Nq9TLo9E+pkrBf9e/3bG1AQc8oMzBMFcFdaUVM?=
 =?us-ascii?Q?C2bSf8ysiEOoBqANzA/n+RIna2ZH9Vr0UtLXLDAZrVhd/Dr9WeJlbS5tcSHT?=
 =?us-ascii?Q?HUJtdlP0BVzm5psmbfsgt5Zu33mYecKgXv4sMWV+ssoxrxpuoW0XkRx2De6b?=
 =?us-ascii?Q?HYv0qigSe4iu5960pw+Sx6JhaWkudW0mYGuO7nR3TE5Of7pbDY8QOnVWUKy/?=
 =?us-ascii?Q?fxYP8l8WYv5k5/bKX3GOEdPXcgenG5ABixR2jh/T45lF7UCKSUvviZSWP3fo?=
 =?us-ascii?Q?kX9ik4X2FmNs6Av5UR65/kZ5MQu4OOfxOsr3yR/lcjhMH6yVo/ti0+eV+gCr?=
 =?us-ascii?Q?UxWXlfrSPGAhYiC3XKhEi+b71nq+hsVvUb5Ap36xU89ly+DjcojBOMHFWSEf?=
 =?us-ascii?Q?guCCTpJ6wcYqVRZv3RGmGzYyq3LItSQ5oUIEsbLVe8UIqkxpvWtpouyG2Y1q?=
 =?us-ascii?Q?qiqB1OsJumjbSUH2YEZuVXhAr58k8ZdX4YMCykpkOvPtDZJQ843RTHNnsLGV?=
 =?us-ascii?Q?ngxX/9PzkrG3asf25F3RzYWhOKlnvtx4VR7rlFQ9ca+8Sye/ASZLyq3OUBlP?=
 =?us-ascii?Q?oRPuQqoVmK8JxEzzpJGm/q0ngP9iCVFhHDgA3qqdxsE2S/ozQnvGVC+7qnk0?=
 =?us-ascii?Q?xGrM9Y3nQ3JW556vurhfKANczIgYhIZCehiQmr4E/1CFpVoLk9XG5spF8idW?=
 =?us-ascii?Q?gPHhhjBOuoITrkK1dW5wo0ki4RM4Z1iVxtM5yjox3YWQd3ZgVdoRkX5c+A8O?=
 =?us-ascii?Q?dWm6+gESdT2BCSS37k58oGz6OdEA?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tub4i5DZkdRIYva1iUwvHFrhYTJojrVzon0aYWXBj+vM5493Pmg3uXqvDc5F?=
 =?us-ascii?Q?bxaTyM9KJq4HyxV7s620PRJjuU6KyZk8FvRDAeMIDuB+pYrpHB6by2M6S3r0?=
 =?us-ascii?Q?GcDjpZ4owLlxLip/YdpIPtfuCNiMGVz6pbK2RoH5MEsaxv3Hx6ob9owS+mFg?=
 =?us-ascii?Q?ZkDnaiexDpjr70uhB9ohlT2eFktc8IKCK3zHq6xwWoNTQmfsmvkB+cftyObY?=
 =?us-ascii?Q?xXTqGWc6ZYL3dKDug6VlFYs/+h58loOR5tKRCxG2XHvpGFqPW9xass/i8NwN?=
 =?us-ascii?Q?iapUo6LZdSfveoKEEwdUwbsXys8/rSmFxCslpnwoXo1TUQVeDdjsUYXW9u4x?=
 =?us-ascii?Q?5jhiIIavWM72MH8oTGdhQTSBmevKJdqqG3Eo9d1fZQ4/t84yB9xT3rbputse?=
 =?us-ascii?Q?ETvUmaUDVhLXcTYcnwq1sIfpJpRw2f21bDDWX9KWN8fkc31I5UBTi2/AsZ7T?=
 =?us-ascii?Q?xBStpWLrxxgXnWCqVgaM+j85EeUmf+J19OjQedF0H/S8JPPk79KAqEusFE54?=
 =?us-ascii?Q?tsJNLtelSnTg9vV0O8+b+kUlkLXqjermAsDdEwM+d/xGypcOGmWvGnyX/ejN?=
 =?us-ascii?Q?xz71JWOkZMV84OS8xpe16dJY3k4IKpukX8e/PV0aBwoee8aM53Q7Hr/iWznK?=
 =?us-ascii?Q?csBz2HHPnZczhDA1Lmqcdl8MfUuvK5dZY+S0VQZ6zgqW8hCjy1NkJjHeUxY2?=
 =?us-ascii?Q?u2ZBWYTKQAerrDTqkjCe1Al7LevpYBW330v9VXyGiIBYy4x237UGYxlSWU6B?=
 =?us-ascii?Q?oFpzqpZY3YeC2aoXItKeSywRFMW0DXns+BLM14g51jgrM1oqgNnRSnOjN7iz?=
 =?us-ascii?Q?Dwt92vznrsvwCuEC3Qrht3lDg6JU3Yy+gPo2PyIZfivjzeuHmEMpRru+14s4?=
 =?us-ascii?Q?xJPeu2a4l55fMI0AQHb5rN9uFZeIIY4I+kNV8LBQLKiA/q/6dtRGG5v4Ae7W?=
 =?us-ascii?Q?83WQ519v4EyVZ2ZDH3xC74d9KqLRMGy56LnaK/HsQVVMNJ5Cu7GZWNY+JABu?=
 =?us-ascii?Q?5ddaB2dR13Kl/riuzb5GvwTGe5bJbgf49acZ/SEhggSSbntSzLwaPbOtUS6+?=
 =?us-ascii?Q?7zBC3lkFjX/7n00hnqbcg2pwlTUYCZTSiOaaISu5FA/52pmDRy5W2f7vpgFy?=
 =?us-ascii?Q?psv7jF8Te7+JJcoZlm2PsJHVvaYX3C1GbY+dc+dNFpzz1X38eRk8ViJZ7GAm?=
 =?us-ascii?Q?YgP8HgH+xJie56aQbmhDvoazqAPzsql/OPCK3GsOoALyeq5+NpvrYi0jeoOo?=
 =?us-ascii?Q?H3mNh1dOaK6WoOhptHXfmme7KPqzCoWA2Ra4CI7SG5RmeOh8NDNdTJaAswjc?=
 =?us-ascii?Q?8Wx9zgVtUzHXh0Y9hOzTMos0dWAf8cCdE+Kkn5P17fspCQsVQiRylV6gxEFP?=
 =?us-ascii?Q?62+IqUcK5njABgFVSyEEf1yJtZvnXpT53X9tKppRMqKcrSDcWDQW19oqZUk3?=
 =?us-ascii?Q?3Q/PFBnsR11ZhQC39t/+0fpDHtXCdN6iuCNrzhzsFwkblOt4XLKpqYcaynDQ?=
 =?us-ascii?Q?lF093WsvRThAlBoWkGokmcX0WQaOVI95XrcaXABYChsJvpOG208QSuxsQ+NF?=
 =?us-ascii?Q?Ajoo4PeGhJfcCX59hyowz+5P+QqIE79ducKJANQH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2157595c-e038-4701-f259-08dd352153ea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 04:59:01.6031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6e19r63TRfP5p4yyDiscWG0BkTzF3r5UY7bLfD4YBddEWqkJeM4mr/CbNub3q8JB9UmuHp8eJFKlWxIxWUWyBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com

On Wed, Jan 15, 2025 at 06:24:43AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2025-01-13 at 10:11 +0800, Yan Zhao wrote:
> > Return RET_PF* (excluding RET_PF_EMULATE/RET_PF_CONTINUE/RET_PF_INVALID)
> > instead of 1 in kvm_mmu_page_fault().
> > 
> > The callers of kvm_mmu_page_fault() are KVM page fault handlers (i.e.,
> > npf_interception(), handle_ept_misconfig(), __vmx_handle_ept_violation(),
> > kvm_handle_page_fault()). They either check if the return value is > 0 (as
> > in npf_interception()) or pass it further to vcpu_run() to decide whether
> > to break out of the kernel loop and return to the user when r <= 0.
> > Therefore, returning any positive value is equivalent to returning 1.
> > 
> > Warn if r == RET_PF_CONTINUE (which should not be a valid value) to ensure
> > a positive return value.
> > 
> > This is a preparation to allow TDX's EPT violation handler to check the
> > RET_PF* value and retry internally for RET_PF_RETRY.
> > 
> > No functional changes are intended.
> 
> Any reason why this can't go ahead of the TDX patches? Seems pretty generic
> cleanup.
Hmm, I wouldn't consider this a cleanup, as returning 1 to indicate continuation
of the kernel loop is a well-established convention in arch/x86/kvm.

Returning a positive RET_PF_* in this patch is primarily a preparatory step for
the subsequent patch,
"KVM: TDX: Retry locally in TDX EPT violation handler on RET_PF_RETRY".

