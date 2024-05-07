Return-Path: <kvm+bounces-16841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1822A8BE68F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F8611C23AF6
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0B3165FBB;
	Tue,  7 May 2024 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W3Ek3Fyu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0788815FA86
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715093408; cv=fail; b=e/A27LJj/ohaedScr4laIP2ED2KxumyfDV/rIJmus4xb3UGMMfReDGiwblYV5nAaeEcJeXgq/kZJQ86oZ2Rh3i1HfCX9/YfhiGZ8JxXY59TBVB5IUgvoSle1+ejowTRDvRtquOIVMWFcLBIHYcCv3Oa14H7tjnHMllcSjVK0MSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715093408; c=relaxed/simple;
	bh=PlgG2tG3B6ednu2FzrhDF1rCQ1sXIHNz4HKq+ttO2vQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TovqXavk0pqJpJMd4CrRNhlj3buJruBRQSZS08WSI34xVjt5kMb35UlORQgIcLQbfDebyrn59ubnR0lV5bUjtQ3YLU80eOO1Ftd2rh+1udJqbfiwZxMPnU6NDiBreUv7Ng8dYEjCQLv/YK9N4yHm6VzublwrPqm4hhCcv2jKukQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W3Ek3Fyu; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715093406; x=1746629406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PlgG2tG3B6ednu2FzrhDF1rCQ1sXIHNz4HKq+ttO2vQ=;
  b=W3Ek3FyuEgYIKQ71LpQKLh/NGnPVBHxQUga0zXdae8A9N/4uQaxJkYnF
   mB9RuRe/2f1VR/yd7UZMgH9YwRpIB6B+tb7UzfvKWTFEwupyIVWksAJtF
   hVMbBQ6p8Ci0ED5BZqPok0KbbslNAaQ/GXnTxXmTULd08w0PxCYIH2vy+
   2JPGVN04EaduqV91ZADj1Fgg9GzzOja9OyvLxSw9nvQjmGi/dArT1LLIS
   yIqG3ryN8uOakQq2KX4LgK4y+erd6IDpZekqpDfjDepYaHjaxjxVBbRFU
   l0Jk8LW71QorqwU4w8Mbk1pqNUtS0GP+N/YyU6a9FQY4Dj60co+guPShl
   Q==;
