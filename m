Return-Path: <kvm+bounces-50290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 88976AE3A7B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:33:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71B681894360
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 09:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1569822FF37;
	Mon, 23 Jun 2025 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M9FPXBtl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B8190679;
	Mon, 23 Jun 2025 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671045; cv=fail; b=YbcRYSuDR0ryfpScUIXl1v5MIGls8ubfyGtaQyEA/vQpKiv4IwhP7Dud1ria+vWtycMEmKuF+F23DnPFnxiRInmsUx8hfhtSFYhSpjYQA6oZUlhM/8uhRgS9VLUyhMqKo8VP0eqFndjv4UFy6ZKxQSkQUy3pUWZKKj34gP9x3W4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671045; c=relaxed/simple;
	bh=B8JLbodgnKn0q49ilDFu+HWlJ1JR2K5RIyvht0D/tlw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jqWFQuwGM8tu0QHJjHXjsvm4NQKUn1yqc5pHj7u64nA25P8I0BtIk6a91ttGscKGNFdTkZ5BLvNSAbVJB0xZ+sL1d4kFVjjZn6wjcF4kMLRy/27Uo7JxjHSF1m4jyHZc2S5rXj8m2P2GpyHwsta4ekSjQ1HjIFH0m7zY8Gw+5PY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M9FPXBtl; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750671044; x=1782207044;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=B8JLbodgnKn0q49ilDFu+HWlJ1JR2K5RIyvht0D/tlw=;
  b=M9FPXBtlplyxdtMY+ajsBE86FLTUL9ofYu0TtLAjTM2aWt3OltnokzyX
   tQTVpsan1+qBsz3B/qTKv/6Ngp3v/zRtjOHjp/zK0FHUEMHGzndHIRAdW
   qpaYJLETPxofz0wHLwEJOD5lyB25g63/gZPQ4G6NGP2FcYmji4VmxEB6M
   Y2/dput1MwNBB//M/EEbl/FbSjrdrtdQr6Yck6MhP8whk2R0+BkIXHwih
   Ej2Lroz+Mt1FXu6dnJSUSSDLB5sRd4mrF77f1g3633NLPEmrytes/nSEj
   qJ4NeB1fx8ss9/D2L5LGg4yZEoSDki7G4ctsGyWk31j3AENTtzip5IWr3
   A==;
