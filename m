Return-Path: <kvm+bounces-65184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91DDFC9D97D
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 03:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A64073A82F8
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 02:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0295239E97;
	Wed,  3 Dec 2025 02:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KzcnkxIb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63250213254;
	Wed,  3 Dec 2025 02:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764730132; cv=fail; b=C6lXpE6scvYSVzPIGJCKipGi8bBA5GCXwy6aQyjg1K2jgreu8ZElr+QQGoeZIUxgKhiVmJy+Eovw/K0i8WWO1CFfxP9ZFYMc3PfdD6g+wI61gcMkPGC12bdkP3kSdf0FwIbUzFCVKeX3cPqa/vtGTosQmEb3ycUIuEej2TY0o6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764730132; c=relaxed/simple;
	bh=3OcBhxtOVzC71/FSFDMl20vJcdQJOZhO2gHyOuV5svc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Tcdo9dgiPmISMsPXGYuRIIT3xSRWTvQVVMF+LPqBKPfdLkP44J1jO5up/hiH2G/KQrD1x7Npp7uAdZAM1T95QL1LV9S/94YszLUl15RpWwXEVwcd0OPXkgNAR+bHCpXnZ+BCH7inQWvi3YtCjtz+Qe5jJzlxHGPORPpEgy8QLzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KzcnkxIb; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764730130; x=1796266130;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3OcBhxtOVzC71/FSFDMl20vJcdQJOZhO2gHyOuV5svc=;
  b=KzcnkxIb9e9DouAIG+B6zIZe+WXthaqJui2MJ5lZIyYfJRrXgvdi9wnZ
   ge+KB28yoE0cX9PL4K2iS20a+D4TOG7mYQrzsc/DDtQl9oIqp3V6MJTxP
   H9/aAqTEZZd7qeB+3vJdar5yai1y65PWS86NqpNZqlGKpIUjo+LnwZJZD
   z1Qf9Oj57ohGgx4ZiZanZuLYalI4Hq/n4QfqUCIycpE/HSF8VVNI6wYlj
   bylLL8cxWtsCj8UPkWOBEx/rPdgDyvTyNUDkV153qYMYkBGoqp4PS4XHp
   bHjO9s8OyN2z87eJUpPW2lfC0WawzYrn8EAR65CydT5ts5XyaY7WBID+6
   Q==;
