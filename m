Return-Path: <kvm+bounces-28717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A02EB99C446
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D251285EE5
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 08:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A9F155300;
	Mon, 14 Oct 2024 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HE6pa4kP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF30C15747A
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 08:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896220; cv=fail; b=KECPTMfOWxowXnPysWuA6O6dPyMBM9Eoy+PCho54pgXNIjqLvd7bFrUwClPD2VCbrLsS9yIwhHpTIvLtVSXTu2DVTomMECIj+oUs1Dkio8Wd8Hm9oo5mVpIHJ0qxIHDC092Add3Cn/UiQ7X/p5Cx5NsJfBNvzuyKj8ICCaEspNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896220; c=relaxed/simple;
	bh=nWtyiBGIor5Eij/KIrU3GZYFuPJPEeKs1WeK69HmFvI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GxTK8VHbS1ZKs/tYdBFxPSTLMu3ffYch+TL099ui5LrZJ91xweJfjkk8qZysqzbW+pvlGLGgXl1pqMRwdRRk6rHBh04r1fgpptbU/c0uDS18Dh0jUDcgjIBsjj2VvVodP5GLIJ0SLHr3YDRIAf2paH6tMMfySilVOd6pZnsfQuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HE6pa4kP; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728896219; x=1760432219;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nWtyiBGIor5Eij/KIrU3GZYFuPJPEeKs1WeK69HmFvI=;
  b=HE6pa4kPL4N/F4yYfIGf24cwQn4D+5q0xAX/tSAhe2TkY7LKQCBQUGuV
   fGY0LQtabOiGEqDge6Oypxc5CYKw4ex2IoMsEN/Qpumh82KTOFCYp6CxD
   bpYk6ih2gpu7D+N4HI17fynijGLSRA0Rpds2TPqR94CBZbq+ypywpFfkc
   NpVu1/w6aeA8+dedEH09dE/37BvIakEVSCyEs9rpU9dSsXock1DDQzjDm
   Dnhica2gGt0pbp2UczSnPNH7qI2GHKVJMj8bCkgsKEggN81I9svzuIxW9
   79fdQB3YuGzrFdMmhCTGGCCFJiw5Vm0fDf4RnDux774TzLzs6xUaVvUep
   w==;
X-CSE-ConnectionGUID: AuhfIfBZR16fb2hTcP4NDg==
X-CSE-MsgGUID: JfVObSY/QJuh+1/P9mTBvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="28316643"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="28316643"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 01:56:58 -0700
X-CSE-ConnectionGUID: MyS0cuPWSrSvUatuFeKxXA==
X-CSE-MsgGUID: vqDIQnwlQhSnHdQ2LqZtgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="82539836"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 01:56:57 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 01:56:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 01:56:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 01:56:56 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 01:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7amhhHW0emLtNqxHX4diJh+ir6KKeZ4xJ7rTskmDgV6zZtGKUKWo1PKXgKslm7qu5omDCVffHcc/gDIoTV81T6yZ91/X6ezgKmLuTpWWMgAl+OSEGG3ssvx4T87JIMT/ZjWt6rFwl/Y7zSlRjSfMqKZMNAcDDISwP0JeBJ24nQZokxwORS2VxTrPzYzi/ZkUOmnHCmE8/XbMxGy7KgA3VdwG+Ax+ukTM96TMQD7Ijd2gHGBnJJZIhTsgnfigNd1M4vDib1wpidSFh5Ay65E7+8NK5UpF3GDFTWiYR2udW+1clXkUz443siFJRU3O0fXiqsZgA6GIYDM1b4vLRa8jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8+uWLuxi/dz6oG+9a8LnYLUxzxj4VLUy0fmyw9AELg=;
 b=Fz7X0z6jT/wJzuIyn5F5I3iiiITyKygAMnsqGcqG5NZNiRMf0mUXTez7IiIP4xmzIz+Uz5lHzYNj04e62YYOQ+WxaFr621BUCCymovM/OryrBmaLfRGtdbSaG0LWUbc9AOdvlSZQEgd09jtJNoWKGlSTY/QZTOcuOjVhuWBSQE7fUQJTVbkOlnN52L65f7HqZrfUAofOHtWgDRoyqUbrHg9HenIu/qOhqhEJ5Xe5bDi5uN23XBkAZBIAv0+QV9iCkipVOgpVeU6H2kTHVoCGa6rk/cjKPRTC5GuRIOF78tHHrBDJWKFEyLk5I1rKq3oZ5lrJi7uqtIWFLFOx+gCLlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.24; Mon, 14 Oct
 2024 08:56:54 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 08:56:54 +0000
