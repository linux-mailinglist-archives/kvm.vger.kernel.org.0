Return-Path: <kvm+bounces-71608-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AEF0GLN8nWmAQAQAu9opvQ
	(envelope-from <kvm+bounces-71608-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:25:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C9B1854C4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:25:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE9BB3028062
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819CA3783C7;
	Tue, 24 Feb 2026 10:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8HVveMh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0791428F4;
	Tue, 24 Feb 2026 10:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771928741; cv=fail; b=rK4NCHFfnHGjN0ZUWdvzajtgeS9F02NPJwaV22dwi+BpcP44bkYIDTgv7ja0iZQh+C8q6eBPZxj6TqaZytS56j29QCxCjMqORpo12LkXBuKug+ydq05CyF1dDfpcyU47uqEHJweUounhLPbi/TXNUg70ywqFjlx4ymjIYTYGETE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771928741; c=relaxed/simple;
	bh=3c5sA+K0/DbAXilQJCGDbQh1IyBtr63aqYs3d5I+xTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=df7UfVOs2iYEj+9Wfulutc2XFsKhn/BEhyFsRLPZTmC0J9wihhERkzKy2iEmwedM+9O40JRp1JP58sW1JLt2uzT4yELr2ITL/e3msU4QKTLPTKlHYBR1K7hg/WrXPxwwZnaRcL0c6SByoCHbBhfriNbJ9kbi/xyDbHSE63B1N6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8HVveMh; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771928741; x=1803464741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3c5sA+K0/DbAXilQJCGDbQh1IyBtr63aqYs3d5I+xTo=;
  b=R8HVveMh4fFCRvs/cBlqyJrPMRlDTtbbp8WVSq5GxkTM0ugjRp96881C
   WIkpYOk5pBt74ytoxTTK84rse7u26VCzhGrM5QNGFJecCM9KiAByKkeIu
   OSm9uCdiqQVapeKe57uVPVRjLdoH4r1wF87LMyQKnWedcVYA/tacCCuwW
   faf6js4lB5tELr9uc9BGitzAqSK8NZl3AALCKRMDIFUteKUSF1V9C/GB/
   BnyPifbu+I1J22Yw30mI/qch7MCvT7XvGE6rHA9jLH6JeuPO6wUFL04Fz
   2JE2FEZfLaz0XoiRib/lshOhWO47FE1ezt1DRvTOZS7fRmif+CvpcvO8n
   A==;
X-CSE-ConnectionGUID: U9Gaq025TdmWySUluaJJRg==
X-CSE-MsgGUID: TnDBJnCER2WI55OB0APlow==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76801650"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="76801650"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:25:40 -0800
X-CSE-ConnectionGUID: dZCVD0aQQ4mhRnJBwFS43A==
X-CSE-MsgGUID: Mpr6Kd9jS7G+dXXuBNGmtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="253592174"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:25:40 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:25:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 02:25:39 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:25:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6i068WbWPkeLI2SVYTyaG9ISCgNjUnW+wh3OjCT/Q5AhrVNjqSqq6BUy0Qtizs7JNLaEUzWe4HYxkdSyIZwnUYnBY3sg6IHAdsdB9SK1GlOcwhAPudAM2S74eAiwXrSbG4qnA0rnTZyhNZCaGyI90WsrOVgQRdYMuhe1HE3Bw6Lk3AbSxd/94JLN/ed2MxxVgz1XiFE6x3EqmMl75dbBcC0zxtF4e9PZUw4S8tkOlmdjoGGlv1HjA3hFXocXQMcMiIQU5lGlZlsSeMlMiIIVDVKXG0Xy3qJ/ti2xGPdPCu+n+RqBvMtb6vuC/0Egx75O+LKPjmb+lHTGB3TRCbfyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3c5sA+K0/DbAXilQJCGDbQh1IyBtr63aqYs3d5I+xTo=;
 b=QosJuGpghvbqUTXb/rv7Xz51pzVEXO3a5s0XTWZdOOXFTq0FycLwK5RSWWnR9g+ovvp68LQQCFzQLx6wS54UI/wmA4VnEfI+q7kPVIP3SoRzZQfzZWt0cB5ev96pm9vxaF4hDP+/BAU8eKfP5VLh+yWWlHWePxjh02Fzhb7tlStIaNgvaZtMC6bMfRuxSLoByWZJjBDgbm5gp1gkb0ug+brBDhvk8E6KVF1qdd08wRpp8FjDzCS774q5nkmgQ5YP12o8nV7MrwOZDnhuXQbQNBKuFaIRSuyYFWHauH+EszTdijUnJo755zcQ/afiu96jESMvYhvp6e7wrfxWQAbobw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA3PR11MB8896.namprd11.prod.outlook.com (2603:10b6:208:57d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 24 Feb
 2026 10:25:35 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:25:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "Weiny,
 Ira" <ira.weiny@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Thread-Topic: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Thread-Index: AQHcnCz5TZUFN+eNL0+dGnboZO9S27WK05qAgAZfiYCAAIRTgA==
Date: Tue, 24 Feb 2026 10:25:35 +0000
Message-ID: <75dae98e3b70b66a56bde9b57992fc7d45671c36.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-5-chao.gao@intel.com>
	 <2683dff7a7950c57aa7a73584d86cf1b34bcfc07.camel@intel.com>
	 <aZ0Nnay7ygKeXmuC@intel.com>
In-Reply-To: <aZ0Nnay7ygKeXmuC@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA3PR11MB8896:EE_
x-ms-office365-filtering-correlation-id: f06fdc15-a012-443a-5e9d-08de738f0c12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bzlyUWU3bEM4VjFPSzBZNkpwTktQMVNOczFwSlZOT0h5Wm4rRk0wOHFXTDAr?=
 =?utf-8?B?YTRoaENiSmRLVHh4RFNZSm5SNjFLZ1Z5RlZFT2NvM2xkQ203eUxwWWhXRnFm?=
 =?utf-8?B?Qlgvbml3NnpucktsR3V0U1JDYXFQUVowKzlwcWxtYnhaZUYxVTRzL1VVRzJQ?=
 =?utf-8?B?dHRyZG54bFZvS2RWcmhHNEZ5Y2NqNkowMzFrcTBvbE92bzhGWWRzT0lBWU5p?=
 =?utf-8?B?OFprTjFtekdjTHJoaUJ2a1J4ZG9VRkZnSVdJSjRtUGhUZktpNk9kdS9RcUVj?=
 =?utf-8?B?VXVnc25aTkIrQkRkUlpZcUlvZ1NwbzJoUGptbC8yUmFsTDFvelU1ai9oRWpu?=
 =?utf-8?B?U3NDRFR5QS91UE0xV24wWmVZcTNvK2EyYVo0TG53anNXWGJ1MmgwbmV5T1FN?=
 =?utf-8?B?cHJ6U0hCUjg2WTJ6cHdwYmRpUmpyb1dXbVljOGhwMFRML0RhRlhGeCtFWTBq?=
 =?utf-8?B?ZFFPTG91WkMvMjg0QWd1T3FoY21rYlUwd016Q0JvTHdLUi84dTRCVWlDSjBk?=
 =?utf-8?B?aTF1UWk3Q3F5N0tUNGdhYVZwZzlxOTdTYi9TcWZzZnFBTUdIa3FNMGkyc251?=
 =?utf-8?B?WHREbW5XYStPTStuZk5oVlhoN0h3SGwra1RMeTZMMUg1dkRCeldnYm93NEh0?=
 =?utf-8?B?aHdGZ1hvOEc4TE14dU1OMHVVaFdVMm9iR2JvVUIwa3JDeUkwOFBZZnVLOUxa?=
 =?utf-8?B?VDVXUkVvR2pRZUQ4MnQ0UzJnT3ZiemVZN00rQ2JjOEgrejdGcmhGa255ZG0y?=
 =?utf-8?B?QzA4dzhpUXZ1MGhqWFNLRnhDZm1rR0k5SlZ0UGJHelZleTZPZlV2OGZ0QlpM?=
 =?utf-8?B?dEt0UnJ3R2YvaGZrNEZFMTJRdi9SeStQRy9oWmJyWjFiVDFPdHlvZm80MzBm?=
 =?utf-8?B?SHRlTDhEa2tOVXMvVGFVaDZBdnFvS2hmWGZuSkdWLzRRYVFINGkvVzNoNzRL?=
 =?utf-8?B?ZzdpVUd5MWJSUzhqRnBtMkpLZ0JrOFRwSm82MEYvZWs4M0VkRjVZOGpxVEFh?=
 =?utf-8?B?aVpad0JGUldZTHYwZkNNMU8vUTduWmdKNDRacG5wTytxNVprUEliVm1hcGF5?=
 =?utf-8?B?Qy9Lc3NsOC9jNjRRUTJCUTZ5ZFFITitRTDFvTHdGb2hZOEY0OHJDVGtFS05E?=
 =?utf-8?B?UTZKZ2hlNCsrTXJtUWIyMzgvbjFWUVRHcUoxamJMMGR3TWpNVjZEM3NzVFBz?=
 =?utf-8?B?WTBtRTZJOWQ0UDdSY1BMS2JHWmdkRU5ZRHVxMnBRbVc2dDRMVUJGNkoySnVH?=
 =?utf-8?B?ekoxRFpLZFlUVXhQZy9hbUgzcW0vQkxCODFqVnpxVTEwVVVEREJCODFieVVr?=
 =?utf-8?B?bitrRENSVEZOMEZVOHZaOUdiUTZTMll6RHV4SC9HaW5BV1hzMStVTmxZVnZ0?=
 =?utf-8?B?eTJEVURyaCtNU2hRYm9xbytZdmR0UW9wZWZ5UlJXWjR3eE5DTFhYamRGTnRs?=
 =?utf-8?B?SHVQTTVGSFV2Q3hKQk1LN0NaOWVnamw3dEQ2Wm5IcmRwUUxKZXlMcGp6NjhZ?=
 =?utf-8?B?VzZIaHlFWHI2bDlPOWl3ZW5JNnNRdXViYkUvQkd4SjdaUG9KTXljVVlEekhh?=
 =?utf-8?B?Z0xmQ1ByV1E0ZTNqeUhjVkJKVVM0M1FKTFB3Zy8xK0R3eTlyc09lU0xPcnY1?=
 =?utf-8?B?UVhKVjZ6VE45ZkhrU3BucDV6Sk80bHoyK2tETC9qNGhPZG1xanVIWkQ5ZXhx?=
 =?utf-8?B?MGNqNkRkTVVXcTEyc3NYQ0swVVhFQzlyTXlrNUpjWnZwMjZITy9LUk01ZXI4?=
 =?utf-8?B?UEZmeFZ3QnlWVjR1TmNPWWx1Y2dMSVZDbXNIQWM5ZXhYTVR3UndTT1RmeGpn?=
 =?utf-8?B?bDFReGJSQzZZb3ZuM3pXUHVBNjlyZmpmUTVKRC9kM05QcVArUit1N0RkVUdP?=
 =?utf-8?B?dWNGS08vVkRLak5EdUg1clowUk1hdkJybUtCSDBtU2VFYkcwVWV6ZTZXNVNL?=
 =?utf-8?B?MC90elIySTFPb3FLWEdKbmQ1Y0JlWDNiZGJuQWdoRk5pN1F4K2ZtcTE2eUts?=
 =?utf-8?B?UjlYTGlyZWhxZ1plZEdtZFRYZFBhVE5lRS9SQzBhKzhpSHJ3Skd0MWlWUXhZ?=
 =?utf-8?B?M2lTa3c3MjFOWDNUQS9YU1lFcGZqeDNMcmsyaTd0eE8zOGd6M3JNL1d2UjJn?=
 =?utf-8?B?ODR0elFVUVdjY2YzL2NXTUJybS9ZalhHSmhzK0k1ZWNNdStlcVdPR2hIZzVy?=
 =?utf-8?Q?44/d0fTzOPEC255/BBc3K2W+qWa3GIt5bny8DDw464Zx?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzUvYnBkQURQYlFpNXQ4a1c0UHVIUmNRZk1nR0I4Y09md0R3OEhGL3paT3o1?=
 =?utf-8?B?cXVjWWtCcEYxRFhwVzRXcU1NVlVjdjJjczIwZVZmM3RFYk9VWE1kMGNXOXMw?=
 =?utf-8?B?Rms1R2x6eE5yZnY5SEV4alNBWDY0ZEJuSWNoRWd0OU5HWVBnWFB5OXlpOWZD?=
 =?utf-8?B?MEZlQXlZWTFGWHp3QUFHRDFaN0M4d2hLNWsrUHFhK3JPK0JqUHpqaVArUTc4?=
 =?utf-8?B?VGlscTN4a2hJUm95azU3dkxKL0hQWDlYU1U5cWFMVXF4azNVdkMrOFI2dnZr?=
 =?utf-8?B?dFBVcWlCdmk2THF0ZXZMc1Boa1loMzFUdU1USDlKNFozYy95OHFnRkwvSDdM?=
 =?utf-8?B?andPNHp0MTZieHZ5NzVBRGFOMlJ6UFoyTUh2eEZ1Q1hVTXNuWFA4cjFQbU9D?=
 =?utf-8?B?ODMzSGIyRnZSRW1wQ0pPdDhFMENmSndjMlJWQlJWcVV4K1BEQWNuRDdGTlBX?=
 =?utf-8?B?a1N1OUozUHNQQlhiVFhvWGlDSlZjQTdDbmd0SGNiQnczYUVicytIbXZXSlFY?=
 =?utf-8?B?NmNkSUdGWFlxZmNFL0p5YmwzeTB4TldQUlFDM0pnT2NrcU5QaTlPLy9xN1la?=
 =?utf-8?B?NHNTeDZpbCtHTk1PK1FmR0QwSThOSFl6ZWttSGkyTkdaM0lja2pSYlNyYk92?=
 =?utf-8?B?c0ZzalQ2b25GT1RIdDhHTnlNTjk1aThTYWlxL05IWW4rcmxvelVkb2FiRElF?=
 =?utf-8?B?OFdPdTJZUHR6S3dXMGdDRGI2OE9Na3V6VlZQQ3pETm1BTkJQYk9FTTU3Y2pT?=
 =?utf-8?B?Y3NMTlhFdkpieUYxYVgvVUQzaU5QWWROVVF4ajFKVElwVmZiTnlwaFY0Ujh6?=
 =?utf-8?B?aE4yd002amZ0eUlyWldRcDROa1FoRGlPa0JSd3dkL1R6VHNJeXVncWRrUUNH?=
 =?utf-8?B?SHNFenp6ZGU5amMrbkhpWjh1WFJTM0FuWU8wRjU0T2d0L2czcEVqMzJtN0VF?=
 =?utf-8?B?QkpwR3QxTy9UaFF6ZWZNNHk0M1YwWHk1NVBKUTRnQUdYYStibkhnT3hqR0Rv?=
 =?utf-8?B?U3dMdHlkaVlaR1pRdE1XNk5JWU0vNmhwRFZVcFZENUZLVCtUdUh3NEFNaCtx?=
 =?utf-8?B?RWQvdWRBMXE5ZkpJSE9JRGc3Yis4aXd6ak41RFRNbGE0b2JDaGNMM3hXUUN3?=
 =?utf-8?B?ZlM2am9PZ1ByRU12dVNGMlJGZFd2WE5xcTNxUEJhQ2lIZGx6b0pURHdJeHAz?=
 =?utf-8?B?aTVhK2EvVExNR1p5aVh2ZERBSDJGdnRjaVZWbndyVzhOQWlDVEZQTDg0b0Ry?=
 =?utf-8?B?d2tmT0RwZ1JHVElKM0Z4dk45RDBPZWVTWlk1OXNWbjBxcjN6aFV4YVJLZU9O?=
 =?utf-8?B?dFAxOVJIZE1lelo1WXN5V2tBR0RQazVhQUhPbjY4TEhGTGtCT09JYW9tVysy?=
 =?utf-8?B?amVaOW5LRzhTSEs2ZEg3YitvdUxDRTN0OHlqenNwYjB6YW41aFF5RTdWcDlR?=
 =?utf-8?B?ZnVJNGFiY0dzYURTbVdFdjhBbWw0cFNWN1BvaFBSRzRabzFoSzRiRmxxc0V4?=
 =?utf-8?B?bUVmNEE1NHIyN1Y4ajgrREVSZE5TcEFJdnZHbUhOMVI4ekNTSGE2clhyKzhY?=
 =?utf-8?B?dXkxSnNWY1NOLzFjVGRpWEF3SmwvYmRLc3hvTFJaYU1nVDU2NTJiOUVNVnJI?=
 =?utf-8?B?dEh1WTZxYUxWYlhpRXRqQVFycEZMMzRWd2VWWEk3YUFRc0xERmk0cHNtMjdl?=
 =?utf-8?B?LzNQNUoyNzBYWTFlMDJDTVRYb0hBcWV0N1F0T1RNZ1ZUY3d4TFZsOGtORjdq?=
 =?utf-8?B?aVNuTHFPNGR2aVFQZSttLzZieDRGdHhaSVUyUzltbHczaVVEc1plZllDZ3Fr?=
 =?utf-8?B?QmhKeThGVTV5M2h5TUcxNGY1S21qcXJHaEZmVGtrWGRIMm9pbEZLSXpoUjNH?=
 =?utf-8?B?d3ZaM0VpUnZVLzk5RS84aFd6K252MzBuZ0ovVGl0YTFHTlJ6RjZCbFZOeGc5?=
 =?utf-8?B?V0hmaHRsZXpxSDVpQjBPQkxtZlZKU2IyMW8rdXM2R09wWit1L0FrTVYzQWRm?=
 =?utf-8?B?aFpMTFN0QVA1N1RIS2orNlJ4bnQwck1nQmh6RlgvdTNxVmVveFpESlRZMUdi?=
 =?utf-8?B?N0prSmQ3TzExemtERUU4Wi84ekFDZUNZZFRYbWpSU3NmeUppMkdrb05wNmZs?=
 =?utf-8?B?bGhCcHFVN3RDMzJmeEI5VC83RjNqK1hDZ3d0aEtnTjZ4RTdpSlp5a21jWlJR?=
 =?utf-8?B?cGtlL3NrZGpUR0ZVV05ZYTlwZlNOZm0rbFpVQ0FBWXJlRGdjSngveTdvSVBt?=
 =?utf-8?B?RlVwYVZLWEJLbFFyNWh6TTFtNGVKTE5kZkNVNlRLV2J4ajgzUkdkb3MxWDhW?=
 =?utf-8?B?UzF2UWJ5ZlE5SmdndUpBLzlaZ1NUVnhTaFNJZVhrWU90UDl5UW5hdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E09C6B75B74724CAE5BB2471C7B3AE0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06fdc15-a012-443a-5e9d-08de738f0c12
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 10:25:35.2657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qe6VB6Lt8rs8ZUsdH/H0APIegC/HEjphrb6wptS42dJqqZxzfSlb0cHSIYA2OXKkYJqzgFlhvmuXE+m5bUG2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8896
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71608-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 83C9B1854C4
X-Rspamd-Action: no action

PiANCj4gPiANCj4gPiBCdXQgSSBkb24ndCBrbm93IHdoeSBkbyB5b3UgZXZlbiBuZWVkIHRvIHRh
bGsgYWJvdXQgTlAtU0VBTUxEUi4NCj4gDQo+IEkgaW5jbHVkZWQgdGhpcyBiZWNhdXNlIERhdmUg
aGFkIHNvbWUgY29uZnVzaW9uIGFib3V0IE5QLVNFQU1MRFIgWzFdLCBzbyBJDQo+IHdhbnRlZCB0
byBjbGFyaWZ5IGl0Lg0KPiANCj4gWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vYVh0
MCtsUnZwdmY1a25LUEBpbnRlbC5jb20vDQoNCkkgdGhvdWdodCB0aGF0IHdhcyB1bmRlciBhc3N1
bXB0aW9uIGJvdGggTlAtU0VBTUxEUiBhbmQgUC1TRUFNTERSIGFyZSBTRUFNDQpzb2Z0d2FyZSAo
d2hpY2ggaXMgd2h5IGJvdGggb2YgdGhlbSBhcmUgbWVudGlvbmVkKS4gIEJ1dCBvbmx5IFAtU0VB
TUxEUiBpcywNCnNvIEkgdGhvdWdodCB3ZSBjYW4gc2tpcCBOUC1TRUFNTERSLg0KDQo+IA0KPiBB
bmQsIHNpbmNlIE5QLVNFQU1MRFIgYW5kIFAtU0VBTUxEUiBoYXZlIHNpbWlsYXIgbmFtZXMsIEkg
dGhvdWdodCBpdCB3b3VsZCBiZQ0KPiBoZWxwZnVsIHRvIGNsYXJpZnkgdGhlIGRpZmZlcmVuY2Uu
IFRoaXMgZm9sbG93cyBEYXZlJ3MgZWFybGllciBzdWdnZXN0aW9uIHRvDQo+IGV4cGxhaW4gU0VB
TV9JTkZPIGFuZCBTRUFNX1NFQU1JTkZPIFNFQU1DQUxMcyBmb3IgY2xhcml0eSBbMl0uDQo+IA0K
PiBbMl06IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS9iMmUyZmQ1ZS04YWZmLTRlZGEtYTY0
OC05YWU5ZjgyMzRkMjVAaW50ZWwuY29tLw0KPiANCg0KU3VyZS4gIElmIHlvdSBmZWVsIHRoYXQg
aGVscHMuDQoNClsuLi5dDQoNCj4gDQo+ID4gPiArICogU2VyaWFsaXplIFAtU0VBTUxEUiBjYWxs
cyBzaW5jZSB0aGUgaGFyZHdhcmUgb25seSBhbGxvd3MgYSBzaW5nbGUgQ1BVIHRvDQo+ID4gPiAr
ICogaW50ZXJhY3Qgd2l0aCBQLVNFQU1MRFIgc2ltdWx0YW5lb3VzbHkuDQo+ID4gPiArICovDQo+
ID4gPiArc3RhdGljIERFRklORV9SQVdfU1BJTkxPQ0soc2VhbWxkcl9sb2NrKTsNCj4gPiA+ICsN
Cj4gPiA+ICtzdGF0aWMgX19tYXliZV91bnVzZWQgaW50IHNlYW1sZHJfY2FsbCh1NjQgZm4sIHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpDQo+ID4gPiArew0KPiA+ID4gKwkvKg0KPiA+ID4g
KwkgKiBTZXJpYWxpemUgUC1TRUFNTERSIGNhbGxzIGFuZCBkaXNhYmxlIGludGVycnVwdHMgYXMg
dGhlIGNhbGxzDQo+ID4gPiArCSAqIGNhbiBiZSBtYWRlIGZyb20gSVJRIGNvbnRleHQuDQo+ID4g
PiArCSAqLw0KPiA+ID4gKwlndWFyZChyYXdfc3BpbmxvY2tfaXJxc2F2ZSkoJnNlYW1sZHJfbG9j
ayk7DQo+ID4gDQo+ID4gV2h5IGRvIHlvdSBuZWVkIHRvIGRpc2FibGUgSVJRPyAgQSBwbGFpbiBy
YXdfc3BpbmxvY2sgc2hvdWxkIHdvcmsgd2l0aCBib3RoDQo+ID4gY2FzZXMgd2hlcmUgc2VhbWxk
cl9jYWxsKCkgaXMgY2FsbGVkIGZyb20gSVJRIGRpc2FibGVkIGNvbnRleHQgYW5kIG5vcm1hbA0K
PiA+IHRhc2sgY29udGV4dD8gDQo+IA0KPiBObywgdGhhdCdzIG5vdCBzYWZlLiBXaXRob3V0IF9p
cnFzYXZlLCBhIGRlYWRsb2NrIGNhbiBvY2N1ciBpZiBhbiBpbnRlcnJ1cHQNCj4gZmlyZXMgd2hp
bGUgYSB0YXNrIGNvbnRleHQgYWxyZWFkeSBob2xkcyB0aGUgbG9jaywgYW5kIHRoZSBpbnRlcnJ1
cHQgaGFuZGxlcg0KPiBhbHNvIHRyaWVzIHRvIGFjcXVpcmUgdGhlIHNhbWUgbG9jay4NCg0KSSB0
aG91Z2h0IHRoYXQncyBub3QgcG9zc2libGUgdG8gaGFwcGVuIGJlY2F1c2UgZHVyaW5nIG1vZHVs
ZSB1cGRhdGUgd2UgaGF2ZQ0KYSBtYWNoaW5lIHN0YXRlIHRvIHNlcmlhbGl6ZSB0aGVzZSBQLVNF
QU1MRFIgU0VBTUNBTExzLg0KDQpCdXQgSSBhZ3JlZSBtYWtpbmcgaXQgSVJRIHNhZmUgaXMgdGhl
IHNpbXBsZXN0IHdheSBzbyB0aGF0IHdlIGRvbid0IG5lZWQgdG8NCndvcnJ5IGFib3V0IHRoZSBk
ZWFkbG9jay4NCg0KDQpTb3JyeSBhYm91dCB0aGUgbm9pc2UuDQo=

