Return-Path: <kvm+bounces-28738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 619A299C7C3
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:57:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8111C231B7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 10:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF9819E967;
	Mon, 14 Oct 2024 10:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DW8lF+PS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F30B19ABDE;
	Mon, 14 Oct 2024 10:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903290; cv=fail; b=S1nH1arBGYDszc66MZbJS37ibqf1EntFqWOj++FEnfoDGqGeGWU9UIMEfsjWuoPCvWcx9FFK0T7u1NvhIe/RHz5SMx040ghmzvkG+sjEiVaJESbabOZYWi0fYYztUz+axy+AVppOTTtLWkmThwM7OzXvg/vPJSfQIqTF37a0opU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903290; c=relaxed/simple;
	bh=SIZEtJeFKdM+HUqHjOAgqlKmS10buzFTJBeWBCQRpdc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jXChalfj31dgVn8w0aV8r8L2ST0eAvQdR7g2nUAIDifJAq2DGfQO0QxzJAv0L89l7j6BvOsogb/GRn6H8hoKo/qIyAYTBvXEEZk58rMRBlj4Bjo8U81ToHe2mdZxRdLxfwxH5q2o3YbYQR4XuPHnUQ4uNBKVd45u1pRzM6LHvWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DW8lF+PS; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728903289; x=1760439289;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SIZEtJeFKdM+HUqHjOAgqlKmS10buzFTJBeWBCQRpdc=;
  b=DW8lF+PS6n10f9zYfERuAcBxKKcjbR0h35Fq/2EmBMgGDr6q5g0N0YqX
   Lt+/e4Ozt6G2lyJz5f9F7U5lpJZNsH9//ZZgRTQjKAFNiijtd43eFjMZB
   ry0xX3IM97tRelXnyAl5G80feK9wReKVVFBdypo8/KCw3nuMTQQlcNzk1
   PkCY60zID7mGFH9XIiyAiZjw95ylN+UPQibpr8gw0a+FYLzi//MhS20eX
   Ycnln1AN6XAWa1HNupqa5MsxkFx/1yPuCI5qBo45FiGMVut0RTNJQNT/h
   QYBTiryhrC38ZUcXYDgXOj0Tm4ytBIUhrZ6HhACEnSfTD9o8l3aGsKSu0
   g==;
