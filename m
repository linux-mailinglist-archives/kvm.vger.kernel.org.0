Return-Path: <kvm+bounces-17801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E108CA47C
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 00:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D2CB1F2263A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 22:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04964AEF0;
	Mon, 20 May 2024 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbE9pO8z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46205374D4;
	Mon, 20 May 2024 22:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716244509; cv=fail; b=J0MEKqRPU3YWd6bSfWkhrgQ6a4H+IE7UlxSspeyNQAnh+zxu4KzWXaGj3NdDOhn4vboUUfo0j2iTpG76H3486ArMl3l4eW+pgqWhcXAkrElCpoM4jUs8ll84lCzvmJj0ayluRjbKAlCKl39Gs5cNA+hxVRakYM6dTibSdvaMog4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716244509; c=relaxed/simple;
	bh=Wf4MKbiDo6FrPksUXLAWu5PBxkXNP9b7SEzl8Hovkg8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IS5Y5w2oA1O+24gTsuMFwUBlzZSLHH5rspiRnSqcLNqqVITQfiraNhX0uHXXLNCk9CIep4uvnjFFc8d61w5IqoFHzMRXn8FzC3ro0O0IiQDmSeLTFm5QcvMVB3rPIWgDVZY4LuSQGr95lbPY6RiEvAgkgtOFUhxkrX+czxKywXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbE9pO8z; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716244508; x=1747780508;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wf4MKbiDo6FrPksUXLAWu5PBxkXNP9b7SEzl8Hovkg8=;
  b=VbE9pO8zSSe/JRAa/XSmmFA6lAOw7CUCBtUugbPxhy7Q9XzbpUz1Zgaa
   ORhl/tPJK9M7yp2eXyFrV26zhcW5l599Wry4AmeIXvYPNYVp9GS82VaAY
   Y3iJeFcht0ncKsku3L9CiL54KnrwcVCZOVj4Rpe+/ORfCANrh2V81R+B/
   0DRj64ogTEErOZeO7i5eSe0CoBrur056WoB3G1NTby1R72Wo4ffCdaLtO
   tmj39Mss6Y2nppAObHLQ4vJlU4WPo7mUmIRetLlHN0mB8qB3rPHnlz6PX
   yDfY8X2AcaNHFa4afpmyQtoMk+t9p4Vm/lsuYNACiC6REu2J8rffYikAg
   Q==;
X-CSE-ConnectionGUID: RoZeydgmQ+SKrZEv5K9uLQ==
X-CSE-MsgGUID: KTX7iVPiR3+DomQnTPIrWA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="16191431"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="16191431"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 15:35:07 -0700
X-CSE-ConnectionGUID: DRHREVCkQy+Md1ixwMVK8w==
X-CSE-MsgGUID: dpEtkq7iQfKGLg5kuJtGrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="63528526"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 15:35:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 15:35:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 15:35:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 15:35:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 15:35:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wud7zp8QOOVl+dotRWkiQPmfSLt4sCH+vs/8V5VdNhm9rtOWRmX6xieRiN925XFDKDdKwXUgGtRb1EgCnc6leG1B031tK462qQ/BHpQt+L1qrVRo8Gyi/SySNyIWaiuB3dTv8R6S0qPQgvKClvqGUQNthhLkqobBjFDb1U5UK5ZuIZcs+HfGRrkF+pv6R4HSHYeLdFEBG1SAC3Utucye/BAMiQYyVxdX5O+RBhriP8FOTxYZ1+g07M0o9pJrRyqqviNVBag5NBQReb/beV91+wBZVa7flmnd88ZAtSysC2LUCEDqtc2l51luv/nKUBZ1TVIcu71pSm9vyedn61f87g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gr9hri/MTtAQ1QjbJH71VP+YkniCWdvnDFQo8GCjQ8=;
 b=Z6HjjvzLu2kKTCgFBQ6pelzokWcD+Z64D+W7u/7Q6Rvmd00i/2Ft4ifBuIxwqHaSd9LEoGM58hiiycDHjNdof0VdZKsoFVrdN63xyM8l7BVBFo6tvDC8p19590WMn7sDujjyOYyacLFhjwi0xoqJkM1ssmBSS4WXfhHICJP0v35nhuqbY6BXr78C3BCdO+1tic+Hel7UdYmmtrTtrltOecMT8h/Rhxn7JYB0YBqUf9ypspIgrwpBOD2TNclfpzGmBkU/fNf/ceoLwX5g8Cq98ZKGaui+myucIbz1cedIbzdgKiPZWS1PQqHnNxzo/9ImhVSJescSN4oH+WKzD9s24A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 22:35:03 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 22:35:03 +0000
