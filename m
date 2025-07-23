Return-Path: <kvm+bounces-53177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FFBDB0E868
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 04:00:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D092D1C82FF7
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 02:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE3B1C07C4;
	Wed, 23 Jul 2025 01:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="liNW3tP4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34181A59;
	Wed, 23 Jul 2025 01:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753235994; cv=fail; b=sTSOD/e14PzezFwfV/itximiElNuNO15L7ynGtLvLn1ffx1Izv/GI/uLhAI/iFTP5iEbtd+v0kHPbj28PtsNZ+jPUQWa1P+WeOH5vkutP7y9K4euJlUpQRrklyDdZNo/QrySWIvzI3KJnN/NqP8GDPMHTlmOy2C00wlHhh3ZqCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753235994; c=relaxed/simple;
	bh=v0vLjphylTo50k02sy+KXYIuNSBmKrA/c/kbwtwtEY4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MSA+A7mzGZw7kKWFr0L0jLuoOruTuhcFJvWDRscgs0c/faX7c88TLrBTOtZAlWyVQxI9QqoaDw61fe2vbsQviZEcetBuRJin5lv6PuFN2BcsfkFMYh/f3YMaWDDw5+zKLPxmwFPOGzFMl1dMYCtewW4idxBzq4XROhcuBod2EUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=liNW3tP4; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753235993; x=1784771993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v0vLjphylTo50k02sy+KXYIuNSBmKrA/c/kbwtwtEY4=;
  b=liNW3tP4hqrt4xdj3SKkoBQ/hqvIrmDEiCyfSZN3tzFz5CudGbmokwK5
   RDru9nMzSR0C48J65eG+2lmylpHVoUpTHw6Hsqn4VTDaiw/HIp2eLjRH+
   FDq61rIqt0t9ES/kXTN5Wm8UW4esBJrpJjmY+OW+B+pKWq9IZ1Ub8Rf5G
   CB4osC3j44C//bPSDr647SnWl9Bh8lLTO7ptV6oYKJuX3gn7hvoU4wJQW
   A7vJEdnsepDmuN++1u3FPcsSlJhwQ65HiQZaUPE9Ejhg/Kk2lgysVR/2b
   kuq3GoPePKrpG9rLYq2hRi7gFEUWKjK3NSi13P+kAi+CwSYZxqWGmDNsB
   A==;
