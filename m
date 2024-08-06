Return-Path: <kvm+bounces-23307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CE2E94883C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 06:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7C77B22BD7
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 04:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE761B580D;
	Tue,  6 Aug 2024 04:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D3+HCS8Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4041FA47;
	Tue,  6 Aug 2024 04:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722917964; cv=fail; b=fKlheLXSLFCc5CLhMJPlmhwstf93UlJgomNWS6uibTpepURil7JGYLdGeuC5tE7WsYRhWSy9+YQkVh268nLSAVUzIXvW8tR4sU1tadssRg/NNhnmx3qQWli6b3OcuiqkBirlGr1LsRToluABHHhKXran9TaISb66/axjMgYm168=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722917964; c=relaxed/simple;
	bh=yUDYkuJ32CjKhZu5sLNl7cZzYTpf63jL4vN1v4kmsUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KrsKoBG83jtrgE2woS6hrrs6zUzEN3E0oWiCiuKw8b19mWciaVxAGKShfrzQOiwo9ATnZGhwonQ8qiz8Av9F9GqTTPrzNHPfofLGfxRzX0/6G6zP867+KIGMD0Jq2q7saptYtqlpibMkrUblBy/sd/T8q55YgQ6nqtYvL2LB3Oc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D3+HCS8Y; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722917963; x=1754453963;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yUDYkuJ32CjKhZu5sLNl7cZzYTpf63jL4vN1v4kmsUQ=;
  b=D3+HCS8YmnlMUykai0DPpDYWCFhY3GL96X8sPb8lyDLkfR05hsJoNiDa
   k8u+QHbVdWO0RZ2QPrebjhqfBtRbdvsGzGmXgBPR63XOQuJg2ekGSK0SY
   1ijQ9Gjuu5cqsAiYusFReES5UbpDqiVrK/+FGmeEkUShsPMcifW4O4/8D
   qlKSiWfFNp9DKKTQTsvbi0WKHdbNTqGbXesphJ5TcVVbKqh+i8EhKSINN
   iLlCdY3P6Jxib8NZrTEwqBRGyVqM/4fQkCM6yhLPqQoQj/vBaIf7ijPUD
   m8tC6FAd4WFWaiX8KzBxjOQXazFPekCM/CaaqA9S6RC5epDAzvOPcFNZy
   Q==;
