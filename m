Return-Path: <kvm+bounces-24674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B326295918A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:03:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D786282903
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAACAD272;
	Wed, 21 Aug 2024 00:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XTretAZK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364B6182;
	Wed, 21 Aug 2024 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198505; cv=fail; b=KPdNbul9nsDvRnAVxmr5neq0BWOc5CIglKO0w5J3kGiLIO3NXP2QcNzn1MoNcnklABqBrgFrwh0IU+4ESDbyn1UQYuDE5fxaZsSpr0JTxsug+dK9ewhFsjtGDo5hdKoaaJjNtF0LAjjvqEmL4/7MM0G2KhfFJYCI6GR2mF7GJmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198505; c=relaxed/simple;
	bh=mpY2BTkPpsrt/238Q64xj+Z/TY1t97yfCH40vcCEfiU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ei4oAEYKTsN9i6e6o+LVAQsArWDsMw6yllO9d1N/fKE9a4s+gAkiFnVjMZhvqz5dm77lGgUvYdmPqHSuEwxzU1viYgxXyGN7fMFb0iSR8CR6lI5CvfPqmMPQf2Vt2EtTczPxhuSIFzxHdp54+MTAAvTsztqOHgjyAxT0O0F38xI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XTretAZK; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724198503; x=1755734503;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mpY2BTkPpsrt/238Q64xj+Z/TY1t97yfCH40vcCEfiU=;
  b=XTretAZKfQIAOjU9s16NxtFZCijRGBw2vvM89Bgrim+EANhJs2Hyr4vf
   Xv4OrWBm6jJoy3b/72lKd5CrpxVQXYXr6ocgo27leWguTRi9v12wWDO6z
   yXhQEpd0UsMQkzL+7YzxsHX44m7H/A4WqeUec/vYu9JjlpAMvi94dejy6
   F8UrzUazoUzBaOOSYPlO3IGOctMlXnkM9nIaGmxqx3/1sTxBID1nO3XTX
   1v56TpYdJF/pNWT6f9a2/V939t6svhuEs552c+FdG/xq2ib3rffUkILSS
   X3XhoJ96F4YuXm4AvB3imECSj+7JlslCSxox6WA85lABi7ETRKZPqlgm0
   A==;
X-CSE-ConnectionGUID: 8GvxFcRoRJSHhjbNsCZ8PQ==
X-CSE-MsgGUID: tMY2k6BXSu6685piQZKgsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="47927960"
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="47927960"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 17:01:42 -0700
X-CSE-ConnectionGUID: Of8stxpzTlu2DcZyjRIlzQ==
X-CSE-MsgGUID: eNmE077iTbSDfS0cEmKunQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="65257316"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 17:01:42 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:01:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:01:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 17:01:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 17:01:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=irEiwxMTGyO2qDebuKq+MtuoPlbE5TBBMmEsN2X00IHRAKS19GBb9zwUXhpJwpfGdmZ+pZXExKs3pZlOXOqf9oVmt5rLaYiicEhX4ST6YcXATK2pqzlujK4Vabt7dvpnxOQRfGv/1m2qhW4o/3xGA5ni7ocf+J0KEJAIeEp/RrHLTi4AkWmvteVa6WjhxCfUCNMcKAEeRRRCmnGgMWAqzWOqU80wir1gpwA7rQN3Aj7HWtY3Xg/YFRMd+CmpSa1bGPfIgg8MFRgZ/kpbp5XAUDw4htlUNDcenhd2Av0sG+Ou5N4TXjRFPkDT8HI6DvDj7dkfpepMGkSOjMdZmkzKcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpY2BTkPpsrt/238Q64xj+Z/TY1t97yfCH40vcCEfiU=;
 b=YnkbdUl2PPnDLIhjIkwvsF6ZNqS4UECqYjuN44hiv+P7WzIst3+fQz3l/nW2zu3PM2b9dF6RMSwDLzFlH52o9RD6DieQ+8TYkaw5FAL31sCPKCFcbUj6jN8KYymiPsEgGM5jq6viOZ81Kh9dYy0suV8ptZqmrPn/IfB8KUtJIZkM6Qy+e+H83/77EK53b75OpyLvB+wiAS1w7olzoCEa+yIAT6lrmnm53HsB9Q1wGsczXVFR8j6+2tN3X9xJAFUDUhm2dXbUfka0AdvJ7y4H+KnNyZaPI2FOf4bjVOjNsD7JmZkI/iqMlDVS/jiDFXH5T5wZsnDdHv7ZBb8Jf1T1Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 00:01:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 00:01:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHa7QnMnUIGjafPIE6UNKd4SDTD+rIuwKaAgAIf3AA=
