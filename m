Return-Path: <kvm+bounces-17487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6758C6F6A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48BF428449C
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A34811;
	Thu, 16 May 2024 00:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSFzD0UV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3272519E;
	Thu, 16 May 2024 00:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715818371; cv=fail; b=tEB3szAKmVcZALG8vrbb2rBJv3LOU47A63jp76Wv7jxBPYjygzUd6mzoMZoI2Y1fX3NSbE5heMPKRg0o54e/buu+KYvR475lRpgqO3ybacxWwj6cmHydg1VgunSPgWBUoFs3x7mvjxCLqBTIkTEl3uzTeuNIc+EcQPeEepuvUtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715818371; c=relaxed/simple;
	bh=RiIO9Q2R2LkX5bcLd+9FxNVsLi+7Syp1xt0DExXUshk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LIIx/Ja6jVMyGX7rbUB026hlnUCnIA5dDZCwDgWC5eTX8stmGpZSP29wXHeqSSwxkRtpSz8evM8XzKnLIQeRbvAssSRqXPcQS4zuI/q09Eg8vRh4JYW4tlp2fKTuBNAVXm4+IXnLTSHllK+dNR0bHyAejbOc4H6dus6iqTuTisY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSFzD0UV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715818369; x=1747354369;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RiIO9Q2R2LkX5bcLd+9FxNVsLi+7Syp1xt0DExXUshk=;
  b=hSFzD0UV0koLOCFly9V1SyTDgLvH+JLAMDri0b89+hVQKAJHTxS1pja8
   6TmnqKjtdRytN+mMb6iD0cbdmqCbngq6BiuSCo6kt3Ks5JBk31Rvp22Y3
   uRKDFNR8uSUobuHfyx+eBECJxGn1p48y3A25WeJ0Ctpa+LSrKmT4xw0gw
   oJWTJ/ITxdE55DUZcmPzEyNoiMc3w3QsPKPPUEdHYmVXOem8SK7fqQKxu
   4uVA2k4JtJp9EZ7CciFZbOuS0KMzV0doJCDtL6E4DA5ZUpVRnTnqp4Cfz
   vvN1Gwj7HHnYIYfvnZYp3ev0Oc2bhtgIg8FS/p079hnO5Yn5rxcD9re9r
   g==;