X-CSE-ConnectionGUID: N0QcuBrgQ0u5vxpWvBgtyw==
X-CSE-MsgGUID: hBS1t53OQWOOR+XNNpZv0A==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="20878507"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="20878507"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 21:19:22 -0700
X-CSE-ConnectionGUID: gVEXX8AHQbOYSKPdCRK5Dw==
X-CSE-MsgGUID: LOjNYtEtTESCVVebDURwug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="93909871"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 21:19:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 21:19:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 21:19:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 21:19:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 21:19:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rJak97UrVOElnsNMXLaysFM2PA1N2y360xI3uEjy5yyjsZoZYDIgKFnLRk7WBP5q9FJ8cQqr0E/Vu5vmqaA1ZMhCft5MXqjECPQyrqWgId/259JlPo2hHpkQYNyGDkTx/6vWLL1T50USx0YKo2fY80nIIYDUzgG0X9g2/TsaK0PA0atC3AA5by0Z/S0fWhzXi0cEiX5NCJQ8rFzOku1El78pqipHJInMfZ9rChnMwbDmj5zTI9yiSsHMAqGee6C+bCP3W5sRxIP/sOMB8JNkqlxRGmpYaSsspWnpu8ff0mrVvi88VjFi+6bD0TMQPByKp6nxM4bzIXrGeKSkMTOvvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFUPVdMJrGR+O4xskforwBpWSZwuJ7GKJ971QIAFj7A=;
 b=F0bEB/iBMt2FmKtuf5L1uxUfCMPT9KrWdVih/PzBsxn2OzoV0j6J1KlLWg1BNgeP7dQ1V0yg8hRuyZGxwWqaMYIRrczDJk08pN92HXW7y+YwTBg4LhvGaUaebRK1b61MwOAZS13b6dyZPnezKDy43u7yOEwohP3wrxnvNbj6/F+5E0ZJ1kzf60lcT80mBtiHGd3IQk4eMQHdOa/fZM3Sr8tJQRW8/mkrYTGqYRTdIF0I/ElL3o6nNb02RbDlTPjRt7ozNRjw20aNdgB2hmXleNU+JT5bdHdntj5gYP+rx+vT7S8ARSeXtta9iX3H4MjB7cj/7aJP1LwngL6GXdRSqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB6278.namprd11.prod.outlook.com (2603:10b6:208:3c2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.28; Tue, 6 Aug
 2024 04:19:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 04:19:17 +0000
Date: Mon, 5 Aug 2024 21:19:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Message-ID: <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4PR04CA0325.namprd04.prod.outlook.com
 (2603:10b6:303:82::30) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB6278:EE_
X-MS-Office365-Filtering-Correlation-Id: 17689dc0-adc8-4455-95f8-08dcb5cef00e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?I4I30yWyNtnu2SNaYbf7wFXDxXLVe+B1m4EHTbzbA4mygZ41Cu694yfM8Pgv?=
 =?us-ascii?Q?aMT9B6b0P/7ukGetPEZxpy9rAFiXYmZw7BSemh03zUHcgVyOkgxgfDLbO23a?=
 =?us-ascii?Q?NCgZW2nm0iUqLu2S90GDbcSIZgdPjtdGvlDb54zqU0iRw3DeIquj/QKZFOgQ?=
 =?us-ascii?Q?QJyChrI3EyZros344I9aHQpV4twMBAmYlXRJyB8W9oNZiihsGJ1EjlEwN11N?=
 =?us-ascii?Q?bvgpiESZkLOq77Y6yD64fZdc5aVo+zHFR8xg2YCTQbMH64RHndM44mQGOevH?=
 =?us-ascii?Q?r0SJ9kHP7eUHDj+6Dl0s/2uyJZVA3lCWJBRHMMKQhnXSqkjn+Lpkr27NElDo?=
 =?us-ascii?Q?6BWeB/G6ON5epL8GXaI7+GDkTXwyUzJ/lNAE6fCjQdFLcTZsCUUkd+jupB1R?=
 =?us-ascii?Q?MOeijStFZ97tHUZzMJ+dbBxT/fJWDpWfoH9BCh42teqPotI0PkL7FyPslYCF?=
 =?us-ascii?Q?D3gS8OuX9UUTAshBibFJ4OIWsKCkSJPxgV6zM3x6i91O/kMHlg3t+cpKQ0gA?=
 =?us-ascii?Q?ch3MS4VFeRtS5Isk1461Ti/UjQqthCsEDDVnL1HzLX8QOk0O6sEqJCI4umBt?=
 =?us-ascii?Q?jhV3KS2bK3tkhNOV1DGwvzglWVT/+nITGvhpinMPBZb4/ad9SjfLwIa8Zr8f?=
 =?us-ascii?Q?MJ++5Otm5WQUxG1fVkupyps82RNYUF1hrjhhrHLZe1Wp+hduWsXBPUcuC15D?=
 =?us-ascii?Q?ZXaMpnUxtGFmwIeDQES0xTcQ3JMNHdyUb08CZaqYC46MUyqZ6Nq1CBYKPJOY?=
 =?us-ascii?Q?IWNNqFIYYgh/hVStA5LXK0t2Y2zSzOZmWkMSe4zB0ukmGGR4AS3KleNVk10K?=
 =?us-ascii?Q?ggy/9oGzLjes5sajy8KA4nTB3I1P69w9N+uxHqCioCAhwa+YYPK9Geuz687n?=
 =?us-ascii?Q?UDlnqjBAV36JeL84T7kO2/+pZK7C8uw9CD3rW+eVSceSWNox4omr4EZft6jN?=
 =?us-ascii?Q?BxX0d0OCrWmohSBhnf3GIhl+qfn/YunTleYqIifJ2UxGglR0udUHiFIxCB4o?=
 =?us-ascii?Q?nLQUKo/5K6SuyEwUUqhfA2rwbvDXJRfB7hJc+tS4oyqx/OIpORBBIXQq92Hv?=
 =?us-ascii?Q?snuYXMxAHCJFRnQRjr6KUrKFnu6WKfhpp380Sx52c7C1lhdokaz+mEy4RStK?=
 =?us-ascii?Q?uPirziMBNGLf/pFQTKk81hHKExazfEgIHWEuiB4niWrBT9ytT2jURPvRld9y?=
 =?us-ascii?Q?6ikoFmcMeTfgvqnTFEXWxHq8VDFVPHlsnGGwVnZtIt90IqQDwQbiI3kNuGtv?=
 =?us-ascii?Q?d0QQnyMryddzm8adD8xFPTXmHxa7bH1tlqk8yzrXXMmCCLw9ZcfChPi+Xeuc?=
 =?us-ascii?Q?JZXBm9TY1Ci+amCM+tlL06DXnedxonC+uJqSxflw/PDMZF/Vvl6nQMvHlyW+?=
 =?us-ascii?Q?hELK7T4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXUTEJr6VUVjTNzPgUXQ3lnrB/eHOOOF9pNbJESLoOY/fTn6LQAs+gZ0oO/D?=
 =?us-ascii?Q?hO3Tjax2i7saPtnuWQ9UBikGZXesXKvYRkM6NdCn+jFwuYKvcy9TBlR/rzn9?=
 =?us-ascii?Q?74BTBRAwtkL7rvPqVmVoU4jH5TkRtJWSTx5rdvi0XYWk+gXhmrhzgM38f9e+?=
 =?us-ascii?Q?iNJ1iy/m6iohDc8/E06LkDAQ0vecQi3yo8zgsrgTXeKTd3LLevvOh3lXjCUE?=
 =?us-ascii?Q?vgvdijkwlGk6Y6Z90VQJJJC9crZPWKS8ici/poGoLU4RDjNpUeIaSlRB5y2s?=
 =?us-ascii?Q?lP5oL7wSj6670ZSnbbspaNner4jS+gj/8gA3D/CrrKwuF7qje8XRfIV+oMIB?=
 =?us-ascii?Q?bp6KFgslZb2zxo3sBKoR1KIJp/rDWcSeZybtUM0qsZHrdyCpK5TSS5Wb0y/F?=
 =?us-ascii?Q?w69S8LA33v+kLr29xH4s7lDRt/V+E8AQ1/iDf82W7CVkT1IURqNRG2FMoQTe?=
 =?us-ascii?Q?DvoPCES88KWoTY1hXTCkOC6PsBG91zGl62ez8duvApUkysTpyGbG96bvagHD?=
 =?us-ascii?Q?Cc2cqYYkac8XrVnE++P945KEH/qKR9oPdomXG2DTkhBirwBLwFUFWAQnDw1l?=
 =?us-ascii?Q?5Yt8fjZpH8+lPg+MCMAU5dECtRJ+/R9klmN56wn8UhoXGo5sVua8B8QNfFdx?=
 =?us-ascii?Q?mUDlS3yc4Gexn81F+DA79zJtA6xYvS8JIheZ4H7Dgj+7C3RhXeplwVpMskEx?=
 =?us-ascii?Q?TJs8KnoIlNErkegCzF1gyL3Noe2/Zv3i7R7+LkjLaX/HM/XS6js61xxlzgdr?=
 =?us-ascii?Q?0eQbJY9fNfpItwrmJQhVq0Mu92CUbBD58L/X/FO28M91rSte9ave4qpViCg2?=
 =?us-ascii?Q?eDGJiZdfoGyIKfTeBHt1pu3aJ93fVd6CI4sjipnxuzoLBllmDQAhG/KBCFhg?=
 =?us-ascii?Q?HTCWbYXkNr0BAWhrv4zOjDX5/y6zJ5d4rAojF1IF65IC+SNJIzjfgQNlUsTX?=
 =?us-ascii?Q?DDmV+9gSPHfnLPv3fDBBypprudRLiybd4tRGpXwUDMwUt1+oxhx4rE2if6Lj?=
 =?us-ascii?Q?4OI1wJ2eAlVGqx/qRRalhR17bHDQ/9N89Ao302oHK3CK0f/p03ByRQ+T6xwG?=
 =?us-ascii?Q?dI3kgiD4rOlY08xjC4mqlgRVN1DjMbDD2KCgDqUqbnZNTrwmuZHYSnysmJM+?=
 =?us-ascii?Q?D9hRk7ZEVHCYI8DuHxhnQX9X4Tz4BONwdH7WiI33VKUMCT9jun40SygQIv07?=
 =?us-ascii?Q?Mo8WycwAT/J0ITjHDdStoboJGIq/YxcaWhySwFSpAr3f12dB7XSBm1IIyGtq?=
 =?us-ascii?Q?cjD/fa5y3RKKkpKXHvhcvporEeQx8r9bY61ySn7JXpTguIQDsTqwJBGN4Rgh?=
 =?us-ascii?Q?VCapKwR4GUo5vq9vZeBEA/QIWg5e3SRzQfgE46Nl1TgW7mD2jI9PkmDHALff?=
 =?us-ascii?Q?/NJJWjOjeQgCTnMyUSMgtBppXY7yOj1544oHHt1BO2U14VrBPiEgHcm5Gjvj?=
 =?us-ascii?Q?2nlqVasBbkaHUotRWsjbIjZrkpaiadbVgURVczHSHbSj6kNtNvWhU7/h0y+h?=
 =?us-ascii?Q?FBqsNg17dsDln0tpePltg2+5y6CLUn2yjjf5XfQVa8Aa7V1c/g/cLEkqKyXB?=
 =?us-ascii?Q?zSP3ha3HrW71SHrBp/m3l9uyD0k3wrxsWTwtz1xrhOjyurfcH5TJ0cWUIljH?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17689dc0-adc8-4455-95f8-08dcb5cef00e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 04:19:17.6198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecjNogkTfZNzBtgqExeFOBZgA2z3Ok5Ks5wUcW9EAjjY1cH0xtk1XmmnvcfRG5nKKbnvf5UgtJ3V1WSAMylQpSQzkHDESmS7bGm7kpZCx6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6278
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Currently the kernel doesn't print any information regarding the TDX
> module itself, e.g. module version.  In practice such information is
> useful, especially to the developers.
> 
> For instance, there are a couple of use cases for dumping module basic
> information:
> 
> 1) When something goes wrong around using TDX, the information like TDX
>    module version, supported features etc could be helpful [1][2].
> 
> 2) For Linux, when the user wants to update the TDX module, one needs to
>    replace the old module in a specific location in the EFI partition
>    with the new one so that after reboot the BIOS can load it.  However,
>    after kernel boots, currently the user has no way to verify it is
>    indeed the new module that gets loaded and initialized (e.g., error
>    could happen when replacing the old module).  With the module version
>    dumped the user can verify this easily.
> 
> So dump the basic TDX module information:
> 
>  - TDX module version, and the build date.
>  - TDX module type: Debug or Production.
>  - TDX_FEATURES0: Supported TDX features.
> 
> And dump the information right after reading global metadata, so that
> this information is printed no matter whether module initialization
> fails or not.
> 
> The actual dmesg will look like:
> 
>   virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323, Production module), TDX_FEATURES0 0xfbf
> 
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
> Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> 
> v1 -> v2 (Nikolay):
>  - Change the format to dump TDX basic info.
>  - Slightly improve changelog.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 64 +++++++++++++++++++++++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h | 33 ++++++++++++++++++-
>  2 files changed, 96 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 3253cdfa5207..5ac0c411f4f7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -319,6 +319,58 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>  	return 0;
>  }
>  
> +#define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_info, _member)
> +
> +static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
> +{
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes),
> +		TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0),
> +	};
> +
> +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modinfo);
> +}
> +
> +#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
> +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_version, _member)
> +
> +static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
> +{
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major),
> +		TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor),
> +		TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update),
> +		TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal),
> +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num),
> +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date),
> +	};
> +
> +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);

