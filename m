Return-Path: <kvm+bounces-19766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ECD190AA44
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 11:53:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27CC71C232BF
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4404195F02;
	Mon, 17 Jun 2024 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g1txndbn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18411195B2F;
	Mon, 17 Jun 2024 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718617498; cv=fail; b=dx2+pxpFsWVA9jzGAqMezb38Dsnsv0sx9JmXqAKzic3WaspY1URjFXPd/Xxoc/MoL2Umr/NQSLB6R/jiy9h0GvXmM5WPe8j6q97TXRyoCISU9DsNNn9t2IoYlYXZKcUXpyHpRqfAz2qvQGH1gtWUdtLqSh+RyFDPHax2336F6wM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718617498; c=relaxed/simple;
	bh=qmE65AnLHeY5J0M/Q2uLV2VwWlIlGwaTxrA5T9ndFjM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S3AIxpCLxqJRXl44noLVhsGY1pMOuhJpAhXXX7J8phkmnP5j2PDZ9oFTPKEPHsGRQSmNQ6W6IVlziBCfrdi6L6kiEvgeBPt6Ld74vNJI4FtA+g0VhnBmzzAscy5ztYaX7WPm1vljgEK902Vk/fGBeAnrgvDgjlRhcXkI0NMdY+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g1txndbn; arc=fail smtp.client-ip=40.107.244.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXcSBZLec6nZkI/hk8dx+sK5Wm9E0ZYXbNlqPg3gSoiPjmfhZYSXCPYNtLTjsjmPO1E9wdtBuA5y0yoyNiJaJ2GF6jwoykmF8BFjglU3D1GmvT92VlzuwsFIm50POBj8rlpAbYuq+l3Qwb7V7P4CkhrUsMpTOr35Wp+yjd3NX+5PnpfssPiKjMK8clRfOyujAUjnE1Q8L7X/aZOpKKnsUAdpDl+zx4DJC64b07E6yiB7PJIIxNRkKQMR3tnAe0AqpqF2zX3WYi5/XiorayZtnmyXB+0KkFn6s6giBLP7+Zd0lws2chCn3k/MRYOQjtY0EmE+WZ/vBp9drnjLA4/6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qmE65AnLHeY5J0M/Q2uLV2VwWlIlGwaTxrA5T9ndFjM=;
 b=foobcuUXqHfliz7zXzsemQVQPyabJvVbDd60fPv72F5Jj+EG9qEhVQgvASB7Pa1Y771G7AAh02Z4vYtKGCvZxOlmTUgpbtRXpASHsve/PnKZwsGWh6Hlkuhx5BtCEB1qmYJFqRDxyhIG9clSSimFEqSrkkYJYnRckJpTY2RKFSosfD8qVyY2Gdq8B0hNwo2iYUmXQ7N/HP/K+qEujy44G/Xtj7U0GUAWguATnWb10DU8eClvjD1F1hm2eBTlEeMz0PDG/9F9TvrSi2QAwro2ydnV8qre23hC9xe7of5I7QtDbdZA5fEnQfHdcVvEC2dwI8Tpqxzr1GW2t0X+CmjgJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qmE65AnLHeY5J0M/Q2uLV2VwWlIlGwaTxrA5T9ndFjM=;
 b=g1txndbn21DDzuQTs+bJVwAIl9Uw86zDB5n/jNWWEQc8IWuealLNU9NObRE0NwYhTRiT7mAQl4LFLQ+4JBs3kihWUAJTX+PNVNdLC6EOIfWPSvkM3NDuj/lVjj09T+QA7RGwu6HGzlknIdM652DPi8jHf5lr5A7aQSKc93vq9PtM3I0XEI21vZeJgbM9tGn/Qmb9pXTYhH0huv/9Iifg8g6hx4RiUKpbnwuGxh16fd5SFvX+VTEd4HaTHDBvgw3MO79vQaBxJlvGWp6wFu+W2c4KEjApbYZPZGOf/e3owD5LlBipOvPzn8iG7cP3ZxG7RWAzL3+/4/1UaYZmJSPQOA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by SA3PR12MB9129.namprd12.prod.outlook.com (2603:10b6:806:397::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Mon, 17 Jun
 2024 09:44:53 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::361d:c9dd:4cf:7ffd%3]) with mapi id 15.20.7677.030; Mon, 17 Jun 2024
 09:44:53 +0000
