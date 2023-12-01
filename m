Return-Path: <kvm+bounces-3037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF1C80007C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B5E3B211D7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 00:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5266017E1;
	Fri,  1 Dec 2023 00:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QX727bTB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F51720;
	Thu, 30 Nov 2023 16:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701391554; x=1732927554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=73L/5MpJgDADkf8EGzv+uHsARB1sIWvTa2gaWO1Ctok=;
  b=QX727bTB4ti+A/oZe5z8slrxkrLIbSpUG9sGUk8VJtfD9ByecuEWjyoQ
   gAFke1FerQRT7y3lx88eBl9yzmwH0R9uC6jHmISYtCWq78ECIhi6rIzbd
   6M+GABNLyUf7RDq6c2hFqChnWPkpjqm+3eUq3Pwyrtzm/iMho85zTFqBK
   2QzXZpDt/SeFEOEP7rjuO+hyBmyKlp/JAj5DZJl5HiDHRB4pDpJXZ/aCO
   ejqV+XYMkJsgCXHKgd2g4WJ4UymVPJj+CG+piAp0PgeLuS7VAl10zna0L
   2gBu+M3IYjSLFdIakuy5v61gA73wWL1BNP3WCwTxLF66Bj1wk0Zfkiz61
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="378447174"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="378447174"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 16:45:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="762933849"
X-IronPort-AV: E=Sophos;i="6.04,240,1695711600"; 
   d="scan'208";a="762933849"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 16:45:53 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 16:45:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 16:45:52 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 16:45:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 16:45:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JM06dRunMwTnpEcOpIfTbEZUpw+9oEnilleasndRAKO9ZqFKuN+fqe9mASny4OAI90/BZm4e5dIY+5oiPSG+c3WEfhW11xqtxPErDsHMq1C1YQ0fPXZmRI7eBe/lZi7qDUprfoRS1ZitTdOXFbAlycJ/WhNmG4ojTYz4oMQZLnv187UieTtItpFSBmyBvJ9GjkeHKalj+sKCByf6nTIU+/F20LGRFGsTtReHVTJ9vkIRe9emLh1Enqb8PhReicUaTASDfMeCehGFTPR0Hj2gbUX0T1GJ2IVfuJAjUmcCf4hHTRmi2yj+2rGys/OJrOFTVit1mrCdROujQPrANGtbHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73L/5MpJgDADkf8EGzv+uHsARB1sIWvTa2gaWO1Ctok=;
 b=F3dDwv+tQ55XfDBNLIH/pU+5FO9o4FZXG7aQzsj2dtgzvoD0uxsKo2Jw0hdnmtK8NQf3JKMufivF3y8Yq04tAetafMZuBYzL8VGNG/GCagmirkeL/zpQS9O/X/9PGEXhT4bR6dHX2RgMevBszxEBNxJY/3LQmVBYWygH9eSVF+wY67vjYx/9HSxjFlTPZJ6IrY3v3zPREGPR4sttlKdmeoqoW16sxeoVyMwP8OGRBJJHywPbGreZFXW6eXGn41pVHVlBLyuDiNYJySLR99D97/YVI8/QGiIdq3gw3hZagxjkAExNhXESPGepN7mY985FMppwkN42p33fwCYylsvjRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7755.namprd11.prod.outlook.com (2603:10b6:208:420::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23; Fri, 1 Dec
 2023 00:45:49 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6dc:cee5:b26b:7d93%4]) with mapi id 15.20.7046.023; Fri, 1 Dec 2023
 00:45:49 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>,
	"madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>
CC: "ssicleru@bitdefender.com" <ssicleru@bitdefender.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mic@digikod.net"
	<mic@digikod.net>, "marian.c.rotariu@gmail.com" <marian.c.rotariu@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tgopinath@microsoft.com" <tgopinath@microsoft.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"jgowans@amazon.com" <jgowans@amazon.com>, "ztarkhani@microsoft.com"
	<ztarkhani@microsoft.com>, "mdontu@bitdefender.com" <mdontu@bitdefender.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
	"seanjc@google.com" <seanjc@google.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "Andersen, John S" <john.s.andersen@intel.com>,
	"yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>,
	"nicu.citu@icloud.com" <nicu.citu@icloud.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "Graf, Alexander" <graf@amazon.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>,
	"dev@lists.cloudhypervisor.org" <dev@lists.cloudhypervisor.org>,
	"will@kernel.org" <will@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>, "yuanyu@google.com"
	<yuanyu@google.com>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "quic_tsoni@quicinc.com"
	<quic_tsoni@quicinc.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH v2 17/19] heki: x86: Update permissions counters
 during text patching
