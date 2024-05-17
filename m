Return-Path: <kvm+bounces-17578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7851F8C8199
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:44:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6C211F2181D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 07:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D12217BB6;
	Fri, 17 May 2024 07:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hilgrCbF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D5A179A8
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 07:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715931837; cv=fail; b=GcACo3lR+0fFXR2rKntajRb3sONnjzqToU6ittChCITfoshYUvlSoN273lzlXZmD+YPCtxd1CfkFWZVd48VqzI/cAg1ke5WoKRuUbg7gI8WGvChLtCajfW+KCLkJohxRvmZNItqiF9hTNzNJaVCSKOfn+sUJEBTuxAmHUeHRr7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715931837; c=relaxed/simple;
	bh=yKNUVmQ5NIVqcE85+dcLBkH3y98yc1GmnNWzvgaVTlw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YXWZjRyUcN2OGZwvXR6noRcu2d+VtteU5UD4a6l4uqOA0t0zhJFPTqYk8JyAvfdEte8RZFXQaqkWNox1IAS3c3TBZUfD40MOL9QjI+Hc+QmClfYlwQKpI7Q/uaNAfjinhBA1/n4hq0AZm0AMa59n6EMcz9CcXdIEp/aPrSSpToA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hilgrCbF; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715931836; x=1747467836;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yKNUVmQ5NIVqcE85+dcLBkH3y98yc1GmnNWzvgaVTlw=;
  b=hilgrCbFKAjzjrha+lYvkG6c2emEC5yr8ayVwwNgOXpqe1sP+ngejyip
   qBUIXwJaI2oCHJHecmPvw5FSmRacLXwwgsta3jncNncyFSYoBvsN6uZgx
   BsbCjOeuH1Las7TrQryObzygXtxZ1Qep9vszkKMumc4HVu16R7nLAg+Sh
   IAGOqNrGMV5CFukNzOt+54WXJA+P/XVbOiUHOSRjGGoOw0mhDlFqhK7NV
   j7d3NpI9w0T+5dMODQ1AcyERjc/nc9EchdJ85FTB1pPi9UxqjtS0K58Yn
   Yl0QEdpuRGigSqRP2rzeBSZ7EotYXIkC6j8Hxsxa2ePcMWZUmhhBCvdPb
   g==;
X-CSE-ConnectionGUID: cYfMEJOnS9OtpvGe16fwVQ==
X-CSE-MsgGUID: 9PILWO+bS3qyQu9BRh2CHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23506005"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="23506005"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 00:43:55 -0700
X-CSE-ConnectionGUID: H/ttwAPpTdyc97lI9YYV8A==
X-CSE-MsgGUID: cqhzBfJORyeEGRpIYlo2Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="31527896"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 00:43:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 00:43:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 00:43:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 00:43:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 00:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnIaC2yvW7zxiBB7ynkpsJxudfrRfrtIx/0aT2gwByIHnVCXHVYNUlJm3V6WuD+bG5Vq/NPbyvuSXtnupB9/4KWax/5VttZX4ffoqp7vdE2X07836CI8KIKWze54bvKUolfjJwLG0q3hlyM7Gi9hHQJp/vFqLP9T0h/vkYUDxYtn0Kl+n8AtpA73DTHH8+8wH1nE5O4lpYccKtT2Z3D5QOnVwdbDjZBU4PtnooZoLglSrLFGUTFIhQ4mFnXWMF7npE1PWRBuLEjwxPJdAVdhZuvU0fleUKJFP/E/5buOhngFfCRSfSxfaYSg10rJIR938uTutG9rTRYE0fzsI+2b0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCV/ELoiAcv3KT++kcy93h0aT9wjq3vI4u0eeQBr/xg=;
 b=NFNG8ZguR09hhvLBxL08mWX2OHFglzodPqu14t/H5pRuB41yYZbEA9AGwUVV4xgIG7V/z3qEc0CRTuZm+WzNi9AH/5VfVVqhXto7bGHKb1IpZYB/6nFrB9rtXDi3PlFXToqIyc9X2qnQmTr2iqbC4vB//TYj961KQShgxzLDWLBclkoLmMS1bUXxD50x+oliAXeh9Mlm/8y03s/g7Jb7kvhwg8WsvHRb36KC04L1eDiGdDe83DITgbtnFHjcLYparUuLpr98FuoHtljFA/4vGJLIsQRXE8bE7Cdif/8lMBbcIg77ETUvc2mj8XUdagS2liuJkDHuW6hveiCiM/QQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 07:43:50 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%7]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 07:43:50 +0000
