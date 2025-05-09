Return-Path: <kvm+bounces-46006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15B7DAB07FF
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 04:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C9A250554E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 02:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B25B522F154;
	Fri,  9 May 2025 02:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6nlpGCS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D7422E403
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 02:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746758347; cv=fail; b=cst7HIUEyYv+LYdWmfOcZRWraiOLX5SymVojewrDVRN+LW2nPBnVlQRlbc5P6dIgNKGKZZ5rnnMkajeCiRKtqLQyhUW808q6ebPLxcazCVHcPbDLcl5tL34KDTGEO7udbFWmK2on0t54LoFPsZc+jHA7OOrZr55HJgJIe/ClZeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746758347; c=relaxed/simple;
	bh=9ZscjTud0qkq06aAe+ogm64z/FCrebK0FAruWsMRFd0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FYkkzv11cG86cgYdSOvGjfW9jh60XJI5wmZwgJ0e2LP0w4KZSF3wjfVN8xoKJ0Or3N5xCWDcuL7TYeuunNpyETZZKp0B8qbKiMGDFcokEQRlCbBu22Ivx4HmSC/y1sYCoInM92PvxNOegccwLSJvmPofZi5+OXKD9lazFiOKPRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6nlpGCS; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746758346; x=1778294346;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9ZscjTud0qkq06aAe+ogm64z/FCrebK0FAruWsMRFd0=;
  b=I6nlpGCSO40lZmMTT4UUFY6fEIRHSiqUbCtxk2pJhAseH1Ty+uN1Pwak
   /q+8dQPBTPZv4sQjMUOqecY9mhZ5K2bxhvyVTvBw+cHQceg2UIRk3vZXm
   oRKOIjSO+cy9q+bsfCiCTfKjn2rd2bM+HpcsM1GWWdUUJg9BhC1xUE38g
   YMavxBnvrIfbQrtmxDQYfzywP47b7UomrMWAVkAZT1AqBP9R0lgkEJyxH
   nYMqm9+hgD66wM3chCIa9Rx/7Z53XaqXFEHsnGcaaERP0qXDT/3ejoTGs
   84gJHj9ji4LzUCM7skAKoAUVZIl+uNi5PNp5N/vV8Iry35qHjSG516kRb
   A==;
