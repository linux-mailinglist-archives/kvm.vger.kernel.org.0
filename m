Return-Path: <kvm+bounces-48261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2857CACC041
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 08:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0A2016F478
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 06:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E8A204840;
	Tue,  3 Jun 2025 06:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AE+a5k32"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E064A1E
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 06:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748932455; cv=fail; b=Nykgsf9v4ZsyPOf2GPA+dWE7OjDLAbl4SlIyVGB7ifhfLACCBXpCIZCnQSdToKQ96knznBYkVRvqEezoak6FKVqe0Hpws6OrXnvVBTozwdp85LRVujGpU2IBzWEVRix2IiAlpcmJUvAjo9JuFmEpVpYr5ea2Oy5Pf3Qw7UpE3Dg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748932455; c=relaxed/simple;
	bh=VaOIT3xEB+gRbiHBgNPnXEjzIWnkbUdgYbUNRgNrXHw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aIDuwg3UR5i16v6yVPIs04uzdCDx6q/cluXn2ZtTopkuCKw/Czq+B8osqosTKa+tuwZCWnPz8AMv4ZQKgj3ivTPTzci3jlMlPJpMoQx3fenLaMC03Q3BJJUjLT2njCvg2RnZUV+hJwqotCAHvEN/rv/ehHnoG4QYI06InB8lccQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AE+a5k32; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748932453; x=1780468453;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VaOIT3xEB+gRbiHBgNPnXEjzIWnkbUdgYbUNRgNrXHw=;
  b=AE+a5k32LhrKxAR3Che2i6GDFfrctnBcfvNWIcE/7TDsksbmXLXTuVWS
   2SYdjaopXE+8snXXvhoxYbc1vclN5NFZQGgEkZ8k7FH0BubVyZouMpa5P
   9DWqWyMlO01vVJsMrqB9l/12HXE5tkTXmkQpUw8jmix2FcvjkyfZ/ak3y
   SDdJvw+LNkX9ncQP7XA+DKb+DE7yK6CicBAkKAt0deae5l4rLvvzzwLcg
   H/+kK7a7/lx36LsN7SB5mtgW2uL+bQvcXr6X29npTSt3yfv2XtOFOnQiB
   L1gf9iCQUNMlJyF8ThVGSTW4gWc9jivolJ+nHRbs97iWE0GeW/ub1oFOl
   A==;
