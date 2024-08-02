Return-Path: <kvm+bounces-23006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C406945834
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 08:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AA92B2337E
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 06:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7C74D8BD;
	Fri,  2 Aug 2024 06:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iNEuiiJw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2002A219FC;
	Fri,  2 Aug 2024 06:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722581476; cv=fail; b=PDuPidowj48ggiVEcU5oeO/YZj9zpqml2VsZEbxHzh3Hss0PDBFe6yPCpcqWJ8xIYsAt3ubx/btXWDKbd+vEl4XXoI4cKS9Oqd5U39BPVUU8tmXA6JpMltdz6IfRfDScGl9fKnBNuKdpHGTRHTb0za60OVv+S1ulcPuySS1vX88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722581476; c=relaxed/simple;
	bh=wR8PJWg1KeQBiTnR6jFaKc2L6MUNRD4CVd3VvpKyKT4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=REuTNtexlp8yhlQhZ4jDAeJAJ1U732qARgf+V/OIjKOt3g+HYmQWJoIu41soucAQRqIVbGNka+eaigVdhvi8rSDtA7rJKPRsCdoVrMp5nsY2LwURRhJvjeRoLcbG4CWnAn0FvfpjdIavYAxBSaEuxihEQSG+RbefbFA0KfLyZ/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iNEuiiJw; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NBGDZNVrzi7gRdM20cn4ff55Hrxr5yhVDfYlp2391Zpmy61yU11Qa4wEMWAUQ4CFGher27mDEKYy72UacDNeoS99pgk8X/tjLnSSYho6hHRWiztgJ7/pkK4LpZ8c2vQjm+DFIdFV29dCUVm273CF9+RQACzQQo4zpQ/RP6ZP4VQFyA+28vFV9V1mSsqgvAsbpc52++NnPCRQbA7osPxfQxCLke7eVImKdYqYKSK+LzKcp/EbvAuI0RQhQi6yS6V0occXD/T9g+7j4UiD4nj+deuZFjWEWSZxtRwj3SNUcrK6XmllSojbixOhD0aQ9f2ZhIzng0b+vCN7v6F3tPpCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wR8PJWg1KeQBiTnR6jFaKc2L6MUNRD4CVd3VvpKyKT4=;
 b=Ms7eQKt+bsyb8fXyneufXSvPjjQcB3VlYyxfAjWBxhEAiLlhHFOtOMkOCoa48FFRBqGkP5w63jUrk5hQEbKL/nv1nWsAJVqRrG118GyWBwy6V3PDXA+MOBNryfKP/lDu4tiwy+hqnbUlMEX8txb1T+dypm1EQs9bITehydQUOwfwq55INo2+rMyhnXKqiwaJDTkc4rhAQEa1nY8KqpcMqMJIy28yjK9J4rizxt6uxuNppGS4nXlknDnSn4KXhcZACAlkJbsTXzU7o4/x+jX8fxV0EaTRKwpqeXC27oawxe0AJMFTtr/bqp2QiA5lC7Umm2T5k9R4NXcex+6tZVlZVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wR8PJWg1KeQBiTnR6jFaKc2L6MUNRD4CVd3VvpKyKT4=;
 b=iNEuiiJwFCKe1HdAYEDsqPYNzflkxqx6hWfX94BADfAUyM8PjLx+sMxd4HIqUCUikK1+85zxUrrMgmYE06knp9FRwoCdKqWmLRdFv+IrL1uY3YztXIU7GtRtzMQKa+Qe68lJTK3LVfTqwZk+/7jONQKrmF+1xY1Yjue1KOU1fNU1WA+lmtGJ9p0g9P87s84MjEVqALnnwfLmUHprbB6k7orDu1W8LVZxO+LiHLhOsKP3hbe2ydQj2PX9YysE0JsY84uckV/Z/9sPgTHgUUT6OJLwlYZAXwNoQD8XW+1uNBVUapXezOULH76KF+jSRZJnWXl8X1ISAQnDOevJtGjhpA==
