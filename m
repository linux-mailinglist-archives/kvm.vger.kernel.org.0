Return-Path: <kvm+bounces-7083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE76D83D55B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F4E51C25AB0
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE22F60DC1;
	Fri, 26 Jan 2024 07:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A1Xslouj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA2611702;
	Fri, 26 Jan 2024 07:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255657; cv=fail; b=AwkYTPuUvOafK/jygQw9ZZ6bagHX27K7IoPTlA1658BnshINjvzHBgdWtCw0VVIMLBLwTwxLOzkyL6K9ru32rGAvupEvtOsbKw2x4hcQSr1JG4WQj6P1zuN6IHa5t38b+jnklMWiHzyHuPMaRKw8UDE7Jrnceudqgx3lz/fQNm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255657; c=relaxed/simple;
	bh=3VAdsZeUoAg6zeR9iQQwwuUwYZ+1VZEm8A1yF86yc1A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VUIBjr2mKqiJbJoqnMpPuF15imvep1jC8fhkwZZ7ACXxDIjKl41qX3HZAcp/MZ/htysjake2ccGJg1kfpscf7FGw+1ra8JUa3w5szep73PcAef8LiJ9h1ld+jv/Kx3XIKFPSQ+nhSvzrpjIsTT0WJBnhFE+lOeY2Cqcc3o22WaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A1Xslouj; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706255656; x=1737791656;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3VAdsZeUoAg6zeR9iQQwwuUwYZ+1VZEm8A1yF86yc1A=;
  b=A1XsloujTMJQ0tDwH3WJqN0STONjMj1F504ZpMdOgip9gBMvEPbdvuWY
   WqkLSyn5brEdaEjIXS+U/0uUC940fnV3L9AkpVlokmJPruPYf05Aws+YZ
   NoYwTHW0Vh4taiZaNUZqqOgm9H5s0yv2ufaivBtXBZYt0Zkn6OgfL+cEo
   V7F1iXGsM/28lNPQEhUn8kYzT/LnNuQWoHWcZy4PavYYZYf5XT+bGq5U+
   E20UvM7hf2p8l49+q/kSQ3M5d68ZIiQni/x2NwjVedpxVW9KqF3/LOaW+
   Zd5818i3FWygEUuBY500/ndLQd2Ic+1uaXHjMKTwNb1gNChxNIPRzWtrV
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="2249307"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2249307"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 23:54:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2526912"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jan 2024 23:54:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 23:54:13 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Jan 2024 23:54:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Jan 2024 23:54:13 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Jan 2024 23:54:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEAFFGkKmO/muJix/2+ZLf5pUPP4Kz+g2BaA+Qj0P4DrLtspGhOaK3QSr19K9SZAObC8h4n1+sLIYDSQv0AUs/c9kjn4K59p1hd8cSy1kHZVNuaVIjRdyE/GVEqlo0NIZjphW9CCAL9WO3QDPz137FkqyZSD+DbFZlhcGQqvROobcZPn5Rwh198pCI0Od+NP2ASggBXoU2lFJnC3ZDTHy048+E4LJ9kI4CVFWgKrC5YFy4CjvqJWxfeqOt0i6QTnuaYejwfna3/hDFjUJ0jo37XiLRGX8aAkNWNWnmJCUNldgFcvea41gbf0GxJ+jE+xVqQ6TEzg+9gJwbn2Om2HVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3VAdsZeUoAg6zeR9iQQwwuUwYZ+1VZEm8A1yF86yc1A=;
 b=maFWVJeLhaMhc/hKF3vDxbCbQOu5v7Z1Afyu8zxz//HpZ6Mch8Ff5byWf9zEWC19bLfAgFHVAErfyZamd4pXTkVJFy9kfqnpMrqJPJRZ0BXr49WBqZmpHaiFLZYEVrPpplIgisSTiICZqIJEyC554a7R+W4b//j9knYr9uuWLqtZvS1MNZbYtAzydUnFxKS16P7lrbxfpHp6RYEFmO8BJsuTbL7DFoCIAdJaAqWMH0JAHlK6cn1v2ZRQ+W+qKmtkBWPDxz4niDBl/KaHD2pApAX++W3iDEiDO4nwkk9QJHe98q5tct+NUpT6IdU8KPEGRKgIraLo5qDkA7FK3znqJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB7280.namprd11.prod.outlook.com (2603:10b6:8:108::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 07:54:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::2903:9163:549:3b0d%6]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 07:54:09 +0000
