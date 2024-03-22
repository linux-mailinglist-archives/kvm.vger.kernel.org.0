Return-Path: <kvm+bounces-12473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F264388676A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 08:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FA0AB22201
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 07:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A80A15EA2;
	Fri, 22 Mar 2024 07:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XyPsGQrJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504E1426C;
	Fri, 22 Mar 2024 07:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711091942; cv=fail; b=fmUD9NZxiji8JwDEVc0AE8I0gqjDxUgjBq9a8j3PYPH1X5N2H35Qu0pha4LaFF8BaqsJr2OUUb3w+Pirsu/m5PQPaxwHoGsEDJlOpQfmt6Vi4w1KX3RmjNGR63wVv7w2DxC/cICQq5OFvrSayeSBM2QwWjHqHrgF6LfEib5g9D8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711091942; c=relaxed/simple;
	bh=/9XPc5m6ZPkv2Tq2BrknWf5XSJdqFya8zxz2KrQwZKI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DPTZ4sS4IZ2J61C7yFlLQEr5b0JHZZSL1pqHDDMiR8OmH9waFZCtjkMEHAdeecv4kxrFyIbgs976xZdVLXzIL9q0ssU5XSaPZGs94Ibq79JneAP1WBomTSfEuhU6mA5gqNhc2878rAKkIxaopY7/QFGaDzl2UDQ43naE+YbUZI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XyPsGQrJ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711091941; x=1742627941;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/9XPc5m6ZPkv2Tq2BrknWf5XSJdqFya8zxz2KrQwZKI=;
  b=XyPsGQrJd+ppQMqJY7VB38rLZ9Xe7ErXjMRIPz+ek+CTGAZUACxxEUun
   zhAmnpKMFBT8jmvLV1vzkJlPlgFv6CS0K9AeAagWgMhlqZGCDvw8eWCso
   954EuEVDRk0a4l/TAIsBqQD/NIprN2YHh8mxRY6DTZ5cjfXPFqfAe3zCJ
   ptOPh8f62qiZszUy1Ppph23lmqW5Y+8k++rxp8xfHmG8i6mP0qCJfzIhU
   VJC76PnPzHPGTyHMgMXabXvwfWOOGcXEBQie6VSoI50I+PfGvQCTY7U45
   zhIZy2c9jPYC0slhOdCquG48BtWfFpqJYtYCj/LglAh8vLPOBKXZAO+4G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6062513"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="6062513"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 00:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="45916223"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 00:18:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 00:18:58 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 00:18:58 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 00:18:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zg9TqddTO12DRaAcyoNvBNDuQtzR3iIIFJPdeMB6e7Gqkcb8CQGxtHiNMegq3fhbfH9DF3qBTnjACfMiHWLYJx8EUT85LhgYjNp5MEv0PeaQVPz6FD+6KVQp5hRcZrLp/0T1OqAXHAhpOfJgChNO4CaXu1gEF37/Zo0WZQ0AXaFcsodDve9AlaDMjWoZdkxuyGis8RwDkinhjHg2D4doDaZPkG7WQYIwxjAwN121u6+PujPTfcorqigTG46HDHPN22nPlxUqYP3x0aLHoxLKZm7c2Hf5BDwGwTT164W2dXOIAHy82063GS8MpmY0+hNJkDggK7jIdyvDaA6aJG8cTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6c4GHkeKD48At6H9rVfdAx8lQTuqFZDLAk3cny/BGnQ=;
 b=NygMk1yurAThmebkGuyWoQdb21WZT4lj8lqZ+pnqaGPQhpfzNKvMAzqUV3l3zZWGWa6UC6DwTow+aUUW1c3RI4qSqIamfMCbLT7IbPBIPVMEcohLkXiZN18BWqKLG6/OLygR3A3+gplhMGXPVfQ1qKHAmp3sEEo/jspLy5fGJLKSZS4+rW+QVuOBWNgBjjx88eMmqiDZSsvrbsVHweFUseKsyJVoUSM7hMVsCZubh/pv2GDxq0RdjuuS7zkYCp9ZLVUZccKpi/GxmQGk9clwtXoao+UPbXoJIrdNt87oROSj+BIT4/XkzlcGuZhz2SP9KhkFj8HsQ/3L9kyAg84fxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB5177.namprd11.prod.outlook.com (2603:10b6:806:11c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Fri, 22 Mar
 2024 07:18:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.023; Fri, 22 Mar 2024
 07:18:50 +0000
Date: Fri, 22 Mar 2024 15:18:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Message-ID: <Zf0wz82nQoL0VsAd@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
 <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
 <20240321212412.GR1994522@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240321212412.GR1994522@ls.amr.corp.intel.com>
X-ClientProxiedBy: SI2PR01CA0034.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: 82e23e5d-8e22-4bd2-d867-08dc4a405280
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y52zIXxtOhNhOQnlC5fGfNjHHJw1qKNHgh+mc6vY6ctTmuQVuK4+6eMaLxRXTvaic4W1tB3DSQI2Lrtitj6r1asnBXMw1ZNfDoVo6duLl3DieUqK+yGk9hTq/FvpFvIH7qvFbfgNFH984RIJDl5qA7OJOsNhOm/c/5sxZ8GAlZupekBPcu7Bl5+3S/WJnpbXUN1yhXJlaBte7aR9qaUNpNjcqdNJMmbqFA6R7seXNO9N9JvwxVaM2AMlIRQFYGNcU/TZZ5WDK/+nWa+Bx1ELFi1Hm2Xy4u2wmDOY8TlRc5AVzz9ciUYsxCq6p+taH1xlnGNo7gsivLAxSyh9eZXb7ebQ8O3ifMxAfNtU6S2Q9oNhw2UHFVWVIerUDhdQ4hyne2FjGqo3Dw7KKtWooPYtIY4d6NNhAz3xmKE2fpLjirOOAOe/PF3DU+7JEAh9QMr+jJnhAj9d0T/EaQH8W5OfDifnBXVGVp0QnIFOzhROISeNnV/sK/0pde4/HsSKyMDA9SKikKGgfY7jEr87fyhVrJzxa3JNBg25i5iqZYjCJ0BBHQKAbP6MXslhDE34yNza9GTRDNceDUICyh3yAAybh/Oi1lyhW03MUIhOcrwmHNI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXlXQ1Q4RzczNGZaRWo2WTJmdTk5cmV3bGFIYXhwdVRtUU43dTQyL09DVzRD?=
 =?utf-8?B?ZnRPUEhZaGlPOU5pSjNhZ2tvQW1UL3Z1eG1zME13NmRLR2RxMVVCbHljRGww?=
 =?utf-8?B?Ykw2blNTSWZGamlWSmVBUkhWRnFqTHh5ZVlKNTBWNjJ1SHlNVmdNWTBuanR3?=
 =?utf-8?B?RlkxRXJ2MFN0YkdIWWZ6dWFlenhuTUorVFJQSGJlR1ZmZThJTmlHMHRsL1dX?=
 =?utf-8?B?aUo0eEo4OXpsNG1zcXVTU0YwSXhxbysrOCtobGxld0JrbVZ4dzB4Z2V1V2JQ?=
 =?utf-8?B?dHhYaElsY3VnSXNyNHpDeGJ0N21FeHcrYnJORDdsb3RSQlVBUVdMS3JzRGhp?=
 =?utf-8?B?VStLUjN5R25hWkcxZVdNUE9SYXJNNUVGVVQxdnVvRGVkdEN5ZVlXeGFwU2RC?=
 =?utf-8?B?YVJsVnJhYmJmQkI0ZHhJSkkxOWxYNWp5MUlpdkRLK3NxaUZGTzZiSVJFZmpS?=
 =?utf-8?B?SXpFNmZ3TUd6OURJVnE2Y0kwekM4elFRL1Zmd1QvV2dQUE1FWE5Ba2dzZ1J5?=
 =?utf-8?B?MXhMUzJYSHRESml3RlB3cGFPS01RVWdmRFl4UEk2MGxITUVIRktkQ2Y0MTYx?=
 =?utf-8?B?SFYybEFMdnlMWUsyajdQTUdwU0hmYUMxNlBFQ2wvakRyUEdCcUJtOGU0YkZQ?=
 =?utf-8?B?eHhPYnczckw4OUVyVFpQMGlFWkE5bUhaWGdLZUo5SHJ0aFBmaG9RUW1sWWxH?=
 =?utf-8?B?OGpzWjA1WExLK1VRMkp4VlhNV0lPNWFoZ0hsL2o3blBGTE5ZaW5YN1RaZ3ZG?=
 =?utf-8?B?aUxDU2o5NHNTcVdXV3FTU3lobDBYMjF2d3NybEF6bTdUUUJIb2VManBzRllW?=
 =?utf-8?B?ZjE0dDFSS0JrZXI0MGdnd3pBb2NlUDBiSWE0RkFzU2g2cG9CeFc4d3BVRTJy?=
 =?utf-8?B?R2dNVm01T3M0M3M4ZXJwd1pQTGJRaXVrYWZsbTZQUlo1ZVQ2V0wrYW9sY0lL?=
 =?utf-8?B?VWZqVFRQQkZnV3VQYTkyajNxK0VmeVlLaEl4MlhjUzRaS2d6ak1yMFBXZUFW?=
 =?utf-8?B?OG1vdkVPVkpyNHhYcmEvVDFVMlpGOHhBekxobmd2c25NcU53U3BPRTk0bG9w?=
 =?utf-8?B?YUFWSkxJS3RyaW40bmtyNmhsZWlBVmZ0bVIzOVJ0RTI2UVdTWDVNWS9ZSitC?=
 =?utf-8?B?MWJRYlB0Wll1L29LMjhMazJQRkd1T0VySkg2Unk2M0pON0tGekJ4N3pkbzVo?=
 =?utf-8?B?WUl0cWJjenNEYmZSb0NPUW5UV0IvbitHNnJkbTgwcCtIdGx4TlFuTHZsSE1H?=
 =?utf-8?B?MjhmS1ArR2tPblpJd0loOFl1ZW5RclhJYnFTSEVCZ2dsL3ptSjlJWm82OEJu?=
 =?utf-8?B?VENvTjE4ZWNRbmJBbWJiOHlmVzVMUWxoalE5cXJWK3hpSDdaVUt6QVNLd0Zi?=
 =?utf-8?B?eDYyVjZMbFROTHQyVlRaaVRvQjZ5ZmNXbU9mOG1OUWU1ZSt0RHNQWVJlOU1I?=
 =?utf-8?B?c1NOQmdLeG9JTGo5dEo0ZEZnaGpDYVRFQ3FmMlFGeWVDcHUvUGNmcHkvZy9W?=
 =?utf-8?B?Y2hoTEJrSU91NklJMHJvZkxYUkZwVjJGcjRYT1VzUXhhWUtNeXhBSU52Qi9j?=
 =?utf-8?B?ZkR6Wm9vOXhuUlJkbzZaN1dST092dXlXeXlPSnNzRHFMTzR3K3VOdkdzeGhm?=
 =?utf-8?B?RVdTTGJibnZkZk9FcTNxaEx6ZU0zRkdZM1ViVjR0bGpJWVZUQVhUMmh0Rmhh?=
 =?utf-8?B?WWpxOXVBUmlSWU81MWNnTFJDS3FJU0N2bmFvNkt3MWd2aDhZTWZmMVUyTXd1?=
 =?utf-8?B?eFBxQjc1amRja2pNY3paR3NWT1RVTHNod2lCVldhUFkzYXZIdm1ZbzBGSDcr?=
 =?utf-8?B?b01jNDBuMzNPWjF0RW95SnNGb0xjVm9wUW1NN1N2aDNGZnRmSG1PWFdab3gy?=
 =?utf-8?B?SkJXTDNiVW9XajFDMDdGeTRWUlkyL3FTcUdTeGsrT0pQVmg5K21JR3BXWnRn?=
 =?utf-8?B?QTlxdmFuN2FvSFo2Q2FjU21VS2tyV3BpckVpSC9YOERtVHlPTW1VQWVSenBz?=
 =?utf-8?B?Rm1XRi9OUEZFR1pYN2dGK1l1WU9XeENhNXFwZXpaNGdOeFpyS3BSaDJGNmM4?=
 =?utf-8?B?eGpCc3JzdytrakY0UXBxaC9DVFFpeVlDUUNsUVFWdFpkaS9UdGVFR3JMdEls?=
 =?utf-8?Q?f9ite0SSc2YqofQwn0aDKAh3l?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e23e5d-8e22-4bd2-d867-08dc4a405280
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2024 07:18:50.6101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JmCIwZBROc8DL9p/c+IT8n2TZfQ3bG/241Ui4FMGRsoqOAG9MGWaxrOV5+JujZxOj2sTLrx3+FuNxNULJHhWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5177
X-OriginatorOrg: intel.com

On Thu, Mar 21, 2024 at 02:24:12PM -0700, Isaku Yamahata wrote:
>On Thu, Mar 21, 2024 at 12:11:11AM +0000,
>"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
>
>> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
>> > To handle private page tables, argument of is_private needs to be
>> > passed
>> > down.  Given that already page level is passed down, it would be
>> > cumbersome
>> > to add one more parameter about sp. Instead replace the level
>> > argument with
>> > union kvm_mmu_page_role.  Thus the number of argument won't be
>> > increased
>> > and more info about sp can be passed down.
>> > 
>> > For private sp, secure page table will be also allocated in addition
>> > to
>> > struct kvm_mmu_page and page table (spt member).  The allocation
>> > functions
>> > (tdp_mmu_alloc_sp() and __tdp_mmu_alloc_sp_for_split()) need to know
>> > if the
>> > allocation is for the conventional page table or private page table. 
>> > Pass
>> > union kvm_mmu_role to those functions and initialize role member of
>> > struct
>> > kvm_mmu_page.
>> 
>> tdp_mmu_alloc_sp() is only called in two places. One for the root, and
>> one for the mid-level tables.
>> 
>> In later patches when the kvm_mmu_alloc_private_spt() part is added,
>> the root case doesn't need anything done. So the code has to take
>> special care in tdp_mmu_alloc_sp() to avoid doing anything for the
>> root.
>> 
>> It only needs to do the special private spt allocation in non-root
>> case. If we open code that case, I think maybe we could drop this
>> patch, like the below.
>> 
>> The benefits are to drop this patch (which looks to already be part of
>> Paolo's series), and simplify "KVM: x86/mmu: Add a private pointer to
>> struct kvm_mmu_page". I'm not sure though, what do you think? Only
>> build tested.
>
>Makes sense.  Until v18, it had config to disable private mmu part at
>compile time.  Those functions have #ifdef in mmu_internal.h.  v19
>dropped the config for the feedback.
>  https://lore.kernel.org/kvm/Zcrarct88veirZx7@google.com/
>
>After looking at mmu_internal.h, I think the following three function could be
>open coded.
>kvm_mmu_private_spt(), kvm_mmu_init_private_spt(), kvm_mmu_alloc_private_spt(),
>and kvm_mmu_free_private_spt().

It took me a few minutes to figure out why the mirror root page doesn't need
a private_spt.

Per TDX module spec:

  Secure EPT’s root page (EPML4 or EPML5, depending on whether the host VMM uses
  4-level or 5-level EPT) does not need to be explicitly added. It is created
  during TD initialization (TDH.MNG.INIT) and is stored as part of TDCS.

I suggest adding the above as a comment somewhere even if we decide to open-code
kvm_mmu_alloc_private_spt().

IMO, some TDX details bleed into KVM MMU regardless of whether we open-code
kvm_mmu_alloc_private_spt() or not. This isn't good though I cannot think of
a better solution.

