Return-Path: <kvm+bounces-53530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2750B136E9
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 10:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07DA117784E
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 08:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D0D22A4F4;
	Mon, 28 Jul 2025 08:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZrG6HsA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F8B21E0BE;
	Mon, 28 Jul 2025 08:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753692189; cv=fail; b=qvcRn8eNueMb+aJGOgnX55jjEEte7SFys63nYR+Lsn/gSRxDCJypzCSl99/T5lMO2HvwdmgHR2PW76hiC2s1FQ9iS5/aD+5tF/mOwvLA4OQNwhjTopy74dICEYsscVo7WTAjkPrrErRJr14u0s20p9T4NCu74dDqnAfl4PVtJCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753692189; c=relaxed/simple;
	bh=vioQI0k6gYaQMi1gbPUOiHEC3CRD5oLzdacbSs22vYg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mEjWSexOeyMN0EAACNnynWLe/gY6Vy/L1M7WmesTZsM8fyZ8HiaV0h4K8xM0IY/n8DvI4E8E7XkPc5V3uoPH9amjf7MhHfzSLSsx+SXWbYDZn185dCPd1xVa3ZTciOy62UDaoajI9FCGxzXH0aXs2TZa99VvphKcJt8/VJtuIts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZrG6HsA; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753692188; x=1785228188;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vioQI0k6gYaQMi1gbPUOiHEC3CRD5oLzdacbSs22vYg=;
  b=dZrG6HsA9qT2tXsK0v1YD+v8fJkDNa73WrrOSaqQHLxfxP64RjDie4Yn
   3bUyn57ARXcD+MO2xD0/Uoq22+uifGzUyjISDEksXlrhAtO4PuhKjJF+C
   ebMSkK40optbn8GaCpN8E3iUnfJB7wDdSGCGutQJ/3ljRfExy1PPOGC8/
   RMwAiMXHVFRAHdp6zUuQ+7b5sXd90n0VZhX+OVd0481LetLuonuJf3SWF
   mZhJG1PUVKZU2OCxxKyLvlTvZ2Li60h7RNGcyp52Y/Mx3W8wg8moqTZVY
   0mI/pEgTvlrcMJLsVSnf/U72UnNX1aseWNQoBsDhYY/vti5+VqHyqEqIJ
   g==;
X-CSE-ConnectionGUID: 612+5iD4Qe+dw1xJ1fusBA==
X-CSE-MsgGUID: qLoEh2V/Tl+HN8qzpsu+TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="56081827"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56081827"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 01:43:07 -0700
X-CSE-ConnectionGUID: y2szX4OoTResYVhuQuutig==
X-CSE-MsgGUID: G3GCOpIHT4emQZ/zXmv2rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="193222542"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 01:43:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 01:43:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 28 Jul 2025 01:43:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 28 Jul 2025 01:43:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GQQg5hafVf7d/QzaLyal7Aj/OLlAm2AptIwKN4+hz9xv4r7xiL9Eb2RNoEHeuJGM5fBIFgEAvMDoeIitWaL6EOuKXvqOZq+ee7OzGE1O8h+TI93pMhb7uV3cHVBu1A8IDWOxhlwqLXvgkPKQlcr+rljUskUJ7rmeFvj0KvY/E13vScbR2f22Sp4koentjZ4zoatYca9KgVv4t2AL5WHae1MgBO907DuPquu8SVwDBZo0bOOWpN2c9nyMf72Lmx3+4JBLbKTP3049uLFDqPnPxYmR+3eSs6mzWIKuo6TdPgGprer1rlQLFA3lgdQ7jJ8lT/l1jAMP9ipwF78pw10NWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRtDhP1vokjDoIm7QQbX5HVCMQPZe9WTKyYl4vTcfL0=;
 b=XYYaYOxDYz7qPSIotuAHTKP+5uYRAH+QYOG8e8FfPOXFeZj5aZ/XjQ0WyozDK5qFeBgQw/JSmV1pQ1jr3+QJRJht804pYFCUhhf+lqtC3JTASaI/vBCDuqCuW74QV0ly23w81x5p5dI8wHsWGQS1QoxYmvnkJ1JOiALQoZBFWXjR1W9POz+0KG4Pi7ymvQUV1dsm4fH91YnCBCrorRSG33hWyfDkyjdacsA+EN/bU60q4e/wGwYdzfSb9be808LucM+/qdu2MIzNE8tQ4voG0qtYfNYGHkx0qlRHbX+Gb8s8GzPPaPlTh1kZ4J1YX97ppnKBM0Iyg5mLMObzfpsZug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB6495.namprd11.prod.outlook.com (2603:10b6:8:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 08:42:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 08:42:47 +0000
Date: Mon, 28 Jul 2025 16:42:35 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	<weijiang.yang@intel.com>, <minipli@grsecurity.net>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v11 21/23] KVM: nVMX: Enable CET support for nested guest
Message-ID: <aIc3+5Srw/QGWngL@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
 <20250704085027.182163-22-chao.gao@intel.com>
 <c3a54990-9cd6-4d8a-baa0-11b4e8d4a23b@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c3a54990-9cd6-4d8a-baa0-11b4e8d4a23b@zytor.com>
