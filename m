Return-Path: <kvm+bounces-23831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E692694E91A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:59:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 667A31F20F35
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 08:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C99E16CD39;
	Mon, 12 Aug 2024 08:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4cHqezr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7309C14D712;
	Mon, 12 Aug 2024 08:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723453171; cv=fail; b=U5rwgn6MVgGJbSIngHWLnPT4MpHvEbzBASX9k1Kpk4lyedbO9DgVf1YUvaYC0mE/DfMsNINC5RKN4JNUBHmi3t/ZdRyvqP2IRhEDnILkzQREBCJOHCNIO/VAlqvvQ+yyXkTs6fAnHyqkvbSxJlUvmF+G/sewR+a/OGVTXTMMujA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723453171; c=relaxed/simple;
	bh=EM0q43LKBG0ko4GA22pzNyIiN/K5Zj0jcnRvgqQCN1o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JVUQUcNpMqKR0pHbkNlONqjIIJa7+OrgXaqdB3mfbVShanT3+T6Hr5CrUQH129WTwA1f4DQASi4EFt5J+cmHkZspi8BVcLoiQnFqIHbcpwZgdWCePhr99IUs9x+E73NRj8lVfmEzROkNZbjcHWSL0KXjO5GeAXE7NXoA2L5HduQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4cHqezr; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723453169; x=1754989169;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EM0q43LKBG0ko4GA22pzNyIiN/K5Zj0jcnRvgqQCN1o=;
  b=S4cHqezrEPKkjbp24hluJdQSLJGqZCVoiOaTdmm7aPXOzfzlMn8PMpxg
   1x6XtrRtUiTaN9l7UPryiuKuas30zbxqdSgyzq8nkodhCGcCUWfTsv7VG
   1lurF1aTNgJvAAQiV5EazqyqMm5k9nYHVNJID7Fii4meh4im7p37ZjDz8
   QD1BxY4U14PQ1qrq+JdML9U+pH1UCvyixFICptzuLikwzVEL8R0D3pdJF
   E0r7Rufj3kjU4OkAvARsh14nIebMMddFvUadCzOm7Q5uLm6zy5XZOSJ1T
   IopmzSErDCEF43M1hKIY1we/NLX12omN/a3NiMqisVuGoZJMIbgf/DOxA
   Q==;
