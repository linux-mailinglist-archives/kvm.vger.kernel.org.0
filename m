Return-Path: <kvm+bounces-71570-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UA3yN+b6nGmgMQQAu9opvQ
	(envelope-from <kvm+bounces-71570-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:12:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 130711806BB
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 549CA30069A7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F5023B632;
	Tue, 24 Feb 2026 01:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cke2mrPi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8862C145A05;
	Tue, 24 Feb 2026 01:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771895509; cv=fail; b=Npvra+Ps/TUHeYkGutEwvc8ffzeZ8rK24774kvfdj82N+fXyafCZtEBD5gFQnaFqTSEe8BjK/fdiJkuqw3mDwGKm0ZM9QDMGEavQCDVQbyh8QF4ZDXldDuxtkYq+kEkl+LrxxEZH0UTK6x93UwP2o2zZbo7zU5z4/l76xUwJNYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771895509; c=relaxed/simple;
	bh=7fsjlWUjeCU6aeDg8W2RTLmr5jT7FYvuZkfIWjUi2uc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FgYsaQZ6aLbh892PppdUAON4/zPOep12FbGiULclV3NG6Y8TvrA9RJy7m702nX9ErHuNZgyDm6i7l85tb3fA2EgWWTzv9/I0AbDgHtKh/T66N5wyRhOOTca0gNxvAK2WwDL8fjU//AnmJ8wgPtdMLv9vruPkBvnV1yuJEHAcS/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cke2mrPi; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771895507; x=1803431507;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7fsjlWUjeCU6aeDg8W2RTLmr5jT7FYvuZkfIWjUi2uc=;
  b=Cke2mrPiV1YkkAkrSBvDcnBK/zTFw1p8605yYbwj56bqvlW41fu7bE/z
   7u72S/66HBKnCmC9rZVkHucDszWhvU3CSKdGMQdN8CTIYiMmlPz1+4beK
   oz7+rU2UYkkYd28nQ54dn5RF4MWaJPruCIFMaegGuTc3k/Vn0KVdu00js
   eWthr8WUVYpt6ILCzg5ry37sIicv3/Nz+ScCBpBErYo6rnD27dWw34X+J
   +KX7QTPZLKaELnMdeu10aPgaWb9G8vw38+rQiE8/oVp0dKMI9mZnSDQPa
   +ER+QPGLa75X3NOynZPMDA+zJwY1wTtintYyxV1LVScQL6dXbuzvCbjzC
   Q==;
X-CSE-ConnectionGUID: FrK2shZxQnelB0/hSDDshw==
X-CSE-MsgGUID: Ac2dDiTKTgqe0s4SpzDsog==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72808507"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="72808507"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 17:11:47 -0800
X-CSE-ConnectionGUID: OEcbXOUGSgiTtjUwTHtrAA==
X-CSE-MsgGUID: ZQdIdtv8Rkq1lXlrGEKslQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="214603106"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 17:11:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 17:11:45 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 17:11:45 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 17:11:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jsji4LQQOWIRIbKNBWQDmYdlewoxxzu3AZ7+B89Ct3QShHzHhLClNt4kwd4ibwS5+WvffTgvJnQtgf/o5ow6Z2iS1lZgEydFTH4aaiUxOOLxHatFfAOx6lfokAQnFNl8Rx4xtjRgS96NLJvFQUJ0s7IJPi2FCCWSKP0qbC1QbXOmOm6Q5+II6OHCdZoUmnUoXECrjJ5tsk6N/jJE/jTMkkaxCZ9Aeipdb/H+tDnwlytL7AKSMLWg8mr3gnlbqP/Y7NknwW5cQFzCArwi6R2jHEypay/L/qeFSUaX8fxafLYgClGPxw5NS62MtVZwQ+iLUotmHFhOfVfPkPhYc1anIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vUuG5eTzc1BTN12LAJTBoA/5gdk8w39sr2xdyHTzN1A=;
 b=JLZzoAv5qgR+pm17mFOEc8miiHMfty3BbBp+b+ABwaMNqSLo0sTbZ4/kiewUjVFPvwRf8m2zI9SVv4JklY9xuyvcU3aYzVLFpGXJslHkr3jjDM7msdNpJv3eMcgOAaMumWtC4Gp+TAT6cRjUOb7XaVQ7nA6JcbFvbmhUw+b7pw4G+ONCZXv/6v+wR+oOx9q5PWsZHt6nybVizMekP/vvFq3xfy8hizC09a9NT8zfKi6UmYlTFOM5yHnfEW5T+qKVLM8Ak6FaCa58xY5RsgikLoI50gMdIYhbBQ+YZ31K9axZB0vFMf+1pyJkqskotHNxpvIc+Bq9hm4LXfsUtYxUSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5188.namprd11.prod.outlook.com (2603:10b6:303:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Tue, 24 Feb
 2026 01:11:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 01:11:42 +0000
Date: Tue, 24 Feb 2026 09:11:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 02/24] coco/tdx-host: Introduce a "tdx_host" device
Message-ID: <aZz6vyshVP8LOyje@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-3-chao.gao@intel.com>
 <3881637de6fc6dc5561e0dcf42c536ae57f6eef9.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3881637de6fc6dc5561e0dcf42c536ae57f6eef9.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0065.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:23::16) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5188:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f4f87ab-85fb-4efd-6b24-08de7341ab8e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EVIW2HPyr5FIgGPUWbI6xrNQjDNNCPM2dnT9APtXpN1YscZYYO3ug4aHlkSw?=
 =?us-ascii?Q?lX2j5yt+ScdYvAVnn/KZm6MzW4bicj93vKuKazOBGGjS0sZ4wAMaV/GGlGhd?=
 =?us-ascii?Q?yuOSCGc43WgwM23/PkMmAJFnpU4AL01Hesp1M6lalMgEh958fRzhVPamp9bQ?=
 =?us-ascii?Q?44SnfeU1GUSo451ONhK/TJRsqqhI3pwFLh2iE77N/Sr4YkdAtc6VdgI++TH1?=
 =?us-ascii?Q?SQaKT+2wNE93EYHyke1hCXufvUIej7oe/ORbkE9hr7CPvwZDz3Suqipvt68b?=
 =?us-ascii?Q?a8LcfXrpedsNHLCre+E0wGhVez7yCwEnp8zev6/UhhAhhIbdD1N4tFJRqP4j?=
 =?us-ascii?Q?Xdrghd/AEKZm/hSC3bBjI3tQh9KnB8M7Yr34KR6LPO+IfxkRprD5FWhdZQZw?=
 =?us-ascii?Q?sFal8wValXmrwYEhlCxrXANxI5B7a5rHHgnTvAzAWc1v8eHO7x8wJ6LFncbs?=
 =?us-ascii?Q?vQO/+PASkXaL7MHtHWttynAEtEPFdWkuuTx1YvFd0v2AzC8ji/JeIQ2HDyad?=
 =?us-ascii?Q?F1IfYQ43VWNMKduwfBaxIGqvcH3Aw1FNPWI98mK292nIN8JD4RUN8JZl+zQ0?=
 =?us-ascii?Q?+BL3U0ueUl7DUfpZLWcbTOyr1licce1Fyo1NHfrgRnRSFYRXv7Tjp5hBYf9k?=
 =?us-ascii?Q?A50Yjc+mE+1IjMNEYHTVIRhB90wnjESVRMWtIDD6p2flwhkZ/ZQpOZQAzwOz?=
 =?us-ascii?Q?uCaJTkkyVJ3G5JJNaJPDy5UVtjOBtPFmoxcEVzIIEY2N0tiHsd8dIIwJ/LFJ?=
 =?us-ascii?Q?BufIiOGxNo06a1jhj5kHxV6Dg0tsRbtydF6SxW6MjH5eVFqlmtYS3rhkJYPU?=
 =?us-ascii?Q?qHbfo/4eCo5mMxJTiPqd+4OIff0Tv7EEb8QWSPrjrLZCiLGTnZGfwJuAv0XK?=
 =?us-ascii?Q?0bjVp/qd3qSuruw4dy+MsPTsE8r4M6RSPVUgmlPmEnZ5n9T4Qk1aM+6oeIVZ?=
 =?us-ascii?Q?FVbmrpEeSORgqAUW/O2Kx2+HO1AfmFnGlCRgtWXjyfpdCWOUW4MvGaJtj2oq?=
 =?us-ascii?Q?5C/dxS1bXr1Wypb8o8viwVSotDdhYkZjBRrLDUNo0ayR5f6jvv92ZPcKtLIc?=
 =?us-ascii?Q?2swh4smkAb11RF+1elQ5UXYJfv8x+vwPWc17t7t9PdSI/IGerhH20LXt0msF?=
 =?us-ascii?Q?cqMNIsXYxluixReWAVN41BZ4Xdzgb8lQr/926PXo8IuY3OMLuTs8PweYrwHU?=
 =?us-ascii?Q?4peLiZ6bxO7q/HyVaj2JFRgxj3uPQ9chdM6fWffmbMi3QzNU8gvl3zXl27tc?=
 =?us-ascii?Q?FZj2paX+CcqmpYMReWLwbq+IRaKY+JEXkjLvWGHblkLkx2xuhMCgiXbZyekZ?=
 =?us-ascii?Q?lRCEoG914r3lcazccVoPz9gNNbS2avIuYJTqvrGTgpLe0aoF3QMZD3HvC7Df?=
 =?us-ascii?Q?TqRweBX8nYQNNkMyjY7Qrp41jWH+z22zxzCLI5IM3FQVwZmdrF4iI5Vgbx2a?=
 =?us-ascii?Q?DX1sKo6vFiMp1UxVsRqjUQMXBIHyXq2R+VjupDuCkuPcnniXb7oxfg3wwD+a?=
 =?us-ascii?Q?DF0QQfPJXZL3m2KS1CYGoh0P2JHt+vowjhdfIe7lH8jMkQuxs3/QvLNrtGWf?=
 =?us-ascii?Q?s0AfSltwcxK+tjk48B4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ev6DQq6pV0WX+h9oCZcmuRg3Sx1H6q8fXbj8Y7twItHBM5WvLRLcmzHA8msU?=
 =?us-ascii?Q?jH4Pt7NEfszdrTRNX4fEM+aTvyDJECqgDs4UqBt2QCIN6TFIPwV+QIecagwK?=
 =?us-ascii?Q?Ygya1m4xG3T67O3cmzjAliwWNtGkiyagGery2zAeihMQK5we3CIrRvQTUWLp?=
 =?us-ascii?Q?aj4MlsZMQvOBH76h+p/IkjazDjcIW45iuntEBlBp7HUtvwb4aGlUuKgBuO6D?=
 =?us-ascii?Q?3a7akT5o4NHV4IdnV2i9Pjg1nWRqDwSffA/kcTs2WqZ3bdcG1fI472QQvSVd?=
 =?us-ascii?Q?4dAX4C0eDWbXKHcrz19iEW8xyxuVtteAUN3qz8j7304OQvKMkCL31bRvcjf7?=
 =?us-ascii?Q?3iLEZuRqS6LZgTYHPsIIKA7tL1rwn/AL83xyIY8AS36P1PWQFKQ0keZAhEAi?=
 =?us-ascii?Q?HQK7Udx+gHY6kHf0QZcOBfdxax0WVmWu1Z0NqshHtYVFJdnJ/7IWNcdHJOJe?=
 =?us-ascii?Q?vS5JXptH/SQGwNFOFpY5v9feinyRqBpBMu1fJF+vHCeGGWxFI6iRVrWG1uOz?=
 =?us-ascii?Q?k5msYQIzQhR9a5QgO1i1W2MPeYFkTfq0mEXVr3+av96cx2BqWYWR4OyF1pBO?=
 =?us-ascii?Q?OiLIzcQ81uP+vAatYn20TqC6XgdmKpdrJF99zGZfzLU5RwVQGoFWv5EN7Eb+?=
 =?us-ascii?Q?f+xA3kuUIakKRXWbVc02/AWn6zoUZigyr3UfRATcd3VLmsOp1uqnyloFXLKr?=
 =?us-ascii?Q?YryrQIUF1DFSaHkxHLZ2lDymwyELoOLdWAH/F0Bu/8JvQ//QO/xN8j4aVWTw?=
 =?us-ascii?Q?Hq1RueIFlofs97NP9VJ5kjfhk9BBuGIntMUJtUXg5Qg6xJnEa4KOq/qUi9bq?=
 =?us-ascii?Q?3KpFpc4iE16ytesvMm6y2xUw/HyWFG9JQ5k7II9z9OtxcRB/izB+v5tOFOKp?=
 =?us-ascii?Q?ykRCUzksnravlPhVpW2p3yYGbDDU1UvMTipX2Aj60f4z6lyojpsN00pB3Ec3?=
 =?us-ascii?Q?qlxYeN/oGJ3dYzQzv7U5TF8z5Y5MoqlGcHDZEZw94kV1RRuUmZgne8cxtTT5?=
 =?us-ascii?Q?LCis4JhtmEAnrSFyGaIyO1YFKglpc2ZtXxGvmjfhnHCkMCGCDyvPsYwwsGz7?=
 =?us-ascii?Q?ftFbEUhvFbWgaoLvJ1S/ZxT1uTZWlWwqq1JJZH0zc0wrcVytyyWevapsZ1em?=
 =?us-ascii?Q?ysmgJhaMI/BYXgwwLYutYGKh1YVZzq84xcz2mH98X75ATXZlAzXvmj7AuGnk?=
 =?us-ascii?Q?Zn6ODHf58Ra/8Gx2tIy97cfTQDvRQL6V94KQMOWE6Bviym6DJe5LRny8u5nW?=
 =?us-ascii?Q?a0HkmRJ0XsgZHi7Pylt7wqjdQn1OAynFP4G16jfxG7Fyx+dvAMwnDxbNRrq+?=
 =?us-ascii?Q?ew1VnEmoqT+/0Mao+VNZgm7x+DO9ORUMGl/v3ipuOEge+O+vywy41V9fFryP?=
 =?us-ascii?Q?j948U5Zw2Pp6EmcfKt1hTGP2JlkMpw0s9qupewfXGtpohCy6uYK8Z63Knqi9?=
 =?us-ascii?Q?Pw4EfufB3sej9aM6HcAi0RKaMRaSFlQ/3SptezQY/E/phKRRWa1J6gxKfe2i?=
 =?us-ascii?Q?8RPIJPCGDTzPsGD2YSsYBo5G9f61ne7L/Ej6NMbUUTY69gHUz0lTLkQi3xoy?=
 =?us-ascii?Q?jwa24B5aZD0xt6eCLQRJVaImrX1rkJgpk86ncP8ECj6fxZtdodN6YlHLpTGO?=
 =?us-ascii?Q?QT52plzjKGO8srxK///Jn0Ysnt0AJcpexrgR8RYbtvccaSgnTaAS3ZAXZfcL?=
 =?us-ascii?Q?rneWUuC2+hPqybIqY9oYwAk0+N+oJAynCwQk0pS043GU33FWIyOBIKigsIZV?=
 =?us-ascii?Q?aABs3FaDtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f4f87ab-85fb-4efd-6b24-08de7341ab8e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 01:11:42.7156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tArebL50WRtx66R7Pgno6XSrf/twOxD42Uc7uVsGqGcD4oCvFtpX/gl7DLEt9hR4FGnlgT4UHS91ruyUCDIaeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5188
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71570-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 130711806BB
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 08:15:20AM +0800, Huang, Kai wrote:
>> 
>> A faux device is used as for TDX because the TDX module is singular within
>			^
>"as" should be removed.

Sure. Will fix this.

>
>> the system and lacks associated platform resources. Using a faux device
>> eliminates the need to create a stub bus.
>> 
>> The call to tdx_get_sysinfo() ensures that the TDX Module is ready to
>> provide services.
>> 
>> Note that AMD has a PCI device for the PSP for SEV and ARM CCA will
>> likely have a faux device [1].
>> 
>> Co-developed-by: Xu Yilun <yilun.xu@linux.intel.com>
>> Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>
>> Link: https://lore.kernel.org/all/2025073035-bulginess-rematch-b92e@gregkh/ # [1]
>
>Reviewed-by: Kai Huang <kai.huang@intel.com>

Thanks.

>
>A nit below ..
>
>
>[...]
>
>> +config TDX_HOST_SERVICES
>> +	tristate "TDX Host Services Driver"
>> +	depends on INTEL_TDX_HOST
>> +	default m
>> +	help
>> +	  Enable access to TDX host services like module update and
>> +	  extensions (e.g. TDX Connect).
>> +
>> +	  Say y or m if enabling support for confidential virtual machine
>> +	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
>
>.. Missing period at the end of the last sentence.

Will do and apply this to the whole series.

