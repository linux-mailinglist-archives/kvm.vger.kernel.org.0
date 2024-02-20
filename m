Return-Path: <kvm+bounces-9150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5141C85B6CB
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE373281D4E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7F35FB83;
	Tue, 20 Feb 2024 09:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VDO3ibvb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F055CDC4;
	Tue, 20 Feb 2024 09:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708420062; cv=fail; b=j0/glYspI2MFN3sj5ZSjXiU5TkJ2QBYLD6cv+nl7/CdhGyGmuCubMMZ04qv57HvvcplfaykYuq2ppjUI1es3I962ihsWjOlyNJunYdoIatoQPEsjbz9IvDGqwYkqk2DbgP3ujb/EWY8jf068P5HhrTZjFhefS4IJPKTufK7HhZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708420062; c=relaxed/simple;
	bh=S6O8a2dJu00sj8YriheWKThr0Mx1uxdeYm3o6oz5T5E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=N2iO/oH0gUnzifcRUVXwJDwju7lONFffMEoGas4qGuZY2FBqjI0yzLvuFYdVGwzoNLi3Wod4BGOdqhzLX+aorSpc+xn9qg2ekTTlXklX7/6phe0BPmluFfB4iSRS59dPQLBhfkTIgNexZYKmmKMDR+3v8Vp5gWwcx7C8pp/2TuQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VDO3ibvb; arc=fail smtp.client-ip=40.107.94.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqZU/8qtPejOc46ywJ0p3+CLXN60NOU5WU36rCt3LJESui9hikmOC/GDnnYYeS2kb+FleVVIkzlbwsXQ5IBukwZzW9LMqt4LzzXmxS0TtDYr0UM3hB8pTuIUo0n9hVC/TIve4Uu6TxXYRC8yo4dpGOzJY9QntiKPtmjgy6i8Nq6hJk7POud5T7oN7RbCBTmrznQaoRXb9AOoRdaXs1KcXyHWF6FKnmA0i5wWm3xZIfJpDZiKeLPS5bR5KVHOwaiopFg/rjAI73uiVkfgr8zIYTAIrDnARMGUBT8IPhWh+YnSmS3A0sZXcKdgDRM61a5tMQkQQx7ZIbmlpE6ZGawASA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6O8a2dJu00sj8YriheWKThr0Mx1uxdeYm3o6oz5T5E=;
 b=A+yG2VPfOOuR8P3BHIgydA9tX0BSsXaDBFqBRxpxYc+yiVP2GffRZ71e4SEt1eRxhuFNrLje08bbiVk1Kh87QKn9//DcBF2SUkDUnrCFjLLj8qIRKI1HAjk3hRndUpn9kUMzPlLa+HnWuBRUMobNE0Cuomcjtx+IwIdOMBK3YbmDWouLkj3B9T1gcp6soq2poiOXPACSe4oJMZvJMbSxS0oU8VzqnTLfceyY/3Ot4yiVOiJcNxpQCB8vWAGrvAKbO/CoVyLjfCMmKfQxvmDdkVonf6mKZGe++bAWQpdEFY0ib4cIJ1QJ6I2CZi/NHaAuiYFe/lcY6A4mNyJWgOnOog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6O8a2dJu00sj8YriheWKThr0Mx1uxdeYm3o6oz5T5E=;
 b=VDO3ibvbTfFiSG2rJM0gDsRIDwnKxbSo/xaPAfO14pUj5eT3bjmtT6guxGqnxLLedLbsBvQHiMQpuH7Rzy9r/Sn0vBMMHw0NZTbr+uh4En8VZHsbkHNvHCkaFFP+G6Fz7eByAO/+UG6Lw9dWMWBeMEahVmHfJOMO9+xTR7FVlxsPFB5V4EKFQ+ne3GOfwmQ0OPp5T5h3m6o+wgrh2CDlHKnHuJqvml84asVuCvYoM/JXBduYFJ4/8Ke0uWUlXbvj5A3a8Az2e4jjeiMmIGuHT9kofyTNzSnKtGA0zHqBcBNuQcTRJpWa6xx3HdkCoqqgFvw5oL6CYUi/iwrIZa+how==
Received: from SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Tue, 20 Feb
 2024 09:07:37 +0000