From: "Liu, Yi L" <yi.l.liu@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH] vfio/pci: Restore zero affected bus reset devices warning
Thread-Topic: [PATCH] vfio/pci: Restore zero affected bus reset devices
 warning
Thread-Index: AQHap7lWLQpOtRmcXU6Fa/MShctRnbGbDBtA
Date: Fri, 17 May 2024 07:43:50 +0000
Message-ID: <DS0PR11MB7529C4499257202D2E599EBBC3EE2@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20240516174831.2257970-1-alex.williamson@redhat.com>
In-Reply-To: <20240516174831.2257970-1-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SA2PR11MB4780:EE_
x-ms-office365-filtering-correlation-id: bfe5edf6-15d5-4493-6193-08dc764517a2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?V7f6ScPhnIr4iw7IxTMPy3BjaHXdcw9/w+Q4+lMLreAbs5iu3yweLHks8S4s?=
 =?us-ascii?Q?JfnIlvEbDtXajgq0E1B2hcPdXnuurfXzfJJz70QReXfovr/01SPUI56KCKyC?=
 =?us-ascii?Q?LIKP5bOam3Vlk2PN8lmxqvPIfpHFhsDX62pvVgB9bwA4gTXV7VtSzHlgqNEY?=
 =?us-ascii?Q?Z15zmX+Ahiate+bHJyrAE8XMfgmbiN5z1kYlF2tFh5yc6ptn5+5oOPlR6v+C?=
 =?us-ascii?Q?yXV+yi2/FrPWOfv1NRxdfkyUhi3xRNM4KIcqzBbxPSwkgEijUOVdE+hKnfzK?=
 =?us-ascii?Q?GZh1orDEePqHheYYDuc0uEoVZNU0+9hb7NmFkay0quAv2cwzF0956daffHJG?=
 =?us-ascii?Q?n5Bn+ZnioLcLw2Cq1sKflUMfnQflVYLRbZ/IlcubTiLbxxRKDvrkUTeNTBCM?=
 =?us-ascii?Q?WXglBP8yA1ttAroaHPs1dxw7QaQrIL4TzfLYFSNYor9caNUw9aV2k+LgiY9z?=
 =?us-ascii?Q?jVtC9bfzx27asNX/JX+Tkdc8BSAb6lKLJb8u8ZxIrDAIZor9/pVIVhpB522n?=
 =?us-ascii?Q?l0ewXVCVHeIsZUqOly/WKa2Tnu7vZ0zllr6eEd3ZtOK3dza9h4ZNkzcU5DON?=
 =?us-ascii?Q?US0PdguB+wqTUB5PG7y43IXjubOBqF1EcIkYJ0YOLbMwjoCi7L5IRFhbcxl2?=
 =?us-ascii?Q?5s9+ArQAXlR8637EKujq1Fi2nEifzXnfl4msI24bRTZwEQ2lWtSxbvxDIjS1?=
 =?us-ascii?Q?MX2B80Bcjj+oH7t67m5LJjP+XYZqoMnbBFRMryINtI2gYAvSuH1B7VnolXcy?=
 =?us-ascii?Q?05tOEUjorwOaTolvEktKA1Byp6SgQcpT3mVJyO3pLfSI3Tl1SkCkp5Sjpf5O?=
 =?us-ascii?Q?EQEoYmfe1sIH0qChuw5UwE250drn6ir3bWjSnE3Pb5DErSvISoxvZXyZydTc?=
 =?us-ascii?Q?SqozvAHDxPcmoItIjb7es8n6lzHJHUaNRaYHik93L234pRHijaa5QH8L38vb?=
 =?us-ascii?Q?FpK0BONqJXynHCw4TdJrIYOAQ9Ct4pcjiHKyzcCZec7rWWei9pktIwxHXvLx?=
 =?us-ascii?Q?hH1Tl1Dy4XwxwILWxQ9dNqsLuX7WBZHb2B+lMQYg5ihWba52c+Gyo1qjlo/Z?=
 =?us-ascii?Q?3Yq7prbmCzhJyPqo1nVQR/8JyCO3ZJ3VNl3ny2/a/DikKgA18rPGZ1p7cLNw?=
 =?us-ascii?Q?1A+TPopgUQSddh+rptX3z63u+Yo7PvVu9OWlqNTHx5G7O7WTeWg/5XTUuel1?=
 =?us-ascii?Q?M1lbtiCe9UsrzyjnlOgmC3nu1j08/XatZSzb2aUsMxjXIHz9c6Gq3bDR7sxU?=
 =?us-ascii?Q?L8RUQfvl8B8gPJ7ZQNIpgU8ZW9MJYJ/fAAc9a8tOGmoUdKpoKJo+iDT7vOnc?=
 =?us-ascii?Q?jkEX4xbLVYqrvS+CraV/rWO8dr+X/ep+Id3DzwFP+8bObw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QvwTZC4EmdQDFK3wmo1BwT2xjw7t6V+1E3h2o15Troy09oC038DvpBpp9P35?=
 =?us-ascii?Q?ZInca6/EWnaH2IyiHuFltiWJ/HCY0h5Wt5zAuRouVR+nvVt6Co9yIiBDflHD?=
 =?us-ascii?Q?lTA4ipa8MKfpgBhpaXvRcfgJXROfPJ89MwYi+bb5QChcbdB7VG11PUu3N2rq?=
 =?us-ascii?Q?bFV+au9Q+YtAsw55J+JJx0WOBXfuGH6DdQZa1b5qtOBzweXitgsJoLU9YR2H?=
 =?us-ascii?Q?VGbQd9YSFXhniiX8z94ls3IW8PXcqRcdqTP5VUEcFI7MmM6lOEMfxYtHH2fy?=
 =?us-ascii?Q?QBDLxYynquLyc2rAOYhOobHDV+VMTGyQ24RtfNmmpJzaX7gzaNNf65vbHGfR?=
 =?us-ascii?Q?BnMXbMWo/oa1Bq7+duINGM1f+jUDLzI2hT/m15+SlxpDz5Sy6UtRLz2qXISP?=
 =?us-ascii?Q?o+/FQSOHPMhsfRgjNyoIU0+I1kSf8KCtPuHfhsUbLG+I/9CogaGiahY3JOTo?=
 =?us-ascii?Q?uucxaZ7C9I8DPCmV7YnkRkDXAg5/f/5I9k3Ye2ULDs6UVUwArTfIlX2r5DVu?=
 =?us-ascii?Q?zDslLMT6ksOW9s0y8ZOzT0HZGDkchoRbk1c3Htu5/FAwVaj2fhF4CzX7TeNd?=
 =?us-ascii?Q?22dUtdT/icP4yhkLYiT+g+y7C+9lTMyN+cqBN++HNnWanepWwUfv0+hV7izX?=
 =?us-ascii?Q?kZnfI6pUeJqu8HJFltgnbUmWSXi8HZtJuE2gesGYHTyvXF5D3FtulWMSZT6K?=
 =?us-ascii?Q?zM6TIS2JT+KO+LKH2an6dswUxjSfeHSk6dN/DcSn8GfmTN4HGIk+SkTB84Pr?=
 =?us-ascii?Q?wH3AAbRfLUx8OPbvfw2DA3QMYnv9CDVpy8J9t/ATcfK8M0ZrpFVencgfs7nt?=
 =?us-ascii?Q?ox0soBW8D5rt/bIZAmeNQHvmESXiF52Om31rLWPsHfHPxx2aPz9z27GZJozr?=
 =?us-ascii?Q?OWqbQra4zOqrg+AyMy5+mFOxO/PQzfb2ChcdpmGIrBd3mewm7GGglt5CFUDb?=
 =?us-ascii?Q?6NPd8CA+gHD63fVLN6qyCKGJHClfZv/1qzbq4q/C/hc7J6YXeVoczGxW7Lyk?=
 =?us-ascii?Q?0y1hw20mpb248zjo0k2JrylKJ3lqWVCkOWSBsAfAfYcC4rnRwzY/+DfcvzWk?=
 =?us-ascii?Q?Te0ySti7N4/l5xEU396bJr/orspISgob3wRTmFOzpDcomjLUmOEeQ86Tis8p?=
 =?us-ascii?Q?JHac1K7zh4qgESv2KSKgiRHtSQb+Z4j+BmavIcX7c/rNUuVQaR+N8gVQYMya?=
 =?us-ascii?Q?eE+3YBI23AydtWWEA6vlGsKiH8nOmcKSz2TOQVKFaCX7D3DUj+0FFZghayor?=
 =?us-ascii?Q?DCfRwKgN/t/Yj3ENPpP0ZodFWQYs967jmUZSrwQp6MTm/bTVaLbpr+yVE2VH?=
 =?us-ascii?Q?gKZi7PNveTTW6hb1UdX5nrWQ3cnv/FtNExkNgRJnf7W0LVON2OCyB/4KLpeG?=
 =?us-ascii?Q?izT5axxKC29UeIH0ic2JdGu6GyjemKtecZJlnrhkRYj5PyrpzrOr/pcWoQ/z?=
 =?us-ascii?Q?L/+VAQQ3PpnJFtHbB71R7mxExS6WsZbemwZJnBd+xxLp3f96KQjG81nQRfCl?=
 =?us-ascii?Q?BMAth5kbg+vLKpYZd2EnDOSxb1eWNlel53Ga8g0Qt3C4qO2iWdKeBKdPbku1?=
 =?us-ascii?Q?8erd6lv2fAbnR7wlGAQVID+pIfVlzCkQ3TZxd1HQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe5edf6-15d5-4493-6193-08dc764517a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 07:43:50.0867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qd8jq0SIKf/MGc2T9RwyX+KPoQT79sfZzSEbrlc6SZjnJMitxfQADFbbvm6oSEgSKdBtnO4oXhY8CJ/VvMxy7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 17, 2024 1:49 AM
>=20
> Yi notes relative to commit f6944d4a0b87 ("vfio/pci: Collect hot-reset
> devices to local buffer") that we previously tested the resulting
> device count with a WARN_ON, which was removed when we switched to
> the in-loop user copy in commit b56b7aabcf3c ("vfio/pci: Copy hot-reset
> device info to userspace in the devices loop").  Finding no devices in
> the bus/slot would be an unexpected condition, so let's restore the
> warning and trigger a -ERANGE error here as success with no devices
> would be an unexpected result to userspace as well.
>=20
> Suggested-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index d8c95cc16be8..80cae87fff36 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1281,6 +1281,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	if (ret)
>  		return ret;
>=20
> +	if (WARN_ON(!count)) /* Should always be at least one */
> +		return -ERANGE;
> +
>  	if (count > (hdr.argsz - sizeof(hdr)) / sizeof(*devices)) {
>  		hdr.count =3D count;
>  		ret =3D -ENOSPC;
> --
> 2.44.0

Regards,
Yi Liu

