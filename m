Return-Path: <kvm+bounces-20795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D13D91DF7E
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FD631C213D6
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F212158D96;
	Mon,  1 Jul 2024 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J2XRIRuo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D54413213D;
	Mon,  1 Jul 2024 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719837494; cv=fail; b=gxq8ESmO9wNr8VzPySzHLpeFhinmNb8dTGI6fIhTeHxek4at1FJCvd41bx3u7RC5fWlJ0g2d7euCsKZN+hAyXKENT2Q3lB21byimZawBm98j1+zsAjgCNnsS52kgeH/P15JcIZHXNgmQvexiA+Ce+p6HIqKEUC0eY5TPAx/pNBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719837494; c=relaxed/simple;
	bh=Bx2KIvBHZvoIM/AmxUlkZxqYaHQUq9T5CYf2eTzDDrc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gikjr2F+T0Doah/V8wh57zqHR4isBoqowHIvMzhrqh5eId57e4i+j3N0sPkzWKBQWgNhhXULg0CkfwZ4HTn8w+QFUOGfgZ2drTSLvll14FoX0i5s1IgAn48icgqVrwjDR5/J577JfFd4n8BveGDUVcc2FC/6tIXe4yl8KQWEAEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J2XRIRuo; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719837492; x=1751373492;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Bx2KIvBHZvoIM/AmxUlkZxqYaHQUq9T5CYf2eTzDDrc=;
  b=J2XRIRuoPPaF/wO/0qOEImbYytduoEcVOIHDRLc7AxAuQAt2VDVyfgBx
   duHnBbMJlTyL1ATEMgegcK70RLYGkDuMxZgUXbE1/g7WWuiV7K0reTnSq
   7Are2W7W6Kd/1aVMvaBrcbIGQK0ysOru/1AxqLgP5sWdv0sv4eJTX8bdJ
   ZAku2JN7UyI2/Cy90IEobF+/M4+3ZIKCKmRy9kHXdl2Df3e/Hm6N5GkSc
   Vjo8gAAtWeQ3WYf3kZcQgoU9Q7cchWNJ3fbhos+ImVpK7jYqV3iAmW78M
   k+9kYHV8ULcCELPC8EZIpgnlnPK1NTv0jmxFHnJqV0D9CxlKbHMo8VJ6i
   g==;
X-CSE-ConnectionGUID: rri33GgCQYGsUAeqyRsIWg==
X-CSE-MsgGUID: ij9xqSGSSJ+6MD8g3QlgjQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11120"; a="17089358"
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="17089358"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2024 05:38:11 -0700
X-CSE-ConnectionGUID: 6v9bIWSaQkiIXGXbfZZ8zQ==
X-CSE-MsgGUID: 8ZHTRCJmQd+h3YI2VUFySw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,176,1716274800"; 
   d="scan'208";a="46169339"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Jul 2024 05:38:11 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 05:38:10 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 1 Jul 2024 05:38:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 1 Jul 2024 05:38:09 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 1 Jul 2024 05:38:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTkibQCoPcK9R42z6LUPstgejM6f769ZNBv9RsKv8CobcTMPIwq2DQXrwybsG3YH5zZBQLxMdfy3VVJHmtBQmGChW+Q/VhRtW/Rx2t1KeeZfKe240edvq7yA3gjPyDs53nJm4wndvBTQ7mIonUKETm/oJD/Uj72gBoMKPrcUxjW0O/RTM/g5zc/fTkAsWfaaYLwNos3P5LynjIY0D+ATEk7KdpCo8Of6L0LzwPL6crTDXwDL/3k62V8uV7fEZASuK07Gho7Tz9hE0dQqZuYOIjmvPdaP0qVLMl3LdN+QroswMJ/SXHHq5XJi9WGmXESyPILjZy/SE+cY1/Zdz5JfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4i+AN23Lp0oBfsA66UHBnsl/m/WyJKoY2F8NDmPJDU=;
 b=Ul0QwoEq25poVbcClgMb49ieuP4D4Z5x3O7aZTSUYiGwkN88ZESmQYCuogb7VVnIPn3XoEcheUqD17YXzq0/QT7eS9RjtL3qIvtfSxVUlEKMMU8kaLF5ze++M9VkS6BO7Jhi3U5jp36d0loOGI9NdKOOoRt3i52UQyR9qdqcB8+Ia27num/JzDagv13IWjKSHIt5WBdFkO/7UWaQFyt6buFtcFsq98woT4xnQoUAlLsM9C1Danbilxn7j6Lnuta0KZrIzcYlIna9v7Pnpa3EkTEJRdUIrCxmn3EZLJMmuGlCGlTsIpo5n+Kn4dGKezs2Sq9592JsoRwXJwcgxVslow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5782.namprd11.prod.outlook.com (2603:10b6:510:147::11)
 by DS0PR11MB8082.namprd11.prod.outlook.com (2603:10b6:8:157::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Mon, 1 Jul
 2024 12:38:07 +0000
Received: from PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::9696:a886:f70a:4e01]) by PH0PR11MB5782.namprd11.prod.outlook.com
 ([fe80::9696:a886:f70a:4e01%7]) with mapi id 15.20.7698.038; Mon, 1 Jul 2024
 12:38:07 +0000
