Return-Path: <kvm+bounces-28572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 841859994BD
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 23:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B364B239DE
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 21:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506381E47A4;
	Thu, 10 Oct 2024 21:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7N8TALV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E781419A2A3;
	Thu, 10 Oct 2024 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728597221; cv=fail; b=jLDPXEQxY8GC15Gs45xjSiTfW26dNZFI7JmvKRpLtbY8jpC/2SRC6/slnW9ub8Py9Wh2IVN10sZ+fhf8HuVHMqg5+xQYh9vdDoEWYqgEe4RwSMlB5qtovXxKeXvZLbt+UsWTe68bo96BXmzYH2t9KFqHw4WXPO7x3hEk5PAgpXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728597221; c=relaxed/simple;
	bh=1k2Rcci/6BeyQQVbZ0frjQOZ6Qy2OMN2MnAcn2DA3wM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YwdR73NlHHEHGiLXF4UDL8bZsH4lFnRNRBIjTkiIZMJHxU1IQIJschXGoy9XKTTDGM/+qB5UpJo7CTGsnN+uaic5RmeD1z7sgeU1YZG4JnoLwUp6trEwQO6Ye9XcoCsXMZ60iaC6Bp5bfQa4lqrBQtevvuUHvwjDiZMb0jWK9ZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7N8TALV; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728597219; x=1760133219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1k2Rcci/6BeyQQVbZ0frjQOZ6Qy2OMN2MnAcn2DA3wM=;
  b=P7N8TALVM3XbmpYEaxV8rMuSkKQnWhTdc/ZkRiiirTAmuquofe86dP8C
   D0Fluolehfm2y+mS/VXX3Zc3ABE2pPKA9+L4C59Kgg8mfYvr/qN7Fw4KQ
   PQydp0PAIN4Gh6y1PP5A3bIH3Q7i8bWc1+xLhmCg/AxN9D6KZdJvMF7si
   jx5mVTtp6qxoKAh2xu4gvne7l1t0O3OBT4CD8LGC9aLvOwwYwXobkX/sj
   OBJ23TDBlpHZeG2TboQcgzqryNp1NiPqxS1WkWC3aIyGCnMIHHTwmxQQO
   924W0bJlwaUcfxg6W0kO55VY+XxgwNgGkPOPbqLddtqGhBGi28Y1Q37MC
   Q==;
