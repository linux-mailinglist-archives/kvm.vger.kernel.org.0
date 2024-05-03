Return-Path: <kvm+bounces-16533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 024498BB348
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:35:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC1CA28A18C
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 18:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64DC415748E;
	Fri,  3 May 2024 18:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+68wcdp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7266E139D19;
	Fri,  3 May 2024 18:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714761095; cv=fail; b=LXKh+sIm0mqQOb6EYdAQLP4kx0qF77k0TX7OmULmLCwSyzEY7RqtpL/w+AdlTdGnkV+PBqxtsSXTnK0o8Wc1Bh5yffV9FuaPZwtIgunU8QjlRljyjznYUjhBy49fTfof4X3R6Y94MYvnzHQb/YflmzToaGZ2EvMkmSlJQcL4RqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714761095; c=relaxed/simple;
	bh=UwpGhYE+XRGHI+0X/IdtVXbj+6VjlpMDUn4kddJvyeA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X5FgX/2GAmgtwAd1RQUCIuPsZWD3hbjrLN/aDuLvH9a6nvDHJ5CiCt57UJgp82yNA2tca5efvZzISJ2abyqISfFMLSNnWMzR9gCv4mWe+/O58IxBeJeDMfY2mujYsS3IRVcSxdzj4Fp1CH4OYdakA7WZ3XxAqbaPqhl37EG1Srk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+68wcdp; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714761093; x=1746297093;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UwpGhYE+XRGHI+0X/IdtVXbj+6VjlpMDUn4kddJvyeA=;
  b=A+68wcdpQcdy2fM83otvVltnwSv8N8BO0qxMwpqWT+9KnbO7e+65DBgF
   Gar9T+s78/K9Q1AL4lgiKqoj4q+XzwUZWV44OgcirW6VS1hUJVtyqnsaZ
   gopS2juh5nHAxzkIoID2jGmBoDu/YL+RMm2H/68ZvwO6u8KpMpK9dyAB8
   VNrU4gc852PDSrjgEuHKp4Qrumal6LsBDN2nnyFDpfP/BrcRDEoeuvg20
   bAzIVQhp83/MepD/g4Ee4X6g+sXsTqU22hYhdYwonzuTksNsF4AbojO2o
   7D1T0TaAs1LEeLnnf5qgB3hdE5EdneV88r3azKwsFePQTdFzaSk0DUTZp
   g==;
