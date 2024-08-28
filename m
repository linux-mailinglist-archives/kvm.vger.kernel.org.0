Return-Path: <kvm+bounces-25260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61913962A56
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 16:34:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12AE92829C5
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 14:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAFE19AA75;
	Wed, 28 Aug 2024 14:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e46FAKEf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D61684A0;
	Wed, 28 Aug 2024 14:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724855670; cv=fail; b=puch3eajM7/o9bw7EQIMQQvxHjIie4hHlTpBX0WzokZUuJb4Dr/X7qPeB/PnrpOX9ti9Cm1FVHsCz2+MpixiuRGJ0foAfA5kotbSzgXA7D8OOEFXtT6aWJBM0+bf2WPuFlYP/DKPQokj1sO1Hfaqxr4weyDOvQbFjX3iqMxdW48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724855670; c=relaxed/simple;
	bh=w4QVkpeSHQpIFlLZn5J4XQCMRVies+kpRV9fa/pDhX8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m4sG16XAAXgBiNI7bKVsTAd7M+55CB4TbH0QQ2IN7nJJUKj6GZtgKJ03qgS8WvQ3ht1FW87ckzCjH2T6fXLurgnjem58EcAr5a2Tl17OlwhuCJARTjXmcCE2tNZlQ5rfmB6T+AVQNxxyHI1HmVZMDKWwARs7aTRoeojmHqm72hM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e46FAKEf; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724855668; x=1756391668;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w4QVkpeSHQpIFlLZn5J4XQCMRVies+kpRV9fa/pDhX8=;
  b=e46FAKEfYZ+8VNchACm4iHMLgTancwhqaZowJCbvnXt50XL8qqyLMFE7
   G9+rKBZS1Tdfz9L2LAeHHwY6X5m/7gWKMMpCwJAgAnz9Xm5CdJx1mF1k5
   232agJk0hjdUYnaE7IDUtPOgA9gRcYdiAmSgR6q+EBRMwxBLMkQKSUb0u
   /UH1adjcQ6HOLAAXL4d5/ijEwAhOFayZ2SwFUSO74IHoiVCMC6SsDkAOb
   GLU/dXHcMmZsy38znN9EJLrBVi6UkPGhO7GJPGQlFQW6eGOGY/fKtQW0I
   3PZB/vVYPAW712Bw4vjJ2M2NcGxkgWIy12awvn9EAWPnlyczP6KlCaoom
   Q==;
