Return-Path: <kvm+bounces-22083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7991393989C
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 05:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A82FBB21AA4
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 03:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB4891E4AE;
	Tue, 23 Jul 2024 03:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b="WnLI252C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2134.outbound.protection.outlook.com [40.107.101.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723728814
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 03:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.134
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721704931; cv=fail; b=ClLoHX+UJs6xAB6aeVfdCvCoblWT3pSUIGBU5EkAM2rwTucbNSxfiQgIgqdYqQE5j0YFoIHV70UwRWxNtDC6eLIQ5+2V8thEAFoKoCna//vVXw6/sH9jFfWTNSGynjS1h+JM3N9IJIj5/+cqG9tDB0Z3zpCe2TrlDK1uYHtD9to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721704931; c=relaxed/simple;
	bh=kpSqv6ti24OCWxauFr1h8Kd29qhdW8rXTPa6GNizKEo=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QTy9ZhQoCCbWtrq3r0HLrCc4vS30l0Rm+/P2gpNXodAPoDh9LIy9swa2TKVAD14UwtGkLJ3JohbNMMlDU6e453k1CqnwLWiZjUUvHEwwtXxnLBBJgNavsrqJkNKPbBh/EZJLb6ScnfM+cR//1FMFscH1pDfY+8ZqUSC2fju5Bso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com; spf=pass smtp.mailfrom=petaio.com; dkim=pass (1024-bit key) header.d=NETORGFT2018045.onmicrosoft.com header.i=@NETORGFT2018045.onmicrosoft.com header.b=WnLI252C; arc=fail smtp.client-ip=40.107.101.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=petaio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=petaio.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSgxEGiBR/vh8924AVtSLSMLLvhLrOL/hgBHcQshFhn5iMOWEGxbvvYhP71jx0ATfexCYd47u1aVZDiTweuxVzDvZuAev6s/SqNeKVBGx3dDMr4mQUarMjjDWbC/XzCQNqmrEvz852msIYd0eZ9RUM3I3V3nwdYVLFIbBOT5afWcEZfJMcuGUbMBrNFiNBjj4MqXRdvQ2B7R1fHeeIdEjvkzrKt7nOn+aA3BYmvmcjSS5JBCsK+/psPuvPVf8lQnxBWeo0U3N80YiTvXhoTEBJz0AhJIw5yO1DSnwzeXsWQBGv5SNDa8wCuW0Sl5L2yPpg4pMk+AQRqyN901wgqp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK2zE17+8aHCEJ6FzDgE73bJCUwine0685JBZQqjL+4=;
 b=va1nKVr9xGsfKpa+YE20TO9CVQYqSnzQbVvUZwWd+Abb3GtUiJvtj/m2Tz0g4KKubXj+Kr3hfB4gdeOHWCZdu6D4IaPn+tpfbu6KziEQkm6ywXBTbBTuoI9kgl0PrjlZDgJ7L0IBJKdr0UVIpfMdH1Sv8pyxX9o9oxbk7rwBm4DXZ5BBa1EKzXdTDvnZkh+HaA8piVdCZFrwpoBBvQx8TS7x4s5T+UMuH2ivqt1GUkrSNPoFxtFa9Rln6OhKThzpZHt8Oc+gf8Oc6l9xUcOCvntGUZWb+5u1R64lUY3Y6mBJBRVPCNSYuPm3ObcEX04x2CI/ichw3gOFBxBZ5pio0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=petaio.com; dmarc=pass action=none header.from=petaio.com;
 dkim=pass header.d=petaio.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT2018045.onmicrosoft.com;
 s=selector2-NETORGFT2018045-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK2zE17+8aHCEJ6FzDgE73bJCUwine0685JBZQqjL+4=;
 b=WnLI252Cnl5tTHRg/Tq0+VyOQSbRpKiZIBWHWbkU2g76+eVzbcc9eOpKXG+rRUOfF1B4IxaEeLm4gm+QIfNYx/cSqlqJdRQK0P6iSs8aJo/SnEAExrMvqef+pb1NpoAdRuwfSIPTYzv5PhXxxDb71YBwtGbPCCvVfmq9ehsAmtE=
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com (2603:10b6:a03:439::9)
 by PH7PR18MB5574.namprd18.prod.outlook.com (2603:10b6:510:2f0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Tue, 23 Jul
 2024 03:22:06 +0000
Received: from SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310]) by SJ0PR18MB5186.namprd18.prod.outlook.com
 ([fe80::e130:2c25:8cf2:4310%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 03:22:06 +0000
From: XueMei Yue <xuemeiyue@petaio.com>
To: Yi Liu <yi.l.liu@intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "joro@8bytes.org"
	<joro@8bytes.org>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject:
 =?utf-8?B?UkU6IEZXOiBBYm91dCB0aGUgcGF0Y2gg4oCdaHR0cHM6Ly9sb3JlLmtlcm5l?=
 =?utf-8?B?bC5vcmcvbGludXgtaW9tbXUvMjAyNDA0MTIwODIxMjEuMzMzODItMS15aS5s?=
 =?utf-8?B?LmxpdUBpbnRlbC5jb20vIOKAnCBmb3IgaGVscA==?=
Thread-Topic:
 =?utf-8?B?Rlc6IEFib3V0IHRoZSBwYXRjaCDigJ1odHRwczovL2xvcmUua2VybmVsLm9y?=
 =?utf-8?B?Zy9saW51eC1pb21tdS8yMDI0MDQxMjA4MjEyMS4zMzM4Mi0xLXlpLmwubGl1?=
 =?utf-8?B?QGludGVsLmNvbS8g4oCcIGZvciBoZWxw?=
Thread-Index: AQHa3KxuuhkrPMFLEU6ok/qWEqHOQrIDoT1Q
Date: Tue, 23 Jul 2024 03:22:06 +0000
Message-ID:
 <SJ0PR18MB5186AD98B2B0449BF097333FD3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
References:
 <SJ0PR18MB51863C8625058B9BB35D3EC1D3A82@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <SJ0PR18MB51864CD07C0F5FB0AA23AC05D3A92@SJ0PR18MB5186.namprd18.prod.outlook.com>
 <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
In-Reply-To: <903517d3-7a65-4269-939c-6033d57f2619@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=petaio.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR18MB5186:EE_|PH7PR18MB5574:EE_
x-ms-office365-filtering-correlation-id: 8ce03ef8-609e-4fb1-28b5-08dcaac6a134
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018|921020|220923002;
x-microsoft-antispam-message-info:
 =?utf-8?B?L09VWDgrdVMzT0tPNDhHTkp1dmVlZHhCS1dmcklrL01JVlRTWEY4a0haa0Mz?=
 =?utf-8?B?ZHhUVFNwRlhHdnJEa0ZNVGI2cC9kQzlKWURoNks0NG51M29uSWc5WVB5YlND?=
 =?utf-8?B?SmRvVktIb013WHNtQ08ybnFuclJqbDlJUm90V3EwUVorU2tGR0lpTXlaTFlJ?=
 =?utf-8?B?bHcwY2dKRTVzb3ZHSHk0TGVXVWwzdis1RXk5SWF1RlBlRUNQQnI5OTVXbWxm?=
 =?utf-8?B?cnFuMlJkREFLenZQMGQ5b2xWTk1UcFJpbnJBS3JOUzNyU2JnVGRINzRvQ0dq?=
 =?utf-8?B?eUVqR1I3WFJNNTFlSzZvUmlwanoxUzZuR1pUY2IwbmxOcGpKTTU1em9VeVBx?=
 =?utf-8?B?VXN5NVlCNUVIeUNNckVVZVNkdi96WkhMcGZNVWszYi95aS96aU9BY2IwVXdq?=
 =?utf-8?B?dEx5ak9BZWx5UXBCK0hIMlFZVENEZkRqU2FPd3FOYWQzSFJtdUtId2ZYeitm?=
 =?utf-8?B?K3BtUy8zYkQzRkZwZVZ2V2lCRHRTYXJIa1RmalVONTlCMXpxNjNaUXhqWVpn?=
 =?utf-8?B?QlpPMnQ0MHhTU2hRVkxJb1RCZCtsZUFvbW9DV1cwQXRQbTlBTGt6MnhWcXJ6?=
 =?utf-8?B?Ty9XRlpxVm5uWTlaZU04dzZROUVoenYzaXVhamx6MDRNWDR0R0xGTm9zRVBY?=
 =?utf-8?B?MkJQbkFNKzhiSlkzclluRW92NEtLSmY0clRNd1poWXU1MjNHZmwwN2ZEbWpo?=
 =?utf-8?B?b292akRET2dFS1V6TzlKNmJ5YnZwZUJvUDZydndDWXJRSnUyb3orTnNEamN5?=
 =?utf-8?B?NUoySXlvT3BDc2wwZFRVWVJmUVRZbHA0a1VSRmdhZG8xd3E5U3lNRGFUSEJX?=
 =?utf-8?B?eUlrdnRJc2VRN3JvTzIvekkvYXBXVDVMWjhXS3VzRTFZdlpZcm5SSEUyT1hv?=
 =?utf-8?B?RXh6cDlqTkF4bkdZUlNESzJnN2MzZURHa0lhREp5cjFLbkp6QkZyUFU0Skdl?=
 =?utf-8?B?UWlaNVpBU3N1NW9ZV0pRcVl6dmVnR0ZKdlRrVzZ4QlhaRHlxT1JTUCs3NllN?=
 =?utf-8?B?VDFoWUJ2dURjaFVpbzcvMW5jMHF3MUY5OXFXWmw1bWFRaERONFNMYmtndUtH?=
 =?utf-8?B?eWtkaFhtOG1USHc5QW5ZWU9CVFNXeVBkRUxTeit2Uk9oL2NCaFlYWnNUbCs4?=
 =?utf-8?B?eXN1VE40WkRDMUdlMmdodHBpRE1tRWdEN3UwUC9OTGxEZExlcForS0xzZk9E?=
 =?utf-8?B?V1JOWnhqSDd1Rnp1M2ZMVlNPaVRRTGxLOXNUeEY5dko3RGhVM0IwZnpOaFl1?=
 =?utf-8?B?VjRjamExV1ZyQjgyR0ZWeW1MVEtjUC9jNFZPNE9CK1JYTXo0dXN6QXQvcEtW?=
 =?utf-8?B?ZXlkZkFiUDIwQzJNdmg2M00zeUI0TnhPc1pXUE9lemNPTklZVm1iVitWUVZL?=
 =?utf-8?B?NjIrZmxrckppSE9UeWpZclo3RC9rTTRKc3FHUWl0S280VVVCN053T0d5YmM1?=
 =?utf-8?B?VlBOYVZxU2NVRlgxcXViT3ExNG5tTzNGUUN6YWFrYzhUa0JnOTVZREc1S1Q4?=
 =?utf-8?B?bzdQSjh2M21MZm9nM3dFNm9jZU1oMmY3TTZHL2RtY2s2SkxUdEloclFHRGNR?=
 =?utf-8?B?TGw2TzVyb3Z6Uzd1MkdhWGh6QUZmclNJTjhMd25jSHQ3UlZvNUp2anZieEV3?=
 =?utf-8?B?ZGt1dVdkK3pYb2w4engxclRRajE5QzFDbk5TZi94K0VSZUFHTzJYbHZWVFJ4?=
 =?utf-8?B?OWJZUmZaVUV6VWxaOXFkb3JLOG1oM3hiQVNEcFdqUCt2dVRLOTBmcnF5WjBl?=
 =?utf-8?B?N29iQUtpOGRVUW5EditvZ09Gb0tEY0tkUHIveGIydmh2SEpBUjBjZ3RNSkxt?=
 =?utf-8?B?dHVWTUxVaFlia0dCdUJEY0hSai9ZM1RDNXFpUjNZa0RqcjdJRzlPSVFNWkht?=
 =?utf-8?B?S0lSMzNQOTNYb1BCVkg2dzJkdzRFL3FOdXI4ZUdYejk1aUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5186.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018)(921020)(220923002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXpQcm9aRyticUgvN1haUGRnSWR4OU1WcmF3M3IzZmlRaUppVUErQUN1L1oy?=
 =?utf-8?B?LzJvaWpsUjB5SnkxS0lmUHorZGtHSlVSU292WHNQR05QYUwyMFcvUWsyNVNK?=
 =?utf-8?B?Ry9aVCtWczhzYkdwREp3OVBHd3Y2Si9TTm5PRjhQMndHVVpYc1NVbTRJTUpN?=
 =?utf-8?B?KzNNTnpwTGhVY1g4VU1FRmxyQWdoZ1JrMkJCOE9XOEhNSjVPT3RzVjdWMS82?=
 =?utf-8?B?NmNFTUhzMUo0UlRVdlhwOVphdXF0QzFDeVlHTnJZQWlVMWg3aFRIQWl6eGM2?=
 =?utf-8?B?SXhFV0pQOG13VGZ6SUZGRTZBTmdaV01OaUllbGhLcGhBbUVHR0l3VlhYQW1Z?=
 =?utf-8?B?cnRnWXhiVFZNdng1MlJqN2VHOW80R3BRcHcvaXlESUVYdmdaUlcrRlo1M05F?=
 =?utf-8?B?Vi9lSnZPOUEwSFlERkNKL2tIaHkyemxFc2YySkExQ0w5eW1TSUFzTEJCaGQy?=
 =?utf-8?B?VEQrN2k5OTlEU285N1RPSmRoMk9IZlRtZVdTa2hKbFZncmRoZjFheFYzZjcy?=
 =?utf-8?B?TTlNejNLOGpkQ0RCcEFJM3ZtSEFsL1hXc0YxaVVuTXY2SmJaVUp0dndkYVo1?=
 =?utf-8?B?U1lZUnZnaGs2L3RWbnpkV3JzSStmdzl0MVowTytIY2xYT1FQc3gxczgrYU5X?=
 =?utf-8?B?Qi9TbWhvR2JDTy9YWTVpSlJsazlzRXdSM1d5TXYwTDgrM3AxMks1OTdkc2d2?=
 =?utf-8?B?bTVRdXNEcWs0ek1RUitrajY1bGFialZDUkRPVlcrbHlVZmp0dlQyN1Y3NjNo?=
 =?utf-8?B?S1ZjLzU4UVBWU3AyYWJFa1NhL2pHRnRtRXJGWmdHQ2RPRmZGTjZqQ2dtY1lF?=
 =?utf-8?B?bmo3dVFSaExlSkEzUHg5Z1ROa2lJZC9sZS93emt4aUhndE8vbWd3Q1A5ejY4?=
 =?utf-8?B?d25UOWlNeDEySWl6VUF0dXZVa3J6cVZvSlZ0dmhnOFovRFVZUm05bWIzSDNY?=
 =?utf-8?B?NHprSEwwa0toNENsT0ZQS1VPWDRJdnY5RVVuNXc3TXZuZnVlMDBDVU1iZ3Iy?=
 =?utf-8?B?NFF4Tnc0eTVPTk1yd0pYTGJCRkxEeGFIRFY3emdsV2dSdkw4ZXZnRFh3eTFP?=
 =?utf-8?B?enpyS244NDhUWFowVmx5SEI1NkJWV0ExSnJkNkVmdVlCODdNY2g5RGUrbEti?=
 =?utf-8?B?UHVOOE8yQytJeDBXKys3YlRpcldoSzNLc2tiK0N4Tjk1NkhTYlN4S2R4azNz?=
 =?utf-8?B?emNLaG1rYWgvalI4MFZnbUNGWHMvamswNE1LODRFcE9SNHRuc3FxMWpoR1Va?=
 =?utf-8?B?Tm9ES0JQc05VQ042VlFqUEtzQmVHNmpHdFBOL3VDZUN2ZUpPSmR3T0RmTFlK?=
 =?utf-8?B?clhBM21XNnNGcVQzRGJqbDkzQnhmWHhlaHpmeUhxdi9aOVJvcFhtM3hKR0Fk?=
 =?utf-8?B?T1hXOU5xd2h0dUJ0MEZ5YzJCT1E3eTV5azlsNnkxc0JvUWtLOEJIRDNadmp0?=
 =?utf-8?B?UlBoTVdmZDJYZ2c4cm5ON0RxaVhBaEVjVlB4ZFZUejZRRW1vaFl5SHh4MWtJ?=
 =?utf-8?B?dndORWpvd2xZUXozNFkwUEpGeVplRzdtOVlTY2VPWlkrZVJqQWFPZzdRekJM?=
 =?utf-8?B?N0g0NzU3a2JreWRmVGorWUxZVzl3YTA0RVh0WTNDaEdhWWRRWUFVSDE2M20v?=
 =?utf-8?B?d0kxMVFtVERUdEdJL05tMndtOCtDMjdFTDJ0clczbUFoZkJYRUthdUduRk9U?=
 =?utf-8?B?anA1NkZVTExRUUZYcDNYM0h6NEI1eXJmTjJlK1FYa1dmTitOa2xhVUNvVFZK?=
 =?utf-8?B?OWJ5bzArKzZWT0hLb2NoYXg5L2ZNQjNHM0w3NlpXZE1uVUN4dGxNWjNDRGhY?=
 =?utf-8?B?QThhWnoxaGdpd2tlVWgreU5WVlN4bSt1b2RtZ05ndFN2ZVM3UE5tRVJkUG1I?=
 =?utf-8?B?dndjWHUrUFZmdlNDMmM2T3BRUm5jSXIzNEV3RG53SGNRcFMzdDdyd25RWDhW?=
 =?utf-8?B?eWNKeDdEOUI1ZUZ6Rk8vMDlOTDdacVRIZ29ndnJqT0dhUVFMQ04vRGdZOFFa?=
 =?utf-8?B?Vm9ZSndjTlJvakJVSmh2eFI3RlVpY3E0QVQyMmdiSTN6bFAzdyt3V0RJaDRO?=
 =?utf-8?B?dEpFYm9jaFRwNTc3UVlsaEVQR2MyNm5mV0JFTTdQaFRiRm9HNlJoQ1FDSkxF?=
 =?utf-8?Q?EHfCWJrguWlMRPFY18FrPgwnO?=
Content-Type: multipart/mixed;
	boundary="_002_SJ0PR18MB5186AD98B2B0449BF097333FD3A92SJ0PR18MB5186namp_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: petaio.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5186.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce03ef8-609e-4fb1-28b5-08dcaac6a134
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 03:22:06.4445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a0ba8444-51d8-486a-8d00-37e5c68c7634
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6zZYTD7+h/V6P3RBC8bAIdZd3LbS6rofaEiyJi/hy6oqgobCXokxBo209PkGRx2AbO8AiFBni2FirZ0ZIw3tng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR18MB5574

--_002_SJ0PR18MB5186AD98B2B0449BF097333FD3A92SJ0PR18MB5186namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

VGhhbmsgeW91IGZvciB5b3VyIHJlcGx577yBDQpNeSBwYyBoYXMgdGhlIFBBU0lEIGNhcGFiaWxp
dHksIFNlZSB0aGUgYXR0YWNobWVudC4NCg0KICIgSSBkb24ndCB0aGluayB0aGUgQU1EIGlvbW11
IGRyaXZlciBoYXMgc3VwcG9ydGVkIHRoZSBzZXRfZGV2X3Bhc2lkIGNhbGxiYWNrIGZvciB0aGUg
bm9uLVNWQSBkb21haW5zLiINCiAgIC0tLS0tLSB4dWVtZWkgOiAgU28gaWYgSSB3YW50IHRvIHVz
ZSB0aGUgUEFTSUQgdG8gdGVzdCBQQ0lFIEFUUyByZXF1ZXN0IG1lc3NhZ2VzLGNvdWxkIHlvdSBn
aXZlIHNvbWUgc3VnZ2VzdGlvbnMgPyB1c3IgU1ZBIGRvbWFpbiBjYW4gc29sdmUgdGhpZSBpc3N1
ZSA/IA0KDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBZaSBMaXUgPHlpLmwu
bGl1QGludGVsLmNvbT4gDQpTZW50OiAyMDI05bm0N+aciDIz5pelIDExOjA0DQpUbzogWHVlTWVp
IFl1ZSA8eHVlbWVpeXVlQHBldGFpby5jb20+OyBpb21tdUBsaXN0cy5saW51eC5kZXY7IGFsZXgu
d2lsbGlhbXNvbkByZWRoYXQuY29tOyByb2Jpbi5tdXJwaHlAYXJtLmNvbTsgZXJpYy5hdWdlckBy
ZWRoYXQuY29tOyBuaWNvbGluY0BudmlkaWEuY29tOyBrdm1Admdlci5rZXJuZWwub3JnOyBjaGFv
LnAucGVuZ0BsaW51eC5pbnRlbC5jb207IGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbTsgam9yb0A4
Ynl0ZXMub3JnOyBTdXJhdmVlIFN1dGhpa3VscGFuaXQgPHN1cmF2ZWUuc3V0aGlrdWxwYW5pdEBh
bWQuY29tPg0KU3ViamVjdDogUmU6IEZXOiBBYm91dCB0aGUgcGF0Y2gg4oCdaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGludXgtaW9tbXUvMjAyNDA0MTIwODIxMjEuMzMzODItMS15aS5sLmxpdUBp
bnRlbC5jb20vIOKAnCBmb3IgaGVscA0KDQpDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQg
ZnJvbSBvdXRzaWRlIG9mIFBldGFJTy4gRG8gbm90IGNsaWNrIG9uIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGF0IHRo
ZSBjb250ZW50IGlzIHNhZmUuDQoNCg0KT24gMjAyNC83LzIzIDEwOjUyLCBYdWVNZWkgWXVlIHdy
b3RlOg0KPiBERUFSIEFMTCAsDQo+DQo+IE5vICBJICBoYXZlIGtub3cgdGhlIHJvb3QgY2F1c2Ug
LCAgdGhlIGlzc3VlICBvdWNjdXJlZCB3aGVuIGJlbG93IGNvZGUgcnVuIG15IEFNRCB0ZXN0IFBD
Lg0KPg0KPiBTbyAgY291bGQgeW91IGd1eXMgIGdpdmUgIHNvbWUgc3VnZ2VzdGlvbiA/ICBXaWxs
IHZlcnkgbXVjaCBhcHByZWNpYXRlIA0KPiBpZiB5b3UgZmVlbCBmcmVlIHRvIHJlcGx577yB77yB
DQo+DQo+IFtjaWQ6aW1hZ2UwMDEucG5nQDAxREFEQ0VFLjZGMkUzRjgwXQ0KDQpGb3IgdGhlIHBl
b3BsZSB0aGF0IGNhbm5vdCBzZWUgdGhlIHBpY3R1cmUuIEl0IHNob3dzIHRoZSBwYXNpZCBhdHRh
Y2ggcGF0aCBmYWlsZWQgYXMgdGhlIGRvbWFpbi0+b3BzLT5zZXRfZGV2X3Bhc2lkIGlzIG51bGws
IGhlbmNlIGZhaWxlZCB3aXRoIEVPUE5PVFNVUFAgZXJybm8uDQoNCkkgZG9uJ3QgdGhpbmsgdGhl
IEFNRCBpb21tdSBkcml2ZXIgaGFzIHN1cHBvcnRlZCB0aGUgc2V0X2Rldl9wYXNpZCBjYWxsYmFj
ayBmb3IgdGhlIG5vbi1TVkEgZG9tYWlucy4gU3VyYXZlZSBjYW4ga2VlcCBtZSBob25lc3QuIEFu
ZCB5b3UgbWF5IGFsc28gbmVlZCB0byBjaGVjayBpZiB5b3VyIHRlc3QgUEMgaGFzIHRoZSBQQVNJ
RCBjYXBhYmlsaXR5Lg0KDQotLQ0KUmVnYXJkcywNCllpIExpdQ0K

--_002_SJ0PR18MB5186AD98B2B0449BF097333FD3A92SJ0PR18MB5186namp_
Content-Type: image/png; name="pasid.png"
Content-Description: pasid.png
Content-Disposition: attachment; filename="pasid.png"; size=4104;
	creation-date="Tue, 23 Jul 2024 03:16:56 GMT";
	modification-date="Tue, 23 Jul 2024 03:22:06 GMT"
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAAhkAAAA+CAIAAAAJTp57AAAAAXNSR0IArs4c6QAAAARnQU1BAACx
jwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAA+dSURBVHhe7Z29buM6E4aN7za2MbJpTu1yOwPB
VusrcEoXaRanc6vW3cE2KVzaV5BTBQHcpUx9mk2QJvfxzZAUNaRI6teysnqfJrEoSkPOkENSEmcG
gGB9+Pg4rM2PPw8u3nO2ML8AAL3xP/MXgD8bdiMfu+X7/mf2Yg4BAAAAAAAAAAAAAAAAAAAAAAAA
AAAwZhbZ4flD83zI1md6hbLO66elc9TbOIZo5jpXLtMuV8/Y8sk3VxeL9eHZauT54GqEE03SIfy6
q7poL6/CFpKUamqR5RLWrMQig8Yv16dH6zJd7wmjG4U9ejiGSPoam8J8m7LV7yS069RIH0KXdaw3
bADROmwvPJ8wNlNhuAJsxVC5KxpDe+q0leg5ycyxRK7yeGnqyHN2WAhfRHXMWhCrRJyiy6TSvJQc
42p6UCOPMdj4EzWVSPJRLcSeqy56+frvEaUN6jWSFd9PVQ6EKpG1Q0d940ILKqtdSrtY84+G7cHX
Rg3rVVL4BlBdh62E98W7BP73JYvsjl/Bvz3qd/Bfjrer+9/q34twvP3y5fZoftRmyFxD8LpffbvN
rEr+2b/Pb35oY1r/vZmf7nWam2IghV49bffv5mcnXrLbb2QZZ/k8gyxte5ot75q18BGzuL6avT/d
v83mX/8yhz456+/LWW5rbAzfVvtX9e8n4+WYfdue5pu/G/S9quyP0d4hZL1BA+hchxHhj490+++X
dSaeL1n8uJm/P/0re4uXoyk4pa6LxS85qVNOMYsttcRyKa4juZQr1jRwt9FcLOHHx8NmPptvHlS6
OCN5Lx4HhCV0pqrheSel9NA3HrPo13XKXl//M79mL/8+uc5kkf3avN1n9oRKWGops//7nPz36no8
M9bKLUSYjrsI60rnpDlaaaPKKi1HMS0p0MYLAUm+a3NQk0hK1cYw5WJbc3nJMtO7dugBWuirBxr2
vRWuhPGtN2gAqTqsT0j4ETgTz5f89XU+e/sd6bnWP77PHn9+Uay2T1e7B9H1Ljd3rzpt9XS1eSj6
n3a5yGPzUXL2TYjm4jkH3YOG5+/7Ff9L2DlI4l7rw8OOOmOVRUmYy06d9G5pEr58+fk4+/5jKD1K
f5/rS3c0fnNjTzLb/9PEVj1vFBhbnA8ujM/V3eG7sZ6fj9dKLnJvD5urJ131vrEdaMAwK9RyXWil
jSrba9lWnNfGHeF/vt5tliYhmZQTqI3hysWmMVvu+IFdtl6XvU+bHqCNvvqBu/6r61IhwtRwJb71
hg2gqg5rEhJ+BM7EgUehgbF5GDNQMv/JwWtqMNssV3G2RzSBiSWm5Arl8qtD5PeF74vK67on5DLn
Rx2J6aA5M11wF3luJF9+1wCJJB9HVh4o8/hT3kwdKV3Ml0n8dq/o4CeJXHybQCGZRFIacTvnzuK2
Cu+8SJIiXhvyqLjKWcrFMwy6o4bmEea4f0G/MBI+tyhyuUiKRLlqUC5f6VZNLhg6171gyXpFsn/r
WB3mtBU+eHBI3HnJy+83818Qno7aSvjYOeMmOZvhyxSLhO1yjQEeaogVJCkhjQLe1XIZjTB4iWAY
FZK57Jan7bfSmhfPu/KjRuL1gU69b773lJiZDDAroTGa5mF3ddquSiWT1a/xp85CKZwUGT62U2Vb
LXPF5ZLooagZMIaENySSLOHaGK5cvFp/+03N4lfb/ft8uRM9XPMeoJ2+RkTUeqMGQKTq8FPjrXEl
Zn7Uj/EUPJ+P1lx/apdrRKgmlyMc4fGWzGG13T49za42u4eeZ+AhVFW+bVfy/YCKmXpu6/ZBUR0p
rTMZwJXMTltjF+QL8xc+JLKD6koLVbbTsupJnMrvafUhXBuDlUtCPeLPfZ1lovY9QKxcveC77lbE
rLemAdSuQ59ehO8dz5eIQWnOwizrqUGEfQOBjruPkWSFiCfC7XKNBO6phbloZFf+cjxmNMjg5zBn
XqpULXK2J0fiWJA3XJO9v35EpLEPimq9p2aMIBvAlbTAd5/CbDgpoocuqmysZTWots/ldO+pRQ4J
b0gkJRiyXOssuYISUUqiB+iir47UeQJiaTwpihtARR3WIyw83/SiDsbzJbOX7P403/zKn+Mu1oeH
O/1CiVa8qQk6/ou9bQFlytMySso7oWa56q/JGDPUeeuibML1lEm4MngKmmfglc5Mm776zxxXo5CS
F6Ten8YkvSxg5o6kvLY149eAl3dalAW/INxH76+cyWbTz8X6RgsXNDbWF40GrcJIX0ZdLVVZreUQ
3NSdmjs+nozdmeYlhVf/EYmkBEOWa/Z182BftaIbiZpnmvcA7fTVGbrWMwcfqP9SCiuw3jBCkTCA
ijqsJip8I+84HM5retboqBjyMP3K10zUf7E3Alvl4jQfbx5eCGn76+pcomQ2JZ2LjVjI7xi3LJc5
XNDOl7Awfp6QgI6EwSqUsCyNJIkIX5bEU4o6wz8WQd0jdW78Wq6BukI6aVZdTAtVVmo5QEyF+TFh
uAe6vKPKeFKqNoYpl8mVZ3PyKeEa9wCK5vpKoO1WYmrdSah5MUmp9hPWK5WdY4/F67Cb8CUBPyl/
SjlGQMgOPxMwhUny56ud+/MRl3AMCvDXuMDlUc8cP51D0YOnvh+RAjAK1KLbWHdl4N1KTtseHydd
DgxGAZgy6AEAAAAAAAAAAAAAAAAAAAAAAAAAAEAN/K+AvI+iFPwqSvlVXP7OKs/LuWxqhw+L3C/t
mn411Z2y6MSo3kGuo68UF32tyAhf3L90oD/qVNRwhl2G7122LHUlWR019FVLpWfRe+Jb4ETSBJnQ
9yV2e5/V9m3pRFFh1L4H795mZBxDwW5Lt+LICzacmQh6YnbekTucmHut7l9vdiKSA0Hm/nCTR2xY
3c82d/X3dOkTf7OjwP4sFyatr9Fj99xQm5Sck3EYdhDeQCW8k1W9XVvisD+qvn93FtkvqqktVwS3
VlnmRNIkmeK3ihcMqDmyEMifg+bhey8fbvl0OhlnQq6EfvUSI7mKi0eKLcE74JUp7UI43vDYiRjY
leGxp8ZEv3vn8ZKEx47v5w+oaW4jWhFZoWnRlCr2H5KrFWrmHg2Ayujlh37GRXw3cSX3J4mYr4yU
J/zRjZWY0rpGI3x9mcWMvE7s/cQ6jHsvfxgbGNZ2k9Dn8VE7E3YlT4+ip45puaLma3Ihw47C8pgd
cqk4unqVe9PTkqi+GGd3siJisbpQEUZB4WTusaUIURm5jXoiaaJM1JfwyEhg+3infbB5cBCCZ7LJ
fgJqJreFbhfMuHdoqrSnCbu+NwfUonmUWeRIhE2lBh4LttoHnr4UoYC10XDLXlMPOPW+IVMiS1qz
K/lXLOcktJyo+dpcyLCj2O3atf+yIphWENUXd/qRiMXJeNt0iztjFVSZS7t1cUvyBsv+yxsfJZIm
yhR9yYLbqdwUmlucsW5uH0Wbo8n/dk92vtzsdjveJEv07i0ojwclx+zWRnl4OartuItRX9GtvHD8
HG8EpJtko0ceeaAeg3RO6g7L3SFzozjy+tyMd/1RP/VJZjnFTVLiNx/nRinpSzN/eyzWCrOqsjvO
ZABXop3J3R27EnmfpJYjNV+Xixl2Ar4vwZKc9vt39j3UC1c+LVEacm1e/VfN+9M/xkLZY/oPa1q0
lJwrMzUKPP9JJE2ICfkS23teLKBmePXYwnN6O+X3dkk04zhF49A8Ibxn727roha3PS03m7ncMI4H
YrIPEGJwUjh2gl6QIHRwuVwFdeZVUX0ZKvsjF+FMHFfSQcIKyJnM554rSWs5UvMVXN6wE7CVkAMh
Czk9Zr/fyGDSIypDPurPqWg6giJX/TyVBGJg5ySSJsaEfInoPS8VUDOxKmDm9PkqUXDePyD8dJbw
hW0cNlUvSBC8JlGooOQYAsT0lSO7mjpYZ+K4ki4SViG7GU0NLUdqPsEIDDsB2fz864/rK+5n6f+r
6x90sKnuLkWiwSaSJspEn5dIuEkMFFBTjI1zuoVAPhN6sX4llu8Jbjyi29LowTMnhbqpcWFq/5Kx
hyu0HKn5lgxo2AnUxOTmZs7ugzQwu6H/q63X76lrTWb6R8y9GTkKSSRNFPgSbhKOEfBjStPh9x5Q
0wRiLa7ZMQSyoeHbKWnoYmax3izfm+smwqYmgq2OCeVM2sQeVutgfVRvWsuxmm/HoIadgMo8n8+1
16EOmP6vMS0xDSWvKZZQ/WdRXbk7LKtD05aSiIF9lvDYYOwoCwoP87ib8E3LHuPusljcdl4x1EYp
MVdxEvhFGffaROS7d+paxGH6lYus/uvxneCy6ESeWXWbsqqcClIVojOUypZ+J7gRCX1pispxUMJ7
OKc1qyiLum6j6nWFE4eiWq6o+TCJigrltsfOY9hhVL5cEueHLrJHURrnnWAvYjEh7E1WoTjJ+8no
Qvj1kqTQWKnlJZIAGCGBJgGGxHbBAIAYWOMCII16MHDfw7N4AAC4IJiXAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAD4//vdXoW/p+G2p8mcE/DVSnpdz2VT/kjarkxD8pCvyrWIMLZiml9e5yqITnb6fiL9p
1rvwCfovV9/UscMUeKMPgMui2rBthOpjY79N8rFnchtO36MO5r29exGDPkN2CPI03mrCS1cZiu0r
Dm4qZ471fpyzl44kWJBOVIvWm/AJ+i9X37gSBu0wyRC1CEA7pvitImL0gjHwGWMPAxBjot+98x57
ErPLpxN9LrA36Rlj9KoxqtoYPBJ5NIUa70YnNE3QI9/YNkNyO67SAs11m82JeOaWyNXjVINLJmrI
/ZkSI73PWDcJfTs0E4+8JosJrFKwwr0XJ0i9+7+JHusQgDgT9SW8HbfA9vGOM+FtZTn8wyAxenUY
jWjk0SGJRjntPYpwIuhv7yD2MADnZIq+ZHGpUKZnC8Kgu5pG4ZtsMD6N7PqjUU47RBEOkQj6255E
ucxG7og9DMAZmJAvsb3MWGP0DooX1Ur6oWLm5AvMyz12saVzFGEVq0lERSpy8VKPonnc3ES56A6I
PVxrvghAcybkS0YQylQsd30+FueIIhwO+nu+uLn8OgXhKwGxhwHoyESfl0jUuPTiMXrHjxqk9xlF
mD2r6Fg1Z31GhNjDAJwL+JJBQ5nGY/Rq1PqK62wspmMLpenXfM68fKHvb+5BknthU72Iql7Aj5Dw
iaC/54AqCbGHAQBdSLwWycvKfidsj3G3UjwgcN4W1d23xFzFSeA3wNxrE8nv3gORRy1FmidxM19S
Fp0wmbno4rbuT3IgQnD6lSeq/5JRhGPCqxrWh8OV1YBUuZSIToXyAStJSgxHXZ0E1BL6WpW49W1R
wns4pzUzAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPxhzGb/B2/oP/VrEbc7AAAAAElFTkSuQmCC

--_002_SJ0PR18MB5186AD98B2B0449BF097333FD3A92SJ0PR18MB5186namp_--