Message-ID: <5e8119c0-31f5-4aa9-a496-4ae10bd745a3@intel.com>
Date: Tue, 21 May 2024 10:34:54 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"seanjc@google.com" <seanjc@google.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
 <20240517081440.GM168153@ls.amr.corp.intel.com>
 <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
 <0d48522f37d75d63f09d2a5091e3fa91913531ee.camel@intel.com>
 <791ab3de8170d90909f3e053bf91485784d36c61.camel@intel.com>
 <20240520185817.GA22775@ls.amr.corp.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240520185817.GA22775@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL1PR11MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dfa1db9-9b32-4366-a90a-08dc791d1712
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ODFidHh2aUNJcit5MDcvaHJHWUk5aUZYRklkYmVheUI4VFB6NjB6biswZnNx?=
 =?utf-8?B?N3dORUY1d1NETVVSYVIvaU1LQW56cG9CQWRJSUtTOC9xa3hJNVpIaWpXRzd2?=
 =?utf-8?B?K2dlWDhpVjUvOXgrTUw4Sy9POWd5ZDNGMU5VbzRpV0tFbkJMZ3F4YSsvcEh0?=
 =?utf-8?B?b05taXhXcGMxRGd3QXVXRmJUaktENm5iS0lBQTlyUEgvQUFMR0JPU0RqQjYr?=
 =?utf-8?B?Z3RzdEFLWFpCaVcxOEx6bjVyZlo3L1g1Ykt3dTQrYWZ2SFdYU0dQZlM4dTk5?=
 =?utf-8?B?RGx1MEFvUE95cmdWRTBhOWRPY0QvRmhtRXVnY1pRYzMrVHJ2QjdaRTB3RXgr?=
 =?utf-8?B?K3RYNndRd0NFN1VIUXVoVmQybzZLOXBWSTl3dTZCaWZ4MFdJTmtvR0V2dG5Y?=
 =?utf-8?B?TkVRUzNub1NsNWFieE9qem1nQTllUGMwT3hPTjFRd21XUkIvRXEzcXNaeUpG?=
 =?utf-8?B?SWpQL1RMYWIxdmJKRTB4Z3I1eWcvVjdtVDRUWkQ0SkZ5T0NjbzBvMFV0VnFO?=
 =?utf-8?B?eEs2OGduVXhtVFczZ0E4dWl4VDlQYzhRNENteGMzd3B2ci9tcjFJUUFGY2xl?=
 =?utf-8?B?Tk5HUU5rTlhFTDZGM3I2N0VuSW1td24rZGtudDVCdWFrWVNMQ0lhaWM5R1ht?=
 =?utf-8?B?SXQzbTREa0M5UTNIME9kMFk4M1U3V3BFYngwSXhiZWg5bDdXYnBnRnVnWFda?=
 =?utf-8?B?UklmV3YraXpLcEM1NmRJWFFyYkhZdzRGT3dJcjNuK3Iyb0wydjRsclUzZGQ1?=
 =?utf-8?B?RmhVdzJYMklNazJieDNiUVBaL0M1TkxGUFl5VndHcWlEYWEvYUNMSDlMRXZa?=
 =?utf-8?B?SXhiZitQSld2ajRvM1pkZDlBQkZONEdLUHlEbStXU3BsK0VZZjEvSlNBNUEz?=
 =?utf-8?B?Q2p0VlpkR29DYW9qQnhEQy8vczgzbCt3OGtLRnNGYzBLMFhlUWtQL05HK2t6?=
 =?utf-8?B?R0Nwck5rQ3RqT3cyeUdqQzJjN3Zwc29XK2lad2xFWExRK2dQM1ZlYTFqM1NG?=
 =?utf-8?B?Q3FFQ3VKSEc3S0pZSDlobkxtNDhFL2ZUYVk1dWVMOFZlU0VadFhZeUNaZDRP?=
 =?utf-8?B?Tk1zMDJ2MytiQmNLait3bngxV2pRejIwemo1ZGxjbS8ybjdjZTlYUjdyMlVx?=
 =?utf-8?B?Y3BVUlMxaXRuZGJSMGJDNUNvbzdYTS9GcU5PYWZUeEpmZUFaR1QxcElrM1Vy?=
 =?utf-8?B?VHQwalF3SGwvSmMwemRqdnZFMGlVam0wUFVocXQwbnd2M0VsSEN3NzQ0UlJl?=
 =?utf-8?B?a1VTLzVsRVl1N3JUQ3lWTU1ZV1hDTWttUEQyZjNGZC9PSVR5MytQeXRDYVRS?=
 =?utf-8?B?aW1abHJYZG5obmhNb1RSUGZsQmdkT0wxQmE5clQ2MVRwKytTQWx4UERYWGxt?=
 =?utf-8?B?Z2lONnpGVTk5NlA1aGxLYXJsTWwrTGR4WVNtRGlMQWRkYzJyMXN5VmJHUXlW?=
 =?utf-8?B?R0xraml0Tmxtci9pZVhxeXpzNnJiR1F3LzZOYk5yb0hkRkhpMFduNk5lNkpv?=
 =?utf-8?B?TThGbG1JZGNHZ2VKclltcEJSREJaMG92TUZBWUVVUElRdHdRa3FaZUVTWnkx?=
 =?utf-8?B?cGlaL0I4dlBRRVpMdWVCSStWVXNXOWtvTnEyWjhtbW1FTHVQLytDWGNxUnNK?=
 =?utf-8?B?L25rUlF3dGVndEdPcW13NHBNejFlaEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVhXU1hoSHlLa25Ebld2a2Z2RFlmTUk4Vi90QUhsb3ZXYXpoc0o2WDdYdnlW?=
 =?utf-8?B?Y3VLNGxPd1daMWNRYm9YaE9iMjlUMGFSWDZzTVdoVDRubzF2NlNEdWNQdmZ1?=
 =?utf-8?B?QzUyejlKZGZVQTVuK0cyMTYwelZGTmtlNWFPY1piREtoN01ZNmthbmN6b3BE?=
 =?utf-8?B?bGJ5M0Fmb1hRWDc1ZENWTkUvYnZ3b0pHREdid1Nnem4zd0ZyY2VVc3J6VXZJ?=
 =?utf-8?B?WVBTZ0pTcEQxUm4wRW50LzB6YUdiNlNwTDRZWXNNbmtFRi9ka01kcXBVTkVt?=
 =?utf-8?B?QXJVNG9zQjhndHRURmJyUzIvcTRDVEJFaU9kNnJyNUVDZGNMem1tcDhZVHkz?=
 =?utf-8?B?enJCdHVyQW5EamtkV053SkQvcm9HbTR0Uk5XNXBkMGZMUnM4KzhtV2VScDFy?=
 =?utf-8?B?TnRIOThocDhCTlBUWDhIeVhGd1hlN0RnQnNiUFFGeFhnVExWcElTODA2dDB6?=
 =?utf-8?B?eFI0NFNQYm5ZUXFYMGgzWmZvd0J4V09BSjRHSEJLNVFkVlAvUm05aHhPTk5t?=
 =?utf-8?B?VUwwbUNWTHZEc2dwWUhwelZmdjJOUWVTeVFTeGtQNzlFZkFyK0NGN08zQmhq?=
 =?utf-8?B?dnorQW1razdQTllUVk91L1A3Z2JteUhlQnY3Qm5Yb0ZKa3g4MjJ4SFNsb2ZE?=
 =?utf-8?B?Wkh2aHFtUSttTlBPR09hbTRreTE4YkN5ZEF1OVdVRkE3RjlLcjBvV1BSN3li?=
 =?utf-8?B?SE5Ga0NyRm1UWHU4VkJXcC9VVXNvTlN5SDBvZ3d3bTFaN1FsTHp4ZjN0dGFX?=
 =?utf-8?B?bFNweVRYMkdOYVh1U0pZelpZenNzWXB0NU5LODFhRzJJSWpVLzgrdzE0QnJr?=
 =?utf-8?B?ZEpyUmhnVUNUd0ZKeDM0enN0Y1FuVndGVFJ0N0g1YkhIUEVRcUcvZUFsOGIz?=
 =?utf-8?B?UjNpbEpGTG9taDJpS0JOTkQ0RFRvZGxoeU54bGx6RktNRXgrdG1EYkRzOVgr?=
 =?utf-8?B?RzFZWXg3eG1nbnc4UXBMM2xHYWhKN09yVERzZjVjQU5KdWlWbDcrOE42RXR3?=
 =?utf-8?B?R0J3NXErR1Z4T0YvTTNGbTJXUkpkM05PSlRlVDhqRjdObzlYYlppUFU5Y1VK?=
 =?utf-8?B?bEdBeXlpUW1OQ25Za2hFRXB0eWJGbmtCM0liRmc2TE8yenlnQjFPb3cyYkRI?=
 =?utf-8?B?L250czEwbWh1a2laVE15VGhNZzJIRG15NW01YWtWUTBla2piWnFxWklZcHd2?=
 =?utf-8?B?eHozaVFsaG5wREdoZ2kyaStmc3JsYjQwRVFXYXJ5NmNVSDJqTDl0NWQ3V0N1?=
 =?utf-8?B?aWFESjNlZ0lBYWh0Y2s3ZGRGOWc4WHUrdmREZnhCVnp3eWx4eVh2L29veUk2?=
 =?utf-8?B?d3RKT0Zjc3I2T1J5VFJrMGlEUkRqVnBNZWZObW1uUExqc1BuczVVcnVoZ2tE?=
 =?utf-8?B?cTkzQzFvZGVkdGJ5cFR0dXRrNXhRd09CRE43aStsQ1EwTmgybXltNm51eTBG?=
 =?utf-8?B?R1l1ZytGdXZ0cVlkb3BUc1IrU1lCQzFUUnJMRm45VVB4TXFTdkNKRTBnSnJo?=
 =?utf-8?B?dGkrdGtkRVpjOWxOd3QrK1hmYlUzZmJ4YkJ5R21WYklKRGtPOGtkelFVSkhC?=
 =?utf-8?B?NS92alFQUWF1anB0RFlpaDFQdGVoMTRLSktYcEJPNWtQRmMzN0FEQmlvR1Bi?=
 =?utf-8?B?WmxpcnZWQkV4WDN2T2o5bUtTZ1ZtaWxCWmtCVC9wOTNoVG04QllZa01YcUtw?=
 =?utf-8?B?NE5KRmUzK2UxaERjUlhYekdtbkU3Um5nZGwyeXBqNDNiejlJWGtUNEw2ekV0?=
 =?utf-8?B?ekZ0OVNvL2FRdEVpcU81Y2RxUTRvRzFoNFNMOS9LL2hFa1JDRjdEeWJZbDZs?=
 =?utf-8?B?Z2FmakdwZ20vY09wTm1mdTFvdldxV0pTQkthcDl4dlFXZDQwOS9Od3grYVFh?=
 =?utf-8?B?bjhvaXFTcVFEcjUwbjVCc3ExM3dBb1o4bmJzaWxPd0FaUHEyblJ6ZHZTdk5u?=
 =?utf-8?B?NVNaRzhtTktFNDdybjNYTkJRS20rRm0vV3l1VlhYYU5qaGtsN2V3VTdJMVpK?=
 =?utf-8?B?R0dUZjdpRWpqUi9oMHM1aVhkZDVVeFpEMmdnWXdRTW1xNm0yOG1YVlBWYzd1?=
 =?utf-8?B?VHhJUldKVUxsUjhaWjNRVnNKVmZaV2tMV3BubVFCZkJOQ3dBWnNrWjJmUkor?=
 =?utf-8?Q?czRv50WZnBrbSoCrd2slKsEX0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dfa1db9-9b32-4366-a90a-08dc791d1712
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 22:35:02.9786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mbDUXVY2N8zNJmR++/6nHd6jwWJz4XRw0zgg0I2Qnp/AzavQ7W0iHYAn2GjqguTrOwk6DerM/byG2TSEJwJEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
X-OriginatorOrg: intel.com