Date: Wed, 21 Aug 2024 00:01:39 +0000
Message-ID: <66718994df9082469a623bca3f24c8cadae41d3e.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
	 <822766d1-746a-4b15-b790-d1e331e4d9aa@suse.com>
In-Reply-To: <822766d1-746a-4b15-b790-d1e331e4d9aa@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4780:EE_
x-ms-office365-filtering-correlation-id: 9f776ae1-cf98-4fc1-7b6c-08dcc1746e98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R09DRjZtYk9GaXVobmJjMHZBWVFJT0RuanJpbE9EUHNuMzhDR01qTklDL00y?=
 =?utf-8?B?anRtcW1WVVRydVR2YXFCRXlIbVFUV0M5WFUrWERzK3doTm8xdWRqemd0NnVu?=
 =?utf-8?B?SG5YaERSU2plOG8yWWg5aUVuVmtQUlJ1RHV2aTlMQ1hOa2lrZ0dSeWpFazVY?=
 =?utf-8?B?YnZ0TGR0ZTVBZlg3cGZ2Rm9iZ1c4WVlJY3JUdEdNbWJwY1JsOE5hWk5IRUZ6?=
 =?utf-8?B?cXVTaldwVXdXSFUzbTdmWnlkRjQvUnVVNXZORVUrcm9MTU1QdWVWaXlHblBY?=
 =?utf-8?B?UEtDQlJNY2t5QjlYZVVJR3B5Wm9zQUJMRHhIcXJjL3BQeS9neDUrM2NXa1NK?=
 =?utf-8?B?MTBiazFXY2QwcTF4UXNVQldMU1czSzl4YVNxenJqRHhIbk85dU9Bb08wczVk?=
 =?utf-8?B?K2lkd0F0dEE5WUNMdWpQSmw1Z2JINlBkdWptR1Q2Ump0RW1mUnFsNUNHN252?=
 =?utf-8?B?d21XUUtYajNkN1FpZ0tld21kZk9WZ1ExVlZ5ZVZ4a2REakN0QnR0YlAzQXZK?=
 =?utf-8?B?MUxGQlFSKzIra01IS3VldFVvaXNDWGdrVTZlbGxQWGx2K0VuQ1J1ZVlzK2xl?=
 =?utf-8?B?ekdyR1BIOGFyUWdLYkFSLzkya3FlNVdZaDFNWDQwSE1JeWVxekZndkgzSk5m?=
 =?utf-8?B?OGI0YkJwV3BWcEdjblJNQXBYR1FWQlhYcVp0RHFHNlBPVncxN01kOUtqWENa?=
 =?utf-8?B?dUdwSEhhelVKLzduYW5FNUMyTHplbXB4azJBcVNPMmQyd00zUEdaeEd4TXZJ?=
 =?utf-8?B?dUJPbmhOUmxGTzN6a3dWbnBLbitVb2FYM1FYODNMMWpmVEhXUWNnR0tKYXhK?=
 =?utf-8?B?UU40b2F5bi9KYTUyQUZJQkFsUXFveDRySVQyeHpNUkQyQndFcjBSZU5PdERr?=
 =?utf-8?B?a1d1eEVwWWhQcUhtQWZCdWdZaVZMNGNHV1RJZ2c5bmhXVWRqYy9GcGttLzZ0?=
 =?utf-8?B?c0pjSnlmU0lLSmpmang3TTlINVVuV0FOQm0xY0s4U09VWHk4N005LzlVbnRK?=
 =?utf-8?B?aG85T0M2N0hqdXZ0aVdIblZMTVRCbzBTbDNUTTFiN3lqVmswQzNCdEJGTTho?=
 =?utf-8?B?dEhPekNZNVlRRmZhTUVHVWFnSTNFVDZYekFNWGxIWkFtWnNJSEJGRUJsVnFk?=
 =?utf-8?B?U01yUGpYQ0w4WjZsZWw1OUQrYUZ1YVk1ZFpLNzJTVVpJY1V3cmJ0ZjE5Qmts?=
 =?utf-8?B?UnhGWGJuSis3d3F3OTZrRHZENFp5RnFxVktwSGllYmFWVm9GTDk0QVJlN1Fo?=
 =?utf-8?B?dmRQZm9qOFlpb3E5THdkZ2VkeGhuUXlGTlhYSnNGQ2xJcUVtOWlZZFM2OW5Z?=
 =?utf-8?B?SU9WOXI2dFpaSURaQkRWdHNRZWZJSHdSZzZISXlkSEdjbUVicEtuUmFiMTRw?=
 =?utf-8?B?UnVrVmdYK2pWR1pwSEQ5eWtZN2l0eERXbVlIZjFPOTZYQnlvS3JIZG9DTGN5?=
 =?utf-8?B?ZWJWby9MNVVEUEEzS2RHbDc5YTBwR3ZrNVBHQ09zN1RlbnNEU0dqNHp6NmZv?=
 =?utf-8?B?cHBuZVhlTWZkSlhGTDluUXhiSk1zcGJvOU5oV1hIY2g4Wm5CY3RDNHR0ekRr?=
 =?utf-8?B?RXFSMkNlVnRISDZtQW9QS0s2OG9QWjIxTVgvN25pWkpIQWR6SUZIOVREZzBx?=
 =?utf-8?B?WHZVQlN6QkRYYmlVbTdiYzdXZCtTOEZkMm52b2FsQ1RiMlA4Vy9ZZjBzTXJ0?=
 =?utf-8?B?VWp3YXNFMmViRHppcHozSFpYemo5M0VOdS9OR3pSU1lBZVNYMDFuOEVQUHF6?=
 =?utf-8?B?bFRKUnB5czJtTXZaOGc4dmNYS0UvSnc1bDNORy9mQUZMQ1V2a3VsMWZPaVp1?=
 =?utf-8?B?YXEvSXdqbHZqYUhqMitQc1BuYktyY3U5Vy9RMEo3U1dyWkNXYmJPVzllQjlK?=
 =?utf-8?B?Q0I0OTZRbVhkbzJ0a3A5eE1sTi9udlhSbE1ua1VRRWxWd3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEhEY0hSTUxYMWcyaGM4dEp1Y0pDWGJGUWlCRFRhRldobHhCRXgvL2E3clRS?=
 =?utf-8?B?WVJGNzE0NmFFT0JON3NraTdEYU5rdUtJc2F2eW9RcTNJKy9QcVNUeXFwMjVz?=
 =?utf-8?B?TXNxa1ZXNzFpc0Z0Z2RuLzJ4NUJSSHh5Z1kwN01KK1hmRktrOTNaZHNlWFQw?=
 =?utf-8?B?UU9aYWF2Y3Frb0xtVmRyNFl3b1ZwMnhQa1NJeVIwVU50Q0VLaVErUTNZekFj?=
 =?utf-8?B?S3JUSm45RTFrekIwLy95VGhhanBVaUN6VW5KNXMyY3daRkluOGU1TE84UU9n?=
 =?utf-8?B?emQwZFFHNjBrRmhSQjFObHJuNTRaV290aFM3ck85QVFFdXIrWTQwODVUSWxQ?=
 =?utf-8?B?Q1l5YTFLZ0pmN3VOb05nVWdZSXBUQ0VySW94eXJDYmpoNmp6dy9MZ1g3RGEv?=
 =?utf-8?B?RzNHQjloOHI3NVUxUk9mMlJkL2FoVHdDQWZXenBaallUT0lmYUgzMXRkRnNQ?=
 =?utf-8?B?VVNYTXdaSnp5Y2o2S3dpMWxJMGgvZ2JSaWVENTBTdnJaZldZVDJOam1QY1da?=
 =?utf-8?B?dkM5Rlo3aWMxd1lMQ21JcldaLy9wYlRkaENYNFI2bEZMKy9WVUxlVll2MTk3?=
 =?utf-8?B?QjBHbWl1TnVTQmVXS1RQYWNZK1FhWC81RE9hTDEvR3dNNmRGWmxQTHF0Q1F1?=
 =?utf-8?B?UVBpcUJGQjB5V0ppZ0xtQ1NrRXVncU83Y1NzcUlTWGd3WmRqeUhJMzVMUnRt?=
 =?utf-8?B?aEJuOGljbVJ4ZE1WWis5UVNlVkh3cEQxZ044MGVzUEExKzBoR08zcDdtVi9N?=
 =?utf-8?B?anlSOUFXVWtjeEJxZGhZVmxEQTR4Um9zYjR3aW80L0gwdnhQZ2ZJVGF4Q0p1?=
 =?utf-8?B?K1B6U1duVi9WRVFWaWxQYjlEc3ZqTkw0b0Q5WEMwaUVOcVd4M2pZMjRaYmo4?=
 =?utf-8?B?T3dWS0pmNjlyNEZpSC9wR3RHVE5uTGgxL0MzZUE1RC83R0lQdVF6RnpjeUZX?=
 =?utf-8?B?K2NHNFYvTEo5V2dsbEM1NnJnWDcwMzRqM1lQYmVjT05VT0NDN1Q5NFYxSTNv?=
 =?utf-8?B?VU1iS2dWZjUwOUFqNXlySVc5a05FdlIyWVBCb3djVU9mZ09sYm1nYlI2RVJk?=
 =?utf-8?B?dWpoNWpyUmExc1FNMENhQUU3V0dleVVtOWpTakExZXF1S2RyUG5aYVZRYjJy?=
 =?utf-8?B?YUZkazk0WklNSGNWMi8yV05nR0VKcEd1czlHcWpZVzJ1TTBEYitJNlMyaitV?=
 =?utf-8?B?ZFhvbG85cWdNUThkSDdnNzFGYzlQNnRXVlpTTmlqcnZSaVhickM3RUhDS2J0?=
 =?utf-8?B?WTVSRVFudEY5WFljdzBTc1VFMFdBVm5JZWs2YW1XN3BZdlc4TVU3ZXA3d3ZT?=
 =?utf-8?B?QjY2S1VXMnRWWUxIYzF4NUNCN1hwOHp3TFdYRTlMV2JJQlJ0eUN0LzhHb3k2?=
 =?utf-8?B?aEd0ekdNRVBYdVE3TDQwTDVkMGY1Q2JBaGZkWlNFM2tham5vSWFEa0s5MFpt?=
 =?utf-8?B?WnZRTXl6RHF3M0dvbGw0ZzZCOTJxKzNIanJLRmNXdW5xY3JQZGxtQ1dvelJm?=
 =?utf-8?B?Q21jRnZzeDlQbktYemdqbjBrbWwvYit3clhaM3FSN2VQc0ZkeXVXYWs5MHRy?=
 =?utf-8?B?S2N1bEowMENqQU9NclBCTm9nT01FSENUQjlzZVhwUDNSVnNTRnFtNk44ZTNF?=
 =?utf-8?B?RUhUckw4bm56aGVLb09YMnV6V1M1VG0wQlU3WWQ4NGRqMldMdUNQOURMRHM2?=
 =?utf-8?B?bHRiNUQ1NnNPVW1DMFMzR1pCdEFXVTRhVWRxSEhVVTExQ1gwOFY2UnhzbEFq?=
 =?utf-8?B?bWlub0h5NWxtZXpPQ3BkYkdyWFl6NE84Vi9GSVczaW9Cc056RlBpN2g2d082?=
 =?utf-8?B?bDc3b2hvZ1hwaTVKQmRlZURvbVRlNElRVnlKVnBjMDBib3Z4MFJmaDNnM3NG?=
 =?utf-8?B?SW5lc1N4M2EySWt3Y3NwV1ZXY05QRWhKc3VJa1QrcmM5NklGM3RZRVdHcExm?=
 =?utf-8?B?cGtYSkN3MmxScXBFZlE3Nk9IMW1EM2lDUUFDa0ltaldqNndZcVpUZkRQbUJQ?=
 =?utf-8?B?TWRJRWNjWmkyS3l1Tlk5cWJYVk9HSjNYQ2R2MHdRWTBzc3UwdDNibVV4OXpz?=
 =?utf-8?B?aG96WHNYN1NFNTVFM21oWXcvdjYxTjdkeTZLYUcwK2U2dzlKNFdCc2U1TmlP?=
 =?utf-8?B?Y0lUbk8zUS9nYmkwbEpncjBxMUJLekx1VVhpbHJlUVR0am84NHZzZGNyeCtQ?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3846DA636BC4F4685582A03867D1A91@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f776ae1-cf98-4fc1-7b6c-08dcc1746e98
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 00:01:39.5037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qOd4hR5CsfxThkS3ungchY1smLppCG3cPpdBkhiW61JYC4ItBnXB6e8Dtna5j/pGaJwg+sl14tWCrZjsFQhRKONjbYvV0C3hG9HBeLeOabE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDE4OjM1ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gK8KgwqDCoMKgwqDCoMKgLyoNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBUaGlzIGZ1bmN0
aW9uIGluaXRpYWxpemVzIG9ubHkgS1ZNIHNvZnR3YXJlIGNvbnN0cnVjdC7CoCBJdA0KPiA+IGRv
ZXNuJ3QNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBpbml0aWFsaXplIFREWCBzdHVmZiwgZS5nLiBU
RENTLCBURFIsIFREQ1gsIEhLSUQgZXRjLg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIEl0IGlzIGhh
bmRsZWQgYnkgS1ZNX1REWF9JTklUX1ZNLCBfX3RkeF90ZF9pbml0KCkuDQo+ID4gK8KgwqDCoMKg
wqDCoMKgICovDQo+IA0KPiBJZiB5b3UgbmVlZCB0byBwdXQgYSBjb21tZW50IGxpa2UgdGhhdCBp
dCBtZWFucyB0aGUgZnVuY3Rpb24gaGFzIHRoZSANCj4gd3JvbmcgbmFtZS4NCg0KVGhpcyBjb21t
ZW50IGlzIHByZXR0eSB3ZWlyZC4gVGhlIG5hbWUgc2VlbXMgdG8gY29tZSBmcm9tIHRoZSBwYXR0
ZXJuIG9mIHRoZSB0ZHgNCnNwZWNpZmljIHg4Nl9vcHMgY2FsbGJhY2tzLiBBcyBpbjoNCg0KdmNw
dV9jcmVhdGUoKQ0KCXZ0X3ZjcHVfY3JlYXRlKCkNCgkJdm14X3ZjcHVfY3JlYXRlKCkNCgkJdGR4
X3ZjcHVfY3JlYXRlKCkNCg0KLi5tYXRjaGVzIHRvOg0KDQp2bV9pbml0KCkNCgl2dF92bV9pbml0
KCkNCgkJdGR4X3ZtX2luaXQoKQ0KCQl2bXhfdm1faW5pdCgpDQoNCk1heWJlIHdlIHNob3VsZCB0
cnkgdG8gY29tZSB1cCB3aXRoIHNvbWUgb3RoZXIgcHJlZml4IHRoYXQgbWFrZXMgaXQgY2xlYXJl
ciB0aGF0DQp0aGVzZSBhcmUgeDg2X29wcyBjYWxsYmFja3MuDQoNCj4gDQo+ID4gKw0KPiA+IMKg
wqDCoMKgwqDCoMKgwqAvKg0KPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiBURFggaGFzIGl0cyBvd24g
bGltaXQgb2YgdGhlIG51bWJlciBvZiB2Y3B1cyBpbiBhZGRpdGlvbiB0bw0KPiA+IMKgwqDCoMKg
wqDCoMKgwqAgKiBLVk1fTUFYX1ZDUFVTLg0KPiANCj4gPHNuaXA+DQo+IA0KPiA+ICsNCj4gPiAr
c3RhdGljIGludCBfX3RkeF90ZF9pbml0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHRkX3BhcmFt
cyAqdGRfcGFyYW1zLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHU2NCAqc2VhbWNhbGxfZXJyKQ0KPiANCj4gV2hhdCBjcml0ZXJpYSBkaWQgeW91
IHVzZSB0byBzcGxpdCBfX3RkeF90ZF9pbml0IGZyb20gdGR4X3RkX2luaXQ/IFNlZW1zIA0KPiBz
b21ld2hhciBhcmJpdHJhcnksIEkgdGhpbmsgaXQncyBiZXN0IGlmIHRoZSBURCBWTSBpbml0IGNv
ZGUgaXMgaW4gYSANCj4gc2luZ2xlIGZ1bmN0aW9uLCB5ZXQgaXQgd2lsbCBiZSByYXRoZXIgbGFy
Z2UgYnV0IHRoZSBjb2RlIHNob3VsZCBiZSANCj4gc2VsZi1leHBsYW5hdG9yeSBhbmQgZmFpcmx5
IGxpbmVhci4gQWRkaXRpb25hbGx5IEkgdGhpbmsgc29tZSBvZiB0aGUgDQo+IGNvZGUgY2FuIGJl
IGZhY3RvcmVkIG91dCBpbiBtb3JlIHNwZWNpZmljIGhlbHBlcnMgaS5lIHRoZSBrZXkgDQo+IHBy
b2dyYW1taW5nIGJpdHMgY2FuIGJlIGEgc2VwYXJhdGUgaGVscGVyLg0KDQpJdCBsb29rcyBsaWtl
IGl0IGhhcyBiZWVuIGxpa2UgdGhhdCBzaW5jZSAyMDIyLiBJIGNvdWxkbid0IGZpbmQgYW55IHJl
YXNvbmluZy4NCg0KSSBhZ3JlZSB0aGlzIGNvdWxkIGJlIG9yZ2FuaXplZCBiZXR0ZXIuDQo=

