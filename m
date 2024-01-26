Return-Path: <kvm+bounces-7040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B10A683D21D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 02:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D60CD1C24388
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 01:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021BE749C;
	Fri, 26 Jan 2024 01:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cMdJfj6M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ABB749A;
	Fri, 26 Jan 2024 01:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706232939; cv=fail; b=tffe7HdIKqmDVJ00aa8+UtaY9l68JzFgH0eHvk4jva0UvHvBjNPTys9v23Q4PaWpSM6nuHImLqED2dlRdEFt2g8SAXuWZ9c+R5q8W/dD00NQCibjZx7YknTVfipBhmTY+75Hs0Q1rFAsoASiOgx+f9QWfQhCxYWSqpVLqkJb3Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706232939; c=relaxed/simple;
	bh=5wlY9AjXiLESEOdjW8zANzc83h2urtjeqqi2f2/Yxzg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R1rrYOQ2K/IFNAVUB0wNk+zMBiHn0BsyswPKlmquXNWWk61Kmv7X/fqTRpodaCElfXH51WBhpPA/01+h8sfDbS3qdPYVSwNJ+MtYkSpEsm1nljxBVxmb+xHdFKczVZxRiVUitzrFcjUWQdbX7jsFwtV+DInpX59pUhlzCuxQ92Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cMdJfj6M; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706232937; x=1737768937;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5wlY9AjXiLESEOdjW8zANzc83h2urtjeqqi2f2/Yxzg=;
  b=cMdJfj6MZLkxS4pOdG+VWjulEHvLO4QR8/X1AM3QlneOmD5PwER5dits
   U50GSgj8zVz5iCX/C78Nu/MwCl3fS/hn3KG7WtV3KKks+zGWmliHW2TxI
   b5kAo1hr6zVmHLm5OEHxwR3F29uSYL2p+4COguhVfpXYLlIBaz9esdt/w
   STnREIGxk2l6IsdRs2Ira7XA5HuFgF5zT6jqWuGo+Ma7ltpRUsFqHaVtc
   P+vtxQ7eev0hWPTIs5O6k/7LQE7lPZy0PoNoo4TN3Q7tAl5u4INUwsE0K
   yD/7IC50jDl89dcpA2LhJ+o6hGrxDS37hZpmh3ztgT3o+9/Hwm2l4Nk7Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2197956"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2197956"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 17:35:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="28672932"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 17:35:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 17:35:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 17:35:34 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 17:35:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyCs5Kop656TBq91PQhookNFQPu0ejaQXnl9rkWtf4In9mdLqarYO3Tcze8zmAB1l1AwUOnafPbL2TGrCHxLr+IN5GQLrOkBH2awzKNMdBq2VAkpfsgkPVa3np86tpEqQyYaDF4lbN5Gp266HZuUhWWrDw5tyeQq+R+/rbjHkEqMYaR7Na3GBWChs2UCW4vyz58EeuUjYJFMu9MzgX9kpIpBD98rA190FSY0o7WYXfYMDork3zu5BB17GodQJ/lvtAqMpIIWY2AzDxso3t6YQnfNA8i24+5nZFS/UMoxINCbamaPkow/fg+7D/UCqETAe630il2TkrHY5/xA5IugYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wlY9AjXiLESEOdjW8zANzc83h2urtjeqqi2f2/Yxzg=;
 b=JPfPTrjMufpW2kji3bYsgOfdrwIYcC28FkAeKmUL++/GyFFQfpjb2JBIEvQJSB8JsyjmBagZx/yZlOLCvOX4kx1jSqEo8RIAvgTT3ws4QjWUCWhGPiS5Id18zjtYpB4f5JDMhzX3GfZTSN3sDDEwIx8Uu63ah1n8EPfLRbc6C1hBpSlXsY7rHOeSzALt9JqrDmrpFQb7UuqU9C+VYnuXc1pEA64XT8Lcvn1hbOr9re4DeVxSOVz/uzPjgGchE37AxeUUvmfDGeq3LBW2+h5xXLmB55EIuKR0GD9Qo+MRfpbcvIbmq/MDAbdcoAzIfetnsiieFgvd8KHXBTpH80y4qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL1PR11MB5430.namprd11.prod.outlook.com (2603:10b6:208:31e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 01:35:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7202.034; Fri, 26 Jan 2024
 01:35:32 +0000
Date: Fri, 26 Jan 2024 09:35:22 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 14/27] KVM: x86: Initialize kvm_caps.supported_xss
Message-ID: <ZbMMWl4PEMSWTiW+@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-15-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-15-weijiang.yang@intel.com>
X-ClientProxiedBy: SGAP274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::18)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL1PR11MB5430:EE_
X-MS-Office365-Filtering-Correlation-Id: c9fb91ba-0755-4542-d542-08dc1e0f1611
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NKRAgGyCtl8v8XIce+YzTeShG2u0nMNb0qBNIoUWYSZ3v5RG57E+zDH9lpE0dlRpB/t+JaJb/UNzNs9Gvog/f595WWQj4BwDXJY9WQkgr2Rc6PX4UsxSI5JhtZacgIwHtGudM74YVskxAz7peG43hbq9RoGlSQJk6MO4C5xrwRp8Id41zIdZSR3V/Nld0jUlE/zINo3rwKDJd91kjR74dy/n2vF558SZf8H+vIbPfZaBC0GQqY+dCyNMYnkbB1eUH1Vy2DwOphlY6df5W+HCab0LhqQkzwSPEfwd2hAzFtCv9FxWvru4Dft/2LGNx8EYlc1RiTKajV6wFRCTHZ2fWszUoA0ZMi3e1ZOFoPcQ2RiTZsY6B9E1waJWOtGDSrQHyuCT0dN96rOfBBU9C3MltKWH4V8l2IKilXIUKOsYaqWzml2RR41kfdfu+upr14sXdQMOl3EmrRDEqNTC8Nc5u3u7/w6hI39nMREuvbZ7hVLzIozWHYAw2lg4nG9JzP41uYVptHS8l5CG5pbTtRpzI5dXh8fJBkEdpi5q1YNy1cK3SDQ8KHjpKvUVwbarjUPT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(6666004)(38100700002)(2906002)(4744005)(5660300002)(44832011)(33716001)(82960400001)(86362001)(478600001)(6486002)(4326008)(26005)(41300700001)(9686003)(6512007)(6506007)(6862004)(8676002)(66946007)(66556008)(66476007)(8936002)(316002)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lLOB+hSgUAeW/3EYo5kMGm/w5wEZLfK3CHYcVudAcR8pOTP3LE4YiBzOhhin?=
 =?us-ascii?Q?MmdoaE72NUcUeJ8GpUPSwyFnpVqsgTkRGYOiAALdzrAe2Xoxauw9kYgGF7qb?=
 =?us-ascii?Q?Tty4F9R4JGK6guMuW9PCyrjvumeR/GeNvg02AOlKlaEBcOa51J0pmfYbtfVM?=
 =?us-ascii?Q?lr2QDukzIR8DUTQA7aJCST+1fhwusuwgyJVDkB2GCp1LKO4Pn00UFV1yYz5U?=
 =?us-ascii?Q?TWlajm7extCIlXPkb3pi7PpdAsCp3fbTFtXBCUFRV94yri4buMNVexvrfohp?=
 =?us-ascii?Q?d7EjJVC6wbkCUcS9rA46CpCrJ3XZu5VIcSejemfOQZGokKeMeH6QtAoCN3F9?=
 =?us-ascii?Q?T4gbjLAtX7JILBdO8SNqSeJIZM1VQ7JGS82qE8YlrSvMtVpgM9kUAEy9Y+ZK?=
 =?us-ascii?Q?MS6R7C/WUys+RxA3+UPRZIUE4RLI/O/Yot+7ewDaEn9QJAQkh1THbw6gjbSX?=
 =?us-ascii?Q?QzfZ+cZoP4YWndd1gJcTUhZmwsYQHoIuY0Vku48STkM50rnAhMw5jIHPsasR?=
 =?us-ascii?Q?J+EejgkFtn7cJM3b0JlwGkjX2b3gHbq0OYQi22VvP/2ryuRctdtg2gx6UPXt?=
 =?us-ascii?Q?3jzmIzDgxQM3BfuESyFhoz/3KUL+/2ix5uFHOcpZrZ4XocCRdJ/RCDC677xK?=
 =?us-ascii?Q?1McU31fGioRbbyv9lblbRfOqjyGo6wqcDeRY5mc2dKmmfQhhk7dSdKr3GGLS?=
 =?us-ascii?Q?oN4fs525O8CPchwFY/LMtkGOrR+2O6DNw7okIa9K7weGBHu4KuaZY7zmmP4K?=
 =?us-ascii?Q?sPNRc01UrzoHnrGraOqMmfaO+61q/jCmdvSq4obpD1EbxvxbBdMrZaDFwjno?=
 =?us-ascii?Q?fHxg0tR87ZjwL1LX2zQ4Galfq/x+aPsqSD1jcXbIgt7EvDvbx2GpqcsTmzY+?=
 =?us-ascii?Q?fXzNdg71ewoOELpMONpg+QAxuuQ+A9LpJ5KLtwCZHRoB5/e7Lls/IKZp0Ca9?=
 =?us-ascii?Q?lcZ/ajTtM9O/ArENcI88o+qZw9pvBsjPS5corr+p9IShg9xepnZKl0i9ZZjp?=
 =?us-ascii?Q?xKGlTqchx7swBNMLtfftr4xB7W/mb8Swyyhe5j9zeyBDbyeBsKTGNx7XIB9K?=
 =?us-ascii?Q?TPj0QrJrXSn7G62xK3uIrXLY8tfnF5mK1x9LwLTORQbGrK59dEImy/drkXJ7?=
 =?us-ascii?Q?w14WYosag95CDNtzmUxy//gGkldm+8+5xLgpW2vRvtuWl2aamvsghhqj87X4?=
 =?us-ascii?Q?k9kGxFPkQoB2p4moy6HtwjkvriJbJ5l5oPo5KBE2LIQrIoz2JphoLw2WcFqj?=
 =?us-ascii?Q?ZS/v4IPAdr//YsR06nupv+/qqQprhjjUurI2f9qSPyX7/JxyC7a3HvuSt8MH?=
 =?us-ascii?Q?YvwPHdldkFWoiSlD69dggWiJD6n1S1HA0BONl7PGHo2LGb6KjEPjD7mjMCvt?=
 =?us-ascii?Q?SrTrZDNvs/6GVEO9fsLA65bdOXfMUifnTZcV5/8e1WnjpUH13qUJFFEaVwMJ?=
 =?us-ascii?Q?PH1JFPFKpJ8sdV3Knh9PLrEyPsU9L8ydH5knARqx6sI5Jr2MU2PCrSO6rFA8?=
 =?us-ascii?Q?0BW6aaDIbUNjY60TfT2E2wtvr5sygYskj8eNwDWiZwwuauAAHbYL9JL6OKSi?=
 =?us-ascii?Q?F3LCoZJqEuL5rQdE8GBfgiTgMEnWtmAePRoL/lbb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c9fb91ba-0755-4542-d542-08dc1e0f1611
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 01:35:32.4807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFFsBc7CW8SXmsSu3egWW4afzyZDc+0Gzvf1uPybdyso8Ovv/dmold4V7slD8PTvbhxdyTTlwVJ7gQ+GVn9Z5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5430
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:47PM -0800, Yang Weijiang wrote:
>Set original kvm_caps.supported_xss to (host_xss & KVM_SUPPORTED_XSS) if
>XSAVES is supported. host_xss contains the host supported xstate feature
>bits for thread FPU context switch, KVM_SUPPORTED_XSS includes all KVM
>enabled XSS feature bits, the resulting value represents the supervisor
>xstates that are available to guest and are backed by host FPU framework
>for swapping {guest,host} XSAVE-managed registers/MSRs.
>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>


