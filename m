Return-Path: <kvm+bounces-11391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9659876BFC
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 21:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FBBB282F97
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 20:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADC35E092;
	Fri,  8 Mar 2024 20:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dh3wTkcW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED7F2B9A0;
	Fri,  8 Mar 2024 20:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709930768; cv=fail; b=OE3jUjD5Zm+XA60l/jYaFR295rCaxjtJBpIvTVHPhxozvFtHnAzVV1Na25Rt8+3OwQrR5LJ5Y9Ynmup5wLLarkOK8qQaVU8aQPnP3lDMcTyC6WdK5WDPYYASuQb0qjiH0kn3SUjSG/h0c6H4+NkQajE5/UT5+95wIfEEX/AtyrU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709930768; c=relaxed/simple;
	bh=ZFHIK4fEo6JZL2NlV8yzay0pMMFv5xiDFXJeJ3lqPCg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CZrtr00YLLgjT+miibexeI1LJsz7U5f8ZQ6qK693AvW1mBKdaaFTNBK/1K7aqYsS66qupRKh6UCtyHdI7Lqzlj5OuvBwVi8d73C7tg2P4ArYJxyFzZlwZ4EqHdwNr91dsNryIf07hEuL31Ea1OIo45xam2VKlcoW9ocQ6GZMOSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dh3wTkcW; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709930763; x=1741466763;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZFHIK4fEo6JZL2NlV8yzay0pMMFv5xiDFXJeJ3lqPCg=;
  b=dh3wTkcW6KyZ0zz5Y4XWWuNaPrPdgdcusjlhU//terxI+B8WS8Fo4szt
   e8SDQBaSXS2dVzX6bNto7RNyFd6NQPFvyAvlyvMDi2nqh3RwqMmpRQts+
   ir/AvLEjEHT649io8b/b6Al/NYViyrip/TFtB/NjZez8ifeN9TNF5xCoA
   stFQqLGrG2P7XB5C3HBW/g18jQpa9P6T3I8RsXTOpdkxWeUtiMwpBwNdM
   NBkZ2QDneTDvYsiUWHytJrT4by3RtS89SS0UrYlsGqRIET95Ju42geiJo
   CRi03QSgVadMM/mE8sUWvemupuaciM7e2cBXiMs8r59UBi6dJnBVN96jj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11007"; a="22190920"
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="22190920"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 12:46:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,110,1708416000"; 
   d="scan'208";a="33721199"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Mar 2024 12:46:02 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:01 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Mar 2024 12:46:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Mar 2024 12:46:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxfXimqgMFEJG9n2TCL+A9Nq0+ziWxskjUPxP8tfshyzyXK1xfUh4mZu+bt2prMbsCBUHx/YCT7bCa9Pd4aKsmrocfEZhLTg7S9Kc5a8ukdQDH/IwqjvtLJgBkrj0FtNj3aEOAv5Jlahn9C5TFbNqS7z3cCH/rzjefanqdr3JJlgoC5ET5J1VKY7XYHOrVFVXdaYyDaJ/O3jxHkOwbthpz5WhXtSXFLOmdfXynZZPfjoybScf0p9By0d0YxD2XSJHF+jWY+Xznr0mdcEql7jKrktR4kx/UMiCKwq1hBNt32pAOPMfoG6eCc0x6bturSSRoUcnt0apACUkR3f9D19ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VqxElCkYvoMts9CD347BKG7MUDstoltHnMSfFVx02hg=;
 b=JhyuCoTnsfLYtNRMJvk84HMP+BeIEQHRKugJVPLPUpywmd7xlUpkBPJkaiq6c35m+dXt335PnPeqi/+ya4DBfZRFDiedPQS40hWUUWzOQA5V+e/ZgVXY7tT6z0CJ2NODX235twr6Jh3dJQpRMp4+bcPNjpj22uwJHVYtExXGYDyGeNdupqn7ROqluAoeNGYfEa4utXXnOK1HBtZQejNX2Qr8Dm7Bvje2MlHtAtAWUKla3hHH/hBOO8DNMO8OgKkc9BaT2K6MiJx4bZeCkPxuaD11O23A2Nn32A3PksnWTaobz/WIhrVAGv85UqbE1ruVcm014cWRnfNR2kUl4y8n7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6491.namprd11.prod.outlook.com (2603:10b6:208:3a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.10; Fri, 8 Mar
 2024 20:45:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::d610:9c43:6085:9e68%7]) with mapi id 15.20.7386.006; Fri, 8 Mar 2024
 20:45:55 +0000
