Return-Path: <kvm+bounces-35266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5761DA0ADEF
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 04:35:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42A70165D11
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFDA145FE0;
	Mon, 13 Jan 2025 03:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yzyrd8PP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76E71B95B
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 03:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736739312; cv=fail; b=JsZchwebB9Caf/Cz1Wpo11NA17Y4Pi8HSpljmZIJPV2Tpei/A3l3ogcfYN6vV0hEdBrvnaBLunIyxG6mOuAsNkGSotEzH3jzSbUbo0OHtb6GBIMcMu5DM4V3VXwnXAxuWODOnz+kPtphHFRNGZGCgm4yMk9uRLwJPriy2jobEcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736739312; c=relaxed/simple;
	bh=diJppkgtBOgJDKJm/XlyVyapekelVFfQjvjScFLYxeo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e2D5Z09qzAgwsYSYTQmN/bMAqvqA+bXZ8E1J4MmKifYrIQJ5zTFrtpDzuMRKLGtYu5BB9k6drOTHmTTkhJhWek4BBP5Q7t5b2LFiieRhUMn0EnELKRDfqPsZR9D4UQ92WG1FZK1vY7oAzBJcMc6/Xels5mXfsJF2MgLvqKiYIwg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yzyrd8PP; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736739311; x=1768275311;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=diJppkgtBOgJDKJm/XlyVyapekelVFfQjvjScFLYxeo=;
  b=Yzyrd8PPG2hiajZOVIIibLMP+OoqtdOf61tDGGmnI7h+NEQTVchAk7Zy
   e3TJ+sTWKL6OBF0zXUV8g9qFF3i7Kd/BRau5Z2+zYzYP+TqIaeh5t/E70
   KEimtV6r2UK9f82sUFOjB10VI6mEFd/D8mK7QP228rElnw4JNt44SFdRW
   kx9oUShNahtBzwbRpBL+h27/6JfzgHJgeJrI+hLH/HWYz0buUQQEtRaEQ
   JlN+B3sRppoud9z1xapgFwh64MOjQRztZsws9Aq6u4/fdWshLecCXL4+p
   sA8/jmb6CHzRAKlrs3PS1f7kuhDdva59n2irvSvSj8mDThj2Z9HpycGJk
   Q==;
X-CSE-ConnectionGUID: jMNCpEsCTuqwHMxe11R1YA==
X-CSE-MsgGUID: T8hFKWGETeOmTUftKpcJbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="39796410"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="39796410"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 19:35:10 -0800
X-CSE-ConnectionGUID: DR8yDQkETvK+oXAdpqlvKg==
X-CSE-MsgGUID: 8U8eTbFmTj6xPYGraFIY6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104133788"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2025 19:35:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 12 Jan 2025 19:35:09 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 12 Jan 2025 19:35:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 12 Jan 2025 19:35:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AuxM7KfuKibydhUhZauUM00MPdDOWnfYCVmy6cLHX2B8RFgf/iXWhq+K1MTwA/aFlJg41n0/ndAg5D1A9lkMU0KMy2SyIQL5De+mFHtGgS9fFKQr2IUmHHXSK7WbuE2H3f9r0KbnomIo6HEiRBaHbyA+iVR8pMETT75R1i/QjDwNeibhgci3XwnPcdv2ifbaWTMNWw7KQ84mfdRrGg3IpEtWlpNQqUgwTT2pUfEi7sHYrd7NqJ9z83PhPAdFM3RtqQPxTHgurOHzCK6T+ZF1+w8HkXAXcJ9tRy1yIUoOQ7aJ8kjq36Dfdp66JX+5PyAfM5ouP106mBEklkTV7TbNVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIQTbgmnRhARvx9nO0N2MFscY1uwAKQnBKRfKZ67N/I=;
 b=mchpOncDDNuUxavClZWsrPROxXOVm6iKJxsgrBg8xQzUeLF2l1vyyKExyI8gOATDLfVUIeRti+XUlmea6sy3pgWo7lJ2p3FFp/ri+3lm3UOAn1Gp+slzHgSmoIqI4dnF7siMmmTaBFX89cxBZA3BLshcMQw4Ujf0fEzezO8ddx26zVoFpdAB2UDmKFtHitKnh2KZ+6lrXAeEBKIBx6GSGmsc7vkrUme3SCUJigtxL68malrLwqoCAxIz7m49uwdc23FMHSclMqHc0QavCod9l3oQfyA+1XWmmvbYwHQ13n3X/jJ2wq+C83f9GWUMrZoF8NkjnkyMjiDKEPXFVDAN+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 03:34:53 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%7]) with mapi id 15.20.8335.015; Mon, 13 Jan 2025
 03:34:53 +0000
