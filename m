Return-Path: <kvm+bounces-52925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CE8B0AA0C
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 20:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE0B1166189
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 18:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA212E6D09;
	Fri, 18 Jul 2025 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CgpTzy/f"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415691946BC
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752862583; cv=fail; b=csJ6wHyF55d38bRGhLCyfUbC7LgamfBnJffNFdLKtbMDrTrHxsEpRW7DWYQtSmYh6RrGdrCJJ1FLxsSp0DbjV0uMcv1PJLN+fyWvk4tr9FM5eeCcC/7U5zG/mUEIlVhhJhBbJF0wDhFgNENLZvARVJQLmtQApPKNOYJkBgriPa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752862583; c=relaxed/simple;
	bh=UKZmDwTz4dsyMZrr84deQZpeTympT2e1aVZ+w8YEdPM=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jWpYaRp1I5qcvToS+YTqRmVm0TM/s2wkBdsmkw9PSs5Z/FWRNnyusqj4cFJaHe3Gbg4MEYER/ASPgeYKJoQ0lAAbtj+roSqZZrArpKuZdPR9QsrsBJl9sppk57s9j7ujjuMnGfV7KP0MKcIB1ShQJkl7ptNbM9eU/OSwwGURptE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CgpTzy/f; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752862582; x=1784398582;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=UKZmDwTz4dsyMZrr84deQZpeTympT2e1aVZ+w8YEdPM=;
  b=CgpTzy/f7BXZ0zEuOUDMX0cudQpP3Q+BPgs3B/yrGxyLQiQiKMerPrHJ
   BvS5bLEu6EwV30iqE8hKMVeK2aD2w7i302v1JqyrkxDiJoe5UQ6bSV6kO
   X5EOdWE5+hBznZ5QgmK7Iu1CSWQE6GSn4GCRSz7we2FfGFcFi+69rXaMV
   k7I+kMxgraTjm2ByMuckzasIFN/9FM5qwlMFFN6/qh+RVcSzWW5eP0D2K
   ILS4g8qJAsTbggOp0rq9h3fpooEnhhYmLex+gbP/ww1FRaKv6vdj8DF0I
   DYgVaAUmrpmtwctGtBM2Wf79irDT6pe7P5H9/NufzQcg5qAk7vMnyTPPd
   w==;
X-CSE-ConnectionGUID: 5hilfhCjR0+UNuOu2O/8WQ==
X-CSE-MsgGUID: MzePoBfIQc6A5ZZ5KZyJ8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11496"; a="54374283"
X-IronPort-AV: E=Sophos;i="6.16,322,1744095600"; 
   d="scan'208";a="54374283"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 11:16:21 -0700
X-CSE-ConnectionGUID: qy+crMyTT+eU8vSayFnSSg==
X-CSE-MsgGUID: qnuN7jG9Sf+LHoGLwt/cLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,322,1744095600"; 
   d="scan'208";a="162150444"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2025 11:16:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 11:16:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 18 Jul 2025 11:16:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.58)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 18 Jul 2025 11:16:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WUxLylMSRk7Fav7h7P4RmF5UolEflo4xUTDhRlX+H+XrbHH1V50NvhDDzql6GTzD2bC+AtQqQa7Sg7Ys7t1VoJVfJ3GAoOrcfSNtkl9ZA1wxcRKAn/bzCGj9AGbb8Nzsbg1+tdozHAudyGsSCSqunGv+8AR8XaMOkUzeQh8fqH1BLGjT15kA9mDBq5moFLmAhAXgUiexIKgXhV2D3YA+K4NX7o/ddC+LOqhP2C6ZOmYTCbb6mgI4/jDXTGavHLUcLNO8pcOAFYz2JNkxuY3xM+91j/uz6bO3e196r0pSNK1ZUMvJpNflDOk+EIAVRX+LdZjdy6cAF5Ml1CO0f2YtrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g+HubKRhOKM+MpFNUyjG2fAv5Ja1NzvjPeuhkjn3es=;
 b=mgnVzEM10L38A/TeDRSP/EEneIOEPDwUDvgyZbjZxQWfJ83avtZrzqzuMHckuhETF41BtyJPGu43t8ER7ybhw8ISpoolRwZxrnwSFAFcRbAH7LJjgejdAhKrh5T+Ag9D+U0iJtRvOrRVrpID6MaqTycCfA4R/cKnWKvoLvJQcPgEl3baI337a8GjWwMKHuNmQbdEDx1+M6bhTwLumv9RG6t2jtw0f9tt7ZIDRCvh5eignfbwduJUfZnnpEq24SDMRxIJb3G/PljwM/Xru8PAfiuRRf7fohg5YC2I512LK0PysMKHAYVpvY6JVaDCXRr9odU6T0ooVRSpfx8LaE2L5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by IA1PR11MB7680.namprd11.prod.outlook.com
 (2603:10b6:208:3fb::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Fri, 18 Jul
 2025 18:16:17 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%5]) with mapi id 15.20.8835.018; Fri, 18 Jul 2025
 18:16:17 +0000
