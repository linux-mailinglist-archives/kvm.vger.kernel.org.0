Return-Path: <kvm+bounces-29326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2219A966A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 018DDB22500
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3903613CFA5;
	Tue, 22 Oct 2024 02:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0ty4JZX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75922219E0;
	Tue, 22 Oct 2024 02:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729565266; cv=fail; b=JdFURtPT3vTKtPeaR9S47R1IMiiCBJBHx0Wx2mq9JYC5rJY7h5yo2bUXPkWAoPD8Zyn9n6PfiAkWcPrhiYmkyMBf3W88vL0eAaPVy3WhM60kfO/SdG6ePphwN2APCz0elz9AJEFGiARfzVVc2yC4fHMJsOj3dlo6/fP+j0lc3Bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729565266; c=relaxed/simple;
	bh=s/zlNKhvgmqFtramOqJmbf5qpOhPdc4AesJRP0kkAqo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CqMAlxGX7GgJaQfXLf8oJP+3hOqx8/h9J31r0mG+l1lpU2A0fFpSCi+9PjwR1BKkcfz1+YZrL+HUekFjLTpBeyCG0IP4n/dXvfFPXqblcK0iCbBtgUj8TEJ4ceDQsI6QMXe27XL54Lclvw7nYg8AQy8tMy0DtA4GNQRg1s6A0fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0ty4JZX; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729565264; x=1761101264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=s/zlNKhvgmqFtramOqJmbf5qpOhPdc4AesJRP0kkAqo=;
  b=Y0ty4JZXNmzZezk486duPjUNUCbxK9xTn+OYV4pLXKVazHNv/uQZcla9
   ip77zsMMhJPx7H0/IZPK+VFjDEan2jHvn2TEBEXHgqthmW3SSuqn4hRIy
   LSusJlRgn+pnt2OOSLXsHWmOWRERGQpD5adLt0RFetefSBjR2vu45hm9x
   NwK54atu/N8uf8SaBf93jU9mBYgBNcPMs8XFGitFDdHivmMprEk4vquHV
   m1p3yBH5iRmEj4yiAvLZFNb/dxq0FNfbT0QGMO1XNbDWsq1lpdDlxGp3i
   cPua+FcRl5kNKL6sGHHBs7XAxUY3Oa7nVx5gWzSFAmTCb8Y6W06axvdLi
   w==;
X-CSE-ConnectionGUID: SnmJbYHUQlyW1F2pBwfbkw==
X-CSE-MsgGUID: QIiBNKatSTO7vSOw0jDMuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="28529568"
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="28529568"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 19:47:43 -0700
X-CSE-ConnectionGUID: QKiXid66TkCdOOsXleErpw==
X-CSE-MsgGUID: gMgHyf71StSYtugJvEatiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79291612"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 19:47:42 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 19:47:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 19:47:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 19:47:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gz7wzjGjMai2SMdZAkgI6vIToKkCUscqJmaoOqrOMXv8GVxCnPtyIRoHs7p8ZxfscxE4tEe052HJEXCY/yLVh9I9LjNphn5sW+yRQAMKw4LYhM0isc1b/tVQcX2YmPvHjrS23sG0dbKF4sHS90FQJOi5cyOOemcmCE4/Bwzu0XWk9+WNx/X4zNY9uZF0ruXy/jKro7rNbBrh5ffVo3ZmdRkodMwPYhM2k21Drk7qURwC+QB4Dp8vHn6yiIN6yxvX06aQWZ/zc19GB+rb8PBzsZDef9mN11MLGPbiJWwfvel8Nw/Azamp+dK4kUDf02cM6q88FcUV0Bm+q9z0NCm59A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhfK49/g7lqCAyBF3rJh+3WtS3So3PVNuZ4+lCrPEEw=;
 b=ispeXaA9k08s7ySVCYJSQv+uWSyok6klMPgKo6LmjwDRdlxf/+uWUqW6EsKc4GbPFDoZOdcRDjmS+eBmy5jHY9hlbAoMj9KFZV2olt1GiPFnXgT4nMqWgV0VwqbZL5a3yfrxgYsC3suViUU5wAKCthrtijEZerDaTEABGP7u/YZIXYYiSJG2/QLlbN5qcq0nDKUMfFN/dkXUwovV/dQwJl8iXoRrJRTnlFtdRxkvdPiWqEK+Ts/4D30HYRiKTPyDK3+rtpoRyejKPqJg77/x/GuuqbX2cixglyfLjq4SCRhNL5n9N7OOu1eATCa2gyaKo7BzqxXeSlHW2D1bdQM81g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW4PR11MB7101.namprd11.prod.outlook.com (2603:10b6:303:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29; Tue, 22 Oct
 2024 02:47:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 02:47:39 +0000
Date: Tue, 22 Oct 2024 10:47:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Xin Li <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 03/27] KVM: VMX: Add support for the secondary VM exit
 controls