Message-ID: <565fb987-a16d-4e15-ab03-807bf3920aa1@intel.com>
Date: Mon, 13 Jan 2025 11:34:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Xu Yilun <yilun.xu@linux.intel.com>
CC: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	Williams Dan J <dan.j.williams@intel.com>, Peng Chao P
	<chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <219a4a7a-7c96-4746-9aba-ed06a1a00f3e@amd.com>
 <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <Z4A45glfrJtq2zS2@yilunxu-OptiPlex-7050>
 <Z4BEqnzkfN2yQg63@yilunxu-OptiPlex-7050>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <Z4BEqnzkfN2yQg63@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0022.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::34)
 To CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|SJ0PR11MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: ed0fb33d-6b85-432a-4c77-08dd33833dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bDVTeWZ0bk10c1h5T3pKZzM3NUJlQ2ErdHYrdDVodTVnaldETlM1bkNYQWZY?=
 =?utf-8?B?V095ZENqL0UwelNJNGpaSUlvVTZ2bGYvdHhlOGFQVDBYVWd1TG9qcDNnQUda?=
 =?utf-8?B?aUJiUnhhU2t4Ym1qSEFGWGQvcEdzY1NoRmJFc1JtbFZuWlhCMzZPRGp2cita?=
 =?utf-8?B?RXI2Yi9qaFNzZVQ2UzVETTg5RFVDWWZwYXUzM3VNdXYwT0syVXl2YmN2TUZl?=
 =?utf-8?B?R3RiVFdGWS9NbXlTY3BSQkV2VWplYkdxTXcwL1EwZjQxcmMrUjdlZkpweVoz?=
 =?utf-8?B?QjF4RW5rYWFDS2ZJTUpFMDMwdUR1engyZnNkY2lCdlA5V0hxc3BqVHIxZDBk?=
 =?utf-8?B?L09kbHNTY1VyTUR0VXpmdVk3NlA2d1BRMXRNdGhMMjRLUW1obGYrUnAzdGZr?=
 =?utf-8?B?MDNnbU1JZWtuTkE2cW11bU5NTVpRTGJDZWliOVQwaGtnSWJ5VTNMSHJJY0t4?=
 =?utf-8?B?S3Z6RDBsYno2ajZ2WkxFbjBJVWFnRWQ2Z0pBamxiNUlDd1EyK04zbVdOaytH?=
 =?utf-8?B?b1BUMlU2amUyVVlYakVucGd1UG4veUdkZkI0R3VyMXYyR0sxYTBqVmZrUlpJ?=
 =?utf-8?B?aStoOVJIekFGcXJ5WlBhTjl2QlNrbTJxWTZORHB0SUhMcGMyM3prM09GSjZy?=
 =?utf-8?B?ZEF0L0lUZ2NVVElBYjdCOFd1TUlaZkw2cGt6TzY3OENWVEtyS1R3M3Zab1Rj?=
 =?utf-8?B?WnlZTDBSRGVWQ1lLMjI3OUl3WUE4MEhxWWxJK3BCVEtFZWd6RGpvKzFaeUt2?=
 =?utf-8?B?VXBMODI5bmhzeDdzRmxNQ1h0dDRMZURLU1d4NnJwdkIwZTdvdEJtYkVWcHVo?=
 =?utf-8?B?U1NFQmc0eHVrNHcrWWFzWmIvK2lUS0hQM2YvSFpmUk8xRXlTUG1vWS9QOTMz?=
 =?utf-8?B?d0thV05PZkhBRUhUWUhEVVhtZks3SklnazlodkI2ZWVtblVYM3JrYk85N3JE?=
 =?utf-8?B?ZnhKTkg4Z2lQTXVralRxUVFJdkNreHlGOVMxYy8vQnpLYURKaDc3Z09oTWJN?=
 =?utf-8?B?MzM0MGdGK2R3TzFtNnAxR2ZDaVFnTU1XWjlZaDEyYVM5azNKUGRyV1dEQU5J?=
 =?utf-8?B?dXU1THJrL200cDA0VUxEV1krOWE4S0ZrZFhCUkxUczJPS1RGUlJ5bzFtWExv?=
 =?utf-8?B?ZkFFUEhEbUVNNVRpelgwa3NRTm9sTHN1WVdjSnVXNUhZT1EzYjhkSHliS1k0?=
 =?utf-8?B?djNqUzM4bDVjOGc3MW5mWmZnbDRtYldYdGEzZHRPNU16S01Ed3lMY3dvTG5B?=
 =?utf-8?B?OXdNMnRxL2UvanNRWnh6WCs2d1lVS0JjVmFFWEVMbTFxYit6dHVIUzc5V1Z1?=
 =?utf-8?B?MnhFTkx4YUNQaGxWbUVnKzNYMHFTeUlldktjVXQyNVZmMXhObHo2RmV2RG5n?=
 =?utf-8?B?bW9LVmlvUGw3cXNlNVM0RW5LSmFodGExbFVqbDVXT0hHNXRHelk4b3ZmL1Rr?=
 =?utf-8?B?NGpQSGhUaTJFWm5aaUx6NTEyeGM5T3RtV2pMbmhYVXphOXR4aURRNk1PRXdW?=
 =?utf-8?B?cUM3c2l0SklhTE5ZQ1hMdXV2RE9oK1JIQkdZNHFybFJWVjkxcEdZMnA4VGgr?=
 =?utf-8?B?TnB0YnBTcWx1S25ob3gxS1hqNEpJczZvYXhPY09ZaHFPdGFYZmtwdFQ1TVJl?=
 =?utf-8?B?dXFnZnNwWjE5TXpCdjlJV1FNSmJhTUd4eEpiN29FZzdpcTVWaXh5MkQ1T0cx?=
 =?utf-8?B?cUo4bjh0eXZWNWRpcmlpaTFBdWhVdysxaWo4SVJLOXVqR1VpMkd5MFYyRFAr?=
 =?utf-8?B?ZkFVU1Q3TGlYdFRqdDhLZFV1WlNLT28vK2lheXh2SFFQakpyeERSeHFSNWNo?=
 =?utf-8?B?aThyUmFCKzJNNjZvc3JmK0poUlZNVUlyb3NuMU9KNllCcFgwL0ZqSU41Skdq?=
 =?utf-8?B?QmtxUW9OZlBFa1dQZUNzR3dtcVEyUUN4dFdTSlBOTlZYVGc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDF4RG9od1N4YzhMYzg0MVhHbzgvTllpeExrYlArY0RLS2t5UGN4dVA5QkJk?=
 =?utf-8?B?WHp6eE5sTG5KWDdhcjF0Z2NLQmVyRzhQWXREK3MyQUUwMWtpVXhVTE5IeXZl?=
 =?utf-8?B?Yi9BVUFwYWIwbVlGTjFkS2F6Z1d1S1NUQ3lyVUx0QXRnR3loWk5jVmc3N2c0?=
 =?utf-8?B?RXBaWlBaZitnUU1uU0Y2OEV1dzk2d2JUSVg2SWNMdFJNSWdqQ0QxVkQyZ1pw?=
 =?utf-8?B?cWNwY3djd29CdG5LbHE4ZExyNzBBSC9jZGVXNjdOUmJxcUd3MkprNVBxOVk5?=
 =?utf-8?B?RkZzK2puUG5sRkJGemZKRFdPMjkzM3FHUTNDdytOVzdQZFhsV1VPWUpTMzRD?=
 =?utf-8?B?Um5RQ0dsamY2YWFqK2FiZlI2OFZ3NWVxS251RE1tZ2tEWUNQMEFrYjEya2RC?=
 =?utf-8?B?ZXNYbnlCYUpFRjNhWmN6YnlsbSthZXhmVVBNQm12Yk5KWVlqdlVZYnpHVDRF?=
 =?utf-8?B?MlBVcTFwNVhWTnFXTFpLdkZZTGs4UEtaSXM4S3E1WC9DcmxTZnlhNnJMWitv?=
 =?utf-8?B?ZjBHYmpiNWNYMi8vY1RYbHMwZ0x3Z2ZZYUIwYXNpOC9lL3RIZkp4bjZIWnY2?=
 =?utf-8?B?U2paN3BqK1JiM01XNkR5S1hhczAvU01KUzdYNGRnWk1NSFVBKzd3TDlPRFRm?=
 =?utf-8?B?U3NKZkJGYStKd1FQTkJvRkxjMHZnVWcySlhtRFJzWE1DU1A1elhyUG9ONFc4?=
 =?utf-8?B?WnVnR294UUxVZ3UwSjRyN25OdlpxbC8yZDN6RzE2TGsvdmZtL0tjeFRTaUhM?=
 =?utf-8?B?N3lEdUxEU0h2Tk80T1ZKenMzcitWd2tTalM5dE5sMm0wMmwxN2VQZFhPVTht?=
 =?utf-8?B?N1AxWkFJbGlsMnpuR3ZWandCSHZvYWNqK25makxVQ2JZY2M2N1ZTbU1GWExa?=
 =?utf-8?B?aU1pcUNqb2YyVHQyQzVSLzdTbEVtWitmOWluNHpOQVlvTGxsZnp3WmVqZFF0?=
 =?utf-8?B?OVVuM0JSUlc3TWJYcU1rTk1MaUhweEdVQTZqRGYrTFBxYmN5SmNENXZ0Q0Ni?=
 =?utf-8?B?bncwRlhuZGdUR0MrelpYWS9jOUZBa3ByRGNyc25VTWtMRlBmUGtlQVRuQTl4?=
 =?utf-8?B?MU5TbThkbE5VajZHOUNmVXlKd28rQWJQeXowZDZxQjFUMHNGS3AyclpsNHU3?=
 =?utf-8?B?SGh3Y2RIM3RpdHdSVnhySTVkdG16VitYM09HUXpFSHB0dC9Sc2tnNldGQkI2?=
 =?utf-8?B?UCtNaVExZ24vaEdYVThiNExXaE9kNXJsZHZyVndldjFvZ3g1R0V3bEQ2aGhu?=
 =?utf-8?B?TlJMcVhKbXpqRXlxUmJmUE9pZFJZalFFL1F1MC9hSm1BRzlNcUduRjd1d1Uy?=
 =?utf-8?B?THpzY1V1cDh2RU9MclFRaU56OHQvL05VY0FKUVBVMThRUzlqVE5NYlZDdGRu?=
 =?utf-8?B?S0JBSHJab0JOdzhyMERlQW5yRzlSU0xTOHZTOHBVR1Q5dVpITlFseEVPb1du?=
 =?utf-8?B?QXVycVJJa1QrQ25JTmNwbE9mMm42ZXJnaEhZeGc5cWx6Q243RWJyRWQ1ZFl2?=
 =?utf-8?B?ZmVBZnh0L2RKelpzT0Ywanp6cklkc000NGthUW5yWll5ZDZLekFRZnJvckwr?=
 =?utf-8?B?OUN4ai96WUY2TVJxNG9oczdXcWdIK1B2bU9jTHRScXFjZDFYOHVDbDNvaTJv?=
 =?utf-8?B?aFd2LzgzVmYzZE9wT3QvbXBoVE9VYWFnNk50ZDF2emNCTlByNStVSS9icVFI?=
 =?utf-8?B?UkM0R2VKTXpPYzFleWNRdWZYMENEYXh1YlNHaVRvL01LM21nU1JnTDZVMStG?=
 =?utf-8?B?QTRkYlhMUTF2alV4M2diNW5lTzNaaEpZOGJMUDNiNFkrZ2pzaTBrNDRNOFVs?=
 =?utf-8?B?TFlaOW9CVmdlUGlsRVBMc0xmbWZraXI2RmRNYndVZ05jYmxMMXRxUSsyOTNk?=
 =?utf-8?B?QUp5d0NQVGI5aTc0TDVOK1hMb0lrdi9BRGo1dTlGN2hld3c1L3oyNlJSam5X?=
 =?utf-8?B?TUtWcEVWSXV4dzI1UlZ1Q0YxVXM1TXRKZ04xeGtveVZ2NE8vKzdkTHdiMzhF?=
 =?utf-8?B?a21leFMvbTFod3NvVDBMQUZTVkg5RjhNMnVXS2s4U2p5TmNhMENSemZGOHlq?=
 =?utf-8?B?L2NkbGhQNEgvdGxHYWd0aWUyL1p1eVBkRUNTWktEc2ZsbDFmYzNraUVpRWlZ?=
 =?utf-8?B?RjZpVEVXOWRJd2laYlZDeEJqSjlOUUNTWGZlN1ZabXZGWnR6OS9Wdmt3ZnJt?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed0fb33d-6b85-432a-4c77-08dd33833dc6
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 03:34:52.9555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n92y0MxCCx3UqjCuDqwxo2XhlzKmnCUE3q64KyPJ6FVfhagzXL5pGqW/XyUG/zrq9N1K458IWu5129+XSNGCHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com