X-CSE-ConnectionGUID: UYruG3crRFKnYryfp0g//A==
X-CSE-MsgGUID: DhAQyDUeQaCt7YmqkQIc6Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="11115083"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="11115083"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 11:31:32 -0700
X-CSE-ConnectionGUID: kUdehmERQtm1K3yY0v/riw==
X-CSE-MsgGUID: ER059oywRaiEOmIwWomJhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="27551785"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 11:31:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 11:31:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 11:31:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 11:31:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 11:31:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONg9CnKgyAkE1oBhWNRzH7pVZ8k9rHSlleUOUqYi0k8yHVJnRVWxqZMFV/2IAwmbyTyQA2aOs1dvGAvc9bSpC1uRNAVXb77B5+7uGyD7hQTz/zLbJsohwsG8fCJLEJEIlBlwlorHaOF/yswoba7o1eyg/B4RDrwfmv5eFpLOaQaipa32pQgnFydgxAS19ybT6rAiSCI3h2pPxYXchhFfv3OKR2+CA9hi7pa6qcC5vaWSv4c4PcebmwdK4CvmIxZh4Fre+16gVt9u/fUsfyJIpDB8fu9BeteIpHvNe9axaQMvKbPIJo6LUMx8MojEn4Cg7+gVhwH+XiH0tCqLuba1aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwpGhYE+XRGHI+0X/IdtVXbj+6VjlpMDUn4kddJvyeA=;
 b=FJlZPR3OnQUboB+UeXJ6/MoTySy/1fzGGwyj5SCzxfaH3hXhjsJoWSPXVBknm72FtpJWKqHDbg09FhpCbmhnIdYHGaDwuoDdBuATNAK11ijOOq1hSoxQ3Pgc77nQRSQqYCZOvYpmLej5Rrkq8+aw4px+C9wfLEIRWfl14fSUztuB0hwifcbZ7W1nK+AwcV0jgfIcBj8u5/j7jZBRno1zBOLeZX1TOQYvIOuLifFGyI5XJfNlXYw3wrov3bqhPLQQaq0Okc4A4QF2t2vTEwQDSVVV+GwXvaQVQeXkFF9jKi5/izEzZzBQpoMJQkcXVH5zfueFWsrrf0hZXPiz4iHR7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7745.namprd11.prod.outlook.com (2603:10b6:930:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Fri, 3 May
 2024 18:31:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 18:31:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Topic: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Index: AQHanO1LpwQKjb3BWkmudfJCqyD9LbGEpckAgAAgcQCAARAjgA==
Date: Fri, 3 May 2024 18:31:28 +0000
Message-ID: <6e839de0e66ac2a9a8af7fd78757b2ed1bffbca4.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
	 <affad906c557f251ab189770f5a45cd2087aca19.camel@intel.com>
	 <330c909a-4b96-4960-9cad-fd10e86c67b8@intel.com>
In-Reply-To: <330c909a-4b96-4960-9cad-fd10e86c67b8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7745:EE_
x-ms-office365-filtering-correlation-id: 5b83f971-d287-4277-dbad-08dc6b9f3f22
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UTNqUW8ydDFSQ29NcHBpNWZrQ1g5WWc0WkRRVVFSL0ZoQ0ZBN3hseGFpRHBU?=
 =?utf-8?B?ekhrMkNtTHZhSDJSb2l2cUtDeU1CT1dkNGJGcmNPU0hPanp4VFdUaFU5NUVR?=
 =?utf-8?B?UTJtdjVjMWtMN1lzMzk0K2Q5ZVZZTDdFdFhFS3REY3dWNXo0UDdBZ3ZwL1pS?=
 =?utf-8?B?Ny9Dd1NTUUZUTEpFc0tEZG5taFBwQmlxazcyZFI2U0hmVTMrV1phRDkvMzRH?=
 =?utf-8?B?V0tpWTVNb3BYc1ZRYXhKQVpyUWk5SnNaRDIrVkFFdW9GQjFhQ1NZVW5Fb29s?=
 =?utf-8?B?c29MWTJtZFo3QktodDdYdTZVRm53WUQ0OVozL2xhUmZhYXd6SHhaMXBRa2lU?=
 =?utf-8?B?aFdXUlpRU1c2SkZmR0dFTlVrMUdlUFVYMFZMRnBHMnhFamNvY0xxamRVZzJP?=
 =?utf-8?B?L29kWUU1b3FFRkxtZ3U2Nm5LMk9OU3hOZGNRdUpDQmQ3K1NHa2JhME00UDNq?=
 =?utf-8?B?aC85T0orMlYrdll4TEN0TmRRUlYxRytrSi8vb25FVUw2TVhkb2QyYXhYK3dF?=
 =?utf-8?B?U1BNOG94MnZIVFV4N2FaSVJ6RWFtaWxieFpRRDJLbmpGSXV3Z3pzbk1VSEhq?=
 =?utf-8?B?a2VzVkZvaXZyaGM0eVpUcDNkN2k1eUdLSlBSRUJzcFBFVEduckpQb1pxdUtR?=
 =?utf-8?B?STdYbjZabFFTZWw4cVlDYjB1dTZzL0wvSVNVSnE5VEtKeTNUWUJnZFNrTVEv?=
 =?utf-8?B?QzZaVlVZcDNEMVhHcWd3M0hSTEdTRTI3NDNFb0F6eTkzNE1LYUxaalhmYWEy?=
 =?utf-8?B?Qk82QkxxSDFuZUsrQ2llbERkNFlyK2xDLzFCaHE1bzZ4WXdmZHc2SytnaHhO?=
 =?utf-8?B?SFhWam12OUM2bEVidWk0TG1lRGZuRGdzTTlFWmZXb1prWXh6ekV0UXMzTFFR?=
 =?utf-8?B?a2pyTEhHSEQzNER1N1JTMWVwNXpYVHQvZzhvbzlGV0hZYVJFelhabVpaQ2pG?=
 =?utf-8?B?aUtUZUMrd3NiNFp2aUlCbE5PYnBlS1Z3WDkwcUc5aHJCdnBFMUR5SHFwTGQ4?=
 =?utf-8?B?WENWT3VOSVl3d3Fnc00wOUlCeVJZVDNmUUhBU1VrZG9tN01Ud0R6MFNkZGxs?=
 =?utf-8?B?RU10WFFacVhZcjhuWEw1WUFid2JrdXUrMHJWSEZ6bE5POTArMTV1dGN5VWVW?=
 =?utf-8?B?STZPTU13NGJsYUtmUHBJWkdpdGZYMkFLY0dPdzB3cE51Wnk4blNCVkc0Q3dE?=
 =?utf-8?B?c0RxcDhiL2w5UFB1VFh0b1M4dFo0bm5sY2d1ejZmeVFSVEhaMmJkZWx3bmJZ?=
 =?utf-8?B?ZC9EZE1QcGVPV2tkNWppd0YvanU0V1piejNtY0V6OSs0MFRCVUpIMytXM2gy?=
 =?utf-8?B?RXZlZmhucUZGWlNYM2tTRXVieWhwcUtWVlZMeUNPMTV4a1dNVnlQL0dPSyt0?=
 =?utf-8?B?TG9UbTZkMjJtOHlyMlBwMGo1UVNQUm80K1RJWEhFdWFoM2lDb2lteHdFcjRK?=
 =?utf-8?B?bmdpaVBXYVN4MVgrRWlBQ0x5aEs3WmxrZ2tzaW1jN1p2NnYzclpRL1VyNXlk?=
 =?utf-8?B?aXdwSmQvRFdqZzZtelZCaU0rVXR0UjdIQndGWkxReXNPMEcyTm1EZ2pDVEVD?=
 =?utf-8?B?Zm1WN1ZhTjlSVU5XVTI1SGN6anVqNDZoc2Z3Q3NPV0pZNGVIRXJJdzVaMUZa?=
 =?utf-8?B?UHo1Y0VqOTVvUnl1ODFBQW9kY3p1ODBwOEsvUWx3S3ZOZGp4T2h4UThqUkJm?=
 =?utf-8?B?U0RRRGk2OGlWMStXaGt0aXdySUlHNkRaN3IxV1AwYXVRQitQZzJpcnZ4dmd5?=
 =?utf-8?B?MzZFSVNFUndMNTBzdVFqL2RBSnhvQTgwcGE3dFNuWVFlei9wTlVlY2p3ZjY1?=
 =?utf-8?B?eHV0dmJBNSttQkEzMGNUdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzAwcE1WQkt3dVltVHQ5ZzVtTWdHSnlnZ3N1Z0g3ME1xYVBjM1EyczFFMVdx?=
 =?utf-8?B?VVgrTzRjdWJYdWljc09vYUtDUlc4MlFCU0VkOVVLa3pSLzRjU2pXc2N0THkz?=
 =?utf-8?B?TmNrQklUS3V1RWVEcUF1bHFZaWl0RUNsbmdlNTJVbEVWdmZLZjRpZDMyTW9M?=
 =?utf-8?B?MEdDNVlJZTZkQU9jSFE0c1prRlFnZU1rRGU3ZXNWK2JwbTAvU1FjZ1ZCb3pq?=
 =?utf-8?B?RVZzNlluVlhtRDl2N0dGLzJwWjJDbmJTZ3k3SU9xYmJoSk00NDltSlR5YW4x?=
 =?utf-8?B?K0YyaVFRUjRsSGZxMTRCa1BEOVUwRllqekZlbytNU0JIRDMwYUFSR04xd292?=
 =?utf-8?B?UjJ1Y3RhQkl4VksrcksvSEs1YUJLNlk4cnZHTGNBeEdlTWhBYXhtdm1Fc1Bq?=
 =?utf-8?B?ekUzekJiUzB2MGJlV0J0dmVDdnc1VXJuazhCWVFSeVlEVnRNRWZYVm8yMjRZ?=
 =?utf-8?B?MkFTeFBJU2JqSEJEdHBPa0J2Vkk4WUFjbW9LYnRNc3hQc3hjZFgvbUtZRjN5?=
 =?utf-8?B?RHcxSi9CdmhoL2I5SDZtWGNqWlcxRDlsQXhlVjZMajU4dUtobHAramVCc3ph?=
 =?utf-8?B?WXZBUXZZOExYVXVvUXBkcEh6bVo1d0hJV1NwbElkWXpGTXNYYnNSZ2Z0S0ND?=
 =?utf-8?B?RlBvZWIyb2JLTThDK21ZR0RxZS9Kd0VCQW9jQm84SkNGTGtVL0NwU1VrK3lz?=
 =?utf-8?B?SXdVYW1QYm9BdU9tc3VRZ0wxQTZoK3BCb2djWERtU0FkWG1VNit2c09obnlx?=
 =?utf-8?B?N2luT2NzSEREanpqUWdCc3dXb0ZldkJFdUV6TzlxWFd5UkVyS2lLUU5HdXIw?=
 =?utf-8?B?Qy9IR0pESTBEQ1VyUHZrdEgydDlOOE9VTHpHZzdNT0RQVEhTOC85dStMSEtr?=
 =?utf-8?B?RUNjalFZMUd4SlhxOUhUcHFDQnZNSjUvUEYzYVhsZkVFSy9lb0F4OUZDY1ZP?=
 =?utf-8?B?TVFPbzJxaExSUUtzaWRmcHlneFVjdE0xSVZzQVgzejBVSS91Ti9pajZiWDFT?=
 =?utf-8?B?UmpqampUNldHUlhLcjhkOEgyTVhMdFU0YSswTDZhc055bndTdkh1NzJYUUQx?=
 =?utf-8?B?Szl2L2pCU2ErcDNIUTdLU1lVcmtZQUY0ZktxU0xyR01USW9EVzhaODgxaVg0?=
 =?utf-8?B?NzZCUEpKcndIZnJaN2NRQisyaUpTMTN4d1FKdXdOS2FYTkFSbTFWRXFoU3Rn?=
 =?utf-8?B?U0x4d1BLcHhId0tCQ1g5RG9YNVJpZTZaU255UkVkdHF3MkRiRURwWWRFZEN2?=
 =?utf-8?B?bnlRUFBPWncwTitXY3VZaU14TC95SXVRTUJNLzRMZ1I0NWFLa3NReTBrcUg4?=
 =?utf-8?B?TzBucWxXTmZjVW54RmJGS0VSMS9iUkhJb3NOdEIwbktNYnM5VFJ0ai84MVVj?=
 =?utf-8?B?Nm1qQTgrdnAzV1Q1Tmk1c1pybWc4eHZ2VExRT3Mra0ZsdEJaZ05hSUhiMGs1?=
 =?utf-8?B?WThDSm45U2FFbDBZazgrdWY0OXcyV2Y0MUh6WEZPbSs5cHNCMFloSElobFR3?=
 =?utf-8?B?UGNpbDZUVFNkTmdodndRbU5SRXNYajVuOENrZnI3aEs0OTIvZXVydFE4UGda?=
 =?utf-8?B?ZWJ0ZVdLSnVPYmhQdjFQNE81TmlsNHhhUTBLdURLeWZUZlAxUTBGdHJBNTcv?=
 =?utf-8?B?ckdHQzRCQXI5WTJaaitrZk5aTytjWkxxejJVNGFpNkRFWC9VeU1TSi9xSXJl?=
 =?utf-8?B?aTdsd2ZSbG5PemsrUW56TkdmcVNqMnhnRzErbCtVVWJoUzQwdEhPM202bUs5?=
 =?utf-8?B?ZUVOeDQ2Y1lXTUNRSExkNEc5RkMrbzg0VWNCQXVrS1FpUDlncVZuWGIyaHVO?=
 =?utf-8?B?WkhLY0lIQk5nemxyZkFEajBBMC81K2V0WUp3dmZFV2Q3RnJVandVOFBOL2NW?=
 =?utf-8?B?THpzOTl3UzJqTkRBMXM0UFRvUVVvUDBaTnljWWJ6aEVEdTc5S3A2R1RmSHBo?=
 =?utf-8?B?dU9zdHhxZW9RdSsrdEZkMEF2OUlMaDBIWlBya25xY0NhRmVVdVBBZmNTLzRz?=
 =?utf-8?B?SE41NU1GSFZwN0l6TDBGZkpVZWJSZnJGekhxN0x1M09jSnBBeTJhOGJZL3VP?=
 =?utf-8?B?Tzh6SkRrcmxHcWJLQ3VjV25nZklBaElqVmlaOE1BenZ6TkVLTEJ2MkxKekl6?=
 =?utf-8?B?ODFxUnBwU2FsTUtvbTgySFhsRXlvbUFJMXl4TnVYTUVlQzRvVzBDSURWTnlE?=
 =?utf-8?Q?jVBvTplDU8LdcMCtZEDU33s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C2853E32BE1844287A8DABE178580D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b83f971-d287-4277-dbad-08dc6b9f3f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 18:31:28.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2e5pun8uouFPT26QRQDke5Z+uL/sqJgDWFJqs1RSs0gr3iNcyuR+KJjtdhulZKAZgUpbfeW6NU53ylScpQtB5WnnUppqKggeSVywOKx01hM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7745
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE0OjE3ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDMvMDUvMjAyNCAxMjoyMSBwbSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+
ID4gT24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+
ID4gPiBLVk0gd2lsbCBuZWVkIHRvIHJlYWQgYSBidW5jaCBvZiBub24tVERNUiByZWxhdGVkIG1l
dGFkYXRhIHRvIGNyZWF0ZSBhbmQNCj4gPiA+IHJ1biBURFggZ3Vlc3RzLsKgIEV4cG9ydCB0aGUg
bWV0YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSBmb3IgS1ZNIHRvIHVzZS4NCj4gPiA+IA0KPiA+
ID4gU3BlY2lmaWNhbGx5LCBleHBvcnQgdHdvIGhlbHBlcnM6DQo+ID4gPiANCj4gPiA+IDEpIFRo
ZSBoZWxwZXIgd2hpY2ggcmVhZHMgbXVsdGlwbGUgbWV0YWRhdGEgZmllbGRzIHRvIGEgYnVmZmVy
IG9mIGENCj4gPiA+IMKgIMKgwqAgc3RydWN0dXJlIGJhc2VkIG9uIHRoZSAiZmllbGQgSUQgLT4g
c3RydWN0dXJlIG1lbWJlciIgbWFwcGluZyB0YWJsZS4NCj4gPiA+IA0KPiA+ID4gMikgVGhlIGxv
dyBsZXZlbCBoZWxwZXIgd2hpY2gganVzdCByZWFkcyBhIGdpdmVuIGZpZWxkIElELg0KPiA+ID4g
DQo+ID4gQ291bGQgMiBiZSBhIHN0YXRpYyBpbmxpbmUgaW4gYSBoZWxwZXIsIGFuZCB0aGVuIG9u
bHkgaGF2ZSBvbmUgZXhwb3J0Pw0KPiANCj4gSSBhc3N1bWUgeW91IHdlcmUgdGhpbmtpbmcgYWJv
dXQgbWFraW5nIDIpIGNhbGwgdGhlIDEpLCBzbyB3ZSBkb24ndCBuZWVkIA0KPiB0byBleHBvcnQg
MikuDQo+IA0KPiBUaGlzIGlzIG5vdCBmZWFzaWJsZSBkdWUgdG86DQo+IA0KPiBhKS4gMSkgbXVz
dCAnc3RydWN0IHRkeF9tZXRhZGF0YV9maWVsZF9tYXBwaW5nJyB0YWJsZSBhcyBpbnB1dCwgYW5k
IGZvciANCj4gdGhhdCB3ZSBuZWVkIHRvIHVlcyB0aGUgVERYX1NZU0lORk9fTUFQKCkgbWFjcm8g
dG8gZGVmaW5lIGEgc3RydWN0dXJlIA0KPiBmb3IganVzdCBvbmUgJ3U2NCcgYW5kIGRlZmluZSBh
ICdzdHJ1Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21hcHBpbmcnIA0KPiB0YWJsZSB3aGljaCBvbmx5
IGhhcyBvbmUgZWxlbWVudCBmb3IgdGhhdC4NCj4gDQo+IGIpLiBURFhfU1lTSU5GT19NQVAoKSBt
YWNybyBhY3R1YWxseSBkb2Vzbid0IHN1cHBvcnQgdGFraW5nIGEgbWV0YWRhdGEgDQo+IGZpZWxk
ICJ2YXJpYWJsZSIsIGJ1dCBjYW4gb25seSBzdXBwb3J0IHVzaW5nIHRoZSBuYW1lIG9mIHRoZSBt
ZXRhZGF0YSBmaWVsZC4NCj4gDQo+IEhvd2V2ZXIgd2UgY2FuIHRyeSB0byBtYWtlIDEpIGFzIGEg
d3JhcHBlciBvZiAyKS7CoCBCdXQgdGhpcyB3b3VsZCANCj4gcmVxdWlyZSBzb21lIGNoYW5nZSB0
byB0aGUgcGF0Y2ggNC4NCj4gDQo+IEknbGwgcmVwbHkgc2VwYXJhdGVseSB0byBwYXRjaCA0IGFu
ZCB5b3UgY2FuIHRha2UgYSBsb29rIHdoZXRoZXIgdGhhdCBpcyANCj4gYmV0dGVyLg0KDQpIYXZp
bmcgb25lIGV4cG9ydCB3b3VsZCBiZSBuaWNlLiBZZWEsIHNpbmNlIHRoZSBtdWx0aXBsZSBmaWVs
ZCBwcm9jZXNzaW5nDQp2ZXJzaW9uIGp1c3QgbG9vcHMgYW55d2F5LCBkb2luZyBpdCBsaWtlIHlv
dSBwcm9wb3NlIHNlZW1zIHJlYXNvbmFibGUuDQo=

