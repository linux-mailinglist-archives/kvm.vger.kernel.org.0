Return-Path: <kvm+bounces-54697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85DEDB27195
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B3CF5E30ED
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 22:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5757D28000A;
	Thu, 14 Aug 2025 22:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UpjtxH35"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091341C9DE5;
	Thu, 14 Aug 2025 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755210355; cv=fail; b=OWLD0iedmM/BlOxwF7lr/mq09gffuqr9BV1XorSS7fwO7knKJM1sW2FT54MWKGoqNANWVT1XxDijMcQaoyK+QdFtg7BZWuJhZoniXPz4OtcsSsw2gHxzdy8AeSbZeeFDb7e4Js9ZSo3ZpSnNSJIF5ruMO1m+skZXcWdJjB5LxJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755210355; c=relaxed/simple;
	bh=aH1DEgqJ4wdOQlscLhsFoESuFYWU82DJW42hT0tQmBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QwTw+X4egzH9GVb2eMrBTGEJPIXCiqmSE4Xlx6bJQuaLEj9HOr137DEFkErFwZl3097pbFfjd1pwev2bMAhKIYjM25UwwABIGTSJl9EW4HlnxKOOUVdbFSXVhvjstIQjaf4Oky8ncbF1OPDoXK1eTiIZM58CgaFXR27X8BdLlls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UpjtxH35; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755210354; x=1786746354;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aH1DEgqJ4wdOQlscLhsFoESuFYWU82DJW42hT0tQmBE=;
  b=UpjtxH35QAjf/spnBbc61eC7JfMX2NVEkNSu+UHC6yHxIbg+QxHlc3lz
   vBkti3AB9MUhj7BL/wkqGCh6piEMwGaiZs3UdvYXBdwqDSMpkUT9zPDu9
   XBGgZc6DabIfWEGn1z+MkE5dZPGbc8JS2TQ37qd4wh50qUW0wVxc+oojk
   nvyLj6X0FwANnkVdGO8k6vVC4S5eLdzDKET/Gh6u6NNTeHeH9byD8Lz06
   DyZw61W54JC0ZG1yXxZX6CLyDoNGAsFa/e2NUdny9yKwuJL1YfMzoCDEQ
   hj73dm5tBs49eNxbjJixxUer3+aBRsGAp+O35/V872ZJQWa3ZJcZ8OSce
   g==;
