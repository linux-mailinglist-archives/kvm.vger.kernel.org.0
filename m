Return-Path: <kvm+bounces-29901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C689C9B3D62
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 23:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86FAA28942F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 22:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FAB204034;
	Mon, 28 Oct 2024 21:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ph/SMWCt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6471EF92F;
	Mon, 28 Oct 2024 21:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730152535; cv=fail; b=QuUERZayYYwv2TAwCKOsBRpbjZxdj3FZqpeToSF5pyVWJsgNPUYCzKDqceZIhrByMRit2j+ExaGNKLS5p10d13dHqKRh+9m1nfCWpx6VQiOvxcFNTHijmU7kONfSKBPrCb7RRTcIqQOOzTdxprAwL0XOe/7xn0qhBig63ejJY5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730152535; c=relaxed/simple;
	bh=odSo9+VhgCyBdia0VA88yzv4IAxYoZaH2BuaVv+WSkQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CzX1FfazFcVhITOmoG+Jr0wCAgrPFl+Gg/VsSGIVp5lxbqQAY6tW1mk0/H5cJHsIxXpqbQfMD+plNPDTCdUFKX20RaQiCOwIgJzUyi0r7mpU4cYSCCFc5skxxJ/hvOMlSij62kVRbrg89/EYUblRgnIxF0+5DOBZELJAZJriB/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ph/SMWCt; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730152534; x=1761688534;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=odSo9+VhgCyBdia0VA88yzv4IAxYoZaH2BuaVv+WSkQ=;
  b=Ph/SMWCtAzWOv85x0K7obGu53MYIZeMAz4oBPYuZm/Fl27dayrcX/AFx
   b77hBnzXqw80zF2v0gqwcBAyA/20CjTRH3NEwIuzQzNkE1z2TunxYeqRA
   A/XPYmxeZCg0jYsyFZvX0Rqy32p26wEuadAOa3gGgcy1cj/uCtKn/U9mk
   W5M88qkK9cxzprixaMPdDUAi4WF/TwILyPKfARvaOOs7Pbt4empFu/Niv
   Ei6Liskoqni5h0VqiLboKYMZCmpyR+l3l99w5ThlGuM3mqn761EBfrUgK
   wvryq52A/C+gADUtQ4nu443ihzbfjSkJYiC7ecDmOhhlJgqrAOrvFx+U2
   g==;
X-CSE-ConnectionGUID: 60MrflhlQV6rK80c8izTww==
X-CSE-MsgGUID: f38oZkrjTdmRfRCDVcb4ZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11239"; a="41132964"
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="41132964"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 14:55:33 -0700
X-CSE-ConnectionGUID: FBjsACWIQ3WUfzQRpmkEjw==
X-CSE-MsgGUID: GeYBfFXcRGCMZTqjH/BVkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,240,1725346800"; 
   d="scan'208";a="82076877"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Oct 2024 14:55:32 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 28 Oct 2024 14:55:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 28 Oct 2024 14:55:31 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 28 Oct 2024 14:55:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMrc3Jf5Ko5zK9/8F85Mx5yQel6KMpI0K6u07J/rIkdiobOmIowiGp6qkEuCLqg1omPj46750srJWAKBDVrYY49AOOQKngxW1Wf1rlh0/84ju+MPB5acZzL0xqYdVsQPgPk+b+PVs0RP568//SZpC9ugtyg3MRBjoD5mJ/D+VL5o+c5SCx3gWSbRW69bUK94chsY/cpF5CBpgdlcUTG3Es0mZ4Pur62q8w4n9QNIdi4Q5lglOijHs4PqhV7iDbUykUhyhRo7rBwhD7DE9D9uYI9vGTgQDNzQqcxSVOQQkZUDchfXn5VAQwuj0Wa4ttfBU8xzuGtONz77tUgnmXb76w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AW08gIZRN4NpHQBcYJF1/YmOC2InXTqYvxfJDVEwNGE=;
 b=J5cuXEmKMx63auE/IO6fm/H3kmI2726PFLSPDLpKwsMY42hnqX05uaaLMWC9ozFt+mSMk7ny403LNtqsoPLqkTHVO6Lpemuj7zW+F5cr2kN9dkqdpvXlzxYktgbSRW7oqx9EOgqbJOE2KInHKnrFEgIQhRWxRLPEDsuzKl4OZpFvtwxmgF9ES+FUt8KSryr8+/eDIoTmsXagj/CYak4POlN75FtakaUmvDaye+0n3YZB2cAXuKEmAh4zZo+DgJXZ008Mi5aWTTus8mrvWOQe//jr38F2z4mdJnts03Jsuzcz5GxhfCScNT7vgWLBkfE1QREOYHTbTg9ATHysygrCDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CO1PR11MB5201.namprd11.prod.outlook.com (2603:10b6:303:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 21:55:25 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8093.018; Mon, 28 Oct 2024
 21:55:25 +0000
