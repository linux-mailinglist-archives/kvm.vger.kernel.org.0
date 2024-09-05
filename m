Return-Path: <kvm+bounces-25926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B089E96D1E7
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 10:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687672884D9
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 08:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A7E127735;
	Thu,  5 Sep 2024 08:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KtEECWg1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFA9194ACF;
	Thu,  5 Sep 2024 08:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524475; cv=fail; b=tnGEWYetFqNolTXDo/j+wFqtvUmGhjZCW04nO2PVSnMAs3AyVEqt5Lh9+kcP8toacBkvU8DC4qRZi55BQuFQL8mlDDPpd3B836Soo8fh2HJdcf6FdjOX1KQSkHPGX3O0d0ph+hv1nYPaA6FXzcHohF+V7aiWnPE/tMO2ush300Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524475; c=relaxed/simple;
	bh=ECPxbuDBDLgsM9gMGMsLpjRIgIIsDCg0vZV5w8pB/+s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q80LevRtHccsxU5+q/g7PyhkkOAIONOdkfLbtbGFrII7ZxEkJpMmb847krmt9yw8IpNL+9G+WKUvsUPtTHllnS+SGqDfqFh/DPSaSlqTbqeZn5C3SbciEG79p8EjVn2g9wJRasS9QOUaatiDWrRCuSh0CS1NTY1TqDUGjA62sjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KtEECWg1; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725524474; x=1757060474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ECPxbuDBDLgsM9gMGMsLpjRIgIIsDCg0vZV5w8pB/+s=;
  b=KtEECWg1lTLbkE4FSOgb4O3bJF5p48wzsbe2VGLXDbfWNVBHDmgCDBtz
   QFVHs26iK3N6UdZkWh63HUrGHV3DRGhO9NHNx8VInPsI4cWfgkmPVCQTc
   QnanrIaReGzfKwqtzFd6uEgUnNoz5JxGuyCVG3fUKGJ/wp+wN4F31Yb26
   jNGsQlFg6TvcMGyaOKYTtzkhYygvAjrhUiiX96j/4S7yqhoJkEGR9KW2D
   ja9De6WZ8HhmIgL0a3nEy4CwydQ62B6aiRhfPsNkzMMGUn6MUv2QRbT+5
   xIKlqczBn+rIZ8s48VJl+WmbYrWnKl8VKCQhCagrJrJiOyR9Y77BG8I+q
   Q==;
X-CSE-ConnectionGUID: gW/rgw+5TMCV0mG/5EFkWg==
X-CSE-MsgGUID: xl5D8k/oTT+CQcS4GqGogA==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="41729696"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="41729696"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:21:13 -0700
X-CSE-ConnectionGUID: ELDqVgSsQ6WXtu/NRC+jFg==
X-CSE-MsgGUID: APFLtEWpTbW3Wy5wcUyYrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65198797"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 01:21:13 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 01:21:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 01:21:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 01:21:11 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 01:21:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4oIlLtYqZMkh/bRKZI2WAr07S+PdO9dRYzU+b+KaN/ytwhKxqE8y5CYzpfLXf9EHgXhN1wwKi0XrEEj7YeWLM2ERVQWLMWa7QoCsbKfAcb28o4vYVkAa5RPxBxzDJgNZqVFAM+rXSp12glBbKt/sKg9qMMXqS6gjZN6PHBB509r5dA6BmxGtV0B3u+BDiutaK73+X6SI7ogfcWhCLaARoLL328Di1MamqNOJCnIi3qrAEh17oD7byMp/N/L7KnbEEpXGExlQJ41bpt24TBqaJ9tepBWDTUcqZZyUgF4wI1Gc7jlVL93/ajqRyLancLHIm1dXARNNn0N2B6um0/7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECPxbuDBDLgsM9gMGMsLpjRIgIIsDCg0vZV5w8pB/+s=;
 b=HMc+Wstx3//nsaCNcZWz2PxVamKAi7VA1trQddWOtaxvr8YjHIwXdor+TVqtS8TLvbeXNCLbFMFKV+VyoIVUBKEEy/eQsqO28LpThexZqbFipIQ1bJx0Z39MwcGf8pim0HpDIcwwEnNOz/VnEVoG+P5IcplxnYVGde97i/16h/TctOoIFIn7ZbzltHFMNS+0oGyYxNoJTOZeK6TG5X87VFDHCPJeudxgR1052FIeE3EX0iJ+cmxlYMRNWOYr+9ytzx2Jai1VGmNy8x2SR7UEMSyhcflyb7HTDz+FZ9S3w1XjTN7tocMhq4njMlha5ZQImCB1afcDDbO6WpwKxZiVfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 08:21:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 08:21:04 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Thread-Topic: [RFC PATCH 00/21] Secure VFIO, TDISP, SEV TIO
