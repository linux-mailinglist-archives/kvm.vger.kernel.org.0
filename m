Return-Path: <kvm+bounces-8583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43A3F852782
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 03:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADC701F23541
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 02:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13A479DF;
	Tue, 13 Feb 2024 02:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W5aecS6Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4F76FA8;
	Tue, 13 Feb 2024 02:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707791399; cv=fail; b=IyrsKTkwnNK1ZyhiXAyyct4w1Wuh+TFkHIyKJjlFORB3ozRLjamwfuqI858Tn/7aWA0BeVx/YrmaIpFvVeKOMZ7hAjH3IOkxhLDDAq6Wm4vCWp/Y3fPaAejRjeKVJyltI0EbA58Hi7+3m8x126Pge3/1ALbDbA8PqO//Zfv9XrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707791399; c=relaxed/simple;
	bh=6W7aGpLBbnqZo8CljubLQcH7VMlWVIsogtRTXeHHdaE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PzJ/LeOguKQahQPyqPAtPeqrfwr8P2IGC+dBxWDlSvGs+V9qI9PRrOrnKJiWxBMRHV69UeklZwYi53WUk/yeQhVM21+6rfj2Vij6J/RLOwbjFNDzOpU2SQmKGJm/IFhonTQFMRWAbbjjkT7H7d+B22vdR0wNIDne5ClPShWU4Xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W5aecS6Z; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cbkm6uyh9YoYhLNDaRQVqNleGJWulb8dy8akNuEdKllOsV3TMc2PbqgYYOYIEeAMHbCrklvyqaSXMENsVh6q0SnsvxVTIC5n4QC8jZDA/8bIJy9/WqyeMZs62PwhfxyM+ivWuP+0YuiwU/uYSiD0l30qvxUT97qOPUkV9ETjM95A9u2cSkCnJyctn4Nm9j8NPyHfQtx3rK/CVGVgIl3IMoldjQVryKhxU/LYTqz/tPvscXK1zRRfgV8WIKjiOu8FJeibAZd84rQZ9Rga4I+pd+nv7t9+Y5BdapoMPopyyqLRj56sE6uumRHmNZusls+/oiYv2D1HbLqj/XXAk/CZvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6W7aGpLBbnqZo8CljubLQcH7VMlWVIsogtRTXeHHdaE=;
 b=ADdYkvklQrkiJrW8h7YuBdg8z4uVm39vor9wjzKiAVp3dNRYy3JHfbd8O+xrUhW01tD4gL0W72+0RmP3XVg3CXCaHrpoVJ1lwDx2Tpc9J2DBQQyJxxvnoN1IaNsqYDFKUmOIieFTe1QIXVXHnrjvjH9IsdrV6o+sH1MsYEPh9zK2srurUAmI2lwSf3BT7sAvEMao4Il18pyfmZOj31g+R7wbQc5pdE3AQxRHBic4m5EVGEOOYi1xU/gVdA0ARXzzeSK2CSvVpwt8FBo9e/tOX3UVCtjQHdIgV9RV6A711YYWy/JgZBUhbuWDYxk2V2iQY0QtV7U9Da3sLPRR6bf2ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6W7aGpLBbnqZo8CljubLQcH7VMlWVIsogtRTXeHHdaE=;
 b=W5aecS6ZWSrNyZv3ifv6fQhH07PuyID2n002cSlEEGfR1Z3wy1Vs1niVyA3hUfC6hp5bd5kUddtMRkI/YjGPfnwcxUJUE3Griibz9+hpw9sqx0bOVRy6jhEl/jh7/0jRDORt4HkgYzseKWhz7j6GyKRrfzHE2DV+Idi/RkOv7OLd3m1ST0P+wV/i3fwkGChAUT2kN1alPkZ4LMc2su4F2g1hjRSuZ9AtelOqlwthVvuSR7XSZLVvou9RCUeM5ESc6cVP5bmECh6EVLRhwKoDAGoVA2wXQE2MEjFcmF+JYAEWgmLQZ0HzewtwyUVK/JOEg1WFVVqmJz7AcEtDametZw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB7867.namprd12.prod.outlook.com (2603:10b6:a03:4cd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.21; Tue, 13 Feb
 2024 02:29:52 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7292.013; Tue, 13 Feb 2024
 02:29:52 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>, "surenb@google.com"
	<surenb@google.com>, "stefanha@redhat.com" <stefanha@redhat.com>,
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>, "alex.williamson@redhat.com"
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
	<linus.walleij@linaro.org>, "bhe@redhat.com" <bhe@redhat.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt
 Ochs <mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Topic: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Thread-Index: AQHaXRJhBBixIQCoOUafo6w/JjtJN7EHKNkAgABk80Q=
Date: Tue, 13 Feb 2024 02:29:52 +0000
Message-ID:
 <SA1PR12MB7199B4F962B580A484BCAFCEB04F2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
 <Zcp-hIlV-ZEu0Jou@linux.dev>
In-Reply-To: <Zcp-hIlV-ZEu0Jou@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB7867:EE_
x-ms-office365-filtering-correlation-id: 2906c7af-0d78-4e1f-c030-08dc2c3ba89d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 6CMmLDEb4nvYx8LZkXb1qD5lWDIxiSM4Kig0RN6tlwOYmNlodKgw9WNXz76miWeNlHwvoDa8kfW4Yq2lZJ4YgF+AlT67graS7i48wk8ZJs2dNRlvcr2njDNGeWgcdy1er42YYZAW5xtUR5lGPkNU/oSz+voTDpkhaBpQJ/rN9RjjW7zk2MaIMMCqxt3uKGTAFoRrkkyQdw6fReQ8FF3gPEYKFigzT5bStw1kivlW+Na1DHsXvwFxXkKLIiIHQz4JaTwF4TvCQTeREvC2/A2sxUTglw448G1jMGkazgqBreimm38TYr7K/pyMNUfTr0AtogaJUTvYPYbpTQ4iq9784OmeShhLEQOgZx9lvU+9tl+mTqrj1TA51v+UykHd7ZXC6RTgNCbt13ZQYszDrrEDd9ZZrKercfNooKU5rdgbhXOXDwUNU3npa+uxUM6Jz5zcxw2VF9ggLxQferHx9WNtuTJv+ARoAakwspp8TYiaivJ1vjKUOP5Af8nUNE9PVgUDFDIn9ZS22RFUKhznbAEM70I8vpvF51NAyyzJc40YrBVDxy6/ysRBxO36s72BOTSe+fPHhi6EihtRS2ayy0cdlNUPUaUXQqSjH1/2yApi07gmSXIy3PobUmYpOMj08CqB
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(376002)(366004)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(478600001)(9686003)(41300700001)(55016003)(8676002)(4326008)(8936002)(52536014)(4744005)(5660300002)(2906002)(7416002)(7406005)(91956017)(64756008)(6506007)(38070700009)(54906003)(7696005)(71200400001)(6916009)(316002)(76116006)(66476007)(66446008)(66556008)(66946007)(83380400001)(122000001)(33656002)(86362001)(26005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?lodSjwelPoqdbf0geHb0349SSHunMnHnkJAGu5ReST7ppBa4f8124grCtK?=
 =?iso-8859-1?Q?WvVGG8GTE3lnh0yJ6y6VVGxC1pqAdnYRXR76jW8RSWmfGxLGHiNZiPcSR0?=
 =?iso-8859-1?Q?4L7Omd+fCYld59VPHpBT4jKu7tyx2HB9L1np9/bIkXUvyUgXQ9yLVqRI06?=
 =?iso-8859-1?Q?Kjm5LcG5S0KBElL89G/Pt583xsC9NEJQE1GqzaE6M9OTnO03dm4wJm8gL+?=
 =?iso-8859-1?Q?XpFXceM0K+SUgVVDjaKm7jxWph1gEy0V7iTtR/24X4DQgYI1lTRjrTnNTl?=
 =?iso-8859-1?Q?VCCOCFgmtgFE8RvsGo487t+GlOdZufFlszPtKafzSD+XAF3XP4j5Oag/ND?=
 =?iso-8859-1?Q?sU7DBI8eJ5GvWQkD/g7kTYDKLj6VaJRq1t3YZNWqP0NqBjlftOVZe4ZkqU?=
 =?iso-8859-1?Q?qTEf/dvyk7+q7hqJ2fMl4nl6zB/bSwnbGjpploGqoJRhs/HVyPvFpqYWcS?=
 =?iso-8859-1?Q?MZt+hCS58sDlc+sr1Eeb06fE+Zs6qGLqQSQW7btkBWzRjZBazfzqdWiwMG?=
 =?iso-8859-1?Q?v+kopeufrQ4hAEGuCZnNLHiaV4eXjdF9Q6vU9FIM/PDhWYrJpMTH2gWxue?=
 =?iso-8859-1?Q?BSXobZS8t9nN2OZaqgcmy8LJc+mgYGgC1d4OZ7ThnY83KXVBbPOp/P9C0z?=
 =?iso-8859-1?Q?Wqp3/9r5m6x1jn/zUMvsQ3sFVsGZFq9nmjweqxc5dS+XHS0GSwynR9XUyL?=
 =?iso-8859-1?Q?zw4bkxRW3pdxf0qHu8guJ3fi3q8jEzqO05TwFD8lzaRS4UogZENpM0i7EB?=
 =?iso-8859-1?Q?5BGdoAF9dM768v4pAw8RvWapSRncngq+DJBOgOjzmGWxaq7V31t6mmPkhj?=
 =?iso-8859-1?Q?Cb6eHMQn4qpXcxlak8jN7TYK25c14N1BYBZi2MQT/imlU+otbt000ia861?=
 =?iso-8859-1?Q?J6Z7ejH9IbliLn/j/NegmMJemEtXSIzvbhq59hITCPleX2uZHTmDqBHzCI?=
 =?iso-8859-1?Q?zgsJojm4acxktHg1CLdGEo8tnMfPuQVPAoK9YS/5CMeFrZ1jup9AYrf0Wg?=
 =?iso-8859-1?Q?YkQmmEUV+QxYFJ4iRVSqS8UF7ZnAXzP5DLxx1IVe1Kn620ANiTIhqNkhZL?=
 =?iso-8859-1?Q?+ZE+0IwJbMrOMU6KrrVsR9w7zpqWIIrZWidnJEnwTMKhmmu1mOebUhiLj/?=
 =?iso-8859-1?Q?z2UDLUaDt6wCcKCr4zldLXMZ/xo0Dc5qPRZWNZRJrfp4XkycK2xArG1XbM?=
 =?iso-8859-1?Q?34lxuxBJOLbHOQwKzaVAdDlc0myUjidd0hLjbAhfLXu59+XE+YwjIVxbQ0?=
 =?iso-8859-1?Q?3AZuWPRVe5uXKlWggAMdpTycxBYirH+SIjvc+A5DR0qcEa3+gybl10RF+O?=
 =?iso-8859-1?Q?y6N13XKDpoR1cC3adFGU9MpJm/3yX9vlWExLgdLca0ebBObvyuMiuBk44N?=
 =?iso-8859-1?Q?LgIdmI3nIa5wcQadcKQmWTbV2HPD1RVD6+SZKGSe7jQrehvlB8Zet32rp5?=
 =?iso-8859-1?Q?RinxQCxzgMJIzkeABEFG9U6hZTwixI3mDDnGI8jS1NpfPSg69i8TOrlJBy?=
 =?iso-8859-1?Q?JnWyDy+PJH6KwWIfPXnudNC+EeuDMojlKV363oKuJ2Kgs1+vubHeWGfGoU?=
 =?iso-8859-1?Q?odlmYouzZhLJ2lJA11zmRXl8tMh/hdy9CpNntAK3Kvqm+d4cx1ip7Be2g+?=
 =?iso-8859-1?Q?DYN4Xd/Cw/k38=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2906c7af-0d78-4e1f-c030-08dc2c3ba89d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2024 02:29:52.1442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJYa6m+qgUbCG+LM2jCwSBvIj59vFQJ6s7cwCFqy6sH23wU0UlCsaz/pX7ekmEqp+v+dVzJy6KIABRNXLC+n5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7867

>>=0A=
>> The default device stage 2 mapping was chosen in KVM for ARM64 since=0A=
>> it was considered safer (i.e. it would not allow guests to trigger=0A=
>> uncontained failures ultimately crashing the machine) but this=0A=
>> turned out to be asynchronous (SError) defeating the purpose.=0A=
>>=0A=
>> For these reasons, relax the KVM stage 2 device memory attributes=0A=
>> from DEVICE_nGnRE to Normal-NC.=0A=
>=0A=
> Hi Ankit,=0A=
>=0A=
> Thanks for being responsive in respinning the series according to the=0A=
> feedback. I think we're pretty close here, but it'd be good to address=0A=
> the comment / changelog feedback as well.=0A=
>=0A=
> Can you respin this once more? Hopefully we can get this stuff soaking=0A=
> in -next thereafter.=0A=
=0A=
Hi Oliver, yes I am planning to refresh it in the next few days after=0A=
incorporating the comments.=

