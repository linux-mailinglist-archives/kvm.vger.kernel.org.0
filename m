Return-Path: <kvm+bounces-20909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81466926915
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 21:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7856B24429
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 19:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B37118E778;
	Wed,  3 Jul 2024 19:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcpvkUB8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2697A183080;
	Wed,  3 Jul 2024 19:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720035642; cv=fail; b=jeFTGSleep+MOd7CjRYz4bNQ743PW6zd/OJSx3RlhxpRB8oQj/tNrjzCRelX1sqL9t5dlZ+nCEu3x+WKh3ryB+uJCtxpZr/77k3RsmH89xq+X6lhZZFVFCLrhrAOTZhQjXWRpbmVm+zM9f55qarl+YlkdWh0brIvqol2BwNkI98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720035642; c=relaxed/simple;
	bh=68HGzXtbMHR23B8FUDbpjwq/09rzeY+gy5G/yDD3X78=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gCDLnrjyKylWT1vJUoXZ7tG/5lK3uWzCv+joQOrkp5QGoFRXKDWsTgGrGMYGyRlvY4OjTDivVJHApo1v+QIG5qaCitxosI5+gpAJGu2k7xTMX6E5WrMsijJZbgrjEbWj0vmtc+7pubpaNMovh/yJAE7Ytl94HPsSs1lP4C0KTIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcpvkUB8; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720035640; x=1751571640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=68HGzXtbMHR23B8FUDbpjwq/09rzeY+gy5G/yDD3X78=;
  b=NcpvkUB8+8Y1UdrnLpN7GIQRUheBJQInskNw1bjHRjBc9EMClLlXdGaY
   EhCzM5bOoZgYCqn2nY9hiVKq98Jd5/0zYRmH+viN9tzu9W+PdgH1jy057
   a/fIvU3gxh7JM89SGlEWE1nNP9B3SnqafqOYoejLzfC+Wsn/UMwNAZu35
   zke0l4VxpaSiO29T7QH91i9LC+CzX5GqGtwdD0fT+E/XxQ5fzJqVsK3o7
   SyzGu1IIKBJesd35SOI1vQPrH2vInocHhJBNpavwjVEwdfDHK1YngUQ2N
   X2o7N6JHgcTA3zVlhdaaro8YnFJ3K3CZ4mnceHhVQWpDjXI1hNkBWCzOA
   w==;
