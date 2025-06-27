Return-Path: <kvm+bounces-51006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35938AEBB96
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:23:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75E573AA919
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B66E22E92B5;
	Fri, 27 Jun 2025 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M1yqAJDR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3B92980BF;
	Fri, 27 Jun 2025 15:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751037811; cv=fail; b=GBRJ3dbNu4OZoGSLMheXzYMQhDU+43hbtKYXSymS5u4lGcYWsv5353Dx1bu1FoMerxU6jfjyIRLvukIsrvf/DbrFJY+EG5QKARaqraRziNu65eBvblaGPSG8nYrOhqVbqeS61ba1PsVCwN3TypsBZQEHFkz2oMZYtwSgIwwvoFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751037811; c=relaxed/simple;
	bh=lJ4xLO3IC6uljndz02dc1UfekIjzioMGY2RyPbcQ410=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HfyWXeU802lt4oTuwvZhUycIWzwaaPWcLoRGqMayWsTIror2bFuGbyHXw/wHpgwCBQ54qL/TWjr7QaJI15lOCeGIQdrtorAgUXtWWOa2H3HHjfYFO9/mSg+h2/wdpN+PAc5eeZwLrWIGC61ZORSrPpAr0eNs6Q1AaMMgo16/Yug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M1yqAJDR; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751037811; x=1782573811;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lJ4xLO3IC6uljndz02dc1UfekIjzioMGY2RyPbcQ410=;
  b=M1yqAJDRIy0VeN4MnoyiElzZ9Lpi7z8P7kEHgNLFX24nGsS5usHJRaxq
   tKWxdiWRrv5yDDT4WznSs9Yjr9X+TSUGA7COO8hRfzB+Pbbqi+jYPvqbh
   FCcrUbx6gi/Mg2UrP8ubH9v5A3++aBx5V8SQawXGksRQrxoHHB7/NVM9i
   cqmLiBh3dXb56HH6lSUzYTBNMB0SRKrM7vPEdSp6kegqR1psd8+oBkCri
   oQNSthJFrUWqZFp8p9q8ntZ5HDoS1HXYBGr1PNrDIMwkl51+2e3gyVn1M
   Hm+kVzsx6pFfiaZkIXtuHpi0nIuzZXWEFuwM4AFl1ZqVKH3/eMlNuC7V+
   A==;
X-CSE-ConnectionGUID: 9yAAQWxKQxaVq8qNAEF1Kw==
X-CSE-MsgGUID: D7bomM5STXKNFzOThJTGyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="53226543"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="53226543"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 08:23:30 -0700
X-CSE-ConnectionGUID: 9F2yNIFSQcSSrHGRx1JCJw==
X-CSE-MsgGUID: W1kt8sb4SzaYsxRJq7yk1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152566571"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 08:23:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 08:23:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 27 Jun 2025 08:23:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 08:23:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=svP5qvmPtXRWhP1cIydDfdkApO489KA0wiwZpAfdwT3zxsWy3cDPVL0CRmAMdDnZUiVxRBeVwYiiWn+ACxhtA6XgxoYqQSgsVRpNBBQ4zo5uPAYNO0oSzRgcNYQ7LeLSvAAARF3gh9MvK5gmwteQwv2BDolmIqp9cNz65Iu7OCEQrziuDoWz6lT6Q7hTAx/d6TN9yG+EK9UmkWRkf7R1k4A8CAKqY++38kYODIYCnoofDZox4wU917LLE8cuCDjvcf+xTSitsmANPiJJpi3MVgDCAxC7e0YTlu/4eaZA8nhHwtWlRJFsnCt8cu9Vm+/69cNMiKNzyOgTGYuBxi4uaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AB5ADaAAAYgW6w9iKAIatDogONUaVH9+aoAGibzKJfo=;
 b=ebWsvRij5MFva234H8LjS3uY+2dmfQnhkDRpLMzGzWJVDZ6dTtAB7MyE8ONTXaHz2HBfp/1N+t5ew4FB3gCBNmv3cJBXsNwaYCp+QdWWKfdZowjpnhAFNkcvxdEYvwNW0i1BRonUrUV0etly2aj1UA+3E6rvNjSmZesaSemTzxjD4l0rU02D3ZAJmi2vt4O7C+tfIgDtPdEH9XYhOiZ9ZwL7Ifw/SvcQt38sG5UWZWtqMaZXbrqk3z6Cll+f/3jaoIZSt5n89KBmxX0aCWNenKW126CpI8jmFDH4sQwp++ZIZE0MdBrvov9dzJKDeHgrbhgklqwvse64YzaOG1iP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Fri, 27 Jun
 2025 15:23:12 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 15:23:12 +0000
