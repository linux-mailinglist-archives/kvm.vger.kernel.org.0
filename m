Return-Path: <kvm+bounces-26606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEC5975E6D
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 03:20:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6766285288
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 01:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A473C1CD2B;
	Thu, 12 Sep 2024 01:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3QhemFF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B061AACA;
	Thu, 12 Sep 2024 01:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726104013; cv=fail; b=XdbVxOKjLWGWLmeZkJAvJd7IHKgD9YiLTf9AdbqZEOd8Z9J/h+I2eqWEpMtKI8EHwq8BoAgWyxzhL8y6QcfII8L5oAqbqQV4luRNbTqa66skZbak+ZsNyxcWohPfqD4bgfS/wsw6Um/Epp+sU/SgiKEVNOHvIXbgu9+rHED76m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726104013; c=relaxed/simple;
	bh=LlPFLpZ7OvjWzzpX4DyylzNAd6Rr1YLG8+rkeoBZTnQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d9aH9oLkSCigIXnaUtoaFnKdL7GxJyO9r5jwdsXLHj40K208Xy7j4g5w6Gx3WbiwtSQGtOpu2r81cqf1mLcE1Bd073+HhOZ1L7Fw57mKtR+Qw4ZRypFJ8KfnOGdtuTEmfr9IOu6NOlSocNBiFhWBvVZVMEG7meLERsYGS/gDGhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3QhemFF; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726104012; x=1757640012;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LlPFLpZ7OvjWzzpX4DyylzNAd6Rr1YLG8+rkeoBZTnQ=;
  b=h3QhemFFbMY3Q0X9h4iUG1YayKYF/7SlrYtpAiCS7bDW02qPERUMaohS
   j9pyZZ+59Qx2T16S1P1ZMoXLg3GrQggi9OlEzLNLkGsQ8uDJn0SgVuITX
   CWN7T/c8bdPiGEoperPQhRnLUt9OeN3XCeVpjaqWRRFUN7ykux4N+JlAL
   +U7AXaKe+O/3hK71R7h9FSAtRg/oFB/lUesey4IPfaOqIaeCZOHxBOW0J
   ZV9WEsh+vvRKau/O5p+5xzt0EoCBlmsAGsGVQdNOQ5cnvMvef2o/m9s4k
   EMcT7lE6g3lygxB3efLcoLkElF4wJlC5R9g9dXycLhmRMToT2XTth2JJT
   Q==;