X-CSE-ConnectionGUID: rVnqNZbDTkyFtnhN0Acz8A==
X-CSE-MsgGUID: rxS+9NAfTFWhNfrtKE1ojw==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="39805035"
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="39805035"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 12:40:39 -0700
X-CSE-ConnectionGUID: 2eY+Zu49SyCaFwUYMSxsxw==
X-CSE-MsgGUID: JKghNVMbTTGPIqR/uXqS7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,182,1716274800"; 
   d="scan'208";a="51217820"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jul 2024 12:40:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 12:40:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 3 Jul 2024 12:40:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 3 Jul 2024 12:40:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 3 Jul 2024 12:40:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXmyEmRvpH7Xidgh4H66mZQNGxcImF6z0N+LX3GjPl6CS0071zbgL84UkPldHXccOHBuHw/ISEiWII4eQXYKihQJl57XYZvWcqR3l8Ma+cusp+0Yn1BdNJVS1etit8mC7m8CWY88+jxzT+tmhohbuhDb5+rCpnRer9elJoJ7KKPNefwbhRIS8a1HQheS4fyeknY1VhrGe1H9tnahJSo9Mf+p3WAj5LuVy+Q17Htmj0Q4mnpCTYTdHs4DgqxnC09cmWZxvFxrP8+xQ98PAdQiwobtlugUNIXRzsHifR+1X5ioHKYgNchRCX3YjBBEkaEOjW/uHXPu4Y+FMsK1LMt8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68HGzXtbMHR23B8FUDbpjwq/09rzeY+gy5G/yDD3X78=;
 b=mSxR7nbNUv7+m0U3HpGkxkivjX4GINzuSZSBHLDtEIl8q7I8B63s3U92DDgHFeI6vD6Sqxw3hXBV4rsV4VNHHmEoMpoyFufMcCX33YnKeE9whwNSVKrZxC37QuZID3RW2rbTdqximqxUv+5Sw6ycuGGobUjskPzFuevcjW8A6+EXtlG6BXLFAT+v5jrWsO0EFwV1cgxtq+ad5J4ikRUzY9yHM3qpWL1OqLrkSki6JNO7hoK13oOFreSsJxoUAt+jdyeiHR/1mqa3hZOC1uOLLsPeiR7tD2ZasoqrNR83H04/aRODXRxYHzoDJ0BbsjOM8AZAzjSHkdzEheKUMG8j2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7067.namprd11.prod.outlook.com (2603:10b6:806:29a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.29; Wed, 3 Jul
 2024 19:40:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 19:40:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHWnFqAgAESGACAAFF6gIAA+LWAgACO+QCAC/TxAA==
Date: Wed, 3 Jul 2024 19:40:35 +0000
Message-ID: <7268ff80d3825fa6d7a50101358b47d5fbe86d5c.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
	 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
	 <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
	 <70dab5f4fb69c072493efe4b3198305ae262b545.camel@intel.com>
	 <ZnuhfnLH+m3cV2/U@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZnuhfnLH+m3cV2/U@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7067:EE_
x-ms-office365-filtering-correlation-id: 899ef6cd-aa4e-4c56-1435-08dc9b980220
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YnZqNlAwcVJ1VGEreURUNDgvbXpSNDNnQ3F1R2dtZ1hIQkowSXVBZ1JHNGhW?=
 =?utf-8?B?cWt1UDN1ZkRjK1I5MGZvTjJnM2VNWnNSdUVjR1ZILytnR1ZWY3ZjR2lXOEl5?=
 =?utf-8?B?ZndPUmZwS1l2QnRDMmllc0dreUNhMFR0UkNaLzcrUEtrVDFodVQrbVA5aHYr?=
 =?utf-8?B?RmlzYlhWbDY2c2FBQ0VWQ1NDRHZjRjlOR3g0V3FxZHFxeEpmR2FGTHhEbXBD?=
 =?utf-8?B?eUIzYTlBNHp5MUFraHlqbGxHWmdMdlJaY0NkVXBmbzdDOHo3amRWM3ZRQnpR?=
 =?utf-8?B?Q2hGT0ZFRHhrZTZHZkdNT2YxejRLYnVlaEl1K3FUWXdVdExkK3VQSlFmV1lk?=
 =?utf-8?B?MXZ2THR6dERnclI5aWhXdzFFNEtiU2JzU0Y4Vy8xREpDUjJka0R4cy91OU1x?=
 =?utf-8?B?TkFBQjZOMitueXFldmFnTEtWd0tIVzhCdVUwZFZrYzYzMDRZcTNPSExxa0c3?=
 =?utf-8?B?bDQxbk84ZXdzNk5zODVMZmFxK0R5TExQNFlRNGV1dzJlOWFpSndjSGdPMnVp?=
 =?utf-8?B?MThSWjZ4SkVsZUVnMXE3dkZTY3dsRjI1aWJkMzY4WTJKQTJUbHNsRi9hTmdo?=
 =?utf-8?B?RTdVNHl2KzkzVU1qUFBwSSsyNzIvNlBTRlRQTVptVXlMekdsanl3YUcwR2c0?=
 =?utf-8?B?QU1GV1B2UzAvamx1RmZoaFViTVpXbG1lbDZXdXZiamJ3c0JmRmlnVVY5YlAz?=
 =?utf-8?B?cHdOcGp1Tld0M1l2enBRUkpWUEIveFJreC81dVVTdm5md3dGYmtxajhYRlE5?=
 =?utf-8?B?dGgvemxFNTg3RDZLUkt1dDJ3bmJOaGxRU0l2cWtnY2FyRnd2cVRYZi9qZEdC?=
 =?utf-8?B?ZjhlbDFyNHE5NVlST2hGMDdTWC9nVXpYK2dLZDNrZjZjZ0RSVzJKeHdwd0p4?=
 =?utf-8?B?Z0prOXBReUlLUlZkNFV0alFpc3dlMEFpeEZVUVJONXArUUFFZC9iZHRLWjgw?=
 =?utf-8?B?a24zZU0rOWlSUlZvM0FZWmVudmZEQlNFV21tT3prTW5XNzRpc0xuQlNGQmEv?=
 =?utf-8?B?ZzhlL2QrZWZ4RVd4enIrbGY3S3k3b0dMSWlJdjdNTUxvS2FFQm9HV0F2VVRJ?=
 =?utf-8?B?STZ6YUVuQ0dkY2NmYUFxNjJNRERrTHYzOUlGTU9mSVZTMzdCeERLZFFSVGVF?=
 =?utf-8?B?bUFYTFpxdVk5OU82eFFhSWIrTG96dEpmbFBIK1pscVlYcGkxajg5Nk5DckM5?=
 =?utf-8?B?aFVRWE81OENMV2FqNkNvUTdyL0l5LzVXdU1yNWJZWlJsckdOZ3BZSlhDNEdq?=
 =?utf-8?B?Z2FBa1poQnRObVFLVXBua1JVR2lQWGl3a213Rmc5UGpkcFIxYXV1bjk2RjRx?=
 =?utf-8?B?M3d3cWhlWmhyMmt6YmFLN0svMWVkbWxGMk9tZlo5dDU2cklGM0JaU2x4MkJH?=
 =?utf-8?B?UzdBeGZRYnc2QVFHUUU5blFmaU1sSk9xMm4vd1NSQTZXS0R3WDdoNFNpWUQx?=
 =?utf-8?B?eWZWU1RWSDJ2ZnNJWVZ2OVVMU3dRTktsZ2FJMEI3NzRmQnNDMWVqaFoxeWxu?=
 =?utf-8?B?d0RkL3UrNEFEMjZkUnFvWXN6aUE2bjBQc0xYVE4yS1JDWmJIZ3lFcUVvaU5p?=
 =?utf-8?B?emJkMFJKelhMcjlOY3dUNFRCUU9DcTFMVHR4LzVsc2pGaFRaMFJTdFVDcXNq?=
 =?utf-8?B?bUU5VGFIMkwzNnovY29mZlVPZGxMTGkrdlVuWFMxN2YrYklLQm55akJ3RTlV?=
 =?utf-8?B?cjNjbVFKVVhMN2hDTUptYWlMeTdhdHVhQjBMd0RKc0dPUTRQc3hBQnpSNndY?=
 =?utf-8?B?Q3BpQld6WkNoSmVTZXNTOGpac2NxTDF2K3FnNllqZ2o3QWlldnM0MzhLZnd5?=
 =?utf-8?Q?OUM1/IsQ+0P91iiq998FTQ2gjM2E4bMhqJ8FA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M1lSU3hmMy9aWkQxY09taGJXSzV3S2VKTzBVeWpBZmZ0Mit5eGF2SzFxMDhG?=
 =?utf-8?B?WnY3blJZcklVb3I4aEpLOU1UL3VlcFUwRHdHbFZZVlhDSXE4VHMvdjA5R1NU?=
 =?utf-8?B?Vjd2M3paNFRVNUc0OVp2N1NodzF3ZHBpNlpEQ2R2RmJQYmkwM2w3ZzdabXIw?=
 =?utf-8?B?TllxU0owbDJIRlY4cVVKcU5mNlVycERFUnNLREp6WVRxN0ZyTTByMXBFb1Ru?=
 =?utf-8?B?S0hiTWN3ZUcwYU53bEdoUmwwVWJEYzdxbnVhcXJmZUlNaUdjTnJmYWVDTnBL?=
 =?utf-8?B?K21VVllCWnhLbXhPaEdqN2JFS2E2ekVnQ0FHeTVkT25kVkc0Q1AreG1EYjYx?=
 =?utf-8?B?TDBMcUU1dzJDdnNqU0NkRk5XVUlIUEpVVlh4MjU0alFxR3hqZjdLM2dnY1pz?=
 =?utf-8?B?L1BhWWVFemJFTGtyMXo2Tzg5QmxWTVhydFJTek1jdWdBdmNWNHFkMjhFcXZN?=
 =?utf-8?B?UTBPeTVKcFNOY0VMMzZxV2djTlhzbWY5Q3Mvam5WblJpSHg2UnBYWWsvNkJa?=
 =?utf-8?B?eisyRDd4STU4aCsyTDFsdHpuUW9iU1Npa3FodktMS3dRNWtITTd4ZHM2VGFR?=
 =?utf-8?B?dVY2a2dDMjdTZG1rTzhCU0VFdU9KbzRkY1VQeG9jODZVVjZ1OGM2SzU0U01U?=
 =?utf-8?B?a2pXdXo4TFBZUGpLdEZoejZpcEZ1SDBCdXBYTFZDVURXOUNYQ0dQU1hiL25B?=
 =?utf-8?B?WDZEZVJzVWlNdFVrcDZSeFA2RGVHeWEvZGp5elNQbmlwVGNJVzJ6VVpDRXR2?=
 =?utf-8?B?bUVPN3lGRi85VW4vWjFOMWV2WmthSWpKdEhjYXNmTnFYaDJQUW03YjdEdXN2?=
 =?utf-8?B?NTlCWFRZbVVkZ3BxUUp2UDczdW9mYUdIWmFpaWVMU21iQ2l0OUZ6TGU3YnBi?=
 =?utf-8?B?THNCeis2TFIrRTc5T3lKQjNJQzFjVFV1QmM5VmtBcU4wT0FpeitRTjlCWnJH?=
 =?utf-8?B?SmsyTnd6YVNTMFYrUUJvenlzTjFOVTRRRnRzWmQ4OU5Hb3lyTjJxTm9kYmhk?=
 =?utf-8?B?dDk0cTlFOVVoVURkQkVqRTluSTZwTzlzZlJGV2R3N2ptWm1qdDRvU0x2L1Vs?=
 =?utf-8?B?Qnl2SFQ2M2xJM25MV2dXSWhTcHNMdXJzV2p0Rk9mUHk1cTlTb1lIdDgxN2da?=
 =?utf-8?B?NzdNOENTcEN1WTgxaDJZOFFIbUYyOWFiSzVTaDI3VHVpRC9JeWhsWkE3U3U3?=
 =?utf-8?B?dE1ZT1NRTms1cHJpVjlkU0g2UUxzRnZNQzNwNmI3VVhQQ2o5VmwxTGVteHNp?=
 =?utf-8?B?SW1nd0FkeWp0RXdJMldtdUJHRktUMWNVY1BaYmF6RlRLWjEvWDU3VHdOdk1s?=
 =?utf-8?B?dGo0d0Q5ZDlIaUN2TDRuMStBQXFvUHZObFFXVjNydzlmeTBzSUt6WHpmN2N6?=
 =?utf-8?B?VTNFdytkN245S1VkVW5ENzl0MDFvTHdBUVFPV3JwV2dXWkErY3E3UWcvUGJG?=
 =?utf-8?B?aUNqZ2VaelZNb21XRFZQNzJta3NJMU9BV2Y4K3drOGRycnFya3FSMmxibkxP?=
 =?utf-8?B?UmZhQ1pSZXMzdTRuSWtUSDljdmw2OUdoVDZCYWtoQzVjR2pPd2VkQkFabisx?=
 =?utf-8?B?MUFTYUpBMUViTGpGSll1NzhEYXlsR1h5THpjWnpJT3BHSmFFVWxzVC9TK09X?=
 =?utf-8?B?T0pET2RxTE9IUlo4VHhXZUdqaEZLVFlDMHhpODFWblMwVk1VOFhFN2FnVm5B?=
 =?utf-8?B?aWkrWXVSNlp5OEZuRTBNWFZ1V1BodHFaS1Y5aUQrT1RZbFFzVmw3WkpLTXNt?=
 =?utf-8?B?Z2hMR29zSStXbDZ4TjdkbU9xM3ltaDRoZWRNSDdxRFRYcE5PK2I0QXo0QjVQ?=
 =?utf-8?B?YVNDQkdPOEtoRHppRC9BUWdoTjlra01lY3dFNmcvL2NVdlV6SjNRNWx4eFln?=
 =?utf-8?B?T0V0bXoyQWNxN3dOU05Xb2ZKVGJ6UzBlVEQ5K3pHNzVHRXo2cFhWZVZCYXpJ?=
 =?utf-8?B?WWMxalZwbElSWGxBbUxqZ3NpUzRjVUlabmNmaVFDZWhseGtjY2s3MU8xclQ5?=
 =?utf-8?B?Tkk2c2tVbHhtek9tWEx5amVIcXgyOUJHTTZHN0JNOFh3M0s1dDJvT296aTd0?=
 =?utf-8?B?ZGhhTWhBalBkc0k1MUxOUVU5dkdBOUJDSmVGN0Jtd2owbk1vaGFFbEtRV1I4?=
 =?utf-8?B?eUdicFZYSDM4SU4xN2g1dXlEQUh3VmE2OHdUWUFzVGozby9OMHBrS1BqdEJK?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <42B9F2728E95764D8A42B1151A8C8952@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899ef6cd-aa4e-4c56-1435-08dc9b980220
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 19:40:35.2717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KcGvL45mbDsEdtjkuXekLniD3Sw9gv6TPX5U7v2BlZlk7GgDePJkTNPQxF8UJAfECziPLukB98AK4hksBJXmkQT4s0peEXFvw3KOhgWyjHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7067
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA2LTI2IGF0IDEzOjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQnV0
IHdlIHN0aWxsIG5lZWQgdGhlIHJlbG9hZCBwYXRoIHRvIGhhdmUgZWFjaCB2Y3B1IHRvIGhvbGQg
YSByZWYgY291bnQgb2YgdGhlDQo+IG1pcnJvciByb290Lg0KPiBXaGF0IGFib3V0IGJlbG93IGZp
eD8NCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11LmggYi9hcmNoL3g4Ni9rdm0v
bW11LmgNCj4gaW5kZXggMDI2ZThlZGZiMGJkLi40ZGVjZDEzNDU3ZWMgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS9tbXUuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11LmgNCj4gQEAgLTEy
Nyw5ICsxMjcsMjggQEAgdm9pZCBrdm1fbW11X3N5bmNfcHJldl9yb290cyhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpOw0KPiDCoHZvaWQga3ZtX21tdV90cmFja193cml0ZShzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIGdwYV90IGdwYSwgY29uc3QgdTggKm5ldywNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBieXRlcyk7DQo+IA0KPiArc3RhdGljIGlu
bGluZSBib29sIGt2bV9oYXNfbWlycm9yZWRfdGRwKGNvbnN0IHN0cnVjdCBrdm0gKmt2bSkNCj4g
K3sNCj4gK8KgwqDCoMKgwqDCoCByZXR1cm4ga3ZtLT5hcmNoLnZtX3R5cGUgPT0gS1ZNX1g4Nl9U
RFhfVk07DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBrdm1fbW11X3Jvb3RfaHBh
X2lzX2ludmFsaWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiArwqDCoMKgwqDCoMKg
IHJldHVybiB2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEgPT0gSU5WQUxJRF9QQUdFOw0KPiArfQ0K
PiArDQo+ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX21tdV9taXJyb3Jfcm9vdF9ocGFfaXNfaW52
YWxpZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqAgaWYgKCFr
dm1faGFzX21pcnJvcmVkX3RkcCh2Y3B1LT5rdm0pKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gZmFsc2U7DQo+ICsNCj4gK8KgwqDCoMKgwqDCoCByZXR1cm4gdmNwdS0+
YXJjaC5tbXUtPm1pcnJvcl9yb290X2hwYSA9PSBJTlZBTElEX1BBR0U7DQo+ICt9DQo+ICsNCj4g
wqBzdGF0aWMgaW5saW5lIGludCBrdm1fbW11X3JlbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
DQo+IMKgew0KPiAtwqDCoMKgwqDCoMKgIGlmIChsaWtlbHkodmNwdS0+YXJjaC5tbXUtPnJvb3Qu
aHBhICE9IElOVkFMSURfUEFHRSkpDQo+ICvCoMKgwqDCoMKgwqAgaWYgKCFrdm1fbW11X3Jvb3Rf
aHBhX2lzX2ludmFsaWQodmNwdSkgJiYNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICFrdm1fbW11
X21pcnJvcl9yb290X2hwYV9pc19pbnZhbGlkKHZjcHUpKQ0KDQpJZiB3ZSBnbyB0aGlzIHdheSwg
d2Ugc2hvdWxkIGtlZXAgdGhlIGxpa2VseS4gQnV0LCBJJ20gbm90IGNvbnZpbmNlZC4NCg0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIDA7DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoCByZXR1cm4ga3ZtX21tdV9sb2FkKHZjcHUpOw0KPiBAQCAtMzIyLDExICszNDEsNiBAQCBz
dGF0aWMgaW5saW5lIGdwYV90IGt2bV90cmFuc2xhdGVfZ3BhKHN0cnVjdCBrdm1fdmNwdQ0KPiAq
dmNwdSwNCj4gwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHRyYW5zbGF0ZV9uZXN0ZWRfZ3BhKHZjcHUs
IGdwYSwgYWNjZXNzLCBleGNlcHRpb24pOw0KPiDCoH0NCj4gDQo+IC1zdGF0aWMgaW5saW5lIGJv
b2wga3ZtX2hhc19taXJyb3JlZF90ZHAoY29uc3Qgc3RydWN0IGt2bSAqa3ZtKQ0KPiAtew0KPiAt
wqDCoMKgwqDCoMKgIHJldHVybiBrdm0tPmFyY2gudm1fdHlwZSA9PSBLVk1fWDg2X1REWF9WTTsN
Cj4gLX0NCj4gLQ0KPiDCoHN0YXRpYyBpbmxpbmUgZ2ZuX3Qga3ZtX2dmbl9kaXJlY3RfYml0cyhj
b25zdCBzdHJ1Y3Qga3ZtICprdm0pDQo+IMKgew0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4ga3Zt
LT5hcmNoLmdmbl9kaXJlY3RfYml0czsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUv
bW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+IGluZGV4IGUxMjk5ZWIwM2U2My4uNWU3
ZDkyMDc0ZjcwIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+ICsrKyBi
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gQEAgLTM3MDIsOSArMzcwMiwxMSBAQCBzdGF0aWMg
aW50IG1tdV9hbGxvY19kaXJlY3Rfcm9vdHMoc3RydWN0IGt2bV92Y3B1DQo+ICp2Y3B1KQ0KPiDC
oMKgwqDCoMKgwqDCoCBpbnQgcjsNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIGlmICh0ZHBfbW11X2Vu
YWJsZWQpIHsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGt2bV9oYXNfbWly
cm9yZWRfdGRwKHZjcHUtPmt2bSkpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChrdm1fbW11X21pcnJvcl9yb290X2hwYV9pc19pbnZhbGlkKHZjcHUpKQ0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV90ZHBfbW11X2FsbG9jX3Jv
b3QodmNwdSwgdHJ1ZSk7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGt2bV90ZHBf
bW11X2FsbG9jX3Jvb3QodmNwdSwgZmFsc2UpOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGlmIChrdm1fbW11X3Jvb3RfaHBhX2lzX2ludmFsaWQodmNwdSkpDQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fdGRwX21tdV9hbGxv
Y19yb290KHZjcHUsIGZhbHNlKTsNCg0KU28gd2UgY2FuIGhhdmUgZWl0aGVyOg0KbWlycm9yX3Jv
b3RfaHBhID0gSU5WQUxJRF9QQUdFDQpyb290LmhwYSA9IElOVkFMSURfUEFHRQ0KDQpvcjoNCm1p
cnJvcl9yb290X2hwYSA9IHJvb3QNCnJvb3QuaHBhID0gSU5WQUxJRF9QQUdFDQoNCldlIGRvbid0
IGV2ZXIgaGF2ZToNCm1pcnJvcl9yb290X2hwYSA9IElOVkFMSURfUEFHRQ0Kcm9vdC5ocGEgPSBy
b290DQoNCkJlY2F1c2UgbWlycm9yX3Jvb3RfaHBhIGlzIHNwZWNpYWwuDQoNCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPiDCoMKgwqDCoMKgwqDCoCB9DQo+IA0K
DQpIYXZpbmcgdGhlIGNoZWNrIGluIGt2bV9tbXVfcmVsb2FkKCkgYW5kIGhlcmUgYm90aCBpcyBy
ZWFsbHkgdWdseS7CoCBSaWdodCBub3cgd2UNCmhhdmUga3ZtX21tdV9yZWxvYWQoKSB3aGljaCBv
bmx5IGFsbG9jYXRlcyBuZXcgcm9vdHMgaWYgbmVlZGVkLCB0aGVuDQprdm1fbW11X2xvYWQoKSBn
b2VzIGFuZCBhbGxvY2F0ZXMvcmVmZXJlbmNlcyB0aGVtLiBOb3cgbW11X2FsbG9jX2RpcmVjdF9y
b290cygpDQpoYXMgdGhlIHNhbWUgbG9naWMgdG8gb25seSByZWxvYWQgYXMgbmVlZGVkLg0KDQpT
byBjb3VsZCB3ZSBqdXN0IGxlYXZlIHRoZSBrdm1fbW11X3JlbG9hZCgpIGxvZ2ljIGFzIGlzLCBh
bmQganVzdCBoYXZlIHNwZWNpYWwNCmxvZ2ljIGluIG1tdV9hbGxvY19kaXJlY3Rfcm9vdHMoKSB0
byBub3QgYXZvaWQgcmUtYWxsb2NhdGluZyBtaXJyb3Igcm9vdHM/IFRoaXMNCmlzIGFjdHVhbGx5
IHdoYXQgdjE5IGhhZCwgYnV0IGl0IHdhcyB0aG91Z2h0IHRvIGJlIGEgaGlzdG9yaWNhbCByZWxp
YzoNCiAgICJIaXN0b3JpY2FsbHkgd2UgbmVlZGVkIGl0LiAgV2UgZG9uJ3QgbmVlZCBpdCBub3cu
IFdlIGNhbiBkcm9wIGl0LiINCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDMyNTIw
MDEyMi5HSDIzNTc0MDFAbHMuYW1yLmNvcnAuaW50ZWwuY29tLw0KDQpTbyBqdXN0IGhhdmUgdGhp
cyBzbWFsbCBmaXh1cCBpbnN0ZWFkPw0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL21tdS9t
bXUuYyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCmluZGV4IGFlNWQ1ZGVlODZhZi4uMmUwNjIx
NzgyMjJlIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KKysrIGIvYXJjaC94
ODYva3ZtL21tdS9tbXUuYw0KQEAgLTM3MDUsNyArMzcwNSw4IEBAIHN0YXRpYyBpbnQgbW11X2Fs
bG9jX2RpcmVjdF9yb290cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogICAgICAgIGludCByOw0K
IA0KICAgICAgICBpZiAodGRwX21tdV9lbmFibGVkKSB7DQotICAgICAgICAgICAgICAgaWYgKGt2
bV9oYXNfbWlycm9yZWRfdGRwKHZjcHUtPmt2bSkpDQorICAgICAgICAgICAgICAgaWYgKGt2bV9o
YXNfbWlycm9yZWRfdGRwKHZjcHUtPmt2bSkgJiYNCisgICAgICAgICAgICAgICAgICAgIVZBTElE
X1BBR0UobW11LT5taXJyb3Jfcm9vdF9ocGEpKQ0KICAgICAgICAgICAgICAgICAgICAgICAga3Zt
X3RkcF9tbXVfYWxsb2Nfcm9vdCh2Y3B1LCB0cnVlKTsNCiAgICAgICAgICAgICAgICBrdm1fdGRw
X21tdV9hbGxvY19yb290KHZjcHUsIGZhbHNlKTsNCiAgICAgICAgICAgICAgICByZXR1cm4gMDsN
Cg0K

