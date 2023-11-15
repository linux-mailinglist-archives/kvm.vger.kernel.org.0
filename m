Return-Path: <kvm+bounces-1799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C3CB7EBE2D
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3DA30B20BC7
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336054683;
	Wed, 15 Nov 2023 07:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UCSQ4lYZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A71E3D6E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:35:31 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F40C1;
	Tue, 14 Nov 2023 23:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700033729; x=1731569729;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lJsGB6VDLhEbp10C0MA9U+8AvXut1iDz33z3m5insvo=;
  b=UCSQ4lYZEEKrt2tzc87ldC2A8YlOCk02UF9u0YkfTwugFx5iJrYZ0h0/
   /BjNEOC2GBsEcRYTYjyhFTPxscfHnT4meNZy3TKOaf/zbND5lzdVTL+LP
   DEE+dYXJm17fQIRxodad5Dg5sHYaEiO2ctr9mughidymfRGGxe32ZfyG8
   kXO8Wh4D244tqC2PBoVOkJ7SCPGEVPe254XsKGpZa7KLlh1Z9XbL5Nd3y
   QkzbLT8B/tWv2Rej4fZfBz8316nuPPM7tEGscLeTjaEq/ajtX9gjteuFS
   kgDRZsX/UyacPcPcRZpLsVAh7sQlTux+zeQlpkZiQrqE7OQUDxdiXqu2x
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="375864979"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="375864979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:35:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="830869827"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="830869827"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 23:35:28 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 23:35:27 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 23:35:26 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 23:35:26 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 23:35:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogVrEZxYDCWzP+roUk+cfjv2LBbDZEIABUMex2u0fXzlizzimT78Sq0c+hrBNid7zzU24y5mghWY3Jo3KYN9dd9TjS0pwhOOPfKf1oIEaZm0gNBIdoReTN9qplQ5fpQf7lS2LIlFC6glE0w4eZ4eTbzTr+yrFdwFEt1DHLAAz1eUQoLSaX7+/56L9pQKW8PnJpcbQ8l2qFMuskOdn//62uSha0+7EaytA+3qRJ8YqpdqBlwGiLGRBdgZrNEM4DHFWMOQSyeD4i3+Jf/KuyBknDEFRkwj27GGHEM95TTatnARbgDmVBfZO2pJ7IZN6OU7GWcq7ANKoIKt6S27/F+SMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUb4hmyy1qZvSzXCS5TKCoWCuiNCs7X0+3WgUNFm73E=;
 b=YACc4VWrgSLSwkrDOLidDL4fwDc5Wj8/2J5tKPfTXLvn7codzdBtWB55dhjIko0CeDlNhCFrza42XwXrIYqqhTznkwK6wtPpKNxnZpAx+gUGc+X2JI3ALwWRyxFwfJ6Uh2RuRk5Ra1GL/vk29xdXznbn9gyvUc3EiATtK+WRWpK7ogkzPbEe/izHYf4OmV4QSWgLHxgrkOzJbvO7NRAmsX8MDrgB2C6O8JZ3zhT9MVPKWJnFMZ315N1wkJpHLAXZcWYkbEsIuXrGo5lRZ1hIzY93KMwhwMNJyfhNiDkxVKxfHt8gKj/gfCPUQCmINqDh+eoL7fGs+Vl/3vETIJf8Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5052.namprd11.prod.outlook.com (2603:10b6:806:fa::15)
 by SA1PR11MB8573.namprd11.prod.outlook.com (2603:10b6:806:3ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.17; Wed, 15 Nov
 2023 07:35:24 +0000
Received: from SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::ab78:a7f1:1e3d:626c]) by SA2PR11MB5052.namprd11.prod.outlook.com
 ([fe80::ab78:a7f1:1e3d:626c%6]) with mapi id 15.20.6977.029; Wed, 15 Nov 2023
 07:35:23 +0000