On 1/10/2025 5:50 AM, Xu Yilun wrote:
> On Fri, Jan 10, 2025 at 05:00:22AM +0800, Xu Yilun wrote:
>>>>
>>>> https://github.com/aik/qemu/commit/3663f889883d4aebbeb0e4422f7be5e357e2ee46
>>>>
>>>> but I am not sure if this ever saw the light of the day, did not it?
>>>> (ironically I am using it as a base for encrypted DMA :) )
>>>
>>> Yeah, we are doing the same work. I saw a solution from Michael long
>>> time ago (when there was still
>>> a dedicated hostmem-memfd-private backend for restrictedmem/gmem)
>>> (https://github.com/AMDESE/qemu/commit/3bf5255fc48d648724d66410485081ace41d8ee6)
>>>
>>> For your patch, it only implement the interface for
>>> HostMemoryBackendMemfd. Maybe it is more appropriate to implement it for
>>> the parent object HostMemoryBackend, because besides the
>>> MEMORY_BACKEND_MEMFD, other backend types like MEMORY_BACKEND_RAM and
>>> MEMORY_BACKEND_FILE can also be guest_memfd-backed.
>>>
>>> Think more about where to implement this interface. It is still
>>> uncertain to me. As I mentioned in another mail, maybe ram device memory
>>> region would be backed by guest_memfd if we support TEE IO iommufd MMIO
>>
>> It is unlikely an assigned MMIO region would be backed by guest_memfd or be
>> implemented as part of HostMemoryBackend. Nowadays assigned MMIO resource is
>> owned by VFIO types, and I assume it is still true for private MMIO.
>>
>> But I think with TIO, MMIO regions also need conversion. So I support an
>> object, but maybe not guest_memfd_manager.
> 
> Sorry, I mean the name only covers private memory, but not private MMIO.

So you suggest renaming the object to cover the private MMIO. Then how
about page_conversion_manager, or page_attribute_manager?

> 
>>
>> Thanks,
>> Yilun
>>
>>> in future. Then a specific object is more appropriate. What's your opinion?
>>>
>>


