Return-Path: <kvm+bounces-45761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF7EAAED4D
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 22:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8975B205A3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 20:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8757E28FFF1;
	Wed,  7 May 2025 20:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PKxF0BSq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89AC28FA9F;
	Wed,  7 May 2025 20:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746650645; cv=fail; b=i3ZSfLNzuldBhcca3RnIBLinsIbiq+BsWpVy2xTClv5Pc12mrLq5MYO1T4bUWjnsXnXelrrcHqM1YJLtEpNGcz7fo01aqxgwuP/PePX3Pl7//ME+Oimbdb5w+vyeDBQuhJIrhTKbF6jeEy0K3u66EK3cNLmFStLtE0fXXeCMbnU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746650645; c=relaxed/simple;
	bh=74Ff8pE1NaU7rkhVOEOs7GJ7sR3xV76dxePCwokXXnM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UjQA2BlrUkY0yw0iIVBLv8etIRqU6EOBn4NzM3+TCdDax0QRTLNIsxBU/NEpkSCXRHos5cgiW2d3DF8Y/trVbMb58c0/TEZWKTE0F+iIHANNo9iiPOnBffLOpZ1IaZZZTKZdZ1fnPUpa+VPRwSjZ0ZVOI24CjCIAYH7cepYA01w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PKxF0BSq; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746650644; x=1778186644;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=74Ff8pE1NaU7rkhVOEOs7GJ7sR3xV76dxePCwokXXnM=;
  b=PKxF0BSqaKo7Vn8ux969mWWMlqbDbzyOvCJuLjy9drO4JIDyjXw2rGTq
   /xw78h/qbcdlid/peFEDNM5okQjOOFcbOsYTG4WaFdvHuOrz+nojE5Aea
   X7o5Oai7NAdcE8vKXzo4jXd9jyprVrzt5/2suFa5Eu65v/w+HJgZTn1Dn
   oS4MhdB8N1EkUvU/BSbUcWT82rGxs3n40c+hQPiJOTuoR0A0gABp8Tz9s
   koJBu/llexzGWxJFSxjqMn1UDsUzdcc37pRpdk3agSzK4BBeKrXSNzvst
   js1Dib20bJYV3PaaOhjApZ4GnFY0jbLeJ6gSLsowgw+NleUvOIxk79abW
   g==;