Date: Mon, 1 Jul 2024 14:37:54 +0200
From: Michal Kubiak <michal.kubiak@intel.com>
To: Jason Wang <jasowang@redhat.com>
CC: <mst@redhat.com>, <eperezma@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Dragos Tatulea <dtatulea@nvidia.com>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH] vhost-vdpa: switch to use vmf_insert_pfn() in the fault
 handler
Message-ID: <ZoKjIpwno/84WQK7@localhost.localdomain>
References: <20240701033159.18133-1-jasowang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240701033159.18133-1-jasowang@redhat.com>
X-ClientProxiedBy: MI0P293CA0014.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::14) To PH0PR11MB5782.namprd11.prod.outlook.com
 (2603:10b6:510:147::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5782:EE_|DS0PR11MB8082:EE_
X-MS-Office365-Filtering-Correlation-Id: bb77ed77-bbe3-4cd6-5324-08dc99caa8d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Wy1Nkftf9B4T58qHgnYNvfxo6YzwniXFyn4yDBldiCVzeBCzg+kbvsraekRF?=
 =?us-ascii?Q?91vu+r4w8baNIvWG2c0rlOAgsBX6YdRijCDApVvMMuU+WWuTY4qu2h94qsvz?=
 =?us-ascii?Q?lmg7lIJ8fVwpnydXxoFLoWdVmZ1yzxT2pIGuzR6TnqjP2L5VOCeiZlcxFAmG?=
 =?us-ascii?Q?9zBZDJM8eKJltkM/kEQtGw2ygdp4S/FEf57uLGed1RLqDQyS10/VzP/hQq8Z?=
 =?us-ascii?Q?Bm7QyoUNW76YC6k3wOuvwiXIpMB+KONFp9Qtgb0R6wvcTTOAE0mP0JAvKRRG?=
 =?us-ascii?Q?eByx1cL7O1Q/gcl0I3PLscNzfN8Z9Sjejtrhv3NvgFEsbXGqXRRAU1PfDzL3?=
 =?us-ascii?Q?eiGyuvTqM0d4te5vnmgAvn2OtqW4zyVwWhkEShcZNISz+3wiJi0+YxykYPPm?=
 =?us-ascii?Q?0y7ME+J02eINUmGHVEaABZ3NROIdOInljxjO7q2F+FhVCBQiNPHuMO14lbXt?=
 =?us-ascii?Q?/YKx168YDqKpyVOsQYUuOmue6jRsb75V4wYwZ++Jl+9G3/sCKj1/kosZWdAE?=
 =?us-ascii?Q?GlcRSXwBHwqtX/q4GSIjw7L+evvFtQVrFqMC3wxm63MdNFmCJa80ybiZKEHO?=
 =?us-ascii?Q?hLFkdBWgJXOtluycOvfc8Xz/V6RiJ3fFJm+NB70TOGBeWWpzA553i+RtLSr+?=
 =?us-ascii?Q?WBRdth7XtYYLt9rB5yUwrnZY1Ms+YU3sI55Q/ChVw5CabZVQLsTf40UaSHit?=
 =?us-ascii?Q?vIY6tw7i2IUgoFcPN+yc9JOkXnacOTU0IuZ8b8m0RmQFEsNzC0pHle9XYdQe?=
 =?us-ascii?Q?8mHlDxjNNQ1ea5u21g5ZZXxyCuej0t4+pmmkNuMJ6QS/0GaBcEdCEZf717Cg?=
 =?us-ascii?Q?9voWngk8bDZHnMwlIlQfjy3QASaRRVLqha65CXvyubu4atCMmvk9V0OVQSAt?=
 =?us-ascii?Q?LFagmQk2Q7AW8cvTLtC8mmrgMzggATy4Cvbdub1cA94hh88ZmBOJVReSTkl3?=
 =?us-ascii?Q?X+sXOCSkqfEjtZseYPWXfpY52ywciMu4H6vIAYR4C9qDpGM+hPg29GQVeZPB?=
 =?us-ascii?Q?n04csiiWlyTgDwM5sGBo7G9KJukCNhUUSCgX07AEPlBct7yKhXE0Pn47ZK7S?=
 =?us-ascii?Q?zoZmE7Vy/fdAN6MnbR5poopi0/YjCUqXRXpHPr0YH9a/E+jZeeqzvpBEmxlG?=
 =?us-ascii?Q?Y1eJpUzxfd9io1+xKF/Nbua6ZQCyG4r6lfIvevQccakWeqz6PYukoq+0CXBn?=
 =?us-ascii?Q?O97rLVaytTu6VC/5FMHQ2VnRnSZVcqnaxq31MjAB/pbCyoTYy/TQwpHZW5MM?=
 =?us-ascii?Q?n0KtECf7iZPx2HPG0K7lzoflVrUPcOBHY/fe8x2W+wVaAYfrpF+/7BPJ9Rqi?=
 =?us-ascii?Q?4Tz0HcTk+QsUl5MWKzozUo0s8LSjR9x8L7MfgcW83MWFvg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5782.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sEa51xaSiirb0aoeMR5638/ATXWrqMxPMIltSEZrhVBKkp/IJlrPrsdb1ZTu?=
 =?us-ascii?Q?YwWgXUpY+mylGZquBmrIzMTOvdV7rEiaV/wxHIEiKM3ZykuOzBxM2XB6tX4m?=
 =?us-ascii?Q?TfwbtHz+TtejmTNo7GWfrikC/hKchsYDf/t2kZM8dkhZc8A9buBcNJiryw0S?=
 =?us-ascii?Q?7e4Ooq0DvgaxwzzD0SEn2Jr3U99+FAcCcvTJfebST7OENSeEQ9Sk9+hxRFcp?=
 =?us-ascii?Q?BHK22oZ2Ja5Z4eYjlIpOy2R2KBYbweJgWA9Eg6S3+PX7a3Kc7L+GnnOQ7uya?=
 =?us-ascii?Q?c74j2HN2KHDpBOFlGTf/d+5Z7NXOo+zjw6ZB3d+5RYxPi7Uxb0X6Zlk2yMmz?=
 =?us-ascii?Q?BM2ftNeuY7SYpDEdQFWT+WEA2437bHVLPMZztk0xsbnt1mVDuM4WLY3V4yuG?=
 =?us-ascii?Q?GTcMFqUUhQSl98f5O8wgfzzuPjDw11dz6k3Uf8Gnd49I0KtY8s/4eIfnZO+v?=
 =?us-ascii?Q?iLYl5I73sC6GuB3Pv/RpybvYL74+AJTRsXW44HjhfrlFWa2JK3cIJyld6dtX?=
 =?us-ascii?Q?E0ErOIJwvC1q60W3BMy3L1ubogoUA4KbLycu8fFxM+VGsC1AKtomDU+0ZnHY?=
 =?us-ascii?Q?SZOmaZvyOfuF1DotoG2aRopsJC+CtYBwizYiwIjpqYcCOrHFkPNNUiwpLe7S?=
 =?us-ascii?Q?uMiZfEjhNP72rbSDe+f7CpEl/cAUTZChDlT0fiDQknhXMK83Lu6Zj0+1jbtS?=
 =?us-ascii?Q?RqF8TAmdjmMU4cRuMgkTE141NhUFbVp2JEW5bLp41dqFtknx6D2fIdg4bFsZ?=
 =?us-ascii?Q?0ImywzWWf1nyNKXRztrPjV7CREYx0FIscBooo7gKF3FcfV+l9zdnbnYxMynf?=
 =?us-ascii?Q?Sxa8c09RKjsz9B0bq6of4/Q9B7Bd+j5fz+imPl32JE/ijBpB30kej/NPSbqp?=
 =?us-ascii?Q?WBK7OssNLkkMNwMe/awSD/SCtd6DpA3+MmpgJGm0S1jJoL/JT6HfvBMmmv5V?=
 =?us-ascii?Q?xJwx2MDDS0OMGZ5hu3V9DaZj6bNyIkZJEVkqAuJXwZfz8sqTu+AZ+bSya0ud?=
 =?us-ascii?Q?EZ1A8nN541z26nBN3e1rrhFrgjVrGVP7VfqarjNPQDDL3BFi4Gk1bIe0EDM2?=
 =?us-ascii?Q?18yYGXRQdXC84kxd3SZ+kVCA+y4k+BtTe+2TML2dXXX4fOLajVV0VytXl8s2?=
 =?us-ascii?Q?kDc6SC6IWByLkDk0nTbUl1HzwW8wnwXi9KbAoL1GEFCIL7+HiclLErsDQ4u6?=
 =?us-ascii?Q?Jhi+S+fcj67zevD/yrdKw1os/WuvXH+BEOfVc91tKzbCqsDYq0ldWdZHAKuk?=
 =?us-ascii?Q?bNHzQ4ZkAVshNwUcQN8GQbWUy7rLrB485REY9O4lcOb7VSnf/R8aapllLrjE?=
 =?us-ascii?Q?lx2+P7Tq8NYT+Hdol9f2ZXBaqvr7unda2nN70XEDZh+cBQAu1kDmOIpgwM41?=
 =?us-ascii?Q?3gu8YWNFXkrOgHjYDKptBLPMsrqBsu0AbKX7Rq7cidxpIrSbU5IEXKvI7mmb?=
 =?us-ascii?Q?C5eSCeWCIWaN6Bd79FhNclRZkdBbLtAj9oVHVWGsRsib6GYhK6cnvnPBGn6G?=
 =?us-ascii?Q?cIVYSdm80ezCv3RJMPbNRZyH3gQIDe7vlSZz6RQ50zqRvVbybWU3dY5nCTA1?=
 =?us-ascii?Q?ThsV9imiqNM8v0wM5PNluAaw0g1REI6q9xRhO2U2pqc1+T+sE1ZS1hmcGEuG?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb77ed77-bbe3-4cd6-5324-08dc99caa8d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5782.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 12:38:07.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RelBZ8OtdsWehJ8pyNafKQCFKegec9LA/EaaCoTw0O3j0TMW66K34+4F+2B37Qr+qf3glLVH4OGQ1zppRa9pPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8082
X-OriginatorOrg: intel.com

On Mon, Jul 01, 2024 at 11:31:59AM +0800, Jason Wang wrote:
> remap_pfn_page() should not be called in the fault handler as it may
> change the vma->flags which may trigger lockdep warning since the vma
> write lock is not held. Actually there's no need to modify the
> vma->flags as it has been set in the mmap(). So this patch switches to
> use vmf_insert_pfn() instead.
> 
> Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
> Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 63a53680a85c..6b9c12acf438 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1483,13 +1483,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
>  
>  	notify = ops->get_vq_notification(vdpa, index);
>  
> -	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
> -			    PFN_DOWN(notify.addr), PAGE_SIZE,
> -			    vma->vm_page_prot))
> -		return VM_FAULT_SIGBUS;
> -
> -	return VM_FAULT_NOPAGE;
> +	return vmf_insert_pfn(vma, vmf->address & PAGE_MASK, PFN_DOWN(notify.addr));
>  }
>  
>  static const struct vm_operations_struct vhost_vdpa_vm_ops = {
> -- 
> 2.31.1
> 
> 

I would only consider pasting an example warning log. (It's my
suggestion only).

Anyway, the patch looks OK to me.

Thanks,
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