X-CSE-ConnectionGUID: 3K1errvFSymAXDN4ES4eLg==
X-CSE-MsgGUID: k6b8fGzZSfeL8FKkywyi0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55651015"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55651015"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 18:59:51 -0700
X-CSE-ConnectionGUID: 5CrFNtyORReBZWNYTn1bUA==
X-CSE-MsgGUID: 5+sp4nyqRCmWzVCl5V2wHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159399648"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 18:59:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 18:59:49 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 18:59:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.63)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 18:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PcEOx3bCfjmMGUHR0v1/q2oBkbGWhu5cWqTc9v3A28souYlgOSnDR857yow2H7k6ib2XhoHY5q5dtCu0r+9MKIlyUMaaG2Oavx4HuMIkF7I+5QbZwji5ghkVpKZ3LZBpODUbKBw0MXDNEKpOx+U73vYvM5fSN1GyYlnSDSgokTFRow1nWpZIsxxzrS5F0a56DP+VkiEKFPRSj3SVmqQqkw6nGFHjV931GrwHBXSj/tiC35UACiMhBFV6avAOSasgNegIXL27rtgwV2IPOpC6geyzX/HREfRD1UOI64pnNveV+BzKULG2IztaEMA8fbz1o7shr2znVnFQTnBDxOdoJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0vLjphylTo50k02sy+KXYIuNSBmKrA/c/kbwtwtEY4=;
 b=lOYL/4iE8cSUMuLqJ3uRv8/qDuhWJZqpZSbktYKf+VdRlBSs1NmngmeO4hG80unxZRI+jG8XVeEhh7pcDsGslI/SWLdhVlzDW6VuuN9bvNJqpKzYbM2DDssZjUrnoBQWzCQSmbxp0BebFeVgXLJPUfnRa1b5B5tOTzdkQnil70fNcmg2KIp8EpU6PLk58bZxjOVjK/IsRTfY4zKV0nRNlnHOepw75Cm5lrJku0P37IezTsv1THu+fzMYFW+E03nZhI1WO9DlI8k1gB1evRw+zkqr0hW03hIuudfQOlpjkBdXzAnzeqRAPF4OzQ3KOf4mPO432yuMJuoILuhauEcDPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB7022.namprd11.prod.outlook.com (2603:10b6:510:222::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 01:59:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 01:59:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v4 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb92MNY3LayrIRbk2F1nQI0dIiy7Q+QdaAgAC6NwA=
Date: Wed, 23 Jul 2025 01:59:28 +0000
Message-ID: <322fed1cba5355ec3ab27ad721ff8142e9361aff.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <ac704fa28a814b8ef5cca14296045c14b1fdd5d5.1752730040.git.kai.huang@intel.com>
	 <aH+lx0vJE5KA7ifd@intel.com>
In-Reply-To: <aH+lx0vJE5KA7ifd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB7022:EE_
x-ms-office365-filtering-correlation-id: b7eb0b0b-aeb8-4369-8c39-08ddc98c8eba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bFVoczRyY3M0Y20wbzd1dmdvL3MySGpBd1IwbU1NTWxsTXNHdjc3dXZ3QmFy?=
 =?utf-8?B?cEZzcUdDVnNZRDBDcnVQbUhzRWRzQnZ2Y1NuWVM1ZXBGTXZBZHBodVE5Q1dh?=
 =?utf-8?B?L1FzYU1xUzRTQ2FoNEtYTFZJalVqZndJa2UyNE5lZnZaV1cvd3FybjhPRkJI?=
 =?utf-8?B?OWZMYjBtM01tcTlxTUtKZjdqR0lWeUc3RlV6L0NraGo2ajlmM2pBQXNZamNM?=
 =?utf-8?B?QUtldjZrV1FpYWlsaGZYTUNNa2VJSkJpUjFPcjd0VWJTdEVRa2daS2VmL3pt?=
 =?utf-8?B?cC8wN002ZnJVZXNMeE9acFMxaU81Mldsc0hwaUh1WTVDckVyZXEvbW10ZG1u?=
 =?utf-8?B?OEdXRGtiRitGRFduR0VLSVd4eGMzWC9kRUsweGQzY2x0Y2phL1VhV0lVelhv?=
 =?utf-8?B?NkpmSFVwekFBOGREVGFFRDlnUzVPQ1NUZ051TWtRcEhXZUdOKys5RWNUeXA4?=
 =?utf-8?B?ay81bjJUdEY1RzF4NGtXKzJlQzErUkw4SW9XSFZaeFJHU2tKRkdmVmx6RXdo?=
 =?utf-8?B?dDU1eEFsUXVRWnh5S09tUmhOeGxCK0Q4dFovelQ5UVBRWTZScmI3bEpXOSs4?=
 =?utf-8?B?SjZ5OEMvL0pWZGFKcXlFS2Q1QlhjalhjWDlaTmFudnE2d0FUb25Ob2E1ZmRH?=
 =?utf-8?B?WmFnUytVUE5LMTRaT1h4bFRrc2NTMlEzdFkwVURHYnNud1FmTW8zN3NaZlR2?=
 =?utf-8?B?MnFUZnpkYlB1QVNlUlNtUTBDdEVEWkhJL2tqL2hSMm1LYlR1U1JyZ2FXZUI5?=
 =?utf-8?B?eEpXcmNJNHloeS9IM1MwMUtpVE16eGR6U3BFVWVaNjVNZG8vK0RuOStpenFY?=
 =?utf-8?B?bVNEeEk1MUpqcTlCbVp5UGh4NlRTcCt0K2VDbEJmQks4ckIvamVlWVZWQ0o0?=
 =?utf-8?B?SE1CWElRUUFVRUNRZDQ1MzA2UzcrL1dhc3VpYmVOWUVuRCtDYlhEcnRkcU1h?=
 =?utf-8?B?QkNZaWhLdEJRWEZRZnhEVkoyMTN3WVVxUkFTMHZPRnFtR1hKY01mSlpXczRT?=
 =?utf-8?B?bUNzUC9hWnN0MlRFMUNGQkgxcUMrNUZIbjBBTWNGaVJESzk2T3A1RFRRV2sv?=
 =?utf-8?B?M3Y1V1liWG9Vcmd5RUJzSW1nWHlQdzBnditHRmQvQmdRcVo1ZFREczEzeU10?=
 =?utf-8?B?WnlqUkIrRU5ReXFlZlBsTDJTK25yUXhIUXJrVXVuMGlub0MwODJ6VHhXOUNH?=
 =?utf-8?B?OFRESUpSMUhZQmV5Y3B6bHBpZEJZMjVUVENrV1FaYStCRlNIekYyN3hiK3dN?=
 =?utf-8?B?ek9UWkNuSWRwV3pZWTFUQ3ZHL0tkMXNnV0hjSXFqcmxvM016WHA5T0M3T3RV?=
 =?utf-8?B?Y0Zub3VEQ2dFSUJiaTc0NmUzSlN1RDMzOWM4bDdoNURNUmxKZ1lsUlJ1QmNy?=
 =?utf-8?B?aVoyZUh2UmNXOGlBREkzTm9iMEZNenkvS1lKY0w4UHZlRTltSzVJMjBlNDdR?=
 =?utf-8?B?bjdzdWJYck1qNVY4aDJaQzhtYzRGMjF2WUpOZndWQmRYb3BmaVJQSWZJM0hY?=
 =?utf-8?B?dTRoelVTYUQ4TVFvWTdGRU43aWgrYm9UaWdCRnhSUHhPQ3ZMaDlMOEh0M1d4?=
 =?utf-8?B?VzJ3VzN4dDlycWpvK0lhS09tZjJGdkxNVk9lVkhHMndvNkR4YTNRSXYvTnpV?=
 =?utf-8?B?K3ZHcEphRWhXb2ovcU5zaEcwVXd6LzMydENlSmVGR3hzT0t5Y0M2NjROUFh0?=
 =?utf-8?B?U0gwV3BmOGF4RGtHUHJFTHFrNytwd3FtSXIxNUFPNlEvQ0pTazZPSWJjWkRp?=
 =?utf-8?B?UW53cmloSDNwTE45Qzh5OHhESVRHQWYrUmprV09qOTZwQXByR0tZdDY5clly?=
 =?utf-8?B?YlozT0lhU1FyeW1HL3kwWld5a3Y0U25xTFp3UmNOM1dYRENJS29tMDc5dy9Z?=
 =?utf-8?B?NmFtaVBhcVNrTTdzeVk5bElabnBjaWwzbEFQQVBKNlJjRWhYL04vWGNpN2Nn?=
 =?utf-8?B?V29wYzB4VFU1d2p5YWRaMVBjNzBMS01KakJSays5a29nTVBTaFJBM0g3VjNL?=
 =?utf-8?Q?ZGL67iKicAxF1y5mbiDKCLcO5K2MqM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmVtcWw3SlF3VmRlKzNKUDhJMDlVZ3dCTGtNRHlLOEVGSkMxNTN1WkN0NTIv?=
 =?utf-8?B?NmpSQmYvbW5WQkFHZWY1d01WQTAxcitnb3N1RUx6OTBIRE1Jczlxc203aFlS?=
 =?utf-8?B?ak84aDN4ZWY4Ylc0ZVIyZlIyWWxiTXpGZGVRU21wcXc5N1ZINjFiRWtmaC9z?=
 =?utf-8?B?bFNtTFRNaVJnNGN5bDluOW5Ed21IbVhqOE14dG1adm4vZ1lGK1Zlenh1d1dv?=
 =?utf-8?B?TVRQaUlNNWI4dlNxaUh5VGhXOGN1aEthakdoMVptem9GUk9ZMDN5MUMyRnhi?=
 =?utf-8?B?WHNhSVlQVENaK0JYNjQzT1c4WTQ0aXh1dVo2ZGlLTEVrWFBHM0RnZDc5eWdX?=
 =?utf-8?B?a09oaWUrbm5RUTRoU3FDYmo5enpyaTc4dHhKUkw4dzQyTkVFL1Nja2NwYm1I?=
 =?utf-8?B?WkdlSHBQakswU1VEa2NmdnkzTnJid3cyemtBMUM0ZGJYT3FWNHAxWDhnangy?=
 =?utf-8?B?a2E5bTljQ0FzTDNWWHhjcFZJd2ZpazV2N3RncmRZS1lRSzY4Nm5oeURxL3VG?=
 =?utf-8?B?aUZyN2ZwOEszU1c2TUpWOGlaNGF3TGU4RHR2dm9XU0FHU014QVdudnRZa0R0?=
 =?utf-8?B?ZGtaL1ltdkhzcitrWktOcWljQVhoZEptU0dZczc5TkNvTE14bEJWNW1EL3Ix?=
 =?utf-8?B?VmEvcDNMaUovTFZvVVZvUkt3RmRHbGZNMngvb09LWmRYT0FWRnowRjhmdXF5?=
 =?utf-8?B?SXJwU2Y4ZDdzbU9CV3FBb1Z1NnY2OWp6M1d0cmFFdVU1YUFlY1dkbE5Kb1NR?=
 =?utf-8?B?aWpxQUlHVFVJdGpuL3VYT09HZmJOQVJWZmkwSCtrbzhyay9HdFJJWVJSdmYv?=
 =?utf-8?B?RnVHM2pQYnFLY0diZ0hsVG9xNGF6eVEycCt4WHFEMnBSdTc4TkhzUFB4MmNi?=
 =?utf-8?B?SktqZllTMUFzai9ZYkNjMEFjaVd6bGNuU1VTWkl2bDR2VjBIc1JBTmZFdm9s?=
 =?utf-8?B?ZU9TWEZ2OWtpMy9HZ0l3QW5jVFRjSmRLUWYwTTVyMnlVMFl4ZU5KeEkxQ2px?=
 =?utf-8?B?SjFqbVV5bWhuMi9EWk5ZQ2hpd2txUGtWOThpVndxcFhPT0dGdXE4WkdOZFQy?=
 =?utf-8?B?aktHMEQvQmJ0VHdVbzN4QndmaUZpREkyT3FIMGsyUThEMVc4WTFDWkxWL3ZT?=
 =?utf-8?B?ZGRjTmI4T1NrUzNVeUFmR29YcXdab2U4RE8yYjJJWDYvaDBqeWFzQ0xia0dR?=
 =?utf-8?B?SDAzSU9CTGRnWUkzV2NxSThmbUY1U0ZCa1ZMUkpQTnpIN09vZTZidTRHK216?=
 =?utf-8?B?MkR3QU1UTk9VdUZ1WDd5TTliMXhjbTkyTllCdWNMVzNCT2Erb2N1K0Q5L1Jq?=
 =?utf-8?B?MC9TRVE3NEhxV2FaMGI1YkNWYmk4NTVTdnhEN2RnNFdYSEROT3N3YjY2Yzhq?=
 =?utf-8?B?eTRZWUNsUVdHM2c2ZkhYYVZiRXdrZEtiSFdkVDk2amhiQ3l6ajRhUk5tQXRV?=
 =?utf-8?B?eVlvYWpHQ291Tkdjck1naDVDQytVTHdEeGtHbXJLRG05ckZBNDhJMllCcGZz?=
 =?utf-8?B?aEQ4Wi9WaUhON1NHRkswalpXZzAvNUJWYUg0UEJUY1R5alBQOElNR0x6Sk8v?=
 =?utf-8?B?VUxsdStoMlg1TjdJWGRqNzZXcmp4dEJxWDBtbkFVaHV0YnU0Q1NMaFZoajlW?=
 =?utf-8?B?M1hRUnBSTGo5bXJOeWxhcHViQ09wVDlaSU92eDFSQ25xQzZjNjFTWm96dUZV?=
 =?utf-8?B?SWl3VlVWb3U0UmlGaUFsWFF0cWc3MTQ1THFzSXhqNjVsNGZSSHhZRjhrRFdv?=
 =?utf-8?B?WS9zOGhzdU9ZOVR3emUwOEQ0UkJKSVdmeWM5a2FwcEZUTjF4VDVRQmU1SzRC?=
 =?utf-8?B?ZG15NkpGSElQMzJUKzRuZ3pJT0RtWEVyS29URUYrSWVlNVNnT0NsbnJkVFIx?=
 =?utf-8?B?RFFqUzc1bU1hMHh5a2lPZXAxdzhZYzRaRCtwbmxjU2tiQnBJaFMwVHJGdVEw?=
 =?utf-8?B?Z2thcWd3N3JlVU1BcHlBUXRJbllLdC9GMkhsY3lCK1V2RGtwVlc5U1B1NVpL?=
 =?utf-8?B?SkxZRkVZNUdzUlNlMmlvVVpESE1WYzJjaWZ2SVZnZmlzYzN3VnIzUnJ6M1pl?=
 =?utf-8?B?OUIvbDB6RUcyVkdKdHJvcE9zSmloTjZuS2p3OUFkSEMxNE9nSzRBRW1OeklB?=
 =?utf-8?Q?8k6zl3JsbebbtCO71xpWQQQQU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AADEA7CA174B4043863543C984E21E34@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7eb0b0b-aeb8-4369-8c39-08ddc98c8eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 01:59:28.3419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7PE4b2UO0yrc+5RvdhsAsAxoXxOPVq/b+iavVdNTnoRqjDLV4Yx75IvRV6mnhRk6WyBUu6gXZaDgLJrp+qcn7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7022
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTIyIGF0IDIyOjUyICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+ID4g
K3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdTY0IGRvX3NlYW1jYWxsKHNjX2Z1bmNfdCBmdW5jLCB1
NjQgZm4sDQo+ID4gKwkJCQkgICAgICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4g
PiArew0KPiA+ICsJdTY0IHJldDsNCj4gPiArDQo+ID4gKwlsb2NrZGVwX2Fzc2VydF9wcmVlbXB0
aW9uX2Rpc2FibGVkKCk7DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFNFQU1DQUxMcyBhcmUg
bWFkZSB0byB0aGUgVERYIG1vZHVsZSBhbmQgY2FuIGdlbmVyYXRlIGRpcnR5DQo+ID4gKwkgKiBj
YWNoZWxpbmVzIG9mIFREWCBwcml2YXRlIG1lbW9yeS4gIE1hcmsgY2FjaGUgc3RhdGUgaW5jb2hl
cmVudA0KPiA+ICsJICogc28gdGhhdCB0aGUgY2FjaGUgY2FuIGJlIGZsdXNoZWQgZHVyaW5nIGtl
eGVjLg0KPiA+ICsJICoNCj4gPiArCSAqIFRoaXMgbmVlZHMgdG8gYmUgZG9uZSBiZWZvcmUgYWN0
dWFsbHkgbWFraW5nIHRoZSBTRUFNQ0FMTCwNCj4gPiArCSAqIGJlY2F1c2Uga2V4ZWMtaW5nIENQ
VSBjb3VsZCBzZW5kIE5NSSB0byBzdG9wIHJlbW90ZSBDUFVzLA0KPiA+ICsJICogaW4gd2hpY2gg
Y2FzZSBldmVuIGRpc2FibGluZyBJUlEgd29uJ3QgaGVscCBoZXJlLg0KPiA+ICsJICovDQo+ID4g
Kwl0aGlzX2NwdV93cml0ZShjYWNoZV9zdGF0ZV9pbmNvaGVyZW50LCB0cnVlKTsNCj4gPiArDQo+
ID4gKwlyZXQgPSBmdW5jKGZuLCBhcmdzKTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gcmV0Ow0KPiAN
Cj4gQHJldCBjYW4gYmUgZHJvcHBlZCBoZXJlLiBKdXN0DQo+IA0KPiAJcmV0dXJuIGZ1bmMoZm4s
IGFyZ3MpOw0KPiANCj4gc2hvdWxkIHdvcmsuDQoNClllYWggdGhhbmtzIHdpbGwgZG8uDQoNCj4g
DQo+IEFuZCB0cmFja2luZyBjYWNoZSBpbmNvaGVyZW50IHN0YXRlIGF0IHRoZSBwZXItQ1BVIGxl
dmVsIHNlZW1zIHRvIGFkZA0KPiB1bm5lY2Vzc2FyeSBjb21wbGV4aXR5LiBJdCByZXF1aXJlcyBh
IG5ldyBkb19zZWFtY2FsbCgpIHdyYXBwZXIsIHNldHRpbmcgdGhlDQo+IGZsYWcgb24gZXZlcnkg
c2VhbWNhbGwgcmF0aGVyIHRoYW4ganVzdCB0aGUgZmlyc3Qgb25lIChJJ20gbm90IGNvbmNlcm5l
ZCBhYm91dA0KPiBwZXJmb3JtYW5jZTsgaXQganVzdCBmZWVscyBzaWxseSksIGFuZCB1c2luZyBw
cmVlbXB0X2Rpc2FibGUoKS9lbmFibGUoKS4gSW4gbXkNCj4gdmlldywgcGVyLUNQVSB0cmFja2lu
ZyBhdCBtb3N0IHNhdmVzIGEgV0JJTlZEIG9uIGEgQ1BVIHRoYXQgbmV2ZXIgcnVucw0KPiBTRUFN
Q0FMTHMgZHVyaW5nIEtFWEVDLCB3aGljaCBpcyBxdWl0ZSBtYXJnaW5hbC4gRGlkIEkgbWlzcyBh
bnkgb3RoZXIgYmVuZWZpdHM/DQoNClRoZSBjYWNoZSBzdGF0ZSBpcyBwZXJjcHUgdGh1cyBhIHBl
cmNwdSBib29sZWFuIGlzIGEgbmF0dXJhbCBmaXQuICBCZXNpZGVzDQp0aGUgYmVuZWZpdCB5b3Ug
bWVudGlvbmVkLCBpdCBmaXRzIGJldHRlciBpZiB0aGVyZSBhcmUgb3RoZXIgY2FzZXMgd2hpY2gN
CmNvdWxkIGFsc28gbGVhZCB0byBhbiBpbmNvaGVyZW50IHN0YXRlOg0KDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sL2ViMmUzYjAyLWNmNWUtNDg0OC04ZjFkLTlmM2FmOGY5Yzk2YkBpbnRl
bC5jb20vDQoNClNldHRpbmcgdGhlIGJvb2xlYW4gaW4gdGhlIFNFQU1DQUxMIGNvbW1vbiBjb2Rl
IG1ha2VzIHRoZSBsb2dpYyBxdWl0ZQ0Kc2ltcGxlOg0KDQogIElmIHlvdSBldmVyIGRvIGEgU0VB
TUNBTEwsIG1hcmsgdGhlIGNhY2hlIGluIGluY29oZXJlbnQgc3RhdGUuDQoNClBsZWFzZSBzZWUg
RGF2ZSdzIGNvbW1lbnQgaGVyZToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8zMWUx
N2JjOC0yZTllLTRlOTMtYTkxMi0zZDU0ODI2ZTU5ZDBAaW50ZWwuY29tLw0KDQpUaGUgbmV3IGNv
ZGUgYXJvdW5kIHRoZSBjb21tb24gU0VBTUNBTEwgaXMgcHJldHR5IG1hcmdpbmFsIGNvbXBhcmlu
ZyB0bw0KdGhlIFNFQU1DQUxMIGl0c2VsZiAoYXMgeW91IHNhaWQpLCBhbmQgaXQncyBwcmV0dHkg
c3RyYWlnaHRmb3J3YXJkLCBpLmUuLA0KbG9naWNhbGx5IGxlc3MgZXJyb3IgcHJvbmUgSU1ITywg
c28gSSBhbSBub3Qgc2VlaW5nIGl0IHNpbGx5Lg0K

