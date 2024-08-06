Return-Path: <kvm+bounces-23306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B95948813
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 05:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1472B229A3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F56F1BA867;
	Tue,  6 Aug 2024 03:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VUjaPh/a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46162F4ED;
	Tue,  6 Aug 2024 03:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722916310; cv=fail; b=jqufxZE6STIf7pBNvdWgwtVtgpmapqhvat4iTS5EKccHdfU+d7Txup5uGTfddI1ZUHfn40epBlKcGq5If7HOwIVaOfS7AsEs4KewiCEuF6/DAgIWVbAdXJC4gx7igz6tu8p/iGiIiOgkyUFyyAwo5WhNCjOISgncqAUor20LsUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722916310; c=relaxed/simple;
	bh=qlImG2UHisnirtiN5cuq6Mr4BPcKPMNtmctFyROFNT0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A9GtawVcxCvqCIQevNG0hgQIrSaM48FAkNyd3MlZ+fa8m4dU5stAlAj1z3oPS5LE0ZR8Guh2V2HRilnrvDfNl6GhqnPHxQ+5qBAHt5zgvQhbXaJNrKyKeJi8yq+OUGBoahChNpwLionzQwqrdkrlspeaAdRzt7MUPerzR4jSs3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VUjaPh/a; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722916309; x=1754452309;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qlImG2UHisnirtiN5cuq6Mr4BPcKPMNtmctFyROFNT0=;
  b=VUjaPh/aNtx0+bZX7J3kVlpAzdtvjcuO3lFd3FjUxG1ry1z05On8Dg7A
   CMm4A3oZDrfhRHqs+9q3Wdy7vjRvv/fmp3BtIhR0uZdoElEa8R7xmkaex
   npYGSzrqtUwvxmNvuymBehmf456qyYPCcYRQpCOK7Eh97SzsZloosp0v7
   EUjsV2zjp4M0DTVd/OQcEacOus+EXjW4tWIdCVaM6w9JCFUS17/obBani
   +AQdGLWFTFg13iGP0IopxSxT5krVF60KRTUQ5eCPwPw+m70m9DrsRarF0
   qoKyZyYfiGjZXl9tXRf0AuUXGVXYWc93NQj4s2aHl+AbZs1FFuJAjvUka
   Q==;
X-CSE-ConnectionGUID: 5U+GqhJWS+eY973gCrzx1A==
X-CSE-MsgGUID: TUrjvI8pSoukYe6IQU+f7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="21058816"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="21058816"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 20:51:48 -0700
X-CSE-ConnectionGUID: eTK4I4eyTWK+gGQayKZ2qQ==
X-CSE-MsgGUID: IDASnjO9SVG0QSjMVwmc1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="61002752"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 20:51:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 20:51:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 20:51:46 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 20:51:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 20:51:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RL2kkcPIlJf7HvwmJ1ds5LYCQLmEasp5ToBbAn2l2WNUY08UT53y++/ZdV7YAxMWRFqUDuOuvtnS6Gaxl0w3xqypynDr6sZXMFkyYzrQMwxPkeH9ciaWyxVu0bR+bDCSp3rlY/5sC9ZCVAzBOvOqF6KplSX8NvukWSEXeTXPR/6DIouS95jWkPQsx21eRv/ed0gDqNP2uI2c6afxWj0x69QLYv+ocBQ8MmvVPbC9b+nyX3MTVrLYlLecntxv+kmTApj8U4HnMK1CilQa+Drikmld2R1Y74fdzk1v5uF+xx/8fp4Po93Qu8y5R6yzLzaQEC59lbpLEgfK/B0CgKpBMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EAQezAyymWEeulnKKjmQHuGAJcnQNjsqZCT0u74m6fo=;
 b=DD5UaZR2a99Jhuef38InNt7paFYR5XMI+dwgI/LnNOgPIJO4Xmz/mQjrAS8XXRMtHRwzvKGKNFDQk7m9lmffcxWD3w+7hwazfZyMLGXrCr7xYNYz8WAV/ta6TVoQTKNhO42Rp0wmbcwdKURa+9ug9lcOMEeBWxLlkdbswB1dvL82tLf+REPLApWBt2dSl4ccjv8C+Z85mCjTTwBfGLpZDCSeObxR/FJZ5DPrgig1+ujBpwjGLc4SrIrn7A1++VfEEDFO0PKBxoKZCT6wcE7FAeWjiZX3M7LDKryd2iGVjEAYduoEpoyN46y2usRoZtfR6BbG9rHaxT3ve5pyDLVTNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 03:51:38 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 03:51:37 +0000
