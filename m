Return-Path: <kvm+bounces-50266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 959DCAE339F
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 04:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 376A91890407
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 02:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060C219ABC3;
	Mon, 23 Jun 2025 02:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fz8wOc/d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6457E6FC5
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 02:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750646206; cv=fail; b=PwUgCfiUiZkJlE6n2fqoKs03udA3Fnu4v693r8iuwI03USgkzmFRxpo+E6zxR65gzZuwMUqMP3JJscDKAci1I7zKlv3Lj6Z8abFuF3jsL1GtnrVFx3Z89YhAcspUWMlP6Vca/Jizo3ZyltMbmm8Sa9nVIaX05yAvZOlO72GW6VI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750646206; c=relaxed/simple;
	bh=qRCd+lTcTtOJkKqyDaAx4ao0YPyvtT5X7diJW+y/cnA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eUe64guaCPIxuZig2cJFrb9jF4gdpfQ077I2Om2Lw/dLsI4nNbsX9jUMOH9g6v08Hsjq56yPUpsJaiH7O8hAwTUBPNtVKqY8MyqRofxybAem9B9DkgrfkLQ1EZ83lIHkIq7PbLHHBCVUVt1xvhX2zfCO7jQHUbBKyWvx9FpWPb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fz8wOc/d; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750646205; x=1782182205;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=qRCd+lTcTtOJkKqyDaAx4ao0YPyvtT5X7diJW+y/cnA=;
  b=Fz8wOc/dQcdnWd42hrYQrLK6aFQ+1nGRjp7oFvW+zXSWEq4k1hcTavIw
   I4mwPfrL6pI5WT4rieRUaM2QhtV0h/fFruE7TeNUXPhruosEfRw/MsPWU
   KB0NetVW+WuwXvI71DYaqLmiwpUHndjFLISqfVBKhoYbctkOlBFD9sDrK
   yGllmsl7HAfIrMj6NXpFK+vIEMiEaB2V4cj2FqbuWpbTECcAcGxTR46zI
   MwDZpaY+RGOiMU7irHvCPHfN5B6MbTdnG2dEM8gfZ5omnR+GEU+KhXwwN
   ha9xHvDfOSANRGVI61kS6K8xxkdbSu52Sn0kwwp7xHwaRG1cISM63x0xM
   g==;
X-CSE-ConnectionGUID: PAUmR6okQwmdWR63iIYggg==
X-CSE-MsgGUID: MwD+JmxqQz2hmRO7pEajPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="52769439"
X-IronPort-AV: E=Sophos;i="6.16,257,1744095600"; 
   d="scan'208";a="52769439"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 19:36:44 -0700
