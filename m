Return-Path: <kvm+bounces-46420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11522AB6324
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EF0D16E6DE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 710F943169;
	Wed, 14 May 2025 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C53qOTN8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E45202C34;
	Wed, 14 May 2025 06:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747204258; cv=fail; b=BcHl5gOoufrqNe6oIFXZtN2EUIF8BCRI6XrvbKfkGG2szW1KH64+dgSvjbEOOYSL7ELo4Sb7p10exFchgVFNUro6N+oXimjP35Q5CKMjoSC+76dbdUAqgBmU0EzsOKez4XP6HSBmOTkcREhcXdBED3CDBQHOze3fAlYFyseXslI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747204258; c=relaxed/simple;
	bh=SVOggS4MvCvCuzfcYwQVXwhFaK0tknD84DnIcmdpIK8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oqZKiK9/vON98O4G/BmKRD48KeDmtk5KC1UFzWgLg0ZIr9SqsrNwZlysQB7mWyySb/4S2MPQcVK+K5ZjWf/KjzBGl4za7vFOT5ZIziwnic+Wl5GsAKNA0Lbb1qEF7E95sh2bQXSLBtgHTPr+/eA1CKRj8hMOgnGm9JX9AYTot/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C53qOTN8; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747204256; x=1778740256;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SVOggS4MvCvCuzfcYwQVXwhFaK0tknD84DnIcmdpIK8=;
  b=C53qOTN810IEf2m+3vH8IFoPZ2ig7ooUoWbKzxqH8FCOF8B9LcDBxfHy
   T+TkRd/8479HKsgMRazbHavjd8C7WJWLNWM3wIsQh6WEaX6NRwRQiHwN7
   PLcGqYNVapJEvUMV6hD7iMg2X07doj4mFhlyEYItN9Yz/1/wZdVe79FO+
   oOunmPQA0JzwnCta4AtTQKMxhLZcUnXmfSw6ICJNeKSvIZebKmD1o5y/u
   FRgB6Z5hx5vXv8ytl2qH+QZPuMwid6Tu8dp6eVcXl3cv/IjVs9PsR5ay3
   RiDmESnWsNbd1gG21Xn/3//IRT5WUu0oYWLr9pGTlqFmr2InIzupfy/yh
   A==;
X-CSE-ConnectionGUID: 138MCUx+SBOoSLORNLHE1w==
X-CSE-MsgGUID: 5oc9nxC9TWa8zW6fkwH14A==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="71583743"
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="71583743"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:30:55 -0700
X-CSE-ConnectionGUID: DEEuOAcgSGi3UDEmPUFOoA==
X-CSE-MsgGUID: eZvYjfVQRiSvZVt/irtvLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,287,1739865600"; 
   d="scan'208";a="143142588"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 23:30:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 23:30:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 23:30:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 23:30:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+hZFe6s4MqgxDIFrdr/Q9wjiIF0lFGT4jKnvXY86z1fknOhUpcxjfQ9Ns745GdZDTWy82vw7VHauqkNyyqSUDVq/2DWynfyXkrYzWpgXATflM1fMVEOE58rlWi3D57tpwusgw/IHGHASFcZThWjbFXfZIxmxszEhf4+msksyKGCG3cfBe7yoqdZlgdeVAjYlASSuQMJt32TNuNDo6ZaouQngFnL03SUcvkTe01jzlJ+1ppJhYm/GutDArEBtajc31P2TJ43h+S5tovaXDuLyEw8Ygpdw5kBcCTy3X5v4ieJ0R0f8hQyJZ/EdMe9gb5TpOipUZ6/QmDY17UqeHwz0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mFZGz/lIWnbBVPMNRFToyR9o1NHOkGtMpkXI2q3dRFE=;
 b=Lyi+K3khYfaFgh3JXQCJexI0RD0qiXnsra7PXs59daPej8elOL8IACtpfAAHsEzD1Xt4VWjMimCmDFBQz0qwUZAFTWdOIQ/zY6iqNonK0FKN3JYg/nuHE1BYGhbpdrHJ0Sq46aCzzjeGZoHygI1lkqsp8oHB2tYnYLWaXLFFu4A7mxUIiCP1budl8BTr1KyXYt6nF4VDMGi+cUO41J4EeH0kvCLYAllwFmOtUyvCJpqr4OAZ07Lmp4ZqwrZK+k6ZmUxN/nvWFZ8JiHqht+LbPqTDalP2xZrxHlZj+lqVJmYxvXVg2yTDYiH85B78HxLfV/44N1VyW0JmtDYje7WNPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4937.namprd11.prod.outlook.com (2603:10b6:806:118::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Wed, 14 May
 2025 06:30:45 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Wed, 14 May 2025
 06:30:45 +0000
Date: Wed, 14 May 2025 14:30:34 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <yan.y.zhao@intel.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 09/12] KVM: TDX: Preallocate PAMT pages to be used
 in page fault path