On 21/05/2024 6:58 am, Isaku Yamahata wrote:
> On Mon, May 20, 2024 at 10:38:58AM +0000,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
>> On Sat, 2024-05-18 at 15:41 +0000, Edgecombe, Rick P wrote:
>>> On Sat, 2024-05-18 at 05:42 +0000, Huang, Kai wrote:
>>>>
>>>> No.  I meant "using kvm_mmu_page.role.mirrored_pt to determine whether to
>>>> invoke kvm_x86_ops::xx_private_spt()" is not correct.
>>>
>>> I agree this looks wrong.
>>>
>>>>    Instead, we should
>>>> use fault->is_private to determine:
>>>>
>>>>          if (fault->is_private && kvm_x86_ops::xx_private_spt())
>>>>                  kvm_x86_ops::xx_private_spte();
>>>>          else
>>>>                  // normal TDP MMU operation
>>>>
>>>> The reason is this pattern works not just for TDX, but also for SNP (and
>>>> SW_PROTECTED_VM) if they ever need specific page table ops.
> 
> Do you want to split the concept from invoking hooks from mirrored PT
> and to allow invoking hooks even for shared PT (probably without
> mirrored PT)?  So far I tied the mirrored PT to invoking the hooks as
> those hooks are to reflect the changes on mirrored PT to private PT.
> 
> Is there any use case to allow hook for shared PT?

