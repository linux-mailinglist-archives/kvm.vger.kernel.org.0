Return-Path: <kvm+bounces-8433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AFC84F6B3
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:12:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390401C20362
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 14:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3CCB69973;
	Fri,  9 Feb 2024 14:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l0kPD6nO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B63B4EB4E;
	Fri,  9 Feb 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707487860; cv=fail; b=jVh4G6DKzafX8h/KLebDYEmk0ryP2BIgyjiiVxrZQ92VsqoJzymrtFAAA96ChyXY9Oidb67+CoOhknPW5XK/yJNfah9wzZku0eksbwUyikg+4ZFkik7ubV7wvfNivIrmTC6qtSvthYVHHARUkpfRahmAX3m1A7QTHoT/JSK5kOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707487860; c=relaxed/simple;
	bh=HFiGNCrukHEefF3Ttt1jj47DRyu+Saxns9CRiZStZaY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lmDWJvMC5/Cd5IdCNQepeCFiGo9Da7ubki43jtlPZIcYKoJ5L1cBVXywg1Ip9L9IqEZnmSiFmI89UnwmVtKVJU7Flj4nGcu1g29SFy4iPS5INm48svNCv6318i9MFKeMlLvmRTQk7FAz71LS7uU59eiqEF8tqQ0UpeRoTRGXhsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l0kPD6nO; arc=fail smtp.client-ip=40.107.237.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCzWPcWf2puIEwo2oyVwSIp731GgkLxGEygw7/ijXKqGU0wfebSlFzoVCox1ZbMq5uCh+etLTsppwXLpM9G+mK/eK0SgUgmjd0cBxZcwGhs5Nfxs8/DvHEi8MO95hziDufDOq6UUV8lVPegVJ159q5aSkNtBy7kUhtt2vjoNWyAVN6/jFwyOEufl6nrSOSIOjvtRNwkC9ayqHIPR10rNHoMnAICV46w+HyDF9e6NmiS2PpV1sjdqwxm2ZnlagT7i3AfU3kJOGOWWAYW/7yJ4xko7CStqAQjGbvUo5mkLtCDFrOyFDzZKCMK0BPATVfNbNgEI9dTaoFjsQRKCZ40CaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hk6Pv3TH4qdCFNjhngzzXUpZ/akQNX8iGzCzLMWZI+0=;
 b=cl50UetaK4DHRZ83AOqHOchkE4IEqQ4NnVmq86IlYmzI2W96x7c6PnwAJzoWQP2CcRmz06272oE6jXTuayr4mli11xb4FJ7au3wd3/rpZlqIaQbSp5np+HoMQz7yEYclzbJaD4VxlGOljN090wnh/0EWNzJmYYZkywIqqwLgLHkxnjgHP5ihAqRtwBj4XyCyIhA2wve/yTqolqOLDgsnjPy7V89tJqPpj0B9jzvi23+/QYRiU8Rx8WT/mgTVsUig25+rFAsd4h4yZ4zAm0llAfA7cvnfkss5VG0XsF/ffLiK3ZYuGzc+alk4OPhZMawIZDBp7rqxLfrYR/woZxwdwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hk6Pv3TH4qdCFNjhngzzXUpZ/akQNX8iGzCzLMWZI+0=;
 b=l0kPD6nO8YMtUBXrx5Saf31cRFqh9WGX7FFZP/cCPjZHoqumsZjhz0Yyeuw2uHgyoDo8AIt+jyxtd8FbWqLO6cJGyCcXBPgMNoU8PlF/dbDllyuTm3zEcTVJqwGrA3J4abfGqhuHcPM5mAbynDOG1fC1tv1d8EE20F0lLH+j6q9o7lSsA+VdrTZkB3yYDLe1ALgh25qdtOjHmoqVhHvrhxJ9+QtqDI0v4wqCcgVqwd5Ac38cCTU5aZsNhq/jFaG78hV0fSBJig8BcWrOGw7TvbgaIy4BYyqytLo8r2sStss2rbSXliMkaHW8IbzZlSKNh68tJCPsepXPqsa/lSCJqg==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Fri, 9 Feb
 2024 14:10:53 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b68c:1caf:4ca5:b0a7%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 14:10:52 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Oliver Upton <oliver.upton@linux.dev>, Catalin Marinas
	<catalin.marinas@arm.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "maz@kernel.org" <maz@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>, "surenb@google.com"
	<surenb@google.com>, "stefanha@redhat.com" <stefanha@redhat.com>,
	"brauner@kernel.org" <brauner@kernel.org>, "will@kernel.org"
	<will@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "yi.l.liu@intel.com"
	<yi.l.liu@intel.com>, "ardb@kernel.org" <ardb@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"andreyknvl@gmail.com" <andreyknvl@gmail.com>, "wangjinchao@xfusion.com"
	<wangjinchao@xfusion.com>, "gshan@redhat.com" <gshan@redhat.com>,
	"ricarkol@google.com" <ricarkol@google.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	"rananta@google.com" <rananta@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Matt Ochs
	<mochs@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Topic: [PATCH v6 1/4] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Thread-Index: AQHaWgbdhvpY3ycYrU2mOegquaqhOrEAaauAgAAGtICAAZ6ADw==