Looks good if stbuf_read_sysmd_multi() is replaced with the work being
done internal to TD_SYSINFO_MAP_MOD_VERSION().

> +}
> +
> +static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
> +{
> +	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
> +	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
> +	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;

Why is this casually checking for debug modules, but doing nothing with
that indication? Shouldn't the kernel have policy around whether it
wants to interoperate with a debug module? I would expect that kernel
operation with a debug module would need explicit opt-in consideration.

> +
> +	/*
> +	 * TDX module version encoding:
> +	 *
> +	 *   <major>.<minor>.<update>.<internal>.<build_num>
> +	 *
> +	 * When printed as text, <major> and <minor> are 1-digit,
> +	 * <update> and <internal> are 2-digits and <build_num>
> +	 * is 4-digits.
> +	 */
> +	pr_info("Initializing TDX module: %u.%u.%02u.%02u.%04u (build_date %u, %s module), TDX_FEATURES0 0x%llx\n",
> +			modver->major, modver->minor, modver->update,
> +			modver->internal, modver->build_num,
> +			modver->build_date, debug ? "Debug" : "Production",
> +			modinfo->tdx_features0);

Another nice thing about json scripting is that this flag fields could
be pretty-printed with symbolic names for the flags, but that can come
later.

> +}
> +
>  #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>  	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_tdmr_info, _member)
>  
> @@ -339,6 +391,16 @@ static int get_tdx_tdmr_sysinfo(struct tdx_sysinfo_tdmr_info *tdmr_sysinfo)
>  
>  static int get_tdx_sysinfo(struct tdx_sysinfo *sysinfo)
>  {
> +	int ret;
> +
> +	ret = get_tdx_module_info(&sysinfo->module_info);
> +	if (ret)
> +		return ret;
> +
> +	ret = get_tdx_module_version(&sysinfo->module_version);
> +	if (ret)
> +		return ret;
> +
>  	return get_tdx_tdmr_sysinfo(&sysinfo->tdmr_info);
>  }
>  
> @@ -1121,6 +1183,8 @@ static int init_tdx_module(void)
>  	if (ret)
>  		return ret;
>  
> +	print_basic_sysinfo(&sysinfo);
> +
>  	/*
>  	 * To keep things simple, assume that all TDX-protected memory
>  	 * will come from the page allocator.  Make sure all pages in the
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index b5eb7c35f1dc..861ddf2c2e88 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -31,6 +31,15 @@
>   *
>   * See the "global_metadata.json" in the "TDX 1.5 ABI definitions".
>   */
> +#define MD_FIELD_ID_SYS_ATTRIBUTES		0x0A00000200000000ULL
> +#define MD_FIELD_ID_TDX_FEATURES0		0x0A00000300000008ULL
> +#define MD_FIELD_ID_BUILD_DATE			0x8800000200000001ULL
> +#define MD_FIELD_ID_BUILD_NUM			0x8800000100000002ULL
> +#define MD_FIELD_ID_MINOR_VERSION		0x0800000100000003ULL
> +#define MD_FIELD_ID_MAJOR_VERSION		0x0800000100000004ULL
> +#define MD_FIELD_ID_UPDATE_VERSION		0x0800000100000005ULL
> +#define MD_FIELD_ID_INTERNAL_VERSION		0x0800000100000006ULL