X-CSE-ConnectionGUID: 2oMHzEXTR+Sqxh+izpLyEg==
X-CSE-MsgGUID: TbvKb3BVT/yXbrYA6SHeCg==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="51064340"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="51064340"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 13:44:03 -0700
X-CSE-ConnectionGUID: nQH0dYWJTdSk/+Qgtiscjg==
X-CSE-MsgGUID: DUh8xz6KQV2dqQ0CfdHNKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="137069901"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 13:44:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 13:44:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 13:44:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 13:44:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NdI8n2EHbsbpVeghoKiWuSI3E96pX8BQEpWagBR4VoCfx2kZi/Phr0rgq0ppydSfHizxTQ9rw2cm2YPtLz/2bokwe+QMmalIKdylELL3/c/6f+LgbPVpqtzrUZ8yFIWbuv1epgCeHmI5ClyMx3SKq4GM+JKBDG7/xQcbTGW2Qpz0qqJhrvgvOlHsseXkLEiFblAvRr9+/rub0qCVxZId6kj3f52+ERKD0iSCMMUIVuRoECYUagN2FU7SnOTHrccdFUJ/snHKN5rgHGxC5oAhzcrRYhzhCeKBfqrDZW5fo+MVmbXi8hgJY28ZTq7qEaWPeJhKywJvFJ7VcAMWXc95+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0eoNp6XRiBO7c1DuNIcDRw4hL5q8ofpaXJKr0yqBJA=;
 b=NgukI/5gW1cDHL2L/L7priIsTNTaO1Mhrb959sg9cOvn9sTzwuMCvnN95MpWXORwpu7M+yoZOHv2cnsV+vuyKilOMfUniS1QisccLZ37q/3jE4GfL6kdSV4MtoeHqFyotIh4sczReNTz07XefUOcgF+xgv+RtvGCLWXR5vHFuJldeKG4+6WH54hzcc6q3eKpSJDHJ5SMseakgxdAmbIDgg3O+cPpl9rdKASQZxMj00ULxEh3SEIYVDm9qSO+LlalDpiSWUpFRmnT6UK+SZgMSi+GCIAyTFY0WG+xkSEU+wFMIXbYvxcxdQ+aJuThfH2cR2hm0H9fI3pL2vo1p0n7GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by BY1PR11MB7982.namprd11.prod.outlook.com (2603:10b6:a03:530::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 7 May
 2025 20:43:26 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Wed, 7 May 2025
 20:43:26 +0000
Message-ID: <3a9ebdf4-1a52-4659-84ad-2ee015b453f8@intel.com>
Date: Wed, 7 May 2025 13:43:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/9] x86/nmi: Assign and register NMI-source vectors
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Sean
 Christopherson" <seanjc@google.com>, Arnaldo Carvalho de Melo
	<acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, "Kan
 Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>, Daniel Lezcano
	<daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, Lukasz Luba
	<lukasz.luba@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brian Gerst <brgerst@gmail.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, Kai Huang
	<kai.huang@intel.com>, Nikolay Borisov <nik.borisov@suse.com>,
	<linux-perf-users@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-5-sohil.mehta@intel.com>
 <20250507082216.GA4439@noisy.programming.kicks-ass.net>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250507082216.GA4439@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR02CA0048.namprd02.prod.outlook.com
 (2603:10b6:a03:54::25) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|BY1PR11MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: e06427bf-db51-49b3-fb43-08dd8da7d100
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cW9Tc1RmNUw2R2I1R2l1Ny90WUkwVHA0T2RKUEgra2xaVm40eEUxZCtLUzc1?=
 =?utf-8?B?WmFGaEhheCtJMmJ4MC95YVFvVU9udFpZb2lVRzI2amZUWUZSd0lxYlhRWFIr?=
 =?utf-8?B?RFVGYkdQZWQ5TUx4L1BaUzc2Sm9EU3JRazNVQTd4cUtRYVpjeGUxYnhGYjY0?=
 =?utf-8?B?UTFBWGhLVXpiRkR5R0YxS2dlSHNaR09lYm4ydWdMNmxjUkprRnc0VWx6M3dU?=
 =?utf-8?B?bVp3b3ltRFdyc2pKb3Jya3N6Y3BZOWdrUFlyRzg3NHhoMldEVFIzcUlNTkxL?=
 =?utf-8?B?WXBpTDd2Y1FMMTlxMlhNTzVocHNPNStOQmYzUUpBZU0zTHkvdk8xT3l2amtt?=
 =?utf-8?B?OEV2SDlBY241ZkREbitsTS9tUUxQeC9pZGkzN1ZtZ1Q1eVZRUjJWSDFuTitp?=
 =?utf-8?B?czZCZFcyVUdTZnJMRFplSWx6dGZCTzlDMXhLZHY5N0p4RHJzenZ5dzNNUHU4?=
 =?utf-8?B?bm9lK0I5emphb1RaektueXRWN1hZUGRTcXRjZmg4cEZmVjFpMFQvZ3ZmWkZG?=
 =?utf-8?B?Sk9TRE9teHIyVlIwOEhoL0xPY2txU2hMK2lGRmhscGE2MllVTUF3Yms4VGJj?=
 =?utf-8?B?ZFM0MVlUNUlqbjA5NUJ6TG15TmtMeUlWYVNVQUxUMkdZcUF1Wk1IcFROSTFk?=
 =?utf-8?B?c3VvVm1kY0hRby9ENTFaZjRrQWgxa211RGdTYXlSZjdwUEFXRE5UTkdnSmdi?=
 =?utf-8?B?WHptdmxXRVFXVVJGVDRKRWd5ZmVkQ2QvZHU5M3MyazBzYUpndXUwWHViVGpH?=
 =?utf-8?B?RURnZXVaVGxDVEhvYm5EejdzRUM0RTk1MzZFNkVqME9yK292dnNQOGJmU01n?=
 =?utf-8?B?UlNNdGJJRlNzKzZsMTZWUTQwZllCL09nNHdlQlJZZVlBRmhCY0wyd3JCM3Ry?=
 =?utf-8?B?NnVrTk9HNHBpcUlBWGJDSXVoTTlJTGIrbTV6d3EwSFRZTDZrRjRnSElLU2tQ?=
 =?utf-8?B?TzkxYVZFTHFnUXRYL28wcVF2SFdqNmdyT3ROMVkwaWR0WkpmV09pSzc2MVJN?=
 =?utf-8?B?cDl3amxGVWwvMFE4TzFiaFEvV0hqWHJUcWVINzk2eE1LbUFiUXJVbVRuNjhs?=
 =?utf-8?B?ZlJXRnVubjJOUlFXZThYSkRRdHpON05odUlnYi9mQmlnVUNsUk91eGljMFd3?=
 =?utf-8?B?Zy9la3AySHV5RTZaK0YrMEE4dmdjc2NhbmlVVU1QdnZvM3Z1NjFrQmd3WG1v?=
 =?utf-8?B?anlkaC9NVG9QV2c1bmtidmlLMzZURkk0M2sweUtEQkw0UXo4UWFyT0M0emRE?=
 =?utf-8?B?Wis3eDlYSTZIMkc5ZDJycndrOHZnakNZNHJ4TWxOWXJVcnJoRk54SzdXVVlq?=
 =?utf-8?B?Z1JjaCtFS3hvYUY0UVhsQ05nNjJGWTFtSGx2US8vZWRZS1dhOXdQYkJraERD?=
 =?utf-8?B?YzMweHprUUc1dFE4YlZmcjlSRVloUWY4Z0sxR0dtRzVRK25BeGJIeG1LUnpG?=
 =?utf-8?B?Ky85Z1kvK1Ywakh3Yitwcm1KYkxZZ0wzQm54VW9hTFF4M3g3TUVWTnNvR1B4?=
 =?utf-8?B?MlVCMlhlelhSS2k1bXJid3JNaWo3K1g2QjBTVVFrMkwxd1RBS2FJbW9haURv?=
 =?utf-8?B?ay9ET0JOVm1kMWZ6MmpXa05ZT3BOWndDZVFVMkZDbnZlNmhnczJFampCN1Rh?=
 =?utf-8?B?QWZXMkx0bGhsUDhJQWU1YTBpbzI3bEFFWk1sMDdCeVNrb1JUMWI0RE1vSHd0?=
 =?utf-8?B?bkY2WUdoSGpZbW1IS3gxVlV1VlRpSWhxbzJqajlmMzIzbXl2QkdJRkZTRGlx?=
 =?utf-8?B?UTM3ckhMbEZSMEc2YWorSU91akRja3NSNmdManZZSnBqZ3l1bkJDOG9nVTgx?=
 =?utf-8?B?aDFXcUxvMUZuV3V4ampwa2QrVk4xZ1MxZ0phT3NYSkxXREJsVUxSRHZBUXFs?=
 =?utf-8?B?RDhHNlBLdnFQWlR1ZUdPdjJqWkpVTkNBUjdrZkVMdXN1MU5FWVZWWG55V2tV?=
 =?utf-8?Q?QdkK/hM58h0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THU4MUVvWnFJY3FKc0hvUEJlemJHajU2K3g2VWVWTEhzcWJVT3ZMWTAzMjNI?=
 =?utf-8?B?b1RReExWL3M3MzNrSmxrUTNtUG1tR0F6K3Zxc01mTzl1dUNCS1A5YjhhOFhr?=
 =?utf-8?B?Y0lSQ1RCYWthSXhPY0RQN21aY09zdTZlano3RUo4Q3FaR1FVTldmakZoaFpD?=
 =?utf-8?B?anJObjA5d2t0TE1FOXpNclZlN0xOeUdWSjVvYWkrbTVST0ZkeTNOVFo5Ym9z?=
 =?utf-8?B?YldWZkxGeE9rUjQ1MS9zNXhwR2ZOcnJ4dU82a0l0ckFObXRPZDRadWU0dTlK?=
 =?utf-8?B?Wk4yQURmMUhoZE9vcXFpNlczQ3I1a05iZk5ZMi9kMzIyS2s1Z2lTaW1CWXhq?=
 =?utf-8?B?QldWR0h6b054dEpHYU9ENzc3SHF1bkc3YTJGa0taZzdWaXZISzNlOVBTSkow?=
 =?utf-8?B?elBTRnNqQUYzQmlNZ1JiQUo3cE91aklsZWJCaCsvU0VvMkVVK2dBK0c3Mm04?=
 =?utf-8?B?dDVTb2hoNnBPa3N0Z0RCUFg2bS9FK1lqbE9SVmZUQUpiTGRxTVlvSmVETWJj?=
 =?utf-8?B?aXMrMmRYdlhsaW1rMVU1aUVqNktMWjlBQmFjd1FIakIvZWRaZlA2U3Y4by9s?=
 =?utf-8?B?K0FZbGRNSmNzTFVuQjNWRGkyWG4zWEZDYkRSSFVWT2ZKUVNQcm1UZkYxTko0?=
 =?utf-8?B?bzJQQmtaeE8vQzl5U3ppN0o5Rk9HMm0vbUlETmp6YjBHbnUxaWlSSGdIclFV?=
 =?utf-8?B?N2hNalBzMkhFMDNvWHYwZU9OOUUxWlk5WHFKR3ZIWXRjN25OaFZ6QWxqWUg3?=
 =?utf-8?B?THdzcXpMUVJLZWEzMnA3UFp2empTTG5pWFZURUNyaFgrU2Y2NnVJV2ZtTjZK?=
 =?utf-8?B?Q25TdzBONno0dzlrYUFhM0pSTFFHbG01bXcxZmtkSHNDTHV3d1BvNDNkeEV1?=
 =?utf-8?B?NDN2V1FxYTBXbEp5NkJXSDBLT054MHUrczRHYjQ3UVUvSjluQzdYZnEyeHdW?=
 =?utf-8?B?ZlZCYTlRQ2xtUWpSVEQxaEdKVUxEVzNrY2dpbHd2cGRWMHczcUJINTZSemJz?=
 =?utf-8?B?eHRxZnNRRUJPSGdwSVNvRnQ5Q3dhSG5sSzBoekF2TDh1S0tXVzFBa3J2QktX?=
 =?utf-8?B?Z3hPK1U4ZGgwL2Z1SjUxaG9tYU9UNmVET3RhVmJrQllIVHM4TWxTblpEeVRa?=
 =?utf-8?B?c2lSdmVFVkZDaDhKUUpFUmtUQkxhaEZCamdHM2JrV1R6RVNJNlpvbUJBcGV2?=
 =?utf-8?B?d3B6bm8zelFQQUVNQzY5SDh0Nzl4ZXBIZDdGZ25FOEsvUU44eDF5dHdncC9Z?=
 =?utf-8?B?Q3liZUZoQS83OGxxaEN3MnpZckZrWlpES0ZYNG9SNnp2czFkaklFVlFzK1A1?=
 =?utf-8?B?REJ6WVZ0VEphOWNUMytOd3k4VGxKY1Q5MEdlYUpERisvYkp2UjdkbnhoTFZ2?=
 =?utf-8?B?MXlsWHo1ODBoZUVuNGFucXFtc09wUlpBVmpIcUNaKy91VGxyZHduVEZESFMy?=
 =?utf-8?B?N21rVUF4U3BQaG1KcUtmSlZiSW5oOGhSODlwazB5WThydG5Pa1oyVU1TSHZE?=
 =?utf-8?B?dkd3R21pWlFkeEFpdFpNaFlmTmZ1R05nVVlsYzFWMFZ0SXhmRy81aEIrKzJQ?=
 =?utf-8?B?SFZRSnczUzFpNXhFNDJ1NTd4QUF5QzN5WG5Wb3hVZzliNVB1U29wUWhpSGV1?=
 =?utf-8?B?ZWhjMkx3NkVNRHZab3NGRHlDQ2h0ZTBLUk9Uam03MkxvVWQvMUFtUlVXOW9I?=
 =?utf-8?B?cFRrLzZ0cS9nYUJ6L0MrMzg3UVFGSkpCdUtHUUdOQWgzT2VDYllEdGxTeHFa?=
 =?utf-8?B?cnBnSEFSR0hxbCs0RTZyNHgrVVlZenprSW11dnZVbGRta0Y4UkJTVzFVcW1Z?=
 =?utf-8?B?ckpZQnFyS2RUSGtQL21ZeFdURHE1cWlycXBGdnpKSDBzT05yd0RVVnlBeXpw?=
 =?utf-8?B?MHBFTW56d09KZlpwRnBrQXZsdVhxbUxPd3l0d3BSRUJQSkwxQSt5Vk8zVFJv?=
 =?utf-8?B?VEZVTkZ2VzBSc2VMOTVSNy9ONjcyU3JYSmVFRGNPLzJydmh6K1djVVpLOXJI?=
 =?utf-8?B?WUE0OWdldjJiWVRocnlQNFlSNGtKMmEyNW5hQzRqRFdwdUNZTlZ4TE1qUStI?=
 =?utf-8?B?MmFKVGs1S0pDQitpR2xGZzFRQXVtZVZ4YUxkOWR0OHhPazFVMmZtT1JGTkV3?=
 =?utf-8?Q?IoAuizvGo1+vpkMOcvI5tToBj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e06427bf-db51-49b3-fb43-08dd8da7d100
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2025 20:43:26.3687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agyQDREo7UjQJehmrDvz61w+1gET98oDqnYG3L9CXnb7+/voDX6rv4g7iMrs+AkdxoIhPCHiJQu/erpuSA8a3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7982
X-OriginatorOrg: intel.com

