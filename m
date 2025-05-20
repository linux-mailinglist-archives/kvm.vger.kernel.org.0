Return-Path: <kvm+bounces-47096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F37ABD3AD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C84734A344C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB9F62686BC;
	Tue, 20 May 2025 09:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KEd7RmiX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC3B268C75;
	Tue, 20 May 2025 09:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747734169; cv=fail; b=oo04y+21tduYmJFRUEKJiSRuYhGohTEQ8A+J9fkrmoEKDNMAAoNaJ5BivR9mOATCWj2bdtAsGOrTkK0uP926wcvBWjJBxgABqBgkBg9zgpLGVS+yA+cwFcu2VJEX1dahJzlnjVyqQ/V5cnvsdnCkKQ4o7Kgu2NBcMg9IsKX615I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747734169; c=relaxed/simple;
	bh=uJbRMjuurMd7op/8zlE8y0YCg83/W6roXv+GwzUbsfc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FbkJrQsi2plyrdXJjzjcukEbTpds4h327jS3Y8+RkxWEAlkkTkjXWfgbIz4vxrnXLY2I6lymOrcRj4Xjo6wC+MJRSVzcOSdfvG4N56IFCWl368lYKlYUgCa/4YqqfM8mf33K+4YW9Jvl0ESL2VEPxwxx+JfT61z2iClkJTazp2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KEd7RmiX; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747734165; x=1779270165;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uJbRMjuurMd7op/8zlE8y0YCg83/W6roXv+GwzUbsfc=;
  b=KEd7RmiXJqdUq+Zsb1JB1mYQpTPfrBgF1wmzSfPTte3syBqpyJNs5TI8
   xZOYbm891fsHSWAnzMOTTwf8YcfjB3Zbr916jFpt3AZ3oIvqlKxyboCtH
   ZBUKyTmF9LxkBtKkM1XWrmug1pyK7PVIJ7FWZxHxh4MonlhRQtSwtMvDF
   kNpLDBwVpCVnnPBl730D20g03tVO4pISOhuKJC8Ur0zQYUCSdOxPezM4s
   DjFE4n9IGhmHYv6dKQ1MVfBfW+8mJgeoLOC/RRXOqKSFQelL9pTCETePv
   elpR6I9IlPdSWXXXckgxyOClN7lzH3VvYew9aCUppDZ+mMXlNuwkMbUxj
   Q==;
X-CSE-ConnectionGUID: xlWJlKc2Tg+tA9jXhlueSg==
X-CSE-MsgGUID: 7Sjj63dMQiqKDDVVN0s2xw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="61051788"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="61051788"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:42:40 -0700
X-CSE-ConnectionGUID: 57kaHttgSnS3atqHxNGWFw==
X-CSE-MsgGUID: PkdRsEs6S/euWg6cRWFW5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="139482818"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 02:42:40 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 02:42:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 02:42:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 02:42:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnN1RsJleTKPGoN9WyLqYbwQCKx9gdqyTzgWCHSFgAMmsEHtpkDPxmXV5umR2cOkI2U05vAlyVD5UZy8qd2DboIfPhBTokJDWPov/7s3pENcoSonLIchazQQQlDA4Zzfw+wzzypv1NGcJLcD5zhx25rwtfZFWbHQmVSp9RO9ZGVnRAH+7sbVJzH1kV91OAKGyXUfcAPyAMm5ri5OT9I6I7LoFgjBIg063yuvUT7pvgx7w0QVgUaJLTKLlCgAjp2VCzXTNawmADaJoGeNVLdQC7gSBIslFFVVJb5IlNiy69sqN1a/awUVwMIhdvZ28DOZc2BwHc0E14vHx/U5D0EnsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmuqVRmThcpHvUwoO1SgYCPrjWZDFOSgrC2WhLHzNp0=;
 b=m95sPsPBdRXsFP2v9YIJQJ1ukCqctMD3XC18iWgF+JXCMwuxiozBrJfpLCCxww1IYfsDcqvC/9C3wbTrBgDu25GojLCF9uX7Ncz73iqilxGqzC2oRj9JeNGmQOXUPCY8FOXCYi0NRfOaiadA0fgfENKVhNvnmXaLdD7wnFIRDXzzOgt01cXpoiMXHee3qkeUo5ljaj7lFGhSUPzDKjziEOdGjT8n4YgQ/k1Od9+mtQIDwYTnHE1dyX83S+Xb5lT9iiCY02Awcd3G1IhKxkRg4bagXz6oUvYqRDS59iH0YqzWSjpkGArnkzjpc0jT5VsN28JJ00wJfwjoRSoPdEc0/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPF25FF87461.namprd11.prod.outlook.com (2603:10b6:518:1::d10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 09:42:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.8746.030; Tue, 20 May 2025
 09:42:36 +0000
Date: Tue, 20 May 2025 17:40:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 15/21] KVM: TDX: Support huge page splitting with
 exclusive kvm->mmu_lock
