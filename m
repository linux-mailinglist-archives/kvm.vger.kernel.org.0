Return-Path: <kvm+bounces-70399-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C1qEDdQhWn5/gMAu9opvQ
	(envelope-from <kvm+bounces-70399-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:21:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEE8F9389
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DAAC4303101A
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 02:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BA32505AA;
	Fri,  6 Feb 2026 02:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IeBcb9/t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F42E20E03F;
	Fri,  6 Feb 2026 02:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770344426; cv=fail; b=Dkwmdu4I9ATWrQUPrxJK1+BcJUN0hVDE5/QO+FG7tMYdtUIomw4IATHOycKzCMb1quB9H/pZCLiQHrwpsGBHbo7+zTHmAu8jdLUB7ia66ngUa42PP2FRmXo87AQIEDXSPhyes6bPNgBz4qivcsmUGEHWmV1nmSIo3taDZleANdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770344426; c=relaxed/simple;
	bh=gSp+wCawQ0E2VLV/U5S4BP+5VDqLGW5jMs7Aga/ofs4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=F3oMB8eYE/MplC8I3uZXP0o1BYSLyAjJ6b49Rv8K1Gi5TK1QOKE1y6BltttkZcTlUDbSafRwoZ4cz899f2a52TZuO7REKnpTiFo5tk3wUmLfCS4bkMUZno/sPF/2IYBxMFYogyzIdwQggIOHJ6jolXhxpnwU/iMuOJnZoqIFWe8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IeBcb9/t; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770344426; x=1801880426;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=gSp+wCawQ0E2VLV/U5S4BP+5VDqLGW5jMs7Aga/ofs4=;
  b=IeBcb9/tWz2TxDSifeDnMjDChmY54bQTEQdVRuU55VX6wHwPDPl0n5M2
   Wy/y+8NyKosVfNIKJCs2LMt8lCpns6xCnKVxqUsI9HobC1uyrg5EyrjKM
   TsU9QbDAcQwWTV1kQMivi+b+qw6tHzNU/UP2ExbtxVLAgR7d2m9YZjnr4
   JYs8OHmYo4UGyZVen7cAQBbyMLmvfNQyhZVadjJ4+v2jaiEWEdOOLvZvA
   22brhu339t0VYXAXMd3oV3sl73N6tCgz1fFiWgNslNKyf3xonghUhvjMu
   wd3IYmaRQgSI4olcTkaXTtUObigzUUcz9vHbeTkw9daoTlm1gCPksJdbv
   Q==;
X-CSE-ConnectionGUID: nBd7kdxJSDSwIF6HXBHOxA==
X-CSE-MsgGUID: uL7SegPBQ+KuRwukf1EpwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="75172949"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="75172949"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:20:25 -0800
X-CSE-ConnectionGUID: DLldRZRITp64JbjVWjw8Qg==
X-CSE-MsgGUID: QcrXOJQDQOKCjYYe8vEyUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210022705"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:20:25 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:20:24 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 18:20:24 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:20:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ecQJ6Zxd1iPezaSUuyYjDRcUPLZz35V3Q3jH35ow/U/5aXpFwLgCQ6+jfdg9FB4gTlwnm53Ht69yGIkdLzE12zEZLPZKpS4s6z1eT0Z7w0qPMYVrtsWHc4+gd6VA9owgh91e9MRT0DZb9OQFERXxu7MXSFj54MMiYQX/a58H9/tUdyQXFsnag6eTAcGvkEXY7NLZCbVWHguF2naN4uaEMx/rAnoW/hi08eTwKHH0sfbdKfPpmL6mz61djmvYXNEjjgQ9YRc+RE9IdbSlgXCFqCbPDfa6mrWQGLIcZ3ClQhNVzCvtW99JPE6CCK/WIq4R2jfFI1YZij7IChp9ZuUUUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzzFYM686vQKSJbBhkHTxfH2ghVlL3yi+zxqqL8Od0E=;
 b=MUf0dJW1S1QgD2PCkndnHFwYDPaKHPAQo3AjveXSGdOG7FA0ooAz67f/05sZtUtzmWXElejQnjLSDiDT3KFTHEPm55pq9xByqD+1rYdVMsrIGTL9SN4xunRGuTrehnplt8oNu0MKQDWdzvC311Rslk0JaW/uX6mKzdjQDMxLN7IhH+7IrBEOK8nmlqYQjDJFYjQOK1Xf16OXuiXjx03D8/pN2Lv2yPGk7cdIGmmfyDpCDuCtrGGr+cg36I2uu8GtAITxx6CEtJs72MUlc2AJHF+eQ544LniByfNWEDc1xjAkJmkJ+SluDGzZpebZulscKMNvNQj6uAKQIDJIG5UlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6805.namprd11.prod.outlook.com (2603:10b6:806:24c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Fri, 6 Feb 2026 02:20:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 02:20:21 +0000
Date: Fri, 6 Feb 2026 10:17:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal
 to S-EPT in handle_changed_spte()
Message-ID: <aYVPN5M7QQwu/r/n@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-9-seanjc@google.com>
 <aYMMHVvwDjZ7Lz9l@yzhao56-desk.sh.intel.com>
 <aYP_Ko3FGRriGXWR@google.com>
 <aYQtIK/Lq5T3ad6V@yzhao56-desk.sh.intel.com>
 <aYUarHf3KEwHGuJe@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYUarHf3KEwHGuJe@google.com>
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6805:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e56bfa-9b53-4a66-c340-08de6526475c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?af08gx4KbCmr13wHN077x/dxmQcij8NHgiopCE8n2o1m+iH+NBsZ/8+sTRXf?=
 =?us-ascii?Q?r0+IxreRO57zaVGx4hDQ0/dNX8b+VZZzdI1l/U19rgWxxLDqKW5xhUVFCXZv?=
 =?us-ascii?Q?O52pUViGU83Bs2HSAYWUN4nunsyxOVZnngZHliuFFtgODlV01lX0hijsWYXD?=
 =?us-ascii?Q?f6CH22CQoNEIm01ZglOpQSmVLxE9ufMsO8Yl+6o+Na/k8BhmqWk7dJ92TdBY?=
 =?us-ascii?Q?Y6C3JSTepvZrEu1YA9Ipzq6YGlweCsTcmHAFtDM1awQNXZUwTGXwO+AsHj36?=
 =?us-ascii?Q?8eeUdPzCdXNa1/OXyMXT3mKDtps7FNAVpQ/K9M/ZyToGJtNsWeEAks6Z93Xt?=
 =?us-ascii?Q?fNLJ2Oaw8pQjzj1ucx01IvmpXkUQcwsJP6VJu5SEapVlLMzMhH0Ekq8BzN0q?=
 =?us-ascii?Q?SUiF9vu6CNDIPse2VkOm60YN43FnZMkWS9w8OfrSRMOpA8aBvtkPhAxYw1uO?=
 =?us-ascii?Q?fZPjdQBJqmxj1Cff4UtYoBKV93js2pzYDMWKJYDoKZNc+//6R8Sn3YtuULK/?=
 =?us-ascii?Q?W7BKnO6dzJAsM8C2uj/lPXewaHbCnNCDZflFw8k80ZTwwNtOQrdOz2OtnZ0Q?=
 =?us-ascii?Q?boOS11wbz5d6UR6guwozcTpKi0ZEHnh2LQSHAoYyqW27L58fuxUEx1ezx3Vc?=
 =?us-ascii?Q?lzoqi0pmrdgqlt1WqeQ+ysjwqG9GyLoo4ubyWaYeQ/kr6yXs7T7OKnfFk450?=
 =?us-ascii?Q?Qdy/ddVbSH9U5J1eW8Jt+icIax+c0S8NEpOr8zTS0hJeB91QpAz1rEfhHXHw?=
 =?us-ascii?Q?xVSjgU4wWt4r0VhceMjfPH8gHWr+LIPygBkI0a+1RVIyjPIpj7Fvmk2mxQ7D?=
 =?us-ascii?Q?ajjh/hCrw886sGha/GiGijExvuhYlrzxTKxjN7sdKrRm/IEZcR6PhLF/s9jF?=
 =?us-ascii?Q?lOg5RgUDOEHJQuKMFxUm+4d15FD/sCPvB1fuqeKNOHPIS0MfKpk4apiOMeMM?=
 =?us-ascii?Q?EPL7XS1Uh+p4q0MeWePxONnCIawmgDgzohoQb9xNvZhXpPwBCWicbjm8A5rk?=
 =?us-ascii?Q?nRZ0v0lmWKQ13Kxu4Mx514qQ8ndIJ7Ij4JtLGZrAorYNrwEl9opcPaKiLgHE?=
 =?us-ascii?Q?q/ebxQS8SX9nWgcMFgw6OE1Un0xrmKO1RZ+sAdsFE1zjNgr83pSJl3+WeJbC?=
 =?us-ascii?Q?votgXQZms99K1nJbw41crs+Tk/iCWgpa4w5c5lBuXCSDEdv9r5Q1NB7LQH/m?=
 =?us-ascii?Q?IpY9V82sbjCWRW0VM5CKNifLUXbbl0GUmShbnOZ24SWUamK2a9+kxZARwEN7?=
 =?us-ascii?Q?b+Q90md7ib1/u6Cwbn2tcE9OeKZ1aEe4aDdHlnVzmDe2UeoJtCYQ/PuXGlH2?=
 =?us-ascii?Q?y5tNXS9WmU3HZwyb7KpsvXFFUYGV7417zgkvLWp63kBXrYEGRdHg+k66F2vt?=
 =?us-ascii?Q?+zwYIacCe3eBXodkgyW/x5JeFsqdTsUljYcRrXb9FFZj0ILDyrSnfgskSd1m?=
 =?us-ascii?Q?bjRjnPz+e2RzWEU8AYkMB2df7C4pm+qgFuPoi7Re+2eU5lYRXvR23npAQ5pO?=
 =?us-ascii?Q?sQfOc1/3M0VtNWFOPHJSY1HTA+adU8VClLKyCXfcgx+zqrhb30qN+84Wqdad?=
 =?us-ascii?Q?1J17b3Und5pvXg8yIJo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wGV1/+VhNlNe3ZIAJ1dd+xn2rr/NSE949cJ7zf+ltn1Avr8EYcuS/lS5Mf0t?=
 =?us-ascii?Q?xRZJCX3N3CaOB2vs2K8L4x4vFJj0ccBBz+yMSyO+pBnXj61Gw1D0FVc7nMiO?=
 =?us-ascii?Q?KLjJee6mONzkMze2gyMZ+OHJAryEc3LaC5ZZ3qnRi3V0KzANPyhnt7efVOAr?=
 =?us-ascii?Q?xlorbXtMY1kzGT9HKkJEq7Iz2+gfyN0Icl2bExV5ipV1GL4vJC9qbIbRs8gK?=
 =?us-ascii?Q?g99EtL3ajI5frVnMJvlmxZf2aJTnItrzXAuynRW2ddiwree9lcjIoIX9BeUq?=
 =?us-ascii?Q?s/WbTwI5DLXX7+V8hQx+am8e9kYx0qjxEmyUIZHvWzj1VzhB7HGAXXt2lWTw?=
 =?us-ascii?Q?4QQyfXXxSg9QeTgI68awoChWTinFTIRwUbcdn8jrRBfuPJSIJEoHPwIxyI//?=
 =?us-ascii?Q?/TLltNuNTlMa0eA5tXL8a9eGUYjXOw902lIOpM3hBp/koXYE9kWN2V/7Kubx?=
 =?us-ascii?Q?Vfwt6OyhFSTvhT47JzvJUDBzvRUgKFcGDaTDixjQMrfWTMBZ0OECeIkbhT8K?=
 =?us-ascii?Q?Cj6v7Nnjn655j2UaG71EBB3NxkQyhjXPVaEzhEdSpbefk4LAFCf0Tb/uLgSk?=
 =?us-ascii?Q?iI94oQ+topn5LnXVPdj+Nw7s4Js8JCXRnlFpPppmEn+2wZvKjh9Fsjn0KA9N?=
 =?us-ascii?Q?CGmnUboRepINDqTJT54XzOGQrCZ32o0RuHoVnur9LuobYo5PyoWma67ehfMo?=
 =?us-ascii?Q?lokkU9WOSyCmLOioA4c9qcXT6UeZju3QQYw56Ye9aM8Mh3IqOkxKDewJHlSP?=
 =?us-ascii?Q?25ZGgvUKYRNbNhqTy7jw1Ycr3bIm4gWOR/SAv413dPr8MnB87smZBugvJKRv?=
 =?us-ascii?Q?Gi27xNtoWfFMj37UglMK44beYg97hgFCnmTEwKeSc2Fb6f0ylsUHn5RmPK2e?=
 =?us-ascii?Q?PVQtgOG3BvdFrBEKZxlbRAjF0NibN4wPI/ayPC67mZpisflJ5G3fv17yn9C1?=
 =?us-ascii?Q?umwxTWxDnYNd+3FNijV7Wiy3+O/HHjqtUYRmVHO5Tt3J4PO4UqItH7cqJJ9m?=
 =?us-ascii?Q?VUcI+/rNsfEPld1lNY1sf73D0YKJpOX74raThoVe3Uof7ync16znRvaNdYYS?=
 =?us-ascii?Q?ymx+QDAYYjFcc6gKOmyRzr5GuflOC4XBQ9/izzr5O8x183aDMhCuNDoSIGZ/?=
 =?us-ascii?Q?xfDcKshwZ9timFPtoZ80diwyvtL9o/0MfgW/om6rUYTIgKGUQH5l7UtiiXad?=
 =?us-ascii?Q?aGD3l0zjib3+7TyJAB0R7B2UOevB2NaCgjxB7d6rzHUcNaqTFoUsBhYg6lUZ?=
 =?us-ascii?Q?Q1i8uE/WvFug5AszOdOipdYc1gIKBSLcvWeJcJa+Iu8thXvvKJqTo7gFQweH?=
 =?us-ascii?Q?TIbiBY8LPH0hP/vYKMSKK+Hyl6G/hQBnAYZ6yRYUgRmFhEM9ZJiyWpQHZ3T4?=
 =?us-ascii?Q?65a7UpI+YKJFleBP9HIcXhtgJyeHGk2TcCqgY3cjMeH3qRuHIPgSHYbKaIcc?=
 =?us-ascii?Q?3J40cJlhmK/6AORM/ml5N/qBcJYd8/nUj74j+zCvCcwPznx6wxnh2suPY9sj?=
 =?us-ascii?Q?P0qMzH7YhKiTkqnCqNX8cbICrsEcGli8zmb0//hbvOl/tFg0fJMGEzXeBxio?=
 =?us-ascii?Q?DSH9svFFbjjO8vptKY7KEOECk+Ybwg8LkMcxtABEmflr11RXSmjukkRFzvGw?=
 =?us-ascii?Q?Jy1SgnDuQ65NW3VSWLR8yJMTQEZ+GxtiklAaRhKJPYz4sVywqGLeK0VcMTQr?=
 =?us-ascii?Q?Z/AI3Pbw9WBz17K1aqYjRoLYczv6CJ/7P9W2C3yW4ZBCUTK+3gy5bQFVJNpr?=
 =?us-ascii?Q?Vj3b39xgtQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e56bfa-9b53-4a66-c340-08de6526475c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 02:20:21.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdGb6+SRNwtaOpAv3gzXKX+7ws0X6CHHsGlJALO7kdPxxO1norhqQR6smrVzDI2icOd3H0JRNkhiXYZ+VMK4pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6805
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70399-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9DEE8F9389
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 02:33:16PM -0800, Sean Christopherson wrote:
> On Thu, Feb 05, 2026, Yan Zhao wrote:
> > On Wed, Feb 04, 2026 at 06:23:38PM -0800, Sean Christopherson wrote:
> > > On Wed, Feb 04, 2026, Yan Zhao wrote:
> > > > On Wed, Jan 28, 2026 at 05:14:40PM -0800, Sean Christopherson wrote:
> > > > > @@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> > > > >  	 * the paging structure.  Note the WARN on the PFN changing without the
> > > > >  	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
> > > > >  	 * pages are kernel allocations and should never be migrated.
> > > > > +	 *
> > > > > +	 * When removing leaf entries from a mirror, immediately propagate the
> > > > > +	 * changes to the external page tables.  Note, non-leaf mirror entries
> > > > > +	 * are handled by handle_removed_pt(), as TDX requires that all leaf
> > > > > +	 * entries are removed before the owning page table.  Note #2, writes
> > > > > +	 * to make mirror PTEs shadow-present are propagated to external page
> > > > > +	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
> > > > > +	 * external page table was successfully updated before marking the
> > > > > +	 * mirror SPTE present.
> > > > >  	 */
> > > > >  	if (was_present && !was_leaf &&
> > > > >  	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> > > > >  		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> > > > > +	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
> > > > Should we check !is_present instead of !is_leaf?
> > > > e.g. a transition from a present leaf entry to a present non-leaf entry could
> > > > also trigger this if case.
> > > 
> > > No, the !is_leaf check is very intentional.  At this point in the series, S-EPT
> > > doesn't support hugepages.  If KVM manages to install a leaf SPTE and replaces
> > > that SPTE with a non-leaf SPTE, then we absolutely want the KVM_BUG_ON() in
> > > tdx_sept_remove_private_spte() to fire:
> > > 
> > > 	/* TODO: handle large pages. */
> > > 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > > 		return -EIO;
> > But the op is named remove_external_spte().
> > And the check of "level != PG_LEVEL_4K" is for removing large leaf entries.
> 
> I agree that the naming at this point in the series is unfortunate, but I don't
> see it as outright wrong.  That the TDP MMU could theoretically replace the leaf
> SPTE with a non-leaf SPTE doesn't change the fact that the old leaf SPTE *is*
> being removed.
Hmm, I can't agree with that. But I won't insist if you think it's ok :)


> > Relying on this check is tricky and confusing.
> 
> If it's still confusing at the end of the series, then I'm happy to discuss how
> we can make it less confusion.  But as of this point in the series, I unfortunately
> don't see a better way to achieve my end goals (reducing the number of kvm_x86_ops
> hooks, and reducing how many TDX specific details bleed into common MMU code).
> 
> There are "different" ways to incrementally move from where were at today, to where
> I want KVM to be, but I don't see them as "better".  I.e. AFAICT, there's no way
> to move incrementally with reviewable patches while also maintaining perfect/ideal
> naming and flow.
Ok.

> > > And then later on, when S-EPT gains support for hugepages, "KVM: TDX: Add core
> > > support for splitting/demoting 2MiB S-EPT to 4KiB" doesn't need to touch code
> > > outside of arch/x86/kvm/vmx/tdx.c, because everything has already been plumbed
> > > in.
> > I haven't looked at the later patches for huge pages,
> 
> Please do.  As above, I don't think it's realistic to completely avoid some amount
> of "eww" in the intermediate stages.
WIP. Found some issues. Will comment after investigating further.

> > but plumbing here directly for splitting does not look right when it's
> > invoked under shared mmu_lock.
> > See the comment below.
> >  
> > > > Besides, need "KVM_BUG_ON(shared, kvm)" in this case.
> > > 
> > > Eh, we have lockdep_assert_held_write() in the S-EPT paths that require mmu_lock
> > > to be held for write.  I don't think a KVM_BUG_ON() here would add meaningful
> > > value.
> > Hmm, I think KVM_BUG_ON(shared, kvm) is still useful.
> > If KVM invokes remove_external_spte() under shared mmu_lock, it needs to freeze
> > the entry first, similar to the sequence in __tdp_mmu_set_spte_atomic().
> > 
> > i.e., invoking external x86 ops in handle_changed_spte() for mirror roots should
> > be !shared only.
> 
> Sure, but...
> 
> > Relying on the TDX code's lockdep_assert_held_write() for warning seems less
> > clear than having an explicit check here.
> 
> ...that's TDX's responsibility to enforce, and I don't see any justification for
> something more than a lockdep assertion.  As I've said elsewhere, several times,
My concern is that handle_changed_spte() can be invoked by callers other than
tdp_mmu_set_spte(). e.g.,

tdp_mmu_set_spte_atomic
  | __tdp_mmu_set_spte_atomic
  |     | kvm_x86_call(set_external_spte)
  | handle_changed_spte
        | kvm_x86_call(set_external_spte)

When !is_frozen_spte(new_spte) and was_leaf, set_external_spte() may be invoked
twice for splitting under shared mmu_lock.

Therefore, I think it would be better to check for !shared and only invoke
set_external_spte() when !shared.

BTW: in the patch log, you mentioned that

: Invoke .remove_external_spte() in handle_changed_spte() as appropriate
: instead of relying on callers to do the right thing.  Relying on callers
: to invoke .remove_external_spte() is confusing and brittle, e.g. subtly
: relies tdp_mmu_set_spte_atomic() never removing SPTEs, and removing an
: S-EPT entry in tdp_mmu_set_spte() is bizarre (yeah, the VM is bugged so
: it doesn't matter in practice, but it's still weird).

However, when tdp_mmu_set_spte_atomic() removes SPTEs in the future, it will
still need to follow the sequence in __tdp_mmu_set_spte_atomic() :
1. freeze, 2. set_external_spte(). 3. set the new_spte 4. handle_changed_spte().

So, do you think we should leave set_external_spte() in tdp_mmu_set_spte() for
exclusive mmu_lock scenarios instead of moving it to handle_changed_spte()?

> at some point we have to commit to getting the code right.  Adding KVM_BUG_ON() in
> Every. Single. Call. does not yield more maintainable code.  There are myriad
> things KVM can screw up, many of which have far, far more harmful impact than
> calling an S-EPT hook with mmu_lock held for read instead of write.
> 
> The bar for adding a KVM_BUG_ON() is not simply "this shouldn't happen".  It's,
> this shouldn't happen *and* at least one of (not a complete list):
> 
>   - we've either screwed this up badly more than once
>   - it's really hard to get right
>   - we might not notice if we do screw it up
>   - KVM might corrupt data if we continue on
Thanks for sharing this bar.