Date: Mon, 28 Oct 2024 14:55:22 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<adrian.hunter@intel.com>, <nik.borisov@suse.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v6 05/10] x86/virt/tdx: Add missing header file inclusion
 to local tdx.h
Message-ID: <6720084a3e6fd_bc69d2946d@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1730118186.git.kai.huang@intel.com>
 <3f268f096b7427ffbf39358d8559d884c85bec88.1730118186.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f268f096b7427ffbf39358d8559d884c85bec88.1730118186.git.kai.huang@intel.com>
X-ClientProxiedBy: MW3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:303:2b::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CO1PR11MB5201:EE_
X-MS-Office365-Filtering-Correlation-Id: de6b996a-ac3b-4de0-f88b-08dcf79b3a43
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FhxG1vEtSV4l3zod8gSYSBdjIuFFHubB2cjxpKm1GPXmDZYyBiURW3LreDJt?=
 =?us-ascii?Q?cnG8L8FMRRyNCNYkqOu+zIyWClf9zp7SYQM22+MCCvsduRDL+GysjJNV33Qh?=
 =?us-ascii?Q?goSnZafPfNMnCFDKstEVIyWd+SJEZpTuKK5IrucBOcw6Iv6e7Ab2/n9D/TgZ?=
 =?us-ascii?Q?YABHiPcPYGCLt1DmYYleiMF0ZGyv2BluAy/YM1kW8XsgqKCjoVwSIDWK7ykz?=
 =?us-ascii?Q?cs4AufYsTCWYJmz9fMgYA+LrY+zUEl4AtRwlCceT9xtEREvGglWhDYmNqaQn?=
 =?us-ascii?Q?qtn0bSLVjsAgEdNQHiEZ1iOHE9C2TaF+r4eervu78rGcuKeJs2CTxAIxRBZz?=
 =?us-ascii?Q?k6xEEs2BS4LppeWBfsbvUObJ0y+3ZZY+KY0LXJXNSYE5TP7s05TXKfJOGdGY?=
 =?us-ascii?Q?wpl1gexCE/2UV+7lYcHCembExnAzKjK/C1daIIJf0rd6T2xdo4PhxdyaRthc?=
 =?us-ascii?Q?X1LsFJIEQUx/FHjludevMOLO/yp+d5FRJQ6MJE5cmBhubuYxPYct6VBbsBJ0?=
 =?us-ascii?Q?aRlSvixPIAJSn58Xil8yQHwnReIdCMZ73OCrAIw+5rFiK8UMg6UaFtSgefNz?=
 =?us-ascii?Q?f+eqoDoxGV6LBqlLK/aWjQtCulE1XMz0wHlM7U4VluESXbBpXIg3i9RIDYq1?=
 =?us-ascii?Q?I3KFeD5aVk4qwuKz3zpqn9e1scsIakiyQpDAA397KOt9rEyG5MLCLf36Q4KY?=
 =?us-ascii?Q?qfx1YnJXfsO5vtwot4qKtBYl8JiknRH1zC3NPVSF/8CRL2acCbtAr8P3VdCw?=
 =?us-ascii?Q?nxAIMI8o77EX36aueLeolGDwQfaufEl3St33x2UsjHSxtsY58weGlRY7IPIF?=
 =?us-ascii?Q?TBzNwQRFs+u8LpNzR1lLP+t5LZe/2aNrC0MMocgYpdzFVt1EtkWEMDpPGbD7?=
 =?us-ascii?Q?Icz22sNCe78J5U3r9ivMrd2qSfR1j6kjQOWSbj8uzzeG+isj+GCW1dayIWt7?=
 =?us-ascii?Q?traAxYTV0nNAv+r5O8WGtRidIIauSboAieEG9YGmq1gw53gaKlTROm4QW8a+?=
 =?us-ascii?Q?WC+jBZfWaBPUADuCJJbzzf3ZZXc05d3erT+KqM2u+PjgD+4ATJGfUyo8WO+w?=
 =?us-ascii?Q?Df2gbETSjj618zYoCM847C2TJhHUF5Jop1ZEaSEfARd2nmh7aWZtMBbp0NPc?=
 =?us-ascii?Q?qa4sCLjR92PQYdH/oXiBIqcNdrEJbOQGOv1SXAT0KgSrIp2410+BAbrKxe+0?=
 =?us-ascii?Q?8x2Jmrmm2UtR0rIIIQkvm3EBajE5aJXX8KADQ4XOTZiZ7rh/ljCB9RTQvYnQ?=
 =?us-ascii?Q?ynK/M+g4EkQiNRl1ArHkt1ZGklBaNnEXYzxfWJzUWtROFQ50jS2oKfJnYQRo?=
 =?us-ascii?Q?E2TaYtwuN83bzyOuzg4WJ4xtpWT57ajUMtHcqnwLrt422L2vvDOHpO0EQ0Si?=
 =?us-ascii?Q?hxEqMFg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cumQeaBZB1lOrMrGeyE7tLx7naFlCfvuTYmZPRKxbGgHeEBZX1KQPCK+mq+3?=
 =?us-ascii?Q?Id+ESlc3PKrXoV6iea2fnLQCTQFpmWTjsVL/DKms7FeQH3NVjNR5u+n8D5rX?=
 =?us-ascii?Q?swEne5MTloFhJKNN0qlJYh68cVnnqDbm/uvoXxtT/OZBHun20Jrc2om+Yv3R?=
 =?us-ascii?Q?nm4B/PI/qmiDN6++kmqh72XIRGpUgchNoGBTiNgLXMdtIGIYimuofkoSBgSb?=
 =?us-ascii?Q?tUtlz6eo1IvxYp2SlOfG/5LV4UkjkNx55DQ8VXDguERSkTRcngvmZ1FpfvSZ?=
 =?us-ascii?Q?c8hh+wTNRj56IQD0ilUuFuYN5jADiYi9GyNuniBXPcFGQOOSrd1xvpJEIMu0?=
 =?us-ascii?Q?4PlPi0Aeg2CRsKn+dWd1SpHlPmGI3vsfoA/Rw8iLjyDS0rDYVuryZEYs7VvA?=
 =?us-ascii?Q?t69V/Nz11r/2FKu+UIf681eM+YVp9SGADXVEFD+2J8EXHMtERPASfZSQKJGJ?=
 =?us-ascii?Q?4ZLR+YapUHihn8gDI3wCX7eYlHyO8zpRwqDplPqFUItiNYEV8vyjDzMV6onv?=
 =?us-ascii?Q?FIzC7vGaOIAjY6hT1+XYbRJDS/UBaTyLw3xkPf4d2ABNJmIE338shrHpTDKz?=
 =?us-ascii?Q?td1TL6OD2/hl8Jy6wYwwkowKT1D/8BuogJwSjtu7i/MtXK45DmDzXcz9v9Qj?=
 =?us-ascii?Q?8HgPIt/+GiYMs3N3PD2s5wJhPmr1fal9jsPvRdg24HZlrk88laEFDCLuuQ0c?=
 =?us-ascii?Q?PoBSpX1gIaIigRrJ76mXvTU00eW7+Z0A1GzRlNHrFVTxFrb10x3Qhqymfyxr?=
 =?us-ascii?Q?IqljHR65zesebRV4rNhsQ/n9y5fiGn3oHPMVex5KKNiuaEZ9YYFieO6N2GCJ?=
 =?us-ascii?Q?TPyPOfbV6uX+v2FH0q6q+naUZUBfpqmEdjd1sX8NEtjM1LCTx5mp2Vhtdxvw?=
 =?us-ascii?Q?H98IflxDtKbsEGXnV/uS5kYj7EMv+aphh8Wakn1lDReUoL2zHOIpycIzPM1c?=
 =?us-ascii?Q?2MV73TkLyYVsUj90BmlogeDQfuyxy/ZBPwrvOpcs6J/f5hLEZPf9yWRJxPIv?=
 =?us-ascii?Q?pU4z6UBSvZGl+qiPqTbTnXdTTW9JdYNBKcgTNnFLLhUlKqfVJslcj1od5Ett?=
 =?us-ascii?Q?FiGm0Oo+0ttTjImztPRlOqL7P7785yaxNfY/ojEMNpgKjI+Dxhe9XQ/KZgu5?=
 =?us-ascii?Q?n7rPLf4U/fRw01ImTluaqw5ihQDx+qUa+2KDJJsUY6mBsAIagOhH0A4yOz74?=
 =?us-ascii?Q?l25x40FQC3PBgzfXK32IP3Cu6Gqqk3PCXsymY/q3F2IFNxnXkoy3QdQnkYyq?=
 =?us-ascii?Q?6+llfU4qgMc81jOwzQwflk2zc8pBt1oy9oPt7mJMmsyaBj84YyaZqb3Y5u37?=
 =?us-ascii?Q?LBSIbypO4WlbQj3v5msie2kpgNs85Z/eQJ2l3yZ5J/5iAbmo3IA+7PdVpfuh?=
 =?us-ascii?Q?fFrDWdp8mB9O+ixKQnDJh+lMVemAdlhfCCGgyP1oM08Vr2FOB3HYECxnbaf+?=
 =?us-ascii?Q?+dTVY28MXqzkbRECK99aKIagCM8zxI4jueC6LDPUye6S3GVcHeKy9AGXyHl6?=
 =?us-ascii?Q?vtoo6QCrn3GMFEMnxOcrJSvA6vb4+cfDVppn4bo32nmHtaCwQkioU4FWXjBQ?=
 =?us-ascii?Q?bDlEY8/CJxvAw7YBA60Rf5q0MUFccLVP2gBAWHTlNRuMwy/PD7F6zh4yb8/c?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de6b996a-ac3b-4de0-f88b-08dcf79b3a43
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 21:55:25.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahhjaOUNHHhE8OPgDlYRMXxFZXt70EnB5p4AdokzpQdH5DEOw18QarKvQiL55JzZwbH0IBinnqb+xg0mmfJNfGAOk8nl01CqB4ZF4uyx/a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5201
X-OriginatorOrg: intel.com

Kai Huang wrote:
> Compiler attributes __packed and __aligned, and DECLARE_FLEX_ARRAY() are
> currently used in arch/x86/virt/vmx/tdx/tdx.h, but the relevant headers
> are not included explicitly.
> 
> There's no build issue in the current code since this "tdx.h" is only
> included by arch/x86/virt/vmx/tdx/tdx.c and it includes bunch of other
> <linux/xxx.h> before including "tdx.h".  But for the better explicitly
> include the relevant headers to "tdx.h".  Also include <linux/types.h>
> for basic variable types like u16.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Makes sense

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

