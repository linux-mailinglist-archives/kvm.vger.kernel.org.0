Return-Path: <kvm+bounces-16025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D6DD8B30EA
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54A46285FE1
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 06:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D833113AD25;
	Fri, 26 Apr 2024 06:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3FmnFB4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405C6567F;
	Fri, 26 Apr 2024 06:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714114727; cv=fail; b=FEcqqalwnaWL4m6yMDE9DRpH0l7J6UsZUCjSk6mcjnKqb2u95F572XFREjFPGrDQ7ayG1HcurF0RzX95x9qSs9e7z98RCys1KBRE/purwS0BIhNnKiFEc+FqMNJlk5A18vS7rCNHKgqlxSSZb1q7XYdGfLt211n/QadGR5AErrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714114727; c=relaxed/simple;
	bh=+upyL3YbN/uj6mlUjGvgtdwvYgO/8k6boH1DBmHJ2M0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q5sV4g9G7GCowh5UGlC9aVB2n96Bt3nNF2Drq9SLVrUKxmAufW6xVYspplMqHwHCmD9dsa2m1dLYcmu2SywnLmonqSCQC7RugkPaR7Y1TafmFMkqLDghRtKERLdN94+QW6HxBKCVUvk1c8deIUSdLFa/BL3zo8OQPxCidOPD45w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3FmnFB4; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714114725; x=1745650725;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+upyL3YbN/uj6mlUjGvgtdwvYgO/8k6boH1DBmHJ2M0=;
  b=a3FmnFB4EqkldWd1mMXciu3WbqX5QBZYSwF86EOb9sbNdY8rVyBw/l1Y
   RC0Q/xa+rLBX3cvSSd3YCfH5WxxWzMzchWJd+NhXl71wInaT5Bhf+hwVS
   8Qx7gOLUb2DRNQtfbLAdU4i9xsOdmfIfY3r+XqJ6JMUiuct7tKehWksoA
   64vhCA57JASCNpNympP3adMMw/U3l8f23q+SXXF0QdyMUUEt/tZs/fs3h
   m54udgRcS1wJ7MAy1LhOdnpBtZ4YYLvstF+I1oyRpXfMuFph3nnA3lIz2
   Dx/PvUvtAF1KgF9gR8g7OSpoxLNSbDLlDChcxzexlGPLn2eeNMAbmyzqb
   w==;
X-CSE-ConnectionGUID: 7xlK969ERtqTecKVSJmMpg==
X-CSE-MsgGUID: RrceLipyStuoxkIG5b9lNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20453920"
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="20453920"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 23:58:44 -0700
X-CSE-ConnectionGUID: VMdvEE1lQTul1Db2rNWhtA==
X-CSE-MsgGUID: RuNXjP1aRf2iVVA39Mr17A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,231,1708416000"; 
   d="scan'208";a="25746430"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 23:58:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 23:58:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 23:58:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 23:58:43 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 23:58:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzviK5ewKcvmkzyJrHIO9lY3+Ax4rHdezuq67pd3sOOJ94++/ntzpxGXx+rQbT6bwNKyTpEJ093uLnsETfgSJexrjKkzI4nhHOinLvFGO7rYeyfeHtc/zdhDGCMRjyw/w45zAq3vVbVYQY74Yb75L9E5BNv/kSaxZgVTmHPxiIxXJataHWmdam2UxRNZwUjbac7r9Nd6UdS9HccaOFFODRgQlCgu3oZJ0QOtsX4vqmBnguoNxtReZ+rsy3yr7X7cZ4clC7uF6MUd2M0j2rjWt4DG8AHJ4NnrTCrBg7K4OgbadX+9oeFdXZa0xZiu7IG3Bn1Gtkm0EcnkEYrFk0iTiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vKmXEq6UXPPNMs9N5mnqdj1wq9UCJUkCUxZ+qyAhhZU=;
 b=eW7Tq3v+3zMHqSpQTuEwjFTPyJmoYpYQKQaNEYgl2A2SV8h1kuKMwmAredY3s+Z9V1+T1DkCP1uSWFzM7ZbKpdar+8H56yd3fX6s/zQ+5/VdWOgZSUHVvFZNryg6MBty6ZJyTnD9/MHvf5Byxbq6XRbfv+UlYBlOvRQORn8LW9wSWsq5YPafRiLJiMCc00zJGq2RDC91f0CZ6uHtyjkij7/ePKKVagRQqfhp454qSnM0bLdfu3FB9+BKoXGqq2p/SJBez6h8f5VawGBAILwRcN23nn5RMuIjfxitD1yN/wOqBewcqvDoJDfm68sY5AciV09gxMBPKOblhDdEzBsdzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM6PR11MB4628.namprd11.prod.outlook.com (2603:10b6:5:28f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Fri, 26 Apr
 2024 06:58:39 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 06:58:39 +0000
Message-ID: <ed625666-7934-4a7e-9b6c-f434ee0ae094@intel.com>
Date: Fri, 26 Apr 2024 14:58:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] KVM: x86: Rename get_msr_feature() APIs to
 get_feature_msr()
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240425181422.3250947-1-seanjc@google.com>
 <20240425181422.3250947-6-seanjc@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240425181422.3250947-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::9) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM6PR11MB4628:EE_