Thread-Topic: [RFC PATCH v2 17/19] heki: x86: Update permissions counters
 during text patching
Thread-Index: AQHaFdikZALJvW8dw0mqOzn84o3Of7B36I2AgBaO2oCAADfvgIADNQeAgAHPZQA=
Date: Fri, 1 Dec 2023 00:45:49 +0000
Message-ID: <4103d68b07bb382e434cdaf19ab1986f9079b0bb.camel@intel.com>
References: <20231113022326.24388-1-mic@digikod.net>
	 <20231113022326.24388-18-mic@digikod.net>
	 <20231113081929.GA16138@noisy.programming.kicks-ass.net>
	 <a52d8885-43cc-4a4e-bb47-9a800070779e@linux.microsoft.com>
	 <20231127200841.GZ3818@noisy.programming.kicks-ass.net>
	 <ea63ae4e-e8ea-4fbf-9383-499e14de2f5e@linux.microsoft.com>
In-Reply-To: <ea63ae4e-e8ea-4fbf-9383-499e14de2f5e@linux.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7755:EE_
x-ms-office365-filtering-correlation-id: 9265360b-1e06-4a76-c094-08dbf206dcd7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sJYoQmCZ9mUPmSzGFYkw9jYzjKYfGtykpnm4aO9u7dFdvv1Xibb8bQXOABMiUjRcZj0aMHik80/SCYPArurUciRsE/O9EdxFjYPr7DxUujqt/P7vrjc1Uh3TbZ8d6iefaU5sBa0PIs0Vk6YYrxltMgUMjnM6DJhfrUjuAPG22LEFiLgLMmJxihuBX7dXdPa1qL2NEvJ3/wvFU/L/SuaCeRLM3Y8GLIquJFfjqTBD+lrUogrc/A2n9n7YPPmKhJy4VtbG94r3YRJOIZM2UpCinom8zAdDP8jgQ4ImT76eVP76a7tz6Brzz6qhP+Bz/Hf/QqV3Snt0jG5keP4zJ13pr45mtQOn9as8BpP3tQxcz4EeazjptT5TQndpfctZk+E/rM20GYe6e4X7sXTo/JoSqvLSSsWMi0pOCLdhDcs4WEgqFP6qXftTpf60VSoczn796+UkKyvJ0zeDRF/Ymy1FbdwVjwEe79Nnc0jFhF0pu1UkxRVTB+WJo0i5XSmYyYWM5RVOjuHo3AFEToqIDRnaP36MAcJ0Rq012izzR7KvkjceDq3+uTYM766SWRsyIUyhRRnG32H1a/0SDQd+rj5+SO8qAXrvF0fYxX9UlC0dmf4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(136003)(366004)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(82960400001)(122000001)(38100700002)(83380400001)(4001150100001)(8676002)(110136005)(91956017)(2906002)(8936002)(86362001)(4326008)(5660300002)(7406005)(66946007)(66556008)(316002)(15650500001)(64756008)(54906003)(66476007)(6486002)(478600001)(966005)(71200400001)(76116006)(36756003)(6506007)(41300700001)(7416002)(66446008)(6512007)(38070700009)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlpZeDU0UUNDOTM3Z1NSU0hLVnNQWmozamtVQ29ZdCt5Z1JQUlNFU2krTzI2?=
 =?utf-8?B?czhKbk1OTGl6bzJRa3R1bmY3c3VNSnpZMjNVTkR0VE5lYktBb1ptVEV1R252?=
 =?utf-8?B?TE9Wa01qd1gxTHQzQW44aElDMHhFbytVSitja054WTNUcDBnMkRVZWYxTXBF?=
 =?utf-8?B?Y1M1aEJybDJvaG5hQk84L1ROTUFkaFdHczJ1Q2Ria3hXTkRiQkZVZ3Vkck5o?=
 =?utf-8?B?QjFkK1JRYkQzOWhiZDB0aTZnSDEraUFZSWhmY0Q4enlRayt3QjNqUkE2WVp2?=
 =?utf-8?B?eCtKQ1UyU1hqUG96d0lSL1Vma0ZkQ1ZWZUIxZlR2M1RtQWpFcGszYlNFRnNI?=
 =?utf-8?B?bzUrYXovak91Skl2MlROVm5MYlRKZmZRVmtDL3F3dUFkV29yOEdodnFMdkJw?=
 =?utf-8?B?N0kzbWdKbFhVeWRUbTB1Uzd2MGZhdjZzdmVreUtJZ2xJWUo1Qi9PVmFFa2NL?=
 =?utf-8?B?UmhaWG14NGM3MFlJWW9JTUgrQnRPc0Zzb1lkQVpRaHdUMnBwZHVUZHJUN292?=
 =?utf-8?B?bFlMcEJUTExqOFFObVlobTJPMW9Ca3BoMWNiYU9tN0dEd0VOWmZQbnd5aDBZ?=
 =?utf-8?B?bThDYjZSVGJyM29UTmJHcXBCc0M3R0ZDLzdkNG56YnZIdWZ2QjUrQjZFMXNq?=
 =?utf-8?B?dk0zR05hVk1rSG9LdEVQVXZPSk9Qb2R2OHB3ZC9KbUxEK0tBZlBOOVBwd3dP?=
 =?utf-8?B?NnlKMW1FeHkxUUF4QWZXbTZVQzlaRVROYkw4aXlQSTRNblNCQUtpZEtmOG1v?=
 =?utf-8?B?K1NpcTlQd25sdXovZThveVpjRUs3UkFFSDM0ampacjFkMllic2xGQVRaVVBU?=
 =?utf-8?B?OHFQc1hGbWtTQ1k5ZncwajFZaDJ2NVRrVXp2dnBxTnpGR3FESytqZUNMNElv?=
 =?utf-8?B?eW9jL08za1laOE5NVFBBS0tQVHZUd3Z4MUptdmpSRnRleEpVNU1qVE5lTUxx?=
 =?utf-8?B?S29HYjhDbDFMOUpBYUV3TTdPcVBuMWJBbE1vTi9VRWlwUnhUOC9LWDhMeUIr?=
 =?utf-8?B?UC8vbjFTQVRxUXRHYWZYaEppZXVDdko5cHJHVmlkb29vNEF6WlUxUUVXaEVG?=
 =?utf-8?B?SGxuYlVpV0lZTTZvUnYvL1kxYTZybGhxN0VGQVJaM05Wdnh1UU5tNW84SGk4?=
 =?utf-8?B?SjRmVWtaa2FHbitjb01zb1RkZFFiQ2l1clBoRmRwS3lpSmJLSmtReEZMSVRP?=
 =?utf-8?B?Q1hiOTEwSWxteVlDMlFDY3J6UWF3dTBPdURyQUg1N2NMa0lWWFFrMlhvbjlJ?=
 =?utf-8?B?ZnZ6ZG5lRkJqMXp5Y0N6YjJtazZsaVBSWkI1UkllN2ZjVE5oMnU5V3QyOWdw?=
 =?utf-8?B?dzNNTG5vMVVYVTZQSGdMZytkQkdLVGd3NEFUNkZtRGIrNDM2bjBZR0xzd3E5?=
 =?utf-8?B?Ym5iakIvSG5CWWpoMUNpQ1k4Tm1kdVJ2YXRiYlBjQUVNalg2MmlJTUc4bTlu?=
 =?utf-8?B?WGpSdGR2WmhjZUJnT3pPWnRaOENaZXJwNU1YaEs0Y2VJYUExRi80UWtTS28w?=
 =?utf-8?B?MGVlS085SWZSQTFnWTY4ZUszWkgyNE5UWkRlRjZ6QmJzZFU3WkZaSXNOUGdN?=
 =?utf-8?B?QitUMHJUeFQvaW1CWllVSFVhYnRSRTZsT0VmUFVPL1UwdjVheldIT2ZOU0Uw?=
 =?utf-8?B?c2YyU1VVVGVCeFVDVzg4VkcwWG9ES2owL3cwRk9QSk5xYXM5RTJ2Q0s5dzBn?=
 =?utf-8?B?dHltdDdxZ0lkc0RXV2VxMzlVWW0rZ1hUbHVEOUVVSm9mangrLytBeDJuOW5x?=
 =?utf-8?B?KzVRU0R1c2tlOG9jdkc1ZXFYRVV6ZTcxU3h6V1ZtQVo5SXQ3cy92NTdDdERG?=
 =?utf-8?B?WWVQaWcxUjYwVklxOUE1M0tVZzBXMXVONGZLOHJXWDRJOCtHSUViMjM1VEZv?=
 =?utf-8?B?MXRzZzlDcG5TWVY1Qk5qZ1QrV0tOeEFZL0svVVNxd3dUWGJBSXBsNzhRTUZH?=
 =?utf-8?B?RUdGWktsMm55bXdVTDdtRklVZk1wTzlNMG16YjV6L3U5UnA0QTVCUFlWVEt6?=
 =?utf-8?B?SlFaWFQwbkIxSFBVZFRXUUk5LzQ1Q3ZtZGxtbVQxY093dXBuNnBmQWdXb0hy?=
 =?utf-8?B?ek1zVCs0VWVyTEx1WkZsY21TT1BMRG5aTS80a1VPenhySzhiNC8rK0J2dVBx?=
 =?utf-8?B?K3I5djgrbFBJdm1lSHFYNVUvdVZNNGRBTHR4cHJIR3h6elM4aU41Z2hKcGli?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <76B637047A03374C8C5D77D8BAB3AE3A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9265360b-1e06-4a76-c094-08dbf206dcd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2023 00:45:49.1438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +eP2airK01gzQvEdRBBxf1yTqqROY91HXa9KYnvsYacLVHYQ7NfB67f3RlcgFmj7FNrvgKKZi+CQMASUHQzEdLP6nNrnsUQ5uVm1oZN4Crc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7755
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTExLTI5IGF0IDE1OjA3IC0wNjAwLCBNYWRoYXZhbiBULiBWZW5rYXRhcmFt
YW4gd3JvdGU6DQo+IFRocmVhdCBNb2RlbA0KPiAtLS0tLS0tLS0tLS0NCj4gDQo+IEluIHRoZSB0
aHJlYXQgbW9kZWwgaW4gSGVraSwgdGhlIGF0dGFja2VyIGlzIGEgdXNlciBzcGFjZSBhdHRhY2tl
cg0KPiB3aG8gZXhwbG9pdHMNCj4gYSBrZXJuZWwgdnVsbmVyYWJpbGl0eSB0byBnYWluIG1vcmUg
cHJpdmlsZWdlcyBvciBieXBhc3MgdGhlIGtlcm5lbCdzDQo+IGFjY2Vzcw0KPiBjb250cm9sIGFu
ZCBzZWxmLXByb3RlY3Rpb24gbWVjaGFuaXNtcy4gDQo+IA0KPiBJbiB0aGUgY29udGV4dCBvZiB0
aGUgZ3Vlc3QgcGFnZSB0YWJsZSwgb25lIG9mIHRoZSB0aGluZ3MgdGhhdCB0aGUNCj4gdGhyZWF0
IG1vZGVsIHRyYW5zbGF0ZXMNCj4gdG8gaXMgYSBoYWNrZXIgZ2FpbmluZyBhY2Nlc3MgdG8gYSBn
dWVzdCBwYWdlIHdpdGggUldYIHBlcm1pc3Npb25zLg0KPiBFLmcuLCBieSBhZGRpbmcgZXhlY3V0
ZQ0KPiBwZXJtaXNzaW9ucyB0byBhIHdyaXRhYmxlIHBhZ2Ugb3IgYnkgYWRkaW5nIHdyaXRlIHBl
cm1pc3Npb25zIHRvIGFuDQo+IGV4ZWN1dGFibGUgcGFnZS4NCj4gDQo+IFRvZGF5LCB0aGUgcGVy
bWlzc2lvbnMgZm9yIGEgZ3Vlc3QgcGFnZSBpbiB0aGUgZXh0ZW5kZWQgcGFnZSB0YWJsZQ0KPiBh
cmUgUldYIGJ5DQo+IGRlZmF1bHQuIFNvLCBpZiBhIGhhY2tlciBtYW5hZ2VzIHRvIGVzdGFibGlz
aCBSV1ggZm9yIGEgcGFnZSBpbiB0aGUNCj4gZ3Vlc3QgcGFnZQ0KPiB0YWJsZSwgdGhlbiB0aGF0
IGlzIGFsbCBoZSBuZWVkcyB0byBkbyBzb21lIGRhbWFnZS4NCg0KSSBoYWQgYSBmZXcgcmFuZG9t
IGNvbW1lbnRzIGZyb20gd2F0Y2hpbmcgdGhlIHBsdW1iZXJzIHRhbGsgb25saW5lOg0KDQpJcyB0
aGVyZSByZWFsbHkgYSBiaWcgZGlmZmVyZW5jZSBiZXR3ZWVuIGEgcGFnZSB0aGF0IGlzIFJXWCwg
YW5kIGEgUlcNCnBhZ2UgdGhhdCBpcyBhYm91dCB0byBiZWNvbWUgUlg/IEkgcmVhbGl6ZSB0aGF0
IHRoZXJlIGlzIGFuIGFkZGl0aW9uIG9mDQp0aW1pbmcsIGJ1dCB3aGVuIGV4ZWN1dGFibGUgY29k
ZSBpcyBnZXR0aW5nIGxvYWRlZCBpdCBjYW4gYmUgd3JpdHRlbiB0bw0KdGhlbiBhbmQgbGF0ZXIg
ZXhlY3V0ZWQuIEkgdGhpbmsgdGhhdCBnYXAgY291bGQgYmUgYWRkcmVzc2VkIGluIHR3bw0KZGlm
ZmVyZW50IHdheXMsIGJvdGggcHJldHR5IGRpZmZpY3VsdDoNCiAxLiBWZXJpZnlpbmcgdGhlIGxv
YWRlZCBjb2RlIGJlZm9yZSBpdCBnZXRzIG1hcmtlZMKgDQogICAgZXhlY3V0YWJsZS4gVGhpc8Kg
aXPCoGRpZmZpY3VsdCBiZWNhdXNlIHRoZSBrZXJuZWwgZG9lcyBsb3RzIG9mwqANCiAgICB0d2Vh
a3Mgb24gdGhlIGNvZGUgaXQgaXMgbG9hZGluZyAoYWx0ZXJuYXRpdmVzLCBldGMpLiBJdCBjYW4n
dMKgDQogICAganVzdMKgY2hlY2sgYSBzaWduYXR1cmUuDQogMi4gTG9hZGluZyB0aGUgY29kZSBp
biBhIHByb3RlY3RlZCBlbnZpcm9ubWVudC4gSW4gdGhpcyBtb2RlbCB0aGXCoA0KICAgIChmb3LC
oGV4YW1wbGUpIG1vZHVsZSBzaWduYXR1cmUgd291bGQgYmUgY2hlY2tlZCwgdGhlbiB0aGUgY29k
ZcKgDQogICAgd291bGQgYmUgbG9hZGVkIGluIHNvbWUgc29ydCBvZiBwcm90ZWN0ZWQgZW52aXJv
bm1lbnQuIFRoaXMgd2F5wqANCiAgICBpbnRlZ3JpdHkgb2YgdGhlIGxvYWRlZCBjb2RlIHdvdWxk
IGJlIGVuZm9yY2VkLiBCdXQgZXh0cmFjdGluZ8KgDQogICAgbW9kdWxlIGxvYWRpbmcgaW50byBh
IHNlcGFyYXRlIGRvbWFpbiB3b3VsZCBiZSBkaWZmaWN1bHQuwqANCiAgICBWYXJpb3VzIHNjYXR0
ZXJlZMKgZmVhdHVyZXMgYWxsIGhhdmUgdGhlaXIgaGFuZHMgaW4gdGhlIGxvYWRpbmcuDQoNClNl
Y29uZGx5LCBJIHdvbmRlciBpZiBhbm90aGVyIHdheSB0byBsb29rIGF0IHRoZSBtZW1vcnkgcGFy
dHMgb2YgSEVLSQ0KY291bGQgYmUgdGhhdCB0aGlzIGlzIGEgd2F5IHRvIHByb3RlY3QgY2VydGFp
biBwYWdlIHRhYmxlIGJpdHMgZnJvbQ0Kc3RheSB3cml0ZXMuIFRoZSBSV1ggYml0cyBpbiB0aGUg
RVBUIGFyZSBub3QgZGlyZWN0bHkgd3JpdGFibGUsIHNvIG1vcmUNCnN0ZXBzIGFyZSBuZWVkZWQg
dG8gY2hhbmdlIHRoaW5ncyB0aGFuIGp1c3QgYSBzdHJheSB3cml0ZSAoaW5zdGVhZCB0aGUNCmhl
bHBlcnMgaW52b2x2ZWQgaW4gdGhlIG9wZXJhdGlvbnMgbmVlZCB0byBiZSBjYWxsZWQpLiBJZiB0
aGF0IGlzIGENCmZhaXIgd2F5IG9mIGxvb2tpbmcgYXQgaXQsIHRoZW4gSSB3b25kZXIgaG93IEhF
S0kgY29tcGFyZXMgdG8gYQ0Kc29sdXRpb24gbGlrZSB0aGlzIHNlY3VyaXR5LXdpc2U6DQpodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjEwODMwMjM1OTI3LjY0NDMtMS1yaWNrLnAuZWRn
ZWNvbWJlQGludGVsLmNvbS8NCg0KRnVuY3Rpb25hbC13aXNlIGl0IGhhZCB0aGUgYmVuZWZpdCBv
ZiB3b3JraW5nIG9uIGJhcmUgbWV0YWwgYW5kDQpzdXBwb3J0aW5nIHRoZSBub3JtYWwga2VybmVs
IGZlYXR1cmVzLg0K