X-CSE-ConnectionGUID: ZuUbXoPwRyObdDN9CeDn7w==
X-CSE-MsgGUID: 00jI1pzsTba8Gs8zH8+m4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="27858724"
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="27858724"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 14:53:38 -0700
X-CSE-ConnectionGUID: oGDFVQ3BRHuuQnr863cMQw==
X-CSE-MsgGUID: VMxY9tBLQY+TqMhbn5i8Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="81522744"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 14:53:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 14:53:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 14:53:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 14:53:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 14:53:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDyQ1F4ks/tq2QdY4ynI20ivxtcFUDNhFp+vcAdjywOAt9eieJF5gcOr8R11ganVTsn5XTsrEmRNixtcLCEa6B+90U4nSjncvqyJhihp7HYWJQ/15maz+hJTktPJnXHT3JQ/4B/DXnDnLv4OpKqi/K8soeKSkNQ0X7jvn0YUq9UlJwxZoWTyG8wgKayMvWttLl11Cw2JTwjWHkLTz8SQvWYw4cM78wHme7nMc9FSP7edVPv9FaQvsZJSWSmh7uCN1cp/04MaCysBtPU/4LCuEGEHRf7gtnELoImBGGcBQTcAp+kYhj/U2S3G2lZiGF1U8LnCNRDiKES+5YzsMT5RIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k2Rcci/6BeyQQVbZ0frjQOZ6Qy2OMN2MnAcn2DA3wM=;
 b=fzYE3xJVVMW0Tez1WKzApw7PXT0OoQGYhoMnD853hVOmrQtAsV53trsjdOVmEcT5tGXeXwjIPmhHfzJ36s926c6V3LlImHNxu5lBlEGLqUQVPxsHJ52JBn8kS2OvD1MLwytWXyU1E0/+Q/ylI11877pewBqybqzpN2efAMu66pJM7ZQZZ8cIs5mReaMZsqY7G5GzDBnaKmtT1GmvNHG9F+5HlARrM94tiiko84eZS+XILZDESaJpMNbyuCnjZ6mvsofBarkaAATzfUkIo2yt7p0k0rmNSW/ZtC8/5PKe34iifkS3uP95EcG4c1pn/5lnnK3WqJhCVlBkx0MvjQNUSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB4979.namprd11.prod.outlook.com (2603:10b6:303:99::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Thu, 10 Oct
 2024 21:53:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8048.013; Thu, 10 Oct 2024
 21:53:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQCAABS2AIAEHmMAgACTNQCAAQ19AIARYacAgBSwvICAAoX8gIAAzAUAgABIogA=
Date: Thu, 10 Oct 2024 21:53:29 +0000
Message-ID: <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
	 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
	 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com>
	 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com> <ZwgP6nJ-MdDjKEiZ@google.com>
In-Reply-To: <ZwgP6nJ-MdDjKEiZ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB4979:EE_
x-ms-office365-filtering-correlation-id: a3ea2624-a2db-4427-6342-08dce975f9da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RnJ0cDdXV2ZCYTBWSlNIZ2dsV2NXa3FDOENpdEFIQzNxZ01FOUEvemtaYmcz?=
 =?utf-8?B?QU4wUEhYeEF3WlREWEZhMzAxTzVlYzZ6RGNaQVhwSXlOdmNKME8ySmFLNnFw?=
 =?utf-8?B?N3IycDNmclJDM3duaXRlUTZsZ1dUUTJFK1diY0NxM1VYK1FWSmRzV3dIU2c5?=
 =?utf-8?B?b3pFU0ZQWFZhRExCSDdubXlzZWFGYllYNUViT283Z1VyUWFNZjhyck55ZTNl?=
 =?utf-8?B?V01UbXpYNlVHTzl1ZjBNK0U0aGpUY3o1eG5UMG0yWkpORmpscTRrNzViV09Y?=
 =?utf-8?B?MUo2VVNZZWUyUDBnaDFLWkN3SWlKWTBRVko4Uzk1NUxCa1NjdWVCSVVMQnpZ?=
 =?utf-8?B?eFlkTS81S04wdkJXSW9zUm92alVNc1g4L1RKUm5pSlErQzloWHBRdkRyUkV3?=
 =?utf-8?B?QzEzcGxiNnR2L3FvQUFKeGk3cWRIdXZBUVdlYUpWN0NYMStjK25uQmtGajhS?=
 =?utf-8?B?K0NQQWVtamI0TFRiVWtYSU5FdEFGOGpTd01qNHJaNXVWM0RtOXFUVlV3R2w0?=
 =?utf-8?B?MEVMc3NvVTZZQlU2aTBXL25HUXNPZWsvWk1ScmY2bjRvQ1pUMmZlK0g4OVBn?=
 =?utf-8?B?dE5hRmMrRk5MeVdOTE5BZGV4Vm4rM09xRDJvNm9yMzMvVHZrM2RMK1JoTGI4?=
 =?utf-8?B?S2wvZ0NwN3VDd1Y2WTd6RnZoYmhueHltVE9ITXkxcVNMUWMvZ0tzcWpJU2NH?=
 =?utf-8?B?Q3BWVlRJeHorWVlNdlhVa0hEUFlhSUt4dDdDSWt0ZXRNSFVxc0UwUVhaSUNu?=
 =?utf-8?B?N0NGakNGbGQzMlFZdVJocWlSaXgreml0dXQvMHEwM0U1S09sYnNPZlFsQWtI?=
 =?utf-8?B?S01yVm1IV3RLQTVveWY1Tld2L3dNcitXOW82T1JBWXZOampYMS9TSE9aSFNX?=
 =?utf-8?B?M0luVm1TbnF6WTZDWmNxRjd0Y3hkRlkrZzdWNE5XcHVlM1NTdmJpbmowaXd0?=
 =?utf-8?B?MlhmOW5LeGZrUjhzTGhLelFDa0pNdzdnQ1o3bGh6bmtxZDRIUXJublhXbDZn?=
 =?utf-8?B?bW5sbG5PYmhzNnExR3JlbWs1bExNaktUZ3o4ekFhWDNiakVzY0ZmdllFZUtp?=
 =?utf-8?B?Y3VtUlhYUDlEMCtRRFNEQktkQXI4Zkh3bk9ZNk9Fb0NTTXViNGFodVZjR2pX?=
 =?utf-8?B?bDZhZFo1cHdZZy9NTnlTcmhXcUc1S1FYRlQwd0E5RmVweERhS1lXTkZBMGZs?=
 =?utf-8?B?YkdCckF1NzNyUTJIdWhCOUNNb00wMFB5UTdBV3dFNzMwMzJ1RWt3QzMyZDFh?=
 =?utf-8?B?dVowOGphbEVESUlrMDRrVSs3RUxhbUVhb01uUXJHbXdrcDNtRjh0TXpQSFdp?=
 =?utf-8?B?c0VkSG9jb2NhUE1NbUJRUmc5NlVoU3ZRa0hDUUJPblhDcTFKUWk0MnhZYy9r?=
 =?utf-8?B?UldLTEptbUFEWjB1ZUt1WFZ4MFNoQ3dEaXJPN1BoY1hybVA2QWZkLzdlR3BI?=
 =?utf-8?B?OW9FRjRSMEdIWCtuQ0lUTDRSRkxONFQ0WVFqN0Y1UW5PUVJnZFQxeWp4U0Fp?=
 =?utf-8?B?MlJ2ZEdpZ3RVcEQyTmhyNHFycmtINkMzWElaQmJjdVFxLzlwM25ZWm0rUkdn?=
 =?utf-8?B?OXFCV3FxMkNGUmdHRlVCYVpRemZNcitucTF5U0J0WnlmSzFmOGxiL3kwd1hr?=
 =?utf-8?B?OXhvazhmYlAvZlM5bzM3Rm9jcENEMFJHdkMwUHp4aXlpTjRxL0x0N3hCYlVi?=
 =?utf-8?B?VExta1FBSEZ6bzNRU2p1eTcrcnVWRUZRRHNQVkpDWGhyOHY0N1hYbERpLzJn?=
 =?utf-8?B?bUxIeEtKbGYvV2I3U0Y2dC9KalV3SkpMM2xsRUR3Qzl4cVBBbUZ4YWttK2ww?=
 =?utf-8?B?aXF3cVBmaG45Uklpc0VwZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0s3VXgzUSs5cnJTQm5VYm13SlkyeU51Ym8rNEZhbFkyTTV6S1ZSWUdaNkpF?=
 =?utf-8?B?SHh2alp0d1dUZE1aSzcrL1BMKzlKYU04TUhGMGJNbHc0TGVtY0lUdmNXOGc5?=
 =?utf-8?B?dkJrVEl6cTdlMXFXbUdqbEVhVUhYZGcvQ1NrWWRvVkRyWlZVZXhlUXVhRkFk?=
 =?utf-8?B?U2R0SCtQUEhFM3ZxdnpPZHF6R2hrbVNXMXM5aDJmbGVEOVIveG1CSFJvR0N5?=
 =?utf-8?B?MXI5RFU2TGpsTjZzZVY0RlhlUmpwcjFyVlY2RUMzTGplbUJqOGlNZ05xWHdy?=
 =?utf-8?B?NTRCa0pyOUY1a1RtTmxzVmxYWmVvQklXNHA3eGtHcGNjL09QMUkvMFR1Rktk?=
 =?utf-8?B?S0xJYm1BZVhteXJDTXRRaU9uWm9Xb0U5TFlVUC80clFQSmJoU1FGOW9mUWRl?=
 =?utf-8?B?eFQxZjNrUzBETEU5YjQvN0MvdGN2MHJhaXp5YW1ONnpOc0dRMURqNXdzbzlJ?=
 =?utf-8?B?UzdhK3RIb21SZXZmU0QwaWxlOERnVDMwc3QrcXpzWStSV2RjVG5naHRYOG5k?=
 =?utf-8?B?RGQ0SlpyZEtwVWJsbEI1cFJwMTVCRkRRZVdWWWNSV3VLMFhaTTd4Y0VLcEJ6?=
 =?utf-8?B?NG9JamxxM0lmdXdPNXh2REFKa3E0K3FzVkk4Rjl1TWFjTW4zZjNndG5wYXA1?=
 =?utf-8?B?bHVQL1MybVZpMWZIWEJNVnpTZmFBcW8xL2hFU1o5R0xBVmZ1VVVzaEdHZy8w?=
 =?utf-8?B?YmxxZ3UrZHhYSEhRL0dqNmRlWXM3bE1lWGQ3WnFRUUlManI5N0VDSXdadkN3?=
 =?utf-8?B?NnRMQ1ZyZndTVklhSkEyUThJZmlaQVV5cCtNcUlBVHNCN29zbW1yUFFBRnc4?=
 =?utf-8?B?ejlXRklwN1RmaHpSbExzUXB2dkV3aG04NmNmVWtpZHllcjc5Z0pHM2FqSk10?=
 =?utf-8?B?ZFNSaHptbnlGdzVsRGhtbWVPUkc1Y0dJdFRLUkVHcEk4eVBpbGZMRzFOSVFT?=
 =?utf-8?B?QmozcjJ4QTUvZ3lEVG5WY3MvNVJReWVoKzhKZHY4UEFiODVIcWlQVVBVVWRD?=
 =?utf-8?B?ZnQxaER4bFpEOVpUWDI0QVBvMHViK0N1cWN4S2xmcTQ5ckVvbTk3dHB0bnlF?=
 =?utf-8?B?bWhFZ3ltNnY2cllMTm54TmpGUnJnOStJbUhyRXhHaVo1YTRhc0NVY1lkNWhr?=
 =?utf-8?B?a1o3dVk0OCtrS2Rzd0dxb3dRWFpOZ1NxWDgwSXM1Z0tDZkRNaW9PTk5Ib3JX?=
 =?utf-8?B?SCswM3pwVWVvT0lWdWpiTnZieU9YNkhjV3U2U1B6aUQvUDl3MEp4QTRKRmNj?=
 =?utf-8?B?VVhtVXZITVYwMnkvWnRtMlo0dGU0NWVoaFJwSkxCOGp1Wk14RnZQdmk4ZE1j?=
 =?utf-8?B?Q0hLY0l0UVRmd1pUbmtNTGxQZ3JOVEVJWUZFL0RVWVdyYWRxQ0U3MU5EbEVC?=
 =?utf-8?B?OUpub29IRGxpSlNQRzZCYU1jN1N5eTVCVlpxRFdUaG80M1d5RjhpNlA2SWxw?=
 =?utf-8?B?RUEvSEtKN3Z1Rm1TREdyWExDUDM1OHlrUzk0aDV2TzM0bnhueTNxNVJLYXBo?=
 =?utf-8?B?cThYU2FDbzFOcHRGK2ZiRUh2b2hTWFk1YldrajNlNldxZlRlaHZGZ3VKaVpa?=
 =?utf-8?B?Z056ZVBkSmFFV1F2aXNxbDFPbzM5K2V1akY1Ny90QzhBV29kR1VDNVRsaUtT?=
 =?utf-8?B?NDNCZTZVWU5ueEFuV0tITmhQTWhhU3pmRXZ3My9telJ6TTlQaUxpbWdmTGNs?=
 =?utf-8?B?MkFYYlowMHluZms5MlI3S1FrTkJQc0pMUUYyMzRpVEZVWjg4UURSTmpNOUkx?=
 =?utf-8?B?dEsrSGpHYXNSOFoyQWI1Q3RCbHN2MHEwQ215aHJjaEliS2RsQ05nbWpmMlRp?=
 =?utf-8?B?T3VUL1pxcDdhNXZYajJEM1BMRlZxa3U4dzh0YTFaQ2p6d1hnNjF3d05WbkhT?=
 =?utf-8?B?QjRXWjdFZjRtdWFvbWV0dWJUVTV0KzRSQUljSWl6WFFBR2dWVTRLWjhFbFVR?=
 =?utf-8?B?ZDlJWTBKdWFxWFV5UE1lUCt0a0tmL3prdG9zMWlWTVJJdVd1YnFpd1ZYOE82?=
 =?utf-8?B?a3YrN0duUmRScHErSkpXczBoYWxMdjlLL0dxSmpXTlFpNWFlc253ejRNMktP?=
 =?utf-8?B?SG14V0FQMGVkVVAzSC9CL1Z6MXJ1RVRBSnduN3FwaWxYdFBGVExWYStuMVFC?=
 =?utf-8?B?SEMzQ09wWGE3WnUwZEQ1Yk5JK3E5WHZBZGNrM2UvRTRTU0NNTzl1MVl4T09y?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E12E94CB1291B4429C81C4706C708F2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ea2624-a2db-4427-6342-08dce975f9da
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2024 21:53:29.2019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6x1LYSiGOuACtkiYdEwR2tRSJURkbbmDhvvlBkj21KGHip5xcdzThRedHRGprrRG3gFOLekXB2VgIpTaKZwe4ffO/jTWKe4CW44lfCmJsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4979
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTEwIGF0IDEwOjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IA0KPiA+IDFzdDogImZhdWx0LT5pc19wcml2YXRlICE9IGt2bV9tZW1faXNfcHJp
dmF0ZShrdm0sIGZhdWx0LT5nZm4pIiBpcyBmb3VuZC4NCj4gPiAybmQtNnRoOiB0cnlfY21weGNo
ZzY0KCkgZmFpbHMgb24gZWFjaCBsZXZlbCBTUFRFcyAoNSBsZXZlbHMgaW4gdG90YWwpDQoNCklz
bid0IHRoZXJlIGEgbW9yZSBnZW5lcmFsIHNjZW5hcmlvOg0KDQp2Y3B1MCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHZjcHUxDQoxLiBGcmVlemVzIFBURQ0KMi4gRXh0ZXJuYWwgb3AgdG8g
ZG8gdGhlIFNFQU1DQUxMDQozLiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIEZhdWx0
cyBzYW1lIFBURSwgaGl0cyBmcm96ZW4gUFRFDQo0LiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIFJldHJpZXMgTiB0aW1lcywgdHJpZ2dlcnMgemVyby1zdGVwDQo1LiBGaW5hbGx5IGZp
bmlzaGVzIGV4dGVybmFsIG9wDQoNCkFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQoNCj4gDQo+IFZl
cnkgdGVjaG5pY2FsbHksIHRoaXMgc2hvdWxkbid0IGJlIHBvc3NpYmxlLsKgIFRoZSBvbmx5IHdh
eSBmb3IgdGhlcmUgdG8gYmUNCj4gY29udGVudGlvbiBvbiB0aGUgbGVhZiBTUFRFIGlzIGlmIHNv
bWUgb3RoZXIgS1ZNIHRhc2sgaW5zdGFsbGVkIGEgU1BURSwgaS5lLg0KPiB0aGUNCj4gNnRoIGF0
dGVtcHQgc2hvdWxkIHN1Y2NlZWQsIGV2ZW4gaWYgdGhlIGZhdWx0aW5nIHZDUFUgd2Fzbid0IHRo
ZSBvbmUgdG8gY3JlYXRlDQo+IHRoZSBTUFRFLg0KPiANCj4gVGhhdCBzYWlkLCBhIGZldyB0aG91
Z2h0czoNCj4gDQo+IDEuIFdoZXJlIGRpZCB3ZSBlbmQgdXAgb24gdGhlIGlkZWEgb2YgcmVxdWly
aW5nIHVzZXJzcGFjZSB0byBwcmUtZmF1bHQgbWVtb3J5Pw0KDQpGb3Igb3RoZXJzIHJlZmVyZW5j
ZSwgSSB0aGluayB5b3UgYXJlIHJlZmVycmluZyB0byB0aGUgaWRlYSB0byBwcmUtZmF1bHQgdGhl
DQplbnRpcmUgUy1FUFQgZXZlbiBmb3IgR0ZOcyB0aGF0IHVzdWFsbHkgZ2V0IEFVR2VkLCBub3Qg
dGhlIG1pcnJvcmVkIEVQVCBwcmUtDQpmYXVsdGluZy9QQUdFLkFERCBkYW5jZSB3ZSBhcmUgYWxy
ZWFkeSBkb2luZy4NCg0KVGhlIGxhc3QgZGlzY3Vzc2lvbiB3aXRoIFBhb2xvIHdhcyB0byByZXN1
bWUgdGhlIHJldHJ5IHNvbHV0aW9uIGRpc2N1c3Npb24gb24NCnRoZSB2MiBwb3N0aW5nIGJlY2F1
c2UgaXQgd291bGQgYmUgZWFzaWVyICJ3aXRoIGV2ZXJ5dGhpbmcgZWxzZSBhbHJlYWR5DQphZGRy
ZXNzZWQiLiBBbHNvLCB0aGVyZSB3YXMgYWxzbyBzb21lIGRpc2N1c3Npb24gdGhhdCBpdCB3YXMg
bm90IGltbWVkaWF0ZWx5DQpvYnZpb3VzIGhvdyBwcmVmYXVsdGluZyBldmVyeXRoaW5nIHdvdWxk
IHdvcmsgZm9yIG1lbW9yeSBob3QgcGx1ZyAoaS5lLiBtZW1zbG90cw0KYWRkZWQgZHVyaW5nIHJ1
bnRpbWUpLg0KDQo+IA0KPiAyLiBUaGUgemVyby1zdGVwIGxvZ2ljIHJlYWxseSBzaG91bGQgaGF2
ZSBhIHNsaWdodGx5IG1vcmUgY29uc2VydmF0aXZlDQo+IHRocmVzaG9sZC4NCj4gwqDCoCBJIGhh
dmUgYSBoYXJkIHRpbWUgYmVsaWV2aW5nIHRoYXQgZS5nLiAxMCBhdHRlbXB0cyB3b3VsZCBjcmVh
dGUgYSBzaWRlDQo+IGNoYW5uZWwsDQo+IMKgwqAgYnV0IDYgYXR0ZW1wdHMgaXMgImZpbmUiLg0K
DQpObyBpZGVhIHdoZXJlIHRoZSB0aHJlc2hvbGQgY2FtZSBmcm9tLiBJJ20gbm90IHN1cmUgaWYg
aXQgYWZmZWN0cyB0aGUgS1ZNDQpkZXNpZ24/IFdlIGNhbiBsb29rIGludG8gaXQgZm9yIGN1cmlv
c2l0eSBzYWtlIGluIGVpdGhlciBjYXNlLg0KDQo+IA0KPiAzLiBUaGlzIHdvdWxkIGJlIGEgZ29v
ZCByZWFzb24gdG8gaW1wbGVtZW50IGEgbG9jYWwgcmV0cnkgaW4NCj4ga3ZtX3RkcF9tbXVfbWFw
KCkuDQo+IMKgwqAgWWVzLCBJJ20gYmVpbmcgc29tZXdoYXQgaHlwb2NyaXRpY2FsIHNpbmNlIEkn
bSBzbyBhZ2FpbnN0IHJldHJ5aW5nIGZvciB0aGUNCj4gwqDCoCBTLUVQVCBjYXNlLCBidXQgbXkg
b2JqZWN0aW9uIHRvIHJldHJ5aW5nIGZvciBTLUVQVCBpcyB0aGF0IGl0IF9zaG91bGRfIGJlDQo+
IGVhc3kNCj4gwqDCoCBmb3IgS1ZNIHRvIGd1YXJhbnRlZSBzdWNjZXNzLg0KPiANCj4gRS5nLiBm
b3IgIzMsIHRoZSBiZWxvdyAoY29tcGlsZSB0ZXN0ZWQgb25seSkgcGF0Y2ggc2hvdWxkIG1ha2Ug
aXQgaW1wb3NzaWJsZQ0KPiBmb3INCj4gdGhlIFMtRVBUIGNhc2UgdG8gZmFpbCwgYXMgZGlydHkg
bG9nZ2luZyBpc24ndCAoeWV0KSBzdXBwb3J0ZWQgYW5kIG1pcnJvcg0KPiBTUFRFcw0KPiBzaG91
bGQgbmV2ZXIgdHJpZ2dlciBBL0QgYXNzaXN0cywgaS5lLiByZXRyeSBzaG91bGQgYWx3YXlzIHN1
Y2NlZWQuDQoNCkkgZG9uJ3Qgc2VlIGhvdyBpdCBhZGRyZXNzZXMgdGhlIHNjZW5hcmlvIGFib3Zl
LiBNb3JlIHJldGlyZXMgY291bGQganVzdCBtYWtlIGl0DQpyYXJlciwgYnV0IG5ldmVyIGZpeCBp
dC4gVmVyeSBwb3NzaWJsZSBJJ20gbWlzc2luZyBzb21ldGhpbmcgdGhvdWdoLg0KDQo=

