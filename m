Return-Path: <kvm+bounces-21243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5A292C648
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:38:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 309CE2817F5
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 22:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1DE18784A;
	Tue,  9 Jul 2024 22:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NCvVKdZz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288247CF18;
	Tue,  9 Jul 2024 22:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720564699; cv=fail; b=FKM6WWbQYkPz3iKT/wPIPoELbUD6OCNWHpjN43Y0JHoaXjNsWQ9sGWHM2TwD2XhAEH8id4nWDq9QjVekDg5ng7MPR6vEisxvILvpsjR5wJ22YxqUZ5kPTEsh7M6pYIu/Ye8zdoOyHsfTyhmsO9mx9abBw8gxu2Fl1FOtQ90ryDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720564699; c=relaxed/simple;
	bh=X6gg7yLQEyMmmr1QkDau0LJ+y3Dquh3oJVK/r2hzpxQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TYDX1Ev+FdZCsiuwrm3Vsk1jy7xp1agLFwUlDX4OB0YoWy5/dZQ1LWCatZbAkqkEl62Uo1ewLo8B/XycOAYGoPAGEc9mGbDLlZpZG8vgDK+xETILVmC7fYbqFd7ligPUa+HNlFfQIngU7FXRZJtP+cgNxZRU3wxO1aYweI+nFcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NCvVKdZz; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720564697; x=1752100697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X6gg7yLQEyMmmr1QkDau0LJ+y3Dquh3oJVK/r2hzpxQ=;
  b=NCvVKdZzq/Kme78WPuAdPdMBdrRuDW97k9SWLOM/Pu1QYSVYs8kq8RV8
   g55aoctlstzFXRuYQSZJp2JYNiqIl9d69gBGw+GaB28bBntH5hHWHxYy+
   42QZDsz9JB2IkDRGzLhQMH9jVJ2FcYEjiydguVt/5RPjIoetmHNFneTb/
   hYrK0+BNc48N7zdispwO9r4mXXbI6qnjq543EJ36G7K7nPiyi4/LCjjAN
   w87Ng4A9Vasp9gnwIafMyG/H8DzrMI1+E00qt8zniKzGq75KvFGfxjpye
   PwPPxxQEBGzUjzN/zj1oKh0zl59fAZiX9kp8jcQb2s9jOL9AQxhjsXniq
   g==;