Message-ID: <aCQ4imYKThyxOWuT@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
X-ClientProxiedBy: KL1PR01CA0003.apcprd01.prod.exchangelabs.com
 (2603:1096:820::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: f6cdef4d-7474-4b82-5bee-08dd92b0dbba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mrHS/5BZ1td+aFDOtY3+LSWvCqzgu6Sgue/0EV0M6kXdsvI4hiYBiJloMpMt?=
 =?us-ascii?Q?cIFfj+Wo9jwiLk59jK+egX/6oidI+BEMNUZGeP5LpNGwlSnr7Eq3HodAFeEA?=
 =?us-ascii?Q?Lz40yRjM6xvwnzB47lI5QmYZY04Tfpmw7gtzg0Pav/ATkKlD62KxHpXGYfNA?=
 =?us-ascii?Q?KoC2d5DCUWWxUqQ3p4TSJk57ZhWO9fwAdhxXMUBhHF/Sb2eRYnemcy7/v2HH?=
 =?us-ascii?Q?KkIwIujq+qo4b/lvQ+hh95sitkNUuw2viifyeBW7G80kB6yIJ6xppCECdM3v?=
 =?us-ascii?Q?dGjEwYgcmI8rHWC5q9Pbobk+5qtufdFb8uoXDmdnXTZKR+1G5abuwtXIMQzj?=
 =?us-ascii?Q?qPXSMiQRqVCt6mBvzSW6GQDI4hDe237hQQDVpT2p64qlvr1Glf2QVlwA3ZOG?=
 =?us-ascii?Q?QumgMIG3DGbwEP5qCBbeFEKMqO6IifdEt3KJW6EovvJkHC4Nh8HRSU2PaUvV?=
 =?us-ascii?Q?zcmb83+PH5yh5I6cqXkEQjZhGok8AXYBsqi8nSc6OP8hAiffBgSq0hTPqFHu?=
 =?us-ascii?Q?UM6x4p8/1fpMDxeH22gN7XKQiS36hBYbyGu/W8QObi88q8VU7+NDPl3/O/rE?=
 =?us-ascii?Q?prwAFzuV1FxvKEXE7biwJn4neah67iYoLIymQuvi7jUEeT5ksaxbTtpLmQxC?=
 =?us-ascii?Q?Jqz7bJKHzQtp9/Fu47MTgfkljoROnpFvQrnBp4ydaa4KIJp6e+uqY9ga00F4?=
 =?us-ascii?Q?t+QzLf6sHCNtsyewpDTM3uR6XqPupjK5D0hXXQC2P2Tbu6VfGsZJ8Tb4rcIn?=
 =?us-ascii?Q?4BPB7xT76pLcbPrj6ghWl/gySgHVUCISzOUmCGQU+i0ziulq4eWidqoxPS/V?=
 =?us-ascii?Q?qF15QGcYXnHob6FC7giMQcO7zT9kvcE5CJTpRpkcFPaGgjP4HOxdoaDr/lco?=
 =?us-ascii?Q?iZ53Q318FxlB6tMDdt86oJEhE4KnwZLPg3upqOy+x3NGvcRpB/k3gTajmyJk?=
 =?us-ascii?Q?gwK6v+kxH7JKRPN9jSGwpFarYazkSqJFkaQZZ94ZkBumdgziFTj8OhQ2V3Sm?=
 =?us-ascii?Q?pr6EcmociPc4xxnd5yvOj5ipFKLrizI7N8jgn6c96HCI6bM3t0cfghctEOfY?=
 =?us-ascii?Q?4qhD4sYuCwkU4s3BHoVSC7ZpgC82LxiMkgpNFs6wkZgwvXO68x4lQqjrXAO2?=
 =?us-ascii?Q?4O8RjX6bxrYBNjtZxsVjkRbXUK4SO7NBPDPyiznd3qMDz1ul7rs0KUkbVmpF?=
 =?us-ascii?Q?K7iAjPSKm0bxjLukFjbPc1d+oQhRZhjg1X1U+ynkd4Lg3B7bm4+Kfo20t9hl?=
 =?us-ascii?Q?o1nnIAWlpwOhpMzoZxGwN2hMnXI3Lv5u2wx1X/DNlZKrfbSNO8sBz9s381u9?=
 =?us-ascii?Q?ldBSTP0vArusYpPzZbf+n1zc551Ue9P+XSj9I9kUGqZdONnvhiShKqZxBhxM?=
 =?us-ascii?Q?Cty68bCrL0yy/PrKWVGSW3ZGW4gOcWt03YpdaEWBPGDQw7hbr+kQJZDdSAnJ?=
 =?us-ascii?Q?MBgztWnFCEk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/iZ72jQH8xYUzxAx9D/Eht9LZ9R1iZP2BOXR9bs2PE2MhP/mFwlHNAaAHSwq?=
 =?us-ascii?Q?WwgClvWKevCn2acpZIdA09ViYah6TtBiTrcxuXYTmnUvz31TsbmraJ0PA1lr?=
 =?us-ascii?Q?4Dl65odsteIVWsiCsAAZxJ+NUeJtf5OGbXPG7ct6HpxJq5xGbs9V0Q+BYtsG?=
 =?us-ascii?Q?XBo025e1f3q5cQXtr3YRRxXn7LpHCzN+mUyMAWV75sotlpyOdDDP8J+BndCF?=
 =?us-ascii?Q?VWTjAk9iMNZhZ+1d+hXmHxgKSdFbEwMtXpTvmlQ9QN650CHhPbRAkRTdoTHy?=
 =?us-ascii?Q?WoN664aq3Yd/06Ngq0eMfUPsILxx5vvI9DR0egwnL2eWBZv1L979uvNMDe85?=
 =?us-ascii?Q?P613LbTVsoyP3L0DO9NXcmc7Q+jZLno3DaDU6anhlXmMa2ceLye80DzHRN4o?=
 =?us-ascii?Q?2mt3GJ3y/WujuL5X1+nnlVSDdnT2oxMMRgHw6YYmSWsVG5PPIEOxBk31PSfk?=
 =?us-ascii?Q?yF/wCtjZPuRv9aZFxWsCIIkSCINk+xJnGsuSVHd4D7obfe8qIMheStU5JY8K?=
 =?us-ascii?Q?nO2Qs8lBEerP+oyFbGZuib3LQq8G5KOhWWcpO9asoKEdMFTp1nMDqGVN8chO?=
 =?us-ascii?Q?+nzp05wx53cl38bjnPuwsVg+GW36n1FGrLJQyCO9gTJc2zTcdsbI3VWPZc+G?=
 =?us-ascii?Q?nfYY0ZdTk50Av9PUL4LEN8F/ohXv+OKbhWHxGKWi8v9ocVg0no0yC5Np3LEK?=
 =?us-ascii?Q?S9+Ck79HFbLwzTPlFdI1IMGT4BDEPYXQz+jGx4DFBrOPMg1f9qedaqQpa/xD?=
 =?us-ascii?Q?7TTAHNhA/FkSYvncb0twlu0V02jCSP/MioOHiEZxBMqagpxr9fQ/wER8grSh?=
 =?us-ascii?Q?icO0ZHsRRDXiIbv/BDOmTEOBpfuMp6So93FWDxH5cBqa/hV5tBssJOK5TRkr?=
 =?us-ascii?Q?pFzVZ53+4DfwLu76CiFHXdykTV2HyxBRqgU4u5D3NlcCHr6Pmh2k4xtLJqAp?=
 =?us-ascii?Q?xiC+trdnQnkYKKB4w6kunJYdaIZNlAzvNqdwg+Frl5Xcppk8gXfwTxZ0thkM?=
 =?us-ascii?Q?fV3DjRfBg7h3L+5kB4UqPF8v6H0gB/6irRYz1MtiSE9f3zzlqmhBok2ZDhrS?=
 =?us-ascii?Q?uhqImxI6AOs+UPB0BTXOmzKcTjywhaZUe+Y8st+zBoKDtq/zev6Vpy0EEhpd?=
 =?us-ascii?Q?Va2UEFS4gKEi9n9K9CdAY7ujTNEW9DvmC0ahEftwcp1LKWmm5WYsgi0dHo6Z?=
 =?us-ascii?Q?xsp0fifNT9xchuloc2LDbGVv3gNa7VYbbBBV9J/rbrigU1Sef7EadaQ7f7TR?=
 =?us-ascii?Q?f/Ldo6AafxTCN15nw+Bo2fdRu/akNcppuxrreEhbrZkpNi73rA8HYaQsrrqj?=
 =?us-ascii?Q?YPMptBBR54WyQTOila9GpVmB0Wd1nHn3A0o9mK/Y1RxrvV1nL5cD8EVg9OoB?=
 =?us-ascii?Q?Koz1PdrzhomKq/7XLCPQupISXsxrwBOlk0biR/wU/k2p6hF2A8Y3ClbFX9L9?=
 =?us-ascii?Q?pL8VUxn41aibK8S8dp7r98p5wwtG1dK+nFvIRhZvWVIiH4JU6oDlk6t079KE?=
 =?us-ascii?Q?LUTvpcaaN8O1xEjDck3VAdVlklm37wsBy/H+VOo8XgDiGzlNjOlZruUNRvgb?=
 =?us-ascii?Q?17UnG8kSW3d9xOa8oyYGPucvBo04S1LF32HBnS9U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cdef4d-7474-4b82-5bee-08dd92b0dbba
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 06:30:45.6263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVS6o/rFH051BO6HYSpVSKOP2zmUTYT6rHM32bW67bZm7lbSJ8H6Rdb6h7rS77SRRnUnoKwf1LBxJ4gaMg4x2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4937
X-OriginatorOrg: intel.com

On Fri, May 02, 2025 at 04:08:25PM +0300, Kirill A. Shutemov wrote:
>Preallocate a page to be used in the link_external_spt() and
>set_external_spte() paths.
>
>In the worst-case scenario, handling a page fault might require a
>tdx_nr_pamt_pages() pages for each page table level.
>
>Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>---
> arch/x86/include/asm/kvm_host.h |  2 ++
> arch/x86/kvm/mmu/mmu.c          | 10 ++++++++++
> 2 files changed, 12 insertions(+)
>
>diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>index 91958c55f918..a5661499a176 100644
>--- a/arch/x86/include/asm/kvm_host.h
>+++ b/arch/x86/include/asm/kvm_host.h
>@@ -849,6 +849,8 @@ struct kvm_vcpu_arch {
> 	 */
> 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
> 
>+	struct kvm_mmu_memory_cache pamt_page_cache;
>+
> 	/*
> 	 * QEMU userspace and the guest each have their own FPU state.
> 	 * In vcpu_run, we switch between the user and guest FPU contexts.
>diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>index a284dce227a0..7bfa0dc50440 100644
>--- a/arch/x86/kvm/mmu/mmu.c
>+++ b/arch/x86/kvm/mmu/mmu.c
>@@ -616,6 +616,15 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> 		if (r)
> 			return r;
> 	}
>+
>+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM) {

The check for vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM is identical to
kvm_has_mirrored_tdp() a few lines above.

>+		int nr = tdx_nr_pamt_pages(tdx_get_sysinfo());

Since you're already accessing tdx_sysinfo, you can check if dynamic PAMT is
enabled and allocate the pamt page cache accordingly.

>+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.pamt_page_cache,
>+					       nr * PT64_ROOT_MAX_LEVEL);
>+		if (r)
>+			return r;
>+	}
>+
> 	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> 					  PT64_ROOT_MAX_LEVEL);
> }
>@@ -626,6 +635,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
>+	kvm_mmu_free_memory_cache(&vcpu->arch.pamt_page_cache);
> 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> }
> 
>-- 
>2.47.2
>