X-CSE-ConnectionGUID: QonCW7jHQMay1Ev3/ZakXg==
X-CSE-MsgGUID: EmACZcw/R7+a8fbdWHxDXQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="66104231"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="66104231"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 19:39:05 -0700
X-CSE-ConnectionGUID: NzrWAadoQ+Ku1NIfV0+SGQ==
X-CSE-MsgGUID: DHjlQbddTMeYUt/vfDZrjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="136437913"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 19:39:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 8 May 2025 19:39:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 8 May 2025 19:39:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 8 May 2025 19:39:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQfNK49I0aDfwIQ1CAlyx40h10q6vfZ3b5n9EEOhJs1xYo2o+8k1TcBm0RovJREBdGtWht17EvZqBBvDJi4gpYddjQXjzx0wCOROefgLFFJiZo7xnjn02G/qYsYItws/mYnTDIxHGYTUkznSExXyA4GeRVoI4UkHLUXR+dhKCnIuWFThmJg4bUQap/TmS3bplQbY4udG+MI+PU6tuTQcoErfMYrcWKurw0BTaDBO95F+5CzjQr1AsUFa0kXXQGEllWVdRtgCi5Qe7+lED2v4eV4aUFFP8S26md8IOZf8m+bk6amPHi1am667ZJFR+jlTbKzqFer+Q9QMDG2/CU81rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ZscjTud0qkq06aAe+ogm64z/FCrebK0FAruWsMRFd0=;
 b=bIV1ReHMUPF6aoYxU1dKMdWKf39H2ikzI3sYnFcSNNaNtScbPQLIhB8YMxZ78RMshlxRv6y2NyWR3CYPNPKrWBdgi+GZ83E9/Mhvw/XXVCNtufzOx1zPJg+KRTVTyzZQFuIhq9xSgaxVTryX23noCjOYdQRO/CW+q3zD1feGW7c5hL6q3pL3ZSna44v/ut7nHa4gqHM+vUTt1siIkPNSU4sgBl1XCNYnrrnKMENj5p9usIo4/enT4B70eKhqYrJzpKGdRW+QnhwAX71EgFdv6PJnQGJz6ZlR6rUY1Ouddel1uKVSOVudzkGMd6AJUtae0gZ1oxqu5rUXzEQ7Gpaviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7365.namprd11.prod.outlook.com (2603:10b6:208:423::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Fri, 9 May
 2025 02:38:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Fri, 9 May 2025
 02:38:43 +0000
Date: Fri, 9 May 2025 10:38:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
CC: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
Subject: Re: [PATCH v4 10/13] memory: Change NotifyStateClear() definition to
 return the result
Message-ID: <aB1qqUGEayKbkL+2@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-11-chenyi.qiang@intel.com>
 <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c7ee2562-5f66-44ed-b31f-db06916d3d7b@intel.com>
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: c31ece39-00b6-45fb-7cb6-08dd8ea29d54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WFC1BwwFvfZx/KyAh/UQhEQtN6zsqFPS+AEz1nIab2BOe2n/1lJ71HvsTMHG?=
 =?us-ascii?Q?3jSsauv7b5vRAqjcjqF+lydNRzmPyXYzdrwrdwY0uRlP2RzzLm05nZ7WnNCS?=
 =?us-ascii?Q?G0ZB4TUirF2ZyOO8FTovBlw2DKSJhUnhkpL0vOC7nhuKGq7bo9eSWmNT+6T0?=
 =?us-ascii?Q?TtwsOY9ACp/UTOOgJz9xGK1MeOlBOPmb61G2Eyhx0BgEojsda8mtZaQ1m31S?=
 =?us-ascii?Q?kMrU25wiQU3m2TeJnQjfeu2RY1fDFSxDDKIpcv7r4PbFmTGoTzd/rLOFXmFb?=
 =?us-ascii?Q?DBLHdbuFNkCiHLNz1iSaneleq2HjBWSh73363/m6Nezq0arxlEhDPDK0Ppmb?=
 =?us-ascii?Q?SX757UJo3u81xrWnW7opzhSdNqjboYLMJL9YKNh5sqFwxI3o13CA9cyZaREL?=
 =?us-ascii?Q?BKzo9deXAPdSTSI2r8llmIGRWCj9Zue8/bf5y0fWyExpqMd40LMS844Eui5j?=
 =?us-ascii?Q?S28V54nF3pWJ2yl/sudXYBQ6GCje40TnJ/V2IYuM6Kams5KS2fDwi2S8vJF2?=
 =?us-ascii?Q?oTXtnt2znZBZcIGcUnzbtCipf2Wd31bnnxU+lvNAkJS+qD3DsBw8OStXAtWQ?=
 =?us-ascii?Q?FxOXYtGWiVyATrLoSqQlefw8hqHoicMqNEwqAfcNMATsl6wx0D8tMgspmfiM?=
 =?us-ascii?Q?jR3TwoC8VMdIzS3oCLDM/Syf295Gr1lIAWBSekPUDnOmV7VtsdEcy5Vp5pnk?=
 =?us-ascii?Q?5VcZE1xXS48iiWLiqZ6xpxoCXTZbObcYgM2v+O8wRZV350lZ4E7++G2BsT9X?=
 =?us-ascii?Q?MhK9KJd0HRzIp6iA1b+2TVhQ4W0b2FvBnGtJ0liu00aFyUIDmwYxbY6fs6ag?=
 =?us-ascii?Q?621GrHUKa8HTM/f8gSbJt7N0AwDwjNv+0l+7tBq1MwBtP5YMkrn/O2TsojIy?=
 =?us-ascii?Q?g1QqpmWYzdax/JA3eBe6ZgwmElJNxBj9S7NefHnPCnTIHAWGl8LjlrhMq17l?=
 =?us-ascii?Q?l9/n7iFAHClZczO1v+1mGb3lWXZ90mUG2o+L0dP5Fh0szMOiYyWPRb8byC71?=
 =?us-ascii?Q?zU1WGQfs8T6k0y2gPFl9HJxH6COLt2dV36Ly6G3Hr6LP/Lr5rNZSt5HSOPHP?=
 =?us-ascii?Q?126EOzW1B/KTSOOUVtRpuewfHAEFI+ofBvQ7+8EwW9ru9Td5b0lEzs96UwYa?=
 =?us-ascii?Q?/NU6cdZRaQ0DuSORhBbYMkfuvlE1rbgxHH5W7BKbEtgp8bvgWQPGkcjmTLbU?=
 =?us-ascii?Q?S4Al3SxPBOvdwwC1Fh8dmFPpe24cPpeK882+ho87/J9svGL1vG5q4uHx+QaH?=
 =?us-ascii?Q?jQ3SeqAAq9kemR+6SeGY9oeL2evXRECuI5Uyhr/dkNBQO/Lk+WfK9X1TWEsj?=
 =?us-ascii?Q?fhJBXof/1W0VbMChGvGJcwjBT/H+DiNvbdAYJylfBAPfZqBt0zDNzWImEHPj?=
 =?us-ascii?Q?23dIvFlSRDxmQKHIE4s2tEElcHzmiwFCnKYv/df8BJqkCHGE57W5kUYUKINi?=
 =?us-ascii?Q?VQ/5nhxxl9M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r6HEEqIWiHESVaAD8qELJBueyw6Nl8hoMTypbH7b1zlA2DIMAPGuY4ac8cR4?=
 =?us-ascii?Q?E8of6VgjzQozE3vZqBTQL0HkyUJPMHQau1n95YSgP9JWVj2pgDzm0Z5eCpCv?=
 =?us-ascii?Q?Sdjl7dyzHKKFgxlRmgHEOVNdplFfKs08ctDzrw9KfMswUO3glyaR+Wq1B9Z9?=
 =?us-ascii?Q?RSvoQvqWx0O+k5FnZW4O/VkPeqd2wNUmpbs/P2uxNIxaq+PKMnOMspjHKS1c?=
 =?us-ascii?Q?wbea6n0RhdyRKpryfvPJgozqREwqoOElI0cQqX/bgI/CeiWdRfleW7NYQat7?=
 =?us-ascii?Q?Kvt35LyVxClxhzTifGVN7t6wBt+rKLzIDIxuJycBiBvINdJS99tVo7M4Y2e5?=
 =?us-ascii?Q?eQ8tdYjxQSj9lr/3pwN88iR2oLjAfWkCO4NNqL2KTKhI+nYo4A+Sc9+C0AWP?=
 =?us-ascii?Q?Pf9Hjs2uqaEQjXY2yALffe9cx2DdiX7xvJZeWxMhVHtC9nSVJ78vok5eLq3q?=
 =?us-ascii?Q?T2LQdn1R4hJpXq1stER2V+KZ36Dab+Qzqz0kKZgtcAKqAIB/ebC8dwb45mUO?=
 =?us-ascii?Q?X57vntQETjrK8ks2TT5bpr/57m60DjSgxyWLU/SF70+amQNFU0Nx3u7rrQuf?=
 =?us-ascii?Q?dYv3b1Y+lKkHmPODucBuwyKDLXTteMV+za6Fg+1Gw8WTatClq148HZd/Tk6E?=
 =?us-ascii?Q?IK0SQ7ds2FDzXv+xG/dZuVNGb5hAiYrkU30/p0zxWPgMmGCTtbQyQS8cJuUh?=
 =?us-ascii?Q?LaBsPZ48hsIKrIxxRhe6RKEDgFtjzFXJZE4dzdcBV7kP3RY/hO+DpKKyFo8y?=
 =?us-ascii?Q?bjzpvmFJFsu9bBGcbh/qibpIonw64xBVP9X4C9mwXiyMZfCWMe3tMxXA54SS?=
 =?us-ascii?Q?tnzQntSt+6sxNLKxL5XJbTR7nqFPwoxkyq3XZfHVlkiBO6EDnYIgI5SR5pXp?=
 =?us-ascii?Q?ztq9L2v/n07crERek6b7PVfFcyUcpZRBqm7uhVxzNSEEGVIRAV6YeC6KNwAG?=
 =?us-ascii?Q?J5CJAb4dLhdgNk96SlaQIv02z8HJIqT69Zlev+VRHqoKKmaE21Q15qx/k3mV?=
 =?us-ascii?Q?mvtQeNQ5k55ju/0TbUGvdwyG6uTtwdOCXFQnrxQhRk9L2z/yu7D6qWTFgxii?=
 =?us-ascii?Q?DpkQbRO6sdzAUH2rRsMQyCegvtjhhXD8RypqLYji8eKXGaGBOk9MS4XGvGVX?=
 =?us-ascii?Q?LtmbGZhUjALvQqNycCiqMMmgo0hbxdJKZe7VQ37w1yi741DpL1aask7BoJBp?=
 =?us-ascii?Q?asvEjFkJG5GQctRLjaDXQOEDMRcbteK0zE3Xw7oqWjxuCnxlHbpTXOzB2PsE?=
 =?us-ascii?Q?dBkczY3u8UpQtx84z6+J+q0np89pxolMZlx0A+cZmbZS6PVMrpji8mKpzBol?=
 =?us-ascii?Q?kfcEGHqMTg6izmzgJktNlJFmOzONUxmn/SriRuXwm7nifSKnVbSYRDv74dGf?=
 =?us-ascii?Q?mHcgHJdTNieI/ZQuDqGS/0kiYJ/ZRnn3fwm7lAoTvXgVjL3QFiVAsVLo1/tA?=
 =?us-ascii?Q?AzPnmX5Ugqe1cWOI+Q4mKD+20YOLb9vK1rwbDvoo6Z6ER+FHdx03TyO/X94W?=
 =?us-ascii?Q?rHRotXIpmGgfHRoKMQ5zz/mcRgJJNyYBN//784tVvlHEKQb2frH35WGEhl+R?=
 =?us-ascii?Q?oCXgeBDd/vxz7JfbstkMaeTkT8TSmM9uxyFvM4QW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c31ece39-00b6-45fb-7cb6-08dd8ea29d54
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 02:38:43.6418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NAKc5YIVg9iwtlJsxpSghrqBrZXtT4JJ8J4zM8XEbByPRV7GQDoHXciE18RNZUaGV+/hqihYEzVS96Ky9IG+8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7365
X-OriginatorOrg: intel.com

On Sun, Apr 27, 2025 at 10:26:52AM +0800, Chenyi Qiang wrote:
>Hi David,
>
>Any thought on patch 10-12, which is to move the change attribute into a
>priority listener. A problem is how to handle the error handling of
>private_to_shared failure. Previously, we thought it would never be able
>to fail, but right now, it is possible in corner cases (e.g. -ENOMEM) in
>set_attribute_private(). At present, I simply raise an assert instead of
>adding any rollback work (see patch 11).

I took a look at patches 10-12, and here are my thoughts:

Moving the change attribute into a priority listener seems sensible. It can
ensure the correct order between setting memory attributes and VFIO's DMA
map/unmap operations, and it can also simplify rollbacks. Since
MemoryListener already uses a priority-based list, it should be a good fit
for page conversion listeners.

Regarding error handling, -ENOMEM won't occur during page conversion
because the attribute xarray on the KVM side is populated earlier when QEMU
calls kvm_set_phys_mem() -> kvm_set_memory_attributes_private(). Other
errors, such as -EINVAL and -EFAULT, are unlikely to occur unless there is
a bug in QEMU. So, the assertion is appropriate for now. And, since any
failure in page conversion currently leads to QEMU quit (as seen in
kvm_cpu_exec() -> kvm_convert_memory()), implementing a complex rollback in
this case doesn't add value and merely adds code that is difficult to test.

Let's see what others think.