Date: Mon, 5 Aug 2024 20:51:34 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 07/10] x86/virt/tdx: Start to track all global
 metadata in one structure
Message-ID: <66b19dc6ddbcf_4fc7294fd@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <3d75e730cc514adfc9ac3200da5abd4d5e5d1bad.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3d75e730cc514adfc9ac3200da5abd4d5e5d1bad.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:303:8e::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e1451a6-8a15-4f30-d043-08dcb5cb12c4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FHxhNX59xV0iXqsdDioos8k9q1xwHNJSRAPUopqZGhwoWvQG/zWzKqyEf3l3?=
 =?us-ascii?Q?QXBUjCTeJaJkiMbeWHozX6atYI1/KyFDtejOVfpj9h31l0JIeMRX60C098zX?=
 =?us-ascii?Q?+SQXknmKXMLPYlTAHLMioJiGGUrLRnBZ0aljHmb+u5jW502Uy9RISQW5enkl?=
 =?us-ascii?Q?xYJUBR8f2vLdma3VzJbj9FAGFcRiQxQvqMG9X5isCA5KZuZC+qqTtg6U0HSp?=
 =?us-ascii?Q?8iS8OntvufGSnaJSzFC2/TAq8K6mX3UBfDI+0mAW1xkPC+TuDLCntcxDoId0?=
 =?us-ascii?Q?H6PxKugk0cWKByviC2pb0srzTipVU6whLZTIbf0JlRkcgdTUV3Wg+JusAdUN?=
 =?us-ascii?Q?ucZb6hEj0SYMgHJqCeP+zKx+AkUAEEgu7LrXy9vvqmIgrFH/FATEysMJ7B9a?=
 =?us-ascii?Q?m5yFogMT4tFFRxoXsckDJ6t7xUvNcJ/zOLEsuJAu0CVZnzH5RIMf0Zb3r9SI?=
 =?us-ascii?Q?ut+Eu6yNavG3STJvAXl3lz0c3pmDWoPBsI/m4ePezvN3ykRXVI6ACWKj5RFY?=
 =?us-ascii?Q?SeVcgzKkM0l4XrAKg0Lhvwu/gYOj0ukA+afoA3hI+SjiRIEt8CqXUaBdxPx/?=
 =?us-ascii?Q?f8OGt00vg5Izmsj3X8Lqgueb1Gh4s3qBPr0jhgf4TTtFJQJJ28vfWlvHeJ9H?=
 =?us-ascii?Q?YjShFOc7cYMkxTISBW0ni1OCa2GezAB8km4ntrNS8mg0nQTBJb2MuFfZ40DO?=
 =?us-ascii?Q?9ZnzYziRkN+HGIR3eExnjf5LC1ulbHb5NrlmjdI88gv2ydSS4be2DOr8QL5A?=
 =?us-ascii?Q?jTDRparavmGSkaCMFlexe3qJqr/ruTBa0GHy7G6siFFLfQ5SReyp7STE16s+?=
 =?us-ascii?Q?9Kb9WDZ+vpq1NexOxk4/hgTLS8CgUBW87zreEvs8JQfKG3N7INkgT7Hlljlk?=
 =?us-ascii?Q?h8/oPVeOxAMN4ErdXvcUKKhUgWDt5KZkgGtfkUBMikojvP42vr869IV1wrS0?=
 =?us-ascii?Q?a/H6NibzVR6lXwEjAIAY8r+5A+o0yvzxHK80y92f7nv98mNx1RAjiZDd6oVJ?=
 =?us-ascii?Q?3rlR9NW8M8sTjn7w3qsLWTRCxUe47E6efwIkvwpGhda6qjnQyGfGrdmaNqo6?=
 =?us-ascii?Q?q8qyLsMhH8cgp7nlGo/gqiSfIy5wLjan11TA7bpnIZs2n4YgF6oW50RqttjB?=
 =?us-ascii?Q?W0tcc+34IoUeqQ8AIb/zvE84JQtFSTWIQJlORXZLH/bote8T8WL6sIxQmdJo?=
 =?us-ascii?Q?SLehHapY74hkWsEGIy3pcKGBsyurCMY+F5836ETNl2Mt1/uaI7qWQVSm/WME?=
 =?us-ascii?Q?MElemAnAywIv3kCSkgKrkTv5pqKzl95HawTtl+a3G5pHDE2GpXydTQoKqRpw?=
 =?us-ascii?Q?f9RHImOgxQVuETBhr31DSNiqecTDYVXvW0n5GNve5GmNFDEU7jPsHaz9DfbQ?=
 =?us-ascii?Q?B89CrTeZFMiF0d8Dr/zvFU2V+eVM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfBDz2OzCxI+iBTUmcIVkJSfVzq59SPUTsbko+pQ3HD7HY2i/E0LWGqyldDs?=
 =?us-ascii?Q?F7vKDwIS8qW8qz4cSesYd3VC5iB2EXOmRUXCaJXz8t263CkQ694NdTtvZSg7?=
 =?us-ascii?Q?Rtic3tQh0cexFhhd3yWZkTlaEvgw7W0Y1dfeJzgPC8HpYiCz95jO9HhjQO5g?=
 =?us-ascii?Q?//2BkYhFgXbCtdRUXlDGESXM+TswIIVc+SV7JH9m3Dmuc3u57csf6QV61eDC?=
 =?us-ascii?Q?glOC6hGlw6yDI4381ed0IfVmv1l0+rBEyNprONiCujUdiAxF/BqgXL2Yq5ez?=
 =?us-ascii?Q?OWZYnpsIW7OOvCZTHVDbP2TL1kZF6AgyMzAiqWTcHPg8qdvUpeb3GMoIK+jw?=
 =?us-ascii?Q?F2W6t6ZiEJrqlfwWDJbCFl4IPAufMll1ajnRujlmUqiuzRy1dEPPR9I2LoF6?=
 =?us-ascii?Q?sjtv/PvLc59MlmcLzPLsmf7U4mlqRTfZo3wFKjJ/JzNGJSc8GRZUo06X9ixQ?=
 =?us-ascii?Q?5qJn0y0M9j3W0u8TP3RASlVYd/a4anP/beG66fPUdW5S9a3AAsWz4+s74ebU?=
 =?us-ascii?Q?y/7RghGlg+roriWeDd6Npk+YFJA1suqSYGYFCCVL2xYtILvHjomOTDoAgvYS?=
 =?us-ascii?Q?iD+B55xzyMQZF0aBbGTXL/IAOF2hyCAgeg2KC2LBvuLuT9qIJ4FIq7+0WpR8?=
 =?us-ascii?Q?umuNhAoQNfo06/h22TP4S5w5FB7c4N17vOnRz7de9qsz39LL1yDWjHOqLsxT?=
 =?us-ascii?Q?Ez1gw2rXmt2jzrYvWfaafnSzCP5vdUv5ysSu6nj0FTum1+5UgNmDI2xM1Vec?=
 =?us-ascii?Q?1yjeVGh+HLHn0quPEgPqTFUBJoAuHJW9UxXJQom5JJn6UJS6g6fGslhun+JJ?=
 =?us-ascii?Q?xXj9AWRCgluqxG8AlRDQQyH45IKv944gTxdSHO0+QAleHSpspIu6qqHkxGs7?=
 =?us-ascii?Q?Pg1OYG0bhNIvvP7Ab5WY0MTB1TsewjVkjeLzqw9zNnpdsbsZMazZYMUjuBlR?=
 =?us-ascii?Q?rtYdafa40Iv2r7SbUdkP0KiCiLSprvHt6vQ4ITm1P2KHYJCdZmRT2R53edQn?=
 =?us-ascii?Q?zfYDbZTYA4kmv/mfz9+xHsVO031hinILu0GSQ6GFyLT5LGkjcCyq6fn+WbQm?=
 =?us-ascii?Q?2e+qGQde6F4N4cAiF7dej4kwf1LiaiK0LaV1DIxWtY68jkNMk27sDqN3CbDG?=
 =?us-ascii?Q?Hf/ClK10AhsB/OccN70r8d69X/2b2TOCWFFXhOGzIMfo8GWOOjpIXp9VBCJJ?=
 =?us-ascii?Q?wYLL7oE3l9/8pp4AWBepqaQjl2onDXy7wbbzuARbZswoZ35/Uny2nCOqvBif?=
 =?us-ascii?Q?Z6m5Tu6rCw8GYCF6SwV9tViNMGMvzIKU+8+Nil7fC44W9SFTQHsqswVbsscK?=
 =?us-ascii?Q?Ca8m0G8Fu+AlOC/8vf4jmvls/HyZHHnYOkg3iN5P4m79b2CspPLGXIjuKH0p?=
 =?us-ascii?Q?FTLv7xUtPvTGVoW3i6Oy7RbDlAc+GHp1+6yyPQZhI6uY3yXF9/FCXJD0XVft?=
 =?us-ascii?Q?ainfLK7D9LN+wuNYWGwHRrs/ejzGZ6e34JdsH+rvG5mOqEWEPo5f2Zz7zl3P?=
 =?us-ascii?Q?1UwNbeQYYp1HjEkySStmcQm/8BHBnwrTsU2wAoUB9A71s2sGSXxynpwX1Pw4?=
 =?us-ascii?Q?HdkJLhD9YlReA77PwiedDlKlusKbwMLT+2MyX+u7NDFowmKfxqLNjthe5bZn?=
 =?us-ascii?Q?rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1451a6-8a15-4f30-d043-08dcb5cb12c4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 03:51:37.8600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O76ZRjiq0yqFOyEPGrAqsdE3Cy1NTUWF4XT56CEL/g3goS2G7eavJc4LY7Yc9joNCGvDIUTSM8hZDDuBHBWoL2XXd2X0SP5sixvpAXCTXmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com