X-CSE-ConnectionGUID: YEvJdpm8SauhT+j87mc5Cw==
X-CSE-MsgGUID: /GKzlICERI2nKrNVOtocWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="39000419"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="39000419"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:59:29 -0700
X-CSE-ConnectionGUID: 6fgjSHqjTyqaP3fyIHMSMA==
X-CSE-MsgGUID: JWnKS5CeS0eS3ff5hv7c9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58132664"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 01:59:27 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 01:59:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 01:59:26 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 01:59:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 01:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nYoqeQz36/y3EGUIX2Db/avdfVb4iXgKt8EBij19R9ltqvOorIaiXd+13pF80Pj7Q/JdpvOcBglVZx+k/FNAf6X7ugqUrf6/ByqNKxBOUSQPzCTeW/Kz50mR0PXeksyyTaTjAXLjgF5m0mEvlP7F64RSJJ75ZAIh1W/3Kn6jWiLn3qXT33yJ26AT6pR2ESzuceQ9pKmcs61IBaZw7DZYgAD23bxw81yOq2bi2OeLhvtxsO8nz3nzIAa+GrDzjl72HHiTsZ7V+rB4ay/n/zZ/XcKpxRMdYlhbr0aiAMN1DAsoUOBnzfBOjiNiTJSt4Nuam+5Ff19KcJfF5G63l0IwyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/Wp3TIGqKYVX3FB/QgptCKQBUDcuKu28wG5nlq8j78=;
 b=yYvQLNoYYK9h8dRDkdbGOHrOqPa5jeVR8MMPsFpp3j2Rg3w0Lj5yhXtn4Ft9trO7bRv8sHdQZqVUi2OruRGWcq1xMLXuHxEiaS5FEZBH+CS+FBx9DsrHe/TS8NoA831PRN0enC/e8mwnfStauZlBtZqHUPOtWjdz7yYLNlnUxql9lpUgqNih/a0LKTdm9TFQrUeoMysC4yyutVDq9r8+2BbtIQBAanrNTor0D8B/UQ3nltGJkS6uPP8Nus0o/oYRA6410un+kM5wlIvy4vXWiU890W9eYn5tOjb+ZfuHekClxn2Gy5rzRgdpvV2mrEWAI4bNjoPZomdZeWEmE7sVnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6243.namprd11.prod.outlook.com (2603:10b6:208:3e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Mon, 12 Aug
 2024 08:59:24 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.7828.030; Mon, 12 Aug 2024
 08:59:24 +0000
Message-ID: <880c1858-afee-4c30-aac5-5da2925aaf11@intel.com>
Date: Mon, 12 Aug 2024 17:03:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Will Deacon
	<will@kernel.org>, "patches@lists.linux.dev" <patches@lists.linux.dev>
References: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
 <BN9PR11MB52762296EEA7F307A48591518CBA2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240809132845.GG8378@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240809132845.GG8378@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d147108-ae96-4061-ca8c-08dcbaad1000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q0hwVWsvY1UxbmQyaTZ6b1NBbzBLNGRudFJUWjMxRGQzbW4yWkVGMWp0RlY2?=
 =?utf-8?B?U05wa1lOamJxWmV0WVNRcnFMSzVsR1JoNldUbEJRV0lReTBlTHFRblBLN25t?=
 =?utf-8?B?cmJZREhUa1lWVUVBTmlZWDR1c0FqamxJdVBNUjlFTFFpa01ia3ExY2lZWHFx?=
 =?utf-8?B?c3lDbkMyWHk3enlUM3VJVlFGZ3FoWmhXTWJGVnhIZnNLaGtHVjNoY3lNK1lV?=
 =?utf-8?B?M2NCNGdldmRFZ284MHNjVjVpeWcrbzhOdzlDb2YrMEtJOGNvOU5lSFdhcFJx?=
 =?utf-8?B?VmZ0emtzT1Q0T3gvZ2srdFh1eW13Zk8xZFVYUmRKKzFqY1lTMy83QzBJMzFt?=
 =?utf-8?B?Vm93bGRPbmJyWHAvejE1a2h0TnUwNFR4emhHN2dVeklVYmVwVXNVV0lJelFs?=
 =?utf-8?B?UGNqcDc4N2JLUkc1STJrbG1VYVpVbXM3NkhiaHg2UnlidkoyU0dsMDBEMU5h?=
 =?utf-8?B?cVUzWEwzM2V2QU1vTDVoeE9lcWlkQ3NDRnF0NHRwd0VrenBlOUc0YmtIbSt0?=
 =?utf-8?B?eXlRSzZsZ01uVllMUWtnd3RBTlk1dzIzemNuZzVOL0czb1QxQjBHN2grN0M2?=
 =?utf-8?B?RldjbXYwRE0wNFRicHFka0U0alBSdUFHOFRhbFJzMDRSeTJoSnRveHJ3T3Bo?=
 =?utf-8?B?SGRTd3M0SjFKV2hkeU93RXdsVjdSMFdTQ2RoQi9YSjJJZG41OTlEa3N3VUJx?=
 =?utf-8?B?ME5qcUg1ZWFUSnhrTDNpQUM5L1E5NGdNTGxiVC80VC9sNlZ1RVZhbTZpMGNz?=
 =?utf-8?B?MFVMOGd4QUNWeFRMSFJ1d08vRno4MVovRmwwM1lIUzFxRTdhdnp6R3pLWjFZ?=
 =?utf-8?B?aVNqSCs0RFJHUUlsUDc4VmNxb2ZSeE1hVlBaNm1zdzRSQytYeWhFN3QrOFZv?=
 =?utf-8?B?YkZDK0d4OElFZ3pmTEV4Q1Zva1FhTWlYSzNoY2dTWkN4eS8wTjhTbytQcWRt?=
 =?utf-8?B?TXJWcTlFK3pDODlNLzFXV0JpMHhReHVaZTRIMTg5enVlcjBYOHNLQytzWWxj?=
 =?utf-8?B?eEpoSnJKV3lNWmw2Q2tPbEhDeFo5bXEyeWE1K1dvVGxTdWkzREc4ZXVUUDRa?=
 =?utf-8?B?TDAvVnUrL3FjOExyckhFRlNJbVFNTFV4VU9raFE2Q3djd3NVa0xTVzlPNk5i?=
 =?utf-8?B?RHR4RTJrekRkMDRLMDQ3aEtxcnZ5bUhTbnBodmpCOUtuYWl3emo0UjZIVlh2?=
 =?utf-8?B?b2Y1TWlDVURWaHpRZWQzVlZWOFduRjR4cm1JeXFQWHhJK0tpRjFUQ1FrQjl2?=
 =?utf-8?B?TWlhUW0xU05mY1RINFEwbFhqRzVKN2tHeTJLNWFTYTlHcVBpamd2TG9SUXNP?=
 =?utf-8?B?ZUFSUWlvdHVXZmtpUVlLZ0h1T0RLcHBTUnRLYjIzQUtXRVczSzdoWUJtQk5E?=
 =?utf-8?B?bGdCL2dlUFM3SldQQWoyZE1QdngyUVowaXVoMjhBTWIxcUxvZURuUmFjdW5z?=
 =?utf-8?B?cFJvWlVFVHRoQnB0TnVUeFNkZnJJTjlvRno0bktVcGFYR05DcFJaNm5BSVVo?=
 =?utf-8?B?MHRTOGNrSkVXUHZkLzRwZjZreGpBWml5ZUhERkkrOWZLWXVGTjhTTjN2OFIw?=
 =?utf-8?B?d2dGcVpOaE9NQTJsWkxZcFRZcnY1YWhRdnNnbG5TSWxSUDg2R3prYWluN2Ns?=
 =?utf-8?B?ZGlCN2ZvbnJCR0JNeEpJU0p4dkZUN1U5Q1lpVUI1TEFuRUtsYldQWlRTNDNo?=
 =?utf-8?B?YnhzY3pXRGxYdUZ6cXkveUdFd29KUm5nVklQTm9ITk4wSWt4SnZKSnFvYXhS?=
 =?utf-8?B?aUY1KzhhUXB3VGp3VlJSS0VLN2Y3Q0xaYUt3SEtVaVRZbmw0SE9GaFpwNXYz?=
 =?utf-8?B?QkgzL1IrNW9EdUdLdWRvQT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjJudWh0aEJVQm9USzdsbWVUOVpRVkVneFFweDliZGxiWjlKODN5U25xbkgx?=
 =?utf-8?B?S3lia0tHQ09CcC82UTJiNlJNcEtsSW00ZnVOZm9RRmRlTEVmQ1VFTEVJdCs1?=
 =?utf-8?B?YVhQT3c1TUR4YlNWamdmUWJzNmY5c0pVa0E5QWRZRzY2UEdkYmNkNVJzS2xD?=
 =?utf-8?B?Qk05UllrNEdhSkFXbWc2bXdMTHg1YmYyVktFamJqV3lyclRXbDFSSk0yZDJp?=
 =?utf-8?B?RkZrSDd1UHZ1Z3JkWHBLTU1La0xlbklsWXhMU09VQzF0eXJ2MnZwTEFDcUpz?=
 =?utf-8?B?cVFycmt3ak0ycWg5bHE5WExCS2s5TG44QmthUWs4MWg5RUF1Rlh2cFpWUlFw?=
 =?utf-8?B?Z3FLY2pNdUQrbzM1VHlTbUFmV1hQUzNNYy96VnBNM0pEZWFBb3JYQ3ZFdno1?=
 =?utf-8?B?bFRqMlovOHJuaXExUGwvS3FBby9TUVVoVm8wbWhhdjdjQlRjaDN6aHJiOTF4?=
 =?utf-8?B?M2JMRHlya1RGdFNHWm9qTjErZi9oRG5zTXhsVitIM1RzeDRlVlF4R202RkVY?=
 =?utf-8?B?b0tSaGVDMjNiM2RQREdMQUJRRkZPc0RsUFRMRlRKbWhMNkJKWUxrREFkdVJt?=
 =?utf-8?B?OE9WRjgyaFU5TlJIMy9KajM3Q2NwY1o2RTAvNGxIR2VwOENNbXh3WlpmMzMr?=
 =?utf-8?B?Y2d2V0t0dmp5WXBkbFBEbENXV0RsUlFqVGNGVDV5Nm42Nlc1a1NGMFVkVDQ3?=
 =?utf-8?B?WUNLcW5OaFI2dm1Sczd0ZENHMGxNS1NNQ1BEWjF6UHNvQUFTM3BkSUkzNG5K?=
 =?utf-8?B?RVJhNkJPTUlCNEg2aERGMk5ZV3ZPQXEyejZrNzhIeDJJblZvQ3pjcnVWaXZy?=
 =?utf-8?B?WnhQRnZReXFBdk4zeEhOdTF2dklXRlNVQ0w4Y25kYWlYYzdsN0dnZUk2Tm9D?=
 =?utf-8?B?dHczTDRnWjlhMVgzWEtwVkJQZTV4eUxqTGozcjJRdHRYcVFOU0tadXBNWmdK?=
 =?utf-8?B?SVBVbU16anlvS1ByemVHOUs4YWdXR0ZmNlh0V3FsbERmdlo1VldvcVRpT29K?=
 =?utf-8?B?dkxJQ3hkcWR2KzdUQTE3ODZPcitTSllMMURDYnh2UkxxcWNNQm9TSmUvaUNh?=
 =?utf-8?B?Q0E3YnF2M24zWGJyT2lOa00wZU1YSHdoeHhjS285MElWRlRXQ0oyMGpyNFU2?=
 =?utf-8?B?SVRJUzNBVnZrQ21hbkpIZ2hCOUl3Qm5la3Bhakt0cU5vOXlTMU9mNTBISmFa?=
 =?utf-8?B?WWM5MStlRUlMaGc5VWVVY0VDOUswOVNJSHdFQllQaEYxRHVhcFlpM0N6b01Y?=
 =?utf-8?B?NWNJMEljZ01vZU8wRkdTb0wzbFNUb0ZQdGxxV0ladUJOSXpmdERFNHNpVE9O?=
 =?utf-8?B?NUFNMzhuYnVER3lUbHF6TGFuOXdxL09TY0tHTVdvQVBUcjMwcTJZSjBnc3BG?=
 =?utf-8?B?aGFSWmU2c1pTNDZBZ0R2aU9uMWd4RlBWQ2FrdnhieWpyZHdTRk5BSHNXUmwr?=
 =?utf-8?B?c3daaFYrUWMvMHprYVljT0dVNkxlOVdzTnFzbGcvRjA5c2FzZFROM25zRnJq?=
 =?utf-8?B?SDJialNGcWpsZ3VQNGNQMnljQ0tDRWxUb0p3SlJDay95bDRDbWcxbHptM3pv?=
 =?utf-8?B?enBVbEZpczV4TTJlSloreEgvNmlEQjh5TnRLcm1ObGZkNFRBMkVyd3VGckcv?=
 =?utf-8?B?NEs4L2QyaENBblYvS1ZuTThRV3dUL3h1c1ZXeks4eVppU3NGSDE4cG1aTEZW?=
 =?utf-8?B?dENaV1ZqZ09xNi85NGFxaEF1U3MvRGcwT3FnUytveHAxVDcza0NhQXFkM2lI?=
 =?utf-8?B?ZnFUS0xwOEd3YjMvMSt6SDFoNmVrdEYrcEZnNUZ5QjJoZ0JzVWo5TXpoc3Uv?=
 =?utf-8?B?RW50VlYwM0tLSWhGL2VoSGdKZjg1aWQweGN6MkNodStwdG44bGQ1clRScFlt?=
 =?utf-8?B?OXI4KzRhdEpvcXRVQU14Um1oUWt3OUdLdnUvMks1N0U2ZStVY3ZDTkJnL0Nl?=
 =?utf-8?B?K0ZpamE2WDZVaXl2dTZldTUwYmg2SU5ZN1VkRnNpN0k1RHpjVnFwU0xaUkEw?=
 =?utf-8?B?UDFmTXJ2Y2FPcG9hZEFTODc0dVFMSGF2aUdOYnJWMUVqSkYxSlRMblN2WGll?=
 =?utf-8?B?Z0dycU5jWW45dFhzNnlwU0JPcDZ3RFFNM3VMc0E4clFOQmxNcEM3U2tIS1NF?=
 =?utf-8?Q?oOwLWtpK3VxYw8RAEBdKyZMDE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d147108-ae96-4061-ca8c-08dcbaad1000
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 08:59:24.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtjTrzmAW6NsEKinPfkVAJZ96ZON74+JQ655KzdjdJ1jNQhb3gxBemGRsLXIcpavLbygj0wDknc63cXqBwmO1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6243
X-OriginatorOrg: intel.com

On 2024/8/9 21:28, Jason Gunthorpe wrote:
> On Fri, Aug 09, 2024 at 02:36:14AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Thursday, August 8, 2024 2:19 AM
>>>
>>> PCI ATS has a global Smallest Translation Unit field that is located in
>>> the PF but shared by all of the VFs.
>>>
>>> The expectation is that the STU will be set to the root port's global STU
>>> capability which is driven by the IO page table configuration of the iommu
>>> HW. Today it becomes set when the iommu driver first enables ATS.
>>>
>>> Thus, to enable ATS on the VF, the PF must have already had the correct
>>> STU programmed, even if ATS is off on the PF.
>>>
>>> Unfortunately the PF only programs the STU when the PF enables ATS. The
>>> iommu drivers tend to leave ATS disabled when IDENTITY translation is
>>> being used.

I think this is the common practice as it is not necessary to enable ATS
since iommu is passthrough mode. :)

