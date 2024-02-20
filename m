Return-Path: <kvm+bounces-9140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A075C85B5E0
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4E7E1C2217B
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 08:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73E55F465;
	Tue, 20 Feb 2024 08:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="awh75Ohn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A00460B9C;
	Tue, 20 Feb 2024 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708419084; cv=fail; b=hYsTOauJK2XYVCmcBAhYQLzHDu/ERgSYqf+3g7L53Vvy/YTBweRvowhAdaUwb/++u9ZQ+VugmmIJGCsi3ACyXDFdGVsKKkgyAY5GG71kB4M4A7XpAm/2GgfGE4iYPiJ61DwLHWImbiTdbR2iYk3r8J21mAflhfiF0Z9A6YQtWHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708419084; c=relaxed/simple;
	bh=EDu0ZCUmk3zhEMjBxvVePfcWvEW0l4qHmvrckbjLo88=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RothGQSa+gkKV2KAZXIxj7rGc/HCEBAsQBs3k94Pzv/MBna4yTgKoCxNKhWsMCzp/Axr53NGquTMfZAg1ztTok6BJJT4fckv1qcQse4di2viTYXFGV7vGkbo5lNaerIpLcqVbw5vKuSnbbVRiqDLEcf3ZnaD2CZ1WNZ5fv05iJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=awh75Ohn; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708419082; x=1739955082;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EDu0ZCUmk3zhEMjBxvVePfcWvEW0l4qHmvrckbjLo88=;
  b=awh75OhnOb+m3e1yVC+v+d38eX389ZzR0BW0CBRCISbhbfnyjgmu48xd
   P4T3CkbYrzX0YvgykJmOyKARQaEWYsbbJgHe2oxXS9p+mvDLMANNTDdqg
   KttiGB43IMe/1RE5q8baBYB2+3sR2BmxqdoS3GlMDt/uKOP2k1Z5HWpCv
   hSjgasbVNeOC74k/L1y3kORUNuxC7yvfoTqLD4YGEWUup1MqJiAUwQ3wi
   RM85CV2iH3K+eculXw68w5l3hmjggHFz8G7rnETIU2zQnP9wwdvUz98g9
   f/AUe9OxQwPhnfehvZfFuAquA4+h4Nc1GnxUeYTiHGqoFR2EShwAjSPmj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="2377229"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="2377229"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 00:51:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="936421130"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="936421130"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2024 00:51:20 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 20 Feb 2024 00:51:20 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 20 Feb 2024 00:51:20 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 20 Feb 2024 00:51:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lHfUJzmVqs+NWYCcgHJPJKuvkrIJv6QuxeVyvY2q1nrbyldqNxGVTOyJdSZ3BjNZ13qMOmLc+4nWE/4Ok45Fj0kq48J3IPuYJAfDv3D7KFP0vq12QEy11D+sgnaGAAcWlPW7icX8NofGnIK1Bb8jZ9OYnqzvk/SYV23bKEEL//Bu+DRIDjmZpHY4pY0afnl0LP1QW5Y2MItqDfUCXmSchyaB6YYl9xTA+tFWn90vIZn7FAsZkMKnaIGttxOtyVFRlormcTNNqMresLP1RJen0dBhHIa2zdOhqez2i1B8O8TwgQxTh/hzSVLgWWPGDEwtEviObDHPOAxIC14LnXKjzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDu0ZCUmk3zhEMjBxvVePfcWvEW0l4qHmvrckbjLo88=;
 b=cpPU0icE7KqotHihk29vxkJr6xnEkrtBehonUIBjGe8QuTUkBPL08zMEXkuGPsmNtGp1ECMpcaKnI1nZ4IufcXYsE0qKVg77afI96RCqfDFidQ8G0wf25B1n/FAulfVv42H00W3TmdyzI2Kn3NQWVecs1T0ASxtd+k7GqM4G78dhK0GqMX3SnYC5ImPYbPGq0S5BzSccG3Lm3iwVZ98QlBv6vQnzIFBMWyxYl/NFCz9ByRZmNZNp4X8XfV6+o3bVmxqQzBv/6SMD8ahzTNHfpCtdra6LWWsXtZovUrqdeZGZ3PPip5keqkd5S37uSa28Jau9dSoGa7+mzZfcAhVDUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 PH0PR11MB5659.namprd11.prod.outlook.com (2603:10b6:510:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.39; Tue, 20 Feb 2024 08:51:13 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::97e:e3d:4a2c:1010]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::97e:e3d:4a2c:1010%7]) with mapi id 15.20.7292.036; Tue, 20 Feb 2024
 08:51:13 +0000
