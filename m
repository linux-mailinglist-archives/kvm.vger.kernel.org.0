Return-Path: <kvm+bounces-26160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFD5972489
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E18C41C2323A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009A618C909;
	Mon,  9 Sep 2024 21:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYFqIodg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B406F18B468;
	Mon,  9 Sep 2024 21:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725917384; cv=fail; b=V11Mh0XIItmcwmWE28obMq4WRp1v3o0iIZ8ANECSpbEfx9LUvU3cJeO4aFobd6up4VjZ79HettlO4Mar3picYjQLvLGQtQ8ENj4Oi25GYyRx2ecES3AwmDILPs/sPwpWK6uiwS+QWzk6YEz4TQatTCebPWbU2IWouDkOD32JdX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725917384; c=relaxed/simple;
	bh=IjPfdGvoJuAjohfa8vYiqEknotDABGF3emq0yIsq8+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ifnf/9LJ1gs5iy9ve06GlQIdiA1AabwMnKvQGdpxD2fuctRSfINXM4XwtAdnAXDg5DGQ/wMbfEhTIVONUtDMY5dufT9cCWw6N16qkTX5MAJCqBCH7cUVStkSSPQxTnBqHUVfMjrE+PkUGgPGm7wY6UXYVIUrOEe+gGZrYNjEJMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYFqIodg; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725917382; x=1757453382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IjPfdGvoJuAjohfa8vYiqEknotDABGF3emq0yIsq8+0=;
  b=CYFqIodgQDOjz1ggFdnHmISTCCuGcs2ChY3VLxAm5XG42RXYXRIp0XVU
   frz/TBLn+7+HhNxp/zM70ns2zx4FCTSLMsYCfrvvgobfdFvzt1idgJJIv
   QnnTZVr20Jtnr4gBsl2/RWU8Nwo5rVJWxhGcUHZ8lZ53MqWG10zfhIQsS
   utnjXFlI3qLIySFSSbVeof8AIzJAjG4vr/NVDNsS+2r0EJFc84CYgK3zK
   /0sRvIukQnLku3FuyuYnCwhQ/jRXhQhxDhLX5Rv3ypbKyj8qssBftjdej
   joEpIi+q8Q2f7ZtjDbYBZWtPzIm1tgze5y0585CO6qVHnYwzhDmxiQrpa
   w==;
X-CSE-ConnectionGUID: MUDY+dwtQjaOYXbaOKcKeg==
X-CSE-MsgGUID: JXkfsYEjTpSBz7MDkFJ7vQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="50048868"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="50048868"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 14:29:41 -0700
X-CSE-ConnectionGUID: j/xavG8TQZKtiaU1qTtvAg==
X-CSE-MsgGUID: Km6BxjaeRCeL27YzMicy1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="66848139"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 14:29:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 14:29:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 14:29:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 14:29:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 14:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKAzlAyfx/I+ee3d8Sf8eKYjTOtNp6kWSgzcpmdSe5XM3P33W0/QFrtSOja4xL7SedO55heagno+UL2LySVXb0N1gnktcfWUSKOXfSqMbrA/pM8k9jIUJx/uuU4km5K1iFyQGGg/MwQNekK4x6luLJDZr4yzwVSFqUkTjd3fuo6RehMMfM+7XaSd0JG+T5qh0PXSnrYqcg7sUQBW3i+NG6Aa3MqmzcY88b9AQVMEHJngNsW5J7EadO6dAxshZR1gpgTh5mHwp+blLBwd6Kk/essEjMQhg3IbXeG/1JoUMDqtwM4QDuRU7SxViYKcMQD2VP+NZvrfU0dO/LfngLCFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjPfdGvoJuAjohfa8vYiqEknotDABGF3emq0yIsq8+0=;
 b=FKSuPf33Fy3McZvl/tQ8IHoYdh1LoYSI/+vW6yFx/7zWRDLO4+8ItxPux212zZZuDV1WN7x2egBRbndWUiHSEk9YRAQiSg/DcaxRj1IsTSHrBUvFG0xw66H6EcvyDPkCljUuFGTt7Cg8dVYII/fL4KMsTwCYBU0jphUumCkBXUGU64w+axLIVeKcFLsP5YqDktS+DAtre107GjHaXJGIH66n6l3vZC5JfJSoftmGv93Pb8MUmxboCZWsfDLOyXh/SwCBriyHIlr7A0XPJRV7Y3YOZy//3zO5vFk74APj5/gooGIBWJ+tWxWfn6WNpc+OeThHAijynac32ECogiA7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7708.namprd11.prod.outlook.com (2603:10b6:806:352::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Mon, 9 Sep
 2024 21:29:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 21:29:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/21] KVM: TDX: Add accessors VMX VMCS helpers
