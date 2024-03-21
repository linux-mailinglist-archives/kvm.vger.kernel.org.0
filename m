Return-Path: <kvm+bounces-12341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9136F881A60
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 01:11:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4DCD1C20EFB
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 00:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F51C15BB;
	Thu, 21 Mar 2024 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c73QVCNb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A77163C;
	Thu, 21 Mar 2024 00:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710979877; cv=fail; b=RKrofaSPU6bjPuB284UWhmV7AfPxBZ4Qawkxwgs9id/e4T7rBASAbV73QBgeBcZ+YwwqyRJY3yvhxafsqkkaL3EN69fBysYDclGXv6eTzBpjrBBPORGZUKdB23eXITjvUMOedGdZ5LdS1NlbVx1gJYUkKtH+O+WOsQ/5Rb7CvWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710979877; c=relaxed/simple;
	bh=DoUb1QTmtxNEaRMmDz3kp5dwO65xgV3rxPwyq1t2O5g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SaIIcUyPfNtAxvoYKl9vqslhvPUmGxc0QLC9yl3/TmJSqMy7AEBaM/d9X44OVWs5E0Bb78W9GvSbfDDoc+j+tlGrxkt3AlLN0Fs4PySRBGKAxeJECJDl+ayNMaBPMrvgibuRJUztTQAORq76fNvAsdMXJ0DgduiNR4ZHfLp1aUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c73QVCNb; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710979874; x=1742515874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DoUb1QTmtxNEaRMmDz3kp5dwO65xgV3rxPwyq1t2O5g=;
  b=c73QVCNbHCGMqcsQKQz0hpzSY9KWCjbJXR7PjBYBKFSx8NYowkblBxaj
   texHTl9J0zzwIctCW4AB4qvuZ1slfVsWMbdsnoitKmWGg9v8QKqscpjrK
   69ujwm2r8a6cmpYpzy9RBuu+4oHJNUwRwhjJpSV3GVUwTGpByfCLIW8HO
   +YzjgjjdADIS9Mp/FS9fE0JKpH090vh8hwYjrIoVDzkMRyzJWXrOy4clI
   akOwal7IH7M0fZPyF0wa4DFhlgjt6BLZRdbvH9cz801bOABACS8CEEUNV
   WlaD46/iyot7EsQSaL7N0PcE+gH2cCnYoyZP22EPULs6517eDbVcVCRzq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5809540"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="5809540"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 17:11:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="14342317"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 17:11:14 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 17:11:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 17:11:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 17:11:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 17:11:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMfKRFqakt44if3qmV1+heid44rlCXjXWBXSkrJQENZjMGqCxS7GJaCHldFMkKKFX4aUQ2zrGbPcZABKUWWDF0G4S5hxz3SviqOqo3LH8an0SdSdxu73XS/eRzGIOGYI6D8EttpnZGS4ls1SAdX9e2BPP80MeQ3RZDNxiEWhIas/0STceUvl8P3/rZ/YzQBbe5l9dUZfKILci9Sldau/yS4eHhgXZN3H6Gxg68es5cpzPupLe7kJJmSUDj/NdRrB6o2HKiWHG3LDxH5oZmydrE8ZAs54ijMcBn1xLXEoxov6jp23obE82ZudagcB4cKQZ9vsqwYWIAfDMilFC3U2Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoUb1QTmtxNEaRMmDz3kp5dwO65xgV3rxPwyq1t2O5g=;
 b=Sr7e891C2m1oYsRi1fBtlyJNOoH9WgedIueVe9kFocb5Hvk63L8NP2FFYrRo+b8KhVgHQOSGzAm3XLhYYWkV3Rwh7HFF8d+hoUA6TFUaHt3Pki7epCxIfxCZt0Us7MpQxT4Z3zHfQzbWcu2lZMEzFUyChmFj5ILcwn6PqMHBQYTxu9md5FXYvNDlEWUGl9QXnRZOPcKiKPVukJF7CfjMTOk4lW9gxytfG/U+FviTjBJwYo3wrkgm7ByjP4JntpDYDzta4jBbLTi/9MSm/H2I2zvEAW5l9LSLFpNPVzRCCDKwLIWZH4pV7fdN+1qN7CGSflFeBwB5vHvsIP6t4M40MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB8130.namprd11.prod.outlook.com (2603:10b6:8:181::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Thu, 21 Mar
 2024 00:11:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 00:11:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Topic: [PATCH v19 056/130] KVM: x86/tdp_mmu: Init role member of struct
 kvm_mmu_page at allocation
Thread-Index: AQHadnqoikf1/sFCe0+iZ0Ofp2o8ULFBW5gA
Date: Thu, 21 Mar 2024 00:11:11 +0000
Message-ID: <9c58ad553facc17296019a8dad6a262bbf1118bd.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <5d2307efb227b927cc9fa3e18787fde8e1cb13e2.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB8130:EE_
x-ms-office365-filtering-correlation-id: 8bb4b8f0-7107-4333-405f-08dc493b6a18
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FZsTApTU9UbWv9YFqeSjXgxSGL4+OOX+5R9pikpJL+ULLWScTeOtlFIFzemBxfax8wjV1vF56REgbvv2XoZozRr0zRWiadf5AEdrxY9KMLD+TMU7/q+ey9QLsEeRId92q2mMmNS4KDbMYcKbRmyk5BjjF7UeIVmNcV3tlUF7KQi4mumyFFnhsw0at+IjyOpW1Nbp5RtAegKM6iN81nruQ7Xq3cqphZF9lqOAmEWfY+bzpH783/OLendYnGSQUyoPhvJB/LHfHBQBIB5sAi5QUNKIIZUmGzwLDEyyqc/NEH7uNLy4y+N+mM7i8C7+sfIDjLVK+hSky+F+Y7oMnqpF8yKf67in0L3qjKlXtNvJAMc/VvYEIHWLLFfKpL4SwC6mJsJw9XvLqqJbf9wjXydaUHEq3Nqx10P9LCYVJjpmPSJI3yeI79g0POAaGCloaDfSYLvRc6m05v2SS+RDPF+rYzCcVhjyJmORMUcP8ce5bPXmOqRGCUPXc5/PfVJZzeFYgWOUusI7BzG35/Pen+QoNvxuQBhw5846EhLC7zneB8SSp4jM8EwlpQxUIGV6GdyExJu3GpehW+AIvNcx+RmAQ0NuKzYbTJJ4/b8b7IiDyMjTxc574zksg++6g30ew79EQAWsTcMWKsNoxim1O2zVda0qS6n2tsaqTA3f+sQnBK8hKhBwxtYYajNqkOZDgLwFCb2+9YUn43WjmsFoqjAZzy/ZxwXlKyhaoWAtmk5soTE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWN1NG1LaHo1a2EyZHpqUlJ1OVR4NWdvUHhTY2FYbE5TZXI2eU1zeC9vVzVp?=
 =?utf-8?B?VmYwcldZRzQrbWJwd05sTjB3aElsTUgwaklJQVg1TWFQazV0eHo2NGVDMHpx?=
 =?utf-8?B?dUV4dm1rQ011cWVmRjdXMFVweDZNcHg5YmZyT0l0NWNEWXgxa2YxVHF2SDZn?=
 =?utf-8?B?aStHZXVQVE1vYlBLYUNVQVRYY3JXVHhTMC95bFJkeTZ0aVBOc245dlZhTVg0?=
 =?utf-8?B?Q1hpS1czUHhIbmNDVk95WlE3NGFDZzBvcVBVRTlUZ2lkOGlqTXVGWjZLL2xW?=
 =?utf-8?B?dUhYUkRqK2EyS01FbUJFQ3BBMEQ0b1RYUEd5NEFCQWxWVW5weXJucnN3YUdX?=
 =?utf-8?B?Q0NtdnkxYVdzZFlKUmluVUxrK2J5bllhOG03V0RmQnhCOEhvQXNmVTdOem53?=
 =?utf-8?B?a2ZZMGczT0NYanc5WC8zZDMva1FlaENHK2oyclltb2J5bFVPeVFDQ3dIRTJ6?=
 =?utf-8?B?OFMvNzVwdEJFRC9iRkdWcGo2ZXVqV1lZUHdGNjBhV0lkWnphS0o1RkN0UUUw?=
 =?utf-8?B?L2RxZTBsa2JJYUZkeHZsVUt2V3MrNThOaWRPRXlXUldNaGZMQlFwYVZNd0w3?=
 =?utf-8?B?NldyVGNkYzRneTQ4RDVKZlFnQmZlcDhaZkRKZnZxMEwzMUpwVVJNb2lNK2Ro?=
 =?utf-8?B?aEpRM2pFaTFEczFodWdZRENtSzArUUZGRXdJQlYxai8yc1RRMWtHdi9yNm9w?=
 =?utf-8?B?cjlDU0tXWTVRQVpOdHNXM1UxMmJOSTRTMU9vZFVpNG9NYWhmblp1QlNaS0Zq?=
 =?utf-8?B?TTFDR2sydyt0bjlQc09nNzN6bkNZdy9MVFRSdUl4dmZxOW1FOEhVWDR5RFJl?=
 =?utf-8?B?S3NINGg5OFpSbnVjMUtLcm5ESGVzbHRzT0N1ZlZISEYrRTZ3UmFCTVJNQkVS?=
 =?utf-8?B?YXlPdG03Q29Majc2aTdXdkpwaGxncndQWWwyYy9hMnJOT2dGMi9TWFV0SzAz?=
 =?utf-8?B?ZFQ3ekVQT3RnQlptQmppdllPV3BwUXpCVVVOWURMOU5XNUtSMjNaVW9MdmtG?=
 =?utf-8?B?dUZGSUxiVXlnSGdoRDg0Q0dxTnM1NDBNdk9IY2xlMkUydi85RzVmRC9Mb1ZG?=
 =?utf-8?B?SW45TGhISllSNlpVWEhFaFhMSmd1YmpBMS8zaENJYWRXQkNnRERkTWNwcDB0?=
 =?utf-8?B?WklQMGFDRGd0aFdjbnVvWFcwc0pUNFZnTEFTZEVCR1duMy9KLzJnVEEyY2Qr?=
 =?utf-8?B?TEFpeWUrQjBMemVidlFZVzdsM3dWUjZNYlRLTzNWdnFQcEhOWmU2WnliRFZ5?=
 =?utf-8?B?V3hkdlIyWG04YVlmRHhvQkhZQWFodzlwdHZDbktrdXUyVUdCM01iYWxadWJz?=
 =?utf-8?B?R3BqTnFSQ0lVbWlUbndSTTVIeS9hSTRPdWtiOWNva2p5ZW8yZy9wT2p0d3oz?=
 =?utf-8?B?YnUyZW9YTGU2d3U0RDloOGJqdklOYXlLaGltUDFrazZSQkZXWEJtWU9SQWtV?=
 =?utf-8?B?MjdoRzJDWHdrbXN0T3g0NlJCbGlGclA1dnFLdkZkdW15dXgyS1pTWjdtdzE0?=
 =?utf-8?B?UE45Uk00THV4S0U0SHBYcUs5bzViYXNOY05ZMG4vVjJTLzVWUUZHdTFxalBs?=
 =?utf-8?B?cXluS0NibFJob2E5NFJLQTg1K2haTkowREwxekZUWUN3UEdyQXI4RUxMRGtO?=
 =?utf-8?B?TXVtTVE1NUxKQ1pPalBJL3NQTHlWWitwSHo0aDQzNDNMRjdYVjd1Wmc3a2hC?=
 =?utf-8?B?YVJJSk9icWdBc1RHOUNvRlc0NHN5Y1lLSzhiYVBLMlQxbUJDd2l6MTJMeUxn?=
 =?utf-8?B?L2ZKV2JPUW1MR1R1VzNSTlNsYThoVEFiM2FvVExGdFhqcVpqUUcrNzQza1Fs?=
 =?utf-8?B?VXdxRloyNWFmbHR1SW4wQXgrbWdMeFZXWTFRZjhyUTFaQU1VcUFxT1RlUTdw?=
 =?utf-8?B?WGZFMFhib3MxYUluTXRSOEh3TDhOTjBaTndUM0paZnpUbUdjazYxRG9ISjdW?=
 =?utf-8?B?TTFtazhVL2MvWVM1YllTV3JDMkdCNDhDR3hCWFgzTGpjS1BsMVJMSFN4Qkd2?=
 =?utf-8?B?aStPM1BGbS9tL3lXNjZUU0dNeHYxSHczeDQ3VUk2Rm8rcS9vVmlteE4zeHBN?=
 =?utf-8?B?YlFmeDlsSTc2VmpwdXA0T3c0aGt4WUV2L0ZXcXBqNGNKS1QyU01XaWczTlBG?=
 =?utf-8?B?TUxYb0hKcVRhZ29naEFwUVBucmozT2lDSVJLNGcrRWJvbTAvSU9PYVdab09q?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58C655EC9F08C94F809D295440F2DECB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb4b8f0-7107-4333-405f-08dc493b6a18
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 00:11:11.1534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gYeQOKbDDq9Fk+rTlMbyFMTnxin1sYdLEn9j9APLHdYSIKCWoiePRYMVYAm88aeNH4F8+iou372bAWT/UL+twlTzVf/AgLwJt8IY7G3dRV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8130
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IFRvIGhhbmRsZSBwcml2YXRlIHBhZ2UgdGFibGVzLCBhcmd1bWVudCBvZiBp
c19wcml2YXRlIG5lZWRzIHRvIGJlDQo+IHBhc3NlZA0KPiBkb3duLsKgIEdpdmVuIHRoYXQgYWxy
ZWFkeSBwYWdlIGxldmVsIGlzIHBhc3NlZCBkb3duLCBpdCB3b3VsZCBiZQ0KPiBjdW1iZXJzb21l
DQo+IHRvIGFkZCBvbmUgbW9yZSBwYXJhbWV0ZXIgYWJvdXQgc3AuIEluc3RlYWQgcmVwbGFjZSB0
aGUgbGV2ZWwNCj4gYXJndW1lbnQgd2l0aA0KPiB1bmlvbiBrdm1fbW11X3BhZ2Vfcm9sZS7CoCBU
aHVzIHRoZSBudW1iZXIgb2YgYXJndW1lbnQgd29uJ3QgYmUNCj4gaW5jcmVhc2VkDQo+IGFuZCBt
b3JlIGluZm8gYWJvdXQgc3AgY2FuIGJlIHBhc3NlZCBkb3duLg0KPiANCj4gRm9yIHByaXZhdGUg
c3AsIHNlY3VyZSBwYWdlIHRhYmxlIHdpbGwgYmUgYWxzbyBhbGxvY2F0ZWQgaW4gYWRkaXRpb24N
Cj4gdG8NCj4gc3RydWN0IGt2bV9tbXVfcGFnZSBhbmQgcGFnZSB0YWJsZSAoc3B0IG1lbWJlciku
wqAgVGhlIGFsbG9jYXRpb24NCj4gZnVuY3Rpb25zDQo+ICh0ZHBfbW11X2FsbG9jX3NwKCkgYW5k
IF9fdGRwX21tdV9hbGxvY19zcF9mb3Jfc3BsaXQoKSkgbmVlZCB0byBrbm93DQo+IGlmIHRoZQ0K
PiBhbGxvY2F0aW9uIGlzIGZvciB0aGUgY29udmVudGlvbmFsIHBhZ2UgdGFibGUgb3IgcHJpdmF0
ZSBwYWdlIHRhYmxlLsKgDQo+IFBhc3MNCj4gdW5pb24ga3ZtX21tdV9yb2xlIHRvIHRob3NlIGZ1
bmN0aW9ucyBhbmQgaW5pdGlhbGl6ZSByb2xlIG1lbWJlciBvZg0KPiBzdHJ1Y3QNCj4ga3ZtX21t
dV9wYWdlLg0KDQp0ZHBfbW11X2FsbG9jX3NwKCkgaXMgb25seSBjYWxsZWQgaW4gdHdvIHBsYWNl
cy4gT25lIGZvciB0aGUgcm9vdCwgYW5kDQpvbmUgZm9yIHRoZSBtaWQtbGV2ZWwgdGFibGVzLg0K
DQpJbiBsYXRlciBwYXRjaGVzIHdoZW4gdGhlIGt2bV9tbXVfYWxsb2NfcHJpdmF0ZV9zcHQoKSBw
YXJ0IGlzIGFkZGVkLA0KdGhlIHJvb3QgY2FzZSBkb2Vzbid0IG5lZWQgYW55dGhpbmcgZG9uZS4g
U28gdGhlIGNvZGUgaGFzIHRvIHRha2UNCnNwZWNpYWwgY2FyZSBpbiB0ZHBfbW11X2FsbG9jX3Nw
KCkgdG8gYXZvaWQgZG9pbmcgYW55dGhpbmcgZm9yIHRoZQ0Kcm9vdC4NCg0KSXQgb25seSBuZWVk
cyB0byBkbyB0aGUgc3BlY2lhbCBwcml2YXRlIHNwdCBhbGxvY2F0aW9uIGluIG5vbi1yb290DQpj
YXNlLiBJZiB3ZSBvcGVuIGNvZGUgdGhhdCBjYXNlLCBJIHRoaW5rIG1heWJlIHdlIGNvdWxkIGRy
b3AgdGhpcw0KcGF0Y2gsIGxpa2UgdGhlIGJlbG93Lg0KDQpUaGUgYmVuZWZpdHMgYXJlIHRvIGRy
b3AgdGhpcyBwYXRjaCAod2hpY2ggbG9va3MgdG8gYWxyZWFkeSBiZSBwYXJ0IG9mDQpQYW9sbydz
IHNlcmllcyksIGFuZCBzaW1wbGlmeSAiS1ZNOiB4ODYvbW11OiBBZGQgYSBwcml2YXRlIHBvaW50
ZXIgdG8NCnN0cnVjdCBrdm1fbW11X3BhZ2UiLiBJJ20gbm90IHN1cmUgdGhvdWdoLCB3aGF0IGRv
IHlvdSB0aGluaz8gT25seQ0KYnVpbGQgdGVzdGVkLg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL21tdS9tbXVfaW50ZXJuYWwuaA0KYi9hcmNoL3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5o
DQppbmRleCBmMTUzM2E3NTM5NzQuLmQ2YzJlZThiYjYzNiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2
L2t2bS9tbXUvbW11X2ludGVybmFsLmgNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11X2ludGVy
bmFsLmgNCkBAIC0xNzYsMzAgKzE3NiwxMiBAQCBzdGF0aWMgaW5saW5lIHZvaWQNCmt2bV9tbXVf
aW5pdF9wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCwgdm9pZCAqcHJpdmENCiAN
CiBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX21tdV9hbGxvY19wcml2YXRlX3NwdChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsDQpzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCkNCiB7DQotICAgICAgIGJvb2wg
aXNfcm9vdCA9IHZjcHUtPmFyY2gucm9vdF9tbXUucm9vdF9yb2xlLmxldmVsID09IHNwLQ0KPnJv
bGUubGV2ZWw7DQotDQotICAgICAgIEtWTV9CVUdfT04oIWt2bV9tbXVfcGFnZV9yb2xlX2lzX3By
aXZhdGUoc3AtPnJvbGUpLCB2Y3B1LT5rdm0pOw0KLSAgICAgICBpZiAoaXNfcm9vdCkNCi0gICAg
ICAgICAgICAgICAvKg0KLSAgICAgICAgICAgICAgICAqIEJlY2F1c2UgVERYIG1vZHVsZSBhc3Np
Z25zIHJvb3QgU2VjdXJlLUVQVCBwYWdlIGFuZA0Kc2V0IGl0IHRvDQotICAgICAgICAgICAgICAg
ICogU2VjdXJlLUVQVFAgd2hlbiBURCB2Y3B1IGlzIGNyZWF0ZWQsIHNlY3VyZSBwYWdlDQp0YWJs
ZSBmb3INCi0gICAgICAgICAgICAgICAgKiByb290IGlzbid0IG5lZWRlZC4NCi0gICAgICAgICAg
ICAgICAgKi8NCi0gICAgICAgICAgICAgICBzcC0+cHJpdmF0ZV9zcHQgPSBOVUxMOw0KLSAgICAg
ICBlbHNlIHsNCi0gICAgICAgICAgICAgICAvKg0KLSAgICAgICAgICAgICAgICAqIEJlY2F1c2Ug
dGhlIFREWCBtb2R1bGUgZG9lc24ndCB0cnVzdCBWTU0gYW5kDQppbml0aWFsaXplcw0KLSAgICAg
ICAgICAgICAgICAqIHRoZSBwYWdlcyBpdHNlbGYsIEtWTSBkb2Vzbid0IGluaXRpYWxpemUgdGhl
bS4gDQpBbGxvY2F0ZQ0KLSAgICAgICAgICAgICAgICAqIHBhZ2VzIHdpdGggZ2FyYmFnZSBhbmQg
Z2l2ZSB0aGVtIHRvIHRoZSBURFggbW9kdWxlLg0KLSAgICAgICAgICAgICAgICAqLw0KLSAgICAg
ICAgICAgICAgIHNwLT5wcml2YXRlX3NwdCA9IGt2bV9tbXVfbWVtb3J5X2NhY2hlX2FsbG9jKCZ2
Y3B1LQ0KPmFyY2gubW11X3ByaXZhdGVfc3B0X2NhY2hlKTsNCi0gICAgICAgICAgICAgICAvKg0K
LSAgICAgICAgICAgICAgICAqIEJlY2F1c2UgbW11X3ByaXZhdGVfc3B0X2NhY2hlIGlzIHRvcHBl
ZCB1cCBiZWZvcmUNCnN0YXJ0aW5nDQotICAgICAgICAgICAgICAgICoga3ZtIHBhZ2UgZmF1bHQg
cmVzb2x2aW5nLCB0aGUgYWxsb2NhdGlvbiBhYm92ZQ0Kc2hvdWxkbid0DQotICAgICAgICAgICAg
ICAgICogZmFpbC4NCi0gICAgICAgICAgICAgICAgKi8NCi0gICAgICAgICAgICAgICBXQVJOX09O
X09OQ0UoIXNwLT5wcml2YXRlX3NwdCk7DQotICAgICAgIH0NCisgICAgICAgLyoNCisgICAgICAg
ICogQmVjYXVzZSB0aGUgVERYIG1vZHVsZSBkb2Vzbid0IHRydXN0IFZNTSBhbmQgaW5pdGlhbGl6
ZXMNCisgICAgICAgICogdGhlIHBhZ2VzIGl0c2VsZiwgS1ZNIGRvZXNuJ3QgaW5pdGlhbGl6ZSB0
aGVtLiAgQWxsb2NhdGUNCisgICAgICAgICogcGFnZXMgd2l0aCBnYXJiYWdlIGFuZCBnaXZlIHRo
ZW0gdG8gdGhlIFREWCBtb2R1bGUuDQorICAgICAgICAqLw0KKyAgICAgICBzcC0+cHJpdmF0ZV9z
cHQgPSBrdm1fbW11X21lbW9yeV9jYWNoZV9hbGxvYygmdmNwdS0NCj5hcmNoLm1tdV9wcml2YXRl
X3NwdF9jYWNoZSk7DQogfQ0KIA0KIHN0YXRpYyBpbmxpbmUgZ2ZuX3Qga3ZtX2dmbl9mb3Jfcm9v
dChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdA0Ka3ZtX21tdV9wYWdlICpyb290LA0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmMNCmluZGV4IGFjN2JmMzdiMzUzZi4uZjQyM2EzODAxOWZiIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYva3ZtL21tdS90ZHBfbW11LmMNCisrKyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQpA
QCAtMTk1LDkgKzE5NSw2IEBAIHN0YXRpYyBzdHJ1Y3Qga3ZtX21tdV9wYWdlICp0ZHBfbW11X2Fs
bG9jX3NwKHN0cnVjdA0Ka3ZtX3ZjcHUgKnZjcHUpDQogICAgICAgIHNwID0ga3ZtX21tdV9tZW1v
cnlfY2FjaGVfYWxsb2MoJnZjcHUtDQo+YXJjaC5tbXVfcGFnZV9oZWFkZXJfY2FjaGUpOw0KICAg
ICAgICBzcC0+c3B0ID0ga3ZtX21tdV9tZW1vcnlfY2FjaGVfYWxsb2MoJnZjcHUtDQo+YXJjaC5t
bXVfc2hhZG93X3BhZ2VfY2FjaGUpOw0KIA0KLSAgICAgICBpZiAoa3ZtX21tdV9wYWdlX3JvbGVf
aXNfcHJpdmF0ZShyb2xlKSkNCi0gICAgICAgICAgICAgICBrdm1fbW11X2FsbG9jX3ByaXZhdGVf
c3B0KHZjcHUsIHNwKTsNCi0NCiAgICAgICAgcmV0dXJuIHNwOw0KIH0NCiANCkBAIC0xMzc4LDYg
KzEzNzUsOCBAQCBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3Ry
dWN0DQprdm1fcGFnZV9mYXVsdCAqZmF1bHQpDQogICAgICAgICAgICAgICAgICogbmVlZHMgdG8g
YmUgc3BsaXQuDQogICAgICAgICAgICAgICAgICovDQogICAgICAgICAgICAgICAgc3AgPSB0ZHBf
bW11X2FsbG9jX3NwKHZjcHUpOw0KKyAgICAgICAgICAgICAgIGlmICghKHJhd19nZm4gJiBrdm1f
Z2ZuX3NoYXJlZF9tYXNrKGt2bSkpKQ0KKyAgICAgICAgICAgICAgICAgICAgICAga3ZtX21tdV9h
bGxvY19wcml2YXRlX3NwdCh2Y3B1LCBzcCk7DQogICAgICAgICAgICAgICAgdGRwX21tdV9pbml0
X2NoaWxkX3NwKHNwLCAmaXRlcik7DQogDQogICAgICAgICAgICAgICAgc3AtPm54X2h1Z2VfcGFn
ZV9kaXNhbGxvd2VkID0gZmF1bHQtDQo+aHVnZV9wYWdlX2Rpc2FsbG93ZWQ7DQpAQCAtMTY3MCw3
ICsxNjY5LDYgQEAgc3RhdGljIHN0cnVjdCBrdm1fbW11X3BhZ2UNCipfX3RkcF9tbXVfYWxsb2Nf
c3BfZm9yX3NwbGl0KHN0cnVjdCBrdm0gKmt2bSwgZ2ZwX3QNCiANCiAgICAgICAgc3AtPnNwdCA9
ICh2b2lkICopX19nZXRfZnJlZV9wYWdlKGdmcCk7DQogICAgICAgIC8qIFRPRE86IGxhcmdlIHBh
Z2Ugc3VwcG9ydCBmb3IgcHJpdmF0ZSBHUEEuICovDQotICAgICAgIFdBUk5fT05fT05DRShrdm1f
bW11X3BhZ2Vfcm9sZV9pc19wcml2YXRlKHJvbGUpKTsNCiAgICAgICAgaWYgKCFzcC0+c3B0KSB7
DQogICAgICAgICAgICAgICAga21lbV9jYWNoZV9mcmVlKG1tdV9wYWdlX2hlYWRlcl9jYWNoZSwg
c3ApOw0KICAgICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KQEAgLTE2ODYsMTAgKzE2ODQsNiBA
QCBzdGF0aWMgc3RydWN0IGt2bV9tbXVfcGFnZQ0KKnRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0
KHN0cnVjdCBrdm0gKmt2bSwNCiAgICAgICAgc3RydWN0IGt2bV9tbXVfcGFnZSAqc3A7DQogDQog
ICAgICAgIGt2bV9sb2NrZGVwX2Fzc2VydF9tbXVfbG9ja19oZWxkKGt2bSwgc2hhcmVkKTsNCi0g
ICAgICAgS1ZNX0JVR19PTihrdm1fbW11X3BhZ2Vfcm9sZV9pc19wcml2YXRlKHJvbGUpICE9DQot
ICAgICAgICAgICAgICAgICAgaXNfcHJpdmF0ZV9zcHRlcChpdGVyLT5zcHRlcCksIGt2bSk7DQot
ICAgICAgIC8qIFRPRE86IExhcmdlIHBhZ2UgaXNuJ3Qgc3VwcG9ydGVkIGZvciBwcml2YXRlIFNQ
VEUgeWV0LiAqLw0KLSAgICAgICBLVk1fQlVHX09OKGt2bV9tbXVfcGFnZV9yb2xlX2lzX3ByaXZh
dGUocm9sZSksIGt2bSk7DQogDQogICAgICAgIC8qDQogICAgICAgICAqIFNpbmNlIHdlIGFyZSBh
bGxvY2F0aW5nIHdoaWxlIHVuZGVyIHRoZSBNTVUgbG9jayB3ZSBoYXZlIHRvDQpiZQ0KDQo=