X-CSE-ConnectionGUID: Rb9pJ/dgRvCoPJcvLXE8Sg==
X-CSE-MsgGUID: wXV17+zrTDuhw/1inoQDMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="29252658"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="29252658"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 15:38:17 -0700
X-CSE-ConnectionGUID: 3+y9Ro5KTuC6TZsdD+4y3A==
X-CSE-MsgGUID: mvt2WE3uSTaD3bacdZiriA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="52294562"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 15:38:16 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 15:38:15 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 15:38:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 15:38:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMKeR8PJ7Lzsvuwbk8Toumdtz7ZX6UvsRo704cgd0XWwzh0dEBBMxfq7OAxF88Xo8mfx4CPngtlc2GFtL7ZzHc2/7oNZTCc+gSrYNhXGIkIrG9m1FuzqR61zJ9y3lw++qI/T0zEHoRUTwU2CAeefQzSftbiLr3OEnxZCaE/ZRMN2kuDJV7LkrgtzfXdg/zKVrlLBah2I23SOD4cESwGkfx2Hhptmy7si5YB9ZcdAz60tHlDi+NRpA0l/4jP75eCkw+gV1zbwvuhLBdtJ0Uy1Owy1stPFhmC84SXoIqv/qq69+bflE36oxbXoe/NbJedBQfMQY2F3T7E1ykoGeT8n7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6gg7yLQEyMmmr1QkDau0LJ+y3Dquh3oJVK/r2hzpxQ=;
 b=M2xOUnWj7K0aM1tS/lpxj69X4E52zaID1Ugi8WXFV9HdGrSgl7vqbXTFSN+bECMSTJYTOAVJWu8yXXmjh/M6GjYCYMnwxk/y3Zm++dSdUPZw0nrAbtw9dahKXdNixR6gv8o+gh23Wke75/n7e2qEe3vljUG7dJRLrp+CF9Pp/Y7ItZ9HrdEq9uR1h1jiFXI5juAwm17FD5h7Oho9vLPulOK0z+6SfWMttrHDSZp1x8BkUBRpyh4jYzyTzjEPpnON+7tIKTjAwqGbNjWyb3cJu/sKt/h5i0UaG1mOwexSFChecIzJz8zq62M2xSjyOsUyXzpuC6WqKBHpecDDKiL5rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7287.namprd11.prod.outlook.com (2603:10b6:8:13f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Tue, 9 Jul
 2024 22:38:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 22:38:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHawpkqUontib46sU2zk5qqIlBj6LHmWZoAgAjCjQA=
Date: Tue, 9 Jul 2024 22:38:11 +0000
Message-ID: <81b3bfa46a457ba19ce32e7a34b793867ebeebbe.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
	 <ZoZiopPQIkoZ0V4T@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZoZiopPQIkoZ0V4T@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7287:EE_
x-ms-office365-filtering-correlation-id: 13b720c5-ef96-4b54-ffe2-08dca067d022
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UjJrd2pWeDFrMncwQ2VnSWhlSGJMUGZ1M2R3dmhDUlZLM3pqOWFFenBaN2sw?=
 =?utf-8?B?ZkppT2RwU3BTVHJYQThpcGI4SE9USmdnakR2MW80Wk5pWE1KN1dnSSszRThF?=
 =?utf-8?B?ZWQvbTUrbWhBZTRkWlNWQWxPc01HU0lUeTlzdmRuaklCeWYyVFNCTVMrdExE?=
 =?utf-8?B?YnZmR1BYVWViSGUyWjdsZFZ3VXZHMDRqRW9IZzJCV0FnREJUeDM0c2JVemwz?=
 =?utf-8?B?anFjanRpZ3A0V3UvNWg5eUlMaXBNYnNaUHB1QmRaWTA4eElKbzdDQXZkRDA0?=
 =?utf-8?B?TXlSYTMxK3ZHV096SGFaZGdKZFdLbVFxbGlpV0dmZmQ5M21TcGxPNloyeHJE?=
 =?utf-8?B?Y0lHaHBFeVY1dWlwWDlPakt3S2REMFNOZ2JFeWhTT001dTY5VkVZaVFYbWlu?=
 =?utf-8?B?YjQrbXdjRS9FNWgzVEpJSDFsYmo0UkZlOU5OMUpSbFl1b01UMFA4N3dic0FI?=
 =?utf-8?B?ZVpZbnJreW1YMjVONjlKbTNXdXNWYmJMTVlmeHZESlNxVy9OT3FWZG9iSjNG?=
 =?utf-8?B?OUxsVkFaSWxpNEZXWlczbDBqZ1kveCtRRkppRTRFZDZTcDNtNU9YbzZpTCtp?=
 =?utf-8?B?R2huWkU4SlUxYUkvVkthQlVzdWZjS1BIUk03YzAzNjhRYlVxVklVOVF5SmRo?=
 =?utf-8?B?T3VlZlorNzRicUdNV3hxT09RaXhzN2lOUU1URWFRZitVZ2RjSHBFVHZRYjZ0?=
 =?utf-8?B?ekpnSFZlenUxelNZQytDVzhwL1N3SEpqdUFtSG9oYzhDTlE1VE5uWXNJU2x0?=
 =?utf-8?B?YWJGdDN5Y3VDS1pIWjFqVjhLOEh3Qk9NUTlSalNwS1c0UTVwaUdpUVQwM0JT?=
 =?utf-8?B?bUdVV2VvUmoyakJCSkwrQ0w3Wnh4cUxwRjJQTWVpSWJyeWIrWUxJSlRROWhY?=
 =?utf-8?B?dU1Bb2UyUzNudnZ4d1NpUTlFVWhHbEVsWm1UdTNvS09HU2N6US9vQUtZQW44?=
 =?utf-8?B?U1JQa1RmSEZETnVLQytmRUhBK21PWTdENHJScG90YTJOVThmWCtnOHE4NjBv?=
 =?utf-8?B?TlhHWHBObVVud1QyclVGakh0ZVlYQ1NnSDgrWUN2QllnTFB4QTZyNEllL3Er?=
 =?utf-8?B?UnQvb2poL2t2WHRMWVpQMDFHOG5jcnU5b3I1aWNQUHRPaDlwSHlrZU80Q25L?=
 =?utf-8?B?MHNzUEdvMWt5SXlGRnlyY3FqdVd3aE5MdEsya1hhQnNsQk9ORVAxa0J6NFZ5?=
 =?utf-8?B?K1BrVUFDbyt6WnhXUk9qVmtuVnZ1NnNpdUpneUhLcGRFUjhFRVRsdjJNRHly?=
 =?utf-8?B?Z1dTTzlNOEFEaGtjTEwrYzgzcHE1U1FZcy9YN1BjeGJWRkZVbERwa3F3UWNE?=
 =?utf-8?B?MmY4aEovb3Q0SjN0QndyaUJSODQ0MGNNR0V5TDZMcEVxV2ZuNU5GbFdXRGpw?=
 =?utf-8?B?WnVwbGJ1dzlzVUJnUE1MK2RNRnM1cFJLWTRqNHh5dGNaTGUxby9UNGlYQ3hH?=
 =?utf-8?B?WlhmK3ZKdm9KdG9OTkRxUG5lcUducnhzdklQeWJUU1gyU0pRNERncWVvT3M5?=
 =?utf-8?B?Y3lVbFZicVdjM01FcXZlSmpkUFRUekNYdkpuakxoWDZCeDBLMy9leWZCUUp6?=
 =?utf-8?B?bytRZm1FSjhMU2NITEZqN1poMWJGZUlLaEhxenV0amZ1Vk1zWDc0c21tdC8z?=
 =?utf-8?B?TXZwYTZFb2ZKZXF2RWRMZkl1QXAwb0lDUnlpWHdBRHlONHpUVWdoM05Jb3Nz?=
 =?utf-8?B?Tk1VaVBPWG5vZS9HdmVaVHhwZDcxU1FReHVPUnRkblBQVUpob2lvSzkyckI3?=
 =?utf-8?B?YmNWWDk0VkZSQnVUVWhuTk4vSTVCQ3BGMWh1QzZBbU0waXF2MmtKTW9vSGlT?=
 =?utf-8?B?dTBsNEg4K2lLMUZiZkVoWmxTOFRWWnlwU2pvdmQzc1VjQmpZcytpYjJoV0xN?=
 =?utf-8?B?R1lvUStUdXpRK0R1MDBFSmVVN05lRWl5R24wWjNqM3Q3d1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjZDeXBzWFREVUY2MGZHWXdvWGtUSTZpQy9Ia1VJOGE2dVJ0dUJZWDh1QUFl?=
 =?utf-8?B?UWdWWDc0TWNLZWRnSUsxckM0aGVyQ3JxL0RMVVpKNlNOY25sVkV2RHl0aEJH?=
 =?utf-8?B?ZnNCdloxRjhyc0d5NzN0RGpMQ0ljZmxBMmNYQmVxYU1Nb3FaOWo4MVZUQ3hQ?=
 =?utf-8?B?K2x6ZVZYU3ZPNHVVSWJ4dTRULzd4OWQ1dEtWSVZCRDJsOENjZi8vc0Q1NkJz?=
 =?utf-8?B?QTE5VTFVTHJNZjJsUy9NZ2huRm5sTFQwQk1neE9NaTg1b21PckY1ZXRvemtB?=
 =?utf-8?B?SU9Nd3V4eFVnRzNNT3JVdEE1azczejBNZTQ1V1Ava2o4dkdHeFp1MVg4RVRO?=
 =?utf-8?B?dVkrWkZjd2FFTjh6Z3V0Nk9qMmRvTHI1S2xVRzNHczM5Ni9ZUThWR0hRSjV0?=
 =?utf-8?B?V0xyR2t2NHV0OGRUWGdwdnVwS3BzaDYrcEdmU2xCV2xRZitodUZxcWVKbEpi?=
 =?utf-8?B?ZHBuMG4vTzRZdG92UU9ydUFBRXdHRHN1ZTYwOVRnQjk2YVNsdjl4YS9wbENW?=
 =?utf-8?B?YStwWGlQc0pmL0VlWXFoSG9CeDBMZk5RUGdrRW9kT3BHWUgrRmR4QXJYZFZo?=
 =?utf-8?B?QmxLQ0EvVDN4NUlxVVBVblNtWnpJVjV4c0hCbHBlNHJ1aTR0a3IvRlQzN0tM?=
 =?utf-8?B?YW1NMkJIL3Q0RUJFc3c1YWtDNDJHZysxZUJ1a21acE1iUFhhNjFIMThoanR0?=
 =?utf-8?B?clBYdzlkUTRSUTQzU2lUZkxYaXIyVUVsQW5FSzZhNWQvZmcvQ29NWkw1NEFq?=
 =?utf-8?B?UTlzbERZdVlvV1lkY1J5VE5KRWhpMG1WNjVGWVRqNkhMc0czY0dlclBoWmdu?=
 =?utf-8?B?alpZTlo2UE91d0pHTGFEZnJmUlJJTWY1K1BoMHl0dUVhdXIwdzJFVXF0QTZ5?=
 =?utf-8?B?S3F0OFdNalpjUzE2YmFWeC9wU1UzOXdWbmpIQWRQL0U4RDRDT0pQc0hmWWNx?=
 =?utf-8?B?aHpUTUtDY1c0MkRTSEc5VVhwY0dkN3Noc0hoU3VQSEpibk5NS1BoR2N6a3VW?=
 =?utf-8?B?OCs2WG5zQmVZclYzTVNxeGJ6RjJQaGJ3UUoyYkJkMVBSemp4cWlsTHU5WTVq?=
 =?utf-8?B?eUxKVENnYWw3czh1cXRyU091SndUTGViMkd2QXJITytBbUxGd3VuaGRkTStw?=
 =?utf-8?B?U2NZV1JFNHhnMUNBRVBlSjIwUkl6MUxBcHllY3p3cCtoQStkaVdEOHlFWXZV?=
 =?utf-8?B?NDJFVHY1VmhFQmJ4ZUM5cUIrMEdKc1V3dzNWYkY5M3YvNGhaM2xaTW5FVHhm?=
 =?utf-8?B?b1hFczNuNGNDU2VUcWN5cGVFTXZOdkpHY3pGWi81MURuL3hMcG0zTFRCWWVm?=
 =?utf-8?B?anZBeDF5b3BZVEpsMzdNdWRwWHFmMmE4eElYYlVXN1ZRVmpLbisyMHlHUmFS?=
 =?utf-8?B?UEU4ajh4N1d0K05TRERmRjQzaGErT2xtSElFc2dQZkNCNkhLWDdJQUplbTBR?=
 =?utf-8?B?NVpiT3lRZi91K0MzNUFJaVBxaFpMTTFUczl1NmZCSHMwSnlSbW50SFMyRDRs?=
 =?utf-8?B?VWV0ZnM5L1o1cjBMSHF2cUZ0NEMyNlFFSERMcTI0MzZ0Y3JlVURWbUFGN3Rr?=
 =?utf-8?B?Z1V1R2VXR2ZnWHFOU2lYcnh4WkhzMU9hZFUxR3JBRjZxZkF4ZGNQdVBMSXUr?=
 =?utf-8?B?NDdpTFQ5eFBkczBVbDR3MHdSNG5wSmgyUjViUk1MODIrK0tOQllvS3ZMWWN2?=
 =?utf-8?B?SUhVSGtvMEt4TWNOZndicHpsTHluQkVIZnJLOFA5SE92OEhDYWZiN1ZoMXlT?=
 =?utf-8?B?WWZEN01UZENVZWJ3WTF0S29GRVZ5aUNuWEN5T1VhLzhnbkhSUXorNXN0S1dz?=
 =?utf-8?B?KzVxSWV3U2VrRFpYUEFLaEFWdjdpVDh4bkZqbWJMNmhYRk41QTNMYjhOYzBL?=
 =?utf-8?B?MjJ5bEpyK2hucUFxVkhFd1R0ZXhvVk50Z2RpM0Y4dlB3ZG5uQnFyWjNObytY?=
 =?utf-8?B?dnF6bncvcHl4RTVhZzNoTVNzU2U4bWJQaXhNMDlsT2RJWGVwYnpDVXRDUk9I?=
 =?utf-8?B?MlBxTkpRaTczTjNRMUlWYUIzWWUyNk92cndJTEdlRnZSbFIrWXZmRWx3ak54?=
 =?utf-8?B?WTdZNzQvMFppTlRVM3gzNEtHRFl6SDhMT2tsN0F6bFNiNmFndVliM0cxSWhL?=
 =?utf-8?B?bUlnWHdQanlrTEhOOFRJVzc5Q1pSdXBhTjQ3ZFFudUl5Yi9lZnlMNHhlUFhV?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8364E09E0B76194FAA1F002B081378BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b720c5-ef96-4b54-ffe2-08dca067d022
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 22:38:11.3553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: apLlUPiTah8FQVl1lrpc/kpqo5B4SgHUgC42WAtbnYrQhbL4HTv6H4VdcKlkrrDky3QAqI8azlwcZlsZ9+mzLb9BIJn8GPbpbBOPysk5FKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7287
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTA0IGF0IDE2OjUxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBKdW4gMTksIDIwMjQgYXQgMDM6MzY6MTBQTSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3Jv
dGU6DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5oIGIvYXJjaC94
ODYva3ZtL21tdS90ZHBfbW11LmgNCj4gPiBpbmRleCBiODg3YzIyNWZmMjQuLjI5MDNmMDNhMzRi
ZSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuaA0KPiA+ICsrKyBi
L2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5oDQo+ID4gQEAgLTEwLDcgKzEwLDcgQEANCj4gPiDC
oCB2b2lkIGt2bV9tbXVfaW5pdF90ZHBfbW11KHN0cnVjdCBrdm0gKmt2bSk7DQo+ID4gwqAgdm9p
ZCBrdm1fbW11X3VuaW5pdF90ZHBfbW11KHN0cnVjdCBrdm0gKmt2bSk7DQo+ID4gwqAgDQo+ID4g
LXZvaWQga3ZtX3RkcF9tbXVfYWxsb2Nfcm9vdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+
ICt2b2lkIGt2bV90ZHBfbW11X2FsbG9jX3Jvb3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBib29s
IHByaXZhdGUpOw0KPiA+IMKgIA0KPiA+IMKgIF9fbXVzdF9jaGVjayBzdGF0aWMgaW5saW5lIGJv
b2wga3ZtX3RkcF9tbXVfZ2V0X3Jvb3Qoc3RydWN0IGt2bV9tbXVfcGFnZQ0KPiA+ICpyb290KQ0K
PiBUaGlzIGZ1bmN0aW9uIG5hbWUgaXMgdmVyeSBzaW1pbGFyIHRvIGJlbG93IHRkcF9tbXVfZ2V0
X3Jvb3QoKS4NCg0KVGhhdCBpcyB0cnVlLg0KDQo+IA0KPiA+ICtzdGF0aWMgaW5saW5lIHN0cnVj
dCBrdm1fbW11X3BhZ2UgKnRkcF9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KHN0cnVjdA0KPiA+IGt2
bV92Y3B1ICp2Y3B1LA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0DQo+ID4ga3ZtX3BhZ2VfZmF1bHQgKmZh
dWx0KQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKHVubGlrZWx5KCFrdm1faXNfYWRk
cl9kaXJlY3QodmNwdS0+a3ZtLCBmYXVsdC0+YWRkcikpKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gcm9vdF90b19zcCh2Y3B1LT5hcmNoLm1tdS0+bWlycm9yX3Jv
b3RfaHBhKTsNCj4gPiArDQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHJvb3RfdG9fc3AodmNw
dS0+YXJjaC5tbXUtPnJvb3QuaHBhKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGlu
ZSBzdHJ1Y3Qga3ZtX21tdV9wYWdlICp0ZHBfbW11X2dldF9yb290KHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBl
bnVtDQo+ID4ga3ZtX3RkcF9tbXVfcm9vdF90eXBlcyB0eXBlKQ0KPiA+ICt7DQo+ID4gK8KgwqDC
oMKgwqDCoMKgaWYgKHVubGlrZWx5KHR5cGUgPT0gS1ZNX01JUlJPUl9ST09UUykpDQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByb290X3RvX3NwKHZjcHUtPmFyY2gu
bW11LT5taXJyb3Jfcm9vdF9ocGEpOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqByZXR1cm4g
cm9vdF90b19zcCh2Y3B1LT5hcmNoLm1tdS0+cm9vdC5ocGEpOw0KPiA+ICt9DQo+IE5vIG5lZWQg
dG8gcHV0IHRoZSB0d28gZnVuY3Rpb25zIGluIHRkcF9tbXUuaCBhcyB0aGV5IGFyZSBub3QgY2Fs
bGVkIGluIG1tdS5jLg0KDQpJIHRoaW5rIGl0IGlzIG5pY2UgdG8gaGF2ZSB0aGUgcm9vdC9lbnVt
IGxvZ2ljIGFib3ZlIGNsb3NlIHRvZ2V0aGVyLg0KDQo+IA0KPiBDb3VsZCB3ZSBtb3ZlIHRoZW0g
dG8gdGRwX21tdS5jIGFuZCByZW5hbWUgdGhlbSB0byBzb21ldGhpbmcgbGlrZQ0KPiB0ZHBfbW11
X3R5cGVfdG9fcm9vdCgpIGFuZCB0ZHBfbW11X2ZhdWx0X3RvX3Jvb3QoKSA/DQoNCnRkcF9tbXVf
Z2V0X3Jvb3RfZm9yX2ZhdWx0KCkgd2FzIHByb3Bvc2VkIGJ5IFBhb2xvLCBhbmQgdGRwX21tdV9n
ZXRfcm9vdCgpIHdhcw0KZGlzY3Vzc2VkIHdpdGhvdXQgY29tbWVudC4gTm90IHRvIHNheSB0aGVy
ZSBpcyBhbnl0aGluZyB3cm9uZyB3aXRoIHRoZSBuYW1lcw0KcHJvcG9zZWQsIGJ1dCBJIHRoaW5r
IHRoaXMgaXMgd2FkaW5nIGludG8gYmlrZXNoZWRkaW5nIHRlcnJpdG9yeSBhdCB0aGlzIHN0YWdl
Lg0KDQo=