X-CSE-ConnectionGUID: 3vRjk7sNSpeTqRPBdVp8lA==
X-CSE-MsgGUID: ZxJRkAT4QLa2JNGB7p+K+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="39627128"
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="39627128"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 03:54:48 -0700
X-CSE-ConnectionGUID: oml5NSFBRpiL4K3ZitEsZQ==
X-CSE-MsgGUID: Ytl0Zz77QeKQp2KxZbHD9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,202,1725346800"; 
   d="scan'208";a="108331496"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 03:54:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 03:54:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 03:54:47 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 03:54:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SnuOzxLApXfbLRe/LuLSZZ75iiOM01GL3Z4tH9EH6VP5m5Q0/g+ppeBSWojh5WMD50/Ii5jIG0lqGWVk68du5mN0LpzhOhSiGZ7qHOw5qv5/VVrYfq21Y6zQPiVh9eLEOS1wZMYIsMVC1rqlpXbRPzbSovHiPWPI98pBXwCPgj+6NSJ0xCbNh9ytKGv/UC2VEPq6WfEVXZUw9hwCuMYP7pL7xFSnrEzphmd3itn4KtBCC+1E0IQ95sAEiwdkUPM0sPC3yP8W2aEDjRiT2prD7DY5cA7GCgsT3qjzLnudj7BNh1ZCJU6Lu4HssT/8WnEiUmbx8SLueVGbskj3lPQNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIZEtJeFKdM+HUqHjOAgqlKmS10buzFTJBeWBCQRpdc=;
 b=dgTNxCMX5R4v24c1MQWUaodP2wVwkF4wAmYXa6i88VYqmHNihlwx2w9Ss1BDpX51c+C27rq2agwT8KZaSP4WKgfiXAghCznvBL+1XLWaDUF379DTKKfJ66DSi1sZxG4Jkh9qKVks+P90NU1eU16uBcr87UPbFHVr+ezqHpp+9tkStTQOd7adfwDYOpHK2tCHMWSaQzzhSSl1CI3R2W3JVHwIr+7iCrM2XVbKG1K3Qj800OxadawIf3iitNJm5UjcgcG5MicCwoRbzmfQPPTEMuhoyN2oIk6tPkYfi6PBOAT5+tUyHWlmWqUvkYfM6GLPcvr1/amyQS9tzzjjTL3hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6284.namprd11.prod.outlook.com (2603:10b6:930:20::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.21; Mon, 14 Oct
 2024 10:54:43 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 10:54:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yao, Yuan"
	<yuan.yao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newE6CXMZDS50W3uorwZIcSBrJPnCEAgABS4ACAAA3ZgIABDTgAgAAL3ACAABXhgIAAC2gAgAAItoCAABS1AIAEHmMAgACTNQCAAQ19AIARYacAgBSwvICAAoX8gIAAzAUAgABIpICABZFCgA==
Date: Mon, 14 Oct 2024 10:54:43 +0000
Message-ID: <08533ab54cb482472176a057b8a10444ca32d10f.camel@intel.com>
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
	 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
	 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com>
	 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com> <ZwgP6nJ-MdDjKEiZ@google.com>
	 <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
In-Reply-To: <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6284:EE_
x-ms-office365-filtering-correlation-id: d36a209b-b7b7-4e11-9144-08dcec3e9c41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZkdIVmM3ZkhmK1B5dWtmTStkcDc5SGpuandwVUtDTndzRjZWYll4SVR4YS83?=
 =?utf-8?B?U3BLbWg2QkdVNlFXQW0rS2ZvYmVISFJTSUx5UmgwRTczME45c2pHcHFsYUU4?=
 =?utf-8?B?MkMrZUpOUTUzVXBYMERGU2ZrSDJOVmI5Mmd3U08xa3I5K21MRHRzVTh4Z3I1?=
 =?utf-8?B?dEdwcXNMT2dlenVnakdOUGdub3hDeHhhd1BOeWdHdkM2NVpkamd0V2RQZS9K?=
 =?utf-8?B?TVJ6TmN4Y0FCdmVFYitnUHRXMzdiUkJFUjMycVYyWFArQjR1elV2S2xXWW5N?=
 =?utf-8?B?VFpDZ1BtSlQvL1I4NHErODVSaGI0V1Z5dlhDK0NxOWxCL2lqUVhNcVFtQm8x?=
 =?utf-8?B?cTZIcTA5d1d2ZmZ3WjZUR2VhM2ZEd0VaWFBGK0N4NVIzWmZiWFgrWjRWQnVn?=
 =?utf-8?B?MTFBQTJtaWhGK2htUEUzSUNObTZ3azgwZXJDUVg2UjZ6SklidllKWWIzUUhS?=
 =?utf-8?B?ZzdzL2dCVG1UTHR6N3BsR2lUVm8yQUpNMXpDa0QwZUxYNEwvQnBCTm9CN0ph?=
 =?utf-8?B?Z3F0ekUzTzBaU05jMWVUMTNuNkZTWE13RWJQUTFFSVc2RHdXVzkvRExWVWtF?=
 =?utf-8?B?aElnbnZrdXNBNmJodG5zb2svVG9tbjdaQzgzejg3ZytPK2pPdG40UnFybG1u?=
 =?utf-8?B?L1VYNms4RXYvS3ZRT3EzWkovLzJRUXBTUlBTWXFEamJoNTBMVGhQckV4ZkdP?=
 =?utf-8?B?R29zSFluVWM2c0Y3YXRmaUppVGNrVGJqM2NhUE5vYnYxalBrWi9CZk1wYzIv?=
 =?utf-8?B?KzUyQWhZdVZkeWgrZlB2ei9hTklSZ01VTHdMbjhMNko2Slp2ZXovc05TRkhY?=
 =?utf-8?B?TVZBTDRDNk94MGV2NU9ZdEFxcG5XU3RVQXhSMVRHWE0rZEp5SlZpVGMzQml6?=
 =?utf-8?B?bUEwMnpvMTZQQURTSTZrRDhER3VWUDdVaCs3bDR2dEpZdm1LV2orQ2liaEFV?=
 =?utf-8?B?eFY0cUViMFYyQS8vQVdReCs1S29BSnFaU01uMUQwbnRVQ2VzbXdIWGxycFNS?=
 =?utf-8?B?Y1VuVlJwbDc2OWtQZ3lPNngvaE93N1ZhQmNHdVNaTzRyYW9YL2lnMWlyVk03?=
 =?utf-8?B?VHpTTFZxYlNPVmZZVFVLNDcvOU9MSFBLZVJyRmhmV0QveGpuVnVLM0RLSXIw?=
 =?utf-8?B?dlhCOEExZEVxWitVVmwyRkRUUEVlVlFDMnFIRzRVUVNMeitweUFvR1BkRG1k?=
 =?utf-8?B?Mk9oN0dYT0F1bWh6NU42OHg5WXVudFUwQTFOYTA3dW9ldjJYdUNJdzRqK3Ey?=
 =?utf-8?B?b1V6dmw2ckFpbXB1d05DUmNZMFh1dnJkU0pKS2pqaVR5d3FIVExhNERHaThq?=
 =?utf-8?B?Y3BGcXI2ZjV3VjlmdnFLak1EWnNMTDY5Wk1pd2NOVXFsSDlodXNOVm0vZ2Zu?=
 =?utf-8?B?R1VSSVkwQ0xJWFFtTXpYZzJsdm5pNnZnMkZNcnhETklRTVB3K2JIWm5aclNw?=
 =?utf-8?B?cE5EZWJLMzE3NVJSakZLcXhEUU5UOGlSNk9DK0ppM1BmNlhmMnNEVEZUMXF3?=
 =?utf-8?B?b0kwc0xRcXJNVE5ML0JyZUtyWWZodTNOTW9TL2FYTWk1Z2tqQXNVVlNQeWRk?=
 =?utf-8?B?aEJyMFlDMlp5YXVDRWZzd2hZSGcveTYrMk10SXdXRmdndFJzSFRGd1djblZU?=
 =?utf-8?B?cVYwQlZBRm1SU25pTXlXdW9Jc1U1RlpqWDFuWWM0YVVnaUxtQmlENGZCTnJx?=
 =?utf-8?B?Y3BSeU1WbHc2eE9WcGlqWjNHb09kLzdrSWhvZmtSUHlzRWdhdXRYY1dNVlpZ?=
 =?utf-8?B?dmlJQm1MR2ZvdWc5MmpXTlhSU2ZtejlYdzZOYU9kdTNIcmRYdENjUkM5V0ZY?=
 =?utf-8?B?T2NWYWlNVUZVSGg2NkhBZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M0FWUXBrVk1lOXV2TGx0NzFKZHBIekN2NXlWKzZzRjRKSjBGcXA0M3BXempt?=
 =?utf-8?B?aGZqVEo3K1dsUE1jUzA5bVYxdE5FTkllQ1o2dmErbUh3eDJkU3VPbEw0SG03?=
 =?utf-8?B?bGt3SkdXOUVWWWNGOVRkOGxoYm0zaW5DOXA3Q3ZlY3FaMUx4QnVjMTgvNVho?=
 =?utf-8?B?NlJOU3lhMVo0QlIxcUpzRGMvbkFCa3hXS2pwUi85QTlCOTJ1Z2JOWmN6NGtQ?=
 =?utf-8?B?NFcyM0FrRWlZV3hGTHZETmNKcHBNU2ZYRUJxclRTdUhwRU1wYXJkOUVSTk1C?=
 =?utf-8?B?bzJTMzd2MUh6azUxcTgrNVlMODg0a3QwR1BYQVQrVHJSdGVnem1EWTJ3dkh4?=
 =?utf-8?B?UVRsN3c4TWYrdVNvMzNUNEhLWkphVHVyaldMNVRrYXM3eGQ0MTRicFBOcUJL?=
 =?utf-8?B?QVp6ZjFoRlJuOEs3a0ZoejV4cU5tY2dKVjZBa0dZTzhNZXl0bnN6VHdIYmJG?=
 =?utf-8?B?WU5tK0w3TTR4RW9JWVZrbTJVczdYYWJSWmFlRlh6N2xSWW55QjdtOENNcEJY?=
 =?utf-8?B?am1Oa0ZjWk5BMmpPbzA0ZWNBQ3JYNHoxMUpVMFE0d3BKaEZTUFhSaDZZWTNv?=
 =?utf-8?B?eVdXdU5KdDJVYmJ0YVd4Qkh1dklsM3ppYjJVcFdVWHFGY21Fa0ZCSlhzdUkz?=
 =?utf-8?B?cGRJeTd1THhDdmJTYjlDTUtrWHVReGlzZmhkbEJMZjI4Sk80U3pwUko1OXZq?=
 =?utf-8?B?M0FFWElzSWVXNEZRVUp3WXdSSVRlQjBmNC9xbFg5ZXQ3ZUp3WEZmT1VwWHZN?=
 =?utf-8?B?RzVwUTNqVHNFemVOcnU0NXpxMFB5dWNBU1U3c3BjTzFaMmkyMGlUekRlNjU4?=
 =?utf-8?B?M1ZCWEdZZ1BHMGg1WVhMUVRXK3dxaUhmSXUxUEVDWjFFTnJpSW9ROEJjUzRG?=
 =?utf-8?B?dU1mV0pWYWVzWWo1WDJNcnhWRVZOUFRuUWluOGVQcSs1RFE1NzRWeWtuTHhn?=
 =?utf-8?B?dTZRNHg2SGRsTHNWeU9PV25xZ3BydnoyZloxeVl4WGE1Q08yaTYwTzlUbUNu?=
 =?utf-8?B?WlpENU1DTXNvNXVVV09iNC9QMllNQ0hCaWVyZ1NKMlpKdFVleFUxQ0lOTGll?=
 =?utf-8?B?Mm95UmVvYUtBQzE1OUVmUTBZaWJTT09uRzVieXU0V3ora0pabmRqQktuQ1Y2?=
 =?utf-8?B?QzE0cXhCVmcrclhxektPdWRGc0U2OCtyZW9xdWtJbkNKNG5Qdk9UQWk1MG5m?=
 =?utf-8?B?TFRTa1MyTjZTbm1ta1FxQWxweUVqRGJaN2FxV1hmZXZRZ2hnTVVnaWtHMFNI?=
 =?utf-8?B?N0FScVJkYmpzdzNTWDIyOHpqVFcwQWxBMEpPMk9ZZ0MrWXNlZHpqT2ZvNEp0?=
 =?utf-8?B?VzF1Zk9rY2dzeEVhMXkwTG1wZWxJSlA5T2FkcVR1NTVkODJWalBxeGxuZXlL?=
 =?utf-8?B?N05URmh1TUJjcmpBKzVtU3l0Z1RsZG1mbmJJTFdOMG10elN4dEFHRmh1UW00?=
 =?utf-8?B?NmZhd3NvcExzdEozWjJ6QmRqUU1Lck9xRzVBWXRPMEF4MGIxY0lZVDdUSUFy?=
 =?utf-8?B?WHIwLzA0MGswcy9EcFVmM3VzblpLb2Qwck9MaXJhSnoxY0NzbEVWSGxrcnFi?=
 =?utf-8?B?c0htRXpxRUptMS83MjF2Z0c3ck1UaS90d3RwYnhXNTlFM2JKTmJKbWlRekxR?=
 =?utf-8?B?MlJtdll2TVVqVVlpWnhPRUx2SG1XYUpZRXJYeXpIK3J6NDZYL3poY3Z1cmww?=
 =?utf-8?B?My9XVFFqNVc2czNoUU1vUzFqdFk0TUZlaTRLK3FlaWxxRlkrcGc3eDRaWVlB?=
 =?utf-8?B?TExYRHhqTFBPSkl1MERKRXdFckdQeC9FcVlHN1ZMb0duaUx6Ry9aSEdDZHY4?=
 =?utf-8?B?OXpKaXVpY2h4U0NYM2t2bTJObzFNT3lnSjFHZHdGRWpxaHlLZ1F2am5BeGhh?=
 =?utf-8?B?SkRUckxGZnBrSTUxYWd0VjZEaldPTVI1Y1d5ajBwVjJDVVRhNy83WithMDZw?=
 =?utf-8?B?aTYxOUlZNkZrNUVGS2dabUNSMzNham5OVWRqR0R0TWpkL1JsOGNGeFA4TTVw?=
 =?utf-8?B?cFFiMUFzeTFpT2Rieko4UjRWLytCcnJsTFBkaTRHQk5zb2hLeUVpZUNCSjBG?=
 =?utf-8?B?dW5IbWZOSm5tL1MyT3pVWlZGeG11WTdQeGdkQVZEa0JzODNPdGo2V1hkTG9T?=
 =?utf-8?Q?ddhhDEDurbxHz5jkG7iODXpXX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DE3FB5363846A4AB036252B94EE9141@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36a209b-b7b7-4e11-9144-08dcec3e9c41
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 10:54:43.2882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +khhTLNHZ+RmsD48FXjfRFVpgnvghVNQPGP6BAMjN3IcINDqZ/VWpqBkpGMBzhjUe7Wiwq3yjENnMCm0GuAF2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6284
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTEwIGF0IDIxOjUzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI0LTEwLTEwIGF0IDEwOjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVy
c29uIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiAxc3Q6ICJmYXVsdC0+aXNfcHJpdmF0ZSAhPSBrdm1f
bWVtX2lzX3ByaXZhdGUoa3ZtLCBmYXVsdC0+Z2ZuKSIgaXMgZm91bmQuDQo+ID4gPiAybmQtNnRo
OiB0cnlfY21weGNoZzY0KCkgZmFpbHMgb24gZWFjaCBsZXZlbCBTUFRFcyAoNSBsZXZlbHMgaW4g
dG90YWwpDQo+IA0KPiBJc24ndCB0aGVyZSBhIG1vcmUgZ2VuZXJhbCBzY2VuYXJpbzoNCj4gDQo+
IHZjcHUwICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmNwdTENCj4gMS4gRnJlZXplcyBQ
VEUNCj4gMi4gRXh0ZXJuYWwgb3AgdG8gZG8gdGhlIFNFQU1DQUxMDQo+IDMuICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgRmF1bHRzIHNhbWUgUFRFLCBoaXRzIGZyb3plbiBQVEUNCj4g
NC4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBSZXRyaWVzIE4gdGltZXMsIHRyaWdn
ZXJzIHplcm8tc3RlcA0KPiA1LiBGaW5hbGx5IGZpbmlzaGVzIGV4dGVybmFsIG9wDQo+IA0KPiBB
bSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KDQpJIG11c3QgYmUgbWlzc2luZyBzb21ldGhpbmcuICBJ
IHRob3VnaHQgS1ZNIGlzIGdvaW5nIHRvIHJldHJ5IGludGVybmFsbHkgZm9yDQpzdGVwIDQgKHJl
dHJpZXMgTiB0aW1lcykgYmVjYXVzZSBpdCBzZWVzIHRoZSBmcm96ZW4gUFRFLCBidXQgd2lsbCBu
ZXZlciBnbyBiYWNrDQp0byBndWVzdCBhZnRlciB0aGUgZmF1bHQgaXMgcmVzb2x2ZWQ/ICBIb3cg
Y2FuIHN0ZXAgNCB0cmlnZ2VycyB6ZXJvLXN0ZXA/DQo=