X-CSE-ConnectionGUID: 3llKfAFMR5qL6lyuW8S+mw==
X-CSE-MsgGUID: KsIwcV4TS2GYNNswYmY7CQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="52957438"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="52957438"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 02:30:43 -0700
X-CSE-ConnectionGUID: yIJIb7vIQ5GSwdjwlc1ZBw==
X-CSE-MsgGUID: EbGIpWR0RaOVYKonS8nkEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="175153615"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 02:30:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 02:30:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 23 Jun 2025 02:30:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.49)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 23 Jun 2025 02:30:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GCKWPWLwK3QmENN4vRHkRDDyIjdfFS6CRQQHnS7gbPICh8HbAqdUzMs0TuELZaH7iIlCfxp0FTC44lWiL1Mf9qpD7cmdZsrbvQqj6xrfmT1MFXRfAatNC4dhlgnfzhxaYJTJNDP+CAXbdYcqEHw2aE3Fddab3xa7KtuhfCN5Kxos8DgRhTx+6XpWMAnk5pNN7xJSZ+UjSuR5iQbucIE+SCOpAjBNpM8yAS5GCJLQ/JqzCwkg+DZ0jxJ0LVlJSn6rbkx1vBmAXl+jwRAxh+17ckrvgAQ58rldAc45hMqzBE2l1aFAYYsCpuv4WONsf+9qS+4A/z6FuaZFEQGIc0B3kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KQrrlZc9eiOtHtM23iAjpCG1QAdFmat6PmAWZX/MoA=;
 b=MlOkGujyYWuR73b0kyPU2oDk+aVuJhhyy7jVNSvwbaRzDmWNEWHI2IdGbECbH77W6/JVqEldsKIb0bVpl24Bj2H8yfOYrByiNy/8Uu3EQmGGyas5kAxPxx0XyHy550E2mNeasWNkpwHHFRQBIEWwE6YWdEy3RcUQNq0and3hHzXtgLuxq4Nn+DF08Ao54HmzGbGJGgNWT9TyfwIVo1IJuLrCAzmjGDpvWbW8TNyiaF8wJL6IztPr4cof/NGCRPHTxQHe/Hn7H0yXHRu7enLXA0VEkEUyoWfFHcN+/SnXMIA24eFv6iAneYMHlNodKXDJzrMHkuENhb0gHSH/6RXO1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB8002.namprd11.prod.outlook.com (2603:10b6:806:2f6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.29; Mon, 23 Jun 2025 09:30:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Mon, 23 Jun 2025
 09:30:07 +0000
Date: Mon, 23 Jun 2025 17:27:34 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"Du, Fan" <fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: 088400f7-62d2-4dd8-a644-08ddb2388ad2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Zu3svrs0rDJQEjWWzKNDJVcid+iuNwY1rMduHXRRp6449+d4ms4V3hnX2Etr?=
 =?us-ascii?Q?nxSEczNH8MWcTw+ZCDgfkZyb1yymTQoOmixbQv7v2cdlSBXZaE3YoPnx+oYG?=
 =?us-ascii?Q?Jn2hkBBxSXRmb3uVDP2xnR1cYI6mAvyXJggLAcGH9N5qC0PIFyqdjhJW/zfJ?=
 =?us-ascii?Q?oR7IH5aF9lgTtl/cfm4aCOlJZ2tpGWDNjowUftplvHJXxQCZu/G8R7p6L60d?=
 =?us-ascii?Q?TpGH1dyUPvkN/XYkfZh3a7i28B6HrQBGnsXlrZbTWGENM9E/ysAjRQHbTWO5?=
 =?us-ascii?Q?R3u6NdyejxwcSOIINaELBjQEldB5h8e9yQSFRABf/2H4iPEm/IfVurgBbTI+?=
 =?us-ascii?Q?lhc/gHjfyfvtgwJcZKJJT98xE7qVSouBiDRNFGSRM0EA0xyXkV9/yCFKSKzA?=
 =?us-ascii?Q?e4Z0apX5RNLFA80DRKCpDeIvq/eC8NcRYW95nx3tCGGMpxIchgnZwkEz7fVE?=
 =?us-ascii?Q?gYVs+uQZSZIe71l/d5QnAIAD+xYlKYXkkoFz+EWMb7LtFgVdA1lblWqZAZI8?=
 =?us-ascii?Q?akrtqbARckwO6TziWZn7WyPJBKUHK2NGkPVdDt1KlmX3RFyB+2uYWZO8+B2F?=
 =?us-ascii?Q?JmyoLt6WuaePT7qWWra3HN9iQ/B1Cc4niTTRKG0dj8mtiDN/97IW39IXrOC3?=
 =?us-ascii?Q?/a0NNqpbFLNtYGKZSBLujtBvHA50DpR7MnYdJlV6lKjp3p2bLwkIRHvIS2QW?=
 =?us-ascii?Q?701YJ+sBk86j+6Bi/Rp0cFdCpGS9/2A9eWXtErHRwYmpro5HTnWdEI38xtYm?=
 =?us-ascii?Q?0IxFgDUatqx5DRrLcOEQjeaSXIVG2Qb2wXUNo7e5K8VxcbrBxCUi1zEjTR5y?=
 =?us-ascii?Q?fByp9Kuw3XmZwM0sKiJVn7Ow6TnG+7AIPoaInUderu5WbGblKyQxrm/ZnMq+?=
 =?us-ascii?Q?mhdnww1LodBnbkAyx+aJTcBmRuFTbUQTuYLozJd5qNOYMGxp2dpndgK2/ot/?=
 =?us-ascii?Q?CpB+SjnCB2wpiMZ1EQxF5i72bql+NBlpjU2CfUjjqetChsWbdbvwCN7k9zZ2?=
 =?us-ascii?Q?7q0Ti1YlWwb3OXYdtllcFMXBPl4lJ5sIUej3ycAC1Tn4TMsGQBiB6ulysH8X?=
 =?us-ascii?Q?iSRQlPYZGcK3c/QJkxjGe20rG4cPNHYoW3HVB14fPgAYe1oap6dyAj3AqvZU?=
 =?us-ascii?Q?xoWYD8UApIi381VD87FPk91kmDd0EH56C6DxlxZmbVMuPbBXeaO22U8c41Rg?=
 =?us-ascii?Q?x/FCtHPisowW/dAOUTI1AX+vDY4Ni0BwsBsxvMVuwGwbYnJGWqIoO5TZMbr7?=
 =?us-ascii?Q?d05dnZebv+lv5Y73wDGns2kppET1Q69cH+rXe8l2C7b+ebzZTyvq/aBQUHKv?=
 =?us-ascii?Q?cLh77UE0BnuDKC9Ix3SgQ8U7QXJVlGd/GkVu63HnT+SprrJHtL2QGkCRgTY+?=
 =?us-ascii?Q?K5+aigtqrDv69HuFhhayswdK5QGM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ShbcJX1vj1FcJwF4rq/Aix7tDXfFkLVbh7i70K5suyEF7xQfH5q/t33uNnOq?=
 =?us-ascii?Q?QByQRM5dngAV/L27fFHlbOg2NPD6Jr5ReiPNSIVx5VzMgMB7zOYoCeNPPNzx?=
 =?us-ascii?Q?69e/2BevahL0TksoIQSbv6EimMdHS9H4gvnFz8SYw1oy3r3lEFeIFHrcFPMG?=
 =?us-ascii?Q?yjr8W4Hr7Zf9I6IQppGt2YZyrOXZMPX1zCjoeiWmEOqTD80bS7CZ7/bZ7LjV?=
 =?us-ascii?Q?vwYrNBxKLByv58YZU/KqdYfyICoeSND9WbAMqNSNMpQ5i5XKhiTdsezr9eep?=
 =?us-ascii?Q?U9IfhVBYykHdqU9YyuERhZDETrzHotlVfV0NQZRLeQmRB1465EL64fbB4+I/?=
 =?us-ascii?Q?5+h1Qtdk2HcwnGmlKlfhMB/R69YbU36I+bNoGaYYYFbwBSiSnyl4TLlkzMj2?=
 =?us-ascii?Q?EdyVKp33NF4AR4VXNONXxgf7DXFb9Niz4N6xZ2uIWrscGzAX884trSlXBDwj?=
 =?us-ascii?Q?fhplvR1Ielm/m8LdjoGBjV596rSigBZeXSWZJJG+9b46+9W00ldcRo1ONtnS?=
 =?us-ascii?Q?Ix/R/WkDYqzcQTvgCPY3HhUfbnpQpHLIA6zvDAWOaUeqHGnuxwzqU36SOPXj?=
 =?us-ascii?Q?dWUU+6deiodGFjR1rLMXQIQmaolSy5W8tZBgYxxKliyDHLxJteIzdmrIPsHQ?=
 =?us-ascii?Q?lXl4yaRzhh2wZGRbPAwCsdvpD717c7WtJ5YfF3plpSPFeGrTbdzCKbUcsemY?=
 =?us-ascii?Q?j7wdPHZ0Z+WiGqECGXYN9hCAHMf+CJf+AOt6APLJ2PXqxsagrwap6C8upf1E?=
 =?us-ascii?Q?cq4SwYYz9W+0Ma8k1E4271eazx+5O2VJr0311dkZvaYq5Y1FTYkEY6y4ea7q?=
 =?us-ascii?Q?LmUV5uz0OrSbX1WXRXJ6KH1ryq4Y7twSswnehMyYmhsSjGtYBBR1HMS6kWEi?=
 =?us-ascii?Q?F0Dittz2RXG3EZTOZAt5A0kAkDB8LLY4BkZLw8IaA4qjDJt9urR3a4wLK5Gi?=
 =?us-ascii?Q?QyT2yXsbgvhmHLF75U0HyGXeLcfA7sH3oWhDEwJEwWKoorB4rkJG2ooM+Gel?=
 =?us-ascii?Q?+cIL9TdKp/tpU7OtCzSr1DUjsW83Mwrowchr4mFav9G9+LEKMnL3peFdtiJV?=
 =?us-ascii?Q?L4TNKvx8ddvpnh771izmzknBOQX2H04ZPXD14VuAQaMDtxzYyWKPFqUWztb8?=
 =?us-ascii?Q?PiCVH4e1gCRX4+ifTbK52/2alO8HCmbZq3rq5zyn03g2XQKKcnhiFNpYgeMC?=
 =?us-ascii?Q?zhDm8a78h/hTINpbOyVtxrA20Z6md4QzBExKLr6MQRjaif1+y1jM/UtCc1I9?=
 =?us-ascii?Q?GB8YmPMiko3i6Gol1UJ1JJscPRe5++H5gHaKWdh1lfRt5bZMWMjU9bN0tX1s?=
 =?us-ascii?Q?01rr6cT5dH3hbnbJcUluOpnBGfy0FzUM0jMXVV9LOYAdoBRNDG/45g/O7clg?=
 =?us-ascii?Q?gkdL/UIr60y+4NPAp4Qu7BvOe0kefaQ1v7pbWvxr+fFhK+D2U73Y4Gui/Tx+?=
 =?us-ascii?Q?Qg26nJ3ca//2vMX7eVZaIdpLJH5AcSLANDs91Phg2rsLEZy8Lh/JhXpbIGRR?=
 =?us-ascii?Q?TEjm+THu/Jn6mG3ZRjnxkZsS0pktaVuMyAaWANvbleSQOUNdpFWi1xhsYuy1?=
 =?us-ascii?Q?XIFcHvPczO63u9rkFKhNbY0l7VBkqVGuY9l0zbyi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 088400f7-62d2-4dd8-a644-08ddb2388ad2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 09:30:07.9072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J4oysNlxpCjHqJBBdf6Qu0vbpZJBF4b/13JTXNVebU3pz0BlQc6GWZorbAOBJ30lNb8txTA3pnLadkbv1TS0Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8002
X-OriginatorOrg: intel.com

On Wed, Jun 18, 2025 at 08:41:38AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-06-18 at 08:19 +0800, Yan Zhao wrote:
> > > I don't think a potential bug in KVM is a good enough reason. If we are
> > > concerned can we think about a warning instead?
> > > 
> > > We had talked enhancing kasan to know when a page is mapped into S-EPT in
> > > the
> > > past. So rather than design around potential bugs we could focus on having a
> > > simpler implementation with the infrastructure to catch and fix the bugs.
> > However, if failing to remove a guest private page would only cause memory
> > leak,
> > it's fine. 
> > If TDX does not hold any refcount, guest_memfd has to know that which private
> > page is still mapped. Otherwise, the page may be re-assigned to other kernel
> > components while it may still be mapped in the S-EPT.
> 
> KASAN detects use-after-free's like that. However, the TDX module code is not
> instrumented. It won't check against the KASAN state for it's accesses.
> 
> I had a brief chat about this with Dave and Kirill. A couple ideas were
> discussed. One was to use page_ext to keep a flag that says the page is in-use
Thanks!

To use page_ext, should we introduce a new flag PAGE_EXT_FIRMWARE_IN_USE,
similar to PAGE_EXT_YOUNG?

Due to similar issues as those with normal page/folio flags (see the next
comment for details), TDX needs to set PAGE_EXT_FIRMWARE_IN_USE on a
page-by-page basis rather than folio-by-folio.

Additionally, it seems reasonable for guest_memfd not to copy the
PAGE_EXT_FIRMWARE_IN_USE flag when splitting a huge folio?
(in __folio_split() --> split_folio_to_order(), PAGE_EXT_YOUNG and
PAGE_EXT_IDLE are copied to the new folios though).

Furthermore, page_ext uses extra memory. With CONFIG_64BIT, should we instead
introduce a PG_firmware_in_use in page flags, similar to PG_young and PG_idle?

> by the TDX module. There was also some discussion of using a normal page flag,
> and that the reserved page flag might prevent some of the MM operations that
> would be needed on guestmemfd pages. I didn't see the problem when I looked.
> 
> For the solution, basically the SEAMCALL wrappers set a flag when they hand a
> page to the TDX module, and clear it when they successfully reclaim it via
> tdh_mem_page_remove() or tdh_phymem_page_reclaim(). Then if the page makes it
> back to the page allocator, a warning is generated.
After some testing, to use a normal page flag, we may need to set it on a
page-by-page basis rather than folio-by-folio. See "Scheme 1".
And guest_memfd may need to selectively copy page flags when splitting huge
folios. See "Scheme 2".

Scheme 1: Set/unset page flag on folio-by-folio basis, i.e.
        - set folio reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
        - unset folio reserved after a successful tdh_mem_page_remove() or
          tdh_phymem_page_reclaim().

        It has problem in following scenario:
        1. tdh_mem_page_aug() adds a 2MB folio. It marks the folio as reserved
	   via "folio_set_reserved(page_folio(page))"

        2. convert a 4KB page of the 2MB folio to shared.
        2.1 tdh_mem_page_demote() is executed first.
       
        2.2 tdh_mem_page_remove() then removes the 4KB mapping.
            "folio_clear_reserved(page_folio(page))" clears reserved flag for
            the 2MB folio while the rest 511 pages are still mapped in the
            S-EPT.

        2.3. guest_memfd splits the 2MB folio into 512 4KB folios.


Scheme 2: Set/unset page flag on page-by-page basis, i.e.
        - set page flag reserved at tdh_mem_page_aug(), tdh_mem_page_add(),
        - unset page flag reserved after a successful tdh_mem_page_remove() or
          tdh_phymem_page_reclaim().

        It has problem in following scenario:
        1. tdh_mem_page_aug() adds a 2MB folio. It marks pages as reserved by
           invoking "SetPageReserved()" on each page.
           As the folio->flags equals to page[0]->flags, folio->flags is also
	   with reserved set.

        2. convert a 4KB page of the 2MB folio to shared. say, it's page[4].
        2.1 tdh_mem_page_demote() is executed first.
       
        2.2 tdh_mem_page_remove() then removes the 4KB mapping.
            "ClearPageReserved()" clears reserved flag of page[4] of the 2MB
            folio.

        2.3. guest_memfd splits the 2MB folio into 512 4KB folios.
             In guestmem_hugetlb_split_folio(), "p->flags = folio->flags" marks
             page[4]->flags as reserved again as page[0] is still reserved.

            (see the code in https://lore.kernel.org/all/2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com/
            for (i = 1; i < orig_nr_pages; ++i) {
                struct page *p = folio_page(folio, i);

                /* Copy flags from the first page to split pages. */
                p->flags = folio->flags;

                p->mapping = NULL;
                clear_compound_head(p);
            }
            )

I'm not sure if "p->flags = folio->flags" can be removed. Currently flag like
PG_unevictable is preserved via this step.

If we selectively copy flags, we may need to implement the following changes to
prevent the page from being available to the page allocator. Otherwise, the
"HugePages_Free" count will not decrease, and the same huge folio will continue
to be recycled (i.e., being allocated and consumed by other VMs).

diff --git a/mm/swap.c b/mm/swap.c
index 2747230ced89..72d8c53e2321 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -98,8 +98,36 @@ static void page_cache_release(struct folio *folio)
                unlock_page_lruvec_irqrestore(lruvec, flags);
 }

