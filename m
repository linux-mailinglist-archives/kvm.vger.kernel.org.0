Return-Path: <kvm+bounces-12343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80806881A8D
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 02:07:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 920C61C20F3C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 01:07:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29901C17;
	Thu, 21 Mar 2024 01:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DbIJ2R+3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A20217D2;
	Thu, 21 Mar 2024 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710983230; cv=fail; b=BXj1sZToKa/pSz35Y1fITanjf9SQh+so+JvqRM/sLnqYKY7554InPEACxsFI/D/cQyhUnPsmzdl3r3xXPNUZRsB7mF08d68Sc/pQ3+ZhhkkIVOjy4U2454XY9+WKBqXKC/CAFYEuYUc8xJh2vsy1wbdjUo6T3ZI8Ruht/ACm2JE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710983230; c=relaxed/simple;
	bh=oQw2BBX0S4I0OTvc4+dwuJRX9cTT24ZFEDHCBYs78Wg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cdhq6mxICESCnrJzmuX0UGSR0V1ifM1dMhSFB6jphOebd+zj9t0+WSPDOphOrWu3VXR3uCCVSw/QXTLPatD7oe36wv4zsIgYOiq7xP/cPmbOH+l5BbP2fWEKEo8nTgzyOLVs5DM6aTBoUbz5j0kkRAereSmPXBP8XGJEZQOzUL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DbIJ2R+3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710983228; x=1742519228;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oQw2BBX0S4I0OTvc4+dwuJRX9cTT24ZFEDHCBYs78Wg=;
  b=DbIJ2R+3pS6Sz50Msu1gd/+alP8J3Ohoa8STc5gW41al9X3rcIPLFfhx
   IqhoqUAbuPPNuwdsd0arST4Twki2suZuMdBAcmE0Gq62+oQx4awXdZ8n3
   UX56V+fomNUazom8klxwcF7WYMAL5XLU9MBT2Q0O1oHANeb1d8Q2mv/8A
   RfJcWHCRalwQR1EgOeCN4vG3SeuescMnPajyFMLqX7QeKhFI76RzzdlQb
   +QWaoSkboEtYMNryWry0c6P955NuLGw+kPgDpIrXhPkRZpkG6g8qhGlx4
   Qzmyx5Q3UwWV1zjX0quXy+AXI7GxOjvxpUEtsZnYhOruMLB9/njUIHNeD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="16679997"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="16679997"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 18:07:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="18814501"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 18:07:08 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 18:07:07 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 18:07:07 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 18:07:07 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 18:07:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IVcuMuZz1G7t7OMqYilASlKJkTK1rR0ZKAbrFN7nkHZXpqgfj15DlsniIBe966SNw+QK7cBOlKiD1X4uwo50mfCe/jXMMmMIjbJhRx0dSINQ/2SINZk3IYTDUM1HLbCpB/E4xzNRoES+V6Ddps8AcjFLEISGgQhEryBVgdKitd2XMRKdzVIs7DXYZA46zGkU5K//hTm91PACylN/F1xKzpV5MKYuE40EVsV6N5woULNW60f3qQbCZlIBXQ1cQjA4omVKqJbTDggpzzeWXrL7qXNbi50wyFFthOXDwghxkKHy4NaL9gJ5FECrS+6yVWA63aSG3esyoGQKJ74KXba+Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4xYz9TQde4rtYK8u9K0ldZQFtveO2WtK36ZjuTySAo=;
 b=TxSsOwzvyO5jeau6db81J3zLVCi8GfriQwjXG5O/uKpAvEF1elZvxeS1J0L1S2Z6oyXlbq/ImtDYSJsF7djYFNhzQFV51HT/I8tmQ8LmyIX9DKLHLSrBRKma+2E3mDD53M1Ui8/UNo4WTDGf3ilf/boobijtvFSizedD/iYVYxJXwOxet06/idO3yw8052I5tV7uJDly9O4abROz2jCVEuterDlJunU1OoJLClhv0qZvOj59lTJCD+o/bxqWB+zOX2B94P2u/8GPrBKqqURtyC1bwnBatPdQrCCT6PHWGbHgOImDTdmFeaIXLC2TndpCpv66cxMIVoYcrys+OJCpXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB8245.namprd11.prod.outlook.com (2603:10b6:208:448::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Thu, 21 Mar
 2024 01:06:58 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 01:06:58 +0000
Date: Thu, 21 Mar 2024 09:06:46 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 041/130] KVM: TDX: Refuse to unplug the last cpu on
 the package
