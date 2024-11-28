Return-Path: <kvm+bounces-32709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A5F9DB171
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30D8AB214DF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C5C52F88;
	Thu, 28 Nov 2024 02:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NnY3slBK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B122E401;
	Thu, 28 Nov 2024 02:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732760601; cv=fail; b=WjIEMGPHfUZA9j8Wu1EZg+xN5zBEVIQZrqDNEwLNO0yHzx9WNJg2TNDCgePKVVDy5ikRQbNfz8SrrakUA39fLrawtD4PORznd5ZtT2TLOoIZmSZJvxREcfHEHmNEqZh5KtOLLCqDSO4k21lcgkAMm30gUxL0dvFI1Wrm9dNdBh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732760601; c=relaxed/simple;
	bh=SDGRzqHO5+8rn8BhYWFfU6+dXJ/MnSWBskWBZb1F3Wo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RIJ9712W2vvHoBDqRsSth/teFbBkxFaTa5g0wUCUW7yqNEqCLSFeQQ6kqcbfIwslrGd+d9KOuCK8NinByM8RNJ7y1MnPwIVIapXS7BTBcNJnaNJ1/Y/Nqu65yAYTO9Wi5bX3SKG+1ehFWS7WROPEeZN25Q25WErydIfkBbkaZFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NnY3slBK; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732760599; x=1764296599;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=SDGRzqHO5+8rn8BhYWFfU6+dXJ/MnSWBskWBZb1F3Wo=;
  b=NnY3slBKYgsDsaRS0DFGZxPsQQhZV4XUEPRqe+Mb53vA7xFXr00FjuzV
   NxWMbhrC7PpXQXSRmPFtLp1VgrgwfBIhT6QYJE42SimT+fhyPbhUFDKx+
   6ULrpwSc2D8ovZeJPiH5LqF2fhdswMZbgDmKvrD/BQrDmqg8Hq3ZnyOjM
   pFlxP2jJVJEjhei34g+8595RyELVl4XJsMHa+srxfRNP797odcTlFQZZW
   BY3dU/GDJ4/R/rzVkqBiFnru71HXnPKWgj6S26sL27WTA0KEBuwHP7+fq
   J22Y2Tp41cJ66Ve/Eb7/D+iTBrBLDrsdoyVAzenNN3kpM67CFusezHw//
   A==;
X-CSE-ConnectionGUID: F6Jno1sXTpaesJgLK6vTpA==
X-CSE-MsgGUID: BMJAw61KQ96Pq/MSsK617w==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="50384618"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="50384618"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 18:23:17 -0800
X-CSE-ConnectionGUID: NxjaJTcQSSy3/uk5a+vT2Q==
X-CSE-MsgGUID: SPnYBaEkQpSypzWlceV4Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="91916366"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 18:23:15 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 18:23:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 18:23:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 18:23:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=id3NPWwgl3NxT/7M2uL8KeG30bAkrN51Q9YXT38PVNLnM14wlM7fg3hKVKp1qdTIqURPOFAU9o83xw+myGYZFPJ7q8XSE0E7BUle/IPM0OFAmjOlNb8ZZenswRlS8LZJ9S4KEMDf+8RYWpAepU7V5/mJtFlIRkWXRC73b++9HXGBh6emYveX4m8tfnxIxIv/rOnPqNEB0//e+BehcRFWLUkQpKcZ0McB5FhnWJBO7kTNBwl0N99i9zJFU6mim7YxvrQz5gPLXs6sDAXaoAUsqqQ+/DbHD9suVQRgxCfQcPSf0LaZbY22KnXQXCs5tWx6F5zl5u3NLhAZxrwpQP4sAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfhq15hK86UmWRBkMvU/OaCjNwf9eitXA6UxphgNW18=;
 b=AKC2GEte6HhgDxrSTEd4cKAKX4Yg3VUm/iyNfJuP2qYHwr9eqFUvByoCJRxJD7euKTBUnEzZoFDcNQGgQsAtWU+I8th7PveST9LdrmsI1jiJpQbtPZSa9xFkVLY/jbq9rfB1Z+Q4EhTTZH44foTvJlmsgQ1JIUI2jPGFZoxXwi9+knIA7Rm5WWDI1yGbzZIbL4b2hUba5Kbz8SOd8NyZbLyQrWLPu9QhdmDTKEc0bNbgFTTDU4gLa98zK19K4rKYvQrDoXXVkBcgnWKSGnW37MUOxsEfyPFfhVfejG/WeC4s5e+C6EamVGwjpsBO/CfqtTf0x0IRSE0xCQhlJN40Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6864.namprd11.prod.outlook.com (2603:10b6:303:21b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Thu, 28 Nov
 2024 02:23:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8182.019; Thu, 28 Nov 2024
 02:23:11 +0000
Date: Thu, 28 Nov 2024 10:20:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v2 21/24] KVM: TDX: Add an ioctl to create initial guest
 memory
