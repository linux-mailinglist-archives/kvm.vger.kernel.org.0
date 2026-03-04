Return-Path: <kvm+bounces-72764-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFA6BgfDqGkIxAAAu9opvQ
	(envelope-from <kvm+bounces-72764-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:40:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7355D20902C
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D90C6307C4BC
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B67F382289;
	Wed,  4 Mar 2026 23:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKGmox6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC3D241139;
	Wed,  4 Mar 2026 23:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772667639; cv=fail; b=jUmuIzz7S4GUkZMBzDAuWR/5gFYhuLVV/SmZ5CzCrKZc3YI9YIZWtyBSuEY33vUAV0gbBKZgmE4GKq2LDXGT+5b7JOiLDL8th2T7qQRWpRHgs8X33+EKyqA7HrTIT/Z/mflvE2JB2oqzkK9x59ZlWcJ6ZDANKSrawvQ3UN2wyqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772667639; c=relaxed/simple;
	bh=a8H6BvDi1W6A3u0SaVnd22MUKA+NIEmjj1QD+1v9yJc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z+H0J4FuwLP2FrRB8mmFM/d9M4lLjGulZV/zCH7NdJE66XQ9LZ/+b96rzRDjhF5eVWbB+3dV7LUzOU/z2lj9rqExqr/hSNs3EGL2DdxQQFzxpZtITlb9EA5vUO/87czdb8ZZsUHVNhRkGKg0dy0AAqHIUYIKI8uAcFIwmmvFIgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKGmox6z; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772667637; x=1804203637;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a8H6BvDi1W6A3u0SaVnd22MUKA+NIEmjj1QD+1v9yJc=;
  b=DKGmox6znw3/10Q4a8EIZCDRLFSBOF2ulk8xn/E7BwJlpWqQtzC/7Aq6
   xgSVAnj62g1azHcoxylAAOxayp/MWJRLoR481tL66MSzg6yugCpEypSyy
   9Cqhbajsj7ut6qgbUS2ZpUqwTCRGLP+Q87M/QAOffjvc7+VHi+FL/3Jmc
   ujCju0p/E7Gh0JCSknInqu835dI2FwYTYas6sr8nYm6pvRHttO68Kuitm
   5rhSXhGY/NKkDGtIK/JiIkhGkq66No9+ek41ylEp8EYuceRNTXaNHhFhh
   Q+vM1NJRSblTep7xO77McbiPbESW0cL+aYERVOJTzlzaoA0qsTMx/2sZZ
   w==;
X-CSE-ConnectionGUID: HqzxIj2kTAW+AO5SZLCUmA==
X-CSE-MsgGUID: fhwOrJszRhOe2DAQS4C6xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="91315471"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="91315471"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:40:36 -0800
X-CSE-ConnectionGUID: m8wFm2TIQXCe8jfir2aZyw==
X-CSE-MsgGUID: 5AWvy49fS8CkbsoJ2yRrjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="218439765"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:40:35 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:40:35 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:40:35 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:40:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rAAXlCEZ5TCKBDjXf4KS0zsTU3kFTx11r/z1e0900CLieFjAChe3mVU6Ph6AZ2edHrrrKsTtdsr2FmhIHsfeIZ/wL0UuWlWVzYyMpKi4Vk1mIiR3K6NR+EIUBxrD+Fzc8n/fCxKC56tpu5NpeomYSKja6BaHUj9M28p0ybkxwF7fNf/2j5p7ikH+6rue5MSY1Nk8k7mHLW6xf/eGv02Im8kz96Zo7+UEKvjUXAc5nwu99YU3mwl3ljehCbLw2cv8sroK/R6QNHbwmza3Z1aywac7HpSNkIzWiUWHDjc2wrT+giQQfL+MzWpWfjkh9U+a6ny7B4lGIgyIOx7xVJKs4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8H6BvDi1W6A3u0SaVnd22MUKA+NIEmjj1QD+1v9yJc=;
 b=TXKBOLdBdFDehM7si7bybDvSYXozxOjYk34lX4DvFDGFIiJ3wgbWeu78nN7DqiIxTWCrVwNQBZNzKDIUe7wdNpZ2sKIHcGRQa+H9qzlUEp+x57RAwMJ9tBDvp+1wGIP/fCEtOoCRZXDQ2uTXRmAISnbsW+BClQCsxSG4tofupOoOK0kecP24SXZwZNHbnBPZbmJf6XOafdU98MFKf9ZvQLfI/3XyvUww2xkOp3Gf0UXbGxeqHFIcTLMZ8cBwuDMWMXQF2v1Er1+xT1geaQ+/LAxUIl2j31lAx3d/Rm1btNZ3SvNVwFJM24bcewHCiqDFxwZ1Gh4f9M0XPWd+zu+nQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA4PR11MB9393.namprd11.prod.outlook.com (2603:10b6:208:569::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Wed, 4 Mar
 2026 23:40:32 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:40:32 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 19/24] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Thread-Topic: [PATCH v4 19/24] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Thread-Index: AQHcnCz/59I787sNd0S3uZ9h/pol27WfKC2A
Date: Wed, 4 Mar 2026 23:40:32 +0000
Message-ID: <1aaa74b61001b45261701aa73fc085a14473919d.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-20-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-20-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA4PR11MB9393:EE_
x-ms-office365-filtering-correlation-id: 5bcc6c51-b8c1-4263-2588-08de7a476ce4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: KbrJ/aRPUjfkBVO0c9ADAxi4DNwXHtwy5nvEK2Wvzzl1PWLQP8c1cDqwnVeiiep9saTlT3qed0hqg4ugi8yABfp+lOtn6ssggjYu5EcXk/NAU7sAdicP77qi45cRw5CYn5X5Fz2oAXIgy7VRgFUS+HDjiRejYlUP52/CNGLthKdDbvf0eu5m/UNseeAYhdgr7TWBMthwHTgsAd3mo9EbsdvrYqW3xKsDVjjY65zbWlf23GAEDB6JoA7/WGHiyL2BM911sbfLax7aEELyMFFQunCSs9GOfInXHZSB1JrUDe5S5OaFv8e0Wb96ZErEleF9Tk34ZyDPxghdMk55Nxgn/+DksI47fDo7l1mnmHBRh2zPfo47d3e7lhpjJ6zSJWVSN0iry+w5Fjv42Iu4QBgl3CGL86be3pWLN+Kl363jWPlCBV6ordzZUD0X1udx7YpM5bssWo96R0ygKMLvsbYOcN//lwk5qdXA9W3n9Rgj0+T2/IEzFqouFNQQtu8SxrsOJ39kCOxa70K7c/YaBVRmiGXTDhqIa0eOY6sIj7duNGBB/sIQ38P0K/iiUHV5OIMzrCEG7DoZWmes55GuSisob8Yb+K3/X2gVxNTXiP5kn9YksTpV9SoRwGeEHSC09N48t+sIDx39RWQYUEkjqwhwVJGRCQDiyxo3ZJ+xYyACLmr5zGZBvwtcnYOOWluYGkEa/Z1ENOxJpUYFu8TxAqDgOnJ0X/P69WwLk0ClYqajAkz9D6YDFMoja325WqWRHo9bfOkwIN47o+l+eJ3buehkj5dqXpJDiayL0/QvQe+8Eto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ekRYbnVIalk3RkZ3MXBtOENmR0grcWExcGFCS3VLeStHYy9OY3V0eldDSXFv?=
 =?utf-8?B?bWoyTzBJaVNPdk42NUh6MHdHa2YwRy9JQmx3c2swT3Q2aGZPWmhFTGt0RFMv?=
 =?utf-8?B?MVJHZTZFUGZsWittTnh2b1U3Y1pBUnJBYUsycTF2WDRTZ2k0dWsyejZ4ZWlt?=
 =?utf-8?B?S0JsTm16bE1pdWRxdVdWYU9WditmcS9jRVZMQzArTWIxbUkraFB2cjBGM3Z1?=
 =?utf-8?B?SjFITWFJYXM2U0pzWStQbmlERE40bXQyTjNFalAxVkFxYy9WU0YvVkdoUGI2?=
 =?utf-8?B?Qkh6eXppem95QUw4R045RDlPUVV5aXdXSDFqOUNSeHpqNDMrRUZqQnQ3cTln?=
 =?utf-8?B?RkhrYTRJMjVmMTd3RDdyRlVyancwb3dPZ0NmbTdxMXNkQ3g2NGFmb29YK0tX?=
 =?utf-8?B?VnJ2SXNDOVkvc3ZEZi83NzB5dzBjdHF5bFIxU2h6V0VJcWFvdjlheWthblJW?=
 =?utf-8?B?cmlnZG5DZ0ZUUElPcjl1QXdCWldOS1ZPYjUzK3Z0cUxSdXRwOWw5VmdqN1Ur?=
 =?utf-8?B?SkhwLzRacll1SFhXamZGN2lTUVlNK1ppR2VvaTZwcVBmOXNhejhOd2w5R3Bm?=
 =?utf-8?B?aTRsTzJlcE1SQXY2cHBYQVE5am1MT0poTklpTE45dEYyUFE1S3krZnJUZE9C?=
 =?utf-8?B?b1dsSkxBWSs1UjdsNjVic3BOcjN3cXU3ZGhuUkkrNFF5aGd5N3pjUFR4YnJF?=
 =?utf-8?B?WEdTVDNDY3R1ZjdTMEJYYTZxek9BQTF6TlUvVStha1drSTlzMVltc3dncGVr?=
 =?utf-8?B?TDh1dU90UG96S281K25zWUNUMEZrczUrcTNVbHQ4YlQrV0FnUjVBOGxmM29F?=
 =?utf-8?B?QjlSUW1SMXZJb1lJUVlydHh4QTgwRUpWTFVqM3ZCaGVUQzlsWkR1Rkt4aDFJ?=
 =?utf-8?B?NGZobWthUEs1VWsyUXA5OU9UdnRQaFlKY0dpZWszTllCVy9HaDdSWHM4dGYr?=
 =?utf-8?B?Y0tYZU9QaEMzK3NUREJCaTlpallRdXhiejRlaE1Wc2RQVWVyL3lLY01sekpo?=
 =?utf-8?B?eEJCR2xPbDJSdWlFSGpvdmRXSjk1aXNYNFVhTFllcUcyUWRHZUt1TkhOV2hB?=
 =?utf-8?B?R1c4eDVUaUVuelVoNmlaVU1wS3JuYi8wZ1RXdm16K21pQ080WVd1RTV4UStL?=
 =?utf-8?B?WWRMYmVzSXZGV0xUT0RXVG5sNmJlbE9zeE1PVFovQndOOXBtRm4zVUE2aG9W?=
 =?utf-8?B?VHExWmhDYUNVWGxEeWV5V3dsR0dTenYvOWRuQTJzV2tiakZKd1R5NzZnTzRP?=
 =?utf-8?B?NS96RlYwcVRsdzdlOUEya0lxcXpQRVFLMzlqK0RsQmFEcks2b1RLVVkwM3lB?=
 =?utf-8?B?WE5uREJ1eWJIejNQM3EySUtwR1FmWjV5Rzg2K3ZJdWo0UndvMFdZRVdvdGQy?=
 =?utf-8?B?R3RyNnNjTzU3djhIWHBzNFFXcXdWMURpNVByL3dObmhmbU85MG9Bb1JmU2h3?=
 =?utf-8?B?bm5rK09yeGUwRUxGZ1BXZjc5YVNzeU1qMTZtUDZ6SlRldnpUTFlsY2lSUHJp?=
 =?utf-8?B?eWlNdStzMHZvaEJnZEg1UEw0b3pXdUxqeHByNHZDd3IvU2t0cllpRnBHSTdk?=
 =?utf-8?B?NzFYUG1UejlDRmVsQ1dMcTQ3anJKZnpUWWFSMVExaVFSaTNVQU8zU2ZGalhN?=
 =?utf-8?B?VkVsRkZjMDIxVWQ3V2tMOWtJcm5VT05tUFJCY2lDQzUwZk9OcWhERi9MT2Fx?=
 =?utf-8?B?anZHYU5YT1BXWGc0Z2ZRbDV2dlhkTUhibldKSVphRlV1ZlY4ZDZMeERkUGp3?=
 =?utf-8?B?M2lMMGZUSS9WQ2d3M1pYZVhnVU1jRFZINGRleUpKcFJOUFZHUTJDdU0rUzVr?=
 =?utf-8?B?azJhQ0ovQzN6bVFDVHc3NmFTd1NsMCtuSFdkSmpCMG1JT2d5aTdna09XSmZN?=
 =?utf-8?B?ei9lZ1hUdHFldmJZaDJ1NlcwRElnTlJwNUZJS2FGeERmOGxOVEhYaDNQRlgz?=
 =?utf-8?B?dEk1Z0NTMklKdGtUZFJWMTVWS2VQTm02UzZsNmJOL2wybVJOS2RYREtyd1FM?=
 =?utf-8?B?azlmOUVjdlF4Q0VwcEVNS2NDWVVXK0VKOFI4V0lzaktKYlM1aTNhTklKQnJW?=
 =?utf-8?B?YlFULzNYWEthaWxJS251bTY5MkJkOHNjR3JJYVpZOWdlM045cldRcEdLZ0xZ?=
 =?utf-8?B?R21CQ2loZ2UzMGIybmhFdVR3WkJheTVFQ2djMStGbGh4SHFFcVhjSHVhMXZ0?=
 =?utf-8?B?NkN3c2RJazlXNnZQZ3EwVkx0OVlBMEFFTkhzSUllYURWcUludm1jOWRqNzdN?=
 =?utf-8?B?UWZjam11aGZnWDlIZUxqcitVclVuVG9UbGJJTFE0WWh3eldZS0UxWmpEYXRP?=
 =?utf-8?B?MkNybkJxbkNzRDJobXE5K1dGSXB5S09ySWNHN2I1M1JXR0JjNXJUUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75DF6594C256CE429411468B6780EA4C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bcc6c51-b8c1-4263-2588-08de7a476ce4
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:40:32.1051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tNYWj8j1BrWvrHp7TE6FqKzlSVQnp58lA8rRzZsgqC/Xd0jgB8nMXDMss4E3BwGbkh7xzv/bh37cmdC3iuJP/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9393
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 7355D20902C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72764-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gdGR4
X3N5c2luZm8gY29udGFpbnMgYWxsIG1ldGFkYXRhIG9mIHRoZSBhY3RpdmUgVERYIG1vZHVsZSwg
aW5jbHVkaW5nDQo+IHZlcnNpb25zLCBzdXBwb3J0ZWQgZmVhdHVyZXMsIGFuZCBURE1SL1REQ1Mv
VERWUFMgaW5mb3JtYXRpb24uwqANCj4gDQoNCk5pdDogYWRkICJldGMiLCBzaW5jZSB0aGVyZSBh
cmUgbW9yZSBzdGFmZiBiZXNpZGVzIHRoZSAzIHRoaW5ncyB5b3UgbGlzdGVkLg0KDQo+IFRoZXNl
DQo+IHZhbHVlcyBtYXkgY2hhbmdlIG92ZXIgdXBkYXRlcy4gQmxpbmRseSByZWZyZXNoaW5nIHRo
ZSBlbnRpcmUgdGR4X3N5c2luZm8NCj4gY291bGQgZGlzcnVwdCBydW5uaW5nIHNvZnR3YXJlLCBh
cyBpdCBtYXkgc3VidGx5IHJlbHkgb24gdGhlIHByZXZpb3VzIHN0YXRlDQo+IHVubGVzcyBwcm92
ZW4gb3RoZXJ3aXNlLg0KPiANCj4gQWRvcHQgYSBjb25zZXJ2YXRpdmUgYXBwcm9hY2gsIGxpa2Ug
bWljcm9jb2RlIHVwZGF0ZXMsIGJ5IG9ubHkgcmVmcmVzaGluZw0KPiB2ZXJzaW9uIGluZm9ybWF0
aW9uIHRoYXQgZG9lcyBub3QgYWZmZWN0IGZ1bmN0aW9uYWxpdHksIHdoaWxlIGlnbm9yaW5nDQo+
IGFsbCBvdGhlciBjaGFuZ2VzLiBUaGlzIGlzIGFjY2VwdGFibGUgYXMgbmV3IG1vZHVsZXMgYXJl
IHJlcXVpcmVkIHRvDQo+IG1haW50YWluIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkuDQo+IA0KPiBB
bnkgdXBkYXRlcyB0byBtZXRhZGF0YSBiZXlvbmQgdmVyc2lvbnMgc2hvdWxkIGJlIGp1c3RpZmll
ZCBhbmQgcmV2aWV3ZWQgb24NCj4gYSBjYXNlLWJ5LWNhc2UgYmFzaXMuDQo+IA0KPiBOb3RlIHRo
YXQgcHJlYWxsb2NhdGluZyBhIHRkeF9zeXNfaW5mbyBidWZmZXIgYmVmb3JlIHVwZGF0ZXMgaXMg
dG8gYXZvaWQNCj4gaGF2aW5nIHRvIGhhbmRsZSAtRU5PTUVNIHdoZW4gdXBkYXRpbmcgdGR4X3N5
c2luZm8gYWZ0ZXIgYSBzdWNjZXNzZnVsDQo+IHVwZGF0ZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBYdSBZaWx1biA8
eWlsdW4ueHVAbGludXguaW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogVG9ueSBMaW5kZ3JlbiA8
dG9ueS5saW5kZ3JlbkBsaW51eC5pbnRlbC5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQoNCk9uZSBiaXQgYmVsb3cgLi4uDQoNClsuLi5dDQoNCj4g
IA0KPiArLyoNCj4gKyAqIFVwZGF0ZSB0ZHhfc3lzaW5mbyBhbmQgY2hlY2sgaWYgYW55IFREWCBt
b2R1bGUgZmVhdHVyZXMgY2hhbmdlZCBhZnRlcg0KPiArICogdXBkYXRlcw0KDQpzL3VwZGF0ZXMv
dXBkYXRlPyAgSSBkb24ndCBzZWUgbW9yZSB0aGFuIG9uZSB1cGRhdGUuDQoNCkFuZCBpdCdzIG1v
cmUgdGhhbiAiY2hlY2sgbW9kdWxlIGZlYXR1cmVzIGJlaW5nIGNoYW5nZWQiIHNpbmNlIHRoZXJl
IGFyZQ0Kb3RoZXIgbWV0YWRhdGEgZmllbGRzIHdoaWNoIG1heSBoYXZlIGRpZmZlcmVudCB2YWx1
ZXMgYWZ0ZXIgdXBkYXRlLCByaWdodD8NCg0KSSB3b3VsZCBqdXN0IHJlbW92ZSB0aGlzIGNvbW1l
bnQgc2luY2UgSSBkb24ndCBzZWUgaXQgc2F5cyBtb3JlIHRoYW4ganVzdA0KcmVwZWF0aW5nIHRo
ZSBjb2RlIGJlbG93ICh3aGljaCBhbHNvIGhhcyBjb21tZW50cyBzYXlpbmcgdGhlIHNhbWUgdGhp
bmcsIGluDQphIG1vcmUgZWxhYm9yYXRlZCB3YXkpLg0KDQo+ICsgKi8NCj4gK2ludCB0ZHhfbW9k
dWxlX3Bvc3RfdXBkYXRlKHN0cnVjdCB0ZHhfc3lzX2luZm8gKmluZm8pDQo+ICt7DQo+ICsJc3Ry
dWN0IHRkeF9zeXNfaW5mb192ZXJzaW9uICpvbGQsICpuZXc7DQo+ICsJaW50IHJldDsNCj4gKw0K
PiArCS8qIFNob3VsZG4ndCBmYWlsIGFzIHRoZSB1cGRhdGUgaGFzIHN1Y2NlZWRlZCAqLw0KPiAr
CXJldCA9IGdldF90ZHhfc3lzX2luZm8oaW5mbyk7DQo+ICsJaWYgKFdBUk5fT05DRShyZXQsICJ2
ZXJzaW9uIHJldHJpZXZhbCBmYWlsZWQgYWZ0ZXIgdXBkYXRlLCByZXBsYWNlIFREWCBNb2R1bGVc
biIpKQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJb2xkID0gJnRkeF9zeXNpbmZvLnZlcnNp
b247DQo+ICsJbmV3ID0gJmluZm8tPnZlcnNpb247DQo+ICsJcHJfaW5mbygidmVyc2lvbiAldS4l
dS4lMDJ1IC0+ICV1LiV1LiUwMnVcbiIsIG9sZC0+bWFqb3JfdmVyc2lvbiwNCj4gKwkJCQkJCSAg
ICAgIG9sZC0+bWlub3JfdmVyc2lvbiwNCj4gKwkJCQkJCSAgICAgIG9sZC0+dXBkYXRlX3ZlcnNp
b24sDQo+ICsJCQkJCQkgICAgICBuZXctPm1ham9yX3ZlcnNpb24sDQo+ICsJCQkJCQkgICAgICBu
ZXctPm1pbm9yX3ZlcnNpb24sDQo+ICsJCQkJCQkgICAgICBuZXctPnVwZGF0ZV92ZXJzaW9uKTsN
Cj4gKw0KPiArCS8qDQo+ICsJICogQmxpbmRseSByZWZyZXNoaW5nIHRoZSBlbnRpcmUgdGR4X3N5
c2luZm8gY291bGQgZGlzcnVwdCBydW5uaW5nDQo+ICsJICogc29mdHdhcmUsIGFzIGl0IG1heSBz
dWJ0bHkgcmVseSBvbiB0aGUgcHJldmlvdXMgc3RhdGUgdW5sZXNzDQo+ICsJICogcHJvdmVuIG90
aGVyd2lzZS4NCj4gKwkgKg0KPiArCSAqIE9ubHkgcmVmcmVzaCB2ZXJzaW9uIGluZm9ybWF0aW9u
IChpbmNsdWRpbmcgaGFuZG9mZiB2ZXJzaW9uKQ0KPiArCSAqIHRoYXQgZG9lcyBub3QgYWZmZWN0
IGZ1bmN0aW9uYWxpdHksIGFuZCBpZ25vcmUgYWxsIG90aGVyDQo+ICsJICogY2hhbmdlcy4NCj4g
KwkgKi8NCj4gKwl0ZHhfc3lzaW5mby52ZXJzaW9uCT0gaW5mby0+dmVyc2lvbjsNCj4gKwl0ZHhf
c3lzaW5mby5oYW5kb2ZmCT0gaW5mby0+aGFuZG9mZjsNCj4gKw0KPiArCWlmICghbWVtY21wKCZ0
ZHhfc3lzaW5mbywgaW5mbywgc2l6ZW9mKCppbmZvKSkpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+
ICsJcHJfaW5mbygiVERYIG1vZHVsZSBmZWF0dXJlcyBoYXZlIGNoYW5nZWQgYWZ0ZXIgdXBkYXRl
cywgYnV0IG1pZ2h0IG5vdCB0YWtlIGVmZmVjdC5cbiIpOw0KPiArCXByX2luZm8oIlBsZWFzZSBj
b25zaWRlciB1cGRhdGluZyB5b3VyIEJJT1MgdG8gaW5zdGFsbCB0aGUgVERYIE1vZHVsZS5cbiIp
Ow0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo=