Thread-Index: AQHa9V+RUBnxKAuIykCdjfC5rrIh0bI9Ky+AgAElcACACpuqMA==
Date: Thu, 5 Sep 2024 08:21:03 +0000
Message-ID: <BN9PR11MB527610C9DB11B984FFE5CDD38C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <66cf8bfdd0527_88eb2942e@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
In-Reply-To: <6cd62b80-9a8d-4f01-a458-4466dac6d27f@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB7472:EE_
x-ms-office365-filtering-correlation-id: 2c5f2175-ed53-49b7-9e41-08dccd83af04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V3l4NmxYeGkwRDJMUzNIS1hXZmhqcW45QTNHOTI5ZUxQMjg3ZHdUWkFybnBu?=
 =?utf-8?B?RzVNZzhqM0lETVRDNWRGL3ZHcndoMVJJMG0wbzk0d3lYUDN0REYxQ2ZVc0cr?=
 =?utf-8?B?UUlhbjhjYWZZSGgxVWZ6aUJLZVR5bmNGL1lhQU9wU0djblVkK1NFODdjbU0v?=
 =?utf-8?B?cFBDYjlZNlZYcldSMGJ1Yi9Ed2FuOUJNN29YazlVbkdvcFNLbXp2dE9aaHBB?=
 =?utf-8?B?Z0lYZWc1TGdGQ1RYQmhsV1hyTjF2cDZKeWFhVEtNVk1PM0FFNVU3Y1NXRldx?=
 =?utf-8?B?LzFFRWl3c0N6Q3FqK3I4bWlJVEdSUmxEK09Id0JkYVhaNUQxQldrV1FnOUwz?=
 =?utf-8?B?am1wN3NMU3A2VHNobVk0UVlZemxhMDhSTVVUR1ZEOTZ1RlorOFI3OFpYa1JV?=
 =?utf-8?B?RXFRUDY0dzMxaS9WT0txY2ZKSGI2U3l5V1Z4anNvVzJNMGFWdVAvRzlFaDNs?=
 =?utf-8?B?RFBUczlrN09CbEVSRHJ3Ym50OXNMZVlnNVRKWVNiTkpObHRwbnhNbm9McC9G?=
 =?utf-8?B?ZTl1bWdZb1ZRQmVqbnE2TldLbkVzQUtneldnMTFHWUNiMnUyODB1MHR4Q1h5?=
 =?utf-8?B?NmRqeUo3ZWRNdW9pTkFiREowQUQzODNpb05iUEFYdU05cndlR1AwVTdodC8r?=
 =?utf-8?B?d2FXdlgwTVJMMVcxRzZncFA4cHU5cXhkVGpwY0F6WUJjVXdmMkJXeUlEakhE?=
 =?utf-8?B?b3lpYzZwWnpZOU5GMCtFQlhGS1pHbmdLenFHYTBtRDQ3ZStTcmVEKzdBSUJD?=
 =?utf-8?B?RkdvZEMxa2l1MDkrcFJSZ29KaENsOTkyV2ZmOE9nNlR0bStHRG9iL1krcFlx?=
 =?utf-8?B?aTMxY2xtZWF3eUg2VXpPUW5WQWNwWGJFSnE5UVlJdmMycDRNYjF0MDh4YTNz?=
 =?utf-8?B?cHRlZlZzV2JLNzU2TjdLY08zZjBKbUsyMjdvYnpXSUlhRVBwdThzY3k0ZHpi?=
 =?utf-8?B?YXNVeHhMem5BbUVkMkpPMDdkd3hsbDJpVUwxWmZRQ3ZGb3RubG1JSDMwaTYw?=
 =?utf-8?B?WDRPOHlLVmRCQXZnVlhHR0dJamc1ZUs3YWNUeTV0N0ZNMnpJUHk1cytZWnhm?=
 =?utf-8?B?dmZnZjNkN1F4T2sxR0RZcG1JQWw3NTBNSngyQk5VNjE2c3NyczVibDBwSU5J?=
 =?utf-8?B?SjVZcm9JTCtRR2dySWV0ZjhqR1c3OFBCK1NxSDdua1JiMGYycjYvZlQrYXgv?=
 =?utf-8?B?Z1FKK2NRbHIwQlBsUWtxcmowWmxBNlhYa01JR01mQ0xVRTVBZFh6K1gyZGJ0?=
 =?utf-8?B?dHhSZHNjT08wUHJ2UzZvYUVjOE0zU04rNVgra1VUd1c0dkUxVXAxbHJGMkZp?=
 =?utf-8?B?bXpQbDByMVlOd0NNbUdYQThXY3Bad1Vma2d3Vmc5NmxHM0IrbmplbThFZGJF?=
 =?utf-8?B?QXBXZ2VBZUFVai8wRlBvbUh5T3lITXVQRThMMkpnZmZGWnpGK2tiMlpGb3VU?=
 =?utf-8?B?L3lhT21qOFdWQURDM0hqQ0VyWnYvV1VySExCYzkxUFUwZVBPZjJKTEJPQ0E3?=
 =?utf-8?B?bFZtdzB2ZmZFWDVUalVHcDY4aTgwZ0VWVS9SMU5sMkJRNjJtT3JyRjlIamtr?=
 =?utf-8?B?STk1Nm9uYnBHTkJabWZiSzBXRFo4UTNGM3VueGpFMlRLNk1EQ3BEcWJkK3hR?=
 =?utf-8?B?LzdRRUdJbkRNbzZGdGYrSERFMGxnK25xSmpQdHBhaHhLcTU4eVF1OGxibHpk?=
 =?utf-8?B?TzhaUFlod0hveUUrMGNZMWRiYk01VHZVQndpVzA4UnprRTBRaThjTGVCdktj?=
 =?utf-8?B?bnVJeDlzSUgrRGVndnBFRWttMnNrbWN6U3o4enVJLzBHTHhqQnBtMGwvVjR0?=
 =?utf-8?B?QlNUaUpaeEEwclRHZmVLWGU4Y2VhZ2tUZ2xESHZYSlgvalY2SWdHOHp6WFV0?=
 =?utf-8?B?MWk1WjJ0N0l0akxJTDh6WXl3V2ZrMjdGUVBNL2QrV3owY2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWowcTdhNnl5eVN5Rkxkd2pVZ3dkaTdHamFaaUJBdHE1dGJqcnZmSGN3M2ZJ?=
 =?utf-8?B?VHdrZ1ZDWkNMaUxab2d1ckxVczBvNzk5SVpCM054UG54b2ZqcGhQN1Z6MWhC?=
 =?utf-8?B?ZTB6N0RHMi9KMHFlc2UyelBmSEFjaEZPc0hJWi9mdlpzSU4yWFU5Mk8wdkR5?=
 =?utf-8?B?ai9TekhkaGY1aDU2M2hxZUR1ZFZja1EyRXgzV3ZoTXpqbnZKUmRiLzJaVUZC?=
 =?utf-8?B?Tlh2bnJEVEpDWFArQ3ZCMUFXdmFuOVphZVBKS0Zjd1RSbVE4L3dmSUU5eDFH?=
 =?utf-8?B?azFzZDlRR1pIU0Fzbm9PZUdyeHVJWU03NlBza0Jna3lHcWtBZmptcHR6c0xM?=
 =?utf-8?B?VUh3Y0UxVFF2ekRYQkx4SUxYQ2d2MFJoY3ZNakI1T3pKTXQ0UVovTkNWQndY?=
 =?utf-8?B?VTRvazVnZVY0R2o0MDZ3TFlWSS9YSWhzTHloOFNHckRoOVpKQ05NTUh2K0NK?=
 =?utf-8?B?ZHhlYjc4V3FXcnc4d01DNXdZMWgrRE5ROEtlRmlEY3cvTjhUU0lrTk5DUXYy?=
 =?utf-8?B?MDFWcFhHRWR3enVaMy9NVHNFRG5HVGt3Y1hZSTlUUzZMV1JhUk1RTzVxWmMy?=
 =?utf-8?B?aHRDa2h3UzdRRkV2TFNHd3Nnby9BY3ZYb2RZT2V0cXVBK2FiNkJEeSsyUDRr?=
 =?utf-8?B?QXoxOG1ocEJhdWlNbGJxL080dFdMODdTdGYrZXpEb0k0cjN0MlplcGtXNVAz?=
 =?utf-8?B?WVlNQ0E0SHFBVXJaY3RsNDdRKzJLWDlJVFBPWjFaU0xWZG5lc1F2RzRoSWV2?=
 =?utf-8?B?NWhHNTVDNzFhV2dlYmc5OEQ2azZ1dGJsVWJSY3VCN01zOHlEK2Zhb3VQa0JY?=
 =?utf-8?B?RVRSQ3JsY25CUWJqRXVxUUZoWi82NzZPQmxNWXJNbms4bUt2bUYvVGZvUDlS?=
 =?utf-8?B?Q2pmWlNmSVJLbnF1Wm8vaysxMkVMMlZtUEZPYU1OcUZEUkZGWEFGbi9jM3Vx?=
 =?utf-8?B?RU5nZk1nTGpka1RSdzV1alN4SEZEVy8vNHZyOE00UGR2NUk1ODJtTmdodEp1?=
 =?utf-8?B?S3pCSW0ydlBrRjNibHBRUU16ZTlEcmtVZjM0MENzUURnaDRNRlplbGlPZ1Q3?=
 =?utf-8?B?c3RHdDRsZjNSZXJDR091b0IvRUd2Z2NYK1c3dkF4allWWWllYTdzRis1OTdC?=
 =?utf-8?B?M3c5WExENlp6NzJZQkFHUUFhM1pIR09jVlY2a3o1TGh2bXU0S2ppK0cybEww?=
 =?utf-8?B?dmsxdWdNUDE0YzB1em52T2wyTTRYVTZCdzdYZnhCTFRBa0t2ZEpzbjBZYUMy?=
 =?utf-8?B?ZmhsZUJ1azVDdFlNMFVpblBBVVRCWVhGQ2hwaG02dE5yMys0djB4a0t4YXRy?=
 =?utf-8?B?azZxUWNhZ2dyZXlDRklxZndrZnBTcXNmdHIvbUZnK09ZTG9NUjFsRStaeFI0?=
 =?utf-8?B?UG1Zd2JxTy9nWG1XQlBYOEIwK0NDTEJRNUl1UUZDaUx4ZVRVenBBRHI2b3ZS?=
 =?utf-8?B?NE5RSDZEdGs5c2l2OHd3dkV3VFVYRmNFKzMzbGdDbGhIbThXdGlNWS81aUk0?=
 =?utf-8?B?NzZybzlLOGI5NDVnaThLcVk3Zk1rT0tVQ3VxS0VNdzdhRmZJeEpTUDU1WXly?=
 =?utf-8?B?M1crSWlMSDlSaHU0VTR0SGpPVVlIM0FlK3JkL0ljYlFyYXg1YU1NdjJWdTB4?=
 =?utf-8?B?L2tBanBTR3lkQ3dPckQ2MWEzN21OUi9SbjVFNkwvRXRpWW1jaktVMUlQOGN4?=
 =?utf-8?B?eitjRmUwaWgwaFI4cjFFSlJiQTlGNGZhaVFGeE4zWTBlS3hqM2xOdDk5SW1p?=
 =?utf-8?B?NVY3SElhOEs2RHdwVW1kN09xN2U4N2FPYXJiclViVU5UQU5mMTl6aVB4UTdW?=
 =?utf-8?B?bVRpQ0wvMWhZNlhldHB2REEvQmhGSjFlcHJEU3FhTUhqWkJlanQvZzhqa1hx?=
 =?utf-8?B?eEVjVTlTUFRUTEJKejVaNHh2K3BZZFNhS2dUeGZGS3JSUGdFRVZmazlHU2V6?=
 =?utf-8?B?UlVYT1ZPNmNTUXUxdmRRSXVwbFlSTFIwTXVKZ2hoT3QrM1FrTnAwNXYyRVRy?=
 =?utf-8?B?d3JGSG45eHZmNVVZNWc0ZDBHckhMWmxwUUQyN1pmMDI3aWJNbFlSYUtLdE5x?=
 =?utf-8?B?T3JkbXNZZVFxdUpUUTdvRXRQejUrU3YvYUtZS2o2elU1Y3pqUkNhZnB5Qlo2?=
 =?utf-8?Q?ChD50Lj+GeHLLC7feWgYb/ki1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5f2175-ed53-49b7-9e41-08dccd83af04
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2024 08:21:04.0251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xn+eErb0HOhIU1k0yFwg3C8dsZ2l1lwCbYtoiSXuHEse1zLytwJCfIxywArvS3UZ4vuIY7wGzBf1PT6t4mEd5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7472
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQGFtZC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBBdWd1c3QgMjksIDIwMjQgMTA6MTQgUE0NCj4NCj4gT24gMjkvOC8yNCAwNjo0MywgRGFu
IFdpbGxpYW1zIHdyb3RlOg0KPiA+IEFsZXhleSBLYXJkYXNoZXZza2l5IHdyb3RlOg0KPiA+PiBB
c3N1bXB0aW9ucw0KPiA+PiAtLS0tLS0tLS0tLQ0KPiA+Pg0KPiA+PiBUaGlzIHJlcXVpcmVzIGhv
dHBsaWdnaW5nIGludG8gdGhlIFZNIHZzDQo+ID4+IHBhc3NpbmcgdGhlIGRldmljZSB2aWEgdGhl
IGNvbW1hbmQgbGluZSBhcw0KPiA+PiBWRklPIG1hcHMgYWxsIGd1ZXN0IG1lbW9yeSBhcyB0aGUg
ZGV2aWNlIGluaXQNCj4gPj4gc3RlcCB3aGljaCBpcyB0b28gc29vbiBhcw0KPiA+PiBTTlAgTEFV
TkNIIFVQREFURSBoYXBwZW5zIGxhdGVyIGFuZCB3aWxsIGZhaWwNCj4gPj4gaWYgVkZJTyBtYXBz
IHByaXZhdGUgbWVtb3J5IGJlZm9yZSB0aGF0Lg0KPiA+DQo+ID4gV291bGQgdGhlIGRldmljZSBu
b3QganVzdCBsYXVuY2ggaW4gInNoYXJlZCIgbW9kZSB1bnRpbCBpdCBpcyBsYXRlcg0KPiA+IGNv
bnZlcnRlZCB0byBwcml2YXRlPyBJIGFtIG1pc3NpbmcgdGhlIGRldGFpbCBvZiB3aHkgcGFzc2lu
ZyB0aGUgZGV2aWNlDQo+ID4gb24gdGhlIGNvbW1hbmQgbGluZSByZXF1aXJlcyB0aGF0IHByaXZh
dGUgbWVtb3J5IGJlIG1hcHBlZCBlYXJseS4NCj4gDQo+IEEgc2VxdWVuY2luZyBwcm9ibGVtLg0K
PiANCj4gUUVNVSAicmVhbGl6ZXMiIGEgVkZJTyBkZXZpY2UsIGl0IGNyZWF0ZXMgYW4gaW9tbXVm
ZCBpbnN0YW5jZSB3aGljaA0KPiBjcmVhdGVzIGEgZG9tYWluIGFuZCB3cml0ZXMgdG8gYSBEVEUg
KGEgSU9NTVUgZGVzY3JpcHRvciBmb3IgUENJIEJERm4pLg0KPiBBbmQgRFRFIGlzIG5vdCB1cGRh
dGVkIGFmdGVyIHRoYW4uIEZvciBzZWN1cmUgc3R1ZmYsIERURSBuZWVkcyB0byBiZQ0KPiBzbGln
aHRseSBkaWZmZXJlbnQuIFNvIHJpZ2h0IHRoZW4gSSB0ZWxsIElPTU1VRkQgdGhhdCBpdCB3aWxs
IGhhbmRsZQ0KPiBwcml2YXRlIG1lbW9yeS4NCj4gDQo+IFRoZW4sIHRoZSBzYW1lIFZGSU8gInJl
YWxpemUiIGhhbmRsZXIgbWFwcyB0aGUgZ3Vlc3QgbWVtb3J5IGluIGlvbW11ZmQuDQo+IEkgdXNl
IHRoZSBzYW1lIGZsYWcgKHdlbGwsIHBvaW50ZXIgdG8ga3ZtKSBpbiB0aGUgaW9tbXVmZCBwaW5u
aW5nIGNvZGUsDQo+IHByaXZhdGUgbWVtb3J5IGlzIHBpbm5lZCBhbmQgbWFwcGVkIChhbmQgcmVs
YXRlZCBwYWdlIHN0YXRlIGNoYW5nZQ0KPiBoYXBwZW5zIGFzIHRoZSBndWVzdCBtZW1vcnkgaXMg
bWFkZSBndWVzdC1vd25lZCBpbiBSTVApLg0KPiANCj4gUUVNVSBnb2VzIHRvIG1hY2hpbmVfcmVz
ZXQoKSBhbmQgY2FsbHMgIlNOUCBMQVVOQ0ggVVBEQVRFIiAodGhlIGFjdHVhbA0KPiBwbGFjZSBj
aGFuZ2VkIHJlY2VubHksIGh1aCkgYW5kIHRoZSBsYXR0ZXIgd2lsbCBtZWFzdXJlIHRoZSBndWVz
dCBhbmQNCj4gdHJ5IG1ha2luZyBhbGwgZ3Vlc3QgbWVtb3J5IHByaXZhdGUgYnV0IGl0IGFscmVh
ZHkgaGFwcGVuZWQgPT4gZXJyb3IuDQo+IA0KPiBJIHRoaW5rIEkgaGF2ZSB0byBkZWNvdXBsZSB0
aGUgcGlubmluZyBhbmQgdGhlIElPTU1VL0RURSBzZXR0aW5nLg0KPiANCg0KQXNzdW1lIHRoZXJl
IHdpbGwgYmUgYSBuZXcgaHdwdCB0eXBlIHdoaWNoIGhpbnRzIGZvciBzcGVjaWFsIERURQ0Kc2V0
dGluZyBhdCBhdHRhY2ggdGltZSBhbmQgY29ubmVjdHMgdG8gYSBndWVzdCBtZW1mZC4gSXQnZCBt
YWtlDQpzZW5zZSB0byBkZWZlciBtYXBwaW5nIGd1ZXN0IG1lbW9yeSB0byBhIHBvaW50IGFmdGVy
ICJTTlANCkxBVU5DSCBVUERBVEUiIGlzIGNvbXBsZXRlZCBmb3IgZGV2aWNlcyBhdHRhY2hlZCB0
byBzdWNoIGh3cHQsDQphcyBsb25nIGFzIHdlIGRvY3VtZW50IHN1Y2ggcmVzdHJpY3Rpb24gY2xl
YXJseSBmb3IgdGhhdCBuZXcgdHlwZS4g8J+Yig0K

