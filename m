Return-Path: <kvm+bounces-29907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6289B3DD5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3920C1F22E93
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5211F4293;
	Mon, 28 Oct 2024 22:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mk/gi89M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDD61EF0B2;
	Mon, 28 Oct 2024 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730154973; cv=fail; b=a9VY49EusUnZGmqWOXO2kmEUi7dZOeWz6mh75RrJLWSrDmNZIDMnZDZ6YYt/PW+lV8HXd7/BmTpKlLiip9l8dZ5C3XyHicPDwv9wgCE6Xwu8fT24lHAf8j7zjNgNPae82U+joII2yy9pJ9xjwXdGdhJe5d6EX7i56Trg5/YpcpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730154973; c=relaxed/simple;
	bh=+FskELPvjQPAvtiqyT5hme5RDV72+V2nwGQCSJN8WhQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XHGZg7uAemXHeOVqyEvGi/nEdN1i+bRtQMUECJ//TeNb+WsrNs2xy5ETK9K0qWkm8nOp2lg5LdhKa9e9x0CFe0kswXdmgWsPhFFHtlWVjmzopMnNOfyBY2UGMVZ/fW1QPQXmjeGzaNhzfOKcUdJ8T01bsJmgoldCH5Ok+yzvsEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mk/gi89M; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730154971; x=1761690971;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+FskELPvjQPAvtiqyT5hme5RDV72+V2nwGQCSJN8WhQ=;
  b=mk/gi89MDmDYbQVg1TAKnXBAsJ6uy6juDP+gNWspbutnLn18A3PwsUG3
   f8VTpxaVHauZMRXXSd2/rHXYgi1ED2+ZPuEkXlCk0DMKQXKyIKAWoKXp9
   e80/Zp4pSOQzTRxMthFUWjEICAK9nIzi6i8x2Wp2PuzJYHp1wS1au14LS
   zKau2qF2Vq3x/rCqvQYf6FAOtlK7vrPMUI/5Obi36wKFUeanrNEQuyddO
   6Rtg1SvzXRrrdKUof0PZuYm84wKPmBgRKLoOXAhRRIwzzr6rO8z6iW7qe
   DkiNnDppBDd8jjjves8awAcVbUlkvRkr+W07cYLLB8fq6yYjPnCSiwHt3
   A==;