Message-ID: <aCxOB5YEpCkUyHU0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030800.452-1-yan.y.zhao@intel.com>
 <22502c16-2733-4d48-892c-3e09dee1aa28@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <22502c16-2733-4d48-892c-3e09dee1aa28@linux.intel.com>
X-ClientProxiedBy: KU0P306CA0090.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPF25FF87461:EE_
X-MS-Office365-Filtering-Correlation-Id: 17f2123c-55ef-4042-3058-08dd9782a6ed
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?FIwoEqNKa0V4ZNjkeOx6i3lygMgROLjbySCzba376/zHEfPUuqTg5OFSE49Y?=
 =?us-ascii?Q?PfJw3NXa1Cl10vUD8xJsuwHmw0iz7mbAXBNudV2k+vKXPzu0UZW89xSZQ0rg?=
 =?us-ascii?Q?qHpwTUXfgTYnI3u3r3qvtcy9PSVgu9yUbRK94Bap+EHhsfcYGeBybu5EpQsv?=
 =?us-ascii?Q?Nu29Rz8WG8Xo1ji6vQdxB/tUSoVSdB+h7y9XNNSGhEL1VvjdtaQ/MBZ/MtDx?=
 =?us-ascii?Q?i+8qWxU3JhUSBZ9IdFAliy+0BtHsriXFKlB4FepbsQtNK9vRRW17OYvlC/wS?=
 =?us-ascii?Q?1qW5SpPyWYtRx4+3/3MX5DDVC4vNf/IWhQer+MFK0ZLofMyoAgFmxhE6dG5c?=
 =?us-ascii?Q?elmoJkYzmctxqTUY4Gm9Cf/U/qLer9mEhlojZzA3/HuGf4fwyUKkRP+BryA5?=
 =?us-ascii?Q?n4bcx4QvswOcm68B1H2LrypvZjudmgLC+rIHNewQMIo1X13rb0fC85IJGPkM?=
 =?us-ascii?Q?Z2htEUqNfvtQWMPLnBsB3M6odTsMKB3omHj7fqfKIRFiekMuQwLF/3c0abxI?=
 =?us-ascii?Q?VCdvhS2SgwSURVwHSDeKoVT3O6HwXCB9VWIHvbAMr2IKS2Y25XfbH5mvHiM+?=
 =?us-ascii?Q?8StQevzIIJaozcAGO0rIMVJD7dELq0UhTAWQs6nGF7fR9eXKGPBoAoxNsyEf?=
 =?us-ascii?Q?yUMiH6ox2VBbq8VdUsbOLj6bjsIrteXMxkdo/kDACfvDQ21xdXVgCYSFDaO9?=
 =?us-ascii?Q?3YVoHfGeH/dUdMqfXwHXbXUqAx7nzF/IU9VTJFTDVT5gjPNqS76nNrS4WDr3?=
 =?us-ascii?Q?aLFthnHCi+ZQx3g9XWOsZQIbyRS/GyUNiICBjm3fVWo6mDBeUYDEbRixRBmI?=
 =?us-ascii?Q?+onlVWAJa6q4spqVToFFRozpK8qGP3nn389iZSCUntY/AdaL5TJY5UBLvUwJ?=
 =?us-ascii?Q?Dd6AZ9pGKZ8MgNLkvmVpSFmh67mDXEHmKQsEryKqyI8Bk/Wo5DHu5Xo9dPdJ?=
 =?us-ascii?Q?BJHW0D8aYe4XAr7jAOLMgJapdRVM5h/+ek2xpoHw6KQp+daXWD3W4NqLHnnt?=
 =?us-ascii?Q?7inbBNcvQssqu/XRO/1+Hi6MXKeAk2yb87lmQyGnRpdywBUXEZPO5mJQy9/h?=
 =?us-ascii?Q?DvWEjbBzTCfyLd7WfyiH2DZphSUclAzybPloM9XYx3/pOmkgHtRjO+Nrcqi/?=
 =?us-ascii?Q?DiNByT2a+RNIVm4muao33LupVNcXzbzGMfSpLgeuoq0dV9dyPYN0VArkQZpc?=
 =?us-ascii?Q?77iXxmEo2Yyk/cItTa+1wl1ak/46PckijX4Cd740nCi6JGb0/WAcsd0qKZ4o?=
 =?us-ascii?Q?fLHWSrL1Y80mwoslZI5EA957ds9I2TWv+hi5g2+yTikUH0rq6D+f+njXTR89?=
 =?us-ascii?Q?zFSD84lNo6J+cNMmE+KFqgvb7OMYdXIMg5VxYPSzOvL3m9PBniwNJV00AFdR?=
 =?us-ascii?Q?phrye5426jTGQJceglPgN4xLrVTJacDVFmKj6HwjsZDanieakg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TZAGsE692sgOZ8a9p1qCwzEK6jUS7Tb3QWKXNiyfvz2CiDQ7tw5A3AXGZ1o7?=
 =?us-ascii?Q?65hbIdH/PK2aWp7M75hrfo81pY7gffOZI+GdVy6smFebP+cdyQOpTpRjcUBT?=
 =?us-ascii?Q?OPo/wtGhr8Rd9DpEyk/qT0x13qPYknHj+mV2jKHJ7XTiGZjL2gGKcIY0qjYP?=
 =?us-ascii?Q?aGLBaiNIid4nNDL9XqobOiB3Iut5pBjUvctHTxxyAPNMAbNUmEwu7rGZjfzY?=
 =?us-ascii?Q?aQFEXE7kuOm33I4d/K4zCBboLhf2O9YMzB7szKaKn7tmJ8Gp9YET2C0CEePm?=
 =?us-ascii?Q?VF05BJeGlm+QZH0CMY9qHoGAPQeCigpx8WGCTni5QPpVAfTEvJfwRYBaCG5K?=
 =?us-ascii?Q?HxoWJawZWRfB1X6gB/kp/wb8h78vg4H1JZQ8hjrAy6/KxGFuBwvzRudUF7iq?=
 =?us-ascii?Q?5wIPB3kKRHrDVCefxNkymLT1li9LLpIbfF5gH1jQlvpiggbQ2CRLX2ljG63/?=
 =?us-ascii?Q?eJX15XEvbTuciXlc6O1QERNZf/xI6h1G0smtXJBvIIjqIV/5ymeOqcgQ0Uog?=
 =?us-ascii?Q?Wkr2bqfnewgsjYDPfAWy/7NF+AXwpO1tz6XSK8gI3qnGFVKkc6QzGXSrFXyK?=
 =?us-ascii?Q?UiAnBuCnuQThNhuwUz0vOHTilxa5I68Pe+4jwiPOxVrDocIRc5dLOClLbnLH?=
 =?us-ascii?Q?1AO7/6zNRNfhFmLuLWTqOxwa05i+V6HpNoU9I9Tv35s0k4ZbwsawmV8mDiIb?=
 =?us-ascii?Q?xQMxzdWZfm+RHBH+aYPu6NzMVR2Wv7nTXEv7qrFH8b9Tni4W936bJO9hk9ci?=
 =?us-ascii?Q?ho0Z5s6gLyK6cjXnRM0+29jut5sN+8EdLKPXmrAKb9VKxffbpmyzH+pOUMNX?=
 =?us-ascii?Q?r1uRJrDCQunJHJU1o9Ao1IOV1R/Rg3/EWHWQ1toCvG7h0/CiOlIpe9qn463Y?=
 =?us-ascii?Q?tdKxI8S3zPm+VdZ7+0oC3h8hAeRrPb4Tm1xMdGOxhrUbC0iB68F5JruJJ9tv?=
 =?us-ascii?Q?tUAPbEwk9Rt8WS+wH/i8kl3t9KmrInjo1+68kVWF7jsDx4Ed2Zu80CNSo3SF?=
 =?us-ascii?Q?UItIY8TOOfSG4/4pI3eAYBVdw019IYgu0Hv1a/g+tTM9leMNeDWWgTCX5Iq7?=
 =?us-ascii?Q?HTwZRHyDJf7+MMkW0i4sI+WfTcoGFQKaNCFs6ylsz+neM75AHQZHkxX3sanL?=
 =?us-ascii?Q?nhIkfya67K+KiXrzV2HmRxFlz9ZhwF8BSq/xTsifBY33mL0HIg1KLZgISKHp?=
 =?us-ascii?Q?3+iE3XeJ40NeiaUAi99a2paqY79fWgpf6Y7mB5KUK9QTwhsMmi8nQ44MB88t?=
 =?us-ascii?Q?oQdswaGopDZ5J/slxysRomRbFURHYYOpahPsrtQAqAGFNKSo2Y4VAXFiJXJ1?=
 =?us-ascii?Q?Noiu62+OY1n9sHagZ3uyrjO8iczaQLlGSSNw7k+681Xq4GQnT1F3k0QOoNG5?=
 =?us-ascii?Q?NQtA+xeD4/kYQ9YzFozgkxRaiKdMVfc0bO2M4P1Gs740kAzs1nBvTEGL6bmD?=
 =?us-ascii?Q?/I3pDwndjMV+z/roqduiHuLQJKWXxDHW3nvShQI1FnKSU692FZl/QqLDv/gj?=
 =?us-ascii?Q?MKeioUaOABDEKa/679m3AB/5me/mRZ+EqvjkyLvHbngUr+3DpELajlrndcQr?=
 =?us-ascii?Q?ixTnQN4YevZQuXj5llhHlybzHDnb6HVhlr/SfQ0j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f2123c-55ef-4042-3058-08dd9782a6ed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 09:42:35.9867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61y9oHZzumfHBSbWTRDQJs9PpAg+P73AQ68exAOAsXvD2oSson8IcD9fM9IexAU+gxXtjUYBJWOuHOHA71yJDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF25FF87461
X-OriginatorOrg: intel.com

On Tue, May 20, 2025 at 02:18:12PM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:08 AM, Yan Zhao wrote:
> [...]
> > +
> > +int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +			       void *private_spt)
> > +{
> > +	struct page *page = virt_to_page(private_spt);
> > +	int ret;
> > +
> > +	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
> > +		return -EINVAL;
> > +
> > +	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
> > +	if (ret <= 0)
> > +		return ret;
> > +
> > +	tdx_track(kvm);
> 
> It may worth a helper for the zap and track code.
> It's the some code as what in tdx_sept_remove_private_spte().
> So that they can share the code, including the bug check for HKID and the
> comments.
Not sure if it's worthwhile.
But I'm open to it if others also agree.

> 
> > +
> > +	return tdx_spte_demote_private_spte(kvm, gfn, level, page);
> > +}
> > +
> > 
> [...]

