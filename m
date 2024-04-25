Return-Path: <kvm+bounces-15990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B46B18B2D29
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C6B72833F4
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529AE156242;
	Thu, 25 Apr 2024 22:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kW27WcSs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419A414D71D;
	Thu, 25 Apr 2024 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714084480; cv=fail; b=MozW6fXICLsGnYpzHoV5VqoSv9dFws+r5a1AiH7FKDXfSAEySJ104fzaLIhjS/LpzgCiWzj4Sx699QVXTZNibl2PuPXZ57VdE8ktfKD0njoRyp/MGF3WGzeQ/BPpjaTQymxNes14Ko06sRlRdcO2fev6jQyfe/3qSnJUP3LiG/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714084480; c=relaxed/simple;
	bh=EEE6171FkqJjNr3uxAdf1aGTDhLReoAiw6prRrht8FE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hSkgLd9hWPuAC/QLmNLrSush9ZdDizB6Y+mtCnScpv87aRUIX6Ny6uI3PMYk0RN/VsMsTK21JuDsUOKEFQkIZjnSNyOkO7Kn65zume1/aDMrwD33pjjPtR1IMrEr3oGsWV1HfBRr91sHQE0f6MxerB+1/faXfXKIoG9TIaJ9l/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kW27WcSs; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714084478; x=1745620478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EEE6171FkqJjNr3uxAdf1aGTDhLReoAiw6prRrht8FE=;
  b=kW27WcSsDkoxz3asioWIJvL1Z0G8C6GpuSHBkK9UHjbpdoPPbTWshScq
   onwuYZJunNKEblrIcsHZ2dgyz/3GDldWtCc1bV6gP8L4LIoaHmZB8d4Rl
   WwNmtLcRZpeMSzabu09oP0BMD7Q5So8S23her1L71kcOuMOHLkoQyQF9X
   Np/kzr4oCpaPTYZ08kHZpx9Itq9m0GjE3mxnHaq0LLzBqEGQvmYS0GYIH
   /lybKuPiNmtL4ismLMx2SWmFZZeb4XJXgm+CE53B0keLDsZXF7ySN1RMb
   pwn7jDDdfmr7r1FsicSiDVf3B/V5MnVe6OV6k+WCb9dT41qq8pYJhX53h
   g==;
X-CSE-ConnectionGUID: wNnuHRjRRheLoDwEDtVmAQ==
X-CSE-MsgGUID: K5CmJmmdTEGke7ogNsborg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9639923"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="9639923"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:34:37 -0700
X-CSE-ConnectionGUID: bX7PxjG3TvytpDscp8oO5g==
X-CSE-MsgGUID: 4q9mI4iDTmu5vwR3YgfFtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="29696414"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 15:34:37 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 15:34:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 15:34:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 15:34:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpOHjGjJlwr57/fl0+FdaC6an5wvZ0Twwf4AAos4UKifOvobGXvpOisKrxjNP7whg+kllVlo5TaBHKi07Whz8s14qHNNv/KXwKvT8XwDAfgAue/i4QDZGQWZ4fRcyF/P8ce5x5MfoBv4yQiME8HtlL8VZRQTcx08awuVeJyyzBTT5o29dvoSOC8+yt1PiJqOeGwgBq8Z0KXFodT6ato9sBRamJnEH8m4dsECrMdifpgBPCONI1NGxOwA+O0gNWIMLT801ckNMnFfTgldUZiuz7+LBwLfkpry4XkZWcpeuVugeOXQ+hGvaaZsFNrAo4zMcwdeIP6urMnuUx8uwQcMtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEE6171FkqJjNr3uxAdf1aGTDhLReoAiw6prRrht8FE=;
 b=niH0CbQUl+PjzadK4DtRTndEFBPHqwwq86xvMvnpwRlDGxT2nT5Y7ujzBD+XOTTfV0OLUj5/TSgdVGnAg8wkmHM5iOicFIoHxMQ6JCBLOEit6S3j7+RJwagc94g7qquf+sFtlQOHVuJawVnA9HOEbYn+PDQjo3c0yGR6BF1tnJxBZZU3n28+Oy3hvRswsTOmP9Df7bvdcyEvNMb+4FSRCP4Ie8uHgQ3yytnfZpzJNAJlnh5l7zT5rZxedRJtxngNJUfM/k2oVunGhCWGvXzNJFtSf/Y4riv16ZXZiuR0gC56o1rSCP+ZK3ybiUSY444FB+8WaSWNksx/c3blrjbjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Thu, 25 Apr
 2024 22:34:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 22:34:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIAACF2AgAKvtYCAAGWPgA==
