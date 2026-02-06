Return-Path: <kvm+bounces-70402-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DvgGvBShWmV/wMAu9opvQ
	(envelope-from <kvm+bounces-70402-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:33:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC1CF9586
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F1B493006828
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 02:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D2D261B6D;
	Fri,  6 Feb 2026 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GdWW7CU2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B731C239099;
	Fri,  6 Feb 2026 02:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770345191; cv=fail; b=NXRqYOlZpV/VawEOt6U2cm/ME37epW3X/tIXohWKU1/ZyEPY3s8OKiK7j358w0jC5IMAtam1ew2o00RhikNe2LnOeXr9JUEoThMShGoq4f/MZhrLDkfZH6Cop1DtRM6/ZYfHThcLMyMESdWo66lWfYAw2tSV5qHAS2tq92afJss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770345191; c=relaxed/simple;
	bh=lb2pyMXIs1/sFT5pRpNApJ+oovCyBrACqn06Il/RgcA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ihxkQvRI0I25eMxeZtmDIwnhDVqu7fMRvPlr4wsfa7PBjM7G30qwvxsvtP3VbZgjIgFDck+yLUkP+lUmf0DGcmtOmD+FRQbAgBizqG6ui4T+q3B7A2ynQEKvlogA7YRrmtcdTdgi2K4CNIhKaFw5IVMyrOEzcZnvw7hw38Q5wBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GdWW7CU2; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770345192; x=1801881192;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lb2pyMXIs1/sFT5pRpNApJ+oovCyBrACqn06Il/RgcA=;
  b=GdWW7CU2TvSgD0PJlpFlHPSUANoEyOYBvUbZN9T45x+GjTtIwJd/9KX2
   mhPrWrTgfez4vXkOUSnIeXLjxMrXyj1zW6+FP5IISlxkOE8baCCE/EVv4
   tdA7bIDQILC1x1jdEIm/KKuU4lhdbymt+g2evewzDVurv649lodGNjbjo
   gYRKT1+0D3LZLs1rgxz0uaxFmxrlTqOOIXhbBaEXJJNNhWN7iIWUcFoDV
   KXkrRxFpm86vhX10v0VpOPQb7m3qBT/5AzvWEvfHwAtzUbWTrQfkECug9
   TMCnoT9Bp3xoJcGctd/ShhJZObvn3MkyG54ey2Mmoxr98+kQ+AI452CdI
   A==;
X-CSE-ConnectionGUID: uts5wf3ETcesSsHUTSpgyg==
X-CSE-MsgGUID: HGp1/4U5QjCeYiTp03RLzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71547155"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="71547155"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:33:12 -0800
X-CSE-ConnectionGUID: rhf0KgYwTAuxOdVMH3d3bg==
X-CSE-MsgGUID: MDHvZ/KeQIKFITCxcuUl4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="209831664"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:33:11 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:33:10 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 18:33:10 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.49) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:33:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rPm25pJaHekJPH4aJfH0Ym3+Tgk5QPE+WcPLFnibDx5GoHXgMabm+XIbZ02iXCDsfk3SxOOPNrP+2sOwUY9N3jgD5PGVpzbEhGiCodwSU/WtVmVNCbBZIAZA0UORjbSFwU2QRBc+2QDh1F1JwxkJsf9N9DXt7br2CNOSYf+7FCik+jrx3bR3e8sMTqFXJIHGvcG3+VMTuBRdNleUpB4fipsuKOiVFDjwc1QG3u6lNw900B/g8YLFG8Gw7FRFiTg8MUOBU14FUL6XLASnkcc6p4SOOtdMzEW5gEMnIf4sWU7FGlvlJsJ3Lt+rIc5MI3TDChHXfOFWIr35b7NBMifeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEEuyUkG/LE9zptWhU3lALDzIMPoH4P1oB6DqcUDQv8=;
 b=PMi0ZFsXfrbcmHHjb6uDc+8aYpgCpSrRgfluMspnQW0EisV6LzAtX+kzOwDPEc4EXCIgNPC1/zxbGHvMfFERdfsD6YjOwnk8MZXYDrEjnX2phqXGa3LFwylpv0NPTsRvQwR65k4lous8ZooWeryOi1Zi+b7Ud6cHD/9/ykQVHcxP9vCs1IvVtrzj2sZKTbVhOrMFKqetBZUFHxi0iGQWEryfR0kLHfoo1JMcmBO45kxl/aU1UQHbebGmQLDdzCdu4cYlkM2mM3plKwZDjNWZSIX6N68eqFSGWwYuqE7K5i640x9OVExHpigAnw6Xedz0M/dFxQZyNeqktj2/lCuT3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Fri, 6 Feb 2026 02:33:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 02:32:59 +0000