Message-ID: <93c4acb4-94be-425d-ae10-92e1096139ae@intel.com>
Date: Fri, 8 Mar 2024 12:45:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] vfio/pci: Lock external INTx masking ops
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <eric.auger@redhat.com>, <clg@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kevin.tian@intel.com>
References: <20240306211445.1856768-1-alex.williamson@redhat.com>
 <20240306211445.1856768-3-alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240306211445.1856768-3-alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0316.namprd04.prod.outlook.com
 (2603:10b6:303:82::21) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c6821e-4bf4-437f-44eb-08dc3fb0c018
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFICfw6ORO9Kqiy9seLgh2Jc/4AVQKO1auTX54yZD/9ad/bw+Dea4G6GSnk+ldpTywLClCTclB8uhQRJctjoUT1kXr0GbIpACaTZQbWA3vywrcwmxQUCUOCqszgAW4E+FFwUmuuYTGCScrcJxE21V+vULhSNXKW7ZTVqFmhsECg9GOJvKvatkeypgY7Mq8k2JfZk4QWhic6T4m+lRdi/2Dw99l2QIuoeo+sOSyvvQZdkwpzwgNwKDWF1PZyDT644Apwebc4gi85fHCtRh9BO9l5sWw2ulFWZddmGpXYmYXQnsvcYpYsXH4kUe0zNerlH3LNEwDnHdD3FEOPRc0u2uv5uY7ZgE8ERe6vZjTORF4H7wPlau+K2HgpcN2XvWLmLV6+BIYelc3K+BXeGyVbn4dryuGwZtfWcIX8q/BtM4wyG11SAcAiyfy0LmrKekeKvjv9FgRqYzpdzCHTE2K/pN9ciBYVMQPBi1pCZlxb0AbpissCoaXdbtpOtx1HkjreCkAqwbt70jlEUv8xzST/YTlJvNimIk3h0oSS69J35dKFWdHcnZo4RhZeZwqEAd/4nuTCE23KTqkAczzbkt7Q4QEFj+hwMBsJnwgKFspMqXXo/b24S7TC8Yz82jugBfB7YU/8nON4Ixt/LHEqY7VGKZU8viLRBnhGsEUUyybq3Bxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGJwd3dBSloycHI5YWtkYmxxOXU1UDRWZk92SWNiTDA2MVp6eXgxOVZsYWZn?=
 =?utf-8?B?ckkyZ09uMWptbWxHQXF2ZHgycVBTSkFHcUlCWThCODNQSUxlOUlLajVvZ09t?=
 =?utf-8?B?a3JiZndtL3d6VFhESHFZSHkyL3YrREhuczRGeGt1ZlJzMWs0R2hxVWVCRXJ4?=
 =?utf-8?B?NFdnRnlXcVRUeFBpYTFYbnU3T2pKMFlHcmlab0lqc1U2YkdDQzNrbHpZVUhC?=
 =?utf-8?B?eWhqVVhYMk82azZwaGR4b1ZrUnNiaXBMVTZWRndWNnc2VjFtSHVkTlFQUkFN?=
 =?utf-8?B?YjNyNmlkc1hzS3pjWHV6RW9zRjNqS2p1N2pVKzZCUU9oS2VveFlaazdTZVJS?=
 =?utf-8?B?N0pvc2h6YUZOcXBmdkpzaE42RFB2Yk1wUzAxQmVxcHJiTitxRFlmN1cyeFBs?=
 =?utf-8?B?Y2ZTWE5lUVZFOTRpcXE1VGVMNk1ZUEo1Qk9iZkxQWWFsNU43YjN1cFZBMUNo?=
 =?utf-8?B?cWRqdEY1UjN1YThRSEtYbWNQTEJJdGRvNEhsTGpaRkt5U3IvaFA4SDRoeWxC?=
 =?utf-8?B?am1yYWh3N0NnMkQrMDhyREFueVp4RVhRUHV5TXU0YmU3TnBUVnNucmhxcG0w?=
 =?utf-8?B?UjFHamF4UHkxY3lWa0FHcitXdnA2OWFNNW9SaVB2VDVRM0dZTFlTRVFOTHBm?=
 =?utf-8?B?NmE1cGJyd3ljVnFycWYxcEZjYnZGdjdFK0phM3VuazVJVUZ1T0w4eCtTb3Zv?=
 =?utf-8?B?bGFNNTRtNEliWE5saG90dkJhS3d1YUU4N21sZWpiWjY2cEUyR0ZMdlM1Wmgy?=
 =?utf-8?B?VkZxamRhV3VLdkJYTmFUQ2ZBUE9haSsyYVNwVDM0eTlaNEZXQ1poTzBOUG5a?=
 =?utf-8?B?ekExb2lWOC9tRUFyQmhtT2NxZm1lVmxvdmtwcWNaalJXZktJQlM2RUUvcHRK?=
 =?utf-8?B?TTJZSklJQ3RvcXV0QUtyYmtnN201MUxhc256YVdBS0g3NmZWYVBlNllvRVdU?=
 =?utf-8?B?UDgwYzc5eUtkanUrempod2Z0ZDJJai81cEVrcFdjK1lpYVYzbHBvMGo5Nm1h?=
 =?utf-8?B?ZlQ1NVkyVVoweXRNeERhc25Sa2FXclUzMXhxQ25zOTlqanJKZzZyYjcvQW53?=
 =?utf-8?B?L291eFFCSitPNlMvblQ1SURtNHF2cnBaRTN1ZFFnbXQvTmhuelVFR2FIVEUw?=
 =?utf-8?B?dnU4a3hYTFFBZW5iVDNkMDUzSmEvQnpKOGNOaVJCYzVDZ29XRWdHT0NGY3I4?=
 =?utf-8?B?eGw1RFFPZTNGMDZaZTc3M0l6MUc0a3d6VmducDFROExXRWllaGMyVlRYbzRT?=
 =?utf-8?B?V1FlcE1zd05UbmRja3p5MGlqaCsrUHBEdkRZSG9JTGxaZWJXUHdGSWp6OS9u?=
 =?utf-8?B?OHVVOFdSdEJOUVNLTWJaU1RwVmRlZ3pKKzBNSGVpd1gvaC9EanlqWFA5S1l4?=
 =?utf-8?B?endtSmt1ZjRmTnppYUY1YURFVnhaN1YyUjBCT2JpektGZS9YT2hnVlNURkhJ?=
 =?utf-8?B?bU80M2NxT2JrT3ptOVpDVmdtQ1FPaUFYYzlwanBPdWRDNUlJb081THRIU3Nv?=
 =?utf-8?B?TDA2SGt0SlEzUFd0dnBDTVVBRjhMTkV4bm45V1JQZGlBbEt4U2RsbjVOcWdT?=
 =?utf-8?B?ek1UNHN0SWl6NVdpbno4WUhnLzY5S1R4UWVkVDFWbmlMNURWeGlDVmhCSVRD?=
 =?utf-8?B?VGdCalNweElUODRRNmMxM1hXWCtiRXkrdWF2aGxpSTZLTVVrdGVpcE9lTWhz?=
 =?utf-8?B?OURZcHQxekFpV0RPVkN0ZW1DNk9yN1Zla3FsMDZvcncwRGJLVmVxM1MzakI3?=
 =?utf-8?B?WFd4S3J6SitWUXp6L25CR0NUYjBKNVJUeGxxSzNHM2tzSFRIN21HUUdxelMw?=
 =?utf-8?B?ZUNhcHRPblBNdkVZcEIxUXdFcXZDRVpnWTVKa2VrMS9EaDhkZEdYR093K1BU?=
 =?utf-8?B?RnNLU2MrbDM4Y0pGS3lJV3AyWHRnMXdmT0pER2xEbE9RM2Rtcy9ORW1sQ3hK?=
 =?utf-8?B?bExuYkZHYWQwTzkxdmdVWmRwQWNqV2F2ejk1dnRXTC80UkY2SVhVNWZmL3li?=
 =?utf-8?B?MTFVUkM5Yk9QRFZTczM5RzJGVVJnU3NEazBCb2YvQTFyV09UTTVKci8vSU0w?=
 =?utf-8?B?TXVEUUZOTnJoMzlTQ3AxRXJpYndScFVLcVVnWEZ1bEVZWGladmx2U2ViSjRY?=
 =?utf-8?B?RHlpU0VNcTYrS3V4bUdlTlR5dGQ4THVEc2VLY0VMWmVDRmFqK2xwVjVJVnUz?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c6821e-4bf4-437f-44eb-08dc3fb0c018
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 20:45:55.0834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04Smty/Lghrrn58DUU5spvBZlRkG52yBZ6D7ixO4q2z1/FQ/02rNSrtioMkrxMo5lNrOaN/UYMQmoGuqoPA20/EaENsDpSIPiswq1UY+GHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6491
X-OriginatorOrg: intel.com

Hi Alex,

On 3/6/2024 1:14 PM, Alex Williamson wrote:
> Mask operations through config space changes to DisINTx may race INTx
> configuration changes via ioctl.  Create wrappers that add locking for
> paths outside of the core interrupt code.
> 
> In particular, irq_type is updated holding igate, therefore testing
> is_intx() requires holding igate.  For example clearing DisINTx from
> config space can otherwise race changes of the interrupt configuration.
> 
> This aligns interfaces which may trigger the INTx eventfd into two
> camps, one side serialized by igate and the other only enabled while
> INTx is configured.  A subsequent patch introduces synchronization for
> the latter flows.
> 
> Fixes: 89e1f7d4c66d ("vfio: Add PCI device driver")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Thank you very much.

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