Received: from SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89]) by SA1PR12MB6870.namprd12.prod.outlook.com
 ([fe80::97d8:a505:950c:6e89%4]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 09:07:36 +0000
From: Zhi Wang <zhiw@nvidia.com>
To: Ankit Agrawal <ankita@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "surenb@google.com" <surenb@google.com>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "ardb@kernel.org"
	<ardb@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"shahuang@redhat.com" <shahuang@redhat.com>, "ricarkol@google.com"
	<ricarkol@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "rananta@google.com"
	<rananta@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"david@redhat.com" <david@redhat.com>, "linus.walleij@linaro.org"
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>
CC: Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy Currid
	<ACurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John Hubbard
	<jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Topic: [PATCH v8 2/4] mm: introduce new flag to indicate wc safe
Thread-Index: AQHaY86q3o4vxPMh/EWney6fGMJmL7ES5W4AgAAHBICAAARtgA==
Date: Tue, 20 Feb 2024 09:07:36 +0000
Message-ID: <b8630236-a081-489e-86aa-efbb39d3d9fa@nvidia.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
In-Reply-To:
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6870:EE_|PH0PR12MB5605:EE_
x-ms-office365-filtering-correlation-id: a70fb582-3deb-4695-c04b-08dc31f361cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Er8okpPBi4zzLEr6EOZGp4IRdF2bswAlZ1W37qYheCVonSKIEYiHK9JQApHaMcteXdAZu76+RUUGydHkcgXxYHUfY4A2339z1ogvIcjm8yKMiy4mpdS06lY5M5iqyXlv/Mf9Q3diJvciLssQ9QJSBGHLTB7EURGVKHvh79ln8JimH/5uwHQXl0+QMaU2ZlDc5hjq8DqlgTl+c+dXAInyXd90b6ax5MczRoWPlBGY9yZQj+pAxdPv1Yl3q2f4aPJ27QjJ7+jJiBLsKOFlq45RCvVo/R2or5q/2O96hqW4kr0A5/ij+KGxOrNdjo4ZQ4ShulgMrZPxwrowTt4fUhmgpnXDUdFKCekTVqT/q/jC0PksEufSGJfXwyThr/VnywACxruft0L9pu55CRVlD1vB4G34EmYgUP41PGhS7pF78v3f5kPF8uka0DVbAQZ28UkPCOzhx8uTaGCDg3/AwAIWrnMkgJXWIDMQQOUEa7ntGSC1U1gh4TMspStZe6AIdAzGHRkgn+GGe9U9GUKWd4EVoa58lX+l1EhstMxrmxGMk9tYd7uywaFCIUlwDppxyADil0dT8JAFcf2OlTKcc0FnrilA9SdsGH0jsaMBwz+AgkzBiU8OUiMP/6Vl9EeWckCZh0Xtclz5wUmezYTv2RA0XA==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6870.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dllpWU9hSkVyay9jTStkZVVZd1ZCc3d5WnJuaDVJT2lQSG5UV21XUkZocm1h?=
 =?utf-8?B?di9va0d0VVBmVU9mWjNsTHJwNHJVbjI5SDVucmR6RmlIbXNTZUNPOXpRUEly?=
 =?utf-8?B?WDl4VmxyWDJxbVZsLzdXMXJ6UXE5TVVsQnRLRXJqM2s0MmwvWTcwVkc2amFq?=
 =?utf-8?B?Vk9lbFNEMHg4ekRJOWRoYWZHdXRiWVhLU2ZxS1VhN0lwK2QrZDVldXgwbGNZ?=
 =?utf-8?B?RGZ4UlRwbVlMMkJhOGg4emd5K0xNQU5QL0dsYzZSb1RYK2Z1Z2R0dlg5T2xC?=
 =?utf-8?B?eGpmb0dZRHU4VVNTT0YxYU5qVkxEMHFUN0F1WEhNb1djcGNIVEV4UVJzQlc2?=
 =?utf-8?B?cFNrbWJ3d2NSNitVL3g2OE5Ga2ppZEs4NXBZaGp3V2FmZ1h2L3gyVktncTdZ?=
 =?utf-8?B?OHhtOEp0QlI0WjJ3YUJNOVJtZ0c5OWVGaUEvZVhTR1NKM1A0S3NEMll1NmtV?=
 =?utf-8?B?bld1VzRzOHc5WG5iMVBuR1NQSE1QVUFFSHF3VnZPK0Ntd1cwQVJNd1dFZ2xI?=
 =?utf-8?B?UnR3dXNhbTR1ZW9oM1l0Q3VQbkJhcXNSVis1MWpxTytNQkRhMWxlOVFJUTVF?=
 =?utf-8?B?ak9GbEhyTHJuYkpkbmlXUEJETWgwaWxOODQ3bmkyMUxpY2hEOGY1QUs1bUQ2?=
 =?utf-8?B?d001UG9yVVpOcFdaN3N3V2wrb1o0WHp1TjhQVXF0SFQ0aHUvSGVvNDYrQnAx?=
 =?utf-8?B?TzlJdDFHN29QaUlSRklONGRpL1RNVWNTSDBMcEowV0FjQTRLeitaOC9aQlFN?=
 =?utf-8?B?cEdhdUIxTDhnYkYvY3FFN3BQWTdjUlpyb0NHVGRZaFlDMEFMNjd1L3lwbHM5?=
 =?utf-8?B?ZWlxdFRGbzBNc0g5em1hTGlWb29WYmlSUCswSEd0T3dWVDhYTTlNcXludkJ3?=
 =?utf-8?B?MSs4WERyWDRVaWtWUFFJQzdJSUhYZ2VHV1hwNFk4RzNCL0d5aWZnRGhhUGs4?=
 =?utf-8?B?VFJsZVJOU3puWUpyYUZJQldEVUs3cEsxWVhvUEQ1cXdRZFI1YmxBam5DSG9J?=
 =?utf-8?B?clREU3p2QmZnbWtka3Z5NFp1Q2FKcS8zMm1OOFRxUGJIdzIrU2U4c3JYRE1a?=
 =?utf-8?B?QXVtYWRFNG9EaGhWclhwU2wvcTcxQ0kyeVRmbkE5V3JxZDBrVHBCZHJqNit2?=
 =?utf-8?B?TjhzanBuamVWUzVpaGkyM0Q4RzlvWTlzWEVpaEJITkdGcm9tRHJjTDkrcnBO?=
 =?utf-8?B?OTV1bUhwMWNkRG1kR3JRVUw0YVVLVXpvVlIwYkVEbzNXN3lRSmtidmNXR1VJ?=
 =?utf-8?B?SEFubExxL0RtNHhmM3ZRM0szZEFIeXAzRlFXcGVNWGQwWHBhUnliMEwyK3dH?=
 =?utf-8?B?b1l2QzNWUnVNS0dTTy9lWExtYWlCak4yMzZJV2ZmY3E5VnliOHhub0NkMDlh?=
 =?utf-8?B?RnZPck4vRFhCeWNERzhGUXN6Z0ZnZWdpa0I2bWhtcW9XT1FDNnI1WmJlVzY5?=
 =?utf-8?B?VGZwYTErbVlRU2NGUFprV0NHang0VDJvTlo0c2IxWHJvOUdUWmNtSVpKZGJh?=
 =?utf-8?B?M0loYlB4ZFFJcTFEem5ibDY5dlpBditlZ1pGTHdzck5wc3V0dk8yZlRaa3Ar?=
 =?utf-8?B?UmhFMHZUK1YyN2ZSN3M0N1laVHdGeGczZGxGTktTYlc1RWdCSzVMY1lhNWJp?=
 =?utf-8?B?T3pzNGpDZVdZOGlKbnpEd3M5VmJkc3pHY1pRdzBWWHdrZWxFQkpsMk1ZWk9S?=
 =?utf-8?B?WjY2N3QvcFJRVnFRMDNyZGRjdW9QQjRacmxrQUNXaHlDb0tPaUdPbS82VWd2?=
 =?utf-8?B?ZWFpNUg3YzNqdEV2UjU3TzlaSDZUMm5ZTjhrN2lpR0JDSjVTKzREeExtR2NX?=
 =?utf-8?B?ZjlkTHlPVkJiSEI4WXlVWWpGQit2cTNKWHFEbEtLS2MwM1hEVHBUNmZkZEUr?=
 =?utf-8?B?ekZNRExVcnN6SnlVaWtySDhjUEFBMmRMcGtmOVZ4dGFzTTVxY0ZGQ3hrU0Fs?=
 =?utf-8?B?VTBFYXMzWEd5YllUZ0ZCdFExenFMb1FMdlVCUC95SEtiODdscFZrZ0MxOUU0?=
 =?utf-8?B?R2Y0K2xsVjRCM1lFdEREekZVVWZpNXh5SkQyaVcxTnF6Ynh5QUxqWVZHZTND?=
 =?utf-8?B?OFp4WTJ5RXlpbWc2YnVXTDVtckVTREI1cFZIMWc5ZFpvRUxmTzFKcWtmUFlk?=
 =?utf-8?Q?fNPU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C27405F8875BD4EB070092C4F991937@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6870.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a70fb582-3deb-4695-c04b-08dc31f361cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 09:07:36.6970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cXtUkhqBgVQG6gjYDZo/yLFrBqAPghtQHpHnF4F5LldYxmGXJWUbK5x7DfHTXQ+x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605

T24gMi8yMC8yNCAwODo1MSwgQW5raXQgQWdyYXdhbCB3cm90ZToNCj4+PiBUbyBzYWZlbHkgdXNl
IFZGSU8gaW4gS1ZNIHRoZSBwbGF0Zm9ybSBtdXN0IGd1YXJhbnRlZSBmdWxsIHNhZmV0eSBpbiB0
aGUNCj4+PiBndWVzdCB3aGVyZSBubyBhY3Rpb24gdGFrZW4gYWdhaW5zdCBhIE1NSU8gbWFwcGlu
ZyBjYW4gdHJpZ2dlciBhbg0KPj4+IHVuY29udGFpbmVkIGZhaWx1cmUuIFdlIGJlbGl2ZSB0aGF0
IG1vc3QgVkZJTyBQQ0kgcGxhdGZvcm1zIHN1cHBvcnQgdGhpcw0KPj4NCj4+IEEgbml0LCBsZXQn
cyB1c2UgcGFzc2l2ZSB2b2ljZSBpbiB0aGUgcGF0Y2ggY29tbWVudC4gQWxzbyBiZWxpdmUgaXMg
bW9zdGx5DQo+PiBhIHR5cG8uDQo+IA0KPiBTdXJlLCB3aWxsIGRvLg0KQWxzbyBwYXRjaCA0IGhh
cyB0aGUgc2FtZSBuaXQuIEl0IHNob3VsZCBiZSBmaXhlZCBhcyB3ZWxsLg0K