X-CSE-ConnectionGUID: U5IjD7WdS0+Gg3VUvwLkoA==
X-CSE-MsgGUID: WJe26F3XQ/6uQEHHb/lAFw==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="13845915"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="13845915"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 07:50:04 -0700
X-CSE-ConnectionGUID: bdwCVgL4Q9OvixshVZqoNw==
X-CSE-MsgGUID: KqCgJH8PSGWkKUEfR06SGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="33117002"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 07:50:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 07:50:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 07:50:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 07:50:00 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 07:49:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2bCgpuGURvtGwoKS08XE0izZfdrpRjIyIlm3lwrOFfQ/8jMv8bx1QIXaTbv5rgeEbBMbEyxsiegzPtTk8GR2YObzGcteSMWNvBVQrjqST6ESeB8tQz0gey25bW+Ak/fGI5mez9Hm31KuOQFWZ/zosdlTObC/bo1hK4SWRKG7WcVXhL7Fqn9Xu8lGdYZRKe8GuJW2Hu91Ozy5/EjJ37w6OqgLtW6f7hPH7SJQxBD7bOF3VuB5MVSWfU2gLXTFNjIOg2NNs2G0kagOEOsX8QptbuuqPsii850uplzHIc+zJZrGy1or/+FqppEzq9aivnWPHZyeDHMldiNvyXh1heOWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlgG2tG3B6ednu2FzrhDF1rCQ1sXIHNz4HKq+ttO2vQ=;
 b=WKsD5utIjiAVgBKeRB4+ZjRDFwBAYFHzmB8SRAGTfVbTX76EJfKtVByfICJPcW9vjX/I4dgbwbiQmbsCZJDoDm+tlFbXxhMXjOwJDeIeJMZFuibfloeJC0vjOfTRyEfnhgUujnSH0v6e5s8HS2AJPARjaXPQNRd8O0uOgA576BHiVwmyr8CkPhDrKFaatpLqUsWPBVTLBtY83zaSr0gugkXn0zoeKZvbRsy+7Lh9BkhLng2/o0ssMllHHJ3pOEFBz7SCpZAYWeyY0LYkqn6irbGYWyPm0EPMm2jkSiDoxa3sQwWwhHWqVFe9X40iwQVmtGyq7fo+eJDLr95yJZb0NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SJ0PR11MB4926.namprd11.prod.outlook.com (2603:10b6:a03:2d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 14:49:52 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 14:49:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYAgAA3YoCAABFSgIAAA1+AgAAETwCAAAWtgIAAAsmAgBD2IwCAAUqAAIAAB4WA
Date: Tue, 7 May 2024 14:49:52 +0000
Message-ID: <ee8c0227816d546a0a02f3db9519d289d3e275b0.camel@intel.com>
References: <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
	 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
	 <ZirNfel6-9RcusQC@google.com>
	 <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
	 <Zire2UuF9lR2cmnQ@google.com>
	 <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
	 <ZirnOf10fJh3vWJ-@google.com>
	 <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
	 <322e67ab6e965a70a7365da441179a7fa65f2314.camel@intel.com>
	 <Zjo5QBVXjO2/wLE6@chao-email>
In-Reply-To: <Zjo5QBVXjO2/wLE6@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SJ0PR11MB4926:EE_
x-ms-office365-filtering-correlation-id: 38ae569e-bdd0-43e8-a080-08dc6ea4f3f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UHZuRk00WGNMaGI1aENLMFNhSHBlMkI2aDBLdDFEMXJTeHVMRXVvRDRSaUNK?=
 =?utf-8?B?Qjg2TERUYUVEOFdEOTVkSGNqYlBPeTg5TlNxa2ZUNlZUOEFXQTI0QnZZQlhO?=
 =?utf-8?B?YkhHdm9jc3ZVeFBVUXhSQXlUcEpYM3lsS3pFVjl0U01BcEhCelRnek9qczdK?=
 =?utf-8?B?SFF0S3JRSFIvYXEvbVpWaUVwTGJPQjJiM0lYbFZvU3JEcVU3K0E2OC9oQUxD?=
 =?utf-8?B?L242MHBCSm1QNy9pM256VENuZFZtTEp0dVRQRm9SNEU3d1RVUEpOUG9aQlBv?=
 =?utf-8?B?RHozSytMZnlBMUF1UTJOdkt0cWhHcUZGRzVhVkR1eXhpZTFOUzBLc1BxekQw?=
 =?utf-8?B?RFlwKzFiKy9FU1N0bVZqRWNDaVRCY2JyUk1qOWVHZExvbm9ObHkzdGF1b0g3?=
 =?utf-8?B?MUVsMURqYks3c09ldHFUSDRsbW44L0gwSlBqQ0JZQ1RGZThxU2hPZENaOW44?=
 =?utf-8?B?ZmFpNmd5aEJ6TWdMcm9BZlNOMTZ3RjVwZDhSanBNNTFTWSs1T0xvZzEzZ0dM?=
 =?utf-8?B?Y3VpM0pTd082WGR0eVB1dmJaWE41WXp0M1RpQncwTHJNZUlFUmYrUnlSdVVL?=
 =?utf-8?B?Vko2enlkcE9YaGorWHB1b1lQNkRITWgzaDVGNE9FRXhleUM1VktGNVFXeXd1?=
 =?utf-8?B?eUo4aGpuNzVHQzRGdUNob3lvM01LR0U1bGFoSElvQUl0c2x4UHJTYWl3bno0?=
 =?utf-8?B?bTY0V1VJY1Foa1IyMWMwZmIyR2JlS001a0s5VUtPSXpJL0Z6WEJteHp1R0o2?=
 =?utf-8?B?bklTMEd6RXVuU3NYUHBQN2JDTU5YQmc2WFhlVCsxMzd1RWs5K0tLYWdyZ2hT?=
 =?utf-8?B?QWNEeXIyVWxNK1ZKbnQzc1BMQVRwbzh5RmhYbEVGaVVYTFY1eEMxOGltd2RE?=
 =?utf-8?B?dyt1OGFONlJwdTg0V3FWbDFKRkRXUlpHcnRIUUlpR2dSUjBaeWkrNGVmam5n?=
 =?utf-8?B?RVFtTGxSNk50Nk9VOXB2ZFl2RkJLM2JlZVRYdlpkUmxpUm9wNXF0ZVN4c0ZI?=
 =?utf-8?B?WStRMFYvOHhTbmgvRnd1SlJES2dTMFFTTEJGbDJGY0RRbTBadkJBenJtSC9D?=
 =?utf-8?B?eXFTUUdiQ3hSdDVoNjIra3ZYMmRCSzdDeG9jUEkwaDhNQjJiNTN1RjFUaHl3?=
 =?utf-8?B?VG1RRXE4WHNTU2tIaUt5bGp4ZWlidDExVzlGRTVzVEIyVGZKa3gzWngyMExR?=
 =?utf-8?B?NkdySU9hQTFmRlBxakNCZjVGa0Rna296VVgzUWlwUC9SWkJ3UzhYTTdheUhD?=
 =?utf-8?B?cnRWdHZFMjgrUkxJNTFlRUswU3hodUc5TjgvemlicFp1aFJvWElsUm9LVlBi?=
 =?utf-8?B?L25GMkNNY0xDTDZnMGlKdWVJT0lTWUJjYXROb1BjckFpQmhaYVIvd3RNSmVn?=
 =?utf-8?B?YXpGRHhZVXV3YjZ0TXYwbjFNYm5HWEU2QU5xT1hISm5aLzNSRFBXcGJCTTZw?=
 =?utf-8?B?RG0xQ2Y1SUVDQmJMMEJwRzFrcnJUQ1dlbzZJc01GVktHY0VvdVp2T25vNlRw?=
 =?utf-8?B?WDN4OXgzZ1VqN0JNVjN6TUN4RlF5RWJCb1pBQmZXRDJMaHlhRnBKeEdXT2Vm?=
 =?utf-8?B?bktxVnl3a3pzYmpxdXBvUXZEcmtGcG5pT0NLbDJRVjhzaFcrRWtXMTN1Z2pq?=
 =?utf-8?B?RTBpN1FwNzJpeVhDRHN2ZWtrL1hYM2RTVTQ0Z0RHNUVCaFRLK3RNY2dmWGN0?=
 =?utf-8?B?Rnc2Z010WXlnaEJLa0dTNHdzRWNHMEZiMWxXdG9wUVNxdlBCM1FMMWFFeUIv?=
 =?utf-8?B?YmJpRDN4b3kyN2g0bElGOGJaVmJ1M3o3RTJKTkxXZEhxdElxZEk3L29wRmIr?=
 =?utf-8?B?bWtRUnlIb1NZeDhZL245Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUMrVVZxM2tJcFVVdjFJSHcyWktYUklTcUZKdU4zZzRrZE5kRzdHUkprN1Jq?=
 =?utf-8?B?UCsyVnVVN05Nd2dBVFVTbUlHRzhXdTR0Zk5WUzdlMHorZHRTcnI0WFBkZ0ds?=
 =?utf-8?B?VUhoMXFack9rZHc4eURRbGZGTXpqRERWTFQ3SXFUQlptaktCTDdSekdNbVZw?=
 =?utf-8?B?RThiVlR2TXg1SWFBeW1OclVkNVpOeE5mVURCSnVrdlhCN2dnb0M4b3M3NG5w?=
 =?utf-8?B?YklwTlozSWV5RmdEcFI4b1VYRitzMDFZRzhFNGptYkNUWnQ1cmsxWlVzY1hZ?=
 =?utf-8?B?Y1V4cGJ4cVNJWlZaUEVMR3FKZzNGWXlyZDdOK091U3gvY3dKa09tb05DV1Mv?=
 =?utf-8?B?N0szbTRtSFE2ZjVwUjRqTkVjeTZLMmVuQXdDZDg5TzhySjZKYlBrVkhESXlx?=
 =?utf-8?B?REMvdXpQWnloazVhNnM5eFVuMUwvQlpaeGl4bnBUZDZHY1FoTW1mM3lkSmFi?=
 =?utf-8?B?QnRxOGY4VUplY3NVVjFjQ2ViWGdMc0VZSjlmQ0VCSkZQcGxxV2Q3WHFYWjdt?=
 =?utf-8?B?L2ZkNzV5R1pFQ1grVzh1SEhnUklXTjVMdEoxM0VOSFVmb1V2WTh1bTY1bWlY?=
 =?utf-8?B?OU9hcGZSdXVPYVhCQzkyeWxRTUdydG1lWk9lZHg4c2RQNXpxQ1NYL1BiLzVZ?=
 =?utf-8?B?MjF2OEpsRWRWeDNrNmZSVU9XUlFuL1Y4MHBKemJpZytId2ZSTS93NXRuZHFP?=
 =?utf-8?B?VEs5cTdOYUJ1RWdqcVFZWUZlNHVVc0x4dWNFdjR0YXY5VDZydkZjdzcvZGhS?=
 =?utf-8?B?YVBMdHl1SzF6cXhYdDdoOHRnaUl1MU82MzdDbEVrWFV3U29JN20weXRpMkhs?=
 =?utf-8?B?Mk5xSVpJaUlMQTIyRTZYTHdkM2tLZXlIeEtqOEQxVTVVeHJ6TURKc1ova0Vy?=
 =?utf-8?B?Y2twbVltaTJHRkJFdTFDSHcxZXRIcXpiWHhFR1FWRE1KUXNSRTI2ZkJoejM3?=
 =?utf-8?B?b29sRmllMDNIV0Z2L3hlb0VtY0hUL0cvMjdJbHJxWUlSSkk5UGxGLzR2SytK?=
 =?utf-8?B?V2lIYWh5blFyL2dGUG1OVXB1ZVpKVHJLSE14NElrbEhtbFZYaHo0c2hDQWxx?=
 =?utf-8?B?WC93UUs0QVd2OEtYRVNXUGRpelBMU2d4ekNTMko1bEFBS2ord1lDdElOVGxj?=
 =?utf-8?B?RDR1ZjZVZmNhYmREN2p5VTduSklTbE1sN0h5R0NseHBkUVVuK1lDYTRrMU9C?=
 =?utf-8?B?TFEvcWFBOTdpWHZqSisxMzBRWXhFcGdmdndqL2Rnck1CVm9zTk9RWGdEYStn?=
 =?utf-8?B?VGFjTFlDZFg5eVZ6S09JT1B3WTFOSGhoT2RLRTZJV25Ub2hmejNheG9DdXdl?=
 =?utf-8?B?ZktKUklrU0RzU2ptc21mWHlJc3gvOFNpOS9RZTNNUTZpeGZwS1dwZ2F1Y0Jj?=
 =?utf-8?B?aE9abm5VbkU3c21GZVZvQXFDVS92L0hMRDRPcFJjK2w0cnF6TWplUVlzQXE5?=
 =?utf-8?B?Vm9OOE1uMHd2Q3VvV1FDNC9aek5SWkd0RXdDWEhrSWdsS2hjcG9CTkZyMXY3?=
 =?utf-8?B?OXh6ZCtJckJBK2Jya0hyek1sL1g2OFJsNzBJaXZWMlQ2ZEJ3MnQ1TEpVTm5C?=
 =?utf-8?B?aDlZYjNtQUYxdFBGN0JxaHg3Z1c3byt4UjZZYWE1eXpuOWhKc2ZZRzhxZzc5?=
 =?utf-8?B?b2VNQVRPRC90NW9nb1VKVll5bGIvTHJ3SytnUk54ZHhWTTgzU1RZKzkrMUlD?=
 =?utf-8?B?dzVqRytDMDdwbHB1S0FPay93VXIwbGllWSt2cGkrMm1RZ3ZtK1JvSU43ODdL?=
 =?utf-8?B?VUNIY0VQN2UrZlhES2wrSGYrbUpzUGF0Q2pwbm9XUGo2dFFmNEw5akJqRVVn?=
 =?utf-8?B?K2x0bmxjL1VETi9PdWUycHVZcGtOem1IemliVWpHTk9QRW5nNkRlUE9OdGto?=
 =?utf-8?B?OURpOGc5QWpxczFsd1lmcHlzODRmMzNuMlM0SVErdUMrUWNHNnlVUEpWNlQz?=
 =?utf-8?B?NWtGZlB6THBMd3FZM2NoOXNaS1VFd25GVm1FMWREKy9OYnk3aDdUaGFZUGdz?=
 =?utf-8?B?ZUp3QUtvcDl0Y0ZrTStlZUIzZVVyZ0d4Y1NwRlFCMlBqdVV5NHhzU0EzY003?=
 =?utf-8?B?MmpiQ3dhZ0p3QVVjWStwUzJnOFNqOFZvZkRVNUtLL3dobC8wMU8wWC9iTG9s?=
 =?utf-8?B?N29ldjRtN0pPbXMwbitWTzJOSnJFNENVV0wvdjM5L0R2Y2RMS3BQbWQyY292?=
 =?utf-8?Q?s8FmT5PqSuGuVm8NQBYKJXI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <130C3463E034FE4A8317DB026171E899@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ae569e-bdd0-43e8-a080-08dc6ea4f3f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 14:49:52.6330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q7PwP1xaivX/9ODe3eJnwfn0x/Y3hZgG6pmVGfc1FVZoG3HdZ+IobWJjzd9LFwJ3SQiJjD8WV0RTZUZNepMnkXYghgcqVS8DaesYPXeHPos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4926
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTA3IGF0IDIyOjIyICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAy
LiBUaGVyZSB3YXMgc29tZSBjb25jZXJuIHRoYXQgZXhwb3Npbmcgbm9uLXplcm8gYml0cyBpbiBb
MjM6MTZdIGNvdWxkDQo+ID4gY29uZnVzZQ0KPiA+IGV4aXN0aW5nIFREcy4gT2YgY291cnNlIEtW
TSBkb2Vzbid0IHN1cHBvcnQgYW55IFREcyB0b2RheSwgYnV0IGlmIHRoaXMNCj4gPiBmZWF0dXJl
DQo+ID4gY29tZXMgYWZ0ZXIgaW5pdGlhbCBLVk0gc3VwcG9ydCBmb3IgVERYIGFuZCBLVk0gd2Fu
dHMgdG8gc2V0IGl0IGJ5IGRlZmF1bHQsDQo+ID4gdGhlbg0KPiA+IGl0IGNvdWxkIGJlIGFuIGlz
c3VlLg0KPiANCj4gRG8geW91IG1lYW4gc29tZSBURHMgbWF5IGFzc2VydCB0aGF0IFsyMzoxNl0g
YXJlIDBzPyBBIGZ1dHVyZS1wcm9vZiBkZXNpZ24NCj4gd29uJ3QgaGF2ZSB0aGlzIGFzc2VydGlv
bi4gQW5kIHRoaXMgY2FzZSAoaS5lLiwgc29tZSBDUFVJRCBiaXRzIGJlY29tZSBub24tDQo+IHpl
cm8pDQo+IGhhcHBlbnMgb24gZXZlcnkgbmV3IGdlbmVyYXRpb24gb2YgQ1BVcyBhbmQgZG9lc24n
dCBjb25mdXNlIGV4aXN0aW5nIE9TZXMuIEkNCj4gZG9uJ3QgdW5kZXJzdGFuZCB3aHkgaXQgd291
bGQgYmUgYSBwcm9ibGVtIGZvciBURHMuDQoNCkludGVsIGRlZmluZWQgdGhlc2UgYXMgcmVzZXJ2
ZWQuIEFNRCBkZWZpbmVkIHRoZW0gZm9yIGd1ZXN0IE1BWFBBLiBTbywgeWVzLCBPU3MNCnNob3Vs
ZCBiZSBtYXNraW5nIHRoZW0uIEknbSBub3Qgc3VnZ2VzdGluZyB0aGF0IGFueSBhcmUgbm90LCBi
dXQgVERYIG1vZHVsZQ0KZm9sa3Mgd2VyZSBjb25jZXJuZWQgYWJvdXQgdGhpcywgYW5kIHRoYXQg
dGhlbiBLVk0gd291bGQgbm90IGJlIGFibGUgdG8gdHVybg0KdGhpcyBvbiBsYXRlciB3aXRob3V0
IGJyZWFraW5nIHRoZW0uIFNvIGp1c3QgY2lyY2xpbmcgYmFjayBoZXJlIHRvIGRvdWJsZSBjaGVj
ay4NCg==