Message-ID: <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
Date: Fri, 27 Jun 2025 18:23:05 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, Tony Luck <tony.luck@intel.com>
CC: <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, H Peter Anvin
	<hpa@zytor.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-2-adrian.hunter@intel.com>
 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
 <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR03CA0028.eurprd03.prod.outlook.com
 (2603:10a6:10:be::41) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|DM4PR11MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: a3056804-1f5e-446b-8f53-08ddb58e872a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3V6WWt6WWYxa2c5OENnVXREZS9OazVnckg2MlQ4MHdKenFCNGRMVlBuUEJK?=
 =?utf-8?B?UzN1dGJySjliL2xaUGVxUU5sYUdMSmlNWjdTSGtTQnkySU9yR2x3TDRKeWIw?=
 =?utf-8?B?cnpwb2xyS000UDkxYlczclF3ZlhlVmloQk1EZVlsUllua3l6LzhjRkFodVVE?=
 =?utf-8?B?V1MydHZQazFDWGtvMGlvbFE3ZnhFWHhNdzRnRHFWK21PaDJlL3M0a0N5REp0?=
 =?utf-8?B?SmR1TzUxSXJjNDlaZk54TTVjallTcGloTXBBM2F3clJxWFNaQy92b0hnUW5W?=
 =?utf-8?B?MmtJTHZUTkI4eDVJTm45SCtGL3BnVVVsZzA3UDBqNVR0YWt0R3NQYUF1V2ha?=
 =?utf-8?B?c0JUeGtHVlFsYStKdUt3NXRzSU9UWnhUN0RHZW1Lb0ZOWitoU282czZMNkV5?=
 =?utf-8?B?UDREUEtPcG1qQ3ZoY3Y3OUtkODlTVFhINFVEL3Z6UDAwL25WamVzWjEyNzRS?=
 =?utf-8?B?VnkzdUxid29KT0E3aUtLd1RmSEdjWkNBeWVOeFlidW5PNWRONjlVMlk3OHFt?=
 =?utf-8?B?OVhoV2NFbUNxRnJzbjVRTHZxb3U5dnJTeFF3ZVBIMnAzaWJCTC9PajlSbWFV?=
 =?utf-8?B?V250UEpWS0t2L1czeDM4ZXRYc2tqdTcxWFBYc3lOaDZGTkozc3hCblJDa3F2?=
 =?utf-8?B?UUVCbE5lT1lBSTk2TGsvWCszYjZKSkRGTStjckFwY3UwOFdGVTRlZzRoRmxa?=
 =?utf-8?B?bit1cVc5NldpY1ZCSi84SEI4b2tFMytKZHdScWxaSnBaSGExczBNSmkwUUdF?=
 =?utf-8?B?d1VYWDZPcDdVanliRXBjSmVYMVJuZ1JUY3B0NUZCTTVZMmI2UWtFRW9ZUkRw?=
 =?utf-8?B?bC8vbDNVVC9ob1pESkhLZGJCQTlUL093QUhnMFRWY0Z1ZVQ1Y01ET2lrTW41?=
 =?utf-8?B?Qk1uVVM1WitDdjZpWVIxL1NPTWR6clEyeGxSRTFoNmZlaXgwMzZLczV3ZXds?=
 =?utf-8?B?UmthTEkzcTQwRnFIcGJ5QTcxVWhwTStLQzRWdW9qeTF3L3l6VlhOSm5vNjMv?=
 =?utf-8?B?bGsrbUxhS2lRREJrbUtqMnI3MThsU1I4aTE3Umw4QXpvTDFoZVlGbGdoVC8r?=
 =?utf-8?B?UktHaDVDV3NOQU1iYm96MTVSYUpMbEpLWFA5dlNGVXRiaml1MHc3Rnh5cC8v?=
 =?utf-8?B?dlEyOGVFZmhTb2Fhd0N0UW5jNkUvdWptVjk1cytVNUs3WVQ4UzJiaUl1RmVR?=
 =?utf-8?B?cG1kanZMclp6SFJmZkF4b3hWaVlBWldRWU1YWjNKYXdpYmgvRDYyTk51NXFJ?=
 =?utf-8?B?b3B6YzVnODBBWXlqdC9tc0JUbnlyZUhBdW1OMXN4OVBrY0FwMDROTkl3YXBW?=
 =?utf-8?B?bFd5M0RobkFGVWtGWTZvazVrZkJPSlVHYU0zV1E4YUx2MUF5aFBzQkthN3Zz?=
 =?utf-8?B?bzZjckVxNVdjV0MyMWFQN3lJWlo4aVNwbUVNWjZxU0pjVERncXE0d3JTb3FZ?=
 =?utf-8?B?SlVnZHV5SG53bDhpUkIwRG44a3Q4UDUxcW9pSDkvdlVsVUdLOENYWXlzRjc3?=
 =?utf-8?B?Zjl0OVZleDlmTkxUdzBqZGcyeGdZN05WWTdGNTE5U3JyMVllMzhmSnlxS1lu?=
 =?utf-8?B?T1BVZ2l5WTlGOE8yalBOeTJSeWpjK0ZES0pYYmFjYXUreDFxNlBWTGJsNita?=
 =?utf-8?B?NGFTR0JMNFpMT3BFYmhYNGp3elUyUG41UkhJblhOMU04YWQ3SkZmeTZYOU5I?=
 =?utf-8?B?bXdZNnQyR2JER3RxYWVHSUZwdzhpWk9yRUJGd3JCWXRET3VBTHlRVmtpamRt?=
 =?utf-8?B?Snh6UUVvbFlDSUpRSXFPZjhDaEVZeVRIU1lFMU4zcytybXc0amZwQ2c4WVZM?=
 =?utf-8?B?bzVPOGFNMCs3L2ZIVkZwbU1pMUh3VHZ5QzZKWVdCTzFOMmNEempJY29ua3E3?=
 =?utf-8?B?bytjSUU0Sjl4RW1OcERYNFZ1ODRSSzdIbXJCTW9jc09LQ1o2M0ovUHdPMFg2?=
 =?utf-8?Q?W/TmCCmOP/8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEs2R1VkOWpKRGdPeGhvYlA0aEZ5OGRtaGJLK09mUCt1YjFYbnFtWUFDcWxI?=
 =?utf-8?B?RkxiTXJoSzNEMmQ3azRPMzdQcEVIUUpxMnJvT1RJNVpNWmUrUlZ6aGVsNEdl?=
 =?utf-8?B?azNma3pISXh6T3lndDJ3R29NQm9nbndKZFVmVGdSQ3FZU0VqRllNaEkwMWhs?=
 =?utf-8?B?c3pKM0Y5MVZycDlFYXdEaG9TM0VMbTI4a0pVcE4xSk1ZUHhLVDU0anFFaW1v?=
 =?utf-8?B?bi9HQ2lhT1ZBTWVtWHVCWVNzZDRlaTNtQnd1OWZyWUJMWFVLS3VCTmowcllC?=
 =?utf-8?B?WnVrQ3JKY3VuY3h0L3BROXJLeFVlTS9zYUxxaG1GUTg3RTNiaE9nTWppSDdz?=
 =?utf-8?B?TjJwYnl1a1doSXhZMEp6S1dWMk14VlNRS3p2eVRMNEw1WnhCU1JXQkVsME9z?=
 =?utf-8?B?RDg0K0NCSFA3MEFUS3RaRmdTMUdBMUFPV0NTTXo2ZTV6RWc2MGY3eWlFKy84?=
 =?utf-8?B?STFuQ2d1U3ZwYTkwQlFJUVRUY21PSDRNbHByeC9qYjFrSTVhdkNYdmRHbzRa?=
 =?utf-8?B?WUdNRGxmaHpnREl3aDFYZGIzS3ltY3VDYWtCbkN1dzJxZXNtQldBVUxlS1R0?=
 =?utf-8?B?WklaVUtFUUFRME9LYlZjRk43c1BES1VBUm16THJKN3Z6WjIxSlh1cUU3NURO?=
 =?utf-8?B?OG1VMERyeTV0WVFLeTMzbTJ5T2ZLRWttTWVOWCtuNStRR2lQbW9UWDh4ZHVD?=
 =?utf-8?B?WGYvK0h0SjByeWxPVjVLOGVtdGZJZVlIWVFXcmdTNTV6cW5rbEIra1RpN3dk?=
 =?utf-8?B?TEs4QmtpeGEvaDZYeFVrZUxIajg5c0FrQzIrOTdYTEpiT0R3Wldkb2tUazlW?=
 =?utf-8?B?UjY2RG5FOVFVMnlKNWZaeHF4a2o3VU51S3J1S0oySkRFNzlLVTlQYzFjYWNP?=
 =?utf-8?B?T1ZKQmJleityeUtGdzVrK0YvZlg5VG9KTXFtNnRMY3FMblFNYThadEdZUkx1?=
 =?utf-8?B?Wlp4STdFeE1ZQTZXUFpFeTZQNG1JT1VhVWhBRnhyNUtBcnpRM3dBWDM0OUlN?=
 =?utf-8?B?RkNRQ09DaTFZWW5ZeERLa1lvZENtOFZwOWtiaEl1VEtWaHZhOVJGYTg2cUps?=
 =?utf-8?B?NVlYVVp3WnlJOThHMkJMQnhFdldLYU1DNHVZcFo1SVg2WE1jTHRFdDVDSm44?=
 =?utf-8?B?SUFpSW5GYWhST1VHWHUxWFFtT1hYMkFjb0g4ZHR6bTB2Q0J2MUJOdFBFaTRK?=
 =?utf-8?B?NEpnbm9SU0JScmVjVDRCUk9qajZLVlhLUXhZalRnQ2hTQ2Z4YXRLbnJzdWhj?=
 =?utf-8?B?WWR2QlNDa1FrOVBNUG9kVlU4THdvbnpmdnF4R1pwSjB1cVB5TjRiTVZJMDFW?=
 =?utf-8?B?VUI2YzkwSmk5dmFFRG83Rk9MU0lUNlFjMDBZVkRjRjczei8zZWpsT3Joeldu?=
 =?utf-8?B?ZWlyaVVBNVZjSzF5eENTem1zNlN0VlNDWTczS3FaSzBXNWdYbzdORUFGd2JP?=
 =?utf-8?B?cDZ6eVlEbS95cDZ4cEd2K2NPT0o5aWVFa1BvMkdsVGRhL3FDVFlxY0hPRjlG?=
 =?utf-8?B?RWZkYW51b3B1L2gxc0hKNHVIZmgwaGE1Z3JCaUF0MWEwT1U5NFJ4VFUwQ3JH?=
 =?utf-8?B?NHRSbXZ1ZFh5SHpmV2hKK2o4WW9xblZNVHU0UDFVSmZuRjkyVzNYMUFnMFZK?=
 =?utf-8?B?cTgvR3N4WFlVRWdHZjRqVjRZcXhHTlBQU2JQTGNkQW1lb3E2ZDVZbnJSbjA2?=
 =?utf-8?B?UGVxYUlSMGFCUnJINEJqdG1PdjR2ZzBtUXN0SkxVck9PRURCbm55UU83UzNt?=
 =?utf-8?B?QkptbFdPVm5mck1FOTNyYjhqemMzUFhSQ1d1cFlEODI2d1NLRndaalpZZHcx?=
 =?utf-8?B?bXFybjNRSm5oNklxelFIeVJRZE1rVGlVT1FNTUpIdklqL0RiNk1HbWRrWEN5?=
 =?utf-8?B?M25jQVZrSVdUUHljOTNLMWN6ck1yZjZ6dndSOVVjRWs2dUI3OXZCcjRlTmlR?=
 =?utf-8?B?YlQ5b3ZrS0ZOUU1CYnRVQmQ5QmpuV3V1YmtRT0pLejNEM2g1aXNtZVVyejFr?=
 =?utf-8?B?VnZLRE5uQzJxOVpvYUQ0aWI4YmdBVFVRVmE4cGhQZjZGcTcrUEhMbEsyRWEz?=
 =?utf-8?B?cDdpMGo3bXdlZmwwUExDSEdmaGcweENSQkhwdDN4QlZFemU3RmxkNHU1SXZj?=
 =?utf-8?B?MEp0T3BDNFlQdC9sSDJxN3hOa0cvdXMyUWVyakk1QWY3c2NMWmprRjljb2lB?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3056804-1f5e-446b-8f53-08ddb58e872a
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 15:23:11.9803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esSxPa9k9enBnBfeJ21wOfbwuDj3LACJGQsImhxCuILvrkgrma8HTEpr7Ght0XWk10kGHITsG6R+VJsW4/7tYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349
X-OriginatorOrg: intel.com