X-CSE-ConnectionGUID: b+cxuFSRQNWv1mGXRUXvmg==
X-CSE-MsgGUID: U85fgEVcTf++CfJY5DRU8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66881613"
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="66881613"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 18:48:49 -0800
X-CSE-ConnectionGUID: KXU364a3Q0iMRJFucmdmVQ==
X-CSE-MsgGUID: qgKSBrWLQRWZe3I1W8xg1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,244,1758610800"; 
   d="scan'208";a="217880592"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 18:48:49 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 18:48:48 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 18:48:48 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 18:48:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OeyDxfI1YPuW+kZhG22kNiUFDqybOaeiEzXxZgwN7T8ktufgPXkQKhenRpioq7lF5y9qGuPi/T5fVVu42Hfuy2Hs8CCkOo/pS1PAleqG895PPVU9MeuvyzG8dXzCBE/CYkbdeJL6LBfeng6V/fpPov3JkQCt2zlY9/lwQphOGKZ7U8U2Do/ESW7zWf6BywX//LN6Jm2lVYG7rixWhsdldzGyGPJfVP0Eo9tzk7U3YHZlLXkEaIRQg4LCafUjoFvDq2Do/kPq128azGFW6QW1TNSddyisDMKpXHSPEFyud3kpUJbOw9FzR7glqRFSHxwEHeWO2b/CKi5sHzmP3qswcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X++BFDF5DTXVe/NOmPFrkvKPiZsThhs3/kEXFmzOoME=;
 b=FiCT0My0R4GixkeMHNE177QyG0OGZD5S0D1WrR6x1q13qQLIr1gyRXX92UTA2SU4m2rgmv7J62zr+wCy149p7d/RDMsNTBjSf5UdbmdsCsfChpvyB1tFhpu0uc2nCQIMpOxPjze5lspYktMJDy+Q0KcPs5dwYlZ0hjzJeTRD1N7RHzb949Umf31RMvQAvga/9ZIcCObkcLn+zVz8xDDVelN7TQSO3JsmiNBIOk1+7gEkjjVThz3uAnU6PmC2RJv36lJCN05cp8vGyxv/81GS9xwbJqSd0RzFKEW6VxEACtW4eYPHEOjczt/SXzsASMlORzpuqwLpaTZutKVTtG36Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8341.namprd11.prod.outlook.com (2603:10b6:610:178::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 02:48:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 02:48:44 +0000
Date: Wed, 3 Dec 2025 10:46:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <aS+kg+sHJ0lveupH@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
 <20251121130144.u7eeaafonhcqf2bd@amd.com>
 <aSQmAuxGK7+MUfRW@yzhao56-desk.sh.intel.com>
 <20251201221355.wvsm6qxwxax46v4t@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251201221355.wvsm6qxwxax46v4t@amd.com>
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8341:EE_
X-MS-Office365-Filtering-Correlation-Id: 91467823-1998-45c8-5866-08de32167990
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?bGqJXJrzp4spNnbkSwyjGJzdoEnLXVuFECsTYkHwX+kiNKtK1fCwFWT7l5PL?=
 =?us-ascii?Q?udrIpQr1RL3evUFIPz2hde8Rqh5gjo9MD+E4MClKZnE73AY6o4UVUOExjTNw?=
 =?us-ascii?Q?YyxK1Qrc6ZuIzIM4IqACFyvfoR0LWrnAFPwM7fOMsP1Oh0ZJ2mwEcbjDcAa/?=
 =?us-ascii?Q?i9vZYTpYmuC46+MQmLL9//YkokpPzm/OC24IxTR0SOAJPA0c0mz9iFbY9Sf9?=
 =?us-ascii?Q?sp9bxESW30EZhq1gijUiaZdX55bMaYJ3qMkGrJb7Ep3mnsxk5BT039P7o7h/?=
 =?us-ascii?Q?gZjNDKpeZ7HHuiJwX4nk8gSNCRuAF8qif1Bbb800S79ZLbVNdX8GaNiNuAHp?=
 =?us-ascii?Q?54m+nS8fbYXU3/pAux/MgOj3I3u5LQR/c1TXo0KlB6X3lEsUMYhjG510pd29?=
 =?us-ascii?Q?HKG+nN4AejK5DO983gXSuOH9EZCJY3arDYre1VxcVR2bnbdlgvmspvDEFSem?=
 =?us-ascii?Q?U5Gn/Sr5Rb1LYVZ0HiQdVC922n32ON8p69f0ECFbkBU7ClXXwre7pypX3MOk?=
 =?us-ascii?Q?t0jLVKQVCFYtAor5u3YRgpKgYAH7tLmUA7g1y1ovTPu5Jel83LZx0M2s5pwd?=
 =?us-ascii?Q?I1PQCIlNI7tEtlthqKLOgPK47w8oNC1Ekoivk3jvrzmiKDfjL2lKjTd+Hqwd?=
 =?us-ascii?Q?5jBglwKZCgs/eNvh+Qna/mSYLqlYzgTG3KgUFDWVdgELshfqu3ceRR9YfFKB?=
 =?us-ascii?Q?E/4SegWp0nKoOfd4Rf0hGZ/l++WmXfmRpt2xb4ONzcQEaYcXSG+B+3rjlAC/?=
 =?us-ascii?Q?18g91/NnHwKgEdqctWc7YQz07w6eLFUa2fBK6yD1lK8CbTkVeqytXB3OXEe2?=
 =?us-ascii?Q?+gJSZr0/zfNKF2wBnu3zKODoDna42qfOxcJI3XWpt9Rr2hOfnxBL2U7M7huW?=
 =?us-ascii?Q?7vsjENRXKW/3rXC+bG2+7rSldP2F2OhKlQUu+NBplzHn8iwaazsvcqKwfOGs?=
 =?us-ascii?Q?LKY5hbFywzTEU9MF002HWNcTZM0AMqRGrMIYGLUxZGaYRbiOqvnvPx01YqD7?=
 =?us-ascii?Q?oTxxtFzZjQ6DvZzRY5Hc5BukMjubR6Yz0frVnKYqk7UwCGWlY1pjr+JMhx/H?=
 =?us-ascii?Q?qtYo/HlLY+YtUwoFvOmTvVj4Ljy1X0rzPnrjSV3eeig4GIJWuqwXSlIEcQgP?=
 =?us-ascii?Q?w9qQKg3diieE8ZZRaiRDGOLmC0mdo9rsFpFrWSYOfEgvrRXxlhVquClSO8FF?=
 =?us-ascii?Q?pjF/UG+UkT90VZ4u2AHJtCvwIvQwNzfJKLsZpLOnxviYIlagaSVnXZTO9NVI?=
 =?us-ascii?Q?JjVbYAP9rkMSkbMjGpMJiM3yzUvVFHpDvUP2X0NDNg44cuw5wnbCFUFUEHON?=
 =?us-ascii?Q?4ddpB+2v/csTgWpDV+H1PEqWI4903hl8iYVLjxdHDgs+weol+w8LU1WclctV?=
 =?us-ascii?Q?dm+9T3bxgJV17gHtKv6NVS9Z+YZjMDVO4DLUMsJmOv47etAdPw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0cQHrQbK0u3EVPpSARoOYUPibag2siThIzvNRQ9luQ8a9cxwjXQZMYLB0tjG?=
 =?us-ascii?Q?MHdk4ERE4M7za0/hQ/sbuPv9R8y7iJ0VVM6+pl9Xq+33dHG52cNXkkymEoRm?=
 =?us-ascii?Q?Nis28hJl8aYDYc6lb1GRAn4Zb5QkYAofoO7HNN/FqNFbEljQIsKc2XWFHjRV?=
 =?us-ascii?Q?d4CKBonlayMwJ9Ku0g+3rb2IAd9oTmO15YJ/pkZmoqXwFa6lMmPduVo4+IIG?=
 =?us-ascii?Q?Bslz+xrVnmf04NjLAfk0J3BSd7p+BtS8kuf6zCSGHiQbCxArMUrWNzr8paZ2?=
 =?us-ascii?Q?amGTNMY9LIMUFG0GCT+Ar2Xob7GL2uLHf0m0JYV8WFi4hTA511rPq6eegzYk?=
 =?us-ascii?Q?7oUZGSklb+DGT30Bx5ehmbCDeFqkG8u7QJzYXHKXS/Yi/1Nxy4HFKNZA6PEr?=
 =?us-ascii?Q?uo5L55kPHcmyt+0q+k63+99QDxCAEz9+gkykcHA3H9qr0TdMEvEgrJKMLjp6?=
 =?us-ascii?Q?HajkrtY+1kwVIZUcYowm3JBo74Nlgx52BQ0ySET6yANyokivccno7mTW1H/8?=
 =?us-ascii?Q?kUl9FIW8AieCFcXaaR+cAUGRS8lyTN75FLh8I4UPydfqm5RkQdxqeZnQNg4y?=
 =?us-ascii?Q?92zp/Ff9uNfOtyS3JZ+nK0BsGEaYJs/MtJ3Vm5hffH0a4CoaIgupg0FSNZCB?=
 =?us-ascii?Q?500mXluONXgsSdx28GdCrMO76DErETI87LjNuwTvT7XqVZR0r6MYrFrX2QU8?=
 =?us-ascii?Q?p9J564bAJhBIYsY9W1hQtxru+7Tbt11TDZVIHgEMbEzZrwtu+sfaUGS/xN4Y?=
 =?us-ascii?Q?yFYomz6xr2b44H0xe9lpwlG9OTxnDT6M/BZpWqR2GV+hELeY/jSQnLVEIoJf?=
 =?us-ascii?Q?zu7//mb1tenv2Yy0SbGt6UaqFLYCPKtmGJM5GTtHJib19VDTBp6AvIXtC5yH?=
 =?us-ascii?Q?VDW9MmE1fiIHNcXTiFNOa/p8cyNBGFVQ4EFbTDptms26BXrjh//LrqswvWAZ?=
 =?us-ascii?Q?TmfufryoWB2ztvP0msoWyNzuv/s1iHRh6Y90ouHU8fxadPIXnQzx6WnjJcs7?=
 =?us-ascii?Q?/I9aJ70Q+LC5rtn3Ox/La0yZHX6QKwOtFs0j5SP+kf6RJSrbL6vk2ObvzlIZ?=
 =?us-ascii?Q?9qqSzu3tjRrFF0q/sxxHRt0qVDuaxlS4/RPaNldQd9igDsWP/DHCtkj2HORL?=
 =?us-ascii?Q?QkQ4T+2iPSecAo5gSt+UK1JbN6hnjXW7nh7wrRUPZjAtEPZxuRzeZPVuUXFj?=
 =?us-ascii?Q?EsCeW0pxx1JdtBvl6R/6StRFwI2MMmQmDjXM/PsgJFlrnujV4RWVyS9XTkqH?=
 =?us-ascii?Q?GIMdnvPqfZ4K3esP0E9oKUpoB1KEuGompPKUgrQmfy0IxKitjOoJY3fgZsnC?=
 =?us-ascii?Q?NbAA8/fo8XjmCmuHBDy44dJ5UPnRhFHj2thz8prKZil8+OspewjR7L3gazXm?=
 =?us-ascii?Q?Ut6Wgz3IJBpEkGZO4fdvrA1FBzP6yKmjne370Qp8ZQNJkptJJ4eMyQSq0yX0?=
 =?us-ascii?Q?E9JQbfPskx6nnkFMp2omRRFYL7AIK0i/M1avXD9B3j9H3kkJNYH+mB4+q2H3?=
 =?us-ascii?Q?liM7R7FKRRjCv/Lhsywroopjnw5HSgrO8CPoTyis+0wRU1jnQ8cPMwUDmbnl?=
 =?us-ascii?Q?6ebYaE6bX0zl8ulJLsyHGZBWJaH6r04o/Ig0pl4x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 91467823-1998-45c8-5866-08de32167990
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 02:48:44.7030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2u2L6IzqRG8BGMKIsEdPL7ge/5+j6EdfpbnAOIyQP+p37lQyqtQDlPx4uQW+3QBAhJiijN+v+Yj+UrJfKDVGpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8341
X-OriginatorOrg: intel.com

On Mon, Dec 01, 2025 at 04:13:55PM -0600, Michael Roth wrote:
> On Mon, Nov 24, 2025 at 05:31:46PM +0800, Yan Zhao wrote:
> > On Fri, Nov 21, 2025 at 07:01:44AM -0600, Michael Roth wrote:
> > > On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> > > > On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> > > > > Currently the post-populate callbacks handle copying source pages into
> > > > > private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> > > > > acquires the filemap invalidate lock, then calls a post-populate
> > > > > callback which may issue a get_user_pages() on the source pages prior to
> > > > > copying them into the private GPA (e.g. TDX).
> > > > > 
> > > > > This will not be compatible with in-place conversion, where the
> > > > > userspace page fault path will attempt to acquire filemap invalidate
> > > > > lock while holding the mm->mmap_lock, leading to a potential ABBA
> > > > > deadlock[1].
> > > > > 
> > > > > Address this by hoisting the GUP above the filemap invalidate lock so
> > > > > that these page faults path can be taken early, prior to acquiring the
> > > > > filemap invalidate lock.
> > > > > 
> > > > > It's not currently clear whether this issue is reachable with the
> > > > > current implementation of guest_memfd, which doesn't support in-place
> > > > > conversion, however it does provide a consistent mechanism to provide
> > > > > stable source/target PFNs to callbacks rather than punting to
> > > > > vendor-specific code, which allows for more commonality across
> > > > > architectures, which may be worthwhile even without in-place conversion.
> > > > > 
> > > > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > > ---
> > > > >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> > > > >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> > > > >  include/linux/kvm_host.h |  3 ++-
> > > > >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> > > > >  4 files changed, 71 insertions(+), 35 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > index 0835c664fbfd..d0ac710697a2 100644
> > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> > > > >  };
> > > > >  
> > > > >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > > > > -				  void __user *src, int order, void *opaque)
> > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > +				  int order, void *opaque)
> > > > >  {
> > > > >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> > > > >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > > > > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > >  	int npages = (1 << order);
> > > > >  	gfn_t gfn;
> > > > >  
> > > > > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > > > > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> > > > >  		return -EINVAL;
> > > > >  
> > > > >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > > > > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > >  			goto err;
> > > > >  		}
> > > > >  
> > > > > -		if (src) {
> > > > > -			void *vaddr = kmap_local_pfn(pfn + i);
> > > > > +		if (src_pages) {
> > > > > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > >  
> > > > > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > > > > -				ret = -EFAULT;
> > > > > -				goto err;
> > > > > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > > > > +			kunmap_local(src_vaddr);
> > > > > +
> > > > > +			if (src_offset) {
> > > > > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > +
> > > > > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > > > > +				kunmap_local(src_vaddr);
> > > > IIUC, src_offset is the src's offset from the first page. e.g.,
> > > > src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> > > > 
> > > > Then it looks like the two memcpy() calls here only work when npages == 1 ?
> > > 
> > > src_offset ends up being the offset into the pair of src pages that we
> > > are using to fully populate a single dest page with each iteration. So
> > > if we start at src_offset, read a page worth of data, then we are now at
> > > src_offset in the next src page and the loop continues that way even if
> > > npages > 1.
> > > 
> > > If src_offset is 0 we never have to bother with straddling 2 src pages so
> > > the 2nd memcpy is skipped on every iteration.
> > > 
> > > That's the intent at least. Is there a flaw in the code/reasoning that I
> > > missed?
> > Oh, I got you. SNP expects a single src_offset applies for each src page.
> > 
> > So if npages = 2, there're 4 memcpy() calls.
> > 
> > src:  |---------|---------|---------|  (VA contiguous)
> >           ^         ^         ^
> >           |         |         |
> > dst:      |---------|---------|   (PA contiguous)
> > 
> > 
> > I previously incorrectly thought kvm_gmem_populate() should pass in src_offset
> > as 0 for the 2nd src page.
> > 
> > Would you consider checking if params.uaddr is PAGE_ALIGNED() in
> > snp_launch_update() to simplify the design?
> 
> This was an option mentioned in the cover letter and during PUCK. I am
> not opposed if that's the direction we decide, but I also don't think
> it makes big difference since:
> 
>    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                struct page **src_pages, loff_t src_offset,
>                                int order, void *opaque);
> 
> basically reduces to Sean's originally proposed:
> 
>    int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>                                struct page *src_pages, int order,
>                                void *opaque);

Hmm, the requirement of having each copy to dst_page account for src_offset
(which actually results in 2 copies) is quite confusing. I initially thought the
src_offset only applied to the first dst_page.

This will also cause kvm_gmem_populate() to allocate 1 more src_npages than
npages for dst pages.

> for any platform that enforces that the src is page-aligned, which
> doesn't seem like a huge technical burden, IMO, despite me initially
> thinking it would be gross when I brought this up during the PUCK call
> that preceeding this posting.
> > 
> > > > 
> > > > >  			}
> > > > > -			kunmap_local(vaddr);
> > > > > +
> > > > > +			kunmap_local(dst_vaddr);
> > > > >  		}
> > > > >  
> > > > >  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > > > > @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> > > > >  	if (!snp_page_reclaim(kvm, pfn + i) &&
> > > > >  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> > > > >  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > > > > -		void *vaddr = kmap_local_pfn(pfn + i);
> > > > > +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > > > > +		void *dst_vaddr = kmap_local_pfn(pfn + i);
> > > > >  
> > > > > -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> > > > > -			pr_debug("Failed to write CPUID page back to userspace\n");
> > > > > +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> > > > > +		kunmap_local(src_vaddr);
> > > > > +
> > > > > +		if (src_offset) {
> > > > > +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > > > > +
> > > > > +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> > > > > +			kunmap_local(src_vaddr);
> > > > > +		}
> > > > >  
> > > > > -		kunmap_local(vaddr);
> > > > > +		kunmap_local(dst_vaddr);
> > > > >  	}
> > > > >  
> > > > >  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> > > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > > index 57ed101a1181..dd5439ec1473 100644
> > > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > > @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
> > > > >  };
> > > > >  
> > > > >  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > > -				  void __user *src, int order, void *_arg)
> > > > > +				  struct page **src_pages, loff_t src_offset,
> > > > > +				  int order, void *_arg)
> > > > >  {
> > > > >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> > > > >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > >  	u64 err, entry, level_state;
> > > > >  	gpa_t gpa = gfn_to_gpa(gfn);
> > > > > -	struct page *src_page;
> > > > >  	int ret, i;
> > > > >  
> > > > >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> > > > >  		return -EIO;
> > > > >  
> > > > > -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> > > > > +	/* Source should be page-aligned, in which case src_offset will be 0. */
> > > > > +	if (KVM_BUG_ON(src_offset))
> > > > 	if (KVM_BUG_ON(src_offset, kvm))
> > > > 
> > > > >  		return -EINVAL;
> > > > >  
> > > > > -	/*
> > > > > -	 * Get the source page if it has been faulted in. Return failure if the
> > > > > -	 * source page has been swapped out or unmapped in primary memory.
> > > > > -	 */
> > > > > -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> > > > > -	if (ret < 0)
> > > > > -		return ret;
> > > > > -	if (ret != 1)
> > > > > -		return -ENOMEM;
> > > > > -
> > > > > -	kvm_tdx->page_add_src = src_page;
> > > > > +	kvm_tdx->page_add_src = src_pages[i];
> > > > src_pages[0] ? i is not initialized. 
> > > 
> > > Sorry, I switched on TDX options for compile testing but I must have done a
> > > sloppy job confirming it actually built. I'll re-test push these and squash
> > > in the fixes in the github tree.
> > > 
> > > > 
> > > > Should there also be a KVM_BUG_ON(order > 0, kvm) ?
> > > 
> > > Seems reasonable, but I'm not sure this is the right patch. Maybe I
> > > could squash it into the preceeding documentation patch so as to not
> > > give the impression this patch changes those expectations in any way.
> > I don't think it should be documented as a user requirement.
> 
> I didn't necessarily mean in the documentation, but mainly some patch
> other than this. If we add that check here as part of this patch, we
> give the impression that the order expectations are changing as a result
> of the changes here, when in reality they are exactly the same as
> before.
> 
> If not the documentation patch here, then I don't think it really fits
> in this series at all and would be more of a standalone patch against
> kvm/next.
> 
> The change here:
> 
>  -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
>  +	/* Source should be page-aligned, in which case src_offset will be 0. */
>  +	if (KVM_BUG_ON(src_offset))
> 
> made sense as part of this patch, because now that we are passing struct
> page *src_pages, we can no longer infer alignment from 'src' field, and
> instead need to infer it from src_offset being 0.
> 
> > 
> > However, we need to comment out that this assertion is due to that
> > tdx_vcpu_init_mem_region() passes npages as 1 to kvm_gmem_populate().
> 
> You mean for the KVM_BUG_ON(order > 0, kvm) you're proposing to add?
> Again, if feels awkward to address this as part of this series since it
> is an existing/unchanged behavior and not really the intent of this
> patchset.
That's true. src_pages[0] just makes it more eye-catching.
What about just adding a comment for src_pages[0] instead of KVM_BUG_ON()?

> > > > >  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> > > > >  	kvm_tdx->page_add_src = NULL;
> > > > >  
> > > > > -	put_page(src_page);
> > > > > -
> > > > >  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> > > > >  		return ret;
> > > > >  
> > > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > > index d93f75b05ae2..7e9d2403c61f 100644
> > > > > --- a/include/linux/kvm_host.h
> > > > > +++ b/include/linux/kvm_host.h
> > > > > @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> > > > >   * Returns the number of pages that were populated.
> > > > >   */
> > > > >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > > > > -				    void __user *src, int order, void *opaque);
> > > > > +				    struct page **src_pages, loff_t src_offset,
> > > > > +				    int order, void *opaque);
> > > > >  
> > > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> > > > >  		       kvm_gmem_populate_cb post_populate, void *opaque);
> > > > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > > > index 9160379df378..e9ac3fd4fd8f 100644
> > > > > --- a/virt/kvm/guest_memfd.c
> > > > > +++ b/virt/kvm/guest_memfd.c
> > > > > @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> > > > >  
> > > > >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > > > > +
> > > > > +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
> > > > Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
> > > > folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
> > > > when src_pages[] can only hold up to 512 pages?
> > > 
> > > This was necessarily chosen in prep for hugepages, but more about my
> > > unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
> > > happens to align with 2MB hugepages while seeming like a reasonable
> > > batching value so that's why I chose it.
> > >
> > > Even with 1GB support, I wasn't really planning to increase it. SNP
> > > doesn't really make use of RMP sizes >2MB, and it sounds like TDX
> > > handles promotion in a completely different path. So atm I'm leaning
> > > toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
> > > support for kvm_gmem_populate() path and not bothering to change it
> > > until a solid use-case arises.
> > The problem is that with hugetlb-based guest_memfd, the folio itself could be
> > of 1GB, though SNP and TDX can force mapping at only 4KB.
> 
> If TDX wants to unload handling of page-clearing to its per-page
> post-populate callback and tie that its shared/private tracking that's
> perfectly fine by me.
> 
> *How* TDX tells gmem it wants this different behavior is a topic for a
> follow-up patchset, Vishal suggested kernel-internal flags to
> kvm_gmem_create(), which seemed reasonable to me. In that case, uptodate
Not sure which flag you are referring to with "Vishal suggested kernel-internal
flags to kvm_gmem_create()".

