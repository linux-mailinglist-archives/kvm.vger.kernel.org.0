Return-Path: <kvm+bounces-9167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C8185B7F2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 10:45:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5086E2831E2
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 09:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C8E67E99;
	Tue, 20 Feb 2024 09:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MhSQRstp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714A67E7A;
	Tue, 20 Feb 2024 09:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708422035; cv=fail; b=n7t7t5L4+Omq2uHrdNnToVkofEtZJlARIYdAeWCfDWA03GSIwbI+0nTOigVT10RKf3RexyUK2tf6NlQCUNAtWfgFbggQH92Jwc5FSoBVTfjbC/EGfO+RvAsGNT+eb6vuVaq0hQXb1QMVd5fH+Xqgi0T/qp5cwHdnUOv2bbAAGeY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708422035; c=relaxed/simple;
	bh=OoA1b7EZr7+fum+dtXHhl4OTukIlRlG+EnUyq0dNuog=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F0h9J+t4vhKtlnffY2U8A2WXbkGd0Ru9Ozl+n/qaagOWovymzgtgErZUnKtuWStCiIF47x6JbGMpxrJLDkX4gXMtcy5OnKVSecX+3EIokcSod+kp5nKpjSko+Hxy/G2Td6cbIfCChlmJzGQoGjqP7aj51uP5bV5esbmHB//YLCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MhSQRstp; arc=fail smtp.client-ip=40.107.95.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QyPbyUmaFA3TSdO4vqaJ27ZxkLUhFEyS6BTHFcdk01TvAa4GJBgcmeZ5inOm3jq0dOiZvQy0bsJrQjYbaFSMPhMmNIfQKYsPQR4qdJ7f65UU/9CLGJPLBgU8DVOwomfBbzpZqoSAo3Fn5gWmC0sz/qj1OtShZhcBEChsSbroAQgLvtwqvdDwKjwEsGgzBD0ma/dAkfFKol02Ade5Sm3915bAE2QxAybbCQ6nxVVeD02RYMsaAMov+0g4sQuowE3PIL3hifysgavgXuxY3ta8WtXiiAigdEMIEH2wvX2gvX9qJZgBmpAMNfJbP+32HvJTi1mmA5LP6UYsbqrUbO7yqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OoA1b7EZr7+fum+dtXHhl4OTukIlRlG+EnUyq0dNuog=;
 b=NNSxF3u6n+J4hpytro1Cz5JmM3JNJ3O/22J1r64Eka8wralAjfTvsfoQP/8n60vd4E+Lwl1mu6f3Kpa58U/n4jjqI4fkwTjvBCsqi4bUXozTestvZIa6LQhUaIa/UWd2XhlWlDfZHYplT4F/rk6ijaiQbmsuEK1874YMnNy7pLBa2lqXCehXUX8a4XCCVgkR5PyRDaGQtIYSgHUkExnROu/+rP+t+e4IUZde3nKlObVppJn7u9sTzTrw7v3LbAvsE2jrIel1r7jGr5FauDcnVUcAkQK/8vgxnW8bRUseJOBlrqBo1RQdxdudz5g3/CL1CbCMjfan7GhbrZ60x4jrfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OoA1b7EZr7+fum+dtXHhl4OTukIlRlG+EnUyq0dNuog=;
 b=MhSQRstpeM4T0kWWJm7subEm8Xw3a78QjmaoVMogEmonkUicYC2811yqNlo2feRnE5EmTe3W597n7z3UxID6IbnS8JDj6Do7bPiR0I0LQogetAa2qT5XNlLu69qGrZ7SWo6IwcdMOa4Ma4Q9MgZQXdU9pI6zDcjNh+V4DqjQKKcCpV9zppPYGi50EAJ9+jtLtggO0G4+59cBRK1tQUGuqSGarfosVgmbNsvrFgsaWy1R6DiGjOokgGsb29QzdZi8Jd1yrVKtQ3VqFOwny+qQFA6o4+ott6oXERoTzpKyoEWZMwZ7z0klw+OuNvM8EXKzszOgzNMSJTpL3KC+7sV5rw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB8478.namprd12.prod.outlook.com (2603:10b6:8:15a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.12; Tue, 20 Feb
 2024 09:40:31 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.016; Tue, 20 Feb 2024
 09:40:31 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Zhi Wang <zhiw@nvidia.com>, David Hildenbrand <david@redhat.com>, Jason
 Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "james.morse@arm.com"
	<james.morse@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "reinette.chatre@intel.com"
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
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>, "bhe@redhat.com"
	<bhe@redhat.com>
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
Thread-Index: AQHaY86qDQVcMVySRkSmtPnSJvq8YrES5W+AgAAGuiSAAAVHgIAABr6AgAABlRY=
Date: Tue, 20 Feb 2024 09:40:31 +0000
Message-ID:
 <SA1PR12MB719965C8386AB1A309397B49B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220072926.6466-1-ankita@nvidia.com>
 <20240220072926.6466-3-ankita@nvidia.com>
 <bc5cdc2e-50d8-435a-8f9d-a0053a99598d@nvidia.com>
 <SA1PR12MB71992963218C5753F346B3D7B0502@SA1PR12MB7199.namprd12.prod.outlook.com>
 <6ca94bf1-68b4-4a81-8cd0-d86683e0b12c@redhat.com>
 <709fe097-9cc0-4d61-89e5-65147f541e95@nvidia.com>
In-Reply-To: <709fe097-9cc0-4d61-89e5-65147f541e95@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB8478:EE_
x-ms-office365-filtering-correlation-id: 21074f60-78ec-49be-7d0e-08dc31f7facd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 wUyCYeFVM2uIU63kJQijxkyCvLZ9DKSAMsa5/QG48b/Q6O/eLNYHQrT48aqwNvb5oxd+9Gj+R8sywOj4p7S84gVcdbFpyIcsSsvpgnTnjyZa02jUjj3pyfq2sqCvAtEcMwpobubJoj0HXoYxqKq6xcokeYjGW4/7xLgKipSdvq2p+/S/Il05zccS/mIVO4gVufROlaqxI1lRF4INJnvljYN1BAgbsrzP1/55xCfIMUq6ohbUkRf81e9lhcvbsKO25PyFHDJPpFDnNVEBrpHlKO/fubh0ueuWk/lxPkR5ZJ+lP6tC7cCk1qOcxP/imlG+rBaXzYPbR0vVCUv6ap0mj0t80hur4yHtY+uGkBnq5nrnzAuI5FQ5CHR2HWq6vsRaFnQKqXqV/wyRwROCxJpiNkJud6EhIDFbgiDKgmuOQ7uKQ1V0tTBfd/46ryUv5aQ2kGHBu5RyTaa92RSiCy9iNrv7F81P9ngl5SX4dtKtv6sh34X3n+YqlvG3B6Qeu38rkqejJuWm3pis9Ib3DsWnQFXfwdSmvOafhKpCMRQuPHlgD6naUWXAiWQWKw5p6/OPOT2nWRHUY+q77j3bDjsvjQE2MIUv62VuJ6c3+j7+lWDVT4dy/fr6W1s7Dl8ClBqSBUxfxM/YJtUfPFHKgGDlLg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?px0rQZEMGTMTcNmbSroK0QHPAcLq+hHucdq5lCK8e/aumHleEcijE2f6O3?=
 =?iso-8859-1?Q?sn5ToiPkheUGBY6PNvo2/GlHU8K7iNUzYNWQ76gpo2d/k5ML451Idgd/oF?=
 =?iso-8859-1?Q?ABZ1Z/RJXxdoom3pifEFd+pVausD6Jgny8SP+aizdXzDWkO61z0+kKAyvu?=
 =?iso-8859-1?Q?4PfJHZwHf4t7PUpzUCD3ypoIYgQ3LV4/tIU6WkGr4jSZ6ovyJWMuBZ+rVC?=
 =?iso-8859-1?Q?sTQh9xOwxEfFaiHBoshH88YYaQ3lv+R+WUO60s7wV3mcgfq6PWpWpgwpky?=
 =?iso-8859-1?Q?bjMztJUNAVRPSOs98AXS7Vo1swGzFFK1cKAOgDk8N0MaWNSSikRkN5fDOI?=
 =?iso-8859-1?Q?7BU9l6SS4/RXt02jrcWf57/x72YEYOEn6ZDcqrLI81GXAcaD66MxH7nBQv?=
 =?iso-8859-1?Q?pH0NqQKXVcNtuTbGtHKNk/J9tvbS5pOHblf4yjkeJDGd3srItDzh0wQFve?=
 =?iso-8859-1?Q?CTvfGnlFOQTfH+H0yTu+E6AisvFJL40HpdG6qMRboNMQTeKNdUQ37XwQlP?=
 =?iso-8859-1?Q?jRRIJdqIjYm3f7nIUbNuxSBIWy98GejBsasNx1J04kb7OEsPH6LTQmh6QD?=
 =?iso-8859-1?Q?K7Oq7dyEoSdq5I51Ove6X0Hp2PmD2jNhfpxB5oO2G6v+vcY2YGD8b6IwCq?=
 =?iso-8859-1?Q?opIVdL7MLnhjr878ld/fHawlzidGCyuMzs4tgQ6345AZuUw18NSNG/ftd0?=
 =?iso-8859-1?Q?U8yql7o9ko0RktnOd8wYknlwi1ysB8+R+aqTrLuVe/itakrz/Y0JA0hQ9Y?=
 =?iso-8859-1?Q?oZ2PFJHxI+ozqtu+yOmzKRrLPIrw8VvXJVmsjeWjVqckZNuisSCy/PaOHy?=
 =?iso-8859-1?Q?GxwYF9/S2oDyNLQBLY8rSE1bT1rL7UqYa29g9jJK58U8BZMGRUHGNBLOuj?=
 =?iso-8859-1?Q?6/DthNvcQeT7ogUNPyE8q4VcaChrQKHQy1t/BmI+3yJ2e5KNO+BaR9kQoc?=
 =?iso-8859-1?Q?qJMTZUnZs9yJhq4dTob+oGTpGd1+rvWikKnFkG1PeYurN9tQmnZO1y72nV?=
 =?iso-8859-1?Q?p8NwL3Cz35rKPzbX9z3pIogpfNSVHMOzKk9oJphYuNXK/OWe7ZJVZjR0XF?=
 =?iso-8859-1?Q?90r2+2jdpYOEpxjurqcGFWy95snM+t03bU60I9J83AdRpfdhhi9uApQmVY?=
 =?iso-8859-1?Q?W2mFkB/U+ng/bVQJ2cVfkZleFsObvZ0dgCzOGm0/K/r0srgl4KPx4BwkSV?=
 =?iso-8859-1?Q?Q5mc8SYQ4wMYUnZaeFVUZ2k55JVTpXrS4fdRfotUtZlwUmaaN7K0VRd+zO?=
 =?iso-8859-1?Q?6H9kPkdRYg8PRVMAkCxXrYYdlHaPZpFC+xk2bQDq5xXT4PKUI6vpH+wE22?=
 =?iso-8859-1?Q?MPmSRtSs31QA4COmzj5USJmMcve7JYPoNBNlO/6yJNKsciymJ3AdC7q1Z3?=
 =?iso-8859-1?Q?VvQ81dp7jfUTFfOAtylXAGsZQTGIoxqPLihllyX34wAB+obybIbGeY9YUL?=
 =?iso-8859-1?Q?GCDxtcN61tFKvXlBlmx9toUTZk4FMLu5+CRNY2jU+qWDugrQruRucEeBPx?=
 =?iso-8859-1?Q?JJ0xWEIPSHnrcXzlBKkkscar4XKMzGq7YA9mf+spTeHFRT0KvVxQZwA9Il?=
 =?iso-8859-1?Q?aqnkQgKBiX/kkApy5mrSJRgX+D/5b5C72YLFNBzpy3nr51VYQ3wb44rQgF?=
 =?iso-8859-1?Q?kgKl/YdUkyfXA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21074f60-78ec-49be-7d0e-08dc31f7facd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2024 09:40:31.3832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ICIStYgNOcE7j+cH7m3/VpiQu/1YT2xMNV/6HuF5BodBnksMtMJa4yV/vGvPCNnFJDwVpkYGhjbGvDuXv1VVLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8478

>>>>> To safely use VFIO in KVM the platform must guarantee full safety in=
=0A=
>>>>> the=0A=
>>>>> guest where no action taken against a MMIO mapping can trigger an=0A=
>>>>> uncontained failure. We belive that most VFIO PCI platforms support=
=0A=
>>>>> this=0A=
>>>>=0A=
>>>> A nit, let's use passive voice in the patch comment. Also belive is=0A=
>>>> mostly=0A=
>>>> a typo.=0A=
>>>=0A=
>>> Sure, will do.=0A=
>>>=0A=
>>=0A=
>> s/we expect/the expectation is that/=0A=
>> s/We belive/The assumption is/=0A=
>>=0A=
>> If it's just that, likely no need to resend. Maintainers usually can fix=
=0A=
>> that up when applying (otherwise, they'll let you know :) ).=0A=
>>=0A=
> Many thanks! :)=0A=
=0A=
Good to know, thanks David.=0A=

