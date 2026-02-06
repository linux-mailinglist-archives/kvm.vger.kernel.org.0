Return-Path: <kvm+bounces-70429-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPebI/K5hWmOFgQAu9opvQ
	(envelope-from <kvm+bounces-70429-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:52:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E7444FC3F2
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:52:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7967A3011C6D
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 09:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A516736215F;
	Fri,  6 Feb 2026 09:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VNdDF3Kp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B822571A0;
	Fri,  6 Feb 2026 09:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770371514; cv=fail; b=TO38BfVMtuLJxYqU0fm+QCrZqEqrr912fORLk6HMC/JQspGCIlTnDIFTW4pzJYqfRzo7m+EGUHpnRtdpz5j4VuGL77Bw/apHWasCXzY5QCsfdRMxhSDD9gOfk+RLxd1dOuuL5lpIH65TRqON/GD2RnENATe8MUgAP0J7hKSXd4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770371514; c=relaxed/simple;
	bh=6/ED0duojVUFS+A+T+v0YR2+GnBCyJ5yNRBKwLP6uy4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PWvBwHSk2APVhi0L4CvsQdHCQInhIecZw5R2t8b9zUIdpsXAhi4rrZgLvxFDAxdsy79p44qLQFIzU3tiinM2xDNhVcmgnBXw5BGIpUDNjnxzFAVkf0o4GI+CI4vr7whNjarmrLaWm9Ru9cxXy/3vTo51PD8ZC9VTu8vRjmbIEko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VNdDF3Kp; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770371515; x=1801907515;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=6/ED0duojVUFS+A+T+v0YR2+GnBCyJ5yNRBKwLP6uy4=;
  b=VNdDF3KpAIu04gwmuu0X/xsHk7eumMM3mcrPQ7katRFBWvM3cHb40bLA
   6VPiYLPe7UeYiVNvDQZ9e4jCF1rgkBU8XYArWJRvKvY2Oe8O3s1+4ZMnW
   AYJJnqwEDAvBKxCyBJUcJXcocf4RDIFieFXF/DWzH92cQLDxvYi6yeQPw
   cY4Wlv/vyF2BB7LNBSl6kRismugP5sxE0EIxE/VTYOP/Dy+XoEuTeSRuZ
   oP9ZGN0JRfIIS19SJWzDa8CKKckfdyALj5C/PfQqVUiBWocj2jRcVUv3N
   F39SUtlDej8DKSljDFd+NCwIYgREMeaKZlGpk4vryk3Hr9naETIZjlOZF
   A==;
X-CSE-ConnectionGUID: CKAfP6jETdO0Q4fMKfgLqw==
X-CSE-MsgGUID: K00yX+VOR4CY6RoZO2KlWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="83019060"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="83019060"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 01:51:55 -0800
X-CSE-ConnectionGUID: 6oYX9PKxRzys3I1G55+8qg==
X-CSE-MsgGUID: YwPGnGN8Sve+1FybPSKCmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="233770321"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 01:51:54 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 01:51:53 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 01:51:53 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.20) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 01:51:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FI6jd1cYLGP//b8sNr+WEtKcjYhEyFz5fU12jG8F8DQrD3YL5RY1w+VTJMCVHejQtdISLUzMDljha6iw+Lv6MZz6DYNl7c2/GPqVxOI77onzo0xiDa+SOLDh+PheEzkTeY3grqcDq92OCTClB/yMNuHhUuWkmtcETAcyskfYBnJUstKRKW4Yfd5lVRwvOOrMH0qwq+1zN+uxCsJQ56f1JpryUmPVZ89+v8b+p/gLomklGeMj5OenFxGV41FHlCj+J4I42MZPU36IEiZUpLCSQotF9rcNRsoovIT+1Tqgl4vaMKM6Zpal5zWqv/0fpaQSo2r0EGPLGJLZS9u/ajTSIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+D809ZUmKXkUwtGweJfk65o2Yb2C4cWj/665IO3hs8=;
 b=h8I8PWoEXWtgyuYs/ZepLdHf1QHAaN/q+WWsuipN9Y7mABUiC0lfdTx7N9I2z62dUQ1XN9dyLjtEncP393CYgaZgVuAsUJLJEnaYDAODGmBQPb9gOTE2xtvAnzqL2E2x4Cejzpo8T23zry6O+zZjYiK9dQEg1ZUZ0G1jbKzWuSo74DedzgBK1cJqcv8AX83cJOpPlBGJnakbz0Oeo2ihnX6QvU2YbUpxmG5H3o1vtJ/M8GJQozlDMzlGETgLXgDkV2OIbOb4yvcTEaf3D4+HoZox04Vd7cRWZ5VJh4eAUfywlxLfpCdEFWobnpueyckTqF1PDaWP7Xxqv/cb9wFgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7882.namprd11.prod.outlook.com (2603:10b6:208:40f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Fri, 6 Feb
 2026 09:51:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 09:51:51 +0000
Date: Fri, 6 Feb 2026 17:48:57 +0800
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
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Message-ID: <aYW5CbUvZrLogsWF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-21-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-21-seanjc@google.com>
X-ClientProxiedBy: KU3P306CA0001.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:15::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7882:EE_
X-MS-Office365-Filtering-Correlation-Id: 3600b28f-bdc7-4730-f05d-08de656559ec
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QW04Ra937MgbBTrW6z95o2evODIHGViLvhZ+3wskG/A6w6HFMxOUayuUajAm?=
 =?us-ascii?Q?oboAVkHib87iTMWJ9OFnpV0W8Nwt2RFDNWDYlh5vfKZYE7lflRu8dl78vyjV?=
 =?us-ascii?Q?Kf/87LcBAYa9/q4J2vP9JYZPhjfVyoOTFcI+Ynb//LCHkkYvVCqrChufZl4T?=
 =?us-ascii?Q?xXDVmT7jJ2cO0Za9Fyqgk7WtmryKbwNvcGKUpnL4VOTlh+F8h37WA9kmxO4j?=
 =?us-ascii?Q?15gHuqHfyc40BFCOMIU2W4pj0jdmpUIJCVQiYZ+ihfv40dtZEGOlyowUjMdZ?=
 =?us-ascii?Q?x3PXvwJvuN0YN24tnbedvX16jmVaMPgWZbLsReExhqWHMTJWkdjHtLgUJcVg?=
 =?us-ascii?Q?VNejYVVFsU9HN3ApcZmkf3KXG1CEfEwPSy1XEYXZtOW/uoB/lsLDapVMeOSH?=
 =?us-ascii?Q?Q8cf3Iua51FsAj5v/rEtYutQwpcVanB3J5UGNboleuY8/JeLG5dQdwpjh6MD?=
 =?us-ascii?Q?G5MpVYS9ti+IIwhdSSSlgVX2AjwXPkExTnN3+HkmKyM77hQ7xqu5AaqYgo/t?=
 =?us-ascii?Q?vAp4TvZlr7HvYlg2TiBNnx/8dnB0VS1iFmtEb0ftDhLOhJscxTc/SoWmfqRW?=
 =?us-ascii?Q?1TaPsG4M6bm1cRDe5D17/CcO08Z6tqygfKn6scV5ulXIgN/ADiDqG78zeXhk?=
 =?us-ascii?Q?D5mQoT5r3OqKzY3OAu94iYUMSkjdpvKEaATcXVebx6/alnCrIfLYi0boBrkG?=
 =?us-ascii?Q?JDuAdDC14k09we8ggl1dGE9d8CwqPjVth2ZorKQ2Pu0xdhJEIQwpLFPk1G/g?=
 =?us-ascii?Q?0ydHsoCRxbuRK+SIo4uF/JukbLqkcB+VForegmIsRk/0HJqfdjJXS2LM/xnT?=
 =?us-ascii?Q?hcPR4dxTTu8LA0PgLjtFquV4OzHBmfVHSRw8ciMuE9Bq499dPur3PUpKzGtI?=
 =?us-ascii?Q?we3v/0b0LsxlUd1ieRIptv8DRUvg0xo0B9sqF3ay+heuKhOxedv5qjxkGdSZ?=
 =?us-ascii?Q?qnALWsqFLCNJDrPuyPe8OaS6M72Lvlr6DqUp6qt/jYoBIQ29GXLHBTJnMq1Y?=
 =?us-ascii?Q?dYHOsRU2XsY/Y1JeiX5EM9GThYJ40vPCwQ/FXzXWKTR7Mlo2Hr9BwCEbu/mQ?=
 =?us-ascii?Q?fQetS4u+N9mcdCnY7UWESNMNaIpuhKK6tHDBqfZhxgj75FGwXYuUtoyd2JaS?=
 =?us-ascii?Q?rINIRCxlmMq40BxRkPC/k6ILuK3IL+ql4TAYuN7xUbCbKWNSVDTIHqyNxA2a?=
 =?us-ascii?Q?ofzMfXWbjx0xTQ5CrLHVd/eGV7iyE91qMH2SjR+FZBhRuIzOk34OPQBYOnZh?=
 =?us-ascii?Q?OOkZ3owmmhgxzz4DZyP7CdmpWjNeTo/agSaSlBRGZNiiezz7R0iLlXJ3vrub?=
 =?us-ascii?Q?WKWy1F9OsPRrl/ZRAs/rm9jQI7+BdodPKLxWRpYGuiTTdF0jHrxJDR6OsikY?=
 =?us-ascii?Q?eRwQmnh5Ja0JKUOdOyNaGNHNkCp3glJA0xUOu36iQAOEBOh8FQhvO0hRukOF?=
 =?us-ascii?Q?+xBLTeyHG0HbFyRpeHCWXhxpau7J/8GCeZeTidc+0Qa2dZXaIg4jEWahuJds?=
 =?us-ascii?Q?1u5zjobibaD3jItP+R8b2LQ09qSEA9tdixArnlG0GxCF9lOOCCnO1rNurEzW?=
 =?us-ascii?Q?7ZQ3hRf5XWvroJnEc1M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vy2XZrMF3OuAbOSvv54mCAGGr4+GN4msT34oLdx3COMZSrhHwdHey4yW483x?=
 =?us-ascii?Q?boCRAliNI6LFf9+E3gvDePH+IQ/42X7lw5XKmHTBEvAdo8ALa8HdRZguFL+/?=
 =?us-ascii?Q?sxzUKqL7ndE4UYrFi5kzb2+4YzKWua8jVCzBTNAa/Lf/tJdzQgl7gFODhzHA?=
 =?us-ascii?Q?30ohcYcyvLw6oKBmoTHP/NtJ3utA9n5jhSCoHT+4pXIYIE5mrmsmfnwhoSKU?=
 =?us-ascii?Q?7ukuvRrS3Yujy5NLJgQN24QyLjiYEDZZddlyUk8doVcpmfE6u7XJn9yglI8Z?=
 =?us-ascii?Q?hiThnqFU75ugFTaGHido7WTgwBHvAAQNuUmpbNccRjmDAOn7s/UekEHT4TJs?=
 =?us-ascii?Q?/x/W5vNiCM0DWn4rph8gNKJCu8afXHGeBQ52IgrA6GVfeUjgQO682VUXtUm6?=
 =?us-ascii?Q?dQtqXHsXicf+R8RhayZa8gPk2myd1vGVEB0lYg9KCWm08oG2Lz2QRDhiaHNf?=
 =?us-ascii?Q?asgWWFDgY6+qYeMqWtgSGNN6EnzKgWTeF0IoAXZJr8S6lfIVYsz2YbM0Dy/G?=
 =?us-ascii?Q?Ki/KlMOpK+DhkTEgI+n9iGXixLp4gfVN3PABoutuYe1IR4uA1H/TRzuwfLqv?=
 =?us-ascii?Q?FwT4CRIaWSSF6R6vF9muFGQ2j9mfAneQSRZJVx3YE40ty6WDZCBN7ZgEfoma?=
 =?us-ascii?Q?0SMOf+5+wtY5WT3rw8jQk6FQDZ8aXqQC+R/TDtH5iC5hYkxXqyaUb5Rccb5o?=
 =?us-ascii?Q?/F3BV/PMTzwA4xlGmL55j2xzBN4lKwgeoe5y1IVl111f22aRDhx7Jb/QdVkt?=
 =?us-ascii?Q?clXKwIiOFEvplx/EDki2KkBeYzyUQPrnTO84tBjgKNqTYFw1yAWZTdPFG6La?=
 =?us-ascii?Q?4LhfsHDHTp4irMJmDccSVw+fRbqT4Tj1JYbF3xsdPWJJdr58EH9k0oiqukVk?=
 =?us-ascii?Q?lE5pDu2v1FBkSGfwVtnoRTBvCxGBHevIc7TaN5hyQYnFAzNpNI4HONbj6GNk?=
 =?us-ascii?Q?bK4H33Rjx2ZaL/pzHWn+N/AeauTd4BRSNbXuxrcwDAVEL9LDCzD4MDm+KC2F?=
 =?us-ascii?Q?2MfvXSVOQyHxibborXnTuWDsiCR6Hq14B1C0eO4BR8guJwSGXlZMB1dfgFlU?=
 =?us-ascii?Q?J4BJuJU1q4zl4iS7yOnikO4KyuFXmszad97XRKHW1xCR+JOJyfnaEAuzGKjJ?=
 =?us-ascii?Q?w+sFjcKHejyvi38TGJvTx9KnRQV3CbBIQyicjyHLkjNJCfIbz9/dnz09QefM?=
 =?us-ascii?Q?mMjQ38/JswS5E6kJxCpFe6Tb8eFErl1VOmFIR13/iP026OXEopGUKCERg7Oc?=
 =?us-ascii?Q?sW/L8atI1mAX5BmqJyTIpYRUuggLWMBZivCjfPVTi/0ohlLmBsYDYUXgom3I?=
 =?us-ascii?Q?iaN7qGxVOVikXGO5M7Sph1i2pe05eqOiaGh+UsDLh7f4i4IPImnlrt2ofmkX?=
 =?us-ascii?Q?ftjlra2u5k+zQ0lA+BBuaEvTP/REWmulPXjALFbPIQCVQohINOvUxjfn5Z5L?=
 =?us-ascii?Q?uTIP8ed3RA39u590Y7HGSQIyCu41UD12aDfmawAKWKXNbeALGJw/EyamTLQG?=
 =?us-ascii?Q?6i4EScGNMYXuIPIxq5ky+MHO0SonySSRkZgEJ74WhGZNFlgrDo6+M0+K+A06?=
 =?us-ascii?Q?BFpLfjIjonkrA8RIc0ARZQ2c2HUi8+UjoFOQv4zftxX8IFR6gJC21XGvDDb4?=
 =?us-ascii?Q?39IRS1Xk/tnHM3EW7sD+zRuDlMM6NxeMnZEP3yTX5VCCpTeZiHfayaOPkluT?=
 =?us-ascii?Q?/7RcP9xrT46n6wWc+zD5KB6vKSAOGj2Mno5zS43B+S6NAor6gw9/z8XTrkrb?=
 =?us-ascii?Q?l8/7aMttcQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3600b28f-bdc7-4730-f05d-08de656559ec
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:51:50.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7prztX52iUAqXkYcfF7myBLmYYW+xF4fBqLrUmeXTeK8QBWHq0DWLrCZir+CmGEDUtlW0bxL84E1s2tkJqRcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7882
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70429-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E7444FC3F2
X-Rspamd-Action: no action

> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 18764dbc97ea..01e3e4f4baa5 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -55,7 +55,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> -	free_page((unsigned long)sp->external_spt);
> +	if (sp->external_spt)
> +		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
>  	free_page((unsigned long)sp->spt);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
Strictly speaking, external_spt is not a control page. Its alloc/free are
different from normal control pages managed by TDX's code.

(1) alloc
tdx_alloc_control_page
  __tdx_alloc_control_page
    __tdx_pamt_get 
      spin_lock(&pamt_lock)   ==> under process context
      spin_unlock(&pamt_lock)

(2) free
tdp_mmu_free_sp_rcu_callback
  tdp_mmu_free_sp
    kvm_x86_call(free_external_sp)
     tdx_free_control_page
        __tdx_free_control_page
          __tdx_pamt_put
            spin_lock(&pamt_lock)   ==> under softirq context
            spin_unlock(&pamt_lock)

So, invoking __tdx_pamt_put() in the RCU callback triggers deadlock warning
(see the bottom for details).

> +	/*
> +	 * TDX uses the external_spt cache to allocate S-EPT page table pages,
> +	 * which (a) don't need to be initialized by KVM as the TDX-Module will
> +	 * initialize the page (using the guest's encryption key), and (b) need
> +	 * to use a custom allocator to be compatible with Dynamic PAMT.
> +	 */
> +	vt_x86_ops.alloc_external_sp = tdx_alloc_control_page;
> +	vt_x86_ops.free_external_sp = tdx_free_control_page;
> +
>  	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
>  	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
>  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;

 ================================
 WARNING: inconsistent lock state
 6.19.0-rc6-upstream+ #1078 Tainted: G S   U
 --------------------------------
 inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
 swapper/7/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 ffffffff9067b6f8 (pamt_lock){+.?.}-{3:3}, at: __tdx_pamt_put+0x80/0xf0
 {SOFTIRQ-ON-W} state was registered at:
   __lock_acquire+0x405/0xc10
   lock_acquire.part.0+0x9c/0x210
   lock_acquire+0x5e/0x100
   _raw_spin_lock+0x37/0x80
   __tdx_pamt_get+0xb8/0x150
   __tdx_alloc_control_page+0x2e/0x60
   __tdx_td_init+0x65/0x740 [kvm_intel]
   tdx_td_init+0x147/0x240 [kvm_intel]
   tdx_vm_ioctl+0x125/0x260 [kvm_intel]
   vt_mem_enc_ioctl+0x17/0x30 [kvm_intel]
   kvm_arch_vm_ioctl+0x4e0/0xb40 [kvm]
   kvm_vm_ioctl+0x4f4/0xaf0 [kvm]
   __x64_sys_ioctl+0x9d/0xf0
   x64_sys_call+0xf38/0x1da0
   do_syscall_64+0xc5/0xfc0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
 irq event stamp: 252814
 hardirqs last  enabled at (252814): [<ffffffff8fa6f41a>] _raw_spin_unlock_irqrestore+0x5a/0x80
 hardirqs last disabled at (252813): [<ffffffff8fa6f096>] _raw_spin_lock_irqsave+0x76/0x90
 softirqs last  enabled at (252798): [<ffffffff8e60f139>] handle_softirqs+0x309/0x460
 softirqs last disabled at (252805): [<ffffffff8e60f401>] __irq_exit_rcu+0xe1/0x160

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(pamt_lock);
   <Interrupt>
     lock(pamt_lock);

  *** DEADLOCK ***

 1 lock held by swapper/7/0:
  #0: ffffffff9077d660 (rcu_callback){....}-{0:0}, at: rcu_do_batch+0x153/0x620

 stack backtrace:
 CPU: 7 UID: 0 PID: 0 Comm: swapper/7 Tainted: G S   U              6.19.0-rc6-upstream+ #1078 PREEMPT(voluntary)  b8f4b38003dc2ca73352cf9d3d544aa826c4f5a9
 Tainted: [S]=CPU_OUT_OF_SPEC, [U]=USER
 Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.SYS.0101.D29.2303301937 03/30/2023
 Call Trace:
  <IRQ>
  show_stack+0x49/0x60
  dump_stack_lvl+0x6f/0xb0
  dump_stack+0x10/0x16
  print_usage_bug.part.0+0x264/0x350
  mark_lock_irq+0x4d6/0x9e0
  ? stack_trace_save+0x4a/0x70
  ? save_trace+0x66/0x2b0
  mark_lock+0x1cf/0x6a0
  mark_usage+0x4c/0x130
  __lock_acquire+0x405/0xc10
  ? __this_cpu_preempt_check+0x13/0x20
  lock_acquire.part.0+0x9c/0x210
  ? __tdx_pamt_put+0x80/0xf0
  lock_acquire+0x5e/0x100
  ? __tdx_pamt_put+0x80/0xf0
  _raw_spin_lock+0x37/0x80
  ? __tdx_pamt_put+0x80/0xf0
  __tdx_pamt_put+0x80/0xf0
  ? __this_cpu_preempt_check+0x13/0x20
  ? sched_clock_noinstr+0x9/0x10
  __tdx_free_control_page+0x22/0x40
  tdx_free_control_page+0x38/0x50 [kvm_intel c135d3571385e160f086f9f6195fc72e4b6aa2b1]
  tdp_mmu_free_sp_rcu_callback+0x24/0x50 [kvm 3932b137c28c130169e7e3615041bcec6cefc090]
  ? rcu_do_batch+0x1dc/0x620
  rcu_do_batch+0x1e1/0x620
  ? rcu_do_batch+0x153/0x620
  rcu_core+0x37d/0x4d0
  rcu_core_si+0xe/0x20
  handle_softirqs+0xdc/0x460
  ? hrtimer_interrupt+0x154/0x290
  __irq_exit_rcu+0xe1/0x160
  irq_exit_rcu+0xe/0x30
  sysvec_apic_timer_interrupt+0xc0/0xf0
  </IRQ>
  <TASK>
  asm_sysvec_apic_timer_interrupt+0x1b/0x20
 RIP: 0010:cpuidle_enter_state+0x122/0x7a0