Date: Thu, 25 Apr 2024 22:34:33 +0000
Message-ID: <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
References: <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
	 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
	 <ZiqFQ1OSFM4OER3g@google.com>
In-Reply-To: <ZiqFQ1OSFM4OER3g@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB7608:EE_
x-ms-office365-filtering-correlation-id: 6222a665-7b3d-4c7b-9324-08dc6577e10d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Y1BXaVhDRzVmRDQvcVdxVk1OVHZ0aFpkRHRyek5YcFJBNDBoTkVjRHJOZlBH?=
 =?utf-8?B?MDFFM3o3RG9sUnowdXpONkNkUkFnTVg4Tmt4YkYvYUdoU0dQMUxvQkpIT0Jv?=
 =?utf-8?B?dHREUjl3RUhQWDRtV3VtNDBMMFhZc2drTVhIV1JWalV2KytJNmF4aUpsY0Ni?=
 =?utf-8?B?cEd6cHM5VGRMQzdQMHo4R1Q4QkxVdjVVL0MwVUV4eUowY1c2algxbUE0Vzdi?=
 =?utf-8?B?YlliWkpRV0FuVks1MDErMEUvb0thV1FwM3JOMjc1ZFc0dkVhbzBFeU50MjJ1?=
 =?utf-8?B?b0FvR2lNUUF5RXhiNG9lQXpMa2E2SVR4Qzd5WkRXNENHOVBrdngwcm56V2ps?=
 =?utf-8?B?ZEowbHFUUGtYekR1NUtWOTBKTm1RYzJDaEFBcE1XUUdXQXFZcDBwV2VzSFQr?=
 =?utf-8?B?dVdaYzgwZmttT2dvMFBaN0psY290aUFUOUl4OHN3UmFCTm0yNGxRZ0NnN3du?=
 =?utf-8?B?Y2taaWtHWmpGaFdnYzFaZVQycXBNN1E2elVsR0VzTDJiMERTTE1pOFNHQmdF?=
 =?utf-8?B?ek52WTVnMG1meGNpTlQrd1RKMmt6dlRPNHFtakJkTkNJZ1BKcEZGWGFleWs0?=
 =?utf-8?B?b1FHNFVscjBuOWx0ak50VmU3NnBnT0Q1WFBQTnVrK3dUbnUwa0lGV2lEZ3ZK?=
 =?utf-8?B?T3JBWjZPZms3dk44cnBkTmtGZUVlUFBSVVZCK3diYkNIZVlvTnNzMWhwcDBS?=
 =?utf-8?B?RGxGNzlhb3pLdFRsTDJ5WG1zczhyUEc3UnN3a2txWUVWaEhzeWcydFRjOGhl?=
 =?utf-8?B?alBVWHpRZE9OUXRDdDFyWjJnd2FhaU1JQVNQeURQSmNoajZGUlZoQVJXWm1J?=
 =?utf-8?B?a0Y1b0VwOXltVGZiWHE1SjR5allTS3BPT003TUY1bHN1Z1JhWUpFdVArY2N3?=
 =?utf-8?B?OTlzSU9kVnRJOHV0WTc1dnVjSU9pSnNReXdESlNkQW4vRzhIdmt5REpmZVM4?=
 =?utf-8?B?N2R2L3BhT1RvcHNGQmNrUjNuUG5YaWM2K0xqUTR5L1l2aGRHS3hwd2E5Vkg2?=
 =?utf-8?B?cTlqY0FDL01RcUF6RnFVMHA5VUczdDFjWTBFLzlUVHA3RURWTlRQSFNzOUNG?=
 =?utf-8?B?Ylpja2FCR0t1eitVVFA0YmppV3U5TkZpVjcvU1l6aE5kZnJXcEU3ajJua0pY?=
 =?utf-8?B?eW9HcGM1K01pc2ZNemtLR2lmbWZaejFPZUJaQUE5dU5rYWdtSnpWb2NEWUNG?=
 =?utf-8?B?Mm8zVlZZRDJIeDM4aGJSUGQ4U1VoTVMxd0pQL25HZEhoOWVwUjF3empJNkNC?=
 =?utf-8?B?Wm1QWEREUC9YMGlROTk0UEFmQjR4VGJaSUo4UHlIWktTb1QxUTVkVG5xNmtY?=
 =?utf-8?B?Q2VRM3BnMGtsa2p0TUpQWGZ5VjdrN1pnVEV0RERkOVNFUFY2VUlsd3dwMUla?=
 =?utf-8?B?UVArU1NBN215RzhVL0RvVjAzZzdVa0M2UmVabzhJZDJIQngvWkFlb3JicXBs?=
 =?utf-8?B?dWRrWkY3L3g5Q3p6eFN5ZEJhMjdXU0V0eXlHU3F0TGhYREd0YzF1VC9Wdzht?=
 =?utf-8?B?dGlJTkpVa3lja0ZmTGs2LzZwTmFmTW0xakZ1dGpzSW9Fcm00Vk95bkxwVVlv?=
 =?utf-8?B?ZXlCZFRtMmlMdUEzRHRZWG5CWkt0Rmp1UUF4OUhYcnk4R2lQK0IrVzE3aVI3?=
 =?utf-8?B?bEJNRTAwcGtLQU9mbmNiKzIxQzNVRkw1OExpZ3l6Rnk4bjNTRlJhcjBYTTVD?=
 =?utf-8?B?QmZnQlBESVYzS2lNMUp4Zmc1Vk1XNU80eVdacWpVcGM4WWVLclFMZkdwMmQx?=
 =?utf-8?B?TjFCY3MwdVo2eWtMRTdjOUtiZWtGMXhQZHdDaHdqNzhEMy8yR2hWWTAvK29T?=
 =?utf-8?B?emJPL2hKS09lSGl4cTVaQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGMwQkFCQUQzc1ErM002L2tOeUJQamdVWXdiRmtpOHZwYTVqTGcrc0MvMzRr?=
 =?utf-8?B?OEhKVDZhSHRrUTgzWGlhZWdCS1ZmeE9mblpYajFqSnViVjFYS2tXT0tXSjk4?=
 =?utf-8?B?T3htUldGMnlEMHpuS29mQVdTTVJuTWxnekMvdHRxdlJNQzBXYitVdU4vSTBx?=
 =?utf-8?B?NlM1Q2FiTlg0Y2NBcUJyMlF6WHU4SjNBQTVSei9vSTJ1QlVKMGZxOVhUMUJ1?=
 =?utf-8?B?U2M2YkNSTFl1YkZ4eG9YdmplNms1YUthYkFKU1dLTFdieGFhVmt0eU54bHZ0?=
 =?utf-8?B?KzB2aTVFa2xueTNNNkM4SGRmOVByRkJPQ093WndlenlYZVErV0tIKzNsbEZG?=
 =?utf-8?B?Yk02NWtWZ2dJbVVIUVU3aXl1SnRzbGpkUWVpOHVwY1lMNEhhendPMHh0c1N4?=
 =?utf-8?B?Uys3aEJPaUJ0NzErUmlkWjlpV0UrN21nTThWbjhINm1HaEMrNlF3YXhVaGNE?=
 =?utf-8?B?UVFwcU5TLzZ5QWs1M0F1WVJ1dDFqUzRWajhVc2NIY3dnM29wcXNoeExWMCtR?=
 =?utf-8?B?QURENnVsSFZmTWhwcXpabG5lWisrZ3h3L0x1Y3p6aFlMMzVLZDVPUENTbTh2?=
 =?utf-8?B?bUU1K09Jb2grNUI4OTI2OXRWTVpyTDVtZjh6ektnQW1UbmVBVW03WU9SNy9u?=
 =?utf-8?B?eExIVXlxMkJIWW03ODNrTXpvZXpYVmV6TGpqNlZRbkh5d1g2dDA1a1JWR1RQ?=
 =?utf-8?B?U3VjOUJENHVZTEp4RjdVOVhVY0Q0YnV2ZkVqWWdOQXhhUFdCUGZlNllqZHV2?=
 =?utf-8?B?ZzVNUGtoMzFRMkpaSnpIREppWGpTUjFCRitUY0c4S3cvSkphMUZVb0JXVkhQ?=
 =?utf-8?B?bUhKMEZ4M3JidnI5L0VlaVhWNmIrQjVnZU9pN1hMRm5uRElzUmpoZmtUVE1S?=
 =?utf-8?B?WFhkVG5QMlZOMm85Sk5hc2k4NHJ2dUlXRlpFekpUK0gzbEdpMkZpbk5NUnM1?=
 =?utf-8?B?Q0gxTmlVZUdQQVNwaE5sSEZRQ0EyOGc5ZWhaVHlTcVpVWXFZUnI1YUVyTlFm?=
 =?utf-8?B?YU4xQ0dXOUY5YWowb3piakxWU1dLSDJZMHNVcEQ2QVdDa3lRdlNKR1Rrdi9Y?=
 =?utf-8?B?UDR1YkRVZkQ2UWV5TUsvRXlCMm9ldkdaSTRTU0FYTTF3Wms1RW9oWVo3TWhO?=
 =?utf-8?B?MXhxQnNTNytjTVBGOTJHbDF4YTJCdFNLdlYzTWZMaWkzU01vWnFiNDNhTG1F?=
 =?utf-8?B?WVJIcjBhNWxxT3lvNm5NZ1A2amhXQ1NTTDR1M2YwNDFqVDFLY3p0dzFEY0VL?=
 =?utf-8?B?dWc2KzRad1RxSGtuM1BSYlVMdERkWks3N1dzYWVwY3ZUZlFvZ2RyNXlVUUZK?=
 =?utf-8?B?c0dISTY4eTV1RnF5ajU1QVhEa2NaSlFaaHhCaFZLVWxsQWdSdEQ2Z0VqSTYz?=
 =?utf-8?B?QWZBK0d5K2xTSlB5cGV0ZjZNbUgya1h6T1ZHbDFUQkt1YVAzcEZZSjhtaTc4?=
 =?utf-8?B?R2RmMUc5ci9vRnFEVHNNdHZKSHcrdndJbGVOTlhtNmhOZDIvUDZBWGt4dTdv?=
 =?utf-8?B?QVlBaFhqS05KNlZrQVpMem9Tai9KSVNUbXI2U3ZGN0ZHY0xjckxQcDM5VzJQ?=
 =?utf-8?B?MFZGUnpuVmJXOTJJcm5OQXlBK1IwMk5NR01HNHpHZ2lvU0xULzcxR1BhQzlV?=
 =?utf-8?B?SGZvcTNYd1hFcnZjbWpyWW4yRFpGTVVud1dvRS9BRCtlSGdQZXovWCtRQ0Nu?=
 =?utf-8?B?R21TcmU2SWpuMWc3WVdQMHNaTGw3WlJxVWtaZFBZMCtPbytQOEZkUGZrRE9O?=
 =?utf-8?B?cVdETkRyZTljZ0VDa1o1K090bEpJM1lwdFNvcUI2QnIxWi9QR3MxNyt6RU9C?=
 =?utf-8?B?KzQ5TjQ0MTNGbWN5dGRndDVsRUVhc1I3S29YY09FckUrTWwwZWFIUmxQL3Jq?=
 =?utf-8?B?U2ZYdUFUdlNnSE92RDZJbTNicjNnRC9KY3RxQXRzdjlNYS9iK2txODM1dy8y?=
 =?utf-8?B?bE5kWU93UGVwUXQ2Qm1EVEFPZk9TMHRTc0FhNjI2eWxqdjRqQlV5RURIZkFu?=
 =?utf-8?B?enNWRDU4dDlmZkpwaDBORlZHdjJyTk5NZHY2WnUyQWNhMjFLMFRoNFliVlhj?=
 =?utf-8?B?UFZ1VzUrYldxUURnYmFRamtaODV6L1BPVkJkci9HdmVjcmVBS2pQTzJaY0lj?=
 =?utf-8?B?Tng3a0U4Um5LQlEvcDVQSWw3aGlKTDNFS0VpdHNHanRVUDRPeFVHbjVtK0lj?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44EAF10E3845D942B43EDFBB867FB2F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6222a665-7b3d-4c7b-9324-08dc6577e10d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 22:34:33.0697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i4FTItqffW4G2a4EcstW5azi0dSpKBc6aS3U6gHqd6zmX/mDKQ+Dpe9s7cB+XzITWwF8w1N4z4CyqU8Ffe6IzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDA5OjMwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAyMywgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNC0yMyBhdCAyMjo1OSArMDAwMCwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiA+ID4g