On 5/7/2025 1:22 AM, Peter Zijlstra wrote:
> On Tue, May 06, 2025 at 06:21:40PM -0700, Sohil Mehta wrote:

>> + */
>> +#define NMIS_VECTOR_NONE	0	/* Reserved - Set for all unidentified sources */
>> +#define NMIS_VECTOR_TEST	1	/* NMI selftest */
>> +#define NMIS_VECTOR_EXTERNAL	2	/* Reserved - Match External NMI vector 2 */
>> +#define NMIS_VECTOR_SMP_STOP	3	/* Panic stop CPU */
>> +#define NMIS_VECTOR_BT		4	/* CPU backtrace */
>> +#define NMIS_VECTOR_KGDB	5	/* Kernel debugger */
>> +#define NMIS_VECTOR_MCE		6	/* MCE injection */
>> +#define NMIS_VECTOR_PMI		7	/* PerfMon counters */
>> +
>> +#define NMIS_VECTORS_MAX	16	/* Maximum number of NMI-source vectors */
> 
> Are these really independent NMI vectors, or simply NMI source reporting bits?
> 
> Because if they are not NMI vectors, naming them such is confusing.
> 
> Specifically, is there a latch per source?
> 

Yes, they are truly vectors, confirmed with HPA that there is one latch
per source. Also, while generating the NMIs these values are used in the
APIC code to program the ICR vector field as shown.

ICR[7:0]  — Vector         -> NMIS_VECTOR_BT (4)
ICR[10:8] — Delivery Mode  -> APIC_DM_NMI    (100)

>> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
>> index be93ec7255bf..a1d672dcb6f0 100644
>> --- a/arch/x86/kernel/nmi.c
>> +++ b/arch/x86/kernel/nmi.c
>> @@ -184,6 +184,11 @@ int __register_nmi_handler(unsigned int type, struct nmiaction *action)
>>  
>>  	raw_spin_lock_irqsave(&desc->lock, flags);
>>  
>> +	WARN_ON_ONCE(action->source_vector >= NMIS_VECTORS_MAX);
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE) || type != NMI_LOCAL)
>> +		action->source_vector = 0;
> 
> How about:
> 
> 	WARN_ON_ONCE(type != NMI_LOCAL && action->source_vector);
> 

This should work fine as well.

I don't see any harm in storing the source_vector unconditionally even
if X86_FEATURE_NMI_SOURCE is disabled.