Date: Mon, 14 Oct 2024 16:56:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: Like Xu <like.xu.linux@gmail.com>
CC: <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/5] nVMX: Simple posted interrupts test
Message-ID: <ZwzczkIlYGX+QXJz@intel.com>
References: <20231211185552.3856862-1-jmattson@google.com>
 <7fe8970c-ecb7-4e46-be76-488d7697d8db@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7fe8970c-ecb7-4e46-be76-488d7697d8db@gmail.com>
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY8PR11MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: a16ef063-ce7b-4e72-e68a-08dcec2e26c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?V5J/SVgVFCulhmfuxQgDAEB7DUOaVxIgmt+YnTr7eq8XBnDDLl3fM/6psSVz?=
 =?us-ascii?Q?cg/6/Mh5KCPhhzf0SetpRBBVs+VEpForTP/QFSlw5BTsYFoo195ahDG4KqvP?=
 =?us-ascii?Q?6+6jAvOgv/OWmCMSVToi1vMTnkkDpVHp+yY3tP8MdeiWmdERc9ny4Oca/eHl?=
 =?us-ascii?Q?uvDeQMsk8B/eV7JUyVxMrfeyuSbGtrUu2l6i3SHLRFShvTYpBZaZu6CEDkOl?=
 =?us-ascii?Q?TZgcI4QCOFl4+rLc/h40wOKpxbqB4xi+WSNjOIqNnqqbkGyOOB/e5390ZlSx?=
 =?us-ascii?Q?h5LgMgU3yt8uSsha4R8YbD+Z6MjWhxQT06eNGWrZ64Ld85LAybn1QBVEIUE1?=
 =?us-ascii?Q?MoUgaObxcj+01wii/yHYeBXtZei1hitcN71u0PI+HsrWWG9ffdTLBkYFD1sU?=
 =?us-ascii?Q?09Qh+VnDcX0aQqbgp+9swezvF2opNVWhFBozTv5aTX2ry6mPzWmkF4xrxPsH?=
 =?us-ascii?Q?skXobJiqcRpVJ14xQ9igaZ/DtvtKrUa55dJMz87oGwCcA3eNuCikBdXGG4TX?=
 =?us-ascii?Q?IcA6qrYqBU3skUHnTF6uJCEHG7HjipDTZz10AfiRUTKKenosHZT8BRmxXSYt?=
 =?us-ascii?Q?SPIcfbyK0UYSp1A5OynIVVGDC8pROX1ufJ8bz0dIFjtIeiFfqtzmp0hqAK5v?=
 =?us-ascii?Q?khx42gdpi/m0OzaCc3mcRx/RevIna9YiS4JKSXuvie7gSIwPoSDjsA7Y8B2X?=
 =?us-ascii?Q?JEcwJwJHQYMzru02fgAuCIM/acwbJK2az4KMN1k5e47v2xR07CMZtjdzMwLB?=
 =?us-ascii?Q?vwbyK6hiMtwyM2NRsRqF/02eW28kBPDU0IUoPOEAZnwsd6vkdwBNZ3Xv2Amd?=
 =?us-ascii?Q?A9i88tdcBEHvugCwYO1oRMCCa3if5yALhtbM/mB1tVECiXQrMl/OQgJtMXqL?=
 =?us-ascii?Q?uI3GvX2y5aedduJbyODuTmXIaXsLae5MoxZteJ5GGjTP/GowlrgLXLJ1tTFu?=
 =?us-ascii?Q?y6n+r7ABi2f0x13BjiwCNHqkQSG+DfC7A2xGc/bSIXgCiPV5fPVv5M4IKS/A?=
 =?us-ascii?Q?uRQLX7ZYC4LucvqOn9FHyt1wa+Li6pzn49YzbDlbW12DtKv+/r6vZGiQXMi4?=
 =?us-ascii?Q?aecbWgkN4ivkyI79R+K/MWRYxmvXMqRD+y2S0+n5FM0Y3kPUjg92R807rc3e?=
 =?us-ascii?Q?hXuagWP+XKHQKmybN9BHrmPqT8vY3Uc+I3LC+1Dy+a7+g/H2Nfw3eIf7cI4M?=
 =?us-ascii?Q?gbZDAzSbif24yKzOv7l5ahOfGFTCK8CwrR3kxMHsoGCLso5l1s7vZ+51xKak?=
 =?us-ascii?Q?86CDSPZj4XrlKFBvwKRAMdxPVccYxoDEOkFiiY5l4Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GZcr2mgZVqBZLKzRFrCZngqkubondsTj165EzUTiBfc0Z5dg6iMZTp0NZlxw?=
 =?us-ascii?Q?1K687MFlfYJq/04xeAGVARlhi/H6jBUbKhnnTT3bwM4rCVccekWhOHcDimcw?=
 =?us-ascii?Q?1suSdxnotg+iFRH9UEaCLYv+PcPTFIQSJ7cHIV4cc0NhW/4SOld6tmx/z/0d?=
 =?us-ascii?Q?XkjHPGEeMftoDocQNRzidJMynELL/kRENLZ6GOcbtBMt0fb+TX3IzG8SJvRB?=
 =?us-ascii?Q?CFiAY/Ip4wfQWh++LvDHciPlz2b0md1PgWXCi/iBstqvsD9UoAuHG4hrxy/Z?=
 =?us-ascii?Q?0mpvjLeo/EZSzCS700ammI/B5RkSpV3Eo4iRLpOfw9Va0LA76Dsx9V69s+LB?=
 =?us-ascii?Q?cy2wxrrSu9/qxASqz9EKIIQqrXkEJlNN2f2D4mQ1Y3gGIm74EaHxonkzQ63i?=
 =?us-ascii?Q?FaOeN3Z77oTJuoH5TweJqthygpsUaVEz5GdworIgg47J+jwZVUOITyWXk+Bk?=
 =?us-ascii?Q?Xq8E80MFtEbunWy/Mfe/cMQQjceiRLVW8cjppVDkiG2pL9g60p5GdAfHOH1C?=
 =?us-ascii?Q?oBtOIMBG1ORP8LHJIU5DDZZVzfu6dx/MepEgYd0qPRDzbCyYU8enJnwUhNq4?=
 =?us-ascii?Q?UkwrXErxGly4ZGMBq8SGNc9pMDWrdDNPava3HD5FbnB6pqnjUJvxmnv62CNB?=
 =?us-ascii?Q?LdHpoPMvhbnvspqyw8DPK7uBKf4SjLPrPbdDLUvr5dLL094kSk9Db3Q6E973?=
 =?us-ascii?Q?v0reEgkU9/9ZoVc05jfaB9UoEZXexGK9TSC+xgN1Lfx1WYxgD1RzxGT5B6YF?=
 =?us-ascii?Q?MgbpALDG7MunN0A8VmvrG3ApmlaulACPp9Ok6OxwrYmXDo5qyYCbsAq1t9cW?=
 =?us-ascii?Q?vggLQSDfxqn5IplEv48XS7RqViOE3fkAtNpaqZd2lJDw2qLHrhZGJnfy6fuK?=
 =?us-ascii?Q?qKRSkBd5k0eBTmyLJWBrHN44dMVmZYqxDOjSZPLOVRrv6Z3jPswllyamJEtC?=
 =?us-ascii?Q?3/RB8aiRX3hX/DM01Crlp7xhXxbKBYQNVQnoywRnAZ+CVabnvnIOD3UGAsvA?=
 =?us-ascii?Q?vdNqIbLEuU9auu2m4lPM0cY6esa5bttZXxJUSXzll6ssoD5BQgu3Kr+sm7At?=
 =?us-ascii?Q?cPcr48e6ay5867xZ3E5ztqGgpeGnaStb6IjLHWUTngAy4tH86vf7jHb6WTMK?=
 =?us-ascii?Q?aygrL5tHwIhPfK2MmKEbqjt3l1SfBONl4kw9U4k/fSmwLrEtDOSX4/MkxvQt?=
 =?us-ascii?Q?bRl08eC96TXalajdlCUJMQkGx8kKUYW7Z6DEUvr+4mIbXPcMkOoLiy/IKrsJ?=
 =?us-ascii?Q?e+UvI5fY2P60OAXyaWDhsN20luxjFC/6JBuYUeyMHuT7MWFBEXU+SJtY4LnZ?=
 =?us-ascii?Q?zZmUlgi+PJ8odS/CvsSC8OrPFzFEGmLbFdJMW3/fKFYqxRXX8kVhiQOSFQeY?=
 =?us-ascii?Q?UAROJDirZK8F1ctVhRjiT1xm7Rfw9h69KLdNPxdK1r9iTwymugrE9gYcGtuo?=
 =?us-ascii?Q?GLKVcdIpEdZgmW8Pxypg6Ym+cdRG7WQzoaSCsTP6Sc/BZblSZE8et9JD36lj?=
 =?us-ascii?Q?LzxfY9mI0oFo88NINoWQMBdWPFVrkXTyq7ioEi3qO8g6fCb8xYI7tDJl0SA+?=
 =?us-ascii?Q?po3WfcN6fhMDp0CcPKk9jqjVEQdbQ2fnUn7inBNw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a16ef063-ce7b-4e72-e68a-08dcec2e26c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 08:56:54.5869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o4njZ31UCN/oNKVKp2yw8bdmKoa2fA+SocLglJksCZQhg4Wj3BEAZakToHjTYIYU6aXk+qewusvfrPfti9KwwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com