From: Parav Pandit <parav@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Jason Wang <jasowang@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Cindy
 Lu <lulu@redhat.com>, Dragos Tatulea <dtatulea@nvidia.com>, "mst@redhat.com"
	<mst@redhat.com>, "virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Topic: [PATCH 1/2] vdpa: support set mac address from vdpa tool
Thread-Index:
 AQHau8E82Oi/Eu4kG0WR1z2wkwF2SbHDYHEAgABL6oCAB4z7gIAAEN/AgAByw4CAAABP0A==
Date: Mon, 17 Jun 2024 09:44:53 +0000
Message-ID:
 <PH0PR12MB5481F6F62D8E47FB6DFAD206DCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20240611053239.516996-1-lulu@redhat.com>
 <20240611185810.14b63d7d@kernel.org> <ZmlAYcRHMqCgYBJD@nanopsycho.orion>
 <CACGkMEtKFZwPpzjNBv2j6Y5L=jYTrW4B8FnSLRMWb_AtqqSSDQ@mail.gmail.com>
 <PH0PR12MB5481BAABF5C43F9500D2852CDCCD2@PH0PR12MB5481.namprd12.prod.outlook.com>
 <ZnAETXPWG2BvyqSc@nanopsycho.orion>
In-Reply-To: <ZnAETXPWG2BvyqSc@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|SA3PR12MB9129:EE_
x-ms-office365-filtering-correlation-id: f63703a3-a842-4ef6-8bf1-08dc8eb223be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info:
 =?utf-8?B?MlBDK0R4eEdLTnpoVHVXRDBIa08xQlhxQ0hvcG11VDBhRU1rN2twdnR0STFI?=
 =?utf-8?B?MkVicWF1UElJb3VxUUJkeEY0R2NIZG5wUEQ4ZS9zWXk0WW9EYm84cmtYWms5?=
 =?utf-8?B?MlRLNFY1enovdUpiQ1kxOW1oYXBqd1B6TlBjSFBvY1JSWlBFSEd4UnpLcWFl?=
 =?utf-8?B?VU5WU211R0orV2QxTXRLQlhTN1VST0YrcXNLRXN5WEV5STdJUFlVUlI0akNF?=
 =?utf-8?B?bW5uN2xOYTF3alNreFUxYlQwWEtBblZEL2R3b0cxSFNHTmZQVDBRVG03bDJ6?=
 =?utf-8?B?MXZPYVhPemZCM3dHRVd5YnhieitPTmxIVnNyQ3RGUW1YTXN5Qk4rQWptOEIx?=
 =?utf-8?B?dVhFWCtFMzh0YlN5b0NYRnZBR010WGJWaVlCQnJDWnIyTW9SRU44YmE2WDJw?=
 =?utf-8?B?OEhFSXB2VENBN3Z6ZjM2UzJwVmhyM0J4TjFDV0lJblcxV25NaDRhQ1JMalZs?=
 =?utf-8?B?NUJvQVdEVTgrNWQxQXhQTE1wVVBxSGUwL3NTNHp5WVBCWjBiQUoyUjAvQlUy?=
 =?utf-8?B?b1BjSGF5RmYwVk5PQTd1TGVSYW5JUDM2YzlySW11ZGFrMFdpUXptM2hiTUhS?=
 =?utf-8?B?WnloMVBpVWVQUnkyZUozMi9XTG9rSmROMEVuclRhWEJiUmlVcWNtdUhpTnhv?=
 =?utf-8?B?MVlvU1o0NE0rMnhJWlQ2TkU4b2Vhais2Y2ZaQjRkSDQwanYzbzRXdG0xNHVB?=
 =?utf-8?B?d2hyMlBFN2JMYml1UHhUR3pFWUpBaEtsT0NNMEVveWQ1QlVKZ0YvVDkrRUpL?=
 =?utf-8?B?QzVFaG9UQkN6TFYyTnlJSG5tOEI1QzVZTUtYUVU4WGxiRzBjUnVQa3F2Q1kr?=
 =?utf-8?B?WDNETHVTZ1JLYlJzM3NCbEZSMGE2djc5b0dTblNkTGRSVHpCVk84Z0VhYnJT?=
 =?utf-8?B?VDBGQkMzSUk5UE9YTlc3WmNkWGFXMy9zSjZtQTB5NVJ2WGVCR2xkcWNId0FK?=
 =?utf-8?B?bW9qRHhTUnJabitmU0ErY2FJclJLeDhnNnJ2dFUwU1R1ZXhrdWFVaVZWRE9B?=
 =?utf-8?B?OGl1cko5Zm44QjRHcW1qeEFOdXdvam1YVUthaVVCdUhCbnBzYlV2Qm1DTlF2?=
 =?utf-8?B?alE1RkFFR0pVREVKaU9jL3N0VXd5WHZ3d1hEY2tKbTNJbmdJS0NHV0dYWHJ1?=
 =?utf-8?B?VjFKUmNQaHJra2poUTlmalBjNzlubWk3ck4vVUFBRXpQcVRYWGU1QlJ1YWZP?=
 =?utf-8?B?L09lS2EvTUNQSXN6L0hnYUNlWUM0dTZod2FCN2tYVmZyTmQxVkx6biticFdY?=
 =?utf-8?B?MzZXZzgvWmI4MXdCeG5lY1pvZ21JblQ3U1VMK004NkY1VXlCNmJwTHlJRVRH?=
 =?utf-8?B?MFlkUmRmMHhIMDBFb1MyYyt5VEM1VUUwSzIzZTJyWW9tMkZWRDF4cEhaYmh4?=
 =?utf-8?B?dzlrZHJvbVlyUXpMQkR5MVVaL0tpcFl1ak5GajkwL3BOUlI4UFBJT1Z6c1FV?=
 =?utf-8?B?azd6MUhsam5UY2FQSXhsUWg5cEVjbCtrRmJHa0dUcGFzSGYyVlRLWTBtMWRa?=
 =?utf-8?B?SXZMVFZGRkczamdZUzY2aTd6K2FaemxVTlFUaGNEYm9LMUdQVVpWNUJOazNE?=
 =?utf-8?B?bDVNbS9pbDl5eVlTMDJZSFg1OXo2aGRsQW5JRjFjeHFUcWhnVlJiRjFobzV6?=
 =?utf-8?B?K01qK2lQOFV6UGlMQVdGQkJZYXhla1Z6c1FwbGlxQ2pLSmZQdnpUMUIwTzhR?=
 =?utf-8?B?VlVGdGQ3QWpYYlFESXp5bFdPS2VwQUZERlREcDRCYkp6NVE5YU1pTS9YMmVT?=
 =?utf-8?B?TW5ZQnRGK0gwVnhEN0habFdwMC9Rc2Y1ejRnbUJ0R083TlVtOEcvQ3lTT0NF?=
 =?utf-8?Q?7ZqaDUFanYaN51aqumdj6ZvZbyY1XTxSIkHl8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MllWZndrMkNNUWNEdlRORFFxdVM4cHVCa2lpd3hGekFRbVVQbUlFYldjWlhw?=
 =?utf-8?B?VlBmMVVLVkNZTzh0YUN5RHJVV21ENCtGWnVPQkR6QUtFK3hlMzdkTXlVVzdn?=
 =?utf-8?B?aUpFejB0V0FsUGhYYjJ1bW9KK2ZwMjBGVHdiTjg2L2VFa0JIY3Rta0ZQYmtL?=
 =?utf-8?B?dmV6Z2ZydS8ybmVFNHoxWjg2RDgxUEpwRGV4OXRieHowbzljcG5TL2lveWRH?=
 =?utf-8?B?YzN3WTVNWXBERFBKaS9pcDdMd3l6TzJoeFJ0RFpwYnZwdDBzb1ZZL0pkYjQw?=
 =?utf-8?B?aitjZ3IrZUkvY0UrRkh5bXBaSFk1Z2ZjY0lvL055SjJVWkJXUENmNGlZSFVK?=
 =?utf-8?B?OWd1WVpJaGVncU5Qd1c5YitvRjQzRWJiUm9nWEtWVWw3T05SVll2YmdvSnY2?=
 =?utf-8?B?cWF2VGwxWk4wMWJoUWpkNlE5bUsramlJVWx2NzVmamo2d2xiTFhTSC9iR2ht?=
 =?utf-8?B?ZWhURHBJOE9lZlgzbDd1aDZLN3UyMlRwS1VPUmdqS2NNbFh5NkxwYXRKVnQ4?=
 =?utf-8?B?SHEyWENDTFUxTDdsZUtVQmRWVWsxL0t4a1dyaXVneVJOSFRmWjBWOGpWNWdD?=
 =?utf-8?B?RnZKZ01IYmppUmJJNGw3bnFkRm8xbVFaWFQ1STZiWUVacEs2c2pGTnFRbitp?=
 =?utf-8?B?MTVIdFB1c1J0bTdOMXI3L1lLa0YraGw2VFp3c0MyNFB4bFM5b3FsNHA4U2Rt?=
 =?utf-8?B?b1E5YkNsb0IybHBtTnhaOWRaMWF2cXdEMklaUVp5ZG5uclA1di9kMFhvTEUr?=
 =?utf-8?B?KzBlWUo1amhCSU9wWTBNMlp1d3ZZSFRUWklUYVZGZ1Y2Vm1XcVphSU1BcGp3?=
 =?utf-8?B?ODdjamxpMitzUHQzQVVCV2JXZGYzN3JoZ0lSVW4wR2M1cHlxY3FlOXJpVndH?=
 =?utf-8?B?Wnd1UVByUWQvYVV2by9id0F5b3VuRmI4blE0T0xqV1phaVk4NkFML0hqVnJl?=
 =?utf-8?B?THVROEx4R3ErbjlWZHkzZUNhbVdNeDNocU1KR1F1MGM4UlIwTVJLZ1JuUWF2?=
 =?utf-8?B?Ym95c2pDaGttRnh3aWtTYkh5cXQ1ajNJMWNkQzFKWjZWVEsvQVdhS0wyWHR3?=
 =?utf-8?B?WXJBc2RPeTQ4anFvQWp3OURtVmd1SGJhcTJRVkdZYUNLYnlXcitwclMrNmg4?=
 =?utf-8?B?Tk13UStGTlZDRVhmY3lmNFNLVTM3dTlUYWQyT3VWd2JhVVFXV0ZMbXlEbmtO?=
 =?utf-8?B?TXcxWHoyVlRrdS9hWWtuRTFtUitpTzZmMUNEVU44UzdsZjVLaEFHMW1OWVpw?=
 =?utf-8?B?VzUzbEdleTIxamI4ZzNTaVY5YUVNdnNqVnpsK29PY2huK0MvQjUyUzBod05n?=
 =?utf-8?B?ZUJXS1Fvak1ROU80TjcyVEF4R2psWm00UDVBeEduWXAyMnhXU2YyNnVRTlBY?=
 =?utf-8?B?S2FISlZKdWplbzNpRERzN1lnZW5OOTQ3Z0ovOERqVGViWmM4OU8vVHpydGs1?=
 =?utf-8?B?VVIzQU5jcTM5RGlrYVVjZjdhV3pJc3JiaWo5TWF6ZTJVczBlVWxtdjlLYWk0?=
 =?utf-8?B?ZHk3T0dXUzVlazZSeE1SVFU2c3psYjV0VFVSM0tnUzVBSVZPckoxTlRhNDli?=
 =?utf-8?B?d0Z0aEdRNTNXQWgzRWVzRE9lU0I4T2NKejdSM0lJbkNJcXM1N2JWOUR4ejRC?=
 =?utf-8?B?bjRKYXJSWllWaU1wcVNFVTFvNHZseVRnTmZTRkRKbFhUZ1RHdGNWRGdPb2FN?=
 =?utf-8?B?Z0lZN2hBaHEvREgvRmdhb1N0WmxhcGs3TktHbU5rSHFISENWUkZGUWxmSFRa?=
 =?utf-8?B?eVJmY1h5S1MxaWtPVjhlbHlybEk1cGliTWltN0VPNGNoUGpWaUdSQmlHOWhr?=
 =?utf-8?B?NXY5NTdqemJ3OE9wTU9oc2pZdkVTdlZpSUdSWXJsUlA2ZFJMS21TNWFXdURF?=
 =?utf-8?B?VHdwTjFva3c3UGtFZ0lOSzdMbURvZ3lGemlETmlMR2pONWsvdDJlTlhOOER4?=
 =?utf-8?B?WFFQOXdRSHdWbmJvWlpnQm0wMWtoLzMyc3JtT0c3Z0xQY2FYL2o5YVFnQkpq?=
 =?utf-8?B?cndob1BtWk9ER0lhZ2hYSDFNQ1BnNEpNSnNLcURkUXFHdGNiMVZZV3RZOXpL?=
 =?utf-8?B?bStJVzI1YVhiMHkvMDhkQmVhc2haZWNZaEEwOFBwOEZab2xPazF2R2xvY3Fi?=
 =?utf-8?Q?qhuA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63703a3-a842-4ef6-8bf1-08dc8eb223be
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2024 09:44:53.4537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hp5QwzIzxvfBLGubQOGphqFycetjiJ4HIxshjatXHWyfpaM3fBOWZ/V5Ze0SRLlu4zEHgcBlnl+w9mRTeBpKjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9129

