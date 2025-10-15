Return-Path: <kvm+bounces-60065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17232BDC998
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 07:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFED7420114
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 05:27:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A65630275A;
	Wed, 15 Oct 2025 05:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khkGbBTO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281364438B
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 05:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760506073; cv=fail; b=MyxhuRHlGubh0qPprcJz0KRPGHhG2glmCbTEOO5kszV65aNlpAbHhSGFufCdklQzHK9PgReGknqBNq0X11jfyzlBSoUJbTUBE0deponXDKUuJ+6hH7KAPFqfXoNhQwhsOei6dr7NRf5CjzoIkaAnB0F/ajpPwVuuPPCqFRQdbNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760506073; c=relaxed/simple;
	bh=3q0xqGYfMXJwJBRrKQc805dy66gtNdhsLrKZ+xXTmbA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kvQz90DORfyVZ/PZaAOLCWg0W5CcjqlmdtgMLXXGQ2dUcLLfvK6SzoG/XRoyeXTudgkykHASpP8PYGN4bL2n/l1ttTPN1TNOlEcYWrKvRCbU/dgM3BzmcvoDCtliihaJPTf3dtjSXn77C2cJn8UmR3Wf+WnKbslB/3x7L4uwoQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khkGbBTO; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760506072; x=1792042072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3q0xqGYfMXJwJBRrKQc805dy66gtNdhsLrKZ+xXTmbA=;
  b=khkGbBTOl+7GyoQGYMJhwfkILVjDOoCF+0NC8dw97MMUFBQqM1hNG7W5
   JXH4sDlH9FYBdDzSIGo/iFWAxdH4CjuLOnj5in/1Rm1rNzUy72rAIMMBJ
   Db6AD80Oi0skt2TiQr38Mg3JpU0DsdVxaaX0w4uDU/riY0ukv6mdWhX30
   blo+O6J56GpBxYYh8UNK/qeuoRJtlaSWAXj4+JOUBgHKIMwpKZoSP+sIH
   lQaU0/hO7dog4hwSPAO17fsGqQVburLhFR/8HgNPOOUA514gB51pl4M3B
   QdY5uhKeuU42Pw4tW+F4aq5L3yMm5ZZwuZYkZn2tJUaKxqH++rJTt3e6D
   A==;
X-CSE-ConnectionGUID: 2WvHShA6QsSJu59ghWG/Uw==
X-CSE-MsgGUID: TlUdoB/QR1W24papTtDe3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="66499542"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="66499542"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:27:51 -0700
X-CSE-ConnectionGUID: 9J8L2ORbQr+Xe6JclH0x7g==
X-CSE-MsgGUID: 6RFynOf4QsaRXdpXLGwsqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="213026232"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 22:27:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 22:27:50 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 22:27:50 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.62) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 22:27:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0wv31VpCLdpCIMxc2k+uWLpzMguUPymA5zTXL1lmRpIwR2TE0aiXydcYdgyfj/1CRY0tr6yLkYxHQJ12r91Cwu7NY7KeikZt6tgZvKczbY3KPH1MTQoT1Bz+wnhCF9Gyr9UsU2RtKZy+n5t6ipkERqS9CwXGn3XmpMq1mrqxFdNN6nxfeE2k+VvgHwZOetnIyVapQvYTLW1J4oZVzwwzrIaaVz128bjwq66TBYUo9aELjMgo9c5ruYSIfGTCO30PHLYHJUc8JGk8C8axJyrChXKasacfXuh4L80bitB8dl1dIG6jG/7xZL3do9ZD3Cr4dy+hXkI5sm691aiNpLnng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3q0xqGYfMXJwJBRrKQc805dy66gtNdhsLrKZ+xXTmbA=;
 b=BrdgGnLEPWnlK5Gso2LaBcFT9gIL0z97nfG060O3Gdba8QZK4EZDLstKVOlbQmKiHaBqd/1cuOTPWop0t1voSP/m+DmXOzriW6Ze/KShECEDDBbLhvXST/cwI2Px8G9INMT73D7DzkdolCXFpVGqAcksxsgjWCKirDZMwBzwSP6C/Wj95Dbm1H6mAMUQzvtBYEjcpksdVLiNAZYn0cpr4MbNNfrSs3BJbtxdyrWIES/zUUnWpWScZp/8lt3hz1qxjm5AwJcX4FN44bioEQIsxMOOLzvuFnosUCWNYUcc42XhbmBu3uyWKw9LsykyjZBFLsmNEzE1BdfMhrDfRl4A/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF92ECB6678.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::846) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 05:27:48 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 05:27:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>, "bp@alien8.de"
	<bp@alien8.de>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcPApHQq5GYUzMbUWZEhHpuKXxubTBhNuAgACYtoCAAAw0AIAAA4EAgAB3QICAAAxDAA==
