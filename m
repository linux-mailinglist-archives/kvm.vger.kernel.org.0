Return-Path: <kvm+bounces-53311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE305B0FA5F
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 20:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D577A547AFB
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7EA0226D00;
	Wed, 23 Jul 2025 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dCVG3xYP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46677155C97;
	Wed, 23 Jul 2025 18:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753295942; cv=fail; b=A7Peb+eMrJ7yYt2NMaHKFCTJPMHFbyFtO7cArlUZOwznys3moSDZGxNHdLRJE6fKFXY8PSNHCddBSlQ29ySXS/PyYgwfvjZBaruHYDKpGLN2hO/+AM/CxCP6nlhWWFINL2mzRHGFKdcfCXSubmPFY8uZl9Ritba4IJk0dpau6qg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753295942; c=relaxed/simple;
	bh=lshl2hBRjVvHKaqlDwooR6myvdE+ZtJpeDBghAxedTE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ll+QE5yDhps4z/oRZ38ofihjJUrnRrSFaoQoY5EVGBU4t2wpg4UMjQnVISjtOXenHmJJuTZSPVsjAUtaWprI8KzRz4qMsDznuW19wqxlmO/ckZOBYGBttlqmQWyncFPLxmN2+SCRQxSdax+jafLv50iCkJmrzyjJ3BvqCGe1zFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dCVG3xYP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753295942; x=1784831942;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lshl2hBRjVvHKaqlDwooR6myvdE+ZtJpeDBghAxedTE=;
  b=dCVG3xYP6qORZ0HLdA1wAj0UO8bh6WzKTk3kUUrOlvRnBTOavBBd5njX
   y7ba8CNR2jjywvdAX5UfHxDCu9ybYXppH5ei6d9bZ5DNdBXxNYpSWNgYV
   7lLlxzePzvLp7ydHHwSnOJU0bCvdVp92etHRi8QK59poCAqaLE/PS3bxj
   8YcNJQaZDILy5YUwr/AayIxCcD+kA7kOqd3jYhoekHnXDQdaUGH5gqg4v
   jgADVS4xeCtj/F6lXGEGicY88DpYTXmba3tMnLrw6mmNGLB/rJJsGI9m7
   JpLTk4wddMfg9/Y1GmalWjKk0U3e5895lFEFilJ92r37zbpFeEbaWAr5x
   w==;