Message-ID: <35cd1aad-87b6-4606-9811-ab56530cf896@intel.com>
Date: Wed, 15 Nov 2023 15:35:11 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 015/116] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
To: <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, David Matlack <dmatlack@google.com>, Kai Huang
	<kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
	<chen.bo@intel.com>, <hang.yuan@intel.com>, <tina.zhang@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
 <69281f4f2e4d2c3c906518d83bc6ec9c0debda16.1699368322.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <69281f4f2e4d2c3c906518d83bc6ec9c0debda16.1699368322.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:194::16) To SA2PR11MB5052.namprd11.prod.outlook.com
 (2603:10b6:806:fa::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR11MB5052:EE_|SA1PR11MB8573:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b285f70-6cff-4ed1-0398-08dbe5ad6ce1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3eu376nwKLVy8r+UOxv5SSr8ahvpz/c0U0u+9AlJ5TqmRXGeolcitb2yVTqRyKUFjyHV3lL2PylfSQjXo9U9J2kBgJjNZwc2dcAg4B+voFb57Nvg+JnHllTjQq+8+w20O/grbPW7VV4UZ/KY4qb1EVYYRCs6izZHELYcRE2lx8ugA0KYtlZ4DiEB+Rsa2viImmyADkLRupY8FVfY4W3Fvdm5MwLatPamwFUzQSC32aDpbU7uD7s6UJwHe8bDUL6/J85g/lkUsVAPdtge0kaU9VuvfMzfJHnClRmfNXwDMP6KUlyaS/qpVGlgR1Yx1hug6evRAzct4/WOo/7SPjn5bfXiasrItnpr6SZw7BLqsWjnz+slcJJ4w78s234C0mMMJ/uuDHFOXchXpiadWVDQEYBKFCMtXXuuBvtQpyyRXQo7jrODdnMrkaaFyRcMvCi2dvTTUdCAXqQuM4uwl1qsopWrzAR8vdxLUmqkirdtFH8e4ttxm49gO8uz5J36xl1BeKPtwpgeuVlLBbkOGJV1ixMfqO8AFZ4RVJST2Tpobqu1bw6fbXxT8tUVkIbotw99qOQTgMOc2cWjoU+7/4mvnj3RkJ8BYIYnYu6CPMEdqa5nRqA8FoJpeN8MKWTG68hReOfZWJHM9raZ/QBE3O5Jw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(366004)(396003)(136003)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(966005)(6486002)(54906003)(66556008)(66476007)(66946007)(107886003)(5660300002)(478600001)(316002)(8936002)(8676002)(4326008)(31686004)(6666004)(6506007)(6512007)(44832011)(41300700001)(31696002)(86362001)(82960400001)(83380400001)(2616005)(36756003)(53546011)(38100700002)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1BNakpLdk96NVZoZXFnT014Y1BzeVQvb1d6TUxFSEVKWVNVbzh1dzV3aE9N?=
 =?utf-8?B?aW56c20wa1ZCMHkzeEQ4VWdmTExYYVFKU0dyckZTUWxoeVdCNWxucXYrVWlq?=
 =?utf-8?B?cGlTN3JoQUx2bDhtTjl2YkNmNmpTYWZaYTJQTXV5MWdMa2I4VnhCMWliRGk0?=
 =?utf-8?B?bjVxcjQ3OWJrUnhnaWxuZTVpSi83V3Y3UTlKbG9oR3dQcWVIU2x3aWU3bjVn?=
 =?utf-8?B?Vm91V0pIMzFXKzdDTHF2NWI2TzZNZG82RkhZazVlbU5jR1JRSFVlNDBiV2Zp?=
 =?utf-8?B?QTgrQXB3aytZVmE4NnhHQklkNkVEUlNoNDJob240WkNPdGtPQ0hDNTZvYXZ6?=
 =?utf-8?B?MGdURDJUbUN0bmVKWExIQ2VqNGhRSnpuSkc1TGhUdTJRR2dUaXY2WjdLODcv?=
 =?utf-8?B?QW1VcGlQUllSeXJFOWlCS3lJWHk3Sml4Tk94WlpqdU9mK3VNbldtQ00yYUhU?=
 =?utf-8?B?VFUwY1daYkliUkRIQ2twdDNzdi8rbE02eUo4TGxCMVNsUE5WOSt1WDZmdHZK?=
 =?utf-8?B?Mmpqeno1OVVFQzBlM09EUmEyVHdoaGgvamdMajkwczN3ZVVYYUIrZWZ1cE5z?=
 =?utf-8?B?ZnJrWmJsQURwRDZtdjgxN1FoZ1RwZFNVM1BBb2JWUGxTeVBiT1FsS1pIVndt?=
 =?utf-8?B?dFdlbjUva1VHN3ZzcmIwQXd1NjR0amNtVkRLQWNTOW1MUkxsbEtURFZrTEE3?=
 =?utf-8?B?THNKTlUrbExZS3orb0lNSTlnYno2UmhXbnpLWkM3c3hPcHBOQmlkSEhsVW1L?=
 =?utf-8?B?ZlZQT243cEgwRlgycmFGU0FtT1NQV1lubVQxZDJWb1plMXRWVS9OYi92M0ox?=
 =?utf-8?B?d2h2KysyVVlqdDVDWlU4ZURoUzNJbmlEOHdZYkxadDdVdGxrVEh3QW8vWTRT?=
 =?utf-8?B?RHNPMk9QZ3V0YXJrQU5sWEJRT0hvM2s1V0p6Uk1NM1puRjVjV3UvbmhCaG5S?=
 =?utf-8?B?cTRNTGExOU5iU3JEYkliNnI3cFFldjZHa0xpaDF6YUtBK1AwNmlxbWRZUEhR?=
 =?utf-8?B?S3dBM1hkcGxwQ1RCc1h3clo5MVA2RnJMMTNFaElCTmJ0TVAxQmJqQVZKbEpk?=
 =?utf-8?B?VUdXVCtrYXEzV1ZLWG01ZHBuZ0IrSEt5bkVtRGVRVVJTMkNRY2kvWGVISDJE?=
 =?utf-8?B?cU1jTWNxcWlqTjJOZGxUbkJIckR4WkhOUWZabDk3SEUvNVJHN0FnMXgxa1RI?=
 =?utf-8?B?dVpoeC9Obis0dUgzTUg2QkVSd0FQM095SmlnN05UWURrL2hKNXh0N01qTUk4?=
 =?utf-8?B?NTB0UmJRT0NFVG5SYXRlaEhkMEhMUTNONHBOY1JwdGRTY2lvK1Y3UUV3RkZk?=
 =?utf-8?B?TzJkMDZaS0M0VGdneFppVlZ3dEk2ZWZKbjExTHVPRTVrbTA0a2hQWXp5YTNv?=
 =?utf-8?B?RStlR2ZvTyt2Nzkrd1hFck56QmtPd2V4M0RGM1o5NmlqNnp3MEJubmNBSmhN?=
 =?utf-8?B?MmNpbmRTL00ralBSZlU3V2tGei8rKzhmcUUyZHpLbXl6cHVMcDVGanFzWnZM?=
 =?utf-8?B?dEFqNStDSW1CMGVmMXNEVFpsOGRibnFpS0RwUGFLV0tXODBUaXNmU29OOXhm?=
 =?utf-8?B?TzVKMnRFV3VTaHhzcDVjS3lzeXlBWnZrZHJ5Z09ZOVdHNENNWDAxWnFreDBa?=
 =?utf-8?B?Nk1GNG1yemZCZStNaWpuR3BqVHpRTUh3MU13NXpWOTlMYUV2NVBnRkUzcTVq?=
 =?utf-8?B?Y1pvNC8rVlJlRGx0NzhhRkp0b0FJeUdSeVZnc1RPcXJlQnVrT2p1Vmw1ZWlw?=
 =?utf-8?B?aXdrRnM0WkVCUWo5d1ZtZkhWTFRqRC9hUW5mOVZWdTVndG4xNWF2OHEzT1dB?=
 =?utf-8?B?SUVVelF0OWpMZzFDTjR5MEIwa2ZrT1J6SmJadHJmVEt6ZEdTNmV0KytUMkZk?=
 =?utf-8?B?SS9DY1pMdHh2NlhjUmlZaEp6YWdZNUhoSS9sbHl1VENlRFNkU2RvZkNPVHpH?=
 =?utf-8?B?T25Ibk9FQTg2VEdiek5PS2lZREkyNVFoN1B2K3BoSmZSWlVDbFFpRzltSXIv?=
 =?utf-8?B?VmJFSEU5MU16QXBSZkpLUi9HSkJlYTVleVo0ejZHc29UUEFCZWwrTW9QRlZ5?=
 =?utf-8?B?Sm9KbUZybFZ6dVRVZ0o2MnNOa05IUVFJL3pkeUZXM0x4MGJGbWRmdVF3NTFF?=
 =?utf-8?B?L2JjRE1kTFEvdUl0NGFDV2FZM2Y4aG9oeThhcmp6eFJhSXBOQ3haWE9GdUZO?=
 =?utf-8?B?U2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b285f70-6cff-4ed1-0398-08dbe5ad6ce1
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5052.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2023 07:35:22.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EEmexRy33MjrsycrOdPJom9fj8H07ym+b8mOJRcz1bICqGlUuOj2YbY+I/H3B9Pd7xBtY40heT8lw1UvL0Zww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8573
X-OriginatorOrg: intel.com



On 11/7/2023 10:55 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add helper functions to allocate/free TDX private host key id (HKID), and
> export the global TDX HKID.
> 
> The memory controller encrypts TDX memory with the assigned TDX HKIDs.  The
> global TDX HKID is to encrypt the TDX module, its memory, and some dynamic
> data (TDR).  The private TDX HKID is assigned to guest TD to encrypt guest
> memory and the related data.  When VMM releases an encrypted page for
> reuse, the page needs a cache flush with the used HKID.  VMM needs the
> global TDX HKID and the private TDX HKIDs to flush encrypted pages.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  | 12 ++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 28 +++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index b7cfdf084860..3b648f290af3 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -114,6 +114,16 @@ int tdx_cpu_enable(void);
>  int tdx_enable(void);
>  void tdx_reset_memory(void);
>  bool tdx_is_private_mem(unsigned long phys);
> +
> +/*
> + * Key id globally used by TDX module: TDX module maps TDR with this TDX global
> + * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
> + * TD-related pages with the assigned key id.  TDR requires this TDX global key
> + * id for cache flush unlike other TD-related pages.
> + */
> +extern u32 tdx_global_keyid;
> +int tdx_guest_keyid_alloc(void);
> +void tdx_guest_keyid_free(int keyid);
>  #else
>  static inline u64 __seamcall(u64 fn, struct tdx_module_args *args)
>  {
> @@ -132,6 +142,8 @@ static inline int tdx_cpu_enable(void) { return -ENODEV; }
>  static inline int tdx_enable(void)  { return -ENODEV; }
>  static inline void tdx_reset_memory(void) { }
>  static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
> +static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
> +static inline void tdx_guest_keyid_free(int keyid) { }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 38ec6815a42a..c01cbfc81fbb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -37,7 +37,8 @@
>  #include <asm/tdx.h>
>  #include "tdx.h"
>  
> -static u32 tdx_global_keyid __ro_after_init;
> +u32 tdx_global_keyid __ro_after_init;
> +EXPORT_SYMBOL_GPL(tdx_global_keyid);
>  static u32 tdx_guest_keyid_start __ro_after_init;
>  static u32 tdx_nr_guest_keyids __ro_after_init;
>  
> @@ -105,6 +106,31 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
>  #define seamcall_prerr_ret(__fn, __args)					\
>  	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
>  
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_guest_keyid_pool);
> +
> +int tdx_guest_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
> +		return -EINVAL;
> +
> +	/* The first keyID is reserved for the global key. */
> +	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start + 1,

Per
https://lore.kernel.org/all/121aab11b48b4e6550cfe6d23b4daab744ee2076.1697532085.git.kai.huang@intel.com/
tdx_guest_keyid_start has already reserved the first keyID for global
key, I think we don't need to reserve another one here.

> +			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> +			       GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
> +
> +void tdx_guest_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (WARN_ON_ONCE(keyid <= 0))
> +		return;
> +
> +	ida_free(&tdx_guest_keyid_pool, keyid);
> +}
> +EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
> +
>  /*
>   * Do the module global initialization once and return its result.
>   * It can be done on any cpu.  It's always called with interrupts