Thread-Topic: [PATCH 06/21] KVM: TDX: Add accessors VMX VMCS helpers
Thread-Index: AQHa/ne4Svy9pA372ESPV2tLnMTITLJPiYuAgAB4QYA=
Date: Mon, 9 Sep 2024 21:29:36 +0000
Message-ID: <38b2a97bd60e55505bd77e92a9257d5504c22b8b.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-7-rick.p.edgecombe@intel.com>
	 <bd423b07-3cb4-434f-b245-381cd0ba4e58@redhat.com>
In-Reply-To: <bd423b07-3cb4-434f-b245-381cd0ba4e58@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7708:EE_
x-ms-office365-filtering-correlation-id: 7fb7ba81-9004-4240-d500-08dcd11680da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?U1NyUDlId1UvQlNoUE5HWHZCZWFDaFR6UGhWMDRlK0wrd04vWXczKzQ4WGhn?=
 =?utf-8?B?UkI1cG9SNlB5d0w0bGV5VUVIVWE3c0dvQjlPc2FqZGF6dW14aFFOekZhd1Rw?=
 =?utf-8?B?U3RwUHp3QXhza0lhSDFaOVBJVk5ra3BRcVUxZGt0SzJmM0NFT25ZSFpjdVNB?=
 =?utf-8?B?M1dzenhOR0x6N1lVMytoRW1Vb09XQndOZGxsL21Wa1krZlY0QnZTL2puL2Zp?=
 =?utf-8?B?MDBhWmVaZ1dNMysxYm5jcTMwVVJwRFJIVVBvYlFVRmJ1QUhlSXQ5b0kweEcz?=
 =?utf-8?B?YURIYi9CNlF2VTZhY25TL2hvR2xiUjFyTEt6dVVMRGk5MVZrWW8vN083MXpn?=
 =?utf-8?B?Y3lxWGJxMDVEL1NYcFdBYlYwaEZETmtMcWZGYXdPRitENm54RlA3YVNYWlQw?=
 =?utf-8?B?akNWcUtsODUzQXdBVUFDbUd4NHNMWWVXWHFDYVZvK1lwRUo1N2xwK3gxWnVh?=
 =?utf-8?B?d1kwN1lIZkpxVUVqZFJWbUJBUzVJam5hR09mZEJSL1dQVTJUMFpxTXpNSW1k?=
 =?utf-8?B?dm9haEZFRmhscTFub3R4eUYvYjIzdjB2Q0hVVWtMdVhRcTg4QmdPQ3dBWkl3?=
 =?utf-8?B?WUpDenFQSWxXbTFkeVdEbEplWjUvaFdzenI4VFFBT1FYYm1GODIwWkg3VEJJ?=
 =?utf-8?B?Z3cvcWJQYkxiS0craGVFUEc0aWNWMkt5RGhwNHFRcHdkRDMzd2J0QXNNdjVI?=
 =?utf-8?B?WWtQWHpNUVBWUDc3dXFES1h2TVlhU1prYk9sMnFYclhkWkJLYlE5ZjZTTDFp?=
 =?utf-8?B?QWNrU3lpRHFGa2tDUzJCc3l6QUdZSXVWRWNyWUFRWlNMMzZid1I1SHhtRE5p?=
 =?utf-8?B?OHJvdWZYelYxcDkva3RjM3kzT3BpUkNlbC85UUpCeHRNK0hwREZWWkNEemxR?=
 =?utf-8?B?bVdQUFdUVmpKaTJYVk9RcGhaM2t0U1dhMTdGSVMzVW5ZSWVzMkRSMjRHQlQy?=
 =?utf-8?B?Y0JGQXNadWZZazViTkFkVmE4ZkxUZksxK1dhQjhXUnRSQ2pRSG5Da0NKaC95?=
 =?utf-8?B?bUh6TDVDRDA3b1cwdlcwQTFaWksvcUM4cUdYTzczWkRjK3lpb0oxRFpBb3px?=
 =?utf-8?B?SFBYUTdaSktucVVuMWN1ODhyR3lhVmxVRVlzYnc1aTAxdVIyVitUUWdWRnQ1?=
 =?utf-8?B?OGM3alpLMC9Tdzl5Tnl2OWRuZXlPNjlkZExLdUR1YmM5NUF6QjR0OE1GbkdV?=
 =?utf-8?B?eFAwd1c2UVpLZWVHL1ZKcmFjZTBrb3RGajdDa0hTb2FEcGN4akIrTko1Mlpa?=
 =?utf-8?B?WTZTNTIwQzFFUmhxYkhybGROQ3pPNHcveFlVZDN4Z2JDdmFDZDdTMlhNVFR1?=
 =?utf-8?B?c3dYSXdoclRXQ3pIV1V5RVo3a1BRQkxkL0pMUXZodEF1Qm53VXBkdGtzS1gr?=
 =?utf-8?B?eER2K2o2ZVpMTDdZeWZJWFEzOGIrY2VMYkY1bjhxdG9zeUxFRzUvUWtBbWZ0?=
 =?utf-8?B?ZHNZRlJRS2tVV2EwN3E0UTQ1YUp3eE1JSis5RlhWL2wyZ3VjbUxwVStkN1FZ?=
 =?utf-8?B?aWVVZ0FvY0hBcUJlV3BsUFJ2dkFuU2Z6KzQ2UEMzblpnQ2tFa1hoTWw3SFNp?=
 =?utf-8?B?Tzl6a29FOXlNZjBTVC9LVUVOQjVVeUZUaHNocDQ4c0VoUS9CYm9ZSXVoSCtk?=
 =?utf-8?B?czhVaUU1bURLcGFpWEVxNDIxVHJHOGtvcS9Eb3VsaFV0NUVtWFlPL2ZHZW12?=
 =?utf-8?B?R1VhN0UrNjd3dGk5WER2bTFqdmJNeXllZSsrU205eHRyVzg3YjZFQWVidGJJ?=
 =?utf-8?B?K1NwRnpjWStqREF3L0N0d0pQRmt2N2dnTkZMazlOeGloeXpIdjNIMHFoWDlZ?=
 =?utf-8?B?WENCWlRzQkIzR3hhbUlvWW1maDBEL1Fvam92cGwyUmRZTWpLN1NacFZObUhP?=
 =?utf-8?B?UjVjS29BZzIrOTBUQjV6WEtSaEs5czRQQ1N5TWhvZHdua1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cE1iZmRyaTE3dHNlcWpDYVg4d1BHNWRkdnY1dmNhSllieGRpRTB0SlNYSU1Y?=
 =?utf-8?B?U3hpUTZjZ2M4U3g4KzFsV0xzaWtidG1YbHpsbVY2czBRMGROd0RFSzRyeDZZ?=
 =?utf-8?B?bjJHeDRLOTdKT0tyUHFuT2ZudldwdTVpbkNUQXZQVm8wSDFBWnFNamQva3gx?=
 =?utf-8?B?WkJCUGlTVkVQakkyZENUVEw4S2d5R0lQVTV0Wi85NjlwcVRlYVVWbjBXeE1P?=
 =?utf-8?B?TVJaWmp4azJPMmlnaVR2NmlSVzUzSnY3eGxjMFcrWExmU0JxNHdwL0xaUkl3?=
 =?utf-8?B?dFlkWDY5L3dxa2dwbkN4QW9WaFg2NU5qWjRFOUM5cmtyM3NIR05TcGhWcHdz?=
 =?utf-8?B?a3RCVmIydDNreHN6dWVCaGNDK3RBbVB1dVNpUWpETjhDeEc3K3R2dENGWWV3?=
 =?utf-8?B?aHB4cFRYSWhXS1dTZ1hLZm5XbTVOZDk4UUlhQjhvUTRKVjZYU0F5VE0rTlBa?=
 =?utf-8?B?cFZmMWxqUmxYSGVXbForYnpRQ0o1STJXZS8zTTJrWTMrWExXNVhHQXZTYXVn?=
 =?utf-8?B?ZTRWeEFSalA5eFB2aHpqWklBZDBLMnQzaU5zb2tGanB3TWtVYkJTKzRvellO?=
 =?utf-8?B?YWpOSkdtdytCMHNaa3AwQ0NEQVB1b2FKNHFlbzRGNWt5aG1QQkFLQWZlRFBt?=
 =?utf-8?B?aTRjZjgzamlSb2xnb1IwTmhWdXdLLzFjb3EzU1FwOFVWeTdyQTlIc29MaTU1?=
 =?utf-8?B?WjM0MVRmUGQvYTA4VkJNVlpHOTN1OGxzVUo0TTBJM1FZTUs4dER4ajQzbnUw?=
 =?utf-8?B?V0dYTjU0K0Y5UDhYMjNRS2t1QUM3VU5Na0duUXpQTFZVS090eEw2MUpaaDZr?=
 =?utf-8?B?WjQxUXlJQUZhT2VxVEczYklvZDhGZm4yTVgzUXFtMWs3Y09zK0NURWd1bEI2?=
 =?utf-8?B?S25paVBZZnh3VXhjb3JhSVJpaWVLRGVTbVNndENKdjc4OXowdDNSajA5d0My?=
 =?utf-8?B?cnlwZTRGK0g4SVMxU2wvSGJKTGZRMVpDMEoxaXNkbHFYbUtoaUs1RzA2MjY5?=
 =?utf-8?B?VzljMUFOeE4rUXdRMkFoZk8vWFVONzJpRXlscjlFWk9jTFJiREdsQTRxOXRu?=
 =?utf-8?B?SW5JeHZ6R3RwVHg3c2V5M1pHUUNTMHh4YTJ3R1RWeVVEWktBeC80Z25FMXdy?=
 =?utf-8?B?WnlBTG1PTi9WYTB2OUhSOGRqYkFYOTdCdDVrTTZYT1pSZm9hUjkwdjZyTmZY?=
 =?utf-8?B?NVFHMHlFSEdiakI2c3AxcXRSNEVLZU14MEIyUlY1NWpmWS9MUmlPd2Z6OHNH?=
 =?utf-8?B?UUJnemo5UEY0MzRtNTZWVFdNOE53WTZSZkR1MW4ycjh2QzY2a2JWU0lzU2lK?=
 =?utf-8?B?STFGc3dWU2N2dmJ4Nm9hSDlkVkh2OEtGL3FyQk5CSGUrTW5RR1RmUnhUOGRp?=
 =?utf-8?B?MElaOGIyUldncXR1NW5seHNzOUhqazZjQWR1d3A2MnBIZ0pmd05sN3lXVUZ5?=
 =?utf-8?B?NEtnaDE1VmwzU080N3M5WU1tZ3FmbFJRbFREUTVxT1lwaWRnaVl5SmZYS2cv?=
 =?utf-8?B?VDRSaFZRVTJaQk0xa2d0cU5HQ2pxaHJOL3B3dldNanN0U2krYlJhQk5Fd2Nz?=
 =?utf-8?B?N1kxSzEzZFdlRWdlM1lJbHJqd2tQKy9VOXlqc2pIdWNkaGgrVklLZFR1WlFp?=
 =?utf-8?B?bUpIRC9ZcFJnSUlPZnRobjFIRTFWa3hiditScjNNbjcyRUhFWVUzQlNpYjJC?=
 =?utf-8?B?N3N4QlBSMCt0V0NTTUhIUTVSaGdQcHFJZG1zVXRJdi9CdFptUElNcW1BZ0tU?=
 =?utf-8?B?czBSdXZVblp1aUUwY0VWWGFWMlBSU3JsM04rcnpsbUdjOFVYYzVsTE4rdjQr?=
 =?utf-8?B?VWhZbUt4dlcvY1ZYUURXVmZ1cmJTT3orOVhkR29BWjZFcGJZY2huL3ZuQVZD?=
 =?utf-8?B?QXhsSTEreWxTSnlsQXlsZjk3ZkY3WDhKRndrVUw2Z3doN2RBMDlGTzNUSk1p?=
 =?utf-8?B?M3JITXFxTEF1Y1c0cUFmSjR6a1VCY05oaVJwQzlyeW9lQko1NHBzdTY1UGNy?=
 =?utf-8?B?MXUxVCtRZFp1Ym5oVitaU1F4NmpISDc2NUF3RzlubTR6b2tCOEtLMmVheGFE?=
 =?utf-8?B?ZE56NFRhUndzVnBsaGltS3loVGVOazJ2dHhCY2JOMlFxTVVWL0s0N01TclZo?=
 =?utf-8?B?ZnZFWGdZeGc4bnpFN0dqRlNscEpIaitLaHRYcTM2azdwaEFRd3BFb1NsNFNj?=
 =?utf-8?B?QUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4614269ED5EDE40BD296F6D4C7B2B11@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb7ba81-9004-4240-d500-08dcd11680da
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 21:29:36.0746
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSzD1IPLXMnqYsjEEISBWEcmBaZIsZFy3DnCGHRJ7Z6ALNUSp7MErTBW3X5nev2vfCEOssRd0+WHackBb7XD17wW9g+OxwOP2DaTQGXCwww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7708
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE2OjE5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
IE9uIDkvNC8yNCAwNTowNywgUmljayBFZGdlY29tYmUgd3JvdGU6Cj4gPiArc3RhdGljIF9fYWx3
YXlzX2lubGluZSB2b2lkIHRkXyMjbGNsYXNzIyNfY2xlYXJiaXQjI2JpdHMoc3RydWN0IHZjcHVf
dGR4Cj4gPiAqdGR4LMKgXAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHUzMiBmaWVsZCwgdTY0Cj4gPiBiaXQpwqDCoMKgwqBcCj4gPiAr
e8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAKPiA+IMKgwqDCoMKgXAo+ID4gK8Kg
wqDCoMKgwqDCoMKgdTY0Cj4gPiBlcnI7wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgCj4gPiDCoMKgwqDCoFwKPiA+ICvCoMKgwqDCoMKgwqDC
oHRkdnBzXyMjbGNsYXNzIyNfY2hlY2soZmllbGQsCj4gPiBiaXRzKTvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBc
Cj4gPiArwqDCoMKgwqDCoMKgwqBlcnIgPSB0ZGhfdnBfd3IodGR4LCBURFZQU18jI3VjbGFzcyhm
aWVsZCksIDAsCj4gPiBiaXQpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBcCj4gPiArwqDCoMKgwqDCoMKgwqBpZiAoS1ZNX0JVR19PTihlcnIsIHRkeC0KPiA+ID52Y3B1
Lmt2bSkpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBcCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcHJfZXJyKCJUREhfVlBfV1JbIiN1Y2xhc3MiLjB4JXhdICY9IH4weCVsbHggZmFpbGVkOgo+
ID4gMHglbGx4XG4iLMKgXAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBmaWVsZCwgYml0LMKgCj4gPiBlcnIpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiAK
PiBNYXliZSBhIGJpdCBsYXJnZSB3aGVuIGlubGluZWQ/wqAgTWF5YmUKPiAKPiDCoMKgwqDCoMKg
wqDCoMKgaWYgKHVubGlrZWx5KGVycikpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB0ZGhfdnBfd3JfZmFpbGVkKHRkeCwgZmllbGQsIGJpdCwgZXJyKTsKPiAKPiBhbmQgYWRkIHRk
aF92cF93cl9mYWlsZWQgdG8gdGR4LmMuCgpUaGVyZSBpcyBhIHRpbnkgYml0IG9mIGRpZmZlcmVu
Y2UgYmV0d2VlbiB0aGUgbWVzc2FnZXM6CnByX2VycigiVERIX1ZQX1dSWyIjdWNsYXNzIi4weCV4
XSA9IDB4JWxseCBmYWlsZWQ6IDB4JWxseFxuIiwgLi4uCnByX2VycigiVERIX1ZQX1dSWyIjdWNs
YXNzIi4weCV4XSB8PSAweCVsbHggZmFpbGVkOiAweCVsbHhcbiIsIC4uLgpwcl9lcnIoIlRESF9W
UF9XUlsiI3VjbGFzcyIuMHgleF0gJj0gfjB4JWxseCBmYWlsZWQ6IDB4JWxseFxuIiwgLi4uCgpX
ZSBjYW4gcGFyYW1ldGVyaXplIHRoYXQgcGFydCBvZiB0aGUgbWVzc2FnZSwgYnV0IGl0IGdldHMg
YSBiaXQgdG9ydHVyZWQuIE9yCmp1c3QgbG9zZSB0aGF0IGJpdCBvZiBkZXRhaWwuIFdlIGNhbiB0
YWtlIGEgbG9vay4gVGhhbmtzLgo=