X-CSE-ConnectionGUID: 4jmyFdU4Syu4UJTGovd4fg==
X-CSE-MsgGUID: K0pLXFw7SUysXJbBpc6Rrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57253494"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57253494"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:25:53 -0700
X-CSE-ConnectionGUID: UmJjCO+FQ6G1/qEEo+dLYQ==
X-CSE-MsgGUID: iiTH1Sq7RBeM8k5cPSrIrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166366928"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:25:53 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:25:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 15:25:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.73)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:25:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7QTFvGdydLp6IA4lpvEaKAn9CsJ0tsH8Bq95uNKS/EBl7TPej8lttAyO15xE37CsP7jaUKR6EbGIxYFDnMkpjSFCetTfs6aSJiaNpkjY4znUOAY8atRVEkDBu+KyK/Wq07S+vAFcZngNCBLM3SUr5s2JqyiFdxmwOtiH/FeT/oYoq1ThsYOFlpLXOVmzRxaO50dYtrz1b2S19zk/CgPMKfPe2hE8m8YQko5PIULzGz8ov/sHT2XxhqQbO0jqdKk7i8bu3t3nWb3PfJ0AmEll7lgc4m1mbNC4ZacMUFph8aPWQX/n81JS1qe1Wg13pXAti0pvcxGjkCpusiSMatJ5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aH1DEgqJ4wdOQlscLhsFoESuFYWU82DJW42hT0tQmBE=;
 b=CievWu3k3YGMjHLLlZyNsYZ+lAKM3UMV3PtunH/CUdp0OmP33jauQJlCEO4yDBy3U+ClxycKoqXpbyQrcRyxPcptN0vCoQ2peTg16EU5RiCajTf+0oK6CZY05fcUFpNNEXuhdefwkpP6LTWVkJNYuL8k99EsQ67d1lgurgmoDU9wHtCUYWgu4+2XOQhg/cSgWc5MmJVowL6dxMO8af5Gxc3TF9bSJrQX+0cu+r9/JYTp+CD6bBNHFmvk82RMfq++PVp9w+cyAGhXOPS7ima+rqGSAv7MBHihHmRxCKddCW8tXzSj+6xKxCCk2mD3VEwRB5+wsyNvnolGQUADZyHfYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6675.namprd11.prod.outlook.com (2603:10b6:510:1ad::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 22:25:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 22:25:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "sagis@google.com"
	<sagis@google.com>, "Chen, Farrah" <farrah.chen@intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Topic: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
Thread-Index: AQHcDKj0KRQjWZhTjEidjLxSJo7SHrRiLIQAgACO7YA=
Date: Thu, 14 Aug 2025 22:25:50 +0000
Message-ID: <404b8048111697a49c9ca18a77ed36730a32ef18.camel@intel.com>
References: <cover.1755126788.git.kai.huang@intel.com>
	 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
	 <aJ3qhtzwHIRPrLK7@google.com>
In-Reply-To: <aJ3qhtzwHIRPrLK7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6675:EE_
x-ms-office365-filtering-correlation-id: 63ad5a9f-ddb6-4a75-771f-08dddb81860b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VGhPNEhvdkt0LzBvTXZZODlFWS91SlVlSVd3cy9BNlNaQTZvMzdwYWZOcTNN?=
 =?utf-8?B?Z1JHRTZ1REY4bUo5ckFocHM3MXpaekgwVS9DS0VaK1hLdi9WSFNtZFJScW8r?=
 =?utf-8?B?R1N3MFFEaklCdVNXWVpxc2tTWEh2eFpOQlBXMXhydTZjeHNxbXhidXpjc1dM?=
 =?utf-8?B?dHhGY2g3RUhySzdJS3RTQmVrSi9JdU5kWWU1YVJ0QllJM3NuODBjVXROT0lt?=
 =?utf-8?B?TGN4NlN2clhPZ1BDRXhQMFZmOFl3TzdWSk52K3NoanFsc2lTUUlDSUVPUjZI?=
 =?utf-8?B?dWRESzJTcFZLcWs3WHBsdy9lTzJTTnBONXIvSWRkZ3pwTHZDZWZUcHUxTTdi?=
 =?utf-8?B?L09HelFYWlFnL2s0ZWV4SkYyMlhzMkJ0WnpTRmUyQUZ3dzAxeFZ4U0VaeHNj?=
 =?utf-8?B?UG53TTMveTRpZ01hWWFuSnEyNVNLQVVGdWh2aEZwVGxYZFJ0T3Z1R1hoeW8x?=
 =?utf-8?B?TXhDc3FvZW1abTVPNXlaUUk5S2YyTDYzbEJhT1h2SnBMYklMOVdkT1FhR2N2?=
 =?utf-8?B?MUgzQk1GOWFUdXQ3eXpLZTlSTURnOVpsQUY1eVQrQ25UbFF3OCtMM0JUZ203?=
 =?utf-8?B?VTd4NjN2SU9XTkVBYlBoOHl3SXhDenVFb2JFY1NOZnFYY0dDa3BGQ3hTS1Yz?=
 =?utf-8?B?d1hvMFB2aDZUajBkRVlnNTQxdmpGSGxFam1DUjZabW9mVlZWRVh2dnQ3ajlP?=
 =?utf-8?B?RExFOHdiSC9LV0Rvb0RCVzRQV21STDhwUGZucHJmRUc1VEVISERFZXhTdk5J?=
 =?utf-8?B?T1FPU21FS1JoOGxSa1EvWUJKLzRGN1hBT2prTXNvMmZCYWRQVnZvdEJERlZL?=
 =?utf-8?B?VWQrOEpTSmJLS3VNVjYzMGNsVW80b3FTWEYvYzU1aWxsRXN6a3d5QlZQakcy?=
 =?utf-8?B?dkV3Y2JEcHJDTUpoRVFybW4zQmluWElxQ1BIRk9lZ0k2QitBLzBmdFZOVnRm?=
 =?utf-8?B?OGQxR3JESVNpaFZGSzRCaExEeHdBRFBndWpySm8zWmZtME43emQ0UE5sT0Jw?=
 =?utf-8?B?U3dNVlo4dFZ2bncycm5YK0lrTEx2Rm5qeDBNL0RFSGZ0MC9DY1BtZTZEUVV4?=
 =?utf-8?B?eTFac0FpQUUxRWxEWlNtUWJtcDNBUGorak9qcU9FWVYzR3dNYmZVTGY0Y2hD?=
 =?utf-8?B?SW0zUjJSWDkyaXVhL1A2M2dMZ0djRDUrS0p3R29ta1RtdjFSLzVqMWxNNDh6?=
 =?utf-8?B?S1llZ2E5OVVucUFlMVZmeHNZTE9xdzN1M3M1eHhHbFV2RldSaDNUeEd3RS9F?=
 =?utf-8?B?NXhWbWF0ZDlaYmdHZ3NiNkttT0krRGVkRnlFYUo1R2xMYVZCWjJScVJQcmVj?=
 =?utf-8?B?ZEhiam5GMEgrSzhQYzczYzVRUE53d0JaRVQ0RXgrOHNtbDBsblg5NlhVZ05X?=
 =?utf-8?B?NjVlRUxscU9GSHVVQld1SFJZNUhJNnRGbjUrbXpuWXZ0L3BwK1F4akZ3Tzgz?=
 =?utf-8?B?Rnh1VHg1OHVnWFRkQml2Z1lCSE1ZS2ZkaXRScEQzV0M2RlhjUWxZNTYvZHV4?=
 =?utf-8?B?TWxaMHd4STl5V3MxMWcxelE1UDg2S0RrbmZ6R1ppUThUVlVvRHppR1NFOEh0?=
 =?utf-8?B?c2l2TXZIQmRydUxRWGpmVm1kUHFnbDYvbVIrcFMvakswSHJ0ZnhlQUtFYWlz?=
 =?utf-8?B?NFFQMEEzeHdjSnZ4TlpHb0NSUUJuWmNvOEdKSDhSMkl0ZUFrb0hKSi9qMWxh?=
 =?utf-8?B?QldZV2NTSGVZZGFvU0R4dllVQXNsNlYzL1crdEJPb3ZQakcrdzFJbjRQSDhR?=
 =?utf-8?B?OEJnMDBXdndQNDA4WWdLNzd2MFZxYmhSeHpRd2N2VjBlY2NBRFBQdHBWdXRO?=
 =?utf-8?B?MkhQUU1zL2FaazB6QU14Qnh4UlVxeUtuQllwRnhRdjFmMkpoNG82dUtKM0Nt?=
 =?utf-8?B?QWkvN2JZL2hUR2NiMnIzZTZlNktMdUtRcEpEQk5VSW1uL3lRNGdXMG1ZUWFP?=
 =?utf-8?B?clE0RXdwUzZydzNkVW9NTkN5WS9Kd1ZvZEVPSDk0OGV5R3hoWGVWSG5wT1Zs?=
 =?utf-8?B?R2VkR1RuY3pRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vi9BN1YrbTkvOFpOQUk4L2pJTkZvcUxyOUZ6YWVzMEwvV1BTL0MzcEtETlVz?=
 =?utf-8?B?TDM0UElKZ0dnQVRZeEZPVWlpdzRkY3JrTkUyaFcrTk45VmlqWG5ZdDFZeWRr?=
 =?utf-8?B?ZUxvT2dZZXdlcElCUFRsUHJtSHZNNVdqVHlqa2RQQVY2eWVWSXZPcHNMWDJL?=
 =?utf-8?B?dDQ1bW90VzV4UmV4QTFzaTFqbGlTVzc3dTl0UHhFNXdtYmZDZmQrOUtwSm5H?=
 =?utf-8?B?RDFxc21oL0ZWbjdaQlFTNzg4NVduRk00TU43SWNPNEZBTjY0TFZMbVNQUHZ6?=
 =?utf-8?B?WWkzbVBSZU1xODRjTkN4Q0xxNnk1SFUxTmNSaWNqYWZiQ2pTS21ZWVltRjBJ?=
 =?utf-8?B?bDRwVXZEK29KeEg1dnNiTU1jV0NLRkFUR3g4QXhLeXA1RklyWmtTNllkNTNm?=
 =?utf-8?B?R1hpd25ncnBwOWNEdzRpZXRrNGUwVjdrMElnTTZqaXBhbmJoN1Nna3MvUVN4?=
 =?utf-8?B?TjJJczZIK3JTVW5GZ1hwdTRlOEZ1U1JEUFpqeDVlMXRKejJ2eVZFT05zMXdn?=
 =?utf-8?B?cW1Sc2kxdUVxOXlPVDBhWWQ2cXJFcVBVZlUreHZodGtra0NSTUlHdnM0M1U2?=
 =?utf-8?B?ZGdrY3ZBTEx2MFB4UldpazloT3JCR3dXYUhxMUtkdWJBcy9nZ3lTUFFYcVBI?=
 =?utf-8?B?a2hUTVJrb0JxMTMrQ2NiaVNNd3ZhSHYrM1V3T2FqdG03T3F4Y0Jna0pFNU83?=
 =?utf-8?B?N3RMSkFiOHVPYWwvNzhUTmh2eE5Ici9FYXg0MmNvRVhEaUV1QURHZDkwM1Bv?=
 =?utf-8?B?NkRKQjNncjJYUVVNU1BZVkxRS2taSzRLVDRXUERyVTAwTDVPNDJpL2xMOWs1?=
 =?utf-8?B?KzA4ZDRJMUtRejc0VXB2S1ZDN3Q0NkhHRzR5eVBOUEQ0NzhGeEh2R3NBMWRU?=
 =?utf-8?B?cDIwWmtRZlJYbjMvUFZFdEROZkkxUW5NUXVsNHphQnU1TG5CZ0djaWNkbU5V?=
 =?utf-8?B?UzYzNDJIUFVsUGdhUC9RUlN3cHNVeFR5c2VRL3NpN05DUTdFeVZzcHNiUkRG?=
 =?utf-8?B?T3JIYTFDZThweHpiN2p3cVgxZkNSU3kvQU9xTkNpaVl3MzZaUjZjNkQ4cm4r?=
 =?utf-8?B?a08zbnh5TEFFWm9LMXlpTTYyVDlhY3NidDJPM3FDNUw1U3NhQjdOV3d2T05D?=
 =?utf-8?B?QTV6SzkxK3lUUHpjZEEvNTdwb1dYUTJXazMxV3RrblFpOU1QSE15RWFqN3dQ?=
 =?utf-8?B?KzNkbDJVVDZMYmVqUDE4V29GSWwveDh3ckM4cEN1VElYMWN3TitLSGMwbGxD?=
 =?utf-8?B?dHJpMmMvanNZazRwWWk3QUs3NDBYRDNOTjlObXdmMFo2bFdldnU2N0VrQ1Rm?=
 =?utf-8?B?emxFMEZHT0psUFdobmRYdHlJNndteG84S1ZHV1NSMGdiTUpFVmRZWmVqbVpj?=
 =?utf-8?B?MGJ3bVAzZkw5WUw4bE1xblk5ZTMveUxnSTBBeG5KVnhBVWp1cVZtSkhZUGZF?=
 =?utf-8?B?ajZQaWdmaUFUMHNtK0tobmN4ZlJXMlg5a3VnQWEzTFV0NlpFMnBFM2hma08r?=
 =?utf-8?B?TjlMTGpwTExxV2RyZDZ0SkFzcGRXSno5UmxCeFhGNFl3eVQvY2JVbXZpYk1L?=
 =?utf-8?B?cGdNeHBtYUxTajN2RENVTUJYVHB0RzVrS09CZWdDbnlBUldGb1c4dHppTlZ1?=
 =?utf-8?B?a3dvNFlvOHhOU2hJVzQzWGdkdmgveVRRZjhPd1I1UGJoMWtWVjZVam5IVXNR?=
 =?utf-8?B?WDA5NEk2WmJkUytodytpS3VDenhrdHlEMUxuWEpYeGo2RWdJYTFFL2JTbERp?=
 =?utf-8?B?bmIrU1BaVGNKSmtwQjJpVDRneFAxRFNROU8wQ3UyTmF2NDBjdHhmZW1DWk9h?=
 =?utf-8?B?NmRtY25jTDY1TEZmMEc1aGFaNlErcnVLUDZEUUVOdXR6QXZEcENzVVY5c3ZM?=
 =?utf-8?B?cFIvTTZOdFRTMm83V3I4Qkk5K0kzYit4YnJrc21YOFZUOWNYN0VzdDBKbG1W?=
 =?utf-8?B?Zk1ZQmZta2hjZGFpMUNvSjl6cHFsVERvWDZBb2hoYnVTRW82bWxvR3FBcTg2?=
 =?utf-8?B?M0NzZnpOUDk3YnlqeUNOWFEyWi9sb2M4UW9hVUZXWnRObi9xTkNNTVl5MnVz?=
 =?utf-8?B?djE2aHJaaHlzQ2V4enhKa21nMkdON2ZmanpFS21ZTVBpTzlnaUtlbitBVXBm?=
 =?utf-8?Q?eD4Ot1o19md8v0ymE+eqcx7Xj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A4B7B0A839F780439FE3157B5741C88D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63ad5a9f-ddb6-4a75-771f-08dddb81860b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 22:25:50.2606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ABUXrG+CC53o5uAdeminrUPa4rP80sAaMGY+V8BHCzOFZROAjoDD8a+YvLwvFYng/NpM07lUl99rVunLTz9qag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6675
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDA2OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+ID4gaW5kZXggMDkyMjI2NWM2YmRjLi5lOWEyMTM1ODJm
MDMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiArKysg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+IEBAIC0yMTcsNiArMjE3LDcgQEAgdTY0
IHRkaF9tZW1fcGFnZV9yZW1vdmUoc3RydWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIHU2NCBsZXZl
bCwgdTY0ICpleHRfZXJyMSwgdTYNCj4gPiDCoCB1NjQgdGRoX3BoeW1lbV9jYWNoZV93Yihib29s
IHJlc3VtZSk7DQo+ID4gwqAgdTY0IHRkaF9waHltZW1fcGFnZV93YmludmRfdGRyKHN0cnVjdCB0
ZHhfdGQgKnRkKTsNCj4gPiDCoCB1NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKHU2NCBo
a2lkLCBzdHJ1Y3QgcGFnZSAqcGFnZSk7DQo+ID4gK3ZvaWQgdGR4X2NwdV9mbHVzaF9jYWNoZSh2
b2lkKTsNCj4gPiDCoCAjZWxzZQ0KPiA+IMKgIHN0YXRpYyBpbmxpbmUgdm9pZCB0ZHhfaW5pdCh2
b2lkKSB7IH0NCj4gPiDCoCBzdGF0aWMgaW5saW5lIGludCB0ZHhfY3B1X2VuYWJsZSh2b2lkKSB7
IHJldHVybiAtRU5PREVWOyB9DQo+ID4gQEAgLTIyNCw2ICsyMjUsNyBAQCBzdGF0aWMgaW5saW5l
IGludCB0ZHhfZW5hYmxlKHZvaWQpwqAgeyByZXR1cm4gLUVOT0RFVjsgfQ0KPiA+IMKgIHN0YXRp
YyBpbmxpbmUgdTMyIHRkeF9nZXRfbnJfZ3Vlc3Rfa2V5aWRzKHZvaWQpIHsgcmV0dXJuIDA7IH0N
Cj4gPiDCoCBzdGF0aWMgaW5saW5lIGNvbnN0IGNoYXIgKnRkeF9kdW1wX21jZV9pbmZvKHN0cnVj
dCBtY2UgKm0pIHsgcmV0dXJuIE5VTEw7IH0NCj4gPiDCoCBzdGF0aWMgaW5saW5lIGNvbnN0IHN0
cnVjdCB0ZHhfc3lzX2luZm8gKnRkeF9nZXRfc3lzaW5mbyh2b2lkKSB7IHJldHVybiBOVUxMOyB9
DQo+ID4gK3N0YXRpYyBpbmxpbmUgdm9pZCB0ZHhfY3B1X2ZsdXNoX2NhY2hlKHZvaWQpIHsgfQ0K
PiANCj4gU3R1YiBpcyB1bm5lY2Vzc2FyeS7CoCB0ZHguYyBpcyBidWlsdCBpZmYgS1ZNX0lOVEVM
X1REWD15LCBhbmQgdGhhdCBkZXBlbmRzIG9uDQo+IElOVEVMX1REWF9IT1NULg0KPiANCj4gQXQg
YSBnbGFuY2UsIHNvbWUgb2YgdGhlIGV4aXN0aW5nIHN0dWJzIGFyZSB1c2VsZXNzIGFzIHdlbGwu
DQoNCk9LIEkgd2lsbCByZW1vdmUgaXQuICBUaGFua3MuDQo=