X-CSE-ConnectionGUID: 6nFi5cTlSgGd7o5xU6ay2A==
X-CSE-MsgGUID: +nUF9E4PSd69pZD8lrXN9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="13481628"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="13481628"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 18:20:11 -0700
X-CSE-ConnectionGUID: m43QpreXRl68xt1SjHhLaA==
X-CSE-MsgGUID: GxcOfggxQ9evvd5PjZnz1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="72345151"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 18:20:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 18:20:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 18:20:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 18:20:10 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 18:20:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4O20m9kk3X4pw54nOHq/6VX4JAathTCkV19Cd4RUNHuiawN3Y37NVy8a6FsjeCObenw0YJEy0Gz8+8lrE5BpI7ApQnse9O0+KVcytvzhXkx0F0t/0Kkv9h1kB4eOTuZ7d3cEpgG+/dzLMpuUdW9iIg+rMiwDbpawoXyj5v+Wh7mTpvLxRUv0SEl39nFx09WUMhkVFz84cIyVmTl4/lpNJ2xWFsJA9OOalux2cDNWBWypWdjBcBKfPXIlCbOGGUvqCDH+q5p5ttP6vbHygtMKPv7FP0TjXBKKBEK3bF7brlzsK/cIO5cMmusFvoz2RJ23Us2oGg+vZpu1dzQ1b+CpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BczAsLz/jh+6Gj5aMFNO+i3r+j+zMGDJauVGt/VU3s=;
 b=vBvNGnTDEe1etnVHsiAxoG/d4ngpb7FrG4wGxoQTZhQSFPmVEnlwzfuMS/g3lFhugs676UXV8YeYa3xGeUC/lwyVdOZtoOywdDXVx0yl9tiQw1MAbMCPWQgSrh6es/U0+geBprIpc4kEfknQIRnwWxI7fbMKFoQkMXCY6OlSrmgNGBTXT9Sb+DAZ4VD3DKPgLEWoE/yCGktC2ymcnPbohINt0RkH8ioWZTTu7D2VZonaKWTQC6EjTiAstKsxtfy31GMiGvzTaX0tVize/EX8FKy94qZXisJRBNlQ/eGf2XmWq3Tk1OTlPKS56tWHM2+6lbDIdYf0AuAi62UqW8tp1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6310.namprd11.prod.outlook.com (2603:10b6:8:a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Thu, 12 Sep
 2024 01:20:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7939.022; Thu, 12 Sep 2024
 01:20:05 +0000
Message-ID: <7ff58b42-ce51-45ff-90da-231db5e0c79e@intel.com>
Date: Thu, 12 Sep 2024 13:19:59 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <dmatlack@google.com>, <isaku.yamahata@gmail.com>, <yan.y.zhao@intel.com>,
	<nik.borisov@suse.com>, <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240904030751.117579-6-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0165.namprd05.prod.outlook.com
 (2603:10b6:a03:339::20) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DM4PR11MB6310:EE_
X-MS-Office365-Filtering-Correlation-Id: 58e1bc56-0572-494f-5a0c-08dcd2c90883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QWRnbk81RFlwaDJRejJpU2Qwd1JOeUprc05BZzhBUElHZ2ttMmNSVzFTa09h?=
 =?utf-8?B?TGczWUgrUnVvTjJTazNGeGJBV01zTEZqYXNPbnBwL0FBUUgzM2V0SFhWUXVY?=
 =?utf-8?B?RzYzZ29OQU12aXdYRGFvcmZ4VE9IZnh4eFByYm9CcGZIWjdsUmhHYU1aM1FD?=
 =?utf-8?B?YmhtN0xGMUNaM2VGdEw4SFdDQkppSm5BNFNuQmM0dG9KTGRwU2ExS3NuL1lJ?=
 =?utf-8?B?MFlubTZkaDNwaUpkWElzb2VKUis1TTY0Q3VmWkZoc3lIMzh2S2I1Ulc5dEg2?=
 =?utf-8?B?QkpPTEt5aWxzVG85SnUwNnNWM0cxcVcwQWJYRjZLWTVIc0pnTDBBcmExb2sv?=
 =?utf-8?B?dnErRkEzQldwaE0wMmlJY0pqRUlHVElBeW5KUVJFRmNUREhDSmFsaGNmbDMr?=
 =?utf-8?B?dkg2M000bXcwY1FpVHdjd1E5eEExL25YQ0VGQWhwclRHYzhuMVF5eko2d1lt?=
 =?utf-8?B?T0I4WVNKclRjMDBVUEZUMDliRUtvemg3WGs2VHV6V2RqMnFGQzNnMjdjcnJ0?=
 =?utf-8?B?eHZsTzBmT2xXSGNibHBlbzY0ZjExSFhjVnRBTDdxNVJBeTI3a3pHRFk2Vitl?=
 =?utf-8?B?M0kvUWNNeThncGJmSmNyZFhqeFd2bk9mQ0hwb29aT0s4bmdHN3lJK3pNdVFk?=
 =?utf-8?B?NnA5RVE2TGRYVjUya1doWktTODU0MENNUjRkdWU4MHVSTjhKRTdYV25pZXFa?=
 =?utf-8?B?a3lHOUlHTWhNc1c0L3AzaDV1eWgyck1IaXl0L1BLNUVqRkE0SjhyYmdyQXFL?=
 =?utf-8?B?QnJmSDhFNVJPd210MndjMUpqQ3FZWjJxMWRHclA0VS9xUkR2TlNFcGR1QVJ0?=
 =?utf-8?B?cURkczBzWmNObWRHUlNwdE5nSGFZc0F5ZFhNdjViMVJKdkZyZGpEc1cxNkFC?=
 =?utf-8?B?UTBBWGFDUWF3dThmWWFNaGNkOGtXdnhCRFVBb1dNb0FDalV4L1dLeGxlaVNz?=
 =?utf-8?B?UEhHOTB5N0x6R3dZb3VRL3BEMzFnMnpmLzBJMCsxcG1SZ3N6VmNnT0pWWUZI?=
 =?utf-8?B?TjY5NFd4a2JjV21LZEVnd0tiUG9HRFRJRHlsZWxiZG5CTWdXYnJhY1dZc0xD?=
 =?utf-8?B?NThWdC91QktteG5YS1AybHFPbWYzZk1GM1hldFdwZDVMbnNPY2FEME9yTVhr?=
 =?utf-8?B?bGhqZEplVW5Eb1RGSUkwa0xWcmVzSm9DMzJmQlJRTllSQVEvNGJ1dlQydWxG?=
 =?utf-8?B?TG9DSWJpUGlCMWFoOVc3RDlPNzVrdlFhQUttMHJ6SXBrSy8xZkhyZWRyM1ht?=
 =?utf-8?B?MCtUSHNlUjlBcTkySnE5Wm9QNWJLTlJYQlg5am00cTJHSGhYT1U5UEtweUgz?=
 =?utf-8?B?WGJ5bXlwR200bzV4WjRQNnJBR2hLcUdFUzBWNmRxakhFRjdyRTJPbFYxY3ZB?=
 =?utf-8?B?MEN1L3MwZHp1WFdkbG9GRkM0djBLZ0ZTcUtZczAzUDlXL2c0TjRHTWpHSEM4?=
 =?utf-8?B?K3M3Q016RE52UW0yZHpHZi9udTZBejhtb0hTVSttSyt1ZzVHRG9Nam1VUm1Z?=
 =?utf-8?B?a1VOTEVzS0xrWDlHREJiZVE2TzFuYWhKeDd3dUhzZ294YlNBQ010Sk9OQ1hF?=
 =?utf-8?B?VWdUYzBLc3orMytoZzBrV2h4OXhSOGVqaFJBRlQrMFJDRGtaL1dxdlkyb1RR?=
 =?utf-8?B?UmlMT3B2RFJXRDRDM0JPZlpyS2pwZUhQZ283SWh6blNEeDFGL1BVZUJLR2pG?=
 =?utf-8?B?L2NOMHVtV2VScnVUcmxIUUt5UlF2dkFHLzBTNXhSUmtya1QwUFdRTENiSHhS?=
 =?utf-8?B?V0lSczhOa21aWXhScEk3V0dvSTNneU1acjZ3WkZRN0xUclFzTlQ5U3FvOGsx?=
 =?utf-8?B?ZUJ0S2JBVEV2MTRuWDZ4Zz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGVDekxLeG44OGxlTWkwNWpyeVR4bTM5MlZmei9keHROYjl6YkxuV3JBNTBa?=
 =?utf-8?B?YTcwa2pZMFFwR2lxNVZGbnVXMmdsZ2lpTmJ0RTlGNWFBVTB6SlE1eHVDREpX?=
 =?utf-8?B?cHg5NWUwdHVzY09QMktudXZCZzJnd0dNT0RuUXNFaE04eXFibHNCemZha242?=
 =?utf-8?B?ZzFZcTJBcVBBeEs0aytjc1FwTTU2ajZOcVFLOGJFYTBaa2ZQRFhkRlcvRFpp?=
 =?utf-8?B?aGwybURjQXVrQk4vSWkwdHlUTmxGTUpLRStuNzJUNzhUMGpibXZTVVVqRUZk?=
 =?utf-8?B?MjVwQVdxUlRzYjhMbFB5UVdPK3orVnNEOVpwMXFLcjNNZ2l2YVhOVHdjWnNJ?=
 =?utf-8?B?UE5CdjFtMjdQemFndzhEdEdndkROVnEwMG85WTkyVzZhd25YMEpiUmlvTlZ1?=
 =?utf-8?B?QVRLNDdFUWhzYzNnRTRtQmxtUExEV1ZMSmIvQkgrVDgvQ3YzejdNZTBRaE9p?=
 =?utf-8?B?MWtkckdnL29oNFUwUHQ3dmpzRGVsaldPaTNrbEVQSjVSUmVheGZRWDhwQlVa?=
 =?utf-8?B?Z2hXSy9qOTRTYWtaNUFlaUNtTFlZT1IzdzJEVUtpQ01pMjM5YnpOZGhNOGxL?=
 =?utf-8?B?UkxSZHJYYVIzKzdkSDgwRDg0MWdCb2hLNmR3bzBSYzdwT0pTZkpsbFpSeHlR?=
 =?utf-8?B?Zk92NmdNVnorUmxpVCszOXNyZk5zOWpyVE92dFNhdFVnRmw5Sk10TW5NYmY2?=
 =?utf-8?B?bUJtN2NoVG5KM3VMUmgvWXNrWlI1OFcrVW5UVmVaaHRCcEYxVXRvZ2xGYm04?=
 =?utf-8?B?bW9TWTJsTmFHVm1OUXo0d1czTVgwaUg3STBpc3A1Rk9NVWhaSlJTbnlWalo2?=
 =?utf-8?B?S1U0dHJCeU1OTU5lK2Q1OW9LcUU2UEh1WEcvcEZXTXFkdmlheEcza29LMExB?=
 =?utf-8?B?cGZRTjU3UlhpNHEzbzczQWhEa09qQXF3Y3lIb3JFaUQ4em9WdEliQVNFSWdV?=
 =?utf-8?B?YVk5eFI1V3UydUlMYkxwcHQ0TzRqUE9tWWtRZE9nMnNCVXM0aXFKTGtQK2Rs?=
 =?utf-8?B?UjVPcEpRVXY1WUVHSFV0WjF0RGNFTHJGUHFRVWtLcXBvdWcrTGNDdCtma3Fp?=
 =?utf-8?B?bkxTamZXdDBvanVQNUFhTUF3a05MU0EwSTBoc3FwbnphbTd2ejdIaWR1NkRO?=
 =?utf-8?B?RmZ2Y2w4TzZIWENvNGJXMGd2ZkVrTkNMWEZDc3JEazBzaW1Vb2o5a3R2cXV4?=
 =?utf-8?B?UWdvVEVRem9jdEdLREdyUk55eFpRQmpwRFNiTzlGNVJaMU12VXQyT0IyNk1Z?=
 =?utf-8?B?bE1YU1BrNDF2L3UyTmRmamgxaHRsNkRjMWgvN05LNjJIQnZvb2RaRGhLSE91?=
 =?utf-8?B?OTFyQmYrbjVlNCs4bFdEYTZHVVJBVlVBN2dvNXpoUXZPRDhlVzRXTjV4U0Vz?=
 =?utf-8?B?amI0anhxK0ZVRUFBLzdnSTNQUmxiU2FaTXRIUEdoOFhBanl0WGFkbVRkcCtQ?=
 =?utf-8?B?VHpobE5PRjFVdEhMVWNWNlFWQkVLK0tpYmtybEVtdElHMjdCWHh0V3pUQXdQ?=
 =?utf-8?B?NVBSblRrZkJ0bktGZjJjRkVuWU9rcitkT1ZWaGl5eXQvdXBOZTNmVWVFZG03?=
 =?utf-8?B?c1VzTE1HUWM0K2duUnVxVUVZRThtdG0wMjU1M09OYU1PblVGRFIxWHVMK3FW?=
 =?utf-8?B?ZytJUFFpSDFsY3lZTVdGV1poM1ZuWFNRVVlaVnJjRTlUWGdKWjBPQUlJR0ha?=
 =?utf-8?B?ZjBsdGVxQWN1R2RYUDFwdXZwRFB1b3hvVlhqckd0Mk81c0tUQWU3WDNSWHVj?=
 =?utf-8?B?R2FhdndWb2pabW14Rmh2WVE3cERHY3NkMG1aUU1ISW9TckQyNDE5ZjRSdmRV?=
 =?utf-8?B?Wm02eUZXRDRjTU8rcGNiczBsR0txMHBodzVuZjVYSmNsUk5weWg2bFR3SGZ4?=
 =?utf-8?B?cnl4VUtoM2hicm5QNXpLUFVHWGU4SFlML1JSL3gwMWhQV2p1N21UZWZlRHJP?=
 =?utf-8?B?ajVTYXkvZE5paEVaZGhDSXVwSlVlZkRZa1lMNkZaSFZ4VFlEQ3pxek96V1JI?=
 =?utf-8?B?N3diN0lpZkxYMU00bXA1cFRZeWk1eHZsRlFTV0phUHpMcnJQcmUremJGNnNY?=
 =?utf-8?B?ZjB5dkZqQTlSYWc1aEVVOWNGTWJTV1dwbmVmbmFCdHo2bGE5Zm0vR3FzaEdF?=
 =?utf-8?Q?e5H70W/hr8R1XEg+FdTK/oECH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58e1bc56-0572-494f-5a0c-08dcd2c90883
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 01:20:05.4324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rx6OJDJImRtYZfWejm950MrGMz4odbY18ZVE6GBv907yCJyUX2k1Jnj/PAuqiq7WuhhFJkhEh+pdycj2yi4a7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6310
X-OriginatorOrg: intel.com



On 4/09/2024 3:07 pm, Rick Edgecombe wrote:
> Teach EPT violation helper to check shared mask of a GPA to find out
> whether the GPA is for private memory.
> 
> When EPT violation is triggered after TD accessing a private GPA, KVM will
> exit to user space if the corresponding GFN's attribute is not private.
> User space will then update GFN's attribute during its memory conversion
> process. After that, TD will re-access the private GPA and trigger EPT
> violation again. Only with GFN's attribute matches to private, KVM will
> fault in private page, map it in mirrored TDP root, and propagate changes
> to private EPT to resolve the EPT violation.
> 
> Relying on GFN's attribute tracking xarray to determine if a GFN is
> private, as for KVM_X86_SW_PROTECTED_VM, may lead to endless EPT
> violations.

Sorry for not finishing in the previous reply:

IMHO in the very beginning of fault handler, we should just use hardware 
as the source to determine whether a *faulting* GPA is private or not. 
It doesn't quite matter whether KVM maintains memory attributes and how 
does it handle based on it -- it just must handle this properly.

E.g., even using memory attributes (to determine private) won't lead to 
endless EPT violations, it is wrong to use it to determine, because at 
the beginning of fault handler, we must know the *hardware* behaviour.

So I think the changelog should be something like this (the title could 
be enhanced too perhaps):

When TDX guests access memory causes EPT violation, TDX determines 
whether the faulting GPA is private or shared by checking whether the 
faulting GPA contains the shared bit (either bit 47 or bit 51 depending 
on the configuration of the guest).

KVM maintains an Xarray to record whether a GPA is private or not, e.g., 
for KVM_X86_SW_PROTECTED_VM guests.  TDX needs to honor this too.  The 
memory attributes (private or shared) for a given GPA that KVM records 
may not match the type of the faulting GPA.  E.g., the TDX guest can 
explicitly convert memory type from private to shared or the opposite. 
In this case KVM will exit to userspace to handle (e.g., change to the 
new memory attributes, issue the memory conversion and go back to 
guest).  After KVM determines the faulting type is legal and can 
proceed, it sets up the actual mapping, using TDX-specific ops for 
private one.

The common KVM fault handler uses the PFERR_PRIVATE_ACCESS bit of the 
error code to tell whether a faulting GPA is private.  Check the 
faulting GPA for TDX and convert it to the PFERR_PRIVATE_ACCESS so the 
common code can handle.

The specific operations to setup private mapping when the faulting GPA 
is private will follow in future patches.



