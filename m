Return-Path: <kvm+bounces-72762-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOcdGEa/qGmXwwAAu9opvQ
	(envelope-from <kvm+bounces-72762-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:24:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06FAF208F6B
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:24:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7F222303A3E6
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3889C36A03E;
	Wed,  4 Mar 2026 23:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gvhyYoro"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A7036495D;
	Wed,  4 Mar 2026 23:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666687; cv=fail; b=Wgn6pixLo/TRPnGJb75Op/Pz1jkrT579DvTrfIMBBhH427lIKsvk7YF1S8/8W6McGLdFjLMv/pP5JfvItXMkaU7Bg9ZYZPlYRLBL49UT68F2gHmVi4pgMOg5scbzQRAlNwNPKXCHGnLFZvLW+d3Lcoo26u/Suv9m9aRk3yeJxvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666687; c=relaxed/simple;
	bh=ChREbKrI/njmGeSKkvBKZEayDOEtFqRXCSEsFlsuVAo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RUPsPsc+w2hBit99KmZIuMQl2af8/GnH2hB7OQKaaNhDxTZnQFdZ9CsFIdYx8JrnvOn42QO2pZaG1GeS8WNT9Ez2aTcw6iqyx4sQe1uALtKJEHrCvzHgd5h0fHkniOqJ0rQnzW66T+c5RxFsS/l3Fd/iVqnA8vYg9K5mOtwZHpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gvhyYoro; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772666687; x=1804202687;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ChREbKrI/njmGeSKkvBKZEayDOEtFqRXCSEsFlsuVAo=;
  b=gvhyYoroEsKlF2DhnZrNiTg550otwxaosvstUWPjqEzOE+amESLMLeIP
   8FulcMb7pr4XS5JDhQRPbg6KMuT5LjFbpS8/nJhLguv8LxWyMFQ7lTHcb
   e8tmU5yhC3tN/AYtYnPKRPxuL5PuhlotxsgN1dZaUtRLZeF4S5Vq2BgaA
   PZl8JvDARpbnKRAQjID9kkCgtsqK8Szo9N8gGxbc9CMhI2F7A9YlGJ7Nt
   J2ra6LPzJV+R7mGxh5z5ks2LjA9TaoRdmq84qE0XWOgjwpIut/adKwcRi
   ehIL88ogO2RAZwjBsDh72g4Ddh5c0TWYU70gKz6FXVRe40OZ0JwNAVAbb
   w==;
X-CSE-ConnectionGUID: L9GkckHVTB6VCsHb4Bz68A==
X-CSE-MsgGUID: FpuLqRuyT9ezxp7Pfh90gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="91133935"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="91133935"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:24:46 -0800
X-CSE-ConnectionGUID: /PJiOwQxTOSJGQmb6pGGcQ==
X-CSE-MsgGUID: LlIhQZt7TK6+TdcTAVgDxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="222988435"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:24:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:24:44 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:24:44 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.39) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:24:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gye6elHBzrOQKPwE6qLQQRWY1/MbQd+FKtaX1bUxc5Hnn0frGZeX8r3kiJzh3FZknsBRjT5FFDLqL1CrLu6AW2/F4L7oCXwWBRLs7P+WzKHQPJG20Yv/zs6E+/ANzMS7PHCWrN9CWJSIHeJi3DWi+msYPjS8LRRNcq9utHbbZT/LTn1jK/dxMLzdA7OdgURs1VAELzVGNPuWJS9O4k5vemhVYGCJjgnuTlUPjMxPWKvOXFRNktahsTf/bJ7orr7oUvxyM5o7znTs86Tp4tGihF8J8QtN02B2yJQUcLlszf9surNaRM8wHgcK4WyxVk/jlvHd9H8bikgaY/+NlavtHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChREbKrI/njmGeSKkvBKZEayDOEtFqRXCSEsFlsuVAo=;
 b=PeQBTzyMAEoC6hFaRrTODg1YvYXUTDKXXrAPFmyoVAtOqrwh381bRs7xccXHCnCZlmedJyuWm2phwVM1BOvfqzbwAg2Uc+DrufFK557cZgQtHRBjAu4LAMHDal4ymyUXKByMxok+kTCcxAXHMXNm7vJng1keWUWYb8hfRdXvFR4kTGb6cwqGoeLYcNyU3/3kWq2tNRapPBHnTwWgQ89Q7vwTAjL7Mxsdp3EvngxT9FocLp+5kLMDyiwaZVGfLem+xVypsI/exV5Zc0gLB1Ov8fa6qTg4EhqKxg/Xlh/FRsNfwooSShom6JjvQt8JOE1UaNMuEWbpPML9HyLFRuR8lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:24:41 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:24:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 18/24] x86/virt/tdx: Restore TDX Module state