X-CSE-ConnectionGUID: JmoS8vJuTXmjc2QdeU8euA==
X-CSE-MsgGUID: jc7BdW3QTeGz6CYS6JdJ0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55439660"
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="55439660"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 11:39:01 -0700
X-CSE-ConnectionGUID: +n6iN/pERY645/RsGDKLFg==
X-CSE-MsgGUID: 3K3UROabSBeqND5OZORj4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,335,1744095600"; 
   d="scan'208";a="159762075"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 11:39:00 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 11:38:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 11:38:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.86) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 11:38:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ums/nFdKNQ8BKNxMkgiOsUAHNQ8SpLzyNA/X3JNqNCmNmiJHAzk+w2aZrKbh+lb5s++Q3VEK7UIpuxdQfcgz3I3OBvKbN9gXyfksQNnnJOkVuyetBwsXG4dsTu6hAEWF1MD7rJNkPM4EoYcgNv36q7rsLOazYU+CNx0b33b1gwbvEHIXtTWe0mbBFbrd0myiAlv9hIMIDVGz4rRGZE2z+vSlfsOJ3mBZxBLtzmoNvxeOyRWg2SoKZ2pvpxF/4b9VniSt6hwI4zg/lvL0ky9KtyX31bMHfaXKEhctddtU4KLCk3PFzZ1xJ/2hCF10gUa+Jwfzyly9rBfmOGRXLbt9Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MK2BT5nluyT3DGCimgZAXGotLqd6/ziokbTLIbjVz2k=;
 b=NzvWHGLYYc8ePX2oIpEBCWgtrBEiexz0XqoPjhXeoHlOM7twdExuufdVjE5WwRdtsgrSu5iZC8lGRJTON3qKEC/IbK30DVvECnq4KcQzy/CECcA8Nod7Bm8+VBf8ixKw5m+JHFmkFtS9BcuuFmORWd60CndoUyVCGtcE0Z6ZEbanJvNO8Lj42gQCERCebu3MmUP9DGFQ7ZMKvakvrNXxf0CGB8wEq2fcSUau3OHit7bF67l6m7KC0O+cr5ROPp1m+R3imYdvp5kIInTfQSElsRMo3e3c3XDzsufMYktNAn1X1FDRh4xRVTg/mpSQUUtxN1BCFbjWliqnR1foF8wYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH8PR11MB6730.namprd11.prod.outlook.com (2603:10b6:510:1c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 18:38:44 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 18:38:44 +0000
Date: Wed, 23 Jul 2025 11:40:28 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: WangYuli <wangyuli@uniontech.com>
CC: <airlied@gmail.com>, <akpm@linux-foundation.org>,
	<alison.schofield@intel.com>, <andrew+netdev@lunn.ch>,
	<andriy.shevchenko@linux.intel.com>, <arend.vanspriel@broadcom.com>,
	<bp@alien8.de>, <brcm80211-dev-list.pdl@broadcom.com>,
	<brcm80211@lists.linux.dev>, <colin.i.king@gmail.com>, <cvam0000@gmail.com>,
	<dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <davem@davemloft.net>,
	<dri-devel@lists.freedesktop.org>, <edumazet@google.com>,
	<gregkh@linuxfoundation.org>, <guanwentao@uniontech.com>, <hpa@zytor.com>,
	<ilpo.jarvinen@linux.intel.com>, <intel-xe@lists.freedesktop.org>,
	<ira.weiny@intel.com>, <j@jannau.net>, <jeff.johnson@oss.qualcomm.com>,
	<jgross@suse.com>, <jirislaby@kernel.org>, <johannes.berg@intel.com>,
	<jonathan.cameron@huawei.com>, <kuba@kernel.org>, <kvalo@kernel.org>,
	<kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux@treblig.org>,
	<lucas.demarchi@intel.com>, <marcin.s.wojtas@gmail.com>,
	<ming.li@zohomail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
	<netdev@vger.kernel.org>, <niecheng1@uniontech.com>,
	<oleksandr_tyshchenko@epam.com>, <pabeni@redhat.com>, <pbonzini@redhat.com>,
	<quic_ramess@quicinc.com>, <ragazenta@gmail.com>, <rodrigo.vivi@intel.com>,
	<seanjc@google.com>, <shenlichuan@vivo.com>, <simona@ffwll.ch>,
	<sstabellini@kernel.org>, <tglx@linutronix.de>,
	<thomas.hellstrom@linux.intel.com>, <vishal.l.verma@intel.com>,
	<x86@kernel.org>, <xen-devel@lists.xenproject.org>, <yujiaoliang@vivo.com>,
	<zhanjun@uniontech.com>
Subject: Re: [PATCH v2 3/8] drm/xe: Fix typo "notifer"
Message-ID: <aIEsnEQ4TksaTkAB@lstrano-desk.jf.intel.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <63E6DAC34DD3C878+20250715134407.540483-3-wangyuli@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <63E6DAC34DD3C878+20250715134407.540483-3-wangyuli@uniontech.com>
X-ClientProxiedBy: MW4PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:303:8f::19) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH8PR11MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: c18a3656-77c1-4be0-4ffd-08ddca1826f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qLaMxSgdqLaWClrPicFnOfxrFxa0wpL/EM8gFWxY+6g+CO6Vd1MkqpPPWH5u?=
 =?us-ascii?Q?odeGIM/nSCf4adMn4eW7yqKI57tsL+oltnXM37YlB+TS3aU8yUyucji7ws3X?=
 =?us-ascii?Q?PTS73VbIovRNlpYjXT/KWJDxBtjTWwp/5Z2hxqHAnyp/uzWJcfPqBZPJVPNi?=
 =?us-ascii?Q?EMvml8Oqo/Y3PrBuAD+hm2wyLNWUkDtK5CQgsQMyydEdUhEdNJN2gN40psKQ?=
 =?us-ascii?Q?bb4vh2qpv93h48jxXzJmHI5K/4kXJckNnamDeIp9pmgjp5fgj0coD4u4V8YF?=
 =?us-ascii?Q?X1UZTRnMcwykCfRge3c44GW/CcHmnI7TOsPVlsGmEZ06Uw5HO2iLlPttZs3y?=
 =?us-ascii?Q?j2SV2BxAwpGXaYMhklCwR+m9KzDXRzfMBX+v8DoO9dhbj/SWh7zBYIjIRcWn?=
 =?us-ascii?Q?FAaec1TcTT99t9vxLN1gZ9+zB4WyKbX9t3/r0LQEkHgkD2m1jFVBRbzf64Xx?=
 =?us-ascii?Q?ZiIxNwTkonOkYeHfAGvV8ER3JL3TvH7jmzYyi9nvJIe31hwdQU87IgDX5tAq?=
 =?us-ascii?Q?+7/aFLzjmXlpSWv8/CxozdWG8+jGbOcoyh2yqpkLcbB1DC1858PPLcX9J5Cv?=
 =?us-ascii?Q?yFHPp/zFwBqyF13R1XRjMPC+ON0a+jyXWN4Fkp3jr2XhoWm/sXQG+DlS1Smr?=
 =?us-ascii?Q?RZFj5fe24nmtuGWS0mfhPlVg6oPkxUdz4scewGWprYQKeKnATLZbTuMjoVs7?=
 =?us-ascii?Q?Z0cDH6cOB9YCbLPH6dv93gAGvF5FfDBPCu/JMp0yhha23p8uFotQ5oGQOtqB?=
 =?us-ascii?Q?a94seTkcKLwtIOQQNg5IJOa6H7zgoVKfI81jcBOMnBLPCoO/dqFPzETJHkkx?=
 =?us-ascii?Q?ehzyqH/SGp+OVoiBVuJA2Q/wBq0Zbsk6yKQtMZoCtTHvUbdMmZJXPLIPh8OB?=
 =?us-ascii?Q?TN8AnlBLFnZwInQYY/kHZQYoXsXHX7qw2yGMf9NCLsMy/lc9+ipart9Xzm/n?=
 =?us-ascii?Q?q7Jo0ASBDQ1Phq6jgk5vAvU2Vr3xNVhrID300wmX7SZPxuirxdsOvn16eD4o?=
 =?us-ascii?Q?wKyqyIofDYO1hbi4WKakkg18VwUb0Syx7HRmrb6MWsGAf8Rqp2QBNQpcKdsE?=
 =?us-ascii?Q?DBk7JcqpG+GbriQU9MLbu3PgPJppg6mvVm2uV6R0bB7fthDbtp1kpUiB+D3h?=
 =?us-ascii?Q?Gdl/LU8E7bbHjLbS0c5LXvHISLdrMXFos+IdsInnlA69zCc0vKeHlC+uFGTL?=
 =?us-ascii?Q?VRTWjYUOpjUVWg0yWCe3ytGqkIGRKzG7NVnfewCIVXZjPqYzdl3ixWM40XwJ?=
 =?us-ascii?Q?zTaaW36+e2kpOdC1rzSC5M6V9zpoU6JqW39PecHdM6qyjVIZjcWcxbbyEyeu?=
 =?us-ascii?Q?lDJHACndDLmURjOsyTqXKPyu0QI95mZqoP0cZl75Y1UMB50xSCN082X1bU7g?=
 =?us-ascii?Q?MnRV6gUe5Xbv+M560XHxUF+x8yHOlWqMqNTVZOWO+ybnUrAQ9XDYiImqm1ja?=
 =?us-ascii?Q?/naa6bov1PA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I6dQSZa1OhCvg66/RlIIrzcPrI2qvtg+uB8PgONvlCCC0pBTd5C1kQQyGExq?=
 =?us-ascii?Q?oO5NPBaZJrr42hEYS7Ddo1fx3vUijFXahnRZU0ciVenl4eBn1C/BHipceOJ8?=
 =?us-ascii?Q?admbu0dYvjQZzLAwQ7zT7ojd+dZeStm8fA3+JyMLHA7F2QV4PSReVoLThPsW?=
 =?us-ascii?Q?qEap3SkEXYywJcAicLGYxbuluD12LDMIy0Qy9GESB+pCC74XkTJFsucEdTjp?=
 =?us-ascii?Q?VkxeDb1fscrWQimtvbcmdM175UcKM7eOaKRe+DrGrdRl/lRB3eddPEsXYwDP?=
 =?us-ascii?Q?EImxlJ14NsjzCEetz0YQrWpRWeQcLo/E1e01deFunDZEbDEw0ZpdmEu6Waio?=
 =?us-ascii?Q?WlbnoprnEgRaSOFkVeMTYBlr4phfE2eUfXMUDhXrKWaM70q0Rt3eidhxWIOi?=
 =?us-ascii?Q?fx9VPGqXxv8j/Uobktw8gN8oM104BMePz/rxf+w6DAbCoCZvxzVi0Y/6CXB0?=
 =?us-ascii?Q?L5W60vHWLqNf0Yb4wlzJcXihwGvbNAvE+JjpOd1iapu2VXYpLReg0tJ2Evkd?=
 =?us-ascii?Q?RLhzF+5Tgt3iuWxQspSvEGJp0viUV87UASBNyvZI+o700841eTvBzfgF2Tkx?=
 =?us-ascii?Q?VvUXFdEJNDac75qbU105XCsKzrsbetXgEP8xge8lz/jbFynZ/eFyBcUUv49v?=
 =?us-ascii?Q?xBQx4pEAtiGwgTPvg5CAwt35kQFQJqboB1CD9BBwh3rZhD8BYXppHHlqymB6?=
 =?us-ascii?Q?IWZx1MF2eps10+lpr5T4zNpp+odMTP79yt8/E1yPTSyU+bwl0lrCf1N/o0eR?=
 =?us-ascii?Q?S90WOMa8nTq+abwBzV9ZEe62KpU4gN/0lviD64yrN0jeTeviV1qMV173dN+T?=
 =?us-ascii?Q?5L8A9o8/3vTvCJj5pVZJShVCsqkCqa0Oeh0bvzjL8x8MbgTtUx/gAXESiQqf?=
 =?us-ascii?Q?4sv2K9egYiPwKgrxjblMFzyz+71wLf3SazrJVO4jbTAYZUZzCXBzP0WkouLp?=
 =?us-ascii?Q?ZwJ7xI/HYBfuw2yGUt2ObXC216GKi5SVqcTtgFNe4qHF0Jp2DG2077pHKHyZ?=
 =?us-ascii?Q?8f+LEkJBjdfsDr+z0lX+3BJ0ckPkXCHIW+52/uEurU0kRuxGrVL4L/FnmEON?=
 =?us-ascii?Q?A+cUeHEHdzayQD5ITDXNMtHtgb2mfCNMQj7vbpID+c1vs2mmvVSKvwE2PSLb?=
 =?us-ascii?Q?g8X/3eZlQMpOfsrNrYbber/0bykf1o3hI2rfkuPJo2DIRAtD0AQ0y1rag3wg?=
 =?us-ascii?Q?IjnSOVxjO8P+5D0ZdeRrVr2DDew+R17cmel6IlNQglIDgL6Qo5OE0okS2k5u?=
 =?us-ascii?Q?G8dgptEGbpkpz5ODXlrqs5rA2dDcvYsniyRKyHW57OrxUK5dVNWZKBAgCVe4?=
 =?us-ascii?Q?7O5BzVC8b4OOUzra5Sn03aEydTR7vGcJHTP8JDs0mPX8f6FSd/LvyU+TAzga?=
 =?us-ascii?Q?4NT3Nb2iBGNOsQXMdOJUP2t8BlbPU9sqsqbXWn8RSNOOde03PXti9wubyU98?=
 =?us-ascii?Q?7gZC1EOCwSNVSqPTDM7zl9UPgaMH5WkDIf9adrVJHEYoewFMwJ7g0K9yWIEU?=
 =?us-ascii?Q?uqaRb/3wJAKTrabFwOPyYcyP4FM2CjSbtN1D4M+i2VFbwSvQpqOURUBDAl60?=
 =?us-ascii?Q?lS0rBV0DjpIZo7Ji1lH8Oqt6d80o2lvbYkZPgxgO8y9vNrNhM9suis92JtqF?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c18a3656-77c1-4be0-4ffd-08ddca1826f5
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:38:43.9795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6g1JzAKQCW8pKnyTnxXF6eI2qeD9xzE9He2Z1mExCygC6QilbT7WFI0X4gYq5Z8DilhdIFCUr/7LsjnmMFsIGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6730
X-OriginatorOrg: intel.com

On Tue, Jul 15, 2025 at 09:44:02PM +0800, WangYuli wrote:
> There is a spelling mistake of 'notifer' in the comment which
> should be 'notifier'.
> 
> Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
> Signed-off-by: WangYuli <wangyuli@uniontech.com>

Reviewed-by: Matthew Brost <matthew.brost@intel.com>

We can apply this patch individually to drm-xe-next if that is ok with you.

> ---
>  drivers/gpu/drm/xe/xe_vm_types.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_vm_types.h b/drivers/gpu/drm/xe/xe_vm_types.h
> index 1979e9bdbdf3..0ca27579fd1f 100644
> --- a/drivers/gpu/drm/xe/xe_vm_types.h
> +++ b/drivers/gpu/drm/xe/xe_vm_types.h
> @@ -259,7 +259,7 @@ struct xe_vm {
>  		 * up for revalidation. Protected from access with the
>  		 * @invalidated_lock. Removing items from the list
>  		 * additionally requires @lock in write mode, and adding
> -		 * items to the list requires either the @userptr.notifer_lock in
> +		 * items to the list requires either the @userptr.notifier_lock in
>  		 * write mode, OR @lock in write mode.
>  		 */
>  		struct list_head invalidated;
> -- 
> 2.50.0
> 