X-CSE-ConnectionGUID: MgBUV0wFSCex+Mdh4JYfaw==
X-CSE-MsgGUID: fvMKb1kSQVWer5eRNVuFqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="38584642"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="38584642"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 23:34:11 -0700
X-CSE-ConnectionGUID: d3k+dtACRyihS/vEco3lSA==
X-CSE-MsgGUID: e+XsokjxSMGxArerasvA+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="148623310"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2025 23:34:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 2 Jun 2025 23:34:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 2 Jun 2025 23:34:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.53)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 2 Jun 2025 23:34:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWZMiwzBwTHUFymIey/4aRvYL0GLdKy6/rU/vjGvqbionX7KjNFlZsFbE9ggUbDKspLNw1B1WQ3VaZaaE7p4p9DhZWq70OZgPyTXlr01eTV56hQXc9D+dFwcaedo8vimVnxFUxxwoM9Uax23w4x2LoekrEaqCGDaqjYTIwOM1m6SUnaJZ4QwXSBe1NOxplmlWbo2kDhsoTHQX0OA0ronpoxI45IQQoend4ptbCTBivCTnuRHaMM09tcKvtUdIMJr908CcARjEZRMkj40+6iV0p0Wo8GWNldRLug5mHDxoQWhbucSmDVb8zpeh4e4/abGfqReoMjjCXDix94JEsFkjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaOfSh0pUW9F2CGdPeYByQKRV/s/jpVFRnMoCw61pRI=;
 b=m9Zz0xjpUZd28fwrSIarlasGjie83YDey0cvLS0DDuK/Qyn0QlwxFWk39aYZVcbsmHP8d5W00fbl9iWplo/HoVQQ1+SUOXGdqVoS3JWriJPG2VjkI/OjppwlmuSRp+v34vVz3qZaj5FI2CqFgstV13eENRJS807eABC0Qx13V5ONWShU00D2LE8/FWvosjLwz18vORWkwYEhP7YlxKd0qFQhXCLHVPFHP4ILWdh8bDwQ2eiayeQKNtYuKM5mll+G8YehNMipcaPgSyF90XQHVoQpjR+oScjptZPjHuJ2iOyE4ZRWyUmdF5DWXVWvZQe5ftKAKZCgEyUaodmIU0h6Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS0PR11MB8686.namprd11.prod.outlook.com (2603:10b6:8:1a9::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.29; Tue, 3 Jun 2025 06:33:28 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.018; Tue, 3 Jun 2025
 06:33:28 +0000
Message-ID: <c646012a-b993-4f37-ac31-d2447c7e9ab8@intel.com>
Date: Tue, 3 Jun 2025 14:33:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
 <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
 <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: JH0PR01CA0134.apcprd01.prod.exchangelabs.com
 (2603:1096:990:54::7) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS0PR11MB8686:EE_
X-MS-Office365-Filtering-Correlation-Id: ab626d1b-ff0c-4b18-5c89-08dda2688c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TzJBb3ZTU3llSjhKb256K0RxRXN4dktMNVJWcjRpTlZyYTB0NnFpbUFNenhZ?=
 =?utf-8?B?bFMrVm1zVUJoNkkwSjBjR1lIY2R4WEpmUWFaTXVSTVM1TUYya3NqekRZTzl6?=
 =?utf-8?B?RUgwWTdrRFlLQ3E0b3Z4V2pCU3VJekFxOHBuZHB2NUZkemtsMlIvSnBwZDkz?=
 =?utf-8?B?T2JDYXdyUVM1NmlvenQxZzAwSzd4eHJTTHhOaksvcGtWVExEOTAxTmVvTXBh?=
 =?utf-8?B?ZDE5VmYrYWl0NWs4TGQ5cmRzQ3pTNWE2WDhtQXYwUmdiKzRpRGhtWGlkNERO?=
 =?utf-8?B?U3RlUW9paHpYTE5qMEhxUzd0NiszZnl4MUxDck9zSFF5VGNldjc4MUM0WWxm?=
 =?utf-8?B?bUpHWlFNQVdkM1RrajhaOGFmZ25PV0k1Q0NJK0N1SWZ2MUlFdHdpaFg1MGZQ?=
 =?utf-8?B?Q0doa29TVEtMSFIyK3JUMmVzR2lheVZYZFRkeHRiN2JlMjVnQXJkc3IzSEls?=
 =?utf-8?B?dmJWeTlyYmd4N0JDZmVoQm5qeWdmOGJxckU4eVI0YitXVkFLcXM1TjI0VnlW?=
 =?utf-8?B?M3phNWFJQjBhQnlNRjJPa2t6dGVHV2xhS1RkejNRaTRYTitwYjRNRDExZFFj?=
 =?utf-8?B?M1BmQWpHdEZuQjlaajhqZTdYeDkxbDIyNE00cEN5Ymp2YmZmRWpKM2NVL0hU?=
 =?utf-8?B?Mnlud2xJV0IvUnN5TUFmOHlwb1lheHcyRkdSTnd1V2gxN0hYTnZITHhkSUp4?=
 =?utf-8?B?M3pJc05TcUhHSUZZc0FBYk40ODkzbmxyUlIrNG5TNjhnZzUzN21RVllBeXps?=
 =?utf-8?B?S2tnRlp6eVIzM2JlZjV2czE1bHR5bnRTTjlHUnBjY29pT3luYmRneW0xT1Rk?=
 =?utf-8?B?UGZYNHFoTkhESUwzSk9HZG4rQWhuNW9JT296aVAyTG0zNVJ3bXpDM2M4WTM1?=
 =?utf-8?B?MmhuUGhwSGNQVmZsS0UxOVJIcE00WFBad3FsMXNEcSt6OHVzc2MvaER5SFB1?=
 =?utf-8?B?SEtKeUJYV25IZnp3ajE0bnJoSWVsaGtjSXd2OGQrV0krbHlKTU0vbllUVHBp?=
 =?utf-8?B?Zjg2eEl2ZTFhN3ZDY0hBZlFRUmp1TTVqQVg2dGRicWtOaDFYSDhIWXBCRHlt?=
 =?utf-8?B?NURFMUVoanRsalJKUnVJNkVGc2M3OTNUTXRsdlkwV2dNSUZSY2RaWDhnZGhj?=
 =?utf-8?B?MjZESitVaWErNTJZREYxYjEybWZidEdkb2tQaEdvTTNQNXMzMlo4eXZ0dW5m?=
 =?utf-8?B?YTF4aUFYTHMwR3J5a243dkU3bE5kek5EWUwrL0EyN2pOdm9pb1BjanVtL0Ju?=
 =?utf-8?B?eFlIc1NJT3dtSlBsUFVxUVczNy9JV0RnMEJvNWRTd2pvSUl2L2pxTlNDUnNL?=
 =?utf-8?B?Q2MxY0lhRHRoMTJDYStBRGtjT3c1cThTcVpsMitpcXkvVTM1aHRGeDh5cGdl?=
 =?utf-8?B?eUUvYURqZUVrbWd2cGgxSmRDZmtJSFUrWnRKWm5xL2tSMml4aHB5TDNuM2xS?=
 =?utf-8?B?UDZkVkhqUzJIWVZnaDJEWjlCUUVlK0pyQlJyVWhpTzhIQTBKQW9NcmJxU1kr?=
 =?utf-8?B?b2NDTVhjZWNDMXlNRlhyU3RxMUd5R1ZMUjU4NG44RWYwKzlrbWxBUEJ4czR6?=
 =?utf-8?B?d2xid0p2Sk1jMWJWc2JXSlNTT3BDSFVwdVQvaHB5MmZFbEV1NlR0Wk9RYVJk?=
 =?utf-8?B?cnR5WHRrU1ZsNzkyY0hVdzZrcTNqQ1ExTVZrMElwZ1I1TW81aXJmcnZtUTY3?=
 =?utf-8?B?Q1kvdzluSldTSmw1ZW81ZzVnN202UFI4ZVFtQ1lVZUJFWURMVHpTd2ZnTjZ1?=
 =?utf-8?B?M2k1cXd4bm1ldngzWnlxaUwyM2tUUlR0V0ZBWWI2WTlSZUo1ZVRWUFpsV3Nz?=
 =?utf-8?B?UDBRZmphV1p5V0FwcENBMWo2ZG1FcHd5QXZNQ0hYS3dWNnU5QkJDT2ZUeTJK?=
 =?utf-8?B?K3dSSjhmd05kQWpBTTZRMTdmd1pIZ0UrTDAyVThLM0dhN0IxLzZCRTZHek82?=
 =?utf-8?Q?S+CbUwC4pBI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0tibEZEYmZoQnh6Zk5aWVE5emdPRVQ4aU5KYldLdkxuc0NZMHQyQm1NZFBJ?=
 =?utf-8?B?N3liR2hRbkh1OHBGWTEvc0EwWG9CbkVWK0ZabXYwVmgvMkxxUnYza2NtL2Rw?=
 =?utf-8?B?ZGxwY3BsQzdqUTUzUWplMU1zdTNLdHBlcmtSczBxSnZxbjRiY3BRSjZ1Qmt4?=
 =?utf-8?B?bVNDZWFjSUF5cnJBOEFCRlE5UHBwMFpMTnN4UmIrMmRwZlVJL213YmgwNkhL?=
 =?utf-8?B?UUx2NExvNEpLMmRjTnZ5TExMSFJGaHlHcWVYOEQvWTVzSUxYL2tJWE9iTlhy?=
 =?utf-8?B?QVlURVNwSkpPbFR0T3cxMzc4NExKTmtQWTJyZHd1MkljWk1MTll0eDdQOXdM?=
 =?utf-8?B?OXlqUWxhSDB4M3cwV0xSK00zeXl0ZWJzUW5WY2t0ZE9nYVBvS2lMRzdWUXRK?=
 =?utf-8?B?TE9XNS83eU9kb1E2TDN3b2hYZGZvNHN4azBZQ2drNFZCZmlKRkdUbWxxT3ln?=
 =?utf-8?B?SmZwQ3Bjdm9lNkpYSFhvOWxFM1hIZHBUczFmWmVMV3VjYkh5bWJLRi9ZYXFu?=
 =?utf-8?B?enlEUkZMeEtTc09mcnA5WHZPa1RKdE8vYjlwa1o3M1FOc1UxVFYyb1o5R1pX?=
 =?utf-8?B?am5peDc4eEhYeFdLK09ReEF6ZjNBWnRmeWZuQkFFRkg0MVRoTHUzN2orZHBv?=
 =?utf-8?B?ZGxWb01UcUUvRmVVZUIyQTlGWGlienp1dVhUUHNRRVJ3aEQyQXlTbm93Z2Q2?=
 =?utf-8?B?enZaOTBhR3MxY3E2WDdqbFVkM2dvN3BSYVNUc2lvK1daOFhGSDdsV1dsb1Fl?=
 =?utf-8?B?RThZL3QyMDk4UitrL09QODdqZUlJMEVNTXF0amJUSU5EeHYxNis4ZnM1Ujdy?=
 =?utf-8?B?K0JvS3lOL0IvVVJYek4wYUtHWlgwMnphWHFVSEVnODFzSThzSC9uR0R4bGVZ?=
 =?utf-8?B?YXgwK0hXb3U0NzEzRHdFR1daSEJQRG85QWlRVlJNOVV0dUF3QnRPMEFLcVk1?=
 =?utf-8?B?ZG9TczdDZ01qZ1BETGp1bUN4dzM4SlNzaE9ubytBelJBYU1lMklaVFg4aWho?=
 =?utf-8?B?UEFwT1R3T1N1TFZ5VGRDdnE1QXpPZ1VCNGVrcWw5dzAxZFRYVFhuYnNDZkNT?=
 =?utf-8?B?SUMxWW9pUkhlQ010Z29mU1YrR2hVUldSUDBtSFVMdElFaU55MEVkazJQeldy?=
 =?utf-8?B?VlI3bmtqMFVtamdjYVArL3J2SnpHNVFhdG5NMzljMTRDaGErQm1wUDU0YWk1?=
 =?utf-8?B?N2N1NU9BQlZaNGo4aUF0aDQ4bjhoNDQrbjlhcG9JNzVmOWdyVW9EZitTZmZv?=
 =?utf-8?B?dlJkL1U4SFprR3B5a3A2eTc4RWVtU2JNbUJTYmtaaGRjb1pvbzZ3SnZpQUdy?=
 =?utf-8?B?V3Azd3pTR1g1NlJPWmNsejN5TEtyUFlxbnlmZE9MUzROUWlhWnhydkRRNWRH?=
 =?utf-8?B?ZkZBK1NiT0VWNDQ0KzlYcUNzN2xONFY1WFIyNnQwNWUxNFBWV05nQ0ZhYXkx?=
 =?utf-8?B?RVZXWEpxSWRldjgzRk10VnBWNzFqME9WZzRyYVBCWnNRcHM4UGhwWVpkK1lF?=
 =?utf-8?B?d2d6SU1uWExnb005Y2FoVW4rc1JPRkN3NkhYWkVmTS91bzl6bFc3QkpsOHQw?=
 =?utf-8?B?OWNSQ0JCYWIxWXpiWnp1NmRwR0FPNTVHeXY2L0l3RkFiQWIzcTc4OXJEdnBX?=
 =?utf-8?B?dXBrZnBPQTNoNi9zYVZhTkNodkRkSkw5U05UcUlTMEVXWXhaZVpXZXIvUzRj?=
 =?utf-8?B?bzNSdHVLUkJ4T0pMUlVjUkFKRVR5cW9QNHhpQjN6WmQvVDV4cnZQV3N4UFBO?=
 =?utf-8?B?ZExuNkphN0ZCMlZ0cG5kU1p1SUFZODlPUFIrZW95MEh1anlYeHlPcjB6akwr?=
 =?utf-8?B?NUQ5RXpqWURLOUFWQ0RXUTZxZHl0UTFZd2lZSzd4MGxVdU5sT3huWEp1MFpC?=
 =?utf-8?B?MGEwNUpydFVETVh0SktZdkhlU2lQcFNibW5QSU95eXB5Z204Tndtaml4Qkph?=
 =?utf-8?B?Ny9VU3d5VVBvenBWWGRWWWFpVmZzVlYya29RSVRBaGNhZWpnYm1nS0dpVU1F?=
 =?utf-8?B?em12MEc0ZXArOTlzeHFqZE5RbW9va29ocEFSMnlMSmFTdmJRRFpQUnVvZkdt?=
 =?utf-8?B?Qm5Ub2hhdlFIc2d0YWpZVDVmaGVwZnhScUxnR0lHVEpYSy94dDlJWEpBUGxE?=
 =?utf-8?B?Zmt3QjR4NHBtbVpzazNHTjBwR3Rpdmkvc0ZaSGpWbGs4cmFzdFhWSEFoT0V5?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab626d1b-ff0c-4b18-5c89-08dda2688c85
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 06:33:27.9189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnYZpOvIb5kq2v4QlXpSN+4uA2MhhF4VaR3paZ7hIP1GXJrNo+gLSXzE1RPZvhFL/SHHNzdCNQt4M5oAuivlvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8686
X-OriginatorOrg: intel.com



On 6/3/2025 1:26 PM, Gupta, Pankaj wrote:
> On 6/3/2025 3:26 AM, Chenyi Qiang wrote:
>>
>>
>> On 6/1/2025 5:58 PM, Gupta, Pankaj wrote:
>>> On 5/30/2025 10:32 AM, Chenyi Qiang wrote:
>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>>> discard. However, guest_memfd relies on discard operations for page
>>>> conversion between private and shared memory, potentially leading to
>>>> the stale IOMMU mapping issue when assigning hardware devices to
>>>> confidential VMs via shared memory. To address this and allow shared
>>>> device assignement, it is crucial to ensure the VFIO system refreshes
>>>> its IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>>> adjust VFIO mappings in relation to VM page assignment. Effectively
>>>> page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other. Therefore, similar actions are required for page
>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>> facilitate this process.
>>>>
>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>>> have a memory backend while others do not. Notably, virtual BIOS
>>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>>> backend.
>>>>
>>>> To manage RAMBlocks with guest_memfd, define a new object named
>>>> RamBlockAttributes to implement the RamDiscardManager interface. This
>>>> object can store the guest_memfd information such as bitmap for shared
>>>> memory and the registered listeners for event notification. In the
>>>> context of RamDiscardManager, shared state is analogous to
>>>> populated, and
>>>> private state is signified as discarded. To notify the conversion
>>>> events,
>>>> a new state_change() helper is exported for the users to notify the
>>>> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
>>>> shared mapping.
>>>>
>>>> Note that the memory state is tracked at the host page size
>>>> granularity,
>>>> as the minimum conversion size can be one page per request and VFIO
>>>> expects the DMA mapping for a specific iova to be mapped and unmapped
>>>> with the same granularity. Confidential VMs may perform partial
>>>> conversions, such as conversions on small regions within larger ones.
>>>> To prevent such invalid cases and until DMA mapping cut operation
>>>> support is available, all operations are performed with 4K granularity.
>>>>
>>>> In addition, memory conversion failures cause QEMU to quit instead of
>>>> resuming the guest or retrying the operation at present. It would be
>>>> future work to add more error handling or rollback mechanisms once
>>>> conversion failures are allowed. For example, in-place conversion of
>>>> guest_memfd could retry the unmap operation during the conversion from
>>>> shared to private. For now, keep the complex error handling out of the
>>>> picture as it is not required.
>>>>
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>> Changes in v6:
>>>>       - Change the object type name from RamBlockAttribute to
>>>>         RamBlockAttributes. (David)
>>>>       - Save the associated RAMBlock instead MemoryRegion in
>>>>         RamBlockAttributes. (David)
>>>>       - Squash the state_change() helper introduction in this commit as
>>>>         well as the mixture conversion case handling. (David)
>>>>       - Change the block_size type from int to size_t and some
>>>> cleanup in
>>>>         validation check. (Alexey)
>>>>       - Add a tracepoint to track the state changes. (Alexey)
>>>>
>>>> Changes in v5:
>>>>       - Revert to use RamDiscardManager interface instead of
>>>> introducing
>>>>         new hierarchy of class to manage private/shared state, and keep
>>>>         using the new name of RamBlockAttribute compared with the
>>>>         MemoryAttributeManager in v3.
>>>>       - Use *simple* version of object_define and object_declare
>>>> since the
>>>>         state_change() function is changed as an exported function
>>>> instead
>>>>         of a virtual function in later patch.
>>>>       - Move the introduction of RamBlockAttribute field to this
>>>> patch and
>>>>         rename it to ram_shared. (Alexey)
>>>>       - call the exit() when register/unregister failed. (Zhao)
>>>>       - Add the ram-block-attribute.c to Memory API related part in
>>>>         MAINTAINERS.
>>>>
>>>> Changes in v4:
>>>>       - Change the name from memory-attribute-manager to
>>>>         ram-block-attribute.
>>>>       - Implement the newly-introduced PrivateSharedManager instead of
>>>>         RamDiscardManager and change related commit message.
>>>>       - Define the new object in ramblock.h instead of adding a new
>>>> file.
>>>> ---
>>>>    MAINTAINERS                   |   1 +
>>>>    include/system/ramblock.h     |  21 ++
>>>>    system/meson.build            |   1 +
>>>>    system/ram-block-attributes.c | 480 +++++++++++++++++++++++++++++
>>>> +++++
>>>>    system/trace-events           |   3 +
>>>>    5 files changed, 506 insertions(+)
>>>>    create mode 100644 system/ram-block-attributes.c
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 6dacd6d004..8ec39aa7f8 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>>    F: system/memory_mapping.c
>>>>    F: system/physmem.c
>>>>    F: system/memory-internal.h
>>>> +F: system/ram-block-attributes.c
>>>>    F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>>      Memory devices
>>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>>> index d8a116ba99..1bab9e2dac 100644
>>>> --- a/include/system/ramblock.h
>>>> +++ b/include/system/ramblock.h
>>>> @@ -22,6 +22,10 @@
>>>>    #include "exec/cpu-common.h"
>>>>    #include "qemu/rcu.h"
>>>>    #include "exec/ramlist.h"
>>>> +#include "system/hostmem.h"
>>>> +
>>>> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
>>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>>>>      struct RAMBlock {
>>>>        struct rcu_head rcu;
>>>> @@ -91,4 +95,21 @@ struct RAMBlock {
>>>>        ram_addr_t postcopy_length;
>>>>    };
>>>>    +struct RamBlockAttributes {
>>>> +    Object parent;
>>>> +
>>>> +    RAMBlock *ram_block;
>>>> +
>>>> +    /* 1-setting of the bitmap represents ram is populated (shared) */
>>>> +    unsigned bitmap_size;
>>>> +    unsigned long *bitmap;
>>>> +
>>>> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>> +};
>>>> +
>>>> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
>>>> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
>>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>>> uint64_t offset,
>>>> +                                      uint64_t size, bool to_discard);
>>>> +
>>>>    #endif
>>>> diff --git a/system/meson.build b/system/meson.build
>>>> index c2f0082766..2747dbde80 100644
>>>> --- a/system/meson.build
>>>> +++ b/system/meson.build
>>>> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>>>>      'dma-helpers.c',
>>>>      'globals.c',
>>>>      'ioport.c',
>>>> +  'ram-block-attributes.c',
>>>>      'memory_mapping.c',
>>>>      'memory.c',
>>>>      'physmem.c',
>>>> diff --git a/system/ram-block-attributes.c b/system/ram-block-
>>>> attributes.c
>>>> new file mode 100644
>>>> index 0000000000..514252413f
>>>> --- /dev/null
>>>> +++ b/system/ram-block-attributes.c
>>>> @@ -0,0 +1,480 @@
>>>> +/*
>>>> + * QEMU ram block attributes
>>>> + *
>>>> + * Copyright Intel
>>>> + *
>>>> + * Author:
>>>> + *      Chenyi Qiang <chenyi.qiang@intel.com>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or
>>>> later.
>>>> + * See the COPYING file in the top-level directory
>>>> + *
>>>> + */
>>>> +
>>>> +#include "qemu/osdep.h"
>>>> +#include "qemu/error-report.h"
>>>> +#include "system/ramblock.h"
>>>> +#include "trace.h"
>>>> +
>>>> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
>>>> +                                          ram_block_attributes,
>>>> +                                          RAM_BLOCK_ATTRIBUTES,
>>>> +                                          OBJECT,
>>>> +                                         
>>>> { TYPE_RAM_DISCARD_MANAGER },
>>>> +                                          { })
>>>> +
>>>> +static size_t
>>>> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
>>>> +{
>>>> +    /*
>>>> +     * Because page conversion could be manipulated in the size of at
>>>> least 4K
>>>> +     * or 4K aligned, Use the host page size as the granularity to
>>>> track the
>>>> +     * memory attribute.
>>>> +     */
>>>> +    g_assert(attr && attr->ram_block);
>>>> +    g_assert(attr->ram_block->page_size ==
>>>> qemu_real_host_page_size());
>>>> +    return attr->ram_block->page_size;
>>>> +}
>>>> +
>>>> +
>>>> +static bool
>>>> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
>>>> +                                      const MemoryRegionSection
>>>> *section)
>>>> +{
>>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    const uint64_t first_bit = section->offset_within_region /
>>>> block_size;
>>>> +    const uint64_t last_bit = first_bit + int128_get64(section-
>>>>> size) / block_size - 1;
>>>> +    unsigned long first_discarded_bit;
>>>> +
>>>> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit
>>>> + 1,
>>>> +                                           first_bit);
>>>> +    return first_discarded_bit > last_bit;
>>>> +}
>>>> +
>>>> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
>>>> +                                               void *arg);
>>>> +
>>>> +static int
>>>> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
>>>> +                                        void *arg)
>>>> +{
>>>> +    RamDiscardListener *rdl = arg;
>>>> +
>>>> +    return rdl->notify_populate(rdl, section);
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
>>>> +                                       void *arg)
>>>> +{
>>>> +    RamDiscardListener *rdl = arg;
>>>> +
>>>> +    rdl->notify_discard(rdl, section);
>>>> +    return 0;
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_for_each_populated_section(const
>>>> RamBlockAttributes *attr,
>>>> +                                                MemoryRegionSection
>>>> *section,
>>>> +                                                void *arg,
>>>> +
>>>> ram_block_attributes_section_cb cb)
>>>> +{
>>>> +    unsigned long first_bit, last_bit;
>>>> +    uint64_t offset, size;
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    int ret = 0;
>>>> +
>>>> +    first_bit = section->offset_within_region / block_size;
>>>> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>>> +                              first_bit);
>>>> +
>>>> +    while (first_bit < attr->bitmap_size) {
>>>> +        MemoryRegionSection tmp = *section;
>>>> +
>>>> +        offset = first_bit * block_size;
>>>> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>>> +                                      first_bit + 1) - 1;
>>>> +        size = (last_bit - first_bit + 1) * block_size;
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        ret = cb(&tmp, arg);
>>>> +        if (ret) {
>>>> +            error_report("%s: Failed to notify RAM discard listener:
>>>> %s",
>>>> +                         __func__, strerror(-ret));
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>>> +                                  last_bit + 2);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_for_each_discarded_section(const
>>>> RamBlockAttributes *attr,
>>>> +                                                MemoryRegionSection
>>>> *section,
>>>> +                                                void *arg,
>>>> +
>>>> ram_block_attributes_section_cb cb)
>>>> +{
>>>> +    unsigned long first_bit, last_bit;
>>>> +    uint64_t offset, size;
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    int ret = 0;
>>>> +
>>>> +    first_bit = section->offset_within_region / block_size;
>>>> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
>>>> +                                   first_bit);
>>>> +
>>>> +    while (first_bit < attr->bitmap_size) {
>>>> +        MemoryRegionSection tmp = *section;
>>>> +
>>>> +        offset = first_bit * block_size;
>>>> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
>>>> +                                 first_bit + 1) - 1;
>>>> +        size = (last_bit - first_bit + 1) * block_size;
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        ret = cb(&tmp, arg);
>>>> +        if (ret) {
>>>> +            error_report("%s: Failed to notify RAM discard listener:
>>>> %s",
>>>> +                         __func__, strerror(-ret));
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        first_bit = find_next_zero_bit(attr->bitmap,
>>>> +                                       attr->bitmap_size,
>>>> +                                       last_bit + 2);
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static uint64_t
>>>> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager
>>>> *rdm,
>>>> +                                             const MemoryRegion *mr)
>>>> +{
>>>> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +
>>>> +    g_assert(mr == attr->ram_block->mr);
>>>> +    return ram_block_attributes_get_block_size(attr);
>>>> +}
>>>> +
>>>> +static void
>>>> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
>>>> +                                           RamDiscardListener *rdl,
>>>> +                                           MemoryRegionSection
>>>> *section)
>>>> +{
>>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(section->mr == attr->ram_block->mr);
>>>> +    rdl->section = memory_region_section_new_copy(section);
>>>> +
>>>> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
>>>> +
>>>> +    ret = ram_block_attributes_for_each_populated_section(attr,
>>>> section, rdl,
>>>> +
>>>> ram_block_attributes_notify_populate_cb);
>>>> +    if (ret) {
>>>> +        error_report("%s: Failed to register RAM discard listener:
>>>> %s",
>>>> +                     __func__, strerror(-ret));
>>>> +        exit(1);
>>>> +    }
>>>> +}
>>>> +
>>>> +static void
>>>> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
>>>> +                                             RamDiscardListener *rdl)
>>>> +{
>>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +    int ret;
>>>> +
>>>> +    g_assert(rdl->section);
>>>> +    g_assert(rdl->section->mr == attr->ram_block->mr);
>>>> +
>>>> +    if (rdl->double_discard_supported) {
>>>> +        rdl->notify_discard(rdl, rdl->section);
>>>> +    } else {
>>>> +        ret = ram_block_attributes_for_each_populated_section(attr,
>>>> +                rdl->section, rdl,
>>>> ram_block_attributes_notify_discard_cb);
>>>> +        if (ret) {
>>>> +            error_report("%s: Failed to unregister RAM discard
>>>> listener: %s",
>>>> +                         __func__, strerror(-ret));
>>>> +            exit(1);
>>>> +        }
>>>> +    }
>>>> +
>>>> +    memory_region_section_free_copy(rdl->section);
>>>> +    rdl->section = NULL;
>>>> +    QLIST_REMOVE(rdl, next);
>>>> +}
>>>> +
>>>> +typedef struct RamBlockAttributesReplayData {
>>>> +    ReplayRamDiscardState fn;
>>>> +    void *opaque;
>>>> +} RamBlockAttributesReplayData;
>>>> +
>>>> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection
>>>> *section,
>>>> +                                              void *arg)
>>>> +{
>>>> +    RamBlockAttributesReplayData *data = arg;
>>>> +
>>>> +    return data->fn(section, data->opaque);
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager
>>>> *rdm,
>>>> +                                          MemoryRegionSection
>>>> *section,
>>>> +                                          ReplayRamDiscardState
>>>> replay_fn,
>>>> +                                          void *opaque)
>>>> +{
>>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == attr->ram_block->mr);
>>>> +    return ram_block_attributes_for_each_populated_section(attr,
>>>> section, &data,
>>>> +
>>>> ram_block_attributes_rdm_replay_cb);
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager
>>>> *rdm,
>>>> +                                          MemoryRegionSection
>>>> *section,
>>>> +                                          ReplayRamDiscardState
>>>> replay_fn,
>>>> +                                          void *opaque)
>>>> +{
>>>> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
>>>> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque =
>>>> opaque };
>>>> +
>>>> +    g_assert(section->mr == attr->ram_block->mr);
>>>> +    return ram_block_attributes_for_each_discarded_section(attr,
>>>> section, &data,
>>>> +
>>>> ram_block_attributes_rdm_replay_cb);
>>>> +}
>>>> +
>>>> +static bool
>>>> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr,
>>>> uint64_t offset,
>>>> +                                    uint64_t size)
>>>> +{
>>>> +    MemoryRegion *mr = attr->ram_block->mr;
>>>> +
>>>> +    g_assert(mr);
>>>> +
>>>> +    uint64_t region_size = memory_region_size(mr);
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +
>>>> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
>>>> +        !QEMU_IS_ALIGNED(size, block_size)) {
>>>> +        return false;
>>>> +    }
>>>> +    if (offset + size <= offset) {
>>>> +        return false;
>>>> +    }
>>>> +    if (offset + size > region_size) {
>>>> +        return false;
>>>> +    }
>>>> +    return true;
>>>> +}
>>>> +
>>>> +static void ram_block_attributes_notify_discard(RamBlockAttributes
>>>> *attr,
>>>> +                                                uint64_t offset,
>>>> +                                                uint64_t size)
>>>> +{
>>>> +    RamDiscardListener *rdl;
>>>> +
>>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>>> +        MemoryRegionSection tmp = *rdl->section;
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            continue;
>>>> +        }
>>>> +        rdl->notify_discard(rdl, &tmp);
>>>> +    }
>>>> +}
>>>> +
>>>> +static int
>>>> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
>>>> +                                     uint64_t offset, uint64_t size)
>>>> +{
>>>> +    RamDiscardListener *rdl;
>>>> +    int ret = 0;
>>>> +
>>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>>> +        MemoryRegionSection tmp = *rdl->section;
>>>> +
>>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>>> size)) {
>>>> +            continue;
>>>> +        }
>>>> +        ret = rdl->notify_populate(rdl, &tmp);
>>>> +        if (ret) {
>>>> +            break;
>>>> +        }
>>>> +    }
>>>> +
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +static bool
>>>> ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
>>>> +                                                    uint64_t offset,
>>>> +                                                    uint64_t size)
>>>> +{
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    const unsigned long first_bit = offset / block_size;
>>>> +    const unsigned long last_bit = first_bit + (size / block_size)
>>>> - 1;
>>>> +    unsigned long found_bit;
>>>> +
>>>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>>>> +                                   first_bit);
>>>> +    return found_bit > last_bit;
>>>> +}
>>>> +
>>>> +static bool
>>>> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
>>>> +                                        uint64_t offset, uint64_t
>>>> size)
>>>> +{
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    const unsigned long first_bit = offset / block_size;
>>>> +    const unsigned long last_bit = first_bit + (size / block_size)
>>>> - 1;
>>>> +    unsigned long found_bit;
>>>> +
>>>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>>>> +    return found_bit > last_bit;
>>>> +}
>>>> +
>>>> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
>>>> +                                      uint64_t offset, uint64_t size,
>>>> +                                      bool to_discard)
>>>> +{
>>>> +    const size_t block_size =
>>>> ram_block_attributes_get_block_size(attr);
>>>> +    const unsigned long first_bit = offset / block_size;
>>>> +    const unsigned long nbits = size / block_size;
>>>> +    bool is_range_discarded, is_range_populated;
>>>> +    const uint64_t end = offset + size;
>>>> +    unsigned long bit;
>>>> +    uint64_t cur;
>>>> +    int ret = 0;
>>>> +
>>>> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
>>>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>>>> +                     __func__, offset, size);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    is_range_discarded =
>>>> ram_block_attributes_is_range_discarded(attr, offset,
>>>> +                                                                
>>>> size);
>>>> +    is_range_populated =
>>>> ram_block_attributes_is_range_populated(attr, offset,
>>>> +                                                                
>>>> size);
>>>> +
>>>> +    trace_ram_block_attributes_state_change(offset, size,
>>>> +                                            is_range_discarded ?
>>>> "discarded" :
>>>> +                                            is_range_populated ?
>>>> "populated" :
>>>> +                                            "mixture",
>>>> +                                            to_discard ? "discarded" :
>>>> +                                            "populated");
>>>> +    if (to_discard) {
>>>> +        if (is_range_discarded) {
>>>> +            /* Already private */
>>>> +        } else if (is_range_populated) {
>>>> +            /* Completely shared */
>>>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>>>> +            ram_block_attributes_notify_discard(attr, offset, size);
>>>
>>> In this patch series we are only maintaining the bitmap for Ram discard/
>>> populate state not for regular guest_memfd private/shared?
>>
>> As mentioned in changelog, "In the context of RamDiscardManager, shared
>> state is analogous to populated, and private state is signified as
>> discarded." To keep consistent with RamDiscardManager, I used the ram
>> "populated/discareded" in variable and function names.
>>
>> Of course, we can use private/shared if we rename the RamDiscardManager
>> to something like RamStateManager. But I haven't done it in this series.
>> Because I think we can also view the bitmap as the state of shared
>> memory (shared discard/shared populate) at present. The VFIO user only
>> manipulate the dma map/unmap of shared mapping. (We need to consider how
>> to extend the RDM framwork to manage the shared/private/discard states
>> in the future when need to distinguish private and discard states.)
> 
> As function name 'ram_block_attributes_state_change' is generic. Maybe
> for now metadata update for only two states (shared/private) is enough
> as it also aligns with discard vs populate states?

Yes, it is enough to treat the shared/private states align with
populate/discard at present as the only user is VFIO shared mapping.

> 
> As we would also need the shared vs private state metadata for other
> COCO operations e.g live migration, so wondering having this metadata
> already there would be helpful. This also will keep the legacy interface
> (prior to in-place conversion) consistent (As memory-attributes handling
> is generic operation anyway).

When live migration in CoCo VMs is introduced, I think it needs to
distinguish the difference between the states of discard and private. It
cannot simply skip the discard parts any more and needs special handling
for private parts. So still, we have to extend the interface if have to
make it avaiable in advance.

> 
> I saw you had it in previous versions(v3) but removed later?

In new versions, I changed the generic wrapper of klass->state_change()
(ram_block_attributes_state_change()) to an exported function and squash
it in this patch because there's no derived class of RamBlockAttribute
which will implement other callback.

> 
> https://lore.kernel.org/qemu-devel/20250310081837.13123-6-
> chenyi.qiang@intel.com/
> 
> Best regards,
> Pankaj
> 
> 