Message-ID: <ZxcSPpuBHO8Y1jfG@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-4-xin@zytor.com>
 <ZxYQvmc9Ke+PYGkQ@intel.com>
 <10aa42de-a448-40d4-a874-514c9deb56a3@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10aa42de-a448-40d4-a874-514c9deb56a3@zytor.com>
X-ClientProxiedBy: SI2P153CA0010.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW4PR11MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e3322df-e1e4-4cdb-35bd-08dcf243e46a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HpUIl4DXSPfLngT7Y/0afZbzWicsZQFG5ZfyDZ/LrzTQgBgfhF7dIsTxaH9Q?=
 =?us-ascii?Q?4lGJOIc7zmuhdcfhrwQ8q+ipnVlbo46a16Syoy84c0H/F7wtYw3hyHpHBLP2?=
 =?us-ascii?Q?SGLnnSig8FIEKPAPIQAlxxle3NvNImF98tZmAWpmpiujMJrnwng6+d3BiyPq?=
 =?us-ascii?Q?bWMlTttjgGttOQjWSU1foVByQnHOcOqXR6S8Q80mYBB0Ib3EGJbJzkWgqEfi?=
 =?us-ascii?Q?fBiFHBpaa1CQunDRUR7njSzyClzsXinLCRc6vgiAKlHv6HmaEzAQZgnY4Tyx?=
 =?us-ascii?Q?I/aw9u/RsqFYAZEcqDDqzTg+pnfn+EQrcEHdnwhDMYBUGRDK5Dt5CDzr10YH?=
 =?us-ascii?Q?whdZv1R8qG4awiOlRMkemzwvbcieYy735PtcsFRZi0VG78gEgUWLCxBYkZ/0?=
 =?us-ascii?Q?a/21/Y52aTX/CkAtTGtitckHhBe+NWnhQFQFKJ9QdPKJQkg29UmGQqgJLRyu?=
 =?us-ascii?Q?wlh87xqJuKVsJDBqz7d45ZAtTkr1kEcJcX/yUezjsRu7UdSQ3nXqBAzy/v12?=
 =?us-ascii?Q?LZtnWpwg/qxqHoNe1T8d2bR95N0V+xlsjOZXHDl7U3NBIn3dLASKzQO4ypQ2?=
 =?us-ascii?Q?7bTD8GutRMwoXqPxXu7Wodnua8l29g4HGAp5Fp2Sg4EOnTl41KtQJNecb5/r?=
 =?us-ascii?Q?sEPZ0Rp3qUOIKXCxZE/iYGaWEGatxjuUAk2BbzTqfyE1rXckXrkWvpR53KCv?=
 =?us-ascii?Q?7e/dj44uL+HeZtkUgTH45ICYU32O9J/by6wYhTlzDrDCmbKkk+vkAqX9RnYZ?=
 =?us-ascii?Q?sAGAjhoJiWXdvtKhCcIP2Pag2Q275cdo/meXWFzgdOyTkjN4E77Mf8P4bX3e?=
 =?us-ascii?Q?JF9RqU4V2zMCKPmcjh/fEnSA8sy+2NuF2iSDuyZLFS3lrxuALgD1qGmeYrXB?=
 =?us-ascii?Q?M97+2JExVaW0jJsTe3oJLTeV37BoHn77JkOrpbvTGT8vMl5dsu5OQFyUjcMJ?=
 =?us-ascii?Q?zlGrDJOvbc6r9O0Vsb2nO0Frqk7qCgpPnaPQn4PDv0ZM7IIL5AJELh5DfPjr?=
 =?us-ascii?Q?wMlIZeEjYPz64PgXEh6m/adG/i06gTOCjDFG4UZdZbCuMEpaQHvTOUmjh106?=
 =?us-ascii?Q?XHhS0HseiK29TQfdokzv6MG/+r39zFo7YBUJP6WJsGIhdBhRzs9Dw/pXyPG3?=
 =?us-ascii?Q?BqKmYvfMTD4tgHmTx7Zg6BEazZgg7Of/WCsInaMRZuWhpnP7ZBt0XwIanFa1?=
 =?us-ascii?Q?V4TZM1mRi6KQLWrfqdTyniQGUmPczLJAmDGexVHERlp9Il/e7WPGANUtdTeN?=
 =?us-ascii?Q?W+dM1yNXEO+yDOLSC00V+JS3BK/nxLnG3w+xxNh8DnT2nVkiHuCGbW0GRAGf?=
 =?us-ascii?Q?Bq4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?16snUWmk+5n9ZSGWdzWfY1QOg6OfTMTNyuoVOOGsvbGguHyJgEB9qJeGk8ok?=
 =?us-ascii?Q?8X1j4+AQ9dSJjj0DAVQNqqxQ3xuw5VsF0umIWe0eFKIuQDxy01oxUe4EYmsb?=
 =?us-ascii?Q?sBok81lLPAF1BacORyZ3Z474ag/WTRRaO7PSoejkv5J+y9C4bRAQD/Cl+3Df?=
 =?us-ascii?Q?7WsXbzgnH878sw98XnkTLV2nRitXmMJERML9jYkS1QQFtrY0daqf5WZcmXEj?=
 =?us-ascii?Q?H3sCY60e79LZB/+lF6JWIxJpRVSYRK+oOx72MSZg93hT5NPnivUb0+GQlLSw?=
 =?us-ascii?Q?LDcko+NtlV+TAcvlUMnAGWacJTOiKBhDi343Cn+hKrZDhn80olo/zVl+tIjX?=
 =?us-ascii?Q?smcRTvzzPWArqMaDGdNGZqi6XCp8/3nX4fpuA5o9ElhXdN0Du0/QJLDpQoqn?=
 =?us-ascii?Q?mlSKfDc9IrlQItXDSH79rFp+5nE+rMQz+214AtA9VqBpv0Fz9wRIzMvOcXh2?=
 =?us-ascii?Q?rCku4MvWmJ15Iz3rUzx37SIJtWOI3jJ1f2B5Dj3FXc0WwDm5EgOZYMAuBDTr?=
 =?us-ascii?Q?lhs9ZtYbs4gGze7Dcknw/g7UP/xa65lpWWkCTR/XWSjzidthj44Jwwzu+F+x?=
 =?us-ascii?Q?/dHWZorOWfEe7tUQrZnEyrpXVaVTiaJ0HXHKDpSGD1fEmzwwdkMhdhBCBAZC?=
 =?us-ascii?Q?4JOJEyBTa+t+vLbLJ56gn1VbPQGsXHfIK9v9SvR1afJ80wbxINZreQ4Demb9?=
 =?us-ascii?Q?9vQLLhS5JeN1HZHfXS3ZZh8+95fZNPXmq3yW66fLZUxmcM9ypJ2Z+nOs+rOz?=
 =?us-ascii?Q?WSP6e7rdB5ncA3LQZGjWDEJ7LH5eE0cHzczOESd+T9p3Mh8bakM84VLqJuAT?=
 =?us-ascii?Q?DmdxD9jCATx439IWI2fEPzLOrCWXV+ZnPa+QHZQpnJB/IuKJfInqWJYyEywK?=
 =?us-ascii?Q?JAKrbeZM/EQuI+MRlJF/brS/RMX3gw9ztz9iA2BmeuOEkVR2OpSD/oBdWHGG?=
 =?us-ascii?Q?ZItNHsAHA3OPx6IF6K6kCldv4Ux9d2Qq7fwKGYxzTQrkVs+wZ21HerRuvuPD?=
 =?us-ascii?Q?G6i0pfOH0rjEddqrfnjJan5DuIz+AtkqEQXofHySObWk9f3hF7sEwCOdijLX?=
 =?us-ascii?Q?WO61SY4Sb72vwSEO7/4s7+bSz1syPoOmCs6q0rUJBwXp0U2b6x1NnczJeanN?=
 =?us-ascii?Q?zSjPf2sGmTigBlFUN13rRSFD4N+nOEFpIU8oiloYraTjmWn0zmSH3KFuVjME?=
 =?us-ascii?Q?rmXD4hZr3Dfx5IV4cs66OcLzXyBdSosMVkWYyLJTnEs+u41Xy+VdTQWtYNHD?=
 =?us-ascii?Q?Rs0kO5cJ8GbTY9ZKv2RRNWHiuty38UAotaQcN79huaSs9ufG9VVTXaE0I8bg?=
 =?us-ascii?Q?g7EvLPvDMbqis9eOEu3L7nYshm5kCl7NRgbly2rC5C2YfVk8HDh2iS1vjO5z?=
 =?us-ascii?Q?zFSd1OV+Ea5b3zV4dB3bw5Ni+a9s+UqqIRrupm5F9b9XaEVS1dl/XH490r06?=
 =?us-ascii?Q?lkkQfDzCU6V8sch6MmOnwI+k9NK0s2o9KiBHMFSFWqVJGpha/Yr4aTTVFcNG?=
 =?us-ascii?Q?fhUARmRNpDGLCG+s1Sa5hxcZ2pnkJ+APChzU5oRUbutXSxe4eUvlbwiveVUB?=
 =?us-ascii?Q?s4SyvEyAqXc53487dzmBD1z+m8te1TBFeCfRHNur?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3322df-e1e4-4cdb-35bd-08dcf243e46a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 02:47:39.0162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdLkyGkxUGQ6Hq20xRaD68ASEUkPT3gL903yLzIWrdGNExosgD+mhSMMVqwouZFsNikIphpEZlMAuGOTktcqoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7101