Received: from CY8PR12MB8297.namprd12.prod.outlook.com (2603:10b6:930:79::18)
 by LV3PR12MB9234.namprd12.prod.outlook.com (2603:10b6:408:1a0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Fri, 2 Aug
 2024 06:51:10 +0000
Received: from CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4]) by CY8PR12MB8297.namprd12.prod.outlook.com
 ([fe80::b313:73f4:6e6b:74a4%7]) with mapi id 15.20.7828.021; Fri, 2 Aug 2024
 06:51:10 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "jasowang@redhat.com" <jasowang@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mst@redhat.com"
	<mst@redhat.com>, "eperezma@redhat.com" <eperezma@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
Thread-Topic: [RFC PATCH vhost] vhost-vdpa: Fix invalid irq bypass unregister
Thread-Index: AQHa5CjSAPAcZ7W9W0quUUr+GUt/YLITUCkAgAA4OoA=
Date: Fri, 2 Aug 2024 06:51:10 +0000
Message-ID: <51e9ed8f37a1b5fbee9603905b925aedec712131.camel@nvidia.com>
References: <20240801153722.191797-2-dtatulea@nvidia.com>
	 <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
In-Reply-To:
 <CACGkMEutqWK+N+yddiTsnVW+ZDwyM+EV-gYC8WHHPpjiDzY4_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR12MB8297:EE_|LV3PR12MB9234:EE_