X-MS-Office365-Filtering-Correlation-Id: e01f0a49-006f-4dfa-838e-08dc65be4d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TDdFSXF5RmUrTzZvLzBXUFluVTZuMGQxMm5mdjltRWFYaytNVEc2alZsbWhu?=
 =?utf-8?B?Qlo4Mm5pMThIRndZVXMrb1pkOTZ3ZElLKzA1R1VNVzVzQWFNREMyc1VUZTdy?=
 =?utf-8?B?OVJFODhtZDR1MmZpR29CUDR1UXJBU2hldHpVMGdIQ3QrMDVVdC9yRFhTNjZ0?=
 =?utf-8?B?SE9wQ1ZzUnBBRU5iS0dPMW5aSHRCK0tCSGRxQ1pmSWVHVnJhVE12dTdWZCtk?=
 =?utf-8?B?akl5ZzBHY05uN2JyMHJic1E4M1FWQTE4b2RnTG4rSGtRdTcyc3ZodXUzSTht?=
 =?utf-8?B?LzhvMzkyUGhzbm9kaDVMNmlTeUtBV2R1TlUzSXpKeThmOGF6ZGZYOVF5U0Vu?=
 =?utf-8?B?elM4VmQ5aFpEME5SSEUrVHVHRGFiRHVrT3Z1YmxMNnR4Q3FzU0doaUNLRzdP?=
 =?utf-8?B?VldYaWl6Ulc5Q1c3YkNKY0hJVzc1K2JSUU0yanEvNGl5MFUzb2lvVmd5YlNF?=
 =?utf-8?B?U25uNnUwYVprek03UmpSL1RtREg5bG5tOWZXdUVWb2xSR1NLTEpERDF0bmto?=
 =?utf-8?B?TExySTFJOWdYQmlyZkwzVjQ3clQ3NUxXQnVIWko5cnZsK1k4MkRTZ0NXU1V1?=
 =?utf-8?B?SEFBek4zTGZwclM4WmVBc1AwandRZU5mUDZHazdNaWwxdVp4T3QvYW03U3RV?=
 =?utf-8?B?LzN3R2RoVFJ1VGtXNzNPQVpHWlNSSy9VcEo1OUo4WnMxMWhCd0hCd2J1SC9K?=
 =?utf-8?B?blhDUHVucklXcnVsRTNGS08wVmd0Q0JERHBVNWUxKzFrZ0xXWlRVRndHRGFv?=
 =?utf-8?B?azNCaVlrOEVzSk5vZXJaRE9aSjZXVVdjQXlqY0I3MHEwYTJ2eWFQZFRWbktn?=
 =?utf-8?B?QVl2ekZjd2ZMYkRLRGMrK1ZWRGk3SjFFTlNwMUpsL2R5bHVUMzFNZFFaSVg5?=
 =?utf-8?B?UjRHbzZkUHpSNStVTFhYRnhRSy9QQ1BSeFpsRjA4cU1TUTRPL3laZllsVVdt?=
 =?utf-8?B?Z2VhTFBnTnQreWlqUHNVSXlxVFU5RmpURUFPeFlWdXdTS2dWYnpKYnVvekp6?=
 =?utf-8?B?OEdjOEZVUGVQcE1mUTZZZDMyT2JQVEwrcmMzcm9FYTBlOVpYK3JDRFhXd29S?=
 =?utf-8?B?amhBcTRSNkZUU3JEeDJlV0U0c1VQd3RrMUVNd1Fjb0grVWVQaHFUUEsycW5k?=
 =?utf-8?B?MnlCYkEzMXBDdWgxbmgrQ0FnOTlUOEQxTGNlTWt5U2JRRFhCU3ZEaDhLbUE3?=
 =?utf-8?B?SERXZ0JIMDVvOVJOam1VWFZnR3BZeXdpcWlMWm45V054MWozUTdCTXFlenZP?=
 =?utf-8?B?UkxzWk1tRFY5MTJZQUFQRUx6WHRQdUo4OEJ5VVJMdyticW1oeWErWEl0eThK?=
 =?utf-8?B?VklhbW9DL0R5YkI3QndZVXo4NnFUcjVYdnN4SVdSeE5PMmdEMGlMYkVsVlpV?=
 =?utf-8?B?dzZUVjJXdjFUU1FQSzJyTEZQcVBOd2tjWVZCTmFjbUs0ekZSaE9rTmJXaXdL?=
 =?utf-8?B?ckpHV01xMGZYaGNWaTB0NThDa3RzVXdJUjJJVkhIVDR5aU9uS0R2Tlc4Zzgy?=
 =?utf-8?B?cnFhSWVERGZDVDlVbFZZQ0FiZ0ZmVys4RkFYRHNmcjBiS2F0K09PaHk2c1RC?=
 =?utf-8?B?NGJyRXk4RUszcXF1S1U2TlBTL2xpSXdqeThVTnh5aVNiQkpCVFVZQkM4dURI?=
 =?utf-8?B?Q1d3SmVLOVBhSkhUVFN1U1h1Vms4SHE1Vjlpd0x3d1ZBUkI4ZEgrcFdyV3JZ?=
 =?utf-8?B?NjZlWVA1TzdINlRTbXZyNGt3Z0ZIdkkydGpGc2IrYjVrbkR5R1hUOC93PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnFEMHZTVGx1QTNhbS9DMDVCYVRCYmUzNm5KakR6M2lFZUt5UE1KazFiNWNE?=
 =?utf-8?B?N2JNb2tqL0h3MXFhMlFwVG5IZ21VNi9VWDd0MnN2Z2Q5ZUhHenFmTkhXeEVk?=
 =?utf-8?B?NFdkcThqS3FoNm9EanlkSEd4TytRVlhUMndHNHpPMDBUWVprcjBFc1lSL3ZR?=
 =?utf-8?B?TDRPeUpaWU1lbjVSWXc1and5TjN0NnJQVzBhYms5cXRWWm03NGtaNy9LVXVM?=
 =?utf-8?B?Vm9iMVBvT0xWN1FKL2JSYXdQOW82M2o2aGVOSDVIb0RrSXdjellha2Rtd1hu?=
 =?utf-8?B?bjRFNnh2TysrTFJtRi93akFBRGo2Mk5kN013WDdOajR0ZHVGRnRETkZGTkhi?=
 =?utf-8?B?M2laYnhQRU5uYzNNUnVnOW05UmtzUjkyUGdPSHAwaExpeElkSVh6blY1dkty?=
 =?utf-8?B?cjBWTitzNEIxeVYzSncvbTNkeG5Ec05zbmdnbk51OFpWSUgxQ250dERDOUM5?=
 =?utf-8?B?TzYyNjVCMjJDbHdQSTJQTnpxTjVGT3BJYjVoL2lNTmNDbk5Fazg0UzFNNURJ?=
 =?utf-8?B?MEJlVUh4TVFyb3g1c1NyQkE5aGF3ZEZCQjRhbkNSaHJMSXlIWUdrUTVYQWhX?=
 =?utf-8?B?QkdyMENKbnVTcjd6bEp1K2VqU29KWW40eENvRk04UDQ0ZGd4S21yYXBpNGQv?=
 =?utf-8?B?NWsxMFUwakpacXdSMEQxVnY5NVV6Rk0rQ0tydjQrUGkrazVoVTgwT0dTUk9E?=
 =?utf-8?B?enZaUzVtWHRIRUlSU2lWMnlvd2hQT25vd1p0L2VxTE5TRnRjQ2JJaFJudUxN?=
 =?utf-8?B?SllnQjVScDN1c0VZSmMvQWQ3R2JJaGRxdGlyTnRTSEMySHRHMEtPNWtLTmF6?=
 =?utf-8?B?ODFCb3ZwTE1oc3puT2R4WTB3VzFFSVpNTHJXWVhDUjUwVldCNitFa0QrdUlI?=
 =?utf-8?B?d3E4R0N5U1JlL1lZYytIMDdvMEIyWnBIdEsyN0tJVXJUVjlTVVFLQjRneG1p?=
 =?utf-8?B?Y0g3SFdlRE82RUsyTnVyK000UWtCNENZVkNWMWc1Skg1dC9qZ2VNU1gwNkRk?=
 =?utf-8?B?eGY5VytFVm80QTdsVUFCQlQyQmk1eEpjUFptOXBhWGc1bVJ6Sk95OGF4WThs?=
 =?utf-8?B?cXFmZ2RqcEdzeHlIN0U1YXZZZHdlOVdlaW15T2JPSTBXMldRM0ROeXdHYmlX?=
 =?utf-8?B?MVRjNC9TQ2JHVlFmVklHQ0I3U0cwWTNHWC9Id0VHVEo1Qk9TdmJPYU5QWXNQ?=
 =?utf-8?B?Y3BYaFRnRmFwNlczZWZTL0l3bmoxUElSaXB4VWpWMVFlV3ZkVjFWNGNISXVS?=
 =?utf-8?B?ZkdrQUgyS1dIc0VLeUJpRjBITzhvdmtMbW1mbkVvK0Qwb2l6VTNFMHJuMDZY?=
 =?utf-8?B?aHVJWTIxTUMwcmtobHJnUm9JanpUSDZWZkFQbmhRQVZ0VFlBZUxWVFRkcys0?=
 =?utf-8?B?a2NBam9PekowVElpanRGbmlIUjlTVzV0dUw0cTBHYnFTaHBLQWV5MTBRcDZS?=
 =?utf-8?B?R1ZxMjliVll4WnZtdWdjYVFmWERlVFNKT2U4WTRrMlNkdzRhQmZieUozQ0M2?=
 =?utf-8?B?SkVWRlE2OUVHT25YYUMzZWQ4bnFlREIwVnJZVTlNZFgxYzl3V2t1MEpCS1lv?=
 =?utf-8?B?R0Nnc0JYSFN5Uk1ENlY3WjdzdFVVaGhXbmNRR3dybjJHUElMSkxONVRDd1dh?=
 =?utf-8?B?N0RlTTh0VjI2TEI2aUVCQWt5QkJ2d2ZCOGt0cHBOV3ZYbGlNMWxlK3JDL0Ja?=
 =?utf-8?B?QXBOcHVoNlRaT1hTVkpsOHgzK2Q5TkZ3NnFNWCtNTm11dnhlUTVyVEJLUDlG?=
 =?utf-8?B?aXFPWGQ1VXhBaXFiMjZiaXF5Uityb0YydnFFa1ViOGdBL0p5Wk5RVy9HT1pR?=
 =?utf-8?B?WkNFTnMvWlY3aTVxTHNtR0k5QXc3WEg4SGxTaUE1ZktyRVdObGRqR2s4V01l?=
 =?utf-8?B?Ymp1NW5WNU9jQlhqNjYvQTJhTzNqQUVQdHYybmpFNTRIcXFPaHR1N1hrUmdZ?=
 =?utf-8?B?OEEwVUN1QS9GZUc0bllxSnkreUVQMzAyeGpMS0dVMHdBU0YwTjE0T0VMNzdK?=
 =?utf-8?B?bGNUSFh3dmN6T2NpY1ZLd3VPS2crZ3R4WHEwZkVGRWd6c3ZUV091QlFJeEFW?=
 =?utf-8?B?SnJQMWhEMVhrSDE5MEZjOEpvNG80SG5MREVtZHpNOHFMNWEvdU1TUndIV0Jl?=
 =?utf-8?B?NVlzRkV5L1VBbSs3QmxlcHc4V1ZURzMxWnkrVlNyNHdaWVJnV3pXRFZ3Nml6?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e01f0a49-006f-4dfa-838e-08dc65be4d32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 06:58:39.6670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKfL/Zg3P9BY6QJaXrpZU7vupIBBTKDbchLeIAk4laJKcGOs4WaPS2ZBL142+hiqqmOWaZX4dS4MjoO+6BOASA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4628