On Wed, Oct 09, 2024 at 02:48:28PM +0800, Like Xu wrote:
>On 12/12/23 2:55 AM, Jim Mattson wrote:
>> I reported recently that commit 26844fee6ade ("KVM: x86: never write to
>> memory from kvm_vcpu_check_block()") broke delivery of a virtualized posted
>> interrupt from an L1 vCPU to a halted L2 vCPU (see
>> https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com/).
>> The test that exposed the regression is the final patch of this series. The
>> others are prerequisites.
>> 
>> It would make sense to add "vmx_posted_interrupts_test" to the set of tests
>> to be run under the unit test name, "vmx_apicv_test," but that is
>> non-trivial. The vmx_posted_interrupts_test requires "smp = 2," but I find
>> that adding that to the vmx_apicv_tests causes virt_x2apic_mode_test to
>> fail with:
>> 
>> FAIL: x2apic - reading 0x310: x86/vmx_tests.c:2151: Assertion failed: (expected) == (actual)
>> 	LHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'0010 - 18
>> 	RHS: 0x0000000000000001 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001 - 1
>> Expected VMX_VMCALL, got VMX_EXTINT.
>> 	STACK: 406ef8 40725a 41299f 402036 403f59 4001bd
>> 
>> I haven't investigated.
>
>This vmx_apicv_test test still fails when 'ept=N' (SPR + v6.12-rc2):
>
>--- Virtualize APIC accesses + Use TPR shadow test ---
>FAIL: xapic - reading 0x080: read 0x0, expected 0x70.
>FAIL: xapic - writing 0x12345678 to 0x080: exitless write; val is 0x0, want
>0x70
>
>--- APIC-register virtualization test ---
>FAIL: xapic - reading 0x020: read 0x0, expected 0x12345678.
>FAIL: xapic - writing 0x12345678 to 0x020: x86/vmx_tests.c:2164: Assertion
>failed: (expected) == (actual)
>	LHS: 0x0000000000000038 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0011'1000
>- 56
>	RHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'0010
>- 18
>Expected VMX_APIC_WRITE, got VMX_VMCALL.
>	STACK: 406f7f 40d178 40202f 403f54 4001bd

These failures occur because KVM flushes TLB with the wrong VPID, causing TLB
for the 'APIC-access page' to be retained across nested transitions. This TLB
entry exists because L1 writes to that page before entering the guest, see
test_xapic_rd():

        /* Setup virtual APIC page */
        if (!expectation->virtualize_apic_accesses) {
                apic_access_address[apic_reg_index(reg)] = val;
                virtual_apic_page[apic_reg_index(reg)] = 0;
        } else if (exit_reason_want == VMX_VMCALL) {
                apic_access_address[apic_reg_index(reg)] = 0;
                virtual_apic_page[apic_reg_index(reg)] = val;
        }


Specifically, in the failing scenario, EPT is disabled, and VPID is enabled in
L0 but disabled in L1. As a result, vmcs01 and vmcs02 share the same VPID
(vmx->vpid, see prepare_vmcs02_early_rare()), and vmx->nested.vpid02 is never
used. But during nested transitions, KVM incorrectly flushes TLB using
vmx->nested.vpid02. The sequence is as follows:

	nested_vmx_transition_tlb_flush ->
	  kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu) ->
	    kvm_vcpu_flush_tlb_guest ->	
	      vmx_flush_tlb_guest ->
		vmx_get_current_vpid ->

With the diff below applied, these failures disappear.

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index cce4e2aa30fb..246d9c6e20d0 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -61,13 +61,6 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 		nested_vmx_is_evmptr12_set(vmx);
 }
 
-static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	return vmx->nested.vpid02 ? vmx->nested.vpid02 : vmx->vpid;
-}
-
 static inline unsigned long nested_ept_get_eptp(struct kvm_vcpu *vcpu)
 {
 	/* return the page table to be shadowed - in our case, EPT12 */
@@ -187,6 +180,16 @@ static inline bool nested_cpu_has_vpid(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_VPID);
 }
 
+static inline u16 nested_get_vpid02(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (nested_cpu_has_vpid(get_vmcs12(vcpu)) && vmx->nested.vpid02)
+		return vmx->nested.vpid02;
+
+	return vmx->vpid;
+}
+
 static inline bool nested_cpu_has_apic_reg_virt(struct vmcs12 *vmcs12)
 {
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_APIC_REGISTER_VIRT);