Date: Fri, 26 Jan 2024 15:54:00 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
Subject: Re: [PATCH v9 25/27] KVM: nVMX: Introduce new VMX_BASIC bit for
 event error_code delivery to L1
Message-ID: <ZbNlGLu/PReeyCu5@chao-email>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-26-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240124024200.102792-26-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: d14a09c5-f76b-4d36-33dd-08dc1e43faa4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MgiGVIseUe+oMDgxLXXzclUh+uu5dMIy3CUWliAI2Mzj55Qo90jRdATOQDQnFxh8XMedbUMWEfImJ7A3lgvg64Ig8FSU4iTLBjSLQ0wLj9n9AZZ6XyxWvafpuKuvZJkG/JVYl3R7JRLR7zIVGC/cVHbaQUo90D9i7RyIK8O6jBSSstBlblf3dzZ17o6LP3eBElsgwWstkWDSW+46PE22ycPA9rs3ZGFxC/gQTufDuPiMlu9NwJLAMofKVe72ZzsuDRAFRZ14LHza8LyinvUzW/Hk5szt1GNNdv7a3sRryxgTq/Oi6nf4zTlfilIA5aVqcSPmtriiNNK4OUtKYWTyXQIe5mIA7X6uwTaeRCV3XXp2hyUpiobl15Q0EHdD9TP6hi3Q8MFQBtfm8Pj5LX8sU0Z/gHfCW3q199TKbZ0u1ZmHt75nTPlNuYCKbgwDGJpP3/Uj/cnK8ML6XHi2KFDcGo/Jk7kQthHKoe3qZ8IHM47GZPiqfoVFZIosKJ27Q5c3Co5OnjA1YGiRpbmvvLiQOyzEekdFNY9vXuRzxlD97SEUmOzE8MyZfBPTe/HIvZyX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(396003)(376002)(136003)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(4744005)(2906002)(5660300002)(6862004)(4326008)(44832011)(66946007)(66476007)(316002)(6636002)(66556008)(6666004)(26005)(6506007)(6486002)(478600001)(8936002)(86362001)(8676002)(6512007)(9686003)(82960400001)(38100700002)(33716001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YYTK+7FjOSxon0DbC4Orztb/uDh+NRp2QjzCnR0jfVTQvfJ+4XV0qerV7YE2?=
 =?us-ascii?Q?3owvBmlVrGrEUj1SoyU/3beKUdUIxNzpaq0OJaWEv9993wvXsc/QQCrBGd6B?=
 =?us-ascii?Q?YpjJLNfeQHFE+RlJLhM5bQSbiVs3eFUvUXqtCtHjo/8LdeLHR+gMDJ0FcCBG?=
 =?us-ascii?Q?pLr174LRnMQD/ncFxgL71BeAOdIIzWMKW/Xfv2vqUe7N66HJbyQ98CN+l03X?=
 =?us-ascii?Q?pL65MOObmdZHet/yjtxpFvWSG+jNQV7DgMRpSYiLdobk9j2yIQRbIHDCcCSC?=
 =?us-ascii?Q?NOV/RitD/QFsQeEak6a9KFSr4l+nrzUJfy5GK5HfVSelOiZ3zbhsAT1R6Fd+?=
 =?us-ascii?Q?tobcXut1ZeySQ4NA+zrQK4WZPrGSyQH52uP5N429SYg0JqrlMkS0NHgzRtix?=
 =?us-ascii?Q?cjEn2eDMZGRUExq+/4b+t6sxJdSq2gMNnHaTj8x4kTZDRfEhu7TiwhPftpZR?=
 =?us-ascii?Q?slacSWVqM6LOsUyCsWlhQyIdNs95vhH4UD3A8Lidr6KJGXHSyagz7fAY3KmS?=
 =?us-ascii?Q?VmVXH5BVLITqvyQ4k9mN48TmVWAr3WISml0iMwR9x+HWFALjZjbNp9aVI+6E?=
 =?us-ascii?Q?wZIXSq1ZccbOzk++1wOoEJogT2L7Mj4Ox2DTyv7NSbYoj7pobnLrRd3Ms/8U?=
 =?us-ascii?Q?KICw4Hph5FFEASXTa0oL94pcAJzg5LQMohcBb6wQaOAIjPNtMHLu4SfVOnO+?=
 =?us-ascii?Q?J5QKmWTsPTRAEXSCF73LEpTmJsJ7mOmyJG4mJsuczDHSGgU7akwVgd3n/gWC?=
 =?us-ascii?Q?IwtXWy8GOUImdZRea90DROLW6jf8aU8XvxfHnf/tVK0NCWnjg6hwLEyYNP7f?=
 =?us-ascii?Q?bY2M4RXAnsBg8PmqLLOsjPiKWKEbnh8qfF2Fge6t1ym0YMqSlovOwcLXq5cM?=
 =?us-ascii?Q?fiV8FzPdzt/KiD7qT0Q7gBqe6LBdDgQgrZjKR6R7yVwxs6mo/A6pGvqN3aMb?=
 =?us-ascii?Q?/4iLVbVYqnz41vZJ0WyxBI8FZGCOfGRIcTmezYRzlxyeQ23/ccHCiqXsbMmQ?=
 =?us-ascii?Q?i+gpxYYGvFX04JSL2lslkJKJ5vVxmebZHU89XkqpB68j4dKmPhNYpDrknmyP?=
 =?us-ascii?Q?+5CYEU+zJX/MX/+FUli359ciJdn4zYuTgwhPwGTr+1+5Lo8jhKI3Ru7W6cbL?=
 =?us-ascii?Q?0lzyNKgt47/JHWLSSTZM1VL8sM1WL+I7WbnDVdD+P7DGRgbhlmh9q/hw76XN?=
 =?us-ascii?Q?EjWAJXpKv23hCQqc+tO4RjmzBnCXruYIpxAX4j2++KAaWbDHcEazPZ73+emQ?=
 =?us-ascii?Q?Fd/1nuw/hnr2JtG1yKIWcby72yJrnkKRux89wRTkI6Bejbm7Jex6eLLRhIGW?=
 =?us-ascii?Q?kHVUrhLCK4NdRQWMi5RmELCeB4v1Xiy99T7ileQPbBMIuER2ek7aX92B0AR1?=
 =?us-ascii?Q?2P0kX/4ecxxklfFrSdFS6m6nAZ+WT3Fp8+yWwx2YauORY+0s3dWdBy0CdNLu?=
 =?us-ascii?Q?Lurl9H9jM2cb3HntT6kP0a3CLdT5bBjWvwH5rJOorti63xZ3cAdJ6lxaoDKf?=
 =?us-ascii?Q?14yEBJelYpa64CDiZPQ1r5Xklm+LXtXl1vm4vCLq0Vq9d+QrVdihtrWIA3sC?=
 =?us-ascii?Q?jxgYhwthogwSfgzPJ97h2GID5xO6SjrGkge0byY6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d14a09c5-f76b-4d36-33dd-08dc1e43faa4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 07:54:09.8379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pf9PB5MSDt8dNMmrvxVlR/0VlIPbnQDip5ue6wyLk2rLRrwB6Vl6SKg3p9AlZFlR7zjyma/MQqtARWF+aOnLwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7280
X-OriginatorOrg: intel.com

On Tue, Jan 23, 2024 at 06:41:58PM -0800, Yang Weijiang wrote:
>Per SDM description(Vol.3D, Appendix A.1):
>"If bit 56 is read as 1, software can use VM entry to deliver a hardware
>exception with or without an error code, regardless of vector"
>
>Modify has_error_code check before inject events to nested guest. Only
>enforce the check when guest is in real mode, the exception is not hard
>exception and the platform doesn't enumerate bit56 in VMX_BASIC, in all
>other case ignore the check to make the logic consistent with SDM.
>
>Suggested-by: Chao Gao <chao.gao@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>