To be clear, my intention is to allow hook, if available, for "private 
GPA".  The point here is for "private GPA", but not "shared PT".

> 
> - SEV_SNP
>    Although I can't speak for SNP folks, I guess they don't need hooks.
>    I guess they want to stay away from directly modifying the TDP MMU
>    (to add TDP MMU hooks).  Instead, They added hooks to guest_memfd.
>    RMP (Reverse mapping table) doesn't have to be consistent with NPT.
> 
>    Anyway, I'll reply to
>    https://lore.kernel.org/lkml/20240501085210.2213060-1-michael.roth@amd.com/T/#m8ca554a6d4bad7fa94dedefcf5914df19c9b8051

For SNP _ONLY_ I completely understand.  The point is, TDX needs to 
modify anyway.  So if SNP can use hooks for TDX, and if in that case we 
can avoid guest_memfd hooks, then I think it's better?

But I can certainly be, and probably am, wrong, because that 
gmem_memfd() hooks have been there for long time.

>   
> TDX
>    I don't see immediate need to allow hooks for shared PT. >
> SW_PROTECTED (today)
>    It uses only shared PT and don't need hooks.
> 
> SW_PROTECTED (with mirrored pt with shared mask in future in theory)
>    This would be similar to TDX, we wouldn't need hooks for shared PT.
> 
> SW_PROTECTED (shared PT only without mirrored pt in future in theory)
>    I don't see necessity hooks for shared PT.
>    (Or I don't see value of this SW_PROTECTED case.)
> 

I don't think SW_PROTECTED VM will ever need to have any TDP MMU hook, 
because there's no hardware feature backing behind it.

My intention is for SNP.  Even if SNP doesn't need any TDP MMU hook 
today, I think invoking hook depending on "private GPA", but not 
"private page table" provides more flexibility.  And this also works for 
TDX, regardless whether SNP wants to implement any TDP MMU hook.

So conceptually speaking, I don't see any disadvantage of my proposal, 
regardless whether SNP chooses to use any TDP MMU hook or not.  On the 
other hand, if we choose to "invoke hooks depending on page table type", 
then this code will indeed be only for TDX.