Date: Fri, 18 Jul 2025 13:17:55 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-07-17
Message-ID: <687a8fd38e118_3c6f1d29415@iweiny-mobl.notmuch>
References: <044a8f63-32d9-4c6f-ae3f-79072062d076@redhat.com>
 <687975b253bbf_3c282b2941@iweiny-mobl.notmuch>
 <eb6afc50-10e1-4326-95a6-6415f407c887@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eb6afc50-10e1-4326-95a6-6415f407c887@redhat.com>
X-ClientProxiedBy: MW3PR06CA0001.namprd06.prod.outlook.com
 (2603:10b6:303:2a::6) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|IA1PR11MB7680:EE_
X-MS-Office365-Filtering-Correlation-Id: 98894625-0372-48ad-7050-08ddc627308f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2hSa/0/GkcnP32KVNfQoWaVjA8Zl2vnMoi/PQDclFZT34LcWJocTsfpiHjPc?=
 =?us-ascii?Q?bm9P67qZLqtJaa5roVasnMAcP+RbR9pMm4CYPBmXmjtkU2Cb13ibHrJ0DWCc?=
 =?us-ascii?Q?+xCR3oEK+gKbXsVMv/jLQrHUNLI2LO7lb8TNye1tsAJJqAhtjJd3lp1Bjrfd?=
 =?us-ascii?Q?OjjQ7WKM3VsI5TKwIIcq00CaBuFFMRgOd3VdLFLZQhOcuxR9fJ1LwTXDr2Tx?=
 =?us-ascii?Q?EGNKicDVcvDBGGQXez8ZbfpU+SGbhRopMd9Xf2kurfXBcEqRB5HTYpb/54vZ?=
 =?us-ascii?Q?4Z3fIedAvqaGTnkWDYZ18+mH9ZTe1LbW533P3jVAcYe6mXbGHfoGzV+oU0es?=
 =?us-ascii?Q?SVFm+dcBOBbnmjVrlyWNWJISwhHo8pwjOKET14PnX0Sj8wI/pOi+UAFrw1Hd?=
 =?us-ascii?Q?xF8BTo9Sl8d3ErSYJET6BYpjia09VlIzBtDGfEn0Svhlp7wxLnSlDfNh/Iyg?=
 =?us-ascii?Q?sCTzMAfAHsn24ie7WJ2GtCwUjosy+xH3uG+yHvZ1mUK0D2GxfiEo/QNAR/Rf?=
 =?us-ascii?Q?gwh1Q6lCJJUU7Kj3Gstl/P6YAh9Dm+R3IA/RCeBXKmpynzLIjp7bAbivTKr4?=
 =?us-ascii?Q?h6CaidvufDso8qatRHcsP/3rpuwNxQkQIgqqGMrrV50DEUByTf6h6O479Kf/?=
 =?us-ascii?Q?l5bWFEnsdRmistg3u2Q6LFFpBFQBhKHuUlfUkhvdGdYeFowFJWn7l3B0vi8P?=
 =?us-ascii?Q?Hh15TkmCyvDBiJRQ3P0FJvebWxofW0JpnaQwOsPv48xrXdfUwlhvm7mXvXaU?=
 =?us-ascii?Q?BbddGGGsATAIGa1n7X3VRty73h6QrASFbC6aiT5yQN07CspuQiSL7e83iivk?=
 =?us-ascii?Q?YodvClAjkaxsMcsuIlPsocMJyhc+gyK3htrHReOdCHZGgAyC8/8e6oh5vElJ?=
 =?us-ascii?Q?xp+HrL1d3L/veL0484jZGOK7AZeBrcYN5lAkBiFa/oxLTzzH92gkNJ6YRmBA?=
 =?us-ascii?Q?7FSEJw3d1igJipRIcAxR1NsJxywVdqAA+tR+kOoGq3HMArb3Ufj3vTi8Ecjh?=
 =?us-ascii?Q?6WHZsvRKbG0tIjSN9j82x3o73MOSiFeXkc0EFxrowt1IWPiPJ068iBTnrY3j?=
 =?us-ascii?Q?xJMGJ1YQYo+HwO/aOWnIc5o4dzXA1KspwScDMKrKyJxuEtFU/KrgRv4zUWrV?=
 =?us-ascii?Q?9L5thLkSZOhq6KczWRS2OUNh+dzIK83sPyd3Mrkn7nlX1Koa+37c5+vMSmdJ?=
 =?us-ascii?Q?jzOG4Mv9K8bfkusW5Irh3IFAH3QNH5oQJEe65Uf7jh4ZuUuYiI3Zk1NIsqDN?=
 =?us-ascii?Q?0X8nDHo0p248KuOXkbba53RW4t9jtxrGSTaVLWK/gMvJigGYLqalh2F9rjM9?=
 =?us-ascii?Q?bsYwzm/bITK1N3/FGYqL2QEpVBe8DI1hydGm9T05XPuvJbFSWKOuwQ8Rq44O?=
 =?us-ascii?Q?sCLPmPBWWGle8vSfDzVJq/rqig8pJI6mvJxFhIY0Q8FfLkpkiw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gNinweYMoOSnYD0oj60fCLPQzzXKy09QYUgb6B3ekXTKy6TfYpL/30MhUQqx?=
 =?us-ascii?Q?XgEL1To9CHrH5wzO8p9cnlKuyCd6Da3nUhs2oADkyjM4aqiMPfd7aRZFVOWs?=
 =?us-ascii?Q?5CywOufLZaQXzY4XFcxdbbM5A/ZUmnsSe/BFiyHNoD83+2ah6OnuUzUQw217?=
 =?us-ascii?Q?4nLQ8MuablwrwvuTRgGeiAnQJOZiOXaSYElRLBQWZrBBBepZQ1jtdwmh9aEV?=
 =?us-ascii?Q?IbAZWqMjrxdbObR6qyzNOO5ijzl8A6cKi4RtHzAeOsMNTLl+9/3I6wcgxPLA?=
 =?us-ascii?Q?q9euB3UbWsQQxmBboqh0ZbbxeQS9cj5ZU7FVPfSiiV14akXWiBFa8Yn+cMMB?=
 =?us-ascii?Q?rUvxMGixNeo5VWkMD41U6sw+pv7o7/eTOe6YiOFRM2eVU+b5EqvyyW5HLzwN?=
 =?us-ascii?Q?yVO+80qlhTS46DYnuVKT6LUUugyU21c3JQmgb3Ew+k9pCF6cI7VOdllnCe6/?=
 =?us-ascii?Q?XbDwmKZlAvWRjqZTD20k5jsBKZ1Zb8u6m3vrrKohngBWCVWn0Kn9tUaMTcGt?=
 =?us-ascii?Q?bNMlx2/dXYcCObXhwsFDyyJQ8V9dtiFJJKG60tbl/kx42NkYhMhhmaFHmEAw?=
 =?us-ascii?Q?nmW+vmStAoWGEGXPWPO93wAqdiShcD+MMfeMhcl38Dju/d9fuhvFKyHwWHmn?=
 =?us-ascii?Q?xGLG8lvxnnWpK2yMVGOJWHK+Oyx70j1yPQg8fkBOanzq0yX3cDkxNi9yw2n+?=
 =?us-ascii?Q?L2im9+eyLc58PFmSy8sRmB+h+QGa1UxjQiqBSaMKynZCjD5/UKjTL7he1Q7O?=
 =?us-ascii?Q?wOaaZsfXYLjBhHttRJdPo2k1aN69hJNdH8eXHgp3NzMCWwEzuuoXWwXgmA8w?=
 =?us-ascii?Q?bXr+AjUZW0Zfc3rjz4Rwvt2BJ8hgJwIGXdiAvQbayp3TKfjVmr4wTvhnO38p?=
 =?us-ascii?Q?Gr1r2QwPrdzdrNL9cC2z3hd+05/npPZYIVdL2aC7hHbJof9rM40fnSlY9kDk?=
 =?us-ascii?Q?b3BJ/MGyAFjIAf2IKH+kK5AAVvz7UY2z+ngZMa6yknDgl9LNr5r1V2prJCkO?=
 =?us-ascii?Q?Kxx8H5oJiftbkIw9C57xxTxTXq0LdKzP55DYUeeeQJWt0YapAXhBpG+SWlCf?=
 =?us-ascii?Q?T13p6DALzzAyZigJr3xcy01l8h2Yr69STG+2KLD6EtLMg2EdcIu4yu9YQmDU?=
 =?us-ascii?Q?XTcGldjwewKSw+eRiv6y/HNdXzvYTE7uV4jcQFwrwvfiQblCmnzTifdA2eIA?=
 =?us-ascii?Q?1wn1VnYU76R5PKH8+TjBXSJgeG5ADJ7eMaw2/rloFs9DK/kgQfqQe9iOyc9L?=
 =?us-ascii?Q?07PU7GIzZOh6gQt8xiSXobR/YQyf2+uzpqgX7pXuqKEmZ2MZkSu5o9vnRCRb?=
 =?us-ascii?Q?wFrx1r1Qtw+PEudtKBb1byaWO3aVnbr5K3joi5l6Gsf6n0PP6NZ9ctJibE21?=
 =?us-ascii?Q?I56l9Ini4BuXq7TgahipS4MCctZ5xDNAMk7T806TDpm0raoVRzTcRcJj+vPy?=
 =?us-ascii?Q?AovJsw7HvOp1iH+Df+QK+z5QxDso5hc+6pu4S4BS8DL/2P5kxPwPGH+iJYAi?=
 =?us-ascii?Q?/9D/TBd3dX/AKQncuDKY5uAogQorclPIY+ZvQ2vSB7l/RoP/OtyNzVXwO34s?=
 =?us-ascii?Q?vuhhegOmo1ukJTmTSb4uE1sXFDZD+ddjU/KolR9y?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98894625-0372-48ad-7050-08ddc627308f
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 18:16:17.8861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T54/UNxdRGldRz+C3uSjulNKnfUPsluVr1Vnb/Ig9Ff8pg/iziIlSQx1ZtLqphZpkenQZsKG7yCREzzpGqEl8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7680
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> On 18.07.25 00:14, Ira Weiny wrote:
> > David Hildenbrand wrote:
> >> Hi everybody,
> >>
> >> I had to move the meeting by one week -- I'll be out the next two days
> >> -- and decided to send the invite out already to highlight that :)
> >>
> >> So, our next guest_memfd upstream call is scheduled for next week,
> >> Thursday, 2025-07-17 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
> > 
> > Did I hear correctly?  I thought I heard you mentioned that we are meeting
> > again in a week?  So was today, 7/17, a one off shift of the bi-weekly call?
> > 
> > Or do we now meet 2 weeks from today?
> 
> So, the plan was to only move a single meeting (last week to this week) 
> and to continue next week with the ordinary schedule.
> 
> So I am planning on sending out an invite next week for the meeting next 
> week (July 24).

That works!  Thanks for the clarification,
Ira