+static inline bool folio_is_reserved(struct folio *folio)
+{
+       long nr_pages = folio_nr_pages(folio);
+       long i;
+
+       for (i = 0; i < nr_pages; i++) {
+               if (!PageReserved(folio_page(folio, i)))
+                       continue;
+
+               return true;
+       }
+
+       return false;
+}
+
 static void free_typed_folio(struct folio *folio)
 {
@@ -118,6 +146,13 @@ static void free_typed_folio(struct folio *folio)

 void __folio_put(struct folio *folio)
 {
+       if (folio_is_reserved(folio)) {
+               VM_WARN_ON_FOLIO(folio_is_reserved(folio), folio);
+               return;
+       }
+
        if (unlikely(folio_is_zone_device(folio))) {
                free_zone_device_folio(folio);
                return;
@@ -986,6 +1021,12 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
                if (!folio_ref_sub_and_test(folio, nr_refs))
                        continue;

+               if (folio_is_reserved(folio)) {
+                       VM_WARN_ON_FOLIO(folio_is_reserved(folio), folio);
+                       continue;
+               }
+
                if (unlikely(folio_has_type(folio))) {
                        /* typed folios have their own memcg, if any */
                        if (lruvec) {


Besides, guest_memfd needs to reject converting to shared when a page is still
mapped in S-EPT.

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d71653e7e51e..6449151a3a69 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -553,6 +553,41 @@ static void kvm_gmem_convert_invalidate_end(struct inode *inode,
                kvm_gmem_invalidate_end(gmem, invalidate_start, invalidate_end);
 }

+static bool kvm_gmem_has_invalid_folio(struct address_space *mapping, pgoff_t start,
+                                       size_t nr_pages)
+{
+       pgoff_t index = start, end = start + nr_pages;
+       bool ret = false;
+
+       while (index < end) {
+               struct folio *f;
+               long i = 0, nr;
+
+               f = filemap_get_folio(mapping, index);
+               if (IS_ERR(f))
+                       continue;
+
+               if (f->index < start)
+                       i = start - f->index;
+
+               nr = folio_nr_pages(f);
+               if (f->index + folio_nr_pages(f) > end)
+                       nr -= f->index + folio_nr_pages(f) - end;
+
+               for (; i < nr; i++) {
+                       if (PageReserved(folio_page(f, i))) {
+                               ret = true;
+                               folio_put(f);
+                               goto out;
+                       }
+               }
+               index += folio_nr_pages(f);
+               folio_put(f);
+       }
+out:
+       return ret;
+}
 static int kvm_gmem_convert_should_proceed(struct inode *inode,
                                           struct conversion_work *work,
                                           bool to_shared, pgoff_t *error_index)
@@ -572,6 +607,12 @@ static int kvm_gmem_convert_should_proceed(struct inode *inode,
                        if (ret)
                                return ret;
                        kvm_gmem_zap(gmem, work->start, work_end, KVM_FILTER_PRIVATE);
+
+                       if (kvm_gmem_has_invalid_folio(inode->i_mapping, work->start,
+                                                      work->nr_pages)) {
+                               ret = -EFAULT;
+                       }
+
                }
        } else {
                unmap_mapping_pages(inode->i_mapping, work->start,



> Also it was mentioned that SGX did have a similar issue to what is being worried
> about here:
> https://lore.kernel.org/linux-sgx/aCYey1W6i7i3yPLL@gmail.com/T/#m86c8c4cf0e6b9a653bf0709a22bb360034a24d95
> 
> > 
> > 
> > > > 
> > > > > > 
> > > > > > This would allow guest_memfd to maintain an internal reference count
> > > > > > for
> > > > > > each
> > > > > > private GFN. TDX would call guest_memfd_add_page_ref_count() for
> > > > > > mapping
> > > > > > and
> > > > > > guest_memfd_dec_page_ref_count() after a successful unmapping. Before
> > > > > > truncating
> > > > > > a private page from the filemap, guest_memfd could increase the real
> > > > > > folio
> > > > > > reference count based on its internal reference count for the private
> > > > > > GFN.
> > > > > 
> > > > > What does this get us exactly? This is the argument to have less error
> > > > > prone
> > > > > code that can survive forgetting to refcount on error? I don't see that
> > > > > it
> > > > > is an
> > > > > especially special case.
> > > > Yes, for a less error prone code.
> > > > 
> > > > If this approach is considered too complex for an initial implementation,
> > > > using
> > > > tdx_hold_page_on_error() is also a viable option.
> > > 
> > > I'm saying I don't think it's not a good enough reason. Why is it different
> > > then
> > > other use-after free bugs? I feel like I'm missing something.
> > By tdx_hold_page_on_error(), it could be implememented as on removal failure,
> > invoke a guest_memfd interface to let guest_memfd know exact ranges still
> > being
> > under use by the TDX module due to unmapping failures.
> > Do you think it's ok?
> 
> Either way is ok to me. It seems like we have three ok solutions. But the tone
> of the thread is that we are solving some deep problem. Maybe I'm missing
> something.