This is where I would rather not take your word for it, or go review
these constants myself if these were autogenerated from parsing json.

> +
>  #define MD_FIELD_ID_MAX_TDMRS			0x9100000100000008ULL
>  #define MD_FIELD_ID_MAX_RESERVED_PER_TDMR	0x9100000100000009ULL
>  #define MD_FIELD_ID_PAMT_4K_ENTRY_SIZE		0x9100000100000010ULL
> @@ -124,8 +133,28 @@ struct tdmr_info_list {
>   *
>   * Note not all metadata fields in each class are defined, only those
>   * used by the kernel are.
> + *
> + * Also note the "bit definitions" are architectural.
>   */
>  
> +/* Class "TDX Module Info" */
> +struct tdx_sysinfo_module_info {

This name feels too generic, perhaps 'tdx_sys_info_features' makes it
clearer?

> +	u32 sys_attributes;
> +	u64 tdx_features0;
> +};
> +
> +#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
> +
> +/* Class "TDX Module Version" */
> +struct tdx_sysinfo_module_version {
> +	u16 major;
> +	u16 minor;
> +	u16 update;
> +	u16 internal;
> +	u16 build_num;
> +	u32 build_date;
> +};
> +
>  /* Class "TDMR Info" */
>  struct tdx_sysinfo_tdmr_info {
>  	u16 max_tdmrs;
> @@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
>  };
>  
>  struct tdx_sysinfo {
> -	struct tdx_sysinfo_tdmr_info tdmr_info;
> +	struct tdx_sysinfo_module_info		module_info;
> +	struct tdx_sysinfo_module_version	module_version;
> +	struct tdx_sysinfo_tdmr_info		tdmr_info;

Compare that to:

        struct tdx_sys_info {
                struct tdx_sys_info_features features;
                struct tdx_sys_info_version version;
                struct tdx_sys_info_tdmr tdmr;
        };

...and tell me which oine is easier to read.

