Return-Path: <kvm+bounces-10650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 839EB86E310
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 15:11:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3738C283CAB
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD0296EB7D;
	Fri,  1 Mar 2024 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VPIb2Byf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA726EB7C;
	Fri,  1 Mar 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709302290; cv=fail; b=R8pAUjpwJBy9Sz7FRyFzaQNBOK4ijg2i7XfakvvnUoiiqYKrDlZ3MKYpq5mkh9QLajYMCUm30h1dkqdt8A74v/1AYz47/9QiNIe26xTdGNsGwOdn1kHDe1Wn7MiKuRTGXysXfyUDTV0DEtaKOmEoCAg7wh/uDmy9yDcu2mqfGT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709302290; c=relaxed/simple;
	bh=UKyhlcbG91+Jj25CNzIDVwC5Bdf+61KeSx71M6tV5GE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t/9rGLNeRxn1TUG4WdH5bIRMjIFvvTAEm6Lnuiy0UI7AUHtGKqNLP9em2WCU38aYUIW45E3H5SQVAT6t+ON7aVxZmBDtyyc4HimNyfJ2AFWBLxw5jQGg/f8XHfvadYpA1gm2mdxAXJWQ6BVz0uiuBP1TChntojN8Rfkqux1Msj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VPIb2Byf; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709302288; x=1740838288;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UKyhlcbG91+Jj25CNzIDVwC5Bdf+61KeSx71M6tV5GE=;
  b=VPIb2ByfeE6S3R/AfZZMmTjifWW16HhrmeIPbBs0wlAjw3GF30ilpbmv
   6k9KKxWKmBYodES3pgF2M3t/9mfph2c0XW6BMcTAc+Dxj5ERx23MTynNk
   eYI5WOkI0Js+sLbVSJsoqOO6EArJZyl7ix1emIHSkhAmf61eh3cIjw4hw
   FVF0S/EHvjIwl5hTPWyTnCtZbPmYe3RCdJVVb2RmrwpXE/3Z6wpFlrouT
   RWs+eel/S6crPSMk9+WNUk1c6GKChpMiIh/GDLmuHUQ1D9pPnnKS+BZbU
   qJu+xPLF2oejSJ4gw9Zby48mzllsOj6ByDiYsNn3fpew3ISiaVSYZ+uq4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="4012818"
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="4012818"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2024 06:11:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,196,1705392000"; 
   d="scan'208";a="8440092"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Mar 2024 06:11:27 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 1 Mar 2024 06:11:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 1 Mar 2024 06:11:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 1 Mar 2024 06:11:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YD+8zEuecfAb4+olCt/iPSXZvZQX5QJwpMKR/n3s6Afx18c1PT9mFeVb5KuHyRIprtBZ83wYatmPFvJYCczk7osKID3TR94YZKNkZXOwppxl4kFcjAiO9RMRt51ZBaRuEjmSXSOrsdZQFyz/qfaVVsY/mFY1a8M5JpSqvICYYXvruBhg3FGXiuVS4McstPDzK8DvRNl4omTKpC6rt2K6J2AUCKZ9vVQC9989/TtgJoelYXEEsQg8broxgBwXrjiUEgTOagKyh6xVQIf5G4XnXUKJQ2SDh3EG9TN3lBJVenF65WCFGbwhtUPOTu/RmCybUfvb5QZhXDculpUny/DPow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2DTzGlhzjDdhJVkCb3cClKxb5xyYa189GXp/9pCEiI=;
 b=mmCf29Fvw8+DL5E/zVpYz+mMFFJFu89NlAhhFVxryWiqzCTtnbBSjqPYmgqg+tagcsDsnfn7rn7cRg+jMHuH88y2Hq3sDUj6h6SxexrXRdfSVIFPIvR7kyZgECKMQ9ZqonJnDXeTPWR2mAwb0Dem8b1sIUHAnenu0sd/+fhfwuDN5/6fTY/U7vLaSvwW837NmB0hvHkWtRYfHOjrj2GddqYUk/H8bflJ4bMrfZGuo5/Mbzj5fawyxba3MUG5FP2/CTUz6QidsTA7/Zlj8WY1lOS51AQaVB7IWMfJXZrxwxPUPM+jty3TWdXR74e1H0KFnqXVMKorimxBtelLWw4gpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CY8PR11MB7083.namprd11.prod.outlook.com (2603:10b6:930:51::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.32; Fri, 1 Mar 2024 14:11:24 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::ccab:b5f4:e200:ee47]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::ccab:b5f4:e200:ee47%6]) with mapi id 15.20.7339.024; Fri, 1 Mar 2024
 14:11:24 +0000