DQo+IEZyb206IEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+IFNlbnQ6IE1vbmRheSwg
SnVuZSAxNywgMjAyNCAzOjA5IFBNDQo+IA0KPiBNb24sIEp1biAxNywgMjAyNCBhdCAwNDo1Nzoy
M0FNIENFU1QsIHBhcmF2QG52aWRpYS5jb20gd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiBGcm9tOiBK
YXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEp1bmUg
MTcsIDIwMjQgNzoxOCBBTQ0KPiA+Pg0KPiA+PiBPbiBXZWQsIEp1biAxMiwgMjAyNCBhdCAyOjMw
4oCvUE0gSmlyaSBQaXJrbyA8amlyaUByZXNudWxsaS51cz4gd3JvdGU6DQo+ID4+ID4NCj4gPj4g
PiBXZWQsIEp1biAxMiwgMjAyNCBhdCAwMzo1ODoxMEFNIENFU1QsIGt1YmFAa2VybmVsLm9yZyB3
cm90ZToNCj4gPj4gPiA+T24gVHVlLCAxMSBKdW4gMjAyNCAxMzozMjozMiArMDgwMCBDaW5keSBM
dSB3cm90ZToNCj4gPj4gPiA+PiBBZGQgbmV3IFVBUEkgdG8gc3VwcG9ydCB0aGUgbWFjIGFkZHJl
c3MgZnJvbSB2ZHBhIHRvb2wgRnVuY3Rpb24NCj4gPj4gPiA+PiB2ZHBhX25sX2NtZF9kZXZfY29u
ZmlnX3NldF9kb2l0KCkgd2lsbCBnZXQgdGhlIE1BQyBhZGRyZXNzIGZyb20NCj4gPj4gPiA+PiB0
aGUgdmRwYSB0b29sIGFuZCB0aGVuIHNldCBpdCB0byB0aGUgZGV2aWNlLg0KPiA+PiA+ID4+DQo+
ID4+ID4gPj4gVGhlIHVzYWdlIGlzOiB2ZHBhIGRldiBzZXQgbmFtZSB2ZHBhX25hbWUgbWFjICoq
OioqOioqOioqOioqOioqDQo+ID4+ID4gPg0KPiA+PiA+ID5XaHkgZG9uJ3QgeW91IHVzZSBkZXZs
aW5rPw0KPiA+PiA+DQo+ID4+ID4gRmFpciBxdWVzdGlvbi4gV2h5IGRvZXMgdmRwYS1zcGVjaWZp
YyB1YXBpIGV2ZW4gZXhpc3Q/IFRvIGhhdmUNCj4gPj4gPiBkcml2ZXItc3BlY2lmaWMgdWFwaSBE
b2VzIG5vdCBtYWtlIGFueSBzZW5zZSB0byBtZSA6Lw0KPiA+Pg0KPiA+PiBJdCBjYW1lIHdpdGgg
ZGV2bGluayBmaXJzdCBhY3R1YWxseSwgYnV0IHN3aXRjaGVkIHRvIGEgZGVkaWNhdGVkIHVBUEku
DQo+ID4+DQo+ID4+IFBhcmF2KGNjZWQpIG1heSBleHBsYWluIG1vcmUgaGVyZS4NCj4gPj4NCj4g
PkRldmxpbmsgY29uZmlndXJlcyBmdW5jdGlvbiBsZXZlbCBtYWMgdGhhdCBhcHBsaWVzIHRvIGFs
bCBwcm90b2NvbCBkZXZpY2VzDQo+ICh2ZHBhLCByZG1hLCBuZXRkZXYpIGV0Yy4NCj4gPkFkZGl0
aW9uYWxseSwgdmRwYSBkZXZpY2UgbGV2ZWwgbWFjIGNhbiBiZSBkaWZmZXJlbnQgKGFuIGFkZGl0
aW9uYWwgb25lKSB0bw0KPiBhcHBseSB0byBvbmx5IHZkcGEgdHJhZmZpYy4NCj4gPkhlbmNlIGRl
ZGljYXRlZCB1QVBJIHdhcyBhZGRlZC4NCj4gDQo+IFRoZXJlIGlzIDE6MSByZWxhdGlvbiBiZXR3
ZWVuIHZkcGEgaW5zdGFuY2UgYW5kIGRldmxpbmsgcG9ydCwgaXNuJ3QgaXQ/DQo+IFRoZW4gd2Ug
aGF2ZToNCj4gICAgICAgIGRldmxpbmsgcG9ydCBmdW5jdGlvbiBzZXQgREVWL1BPUlRfSU5ERVgg
aHdfYWRkciBBRERSDQo+IA0KQWJvdmUgY29tbWFuZCBpcyBwcml2aWxlZ2UgY29tbWFuZCBkb25l
IGJ5IHRoZSBoeXBlcnZpc29yIG9uIHRoZSBwb3J0IGZ1bmN0aW9uLg0KVnBkYSBsZXZlbCBzZXR0
aW5nIHRoZSBtYWMgaXMgc2ltaWxhciB0byBhIGZ1bmN0aW9uIG93bmVyIGRyaXZlciBzZXR0aW5n
IHRoZSBtYWMgb24gdGhlIHNlbGYgbmV0ZGV2IChldmVuIHRob3VnaCBkZXZsaW5rIHNpZGUgaGFz
IGNvbmZpZ3VyZWQgc29tZSBtYWMgZm9yIGl0KS4NCkZvciBleGFtcGxlLA0KJCBpcCBsaW5rIHNl
dCBkZXYgd2xhbjEgYWRkcmVzcyAwMDoxMToyMjozMzo0NDo1NQ0KDQo+IFdoaWNoIGRvZXMgZXhh
Y3RseSB3aGF0IHlvdSBuZWVkLCBjb25maWd1cmUgZnVuY3Rpb24gaHcgYWRkcmVzcyAobWFjKS4N
Cj4gDQo+IFdoZW4geW91IHNheSBWRFBBIHRyYWZmaWMsIGRvIHlvdSBzdWdnZXN0IHRoZXJlIG1p
Z2h0IGJlIFZEUEEgaW5zdGFuY2UgYW5kDQo+IG5ldGRldiBydW5uaW5nIG9uIHRoZSBzYW1lIFZG
IGluIHBhcmFsbGVsLiBJZiB5ZXMsIGRvIHdlIGhhdmUgMiBlc3dpdGNoIHBvcnQNCj4gcmVwcmVz
ZW50b3JzIHRvIGJlIHNlcGFyYXRlbHkgdXNlZCB0byBzdGVlciB0aGUgdHJhZmZpYz8NCj4gSWYg
bm8sIGhvdyBpcyB0aGF0IHN1cHBvc2VkIHRvIGJlIHdvcmtpbmc/DQpBIGVzd2l0Y2ggbWF5IGFs
bG93IGluY29taW5nIGFuZCBvdXRnb2luZyB0cmFmZmljIGZyb20gbXVsdGlwbGUgbWFjIGFkZHJl
c3NlcyBsZWZ0IHRvIHRoZSB0YyBydWxlcyB0byBkZWNpZGUuDQpJdCBkb2VzIG5vdCBuZWVkIHR3
byBlc3dpdGNoIHBvcnRzLg0K