Date: Fri, 6 Feb 2026 10:30:36 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 09/45] KVM: x86: Rework .free_external_spt() into
 .reclaim_external_sp()
Message-ID: <aYVSTAOLNgGhZaKP@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-10-seanjc@google.com>
 <aYMVEX5OO22/Y72/@yzhao56-desk.sh.intel.com>
 <aYRBE1tICOiQ/RL0@yzhao56-desk.sh.intel.com>
 <aYUb0KvJynvYjr3h@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYUb0KvJynvYjr3h@google.com>
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: a9882bb1-6d29-4c21-bc45-08de65280b0b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iF/O1UpS3YI+YaRjPDRLvOllMTtyzLDQ5dAQ6dNQHoDgBOXnB5F2kIZUFwAg?=
 =?us-ascii?Q?VVXnK36faAKMw986/CZI9HbgLLtT1if6Df7jlXzg3fTbTSAL33w6bQ/G/aLA?=
 =?us-ascii?Q?P4yQMnU+9AjXID99Lxp5/ivSNlvcXHv6EHIydRlt6XHdoKts1akmaoGUDBVS?=
 =?us-ascii?Q?XLVEusPv3ngR9IPLaMIDZrWN1YMPN8pQRi3mvlL7NLgJe6aUelfWhUQLvMwz?=
 =?us-ascii?Q?cflSKKY2ahnwVHTfUroHWL/8bSRm801lkbqTCNDZwpRBZNBalGbyfU9hlkZO?=
 =?us-ascii?Q?A4oRK6MmeQDTSLPmF4w5DIbh8gGly5DQ3SrV4+HHSEX4k7HSY6MgnYfIOyzc?=
 =?us-ascii?Q?WIs5ZyZz4oa4/FJgLX72cJlZlLCMN1Zl5lKIyhVKZexD0OlYPBNaAFWISifh?=
 =?us-ascii?Q?JkGkISVlEL0uN72guPFEmRHMwBUCcsTphFju0848jJNyJG8PGaGOUMe+G5Xi?=
 =?us-ascii?Q?DButeRlH7kHc4ilgQuGRYiuTW7sX3O2mAxT1iT+fiuWcrJAwilw4nXko3oi/?=
 =?us-ascii?Q?O064U/at3Cae3UrVvfJ47XlOdSD5kf/oOeJlrGRin9JmQXKkP0Bf78m+YEEL?=
 =?us-ascii?Q?lk6qSLHW23YgRHmdx3BpuKyldfpMY7zhAKKSwy7Kn1euEWpCs+5ut2imH89P?=
 =?us-ascii?Q?J79PNsa4wHXvmWdfBS+c8vrg2/f2PdGSIxX93XbbAydugxnsxpgRH/h2Qt6o?=
 =?us-ascii?Q?Rs0GVls6q9uGa2dykqvHvNuONniloRxWfTMzuFfJUks8tqA69jaz5FwWy6hk?=
 =?us-ascii?Q?5MY7B5vRdRC9Tw8SOnyM3nRMq3oMy/AI/FF3AAlaCNEUgiUTfdCLSctsg1UB?=
 =?us-ascii?Q?qc1QGyTnh+QPV4fxu4bZzMmFJDtMDCgjurhwCEupQLKS02zkIbPYD2qfHk1n?=
 =?us-ascii?Q?UJcjEtVWBgm2U2ErRKm5luTZA1Z6mJ9NvF7HYqQonHFhgUsIdPZp9Kcs6AzU?=
 =?us-ascii?Q?9YBAHAQ7/FmTMDQm/tDcWsoJXT3O3z2emdexWLmWbICPUA5d6chgbHYzPqqd?=
 =?us-ascii?Q?QAkKYD+LkMSIg1bp69jXGdoyMEfldoDzcujAholJsTeOiYae7ThS8RQGpkRY?=
 =?us-ascii?Q?yrmD4wq/i8zkiV/Ljk2viEuznjop+j7HuXxZX2bm6PW0ud1QuIW3k95idgdx?=
 =?us-ascii?Q?2vCXjSK8N62G+sBWV/DdN0amsISm7iHYt72MogqIh/eI+jlhvKnSMuUxu26p?=
 =?us-ascii?Q?Z5jPbQ18ScWrYWjvYFniIEKdr0CGytkEGTXZi3ZpOZZux5bbc0KJMEtDhOay?=
 =?us-ascii?Q?s4jkX8PVTX0rByWdURi79jAw2eqEmpS9ypLsDnOFyu9xe8XkvOPfwcd1X9KI?=
 =?us-ascii?Q?o0BlLpcVMXuHfYY4Okt7evn6L8aDyFLzf93EGuszaRiO/Wrhf5P3gntsjVUY?=
 =?us-ascii?Q?NztqDyvyL+yIWuBGdt0E/L5KU+sw3YZ5hHiR2NRCYMLk//5X4NSDKQF8U23Q?=
 =?us-ascii?Q?/TaWnZv9pLSZZxWr8q1V8wBQgaQUVdB+kvRmsZ+E63Sna3ZeZfxqBl1b9NdQ?=
 =?us-ascii?Q?VnGNUz3k5FKkb3vhRCoOMF0IDtj22eT0rqOx2nObokL18vwNHdXu5wkvWrHQ?=
 =?us-ascii?Q?uLhn8jb0cxhIPXL/L8Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wr8GUGfL/wXvODJfMH/6IGS+l58WxKRcrHocsm9zltfNlEefiDjJhd1a3nPS?=
 =?us-ascii?Q?Ee+jq04KQ2SEqsZRRJJZ2QuCHclow1wuXlGLhqyka1MMPGmujIkAC2/XixJ9?=
 =?us-ascii?Q?nC/GI57jjGOXqH5iiCB/rBxUkNS9peMhLTy+pz7nk5TATBZHhJd1mU0DziYI?=
 =?us-ascii?Q?W7isZvvZ5KF+704j3NaAvAbiF5AMnK7bXbyQErHFuI1wRqJfJYxd8lf2g1cL?=
 =?us-ascii?Q?4OjEb/xNUWjWB3wN4CO52FU5o5PVSvlhPurcEmKQkSpAmCT5cbCjZ+BRaezi?=
 =?us-ascii?Q?0ocfboqmqIWgah7qQoUdRYJ0XiIu3QT8T2tz5NCj52zF2faxg4TVTgI6oVWn?=
 =?us-ascii?Q?XUOlbiDpoZPj0ZArIwRd5qKyu9xF/H3w2XftuBBIGAWxvsacgdA7wNj4cHcs?=
 =?us-ascii?Q?7vRSkqxBurw/SADWoApT14WevDAXInjl8kPngTqJPR5vHoG5xR8iiyjCTcya?=
 =?us-ascii?Q?ESaOKDp1zl6qFHN7un9TlxaS9k6Q0DZgfvTRsHKfrpbVD7YV6SZtNblmM3jv?=
 =?us-ascii?Q?3g2TXrHKZUgD310kNvvxES3LAkDP6OMiynOxRcS6AoaD+X6/pu0jVUmgmDMR?=
 =?us-ascii?Q?wPlfsziyEBd/HMrvtOglFPJD3mULExnjsqA5S98P6FYiy2rRcGLQmmhqYdDk?=
 =?us-ascii?Q?TqapRknuPC2ch85YxRnEixJJSO01sUc5mtpdCeATXpk4QQ+TQ3Od3rs6xZoG?=
 =?us-ascii?Q?tOOOcGJzDo5TW8L1W8TWRjqWRyNA5aqItQ5/6pD0ml3zMwRy0/UUhaxg0rBo?=
 =?us-ascii?Q?+sOUpHLfNuH9CInrwS9sbPHlvx/Fw4IMhBVWL+dImccUnZkxqLh3y0p/iJs2?=
 =?us-ascii?Q?Q4lDY6LdU2AiA9mw2VqvbzePiNXVQevFrOdVp9GinQMuxp9isc7TV2OzSXWI?=
 =?us-ascii?Q?nA810H8N1eJYcWgOETrJHeJfYUP7YjMcSjeKyqRuAJSLiOtoECE4QeeYL8Sw?=
 =?us-ascii?Q?7LC1VpRDWKCh1lGaBftrr2d3r4lBzhOCO+b212DWqdSQScDgnF4BIuiA9BNE?=
 =?us-ascii?Q?C5NklG+xgvi+BwDmGtK7JWMQdYh3mJS4qMlx7k6PPbnvv9ts5D4EuWRxhFGt?=
 =?us-ascii?Q?chTd09gpQUS2S3A5rxyZfW34lRYy21l0ourslyA/6jbUcKagZFJ93nL6m8e1?=
 =?us-ascii?Q?hOiCs+mP9JyU4oBBGVZSbtWyfWY3plmRoa1j21wN50blZp69a1P0RBV3ELH7?=
 =?us-ascii?Q?FvJsH+orXHC6nWGP45+ekbLxjW0l9CsiK9aNPUnaSnYqvaQv1hD0QngEgE42?=
 =?us-ascii?Q?L1zxpukKZoBIr06c6lVja5t1Ruxn6LJKubVncP0wMt51fasfLr49o/oONdst?=
 =?us-ascii?Q?beVT3gmsTgsIxY7wexqExiHCfx/zS3cHDD6sKFv8//vSPHWqSQpoGxE5SyEG?=
 =?us-ascii?Q?99kiVfyn63LPD9Ak0T3KGtZ067U1VWnYAoDhiQjWaYvNDQhAVlD/DjhvF/H8?=
 =?us-ascii?Q?Q7xTFWcYKaMk9BvFvMGjg5f4UOV7a9ZyVD1YL7/ro/TYFlunYTJ/1qtC2Bop?=
 =?us-ascii?Q?sTd2+hkMXEvlgiKOnp+QMkagH061sywd77t6vYyiTx5Uy0c2hdI/Dfv8BibM?=
 =?us-ascii?Q?Mb5rgLaV73LMj+TIqro0u2885BwYQOJbpWsSMx1y9d63mdXrNxsFw590FWI7?=
 =?us-ascii?Q?wXAGmoqBbat2ixG1OCJcyE2secpWMQkOuRs0pn52o6qTpg7Uxt+2Yr+GWuLW?=
 =?us-ascii?Q?Z9Pe8SDFsAMrpHm9fYWEhCnl3F9EnTRHYZor22ODplpOlLiG7YKoIsi+i03p?=
 =?us-ascii?Q?19VMlbRQ1g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9882bb1-6d29-4c21-bc45-08de65280b0b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 02:32:59.2462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CcEY0K8AvZCkRZY2yqnoyVstdzbjctk11LCAGgm7D9Eta56ylziDpDq8wepTZ73WsDoMA8c+ibeX36XJqrnr2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70402-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 1FC1CF9586
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 02:38:08PM -0800, Sean Christopherson wrote:
> On Thu, Feb 05, 2026, Yan Zhao wrote:
> > On Wed, Feb 04, 2026 at 05:45:39PM +0800, Yan Zhao wrote:
> > > On Wed, Jan 28, 2026 at 05:14:41PM -0800, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index d12ca0f8a348..b35a07ed11fb 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1858,8 +1858,8 @@ struct kvm_x86_ops {
> > > >  				 u64 mirror_spte);
> > > >  
> > > >  	/* Update external page tables for page table about to be freed. */
> > > > -	int (*free_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > > > -				 void *external_spt);
> > > > +	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
> > > > +				    struct kvm_mmu_page *sp);
> > > Do you think "free" is still better than "reclaim" though TDX actually
> > > invokes tdx_reclaim_page() to reclaim it on the TDX side?
> > > 
> > > Naming it free_external_sp can be interpreted as freeing the sp->external_spt
> > > externally (vs freeing it in tdp_mmu_free_sp_rcu_callback(). This naming also
> > > allows for the future possibility of freeing sp->external_spt before the HKID is
> > > freed (though this is unlikely).
> > Oh. I found there's a free_external_sp() in patch 20.
> > 
> > So, maybe reclaim_external_sp() --> remove_external_spt() ?
> > 
> > Still think "sp" is not good :)
> 
> I think my vote would be for reclaim_external_spt().  I don't like "remove", because
> similar to "free", I think most readers will assume success is guaranteed.
Ok. reclaim_external_spt() looks good to me.