Message-ID: <Z0fTaqabmj27OJqe@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241112073837.22284-1-yan.y.zhao@intel.com>
 <c270d467-4a12-4dab-8cdc-47b61779a37c@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c270d467-4a12-4dab-8cdc-47b61779a37c@suse.com>
X-ClientProxiedBy: SG2PR01CA0127.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 99db352b-40ac-4c8e-86c5-08dd0f539b2b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b3BId0wra3V2TGFvTnlOelBRdHNZVkpJWitpeTh1T0JFM1p1bTNtTEFZbm1p?=
 =?utf-8?B?emNlNVBLdHhYSHNrUGlWdkpUZGpFazQ0UTl5bmQxNEV2NkkySS9LYnhWYUxD?=
 =?utf-8?B?QkZDVTZmRitlUUNDdDQ1cUlYbkEzcmpxQU5ZZDhKZzd2MWZtaEcyK3IvUWhj?=
 =?utf-8?B?Vld0SEREWVVWRTI2eC90YTk0b0tFdFVRMWxXQ093OHc3RW41VWJHeGlwRFph?=
 =?utf-8?B?emZYZldSZ1lQSEx5TCsrZHRRZVVXb2p1elQwTjMwUDAvclpneTBoZnZHK2M2?=
 =?utf-8?B?cEN6QWdqOFUyU0lYc0laRXBZd3J5K2t2OTRSbGdRendWWnpvTXhYV0FzM0dM?=
 =?utf-8?B?UDJoOW9la2F3Q1dqcEFPWDB5WUM3allYWDNBWVhLekg2TUkrSGNjUWlhQ2Ex?=
 =?utf-8?B?U1ZGWWdQcVdkalpidUJnTStNR3pRNDBBOHlWcjdKVTF5cStIclA0VWh0RDBm?=
 =?utf-8?B?TFZWOHNMWW5Cb2ptTnlvOFd1UFl1TEpZNCtPRGlNV09yWVZGamhRTmlXeW5h?=
 =?utf-8?B?Si9qYTY4bGZjT3phdnFUNCtIeUUwTjVuNWNzUGVzV3J6YkErbzFFQi9XOEh4?=
 =?utf-8?B?eE9mdWVLRGxhTUw2VUpPQzh4ZDdSVDY3U24rNGdlQjJqaW13WDk5azhuTDk0?=
 =?utf-8?B?UVRZU1lQVUVBNjdNZitQdmRFaXNYZEJqbzR6cVd1UXhaU0lXRlBzajBkOStn?=
 =?utf-8?B?SDQ0N2JrNmgrVWtZcDNTTVduTE85SkN0S25qUUU4cVBmYkIzOEpWUG1tQ1Z2?=
 =?utf-8?B?c0xCRnpMNlBoNXZ4dkFGZ2xFTXFoNGRxaUx1OHV4ZVd1d2R1cmprRU44eFdR?=
 =?utf-8?B?SG1IMzF5clQrbmpXVkIrNkZGNWtvZklwVUdjTmk3aElKK0V4Wk44Z2VVWnJX?=
 =?utf-8?B?dXFhRWxUcTJYZkZmK1FNR2lKemM5akRJdmhiVklBVDhHZHBVZkgxNk9EdW5I?=
 =?utf-8?B?VmxWV1NtdEpiRVVrcFo2RXFCTW4rR3d1UVMyblRIanpHOGlvNlpqdC9IZXND?=
 =?utf-8?B?Y3hndjBZZUdDNDREVjZzZUdNMWNlSnpsS0VWeGtYbmYrNVJaZmc4TUxmUGNi?=
 =?utf-8?B?UEUyODlEUjZhYlJRWjNpRHJKNi91R0pveXVRUXR3MVBqd1I1WU5hNXM5eVVK?=
 =?utf-8?B?KzFXeG5CdnYxTm5xL0VxMWNjTktSTVdnUURNcWNSUk9pZnFEcWRBVGZnQ0JE?=
 =?utf-8?B?bWV0WlNFdllKcFg0cmx2dHlQNUN5WlVxZ1dPZWhuNVJic2VFZ0pWaUFmMWxQ?=
 =?utf-8?B?aWQwcjhYMUhiOFRMNEJhVmZJSkNzSkdpSzAzbDROOTZxV3NvcjVLaVRJVXpq?=
 =?utf-8?B?SHRobTdCc1NwRjMwNnJ4dnpHWkJham1wMXlHL041UW1DR2VhU3orY2pEOFE5?=
 =?utf-8?B?NXRoTnBBaXJORFdBbWxuZGdNZWlhNWZUVU1DdkgwdHNBTzl0R2xaUks4cEhG?=
 =?utf-8?B?WlRwMExpSEdWNEcwMkNXRzI1OFhFUnM1OHpEYTNqV3A0aUY3dTNjalhwUXB4?=
 =?utf-8?B?cVJsTGZ2STJWOWR0ZFowcm1wM0F1ZUdJRWN3QTlkRjdYTUJVWXVMbUY2SHVN?=
 =?utf-8?B?TkZkUUhoRHlBcTRmRHBtZEZMUksxSXUxWC81dmhJUW1TWkplRGh4eWZZenIr?=
 =?utf-8?B?RHNJbHpidTB4Sm5xOUlWYmN3YWpiK29LSnhObHhVN3duNGFldzRWV0EyaHo2?=
 =?utf-8?B?R1RXWlQ4dUJydlYwTUkreGtSZk5BYjlaQUpQT3RnQ3AvZWtqb3hzSWFQb1VL?=
 =?utf-8?B?Ry80dkVtZTAyWnQvOS96aXRzUDF6ZDRQbDRxdW15WEdUYUw4SlBlazJQZTBl?=
 =?utf-8?B?RnRkRFU4Y0dybWVCaFNodz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wm5oWHpsWUhLMno1UkJ4YkNCRit0TW1RYkQ4QjJ0TWpXZ1VGdmlOVFNnbFZP?=
 =?utf-8?B?TW9IZjFyOFpoMHV4OHB4bFE1aXhkM1ZCcHJPTlBxV1FaeWVBaCtOK3c2M1Fi?=
 =?utf-8?B?eEN5V2dsbDhLV1Q2K1E2QU9NRTNBOFNBaFNMTU1VV2xHZ2hrTzBUVkZFSzNo?=
 =?utf-8?B?Wjk0MzNibWl1dm54Smd5WnRWQWJUYk9Bb2E2YzF3L0dKdUc3UlgxMzExdWsr?=
 =?utf-8?B?QWZDVzF2dVJPSGNqM2tDbGZNZWdkRlNzN29JQmVabWozWitaSGpqUCtET3Ri?=
 =?utf-8?B?MnZnVnhBbW9DY01lVzVsSVQxVSsrVStSOVh2UktTZ2Z4YVBpaXlpOVFFMitP?=
 =?utf-8?B?Z01NcFI4M3htWHB0MFpEN3NINkNLRTNUeTRnV09hTTduMlBxOUNTK2FxZ2J1?=
 =?utf-8?B?SXhmN1BqVVFGV0ZpMWhKaE0xY3UvVVI3ck4vN1FjTEl5aW9zU3ZaN3I0TlNj?=
 =?utf-8?B?WmZJbFhNSVBld3hkSmE2Q1RRWm56RDJJb3RDLzJCdUg2S2JyeU9VTkEvWkh5?=
 =?utf-8?B?Sm5IV0oxZlYyZEx6NkdNdGVGL0hXQmpBeGFJcDNkQ3lZOHRvS3FKTW1HM0xT?=
 =?utf-8?B?YktZTXBtUXlUVG5CQU9xVWNMZktjZmRTM1NYNjd3UHUwZDVpQm9uUnRWS3JV?=
 =?utf-8?B?UGdxYUVmK3JnZWtMeTBpbkl5eU1rODlBQmVaR1dmQllRVEZOWkpwdnFpVGFN?=
 =?utf-8?B?eGJHc2NPdU81dWNzUU1UUFY2WGF6dWlYaHQwWHg0dWZVdEZDS3JiR0d0bmZ0?=
 =?utf-8?B?cEtMWnZqN3pCcTJLSGQ2dE8xNmdFS0ZzRU1LMTJ3bm4yaGU3dFc5MjBDQkg4?=
 =?utf-8?B?cWxScU5SVVI3cW0vY1hBZjZ0WnJoME5GaTVSdzJmS1VTQzYxUnQyNFhVcS81?=
 =?utf-8?B?RkVvUWpwN1ZURHhzOGtMRDh4cXY3ZzlmV3ozVGhldnpvbmxid256WXp5Qitr?=
 =?utf-8?B?dHNINDFDS0MrWWFBSE80cmx1UnVTVXlEeGNoNTNRaWh1Q3ltbWRHWDR3aVZy?=
 =?utf-8?B?L1BlVGhXOUhidDFFWnZIOEFGVlNaMGt4aVBtM2dFWmprMDRURS9sYnpuR2pT?=
 =?utf-8?B?bzRBa0hYL0s3MnFSclNDdEhyOXBFOEpiSkxvK2JCOGxUSDJBSGxSL2VreSt3?=
 =?utf-8?B?TlF5WXFDK3dnZVp4bU1ZYURTbFNCN1ZPQldyeWYydWs5eHJraDlFdFJxZHMv?=
 =?utf-8?B?bksyQ2ZaeHRoQVZLaU83MVBuaWhEeVlnSWRZamNKa3BQdW04S1NXYTB1NlZY?=
 =?utf-8?B?RHFTT1lHeEhwbnByWFVaUk1sS3dCK2FGZSt0eXQrQy9BYTRuRG9TUk5jN2Jq?=
 =?utf-8?B?enI3eDU1cGNmeEFldW1mdkMvWlRualcvWW5IdWNMekh2QjNwc205UVUreUpO?=
 =?utf-8?B?YUhabnR1QnNUOXRvTTlSWG1tKzFybm54cDc2Z2R1L2VLTGJxWlpIYytaWUJQ?=
 =?utf-8?B?SllaTllqQXpGVkZoYWwxemYwZitsbXhHRE4wUkdxSmdybzBQSk1lRGE0OU5L?=
 =?utf-8?B?S0t3c2VycFFuZ21WT1JBVEJOMGVibnU3OGxJTDRLanZTanlNNHVQMVlVL2ZK?=
 =?utf-8?B?NVJBWWpndm9LZlRhalp2VkxaLzVNU3BUUDU2OFN5UC9UU25GMy9XcnRFaHIw?=
 =?utf-8?B?WDV0dlpTalNhNlMxem85cVJyNEllc1RiR3JtZlRQMk42ak1lUWVXNXQvQkVk?=
 =?utf-8?B?NlRMWCtSY0NGZTVxM0RubkFhWjFzcktXQkMwalpyU0dsYzNFdkFQNVdTRHBr?=
 =?utf-8?B?MCtoRk01NVZ4YjdpdXJDOUFuSndlK0JIakd6NDlvVXpBY29hRFU3MlBSTk1i?=
 =?utf-8?B?Z3BITTU2Ty9rSXBYNlcrNEtCdjVLZ0hTeFY1TzlOU3k5TkV4OFZnYXFhNWk1?=
 =?utf-8?B?QjZmTFRCaTJhZDRjeWFvZk9RaGRDMFhEc3hvTVBraVlmd0UxTllWdWU4SWN5?=
 =?utf-8?B?SlZ1TUVQdU40Zkg0Ym41NkhrTnNBNWVJODdjWVJwOWF4dFppTWN1U0pJSG54?=
 =?utf-8?B?YnlmdENlbjdjZ3ZHaVdwclBUV25oSHV1S05yV0N6RWh5dDh1d0ZlOVRrRGVO?=
 =?utf-8?B?NU1XMjZiMjZMdXVQMys3NnFVeUVVcHhUQmNkcVlIdXVQUEFOM3V0TWY0R3A4?=
 =?utf-8?Q?vf8ufUO+pZW3/8Ck68I4l8OQB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99db352b-40ac-4c8e-86c5-08dd0f539b2b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2024 02:23:11.8083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlRxqqCxHWg31PybMLvgUne24zNWBSGXCi5d57+w4vTLiQxlcRv6zMxm05WA4ZQ52+eltNc1794vxNJXaGMAPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6864
X-OriginatorOrg: intel.com

On Wed, Nov 27, 2024 at 08:08:26PM +0200, Nikolay Borisov wrote:
> 
> On 12.11.24 г. 9:38 ч., Yan Zhao wrote:
> > +static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	struct kvm *kvm = vcpu->kvm;
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct kvm_tdx_init_mem_region region;
> > +	struct tdx_gmem_post_populate_arg arg;
> > +	long gmem_ret;
> > +	int ret;
> > +
> > +	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
> > +		return -EINVAL;
> > +
> > +	guard(mutex)(&kvm->slots_lock);
> 
> It seems the scope of this lock can be reduced. It's really needed for the
> kvm_gmem_populate call only, no ?
Strictly speaking, yes.
But this KVM_TDX_INIT_MEM_REGION ioctl is only expected to be executed after
QEMU machine creation done and before any vCPU starts running. So no slot
changes are expected during the ioctl.