Date: Fri, 1 Mar 2024 15:11:18 +0100
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Yunjian Wang <wangyunjian@huawei.com>
CC: <mst@redhat.com>, <willemdebruijn.kernel@gmail.com>,
	<jasowang@redhat.com>, <kuba@kernel.org>, <bjorn@kernel.org>,
	<magnus.karlsson@intel.com>, <jonathan.lemon@gmail.com>,
	<davem@davemloft.net>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <xudingke@huawei.com>,
	<liwei395@huawei.com>
Subject: Re: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Message-ID: <ZeHiBm/frFvioIIt@boxer>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
X-ClientProxiedBy: WA0P291CA0021.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1::25) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CY8PR11MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 8336d201-a502-4eab-58c3-08dc39f97a2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUfrtyTC+WlA++7o+VbQ8QtU6ZrTGeWbub0iQmk4wleAi/tjAlXLnCIMVQZIlDSHSA05VY6gkgv4d8q6gzcuG1YqpZlMsN5TnUalEbGWClB5wXOW1kfQCKMYArzDsUj9SxZwwGplElvoPQzb+sm0rUeLKCB1Ap8TlFRIHvfwEtoxF+e9m6GrgT9uCUAUq66So17m+4k5VA+7OPaNX/S6ZkdgaO4Di86skvIefaxUW2bSvEejICBjTuvwfkAY7E8jVxj+Obh6d+8PUl3mMB1fRHhs05SS0tp82gApkGUS9rqA6mF7BmGZd8fTWfNVfB2wLTO9qmW95kIsO09b5BPUk7DEBqfyVohsUI/Y89csXC2Rxy+MAr6IIt9uNIV8OQhGqV1sd2kL8deVY/mVmulKg0tlBfmQIeuvW+haqTpO+0Rc6eDXKPPuTKRCTC1CTkKWANrvaPbuw2x/RPWmNiGWUDSjf6bk4vkbYL0GpfCXzyTTbwLPUE0eT5QVM/UALhho7wubE9tn5YucM/JDp07Or9Rny2KVmxpu/ZI1OljgO18KD06PTp8YYl6x/AY4E3fnARPfVFI+XB/xlqIyehqdaOWsDx0Iemt+j2hBXuk22Rh9mDcJ1+K6Gi/8gHI5f748
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NiTGaq+F0r7L+WTypT7ycj6jhu1Hw+rQiQ8D2Ihz5uim/ADWUVnIs767hthb?=
 =?us-ascii?Q?T5yxxnG0uNJpH0SHUKTmathIFIieONj2NfTcIqZ1b6zhlGz73ElEqonNh3tN?=
 =?us-ascii?Q?a9AnbsR7zDwla7CI1zrysi5h6s3b6rymQtxhpxvVQEO6W95xFT9bMrBRvy2o?=
 =?us-ascii?Q?R25qtfzLstWgQoicb39uQlPOhebJx1MuNW8vXsTICly7d8tTnYMtBOFl0Y7h?=
 =?us-ascii?Q?hgGmCTG+BPEciO3abhCk1Nz66iZiny50s0dcjhDFZzgGBDAmJz+2hL/psmOC?=
 =?us-ascii?Q?nV673D3seKPtpbmBr4foj96jQuMvdQ4MA6DksaRxFcAKO2fUU4cIDNPbo2OD?=
 =?us-ascii?Q?glvW2icfbYe2bcIFBLzD0ea4dEzJOKQc/E9a9edwDL9WS9j+5xDKieDYAxRA?=
 =?us-ascii?Q?pjCF7k2j5RLFmgqSe39hJlqmVuQ+Fqq/Xry6Q5cW0C9AIGHkJS/WwVzIg01S?=
 =?us-ascii?Q?lbYniQwgWkXQZEay8yrx13qcCB6O+9PGpVrqqomtS7daX/Fsi30fL2tgHvXe?=
 =?us-ascii?Q?G4j6fwGAhieAHxeubL4l6BGygxP0q2Qhoidb8rIUSnRXPx8Pt2TutFbHcMjm?=
 =?us-ascii?Q?cn/PydoWv0dhyrTL0vXa1xevmi6xYyWhB8mYhiy+CcLncEJtYdgRteiNBDlK?=
 =?us-ascii?Q?2XU0qP5AXrAYvNJe6/mB4pqLKgZTdmkoRpmSsYIWqs3Kr0GfzPx79k/7t0U4?=
 =?us-ascii?Q?Aj8obuvk5LntcjJP0qv5PZ7eFcUfLB2/CnJ3KXT8MvDng+Uux+zfGkbHJ7e1?=
 =?us-ascii?Q?renmVzM2eBwUg2Pay6Sm/psED3ziPuW1nsSfdICKVwNaucD/QR2FIDk4gMFa?=
 =?us-ascii?Q?ByjZRB+gdeYcX63sdJd813e9iRgHNWxl5X6QmzW3c1e16DUPQx7XvrsoVGiq?=
 =?us-ascii?Q?qcxV31ujWpjvjhZOjrEuoa48aEWo+2fr2BBGvwp+3q37kqvWBcFhnvMWD+NH?=
 =?us-ascii?Q?5BpmKXNwoB8E7D1z2taJtJYRnbqcoD1ckOvXLucguXdmICcQ4Jg5jiwsxWUZ?=
 =?us-ascii?Q?VO//BKHbvi8iJBYrWgRu3qXc9krGihUVMsexO+SY3J5kfIZaYkzVx67QJqH9?=
 =?us-ascii?Q?K9VIVDoEXGn/rwWl+4cAHowIYY2bdxlgM1aCTRCALDW/MW07reIoTAPu8xll?=
 =?us-ascii?Q?SuX9HvfYmd5CbJZGuT9IHfooEA7ECWuHX1LPia4m5MgnfDQGJHw5xNfSB7wR?=
 =?us-ascii?Q?MhxJbn1U/uHv1XjdjLp9S7br3oPoGpTlbajAQgJfL86GNzHIw8PGAxmnXDwl?=
 =?us-ascii?Q?PhRDNI0Cqdj8IRnWw4eSmDjFTC4XFLDS8nw4eh9L59HK7DVyrxhawpwpTwMp?=
 =?us-ascii?Q?s2TUEwTRoz6aZOBJ+TYDaKILHkhIfIwNs8G2YCoTmDVRHctXXfRcztyubTwA?=
 =?us-ascii?Q?7yiOdpgnLVIEs+t7aCi4fxwMYRNX0/oqKhG19SVwaKrJafhvsQLew79hGaSR?=
 =?us-ascii?Q?1P/TrRKGijAOioJ67oO9XSBJZB/KoCq7aRLLtdSDzAl8pX7lVOcAHkxVNzqx?=
 =?us-ascii?Q?/VwdSv5+fT+zwkcxsk1MsL4mQRoW6PQP0MVnQ0WVnx20e7LvryBWBEmJxa7Y?=
 =?us-ascii?Q?w79FJwVCNK4P3N7SBbujHL/4gpPakXormFKJsUg4eURPhs77JPoW056nNLuI?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8336d201-a502-4eab-58c3-08dc39f97a2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 14:11:24.0415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3CWgxJTBghRWvkWwvkKD4epe3rFPy8E/2d18lYYqYTGVN4Dk+/IGAEcJ/QDYX3asAXsZ7RvTghhW4E1n6FvgOpf+WjlxC1TPW08FKmJJCCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7083
