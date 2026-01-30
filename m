Return-Path: <kvm+bounces-69708-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHG7LbyyfGmbOQIAu9opvQ
	(envelope-from <kvm+bounces-69708-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:31:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 62076BB0B1
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DD301300E0F5
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A645929E101;
	Fri, 30 Jan 2026 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YIdi6SPC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38542E03F5;
	Fri, 30 Jan 2026 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769779846; cv=fail; b=n/rJQIDVAxYt01eh9cFjMevWhSxYwjFCzWAvy1ajd5O0/OsXdh1dSa6o9QE40T1KxZFjfFI17dwlq5X2z/j8iBrT1CVd4UYllQHDYFr6FKk9xZDBX6u3+udJAjC4HEBCOr2dUqsWJU4By08qL9EthvlJAQHL7QKxOOmeqer0fF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769779846; c=relaxed/simple;
	bh=Gv1ddsQFbdzCFEV/6no6GVZXoF4z7zuootWIEbi+Y+U=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GOmX8KJg3TX6VpiC0bIqHr7784LCrMCUTZao/lGV7SIBk9BaJrmFe6lNThYNL+5VdtyMjCcNzd3d6YLJhuxxm0oTSXx7PFh2HncK1aBYE+ndmzCLgaNU9x5CP6K3SZJPramPB09qAUOQBCPGlio66gmeOc31TRrIRtCaW6pvE9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YIdi6SPC; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769779845; x=1801315845;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Gv1ddsQFbdzCFEV/6no6GVZXoF4z7zuootWIEbi+Y+U=;
  b=YIdi6SPChLAdivdZMYTArd1qgrzDzRACg1Ibre8qrWw0RqhNATsynCCF
   4Vu8Fiuj1ZQ3ywh91PwDKDcAJQhG4FftdkaUpvamikcZYyTpR9QwJIi2A
   EJTUuwa5Srj5LMfOwo7Ef/ryVe0qx6CpzlBuXCXrnKkUnq31rT9SH3ZWn
   ZYcnHM9dJcjFuLKBXxo8ISNr+byQSLwv5Kd2gKCcBki/lfifAjOQmu4Jh
   5p4BVLNd6byG39Ox1aS4Ihjkf2ru2Uqw7UtD3c+wikn783fU+NFEBjNoB
   O5JrFIt7C9VI/0EydGcSB9J3ixRRcjPFbQ/i3EXQBC95vhVf6hSXnYv4w
   A==;
X-CSE-ConnectionGUID: vWFJUxFgRqKLNj+0nvgO7w==
X-CSE-MsgGUID: w5ZcwqbRRxuCvFQ4XSrj8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="82454233"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="82454233"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:30:45 -0800
X-CSE-ConnectionGUID: gsEEX8VCSEizit2b0xHAEg==
X-CSE-MsgGUID: H4AZKb1jQ3W/dtJD3a2HTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="213751486"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:30:45 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:30:44 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 05:30:44 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.68) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:30:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WS5ZVHjpPsin5bhYbODbbbAeino9AEtrGB0pbGpBxLaRtO3teCAE0/82LNWU5KndkPnpeW98PFyxXmeMYk9URb3m9XRBSDeMgza7vBvx3TR7c1H2IjmzwFjf9SAJBvnJiXkXqnq0Au7WGlioYtC/7uOOP6x9iKg8Mpd2tCnaB1lmGDVxpgsd6s/D0mNDJO4JD0SHHciAvGKzb7ZuzQm3IzPVcZvdYzevqG42E5VD445SOkOdJYDr2/kiXkxidq213cAWw3FaKnknUZTIYNFXdS3Q/krmQSFtuDPAO1UmBLiT+Pm5PB81eGR5MLrFsonozPcZkA9kEfTBbvAKD37taw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gv1ddsQFbdzCFEV/6no6GVZXoF4z7zuootWIEbi+Y+U=;
 b=oAxJrS47qps5vXVnPIm6rBjnYZ5axoo9I/47rMvoX+/zL7x8vg7hB1y5DP2U492eM9glDgd5NLWZC0vOLAtb4c/ylyrCOyBHvEBafHiaCe4K8WtzuooWD7G2YPMBpsLyg1G+XWUTYhDiNgEiuIRxrvY8yz0g9icO5o5pDMh8HtqLgF111iGkaexScM0P0na3TIHMJ0MnpPMKmHNDjTQ/M3bcb4Pj5+1lSAhBSmsF6KCoSojwImYnq0JHBoUTjmDEtzlchEiSieaipUSEIeJNG+mc53oQxQsBnMz3j0GEt4NpJGa9ZCyCqQI3gJBnnpNJFkNWCbtSlWn5rMYf/Hd/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB5824.namprd11.prod.outlook.com (2603:10b6:303:187::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Fri, 30 Jan
 2026 13:30:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 13:30:36 +0000
Date: Fri, 30 Jan 2026 21:30:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aXyybZc1wi1KQmL5@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-9-chao.gao@intel.com>
 <7e981cd1-cfd5-4bc3-a87d-0a187c510dc2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7e981cd1-cfd5-4bc3-a87d-0a187c510dc2@intel.com>
X-ClientProxiedBy: SGBP274CA0011.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::23)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 249feb6c-7203-4610-4ec1-08de6003c02c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8pANBxQ/Tj180bh1GqYVZsYNNGLOIv817SNvnghAVwn+MAbb7CSriXPufxen?=
 =?us-ascii?Q?dXOc5TXerpp1/dikY8oe2HTHxNYduRhsLW08NWjJztaUU3qG+B/yKle4QVQh?=
 =?us-ascii?Q?6f6XQV9G2VA/FuPVJlSIZrgpZr3gnQZQ9KMuFWRPF6umnRiIN0RRU8jgxJGf?=
 =?us-ascii?Q?I9yfDUfugkbIMWsCoP4mwLVdpHgStFxIR4HHvlGUkPGC1deBbxJta/Xji8dC?=
 =?us-ascii?Q?bOhX990kYiaCK0b3ozCPlLzLThrymZkl+mugZq+Y8vDDVpE4BaBk6aaaehak?=
 =?us-ascii?Q?2jRU44y1INQLnUhRi4RvPdYXEsk2bRKQoEfcSRvktLi78OY29N7EPrYeZpl/?=
 =?us-ascii?Q?v6iqSYUmPZ33M3U2QpDWAAdad5N8/yohQ3QmnaJU2fvpw54QOWGufRRWNebO?=
 =?us-ascii?Q?UYXSU8tkFPFKtqArkST8j5rC41IG0IIwtzBXteXMd96548UYyEP1rO8QRkL1?=
 =?us-ascii?Q?T8YQaHPOpfGk8F388IHMCQ2y/nW7McSn/AtrxE7dfZlKZmjTea2zDUATNemT?=
 =?us-ascii?Q?xt1EfAewb8CugahOzoFcoFpK1XBX0mc0rPVsSw+kqNr+RJWeK6xlsVy+rIui?=
 =?us-ascii?Q?t7nNz/IG5kbYMn+tTfuwSTSzeY+lsQNNaKT6NMa8uYehgpmUOB59J4I611FY?=
 =?us-ascii?Q?uKLMjvthUZysvldyS5bJCJggCxnI4+bq0ejee8g5rYEZO2oMr4Z+XOTjKTZh?=
 =?us-ascii?Q?vVgyztnfBQCy5IvDsoYDvwPzFZV+nbrFhIRO5+fNvoJMkAmDplgP0YoOH3Qt?=
 =?us-ascii?Q?NZMUJCymTm1d+rWmQiTm3szo8usq041gYqXVynUC8Rr+xxeC/tdo0P6zSTvr?=
 =?us-ascii?Q?+uhBIq3g1wQ9rBIProczbksT6nXl7mc5ARkOWkSfyvzUDHkqu6fVsGopPvlo?=
 =?us-ascii?Q?m9OEOTg8MNpDxk7Aex1fWBaE4r06NitB2qYSj0eyFdJ6I/wBGLKVuD1ThpiJ?=
 =?us-ascii?Q?FQKm2W+g8E8A0vSmPH666SOg25Alm+myj75leBUpBp9wudsGBUIDTf/NyBJm?=
 =?us-ascii?Q?SaVwgCVB1nOLbzU/SBdy0Gb9nV5Ll9JSqMDUoaxMdV6lohAtDtbjnRsgyQN5?=
 =?us-ascii?Q?aJqtrMNTkn8+tyexYlIsrCQKqLCMfN053YxEbzdOnWpqeNWVYTzuuE0u3tyk?=
 =?us-ascii?Q?bmyQldlDNl7JH89T4pX5Qy4gfYbtTS4G8zkOAWjrR1Z2EV1gh+1s5nXwfhHS?=
 =?us-ascii?Q?4Bj2Stv058T6fO6TWF0Fcj22PxixbH69gWQeTYe/tQm43jz6gJSllJ4vhMuQ?=
 =?us-ascii?Q?Sessme9P9h/AfY1mZfBntTImNwjvvimGf64b4IbKh2LUMU4Gag6Kw4fKmR/O?=
 =?us-ascii?Q?JxhcZlEiFKvgvbIv87tmik+IbwvRTHl8ssBezw/skYia0yCGn4oFOLp7I9ZT?=
 =?us-ascii?Q?aJn8fENlzom0IbauzDcAs+xSU2QLiNk37egNcGXvrpaNseyqku4J/+Kqs80t?=
 =?us-ascii?Q?ohSWNk1fro2MWgGFDPmbrZ29Bdm6ydLgp2yfum/+jh8SFZASNKCtHnI23M+R?=
 =?us-ascii?Q?wV1EEr0AL11wkORy9Two+Ji3lJqiwo8sa3MiaqK6VJdVgT4l9xVq0KQGkle3?=
 =?us-ascii?Q?tm9gLB1XD0vPht46VWc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NRcWHhUeuFOrISXxlyGA8y8IX7E6IDyylU3PEnzIFUdzWnTEB/pdsTOeRs7W?=
 =?us-ascii?Q?HlVjzz1XHQ2fAcr9UAn2y0DxpP9Dd79xHjgFPD3aiW1pEO3WT7GZp14DKB+e?=
 =?us-ascii?Q?NSe3dEE96YQtV33Hg/zCyZa6KVVnZMvaftMghwd09W3y3Y2zIBhK+qNQfppc?=
 =?us-ascii?Q?yLVMqsxr9igilhqaAv6V3CAya/M75PPZCtXowk7Tk8Kf1BeAUpQIzQtRD1x4?=
 =?us-ascii?Q?NMHH8wjnCBgCQotJzlkonkHa1tkniPQbmy1YwFdlXxOz6rwPOsVE7tHssZGD?=
 =?us-ascii?Q?vTUUzQ4QCm3MFoOqz1/6hB4v39crPLRz4P3mVRoSmLCB0kFVvTaV3jYqms4H?=
 =?us-ascii?Q?TS7SIF2Dyg8lIwaOL+Dvi3nRZFHG3RwYQhUwN8f3unHeX+6nmBn6mVhP++Vo?=
 =?us-ascii?Q?fhOeWTLd0VaUK5/uxtsT2QWo1TGYsC7qhVfUX6g93PsVRV06qRF1P9tKc2VL?=
 =?us-ascii?Q?nDhlsVQUd0sYjSdos8wg1LsSuvXUUsB8kM+zoGfwrOeowss5UiQAgMDHETKV?=
 =?us-ascii?Q?1ZYLXPjVzX+ElqdPyYwSc186NYjFM4D4gMIVJ2emFffUVhgsVQ4XeeSpbYXN?=
 =?us-ascii?Q?0k3/DQkLbNNUwgWm06qI2a/h8ahiSurHsZfm44G2U4SqcBDvVMVo7+uXLiVi?=
 =?us-ascii?Q?fOxvTP4W0ch7ZECxhWkwPtBUgksePjBaVYO1h/zE4Oa6f1VdLKEvMrOzkMDU?=
 =?us-ascii?Q?UJx3lrMzBM3AcLh8AWpQqZkBkA33HRzV8phmraPfU0lNmIOaFVUJsbHKMboC?=
 =?us-ascii?Q?K7niPJa+xRCqu4KKL2oqyBqNj4GpGTyp5uF+ja/iZk2U9pwv2aWFHyPclMsM?=
 =?us-ascii?Q?tTO+7gJ80kQbNX23vP16LyNxPsV4quEsmNIa/54lzwuGHgRTnX1GujkIZvgj?=
 =?us-ascii?Q?zQTBpBjUSSt5WIYLPtgiv+tCjYx7RJafu/yK/XbfI+TW+N1ZAJ620iDbTR7u?=
 =?us-ascii?Q?SnYtwJc36RbxjSZwnV2LjzsH5wqr92gJid+6KsJTLQCxxaKLA7Z6TWOE5/3r?=
 =?us-ascii?Q?xINclptHOqueNlEL2qRbtrpzMmjXVmrwAyyd97MrkaxLVhLAPIHraePVujpy?=
 =?us-ascii?Q?rzzrLazt5XjMiV76kebDo/rR36iXJ9zQwOxZAgqTsmWnDSpuOsbtZ2AZwjZp?=
 =?us-ascii?Q?6VRK50bKHd72Cxn58mxuOCDynjQCyS8d0Jkufa5OsAsgckkYF/veEUJN48gM?=
 =?us-ascii?Q?pG4bXggEBGVxIiMqGVpaxPqvTEi7qU5K4k/b9b8QR9wxsDoYOHyvZqJMw4gZ?=
 =?us-ascii?Q?XU+FxwlnVTXLZPphoIhc+nMr8csVgig51fVB1tvhXB9UUlJxEWT5/qBHzg5B?=
 =?us-ascii?Q?arzdqmtMIdEXu7OBMu33BZ4fr01dRf3bVPtPWSr1ogTCpJjtawd+ctZbcB11?=
 =?us-ascii?Q?O1HIyTxawZba461CrBhnqcSixi5T0rQVdYDMNnCC/iKjgTUZG5Wldhl3dh5e?=
 =?us-ascii?Q?7XEXWBF0Tf6SNgB/tKvezxyR/Hc7v6/JLx3bLikTG/lqOKHgwdDS4YeMrTak?=
 =?us-ascii?Q?xQBMBSml2yQc8QLU1ShcAzJRjjPk5C34PWRn7lPKzrhiZ8LsrurIIeOOpiIj?=
 =?us-ascii?Q?UNdBa34baC13QFcu63REdzHtMut0aIlRzzuRQlgRpNiVQHVohH+GHykiQyK9?=
 =?us-ascii?Q?Yw/jfPYJ2I6KyB4vhJE+mFivdy6tZcZNSOU3pUMPbVWAz9/RJhCCJn95AhCA?=
 =?us-ascii?Q?qkZHkiR/IRgIOJDjhLCnpT0aBQGLlPkp6eX9+e+bqwnIXIbwmQGMYBz/1VKa?=
 =?us-ascii?Q?oPDW3KndmQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 249feb6c-7203-4610-4ec1-08de6003c02c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 13:30:36.1226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wN30XnBDJyY1fqV8u6on0OBCsq86Bk8p3lr0BNy5SCRbjfKx/p7Cl4C4cyB9c2pvMhYhkk0zph3AJ3cLStg6sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5824
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69708-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 62076BB0B1
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:57:30PM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>> +static struct seamldr_info seamldr_info __aligned(256);
>
>I also wonder if this should be __read_mostly or even read-only after
>boot. Is it ever modified?

This should be __read_mostly. num_remaining_updates changes after successful
updates.