Thread-Topic: [PATCH v4 18/24] x86/virt/tdx: Restore TDX Module state
Thread-Index: AQHcnCz/mzwYczUmk02wXbB0WkHrPLWfI7EA
Date: Wed, 4 Mar 2026 23:24:41 +0000
Message-ID: <77c3c5d7e20f431dcc48b540f4d3b12ea76b2547.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-19-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-19-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM6PR11MB4546:EE_
x-ms-office365-filtering-correlation-id: ce38cb1b-9e19-4ef2-c1f0-08de7a453676
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: GfCBKdERv/7i6OSmQ0WhQ/tv7bdlwk9zAAuSjUFi1y8hiH9vglkXj5tPVXurtpPRi9f7gPXOa4r5/mvqlVqvFGGrrPC54scU9sDj/qNJi4lArigXvLoJkdIBPWstWHck22Tr6KwtmtS7QAvKBZy8RPKccm5bs5yTOjVeVDj5KTwCqT+xpM1Am9d3uoavU+rHeTcwFcElnvS2h352vw3Kkn6TbAFKjpmRSdWCHTe5ubJq29Mvwi6ome8mHuyZnQkF8IwFQjpZnxWXHfXVfZ01itYmqmnyeGs2LmxVz7e/Db2sOrobFdRvFmPGirsOHbIHusTlZUn6Czljww5H4L4ahfmFPg4TcKzfS3gRQRONLU37LoKIhIjzVAugsiaaiU3sg/v95V7TsTAPR7mf7qqyC36mhigx0SwddhRFqZRVOXP7j/aEXzgnK0a3uUj3HwUKD1tSiR6jh5ydxB5FBlbLizCML9zA5M3sRLXytz8MRoE2n7+/C9o8C8pO9ptlaA0C9838iQeFOzuhjhgee7zAmFnB+XYd3I8eFx9yemZexNu4BY8281uACgUWkGPS7opEld++CxqFRX8DsTGiGR0NmEc19CkfR2dCKlw0oMI+62x5Nhxwu9Li/YVPLSs0vBYlEcr9tr0rNIo1vaLCcN81o9KyZPFBVqZ5t87y/vVY5KVTe4ADEdG9vllrxaaSl2USDinpo+DRxchA5INiGpVI+XZaK36qoolTJJSuR5HIaNCjYzPusq8gPIeffeLk4kLXapu2zi3aYN2H1OQal4vM3MjkaMpFBl4Ie7h/yKQhjWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmxKOUk1K0Z2dC85aXBjUW5ZYlYzS1M0dUZJTHZkU2tReXp4MEpsKzhGdHE3?=
 =?utf-8?B?c0QzWnFZaVdNWjhKbHNneGtaU2poM2lYa1cvM2hFbFlnS3hSSFpEQnk3TFZy?=
 =?utf-8?B?SWI1YXhzT0VTTTMzOGxyN2JldEN2NXdPK2w5RTZaekNra0dOWmlJb2tBaDNx?=
 =?utf-8?B?aDROYUludmNxT2N0cFFjN0E2RHdENUFHNXJMMGZ2Z3JDVXlHNGErczNMb3Rm?=
 =?utf-8?B?V0RXZVJVdEN2SDdWTk9DN1pXSlVzdnJOV2VjMCtOdlRHUEh1cUxwZFJDVUFN?=
 =?utf-8?B?NzdwTE5aTEkzamU2ZFYzQ0lWMHpWVnZjVDJmRS8zOUpvbFNYY1hUQjU0aW85?=
 =?utf-8?B?VUxIY0xaVGFNY0VYa0dySXVsR1hQRnNxcE1YL1pkbXNidGoxeWdpcGRGVjNw?=
 =?utf-8?B?MlNUNkVveFRzbktJTUdzR2RLWWo5eUZBTFhaaXZrSng2VDcvUmVQNUtpOE9R?=
 =?utf-8?B?YXNxNzJtRFZjMUpVbVMzR0xwM25JTDQxd2orTjNobnJvWEd1Znk0YXZpcnlM?=
 =?utf-8?B?R0VrUzJheUZuZ3ZybUpQSmhhNG4vSEdhdlpNaU9lMTFlV2hTSCtEL2RHRWNw?=
 =?utf-8?B?L0xZL1dqdWwvdUJ6L2U4SDJrdVpJWHROak9BbjJ6d0gyc2lMKzJOUVRMS0RL?=
 =?utf-8?B?dVJIb0ZoVDJwTkNYeGxnMGJoNHJsdVk1NkpNL0VNWDc1dkp3TzdPeFptQUpS?=
 =?utf-8?B?bEVKQUtvdVRGaGNMSXhHZEp4QXVHY052V3pmbEFTTXpobVJaekc1VWdCdVRk?=
 =?utf-8?B?QXNQZGRzL0pxZHdnWXRGMU5rbW9ibnhYTEhPQ1BZbkRMZ09QTjNqb3lQZkp0?=
 =?utf-8?B?Y3Nna1JEOGZtRThJMFdaSGVUdFovYzM5RkIzM2ZHSW5RMkkrckVSWkJjNDhn?=
 =?utf-8?B?SjZlRk1MbE1PZ0xWQ21KMEFhYktEbU05MEFjcHZqdkpNaE9ocTJyREhBNG03?=
 =?utf-8?B?NmhEV3ZiMWQwZUJDSnZ1RW9JSlByMDh6alJKbld0UmNLNlVuY1c3eWRIQzkr?=
 =?utf-8?B?R3R6ajVQUmR1enM1aW9zdDFSTlk2cUFXSVBhZ0R4eGFKdkk2UGZHSDUzOHBY?=
 =?utf-8?B?TUpUWDcvVi8wbmRUc0RyMHBjLzUvZjRteHRyUHBLQ2NjVEJ5MlY4dWg3YXpC?=
 =?utf-8?B?bDZ4Q2VNbllIS1U5dmtxbHJMSldxVmpCK0lTbFVXTEQrRGpUdEFINEVnRWp1?=
 =?utf-8?B?QjFmN2swL3VDSjBqWGFlVzhYbk45SVFGbTZjZm81WEl4SGVVdjBwOEkxeERR?=
 =?utf-8?B?YXc0KzUrbWNvOEZhSCtuTVAxZ2owZld6VldLZmMyWWNsTGN3R3NQM2d1N3I3?=
 =?utf-8?B?R0NRUHVRM1FYaUFtbUdVcmdLdlYxbUV1eUVMUmhCYW9UUGlJelBLbitUQzZx?=
 =?utf-8?B?N2ZKSm4xQ2NNYnBrYUlTekdLMk4yMGh1bnJuNHlRNXNScEl4Q3IyY3NVLzV2?=
 =?utf-8?B?RERoWENQQmp6bCtSNi8rVnhlNUlabFY3ZWl0RVdsQ1JvSHhSQ2VDdFc5VWtC?=
 =?utf-8?B?WjVDODQ3K2xVUHlCSG9kK0EzQ2liTkwzOE5qNzVTbVhlU0VhR21ucW5IUDJX?=
 =?utf-8?B?SnRvSDFlZTNTWVVHa3dQL1d6bm8xSHcrdXRndTBXdDBHN2hMRmhDWEpkajhN?=
 =?utf-8?B?Q3QvcE1VWnNXWU5Ycmt5T1hMVHpraEwzVUFHTXh3NDlsdk9yRUE0NjR5Nlcw?=
 =?utf-8?B?SWhoNld3K1lUTTZsRVJvVnh4V09DSUttYUFId1dzbnFQWEU2dEdIWWVqOXVx?=
 =?utf-8?B?UUZ4K211alBmWkJiNmVOUlRkYjNQWGtxLzl0aTduUmlxYmhTTVhjMmUveXpI?=
 =?utf-8?B?WE1JRGdUY1V2dGxrZGd6aEdLZ1dYOEhvcTFadENINTVCWE9zWWM2bGY5Z24y?=
 =?utf-8?B?SGF1UDdJN2E1bitFUVU4OE5xcUkvSFFvekZJcHhhOWRUL3RncVhSR0FOcUZU?=
 =?utf-8?B?TzBSSE02RE9Bcmg4NUUvUmowL0I1QUpuQjZYSnpqTFJSMVNsVnl6Nk5RUFRR?=
 =?utf-8?B?RU9zOFVSRzNXaU9OZkMxZjYwVU1HWFZtdjRSejRJYnNQS0F4L1lLTDRqODNZ?=
 =?utf-8?B?SWlhZVVHbFZCalIyT1NHbE93clUyTGd0TXBQc0Y2c2ZSK29rZUhRbHhqK2xS?=
 =?utf-8?B?RzdXMmczYnJwYnZuTlI0djAweVV6S0ZtR05idS9oZzlnZGJiL3F1WW9LazBo?=
 =?utf-8?B?MVB6eDVUeXNuS0hJQTlUZnZVUXJPTldJQ0p5WG5MVG9KWjJHaVI1VU83MVVH?=
 =?utf-8?B?ZUlWb2hlTUxiYWRGdEtYaFdqcXRRVVA0ZjBPaE1YZy9DZnBiN21xTmN2RTQv?=
 =?utf-8?B?aXZGU0czdkRWbjBxRGt4ME9pa0F0M1pHQjhjaE56VTAyUGpEY3dQZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E93994CF5829C41A6A5FB192FC747CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: BbyLeUrTA3EK+4HkgRQr1s3HkKM0K0/pNar6UknuY8BOlF6ZB+Is4MNCJB6xpteZi7G65XQoLWEbgERxR6IT/9D1LVBsb7bAk1J9H2mC1sJSNHgxav9BtZcD5pW4NKYLe4ZREx9nBZD8Vul5X0HWmgHqM418+03YE6HdTEK0UpTL+MEdQ5g/TbUxtClMRnSl7gQFn64yGrMuarF91jhBPj/tW8AyexC/Nu0d/nWNpPYSRzqMNT/+JpBy3RrSqIhoyW0j1lSQ+pTsufAKM4a8XDqWg8OUk7ZUnvTxjMdgljc/pMV0Rb5oQvKgbO9AoCLRgjGqTKQOZRIia6BfGB3GBw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce38cb1b-9e19-4ef2-c1f0-08de7a453676
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:24:41.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gStcZ1EvX4nyVwbJ2Oy4+CGNTpZX3AuBJFj7qlIvHeDdPjP05Dr1pxBiDOMpFnLu0/1AzbmKDXWCR+n8jlcJjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4546
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 06FAF208F6B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72762-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVERY
IE1vZHVsZSBzdGF0ZSB3YXMgcGFja2VkIGFzIGhhbmRvZmYgZGF0YSBkdXJpbmcgbW9kdWxlIHNo
dXRkb3duLiBBZnRlcg0KPiBwZXItQ1BVIGluaXRpYWxpemF0aW9uLCB0aGUgbmV3IG1vZHVsZSBj
YW4gcmVzdG9yZSBURFggTW9kdWxlIHN0YXRlIGZyb20NCj4gaGFuZG9mZiBkYXRhIHRvIHByZXNl
cnZlIHJ1bm5pbmcgVERzLg0KPiANCj4gT25jZSB0aGUgcmVzdG9yYXRpb24gaXMgZG9uZSwgdGhl
IFREWCBNb2R1bGUgdXBkYXRlIGlzIGNvbXBsZXRlLCB3aGljaA0KPiBtZWFucyB0aGUgbmV3IG1v
ZHVsZSBpcyByZWFkeSB0byBoYW5kbGUgcmVxdWVzdHMgZnJvbSB0aGUgaG9zdCBhbmQgZ3Vlc3Rz
Lg0KPiANCj4gSW1wbGVtZW50IHRoZSBuZXcgVERILlNZUy5VUERBVEUgU0VBTUNBTEwgdG8gcmVz
dG9yZSBURFggTW9kdWxlIHN0YXRlDQo+IGFuZCBpbnZva2UgaXQgZm9yIG9uZSBDUFUuDQoNCk5p
dDoNCg0KImZvciBvbmUgQ1BVIiAtPiAib24gb25lIENQVSBzaW5jZSBpdCBvbmx5IG5lZWRzIHRv
IGJlIGNhbGxlZCBvbmNlIi4NCg0KPiANCj4gTm90ZSB0aGF0IEludGVswq4gVHJ1c3QgRG9tYWlu
IEV4dGVuc2lvbnMgKEludGVswq4gVERYKSBNb2R1bGUgQmFzZQ0KPiBBcmNoaXRlY3R1cmUgU3Bl
Y2lmaWNhdGlvbiwgUmV2aXNpb24gMzQ4NTQ5LTAwNywgQ2hhcHRlciA0LjUuNSBzdGF0ZXM6DQo+
IA0KPiAgIElmIFRESC5TWVMuVVBEQVRFIHJldHVybnMgYW4gZXJyb3IsIHRoZW4gdGhlIGhvc3Qg
Vk1NIGNhbiBjb250aW51ZQ0KPiAgIHdpdGggdGhlIG5vbi11cGRhdGUgc2VxdWVuY2UgKFRESC5T
WVMuQ09ORklHLCAxNSBUREguU1lTLktFWS5DT05GSUcNCj4gICBldGMuKS4gSW4gdGhpcyBjYXNl
IGFsbCBleGlzdGluZyBURHMgYXJlIGxvc3QuIEFsdGVybmF0aXZlbHksIHRoZSBob3N0DQo+ICAg
Vk1NIGNhbiByZXF1ZXN0IHRoZSBQLVNFQU1MRFIgdG8gdXBkYXRlIHRvIGFub3RoZXIgVERYIE1v
ZHVsZS4gSWYgdGhhdA0KPiAgIHVwZGF0ZSBpcyBzdWNjZXNzZnVsLCBleGlzdGluZyBURHMgYXJl
IHByZXNlcnZlZA0KPiANCj4gVGhlIHR3byBhbHRlcm5hdGl2ZSBlcnJvciBoYW5kbGluZyBhcHBy
b2FjaGVzIGFyZSBub3QgaW1wbGVtZW50ZWQgZHVlIHRvDQo+IHRoZWlyIGNvbXBsZXhpdHkgYW5k
IHVuY2xlYXIgYmVuZWZpdHMuDQoNCk5pdDogdXNlIGltcGVyYXRpdmUgbW9kZToNCg0KRG9uJ3Qg
aW1wbGVtZW50IHRoZSB0d28gYWx0ZXJuYXRpdmUgLi4uIGR1ZSB0byAuLi4NCiANCj4gDQo+IEFs
c28gbm90ZSB0aGF0IHRoZSBsb2NhdGlvbiBhbmQgdGhlIGZvcm1hdCBvZiBoYW5kb2ZmIGRhdGEg
aXMgZGVmaW5lZCBieQ0KPiB0aGUgVERYIE1vZHVsZS4gVGhlIG5ldyBtb2R1bGUga25vd3Mgd2hl
cmUgdG8gZ2V0IGhhbmRvZmYgZGF0YSBhbmQgaG93DQo+IHRvIHBhcnNlIGl0LiBUaGUga2VybmVs
IGRvZXNuJ3QgbmVlZCB0byBwcm92aWRlIGl0cyBsb2NhdGlvbiwgZm9ybWF0IGV0Yy4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2Vk
LWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVsLmNvbT4NCg0KUmV2
aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