Kai Huang wrote:
> The TDX module provides a set of "global metadata fields".  They report
> things like TDX module version, supported features, and fields related
> to create/run TDX guests and so on.
> 
> Currently the kernel only reads "TD Memory Region" (TDMR) related fields
> for module initialization.  There are immediate needs which require the
> TDX module initialization to read more global metadata including module
> version, supported features and "Convertible Memory Regions" (CMRs).
> 
> Also, KVM will need to read more metadata fields to support baseline TDX
> guests.  In the longer term, other TDX features like TDX Connect (which
> supports assigning trusted IO devices to TDX guest) may also require
> other kernel components such as pci/vt-d to access global metadata.
> 
> To meet all those requirements, the idea is the TDX host core-kernel to
> to provide a centralized, canonical, and read-only structure for the
> global metadata that comes out from the TDX module for all kernel
> components to use.
> 
> As the first step, introduce a new 'struct tdx_sysinfo' to track all
> global metadata fields.
> 
> TDX categories global metadata fields into different "Class"es.  E.g.,
> the current TDMR related fields are under class "TDMR Info".  Instead of
> making 'struct tdx_sysinfo' a plain structure to contain all metadata
> fields, organize them in smaller structures based on the "Class".
> 
> This allows those metadata fields to be used in finer granularity thus
> makes the code more clear.  E.g., the current construct_tdmr() can just
> take the structure which contains "TDMR Info" metadata fields.
> 
> Start with moving 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo', and
> rename 'struct tdx_tdmr_sysinfo' to 'struct tdx_sysinfo_tdmr_info' to
> make it consistent with the "class name".