X-CSE-ConnectionGUID: C6b/weZ8RaCW/DcjVyZaTw==
X-CSE-MsgGUID: rLhypOGzRlSdzaQz6BRa+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11712532"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11712532"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:12:48 -0700
X-CSE-ConnectionGUID: AK3KIYZpTqiIjqTifKYJ6A==
X-CSE-MsgGUID: SYteIQnrTDmfS12TgZKjFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="36019911"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:12:48 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:12:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 17:12:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:12:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFY5NJ6bCpkqEt+S1hAu54l8pB6Da4rKK8UYIM1NU28pDdOpyxWUsy9xu0GnDjAdeAL/NY+msHtoqgHD0Zsj2IDfVOT5KD0Tnexj6jQOqyGm1dw4kg6HQQoKche4K4bDNRUX1h2ze0xPENCioDTVypwmJSRpI0QilOHA/eV+MidMnmO0hI8TszpItptPAoyIxbK+/ipohfrY+3B0tk9YGOUbD8pmct3kMmy6F1Hd8u3WfTJUBGwiV/mGobMwL7NdZUYGE7pbmeW6M0z50iCTpLr9Eg5Jup9TbaO45FPcdRlfQdo+2U8c+RsgWg+QROhKkW5v1ZhOmPYe52t7VDghZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPfP9Ve8MsYRhmXK2PHG7oQ+r9+I2mbwrbhpPJNzmro=;
 b=AeuexudBxZzhClg/7s9n7bt1QB6vQtN1aZEQlE56t7H4xdSTLJMU5l6TDtBQGPOFg3BWIEMd2vn0XF4RVgS+8Qk2BQhWOeRc+wfFQ1XwWlsnV4ird0n2wuKbLF1orHnYeSwjTZxwXirhXiI0VEqOvrkDUt67GmtCCBEW+G+Wp4uZ8UTnOvkHJi9kDK/nFjbRnJoQawFtwHsMqV3SD+iumYD/D5zTmPwL4Skq4MSUXsIwT79MXQhVeG1FuxbMXL398rSbMWgRcP9FtOyUIhAXqOj7lKmQm/XqLd9MTHM4LS498vCSCiWck+axXAPhLTdBo+ESTtGlJcAWIMk5ru4EvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7493.namprd11.prod.outlook.com (2603:10b6:510:284::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 00:12:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 00:12:40 +0000
Message-ID: <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
Date: Thu, 16 May 2024 12:12:31 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0369.namprd04.prod.outlook.com
 (2603:10b6:303:81::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7ac04a-ef8f-4bfc-5527-08dc753ce618
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YVEzYjVmZWdkNGpIS2FpcmR1dE53cHJXWEtnMDFMbmlzNlFGekFuQkgwMXhD?=
 =?utf-8?B?SndNYTlqdnJucEVwU04zR01QVTFNdFFNdmI5NVdEV3ZkZTRIM3YwdGdmaVdT?=
 =?utf-8?B?L1VubTNnNU9KR2hJVm4ybTRBbzN0R1lhRWFNZHJFR1VoOUJQNEdNRVllclFK?=
 =?utf-8?B?VHl6ZVR6Y25oZ05kQ1pnVnYyTkFxUnFkamxlRmhyYTNKWWxTRzRqbnFGMEpl?=
 =?utf-8?B?SEtYOUFjbE1PeitubVZsWWsxQ3lrck44Wm5BSzNFdXhMMTdYRm5Fb2VCaDdy?=
 =?utf-8?B?M2FyTEc4TExITUhEVUxaN3ViK3JnR2pWNktLa1VUMW1STEo2eGhHMWNacGow?=
 =?utf-8?B?WHlXVm9SZjJ3NmlzMXJESHVGV1NoY09NOUlnajZSUkZ1MEhicFlEZ0hTNDJk?=
 =?utf-8?B?T21DZlkvWkJsMWxKb2M3dWhzdXAzMStNRWswdnFhZWREc3A2cGFGczJYbmV2?=
 =?utf-8?B?WmNPUTYxR2RINGZyVUQ0bTYwQ05rK0VZNUxvYVpiRWFMZWNQTHllNTdjc1hZ?=
 =?utf-8?B?bWxhQU51OUFjTnp6TWd6U1ZCcGJxTjFXQkpLdWw3ZFJRQmgvenc5bUwwUSt0?=
 =?utf-8?B?NFVScDdWVVhLS0N3aHJVNXROcGwrd1V2TWNGRTgrTHlpOVJBQThjUHVaWEZB?=
 =?utf-8?B?YVdLTzZrSTJIWnY3eWRjcVJCek5jVzNUTDNpZ2NrWFJIbEVCOXhpbUI5RTk2?=
 =?utf-8?B?SVZiOWM1bEgyRHVpRFFiTVNidi8xb1c4bXU5SnR4bTI5K0ZKK2wvODJmUWlC?=
 =?utf-8?B?VWZjSDNiV3NOeUhuei94ZW9kcTZOTloxSmp0SnBLN2FFcVdjR3c3cWdvQzFX?=
 =?utf-8?B?QmE4bEFMdXpKNkRGR3pCM0xweGtiUVNpNDVpUS9vUU81Z2wwNEZZNHdoRVQx?=
 =?utf-8?B?N0JURHlaWmsvK2h6SXpKMDF3YzFZR2R6Mis5QmNRM3ZRNDlWclN1Q210VG01?=
 =?utf-8?B?SFc2bk0xanlJdVVJRHVQaHlTTjFPRWNIb29rSXJxOVY5SlM4UDlHc0tMYld6?=
 =?utf-8?B?UFBFVDRGK0N5Vy9FM0NqZ1pmKytHWGkwVjRxaFlBM2x6UXhGMDJMUFZCZm44?=
 =?utf-8?B?U3VTZi9jQmVrVjVrR2lHSWhNOFY5RWVKSzc2bnZ4WGRJUUljNERNM1kvYmhH?=
 =?utf-8?B?ZHhxcUVpK2tzZFdxN05RWHJ4dmhjTEdxclFObVN4TTZoWm5iU3VURWJ2akRR?=
 =?utf-8?B?YmhNNFpwbjNOU2N5ZG5kKzU5Y1pvS2JUMnJlakV2NVkzbm5CWTI1QUptRkd5?=
 =?utf-8?B?blB3Sm85MFlIeDVPRGd0UHZVcTMxcWxHV2xEUnhvMjh2MWJlMm5mTG9RVnpX?=
 =?utf-8?B?Qk9TTGxqRWZtZ2xQWFMvbmZjMW9sRkQralZSb0lMT2kzRjk2OEluLzh0S3g4?=
 =?utf-8?B?MXZUdnR4TzB2WWxLM010bmlBTEg2TG1kemo0bFZidWl0c3dCM0JmeTN4UFRl?=
 =?utf-8?B?Sjg3U1FtSzY4SERVZEwyd1NCNzdKejRYTkFYTzduVnpOb2JBMDRuYXNXclV5?=
 =?utf-8?B?RGNvZjN5L0FCdlV0dDlVRU4wUE1Lbm5lR3VyaGV2YzZoYm9zY1RERWJFQXlk?=
 =?utf-8?B?Qk9Mcm1sM2ZuM3VHeDBvYlNQQklJNUFTOHk1c2tRQkdacG5tc3FwaW1qN3h4?=
 =?utf-8?B?c1kyY2xUOWdyTkt2bVZEc2trL3g4YitVRzdPZW5hQk9tV1JFWlYrMXVQeXF0?=
 =?utf-8?B?MC9XWCsyYnJ0RGhEM3FYdEF3eTdzU28yR1BTVEZUSFROazlGbDZWMC9RPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUJnd0NJZ3E0TXRVTzl6SkZ2R29tZ1RwelRIeGY5MzJZYlNvTVZmMEgrQW45?=
 =?utf-8?B?dFpXVlhGT2lXZzNielpWYTlwTHV2dVh6Y2pJMHpvZXBMdzYwODVuMXVpV3J0?=
 =?utf-8?B?TU5DVGs4NkxvOWVyeHRiem92NytlZVRtSzkySjRVWHVPSmRiVE1YajQ3ajZm?=
 =?utf-8?B?SHgzWGFkdVU2dlBkUStlTm9YVUx4WVBJc1NQWmw0OWZwemhTRk1XRzV2dVpQ?=
 =?utf-8?B?SE5hRlhRTHloejQvOFFyejFHa1Nwb1RSV2xuSTM4eUlqbGMwQ1BKRlRnd0lY?=
 =?utf-8?B?eUpObEtVVEd0Q1E2elN4Q1oyTmFyeVowQWduUTczVE9ySlVnMklZYWVOTjlH?=
 =?utf-8?B?cVAwalNnYjJSMWk2djlmRHZraWI3cXlQZkhhdCtzRk5WOEdmTDUvNkFSRk9W?=
 =?utf-8?B?VUJ3SHUrb2V6OVU5QkdJS29udVhFMjZpNGZGcFpHK2xjejc3OHV3cDJwTDc1?=
 =?utf-8?B?Q3luMWt4SXRtU3BnWnlzL0xSRGJaMVRBT1lmSVZqRFRjb1N5WVJoeGs1SlBL?=
 =?utf-8?B?Nk9WdXBWTS8wYzFiRmNicUlQM01ubFVuM3gwL1pJQmtkekc0L1gyeHhhRHg2?=
 =?utf-8?B?SE83OTlpdmVIanFnZkdhUUdZSWxldmx1RytDcnZva09nSlpJenlSaXhxdmhO?=
 =?utf-8?B?QUNBbllWdGRkSnZVbjh6V2tBSU9PM1kvNzlLRHRmeitoZ1k0REJUajVzeXN4?=
 =?utf-8?B?MDV3MThEZEp6N0phaUtuNU5NR1hEOEYyUXhDSTNtcnRYRENzNnlrUlhGOE9x?=
 =?utf-8?B?Q1RoOVNUNklFNjhjTEdUS21kZ3BWM1FRTTBUdm5NalNwU3QybFR6N1FZUkJX?=
 =?utf-8?B?aG1BMUo2eCt4dXA1MUx6VzU5djlzS25wdXpBMXNVbVAzNjVac2M5RnVRem92?=
 =?utf-8?B?dVdBVGpRYVNQZGtXek1UcjNITzg1Sy91b0l0cmJsVjNnYWVHVy93SWFiRXZh?=
 =?utf-8?B?dUhEVG9aOHpYc3l2YjNhR1ZxOStqZ0liZFNZK3l5cnh6eUN1ZWtKZlRJR3Nk?=
 =?utf-8?B?cTJVdG8ydUd1eWxZZXhEcERMTC9PNnBxZjFWMDgvZFVneVZDQkFJTDd3UnMz?=
 =?utf-8?B?bHc3bi95UEtmTkFYWVkveUNaMzVreDk3a29ia2pvd25ZYVN3dTZXUGhyYVZZ?=
 =?utf-8?B?TnNnTHFNZkc0NWtmUWJwOGZRTzRtRE1GbFdwVDQ2b0xlN3Z6L3dYb3R0dzcw?=
 =?utf-8?B?L09DVmQrdzFRU25vY0prV3NxZFlZLzBOTTkyK3dVY2JMeTlPMG5PUG43Nm9i?=
 =?utf-8?B?SmZPbVI3TGhuMjJza3piNHNLekR6cmZsYWo5UXpzMkJYeHJ4MVJSMzlaUjRW?=
 =?utf-8?B?TkY2a2I1RDI4L1M4SUF2ZXM4T1VVeUkzaUI5NEJpR0ZPUkpmYXVROGQ1bGhX?=
 =?utf-8?B?QUVic2N0cUJ6U1N5NCtTQnJmMEE4alJvandFTmlBUVBhK0tVUTlZOUZxRFRs?=
 =?utf-8?B?WlN5STJrK1h3NGtZdXhtY1FxQndZQ1d4eHJiNnZKNnRQU2s4YW1xbktFUWI5?=
 =?utf-8?B?L3R5MGg1WTJYVlN3U3kxUk45UkU4bk5xWGNqUHVydW5KaGNuOXdxKzhBSmxm?=
 =?utf-8?B?RGNxbUo3RWNQRnFEejExeWlSbG5GQ2NzcVArL2F3cU4vSHc4TXAwbElCQTRt?=
 =?utf-8?B?UWZQalNsRkZNZ2NEVUhHWTlRZDRlV3dNcUhwbEoyU3JsQy9BOXNuaEhKckNh?=
 =?utf-8?B?RHJOZnRKNDN6MVdWenpMcTEzdlVkMUZZRkk1Y1NPUmtZNXJoNkRIZ0Ivb2lh?=
 =?utf-8?B?emtXMEVvZEJ4QXQ1anQ4YU9EcEU1ZDRad1JtcVlTQy9MRERVdm1mNGZ2WVdy?=
 =?utf-8?B?dUlRNEVCYTJQRDBYaHBMOEd1bGxBQmJpdnVTOE1zcG43UExadkUwdWk5bW4y?=
 =?utf-8?B?UG5wQzZPcGZYdFhCS3ZXV1FaVnZyc3RjcWJRdlhZYzJSam83NlFTdmV6VFVS?=
 =?utf-8?B?bmVwRHA4TjY2ZWkrNnljQVh5MVVIMFU3bkN6RDY1ZGZkMkloUThsMGxaZGRC?=
 =?utf-8?B?V2hJblBEbTdMdzRCMjkvcC9HSUQ1ZFQ0S0t3MXdqU3ZzYlNSdU1VaEFqZUdo?=
 =?utf-8?B?SUlqMFdIZHQ5cjE5OHVsc0xob3dXeXpBMUNSUHRETW1BSTY0bnYzSVR1ekxm?=
 =?utf-8?Q?ULmvps1A5cFK5lLI1kWNB9f7H?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7ac04a-ef8f-4bfc-5527-08dc753ce618
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 00:12:40.0227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfdROxOMUZig0lWGutuuS16i3HCV2TUtta3Hx+N5pCkNC6cxLnCN6fYNMe6OUw0ts2111R9il/U8W9mqiFqT+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7493
X-OriginatorOrg: intel.com



On 16/05/2024 11:59 am, Edgecombe, Rick P wrote:
> On Thu, 2024-05-16 at 11:44 +1200, Huang, Kai wrote:
>>>
>>> Sorry, still not clear. We need to strip the bit away, so we need to know
>>> what
>>> bit it is. The proposal is to not remember it on struct kvm, so where do we
>>> get
>>> it?
>>
>> The TDX specific code can get it when TDX guest is created.
> 
> The TDX specific code sets it. It knows GPAW/shared bit location.
> 
>>
>>>
>>> Actually, we used to allow it to be selected (via GPAW), but now we could
>>> determine it based on EPT level and MAXPA. So we could possibly recalculate
>>> it
>>> in some helper...
>>>
>>> But it seems you are suggesting to do away with the concept of knowing what
>>> the
>>> shared bit is.
>>
>> What I am suggesting is essentially to replace this
>> kvm_gfn_shared_mask() with some kvm_x86_ops callback (which can just
>> return the shared bit), assuming the common code somehow still need it
>> (e.g., setting up the SPTE for shared mapping, which must include the
>> shared bit to the GPA).
>>
>> The advantage of this we can get rid of the concept of 'gfn_shared_mask'
>> in the MMU common code.  All GFNs referenced in the common code is the
>> actual GFN (w/o the shared bit).
> 
> When it is actually being used as the shared bit instead of as a way to check if
> a guest is a TD, what is the problem? I think the shared_mask serves a real
> (small) purpose, but it is misused for a bunch of other stuff. If we move that
> other stuff to new helpers, the shared mask will still be needed for it's
> original job.
> 
> What is the benefit of the x86_ops over a static inline?

I don't have strong objection if the use of kvm_gfn_shared_mask() is 
contained in smaller areas that truly need it.  Let's discuss in 
relevant patch(es).

However I do think the helpers like below makes no sense (for SEV-SNP):

+static inline bool kvm_is_private_gpa(const struct kvm *kvm, gpa_t gpa)
+{
+	gfn_t mask = kvm_gfn_shared_mask(kvm);
+
+	return mask && !(gpa_to_gfn(gpa) & mask);
+}