Message-ID: <ZfuIJpHzp4sEjCi/@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <15d4d08cf1fe16777f8f8d84ee940e41afbad406.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <15d4d08cf1fe16777f8f8d84ee940e41afbad406.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:194::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: 950399c2-81ed-47cc-e0e5-08dc494334d9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zCV/0jwx1kmC82aWz6odao9F8M6T+dHhAtRckbYIgVLGJXDvSMDlITt5WJSjKBGXrHr5GHn9PEbwbb0k9QwWJdIQ38IRY+NmLph6pEGIELtNHbIxGmwzfeVCyo5pc+IZFPoX6QvENf4tCqjTlvZg5bvhQsRbdJxR49M4qs+SzUCrdNKxVtrJXCUVNvIZwStix2VihQNBHs7A/EGwQ7NpZebDy/bjft4kRgsfxCKSaN7+8xxeV4DJumdPIpnLRTO/M2BzHoXnnK11alKRCiIFGcbKQ8qpEGKE9b3J5jPpmaliE9bfwy4h2Rn+LTmXQVpJtN4BYUo5VGLgedvp8jE12nUjAHbgrwO7LIxrAUFWQW2JXSsxdgWPRKBQqKYG2ilT72ufd6EDEHfhgKPv5YPSRrZbdnqmrE1RxPuRubEApAATA07A4jtd/mScvayT/A5dsZpVMAMFd+n39g8HXlnW8VjuwBl09uRHExjgNDD6q722ARwb+VJlfrPKGl7LAjFmCOonYeweyBrJc5nsNfjGwokcMgGbA7JshCiYU+IjHR/qxfXDKz4XZIK7Um5sOeDvZe5FzKjth6ZfxqkZl/m4zLgovGkG+KnpIbB8zTUtYQ1ZU2mUJDVd8SB9gV4QylmbrwTR4JP9E5ywvGgOvNStiuMMspKKM3W79yp1YLPByE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C3cP+J5ECp/LwcbUgInu6OgjXehekQR968utbSLjZwe4vzgdRFVfk8qThMLT?=
 =?us-ascii?Q?9Ow173I7AJjyVasnxH+iFskG4P8tB3pq95oR6sPqlneUtsG9oD8NRDtEr9u7?=
 =?us-ascii?Q?i7rOJz/PD5sLtYwg7ENHKRltggpuecoPBXlAm36bMiUOKeRKaWgfgi8y1uaa?=
 =?us-ascii?Q?uFFJEyD5ze30LYm6QrRpKLTAPvkwEksFkBn57sxHwpcmCRO/2qyE6IjSSXUX?=
 =?us-ascii?Q?s/LlOc+qNjVVLBqYRrAP7c/Sn/HmGn3ASPcjwfO7BszX9S3EZWFe5F1hYuoP?=
 =?us-ascii?Q?67P9xFZdKu8WeJ+Sf+v9/HGedKY/ht+kPr/kLWRoKT+JUXBliUWkKvO6RuJb?=
 =?us-ascii?Q?uoBmKpPeZObqtHbj7620lel5/LKkmseGbyHnNfZKonVtbeaPpHo0JSNzxq1N?=
 =?us-ascii?Q?UHYCAngqlti4EukweWBQiOBGG40X9xrJ8PnqKjyuH7r62bWws0a0wkry+MRH?=
 =?us-ascii?Q?aX+ItnL0Rkkj3laNj2G9xx1gnfis9abdwb03vzFI5iQPShhE+PUtG68Y9I38?=
 =?us-ascii?Q?DKVwFDofLbEsZJ5N14dOeaCoPuDcFfqBnXbtvZ3lGChyPOjxtwZOX8RA1wJj?=
 =?us-ascii?Q?spBbPnbrT9pHMcuyeH3OhvwVRx6GOMnGfjLI8JXuh00MC1n2LSaXnP932Ll/?=
 =?us-ascii?Q?7cVQXWM6h18Ce6Xmilb+PVNXIJVbK/6un3UDYpnmhgI8lYeFvvMwq7bh7x82?=
 =?us-ascii?Q?/uN9zhWiL0Cc70uEHQLk64xU+BQC4fJWoY1Nk3f8X8VJof40fyvHV4b43ZHR?=
 =?us-ascii?Q?4cZaePfXaau5IIz+Mxjm2NDkMex00ZNDPYrnLXS2q/aDYrv7xXLc6UM7lNmU?=
 =?us-ascii?Q?eTJ63120+5N67Qf1WBwtjJ7rhqPgV4ckxXNC04n/GwKJWSxUtGBPJ1h86IwX?=
 =?us-ascii?Q?ZoatyiE7nMg5Lr5jkavCH6rQ5+HlVg6pasgRIgzd83OTTK5tC3YLbAhxfi9s?=
 =?us-ascii?Q?uQohbnoRAZtPdvw5WEHQPQR2Z7ttNhBZZWtrhzA0e4BtlUxbieuDiub6XbXG?=
 =?us-ascii?Q?b1yteSadVyZNbfc8a7FqxBo2Sc8b8FBMck0zPwGedCltgzRW/wzQohSGwysh?=
 =?us-ascii?Q?8Te+nSPQVGGx6qc5h6fT+YeWr31YQ/TqljeqXuZrs6UoNAslW7iiqk/Ialb8?=
 =?us-ascii?Q?eop1rKDhQnwe8q5r1JWvzFq/OylPwV+fKt93Dl6f/LfVkT2rOHVdYzbp1hb4?=
 =?us-ascii?Q?7Idc8x7mLkfnZ64YSX9dGkvs6+W/CIX2AD6H8ir1QxLqqdrV8fIstSr0vnL0?=
 =?us-ascii?Q?wyQ/EOQqTRyaHjHsXHe/fwf76v6EEcNn9Pq11ahSOyiXfNBffazlQ+ve3Eh4?=
 =?us-ascii?Q?GDGJy7OfHAOREUxdFgvx1GdpkijEeQcflZ91/SK5AucsEo4qinsaeaztJpHs?=
 =?us-ascii?Q?1oRdvEdlX1Ac+PLEFurabkxU/Y56HqCt+P7dkL1BguDLS1RaRsGI8k1ligiJ?=
 =?us-ascii?Q?OPsuDspPAlJuYSl3ucPoa7K1X4lRHn8b+F+hwwpNRDy9B3L61Rze+fNs51uE?=
 =?us-ascii?Q?UzfaCvTgjLunWqSr9vAIEBD+f+pJLNYNEEvJ4i06Pz+IIk2ia8VufAjoLgck?=
 =?us-ascii?Q?lZTx3K2dgeflwAAf/0Sb5bAlNSfNbCKvdMBD74xg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 950399c2-81ed-47cc-e0e5-08dc494334d9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 01:06:58.2760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z32i2lvNJXI1wtI4jRsK0rhO3CgT/uDUiG+zwXrEkF+QkXRkTgr2cBndwrbVHGmyT5+pNbV39J18DLBcgkC+bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8245
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
>index 437c6d5e802e..d69dd474775b 100644
>--- a/arch/x86/kvm/vmx/main.c
>+++ b/arch/x86/kvm/vmx/main.c
>@@ -110,6 +110,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> 	.check_processor_compatibility = vmx_check_processor_compat,
> 
> 	.hardware_unsetup = vt_hardware_unsetup,
>+	.offline_cpu = tdx_offline_cpu,
> 
> 	/* TDX cpu enablement is done by tdx_hardware_setup(). */
> 	.hardware_enable = vmx_hardware_enable,
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index b11f105db3cd..f2ee5abac14e 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -97,6 +97,7 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
>  */
> static DEFINE_MUTEX(tdx_lock);
> static struct mutex *tdx_mng_key_config_lock;
>+static atomic_t nr_configured_hkid;
> 
> static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
> {
>@@ -112,6 +113,7 @@ static inline void tdx_hkid_free(struct kvm_tdx *kvm_tdx)
> {
> 	tdx_guest_keyid_free(kvm_tdx->hkid);
> 	kvm_tdx->hkid = -1;
>+	atomic_dec(&nr_configured_hkid);

I may think it is better to extend IDA infrastructure e.g., add an API to check if
any ID is allocated for a given range. No strong opinion on this.

> }
> 
> static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
>@@ -586,6 +588,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
> 	if (ret < 0)
> 		return ret;
> 	kvm_tdx->hkid = ret;
>+	atomic_inc(&nr_configured_hkid);
> 
> 	va = __get_free_page(GFP_KERNEL_ACCOUNT);
> 	if (!va)
>@@ -1071,3 +1074,41 @@ void tdx_hardware_unsetup(void)
> 	kfree(tdx_info);
> 	kfree(tdx_mng_key_config_lock);
> }
>+
>+int tdx_offline_cpu(void)
>+{
>+	int curr_cpu = smp_processor_id();
>+	cpumask_var_t packages;
>+	int ret = 0;
>+	int i;
>+
>+	/* No TD is running.  Allow any cpu to be offline. */
>+	if (!atomic_read(&nr_configured_hkid))
>+		return 0;
>+
>+	/*
>+	 * In order to reclaim TDX HKID, (i.e. when deleting guest TD), need to
>+	 * call TDH.PHYMEM.PAGE.WBINVD on all packages to program all memory
>+	 * controller with pconfig.  If we have active TDX HKID, refuse to
>+	 * offline the last online cpu.
>+	 */
>+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
>+		return -ENOMEM;
>+	for_each_online_cpu(i) {
>+		if (i != curr_cpu)
>+			cpumask_set_cpu(topology_physical_package_id(i), packages);
>+	}

Just check if any other CPU is in the same package of the one about to go
offline. This would obviate the need for the cpumask and allow us to break once
one cpu in the same package is found.

>+	/* Check if this cpu is the last online cpu of this package. */
>+	if (!cpumask_test_cpu(topology_physical_package_id(curr_cpu), packages))
>+		ret = -EBUSY;
>+	free_cpumask_var(packages);
>+	if (ret)
>+		/*
>+		 * Because it's hard for human operator to understand the
>+		 * reason, warn it.
>+		 */
>+#define MSG_ALLPKG_ONLINE \
>+	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
>+		pr_warn_ratelimited(MSG_ALLPKG_ONLINE);
>+	return ret;
>+}

