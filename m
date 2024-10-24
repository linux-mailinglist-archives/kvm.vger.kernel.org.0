Return-Path: <kvm+bounces-29592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8C59ADD80
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 09:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71F421F22227
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 07:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD99218BBA4;
	Thu, 24 Oct 2024 07:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KM3Z4Qm8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A6B16DEB5;
	Thu, 24 Oct 2024 07:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729754599; cv=fail; b=CBxDTmecJ+d8KvQgApthVrjak+wZPKudVajYFI/k315oC/fTCVmchxqHngsR7pDemXC1B4Cez2MmlLnAHfAe0xnDv2hBfERQLy2HhGb8neen2nV85DGxXtnue0ZyZS+/2b9ZUF5Vp85EJYwjWjWsKWYFiP5qcnARGbPXHqeSsus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729754599; c=relaxed/simple;
	bh=CStZSdfAN3B2OG2RbXCxykI6VAJ8QOicwpj4wa7q4w0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UV50FbrJ3ea/NCZnqCkWwU50wTLPQFr6yT4dNm7qAs6ryuZ1kiAK7v6uCKI2VII3CVMw33uzKSbGLyCe4jAsMl1s/E8tC/xXFBTE5LqdhPbnWRtubp2V5EkXEDm5o78jJiO4KeBtBUl0kLfOg0EAP6my69xYkzKHc8LQpH0lUQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KM3Z4Qm8; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729754597; x=1761290597;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CStZSdfAN3B2OG2RbXCxykI6VAJ8QOicwpj4wa7q4w0=;
  b=KM3Z4Qm8V33VPDz0VHad+yMzAbXoQOWcVlrxww7OjsQgvuNszNgnZ7aC
   Oc5kzWjLOGHJ2NAPo8b8gUCP/q1V8QVsBrHQJYLm063+Mt9j+x7MconRs
   h3AndxXNwSJZUk0+ZpLGeLfXr11GPu/sa8xFPbgjPHw83rD3+x3zyTR+3
   IxqDe0kExv1U+f/af9WpZUZyJMArhrat2LuIKwsrIx83dELVIybN4QxOl
   Sp1UYngtWZwaoX46GME7J852jJJceVx+K0dQz3peUGajzXmN++vedIBqG
   jgWNJ9BCaQcnJcEfpL8bJERDsWnB4jDPoo088AIPqafx/IdOZRES6tSQx
   w==;