X-OriginatorOrg: intel.com

On Wed, Feb 28, 2024 at 07:05:56PM +0800, Yunjian Wang wrote:
> This patch set allows TUN to support the AF_XDP Tx zero-copy feature,
> which can significantly reduce CPU utilization for XDP programs.

Why no Rx ZC support though? What will happen if I try rxdrop xdpsock
against tun with this patch? You clearly allow for that.

> 
> Since commit fc72d1d54dd9 ("tuntap: XDP transmission"), the pointer
> ring has been utilized to queue different types of pointers by encoding
> the type into the lower bits. Therefore, we introduce a new flag,
> TUN_XDP_DESC_FLAG(0x2UL), which allows us to enqueue XDP descriptors
> and differentiate them from XDP buffers and sk_buffs. Additionally, a
> spin lock is added for enabling and disabling operations on the xsk pool.
> 
> The performance testing was performed on a Intel E5-2620 2.40GHz machine.
> Traffic were generated/send through TUN(testpmd txonly with AF_XDP)
> to VM (testpmd rxonly in guest).
> 
> +------+---------+---------+---------+
> |      |   copy  |zero-copy| speedup |
> +------+---------+---------+---------+
> | UDP  |   Mpps  |   Mpps  |    %    |
> | 64   |   2.5   |   4.0   |   60%   |
> | 512  |   2.1   |   3.6   |   71%   |
> | 1024 |   1.9   |   3.3   |   73%   |
> +------+---------+---------+---------+
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/net/tun.c      | 177 +++++++++++++++++++++++++++++++++++++++--
>  drivers/vhost/net.c    |   4 +
>  include/linux/if_tun.h |  32 ++++++++
>  3 files changed, 208 insertions(+), 5 deletions(-)
> 