x-ms-office365-filtering-correlation-id: 30e33e5c-2b81-415d-5c8e-08dcb2bf7e40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QVNYcjVsaHRRRFo4d2J3c0hCZlJldk1JcW9UUXBoUnViVS9Ta3prTi9hMU5F?=
 =?utf-8?B?d0F5ZG0wWGx2YUcyQ3EzRU5CcFNqZ3BORFJ0dEVvVkFEdHNiUHZYUXkrcjhJ?=
 =?utf-8?B?NnJjaDVVblpFV1JTV3hKSEJReTRwRlk3RWlpd2NybEtTdHVIVjJPbVIzcVpt?=
 =?utf-8?B?UjlDeGtvbVFjQU02WlpwOUhXZ1MyY04wYWR0MG5uV0JsRjQxN21IM3ovem1x?=
 =?utf-8?B?UGsxeEQ0WU1HZ1BpMnBjeHdLMW1tL1R3N1NSTmg2RURsNVZHd0N0dTNLblI0?=
 =?utf-8?B?S2JCQXhCZk16c0Q3T09jMDRrVmdrL1ZyeFFXbHY4QWdFVFlBcWcyQjA3V2lY?=
 =?utf-8?B?SWRKcE15cUxKR0dROGEwMVQzT3FxRnF2blIxa0xhcVNXditUb2s1SXkzZk91?=
 =?utf-8?B?a21Wa1NhN2VQMEJiZXZ2bk5NQUZZVE5PS3o2Z1hnbXVvOFRMRjVhb2JqZ0hJ?=
 =?utf-8?B?RS93MWdSL1FZTTd2N0l3MTdoSGJsWmRxK0JSdUVmQlh2cjVycmtseHZzQXYv?=
 =?utf-8?B?dUZ3L3Y1L3FCcGdTWFJNTWNEeGhhVWpzRUcwY0d6M0NadDliSEhxWWdJKzFi?=
 =?utf-8?B?dGpTSkw4U1RSZ2wycFdJaE5PT2RPbExpVTgwK1BGRVU1WFRVUzhPZnNxcnIw?=
 =?utf-8?B?Rlh1ZnVudHhSTnpTVENwYzJMcVZyTmM1cGFMMmpsOGpWamlDOGdJc3laU1hR?=
 =?utf-8?B?ekJLNTRxWTJ6N1pMNTdsR3NMbXBLbVkyNzRLenZIcE81b1dEK0RHSkxtWkVP?=
 =?utf-8?B?VG00RjJHcUZ3dFJWS2xtSmRrbVNaazVDeFpOa0x1RG1peWZ4T2IyWDExTFpy?=
 =?utf-8?B?VWQ5dlVLTTNDcFhNZ0pEa2FjTkEwaG1CbXYrMzUyQVF4YlpzL2VYaFFsenlF?=
 =?utf-8?B?ODVxbDhTeWErdjBieXN5cDg4SEZKR2dDckw1c1JUYmFQU2RJWUFNbnhmVTFL?=
 =?utf-8?B?b05CVlphV1I5SU1RU2tXaWN1VUlkNGRNWi9EYWFkVllnWVRFdGU5UUZka2xU?=
 =?utf-8?B?ZHBsTFRxYlp4OE1uVkJJeUpFcTFKZEtPZHF4OW8vOHdGUk13ZFduMWRmVDJk?=
 =?utf-8?B?d2NDSXJLbURmakVNK1k0RjdnU3FLd2RCUEVoNE45V0FqS01hbk5HOHhDa0wz?=
 =?utf-8?B?T1NIUksrK2FVaVFxejFrRmlqa0F6ZDVEaDJ6bjFoUCtRVEI2ek5DYzFmZy9O?=
 =?utf-8?B?UFpUYzVTWHJWdzdadWllSkNyNHEzcmxwOXBjZy9NSzRIRWREUEhMQkpva2px?=
 =?utf-8?B?R1BMSnU0OVlWL0dBSjIvOHEzWTlBS1RqTER2R2RLOVVHUExTdWwxTlVZWkVH?=
 =?utf-8?B?REFpc1dKV3FCOFQrbU1qalBGVjNnVHJkNTNUdlUwSm0rV2V3WUYvaGpGc2JI?=
 =?utf-8?B?WG16d0xUWTBPdFA5VEV1WGJyeXBGeGpEOXJJdEFtUVBGK3VkbTNscHFyaUw2?=
 =?utf-8?B?c0Q1MEZpMnpsb3lyTzQ2bUpXVUJyYmFKVUcwNE9QNFRHYkJRcjlNRVQ5M1ZK?=
 =?utf-8?B?VjFXNk5EeUVENTBMcmx2VFpLYUpYdUFUSXhDNDVYV3dCREovcnk5Z2dYaGlx?=
 =?utf-8?B?Ujd1QVlSY0pyZ1luVWRWZ21nZUVnSGRGTWJFUU43U2ZtREIzbDIwbGdlVWVu?=
 =?utf-8?B?eTl0bHVrenk1QWdmRmFYVXdsZGxaWWNyOXhUNzZXVmRYNE9ydXRreFRWbW4r?=
 =?utf-8?B?QzBUMHlaOSt6clVCMHcxc3Z3YUhnL285TEJZbElzdmF3Y0s4cFpreHgrZksy?=
 =?utf-8?B?eGxISUMvbGxMQWVGQkFCTmY3cG5MQ2lob1l6Tlc1djdFbm1uSGs5V283WXpP?=
 =?utf-8?B?U3QvTVIzUlJTbjg3OWNuSFlKOThHMCtGS2xONmFJMi9LMzg3RFdHNFNMUUZX?=
 =?utf-8?B?QzBpTmh1M3kyN0dpSDVrK25BaU5UYXZqTFhSTi9tc0c5UlE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8297.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dFV6TW1MREtDQnBwSU04SWxaYWxKQTB4bWFqZG1yVU8xbVRYam9LdDhqb2pN?=
 =?utf-8?B?Z0s4VlNPT3A4WENXTjNNbVlKY1RqcU13cnQ3YndKejlyOU9rTmtyQkZEZjh4?=
 =?utf-8?B?VjlyaTZLOEg1NnN3cGFQVjk3Tm1icVdRV2hzNnlSV2syL1lvMXRJQUg1dW4y?=
 =?utf-8?B?V2s2TXpBbmNFaFVoaEIvaXFLUEU3S0dpME5qcGZ4YnNNRnlnZDU2TFBycTJE?=
 =?utf-8?B?b3UwVE5vM1lZUTgyQTNFeUhBSFRMcmpIQzhPMkF1N1hnMzMzbnVWbHcybnNM?=
 =?utf-8?B?YkFaR2UvZEpRdnNUaWdVck1uRktNRFd5eVA4TitvZjY1S1A3TndjVGpkM1BW?=
 =?utf-8?B?V0dZYm01WEsxbGpxNG1UclBkVmo5eFphN0krem9JbGlYblFDRzRVR0FjbWIx?=
 =?utf-8?B?OXdvQzE1L3I4cUhHR0l4aTN6Z1NEWGRHaFlCSDlqVzFkdENNOUdWQTNqeGNF?=
 =?utf-8?B?LzV5U1h2SjV6dEhFWnQzWDdQZ0xnSmZlSERWY3YyWEdGQ2laL1FmVFRnYVpW?=
 =?utf-8?B?NEorTUYydzFPZGJvOThaR1pPRzllVFd2K0lmVk5MdmpTT0xXTU5BZ28wbjVH?=
 =?utf-8?B?OE1BM09YK0ZMTFB5eFdKbFBsTkE5L2FRVU0yRG5wWFI2bDE5YmRyOE15VGVH?=
 =?utf-8?B?UHR0Q0U4cVB6cENXSjNxUy9nWG9xLzBiUXpOM01PeWZrWUlsY1lUd01ZcFRF?=
 =?utf-8?B?eVZIeS94UmlVcHFoOUhBY09QTk5CL1UzelpGUUZobERvMUR4bUpZT2FvWENV?=
 =?utf-8?B?NFMvOTRqWU5KYXFva2VSWWpXYjhMampTeU9lTzlBaGFnTzZ1SEgrVFdlR3dU?=
 =?utf-8?B?REQ1RVBnT0pHMFF4VkV2UTd5eDZLbFRDVW1HR2pnMEFnTndjOTRHOUJtdFNU?=
 =?utf-8?B?WXB2ZW5oWlVsaVFFL3RSQmdJOWhVcy9DNU94bU1ncXZ1dGNTQ0xsc1d5aHFn?=
 =?utf-8?B?WXV5UnNnSWdZckU2TVZsM2RUV3FKUkQrMFRIWVhielJsR0k2T0lkTkIxUll5?=
 =?utf-8?B?S2pQRnlOamZUVXBJWFhqYWRxczA2QU1jRnR1YkhKTzhNdGxFQmZjTFoyOC9N?=
 =?utf-8?B?UkZFa0phUk1jR1QrQ1hWZ2JFWlhSRmpHcWx0bjhUTHByajNTSDdXVkZuRVZ0?=
 =?utf-8?B?bzZQczBrOEh4T2NwdzYrbFQwcmN2MFpQc2pUeU5YVFdRbkI5TnRHYkozbFBU?=
 =?utf-8?B?bEZZeXVlMW1vODVYS0pzbjhxMTEzZW5MMURMVWIwdXoxZUxERDdaNGNtMlFH?=
 =?utf-8?B?TnFuQlpmL2VtalhDVWU1NElUVjNBaW1Dbm00M3Bva3p2cEgxbmxYTnk2cUxi?=
 =?utf-8?B?cDFyd1NTTkNxcmVXekhobys0K0xGeG01YzEvRHZOaTd2TWovOTBBZG1NanRR?=
 =?utf-8?B?R0VmVVZGR3YyTHcvQVA4SnB5NGNJVWJFaVlTcmMydTdsN2JDOFdsdytRVjJK?=
 =?utf-8?B?K2NpaDVMNE81aGlMODJTYXJzdzRzMWFjYlRHMVBMeHNEdVRYb0tTWDN5aXFP?=
 =?utf-8?B?cS9nMjlJUGp0OS9MaEs2QnRUVHlkMVF5YXZUL0Jqbm4wRUZhcHJjeGo2ellq?=
 =?utf-8?B?d1ovYlFDZGt5czhKdzI0cWtuOFVKTTYyOTFTaHYrajlqZUVIR0h3cUpXZmhH?=
 =?utf-8?B?MTl0b2QxZ0k5ZmtjV0Y2NEVaSW1oTWpZeGI1VjE5NVkzTkI0alppbUVNcmll?=
 =?utf-8?B?UjY5NERnMWFhSDFsTVJ3bHNjMDVCWHdTTDNoK0N6MFhCcVkzbHVqQ2wxUTFH?=
 =?utf-8?B?MjZvOGYvbk1UcWRFUHRhMDJmT1hBWm51NFRPSVUwdWtjZi9iWElYK0JnL1hn?=
 =?utf-8?B?ODJCRUMrbDFNZnNMeVI3RkoxL0Ryc1lMdFVNTGtXVm5HVThnaFMydjNrS1hl?=
 =?utf-8?B?Y0hETFpjOVZxWGU1SkkzMUhMQ0VsSmw2M0xQeHNPbFB3QzFLL29xSk0ra3hF?=
 =?utf-8?B?V1JSWjNFZWliNXlYKzlQekZoWkt3dXJHbXNTTjFUbUVyd3FmU2VWSGxOc2xj?=
 =?utf-8?B?KzdldVVzQUFVV0x0Y0dZanJZZmJkcWpnVk9XSXU0dUVWSnpIOXJqRmJFVFJ6?=
 =?utf-8?B?SEF3ZmZRSERvbEtQTVYyS0F0YTdhanQwTk5tbU45SG00UUQwcGhqZEZnSlVZ?=
 =?utf-8?B?NndHYUNIMCtDR1JqOWxKTW41WDU1aE5pU3NUS3NnQ1QxZDVRMjM3eUNKa0tP?=
 =?utf-8?Q?xmVfpiDio+QykKodjsLmQdHjfcThyKaxgS9By10NTHmq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5102C345845B3D4399E45D19EF202BEB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8297.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30e33e5c-2b81-415d-5c8e-08dcb2bf7e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 06:51:10.5898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RV00hMVCaMdMFrQapVYlP1TvlJm0vjva3OmIddUaMQMxjqhND2ujzBtGc5wVyy+mHs1uvsIbpCZUg3kafTQocQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9234

