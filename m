Return-Path: <kvm+bounces-71365-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aKL7EiBkl2mnxgIAu9opvQ
	(envelope-from <kvm+bounces-71365-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 20:27:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B48DA161FCC
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 20:27:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 618873015486
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 218B7306B37;
	Thu, 19 Feb 2026 19:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Al4JCqjV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC5F35977;
	Thu, 19 Feb 2026 19:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771529242; cv=fail; b=OWlSoxjLaMAwyYp4wJ7RQ97FOunHbHJqq0T4MSSpuQrD1/0i7XYk5CGnU0dCaXG5DWlCZPVc3EtC6KfCTN9DS9+Pi/ReTS4XDUTHe9ZbAsVN4ykUEO+xMhyGlQ0eLEDh3wDLEw1jiwQNQ+1Fsw+77WtxegZLFltq2Do1f19Uwh4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771529242; c=relaxed/simple;
	bh=cUqIRzMoxN7ewAJGUwKhYU4hQZHZOCc4nCBoU18FH0k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ML1XjoxnstpcZeZEp93HFPeZqqzsUYfx+utKkEMRINW3zKv5ZKxdn2Xm+LXH3k06vz+fqjWTjOuKmuggBBfV4uB0U5AxwatIFFmwQFYlRx0NED+QARvHffd5n/ckS5yQBz08MjEkUOA3e0QY5IetfvGncr7BJ7RFhSsRVzRmP50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Al4JCqjV; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771529240; x=1803065240;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cUqIRzMoxN7ewAJGUwKhYU4hQZHZOCc4nCBoU18FH0k=;
  b=Al4JCqjV+ORIRFRBOhIqEgWjOwVTHinprDHXfvGEb5rErIoKxHoxjlde
   6i+4lBDkrmIIiI02l4WYT7jMj12H/AknaKdZh9YTHaewRveDcE+b5dPME
   U/8NmRK3WIGmlj3nbKhWtdyd7BCuVFriQai9HkZD8UTBuOx/FV8Qa+M4d
   i+o0V12ret4oEn/DQ5siXkRHADSQDvh/slYqWTu3rLIuxbcYlU0DvJE16
   +urRYhl5anqNF7ZhPkGfEJGWbjY6sasn5Ft9ATkn42VjaBkOfkF6d8lz9
   1uTWG+DBSq6W1HyxCAlJEEcBWl7OmOGwc29i6faO3QRqoYIxNM4D7AnBC
   A==;
X-CSE-ConnectionGUID: IJpYyqTAS+eCT0sEYKVrnA==
X-CSE-MsgGUID: ISInBYJkSKONM6DAsLjiUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72329637"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="72329637"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 11:27:20 -0800
X-CSE-ConnectionGUID: cMZ0Jq/HR1GMZHu+w+wswQ==
X-CSE-MsgGUID: GzrQKssWQkGmHxBlZBT94w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="213730526"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 11:27:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 11:27:19 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 11:27:19 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 11:27:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LJQll3EfLte7nfAX8AHGkKy0QlOBI2YN/FDjQkSqnZ+Nj0L+x/F5bZRczyXH07t6D8mA92MdMXj1wlNh/EZIhdC2JmS1XKt4ffCB1whNLw0MF2G8JZi+irluAAhRz71lmcuxedPQkbF88ULJcWIHtEqp8cPtzzO1zLem4xpPmxk/Rn95b0NdpTmazQ/Pqb/PA/+QFMsGI/H0CKw29b+/8VzjLuKx4NPB4UCzVjXzJaMD50bxzCd02TrzMcv+4JmQgTd9q3qbhpV7545uO4E2vE6DNjPOeq4OcZ8fENENx2flVTC8Lv809J43ZpyMEVcTxknCajxRYW1td5b5bCs9rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sIbcJvr/mF+/1oRTD2UNsXehxNaM4yPAE6T15B6ARGA=;
 b=rkbzLNbAA24CbLGOlVHTY2JoiollBjZ/xXlKf/EMLpsC5gAWEmqZxADhfDpqyG4w1zSO0/RRqrOmKWMETD7NEb2diM6a3Kj9DBW7V6v2kCFFINFtPkA0he52m5a3yBpgSDe6hVucKtk4cUmI0dYkYLL3/yGuhN1w6efunaqlTePgtwZG/kspz5VOaoM8JmhQ2SgBukVP7XsQWo+Bpjotj0zQKeB0PEB8ruFsl4eFB/pZ8b6SnwkR8K4iJy/9MAyc7zeR0smHzDUcl79C9HVKEKhOx/+rzutApJL4GVeiwt0sShkCEAO1/sGOsQVIQ4UD8H9sA3ICPmUNMjTsfB/dXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7997.namprd11.prod.outlook.com (2603:10b6:8:125::14)
 by IA3PR11MB9423.namprd11.prod.outlook.com (2603:10b6:208:582::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 19 Feb
 2026 19:27:10 +0000
Received: from DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246]) by DS0PR11MB7997.namprd11.prod.outlook.com
 ([fe80::24fa:827f:6c5b:6246%4]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 19:27:09 +0000
Message-ID: <f7595e7a-e956-426f-81cc-63d742330532@intel.com>
Date: Thu, 19 Feb 2026 11:27:07 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
Content-Language: en-US
To: "Nikunj A. Dadhania" <nikunj@amd.com>, Dave Hansen
	<dave.hansen@intel.com>, <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <xin@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<jon.grimm@amd.com>, <stable@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, <linux-kernel@vger.kernel.org>,
	<andrew.cooper3@citrix.com>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
 <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
 <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
 <5cf9358a-a5c3-4d4b-b82f-16d69fa30f3e@amd.com>
 <317f7def-9ac7-41e1-8754-808cd08f88cb@amd.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <317f7def-9ac7-41e1-8754-808cd08f88cb@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::16) To DS0PR11MB7997.namprd11.prod.outlook.com
 (2603:10b6:8:125::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7997:EE_|IA3PR11MB9423:EE_
X-MS-Office365-Filtering-Correlation-Id: 5349afb9-f624-4062-c922-08de6fece01f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?KzBJSmdFOEh0MFN1R29CM0czcGhaY01GR0FGTXJTeUtybFVIdW5QRnhVSDdp?=
 =?utf-8?B?L0FxS0pqOVBibVVXZ2NUSkJsSGFqT1ZqMkNxQkplR1NGSDRyUEJ0bDJqR25q?=
 =?utf-8?B?QThnTExsaHMxYWFFd0tIZmVnaVQ0VzBteDh1ZTlLTTdpUWx1YXlROGVNL25m?=
 =?utf-8?B?TGxYOGpTZGtoTE1QOEJEakV3dWRzOHV5NEVodmJLS0xxY2ZNZEV4Z1hPRnND?=
 =?utf-8?B?akxkcFc2VWtxRVpjWFBGTW83U2FCRGxtZmtKNDVEWE1sUWhqVUI2aHpYa0Zv?=
 =?utf-8?B?OVhVSEhySnduRTdnVlVLNzR6UDRIQTJZYjBwK3c5UkVqZEJuQUNIcUIzd0RW?=
 =?utf-8?B?d2JxMWJuVGxTNTlXQW9CZHVscTgvUUZWYVRlVkp5WHArNkVrR3AyOCtJQnJW?=
 =?utf-8?B?dkE4N1hOTW52Y0c3RXBmUk1sMStwTXRoUUt3VE5jTlRvUHhSQThteURlZXk3?=
 =?utf-8?B?ZWRJSmYycitGUjlpTXdWdHhHYzhNRzUvZmRPeEp5ZTUrSENMcDFDbEVwaTN6?=
 =?utf-8?B?cTJxYlZJTVo3bHFDWUF5SWFvZEp2WkpyK1FIOTZoWHJza2ZNb1JGTktJaXlh?=
 =?utf-8?B?eUZNalQyNFpTbE85THVyK0gyTUEvMVYxYklRNGZ1cjIvWm5qaFN5TENZQUF4?=
 =?utf-8?B?R2dyQ0M2UldkWDdDY2dLSkVCY1Q1WnZEQzlVRzFLaE51WEtVUmk0K1dQSldQ?=
 =?utf-8?B?YWtYWHZCUExMQ01GS2x2OFFjd0NaSnpyZGZLa3hGb2ZLTHVCYWorQXRnWlVw?=
 =?utf-8?B?RG1LVlpsaGtjTHhTUXVpcmlidmwrWWVEM01nTFdUUnMwV0hVaVVSS05Xd0tB?=
 =?utf-8?B?ai92elB4MmtGVjJOa280Y2ppQUtydU9hdkJ4SDFZcG12eUh1U3ZoTCtoejJV?=
 =?utf-8?B?dm9IR0NxOHdNNHloSTF2elgrcnZKbG5HaENWUU4vRVVpK1FpZkU5LzJ1MjJa?=
 =?utf-8?B?Q2VaQ2JCdHVlRmJZQXpkTWQrbDV4ODNtQ0pSc1pOckl1cGRBRmZuM1pJR3dC?=
 =?utf-8?B?S1Y4bGRTMlRMQ05KVlFpT0tmdjJBWVZRamo1ck4xQUFmc2NadCt2RDRkOGhw?=
 =?utf-8?B?amN0VGRpaXRPdDE2SHhKeVF4b0pwb1Y3Vk9QRjZGakR2aTBKZmJqSHlWTmpN?=
 =?utf-8?B?U09odlBsbVZxZVdFZXUyL1NyTFRxM1I0cVNtb2tjTVFJL3Z2aW1lVGp0R0U1?=
 =?utf-8?B?RncrU0Vyb3ZGUU1mbU9aYlJqbW9UK1c3SytkWGQzbjNaZmRZeS9MQVZLbFNP?=
 =?utf-8?B?cXdkSkpobUV2MjQycEdsYUxIS2FCVjhoNkdCRmRweWl4WmY2YlpHaXZFV3c3?=
 =?utf-8?B?ekgzZkU4SVllVTM5bzQ5TFhrei9KUndsYnFTRVRWVWovUFN0a2VYbjJ2ZUFK?=
 =?utf-8?B?RXdnQkRrMlpiYU1KZlI5UEhlMWJUckJXVTFmb0htaDJtWmhEcnZOTlBpcUdx?=
 =?utf-8?B?cTdUT2xTekNaSmVpTi85ZW14cldaendpS2pBbkN0WVVpRXNwZXBmUmQ2THVH?=
 =?utf-8?B?MTFuSFF5ZWRUZkdpRHVwVDdGTUYybmhTa0dwUFQzWGZhVDc4ci90VFpKWEt4?=
 =?utf-8?B?WnBEemMwdE5xdEFvNGNMYy9rQmhEbGVaRnNJUjdDdk51M05oK3JxWDY0NHFr?=
 =?utf-8?B?VytJc1h4bDFPZUNieGU5ZS9wdTg2WSsxT09SQlJ3aVZxWVJ2SDVyY2N5TG0z?=
 =?utf-8?B?ZjVsRE5sN2RONUNGR2prRzN3UW1xWTFBN21yb3NlaEQ4SzV0SFd0dVp4a0hB?=
 =?utf-8?B?dzdheUh0VHZlRHYxWXc0eitUM1FuUFZBblFTSnhwQTJiWFluVm5iaEY4dGdn?=
 =?utf-8?B?TDErbCtjYkZ4S242amQycU4wWWowbTB4NEUrenYxcUl3WFYxU2FjZGhhaVU2?=
 =?utf-8?B?aDM5Tmd0aGh5OVFoR2pOOThSeUp1N2xHR0s4U2MrSlFWc0REc21SVGRueHlQ?=
 =?utf-8?B?dXYrZ21NTG1xK0EzamI0dmZ0ZFlRTHBEY1EremFqODlYa2xmV1p4emlKc1FQ?=
 =?utf-8?B?cXZHNlI0aE8wRnBCenVKT3BwY3Azd1RSemhDSXhSOS9UOWIwZTBuWDNuVEhr?=
 =?utf-8?B?NXcvQkRxL2EwUFhYRG9HVVFHeWRzUWtMcW1QVFBudjFPQjlZZEJCZFIzVTlu?=
 =?utf-8?Q?M0oo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7997.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVZPQ09VajUva2JDYjViUDVFaTBQRlNGQ1MwakVpT3ROSThKeEt5bnlBYkwy?=
 =?utf-8?B?MXpPYmtUY1I0YVJsNlpjWGlzc2U2b2JaOGtUYWVoRWZBZ2o0ZWp6RTBqMjdK?=
 =?utf-8?B?TFdWT1Nla3RCcWFSTTdSbXA1ZXB1SVlOdWJ0NGNzR0xKcHc4ODMzaFAvVWhl?=
 =?utf-8?B?QS9hOFNDV3VpSnZNNk02d0VTZktQQ1kxSUpwY1VFWHhLUTF5aG0zMGJkdWFj?=
 =?utf-8?B?cXdUUE02dHV1WkdKZHhsVFlwV29SSElMUkVGRnBTR3N0T3VjcHZqOWFTVUpO?=
 =?utf-8?B?OU1Ed2lJVEVuQTgvR0xROFoyaXZoOHhrQVBnTjhSSmFyRExRSk1lNTczeTBx?=
 =?utf-8?B?U1crMFBaMnprbjVKZWZOK05uTFRaM2w1TmhiUlhoZ2N3dEt5RzJaSHBCUlBM?=
 =?utf-8?B?djdEL3FEZnBOdUNyN29CbVNHblNwU0d5VWRYYnFrMjZJcVlQUlNYSENsa3pB?=
 =?utf-8?B?MTJ5V3FoVGVySDFuUFEyVGtsOTFEejFINndwTzY1Vkp1cnlWQktaS3JERHBV?=
 =?utf-8?B?ZUhEdW91NVdBaEJ6UzVjRDZ2SVl3WTNQNm5JVkhjUHdkeWtwcHJuRWQ1Tllt?=
 =?utf-8?B?cG1YdkQ3YXBCSVRvTzZFWktpYjdZL3QxLzRlR1lNRjRWU0ZtaGZqRE9yRjh5?=
 =?utf-8?B?ZEc0OWtaYmw2dFBlblk0K3IrZ29DTk9lWXYwU3JCVnBOYm9zQmhzRkd0bUYv?=
 =?utf-8?B?RUYzUXhUZStDTUIzL2VQbE11dERhM3d6NkVucmtKajN1ekoxa2V1MFpYRU93?=
 =?utf-8?B?THdFSGdQa1F3bTE5QTk4NmJOaDk4cFFvK2pVeEJ5R21idEg1dFV1Nk5rNFpV?=
 =?utf-8?B?alFuQi9mcHJYUldrQ3V3VWc3MGQ2Z2xFMjYrbkJTTlFKdzZkbE5TSnZSU3Fs?=
 =?utf-8?B?dm9DNHo3VmQyWi9JbEtFRHVjSUh6Q1BQenYxMFVoQlV3dkN0SVBNWmdpSE1P?=
 =?utf-8?B?b2RESEthS2drcmw1MStsWVJHb3RYeVRLczNIWmROVnVNdmVOQStrUTBRc3Bh?=
 =?utf-8?B?YW81Sk1PRE1CNmVsN1g2T3JtSS9FSDBHSmR6RHdSYWdLTVI4cnFhd3dmSlZ2?=
 =?utf-8?B?K3BSdGI0dSt6M2diWTlEalE1SDJ1TmhVZ1NPSmNzM29sQVV3M09MVUdHUC9r?=
 =?utf-8?B?MUVMc1ZhbzFkdGNWQnhzMnBXdzdjcTU4dmhCVnMwYVlndkZlRG5mRGdkTGtB?=
 =?utf-8?B?WUQ2YVI4ZUc3dmtKTCt0MWt1RWo1Vm1CQXFzSGIyY1hNS0dFamZuTDVyaFc1?=
 =?utf-8?B?VVBxLzRHQ1U5b1NvMHFkWWZRcXF1WGtBQ3ZBN3pVQVNDSDVHQU9XZ090V2pT?=
 =?utf-8?B?M0pWVFpKQ2RiSGJWUmNlMmNQQkc0ZTV5Y1RyL2ZoSWxhV0hZNjdaaW5tU3hh?=
 =?utf-8?B?M3dkbHFjUmkwMkJQaTdnLzlQcDM5MjJVNGhwNjd1YTJ5TURRcDJUdytkRzFI?=
 =?utf-8?B?Ti9OTnFJOU1vTzQrelBRN3VPY0NIWXAvaTFkdEVNRlZFN0ptZFNnR1BoRERz?=
 =?utf-8?B?NXEvbGJoTXZpalU5WEM3aEdiV0VhWm5TdTJXVmNUc1RkTUFvTEtET1pjb2tF?=
 =?utf-8?B?R2RQODZHckZzaVVzNmFQWWFXK3dHMDdseVFGTDNPdXdXL1pjWmZ4V2hwZGFr?=
 =?utf-8?B?THVaS0JGTDBWOTF6WlErZXN2Q3IyMXg4QmtweFBHNTFzU01zb2pUSS94S3Zj?=
 =?utf-8?B?dU9FNnhFL3llck16a2FUS043WVlaZkppbE04cStGTGVzK1ZpbjFST3RWRWdS?=
 =?utf-8?B?QjFFaG05WlZ1Y0NSWGt5QzRUWStwN3h5cnlCN3Y0Tm1oWFRDSXJIMVg2Z1dX?=
 =?utf-8?B?bVN2KzcwQTNONmxRdGIxY2pZcFdaVTFkc2YzdUViRU13YUJQb0JrRGZVYkEy?=
 =?utf-8?B?dk9xaVdDbVlmdjQzZzdwSStjQ3hVaUx5aStjckdaV3V4K2dEOGU1WHFMWnQ1?=
 =?utf-8?B?eS9Zb0h4QTNvblFUd3lnYWM2ZUZob1o5cjYwRnZ6QUlMelp6NE9OakFnUTJB?=
 =?utf-8?B?SzlBVElKcUVkd1E1MGVheDB6UkREUmJORGRVaGgwUDhvY3Myc2F3R2F2SE5W?=
 =?utf-8?B?SHVUek1KVlV0emF5SXJ6M0dCSUVIVjQxVzk5NXEyR1k1cDhBMzc4dlg4UU5l?=
 =?utf-8?B?M3hybk5GT2o1UWQrNUJmWHpaQnVzekgydHlWeURYK2pvT2xqcFlYNW04V3Uz?=
 =?utf-8?B?VnN5aUg3QkVWemFQb1FkWXkzSHJPYW5wazFITUtMc05ucVg0YzFheXppNTg0?=
 =?utf-8?B?VTNNTnF5WGZaNzlMdnM2cU8xa2RLb3cyRThqSk15SjJuSFlIMVVndTd5eHpM?=
 =?utf-8?B?YUZOLzRtSXBMWHIya1d1Tm1HVFhSZEg4cnY0RENYSTJ4TmhRTlJOQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5349afb9-f624-4062-c922-08de6fece01f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7997.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 19:27:09.8238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VX+9y8Ps5zvKgth79uGoDway665pYyuEH5aeWVMZ2H1NopX1W2YTYCjIzytVepknAAaJYLuxEGg2YWPu1KOAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9423
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71365-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sohil.mehta@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B48DA161FCC
X-Rspamd-Action: no action

On 2/15/2026 9:16 PM, Nikunj A. Dadhania wrote:

> @@ -502,7 +517,7 @@ void cr4_init(void)
>  
>  	if (boot_cpu_has(X86_FEATURE_PCID))
>  		cr4 |= X86_CR4_PCIDE;
> -	if (static_branch_likely(&cr_pinning))
> +	if (cr_pinning_enabled())
>  		cr4 = (cr4 & ~cr4_pinned_mask) | cr4_pinned_bits;
>  

Maybe I am missing something, but is there a reason to keep this check
anymore?

AFAIU, cr_pinning_enabled() will always be false during cr4_init().
cr4_init() always happens during early bringup when the cpu is marked
offline.

>  	__write_cr4(cr4);