Date: Fri, 9 Feb 2024 14:10:51 +0000
Message-ID:
 <MW4PR12MB72138D289232B5D62078158DB04B2@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-2-ankita@nvidia.com> <ZcTQi0wWZgvl05LB@arm.com>
 <ZcTWK6TksvugSlI-@linux.dev>
In-Reply-To: <ZcTWK6TksvugSlI-@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|SA1PR12MB7296:EE_
x-ms-office365-filtering-correlation-id: e1dfb7cf-efb9-41cb-b4c1-08dc2978ec7d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 875ELY2dE+5FoWoWDn590ilExe10CRYKnWHMVlnBweHkVhYmxaGrVWEJah4ZdfYAQRmnH7X9gQ2tMRld8y7XAoZn7yj4+7ZkWMEVDRh1zD+VhRIarXdQrfJKo/CEs466t3Kiv+NP4uRgnsFyKjj9B76X4zx3jsoDztaU6d0LCvkhvWxod8aD29FSJQ5OQU3Z9uOpSEBmr6tM4O8bKrXzlauhx5FJw+duXLnGFObbOXkUeh1/+OlG+kwPrNloqxhdBSoyNK9vndVeHFeCIcp5Qu6w3KDhihR8NKfd1pRxxqDo9l+gTCnqZU28mfvWjnwkfQmQ8YKo0RGeoobaQrQ4570Mzfhz7+Zea4188MGj6EImBVIeA+MMUtAi00iSI4R6xLy/3NKF2L2N7nZi+qTtrg+Mp/871cfYDrtsh7WCvmrPHTxiEJxrt/WyLfiHhdk55qvXUMBl0F0Y7hFJstQsvMMRoDEoR3/hyOyNCGCITHB/hnH8mRIoEJWeD5DRYrUNyG7DSVLn0X0rd1F4Sg+2kZPpP/XJuSgvkc/5OF9cAZVj5MnHRQuvLnPKxzVWFYn1om3UIxCnBmYKKAbWH9S7YuXG284Ks5vNkDPc0CTnOaThIh5F54BXsWyURL0T/Bp1
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(33656002)(26005)(55016003)(7416002)(41300700001)(4744005)(8936002)(76116006)(54906003)(86362001)(66476007)(38070700009)(122000001)(91956017)(66446008)(66946007)(7696005)(64756008)(6506007)(71200400001)(110136005)(9686003)(66556008)(38100700002)(478600001)(4326008)(316002)(2906002)(5660300002)(52536014)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ViI9fhUn9zwDsswn/KMlCC3XkpiXYm5AecFu/qSvBDWswoLY2y4kxPQvH+?=
 =?iso-8859-1?Q?loLTVQN2a/mj1EBZ2jwIdny8ecTOZDgStRlQtc2yeIPDXoPjGnAbkZtJKY?=
 =?iso-8859-1?Q?jwAeYtOHGCWevGd8uLrVgAh+N2KsXO4o13u8EsngWUneLcHsLKc04oriVq?=
 =?iso-8859-1?Q?R/wJVaV+aNsrx8hs4L2HY6TwBiAog98OJs1K4Iwn3/PGHGlgLr6GF2FprK?=
 =?iso-8859-1?Q?z5UddO2YiybKJbQqUizZT111mud/u59MvIiq+NhqrlYoCYIZDmXM2mm28l?=
 =?iso-8859-1?Q?50m96pFvGirnznmZewrgZTmo7e3FMSuyYX3xtI+/zjZTJ4//xNFWP1D6xf?=
 =?iso-8859-1?Q?q3w2bqBZ6LH2h8CR3vbicjeLwL0W8qGhQfC7LuOiKyGq79En3aBU6GFk4j?=
 =?iso-8859-1?Q?QMggZ9HC+icENloJmSDROD/r2/GCv7GqMzP5MRCP9XWKkQdOPHM65hWBJB?=
 =?iso-8859-1?Q?r/w/+0ESTOUU3Z2Z6mkyw8SNQjZcyXfeuL86sKYaUtF5bOcSzHsrduJ0AT?=
 =?iso-8859-1?Q?sWF+yjBniPHv9rVk9nSG8TW8oud3reoHP8/dbO37QFKdhiy/zkMAAYXDLb?=
 =?iso-8859-1?Q?A+ZrMr63m5SvpOVO2fefo6usuSSg8OCA0IqLC0NM3BarROdPJYuGdY65tG?=
 =?iso-8859-1?Q?eKAS17utP5eSvkNp51pTUMfrwSZFp8CHpG2507G3x2Ds5gRvFu9pmcnYyL?=
 =?iso-8859-1?Q?zQxDnkjrtEL0ANUlhGoXCSj4CEObWXjhjMItiTQ0L6RlwgsgjuJP1crP11?=
 =?iso-8859-1?Q?kYURC8C4NURFDG+qJWlWn3NR5G4se+ohglKWJjzhaZyUksRzFpGghih2oj?=
 =?iso-8859-1?Q?oCLhj1B50ADa554UeWZlWBr7/zRSadPuS8+jy7qKjvhzKZow58e9WIgTVW?=
 =?iso-8859-1?Q?/7VpbRkyaux+9keiY1uO7LpkqCs1XaECCGk452AalTqTq2ghV4EhH+QBjt?=
 =?iso-8859-1?Q?CS/OLRD8YO+DYUTDTDT3ZrB3nZWYfDT3cs0iy35hLTRLUA50tnvCFvZkYu?=
 =?iso-8859-1?Q?+AHYBh9v/1AOZssIh4VU3wkNBfQDcaCnuBH4nQASl/+3vjji2IMfJ/zsDV?=
 =?iso-8859-1?Q?chETSsOF5U39syS8N5W2jbhLmJHp10ewpGJMTc4EzptK1ll5l/zP5OhzQ3?=
 =?iso-8859-1?Q?7LWqaMYkiwZkQIuBpsfRkcG8nDSF+UyKFh3FiroJc6Ep4PU9pggI3yywYt?=
 =?iso-8859-1?Q?4nz10hg9KrZcIkvmAhuLWWSXB+l5FSZWoN+730W9c+O4Jwxd2VSokRji3R?=
 =?iso-8859-1?Q?V6CiSwYjHPGBIB6HcR3hHMDyU01AiWF0LKastHI1HK3VizbI0OPWAdGC/p?=
 =?iso-8859-1?Q?UMu42RbmQ0/UhBFLRSr9IUp6R7AS2HqycEg+W7BlrV9vHMQL4vQKTBaTTu?=
 =?iso-8859-1?Q?idTu1yZRsVMRIxOKjbCKgYY9DzLcNy+tCac4v/G23yxqSOppBLj+r/EHTH?=
 =?iso-8859-1?Q?/NAO/5zqyJ+7l94ae2McKR40TkfuZnavbSOXn+B4d5NB6puHpVT1WIPsrt?=
 =?iso-8859-1?Q?JdwIiMLL12bN2HOVmosX0/zRndRAJe6on3xdUCOXsTi8AsTiBFU9aC7YH+?=
 =?iso-8859-1?Q?PucXSRW4SL3iMZOsaIGOJf/JIc0CHa00IY0nL7uzoMPxh6xyRT0tSkgPOF?=
 =?iso-8859-1?Q?ZBtIJWY+wJgeM=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1dfb7cf-efb9-41cb-b4c1-08dc2978ec7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 14:10:52.0056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xKdTsrtdzv+IUvkY0/0yzn7bY86714an0DwwSj10EPpV/p1u76/DehjzY8VaWeXLvzoszzb+UC1wiEYLG4jL9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296

>> +	default:=0A=
>> +		WARN_ON_ONCE(1);=0A=
>=0A=
> Return -EINVAL?=0A=
=0A=
Sure.=0A=
=0A=
>> > +=A0=A0 case KVM_PGTABLE_PROT_NORMAL_NC:=0A=
>> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 attr =3D KVM_S2_MEMATTR(pgt, NORMAL_NC=
);=0A=
>> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;=0A=
>>=0A=
>> Does it make sense to allow executable here as well? I don't think it's=
=0A=
>> harmful but not sure there's a use-case for it either.=0A=
>=0A=
> Ah, we should just return EINVAL for that too.=0A=
>=0A=
> I get that the memory attribute itself is not problematic, but since=0A=
> we're only using this thing for MMIO it'd be a rather massive=0A=
> bug in KVM... We reject attempts to do this earlier in user_mem_abort().=
=0A=
=0A=
Ack, will change to test executable and return -EINVAL in that case.=