X-CSE-ConnectionGUID: WwWQM78+RkKry7/vKLhtvA==
X-CSE-MsgGUID: Udj4L3BATB2oQwRJSxKvWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52327592"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52327592"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 15:36:10 -0700
X-CSE-ConnectionGUID: hEMBR2A/QxOoTPf2CnYXSA==
X-CSE-MsgGUID: gnh0wu/rQh+Ps5Q+w839wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="81326014"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 15:36:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 15:36:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 15:36:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 15:36:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adTeLFoqNQfo3gPHuqaUw6YBpKpMN815buTlOjhXkUBrNKYP5RMt8mEbCCoMhwQ+EtJz5UD5am/GyCCkSSNnRhx0HaEXmaSft3s8FydXr1Qs4fQQNAZNXfWaX8y3gTLINsNFp+m9EJRE9mEq+Lf0wOnFbPwLcwXv9QJ+f56E7HBl7uEzs1sDRwHgU6PbwmVSfjL7fpA9hJVyLeF31PL3vgwLz+ueEXvrFMQxVEYsHF8hBq2aHNYcYXQHM5olUDbVsckFPaK8bQQCImfq4b6BHv3KjyKLKRvMXoSZtNzqKwtIci7/BP8QOHpv/s568zHMUcRE1jNFK3/KvQzTfYfPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ed9xcEKyZ+4x2/vyq3hABgEMVIG2dSespG6Ch1oPmN0=;
 b=AHZT8j7R7FugNxTsIA61Y28Nz9aPneEXtuG1UfkB3+O3WMCE3v1QuO6yI398Zwmk5dy3sVwW94oe+uSbUxetscQjp0nXzDMDUp06pq9XJBswuXqv2G/iXhcx0v2gYYx2DU2K+m/9RxZQ06qEjt25k5T7S1/GtO5uoad+be11kF5K2PspPCXHA1s3vlejkId+uR81cu9zrNcFUegeJ3PlZMnlxL9btZLjBlp0579fclR0MnxUZzk+WsRJgnZi0GUDqqhGB2zAs26R74oANyPojtKbvJrntq3OVXm22rDm2mPaqUSfQAwmefJFwRIAQ9DHLGlPFIOzsZKgFrjsFqynqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA1PR11MB5779.namprd11.prod.outlook.com (2603:10b6:806:22b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20; Mon, 28 Oct
 2024 22:36:07 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 22:36:07 +0000
Date: Mon, 28 Oct 2024 15:36:04 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 10/10] x86/virt/tdx: Print TDX module version
Message-ID: <672011d43958d_bc69d29422@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <57eaa1b17429315f8b5207774307f3c1dd40cf37.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:303:b6::16) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA1PR11MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: a42a9ebb-f946-4fe0-618b-08dcf7a0e9fc
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MG09gRsoDgXr9jkwlIH8nFHwldL0tybUUXWQsiCCFTpPWRwxY2GFqANVexcB?=
 =?us-ascii?Q?az4kvysnhe6S6zvUWubFoWLBzsDVC2eIh4+tTUpJbLIbMzgn0xYee+NIliS0?=
 =?us-ascii?Q?0SLlUG3fEOWB6Tu4bE2mzQU6UjkYtyLG3r4DQdFwZiZ5GN4n231VHR2CdGsJ?=
 =?us-ascii?Q?bpcBQbwySqPa9o1LgLWQXw+sp7ABBnd5A894ireYHxm7GksLpNmW8uq/saCG?=
 =?us-ascii?Q?kR44wtjNXMVnEYZUmFDrJZd2LuwyGJzhmasXOWkuIBHJUf1W5RZL6b0U2b/4?=
 =?us-ascii?Q?HNWwr7fpcPHP759Wd9yaFWETTklFZNFlmFR+POxt1xgk+pM4Dgftjy38McFQ?=
 =?us-ascii?Q?fzqPZb1tv7xnmpnLmfAQHBPKHLcyUkdHDjViCxegNndXTnwnQgBFvYxRZ7d9?=
 =?us-ascii?Q?0NrRdRMqzdqtBxcVBsm0RkwiqMlfmzIEZKTDchFoP0V9eHxjFwhNUfU24aaj?=
 =?us-ascii?Q?k6P0R5iODG6aUEJ5HTLfIgg15MsUvYxrWlq5AXAP8lhPidwIfSTlXBuZUPv9?=
 =?us-ascii?Q?QcJs4tbpdwCpIX2m/BCAh9/zBaeutLjkM+E4++YF3KTTy9/tkoL3dS7shOBU?=
 =?us-ascii?Q?7KkpGo3x5UqNVZnmYP+BnH/5lPjcu6QqAoFNJAKof8baNeG0f6jMo3cM6qAI?=
 =?us-ascii?Q?bnKVDBzxh1ET2DQLPRsBHdKHvUslm8TyUqh+tO0E+7jznxL62G04qLm4vM7c?=
 =?us-ascii?Q?5m1j3NITe/HZgBrX9OsBkQdK9xCR3n5NO2BSAwj7CMkAy02BiNkvOTJEwYgW?=
 =?us-ascii?Q?CtLg9lxJ9atR/Kb4aomYvIRle1u3UoxoXKBxJ8FI3g91sJ2/gX2C4NUaqh05?=
 =?us-ascii?Q?maXtRkRIi5EzepxEAPBLVsLK2Z4OSqwT1dfkMznUcLZmACkW7Qdq87olZTIv?=
 =?us-ascii?Q?85VxvprEHkOvpF+/6eYXuWN3y520v+AdmJOVroS71PFai1Anq7IkbOIZJNQs?=
 =?us-ascii?Q?0ReFQz5duv5WPoRRXU0aGsUjMyoBf5qm/QsJoTM3tdajOJaSim1s89e1H6Gi?=
 =?us-ascii?Q?iz0YQhCSt4wEvLl1vzh3/TAavmHztAzo8MXM2guayuUT3tQN/5xtATzRQpbB?=
 =?us-ascii?Q?t7ucCBTikc2B08vcu8+PAVLdMZ+HicC/qc2Di+rXMjyE5sziO8k3AJdfZym6?=
 =?us-ascii?Q?SsOHV/0MAvI7sW98fCWqwB1N7MWAZoFJSXJONr5ZDM8RSFbGVHvo4WM1jGWG?=
 =?us-ascii?Q?+FsHi7fA7uMot7w0mQT+R+lhZxnSy4T4C06/qRvdxLKXgbVXOCRw40HIqvy/?=
 =?us-ascii?Q?nXf80wAetUD77M5RDUNU4dZ0RWzdICbWzt2hiUVSrEW1jZMOiYbxWclg3+qI?=
 =?us-ascii?Q?WrGahw6p/1MJpBPZr8ht5OCoFGbK0+3Gh2TZtKcUiuHiBPcRmCm9EG74pPtY?=
 =?us-ascii?Q?XCcjfWo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eYXQySWuEbWyHiGTzDIySX841J5nol0KIYDW8AIn5FeH1dUUp6PVBQ5ENK7Y?=
 =?us-ascii?Q?UhEWGW97JdJN/EKPL8QXPjuwUtYNS9JEM/zryW9xwhukgUd9UhsotaPJrn/y?=
 =?us-ascii?Q?P7JmpH/TK4oYgdSECtiRzCUSM0TGlGTrpzr36UOrpT2SIZDIDVpWhmk87nku?=
 =?us-ascii?Q?j1VB+I8aCDcAJG4UWLZR28b9bb0c6rPgGr0XKEol5R04cbne14hTo56kGJAQ?=
 =?us-ascii?Q?7qj+uqU1tDmqnPKwi2kNYK0p7DW/8d93DKgtlZ8Ylf9NID0TmYYW1Zam16iq?=
 =?us-ascii?Q?pTce3K5mtVpksO2Mi92sIEnztSIPB1pL+wUGr62nZjeua+5DcQ8K7zMYxuwf?=
 =?us-ascii?Q?nTRHXNRvTl79H+9jP0dFzYiI23rjbkd16qAVNxaDA6ct+UPHv/+pN6/GfHEj?=
 =?us-ascii?Q?w4mdwk/xNE+0PxShbZLXGp5Ho1AlPhqGJJaQpPCj6Eiwb25btoPvPXXal2Hd?=
 =?us-ascii?Q?x8fmm36tMq19wJci69oNw2P1dHwhFf85Ms/LhKSR4DvYqDDxPqvBt8R3+lI6?=
 =?us-ascii?Q?clHfu8hPAIZIbjgxgAbQhJ1o8T4Ql+H3dJL9QUAPK7ORRKuQ8vTWfXVfCSPK?=
 =?us-ascii?Q?a4UcmKXQhUHcj7bDcUz1WTNkZbJ7ICTaztdTe5sokTGQx9m2FXyCVGgdS9WT?=
 =?us-ascii?Q?2LjLvcI+SkzARnGv+ShnGy30bTGVhzsvhHGcNGXhQ9p4x99ulofm/bHmHeoJ?=
 =?us-ascii?Q?mPhsqYHFbmPQN9qcfu2XKUA9j1jhhcLmZcwpZaVDFEsLdqRNL/7m3NAZdOlT?=
 =?us-ascii?Q?Sxu64obSeIVkThT+7VWKJ5mJeY4SAkxiSe/b8LHgjnnBCOXAJDc+MSSAYfBl?=
 =?us-ascii?Q?FqfzUVmEnoMfgOJk6J5K6f7I5pvRLDlNbA5zvHmRDaRj+om/ZTi7jE0rYO9/?=
 =?us-ascii?Q?q64WCmRBEyiOdi16rBf9z+ztPHbGtGckbmaeNjgkdHiOY0Sr8bUZS4r2zQgC?=
 =?us-ascii?Q?izj/3In63WVnVio8KxbZPDCTbVJdSnPIozmw6dnksauCwmNIVBG51gsl1Fye?=
 =?us-ascii?Q?ODBvL3zvuIhiTwK/4AcZ3os9DdXmrkJiLBduAHSnom5Oa2lTZVhBONhfIifY?=
 =?us-ascii?Q?ESH4fx2BQULpQaRj3WjIFZOUVH0Ho/YQlMeuwgMXGqsA/1a95J+JPLkPg2tx?=
 =?us-ascii?Q?LfbHx8gOnTtTIDRtfWHP4qWwKbHaNWtsXgVbhna7zJlM5n+ows4OAUYz67FJ?=
 =?us-ascii?Q?kVF2AG0sTanjS1xHHMJQUO8FhF/rhagUqakR0q9+7OXgsnannfAQV7cbSaY7?=
 =?us-ascii?Q?IHH/ZpxwNCmTdmfoexiOb+xpdCUpTZ4SFKpizQk+oX8BIDjUJLyQnJmTQ9dQ?=
 =?us-ascii?Q?cOr4MztYKsxILKLmZQI6zpzhNPL2VPXysJUt9LonLCsu5lODu5mK0FGL4Fmh?=
 =?us-ascii?Q?SWEtVzXl3+mkCV87RAYoc4iIsZpb0xgJ0h0XBv7+ZYC+1IPIzavyYXImWfbv?=
 =?us-ascii?Q?Z4oKoom4ZX6VAc20ftDljPybGuc9rc5/75LeJd4FjGTjwxH2jyMazdVXmvdR?=
 =?us-ascii?Q?MxkISzVKMKpLwO43KROsmEm1G+SAyr5zoyeA7M5sL06DvOl9hGjCzjDkpYrR?=
 =?us-ascii?Q?jO/M3Mvdw5ZVfIjSBSOfFhoUGb2LKy+NBaFtG4JfmWc1U6kku+R+zKSLe50Q?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a42a9ebb-f946-4fe0-618b-08dcf7a0e9fc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 22:36:07.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ov6NpXHbnM6ZxuOHfqfMtPWn+kdp8c4JF0YVuC7P7zEw2L4pRLWNpIzG/gycwIbhy84DwqO0A1tmnLOjvnKYrs4W+PZZCT+BXd05s9lwomw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5779
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Currently the kernel doesn't print any TDX module version information.
> In practice such information is useful, especially to the developers.
> 
> For instance:
> 
> 1) When something goes wrong around using TDX, the module version is
>    normally the first information the users want to know [1].
> 
> 2) The users want to quickly know module version to see whether the
>    loaded module is the expected one.
> 
> Dump TDX module version.  The actual dmesg will look like:
> 
>   virt/tdx: module version: 1.5.00.00.0481 (build_date 20230323).
> 
> And dump right after reading global metadata, so that this information is
> printed no matter whether module initialization fails or not.
> 
> Link: https://lore.kernel.org/lkml/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
> Signed-off-by: Kai Huang <kai.huang@intel.com>

LGTM, would be nice if the build hash was also included to precisely
identify the image, but will need to ask for that metadata to be added.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