X-CSE-ConnectionGUID: tDTFzp4bQt6KpAGVZQlu6g==
X-CSE-MsgGUID: XaNZ6UkfQnGmBvQN+I/Y4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29536331"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29536331"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 00:23:16 -0700
X-CSE-ConnectionGUID: PUQsFw9+RgyKJ9XUAMfyeg==
X-CSE-MsgGUID: LcVP8n0hQtGZpmbqHdyJ9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,228,1725346800"; 
   d="scan'208";a="84478999"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Oct 2024 00:23:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 24 Oct 2024 00:23:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 24 Oct 2024 00:23:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 24 Oct 2024 00:23:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=persYWI8qvINtPzfaQ//itk8M3psyqvYz4gS93ZuRpE4QDprOLCM3FL9iemHLrY6++MsPAvgNuDwiHGVzJtqOgxPUeFaNdYOuV7B0zxuG1UxrJ6uhlFtDBPZcTEeqK5kZ3+PuwsaC3YJF8dM1N39FQ+yYO+q1I/6hA+g9+QPUJKK9TR0uZ5vNJ5caKqp6Q6wJzas+M7BnBifVfT8163qMGq0KaxeIygBMLeEFFFuF/3WfREvlK+kyvAQ3vUH5jbaT/0YuwgKBOXZDDytxZNlLwkmzaX/3cWOS4M5DApNx41H/ImlJPDP0xfJP6ZL0Iiir8VW98cj3S+ZkXfzHPjZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CStZSdfAN3B2OG2RbXCxykI6VAJ8QOicwpj4wa7q4w0=;
 b=ButehRf4NyYLJ4wGq151m+q0Es7UVKCWGTqvyXT6EZ4lA/wdJLmFth3IBh/mYvA3i8ugKSItzgfVHxrhfp2zhyjL/ABCBVnJFgm/LZKaSgs5yiZ9YYtyerVkNP6W4h+8cDcuYKxuHnlVChNrsfhKEYN6UIEf1rBNEtOmuMIGb33yQozVxjZRbMGjhL5CclZkaHtVvtT2a5KydHnHqSz5+8MaXHpmDbNoQK3m0c+TFZz09F3o9bdwesuwXwaTNkpUAgJXdaRmnznpTrSHmR8dtY6JhHax18RVoI6wBLsvdu/S5MHmA8rjHLKij8ncn9KBpiVMgYFXC2x/0jzq16XZsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BY1PR11MB8056.namprd11.prod.outlook.com (2603:10b6:a03:533::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 07:23:12 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8093.014; Thu, 24 Oct 2024
 07:23:12 +0000
Date: Thu, 24 Oct 2024 15:23:01 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 18/27] KVM: VMX: Dump FRED context in dump_vmcs()
Message-ID: <Zxn11WJkMXPUai5y@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-19-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-19-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BY1PR11MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3d65db-8315-4f58-0237-08dcf3fcb807
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?lvSmwp/OKo4t9dsXpIGMBhyfDzGJwKrlGyDDIyzCFl0tVaorvChwDBJGCT11?=
 =?us-ascii?Q?gfUmI6vFb69LR+zD6uJAmzGu1XeiBzvrelS98wVC5f2sTUuI188opRA9OOOW?=
 =?us-ascii?Q?CwrSRkcuDAOXQqIpT3QlG6vKYyxRh0HRJajSxMiBxbGoAuB+nE7sFCYoSj3k?=
 =?us-ascii?Q?qIUil8oFOJi7qY2cVpiMhnvaMxWeHZSs2+lrhNgCXXM8XdkM9CnAoBzbufQw?=
 =?us-ascii?Q?DMIcOkolMD8Gki6vmgVqkdFwHnZoRBlrEAJwXVTfB6AEWN1M2ZLgn9KjMLZt?=
 =?us-ascii?Q?K3IAR1jGq/BFUNyvb8LF+fTs36F3mi0RyTMr17GkcW0qk8DpSy+svibNKSO1?=
 =?us-ascii?Q?vVDR8zl30v75gLXuJftqT+hURbrf7bqtBJTvK3DD+7MZ4gzBD+3eE8t1C4RD?=
 =?us-ascii?Q?RA1kanoxENmKvEaAOSwx8+iJbUfomOHQlUBKi1kqxOGYcb/RQPSjE1LJMwFi?=
 =?us-ascii?Q?t56vy2Bn0kNOwhcQb/EGtMv/1bK254zbxAUV0ZnIyvmXuXXR667i7jlWnMZ4?=
 =?us-ascii?Q?aXD/gmLkHRhMfgfTM3eNH8Kii7v3aoDSr4bz/NVeVvwkSvgFURoZzHoh02Au?=
 =?us-ascii?Q?0zeWOhNfXlo+ln7Ncpt/ajSx/2ojOk3GHh9WF5FVF8PhVm/5QGrfNCkn5Tlc?=
 =?us-ascii?Q?9V3L3Rz1jxHLTnd6bsu7ed4Z+qquCbojWshOBqFzh5940i6WLfpWJwNm1FPB?=
 =?us-ascii?Q?NANNrgvhxyfOLzv2iygsmGwx5j0Ix97rXETlRO+nrM+zdjTdNX55VsBupZYA?=
 =?us-ascii?Q?w8LpoJV7lDtsmhBf6No/Q0hAz03sfQ5I7mqJ6SPjh8MZ34IwkMnsNUiS5dGd?=
 =?us-ascii?Q?zkaU+pjF2pKivUCiHyhDdBAQPF4keeC28Q9EUjqj1Z81ewAC01mbuAYGlmMX?=
 =?us-ascii?Q?Q/KuzD/3kTKnAPMcRD+50pmSoRd/AHpbQZaoZ0esmPOsj4LiYaU37ac7y9D1?=
 =?us-ascii?Q?Bs6d4KnWgO26PgwFH3OjjvNi9tq70ku/VLNO7oL/u3KxQs+N9ajTEwGTMT8K?=
 =?us-ascii?Q?Aw1o1OEJEJBjtV6Uz+Po9Nm/Adpv4XIPRN5pUV1AwJkp+273TywaHtv+K20b?=
 =?us-ascii?Q?OziNzJA7CN17ciofFNaiNnT0sMsE4W4Gq5TGaWqUX7+MkMgwsfkRNosisd6c?=
 =?us-ascii?Q?K7I1IRHwLk0bRDbtmf24u9ngcrqUEJL7zVKsCvWgNnU6dHJC/Ct7QcmqmW8k?=
 =?us-ascii?Q?xT8fMAdoggqP6c93Qaou25EvPDIA0it4N5LiY4LJcjKn+WBSqgYbYHMcpXDC?=
 =?us-ascii?Q?3YXOh4PECZMY0RL2K57K51Qlps+mTqv75UTGNN+ZI4vVhJ48Ah3VBkMXZylG?=
 =?us-ascii?Q?Z+3VgqcnWdPOSlPvtmtcRIYv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OzC9GKDn0MNgXMnEg4dAkmAqQ5TIpm+0Z0MgydqAD2CLwzq4Ro/gnUtznJW8?=
 =?us-ascii?Q?G/n8cbaVIKITPKIokX2oxwGfLPqXxzIxTutQI5vShW/QzEXZ9EUJn1shDmZk?=
 =?us-ascii?Q?7Yz3xLphUUHiCd7Mqi3ErkXmamp1w2Az7un+bhO7t7+56vEsCd52eiWELtZi?=
 =?us-ascii?Q?4Jspxd76QT/QrgQsX+owGV4zYnW3pp7uQRe1H1izzmIxPyyx/8qNBHfic1ed?=
 =?us-ascii?Q?MeSTBkEaOR1xCT+FrqT7K+G0D3AWBPDjw2xpTDFHTd/QtKFSRJFcmUwk4n1n?=
 =?us-ascii?Q?ERfobwY62kAOxpWs+Kbm9zNAh4u6P38R3miiEPKCWmOQb8CML84SvpDtG7Hf?=
 =?us-ascii?Q?FB0Y+LTLtILUut2jixrqKjRW6Cl5ykNpjAoQltTG5eC8j7KXUCznR67Qv4bn?=
 =?us-ascii?Q?3JJ/wIFQlO8WJNjp2CRr+VB4zLhd0U/Sc0dsfQo32j6RfH4IoWBy9IFBQA+/?=
 =?us-ascii?Q?q9XIgIp0alV9dbq33nooJPZFx6IgKpVQEI7NaxBot53UeY9xhfKECoCpAAPO?=
 =?us-ascii?Q?aGQHjm1onxQQKoujEhA8wf2aQvT0L/KV/JoO8yf3/bMNUWudeqL83psMUCuW?=
 =?us-ascii?Q?0h5YJ36i/TrbzJZuXHN3lFK87XTrN88VQs+YG4RHfLh8o2RAuu2Ka9DTX1zH?=
 =?us-ascii?Q?sN7rgGRiwyqwLCFC4UvSpd6wnOJR6fGDe7jdPJcTvwswOVjPm9Q4zC4dgwHj?=
 =?us-ascii?Q?zI+bdZFyC4a+k4WfJB9Ax+FqaKgBsZ2oAo9olbpDukhbxylYZNX99IP4G0kB?=
 =?us-ascii?Q?m8wksrOSqBPXbs5w1BghBwC3eaYrzYJtef7AudXaAadfpcyo06IeVSEnJRiA?=
 =?us-ascii?Q?8IBxxuc0pmgeMzJ5A3T0dG72PO6zXM/NP+Im6pfLXS82mkiiCjGg8nY+Owt7?=
 =?us-ascii?Q?uYVs99iS7/VeXB7puusfAQ2TtpfKwD4LmlHVAvxu+ffGNoMglLL6GJ+WekFb?=
 =?us-ascii?Q?mR2mCfMpd0IXZd3G0l+ln0lQHB06VazumxFVtPr0mncvZEAa23jI2IVg8AFx?=
 =?us-ascii?Q?czLegV2POhnr99EMBnYlZwj0BghSNgWQw13TOQcCSCKUf9iwGyX4BbPZXP/n?=
 =?us-ascii?Q?j8jZfiWqY7gQlEgJSduJGJ1vSPU7WzapdUI2aJGRHXyp05WAJkcyOZHzK6st?=
 =?us-ascii?Q?iiHzKhlIwGVc46rvAxWHMPOmXrH2zwjqEb2Lw6jswCeGvA/wfnDkoG4ClCuu?=
 =?us-ascii?Q?7CokzffhKH+PfB79iOapequvSRGaAmWmfiVd3rplG6ny3J8SeVMRpn/hvQ72?=
 =?us-ascii?Q?YNYySUcY/CKn+fxjvDPmIyQV0dYMbDRWfPDkPcE6SLGoh806LvOgF0SmvNnP?=
 =?us-ascii?Q?yQMIArTGJZYqTiLSAPNuWGPXXTtq3gFBfWeMZC6JDyj/tBEyoXczDY/TKnoB?=
 =?us-ascii?Q?E9s8NIh/a153ad5x90fLnG9qiP/Jg78dTc8A8AXcdEFPHzZQs/S2IgQUvJ9n?=
 =?us-ascii?Q?EM/7apa4H250QgH6HAkQMoM7ioDaohhn1AitA4hEi77vXmFyZm6xWCbDwp2O?=
 =?us-ascii?Q?FQwHEoHHQXkHIKc01s9eZ/kkZuB3REmPG1RtDtxAx/OSlpPGqERpY2M95OxH?=
 =?us-ascii?Q?XUGxWM4GSCbl0UMrFgjSEBqmMRPL4clW+WIvJkP8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3d65db-8315-4f58-0237-08dcf3fcb807
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 07:23:12.5960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCBkIjvG7y+39fagmcRF3uQa5jGlTK39X7J8uD4v5sgYBevwngzgwq1RVz56tO5HOk64BkIID0CeT5WaSv0HOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8056
X-OriginatorOrg: intel.com

On Mon, Sep 30, 2024 at 10:01:01PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Add FRED related VMCS fields to dump_vmcs() to dump FRED context.

Host/guest SSP[1-3] are not dumped. Is this intentional?