X-CSE-ConnectionGUID: kwbI4XcaSeeAFoJJMAhepA==
X-CSE-MsgGUID: sP6xyj4hTjqQYFJKb4APGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="33958394"
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="33958394"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 07:34:26 -0700
X-CSE-ConnectionGUID: MmMLiTwpQduJ6FuHluTQlA==
X-CSE-MsgGUID: HnZ74E3lQYuTgz4Ce9+9Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,183,1719903600"; 
   d="scan'208";a="63425872"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Aug 2024 07:34:25 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 07:34:24 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 28 Aug 2024 07:34:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 28 Aug 2024 07:34:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 28 Aug 2024 07:34:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dRo8Vd6jFenm9KdpMNzgX3VukRP/JoICWYDPtlAZvUodm5hrRuCGH7TGa3oX3szPOJiB91+XKUWMeWVQlWaVYG93X3l9gbUzbUnd/CbwJA+DDRYbweTtqEbrUErnH/BuQpzjeqsz7Z/mbO6YXn0VRIJ1KWE3XDIHrk4OXNFrGu2DBiQwMpQpLwCDIFLk3pdSwQeAdE9NcDGOhMT9F2uhICnl4vt0k6ApuFYX91Fx2eWiOhLahUnzThfELPbXcPpyuRnuD28AaqjOsn3226CQUtMwWMtUP/tHQvQYErXii/jPaVRX3uHB2wmWczPH8sOw05VrixQliMEYmViI7h/LAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4QVkpeSHQpIFlLZn5J4XQCMRVies+kpRV9fa/pDhX8=;
 b=fHFXxa6pA/dJd3cOLWsNb8AJ80+T7G1I59ye54LwH7US5cewRqCpYUhLCsUcN5kPNhsQld5kZQVccC2Nd8yVIzD5In0rXVeF4QBafxffugY6vM1Yes14SyiqwdFkIU5kGSD3lPBZrek4ewGyp4KGXINjPARSXnrtbPJnDfaZBdkIRdqlj3MHthT97BZiOGx0Ej26+FBzWlyfkibpVt9DQcPRfIpni0OtPUzfz+ktHJHF1luoafEu6ddLDnwkfB6a7P0JOn3g/GHllQBLiBtPVUA5v5NWkIbvGiZPyEG+Oru7a4WhA9kXcAmU9NrXRKgNIPJeCspRzxfCBfmC87QWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7939.namprd11.prod.outlook.com (2603:10b6:610:131::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Wed, 28 Aug
 2024 14:34:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 14:34:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Topic: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Index: AQHa7QnTM8YJSmcK70mWBvdOl91Ku7I81KqA
Date: Wed, 28 Aug 2024 14:34:21 +0000
Message-ID: <bb67e7315b443ad2f1cf0b0687c3412b9224122b.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
In-Reply-To: <20240812224820.34826-19-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7939:EE_
x-ms-office365-filtering-correlation-id: 3b9f7ff5-75b4-4278-2751-08dcc76e81ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aXRKRjJCaGY0b1FnR2tBZ3RiZEdEQjZHT3VYQjlVZ1hYSjQwN2hXZks0bzBz?=
 =?utf-8?B?eE12eTZJUUFsUmszSFdPbGFVdnFMY2NKOHpnTEMzOTRSZDBmeVN0TitOQW9N?=
 =?utf-8?B?eGFQMFp2dUJreFN5TVY0d3UvQXBLd1VUTnhMTWRsWWZiSUwxUk53NDFIbjBY?=
 =?utf-8?B?OFIrYmQ4SWo0Sk9GeDhSUUpvdmN4TUo0Y1ZPVVZZMXJLRFFQWEkwbk5nSHRK?=
 =?utf-8?B?MjRZTVFjR0hJR2VoOUFrdlR1L2U1eTBLV2NYa2xGNlVWYlhucVNnd2Z3VkY4?=
 =?utf-8?B?eGhuY3htWFJuQTZzSnpiZ1cyWVVNZjE2UFFHbEY3aHBLYUt2K3AxdlYwOE95?=
 =?utf-8?B?alJhUXNKUmV1Qkl2M2pJajNmWTBpaEpVejg4Sk14d21DNFJ0anBYSkZWSXUr?=
 =?utf-8?B?NFlrUXg2OFBUdE5ZQVNxcmk4WmdFWGx0Szg2djBCRlhqeWhaN2tGM2REeU1G?=
 =?utf-8?B?bmFuQytONjZObFl1SVlwMlVXOU9iSlFQUFhTWnlMcmFaTWZ6d1o0MHVRKzlY?=
 =?utf-8?B?ZWhiRGgwNGV4OWd3OGpNMUtOY0had1dtdGhkU0djdnRDWUdxUjRxQXdhbWVI?=
 =?utf-8?B?S2MzQU5YaUdKTGdVY2NVUFVBbHM1UVREdEVnNzJPeG1QeTAzQVZyMUFINndr?=
 =?utf-8?B?L2NvdXhsMFR4SmorL2ZJb0FEbER1TTFvWTFONDE2QzFKN3crKzVMSkhuaVVH?=
 =?utf-8?B?QVpWZWJreDRJUWg1b2N6YkF3YmtFN05WelB0VUorSG5QL29SbURMSWFsRE5m?=
 =?utf-8?B?YXdzd2lFRUxCRlE0SFQ0bWlobWltK1BuR0lNSXJzK3pMYzQ4SkZ5bFBVSDB0?=
 =?utf-8?B?eElncFRhRFgyR3FSK2paa1FpNmd3bUlSd3VUUmdSdUdteVc3Q0gzMDl3ekFq?=
 =?utf-8?B?QThpcnhFS1ZuaVJ1MzVNN0VxZVhWTVZwaUsxbHFBUVZEWEdoRGdrQTFsQ0w5?=
 =?utf-8?B?Y29VcXorVHRjaUtBUTczQ29iK0V4OGl2WnVVL3d4ZUt3MlBxYXVlb1hiYjR1?=
 =?utf-8?B?TG0xcWtUbDdVYm9FMGorU2ZjcWMyaVNWY1RtaEFsbUx1b1JsWkRyYW5wQVk1?=
 =?utf-8?B?ZG9hWlg1Q1U1ODNEaHI3V29POUUzYklOQklacGVQeWg3dFZNTTBPb3RSSS80?=
 =?utf-8?B?MllHNjZNR05GVWhQYWluZmx4Y1d4WnZ0cXlRM0F2M0lXNW9GOGc3ZEpsb05V?=
 =?utf-8?B?SW41R1BSWk85aU1jRmJnT2lDRWs5eVgwdkNiT1BBZXk1Yk1qUGliQURhV3I4?=
 =?utf-8?B?N2hOY0Z3R0N3MXU5V1VRQ0RFUzJpcW5TdUNGeFhQNXdXT3FJOERvTlc1eFRT?=
 =?utf-8?B?UmtBUHVDVW5SU2JVQUdBT1NuRnZyRGgrQUc2Z0dsalZVWkpKTlZVTjJvYktr?=
 =?utf-8?B?eVZyZnFkUzU2Q1Y5VXI1VGE0NU9vZk41Qng2bHhZdHN3MW0yY3ZleEZLOU8z?=
 =?utf-8?B?NUhlVzVWUG1QMVUrLy9FQUVIUTVpM1YxNUI0WVhCdTFYeXU0Q0dYRWVwdDEv?=
 =?utf-8?B?aUJ6aExkNlZtaG5xUC8zR3ZLNkVKSWtCWEtIMEcwdVhjSnNCNjU2OXN2VHBP?=
 =?utf-8?B?TGR2OU9DYjN0RzVGVEVMck4xY1NPZ29xdzh1bVhEa3VPVjNsVmtOajM3a21Z?=
 =?utf-8?B?VkZJaERGTm5vUzNvWmV4OUQ1eWdhalpsWitWM2lxSmJtaHZCYkh1MTBmTzJ0?=
 =?utf-8?B?bHVaN3I3R1AyT2RHb3BtT0F3aU91WEpsTFJrRDhHSjBMWEF4OEhrZTdUbE9D?=
 =?utf-8?B?M2tWN0lQT3NLaUI1QU9TMlZ0bVhPTy93RTYySlhUZDJWVHM5KzJ3M28yeXl1?=
 =?utf-8?B?V1NnTFgrdVVHVWdpNVAva2wvTE9vRTNmNk01N1VzTlhjYkVBQVJoUThFUVI4?=
 =?utf-8?B?Y0g0ZG5tV0c1bkhIc1c5KzRWQW10ZW9DeFpuenprZTFLRWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWxwSnhZTng2NXZNei9WZWxUQ2U1ZkdUUGtkbjJ5RG5LMUhIUUdTaGI5NXB1?=
 =?utf-8?B?ZlIyS2l4RGt3TDRjcGkvaHhjVXF5WE9Sc0RhTGhOMGJQb0NPak9WbGEvbnh1?=
 =?utf-8?B?WnlQL1Zwam9kMjBYKzQ5dktHLzQvaDRTSEFDTWlrYXBxY3N5Mk1TYXQ4djkz?=
 =?utf-8?B?RytJNXZsWk5NUFIxcnlrVWZBaE5hbnVUQjdlUHRoU3lsR0xwNVBIVVhYUER0?=
 =?utf-8?B?a3hqbVFmRkdCVVpOQnNmNGVZTWtrMFgwY1BmNkFhSVkyVGVXUStNb2tVanQw?=
 =?utf-8?B?ajEvL1BoWlg5b2RwUW8rVnpDK1ZlNkI2Ujh5dDFVaWh0czVJYUxLYWtkbk5t?=
 =?utf-8?B?b2NRbUJSUkQ2eHRmTFNqNkExWlZ5RjFjdnUwQXVjc3dXa1llSUxzRXU3MXJU?=
 =?utf-8?B?dURJQlpvbUM2bW9zcnYwaUtaV0NMMGNlZVhEa2dzL3lJeGY4Qm5HZTVXSGdL?=
 =?utf-8?B?Uk1UdDdOa0tyNDV0TXhPR1R0Z1BhRHFyZTM3L01TZ3orK2lIemtlU3NKQ1BE?=
 =?utf-8?B?SWRaNm41N0NydFNlOVpuK1pjR3pwV1UxakFoMUk3V2pZemVXZkdmT1JqbW4z?=
 =?utf-8?B?MGd6TmpqbkI3Nlk0bHFOL3I3TEk0VVFIYy9OSHhRbEI4d0RzVGl4eEpHRnlv?=
 =?utf-8?B?UGFwUUROTUZNMEdwdFlUaVdvalVRLys5NVIwZEVkclhIZFNvaXg2RW9kSFFr?=
 =?utf-8?B?bXJGN0JvVHZCNHBzODY2RG50V1l0ZWdxYnJXQzVsNytLbFpTQTZsVzVLRlgw?=
 =?utf-8?B?ZVZIMFB3R3MrYW80VnJMVC9hWDk4enFFSmxleDBQVzg0MmU2Mk5obkQvSVRz?=
 =?utf-8?B?dXZ0eERxN1Rna3FmTjMrRVNETDdnL2pBeXRtWHV3aUI5UEpxMU9hSnZxTUFP?=
 =?utf-8?B?VGF5RzgySGZzeS83RkxpaXMzRFRzUW9ZdGhNajJWWXd6dUZ2TzkzRWI0ZVdt?=
 =?utf-8?B?clZHZUdsTmpvejVod0VZUnA5UUNEQmg2NkZDTm5IVkprQWVpVDJJMmhCNENk?=
 =?utf-8?B?WlZ0WCs1RHUxY1pOejJNdTlWZ2ZhQjhsbHRPNlAvVmszbmFOREt0amVwaHFz?=
 =?utf-8?B?MW9RbFR1cnZkZkNnL1V3akltSjJ1NWsreWsvL0hyTGZMUk9aZDVnUS91Q2NK?=
 =?utf-8?B?eVE5VXpRS1VWekdZUWhwRXFlUm1rN1hHbVUyTDlqcWw3dTJNMWhqQ0hjZ3ZT?=
 =?utf-8?B?YVQ4QmcxcHdSN3FFcEM1aXFFR2o4YjR2MHJmTm16dHN0SzlWdUlkZWpuU0tC?=
 =?utf-8?B?V0NhYVBGZkNyZXkybUF3SU51MzVBZ25FZHZHNytZK2p5S0haZkQxUDhkc2tE?=
 =?utf-8?B?cnBpU05RVXRpUGFsMm1jWG9Qb0FRRFM4Q3lVOWptaGl1c3hTSHlnV0N2UUhM?=
 =?utf-8?B?bXNnUWpPbXFwakpQRFV4c28yaFJacTVpWEJsVVd6c2ZrSVJzYWkxVkNDT3Z2?=
 =?utf-8?B?MEFyNXBIWUhCMGhQVTlPQVNVVWhSRDBza05DODQ4RFVhUzNpTVNYdm51dmtT?=
 =?utf-8?B?bUV3MmtFNEJkMG1RdWtwR1B5UkNnWllPRExqQWtNUE5yYlpzUWdMOEZIcUQ5?=
 =?utf-8?B?RTRmUmhsQThtdUsyczZGVXdYTUs2S1JOU0F3M3lVTG53SUt0OHBTcmJtUkVV?=
 =?utf-8?B?bDRqZVNncGtKVXMyR0RKWWswSmI5c2MyQmwyNlJsUTRvMEN4QjFNcHZpcjNo?=
 =?utf-8?B?citob3ZXZUpnT25qcURMU0VONjA1cUlqMnVMUUVjakdoa0VuSnh0RDA2S3lm?=
 =?utf-8?B?c3JjUGNJUG1PRWZWaVdmSGRiQ1YweDc0ZGdMZEtqTlBlWndWOUZMQjMzS2lE?=
 =?utf-8?B?K2JDeGZEN3ZCeEZRVWZZS045Q2xMTzlHdlBJNUJNdVBicE5JMm8zZU9yc08v?=
 =?utf-8?B?MTBLUmt5aHZvOUZPQXlmUU5uMjVJZDArRVVwcXFiZnZuM0NicEt3b3I5dnRl?=
 =?utf-8?B?SmgrSEFWNlZrVWZlVjlhSWFEZEFRa1RMZ2sySnR3T1FPUHhLc0wzZkl4LzVi?=
 =?utf-8?B?U2xYalkxcUZzSjVKalV0N0o2aDE2RnB5M0txRWZySW5uMktoNlMrTjBGUlpX?=
 =?utf-8?B?cGR6U3Jna0hEU3ZGVk9YN1BNelZkbFd2ankvYm5Ta0NtYkt4VGFCM3kwdFgx?=
 =?utf-8?B?WkhjN1pGZU02NkE3dm8yN3ljZlRQeTZaYy9qRmpyZUNoZUx1VlBoTS9sRVoz?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8B103D8D97EEB41AF581B617F0037A3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9f7ff5-75b4-4278-2751-08dcc76e81ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2024 14:34:21.7432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5Lur7HNddfhVI1tnZ22O4McHryE4nwL2f/t0SrsFbmpiMZf63NKTIzXVw2h/gi2bF85BcnCQK+h6XiXhO8fJeV9nQtM6X2vTCOm7huXiEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7939
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTEyIGF0IDE1OjQ4IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpc190ZF92Y3B1X2NyZWF0ZWQoc3RydWN0IHZjcHVfdGR4
ICp0ZHgpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiB0ZHgtPnRkX3ZjcHVfY3JlYXRl
ZDsNCj4gK30NCg0KVGhpcyBhbmQgaXNfdGRfZmluYWxpemVkKCkgc2VlbSBsaWtlIHVubmVlZGVk
IGhlbHBlcnMuIFRoZSBmaWVsZCBuYW1lIGlzIGNsZWFyDQplbm91Z2guDQoNCj4gKw0KPiDCoHN0
YXRpYyBpbmxpbmUgYm9vbCBpc190ZF9jcmVhdGVkKHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4KQ0K
PiDCoHsNCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBrdm1fdGR4LT50ZHJfcGE7DQoNCk5vdCB0
aGlzIG9uZSB0aG91Z2gsIHRoZSBoZWxwZXIgbWFrZXMgdGhlIGNhbGxlciBjb2RlIGNsZWFyZXIu
DQoNCj4gQEAgLTEwNSw2ICsxMTAsMTEgQEAgc3RhdGljIGlubGluZSBib29sIGlzX2hraWRfYXNz
aWduZWQoc3RydWN0IGt2bV90ZHgNCj4gKmt2bV90ZHgpDQo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4ga3ZtX3RkeC0+aGtpZCA+IDA7DQo+IMKgfQ0KPiDCoA0KPiArc3RhdGljIGlubGluZSBib29s
IGlzX3RkX2ZpbmFsaXplZChzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCkNCj4gK3sNCj4gK8KgwqDC
oMKgwqDCoMKgcmV0dXJuIGt2bV90ZHgtPmZpbmFsaXplZDsNCj4gK30NCj4gKw0KDQo=