However, my point is that when the backend folio is 1GB in size (leading to
max_order being PUD_ORDER), even if SNP only maps at 2MB to RMP, it may hit the
warning of "!IS_ALIGNED(gfn, 1 << max_order)".

For TDX, it's worse because it always passes npages as 1, so it will also hit
the warning of "(npages - i) < (1 << max_order)".

Given that this patch already considers huge pages for SNP, it feels half-baked
to leave the WARN_ON() for future handling.
    WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
            (npages - i) < (1 << max_order));

> flag would probably just default to set and punt to post-populate/prep
> hooks, because we absolutely *do not* want to have to re-introduce per-4K
> tracking of this type of state within gmem, since getting rid of that sort
> of tracking requirement within gmem is the entire motivation of this
> series. And since, within this series, the uptodate flag and
> prep-tracking both have the same 4K granularity, it seems unecessary to
> address this here.
> 
> If you were to send a patchset on top of this (or even independently) that
> introduces said kernel-internal gmem flag to offload uptodate-tracking to
> post-populate/prep hooks, and utilize it to optimize the current 4K-only
> TDX implementation by letting TDX module handle the initial
> page-clearing, then I think that change/discussion can progress without
> being blocked in any major way by this series.
> 
> But I don't think we need to flesh all that out here, so long as we are
> aware of this as a future change/requirement and have reasonable
> indication that it is compatible with this series.
> 
> > 
> > Then since max_order = folio_order(folio) (at least in the tree for [1]), 
> > WARN_ON() in kvm_gmem_populate() could still be hit:
> > 
> > folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
> > WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> >         (npages - i) < (1 << max_order));
> 
> Yes, in the SNP implementation of hugetlb I ended up removing this
> warning, and in that case I also ended up forcing kvm_gmem_populate() to
> be 4K-only:
> 
>   https://github.com/AMDESE/linux/blob/snp-hugetlb-v2-wip0/virt/kvm/guest_memfd.c#L2372