Date: Tue, 20 Feb 2024 16:51:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: Yang Weijiang <weijiang.yang@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<john.allen@amd.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH v10 13/27] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Message-ID: <ZdRn+A7g395N2AGx@chao-email>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240219074733.122080-14-weijiang.yang@intel.com>
X-ClientProxiedBy: SI2PR01CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::12) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|PH0PR11MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: 05f2ba58-9f97-4523-0796-08dc31f1176c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a6VUpT4MwynbdRG44RI0k4JRwSODjZVAy7d4bmndvicWVTdWz3Q9zqo/LwEvL2Q8enj/txMd2soSF5GPk2lTPJ8DlNzDum25JdODa7guJc1JgLiPXjCdY6GPmgw3AddbOhoH3mz8PYhY60iS95V6SZnWcD7xDVlUiZaxlCWrt/uiUzTPP/g/uLzJro9qQw/oahNx7qpHw/2Pfy8BR+uSIpEbPJad6Ty8hMXCKjedJ4b2MTzqFPzF+8lRwA1xWNenhsXPsE0AuGIssqaf9F78Jug5VmOj9/KNfFczvBNAmyqIJ1M6LTR2runkSPj5elqJvTVQZDzWRl4wLAu7JPdzlkCo8qZCuVchgyPRWzv5ORWKE4K3Iw0pxw5ML1CJZal4bOrXKi2CKCWmtE7AvUxYGawTUEkAs5CSBB3l5cPFyYGQjk0SA9kkV+ocgWY/sISwJ5yYYZERI9Ob2VAw3Ys56ssVA0CwI1TPzBanj6YxePPkhBc/rRuB2zhkX5zYfY8M6OO1kSLNvIcPymaS6PLBqovmNh/NDBrt4Xp15Xmyzas=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tSYe45shUMt5CDVuy5FZyYO1Ietngy3fTW6jFwiKET9brBWxAYYdzj9+v/3F?=
 =?us-ascii?Q?qkiUwxy/ro1pCj//NUSwkydw1b88xcenIBjsjtsiX/rkC02TVsA3YPiDpcfG?=
 =?us-ascii?Q?RsC0tsEYAcWT2PplfffvBtOWS3ikbq3+WehPfHkveYT0+/Bk6nG04cV/692v?=
 =?us-ascii?Q?8BYTdwGWyQtkPTrxGAJOqp7orAIIhj0xhbAq+xCAYbYPg4mNBYUZyYS6u+Vd?=
 =?us-ascii?Q?1ezvkDBlbpzxwoacZsvGU0Yeb8HA0VxhStvDHdZWSj+pyWhExy1LPDqfupLx?=
 =?us-ascii?Q?OUrSyJcasdLWqrlZqFqGB+ruyw+XZjltm5fs2YaqhnpE44GphQNUgZlF4pxz?=
 =?us-ascii?Q?LPXgXPJCtjVix96O0fG6+dM1YTnufff+565DPeGyeZKxBxXl5yQ64yJ3pgar?=
 =?us-ascii?Q?/NaIQQpLKk8JqKuP42Tyw5EjaN1Z8pXh9mqpKV8yD58h0ztxUR+kKse2u2t3?=
 =?us-ascii?Q?IAOyXqFU468YN74UxV1mQcDMi4Fjxd0cDFGKccZOOnt+CIT3y71utAZH/HCe?=
 =?us-ascii?Q?mmcJCpaiC+O/vsAd8Ea0WHoHKXThCBMwRPzZUTL5IJIlNgxPNjndslfM9Vz2?=
 =?us-ascii?Q?1WSsZ2UYOBO6O0jktxRhGgN2VCgkHPwtvOzC1mROgL6rAaZCuaQQ0x2JBx06?=
 =?us-ascii?Q?bh4fiwunFRyIYt3A8B6JuuwMRfoWaFGj03DAuw638Y5RpQeorZhYeoK69NBy?=
 =?us-ascii?Q?JUQdmUwu/VJgIq/a15oT5bu408ESx/ltWUq8i89QEN5xpVP0DTYsHdpJiiPy?=
 =?us-ascii?Q?5XCxlTJRISRFdSsBWX0vo9HYYWKnChZ2S8sma6KdEdHlezrnD2IoT3GZOU0J?=
 =?us-ascii?Q?OMKt3eMRSNP3mtySxx28VC1e15QoYtmvclCLNHwuChC/yA93vBVYkzt53nHy?=
 =?us-ascii?Q?77uXpRen+DrNlRskWfH19xuX8ottO/+Qw562iIMlOrazXpZpKXZNRZNMr+sn?=
 =?us-ascii?Q?feZgq+oDbYKHVj+FQzt348KRdfc6X5lUsDuqFcbbJ940VOJrcNdPwPTVD1CO?=
 =?us-ascii?Q?e0GwWDSgCaxICPzlyk+dKVGjV9AbiJjFVwMo3zVIYlHqB4x64/710BTIPilf?=
 =?us-ascii?Q?XIqA9tT4/DrhIi8mFzL6+pgxwCPe5cVNi88yUM6oGuYerj0xOM9LBi0jmec7?=
 =?us-ascii?Q?B3pfRO++6YIJdzvTNuLB76H5Ued00qegotc32rNRnx02Lku9tsUzDLWsBSH8?=
 =?us-ascii?Q?H6l+BbPveLSygYluwv5ilxdNUvhfo6G/0+GucdJEVru54HY3o/40jrrKvgSF?=
 =?us-ascii?Q?hEi3FqS7ZF8X0HCR3etiaDdW4C4UU7/sx5I3SEXb42v9Z+kKrMNKJPSnUIMN?=
 =?us-ascii?Q?thxD5mvDey33U4zMFYDkSKqdTWhjnSKZqQRxNJfGdGO83qDJuYWHRSpDdd37?=
 =?us-ascii?Q?tDsHN5I/6Fbh9HGi66ny5DtQeshAkwVzHAcqp5ujym47K2dG9aFbAnhDXZYk?=
 =?us-ascii?Q?wtAXQJd7hKiGsJ9ouqLYbz+ooTd/I9dEVDWW3iHfP8yfUgolPkS4kRBymDyJ?=
 =?us-ascii?Q?iWSWMl/DixI1bfStYqbKwF4G1GEPxZDomQ7J2hBT5p6ljYlhmWrZcYMMfJHi?=
 =?us-ascii?Q?tDEfS0ERwsEWQ/tEQtR1vl3W0VxjHLk0mamfDLAD?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f2ba58-9f97-4523-0796-08dc31f1176c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 08:51:13.0485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/Iz8mWjzBMQKBsOXOIDopmLh+vTVF2Ra2dwieaOLv0vtMxKallCiIUCEbz13wsTinpPbmgko5bK45IQzkptNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5659
X-OriginatorOrg: intel.com

On Sun, Feb 18, 2024 at 11:47:19PM -0800, Yang Weijiang wrote:
>Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
>due to XSS MSR modification.
>CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
>xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
>before allocate sufficient xsave buffer.
>
>Note, KVM does not yet support any XSS based features, i.e. supported_xss
>is guaranteed to be zero at this time.
>
>Opportunistically modify XSS write access logic as:
>If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
>to anything but 0, even if the write is host initiated.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