X-ClientProxiedBy: SI2P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: b6508812-8dd0-48cb-f1fa-08ddcdb2ba43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ls9V+lnibqwgm7BkGHp4PwXilTVnAp1qzkL6TN5b2xc5PcsgMiyvDTuzylIR?=
 =?us-ascii?Q?uKDRI/a5GJjUAQpkUrk5a6zxvTsqGZC6bxJpN4+kuE2+I3HybKwm/C10DorS?=
 =?us-ascii?Q?PK1Wu034hxX3XPvkk3m/08t6fsUcYBd5TEYjvtEEPR2lf2gZMHXEiR1FSnM9?=
 =?us-ascii?Q?VjHJku/qJmivVGSXJ5kugXgmO1jbzYy2Gt2YXqLOvB8Cam155BQZ1NmEniec?=
 =?us-ascii?Q?xjEffMTfIlkIBnwReTy+52CyTnmhaJrmfv0rbic9b5gyEgwUiz2TEh7Ogx3P?=
 =?us-ascii?Q?2E+3zJZmX0w2T+a/cv7wh7H4Bm41S2Adptz3/CvIUDrysEnwZK5Sa4RtJ1xG?=
 =?us-ascii?Q?1Ob5X2tZf8qhgFutEHxJUBS+SrZ5YcgigceGnrs0BeL4aDNto5GrikSx8W6O?=
 =?us-ascii?Q?ohkmhpaFEXYkAKb0z3C8rYRzz3X2iEPtAM3iVaP0johVllr8miLKp5ODWdPR?=
 =?us-ascii?Q?NmF/404HnAfuxX6jbAPURGl1r2RqnW//mrGp1Mc0TvahdVeWn7EgF3w67eOc?=
 =?us-ascii?Q?q5IuxSeKXb7hRtaElO44+NjIwEfdf/CF6pnByay7nyJTlCBYyfMo0sn1iL1h?=
 =?us-ascii?Q?IFU0XYX+rXvI9GPXCiHacF1kdDAKQ/rid6wAYmvqRjgv1aiHCRiOb5I0do/6?=
 =?us-ascii?Q?p4ac+I1S7b4nEeNX6Js+cHGrtWI3NZftxCK1Ln7LlE670/JTB6vuj3wCGisa?=
 =?us-ascii?Q?87QujOGFwGuJ9h7XK4L3pjjOOhZHfJFrTVJYsZS23TrsP9YUJvonMdfw6xtp?=
 =?us-ascii?Q?YlTj+m/0bAz6y7bt37FugW127AY2eVLdw2HZ6bBDbwUeHcP4HEvwNr+u3+IC?=
 =?us-ascii?Q?DG2CiKmH6+bSow964f3q5BwKKWNnN0Q+/bk2EGYbcsWmk767fP6gksY1W4IV?=
 =?us-ascii?Q?rx2/Gi9HvaogWjn1RWIBRXRKg7e9LPaCgoc5joT+WGgF929yTuuxSuw67HBQ?=
 =?us-ascii?Q?6lJ0sIhuKP21pp45fRATTH+R5koO3dVpUhu7kTqmVuyKM977RP2Q5IH8L+DM?=
 =?us-ascii?Q?vAB/+kjhfVSQOtQRgwHIjirWoY2l9kQv2J2NH3RjRxZsSycRkeF4pPzCZ7ux?=
 =?us-ascii?Q?7cO3u4EAGETlPlfYfk3/9gJ03MJOLwFJNs0OovTH6lp3eJxDc/0FTsBk9a9o?=
 =?us-ascii?Q?in/eblZ/7nJgLpQmfPFvb5IFwgLZ/jp2AHlQsQi0lpGk9N23UZgsiVGdVJhm?=
 =?us-ascii?Q?D0Hets+w80Z811AQGwk/Ih5Gy2VR9z1F0KbHx3I6kd+DYKmyD4G/lX5kLeuG?=
 =?us-ascii?Q?SHpglzOPWyUX307W8M+JCEMLfuOpr2RSKzyTkPegZKAsUutDHjB3/qrquctw?=
 =?us-ascii?Q?Ii/NcM+DDTMiYKDqBJTIgn0O05Z4v5E44z9fK5GnZg6TbsQqcDZ2usNxPmcf?=
 =?us-ascii?Q?YNHZk0QzMXHNwanjvVqLi4HRJMnSqXFeInoXvK9fw3BdxywjkEDMD84eYOtx?=
 =?us-ascii?Q?tGx7b21neMI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7Y+pgbMyGKNP374eVRb4Ow5NSJ8rvcmFCSaqyUnlp2R24NnuNcTfyYyAgByE?=
 =?us-ascii?Q?a1fHtjQAbXAziuiVwfcOCXX+jpAJnMsud+EAK5Hgql4PaSAyEqHfCR85d4pz?=
 =?us-ascii?Q?9j+tRJzmEG/+n6p8Z+X5ztq6hIU/vtn/UrsxVsvJr70H1A7UiYxAZGFcygTv?=
 =?us-ascii?Q?eCnhtOQiurJ5BOB7UvwiiTqPFAYIos5U2rZjKHFu5/6uf3hH04E7bOLkx2d/?=
 =?us-ascii?Q?OqDz/ES5K9xt0U/6qNKhgQ5SDFGRXMjmbQz1Hl3o4q3U3GW2+vJnRvPaK82W?=
 =?us-ascii?Q?lkAX++ZGOoRVvfMQkI4sDlde+uSVq7p//snn8+taC33e9CprxzxDVp4rXkWS?=
 =?us-ascii?Q?svLicpyPRImTFDPtMjim5/qoaLu2GBbI6kjaLpAstdS77uM8Vb2UKRX4ILqR?=
 =?us-ascii?Q?sizFslC97fBtGFKZ19D9O04Pz+yY+lOJv6sAS7bTzpDDq7OLsn1E4VmCC+Hy?=
 =?us-ascii?Q?VUJ/AJ+vPnKOJPIQeer7QbaLIOI0diTKYeaqTOBbgWZKSVQ6qfQbj9IrDUeu?=
 =?us-ascii?Q?f5glctQ2bCYmVQVJdOEPBn2nLy4dk9AbmqoWbhMo5lxa4KuRB6xQJnvtiO1h?=
 =?us-ascii?Q?luTXdHA4KLQ9wHqjZ5ZnHHUXgf34xbe5AE7lSHKVK5TjQBBHyJgZKGwj+csq?=
 =?us-ascii?Q?9cL1VjK6o9rFtZAFZyVbetaTPiZ+C9jAZ3rcPsJeFv9CyXhsePw8zaZD8pk9?=
 =?us-ascii?Q?aqWLxq+W1cKPMZMpT9vCmoNBlesVo4jXjXqseUmjBlHZCX4gjuRGA5u7tLpz?=
 =?us-ascii?Q?0QnTGs+bvW9TVOCcaTBR9bVRIW3HYfHMGn9lFqEeboBGstwSpVnX0gXc0Dd/?=
 =?us-ascii?Q?hg0uRwlLPWVaW83gTY5MyJXn0aUguMv0fb+6GtWWTXaCw6/yJn9Ewr6xrFOW?=
 =?us-ascii?Q?fLihkl0TUQb4Gz4GOrqWbpu8YBFNypIhpminMg4VcxbBpCHLOdF0O+Svfl6v?=
 =?us-ascii?Q?KS5yM14asgrPt8hnMwhu0GtK6XBXdDQdiKvv7XXE//mhy+iAZe16zcmVSRxI?=
 =?us-ascii?Q?VoJNHciKdxiO8MJyX1gLKQAJLo5TOofKl5wb+OqSnZG3g3lVMYhajnYNVt/h?=
 =?us-ascii?Q?MxEypX911rkmfRS+z9MnenMK3wECf6RO8z16CMaMxLNtdT0mzXoaDuZhJNUj?=
 =?us-ascii?Q?WXgmbdLbaKR52WNCl+m+3uZAJ1+irmwNi4A4AQQ2+fWKLwtYITWtdaRw94lm?=
 =?us-ascii?Q?UImzKRRZfya2zR1l3AyNRQ0CP4E+AWJWkvhWXGd8qKQnQLVWpOvy6IajR9oq?=
 =?us-ascii?Q?2VtwK92EluZHz1chG07d4vhekMcdo4c/bB2XKEGiJ+vifeEmLexNI2Pa5pnG?=
 =?us-ascii?Q?RpN7FUoB5TUDctzOtMAhgJbvwA1BGPjJHf5+n+eBspUmE/ZrCul2trdwj4AN?=
 =?us-ascii?Q?WjnEHyXrvBcijMmECgvcy+aQ1OKyq0ptMPJ9+I2cQpBJCMpE2Kz/cwWyGDH9?=
 =?us-ascii?Q?hXXoqlxZnYFaTs+7eBoJd6C49j7t1HsR0GRFPBtiU1DCd1GP2PWPXn0LEEFE?=
 =?us-ascii?Q?HioFp49d6qTBQiXN53LclZIZ88PFhn7yJzOXuLUA1EVfARzkrYWGm5vuhqBm?=
 =?us-ascii?Q?Jqi531iZWFG6lqwSZrfu0YwvIeau2cZlZxAijWDZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6508812-8dd0-48cb-f1fa-08ddcdb2ba43
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 08:42:47.2944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e87JL8iILFby+1Tfvz8c2W3/sYteSOvHkC2xbWnD0ekcT80XS8XeUP+nhKoZwCgl0cdZJnBEtVsa6Di42UfzRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6495
X-OriginatorOrg: intel.com