X-OriginatorOrg: intel.com

On Mon, Oct 21, 2024 at 10:03:45AM -0700, Xin Li wrote:
>On 10/21/2024 1:28 AM, Chao Gao wrote:
>> > +	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_triplets); i++) {
>> > +		u32 n_ctrl = vmcs_entry_exit_triplets[i].entry_control;
>> > +		u32 x_ctrl = vmcs_entry_exit_triplets[i].exit_control;
>> > +		u64 x_ctrl_2 = vmcs_entry_exit_triplets[i].exit_2nd_control;
>> > +		bool has_n = n_ctrl && ((_vmentry_control & n_ctrl) == n_ctrl);
>> > +		bool has_x = x_ctrl && ((_vmexit_control & x_ctrl) == x_ctrl);
>> > +		bool has_x_2 = x_ctrl_2 && ((_secondary_vmexit_control & x_ctrl_2) == x_ctrl_2);
>> > +
>> > +		if (x_ctrl_2) {
>> > +			/* Only activate secondary VM exit control bit should be set */
>> > +			if ((_vmexit_control & x_ctrl) == VM_EXIT_ACTIVATE_SECONDARY_CONTROLS) {
>> > +				if (has_n == has_x_2)
>> > +					continue;
>> > +			} else {
>> > +				/* The feature should not be supported in any control */
>> > +				if (!has_n && !has_x && !has_x_2)
>> > +					continue;
>> > +			}
>> > +		} else if (has_n == has_x) {
>> > 			continue;
>> > +		}
>> > 
>> > -		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
>> > -			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
>> > +		pr_warn_once("Inconsistent VM-Entry/VM-Exit triplet, entry = %x, exit = %x, secondary_exit = %llx\n",
>> > +			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl,
>> > +			     _secondary_vmexit_control & x_ctrl_2);
>> > 
>> > 		if (error_on_inconsistent_vmcs_config)
>> > 			return -EIO;
>> > 
>> > 		_vmentry_control &= ~n_ctrl;
>> > 		_vmexit_control &= ~x_ctrl;
>> 
>> w/ patch 4, VM_EXIT_ACTIVATE_SECONDARY_CONTROLS is cleared if FRED fails in the
>> consistent check. this means, all features in the secondary vm-exit controls
>> are removed. it is overkill.
>
>Good catch!
>
>> 
>> I prefer to maintain a separate table for the secondary VM-exit controls:
>> 
>>   	struct {
>>   		u32 entry_control;
>>   		u64 exit2_control;
>> 	} const vmcs_entry_exit2_pairs[] = {
>> 		{ VM_ENTRY_LOAD_IA32_FRED, SECONDARY_VM_EXIT_SAVE_IA32_FRED |
>> 					   SECONDARY_VM_EXIT_LOAD_IA32_FRED},
>> 	};
>> 
>> 	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit2_pairs); i++) {
>> 	...
>> 	}
>
>Hmm, I prefer one table, as it's more straight forward.

One table is fine if we can fix the issue and improve readability. The three
nested if() statements hurts readability.

I just thought using two tables would eliminate the need for any if() statements.