X-OriginatorOrg: intel.com

On 4/26/2024 2:14 AM, Sean Christopherson wrote:
> Rename all APIs related to feature MSRs from get_feature_msr() to

s /get_feature_msr()/get_msr_feature()
> get_feature_msr().  The APIs get "feature MSRs", not "MSR features".
> And unlike kvm_{g,s}et_msr_common(), the "feature" adjective doesn't
> describe the helper itself.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  2 +-
>   arch/x86/include/asm/kvm_host.h    |  2 +-
>   arch/x86/kvm/svm/svm.c             |  6 +++---
>   arch/x86/kvm/vmx/main.c            |  2 +-
>   arch/x86/kvm/vmx/vmx.c             |  2 +-
>   arch/x86/kvm/vmx/x86_ops.h         |  2 +-
>   arch/x86/kvm/x86.c                 | 12 ++++++------
>   7 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 5187fcf4b610..9f25b4a49d6b 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -128,7 +128,7 @@ KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
>   KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
>   KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
>   KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
> -KVM_X86_OP(get_msr_feature)
> +KVM_X86_OP(get_feature_msr)
>   KVM_X86_OP(check_emulate_instruction)
>   KVM_X86_OP(apic_init_signal_blocked)
>   KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7d56e5a52ae3..cc04ab0c234e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1785,7 +1785,7 @@ struct kvm_x86_ops {
>   	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>   	void (*guest_memory_reclaimed)(struct kvm *kvm);
>   
> -	int (*get_msr_feature)(u32 msr, u64 *data);
> +	int (*get_feature_msr)(u32 msr, u64 *data);
>   
>   	int (*check_emulate_instruction)(struct kvm_vcpu *vcpu, int emul_type,
>   					 void *insn, int insn_len);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 15422b7d9149..d95cd230540d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2796,7 +2796,7 @@ static int efer_trap(struct kvm_vcpu *vcpu)
>   	return kvm_complete_insn_gp(vcpu, ret);
>   }
>   
> -static int svm_get_msr_feature(u32 msr, u64 *data)
> +static int svm_get_feature_msr(u32 msr, u64 *data)
>   {
>   	*data = 0;
>   
> @@ -3134,7 +3134,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>   	case MSR_AMD64_DE_CFG: {
>   		u64 supported_de_cfg;
>   
> -		if (svm_get_msr_feature(ecx, &supported_de_cfg))
> +		if (svm_get_feature_msr(ecx, &supported_de_cfg))
>   			return 1;
>   
>   		if (data & ~supported_de_cfg)
> @@ -4944,7 +4944,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.vcpu_unblocking = avic_vcpu_unblocking,
>   
>   	.update_exception_bitmap = svm_update_exception_bitmap,
> -	.get_msr_feature = svm_get_msr_feature,
> +	.get_feature_msr = svm_get_feature_msr,
>   	.get_msr = svm_get_msr,
>   	.set_msr = svm_set_msr,
>   	.get_segment_base = svm_get_segment_base,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 7c546ad3e4c9..c670f4cf6d94 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -40,7 +40,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.vcpu_put = vmx_vcpu_put,
>   
>   	.update_exception_bitmap = vmx_update_exception_bitmap,
> -	.get_msr_feature = vmx_get_msr_feature,
> +	.get_feature_msr = vmx_get_feature_msr,
>   	.get_msr = vmx_get_msr,
>   	.set_msr = vmx_set_msr,
>   	.get_segment_base = vmx_get_segment_base,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 25b0a838abd6..fe2bf8f31d7c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1955,7 +1955,7 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
>   	return !(msr->data & ~valid_bits);
>   }
>   
> -int vmx_get_msr_feature(u32 msr, u64 *data)
> +int vmx_get_feature_msr(u32 msr, u64 *data)
>   {
>   	switch (msr) {
>   	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 504d56d6837d..4b81c85e9357 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -58,7 +58,7 @@ bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
>   void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
>   void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
> -int vmx_get_msr_feature(u32 msr, u64 *data);
> +int vmx_get_feature_msr(u32 msr, u64 *data);
>   int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
>   u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
>   void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 03e50812ab33..8f58181f2b6d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1682,7 +1682,7 @@ static u64 kvm_get_arch_capabilities(void)
>   	return data;
>   }
>   
> -static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
> +static int kvm_get_feature_msr(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
>   	case MSR_IA32_ARCH_CAPABILITIES:
> @@ -1695,12 +1695,12 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>   		rdmsrl_safe(msr->index, &msr->data);
>   		break;
>   	default:
> -		return static_call(kvm_x86_get_msr_feature)(msr->index, &msr->data);
> +		return static_call(kvm_x86_get_feature_msr)(msr->index, &msr->data);
>   	}
>   	return 0;
>   }
>   
> -static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> +static int do_get_feature_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   {
>   	struct kvm_msr_entry msr;
>   	int r;
> @@ -1708,7 +1708,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
>   	/* Unconditionally clear the output for simplicity */
>   	msr.data = 0;
>   	msr.index = index;
> -	r = kvm_get_msr_feature(&msr);
> +	r = kvm_get_feature_msr(&msr);
>   
>   	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
>   		r = 0;
> @@ -4962,7 +4962,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   		break;
>   	}
>   	case KVM_GET_MSRS:
> -		r = msr_io(NULL, argp, do_get_msr_feature, 1);
> +		r = msr_io(NULL, argp, do_get_feature_msr, 1);
>   		break;
>   #ifdef CONFIG_KVM_HYPERV
>   	case KVM_GET_SUPPORTED_HV_CPUID:
> @@ -7367,7 +7367,7 @@ static void kvm_probe_feature_msr(u32 msr_index)
>   		.index = msr_index,
>   	};
>   
> -	if (kvm_get_msr_feature(&msr))
> +	if (kvm_get_feature_msr(&msr))
>   		return;
>   
>   	msr_based_features[num_msr_based_features++] = msr_index;