Date: Wed, 15 Oct 2025 05:27:47 +0000
Message-ID: <90621050a295d15ed97b82e2882cb98d3df554d5.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-5-nikunj@amd.com>
	 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
	 <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
	 <aO6_juzVYMdRaR5r@google.com>
	 <431935458ca4b0bf078582d6045b0bd7f43abcea.camel@intel.com>
	 <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
In-Reply-To: <48e668bb-0b5e-4e47-9913-bc8e3ad30661@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF92ECB6678:EE_
x-ms-office365-filtering-correlation-id: 1d141c2c-c486-4fcc-acae-08de0bab93ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SHo0d2NxVzNKaFpKRVNtNkVodUNVRHBaZFZyZ3lLdStTeXI1SjlkMVpyUmtL?=
 =?utf-8?B?RG01ejJqbWI0azNNN0pwVGdDNFJHQURmS3RvRHhmZm4rS1Z6eWR1cGN4QkpN?=
 =?utf-8?B?Q0ZDVEx5Mnd5MVMwQVVkTmpqQ01KSjIyeGtNKzdadWE1VzNEUVM4MVBJSGFh?=
 =?utf-8?B?OS84MzJjb2Zza0NjNUVOdDMxV0JiN1lCQkdZMjM0bmRYVmUyN2ZhK09leXNV?=
 =?utf-8?B?aUV0S0tSZEtvdTZDVVVianpwNjVYeDBsdXhHcUlXZXhqcDBQV0JHOElnSkNN?=
 =?utf-8?B?MWpDZDBKY092WEVmQllYMmpsd3hiZVdvdHYwcy8vUEhlQ0dBWTF4Y2ZsMUFB?=
 =?utf-8?B?dytEcnliL05Ea2Y3MmZ2SmtyOUhJZzNZZUlvOS9YZVMxRUxIWlN5bFMxa2pW?=
 =?utf-8?B?M3FpT0ErbG8vQzREc2dmTzZ3Y3NJS3FYcWlKbnhPTys1TnJSaXVMREJmQnlz?=
 =?utf-8?B?TTZLemVyQzB5RDk2TnlGRnJWc2xGbVlxNkVVRFR6aW92Nkc5M1NERm9oSncv?=
 =?utf-8?B?TVNMVGNnZHltUDdRZ2VnanFHdnZsSjE2TWJkUFkyZ0dBQnFZSXo4NGkycVhD?=
 =?utf-8?B?ejVYaHZIeU1SanpHWlZ3a0xhNm5VVmtleXRwbzVBbjZTUGdIUEpISkdKKzBL?=
 =?utf-8?B?RjFvdUxnZm1TUnNjTnI4SDZFZS9WUDVYMDV2d1hSYUNsaUJYeHNsQ1dUTG9U?=
 =?utf-8?B?QVFaWlJ1Tmx4SHJZNU52eE9xWG5Wc0ltUXdwbDFvbExLcE9SM3VlbEZPN0pX?=
 =?utf-8?B?L3BhYUtmM0lhcWJ3bmVpSUpxc29DcDdzalNNWnkyaWkxZFlsWG1sZXE5a21o?=
 =?utf-8?B?dkkxNCtiWUk5ZVNOaG56NUJ1U3F2ZFJ5MlJzV1J3V2RERlRPcGtabXc0RG5R?=
 =?utf-8?B?R2NWN3FXYlNZc0VvS1BqMWNhbmwxQ3BYMkRWb1hON1RFMGNBRzY1VkIvUDQx?=
 =?utf-8?B?emFEZnFFc2ZCcm8yREJpcHZkeEI4NU5jVGk0Z0ttYkJMbnB3MlZIT3loUnBo?=
 =?utf-8?B?SWJacWpMNWFvR2FUWVZCb1VBWFZhSXFZTVkzZGszRHc1d1ZuYVhIbGgvcWg1?=
 =?utf-8?B?RUdWa2llSUk3eDZMV3lTMmVGMzdONjVhaThpNmk2MlhkRm1LTkp6YUhhTUMy?=
 =?utf-8?B?OGZtUFE2Y294RnV6SWhraXlES0xmNHUzTHFDY05qUmh4TTE0eFI5WDZhWFZL?=
 =?utf-8?B?QTQ4ZjJrK20xMlJkNHVENlVRbGRFZURKajhmYmJ2cDJKd0I3bnVaWjlZRUly?=
 =?utf-8?B?Mi83V3FIZWhwRkZIblVFNHN5bS9nUERwTlNhWGhNS1F6WWtsNzlEZE5JcGpr?=
 =?utf-8?B?c0l0OHFrZnRVaWlqOUQ5MkpDQjY4SEYra0NxdHBGak1aN2lKTE50a3YvZ2ZJ?=
 =?utf-8?B?SEkyM1BPWHZYNzEvdTk3V0pQOTRtd1IyRW1jNzhsYVFOMDRjak45NGFocDhI?=
 =?utf-8?B?dXpWTWc5TExJZVdsNUdHcXIvZ3lvSTZLMDIzY0RuUFZVK3prTHJENXF0NlRB?=
 =?utf-8?B?c3BNb25yOHVWZ0NVK0x4MWtITDZ3V0MyRFhHVlcweHVzZmRNRjlrVWRtSS9q?=
 =?utf-8?B?bnRpcDNIbkhIY1hQbFZvOGVnVkVKbUk2RDNma3NxUVBOL2liVlh6cHVhay8x?=
 =?utf-8?B?eVNOcGcyVWxVVXlsUzcxbWR4SC8yN1hnMFlxbGFHT1Y2S3lvSGJTT2wxUVhu?=
 =?utf-8?B?dElrMkJ2U2d3MjFMSDlrbjFjN0h6V0FYRTFMOFh5bWVRa3RzNnpkTXFzQWE2?=
 =?utf-8?B?U2orNXorTG5WejJhbysxTzI1cnN5WmxXaGgvNFVSdzdtSFp1SURYV1N5YTEv?=
 =?utf-8?B?Mm5mS2hvZnJKVG0yME9YUlpzRFVManNYTEN1RWpORVFsZzFkUEhIeEJmUmpB?=
 =?utf-8?B?ZSszdUFkd2plMWxucUtQRGVYSVRxYkdqZU5WMkoxVW1xb3JXN0RHc0YzWlRT?=
 =?utf-8?B?WE12UXhMeXl2WCtzZGJxNTZxeU41Q1hZd2tnRENCeFYyNllVUGNySmJqNklX?=
 =?utf-8?B?MTA5dS8rZFdDVk1US2xxeGRSekhBU1V2Q25sZFlCMlpERkVxWWRWekNwYVRT?=
 =?utf-8?Q?WMlwx+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXFiV1ByalRHZTlibEdJME5FVHd5bHdvbVRRWUxIK2QwRjdpM3VVSjBuak4r?=
 =?utf-8?B?K0dsOWloM2xlanJkVDhSNkoyVEUzcXV4VWluUjdjYzRPQ3BzQXp2NG1tbzc5?=
 =?utf-8?B?S0Q0YW5ORSs1S0o4NncvNUV1TlBJUWVLUEFZQ2U0S2plZElDL0pSK2VEdmFx?=
 =?utf-8?B?M2t4Mzl5RGxSYWhKVHRHWU11dU5QQ0NTOUlhUFMyRWlheEtLbktqWVBYMmtS?=
 =?utf-8?B?N3VrVVlYSUUzREIxVGZoZkh6Ym54dnJjcG5KSzNzWXZjYTZQMVU4NTF5QWZX?=
 =?utf-8?B?RzFlRGp5a1FkWTM3dDZjQ1QrMFJRb0FLMTJla29XNnAzdjNQQmFlT0JEMXNj?=
 =?utf-8?B?VForNFVEbkdUU1NnSnVxTy9nK080bWdyWGFWelFkSlhYdm5weGFDS3ZxU25Y?=
 =?utf-8?B?SDFBT1Q3ck8zT3Z2bEwveGlTOUZjMlFLUmpFejNSZkxpSkVIc0hrLzV2QnBK?=
 =?utf-8?B?RVV4bFJ5SldIbjNRSkVuS0g2YVhGT0hYUHBsWnd0SE1iaStuaXE2dzRwUDEy?=
 =?utf-8?B?enQ0dnZPVTdkdTRhWFpKTnNwODlCWGdlSGRoVmhMTmRrc0ZCaG96K1pyblBN?=
 =?utf-8?B?QUk4M0JSalMveCtabDdIU3FTY0dKNHBNOTBmckx5NzhyOWJLYkVER3E3N29a?=
 =?utf-8?B?SGlmNlJYZmpIY0JlMnJBcEt6NUxRaEExNmUxYk9HVG9kbjdwWWFUejZRcjBC?=
 =?utf-8?B?bSt0LzBVcWtxSEx0c2lUVkhOTnlsWTdBRDhDb2Q3NVlKWHhvYXJzcHV2eS9q?=
 =?utf-8?B?WFlrQUNrdWtsWWRqVDJsNnU2cjl6d0tQamdTUzVOYnVTMHlraUEzRzYxL2xu?=
 =?utf-8?B?eW1ydFZZUEM2V0hqTDNkUzdrZmtIVXVLNi9pamJqTit2SktZaWNaem82NHl0?=
 =?utf-8?B?TXVITnpxcFJMdjNieDhMektLc1JBSE82NWxGaFVOdktpTGZFMUV3SnByOTNp?=
 =?utf-8?B?NElnYi9RYVRvZUNObVRpZWx0d1NwbnJkd2hNNmFrT1pmekxFamluWmtSamJW?=
 =?utf-8?B?ZElWdnRRTGRFSzlJNVd1bmt1QU43T2E4a2dCaWM2MW5mN005VEhCcStwa1d2?=
 =?utf-8?B?WEJDUEFCVEdCbHRqclFuU29LdzRPcytrM2RiSG5YRStha3l1TmJJZ1FEekl0?=
 =?utf-8?B?QlNqZnQyNnpsdU1uMHl1NDFEMmRjZm53WVZlVG9sbnhNbUpobEFBaFBONzJz?=
 =?utf-8?B?UFhDSi9EMW82N1QvS05kMytpR3NIMDhCWmpzQjIraFBUSWdTa2oyYUl2OVBC?=
 =?utf-8?B?UVJUZjEzSmhzT2hOK3NLelgvYnhFTDRBbG9Vb2tTUCtTTXdSL2VjZWdRME9p?=
 =?utf-8?B?TUVaRlJTRXhMYlNQcTdiQ2hwTDBJbkUvNVY3M2psUUtJS2MwK1N4Nk5lb242?=
 =?utf-8?B?QzlxNjJsU00zTmlSVkM5Q0dYS0xWenVFQ0Y1UE1VdVBLZGd5T1c5cWMzWXVE?=
 =?utf-8?B?Q29aWkFoeHMvaDlnU3JkcFljWGVUZ3FFUG0vYnU3VFVrRnp3RG5iMStpTi9X?=
 =?utf-8?B?d0VmbVZUdzEyNlY0OWV0dFpaTmhDWWJ3Rk9jR2VBem9wVFp3SGdRV0RPR2x0?=
 =?utf-8?B?SVhJMTFSZmdTZ2VWVWxUQkQwcDZMTDRIdnpkUlVJL3FkUDdhT2hJNzVZbjlV?=
 =?utf-8?B?aEs4REtaTkVqR25tcVdLdm54Z0s1dDJVbHFIMndySDV6RU1ML0IwaUs0aEhB?=
 =?utf-8?B?YnlUOU0yNlVEN1JxbG1BeWJTOXRtQUV2c2FwM1k3TXQrWkVUbTZjcnBRaTRD?=
 =?utf-8?B?NHBVem9zMzVWeTF4aUdHRml0V3EvVjhBVmhxTnJYUEdiTjM3QzZvNzhVUm9S?=
 =?utf-8?B?cGJROEJmZXJBblRMMXAwQlo2NkR5TitnVFc2eG96bk1CSDRuQTc5UnYrOXI0?=
 =?utf-8?B?VFpTWmZEZjRpMW1QQWRRWWRaTGVhakNsZDBRVVFiNlRGV2VqWHo5cjlFTjUw?=
 =?utf-8?B?L1dwblVsYXloRVBlNjUyVmpVK2xsMk9EVmN4YXE5a0RMMk1GeUY4bEwxdUNN?=
 =?utf-8?B?OVVVR0lXTk4vUVE2d3FkOUtwVUpINWlreUYyOGpEMWU1SnQxRVNpc0lpckla?=
 =?utf-8?B?cmdEZk13Q2V4ZjBXTHZJbm1EbGdjd2lzdDBnVGlvQWV2ZVBXRGVhN1lmbml0?=
 =?utf-8?Q?EjKm2XLyx41eWO+JyvOzNrVVU?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B72F20308C56F44D8FDCB88825C86F46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d141c2c-c486-4fcc-acae-08de0bab93ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2025 05:27:47.9766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /km1IiVDjRpXhqID1n22zm41nrQd2Tbn0Up87dgx3DCtoSyu0gQWDde0JobqX9Oxpnwe+uvmpgnjOJURxKQaaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF92ECB6678
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTE1IGF0IDEwOjEzICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiAxMC8xNS8yMDI1IDM6MDcgQU0sIEh1YW5nLCBLYWkgd3JvdGU6DQo+ID4g
T24gVHVlLCAyMDI1LTEwLTE0IGF0IDE0OjI0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gT24gVHVlLCBPY3QgMTQsIDIwMjUsIEthaSBIdWFuZyB3cm90ZToNCj4gPiA+
ID4gT24gVHVlLCAyMDI1LTEwLTE0IGF0IDExOjM0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0K
PiA+ID4gPiA+ID4gwqAgDQo+ID4gPiA+ID4gPiArc3RhdGljIHZvaWQga3ZtX3ZjcHVfdXBkYXRl
X2NwdV9kaXJ0eV9sb2dnaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gPiA+ID4gPiA+ICt7
DQo+ID4gPiA+ID4gPiArCWlmIChXQVJOX09OX09OQ0UoIWVuYWJsZV9wbWwpKQ0KPiA+ID4gPiA+
ID4gKwkJcmV0dXJuOw0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE5pdDrCoCANCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBTaW5jZSBrdm1fbW11X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZygpIGNoZWNr
cyBrdm0tDQo+ID4gPiA+ID4gPiBhcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZSB0byBkZXRlcm1pbmUg
d2hldGhlciBQTUwgaXMgZW5hYmxlZCwgbWF5YmUgaXQncw0KPiA+ID4gPiA+IGJldHRlciB0byBj
aGVjayB2Y3B1LT5rdm0uYXJjaC5jcHVfZGlydHlfbG9nX3NpemUgaGVyZSB0b28gdG8gbWFrZSB0
aGVtDQo+ID4gPiA+ID4gY29uc2lzdGVudC4NCj4gPiA+ID4gDQo+ID4gPiA+IEFmdGVyIHNlY29u
ZCB0aG91Z2h0LCBJIHRoaW5rIHdlIHNob3VsZCBqdXN0IGNoYW5nZSB0byBjaGVja2luZyB0aGUg
dmNwdS0NCj4gPiA+ID4gPiBrdm0uYXJjaC5jcHVfZGlydHlfbG9nX3NpemUuDQo+ID4gPiANCj4g
PiA+ICsxDQo+ID4gPiANCj4gPiA+ID4gPiBBbnl3YXksIHRoZSBpbnRlbnRpb24gb2YgdGhpcyBw
YXRjaCBpcyBtb3ZpbmcgY29kZSBvdXQgb2YgVk1YIHRvIHg4Niwgc28NCj4gPiA+ID4gPiBpZiBu
ZWVkZWQsIHBlcmhhcHMgd2UgY2FuIGRvIHRoZSBjaGFuZ2UgaW4gYW5vdGhlciBwYXRjaC4NCj4g
DQo+IEkgd2lsbCBhZGQgdGhpcyBhcyBhIHByZS1wYXRjaCwgZG9lcyBpdCBuZWVkIGEgZml4ZXMg
dGFnID8NCg0KTm8gSSBkb24ndCB0aGluayB0aGVyZSdzIGFueSBidWcgaW4gdGhlIGV4aXN0aW5n
IHVwc3RyZWFtIGNvZGUsIHNpbmNlIGZvcg0KVk1YIGd1ZXN0cywgY2hlY2tpbmcgJ2VuYWJsZV9w
bWwnIGFuZCB0aGUgcGVyLVZNICdjcHVfZGlydHlfbG9nX3NpemUnIGlzDQpiYXNpY2FsbHkgdGhl
IHNhbWUgdGhpbmcuDQoNCkkgd29uJ3Qgc3RvcCB5b3UgZnJvbSBkb2luZyB0aGlzIGluIGEgc2Vw
YXJhdGUgcGF0Y2gsIGJ1dCBJIHRoaW5rIHdlIGNhbg0KanVzdCBjaGFuZ2UgdGhpcyBwYXRjaCB0
byBjaGVjayBjcHVfZGlydHlfbG9nX3NpemUgd2l0aCBzb21lIGp1c3RpZmljYXRpb24NCmluIGNo
YW5nZWxvZyAoZS5nLiwgYmVsb3csIGEgYml0IGxlbmd0aHkgYnV0IG5vdCBzdXJlIGhvdyB0byB0
cmltIGRvd24pOg0KDQogIE5vdGUgS1ZNIGNvbW1vbiBjb2RlIGhhcyBhIHBlci1WTSBrdm0tPmFy
Y2guY3B1X2RpcnR5X2xvZ19zaXplIHRvDQogIGluZGljYXRlIHdoZXRoZXIgUE1MIGlzIGVuYWJs
ZWQgb24gVk0gYmFzaXMuICBJdCdzIGZvciBzdXBwb3J0aW5nDQogIHJ1bm5pbmcgYm90aCBWTVgg
Z3Vlc3RzIGFuZCBURFggZ3Vlc3RzIHdpdGggYSBLVk0gZ2xvYmFsICdlbmFibGVfcG1sJw0KICBt
b2R1bGUgcGFyYW1ldGVyIC0tIFREWCBkb2Vzbid0ICh5ZXQpIHN1cHBvcnQgUE1MLCBhbmQgJ2Vu
YWJsZV9wbWwnIGlzDQogIHVzZWQgdG8gZW5hYmxlIFBNTCBmb3IgVk1YIGd1ZXN0cyB3aGlsZSBz
dXBwb3J0aW5nIFREWCBndWVzdHMuDQoNCiAgQ3VycmVudGx5IHZteF91cGRhdGVfY3B1X2RpcnR5
X2xvZ2dpbmcoKSBoYXMgYSBXQVJOKCkgdG8gY2hlY2sNCiAgJyFlbmFibGVfcG1sJyB0byBtYWtl
IHN1cmUgaXQgaXMgbm90IG1pc3Rha2VubHkgY2FsbGVkIHdoZW4gUE1MIGlzDQogIG5vdCBlbmFi
bGVkIGluIEtWTS4gIEl0J3MgY29ycmVjdCBmb3IgVk1YIGd1ZXN0cy4gIEhvd2V2ZXIgc3VjaCBj
aGVjaw0KICBpcyBub8KgbG9uZ2VyIGNvcnJlY3QgaW4geDg2IGNvbW1vbiBzaW5jZSBpdCBkb2Vz
bid0IGFwcGx5IHRvIFREWCBndWVzdHMuDQrCoA0KICBUaGVyZWZvcmUgY2hhbmdlIHRvIGNoZWNr
IHRoZSBwZXIgVk0gY3B1X2RpcnR5X2xvZ19zaXplIHdoaWxlIG1vdmluZw0KICB2bXhfdXBkYXRl
X2NwdV9kaXJ0eV9sb2dnaW5nKCkgdG8geDg2IGNvbW1vbi4gIEFuZCBpdCdzIGFsc28gbW9yZcKg
DQogIGNvbnNpc3RlbnQgd2l0aCBrdm1fbW11X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZygpLCB3
aGljaCBjaGVja3MgdGhlDQogIGNwdV9kaXJ0eV9sb2dfc2l6ZS4NCg0KT3IgcGVyaGFwcyBTZWFu
IGhhcyBzb21lIHByZWZlcmVuY2U/DQo=