X-CSE-ConnectionGUID: 0zBg0v1OQ4iLpwYWP3WM0A==
X-CSE-MsgGUID: //oSdkpPQgy0Lodb+Hm2ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,257,1744095600"; 
   d="scan'208";a="151748741"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 19:36:42 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 19:36:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 22 Jun 2025 19:36:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.67) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 19:36:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FLhhPE/OtJqHMYpSwH8+FD2UUcKy7HznxpPKmtW6UdcdSKWITw9bAGAV8YV7VeIFiVW6gv3S+BKceREnzTZt7pK75nt5gMFLshITfijCVxCGpeGZeXBPP1Bvkqf83b49XTVuIquyWK2lEtqrhc63ZESYR/RhaO/RsUur0wuBVylw/upNvqV5WNIq3PSwXmY59MbxjnSx4ZQhfVkYFCSuZE3r7HptKAQBYcZGj9NV2YkENWEs0WMC1170zxGETQBdi4UymS2DBhMWtlt06+Q3V4aNfXeI/A/HD8IeCgVDk9/y5wtQxcxgww6wn/0GQ/SqAi078088JkzK9bD1RomJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yf4028o2yj6nzj6wgnaAgzQgW8I7UCe7NQs2O2lb1Rw=;
 b=Aa4jPaDpwoAWKCLmkYyn8PvwgkGJ4NXXIe3En8KIVFelRxA3N/bnIHfPgPISCVBAaceRoAnW6LO09w3U3V9Jbbzo91Yeb3w290WhbglQpA7Jy/JHLog6xprOg+Pz7PxxbROdJrfC2WLXzlz9dTCXlJU0iBEeXF83bKJ7dOl8/rfVfeUjjq19fvlK18HdyBymaSmfo+ks8kvweD1Gb441PUdzBhOPA5jmV54nLrvBLvcvrNapRNhYgVIv2S5NV2mziI6/fuYouU3iNzTM0EYox9baG+22C/+HYlfKPFZ7mzW9LV6gE4lUUfKp4EJlfJJhoqA7WrmHzL21nwhANr5Umg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB5933.namprd11.prod.outlook.com (2603:10b6:303:16a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Mon, 23 Jun
 2025 02:36:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 23 Jun 2025
 02:36:38 +0000
Date: Mon, 23 Jun 2025 10:36:29 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 0/8] x86: CET fixes and enhancements
Message-ID: <aFi9rUWBarenqfkK@intel.com>
References: <20250620153912.214600-1-minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620153912.214600-1-minipli@grsecurity.net>
X-ClientProxiedBy: SG2PR04CA0210.apcprd04.prod.outlook.com
 (2603:1096:4:187::7) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f5285c-0449-4408-7830-08ddb1fec77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Vb3s9Q1scRL6p/D1qTxPYzHUxZqqYVjVHMQcBe/xSJEkvkPcXe93yNcywWKq?=
 =?us-ascii?Q?5pRIg+016pSuuYJ46NR6M0jV5M8eNRzMTjL9yjEsRNSWnU6Bvhxn35BUjxWL?=
 =?us-ascii?Q?oTbfRmAjJg7WjpeTECOaqrEKi3Jz1F3FiRUeOyuSdxVSJu7YWyf9vZdfgQG6?=
 =?us-ascii?Q?+HTLCCGSBejMeB9cevdmviI61QkXkkQzAAc+GDmQ8gqKhJnnGAYmwE2h5got?=
 =?us-ascii?Q?hS3FxO/65KUJsxg1TuCU6dHMak89mEadNVaN9FonYzNIKGZm+yOF3w0d6GXE?=
 =?us-ascii?Q?3U6oxWiKlYHgw7o1PYFrmGbRXmH691sOttcUxQBNuwBdxwZQ096/uCOK/f7k?=
 =?us-ascii?Q?Z0fMju9KYqGClcf9sghwzAmB9clJrMY03QOwHgi/Gl1ATLrJ9LEUosU0+MC9?=
 =?us-ascii?Q?wlDY0Xfe8DHePrucpcGzhCdOc+8K4JIXYKVGKSyBPDnz9Fy5BGjNwGlrZ/Gy?=
 =?us-ascii?Q?R72ou6aOB9u50scti0KYEW4h2cgDGOo2jm3AVZE77lEj6p9qajg6o04yANut?=
 =?us-ascii?Q?OaotPjFd1YQQp+2xJi+lBlEi+kZlCUi6A/qjvjem9zrNSR8fDP837sqwo5sM?=
 =?us-ascii?Q?SNCmowm64VuHkk9e9ds2I6GrHczFoThasX3zHHFhbKIjMN17XvkKnaswfNhe?=
 =?us-ascii?Q?fJV/CuhxAqXW1PXimeEtIpDuOqK6cXNs/eQWCutUSXe5RgYufwaaZiaWp0e6?=
 =?us-ascii?Q?4KF45NW0mRzqkopso6wcVi2pw7jIDGJDRBqtBDYUjcfVbsyrbCFbaN2MYI+/?=
 =?us-ascii?Q?yKN9iUWRL0saGdNknRIQj8f21RvWmOXYmqqAzZT2jguB7BgvEr5uRCBpSOD3?=
 =?us-ascii?Q?DZ2V1ZrgpnVlNxXXXDmlgGmsreof1toEx7CgFmwuqbcKStcWbrBXk3BCNRhG?=
 =?us-ascii?Q?IcQeWxy8Hp9rOfVFjDLFI8/6iolAduFoUpHHsD+X6Ihvo11L4L3+xqo0U8Ft?=
 =?us-ascii?Q?rYdCmgV5e23a/c3ARCkE0F4HObOyoKll/qKsEtE2a/vL9cnNWonZ6hIFsp2o?=
 =?us-ascii?Q?9ANYOx5Sv3NCunHtopNF9N8k0IfKM0gMJsXcqFIdJ0aVrsjgZUDRU+Lgynwl?=
 =?us-ascii?Q?xlde/pABk6J4HQT3N5ZCFeZKrdmntYcd7RM0gD8uIQOaMGcNTELMFQ2GW7Tr?=
 =?us-ascii?Q?QmKpZrZ1HiCnKg/I1aqM5GMV6vbNvpYklkq4Pv2620SLM8VCAWOZPKifeaWA?=
 =?us-ascii?Q?hF//OquiLtzdV8JHX399kVrTD/AEqbI/DWxrg9aI3mFyNYzkxJgJu4FeibGM?=
 =?us-ascii?Q?VSq5UxhuZGcBS8iwRq1/VpUgvq4uQqZtxQy/vGX905MVYu+jQOAATNiDG9ZB?=
 =?us-ascii?Q?UDp1cS8K2yugBDcC48u7J3deE2g5Bzx8XbeeUL+5k2lFrhTMfZ+stPoc0m1o?=
 =?us-ascii?Q?7t3IJMJ0joQpmLJ74MwwO8qlmvHkA0SQ0H3tVZsECVpz33lON7D2+Rg9NM+8?=
 =?us-ascii?Q?Ma6NW2Lmbr4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WPuwGy8Ka6vHuN0Y0eqzLBwnXJ8YNXp9TJBFqxtjqNp86DSrtCbiKwuJd/4i?=
 =?us-ascii?Q?YSAvv13pTJYv4hsSu1dwk/Kmg6j0vCE25OprG7dk6v2qQUccFEbtHFqLO1g0?=
 =?us-ascii?Q?s/XiMpgUy7uXtdXgxw3W4Bm/61+Z/kndpXEBwaludYLVee8wYjfVugFv7JOQ?=
 =?us-ascii?Q?B93wSEtfk0J9TtUvPPbn+sFC5CW+G08TNdj4WrrcrVfubOHOPIIsjFE1tK0H?=
 =?us-ascii?Q?Xcg6O8Mt5PXZ+T33PCt5a4ePnb5zGwsMAjGMR9RzCwMaY/fBbvvubDkw1Lii?=
 =?us-ascii?Q?EHaq4KD6WsCpL/PH/qK8vAFs1TNSwaBvgAQMtimao1VxaWO3MAyftLyQYFFS?=
 =?us-ascii?Q?1Mcib1lsj52o2ptbah+bOKmLEZZNGZbpydKQRGiw2bV+3QElpxOKOehEfgdf?=
 =?us-ascii?Q?/3W/Tt3A0AkvOQ5XDbdkDhNOhXZS2LLW+oKPG57/5XoDntgfuP3Z10wpvBhw?=
 =?us-ascii?Q?j+I5RmOfC5ScjavgB8Biz5vAbYiQS6xmGrTs3VXfiT8BfR995meWhE6UNiWL?=
 =?us-ascii?Q?dDpKPxO0n9rHkqaxUkcVacahW4RslI18FtGtqzb+VNg7UEOfe0+1o/8brq1V?=
 =?us-ascii?Q?nUyWdhsb/ZMp3pRHbvcwrDeVCN7I9jqfYF4WE9gpd9TDjibjNeDINieXxlGQ?=
 =?us-ascii?Q?d45wwp/2WIcCr/eOyiRVqAFhMJIasrSqQTwbJzdll+/33Uj+RIPJDjA8kWte?=
 =?us-ascii?Q?UiUlvIbA//ZNu1pqA0q2FYiTWVG9v3X9lZerqHlrM8Oihu1GqIbeg4IerYiT?=
 =?us-ascii?Q?lPToT9pc/mir0Mk8YwugsJ5G3nxhxZSi5C+g594p3qsnwrC5mIdEbtRa4Pc8?=
 =?us-ascii?Q?coI10fW0/J2otKFL/sncwQHOorLl9uW76hU1FWsff6ehpwcI09IAadzksDbz?=
 =?us-ascii?Q?glAMwnxm37rfMgtCPitFxndmn9VnqgvsVRbTY8QAFgZ/vRosJ9/95dZgNZpi?=
 =?us-ascii?Q?XgKlZI9jv3TAH/z6GQSO3DYP/5zFYdwjEITPywfqUTyJXUDUvbUIMQsnxOA9?=
 =?us-ascii?Q?vxD3otlBSPDkC+tNtEbG/VMaCFZT4QLSmnvOeo3smWGv5ZGMTE/OZWWCZtet?=
 =?us-ascii?Q?47YnQH4HMorkdZXMm3NBhhBGb71b50WHsUDTX6VHK5waafzmBiEjS9P9EGpx?=
 =?us-ascii?Q?5DHcZxphiYI8JDEcyQY66Fkm350Q6CYa0VaAjN/xseKS9jw+FvAuGj4XS88k?=
 =?us-ascii?Q?nhBp8YhMA0V9rjIquBMWUoFo5/lH/Mmiv7MPNJVIpZg96LQVkEun1gHtNmfM?=
 =?us-ascii?Q?YwVgCpVvVc4gCLxFfNgRspei/9SQU63LnPj+AXB4aIxm/mGgza2WPTHMPlyQ?=
 =?us-ascii?Q?pY49gYDv1/T7T7w3l7w2wIjxZaN5Z8Ff8ag6KAdFHdkZeMSE4QdNzI7Seer3?=
 =?us-ascii?Q?4DlavnPpPij749cUb2hxKXUMrBv6RtKzE5cHDKbc7vDkC9ZM0PEcVfZSqpp5?=
 =?us-ascii?Q?vEE6x2C6PVjaS/3eytqTiksmovbcXtROD4f0KG36dmFxm44h9QTi6bBEc5+j?=
 =?us-ascii?Q?Fh6hZ4dhc/tcK3LnqwN5gb7yShV7+pftGHXT1JA9dLx0LtgDu2eg98RKfsQ7?=
 =?us-ascii?Q?YaerzlfmNbiKtmPqFQTZvuz0AbJXQvgxA2vg79QQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f5285c-0449-4408-7830-08ddb1fec77a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 02:36:38.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0UVk8yXv7XdQBcsT3ZEhHE1wfVimShJU+lMZypce5i3mclJD8jwX34COK+EaJUqI0/cTGUZ+pjou+NF8CUh90A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5933