How about 'struct tdx_sys_info' and 'struct tdx_sys_tdmr_info' to avoid
duplicating 'info' in the symbol name?

Do pure renames indpendent of logic changes to make patches like
this easier to read.

I would also move the pure rename to the front of the patches so the
reviewer spends as minimal amount of time with the deprecated name in
the set.

> Add a new function get_tdx_sysinfo() as the place to read all metadata
> fields, and call it at the beginning of init_tdx_module().  Move the
> existing get_tdx_tdmr_sysinfo() to get_tdx_sysinfo().
> 
> Note there is a functional change: get_tdx_tdmr_sysinfo() is moved from
> after build_tdx_memlist() to before it, but it is fine to do so.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 29 +++++++++++++++++------------
>  arch/x86/virt/vmx/tdx/tdx.h | 32 +++++++++++++++++++++++++-------
>  2 files changed, 42 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 86c47db64e42..3253cdfa5207 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -320,11 +320,11 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>  }
>  
>  #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
> -	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
>  
> -static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>  {
> -	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +	/* Map TD_SYSINFO fields into 'struct tdx_sysinfo_tdmr_info': */
>  	static const struct field_mapping fields[] = {
>  		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
>  		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> @@ -337,6 +337,11 @@ static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>  	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
>  }
>  
> +static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
> +{
> +	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
> +}
> +
>  /* Calculate the actual TDMR size */
>  static int tdmr_size_single(u16 max_reserved_per_tdmr)
>  {
> @@ -353,7 +358,7 @@ static int tdmr_size_single(u16 max_reserved_per_tdmr)
>  }
>  
>  static int alloc_tdmr_list(struct tdmr_info_list *tdmr_list,
> -			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>  {
>  	size_t tdmr_sz, tdmr_array_sz;
>  	void *tdmr_array;
> @@ -936,7 +941,7 @@ static int tdmrs_populate_rsvd_areas_all(struct tdmr_info_list *tdmr_list,
>   */
>  static int construct_tdmrs(struct list_head *tmb_list,
>  			   struct tdmr_info_list *tdmr_list,
> -			   struct tdx_tdmr_sysinfo *tdmr_sysinfo)
> +			   struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>  {
>  	int ret;
>  
> @@ -1109,9 +1114,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
>  
>  static int init_tdx_module(void)
>  {
> -	struct tdx_tdmr_sysinfo tdmr_sysinfo;
> +	struct tdx_sysinfo sysinfo;
>  	int ret;
>  
> +	ret = get_tdx_sysinfo(&sysinfo);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * To keep things simple, assume that all TDX-protected memory
>  	 * will come from the page allocator.  Make sure all pages in the
> @@ -1128,17 +1137,13 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_put_tdxmem;
>  
> -	ret = get_tdx_tdmr_sysinfo(&tdmr_sysinfo);
> -	if (ret)
> -		goto err_free_tdxmem;
> -
>  	/* Allocate enough space for constructing TDMRs */
> -	ret = alloc_tdmr_list(&tdx_tdmr_list, &tdmr_sysinfo);
> +	ret = alloc_tdmr_list(&tdx_tdmr_list, &sysinfo.tdmr_info);
>  	if (ret)
>  		goto err_free_tdxmem;
>  
>  	/* Cover all TDX-usable memory regions in TDMRs */
> -	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &tdmr_sysinfo);
> +	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, &sysinfo.tdmr_info);
>  	if (ret)
>  		goto err_free_tdmrs;
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 4e43cec19917..b5eb7c35f1dc 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -100,13 +100,6 @@ struct tdx_memblock {
>  	int nid;
>  };
>  
> -/* "TDMR info" part of "Global Scope Metadata" for constructing TDMRs */
> -struct tdx_tdmr_sysinfo {
> -	u16 max_tdmrs;
> -	u16 max_reserved_per_tdmr;
> -	u16 pamt_entry_size[TDX_PS_NR];
> -};
> -
>  /* Warn if kernel has less than TDMR_NR_WARN TDMRs after allocation */
>  #define TDMR_NR_WARN 4
>  
> @@ -119,4 +112,29 @@ struct tdmr_info_list {
>  	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
>  };
>  
> +/*
> + * Kernel-defined structures to contain "Global Scope Metadata".
> + *
> + * TDX global metadata fields are categorized by "Class".  See the
> + * "global_metadata.json" in the "TDX 1.5 ABI Definitions".
> + *
> + * 'struct tdx_sysinfo' is the main structure to contain all metadata
> + * used by the kernel.  It contains sub-structures with each reflecting
> + * the "Class" in the 'global_metadata.json'.
> + *
> + * Note not all metadata fields in each class are defined, only those
> + * used by the kernel are.
> + */
> +
> +/* Class "TDMR Info" */
> +struct tdx_sysinfo_tdmr_info {
> +	u16 max_tdmrs;
> +	u16 max_reserved_per_tdmr;
> +	u16 pamt_entry_size[TDX_PS_NR];
> +};
> +
> +struct tdx_sysinfo {
> +	struct tdx_sysinfo_tdmr_info tdmr_info;
> +};

I would just call this member 'tdmr' since the 'info' is already applied
by being in tdx_sys_info.