UmlnaHQsIGJ1dCB0aGF0IGRvZXNuJ3Qgc2F5IHdoeSB0aGUgI1VEIG9jY3VycmVkLsKgIFRoZSBt
YWNybyBkcmVzc2VzIGl0IHVwIGluDQo+ID4gPiA+IFREWF9TV19FUlJPUiBzbyB0aGF0IEtWTSBv
bmx5IG5lZWRzIGEgc2luZ2xlIHBhcnNlciwgYnV0IGF0IHRoZSBlbmQgb2YgdGhlIGRheQ0KPiA+
ID4gPiBLVk0gaXMgc3RpbGwgb25seSBnb2luZyB0byBzZWUgdGhhdCBTRUFNQ0FMTCBoaXQgYSAj
VUQuDQo+ID4gPiANCj4gPiA+IFJpZ2h0LsKgIEJ1dCBpcyB0aGVyZSBhbnkgcHJvYmxlbSBoZXJl
P8KgIEkgdGhvdWdodCB0aGUgcG9pbnQgd2FzIHdlIGNhbg0KPiA+ID4ganVzdCB1c2UgdGhlIGVy
cm9yIGNvZGUgdG8gdGVsbCB3aGF0IHdlbnQgd3JvbmcuDQo+ID4gDQo+ID4gT2gsIEkgZ3Vlc3Mg
SSB3YXMgcmVwbHlpbmcgdG9vIHF1aWNrbHkuICBGcm9tIHRoZSBzcGVjLCAjVUQgaGFwcGVucyB3
aGVuDQo+ID4gDQo+ID4gCUlGIG5vdCBpbiBWTVggb3BlcmF0aW9uIG9yIGluU01NIG9yIGluU0VB
TSBvcsKgDQo+ID4gCQkJKChJQTMyX0VGRVIuTE1BICYgQ1MuTCkgPT0gMCkNCj4gPiAgCQlUSEVO
ICNVRDsNCj4gPiANCj4gPiBBcmUgeW91IHdvcnJpZWQgYWJvdXQgI1VEIHdhcyBjYXVzZWQgYnkg
b3RoZXIgY2FzZXMgcmF0aGVyIHRoYW4gIm5vdCBpbg0KPiA+IFZNWCBvcGVyYXRpb24iPw0KPiAN
Cj4gWWVzLg0KPiAgDQo+ID4gQnV0IGl0J3MgcXVpdGUgb2J2aW91cyB0aGUgb3RoZXIgMyBjYXNl
cyBhcmUgbm90IHBvc3NpYmxlLCBjb3JyZWN0Pw0KPiANCj4gVGhlIHNwZWMgSSdtIGxvb2tpbmcg
YXQgYWxzbyBoYXM6DQo+IA0KPiAJSWYgSUEzMl9WTVhfUFJPQ0JBU0VEX0NUTFMzWzVdIGlzIDAu
DQoNCkFoLCBub3cgSSBzZWUgdGhpcyB0b28uDQoNCkl0J3Mgbm90IGluIHRoZSBwc2V1ZG8gY29k
ZSBvZiBTRUFNQ0FMTCBpbnN0cnVjdGlvbiwgYnV0IGlzIGF0IHRoZSAiNjQtQml0DQpNb2RlIEV4
Y2VwdGlvbnMiIHNlY3Rpb24gd2hpY2ggaXMgYWZ0ZXIgdGhlIHBzZXVkbyBjb2RlLg0KDQpBbmQg
dGhpcyBiaXQgNSBpcyB0byByZXBvcnQgdGhlIGNhcGFiaWxpdHkgdG8gYWxsb3cgdG8gY29udHJv
bCB0aGUgInNoYXJkDQpiaXQiIGluIHRoZSA1LWxldmVsIEVQVC4NCg0KPiANCj4gQW5kIGFuZWNk
b3RhbGx5LCBJIGtub3cgb2YgYXQgbGVhc3Qgb25lIGNyYXNoIGluIG91ciBwcm9kdWN0aW9uIGVu
dmlyb25tZW50IHdoZXJlDQo+IGEgVk1YIGluc3RydWN0aW9uIGhpdCBhIHNlZW1pbmdseSBzcHVy
aW91cyAjVUQsIGkuZS4gaXQncyBub3QgaW1wb3NzaWJsZSBmb3IgYQ0KPiB1Y29kZSBidWcgb3Ig
aGFyZHdhcmUgZGVmZWN0IHRvIGNhdXNlIHByb2JsZW1zLiAgVGhhdCdzIG9idmlvdXNseSBfZXh0
cmVtZWx5Xw0KPiB1bmxpa2VseSwgYnV0IHRoYXQncyB3aHkgSSBlbXBoYXNpemVkIHRoYXQgc2Fu
aXR5IGNoZWNraW5nIENSNC5WTVhFIGlzIGNoZWFwLg0KDQpZZWFoIEkgYWdyZWUgaXQgY291bGQg
aGFwcGVuIGFsdGhvdWdoIHZlcnkgdW5saWtlbHkuDQoNCkJ1dCBqdXN0IHRvIGJlIHN1cmU6DQoN
CkkgYmVsaWV2ZSB0aGUgI1VEIGl0c2VsZiBkb2Vzbid0IGNyYXNoIHRoZSBrZXJuZWwvbWFjaGlu
ZSwgYnV0IHNob3VsZCBiZQ0KdGhlIGtlcm5lbCB1bmFibGUgdG8gaGFuZGxlICNVRCBpbiBzdWNo
IGNhc2U/DQoNCklmIHNvLCBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhlIENSNC5WTVggY2hlY2sg
Y2FuIG1ha2UgdGhlIGtlcm5lbCBhbnkNCnNhZmVyLCBiZWNhdXNlIHdlIGNhbiBhbHJlYWR5IGhh
bmRsZSB0aGUgI1VEIGZvciB0aGUgU0VBTUNBTEwgaW5zdHJ1Y3Rpb24uDQoNClllYWggd2UgY2Fu
IGNsZWFybHkgZHVtcCBtZXNzYWdlIHNheWluZyAiQ1BVIGlzbid0IGluIFZNWCBvcGVyYXRpb24i
IGFuZA0KcmV0dXJuIGZhaWx1cmUgaWYgd2UgaGF2ZSB0aGUgY2hlY2ssIGJ1dCBpZiB3ZSBkb24n
dCwgdGhlIHdvcnN0IHNpdHVhdGlvbg0KaXMgd2UgbWlnaHQgbWlzdGFrZW5seSByZXBvcnQgIkNQ
VSBpc24ndCBpbiBWTVggb3BlcmF0aW9uIiAoY3VycmVudGx5IGNvZGUNCmp1c3QgdHJlYXRzICNV
RCBhcyBDUFUgbm90IGluIFZNWCBvcGVyYXRpb24pIHdoZW4gQ1BVIGRvZXNuJ3QNCklBMzJfVk1Y
X1BST0NCQVNFRF9DVExTM1s1XS4NCg0KQW5kIGZvciB0aGUgSUEzMl9WTVhfUFJPQ0JBU0VEX0NU
TFMzWzVdIHdlIGNhbiBlYXNpbHkgZG8gc29tZSBwcmUtY2hlY2sgaW4NCktWTSBjb2RlIGR1cmlu
ZyBtb2R1bGUgbG9hZGluZyB0byBydWxlIG91dCB0aGlzIGNhc2UuDQoNCkFuZCBpbiBwcmFjdGlj
ZSwgSSBldmVuIGJlbGlldmUgdGhlIEJJT1MgY2Fubm90IHR1cm4gb24gVERYIGlmIHRoZQ0KSUEz
Ml9WTVhfUFJPQ0JBU0VEX0NUTFMzWzVdIGlzIG5vdCBzdXBwb3J0ZWQuICBJIGNhbiBjaGVjayBv
biB0aGlzLg0KDQo+IFByYWN0aWNhbGx5IHNwZWFraW5nIGl0IGNvc3RzIG5vdGhpbmcsIHNvIElN
TyBpdCdzIHdvcnRoIGFkZGluZyBldmVuIGlmIHRoZSBvZGRzDQo+IG9mIGl0IGV2ZXIgYmVpbmcg
aGVscGZ1bCBhcmUgb25lLWluLWFuZC1taWxsaW9uLg0KDQpJIHRoaW5rIHdlIHdpbGwgbmVlZCB0
byBkbyBiZWxvdyBhdCBzb21ld2hlcmUgZm9yIHRoZSBjb21tb24gU0VBTUNBTEwNCmZ1bmN0aW9u
Og0KDQoJdW5zaWduZWQgbG9uZyBmbGFnczsNCglpbnQgcmV0ID0gLUVJTlZBTDsNCg0KCWxvY2Fs
X2lycV9zYXZlKGZsYWdzKTsNCg0KCWlmIChXQVJOX09OX09OQ0UoIShfX3JlYWRfY3I0KCkgJiBY
ODZfQ1I0X1ZNWEUpKSkNCgkJZ290byBvdXQ7DQoNCglyZXQgPSBzZWFtY2FsbCgpOw0Kb3V0Og0K
CWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsNCglyZXR1cm4gcmV0Ow0KDQp0byBtYWtlIGl0IElS
USBzYWZlLg0KDQpBbmQgdGhlIG9kZCBpcyBjdXJyZW50bHkgdGhlIGNvbW1vbiBTRUFNQ0FMTCBm
dW5jdGlvbnMsIGEuay5hLA0KX19zZWFtY2FsbCgpIGFuZCBzZWFtY2FsbCgpICh0aGUgbGF0dGVy
IGlzIGEgbW9jcm8gYWN0dWFsbHkpLCBib3RoIHJldHVybg0KdTY0LCBzbyBpZiB3ZSB3YW50IHRv
IGhhdmUgc3VjaCBDUjQuVk1YIGNoZWNrIGNvZGUgaW4gdGhlIGNvbW1vbiBjb2RlLCB3ZQ0KbmVl
ZCB0byBpbnZlbnQgYSBuZXcgZXJyb3IgY29kZSBmb3IgaXQuDQoNClRoYXQgYmVpbmcgc2FpZCwg
YWx0aG91Z2ggSSBhZ3JlZSBpdCBjYW4gbWFrZSB0aGUgY29kZSBhIGxpdHRsZSBiaXQNCmNsZWFy
ZXIsIEkgYW0gbm90IHN1cmUgd2hldGhlciBpdCBjYW4gbWFrZSB0aGUgY29kZSBhbnkgc2FmZXIg
LS0gZXZlbiB3L28NCml0LCB0aGUgd29yc3QgY2FzZSBpcyB0byBpbmNvcnJlY3RseSByZXBvcnQg
IkNQVSBpcyBub3QgaW4gVk1YIG9wZXJhdGlvbiIsDQpidXQgc2hvdWxkbid0IGNyYXNoIGtlcm5l
bCBldGMuDQo=