X-OriginatorOrg: intel.com

On Fri, Jun 20, 2025 at 05:39:04PM +0200, Mathias Krause wrote:
>Hi,
>
>I'm playing with the CET virtualization patch set[1] and was looking at
>the CET tests and noticed a few obvious issues with it (flushing the
>wrong address) as well as some missing parts (testing far rets).
>
>[1] https://lore.kernel.org/kvm/20240219074733.122080-1-weijiang.yang@intel.com/

Hi Mathias,

Thank you.

I posted a series https://lore.kernel.org/kvm/20250513072250.568180-1-chao.gao@intel.com/
to fix issues and add nested test cases. we may consider merging them into one series. e.g.,

>
>Below is a small series with fixes and cleanups.
>
>Please apply!
>
>Thanks,
>Mathias
>
>
>Mathias Krause (8):
>  x86: Avoid top-most page for vmalloc on x86-64
>  x86/cet: Fix flushing shadow stack mapping
>  x86/cet: Use NONCANONICAL for non-canonical address

This will be not needed as my series eliminates the jump to a non-canonical
address.

>  x86/cet: Make shadow stack less fragile
>  x86/cet: Avoid unnecessary function pointer casts
>  x86/cet: Simplify IBT test
>  x86/cet: Track and verify #CP error code

We can use exception_error_code() to retrieve the error code instead of adding
a global variable.

>  x86/cet: Test far returns too
>
> lib/x86/vm.c |  2 ++
> x86/cet.c    | 81 ++++++++++++++++++++++++++++++++++++++++------------
> 2 files changed, 64 insertions(+), 19 deletions(-)
>
>-- 
>2.47.2
>

