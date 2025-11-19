Return-Path: <kvm+bounces-63688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6D6C6D4DB
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 09:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9F7C24FBAD7
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 08:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B023346A6;
	Wed, 19 Nov 2025 07:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b="TQYL9ZUb"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022098.outbound.protection.outlook.com [40.107.75.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D3532B9B8;
	Wed, 19 Nov 2025 07:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538860; cv=fail; b=NPsYIyejZUsB077nvkfzUcabzpTEyISZZf25Lsv4mMaDt2rOYMUaPgKmn/OMO7AAjoSU4Nmmcl/eYr+TbF0+v1kDhtv96h0tzD7ouVMp5Tey5jo307CY6pAQamRm6oNgMIsS9NaeXVuZ/A3wt//M1kVwg64Ev6HmZZ4KGCGXZ0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538860; c=relaxed/simple;
	bh=VMRL+GNOpyO6zRLexYZU+kuOTKq3IpWWzDdV05WUGv0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=no41dTikgQ8Uvhr87aROyuTht2k54HNRzXdSAt3XtJ6EsfLgBl8hDn3OslfwHuTm7ff82jzG44xOiZlb/kN4muvEZUQCqlLOpHlhqrmyGI7OzyA7eOp0z0yWx4JzG6Z9rZ2EQKdOs1YkG1rmGI5yrv8SQxGYVFitJ+YNCO1uZ5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com; spf=pass smtp.mailfrom=jaguarmicro.com; dkim=pass (2048-bit key) header.d=jaguarmicro.com header.i=@jaguarmicro.com header.b=TQYL9ZUb; arc=fail smtp.client-ip=40.107.75.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jaguarmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaguarmicro.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlNCtZ7YgSvgR1crpZstjMHwBHuZ4mlvAS17bUJLk4prTcWvcQ6YDq0qmzlMvVRErfl4EA7D4PIPiFYu9fXG1vWxj+lX04R7BvoRNll5wQoCSHTR0H9heGK2KuprsXv5xOCVz1ZjhSfgdFB9j8LeV9+LTA7g8McvupMuT2yD9s5q2SOyqWuq3tn3fki2dM5vAX/vFO6aXq6S1fYlvZjnlrOG4Ynilw7ggihZGebkbJXANbsoZyta/Oce9iQW4AKYfR1QHNLUteZ5KPDvJlL5dJvc4Mrs4oWKnegn48USY1mEwXUPfYw7bGo459FTsplPDf0L93x8joohwfR1r+RCMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VMRL+GNOpyO6zRLexYZU+kuOTKq3IpWWzDdV05WUGv0=;
 b=nFEt9bxPTQ6gwGsNENg9aqQLAOiEkIxPgQ/xEC7ydexpDRnfE+XyoMgV5uh5cYEDebLwgQYvepj9dZgVxUJZBouZ+RKO7zwV4UqPr5ogBC6TmxWF2L8SuWBGFJ/yAmSpbf+0CtvslWJS0eWqCDbzMaJ5D9ow2MmYHd4ZyIm/ttXXnsnj/dbpRIZttCKNNvtiWr64bOTCBE7FsDaLEmbhHWJAxPtOPBq1kRIqUwghCRTeyKIKC6wI1LmSXcur55vYz0e81WnduD60Esf5R/JzJavIg4u1CJ33pIWSqA5n524W/VYbqUZvGExOj/gJeIhWSji/yHOSVnkV7aGaQRnhQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VMRL+GNOpyO6zRLexYZU+kuOTKq3IpWWzDdV05WUGv0=;
 b=TQYL9ZUbWjSnpVGnkxPwzTl18qjzR65NNlrAI4TttV5nIpnmK30b4YAuvZ1jmUCWBkfAZtvCC7BjzHhj6KT9jjjuqbXLuK+do6hD5xVQu0m4JHJd3b2fejkZHXNZoYBYVuw/2tu19wTRz0a9GSGg+drKYPd+j5wMfRLuo90sV6MvvG8tc1SRcYx6nP4orZMQl9htxbJfCwOyDgui6ZoPVb76PjiOWahZtPaAnlDMcIPuWcVg8g6oeW7W/SP0mQpjFsuvdCWuCcIq99yXty5RumdDvYUO54KaPQcdQKoeV07G3XQroI+6pTq8Se27i9gzNH0l/wtPIQdDQZi6653/Dg==
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com (2603:1096:301:2b::5)
 by KUZPR06MB8058.apcprd06.prod.outlook.com (2603:1096:d10:48::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 19 Nov
 2025 07:54:07 +0000
Received: from PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881]) by PSAPR06MB3942.apcprd06.prod.outlook.com
 ([fe80::9b95:32e5:8e63:7881%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 07:54:07 +0000
From: Liming Wu <liming.wu@jaguarmicro.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S . Tsirkin" <mst@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Angus Chen <angus.chen@jaguarmicro.com>
Subject: RE: [PATCH] virtio_net: enhance wake/stop tx queue statistics
 accounting
Thread-Topic: [PATCH] virtio_net: enhance wake/stop tx queue statistics
 accounting
Thread-Index: AQHcWGsdJGJTMv6SqU2bnvzij0+hFLT5T1CAgABR10A=
Date: Wed, 19 Nov 2025 07:54:07 +0000
Message-ID:
 <PSAPR06MB39429783A41F42FDD82477A2E1D7A@PSAPR06MB3942.apcprd06.prod.outlook.com>
References: <20251118090942.1369-1-liming.wu@jaguarmicro.com>
 <CACGkMEvwedzRrMd9hYm7PbDezBu1GM3q-YcUhsvfYJVv=bNSdw@mail.gmail.com>
In-Reply-To:
 <CACGkMEvwedzRrMd9hYm7PbDezBu1GM3q-YcUhsvfYJVv=bNSdw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR06MB3942:EE_|KUZPR06MB8058:EE_
x-ms-office365-filtering-correlation-id: fbb97062-5bdf-4a57-5808-08de2740d10e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NHNLeXdnTXhKMHROYWtjaEVHUnVsM0xPU3FjdGtBZWtneG5XS0dpZGp3MGxU?=
 =?utf-8?B?UDVRY1pQQ0JyUEMvWGhoZlh6cThCTkNpalJSUDQrakRBSGFGRVlPNUFEUy9B?=
 =?utf-8?B?ODdVVVR6MDEyOVk4WkFFN0JqTGpOM21HMlBiT2xncVpEeGl5cWcwVDBZc0ov?=
 =?utf-8?B?cEx0MUNVSHFZTE5ZUkRaSFhnOG9wUHptMXY4dWhzd2h5K2w2aW93d3plL0Q2?=
 =?utf-8?B?Ny9URWl4b1plekRoRnNwNkFFSHE3Rk01V0NaYUFETXZScytFUnJobHpZQ1J6?=
 =?utf-8?B?WjU3LzF1MGE0UFNQUjFyeS9tU2hIbFRMY0Uxc3NNRU91ZGd2TFFwdVZoMHFO?=
 =?utf-8?B?cGF1anBHOHY0UUNWazR0Z3dEU1kxTzhTeURtVGtzWTAzUHh2RXY4bXRuRkE0?=
 =?utf-8?B?K3JyYTZ6UFVxYTNTZXA2Yng5ZXFjS05VdFBXS08yeitremt6QkdWQk16bDVC?=
 =?utf-8?B?TXdoYUhNVUh2MjhwcG1tLzlMWHdaQ2NTU2swMllDc0J3WmxISnp6d3owU3lW?=
 =?utf-8?B?TGpJc1Bqd1N1c1lGVU1BOWdXSDJQeklGRUZsT2xsa1VHanptU1NTRUZFSlpr?=
 =?utf-8?B?ang3Ty9tdzBQRnBtTm5mb0RmdFdlbE5sZlpqY3ljVjZwcWhLdGczQUN6WTR2?=
 =?utf-8?B?TEQyQ1ZqNmFUbDcrYmVTZmFkeDFiMFJyU3dqZ0pIQ3dDN1FsYWJtdlZWRU1s?=
 =?utf-8?B?dFR2WTJwNyt3ZFZmSzNyTi8xOE40S0o1QnBjUURBM08vUGJJVzRVUXBkQlhX?=
 =?utf-8?B?ay9jVzNQb05aa1Z4WTZ3RjhqM21YTkxockM1WG4wc3FRNmE0SE1qZTg1YWhj?=
 =?utf-8?B?RkpEaGl4cG9VSDZadU5jMTl2cWUxWlRpYWY5SVpsclhnS2hlOWJzU1M3UzE0?=
 =?utf-8?B?S3R4ZEhqVFQyMk9Qb2FKR3ZEUFMrV2phQTF1VWRoeGtHMm9tSVlzblJDYmEr?=
 =?utf-8?B?ZWtRVmp1TW5acGl3M21CY1haVVZaWjlTa0E5cTZ6WnVyQkdMeGMvdWtONzdy?=
 =?utf-8?B?clRmR2xqVGpvdHdKMzZINzRJUmY1WCtVdXo0dW5hWGRySTZORVBubFMwSEk0?=
 =?utf-8?B?ak93akFnQzJ1SitvZUVtRkRUcjZPZmtaQTdGVzhaYW9TOWhiS3N4WUdtcFhz?=
 =?utf-8?B?SWNHN0MvVVdTelJ3eU1JdkJyQ3RYWFpkT0dIUStjQ2VMOEh6WG95SlhULzNM?=
 =?utf-8?B?SzUrakZlTGpvazJzbzVhYWV0VUJUVWlhQ0UxZ3ZiaVFoc1I0WXhEa3MyU3I4?=
 =?utf-8?B?aXo4cE1uZHQxbXVsK3ZWclZiV21ncWFOTVdYWS9BNDBqUmRtT0wzOFBxcU5H?=
 =?utf-8?B?K3BOMHA2UUhsVmpLMGFYSUJVNXZUaTNVOXdFdmpSRW43bHkva1RtV1c1b3Aw?=
 =?utf-8?B?M0o0eGVSMUM5elBlV25UUEZOTFN6akVZTjVrOGQ1WjBvdG12OExVODF1SlBX?=
 =?utf-8?B?elF3cGE2TTJRR1F5cU5oV1RpUzdBSkllZE1CVUtDN05BNlREeDhMN282TkR2?=
 =?utf-8?B?NjErQmQzdHpkeERLS0ZIK0lrSExQeXdDb3Q5YmNXdVE4VXRLcFAwb0lMTjl0?=
 =?utf-8?B?d090MjJnNlBDckM2Sm9OSE5xL2lUdEY5WnlaU3FLN3laLzdtYmcycGM3RWRH?=
 =?utf-8?B?WTB0eEpXR2d2VFdPb2lzS1dwaS9oenRFaHMvMDdoUStWNXh3b21UOG54Z0tX?=
 =?utf-8?B?SWxndzRla0VZcW5WNUdwRnI1aDNoWEgxc2F0MEtaaFNGakRFdlVmQ1AyQ0Zr?=
 =?utf-8?B?RVI2UlgySjhIZ0diN0kvanVQV2RpZmdHU3lBMnA1eXd0alZaSWw3T0Y1Q2hY?=
 =?utf-8?B?Uk1IVURaNTRuZHJTd29vSTJFMzFHbnZIN1JqTnVBRjc2cW9zb2liNmdpMkdk?=
 =?utf-8?B?YXhRWHlneHdZOFYzYkR3aFEvSjQxbktkRUVvUVl4M1V0a0hyUUhTM3Q1dGhm?=
 =?utf-8?B?MTgyczNWb2tTbFN4VHVmUzhKQ0ZFYUpqM2xZYTlGTW8zcStXM0JPUjlENVdL?=
 =?utf-8?B?WnU1a0trRlhIWkRBNng4MW5VU0dqWXJDc0R6RVFBOHhuSWFFTU5TV0p4clZl?=
 =?utf-8?Q?IFz+Gz?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB3942.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UzA4Z3FUU3ZqdVgwNDVmNStOMFZmT2xVUitQeHlGTzhrdWVheXRDWjhnYjhJ?=
 =?utf-8?B?WmJtYlhnR0tjUkt1V2pNWjROMVYzdER6bUVvS2ZkSEorK2E5UkNGTjlHTWRQ?=
 =?utf-8?B?RDhpWG51QkhnWUpncUJtaWUzMEp5ZlE3VFlmYmpTTTE4a1A0dU1VcWxoVTZs?=
 =?utf-8?B?a3ZkVUpQWDZjOVdOUkdITmI1c2pqRnN2OHM2bUltNHFvU2NqQmo0QXZiWmpw?=
 =?utf-8?B?dmZGRXpUQ1FSc09iN3JjQ2NMek1CLzU1YmlPQXNmQU5NTGFmOFY0Vjd5Y3lh?=
 =?utf-8?B?N24zM2pRSHhuWjRZTTduSklaOHduS2JIQ2pMaDVtcnlUenpjd1lGTlJkTzB5?=
 =?utf-8?B?d0dqTEZBTDBVeWFoNEZUeUU3enJNOGJoTlJpUTVnbjVLdmNkWkF4anNmakZT?=
 =?utf-8?B?QytjbzQ1YlgwODFxRkNaSG5nN0FDYXk1cHBCSksrWlRESnVvMXFhMEZEdS9L?=
 =?utf-8?B?MmhRS0htVDJKSFF2TVBTV3ZOS0NVWGJEeEtUeituMThVYnM3NU1HT0pieEo3?=
 =?utf-8?B?TEkyZXNrcng2WW9uTWVGdFUxOGZlV1JtVGFhekVoVE4yRnBxbUxHTHp6NUlo?=
 =?utf-8?B?a2I3VWxDM0M0S3I3VHhwVm9ybGVuTDdHV0RWa0wvUkZJdlJMUG9FQVVnUWpD?=
 =?utf-8?B?SEl5KzdiVHZNNlUzOTd5UkZWS3Y5U0MzdFg0OXpBaEZra0pVMEpDTGFsYkxa?=
 =?utf-8?B?V0hVb0g5dGxpQU81TjJXNFJieG5UbkR3Uy9leXlDY0lML3BBOWZDRGFqSHNS?=
 =?utf-8?B?cnhBb0hCOUdrQkRCYUN0c2JJeExGZWlOb2ZOd0RnSFNmc2pnSk10dlBjb1li?=
 =?utf-8?B?OEFFTnk4TEFTUmJ3VjkzYStJYWQxYkx5T0ZkNmlRdFlXbGszSVp6WGhBSUZv?=
 =?utf-8?B?anA4QWMzWjRBQlBocnUxU1dITno2VXBzUEZoWTcyUXpIRHdTNEl3REdyM1NL?=
 =?utf-8?B?a3NOR1UvNFlJaEpidEdYK092VG85MTdlcm9ZZVZTMFpRd3hnbkhIaGhkM0Vm?=
 =?utf-8?B?K29ZZDROeWtrbVVpZzdaTTh0UkJocVlGdlA1eHYrRkpJYzVoS1lzK0ZFdUFI?=
 =?utf-8?B?N0JWdm5CU0ZWRFdhN0tJYUFvajZwUnpPdVpkRUUra0prQ3hobUxwRUtRZzZP?=
 =?utf-8?B?YVI2QUVsa3JoS0tHY1BBbjlLQzdpdThzRVd3N04raTY0ZVRGVm0zVEFTYVUz?=
 =?utf-8?B?dEU2RWtiMXBSblpwc2w1Witva2lmNUhLZjNjUkloYzczQXdqY3JsR1p1NE9S?=
 =?utf-8?B?TmJYUVRKM3duV0dyOWN5STREQnpsRWh4dkN5YzNpTTNHNC81UkIyTENBTXUr?=
 =?utf-8?B?WElGbmlXMWh4MFN1TTlGaDY0K0tTMWZRK3pTUlM2VHN1aVRKL2JoTGRFeEhK?=
 =?utf-8?B?enFjL2tBSjk2d0pxVjFqdlNZbXllMkNNRS9YYXhEeEwvRFg5U1lScDVkcStE?=
 =?utf-8?B?M0VHU2t3c0hxQWpwa0JHM3h4RFhWTDRPeUo4djJmOG04cjU2MSs1dm1lY2tE?=
 =?utf-8?B?aTVYQllwVGE1aGtDNjVYUlhrR1BQdkUrb3RLVWJ1VVRYQXgyL3pHK1BIbjN4?=
 =?utf-8?B?bG52cmNKYnV3dS8xSXp5TU10MHlaeEpXTWlKSFBZUTBVK1MvbG10MFNDNFZy?=
 =?utf-8?B?WGVKQlZQWU1hWWRkb3RtWHVHQk5CL3A4dUxQY1Bvb3V4OCsxbnJDSC91eWFo?=
 =?utf-8?B?b2pwR2VtOUlqS09JNGhWcjl6OXA1cVNGVlc1TUFMRVhSbHBiU0U1UERoeUF5?=
 =?utf-8?B?em5HYkovRlR0Sjg3MUM5REo2cTBlUEsxazZCQWRha2NzRnp0aEhBbFhZVTRI?=
 =?utf-8?B?YzRlWlhHaElEeHhDUG9hbC9JNjFvZFQwMWRDL1NwYXFnRFlkczUxMVd5Sk14?=
 =?utf-8?B?QVVkTHFqelhFTURDbTUxckVLUldYVE01ekxwRGExRDVmN2JXQXBxWXVyNHV2?=
 =?utf-8?B?MjZlTWhOUENyVGE4ZVJoT2tSdUJCTFo2MzJHQnUrU2hhdmYxUkRQd0RJcXdo?=
 =?utf-8?B?VkdXQjRZdm9CTUREUEN2aWVtREFrMUh0MitIMUpLSDIxT2Y3TDFZcEpXWVNP?=
 =?utf-8?B?Umk4WTNvQVRjUXY1U3BFdFo3bm1XYXYzZjdMZEYrSWtkZzl4ZFgzTFhud0Vv?=
 =?utf-8?Q?R/OfletaeIujUfGWzt0XqiANk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB3942.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb97062-5bdf-4a57-5808-08de2740d10e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2025 07:54:07.1912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 581Kq9zhu2wQ8NOHIMhGrQtsa68qILnlqhL8dDPRTuV1uVTH2X0JyRX4NlqorpJuooZMv5EwrgI2Cf/OabCO57BW2/OIjIeqg7H1EfsQgCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR06MB8058

PiBxdWV1ZSB3YWtlL3N0b3AgZXZlbnRzIGludHJvZHVjZWQgYnkgYSBwcmV2aW91cyBwYXRjaC4N
Cj4gDQo+IEl0IHdvdWxkIGJlIGJldHRlciB0byBhZGQgY29tbWl0IGlkIGhlcmUuDQpPSywgdGh4
Lg0KDQo+IA0KZWNrLiAqLw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGZyZWVfb2xkX3ht
aXQoc3EsIHR4cSwgZmFsc2UpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChzcS0+
dnEtPm51bV9mcmVlID49IE1BWF9TS0JfRlJBR1MgKyAyKSB7DQo+ID4gLSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBuZXRpZl9zdGFydF9zdWJxdWV1ZShkZXYsIHFudW0pOw0KPiA+IC0N
Cj4gdTY0X3N0YXRzX3VwZGF0ZV9iZWdpbigmc3EtPnN0YXRzLnN5bmNwKTsNCj4gPiAtICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHU2NF9zdGF0c19pbmMoJnNxLT5zdGF0cy53YWtlKTsN
Cj4gPiAtDQo+IHU2NF9zdGF0c191cGRhdGVfZW5kKCZzcS0+c3RhdHMuc3luY3ApOw0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdmlydG5ldF90eF93YWtlX3F1ZXVlKHZpLCBz
cSk7DQo+IA0KPiBUaGlzIGlzIHN1c3BpY2lvdXMsIG5ldGlmX3R4X3dha2VfcXVldWUoKSB3aWxs
IHNjaGVkdWxlIHFkaXNjLCBvciBpcyB0aGlzIGludGVuZGVkPw0KVGhhbmtzIGZvciBwb2ludGlu
ZyB0aGlzIG91dC4NCllvdSdyZSByaWdodCDigJQgdXNpbmcgbmV0aWZfdHhfd2FrZV9xdWV1ZSgp
IGhlcmUgd291bGQgaW5kZWVkIHRyaWdnZXIgcWRpc2Mgc2NoZWR1bGluZywgd2hpY2ggaXMgbm90
IGludGVuZGVkIGluIHRoaXMgc3BlY2lmaWMgcGF0aC4NCk15IGNoYW5nZSB0cmllZCB0byB1bmlm
eSB0aGUgd2FrZS9zdG9wIGFjY291bnRpbmcgcGF0aHMsIGJ1dCByZXBsYWNpbmcgbmV0aWZfc3Rh
cnRfc3VicXVldWUoKSB3YXMgbm90IHRoZSByaWdodCBjaG9pY2Ugc2VtYW50aWNhbGx5Lg0KDQpJ
IHdpbGwgcmVzdG9yZSBuZXRpZl9zdGFydF9zdWJxdWV1ZSgpIGF0IHRoaXMgc2l0ZSBhbmQga2Vl
cCBvbmx5IHRoZSBzdGF0aXN0aWMgaW5jcmVtZW50LCBzbyB0aGUgYmVoYXZpb3Igc3RheXMgY29u
c2lzdGVudCB3aXRoIHRoZSBvcmlnaW5hbCBjb2RlIHdoaWxlIHN0aWxsIGltcHJvdmluZyB0aGUg
cGVyLXF1ZXVlIG1ldHJpY3MuDQoNCj4gDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB2aXJ0cXVldWVfZGlzYWJsZV9jYihzcS0+dnEpOw0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgIH0NCj4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+IEBAIC0zMDY4LDEzICszMDgwLDgg
QEAgc3RhdGljIHZvaWQgdmlydG5ldF9wb2xsX2NsZWFudHgoc3RydWN0DQo+IHJlY2VpdmVfcXVl
dWUgKnJxLCBpbnQgYnVkZ2V0KQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGZyZWVfb2xk
X3htaXQoc3EsIHR4cSwgISFidWRnZXQpOw0KPiA+ICAgICAgICAgICAgICAgICB9IHdoaWxlDQo+
ID4gKHVubGlrZWx5KCF2aXJ0cXVldWVfZW5hYmxlX2NiX2RlbGF5ZWQoc3EtPnZxKSkpOw0KPiA+
DQo+ID4gLSAgICAgICAgICAgICAgIGlmIChzcS0+dnEtPm51bV9mcmVlID49IE1BWF9TS0JfRlJB
R1MgKyAyICYmDQo+ID4gLSAgICAgICAgICAgICAgICAgICBuZXRpZl90eF9xdWV1ZV9zdG9wcGVk
KHR4cSkpIHsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICB1NjRfc3RhdHNfdXBkYXRlX2Jl
Z2luKCZzcS0+c3RhdHMuc3luY3ApOw0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIHU2NF9z
dGF0c19pbmMoJnNxLT5zdGF0cy53YWtlKTsNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICB1
NjRfc3RhdHNfdXBkYXRlX2VuZCgmc3EtPnN0YXRzLnN5bmNwKTsNCj4gPiAtICAgICAgICAgICAg
ICAgICAgICAgICBuZXRpZl90eF93YWtlX3F1ZXVlKHR4cSk7DQo+ID4gLSAgICAgICAgICAgICAg
IH0NCj4gPiArICAgICAgICAgICAgICAgaWYgKHNxLT52cS0+bnVtX2ZyZWUgPj0gTUFYX1NLQl9G
UkFHUyArIDIpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgdmlydG5ldF90eF93YWtlX3F1
ZXVlKHZpLCBzcSk7DQo+ID4NCj4gPiAgICAgICAgICAgICAgICAgX19uZXRpZl90eF91bmxvY2so
dHhxKTsNCj4gPiAgICAgICAgIH0NCj4gPiBAQCAtMzI2NCwxMyArMzI3MSw4IEBAIHN0YXRpYyBp
bnQgdmlydG5ldF9wb2xsX3R4KHN0cnVjdCBuYXBpX3N0cnVjdCAqbmFwaSwNCj4gaW50IGJ1ZGdl
dCkNCj4gPiAgICAgICAgIGVsc2UNCj4gPiAgICAgICAgICAgICAgICAgZnJlZV9vbGRfeG1pdChz
cSwgdHhxLCAhIWJ1ZGdldCk7DQo+ID4NCj4gPiAtICAgICAgIGlmIChzcS0+dnEtPm51bV9mcmVl
ID49IE1BWF9TS0JfRlJBR1MgKyAyICYmDQo+ID4gLSAgICAgICAgICAgbmV0aWZfdHhfcXVldWVf
c3RvcHBlZCh0eHEpKSB7DQo+ID4gLSAgICAgICAgICAgICAgIHU2NF9zdGF0c191cGRhdGVfYmVn
aW4oJnNxLT5zdGF0cy5zeW5jcCk7DQo+ID4gLSAgICAgICAgICAgICAgIHU2NF9zdGF0c19pbmMo
JnNxLT5zdGF0cy53YWtlKTsNCj4gPiAtICAgICAgICAgICAgICAgdTY0X3N0YXRzX3VwZGF0ZV9l
bmQoJnNxLT5zdGF0cy5zeW5jcCk7DQo+ID4gLSAgICAgICAgICAgICAgIG5ldGlmX3R4X3dha2Vf
cXVldWUodHhxKTsNCj4gPiAtICAgICAgIH0NCj4gPiArICAgICAgIGlmIChzcS0+dnEtPm51bV9m
cmVlID49IE1BWF9TS0JfRlJBR1MgKyAyKQ0KPiA+ICsgICAgICAgICAgICAgICB2aXJ0bmV0X3R4
X3dha2VfcXVldWUodmksIHNxKTsNCj4gPg0KPiA+ICAgICAgICAgaWYgKHhza19kb25lID49IGJ1
ZGdldCkgew0KPiA+ICAgICAgICAgICAgICAgICBfX25ldGlmX3R4X3VubG9jayh0eHEpOyBAQCAt
MzUyMSw2ICszNTIzLDkgQEAgc3RhdGljDQo+ID4gdm9pZCB2aXJ0bmV0X3R4X3BhdXNlKHN0cnVj
dCB2aXJ0bmV0X2luZm8gKnZpLCBzdHJ1Y3Qgc2VuZF9xdWV1ZSAqc3EpDQo+ID4NCj4gPiAgICAg
ICAgIC8qIFByZXZlbnQgdGhlIHVwcGVyIGxheWVyIGZyb20gdHJ5aW5nIHRvIHNlbmQgcGFja2V0
cy4gKi8NCj4gPiAgICAgICAgIG5ldGlmX3N0b3Bfc3VicXVldWUodmktPmRldiwgcWluZGV4KTsN
Cj4gPiArICAgICAgIHU2NF9zdGF0c191cGRhdGVfYmVnaW4oJnNxLT5zdGF0cy5zeW5jcCk7DQo+
ID4gKyAgICAgICB1NjRfc3RhdHNfaW5jKCZzcS0+c3RhdHMuc3RvcCk7DQo+ID4gKyAgICAgICB1
NjRfc3RhdHNfdXBkYXRlX2VuZCgmc3EtPnN0YXRzLnN5bmNwKTsNCj4gPg0KPiA+ICAgICAgICAg
X19uZXRpZl90eF91bmxvY2tfYmgodHhxKTsNCj4gPiAgfQ0KPiA+IEBAIC0zNTM3LDcgKzM1NDIs
NyBAQCBzdGF0aWMgdm9pZCB2aXJ0bmV0X3R4X3Jlc3VtZShzdHJ1Y3QNCj4gPiB2aXJ0bmV0X2lu
Zm8gKnZpLCBzdHJ1Y3Qgc2VuZF9xdWV1ZSAqc3EpDQo+ID4NCj4gPiAgICAgICAgIF9fbmV0aWZf
dHhfbG9ja19iaCh0eHEpOw0KPiA+ICAgICAgICAgc3EtPnJlc2V0ID0gZmFsc2U7DQo+ID4gLSAg
ICAgICBuZXRpZl90eF93YWtlX3F1ZXVlKHR4cSk7DQo+ID4gKyAgICAgICB2aXJ0bmV0X3R4X3dh
a2VfcXVldWUodmksIHNxKTsNCj4gPiAgICAgICAgIF9fbmV0aWZfdHhfdW5sb2NrX2JoKHR4cSk7
DQo+ID4NCj4gPiAgICAgICAgIGlmIChydW5uaW5nKQ0KPiA+IC0tDQo+ID4gMi4zNC4xDQo+ID4N
Cj4gDQo+IFRoYW5rcw0KDQo=