For 1G (aka HugeTLB) page, this fix is also needed, which was missed in [1] and
I pointed out to Ackerley at [2].

[1] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
[2] https://lore.kernel.org/all/aFPGPVbzo92t565h@yzhao56-desk.sh.intel.com/

> but it makes a lot more sense to make those restrictions and changes in
> the context of hugepage support, rather than this series which is trying
> very hard to not do hugepage enablement, but simply keep what's partially
> there intact while reworking other things that have proven to be
> continued impediments to both in-place conversion and hugepage
> enablement.
Not sure how fixing the warning in this series could impede hugepage enabling :)

But if you prefer, I don't mind keeping it locally for longer.

> Also, there's talk now of enabling hugepages even without in-place
> conversion for hugetlbfs, and that will likely be the same path we
> follow for THP to remain in alignment. Rather than anticipating what all
> these changes will mean WRT hugepage implementation/requirements, I
> think it will be fruitful to remove some of the baggage that will
> complicate that process/discussion like this patchset attempts.
> 
> -Mike
> 
> > 
> > TDX is even easier to hit this warning because it always passes npages as 1.
> > 
> > [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com
> > 
> >  
> > > > Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> > > > 
> > > > Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> > > > per 4KB while removing the max_order from post_populate() parameters, as done
> > > > in Sean's sketch patch [1]?
> > > 
> > > That's an option too, but SNP can make use of 2MB pages in the
> > > post-populate callback so I don't want to shut the door on that option
> > > just yet if it's not too much of a pain to work in. Given the guest BIOS
> > > lives primarily in 1 or 2 of these 2MB regions the benefits might be
> > > worthwhile, and SNP doesn't have a post-post-populate promotion path
> > > like TDX (at least, not one that would help much for guest boot times)
> > I see.
> > 
> > So, what about below change?
> > 
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -878,11 +878,10 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >                 }
> > 
> >                 folio_unlock(folio);
> > -               WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > -                       (npages - i) < (1 << max_order));
> > 
> >                 ret = -EINVAL;
> > -               while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> > +               while (!IS_ALIGNED(gfn, 1 << max_order) || (npages - i) < (1 << max_order) ||
> > +                      !kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE,
> >                                                         KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> >                         if (!max_order)
> > 
> > 
> > 
> > > 
> > > > 
> > > > Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
> > > > triggered by TDX when max_order > 0 && npages == 1:
> > > > 
> > > >       WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > >               (npages - i) < (1 << max_order));
> > > > 
> > > > 
> > > > [1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > > > 
> > > > >  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> > > > >  		       kvm_gmem_populate_cb post_populate, void *opaque)
> > > > >  {
> > > > >  	struct kvm_memory_slot *slot;
> > > > > -	void __user *p;
> > > > > -
> > > > > +	struct page **src_pages;
> > > > >  	int ret = 0, max_order;
> > > > > -	long i;
> > > > > +	loff_t src_offset = 0;
> > > > > +	long i, src_npages;
> > > > >  
> > > > >  	lockdep_assert_held(&kvm->slots_lock);
> > > > >  
> > > > > @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > >  	if (!file)
> > > > >  		return -EFAULT;
> > > > >  
> > > > > +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > > > +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> > > > > +
> > > > > +	if (src) {
> > > > > +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> > > > > +
> > > > > +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> > > > > +		if (!src_pages)
> > > > > +			return -ENOMEM;
> > > > > +
> > > > > +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> > > > > +		if (ret < 0)
> > > > > +			return ret;
> > > > > +
> > > > > +		if (ret != src_npages)
> > > > > +			return -ENOMEM;
> > > > > +
> > > > > +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> > > > > +	}
> > > > > +
> > > > >  	filemap_invalidate_lock(file->f_mapping);
> > > > >  
> > > > > -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > > > >  	for (i = 0; i < npages; i += (1 << max_order)) {
> > > > >  		struct folio *folio;
> > > > >  		gfn_t gfn = start_gfn + i;
> > > > > @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > >  			max_order--;
> > > > >  		}
> > > > >  
> > > > > -		p = src ? src + i * PAGE_SIZE : NULL;
> > > > > -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > > > > +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> > > > > +				    src_offset, max_order, opaque);
> > > > Why src_offset is not 0 starting from the 2nd page?
> > > > 
> > > > >  		if (!ret)
> > > > >  			folio_mark_uptodate(folio);
> > > > >  
> > > > > @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > > > >  
> > > > >  	filemap_invalidate_unlock(file->f_mapping);
> > > > >  
> > > > > +	if (src) {
> > > > > +		long j;
> > > > > +
> > > > > +		for (j = 0; j < src_npages; j++)
> > > > > +			put_page(src_pages[j]);
> > > > > +		kfree(src_pages);
> > > > > +	}
> > > > > +
> > > > >  	return ret && !i ? ret : i;
> > > > >  }
> > > > >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > > > > -- 
> > > > > 2.25.1
> > > > > 