On Sun, Jul 27, 2025 at 11:30:28PM -0700, Xin Li wrote:
>> @@ -2515,6 +2537,30 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
>>   	}
>>   }
>> +static inline void cet_vmcs_fields_get(struct kvm_vcpu *vcpu, u64 *ssp,
>> +				       u64 *s_cet, u64 *ssp_tbl)
>> +{
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
>> +		*ssp = vmcs_readl(GUEST_SSP);
>> +		*ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +	}
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
>> +	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
>> +		*s_cet = vmcs_readl(GUEST_S_CET);
>> +}
>> +
>> +static inline void cet_vmcs_fields_set(struct kvm_vcpu *vcpu, u64 ssp,
>> +				       u64 s_cet, u64 ssp_tbl)
>> +{
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK)) {
>> +		vmcs_writel(GUEST_SSP, ssp);
>> +		vmcs_writel(GUEST_INTR_SSP_TABLE, ssp_tbl);
>> +	}
>> +	if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBT) ||
>> +	    guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK))
>> +		vmcs_writel(GUEST_S_CET, s_cet);
>> +}
>> +
>>   static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>>   {
>>   	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
>
>
>The order of the arguments is a bit of weird to me, I would move s_cet
>before ssp.  Then it is consistent with the order in
>https://lore.kernel.org/kvm/20250704085027.182163-13-chao.gao@intel.com/

Sure. I can reorder the arguments.