>>
>> Is there more context on this?
> 
> How do you mean?
> 
>> Looking at intel-iommu driver ATS is disabled for IDENETITY when
>> the iommu is in legacy mode:
>>
>> dmar_domain_attach_device()
>> {
>> 	...
>> 	if (sm_supported(info->iommu) || !domain_type_is_si(info->domain))
>> 		iommu_enable_pci_caps(info);
>> 	...
>> }
>>
>> But this follows what VT-d spec says (section 9.3):
>>
>> TT: Translate Type
>> 10b: Untranslated requests are processed as pass-through. The SSPTPTR
>> field is ignored by hardware. Translated and Translation Requests are
>> blocked.
> 
> Yes, HW like this is exactly the problem, it ends up not enabling ATS
> on the PF and then we don't have the STU programmed so the VF is
> effectively disabled too.
> 
> Ideally iommus would continue to work with translated requests when
> ATS is enabled. 

As Kevin's pasting, the Translated requests will be blocked. So it does
not work. :(

> Not supporting this configuration creates a nasty
> problem for devices that are using PASID.
>
> The PASID may require ATS to be enabled (ie SVA), but the RID may be
> IDENTITY for performance. The poor device has no idea it is not
> allowed to use ATS on the RID side :(

If this is the only problematic case, the intel iommu driver in this
patch could check the scalable mode before enabling ATS in the
probe_device() op. In this way, the legacy mode iommu would keep the old
ATS enable policy.

Seems an alternative is to use paging domain for IDENTITY. This means
the TT would not be 10b, hence it would work with ATS enabled.

-- 
Regards,
Yi Liu

