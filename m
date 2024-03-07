Return-Path: <kvm+bounces-11265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45E0887483C
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 338C1B234D1
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 06:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602851CD2B;
	Thu,  7 Mar 2024 06:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nk7QPH/x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D181848;
	Thu,  7 Mar 2024 06:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709793474; cv=fail; b=kbOoYdbHtoS8MH1MNi4/7ULxF9eVmhSrKaEwo1MweYsT5jgY4e29yOMYLWwYP+1lKiR0WqRBhmWpJmpdG2/B0W5BCS/4xa4sUVMZaL+7RwpZnMOpVR7EaJ7+fwcHi7ZZH34LJja4b3hk62lV/+uKQaZNa8oLB/ucukmhPtxw+AY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709793474; c=relaxed/simple;
	bh=2TZZ0kEVPva8FlKcEYihZ2r+1hDu/+OBoJ8BZlWpZTo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ofzhCP9dm9Nhi2PbUFSX7mlGb84O68kRjbEtSaLtW6losvFmthA7yntoaBGKkHXBg8B8di8LM7PK+4/H+mEgMJGAdT9C4BR2RTM4vitWFKj0yK/GLU3sHZjzqY3Cw0bQt9f79IeMy8b63kqb6ng8mDb+qxRhxDAe2GPU8MmtAj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nk7QPH/x; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709793472; x=1741329472;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2TZZ0kEVPva8FlKcEYihZ2r+1hDu/+OBoJ8BZlWpZTo=;
  b=nk7QPH/xYc6UVDRVlFfqwDI7axriFVryGpL9xTB3YaafE6P6vxZrqyXA
   f5TFqvEmIZehvE8vhsxI0X74krIVNaFehE+BOS2dpicnuHYBLtpUzfSFg
   8Pb1GvmAoZ+12u2kvQHyBSv5e52LG3otiuKoAipkywASfyngVGAC6cYF8
   Y6U/1dxLSQMML6SBq6z9fp4Q3NamR5pv3UWMmFmmKHnS3pSVLKl4DnpiH
   Ll83aUspus8pII6yK0mCsi+stldLMlnY1yEfw7y2fvSmyCpcl4wrr2Omm
   biadx5JZnog5cjKsemygsqAyRkk0nDMaoCTlarvLfOoUYB+sl9eoEicnS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4304282"
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="4304282"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 22:37:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,210,1705392000"; 
   d="scan'208";a="9902978"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 22:37:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 22:37:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 22:37:51 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 22:37:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jk2SWLLvrvW+e0Up0WeziogDB/eluSINdVpnsvNsqCU5Ys61RG/RvToVIpON51dFN3GbQxN9VYzazjy3HFjTN8rSP3kS1I0aP7LA9qtSS+RFcZcof8Zaga5lYblFGvICdd4xkPIc9jVwgc/4TwunfjYhee1ELJRKsv9R///SBx35LeaHX38Oe34hAx/p9FeHXwcQRnNV39G6uVRijUDOOdF0QRCt/OD8Hxy87vEK8E+NiEFoomoUXs8vIu3NkYxjNx4d+4RYOnOj0o293Q97399eR8x0FDOCuIgvM24bd8XJx/sM8Ms440ePtHh7jV8lk/UzqAYIxbNFwVh7HOE5WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wglsISMDwn0qgab1Fogy1upX1pYnmQWRNqHkUQuOjTw=;
 b=UBFgWVDaEL/y1v+7O+yU4n4vEr5X+OR6odu4SRfXccYQeKljpjk3/5JD6CX0QLDKYPxCNohEZ9EvDX8I5Oq7qW3ACzg2dCMB5T9Y8cHOmmehF8+LnRshRGLDXnjlF8KMkQVAJvkDXW1ITk/kKOWXinLzzI/JKSSyWrBrD2IqLyU5TlshgMEjxpawbGemX2JtRg2GfKHOF/nuojsfuW48jWgYUAnQXSBN8KGJOwZRYsSh95iRw/fiyBtM/0D2gczWC64uwdKk95Vvmr03F8PbwT3ifNiucjih9mNUYYgxMLiG1ECjfCo4rV3yA2g2CHt55gDoarpMrOk1CvM1dpSfxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4850.namprd11.prod.outlook.com (2603:10b6:303:9c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.24; Thu, 7 Mar 2024 06:37:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 06:37:49 +0000
Date: Thu, 7 Mar 2024 14:07:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Andrei Vagin <avagin@google.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>
Subject: Re: [PATCH v3] kvm/x86: allocate the write-tracking metadata
 on-demand
Message-ID: <ZelZv6/aXaViwkwd@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240213192340.2023366-1-avagin@google.com>
 <170906349657.3809281.8603439312604083486.b4-ty@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <170906349657.3809281.8603439312604083486.b4-ty@google.com>
X-ClientProxiedBy: SG2PR06CA0235.apcprd06.prod.outlook.com
 (2603:1096:4:ac::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4850:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9b8275-2207-483e-3065-08dc3e711b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0SdaankcVvjvhatezqyONnrCwbnbF/W0aaJyNtNQn2jNShBzC3vbPJeaXyqHeYTf4U+zaYxJhdX1O0mDiK4hsWP8b6nmhZBERAN7CE22lnutWmaQt9SDZO2Jn+RadsTlccmz4u+ZOhlrJq8Xu1z7AWXFgjyFgvwczzxvDkwa6Jd3Ttyh/hDIQsyf/eoBHaVekbH6mFZXhQZH+kM9W9W5t/uCZwh/PYR26qaNj18IlpZgMkYkl5jWvnlfm7RKi1UuAuwy/06b0CrQTfhLZi/yPEjyeRYqClOc+EkfAqscSNcG8DnoyK3Sg7NuDZrxzMQL5UK4O6gVRfdjaxYnLAU1wcbIY7Z5/j2EENIQ45qHD/SS5O6BJZ/ptzT2XJNNNc9IWQE9xvc3Su+sNF4ivIdezzkgpGniUqrfejnLFnjC3oAV9pqGrk2zrvqDRRvuhsdQ2HkJhShk1UdgkDbSJdJZFrw5VdZH6pOo7VWlq/OG/y5EH1Q59LQ5cSiyr5HHA6nfAFZ+euFY9A2ghyq9oOzJHugvL6R1d5/GVm9qwHmKuv+KtagLIxxkAv1IP77dZJttPm+lqN2wTvsbA9YNWUo6G4eCw0nuZOYCUwtsJph+SbU1dYHZgdQGcuRYZMipZ2iGEw9k3Qtv2hwJ8sbSKgiR8vhEWXiNskwuuEL2OSjD02I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TPR9SEywBViDQaVCUKEszywBQkgifaaTC2qgVkLi5Td6y7yrFtUEfhojduTn?=
 =?us-ascii?Q?eOLJrhmDbHq08H20qZbvvwIqe0n3k/yaeOLiDWcigAYXijVfbGzMgl/boRWr?=
 =?us-ascii?Q?feMO66aNJAQkshgfrNrR3F2pcgqS0ozlrle5eG5p38vwYt93GZvSaIvJI2Bh?=
 =?us-ascii?Q?bQFFTbZZanGymoD1UDKND+03whvaeeZXZsJKaxyYlWy0x9LkdNXmSA9mkAiO?=
 =?us-ascii?Q?OorqJMvMnU9wsYDGAeaVZSqvqVvGlSnhp3zoHG0cNuVH79vaGSQ49V1WzGUn?=
 =?us-ascii?Q?nWZKzSI5mHghTl3dy1/UPqOtp8VLcPXkerCRsdeBSI4gLaV93PquiDMjNEOn?=
 =?us-ascii?Q?cNBmn17E9oVprFEnPinlYHRbS4uB/K6YkTA7sHs2+RxrSLbcorPQYtW3NpJH?=
 =?us-ascii?Q?O2OBUWJ1joJu98qlQsghinjdPiFuknUDirJkpZvcA6YcVmuK3yhx/t9AfkP7?=
 =?us-ascii?Q?4QEysTOw8eAY2q3I1g07ShFqWTN9YiBhi8I9JAcSlCWU6iEXqeY5BJg8DfQH?=
 =?us-ascii?Q?dyKr21QCfceWdmyP+YtHCe2fp3QeDHufhNt1tFXhxW9pwiI0rz3YHOSpHJFY?=
 =?us-ascii?Q?u+cbgnKtPwoiASkYfXY7nk/hpGwRwE6MKkGbuUUb1g2MGzXou+6/eNZmWpip?=
 =?us-ascii?Q?ADQju/7gTCkv9tj6OkfXCeLf2kwpffRdGX83+bav2n36CyyTBd4pTQK2blWb?=
 =?us-ascii?Q?M1htDlCqDlfJkcCzWiqMA9PsYGRUw/DyIb24JuAQl38FOnv1LGGIZczyvgJ4?=
 =?us-ascii?Q?h+aNmej1kzL7BcBFT8idy53eIlCe2OTEs9T7y4u3vBP0JnjGGVt3Vr+g/0qR?=
 =?us-ascii?Q?oAF9C8G5F/Si8oPgAPFu12BtiG9LiReOl8LjJbJ61trLstfqSaYNemA6dJIA?=
 =?us-ascii?Q?J8Sn1L56zsrojjnSylU8ltQpKRmDcjKDz14r2Ee/90MIrUbijGPKcdyA3slv?=
 =?us-ascii?Q?ywIEdtycKnicSZecp28Bx/rI1E/xKfs2BFYDA3sAV12tHrmuXUqTvHsb5Vy3?=
 =?us-ascii?Q?d/xFg7x2vjuPPzdKFKIO3l8oEBOsv+Lf4cYM+Ksry5w8B1gmy7HwGNFcK/w+?=
 =?us-ascii?Q?tyHkL2MK22sYkk2NVg5lZg1TMnDy76DxqxKIkuuP8rz4YNb1+Qi9AsgYwTku?=
 =?us-ascii?Q?h+xseckItHcJFRkFdjYn8xb1tKLxug4QxpIyRqTCctBScOS/fzgU/ept3hN+?=
 =?us-ascii?Q?OOhAb3MGznm1EP9m8JGnq64NleDJdqzp+sGeuEctXWk8Rtuui+X81F5/0zll?=
 =?us-ascii?Q?IP+frZbjEx/+1fGmY1QWo1EzkCkRAzphxoAHX0JUamMXOHj5AwTd7Ig6tNN/?=
 =?us-ascii?Q?JbtWpdtcnxZu0HhzcA2Juxx4pCCfOn3pr0i+c0V/QDJwzO7+5rv70Zd22aFE?=
 =?us-ascii?Q?6U/LdQwR6z2sPT9BjcmCFblFs519e+/Swudp0NuYz3B5M/LgkhVsC/iBtfFv?=
 =?us-ascii?Q?7TCzjfmznhKVmYWwPhTk549ZFIAAE2/wOzWDADSSrxIvJLZizKQbJdwO35MG?=
 =?us-ascii?Q?p7MmVwnxGpSikApoEQ++0xEg6m5n+JVlKHBR9HAv9dhthQ99WvV5TG7JIV+1?=
 =?us-ascii?Q?sGNaVRhu7uCwnfIxJI+xAwuEz9jzXyA2nKML5eTc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9b8275-2207-483e-3065-08dc3e711b74
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2024 06:37:49.3748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZdjQPmssng0Wi32ouCmd29rf+CbrkUmBlE50oYZMaP2wH9nclvlN5yV0IgLYp/nhieq/I9jQWDggG3T6u3wGGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4850
X-OriginatorOrg: intel.com

On Tue, Feb 27, 2024 at 01:28:18PM -0800, Sean Christopherson wrote:
> Added a few more KVM-GT folks.  FYI, this changes KVM to allocate metadata for
> write-tracking on-demand, i.e. when KVM-GT first registers with KVM.  I tested
> by hacking in usage of the external APIs, to register/unregister a node on every
> vCPU before/after vcpu_run(), so I am fairly confident that it's functionally
> correct.  But just in case you see issues in linux-next... :-)
I tested in my environment with KVMGT and found no issues :)