On 19/06/2025 14:57, Adrian Hunter wrote:
> On 18/06/2025 17:55, Dave Hansen wrote:
>> On 6/18/25 05:08, Adrian Hunter wrote:
>>> --- a/arch/x86/kernel/cpu/mce/core.c
>>> +++ b/arch/x86/kernel/cpu/mce/core.c
>>> @@ -1665,7 +1665,8 @@ noinstr void do_machine_check(struct pt_regs *regs)
>>>  		 * be added to free list when the guest is terminated.
>>>  		 */
>>>  		if (mce_usable_address(m)) {
>>> -			struct page *p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
>>> +			unsigned long pfn = (m->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
>>> +			struct page *p = pfn_to_online_page(pfn);
>>
>> If ->addr isn't really an address that software can do much with,
>> shouldn't we mask MCI_ADDR_PHYSADDR off up front, like in mce_read_aux()?
> 
> Would that mean no one would know if the mce addr had KeyID bits or not?

Current design, to keep the bits in mce addr, is from Tony's patch:

	x86/mce: Mask out non-address bits from machine check bank
	https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8a01ec97dc066009dd89e43bfcf55644f2dd6d19

Assuming that is not altered, a tidy-up is still possible like:

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6c77c03139f7..b469b7a7ecfa 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -386,4 +386,14 @@ static inline void mce_amd_feature_init(struct cpuinfo_x86 *c)		{ }
 
 unsigned long copy_mc_fragile_handle_tail(char *to, char *from, unsigned len);
 
+static inline unsigned long mce_addr_to_phys(u64 mce_addr)
+{
+	return mce_addr & MCI_ADDR_PHYSADDR;
+}
+
+static inline unsigned long mce_addr_to_pfn(u64 mce_addr)
+{
+	return mce_addr_to_phys(mce_addr) >> PAGE_SHIFT;
+}
+
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 76c4634c6a5f..e9e8c377790f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -642,7 +642,7 @@ static int uc_decode_notifier(struct notifier_block *nb, unsigned long val,
 	    mce->severity != MCE_DEFERRED_SEVERITY)
 		return NOTIFY_DONE;
 
-	pfn = (mce->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = mce_addr_to_pfn(mce->addr);
 	if (!memory_failure(pfn, 0)) {
 		set_mce_nospec(pfn);
 		mce->kflags |= MCE_HANDLED_UC;
@@ -1412,7 +1412,7 @@ static void kill_me_maybe(struct callback_head *cb)
 	if (!p->mce_ripv)
 		flags |= MF_MUST_KILL;
 
-	pfn = (p->mce_addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = mce_addr_to_pfn(p->mce_addr);
 	ret = memory_failure(pfn, flags);
 	if (!ret) {
 		set_mce_nospec(pfn);
@@ -1441,7 +1441,7 @@ static void kill_me_never(struct callback_head *cb)
 
 	p->mce_count = 0;
 	pr_err("Kernel accessed poison in user space at %llx\n", p->mce_addr);
-	pfn = (p->mce_addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+	pfn = mce_addr_to_pfn(p->mce_addr);
 	if (!memory_failure(pfn, 0))
 		set_mce_nospec(pfn);
 }
@@ -1665,7 +1665,7 @@ noinstr void do_machine_check(struct pt_regs *regs)
 		 * be added to free list when the guest is terminated.
 		 */
 		if (mce_usable_address(m)) {
-			unsigned long pfn = (m->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
+			unsigned long pfn = mce_addr_to_pfn(m->addr);
 			struct page *p = pfn_to_online_page(pfn);
 
 			if (p)
diff --git a/drivers/cxl/core/mce.c b/drivers/cxl/core/mce.c
index ff8d078c6ca1..f3c4d6a5f159 100644
--- a/drivers/cxl/core/mce.c
+++ b/drivers/cxl/core/mce.c
@@ -24,7 +24,7 @@ static int cxl_handle_mce(struct notifier_block *nb, unsigned long val,
 	if (!endpoint)
 		return NOTIFY_DONE;
 
-	spa = mce->addr & MCI_ADDR_PHYSADDR;
+	spa = mce_addr_to_phys(mce->addr);
 
 	pfn = spa >> PAGE_SHIFT;
 	if (!pfn_valid(pfn))
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index c9ade45c1a99..83fcec743ea7 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -732,7 +732,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 
 	memset(&res, 0, sizeof(res));
 	res.mce  = mce;
-	res.addr = mce->addr & MCI_ADDR_PHYSADDR;
+	res.addr = mce_addr_to_phys(mce->addr);
 	if (!pfn_to_online_page(res.addr >> PAGE_SHIFT) && !arch_is_platform_page(res.addr)) {
 		pr_err("Invalid address 0x%llx in IA32_MC%d_ADDR\n", mce->addr, mce->bank);
 		return NOTIFY_DONE;