T24gRnJpLCAyMDI0LTA4LTAyIGF0IDExOjI5ICswODAwLCBKYXNvbiBXYW5nIHdyb3RlOg0KPiBP
biBUaHUsIEF1ZyAxLCAyMDI0IGF0IDExOjM44oCvUE0gRHJhZ29zIFRhdHVsZWEgPGR0YXR1bGVh
QG52aWRpYS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoZSBmb2xsb3dpbmcgd29ya2Zsb3cgdHJp
Z2dlcnMgdGhlIGNyYXNoIHJlZmVyZW5jZWQgYmVsb3c6DQo+ID4gDQo+ID4gMSkgdmhvc3RfdmRw
YV91bnNldHVwX3ZxX2lycSgpIHVucmVnaXN0ZXJzIHRoZSBpcnEgYnlwYXNzIHByb2R1Y2VyDQo+
ID4gICAgYnV0IHRoZSBwcm9kdWNlci0+dG9rZW4gaXMgc3RpbGwgdmFsaWQuDQo+ID4gMikgdnEg
Y29udGV4dCBnZXRzIHJlbGVhc2VkIGFuZCByZWFzc2lnbmVkIHRvIGFub3RoZXIgdnEuDQo+IA0K
PiBKdXN0IHRvIG1ha2Ugc3VyZSBJIHVuZGVyc3RhbmQgaGVyZSwgd2hpY2ggc3RydWN0dXJlIGlz
IHJlZmVycmVkIHRvIGFzDQo+ICJ2cSBjb250ZXh0IiBoZXJlPyBJIGd1ZXNzIGl0J3Mgbm90IGNh
bGxfY3R4IGFzIGl0IGlzIGEgcGFydCBvZiB0aGUgdnENCj4gaXRzZWxmLg0KPiANCj4gPiAzKSBU
aGF0IG90aGVyIHZxIHJlZ2lzdGVycyBpdCdzIHByb2R1Y2VyIHdpdGggdGhlIHNhbWUgdnEgY29u
dGV4dA0KPiA+ICAgIHBvaW50ZXIgYXMgdG9rZW4gaW4gdmhvc3RfdmRwYV9zZXR1cF92cV9pcnEo
KS4NCj4gDQo+IE9yIGRpZCB5b3UgbWVhbiB3aGVuIGEgc2luZ2xlIGV2ZW50ZmQgaXMgc2hhcmVk
IGFtb25nIGRpZmZlcmVudCB2cXM/DQo+IA0KWWVzLCB0aGF0J3Mgd2hhdCBJIG1lYW46IHZxLT5j
YWxsX2N0eC5jdHggd2hpY2ggaXMgYSBldmVudGZkX2N0eC4NCg0KQnV0IEkgZG9uJ3QgdGhpbmsg
aXQncyBzaGFyZWQgaW4gdGhpcyBjYXNlLMKgb25seSB0aGF0IHRoZSBvbGQgZXZlbnRmZF9jdHgg
dmFsdWUNCmlzIGxpbmdlcmluZyBpbiBwcm9kdWNlci0+dG9rZW4uIEFuZCB0aGlzIG9sZCBldmVu
dGZkX2N0eCBpcyBhc3NpZ25lZCBub3cgdG8NCmFub3RoZXIgdnEuDQoNCj4gPiA0KSBUaGUgb3Jp
Z2luYWwgdnEgdHJpZXMgdG8gdW5yZWdpc3RlciBpdCdzIHByb2R1Y2VyIHdoaWNoIGl0IGhhcw0K
PiA+ICAgIGFscmVhZHkgdW5saW5rZWQgaW4gc3RlcCAxLiBpcnFfYnlwYXNzX3VucmVnaXN0ZXJf
cHJvZHVjZXIoKSB3aWxsIGdvDQo+ID4gICAgYWhlYWQgYW5kIHVubGluayB0aGUgcHJvZHVjZXIg
b25jZSBhZ2Fpbi4gVGhhdCBoYXBwZW5zIGJlY2F1c2U6DQo+ID4gICAgICAgYSkgVGhlIHByb2R1
Y2VyIGhhcyBhIHRva2VuLg0KPiA+ICAgICAgIGIpIEFuIGVsZW1lbnQgd2l0aCB0aGF0IHRva2Vu
IGlzIGZvdW5kLiBCdXQgdGhhdCBlbGVtZW50IGNvbWVzDQo+ID4gICAgICAgICAgZnJvbSBzdGVw
IDMuDQo+ID4gDQo+ID4gSSBzZWUgMyB3YXlzIHRvIGZpeCB0aGlzOg0KPiA+IDEpIEZpeCB0aGUg
dmhvc3QtdmRwYSBwYXJ0LiBXaGF0IHRoaXMgcGF0Y2ggZG9lcy4gdmZpbyBoYXMgYSBkaWZmZXJl
bnQNCj4gPiAgICB3b3JrZmxvdy4NCj4gPiAyKSBTZXQgdGhlIHRva2VuIHRvIE5VTEwgZGlyZWN0
bHkgaW4gaXJxX2J5cGFzc191bnJlZ2lzdGVyX3Byb2R1Y2VyKCkNCj4gPiAgICBhZnRlciB1bmxp
bmtpbmcgdGhlIHByb2R1Y2VyLiBCdXQgdGhhdCBtYWtlcyB0aGUgQVBJIGFzeW1tZXRyaWNhbC4N
Cj4gPiAzKSBNYWtlIGlycV9ieXBhc3NfdW5yZWdpc3Rlcl9wcm9kdWNlcigpIGFsc28gY29tcGFy
ZSB0aGUgcG9pbnRlcg0KPiA+ICAgIGVsZW1lbnRzIG5vdCBqdXN0IHRoZSB0b2tlbnMgYW5kIGRv
IHRoZSB1bmxpbmsgb25seSBvbiBtYXRjaC4NCj4gPiANCj4gPiBBbnkgdGhvdWdodHM/DQo+ID4g
DQo+ID4gT29wczogZ2VuZXJhbCBwcm90ZWN0aW9uIGZhdWx0LCBwcm9iYWJseSBmb3Igbm9uLWNh
bm9uaWNhbCBhZGRyZXNzIDB4ZGVhZDAwMDAwMDAwMDEwODogMDAwMCBbIzFdIFNNUA0KPiA+IENQ
VTogOCBQSUQ6IDUxOTAgQ29tbTogcWVtdS1zeXN0ZW0teDg2IE5vdCB0YWludGVkIDYuMTAuMC1y
YzcrICM2DQo+ID4gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoUTM1ICsgSUNIOSwg
MjAwOSksIEJJT1MgcmVsLTEuMTMuMC0wLWdmMjFiNWE0YWViMDItcHJlYnVpbHQucWVtdS5vcmcg
MDQvMDEvMjAxNA0KPiA+IFJJUDogMDAxMDppcnFfYnlwYXNzX3VucmVnaXN0ZXJfcHJvZHVjZXIr
MHhhNS8weGQwDQo+ID4gUlNQOiAwMDE4OmZmZmZjOTAwMDM0ZDdlNTAgRUZMQUdTOiAwMDAxMDI0
Ng0KPiA+IFJBWDogZGVhZDAwMDAwMDAwMDEyMiBSQlg6IGZmZmY4ODgzNTNkMTI3MTggUkNYOiBm
ZmZmODg4MTAzMzZhMDAwDQo+ID4gUkRYOiBkZWFkMDAwMDAwMDAwMTAwIFJTSTogZmZmZmZmZmY4
MjkyNDNhMCBSREk6IDAwMDAwMDAwMDAwMDAwMDANCj4gPiBSQlA6IGZmZmY4ODgzNTNjNDIwMDAg
UjA4OiBmZmZmODg4MTA0ODgyNzM4IFIwOTogZmZmZjg4ODEwMzM2YTAwMA0KPiA+IFIxMDogZmZm
Zjg4ODQ0OGFiMjA1MCBSMTE6IDAwMDAwMDAwMDAwMDAwMDAgUjEyOiBmZmZmODg4MzUzZDEyNmEw
DQo+ID4gUjEzOiAwMDAwMDAwMDAwMDAwMDA0IFIxNDogMDAwMDAwMDAwMDAwMDA1NSBSMTU6IDAw
MDAwMDAwMDAwMDAwMDQNCj4gPiBGUzogIDAwMDA3ZjlkZjk0MDNjODAoMDAwMCkgR1M6ZmZmZjg4
ODUyY2MwMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwDQo+ID4gQ1M6ICAwMDEwIERT
OiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMw0KPiA+IENSMjogMDAwMDU2MmRm
ZmM2YjU2OCBDUjM6IDAwMDAwMDAxMmVmYmIwMDYgQ1I0OiAwMDAwMDAwMDAwNzcyZWYwDQo+ID4g
UEtSVTogNTU1NTU1NTQNCj4gPiBDYWxsIFRyYWNlOg0KPiA+ICA8VEFTSz4NCj4gPiAgPyBkaWVf
YWRkcisweDM2LzB4OTANCj4gPiAgPyBleGNfZ2VuZXJhbF9wcm90ZWN0aW9uKzB4MWE4LzB4Mzkw
DQo+ID4gID8gYXNtX2V4Y19nZW5lcmFsX3Byb3RlY3Rpb24rMHgyNi8weDMwDQo+ID4gID8gaXJx
X2J5cGFzc191bnJlZ2lzdGVyX3Byb2R1Y2VyKzB4YTUvMHhkMA0KPiA+ICB2aG9zdF92ZHBhX3Nl
dHVwX3ZxX2lycSsweDVhLzB4YzAgW3Zob3N0X3ZkcGFdDQo+ID4gIHZob3N0X3ZkcGFfdW5sb2Nr
ZWRfaW9jdGwrMHhkY2QvMHhlMDAgW3Zob3N0X3ZkcGFdDQo+ID4gID8gdmhvc3RfdmRwYV9jb25m
aWdfY2IrMHgzMC8weDMwIFt2aG9zdF92ZHBhXQ0KPiA+ICBfX3g2NF9zeXNfaW9jdGwrMHg5MC8w
eGMwDQo+ID4gIGRvX3N5c2NhbGxfNjQrMHg0Zi8weDExMA0KPiA+ICBlbnRyeV9TWVNDQUxMXzY0
X2FmdGVyX2h3ZnJhbWUrMHg0Yi8weDUzDQo+ID4gUklQOiAwMDMzOjB4N2Y5ZGY5MzA3NzRmDQo+
ID4gUlNQOiAwMDJiOjAwMDA3ZmZjNTUwMTMwODAgRUZMQUdTOiAwMDAwMDI0NiBPUklHX1JBWDog
MDAwMDAwMDAwMDAwMDAxMA0KPiA+IFJBWDogZmZmZmZmZmZmZmZmZmZkYSBSQlg6IDAwMDA1NjJk
ZmUxMzRkMjAgUkNYOiAwMDAwN2Y5ZGY5MzA3NzRmDQo+ID4gUkRYOiAwMDAwN2ZmYzU1MDEzMjAw
IFJTSTogMDAwMDAwMDA0MDA4YWYyMSBSREk6IDAwMDAwMDAwMDAwMDAwMTENCj4gPiBSQlA6IDAw
MDA3ZmZjNTUwMTMyMDAgUjA4OiAwMDAwMDAwMDAwMDAwMDAyIFIwOTogMDAwMDAwMDAwMDAwMDAw
MA0KPiA+IFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAyNDYgUjEyOiAw
MDAwNTYyZGZlMTM0MzYwDQo+ID4gUjEzOiAwMDAwNTYyZGZlMTM0ZDIwIFIxNDogMDAwMDAwMDAw
MDAwMDAwMCBSMTU6IDAwMDA3ZjlkZjgwMWUxOTANCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBE
cmFnb3MgVGF0dWxlYSA8ZHRhdHVsZWFAbnZpZGlhLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVy
cy92aG9zdC92ZHBhLmMgfCAxICsNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92
aG9zdC92ZHBhLmMNCj4gPiBpbmRleCA0NzhjZDQ2YTQ5ZWQuLmQ0YTdhMzkxOGQ4NiAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3Qv
dmRwYS5jDQo+ID4gQEAgLTIyNiw2ICsyMjYsNyBAQCBzdGF0aWMgdm9pZCB2aG9zdF92ZHBhX3Vu
c2V0dXBfdnFfaXJxKHN0cnVjdCB2aG9zdF92ZHBhICp2LCB1MTYgcWlkKQ0KPiA+ICAgICAgICAg
c3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdnEgPSAmdi0+dnFzW3FpZF07DQo+ID4gDQo+ID4gICAg
ICAgICBpcnFfYnlwYXNzX3VucmVnaXN0ZXJfcHJvZHVjZXIoJnZxLT5jYWxsX2N0eC5wcm9kdWNl
cik7DQo+ID4gKyAgICAgICB2cS0+Y2FsbF9jdHgucHJvZHVjZXIudG9rZW4gPSBOVUxMOw0KPiA+
ICB9DQo+ID4gDQo+ID4gIHN0YXRpYyBpbnQgX2NvbXBhdF92ZHBhX3Jlc2V0KHN0cnVjdCB2aG9z
dF92ZHBhICp2KQ0KPiA+IC0tDQo+ID4gMi40NS4yDQo+ID4gDQo+IA0KVGhhbmtzDQoNCg==

